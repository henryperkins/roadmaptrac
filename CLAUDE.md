# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A living-documentation repo that tracks the **WordPress AI Planning & Roadmap board** (GitHub org project `WordPress` #240, which in practice is the dev tracker for the `WordPress/ai` Showcase Plugin). There is no application code. It is:

- one bash data engine — `wp-ai-roadmap-refresh.sh`
- two versioned JSON registries — `wp-ai-roadmap-repositories.json` (extra full-census repos) and `wp-ai-roadmap-dependencies.json` (the dependency watchlist)
- four hand-curated Markdown docs (plus `wordpress-ai-roadmap-refresh-prompt.md`, the canonical refresh prompt)
- git-tracked JSON baselines in `.wp-ai-roadmap-snapshots/`
- an offline test suite in `tests/` (fixtures + a mock `gh`), and design/plan docs under `docs/superpowers/`

The recurring task here is the **refresh cycle** — its canonical prompt (including the final verification checklist) lives in `wordpress-ai-roadmap-refresh-prompt.md`. Script edits are in scope only when the script has drift or a bug; substantive engine changes in this repo go design → plan → implement (see `docs/superpowers/specs/` and `docs/superpowers/plans/`).

## Commands

Requires `gh` (authenticated; the board pull needs the `read:project` scope — grant with `gh auth refresh -h github.com -s read:project`; fine-grained PATs cannot read the org project even though it's public) and `jq`.

```bash
./wp-ai-roadmap-refresh.sh                  # live refresh: board diff vs latest snapshot + per-repo PR/release censuses + dependency watchlist (read-only)
./wp-ai-roadmap-refresh.sh --save           # ...and persist new snapshots as the next baseline (commit them with the doc updates)
./wp-ai-roadmap-refresh.sh --json           # raw report as JSON ({board, repo, repositories, dependencies, validation})
./wp-ai-roadmap-refresh.sh --strict         # read-only audit: exit 2 after emitting the report if any validation error exists
./wp-ai-roadmap-refresh.sh --markdown       # report as Markdown
./wp-ai-roadmap-refresh.sh --baseline F     # diff against a specific snapshot instead of the latest
./wp-ai-roadmap-refresh.sh fetch            # normalized full-board snapshot to stdout (use for recomputing doc aggregates with jq)
./wp-ai-roadmap-refresh.sh census           # primary repo census plus every registry repository
./wp-ai-roadmap-refresh.sh census --strict  # exit 2 if any tracked PR fetch is incomplete or malformed
./wp-ai-roadmap-refresh.sh dependencies     # dependency watchlist only (--json, --strict available)
./wp-ai-roadmap-refresh.sh diff A.json B.json   # offline board diff (also: gap, prdiff, reldiff) — for testing without network

bash -n wp-ai-roadmap-refresh.sh            # syntax check after any script edit
```

Tests — the first five are offline (they stub `gh` via `tests/helpers/mock-gh.sh`); the last is live:

```bash
tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh
tests/wp-ai-roadmap-refresh-prs.sh
tests/wp-ai-roadmap-refresh-gap.sh
tests/wp-ai-roadmap-refresh-strict.sh
tests/wp-ai-roadmap-refresh-repositories.sh
tests/wp-ai-roadmap-refresh-dependencies.sh   # live smoke — needs gh auth + network
```

`--no-repo` / `--no-deps` skip the censuses/watchlist. Env overrides: `WP_AI_ORG`, `WP_AI_PROJECT`, `WP_AI_REPO`, `WP_AI_REPOS_FILE`, `WP_AI_SNAP_DIR`, `WP_AI_DOC_DIR`, `WP_AI_DEPS_SLUG`, `WP_AI_DEPS_FILE`.

## Architecture

**Data flow (all inside `wp-ai-roadmap-refresh.sh`, logic written as jq programs in shell variables):**

1. **Board**: paginated GraphQL pull of project #240 → normalized to a sorted array keyed by stable id (`repo#number`) → diffed against the latest baseline (added / newly Done / newly merged / status / milestone / state moves / removed).
2. **Repository censuses**: open PRs + releases for the primary repo (`WP_AI_REPO`, default `WordPress/ai`) **and** every repo listed in `wp-ai-roadmap-repositories.json` (currently `WordPress/php-ai-client`, `WordPress/mcp-adapter`). Produces the board↔repo gap plus PR/release diffs vs sibling snapshots. Fail-soft: census failure degrades to a board-only report.
   - Open `WordPress/ai` PRs are bucketed into **five coverage classifications**: `direct-board-pr`, `linked-board-issue`, `routine`, `linked-off-board-issue`, `unexplained`.
   - PR→issue links come from GitHub `closingIssuesReferences` (source `closing`) first; title/body/branch parsing and legacy bare numbers are lower-precedence and labeled with their source. **Only `closing` links are authoritative** when correcting dossiers.
   - Project #240 coverage requirements apply **only** to the primary repo — never to php-ai-client or mcp-adapter.
3. **Dependency watchlist**: membership lives in **`wp-ai-roadmap-dependencies.json`**, not in shell code (`schemaVersion` 1; each item has `id`, `theme`, `aiRefs`, `note`, `required`). Adding/removing a tracked Gutenberg/abilities-api dependency is a reviewable JSON data change. The registry is schema-validated every run; items fetch live via `gh api`, and a 404'd pin is skipped with a warning, not fatal.

**Validation & exit codes:** normal runs are warning-only — exit 0, with problems reported under `.validation` and on stderr. `--strict` emits the complete report and *then* exits 2 if any validation error exists (exit 1 means an operational failure prevented the report). A strict failure suppresses `--save` and `--update-changelog` ("persistence skipped"); persist snapshots with a normal-mode `--save` run.

**Snapshots** (`.wp-ai-roadmap-snapshots/`, git-tracked): UTC-stamped filenames; the lexicographically-latest per prefix is the baseline. `--save` writes **8** files at present — `proj240-*`, then `prs-<slug>-*` + `releases-<slug>-*` for each of the three tracked repos, then `wordpress-ai-cross-repo-dependencies-*`. Baselines are per-prefix and independent. An invalid dependency registry skips the deps snapshot rather than wiping the watchlist baseline.

**The four docs are hand-curated views, not generated output.** The script reports diffs; a human/Claude folds them in. Division of labor:

- `wordpress-ai-roadmap.md` — strategy, board composition (§1), release cadence (§2), open-issue tracker tables (§9), changelog (§11).
- `wordpress-ai-open-issues.md` — deep per-issue dossiers grouped by board status; dossiers move between sections as statuses change; newly-Done issues move to a "Recently board-Done" set.
- `wordpress-ai-planned-work.md` — release-ordered delivery plan for all non-Done board cards incl. PRs, commitment tiers ①–④, and the Board-vs-repo untracked-PR table (regenerated from the report's copy-paste block, then hand-adjusted).
- `wordpress-ai-cross-repo-dependencies.md` — "Cross-Repo Dependencies & Repository Radar": the watchlist table mirroring `dependencies` output, **plus** the full-repository PR/release census table for php-ai-client and mcp-adapter.

**Cross-doc invariants** — the same numbers appear in several docs and must stay consistent after a refresh: total items = PRs + issues; §2 milestone table sums to the total; non-Done cards = open issues + PR cards, where PR cards = open board-tracked PRs + the stale merged PR #484 (a known board-hygiene straggler still Needs-review under 0.9.0); the Repository Radar's open-PR counts match the census; and the roadmap header, planned-work header, and open-issues header all state the snapshot date and open counts.

## Refresh-cycle conventions

- **Date docs by the local working day**, not the snapshot's UTC timestamp — an evening refresh stamps snapshots with the next UTC day (`date -u`).
- **Changelog rows are hand-written** per doc per window (rich, specific). Do not use `--update-changelog` — its terse auto-row format was abandoned after one use (2026-06-16).
- **Zero-change run** (0 board / census / dependency changes): make no doc edits, add no changelog rows, and skip `--save` (an identical baseline is git noise). Still verify doc aggregates against fresh `fetch` output before declaring the docs current.
- Commit style: `Refresh WP AI roadmap docs vs YYYY-MM-DD (<highlights>)`, including the new snapshot files.
- Don't trust doc counts from memory or prior text — recompute from live data every cycle (the prompt file's checklist).

## Windows / Git Bash gotchas

- **Native `jq.exe` emits CRLF.** `jq -r` output ends `\r\n`, so `while IFS= read -r x; do ... done < <(jq -r ...)` leaves a trailing `\r` on `$x` (`read` strips `\n`, not `\r`). This currently breaks the multi-repo census on Windows: `fetch_pr_census()` derives `owner`/`name` from the CR-tainted repo string, so `gh api graphql -F name=ai$'\r'` and `gh release list --repo WordPress/ai$'\r'` are wrong, and the `--save` loop copies `prs-WordPress-ai$'\r'-current.json`. Symptom: `tests/wp-ai-roadmap-refresh-{prs,strict,repositories}.sh` fail here while passing on Linux, with paths like `WordPress-ai'$'\r''.jsonl`. Strip CRs from jq output before use (`x="${x%$'\r'}"`) when touching these loops.
- Native `jq.exe` cannot open process-substitution paths (`/proc/<pid>/fd/...`), so `<(...)` into `--slurpfile` fails — pass JSON via stdin or real temp files.
- Never pass large JSON on argv (`--argjson`): Git Bash has a ~32 KB arg-length limit. The script already pipes large GitHub payloads via stdin (`printf ... | jq`) for this reason; preserve that pattern when editing.
- `core.autocrlf=true` is set system-wide by the Git for Windows installer. `.gitattributes` pins `eol=lf` so checkouts stay LF and match the Linux clones; don't remove it.
