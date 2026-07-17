# Pull Request and Dependency Tracking Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the WordPress AI roadmap tracker report authoritative PR relationships and resilient cross-repository dependencies, with warning-only normal operation and an optional read-only strict audit mode.

**Architecture:** Keep `wp-ai-roadmap-refresh.sh` as the single Bash/jq CLI. Move dependency membership into a versioned JSON registry, normalize paginated PR GraphQL responses into backward-compatible snapshots, join roadmap entities by `repository#number`, and aggregate deterministic validation records at command boundaries. Deterministic shell fixtures cover contracts offline; one existing smoke test continues to exercise live dependency reads.

**Tech Stack:** Bash with `set -euo pipefail`, jq, GitHub CLI REST/GraphQL reads, JSON fixtures, Markdown

## Global Constraints

- The tracker is read-only: no command may add, edit, or remove GitHub issues, PRs, releases, milestones, or Project #240 cards.
- Preserve `wp-ai-roadmap-refresh.sh` as the only user-facing entry point and retain every existing subcommand.
- Normal mode is warning-only when a board report can still be produced.
- Exit `0` means completed, exit `1` means an operational/usage failure prevented the promised report, and exit `2` means a complete strict report contains audit violations.
- JSON stdout must remain parseable when exit `2` is returned; human diagnostics go to stderr.
- A strict violation suppresses `--save` and `--update-changelog`.
- Strict coverage requires a direct board PR or a repo-qualified link to an on-board issue; routine PRs are exempt.
- Derive `isBot` from GraphQL `author.__typename == "Bot"`. Preserve the current routine rules: bot typename, login containing `dependabot`, or a title starting with `fix(deps)`, `build(deps)`, `chore(deps)`, or `ci:`.
- Disable fallback issue parsing for routine PRs. Use only the exact title, branch, and body grammar in the approved spec.
- Join board PRs and issues by `repository#number`. Interpret legacy bare `issues` numbers as `WP_AI_REPO`.
- Query `closingIssuesReferences(first: 20)` and reject truncation or count mismatch.
- Store new dependency `aiRefs` as integers, accept historical `"#NNN"` strings, and render exactly one `#`.
- Retry each failed request for a required dependency exactly once; optional dependency requests get one attempt.
- Preserve old PR snapshots as valid baselines and ignore enriched readiness fields that are absent from either side of a PR diff.
- Every fixture reaching the main path must export a temporary `WP_AI_SNAP_DIR` and prove the real snapshot directory is unchanged.
- Preserve the five currently modified roadmap documents and four untracked 2026-07-17 snapshots until the documentation task deliberately reconciles them.
- Preserve the existing stdin-to-jq dependency payload path; do not reintroduce large `--argjson` command-line payloads that fail under Git Bash.

---

## File Structure

- Create `wp-ai-roadmap-dependencies.json`: versioned source of truth for the 16 curated upstream items.
- Modify `wp-ai-roadmap-refresh.sh`: registry loading, resilient dependency records, GraphQL PR census, repo-qualified coverage, validation, strict exits, rendering, and persistence gating.
- Create `tests/helpers/mock-gh.sh`: deterministic read-only GitHub CLI substitute driven by environment-selected fixtures and a temporary state directory.
- Create `tests/fixtures/pr-graphql-pages.jsonl`: two paginated PR GraphQL responses covering authoritative, fallback, routine, and near-miss links.
- Create `tests/fixtures/board-graphql-page.json`: minimal live Project #240 response for isolated full-path tests.
- Create `tests/fixtures/board-pr-coverage.json`: board cards with local and cross-repository number collisions.
- Create `tests/fixtures/prs-pr-coverage.json`: normalized PRs spanning all five coverage classifications and legacy links.
- Create `tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh`: offline registry, retry, UNKNOWN, summary, and dependency strict-mode tests.
- Create `tests/wp-ai-roadmap-refresh-prs.sh`: offline PR GraphQL normalization, parsing, pagination, and readiness-diff tests.
- Create `tests/wp-ai-roadmap-refresh-gap.sh`: offline repo-qualified classification, validation-invariant, and gap exit tests.
- Create `tests/wp-ai-roadmap-refresh-strict.sh`: full-path aggregation, JSON stdout, exit-code, snapshot-isolation, and persistence-gate tests.
- Modify `tests/wp-ai-roadmap-refresh-dependencies.sh`: retain the exact 16-ID live smoke test and require strict validation success.
- Modify the five existing roadmap Markdown files only after code and deterministic tests pass.

### Task 1: Add the Declarative Dependency Registry

**Files:**
- Create: `wp-ai-roadmap-dependencies.json`
- Create: `tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh`
- Modify: `wp-ai-roadmap-refresh.sh:36-61`
- Modify: `wp-ai-roadmap-refresh.sh:254-276`
- Modify: `wp-ai-roadmap-refresh.sh:394-450`

**Interfaces:**
- Consumes: `WP_AI_DEPS_FILE`, defaulting to `$SCRIPT_DIR/wp-ai-roadmap-dependencies.json`.
- Produces: `load_dependency_registry FILE`, which prints `{"items":[...],"validation":{"ok":BOOL,"errors":[],"warnings":[]}}` and returns `0` for a readable file even when schema errors are present; a missing/unreadable file uses operational exit `1`.
- Produces: registry items with `id`, `theme`, integer `aiRefs`, `note`, and Boolean `required`.

- [x] **Step 1: Write the failing registry contract test**

Create the initial `tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh` with:

```bash
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

printf 'dependency registry contract passed\n'
```

Set its executable mode:

```bash
chmod +x tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
```

- [x] **Step 2: Run the new test to prove the registry is absent**

Run:

```bash
bash -n tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
```

Expected: syntax passes; direct execution fails with `FAIL: dependency registry is missing`.

- [x] **Step 3: Add the complete 16-item registry**

Create `wp-ai-roadmap-dependencies.json` with exactly:

```json
{
  "schemaVersion": 1,
  "items": [
    {"id":"WordPress/gutenberg#70710","theme":"Platform / workflows","aiRefs":[21,40,430],"note":"Abilities and Workflows overview for Command Palette and AI tool surfaces","required":true},
    {"id":"WordPress/gutenberg#74234","theme":"Platform / core abilities","aiRefs":[40],"note":"Core post-management abilities implementation","required":true},
    {"id":"WordPress/gutenberg#77230","theme":"Skills / Guidelines","aiRefs":[430],"note":"Guidelines CPT evolution toward skills, memory, and plans","required":true},
    {"id":"WordPress/gutenberg#77643","theme":"Skills / Guidelines","aiRefs":[430],"note":"Guidelines public API extraction","required":true},
    {"id":"WordPress/gutenberg#75221","theme":"Media / focal point","aiRefs":[238],"note":"Media-level focal point selector for AI crop suggestions","required":true},
    {"id":"WordPress/gutenberg#72734","theme":"Media Editor","aiRefs":[325],"note":"Dedicated media editor foundation","required":true},
    {"id":"WordPress/gutenberg#73771","theme":"Media Editor","aiRefs":[238,325],"note":"Media Editor modal task tracking and extension surface","required":true},
    {"id":"WordPress/gutenberg#77994","theme":"Media Editor","aiRefs":[325],"note":"Media Editor route and modal component refactor","required":true},
    {"id":"WordPress/gutenberg#74572","theme":"Admin UX / DataViews","aiRefs":[741],"note":"DataViews flicker fix used as a reference for AI admin flicker","required":true},
    {"id":"WordPress/gutenberg#16549","theme":"Admin UX / accessibility","aiRefs":[699],"note":"Snackbar accessibility caveat for copy-feedback UI","required":true},
    {"id":"WordPress/gutenberg#77816","theme":"Admin UX / toast component","aiRefs":[699],"note":"Toast component direction related to snackbar replacement","required":true},
    {"id":"WordPress/abilities-api#38","theme":"Ability registry filtering","aiRefs":[21,354],"note":"Filter registered abilities by namespace, category, and metadata","required":true},
    {"id":"WordPress/abilities-api#62","theme":"Ability safety metadata","aiRefs":[40],"note":"Hints for destructive, read-only, and idempotent abilities","required":true},
    {"id":"WordPress/abilities-api#84","theme":"Core CRUD abilities","aiRefs":[40],"note":"CRUD abilities that work across post types","required":true},
    {"id":"WordPress/abilities-api#105","theme":"Core abilities scope","aiRefs":[40],"note":"Core Abilities for WordPress 6.9","required":true},
    {"id":"WordPress/abilities-api#106","theme":"Ability metadata","aiRefs":[40],"note":"Determine what belongs in Ability meta","required":true}
  ]
}
```

