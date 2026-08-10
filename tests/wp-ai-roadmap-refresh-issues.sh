#!/usr/bin/env bash
# Issue census: normalization, completeness validation, the diff contract, and
# the board issue-coverage audit. Coverage is PRIMARY-REPOSITORY-ONLY -- an
# upstream repository must never be able to produce a Project #240 coverage
# diagnostic, so that exclusion is asserted here rather than assumed.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
STATE_DIR="$TMP_DIR/state"
mkdir -p "$MOCK_BIN" "$STATE_DIR"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"

ISSUES="$ROOT_DIR/tests/fixtures/issue-graphql-pages.jsonl"
# Census the primary repository alone so the assertions below concern one repo.
REPOS="$TMP_DIR/repositories.json"
printf '{"schemaVersion":1,"repositories":[]}\n' >"$REPOS"

run_census() { # [extra args...] -> census JSON
  PATH="$MOCK_BIN:$PATH" \
  WP_AI_TEST_STATE_DIR="$STATE_DIR" \
  WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
  WP_AI_TEST_ISSUE_PAGES="$ISSUES" \
  WP_AI_REPOS_FILE="$REPOS" \
  WP_AI_MERGESTATE_RETRY_DELAY=0 \
    "$ROOT_DIR/wp-ai-roadmap-refresh.sh" census "$@"
}

# ---------------------------------------------------------------- normalization
json="$(run_census)"
jq -e '
  (.repositories[0].open_issues | length) == 4
  and .repositories[0].issues_available
  and ([.repositories[0].open_issues[].number] == [40,514,931,932])
  and ([.repositories[0].open_issues[] | select(.number==40)][0]
       | .id == "WordPress/ai#40"
         and .repo == "WordPress/ai"
         and .milestone == "Future Release"
         and .labels == ["[Type] Enhancement"]
         and .assignees == ["gziolo","jorgefilipecosta"]
         and .comments == 39
         and (.isBot | not))
  and ([.repositories[0].open_issues[] | select(.number==932)][0].isBot)
  and ([.repositories[0].open_issues[] | select(.number==514)][0].milestone == "1.3.0")
' <<<"$json" >/dev/null

# Bounded label/assignee connections truncate as WARNINGS, never errors: nothing
# downstream depends on their completeness, unlike closingIssuesReferences.
jq -e '
  .repositories[0].validation.ok
  and ([.repositories[0].validation.warnings[]
        | select(.code=="issue-connection-truncated")
        | .context.connection] | sort) == ["assignees","labels"]
' <<<"$json" >/dev/null

# ------------------------------------------------------- completeness contract
mutate_issues() { # filter destination
  jq -sc "$1 | .[]" "$ISSUES" >"$2"
}

assert_issue_error() { # fixture code
  local fixture="$1" code="$2" payload status
  set +e
  payload="$(
    PATH="$MOCK_BIN:$PATH" \
    WP_AI_TEST_STATE_DIR="$STATE_DIR" \
    WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
    WP_AI_TEST_ISSUE_PAGES="$fixture" \
    WP_AI_REPOS_FILE="$REPOS" \
    WP_AI_MERGESTATE_RETRY_DELAY=0 \
      "$ROOT_DIR/wp-ai-roadmap-refresh.sh" census --strict
  )"
  status=$?
  set -e
  [ "$status" -eq 2 ]
  jq -e --arg code "$code" '
    (.validation.ok | not)
    and ([.validation.errors[].code] | index($code) != null)
  ' <<<"$payload" >/dev/null
}

mutate_issues '.[1].data.repository.issues.nodes[0].number=40' \
  "$TMP_DIR/duplicate.jsonl"
assert_issue_error "$TMP_DIR/duplicate.jsonl" issue-duplicate

mutate_issues '.[1].data.repository.issues.pageInfo.hasNextPage=true' \
  "$TMP_DIR/incomplete.jsonl"
assert_issue_error "$TMP_DIR/incomplete.jsonl" issue-pagination-incomplete

mutate_issues 'map(.data.repository.issues.totalCount=9)' \
  "$TMP_DIR/total.jsonl"
assert_issue_error "$TMP_DIR/total.jsonl" issue-total-mismatch

# ------------------------------------------------------------- diff contract
BASE="$TMP_DIR/issues-base.json"
CUR="$TMP_DIR/issues-cur.json"

jq -n '[
  {number:1,title:"Milestone moves",milestone:"Future Release",
   labels:["bug"],assignees:["alice"],updatedAt:"2026-08-01T00:00:00Z"},
  {number:2,title:"Labels reorder only",milestone:null,
   labels:["a","b"],assignees:[],updatedAt:"2026-08-01T00:00:00Z"},
  {number:3,title:"Activity only",milestone:null,
   labels:[],assignees:[],updatedAt:"2026-08-01T00:00:00Z"},
  {number:4,title:"Closes",milestone:null,
   labels:[],assignees:[],updatedAt:"2026-08-01T00:00:00Z"},
  {number:6,title:"Assignee changes",milestone:null,
   labels:[],assignees:["alice"],updatedAt:"2026-08-01T00:00:00Z"},
  {number:7,title:"Legacy record"}
]' >"$BASE"

jq -n '[
  {number:1,title:"Milestone moves",milestone:"1.3.0",
   labels:["bug"],assignees:["alice"],updatedAt:"2026-08-10T00:00:00Z"},
  {number:2,title:"Labels reorder only",milestone:null,
   labels:["b","a"],assignees:[],updatedAt:"2026-08-10T00:00:00Z"},
  {number:3,title:"Activity only",milestone:null,
   labels:[],assignees:[],updatedAt:"2026-08-10T00:00:00Z"},
  {number:5,title:"Newly opened",milestone:"1.3.0",
   labels:[],assignees:[],updatedAt:"2026-08-10T00:00:00Z"},
  {number:6,title:"Assignee changes",milestone:null,
   labels:[],assignees:["alice","bob"],updatedAt:"2026-08-10T00:00:00Z"},
  {number:7,title:"Legacy record retitled",milestone:null,
   labels:[],assignees:[],updatedAt:"2026-08-10T00:00:00Z"}
]' >"$CUR"

