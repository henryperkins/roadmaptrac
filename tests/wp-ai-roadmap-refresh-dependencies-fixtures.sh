#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT_DIR/wp-ai-roadmap-dependencies.json"

[ -f "$REGISTRY" ] || {
  printf 'FAIL: dependency registry is missing\n' >&2
  exit 1
}

jq -e '
  .schemaVersion == 1
  and (.items | length == 16)
  and ([.items[].id] | unique | length == 16)
  and all(.items[];
    (.id | test("^[^/]+/[^#]+#[1-9][0-9]*$"))
    and (.theme | type == "string" and length > 0)
    and (.note | type == "string" and length > 0)
    and (.required | type == "boolean")
    and (.aiRefs | type == "array"
      and all(.[]; type == "number" and . > 0 and floor == .)
      and (unique | length) == length))
' "$REGISTRY" >/dev/null

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
STATE_DIR="$TMP_DIR/state"
TEST_REGISTRY="$TMP_DIR/dependencies.json"
mkdir -p "$MOCK_BIN" "$STATE_DIR"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"

jq -n '{
  schemaVersion:1,
  items:[
    {
      id:"Example/deps#1", theme:"Required", aiRefs:[40],
      note:"Required fixture dependency", required:true
    },
    {
      id:"Example/deps#2", theme:"Optional", aiRefs:[430],
      note:"Optional fixture dependency", required:false
    }
  ]
}' >"$TEST_REGISTRY"

run_dependencies() {
  local mode="$1" strict="$2" output="$3"
  set +e
  PATH="$MOCK_BIN:$PATH" \
  WP_AI_TEST_STATE_DIR="$STATE_DIR" \
  WP_AI_TEST_DEP_MODE="$mode" \
  WP_AI_DEPS_FILE="$TEST_REGISTRY" \
    "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies $strict --json >"$output" 2>"$output.err"
  RUN_STATUS=$?
  set -e
}

run_dependencies required-fail-once --strict "$TMP_DIR/retry.json"
[ "$RUN_STATUS" -eq 0 ]
jq -e '.validation.ok and ([.items[].state] | index("UNKNOWN") | not)' "$TMP_DIR/retry.json"
[ "$(<"$STATE_DIR/repos_Example_deps_issues_1.count")" -eq 2 ]

PATH="$MOCK_BIN:$PATH" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_DEP_MODE=all-ok \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --markdown \
  >"$TMP_DIR/dependencies.md"
grep -F 'AI refs: #40' "$TMP_DIR/dependencies.md"
grep -F 'AI refs: #430' "$TMP_DIR/dependencies.md"

rm -rf "$STATE_DIR"; mkdir -p "$STATE_DIR"
run_dependencies required-fail --strict "$TMP_DIR/required.json"
[ "$RUN_STATUS" -eq 2 ]
jq -e '
  (.items | length)==2
  and ([.items[]|select(.id=="Example/deps#1")][0].state=="UNKNOWN")
  and (.validation.ok|not)
  and ([.validation.errors[].code] | index("dependency-required-unreachable") != null)
' "$TMP_DIR/required.json"

rm -rf "$STATE_DIR"; mkdir -p "$STATE_DIR"
run_dependencies optional-fail --strict "$TMP_DIR/optional.json"
[ "$RUN_STATUS" -eq 0 ]
jq -e '
  .validation.ok
  and ([.validation.warnings[].code] | index("dependency-optional-unreachable") != null)
' "$TMP_DIR/optional.json"

printf '{not-json\n' >"$TMP_DIR/malformed.json"
set +e
PATH="$MOCK_BIN:$PATH" WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_DEPS_FILE="$TMP_DIR/malformed.json" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --strict --json \
  >"$TMP_DIR/malformed.out" 2>"$TMP_DIR/malformed.err"
malformed_status=$?
set -e
[ "$malformed_status" -eq 2 ]
jq -e '
  (.validation.ok|not)
  and .items==[]
  and ([.validation.errors[].code] | index("dependency-registry-invalid") != null)
' "$TMP_DIR/malformed.out"

set +e
PATH="$MOCK_BIN:$PATH" WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_DEPS_FILE="$TMP_DIR/malformed.json" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --json \
  >"$TMP_DIR/malformed-normal.out" 2>/dev/null
malformed_normal_status=$?
set -e
[ "$malformed_normal_status" -eq 0 ]
jq -e '(.validation.ok|not)' "$TMP_DIR/malformed-normal.out"

# Markdown strict mode must name the failure on stderr — exit 2 with a
# blank stderr leaves the operator with no stated reason.
set +e
PATH="$MOCK_BIN:$PATH" WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_DEPS_FILE="$TMP_DIR/malformed.json" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --strict \
  >"$TMP_DIR/malformed-md.out" 2>"$TMP_DIR/malformed-md.err"
malformed_md_status=$?
set -e
[ "$malformed_md_status" -eq 2 ]
grep -F 'dependency-registry-invalid' "$TMP_DIR/malformed-md.err" >/dev/null

# An empty Open-dependencies list renders the explicit "_(none)_" marker.
jq -n '{
  schemaVersion:1,
  items:[{
    id:"Example/deps#2", theme:"Optional", aiRefs:[430],
    note:"Optional fixture dependency", required:false
  }]
}' >"$TMP_DIR/optional-only.json"
rm -rf "$STATE_DIR"; mkdir -p "$STATE_DIR"
PATH="$MOCK_BIN:$PATH" WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_DEP_MODE=optional-fail \
WP_AI_DEPS_FILE="$TMP_DIR/optional-only.json" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --markdown \
  >"$TMP_DIR/none.md" 2>/dev/null
grep -F '_(none)_' "$TMP_DIR/none.md" >/dev/null

jq '.items += [.items[0]]' "$TEST_REGISTRY" >"$TMP_DIR/duplicate.json"
set +e
PATH="$MOCK_BIN:$PATH" WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_DEPS_FILE="$TMP_DIR/duplicate.json" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --strict --json \
  >"$TMP_DIR/duplicate.out" 2>"$TMP_DIR/duplicate.err"
duplicate_status=$?
set -e
[ "$duplicate_status" -eq 2 ]
jq -e '
  (.validation.ok|not)
  and ([.validation.errors[].code] | index("dependency-registry-invalid") != null)
' "$TMP_DIR/duplicate.out"

set +e
WP_AI_DEPS_FILE="$TMP_DIR/missing.json" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --json \
  >/dev/null 2>&1
missing_status=$?
set -e
[ "$missing_status" -eq 1 ]

printf 'dependency registry contract passed\n'
printf 'dependency fixture tests passed\n'
