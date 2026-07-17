#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
STATE_DIR="$TMP_DIR/state"
mkdir -p "$MOCK_BIN" "$STATE_DIR"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"

json="$(
  PATH="$MOCK_BIN:$PATH" \
  WP_AI_TEST_STATE_DIR="$STATE_DIR" \
  WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
    "$ROOT_DIR/wp-ai-roadmap-refresh.sh" census
)"

jq -e '
  (.open_prs | length)==5
  and .validation.ok
  and all(.open_prs[]; .repo=="WordPress/ai")
  and ([.open_prs[]|select(.number==100)][0]
    | .isBot and .routine and (.issueLinks|length)==0 and (.issues|length)==0)
  and ([.open_prs[]|select(.number==101)][0].issueLinks
    == [{repo:"WordPress/ai",number:40,source:"closing"}])
  and ([.open_prs[]|select(.number==102)][0].issueLinks
    == [{repo:"WordPress/ai",number:514,source:"fallback-title"}])
  and ([.open_prs[]|select(.number==103)][0].issueLinks
    == [{repo:"WordPress/ai",number:430,source:"fallback-branch"}])
  and ([.open_prs[]|select(.number==104)][0].issueLinks
    == [{repo:"WordPress/ai",number:600,source:"fallback-body"}])
' <<<"$json" >/dev/null

mutate_pages() {
  local filter="$1" destination="$2"
  jq -sc "$filter | .[]" \
    "$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" >"$destination"
}

assert_census_error() {
  local fixture="$1" code="$2"
  local payload
  set +e
  payload="$(
    PATH="$MOCK_BIN:$PATH" \
    WP_AI_TEST_STATE_DIR="$STATE_DIR" \
    WP_AI_TEST_PR_PAGES="$fixture" \
      "$ROOT_DIR/wp-ai-roadmap-refresh.sh" census --strict
  )"
  local status=$?
  set -e
  [ "$status" -eq 2 ]
  jq -e --arg code "$code" '
    (.validation.ok|not)
    and ([.validation.errors[].code] | index($code) != null)
  ' <<<"$payload" >/dev/null
}

mutate_pages '.[1].data.repository.pullRequests.nodes[0].number=100' \
  "$TMP_DIR/duplicate.jsonl"
assert_census_error "$TMP_DIR/duplicate.jsonl" pr-duplicate

mutate_pages '.[1].data.repository.pullRequests.pageInfo.hasNextPage=true' \
  "$TMP_DIR/incomplete.jsonl"
assert_census_error "$TMP_DIR/incomplete.jsonl" pr-pagination-incomplete

mutate_pages 'map(.data.repository.pullRequests.totalCount=6)' \
  "$TMP_DIR/total.jsonl"
assert_census_error "$TMP_DIR/total.jsonl" pr-total-mismatch

mutate_pages '.[0].data.repository.pullRequests.nodes[1].closingIssuesReferences.totalCount=21' \
  "$TMP_DIR/closing.jsonl"
assert_census_error "$TMP_DIR/closing.jsonl" pr-closing-refs-truncated

printf 'PR census fixture tests passed\n'
