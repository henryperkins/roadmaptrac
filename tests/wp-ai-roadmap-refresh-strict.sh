#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
STATE_DIR="$TMP_DIR/state"
TEST_SNAP_DIR="$TMP_DIR/snapshots"
TEST_DOC_DIR="$TMP_DIR/docs"
TEST_REGISTRY="$TMP_DIR/dependencies.json"
TEST_REPOS_FILE="$TMP_DIR/repositories.json"
RELEASES="$TMP_DIR/releases.json"
OUT="$TMP_DIR/out.json"
ERR="$TMP_DIR/err.txt"
mkdir -p "$MOCK_BIN" "$STATE_DIR" "$TEST_SNAP_DIR" "$TEST_DOC_DIR"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"

cp "$ROOT_DIR/tests/fixtures/board-pr-coverage.json" \
  "$TEST_SNAP_DIR/proj240-20260716T000000Z.json"
printf '[]\n' >"$RELEASES"
printf '# Planned Work\n\n## Changelog\n\n| Date | Change |\n|---|---|\n' \
  >"$TEST_DOC_DIR/wordpress-ai-planned-work.md"
jq -n '{
  schemaVersion:1,
  items:[{
    id:"Example/deps#1", theme:"Fixture", aiRefs:[40],
    note:"Full-path dependency", required:true
  }]
}' >"$TEST_REGISTRY"
jq -n '{schemaVersion:1,repositories:[]}' >"$TEST_REPOS_FILE"

find "$ROOT_DIR/.wp-ai-roadmap-snapshots" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/real-snapshots.before"
find "$TEST_SNAP_DIR" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/test-snapshots.before"
sha256sum "$TEST_DOC_DIR/wordpress-ai-planned-work.md" \
  >"$TMP_DIR/planned.before"

set +e
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$TEST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
WP_AI_REPOS_FILE="$TEST_REPOS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
WP_AI_TEST_RELEASES="$RELEASES" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" \
  --strict --json --save --update-changelog >"$OUT" 2>"$ERR"
status=$?
set -e

[ "$status" -eq 2 ]
jq -e '
  (keys | sort)==["board","dependencies","repo","repositories","validation"]
  and (.validation.ok|not)
  and ([.validation.errors[].code] | index("pr-roadmap-coverage-missing") != null)
' "$OUT"
find "$TEST_SNAP_DIR" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/test-snapshots.after"
diff -u "$TMP_DIR/test-snapshots.before" "$TMP_DIR/test-snapshots.after"
sha256sum -c "$TMP_DIR/planned.before"
rg 'persistence skipped' "$ERR"

before_count="$(find "$TEST_SNAP_DIR" -maxdepth 1 -type f | wc -l)"
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$TEST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
WP_AI_REPOS_FILE="$TEST_REPOS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
WP_AI_TEST_RELEASES="$RELEASES" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --json --save \
  >"$TMP_DIR/normal.json" 2>"$TMP_DIR/normal.err"
jq -e . "$TMP_DIR/normal.json" >/dev/null
after_count="$(find "$TEST_SNAP_DIR" -maxdepth 1 -type f | wc -l)"
[ "$after_count" -eq "$((before_count + 5))" ]  # board + prs + issues + releases + deps

# First run (no baselines yet) must honor the strict gate: a red audit
# establishes nothing and exits 2 with parseable JSON.
FIRST_SNAP_DIR="$TMP_DIR/first-snapshots"
mkdir -p "$FIRST_SNAP_DIR"
set +e
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$FIRST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
WP_AI_REPOS_FILE="$TEST_REPOS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
WP_AI_TEST_RELEASES="$RELEASES" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --strict --json \
  >"$TMP_DIR/first-strict.json" 2>"$TMP_DIR/first-strict.err"
first_strict_status=$?
set -e
[ "$first_strict_status" -eq 2 ]
jq -e '(.validation.ok|not)' "$TMP_DIR/first-strict.json" >/dev/null
[ "$(find "$FIRST_SNAP_DIR" -maxdepth 1 -type f | wc -l)" -eq 0 ]
rg 'persistence skipped' "$TMP_DIR/first-strict.err" >/dev/null

# Normal-mode first run still establishes all four baselines and emits pure JSON.
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$FIRST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
WP_AI_REPOS_FILE="$TEST_REPOS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
WP_AI_TEST_RELEASES="$RELEASES" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --json \
  >"$TMP_DIR/first-normal.json" 2>"$TMP_DIR/first-normal.err"
jq -e '(keys | sort)==["board","dependencies","repo","repositories","validation"]' "$TMP_DIR/first-normal.json" >/dev/null
[ "$(find "$FIRST_SNAP_DIR" -maxdepth 1 -type f | wc -l)" -eq 5 ]  # board + prs + issues + releases + deps
rg 'Baseline established' "$TMP_DIR/first-normal.err" >/dev/null

# An invalid registry must never produce a dependency snapshot: a normal-mode
# --save run still saves board/PR/release snapshots but skips the dependency
# baseline instead of wiping the watchlist history with [].
printf '{broken\n' >"$TMP_DIR/broken-registry.json"
dep_count_before="$(find "$TEST_SNAP_DIR" -maxdepth 1 -type f -name 'wordpress-ai-cross-repo-dependencies-*' | wc -l)"
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$TEST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TMP_DIR/broken-registry.json" \
WP_AI_REPOS_FILE="$TEST_REPOS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
WP_AI_TEST_RELEASES="$RELEASES" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --json --save \
  >"$TMP_DIR/broken-save.json" 2>"$TMP_DIR/broken-save.err"
jq -e '.dependencies.validation.ok|not' "$TMP_DIR/broken-save.json" >/dev/null
dep_count_after="$(find "$TEST_SNAP_DIR" -maxdepth 1 -type f -name 'wordpress-ai-cross-repo-dependencies-*' | wc -l)"
[ "$dep_count_after" -eq "$dep_count_before" ]
rg 'dependency snapshot skipped' "$TMP_DIR/broken-save.err" >/dev/null

# Readiness rendering must print boolean values verbatim: a draft PR going
# ready is "isDraft true → false", never "true → —".
latest_prs="$(find "$TEST_SNAP_DIR" -maxdepth 1 -type f -name 'prs-WordPress-ai-*' | sort | tail -1)"
jq 'map(if .number==101 then .isDraft=true else . end)' "$latest_prs" \
  >"$TEST_SNAP_DIR/prs-WordPress-ai-20990101T000000Z.json"
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$TEST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
WP_AI_REPOS_FILE="$TEST_REPOS_FILE" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
WP_AI_TEST_RELEASES="$RELEASES" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --markdown \
  >"$TMP_DIR/radar.md" 2>/dev/null
rg -F 'isDraft true → false' "$TMP_DIR/radar.md" >/dev/null

set +e
"$ROOT_DIR/wp-ai-roadmap-refresh.sh" --not-a-real-option >/dev/null 2>&1
invalid_status=$?
"$ROOT_DIR/wp-ai-roadmap-refresh.sh" \
  --baseline "$TMP_DIR/missing-baseline.json" >/dev/null 2>&1
baseline_status=$?
set -e
[ "$invalid_status" -eq 1 ]
[ "$baseline_status" -eq 1 ]

find "$ROOT_DIR/.wp-ai-roadmap-snapshots" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/real-snapshots.after"
diff -u "$TMP_DIR/real-snapshots.before" "$TMP_DIR/real-snapshots.after"
printf 'strict CLI fixture tests passed\n'
