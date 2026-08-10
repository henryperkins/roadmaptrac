#!/usr/bin/env bash
# GitHub computes PR mergeability lazily, so a cold census can answer
# mergeStateStatus:"UNKNOWN" for PRs nothing has changed. Recorded verbatim that
# sentinel reports every open PR as newly unreadable and then persists into the
# snapshot, so the next window reports them all again in reverse. Cover both
# halves of the fix: retry the query, and never diff against UNKNOWN.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
mkdir -p "$MOCK_BIN"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"

SETTLED="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl"
COLD="$TMP_DIR/pr-cold.jsonl"
# Census the primary repository alone, so the mock's call counter means exactly
# "first query vs retry" rather than being shared across registry repositories.
REPOS="$TMP_DIR/repositories.json"
printf '{"schemaVersion":1,"repositories":[]}\n' >"$REPOS"

# Same fixture, but with mergeability not yet computed for any node.
jq -c '.data.repository.pullRequests.nodes
       |= map(.mergeStateStatus = "UNKNOWN")' "$SETTLED" >"$COLD"

run_census() { # first-response second-response [args...] -> census JSON
  local first="$1" second="$2" state
  state="$(mktemp -d "$TMP_DIR/state.XXXXXX")"
  PATH="$MOCK_BIN:$PATH" \
  WP_AI_TEST_STATE_DIR="$state" \
  WP_AI_TEST_PR_PAGES="$first" \
  WP_AI_TEST_PR_PAGES_RETRY="$second" \
  WP_AI_REPOS_FILE="$REPOS" \
  WP_AI_MERGESTATE_RETRY_DELAY=0 \
    "$ROOT_DIR/wp-ai-roadmap-refresh.sh" census "${@:3}"
}

# 1. A cold first answer is discarded once the retry knows the real states.
json="$(run_census "$COLD" "$SETTLED")"
jq -e '
  (.open_prs | length)==5
  and ([.open_prs[] | select(.mergeStateStatus=="UNKNOWN")] | length)==0
  and ([.open_prs[]|select(.number==102)][0].mergeStateStatus=="BLOCKED"
       and [.open_prs[]|select(.number==103)][0].mergeStateStatus=="DIRTY")
  and (.validation.warnings|length)==0
  and .validation.ok
' <<<"$json" >/dev/null

# 2. Retrying is best-effort: a still-cold repository keeps its UNKNOWNs, says so
#    as a warning, and stays green -- uncomputed mergeability is not a coverage
#    failure, so it must not fail the strict audit.
set +e
json="$(run_census "$COLD" "$COLD" --strict)"
status=$?
set -e
[ "$status" -eq 0 ]
jq -e '
  ([.open_prs[] | select(.mergeStateStatus=="UNKNOWN")] | length)==5
  and .validation.ok
  and (.validation.errors|length)==0
  and ([.validation.warnings[].code] | unique == ["pr-mergestate-unknown"])
  and ([.validation.warnings[].context.number] == [100,101,102,103,104])
' <<<"$json" >/dev/null

# 3. A settled answer must not be downgraded by a retry that comes back cold.
json="$(run_census "$SETTLED" "$COLD")"
jq -e '
  ([.open_prs[] | select(.mergeStateStatus=="UNKNOWN")] | length)==0
  and (.validation.warnings|length)==0
' <<<"$json" >/dev/null

# 4. The diff never manufactures a readiness change out of UNKNOWN, in either
#    direction, while real transitions and co-occurring changes still report.
BASE="$TMP_DIR/pr-base.json"
CUR="$TMP_DIR/pr-current.json"

jq -n '[
  {number:1,title:"Cold this window",isDraft:false,
   reviewDecision:null,mergeStateStatus:"BLOCKED",checkState:"SUCCESS",
   updatedAt:"2026-08-09T00:00:00Z"},
  {number:2,title:"Cold last window",isDraft:false,
   reviewDecision:null,mergeStateStatus:"UNKNOWN",checkState:"SUCCESS",
   updatedAt:"2026-08-09T00:00:00Z"},
  {number:3,title:"Genuinely conflicted",isDraft:false,
   reviewDecision:null,mergeStateStatus:"BLOCKED",checkState:"SUCCESS",
   updatedAt:"2026-08-09T00:00:00Z"},
  {number:4,title:"Cold, but checks moved",isDraft:false,
   reviewDecision:null,mergeStateStatus:"BLOCKED",checkState:"FAILURE",
   updatedAt:"2026-08-09T00:00:00Z"}
]' >"$BASE"

jq -n '[
  {number:1,title:"Cold this window",isDraft:false,
   reviewDecision:null,mergeStateStatus:"UNKNOWN",checkState:"SUCCESS",
   updatedAt:"2026-08-10T00:00:00Z"},
  {number:2,title:"Cold last window",isDraft:false,
   reviewDecision:null,mergeStateStatus:"BLOCKED",checkState:"SUCCESS",
   updatedAt:"2026-08-10T00:00:00Z"},
  {number:3,title:"Genuinely conflicted",isDraft:false,
   reviewDecision:null,mergeStateStatus:"DIRTY",checkState:"SUCCESS",
   updatedAt:"2026-08-10T00:00:00Z"},
  {number:4,title:"Cold, but checks moved",isDraft:false,
   reviewDecision:null,mergeStateStatus:"UNKNOWN",checkState:"SUCCESS",
   updatedAt:"2026-08-10T00:00:00Z"}
]' >"$CUR"

diff_json="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" prdiff "$BASE" "$CUR")"
jq -e '
  [.readiness_changed[].number]==[3,4]
  and ([.readiness_changed[]|select(.number==3)][0].changes
       == {mergeStateStatus:{from:"BLOCKED",to:"DIRTY"}})
  and ([.readiness_changed[]|select(.number==4)][0].changes
       == {checkState:{from:"FAILURE",to:"SUCCESS"}})
' <<<"$diff_json" >/dev/null

printf 'mergeStateStatus UNKNOWN tests passed\n'