diff_json="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" issuediff "$BASE" "$CUR")"
jq -e '
  [.newly_opened[].number] == [5]
  and ([.newly_opened[] | select(.number==5)][0].milestone == "1.3.0")
  and [.no_longer_open[].number] == [4]
  # #2 reordered its labels and #3 only bumped updatedAt: neither is a change.
  and [.changed[].number] == [1,6,7]
  and ([.changed[] | select(.number==1)][0].changes
       == {milestone:{from:"Future Release",to:"1.3.0"}})
  and ([.changed[] | select(.number==6)][0].changes
       == {assignees:{from:["alice"],to:["alice","bob"]}})
  # #7 is the schema-migration guard: its baseline record carried only number
  # and title, so the milestone/labels/assignees it gained must stay silent
  # while its genuine title change still reports.
  and ([.changed[] | select(.number==7)][0].changes
       == {title:{from:"Legacy record",to:"Legacy record retitled"}})
' <<<"$diff_json" >/dev/null

# --------------------------------------------------------- board coverage
# The board fixture cards WordPress/ai#40 and #514; the census also returns
# #931 and #932, so exactly two issues are uncarded.
run_full() { # snapshot_dir [args...] -> full report JSON
  local snap="$1"; shift
  PATH="$MOCK_BIN:$PATH" \
  WP_AI_SNAP_DIR="$snap" \
  WP_AI_DEPS_FILE="$TMP_DIR/dependencies.json" \
  WP_AI_REPOS_FILE="$REPOS" \
  WP_AI_TEST_STATE_DIR="$STATE_DIR" \
  WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
  WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
  WP_AI_TEST_ISSUE_PAGES="$ISSUES" \
  WP_AI_TEST_RELEASES="$TMP_DIR/releases.json" \
  WP_AI_MERGESTATE_RETRY_DELAY=0 \
    "$ROOT_DIR/wp-ai-roadmap-refresh.sh" "$@"
}

jq -n '{schemaVersion:1,items:[{
  id:"Example/deps#1", theme:"Fixture", aiRefs:[40],
  note:"Issue census fixture", required:true
}]}' >"$TMP_DIR/dependencies.json"
printf '[]\n' >"$TMP_DIR/releases.json"

COV_SNAP="$TMP_DIR/coverage-snapshots"
mkdir -p "$COV_SNAP"
full="$(run_full "$COV_SNAP" --json)"

jq -e '
  .repo.issue_gap.repo == "WordPress/ai"
  and .repo.issue_gap.open_total == 4
  and .repo.issue_gap.carded == 2
  and ([.repo.issue_gap.uncarded[].number] | sort) == [931,932]
  and ([.repo.issue_gap.validation.errors[].code] | unique)
      == ["issue-roadmap-coverage-missing"]
  and ([.validation.errors[]
        | select(.code=="issue-roadmap-coverage-missing")
        | .context.id] | sort)
      == ["WordPress/ai#931","WordPress/ai#932"]
' <<<"$full" >/dev/null

# An uncarded open primary-repository issue is a strict-audit failure, exactly
# as an uncarded substantive PR is.
STRICT_SNAP="$TMP_DIR/strict-snapshots"
mkdir -p "$STRICT_SNAP"
set +e
strict_out="$(run_full "$STRICT_SNAP" --strict --json 2>/dev/null)"
strict_status=$?
set -e
[ "$strict_status" -eq 2 ]
jq -e '[.validation.errors[].code] | index("issue-roadmap-coverage-missing") != null' \
  <<<"$strict_out" >/dev/null

# Upstream repositories are censused without any Project #240 expectation: no
# coverage diagnostic may ever name one.
jq -e '
  all(.validation.errors[]
    | select(.code=="issue-roadmap-coverage-missing");
    (.context.id | startswith("WordPress/ai#")))
' <<<"$strict_out" >/dev/null

# ---------------------------------------------------- fail-soft independence
# A failing issue fetch must not blank PR data that arrived fine, and must not
# overwrite a good issue baseline with an empty array.
FAIL_SNAP="$TMP_DIR/failsoft-snapshots"
mkdir -p "$FAIL_SNAP"
cp "$COV_SNAP"/issues-WordPress-ai-*.json "$FAIL_SNAP/issues-WordPress-ai-20260101T000000Z.json"
baseline_before="$(cat "$FAIL_SNAP/issues-WordPress-ai-20260101T000000Z.json")"

set +e
WP_AI_TEST_ISSUE_FAIL=1 run_full "$FAIL_SNAP" --json --save >"$TMP_DIR/failsoft.json" 2>/dev/null
set -e

jq -e '
  (.repositories[0].open_prs | length) == 5
  and (.repositories[0].issues_available | not)
  and (.repositories[0].open_issues | length) == 0
  and ([.repositories[0].validation.errors[]
        | select(.code=="issue-census-unavailable")] | length) == 1
  and .repo.issue_gap == null
' "$TMP_DIR/failsoft.json" >/dev/null

[ "$(find "$FAIL_SNAP" -maxdepth 1 -name 'issues-WordPress-ai-*.json' | wc -l)" -eq 1 ]
[ "$baseline_before" = "$(cat "$FAIL_SNAP/issues-WordPress-ai-20260101T000000Z.json")" ]

printf 'issue census tests passed\n'