- [x] **Step 4: Add registry configuration and schema loading**

In the configuration block add:

```bash
DEPS_FILE="${WP_AI_DEPS_FILE:-$SCRIPT_DIR/wp-ai-roadmap-dependencies.json}"
STRICT=0
```

Replace `dependency_watchlist()` with `load_dependency_registry()`. The jq predicate must build stable `dependency-registry-invalid` errors for each failed condition and set `ok` from the error-array length:

```bash
load_dependency_registry() {
  local file="$1"
  [ -r "$file" ] || die "dependency registry not readable: $file"

  if ! jq -e . "$file" >/dev/null 2>&1; then
    jq -n --arg file "$file" '{
      items: [],
      validation: {
        ok: false,
        errors: [{
          code: "dependency-registry-invalid",
          message: "Dependency registry is not valid JSON",
          context: {file:$file}
        }],
        warnings: []
      }
    }'
    return 0
  fi

  jq '
    def diagnostic($message; $context): {
      code:"dependency-registry-invalid",
      message:$message,
      context:$context
    };
    . as $registry
    | ([
        if (.schemaVersion != 1)
          then diagnostic("schemaVersion must equal 1"; {actual:.schemaVersion}) else empty end,
        if ((.items | type) != "array" or (.items | length) == 0)
          then diagnostic("items must be a nonempty array"; {}) else empty end,
        ([.items[]?.id] | group_by(.) | map(select(length > 1) | .[0]))[]?
          | diagnostic("dependency IDs must be unique"; {id:.}),
        .items[]? as $item
          | if (
              ($item.id | type) != "string"
              or ($item.id | test("^[^/]+/[^#]+#[1-9][0-9]*$") | not)
              or ($item.theme | type) != "string" or ($item.theme | length) == 0
              or ($item.note | type) != "string" or ($item.note | length) == 0
              or ($item.required | type) != "boolean"
              or ($item.aiRefs | type) != "array"
              or ([$item.aiRefs[]? | select(type != "number" or . <= 0 or floor != .)] | length) > 0
              or (($item.aiRefs | unique | length) != ($item.aiRefs | length))
            )
            then diagnostic("dependency item does not match schema"; {id:($item.id // null)})
            else empty
            end
      ] | sort_by(.code, (.context|tostring))) as $errors
    | {
        items: (if ($errors|length)==0 then $registry.items else [] end),
        validation: {ok:($errors|length==0), errors:$errors, warnings:[]}
      }
  ' "$file"
}
```

For this first slice, preserve the existing pipe-delimited fetch loop by replacing `dependency_watchlist()` with this registry adapter:

```bash
dependency_watchlist() {
  local loaded
  loaded="$(load_dependency_registry "$DEPS_FILE")"
  jq -r '
    .items[]
    | [
        .id,
        .theme,
        (.aiRefs | map("#" + tostring) | join(",")),
        .note
      ]
    | join("|")
  ' <<<"$loaded"
}
```

Task 2 will replace this transitional adapter when `required` and structured fetch errors become part of every emitted item. Keep the existing stdin-to-jq REST payload normalization unchanged in this task.

- [x] **Step 5: Run the registry contract and existing live smoke test**

Run:

```bash
./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
./tests/wp-ai-roadmap-refresh-dependencies.sh
bash -n wp-ai-roadmap-refresh.sh
git diff --check
```

Expected: both dependency tests pass; Bash syntax and whitespace checks exit `0`.

- [x] **Step 6: Commit the registry slice**

```bash
git add wp-ai-roadmap-dependencies.json \
  wp-ai-roadmap-refresh.sh \
  tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
git diff --cached --check
git commit -m "Add declarative roadmap dependency registry"
```

### Task 2: Make Dependency Fetches Complete, Retryable, and Strict

**Files:**
- Create: `tests/helpers/mock-gh.sh`
- Modify: `tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh`
- Modify: `wp-ai-roadmap-refresh.sh:278-327`
- Modify: `wp-ai-roadmap-refresh.sh:394-471`
- Modify: `wp-ai-roadmap-refresh.sh:491-501`

**Interfaces:**
- Consumes: validated registry items.
- Produces: `fetch_dependencies` records for every registry ID, using `state:"UNKNOWN"` and `fetchError:{code,endpoint,attempts,message}` after exhaustion.
- Produces: dependency result `{items,summary,diff,validation}`.
- Produces: `dependencies [--strict] [--json|--markdown]` with exit `2` only after output when required items remain unknown.

- [x] **Step 1: Add a deterministic GitHub CLI mock**

Create executable `tests/helpers/mock-gh.sh`. Its dependency branch must parse `gh api repos/OWNER/REPO/issues/NUMBER`, persist attempt counts under `WP_AI_TEST_STATE_DIR`, and support `all-ok`, `required-fail-once`, `required-fail`, and `optional-fail`:

```bash
#!/usr/bin/env bash
set -euo pipefail

state_dir="${WP_AI_TEST_STATE_DIR:?}"
mode="${WP_AI_TEST_DEP_MODE:-all-ok}"
mkdir -p "$state_dir"

if [ "${1:-}" = api ] && [[ "${2:-}" == repos/*/issues/* ]]; then
  endpoint="$2"
  number="${endpoint##*/}"
  counter="$state_dir/${endpoint//\//_}.count"
  attempts=0
  [ ! -f "$counter" ] || attempts="$(<"$counter")"
  attempts=$((attempts + 1))
  printf '%s\n' "$attempts" > "$counter"

  case "$mode:$number:$attempts" in
    required-fail-once:1:1|required-fail:1:*|optional-fail:2:*)
      printf 'mock dependency failure for %s\n' "$endpoint" >&2
      exit 1
      ;;
  esac

  printf '{"number":%s,"title":"Dependency %s","state":"open","updated_at":"2026-07-17T00:00:00Z","labels":[],"html_url":"https://github.com/Example/deps/issues/%s","milestone":null}\n' \
    "$number" "$number" "$number"
  exit 0
fi

printf 'unexpected mock gh invocation: %s\n' "$*" >&2
exit 1
```

Set the helper executable:

```bash
chmod +x tests/helpers/mock-gh.sh
```

- [x] **Step 2: Extend the fixture test with RED cases**

Append this setup to `tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh` after the committed-registry assertion:

```bash
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
```

Then add these assertions:

