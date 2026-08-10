# Issue Census Implementation Plan

> **For agentic workers:** Steps use checkbox (`- [ ]`) syntax for tracking. Implement task-by-task; run `bash -n` plus the offline suite after every task.

**Goal:** Give `WordPress/ai`, `php-ai-client`, `mcp-adapter`, and `abilities-api` full PR + issue + release coverage from one command, and make "every open primary-repository issue is on Project #240" an enforced strict-audit invariant.

**Architecture:** Add an issue census as a third peer of the existing PR and release censuses inside `wp-ai-roadmap-refresh.sh`, reusing their shapes: paginated GraphQL → normalizing jq → `{items, validation}` → number-keyed diff → independent snapshot prefix. Add `WordPress/abilities-api` to the repositories registry as a pure data change.

**Tech Stack:** Bash with `set -euo pipefail`, jq, GitHub CLI GraphQL reads, JSON fixtures, Markdown

## Global Constraints

- Read-only: no command may add, edit, or remove GitHub issues, PRs, releases, milestones, or Project #240 cards.
- Preserve every existing subcommand and flag; add only `issuediff`.
- Project #240 coverage rules apply to `WP_AI_REPO` alone. No upstream repository may emit `issue-roadmap-coverage-missing`.
- The issue census is independently fail-soft: its failure must not blank `open_prs` or `releases`.
- An unavailable issue census skips its own snapshot and leaves the prior baseline intact.
- Census open issues only. A closed issue leaves as a `no_longer_open` disappearance.
- Compare `labels` and `assignees` as sets; reordering is not a change. Compare a field only when present on both sides.
- Exit `0` completed, `1` operational failure, `2` complete report with strict violations. JSON stdout stays parseable at exit `2`.
- **Windows/Git Bash:** feed every `read` loop from `jq_lines`, never bare `jq`; never pass large JSON on argv (`--argjson`) — pipe via stdin or real temp files; never hand `<(...)` to `--slurpfile`.
- Every fixture reaching the main path exports a temporary `WP_AI_SNAP_DIR` and asserts the real snapshot directory is unchanged.

---

## File Structure

- Modify `wp-ai-roadmap-refresh.sh`: issue GraphQL query, normalization, diff, coverage join, fetch with independent fail-soft, entry/report wiring, `issuediff` subcommand, renderers, `--save`, usage header.
- Modify `wp-ai-roadmap-repositories.json`: add `WordPress/abilities-api`.
- Create `tests/fixtures/issue-graphql-pages.jsonl`: two paginated issue GraphQL responses.
- Create `tests/fixtures/board-issue-coverage.json`: board cards with a carded issue, an uncarded issue, and a cross-repository number collision.
- Create `tests/wp-ai-roadmap-refresh-issues.sh`: offline normalization, diff, coverage, strict-exit, and fail-soft tests.
- Modify `tests/helpers/mock-gh.sh`: serve issue GraphQL fixtures and support an induced issue-fetch failure.
- Modify `tests/wp-ai-roadmap-refresh-repositories.sh`: four-repository membership.
- Modify the four roadmap Markdown files, `CLAUDE.md`, and `wordpress-ai-roadmap-refresh-prompt.md` only after code and tests pass.

---

### Task 1: Issue GraphQL Query and Normalization

**Files:** Modify `wp-ai-roadmap-refresh.sh` (beside `PR_GQL_QUERY` / `PR_CENSUS_JQ`)

**Interfaces:**
- Produces `ISSUE_GQL_QUERY`: `repository.issues(first: 100, after: $endCursor, states: OPEN)` with `totalCount`, `pageInfo`, and per-node number, title, url, state, createdAt, updatedAt, `milestone{title}`, `labels(first:20){totalCount,nodes{name}}`, `assignees(first:10){totalCount,nodes{login}}`, `author{login,__typename}`, `comments{totalCount}`.
- Produces `ISSUE_CENSUS_JQ`: slurped pages + `--arg repo` → `{items, validation}`.

- [ ] **Step 1: Add the query and normalizer**

