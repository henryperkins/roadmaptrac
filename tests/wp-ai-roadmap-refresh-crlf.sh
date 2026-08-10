#!/usr/bin/env bash
#
# Regression test: the engine must survive a jq that emits CRLF.
#
# Native jq.exe on Windows writes CRLF, so `while IFS= read -r x; do ... done <
# <(jq -r ...)` leaves a trailing \r on every value. That tainted the repository
# slug in two places -- fetch_repository_censuses (which then asked GitHub for
# `-F name=ai$'\r'`) and the --save loop (which copied
# `prs-WordPress-ai$'\r'-current.json`) -- so census/--save/--strict all failed
# on Windows while passing on Linux.
#
# This test shims jq to emit CRLF, which reproduces the failure on any platform.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
STATE_DIR="$TMP_DIR/state"
PR_DIR="$TMP_DIR/pr-pages"
RELEASE_DIR="$TMP_DIR/releases"
SNAP_DIR="$TMP_DIR/snapshots"
mkdir -p "$MOCK_BIN" "$STATE_DIR" "$PR_DIR" "$RELEASE_DIR" "$SNAP_DIR"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"

# Resolve the real jq before PATH is shadowed, so the shim cannot recurse.
REAL_JQ="$(command -v jq)"
ln -s "$ROOT_DIR/tests/helpers/crlf-jq.sh" "$MOCK_BIN/jq"

# Sanity-check the shim itself: without it there is nothing to regress against.
shim_out="$(PATH="$MOCK_BIN:$PATH" WP_AI_TEST_REAL_JQ="$REAL_JQ" \
  jq -rn '"WordPress/ai"' | od -c | head -1)"
case "$shim_out" in
  *'\r'*) : ;;
  *) printf 'shim did not emit CR: %s\n' "$shim_out" >&2; exit 1 ;;
esac

cp "$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
  "$PR_DIR/WordPress-ai.jsonl"
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-php-ai-client.jsonl" \
  "$PR_DIR/WordPress-php-ai-client.jsonl"
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-mcp-adapter.jsonl" \
  "$PR_DIR/WordPress-mcp-adapter.jsonl"
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-abilities-api.jsonl" \
  "$PR_DIR/WordPress-abilities-api.jsonl"
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-ai-releases.json" \
  "$RELEASE_DIR/WordPress-ai.json"
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-php-ai-client-releases.json" \
  "$RELEASE_DIR/WordPress-php-ai-client.json"
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-mcp-adapter-releases.json" \
  "$RELEASE_DIR/WordPress-mcp-adapter.json"
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-abilities-api-releases.json" \
  "$RELEASE_DIR/WordPress-abilities-api.json"

DEPS_FILE="$TMP_DIR/dependencies.json"
"$REAL_JQ" -n '{
  schemaVersion:1,
  items:[{
    id:"Example/deps#1", theme:"Fixture", aiRefs:[40],
    note:"CRLF regression fixture", required:true
  }]
}' >"$DEPS_FILE"

run_with_crlf_jq() {
  PATH="$MOCK_BIN:$PATH" \
  WP_AI_TEST_REAL_JQ="$REAL_JQ" \
  WP_AI_SNAP_DIR="$SNAP_DIR" \
  WP_AI_DEPS_FILE="$DEPS_FILE" \
  WP_AI_TEST_STATE_DIR="$STATE_DIR" \
  WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
  WP_AI_TEST_PR_PAGES_DIR="$PR_DIR" \
  WP_AI_TEST_RELEASES_DIR="$RELEASE_DIR" \
    "$ROOT_DIR/wp-ai-roadmap-refresh.sh" "$@"
}

# 1. census must reach every tracked repository. Pre-fix this dies with
#    "PR census query failed for WordPress/ai" because the slug carried a CR.
census_json="$(run_with_crlf_jq census)"
"$REAL_JQ" -e '
  .validation.ok
  and (.repositories | map({repo, open_prs:(.open_prs|length)})) == [
    {repo:"WordPress/ai", open_prs:5},
    {repo:"WordPress/php-ai-client", open_prs:1},
    {repo:"WordPress/mcp-adapter", open_prs:2},
    {repo:"WordPress/abilities-api", open_prs:2}
  ]
' <<<"$census_json" >/dev/null

# 2. No string *value* anywhere in the report may carry a stray CR. jq's own
#    pretty-print line breaks can still be CRLF under a text-mode jq; that is
#    legal JSON whitespace and harmless, so this checks the parsed values rather
#    than the raw byte stream.
"$REAL_JQ" -e '
  [paths(type == "string") as $p | getpath($p)]
  | all(contains("\r") | not)
' <<<"$census_json" >/dev/null

# 3. A full run must persist all 8 baselines under clean, CR-free filenames.
#    Pre-fix the --save loop copies prs-WordPress-ai$'\r'-current.json and dies.
run_with_crlf_jq --json >"$TMP_DIR/full.json" 2>"$TMP_DIR/full.err"

[ "$(find "$SNAP_DIR" -maxdepth 1 -type f | wc -l)" -eq 14 ]
for snapshot in \
  proj240 \
  prs-WordPress-ai issues-WordPress-ai releases-WordPress-ai \
  prs-WordPress-php-ai-client issues-WordPress-php-ai-client releases-WordPress-php-ai-client \
  prs-WordPress-mcp-adapter issues-WordPress-mcp-adapter releases-WordPress-mcp-adapter \
  prs-WordPress-abilities-api issues-WordPress-abilities-api releases-WordPress-abilities-api; do
  find "$SNAP_DIR" -maxdepth 1 -type f -name "$snapshot-*.json" | grep -q .
done

# A CR in a slug would show up as a filename with an embedded control character.
if find "$SNAP_DIR" -maxdepth 1 -type f | grep -q $'\r'; then
  printf 'snapshot filename contains a carriage return\n' >&2
  find "$SNAP_DIR" -maxdepth 1 -type f | cat -v >&2
  exit 1
fi

"$REAL_JQ" -e '
  (.repositories | map(.repo)) == [
    "WordPress/ai",
    "WordPress/php-ai-client",
    "WordPress/mcp-adapter",
    "WordPress/abilities-api"
  ]
' "$TMP_DIR/full.json" >/dev/null

printf 'CRLF-jq regression tests passed\n'