```bash
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
rg 'AI refs: #40' "$TMP_DIR/dependencies.md"
rg 'AI refs: #430' "$TMP_DIR/dependencies.md"

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

printf 'dependency fixture tests passed\n'
```

Move the Task 1 `dependency registry contract passed` print to this final position so the script never reports success before retry and strict assertions finish.

- [x] **Step 3: Run the dependency fixture test and verify RED**

Run `./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh`.

Expected: fail because `dependencies --strict` and UNKNOWN placeholder validation do not exist yet.

- [x] **Step 4: Implement bounded fetches and validation**

Add `fetch_dependency_endpoint ITEM ENDPOINT`. It makes one request for optional items and two for required items, captures the final stderr text, and returns a structured failure without dropping the item.

Call `load_dependency_registry` exactly once per command. If its validation is false, make no GitHub requests and pass its errors into the final dependency result. Otherwise fetch its `items` and merge registry diagnostics with fetch diagnostics before computing final `validation.ok`.

Update `fetch_dependencies` so every registry entry emits either a live record or:

```json
{
  "id": "Example/deps#1",
  "repo": "Example/deps",
  "number": 1,
  "type": "Unknown",
  "title": "(unreachable dependency)",
  "state": "UNKNOWN",
  "isDraft": null,
  "mergedAt": null,
  "milestone": null,
  "updatedAt": null,
  "labels": [],
  "url": "https://github.com/Example/deps/issues/1",
  "theme": "Test",
  "aiRefs": [40],
  "note": "Test dependency",
  "required": true,
  "fetchError": {
    "code": "github-fetch-failed",
    "endpoint": "repos/Example/deps/issues/1",
    "attempts": 2,
    "message": "mock dependency failure"
  }
}
```

Build validation from emitted items:

```jq
def diagnostic($code; $message; $item): {
  code:$code,
  message:$message,
  context:{id:$item.id, endpoint:$item.fetchError.endpoint}
};
[
  $items[]
  | select(.state=="UNKNOWN")
  | if .required
      then diagnostic("dependency-required-unreachable"; "Required dependency is unreachable"; .)
      else diagnostic("dependency-optional-unreachable"; "Optional dependency is unreachable"; .)
    end
] as $unknown
| {
    errors:[$unknown[]|select(.code=="dependency-required-unreachable")],
    warnings:[$unknown[]|select(.code=="dependency-optional-unreachable")]
  }
| .ok=(.errors|length==0)
```

Before merging fetch diagnostics, assert that emitted IDs equal the validated registry IDs exactly and recompute `summary.total`, `summary.by_repo`, and `summary.by_state` from emitted `items`. Add `dependency-validation-inconsistent` when any equality fails.

Update `RENDER_DEPS_JQ` with one formatter that accepts both historical strings and new integers:

```jq
def ai_ref:
  tostring | if startswith("#") then . else "#" + . end;
def ai_refs:
  [.[] | ai_ref] | join(", ");
```

Replace every dependency `aiRefs|join(", ")` expression with `aiRefs|ai_refs`. Do not add `aiRefs` to dependency change comparisons, so the representation migration itself produces no diff.

Add subcommand option parsing for `dependencies --strict --json` in either option order. Emit the result first, then return `2` when `STRICT=1` and `validation.ok=false`.

- [x] **Step 5: Verify dependency retry, strict, and summary invariants**

Run:

```bash
./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
bash -n wp-ai-roadmap-refresh.sh tests/helpers/mock-gh.sh
git diff --check
```

Expected: fixture test reports registry, retry-success, required-UNKNOWN, optional-UNKNOWN, and summary checks passed.

- [x] **Step 6: Commit resilient dependency tracking**

```bash
git add wp-ai-roadmap-refresh.sh \
  tests/helpers/mock-gh.sh \
  tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
git diff --cached --check
git commit -m "Make roadmap dependency tracking resilient"
```

### Task 3: Replace the PR Census with Authoritative GraphQL Data

**Files:**
- Create: `tests/fixtures/pr-graphql-pages.jsonl`
- Create: `tests/wp-ai-roadmap-refresh-prs.sh`
- Modify: `tests/helpers/mock-gh.sh`
- Modify: `wp-ai-roadmap-refresh.sh:155-172`
- Modify: `wp-ai-roadmap-refresh.sh:362-367`
- Modify: `wp-ai-roadmap-refresh.sh:486-490`

**Interfaces:**
- Produces: `fetch_pr_census` with `{items:[normalized PR...],validation:{ok,errors,warnings}}`.
- Each normalized PR adds `repo:WP_AI_REPO` and preserves `issues:[NUMBER...]` for local links while adding `issueLinks:[{repo,number,source}]`, `isBot`, `routine`, `reviewDecision`, `mergeStateStatus`, and `checkState`.
- `census` produces `{open_prs,releases,validation}`; `census --strict` validates PR fetch/schema only.

- [x] **Step 1: Create two GraphQL fixture pages**

Create `tests/fixtures/pr-graphql-pages.jsonl` with these exact two JSON lines:

```json
{"data":{"repository":{"pullRequests":{"totalCount":5,"pageInfo":{"hasNextPage":true,"endCursor":"page-2"},"nodes":[{"number":100,"title":"fix(deps): update packages","url":"https://github.com/WordPress/ai/pull/100","body":"Release notes (#312), #78820","isDraft":false,"headRefName":"dependabot/npm/update","updatedAt":"2026-07-17T00:00:00Z","reviewDecision":null,"mergeStateStatus":"CLEAN","author":{"__typename":"Bot","login":"dependabot"},"commits":{"nodes":[{"commit":{"statusCheckRollup":{"state":"SUCCESS"}}}]},"closingIssuesReferences":{"totalCount":0,"nodes":[]}},{"number":101,"title":"Fix #40","url":"https://github.com/WordPress/ai/pull/101","body":"Fixes #40","isDraft":false,"headRefName":"fix/issue-40","updatedAt":"2026-07-17T01:00:00Z","reviewDecision":"APPROVED","mergeStateStatus":"CLEAN","author":{"__typename":"User","login":"alice"},"commits":{"nodes":[{"commit":{"statusCheckRollup":{"state":"SUCCESS"}}}]},"closingIssuesReferences":{"totalCount":1,"nodes":[{"number":40,"repository":{"nameWithOwner":"WordPress/ai"}}]}},{"number":102,"title":"Feat 514: add score","url":"https://github.com/WordPress/ai/pull/102","body":"No relationship phrase here (#900)","isDraft":true,"headRefName":"comment-score","updatedAt":"2026-07-17T02:00:00Z","reviewDecision":"REVIEW_REQUIRED","mergeStateStatus":"BLOCKED","author":{"__typename":"User","login":"bob"},"commits":{"nodes":[{"commit":{"statusCheckRollup":{"state":"PENDING"}}}]},"closingIssuesReferences":{"totalCount":0,"nodes":[]}}]}}}}
{"data":{"repository":{"pullRequests":{"totalCount":5,"pageInfo":{"hasNextPage":false,"endCursor":null},"nodes":[{"number":103,"title":"Add guidelines support","url":"https://github.com/WordPress/ai/pull/103","body":"","isDraft":false,"headRefName":"feature/430-fix","updatedAt":"2026-07-17T03:00:00Z","reviewDecision":null,"mergeStateStatus":"DIRTY","author":{"__typename":"User","login":"carol"},"commits":{"nodes":[{"commit":{"statusCheckRollup":{"state":"FAILURE"}}}]},"closingIssuesReferences":{"totalCount":0,"nodes":[]}},{"number":104,"title":"Improve global toggle","url":"https://github.com/WordPress/ai/pull/104","body":"Related to WordPress/ai#600. Changelog (#999).","isDraft":false,"headRefName":"update-php-8.2-compat","updatedAt":"2026-07-17T04:00:00Z","reviewDecision":"CHANGES_REQUESTED","mergeStateStatus":"UNSTABLE","author":{"__typename":"User","login":"dana"},"commits":{"nodes":[{"commit":{"statusCheckRollup":{"state":"ERROR"}}}]},"closingIssuesReferences":{"totalCount":0,"nodes":[]}}]}}}}
```

