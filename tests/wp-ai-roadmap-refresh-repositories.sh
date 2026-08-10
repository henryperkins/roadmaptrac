#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
STATE_DIR="$TMP_DIR/state"
PR_DIR="$TMP_DIR/pr-pages"
RELEASE_DIR="$TMP_DIR/releases"
mkdir -p "$MOCK_BIN" "$STATE_DIR" "$PR_DIR" "$RELEASE_DIR"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"

jq -e '
  .schemaVersion == 1
  and .repositories == [
    "WordPress/php-ai-client",
    "WordPress/mcp-adapter",
    "WordPress/abilities-api"
  ]
' "$ROOT_DIR/wp-ai-roadmap-repositories.json" >/dev/null

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

run_census() {
  PATH="$MOCK_BIN:$PATH" \
  WP_AI_TEST_STATE_DIR="$STATE_DIR" \
  WP_AI_TEST_PR_PAGES_DIR="$PR_DIR" \
  WP_AI_TEST_RELEASES_DIR="$RELEASE_DIR" \
    "$ROOT_DIR/wp-ai-roadmap-refresh.sh" census "$@"
}

json="$(run_census)"
jq -e '
  (.open_prs | length) == 5
  and (.releases | last | .tag) == "1.2.0"
  and .validation.ok
  and (.repositories | map({
    repo,
    open_prs: (.open_prs | length),
    latest: (.releases | last | .tag)
  })) == [
    {repo:"WordPress/ai", open_prs:5, latest:"1.2.0"},
    {repo:"WordPress/php-ai-client", open_prs:1, latest:"1.4.0"},
    {repo:"WordPress/mcp-adapter", open_prs:2, latest:"v0.5.0"},
    {repo:"WordPress/abilities-api", open_prs:2, latest:null}
  ]
' <<<"$json" >/dev/null

jq '.data.repository.pullRequests.totalCount = 3' \
  "$PR_DIR/WordPress-mcp-adapter.jsonl" >"$TMP_DIR/malformed.jsonl"
mv "$TMP_DIR/malformed.jsonl" "$PR_DIR/WordPress-mcp-adapter.jsonl"

set +e
strict_json="$(run_census --strict)"
strict_status=$?
set -e
[ "$strict_status" -eq 2 ]
jq -e '
  (.validation.ok | not)
  and ([.validation.errors[]
    | select(.code == "pr-total-mismatch" and .context.repo == "WordPress/mcp-adapter")]
    | length) == 1
' <<<"$strict_json" >/dev/null

# The full refresh exposes enriched repository reports, renders the two added
# repositories, and persists independent PR/release baselines for all three.
FULL_SNAP_DIR="$TMP_DIR/full-snapshots"
FULL_DEPS_FILE="$TMP_DIR/dependencies.json"
mkdir -p "$FULL_SNAP_DIR"
jq -n '{
  schemaVersion:1,
  items:[{
    id:"Example/deps#1", theme:"Fixture", aiRefs:[40],
    note:"Full repository census fixture", required:true
  }]
}' >"$FULL_DEPS_FILE"

# Restore the valid MCP fixture after the strict-error assertion above.
cp "$ROOT_DIR/tests/fixtures/repository-census/WordPress-mcp-adapter.jsonl" \
  "$PR_DIR/WordPress-mcp-adapter.jsonl"

PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$FULL_SNAP_DIR" \
WP_AI_DEPS_FILE="$FULL_DEPS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES_DIR="$PR_DIR" \
WP_AI_TEST_RELEASES_DIR="$RELEASE_DIR" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --json \
  >"$TMP_DIR/full.json" 2>"$TMP_DIR/full.err"

jq -e '
  (keys | sort) == ["board","dependencies","repo","repositories","validation"]
  and (.repositories | map(.repo)) == [
    "WordPress/ai",
    "WordPress/php-ai-client",
    "WordPress/mcp-adapter",
    "WordPress/abilities-api"
  ]
  and all(.repositories[];
    has("pr_diff") and has("release_diff") and has("issue_diff")
    and has("latest_shipped") and has("open_issues") and has("issues_available"))
  and all(.validation.errors[]
    | select(.code == "pr-roadmap-coverage-missing");
    (.context.id | startswith("WordPress/ai#")))
' "$TMP_DIR/full.json" >/dev/null

# 4 repos x (prs, issues, releases) + board + dependencies
[ "$(find "$FULL_SNAP_DIR" -maxdepth 1 -type f | wc -l)" -eq 14 ]
for snapshot in \
  prs-WordPress-php-ai-client \
  issues-WordPress-php-ai-client \
  releases-WordPress-php-ai-client \
  prs-WordPress-mcp-adapter \
  issues-WordPress-mcp-adapter \
  releases-WordPress-mcp-adapter \
  prs-WordPress-abilities-api \
  issues-WordPress-abilities-api \
  releases-WordPress-abilities-api; do
  find "$FULL_SNAP_DIR" -maxdepth 1 -type f -name "$snapshot-*.json" \
    | grep -q .
done

PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$FULL_SNAP_DIR" \
WP_AI_DEPS_FILE="$FULL_DEPS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES_DIR="$PR_DIR" \
WP_AI_TEST_RELEASES_DIR="$RELEASE_DIR" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --markdown \
  >"$TMP_DIR/full.md" 2>"$TMP_DIR/full-md.err"
rg -F '## Tracked repository PR/issue/release census' "$TMP_DIR/full.md" >/dev/null
# Columns: repo | open PRs | open issues | latest release | ...
rg -F '| `WordPress/php-ai-client` | 1 | 0 | `1.4.0` (2026-07-15) |' \
  "$TMP_DIR/full.md" >/dev/null
rg -F '| `WordPress/mcp-adapter` | 2 | 0 | `v0.5.0` (2026-04-15) |' \
  "$TMP_DIR/full.md" >/dev/null
rg -F '| `WordPress/abilities-api` | 2 | 0 | — |' "$TMP_DIR/full.md" >/dev/null

printf 'multi-repository census fixture tests passed\n'
