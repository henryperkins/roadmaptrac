# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A living-documentation repo that tracks the **WordPress AI Roadmap board** (GitHub org project `WordPress` #240, which in practice is the dev tracker for the `WordPress/ai` Showcase Plugin). There is no application code. It is:

- one bash data engine — `wp-ai-roadmap-refresh.sh`
- two versioned JSON registries — `wp-ai-roadmap-repositories.json` (extra full-census repos: php-ai-client, mcp-adapter, abilities-api) and `wp-ai-roadmap-dependencies.json` (the dependency watchlist)
- four hand-curated Markdown docs (plus `wordpress-ai-roadmap-refresh-prompt.md`, the canonical refresh prompt)
- git-tracked JSON baselines in `.wp-ai-roadmap-snapshots/`
- an offline test suite in `tests/` (fixtures + a mock `gh`), and design/plan docs under `docs/superpowers/`

The recurring task here is the **refresh cycle** — its canonical prompt (including the final verification checklist) lives in `wordpress-ai-roadmap-refresh-prompt.md`. Script edits are in scope only when the script has drift or a bug; substantive engine changes in this repo go design → plan → implement (see `docs/superpowers/specs/` and `docs/superpowers/plans/`).

## Commands

Requires `gh` (authenticated; the board pull needs the `read:project` scope — grant with `gh auth refresh -h github.com -s read:project`; fine-grained PATs cannot read the org project even though it's public) and `jq`.

```bash
./wp-ai-roadmap-refresh.sh                  # live refresh: board diff vs latest snapshot + per-repo PR/issue/release censuses + dependency watchlist (read-only)
./wp-ai-roadmap-refresh.sh --save           # ...and persist new snapshots as the next baseline (commit them with the doc updates)
./wp-ai-roadmap-refresh.sh --json           # raw report as JSON ({board, repo, repositories, dependencies, validation})
./wp-ai-roadmap-refresh.sh --strict         # read-only audit: exit 2 after emitting the report if any validation error exists
./wp-ai-roadmap-refresh.sh --markdown       # report as Markdown
./wp-ai-roadmap-refresh.sh --baseline F     # diff against a specific snapshot instead of the latest
./wp-ai-roadmap-refresh.sh fetch            # normalized full-board snapshot to stdout (use for recomputing doc aggregates with jq)
./wp-ai-roadmap-refresh.sh census           # primary repo census (PRs + issues + releases) plus every registry repository
./wp-ai-roadmap-refresh.sh census --strict  # exit 2 if any tracked PR fetch is incomplete or malformed
./wp-ai-roadmap-refresh.sh dependencies     # dependency watchlist only (--json, --strict available)
./wp-ai-roadmap-refresh.sh diff A.json B.json   # offline board diff (also: gap, prdiff, reldiff, issuediff) — for testing without network

bash -n wp-ai-roadmap-refresh.sh            # syntax check after any script edit
```

Tests — the first eight are offline (they stub `gh` via `tests/helpers/mock-gh.sh`); the last is live:

```bash
tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
tests/wp-ai-roadmap-refresh-prs.sh
tests/wp-ai-roadmap-refresh-gap.sh
tests/wp-ai-roadmap-refresh-strict.sh
tests/wp-ai-roadmap-refresh-repositories.sh
tests/wp-ai-roadmap-refresh-crlf.sh           # shims jq to emit CRLF; reproduces the Windows bug on any platform
tests/wp-ai-roadmap-refresh-mergestate.sh     # cold-query mergeStateStatus UNKNOWN: retry + diff suppression
tests/wp-ai-roadmap-refresh-issues.sh         # issue census, diff contract, board issue coverage, fail-soft
tests/wp-ai-roadmap-refresh-dependencies.sh   # live smoke — needs gh auth + network
```

`--no-repo` / `--no-deps` skip the censuses/watchlist. Env overrides: `WP_AI_ORG`, `WP_AI_PROJECT`, `WP_AI_REPO`, `WP_AI_REPOS_FILE`, `WP_AI_SNAP_DIR`, `WP_AI_DOC_DIR`, `WP_AI_DEPS_SLUG`, `WP_AI_DEPS_FILE`.

## Architecture

**Data flow (all inside `wp-ai-roadmap-refresh.sh`, logic written as jq programs in shell variables):**

1. **Board**: paginated GraphQL pull of project #240 → normalized to a sorted array keyed by stable id (`repo#number`) → diffed against the latest baseline (added / newly Done / newly merged / status / milestone / state moves / removed).
2. **Repository censuses**: open PRs + **open issues** + releases for the primary repo (`WP_AI_REPO`, default `WordPress/ai`) **and** every repo listed in `wp-ai-roadmap-repositories.json` (currently `WordPress/php-ai-client`, `WordPress/mcp-adapter`, `WordPress/abilities-api`). Produces the board↔repo PR gap, the board↔repo **issue** gap, and PR/issue/release diffs vs sibling snapshots. Fail-soft: census failure degrades to a board-only report.
   - Open `WordPress/ai` PRs are bucketed into **five coverage classifications**: `direct-board-pr`, `linked-board-issue`, `routine`, `linked-off-board-issue`, `unexplained`.
   - PR→issue links come from GitHub `closingIssuesReferences` (source `closing`) first; title/body/branch parsing and legacy bare numbers are lower-precedence and labeled with their source. **Only `closing` links are authoritative** when correcting dossiers.
   - Project #240 coverage requirements apply **only** to the primary repo — never to php-ai-client, mcp-adapter, or abilities-api.
   - **Issue coverage mirrors PR coverage, primary repo only.** Every open `WordPress/ai` issue must have a Project #240 card; an uncarded one is an `issue-roadmap-coverage-missing` **error** that fails `--strict` (currently 50/50 carded). The rule is enforced at the call site (`board_issue_gap` is only ever invoked for `$REPO`), not by a filter inside the jq, so an upstream repository cannot reach it. Upstream issues are census-level only — records, counts, and diffs; **no dossiers**, which stay exclusive to `WordPress/ai` board issues.
   - **The issue census is independently fail-soft.** It is deliberately *not* part of the all-or-nothing PR+release contract: a failed issue fetch sets `issues_available: false` and emits one `issue-census-unavailable` error while `open_prs`/`releases` survive, and it **skips its snapshot** so a good issue baseline is never overwritten with `[]` (which would report every issue closed next run). Regression-tested by `tests/wp-ai-roadmap-refresh-issues.sh`.
   - **`mergeStateStatus: "UNKNOWN"` is "not computed yet", not a state.** GitHub computes PR mergeability lazily and asking is what schedules the job, so a cold census can answer UNKNOWN for PRs nothing has touched. `fetch_pr_census()` re-asks once (`WP_AI_MERGESTATE_RETRY_DELAY`, default 2s) and keeps whichever answer knows more; a still-cold PR gets a `pr-mergestate-unknown` **warning** (never an error — it is not a coverage failure), and `PRDIFF_JQ` ignores transitions into or out of UNKNOWN. Without both halves one cold run reports every open PR as newly unreadable *and* saves that into the baseline, so the next window reports them all again in reverse. Regression-tested by `tests/wp-ai-roadmap-refresh-mergestate.sh`.
3. **Dependency watchlist**: membership lives in **`wp-ai-roadmap-dependencies.json`**, not in shell code (`schemaVersion` 1; each item has `id`, `theme`, `aiRefs`, `note`, `required`). Adding/removing a tracked Gutenberg/abilities-api dependency is a reviewable JSON data change. The registry is schema-validated every run; items fetch live via `gh api`, and a 404'd pin is skipped with a warning, not fatal.

**Validation & exit codes:** normal runs are warning-only — exit 0, with problems reported under `.validation` and on stderr. `--strict` emits the complete report and *then* exits 2 if any validation error exists (exit 1 means an operational failure prevented the report). A strict failure suppresses `--save` and `--update-changelog` ("persistence skipped"); persist snapshots with a normal-mode `--save` run.

**Snapshots** (`.wp-ai-roadmap-snapshots/`, git-tracked): UTC-stamped filenames; the lexicographically-latest per prefix is the baseline. `--save` writes **14** files at present — `proj240-*`, then `prs-<slug>-*` + `issues-<slug>-*` + `releases-<slug>-*` for each of the four tracked repos, then `wordpress-ai-cross-repo-dependencies-*`. Baselines are per-prefix and independent. An invalid dependency registry skips the deps snapshot rather than wiping the watchlist baseline.

**The four docs are hand-curated views, not generated output.** The script reports diffs; a human/Claude folds them in. Division of labor:

- `wordpress-ai-roadmap.md` — strategy, board composition (§1), release cadence (§2), open-issue tracker tables (§9), changelog (§11).
- `wordpress-ai-open-issues.md` — deep per-issue dossiers grouped by board status; dossiers move between sections as statuses change; newly-Done issues move to a "Recently board-Done" set.
- `wordpress-ai-planned-work.md` — release-ordered delivery plan for all non-Done board cards incl. PRs, commitment tiers ①–④, and the Board-vs-repo untracked-PR table (regenerated from the report's copy-paste block, then hand-adjusted).
- `wordpress-ai-cross-repo-dependencies.md` — "Cross-Repo Dependencies & Repository Radar": the watchlist table mirroring `dependencies` output, **plus** the full-repository PR/issue/release census table for all four tracked repos. **Watchlist and census overlap on abilities-api by design — never sum them.** Also note `WordPress/abilities-api` is **pending archival** (its API moved into Core/Gutenberg; issue #160 has unanimous agreement since 2026-01-29, unactioned): treat its counts as archaeology, not backlog.

**Cross-doc invariants** — the same numbers appear in several docs and must stay consistent after a refresh: total items = PRs + issues; §2 milestone table sums to the total; non-Done cards = open issues + PR cards, where PR cards = open board-tracked PRs + the stale merged PR #484 (a known board-hygiene straggler still Needs-review under 0.9.0); the Repository Radar's open-PR counts match the census; and the roadmap header, planned-work header, and open-issues header all state the snapshot date and open counts.

## Refresh-cycle conventions

- **Date docs by the local working day**, not the snapshot's UTC timestamp — an evening refresh stamps snapshots with the next UTC day (`date -u`).
- **Changelog rows are hand-written** per doc per window (rich, specific). Do not use `--update-changelog` — its terse auto-row format was abandoned after one use (2026-06-16).
- **Zero-change run** (0 board / census / dependency changes): make no doc edits, add no changelog rows, and skip `--save` (an identical baseline is git noise). Still verify doc aggregates against fresh `fetch` output before declaring the docs current.
- Commit style: `Refresh WP AI roadmap docs vs YYYY-MM-DD (<highlights>)`, including the new snapshot files.
- Don't trust doc counts from memory or prior text — recompute from live data every cycle (the prompt file's checklist).

## Windows / Git Bash gotchas

- **Native `jq.exe` emits CRLF — feed `read` loops from `jq_lines`, never bare `jq`.** jq's Windows stdout is text-mode, so `while IFS= read -r x; do ... done < <(jq -r ...)` leaves a trailing `\r` on `$x` (`read` strips `\n`, not `\r`). That broke the multi-repo census: `fetch_pr_census()` derives `owner`/`name` from the repo string, so it asked GitHub for `-F name=ai$'\r'`, and `--save` copied `prs-WordPress-ai$'\r'-current.json`. `jq_lines()` (a `jq … | tr -d '\r'` wrapper) is the fix; all four read loops use it. Note the asymmetry that made this look intermittent: single-line `$(jq …)` strips the CR for you, multi-line `$(jq …)` keeps the *internal* CRs, and a here-string of a capture keeps a CR on every line except the last. CRs inside JSON are harmless (legal whitespace, and jq escapes real ones as `\r`) — only raw values used as filenames or argv break. Regression-tested cross-platform by `tests/wp-ai-roadmap-refresh-crlf.sh`, which shims jq to emit CRLF.
- Native `jq.exe` cannot open process-substitution paths (`/proc/<pid>/fd/...`), so `<(...)` into `--slurpfile` fails — pass JSON via stdin or real temp files.
- Never pass large JSON on argv (`--argjson`): Git Bash has a ~32 KB arg-length limit. The script already pipes large GitHub payloads via stdin (`printf ... | jq`) for this reason; preserve that pattern when editing.
- `core.autocrlf=true` is set system-wide by the Git for Windows installer. `.gitattributes` pins `eol=lf` so checkouts stay LF and match the Linux clones; don't remove it.