- [x] **Step 2: Write the failing PR census test**

Extend `tests/helpers/mock-gh.sh` before its dependency branch:

```bash
if [ "${1:-}" = api ] && [ "${2:-}" = graphql ] \
  && [[ "$*" == *pullRequests* ]]; then
  cat "${WP_AI_TEST_PR_PAGES:?}"
  exit 0
fi

if [ "${1:-}" = release ] && [ "${2:-}" = list ]; then
  if [ -n "${WP_AI_TEST_RELEASES:-}" ]; then
    cat "$WP_AI_TEST_RELEASES"
  else
    printf '[]\n'
  fi
  exit 0
fi
```

Create executable `tests/wp-ai-roadmap-refresh-prs.sh` with this setup before its assertions:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
MOCK_BIN="$TMP_DIR/bin"
STATE_DIR="$TMP_DIR/state"
mkdir -p "$MOCK_BIN" "$STATE_DIR"
ln -s "$ROOT_DIR/tests/helpers/mock-gh.sh" "$MOCK_BIN/gh"
```

Then fetch and assert:

```bash
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
```

Set the test executable before its first run:

```bash
chmod +x tests/wp-ai-roadmap-refresh-prs.sh
```

End the script, after every assertion added by Tasks 3 and 5, with:

```bash
printf 'PR census fixture tests passed\n'
```

Add this mutation helper and exact diagnostic assertions:

```bash
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
```

- [x] **Step 3: Run the PR test and verify RED**

Run `./tests/wp-ai-roadmap-refresh-prs.sh`.

Expected: fail because `census` still uses `gh pr list`, lacks enriched fields, and the mock rejects that invocation.

- [x] **Step 4: Add the paginated PR GraphQL query**

Add `PR_GQL_QUERY` using repository owner/name derived from `WP_AI_REPO`:

```graphql
query($owner: String!, $name: String!, $endCursor: String) {
  repository(owner: $owner, name: $name) {
    pullRequests(first: 100, after: $endCursor, states: OPEN) {
      totalCount
      pageInfo { hasNextPage endCursor }
      nodes {
        number title url body isDraft headRefName updatedAt
        reviewDecision mergeStateStatus
        author { __typename login }
        commits(last: 1) {
          nodes { commit { statusCheckRollup { state } } }
        }
        closingIssuesReferences(first: 20) {
          totalCount
          nodes { number repository { nameWithOwner } }
        }
      }
    }
  }
}
```

Call `gh api graphql --paginate` and slurp its page objects. Treat a failed whole query as operational failure `1` for standalone `census`.

- [x] **Step 5: Implement deterministic normalization**

Replace the broad `refs()` parser. Implement exact source functions matching the spec and merge links with this rank:

```jq
def source_rank:
  {"closing":0,"fallback-title":1,"fallback-body":2,"fallback-branch":3,"legacy":4}[.source];
def unique_links:
  group_by([.repo,.number])
  | map(sort_by(source_rank) | first)
  | sort_by(.repo,.number);