Normalized record fields, sorted by number: `id` (`repo#number`), `repo`, `number`, `title`, `url`, `state`, `milestone` (title or null), `labels` (name array), `assignees` (login array), `author`, `isBot` (`author.__typename == "Bot"`), `comments`, `createdAt`, `updatedAt`.

Diagnostics, sorted by code then context:
- `issue-duplicate` — number on more than one page (error)
- `issue-pagination-incomplete` — last page still `hasNextPage` (error)
- `issue-total-mismatch` — `totalCount` ≠ unique normalized nodes (error)
- `issue-connection-truncated` — `labels`/`assignees` `totalCount` exceeds returned nodes (**warning**)

- [ ] **Step 2: `bash -n` and confirm the seven existing suites still pass**

---

### Task 2: Issue Diff

**Files:** Modify `wp-ai-roadmap-refresh.sh` (beside `PRDIFF_JQ`)

**Interfaces:** Produces `ISSUEDIFF_JQ` consuming `$base[0]` / `$cur[0]` arrays → `{newly_opened, no_longer_open, changed}`.

- [ ] **Step 1: Implement the diff**

`newly_opened`: `{number,title,milestone}` for numbers absent from baseline.
`no_longer_open`: `{number,title}` for numbers absent from current.
`changed`: `{number, title, changes:{FIELD:{from,to}}}` for `milestone`, `title`, `labels`, `assignees`.

Set comparison for `labels`/`assignees` — compare `(sort)` on both sides so reordering is silent, but report the original arrays in `from`/`to`. Guard every field with `has($key)` on both records, exactly as `change()` does in `PRDIFF_JQ`.

- [ ] **Step 2: Add the `issuediff A.json B.json` subcommand** beside `prdiff`, and add it to the usage header comment block

---

### Task 3: Issue Fetch with Independent Fail-Soft

**Files:** Modify `wp-ai-roadmap-refresh.sh:889-967` region

**Interfaces:**
- Produces `issue_census_query REPO OWNER NAME` → raw paginated pages (peer of `pr_census_query`).
- Produces `fetch_issue_census REPO` → `{items, validation}`; returns `1` on fetch failure.
- Modifies `fetch_repository_census_entry` to add `open_issues` and `issues_available`.

- [ ] **Step 1: Add the fetch functions**

- [ ] **Step 2: Extend the entry builder**

The PR + release all-or-nothing contract is unchanged. Issues are attempted separately:

- success → `open_issues: <items>`, `issues_available: true`, issue validation merged into the entry's validation with `repo` added to each context;
- failure → `open_issues: []`, `issues_available: false`, and exactly one `issue-census-unavailable` error;
- entry already `available: false` → `issues_available: false` and no extra issue diagnostic (the `repository-census-unavailable` error already covers it — do not double-report).

Pass items via temp file + `--slurpfile`, never argv.

---

### Task 4: Snapshots and Repository Reports

**Files:** Modify `wp-ai-roadmap-refresh.sh` `build_repository_reports` and the `--save` block near line 1497

- [ ] **Step 1: Diff issues per repository in `build_repository_reports`**

Write `issues-$slug-current.json` into the temp dir; baseline via `latest_snap "issues-$slug"`; emit `issue_diff` (null when no baseline). Only when `issues_available` is true.

- [ ] **Step 2: Persist `issues-<slug>-<TS>.json` in `--save`**

Inside the existing tracked-repository loop, guarded on `issues_available`, so an unavailable census keeps its prior baseline. Report it on the existing stderr status line. Snapshot count becomes 14.

---

### Task 5: Board Issue Coverage (Primary Repository Only)

**Files:** Modify `wp-ai-roadmap-refresh.sh` (beside `GAP_JQ`), and `build_repo_json`

**Interfaces:** Produces `ISSUE_GAP_JQ` consuming `$board[0]`, `$issues[0]`, `--arg repo` → `{repo, open_total, carded, uncarded, validation}`; `board_issue_gap BOARD_FILE ISSUES_FILE`.