def is_routine:
  (.author.__typename=="Bot")
  or ((.author.login // "") | test("dependabot";"i"))
  or ((.title // "") | test("^(fix$(deps$)|build$(deps$)|chore$(deps$)|ci:)";"i"));
```

Add these exact fallback functions to `PR_NORMALIZE_JQ`:

```jq
def title_links($text; $repo):
  ([
    ($text // "")
    | match("(?:^|[^A-Za-z0-9_/-])#([1-9][0-9]*)(?=$|[^0-9])";"gi")
    | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-title"}
  ] + [
    ($text // "")
    | match("\\b(?:issue|feat|feature)[ :_#-]+([1-9][0-9]*)(?=$|[^0-9])";"gi")
    | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-title"}
  ]);

def branch_links($text; $repo): [
  ($text // "")
  | match("(?:^|/)(?:issue|feat|feature)[/_-]#?([1-9][0-9]*)(?:$|[/_-])";"gi")
  | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-branch"}
];

def relationship:
  "\\b(?:fix|fixes|fixed|close|closes|closed|resolve|resolves|resolved|implement|implements|implemented|track|tracks|tracked|relates[ ]+to|related[ ]+to|issue)[\\t ]*:?[\\t ]+";

def body_links($text; $repo):
  ([
    ($text // "")
    | match(relationship + "https://github\\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/issues/([1-9][0-9]*)";"gi")
    | {
        repo:(.captures[0].string + "/" + .captures[1].string),
        number:(.captures[2].string|tonumber),
        source:"fallback-body"
      }
  ] + [
    ($text // "")
    | match(relationship + "([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)#([1-9][0-9]*)";"gi")
    | {
        repo:.captures[0].string,
        number:(.captures[1].string|tonumber),
        source:"fallback-body"
      }
  ] + [
    ($text // "")
    | match(relationship + "#([1-9][0-9]*)";"gi")
    | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-body"}
  ]);
```

Build closing links before checking `routine`. When routine is true, concatenate no fallback links; otherwise concatenate `title_links(.title;$repo)`, `body_links(.body;$repo)`, and `branch_links(.headRefName;$repo)`. Pass the result through `unique_links`. Set `repo:$repo` on every normalized PR and set local `issues` from `issueLinks | map(select(.repo==$repo)|.number) | unique`.

Normalize `checkState` from the latest commit's `statusCheckRollup.state`. Validate unique PR numbers, repeated total count, last-page completion, total node count, and every nested closing-reference count. Sort diagnostics by `code` then serialized `context`.

- [x] **Step 6: Make `census` expose strict validation without board coverage**

Parse `census [--strict]`. Return:

```json
{
  "open_prs": [],
  "releases": [],
  "validation": {"ok": true, "errors": [], "warnings": []}
}
```

Exit `2` after JSON only when `--strict` is present and census validation has errors.

- [x] **Step 7: Verify and commit authoritative PR census**

Run:

```bash
./tests/wp-ai-roadmap-refresh-prs.sh
./wp-ai-roadmap-refresh.sh census | jq -e '
  (.open_prs|length)>0
  and .validation.ok
  and all(.open_prs[]; has("issueLinks") and has("routine") and has("checkState"))
'
bash -n wp-ai-roadmap-refresh.sh tests/wp-ai-roadmap-refresh-prs.sh
git diff --check
```

Expected: fixture and live census checks pass.

Commit:

```bash
git add wp-ai-roadmap-refresh.sh tests/helpers/mock-gh.sh \
  tests/fixtures/pr-graphql-pages.jsonl \
  tests/wp-ai-roadmap-refresh-prs.sh
git commit -m "Use authoritative PR roadmap relationships"
```

### Task 4: Add Repo-Qualified Coverage and Offline Strict Gap Audits

**Files:**
- Create: `tests/fixtures/board-pr-coverage.json`
- Create: `tests/fixtures/prs-pr-coverage.json`
- Create: `tests/wp-ai-roadmap-refresh-gap.sh`
- Modify: `wp-ai-roadmap-refresh.sh:179-205`
- Modify: `wp-ai-roadmap-refresh.sh:502-505`

**Interfaces:**
- Consumes: a normalized board array and either enriched or legacy normalized PR array.
- Produces: gap JSON with `classifications` arrays and `classification_counts` for `direct-board-pr`, `linked-board-issue`, `routine`, `linked-off-board-issue`, and `unexplained`.
- Produces: `validation` with exact coverage invariants.
- `gap BOARD PRS` exits `0`; `gap --strict BOARD PRS` emits identical JSON and exits `2` when coverage errors exist.

- [x] **Step 1: Create complete coverage fixtures**

Create `tests/fixtures/board-pr-coverage.json`:

```json
[
  {"id":"WordPress/ai#200","type":"PullRequest","number":200,"title":"Direct PR","repo":"WordPress/ai","state":"OPEN","status":"In progress","milestone":"1.3.0","assignees":["alice"]},
  {"id":"WordPress/ai#40","type":"Issue","number":40,"title":"Core abilities","repo":"WordPress/ai","state":"OPEN","status":"In progress","milestone":"1.3.0","assignees":["bob"]},
  {"id":"WordPress/ai#514","type":"Issue","number":514,"title":"Comment score","repo":"WordPress/ai","state":"OPEN","status":"Needs review","milestone":"1.3.0","assignees":["carol"]},
  {"id":"Other/repo#999","type":"Issue","number":999,"title":"Collision fixture","repo":"Other/repo","state":"OPEN","status":"To do","milestone":"Future Release","assignees":[]}
]
```

Create `tests/fixtures/prs-pr-coverage.json`:

```json
[
  {"id":"WordPress/ai#200","number":200,"title":"Direct PR","isDraft":false,"routine":false,"issues":[],"issueLinks":[],"author":"alice","updatedAt":"2026-07-17T00:00:00Z"},
  {"id":"WordPress/ai#201","number":201,"title":"Authoritative board link","isDraft":false,"routine":false,"issues":[40],"issueLinks":[{"repo":"WordPress/ai","number":40,"source":"closing"}],"author":"dana","updatedAt":"2026-07-17T00:00:00Z"},
  {"id":"WordPress/ai#202","number":202,"title":"Routine update","isDraft":false,"routine":true,"issues":[],"issueLinks":[],"author":"dependabot","updatedAt":"2026-07-17T00:00:00Z"},
  {"id":"WordPress/ai#203","number":203,"title":"Wrong-repo collision","isDraft":false,"routine":false,"issues":[999],"issueLinks":[{"repo":"WordPress/ai","number":999,"source":"closing"}],"author":"erin","updatedAt":"2026-07-17T00:00:00Z"},
  {"id":"WordPress/ai#204","number":204,"title":"Unexplained work","isDraft":true,"routine":false,"issues":[],"issueLinks":[],"author":"frank","updatedAt":"2026-07-17T00:00:00Z"},
  {"id":"WordPress/ai#205","number":205,"title":"Legacy board link","isDraft":false,"routine":false,"issues":[514],"author":"grace","updatedAt":"2026-07-17T00:00:00Z"}
]
```

Expected counts are direct `1`, linked-board `2`, routine `1`, linked-off-board `1`, unexplained `1`, and open total `6`.

- [x] **Step 2: Write the failing gap test**

Create `tests/wp-ai-roadmap-refresh-gap.sh` that runs both modes and asserts:

```bash
set +e
normal="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" gap "$BOARD" "$PRS")"
normal_status=$?
strict="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" gap --strict "$BOARD" "$PRS")"
strict_status=$?
set -e

[ "$normal_status" -eq 0 ]
[ "$strict_status" -eq 2 ]
jq -e '
  .open_total==6
  and .classification_counts=={
    "direct-board-pr":1,
    "linked-board-issue":2,
    "routine":1,
    "linked-off-board-issue":1,
    "unexplained":1
  }
  and ([.classifications["linked-off-board-issue"][].number] == [203])
  and ([.classifications.unexplained[].number] == [204])
  and ([.classifications["linked-board-issue"][]|select(.number==205)]
    | .[0].issueLinks[0].repo=="WordPress/ai"
      and .[0].issueLinks[0].source=="legacy")
  and (.tracked_open + (.untracked|length) == .open_total)
  and (.routine_count + (.substantive|length) == (.untracked|length))
  and (
    [.classifications[][].number] | sort
    == ([200,201,202,203,204,205] | sort)
  )
  and ((.classification_counts | [.[]] | add) == .open_total)
  and (.validation.ok|not)
  and ((.validation.errors|length)>0)
  and ([.validation.errors[].context.number] | sort == [203,204])
' <<<"$normal" >/dev/null

diff -u <(jq -S . <<<"$normal") <(jq -S . <<<"$strict")
```

This assertion recomputes classification membership, count totals, tracked/untracked totals, routine/substantive totals, legacy conversion, and the errors-empty equivalence instead of trusting reported summaries.

Set the test executable:

```bash
chmod +x tests/wp-ai-roadmap-refresh-gap.sh
```

End the script with:

```bash
printf 'PR coverage fixture tests passed\n'
```

- [x] **Step 3: Run the gap test and verify RED**

Run `./tests/wp-ai-roadmap-refresh-gap.sh`.

Expected: current `gap` rejects `--strict` and joins only local bare issue numbers.

- [x] **Step 4: Replace the gap join with canonical keys**

In `GAP_JQ`:

```jq
def key($repo; $number): $repo + "#" + ($number|tostring);
def legacy_links($pr):
  [$pr.issues[]? | {repo:$repo,number:.,source:"legacy"}];
def links($pr):
  if ($pr.issueLinks // [] | length)>0
  then $pr.issueLinks
  else legacy_links($pr)
  end;
```

Index and classify with this pipeline, using `($pr.repo // $repo)` for historical PR snapshots:

```jq
($board[0]) as $B
| ($prs[0]) as $P
| (reduce ($B[] | select(.type=="Issue")) as $item
    ({}; .[key($item.repo;$item.number)]={
      status:$item.status,
      milestone:$item.milestone,
      assignees:($item.assignees // [])
    })) as $board_issues
| (reduce ($B[] | select(.type=="PullRequest")) as $item
    ({}; .[key($item.repo;$item.number)]=$item)) as $board_prs
| [$P[] as $pr
    | (links($pr) | unique_by([.repo,.number,.source])
        | sort_by(.repo,.number,.source)) as $links
    | [$links[]
        | . as $link
        | ($board_issues[key($link.repo;$link.number)] // null) as $board
        | $link + {
            onBoard:($board!=null),
            status:$board.status,
            milestone:$board.milestone,
            assignees:($board.assignees // [])
          }] as $mapped
    | (($pr.repo // $repo) as $pr_repo
        | $board_prs[key($pr_repo;$pr.number)] != null) as $direct
    | ([$mapped[] | select(.onBoard and .source=="closing")] | length>0)
        as $authoritative_board
    | ([$mapped[] | select(.onBoard)] | length>0) as $any_board
    | (if $direct then "direct-board-pr"
       elif $authoritative_board then "linked-board-issue"
       elif ($pr.routine // false) then "routine"
       elif $any_board then "linked-board-issue"
       elif ($links|length)>0 then "linked-off-board-issue"
       else "unexplained"
       end) as $classification
    | $pr + {
        repo:($pr.repo // $repo),
        issueLinks:$links,
        mappedIssues:$mapped,
        classification:$classification
      }
  ] as $classified
| (reduce $classified[] as $pr
    ({
      "direct-board-pr":[],
      "linked-board-issue":[],
      "routine":[],
      "linked-off-board-issue":[],
      "unexplained":[]
    };
    .[$pr.classification] += [$pr])) as $classes
| {
    repo:$repo,
    open_total:($classified|length),
    classifications:$classes,
    classification_counts:($classes|with_entries(.value=(.value|length))),
    untracked:[$classified[]|select(.classification!="direct-board-pr")],
    substantive:[
      $classified[]
      | select(.classification!="direct-board-pr" and ((.routine // false)|not))
    ],
    routine_count:([
      $classified[]
      | select(.classification!="direct-board-pr" and (.routine // false))
    ]|length),
    tracked_open:([$classified[]|select(.classification=="direct-board-pr")]|length)
  }
```

Add the existing board-card totals to this object. Build `untracked` and `substantive` aliases from the classified items rather than recomputing issue relationships elsewhere.

Build stable `pr-roadmap-coverage-missing` errors for every non-routine linked-off-board or unexplained PR. Then assert the exact classification, total, tracked/untracked, and routine/substantive invariants; add `validation-inconsistent` when a derived invariant fails.

- [x] **Step 5: Parse both gap forms and enforce exit semantics**

Accept:

```text
gap BOARD.json PRS.json
gap --strict BOARD.json PRS.json
```

Missing/unreadable/malformed input exits `1`. Coverage errors exit `0` normally or `2` under strict, after JSON is printed.

- [x] **Step 6: Verify and commit coverage classification**

Run:

```bash
./tests/wp-ai-roadmap-refresh-gap.sh
./wp-ai-roadmap-refresh.sh gap \
  .wp-ai-roadmap-snapshots/proj240-20260717T210540Z.json \
  .wp-ai-roadmap-snapshots/prs-WordPress-ai-20260717T210540Z.json \
  | jq -e '.open_total==35 and (.classification_counts|type=="object")'
bash -n tests/wp-ai-roadmap-refresh-gap.sh
git diff --check
```

Commit:

```bash
git add wp-ai-roadmap-refresh.sh \
  tests/fixtures/board-pr-coverage.json \
  tests/fixtures/prs-pr-coverage.json \
  tests/wp-ai-roadmap-refresh-gap.sh
git commit -m "Classify roadmap PR coverage by repository"
```

### Task 5: Track PR Readiness Changes and Render the Developer Radar

**Files:**
- Modify: `tests/wp-ai-roadmap-refresh-prs.sh`
- Modify: `wp-ai-roadmap-refresh.sh:207-252`
- Modify: `wp-ai-roadmap-refresh.sh:379-391`

**Interfaces:**
- Produces: `prdiff` with `newly_opened`, `no_longer_open`, and `readiness_changed`.
- Produces: repo report ordered as changes, underway work, then uncovered work, with board issue assignees and mapping source.

- [x] **Step 1: Add failing readiness-diff fixtures inline**

In the PR test, create these exact baseline/current arrays:

```bash
BASE="$TMP_DIR/pr-base.json"
CUR="$TMP_DIR/pr-current.json"

jq -n '[
  {
    number:1,title:"Readiness change",isDraft:false,
    reviewDecision:null,mergeStateStatus:"CLEAN",checkState:"PENDING",
    updatedAt:"2026-07-16T00:00:00Z"
  },
  {
    number:2,title:"Activity only",isDraft:false,
    reviewDecision:"APPROVED",mergeStateStatus:"CLEAN",checkState:"SUCCESS",
    updatedAt:"2026-07-16T00:00:00Z"
  },
  {number:4,title:"No longer open",updatedAt:"2026-07-16T00:00:00Z"},
  {number:5,title:"Legacy fields absent",updatedAt:"2026-07-16T00:00:00Z"}
]' >"$BASE"

jq -n '[
  {
    number:1,title:"Readiness change",isDraft:false,
    reviewDecision:"APPROVED",mergeStateStatus:"CLEAN",checkState:"SUCCESS",
    updatedAt:"2026-07-17T00:00:00Z"
  },
  {
    number:2,title:"Activity only",isDraft:false,
    reviewDecision:"APPROVED",mergeStateStatus:"CLEAN",checkState:"SUCCESS",
    updatedAt:"2026-07-17T00:00:00Z"
  },
  {number:3,title:"Newly open",updatedAt:"2026-07-17T00:00:00Z"},
  {
    number:5,title:"Legacy fields now present",isDraft:false,
    reviewDecision:"REVIEW_REQUIRED",mergeStateStatus:"BLOCKED",
    checkState:"PENDING",updatedAt:"2026-07-17T00:00:00Z"
  }
]' >"$CUR"
```

Assert:

```bash
diff_json="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" prdiff "$BASE" "$CUR")"
jq -e '
  [.newly_opened[].number]==[3]
  and [.no_longer_open[].number]==[4]
  and [.readiness_changed[].number]==[1]
  and .readiness_changed[0].changes=={
    reviewDecision:{from:null,to:"APPROVED"},
    checkState:{from:"PENDING",to:"SUCCESS"}
  }
' <<<"$diff_json" >/dev/null
```

- [x] **Step 2: Run the focused PR test and verify RED**

Run `./tests/wp-ai-roadmap-refresh-prs.sh`.

Expected: fail because `readiness_changed` is absent.

- [x] **Step 3: Implement readiness comparison**

Extend `PRDIFF_JQ`. Compare `isDraft`, `reviewDecision`, `mergeStateStatus`, and `checkState` only when both objects have the key. Emit only changed keys:

```jq
def change($b; $c; $key):
  if ($b|has($key)) and ($c|has($key)) and ($b[$key] != $c[$key])
  then {($key):{from:$b[$key],to:$c[$key]}}
  else {}
  end;
```

Merge the four objects with `*`, discard empty `changes`, and sort by PR number.

- [x] **Step 4: Update repo JSON and Markdown rendering**

Render in this order:

1. PR census changes, including readiness changes.
2. “Already underway” groups for direct-board and linked-board PRs.
3. Linked-off-board and unexplained substantive PRs.
4. Routine PR count, collapsed unless nonzero.

For every mapped on-board issue show `repo#number`, mapping `source`, board status, milestone, and assignees. Show PR author, draft/review/merge/check state, and whole-day activity age. Render age only; do not make it a validation failure.

- [x] **Step 5: Verify output and commit**

Run:

```bash
./tests/wp-ai-roadmap-refresh-prs.sh
./tests/wp-ai-roadmap-refresh-gap.sh
./wp-ai-roadmap-refresh.sh --markdown --no-deps | rg \
  'What changed|Already underway|Unexplained|Review|Check'
git diff --check
```

Expected: tests pass and the report contains the developer-radar sections.

Commit:

```bash
git add wp-ai-roadmap-refresh.sh tests/wp-ai-roadmap-refresh-prs.sh
git commit -m "Report PR readiness and roadmap coverage"
```

### Task 6: Integrate Full Strict Validation and Transactional Persistence

**Files:**
- Create: `tests/fixtures/board-graphql-page.json`
- Create: `tests/wp-ai-roadmap-refresh-strict.sh`
- Modify: `tests/helpers/mock-gh.sh`
- Modify: `wp-ai-roadmap-refresh.sh:476-529`
- Modify: `wp-ai-roadmap-refresh.sh:531-650`

**Interfaces:**
- Produces: full JSON `{board,repo,dependencies,validation}`.
- Produces: aggregate validation as the deterministic union of subsystem diagnostics.
- Enforces: exit `2` after a complete strict report; no snapshot or changelog mutation on strict failure.

- [x] **Step 1: Write the failing full-path strict test**

Create `tests/fixtures/board-graphql-page.json`:

```json
{"data":{"organization":{"projectV2":{"items":{"totalCount":2,"pageInfo":{"hasNextPage":false,"endCursor":null},"nodes":[{"fieldValues":{"nodes":[{"name":"In progress","field":{"name":"Status"}}]},"content":{"__typename":"Issue","number":40,"title":"Core abilities","url":"https://github.com/WordPress/ai/issues/40","state":"OPEN","repository":{"nameWithOwner":"WordPress/ai"},"milestone":{"title":"1.3.0"},"assignees":{"nodes":[{"login":"bob"}]},"updatedAt":"2026-07-17T00:00:00Z"}},{"fieldValues":{"nodes":[{"name":"Needs review","field":{"name":"Status"}}]},"content":{"__typename":"Issue","number":514,"title":"Comment score","url":"https://github.com/WordPress/ai/issues/514","state":"OPEN","repository":{"nameWithOwner":"WordPress/ai"},"milestone":{"title":"1.3.0"},"assignees":{"nodes":[{"login":"carol"}]},"updatedAt":"2026-07-17T00:00:00Z"}}]}}}}}
```

Extend `tests/helpers/mock-gh.sh` above the PR GraphQL branch:

```bash
if [ "${1:-}" = api ] && [ "${2:-}" = graphql ] \
  && [[ "$*" == *projectV2* ]]; then
  cat "${WP_AI_TEST_BOARD_PAGES:?}"
  exit 0
fi
```

Create `tests/wp-ai-roadmap-refresh-strict.sh` with this isolated setup:

```bash
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

find "$ROOT_DIR/.wp-ai-roadmap-snapshots" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/real-snapshots.before"
find "$TEST_SNAP_DIR" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/test-snapshots.before"
sha256sum "$TEST_DOC_DIR/wordpress-ai-planned-work.md" \
  >"$TMP_DIR/planned.before"
```

Set the test executable:

```bash
chmod +x tests/wp-ai-roadmap-refresh-strict.sh
```

Run a strict JSON refresh against an isolated snapshot directory with a fixture containing one unexplained PR:

```bash
set +e
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$TEST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
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
  (keys | sort)==["board","dependencies","repo","validation"]
  and (.validation.ok|not)
  and ([.validation.errors[].code] | index("pr-roadmap-coverage-missing") != null)
' "$OUT"
find "$TEST_SNAP_DIR" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/test-snapshots.after"
diff -u "$TMP_DIR/test-snapshots.before" "$TMP_DIR/test-snapshots.after"
sha256sum -c "$TMP_DIR/planned.before"
rg 'persistence skipped' "$ERR"
```

Then run normal mode with the same fixture and assert exit `0` plus four additional snapshot files:

```bash
before_count="$(find "$TEST_SNAP_DIR" -maxdepth 1 -type f | wc -l)"
PATH="$MOCK_BIN:$PATH" \
WP_AI_SNAP_DIR="$TEST_SNAP_DIR" \
WP_AI_DOC_DIR="$TEST_DOC_DIR" \
WP_AI_DEPS_FILE="$TEST_REGISTRY" \
WP_AI_TEST_STATE_DIR="$STATE_DIR" \
WP_AI_TEST_BOARD_PAGES="$ROOT_DIR/tests/fixtures/board-graphql-page.json" \
WP_AI_TEST_PR_PAGES="$ROOT_DIR/tests/fixtures/pr-graphql-pages.jsonl" \
WP_AI_TEST_RELEASES="$RELEASES" \
  "$ROOT_DIR/wp-ai-roadmap-refresh.sh" --json --save \
  >"$TMP_DIR/normal.json" 2>"$TMP_DIR/normal.err"
jq -e . "$TMP_DIR/normal.json" >/dev/null
after_count="$(find "$TEST_SNAP_DIR" -maxdepth 1 -type f | wc -l)"
[ "$after_count" -eq "$((before_count + 4))" ]
```

Run invalid-flag and unreadable-baseline cases and assert operational exit `1`:

```bash
set +e
"$ROOT_DIR/wp-ai-roadmap-refresh.sh" --not-a-real-option >/dev/null 2>&1
invalid_status=$?
"$ROOT_DIR/wp-ai-roadmap-refresh.sh" \
  --baseline "$TMP_DIR/missing-baseline.json" >/dev/null 2>&1
baseline_status=$?
set -e
[ "$invalid_status" -eq 1 ]
[ "$baseline_status" -eq 1 ]
```

At the end, hash the real snapshot directory again and compare it with `real-snapshots.before`:

```bash
find "$ROOT_DIR/.wp-ai-roadmap-snapshots" -maxdepth 1 -type f \
  -exec sha256sum {} + | sort >"$TMP_DIR/real-snapshots.after"
diff -u "$TMP_DIR/real-snapshots.before" "$TMP_DIR/real-snapshots.after"
printf 'strict CLI fixture tests passed\n'
```

- [x] **Step 2: Run the strict test and verify RED**

Run `./tests/wp-ai-roadmap-refresh-strict.sh`.

Expected: fail because the full parser does not recognize `--strict` and persistence is unconditional.

- [x] **Step 3: Add global strict parsing and aggregate validation**

Parse `--strict` in the main option loop without changing other options. Build:

Before the top-level aggregate, set `repo.validation` to the deterministic union of `fetch_pr_census.validation` and `gap.validation`. Extract `fetch_pr_census.items` into the PR snapshot file, but retain its validation object in the repo report. Keep dependency validation inside `dependencies.validation`.

```jq
def diagnostics($object):
  ($object.validation // {errors:[],warnings:[]});
[diagnostics($repo), diagnostics($dependencies)] as $parts
| {
    errors: ([$parts[].errors[]] | unique_by([.code,(.context|tostring)])
      | sort_by(.code,(.context|tostring))),
    warnings: ([$parts[].warnings[]] | unique_by([.code,(.context|tostring)])
      | sort_by(.code,(.context|tostring)))
  }
| .ok=(.errors|length==0)
```

If a fail-soft subsystem is unavailable, add a stable `repo-subsystem-unavailable` or `dependency-subsystem-unavailable` diagnostic to the aggregate.

- [x] **Step 4: Gate all persistence after report emission**

Compute final strict status only after rendering stdout. If `STRICT=1` and aggregate `ok=false`:

```bash
if [ "$STRICT" = 1 ] && [ "$VALIDATION_OK" != true ]; then
  [ "$SAVE" = 0 ] || printf 'persistence skipped: strict validation failed\n' >&2
  [ "$UPDATE_CHANGELOG" = 0 ] || printf 'changelog skipped: strict validation failed\n' >&2
  exit 2
fi
```

Move `append_changelog` and snapshot copies after this gate. Normal mode retains warning-only save behavior, including UNKNOWN placeholders.

- [x] **Step 5: Verify output purity, exit codes, and snapshot isolation**

Run:

```bash
./tests/wp-ai-roadmap-refresh-strict.sh
./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
./tests/wp-ai-roadmap-refresh-prs.sh
./tests/wp-ai-roadmap-refresh-gap.sh
bash -n wp-ai-roadmap-refresh.sh tests/*.sh tests/helpers/mock-gh.sh
git diff --check
```

Expected: all deterministic tests pass; every strict `2` stdout file parses with jq; real snapshot hashes remain unchanged.

- [x] **Step 6: Commit strict integration**

```bash
git add wp-ai-roadmap-refresh.sh tests/helpers/mock-gh.sh \
  tests/wp-ai-roadmap-refresh-strict.sh
git commit -m "Add strict roadmap audit mode"
```

### Task 7: Update the Live Smoke Test and Roadmap Documentation

**Files:**
- Modify: `tests/wp-ai-roadmap-refresh-dependencies.sh`
- Modify: `wordpress-ai-roadmap.md`
- Modify: `wordpress-ai-planned-work.md`
- Modify: `wordpress-ai-open-issues.md` only when authoritative mappings change a dossier
- Modify: `wordpress-ai-cross-repo-dependencies.md`
- Modify: `wordpress-ai-roadmap-refresh-prompt.md`
- Add: new generated snapshots under `.wp-ai-roadmap-snapshots/` without deleting the existing untracked 2026-07-17 files

**Interfaces:**
- Consumes: completed CLI and live read-only GitHub data.
- Produces: exact live dependency smoke validation and current developer-facing Markdown.

- [x] **Step 1: Make the live dependency test require strict success**

Change its fetch line to:

```bash
json="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --strict --json)"
```

Extend the jq assertion:

```jq
and .validation.ok
and (.validation.errors | length == 0)
and ([.items[] | select(.required and .state=="UNKNOWN")] | length == 0)
and all(.items[].aiRefs[]; type=="number")
```

- [x] **Step 2: Run every deterministic and live test**

Run:

```bash
./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
./tests/wp-ai-roadmap-refresh-prs.sh
./tests/wp-ai-roadmap-refresh-gap.sh
./tests/wp-ai-roadmap-refresh-strict.sh
./tests/wp-ai-roadmap-refresh-dependencies.sh
```

Expected: five passing test messages; live dependencies contain the exact 16 IDs with no required UNKNOWN item.

- [x] **Step 3: Run live normal and strict audits without saving**

Run:

```bash
audit_dir="$(mktemp -d)"
trap 'rm -rf "$audit_dir"' EXIT
./wp-ai-roadmap-refresh.sh --json > "$audit_dir/normal.json"
normal_status=$?
set +e
./wp-ai-roadmap-refresh.sh --strict --json > "$audit_dir/strict.json"
strict_status=$?
set -e
jq -e . "$audit_dir/normal.json" >/dev/null
jq -e . "$audit_dir/strict.json" >/dev/null
printf 'normal=%s strict=%s\n' "$normal_status" "$strict_status"
```

Expected: normal exit `0`. Strict exit is `0` if every substantive PR is represented, otherwise `2` with exact coverage errors; either outcome must match `.validation.ok`.

- [x] **Step 4: Save one enriched normal-mode baseline**

Run:

```bash
saved_json="$(mktemp)"
./wp-ai-roadmap-refresh.sh --json --save > "$saved_json"
jq -e . "$saved_json" >/dev/null
rm -f "$saved_json"
```

Expected: one new board, PR, release, and dependency snapshot generation. Do not delete or overwrite the four pre-existing untracked 2026-07-17 snapshots.

- [x] **Step 5: Reconcile the roadmap documents with live output**

Update:

- `wordpress-ai-planned-work.md`: authoritative link source, five-category coverage totals, readiness changes, assignees, and unexplained/off-board risks.
- `wordpress-ai-cross-repo-dependencies.md`: registry path, required/optional semantics, retry behavior, UNKNOWN behavior, and integer-to-`#NNN` rendering.
- `wordpress-ai-roadmap.md`: explain normal versus strict refresh and why strict is a scheduled visibility audit.
- `wordpress-ai-roadmap-refresh-prompt.md`: add registry, deterministic tests, `--strict`, exit codes, and persistence-gate instructions.
- `wordpress-ai-open-issues.md`: change only dossiers whose PR relationships differ after authoritative GraphQL mapping.

Preserve and build on the existing uncommitted 2026-07-17 edits; do not regenerate unrelated narrative sections from scratch.

- [x] **Step 6: Verify documentation and snapshot invariants**

Run:

```bash
bash -n wp-ai-roadmap-refresh.sh tests/*.sh tests/helpers/mock-gh.sh
./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
./tests/wp-ai-roadmap-refresh-prs.sh
./tests/wp-ai-roadmap-refresh-gap.sh
./tests/wp-ai-roadmap-refresh-strict.sh
./tests/wp-ai-roadmap-refresh-dependencies.sh
jq -e '.schemaVersion==1 and (.items|length)==16' wp-ai-roadmap-dependencies.json
git diff --check
git status --short
```

Inspect live counts in the JSON and assert the same values appear in the relevant document summary/table. Confirm every new snapshot parses with jq and PR snapshot records retain `issues` plus `issueLinks`.

- [x] **Step 7: Commit the live test and documentation refresh**

Stage only the live test, five reviewed documents, and intended snapshot generations:

```bash
git add tests/wp-ai-roadmap-refresh-dependencies.sh \
  wordpress-ai-roadmap.md \
  wordpress-ai-planned-work.md \
  wordpress-ai-open-issues.md \
  wordpress-ai-cross-repo-dependencies.md \
  wordpress-ai-roadmap-refresh-prompt.md \
  .wp-ai-roadmap-snapshots/
git diff --cached --check
git diff --cached --stat
git commit -m "Refresh roadmap with PR and dependency coverage"
```

### Task 8: Final Verification and Review Handoff

**Files:**
- Review only: all files changed by Tasks 1-7

**Interfaces:**
- Produces: evidence that implementation matches the design and that the repository remains usable for live WordPress AI tracking.

- [x] **Step 1: Run the complete verification matrix**

```bash
bash -n wp-ai-roadmap-refresh.sh tests/*.sh tests/helpers/mock-gh.sh
./tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
./tests/wp-ai-roadmap-refresh-prs.sh
./tests/wp-ai-roadmap-refresh-gap.sh
./tests/wp-ai-roadmap-refresh-strict.sh
./tests/wp-ai-roadmap-refresh-dependencies.sh
./wp-ai-roadmap-refresh.sh census --strict | jq -e '.validation.ok'
./wp-ai-roadmap-refresh.sh dependencies --strict --json | jq -e '.validation.ok'
git diff --check
git status --short
```

Expected: syntax and all five tests pass; live census/dependencies validate; no unintended uncommitted files remain.

- [x] **Step 2: Audit the implementation against every spec section**

Check:

```bash
rg -n 'WP_AI_DEPS_FILE|closingIssuesReferences|routine|issueLinks|readiness_changed|classification_counts|validation|STRICT|exit 2|persistence skipped' \
  wp-ai-roadmap-refresh.sh tests wp-ai-roadmap-dependencies.json
```

Match each design requirement to code plus at least one deterministic test. Correct any gap with a new failing test before changing implementation.

- [x] **Step 3: Review commit scope and history**

```bash
git log --oneline --decorate -10
git show --stat --oneline HEAD
git status --short
```

Expected: focused commits for registry, resilient dependencies, GraphQL PRs, coverage, readiness, strict integration, and docs; no unrelated changes.

- [x] **Step 4: Request code review**

Invoke `superpowers:requesting-code-review` against the complete diff from `704a06e` through `HEAD`. Resolve any verified blocking finding with a failing regression test and a focused follow-up commit.