- [ ] **Step 1: Implement the join**

Index board issue cards by `key(.repo; .number)`. An open censused issue with no matching card joins `uncarded` and emits `issue-roadmap-coverage-missing` (**error**) with context `{id, number}`. Invariant: `carded + (uncarded|length) == open_total`.

The join runs against the primary repository's issue census only. It is never invoked for a registry repository — enforce this by call site, not by a filter inside the jq, so an upstream repository cannot reach the rule at all.

- [ ] **Step 2: Fold `issue_gap` into `build_repo_json`**

Union its validation into `repo.validation` alongside the census and PR-gap validations, preserving `unique_by([.code,(.context|tostring)])` and the code/context sort. Skip cleanly when the primary issue census is unavailable.

---

### Task 6: Rendering

**Files:** Modify `wp-ai-roadmap-refresh.sh` `RENDER_REPOSITORIES_JQ` and `RENDER_REPO_JQ`

- [ ] **Step 1: Repository table gains Open issues + issue-change columns**

`unavailable` when `issues_available` is false; `baseline missing` when `issue_diff` is null; otherwise `+N opened · -N no longer open · N changed`.

- [ ] **Step 2: Issue-movement section**

Per repository, list newly opened (number + title), no longer open, and changed with the changed field names. Omit repositories with no issue movement.

- [ ] **Step 3: Primary-repository issue coverage line** in the gap section — `open_total`, `carded`, and each uncarded issue.

---

### Task 7: Registry Data Change

**Files:** Modify `wp-ai-roadmap-repositories.json`, `tests/wp-ai-roadmap-refresh-repositories.sh`

- [ ] **Step 1: Add `WordPress/abilities-api`** after `mcp-adapter`
- [ ] **Step 2: Update the membership assertion** in the repositories test to the four-repository list

---

### Task 8: Tests

**Files:** Create `tests/fixtures/issue-graphql-pages.jsonl`, `tests/fixtures/board-issue-coverage.json`, `tests/wp-ai-roadmap-refresh-issues.sh`; modify `tests/helpers/mock-gh.sh`

- [ ] **Step 1: Mock support** — serve `WP_AI_TEST_ISSUE_PAGES` for GraphQL bodies containing `issues(`, with `WP_AI_TEST_ISSUE_FAIL=1` inducing a failure. Match on the issue query specifically; the existing PR branch matches `pullRequests`, so keep the two selectors disjoint.

- [ ] **Step 2: Census + diff tests** — pagination, duplicate, total mismatch, truncation warning, and every diff case from the spec including label reordering and `updatedAt`-only bumps producing no change.

- [ ] **Step 3: Coverage tests** — carded/uncarded classification, cross-repository number collision not counted as coverage, strict exit `2` on an uncarded primary issue, exit `0` when only an upstream repository has uncarded issues.

- [ ] **Step 4: Fail-soft test** — induced issue failure leaves `open_prs` populated, sets `issues_available: false`, emits exactly one `issue-census-unavailable`, and skips the issue snapshot while the prior baseline survives.

- [ ] **Step 5: Full offline suite green (8 files)**

---

### Task 9: Documentation and Live Verification

**Files:** Modify the four roadmap Markdown files, `CLAUDE.md`, `wordpress-ai-roadmap-refresh-prompt.md`

- [ ] **Step 1: Live run** — `./wp-ai-roadmap-refresh.sh --json` and record real counts for all four repositories
- [ ] **Step 2: Radar tables** — `abilities-api` row + open-issue columns in the cross-repo doc, roadmap §1, and planned-work; add the watchlist/census overlap caveat
- [ ] **Step 3: `CLAUDE.md`** — snapshot count 8 → 14, `issuediff`, the new test file, four tracked repositories
- [ ] **Step 4: Refresh prompt** — verification checklist gains per-repository open-issue totals and the issue coverage check
- [ ] **Step 5: Verify** — `bash -n`, offline suite 8/8, live dependency smoke test, strict audit, then `--save` and commit
