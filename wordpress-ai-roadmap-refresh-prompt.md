# WordPress AI Roadmap Refresh Prompt

```text
In the roadmaptrac repo (this checkout), review wp-ai-roadmap-refresh.sh and refresh the WordPress AI roadmap docs from live GitHub data.

Update:
- wordpress-ai-roadmap.md
- wordpress-ai-planned-work.md
- wordpress-ai-open-issues.md
- wordpress-ai-cross-repo-dependencies.md
- wp-ai-roadmap-refresh.sh, only if the refresh script has drift or a bug
- wp-ai-roadmap-repositories.json, only when full-repository census membership changes (this registry is the source of truth for additional repositories; do not hard-code additions/removals in shell)
- wp-ai-roadmap-dependencies.json, only when dependency watchlist membership changes (this JSON registry is the watchlist source of truth; do not edit shell code to add/remove a dependency)

Re-pull GitHub Project #240; the full PR/issue/release censuses for WordPress/ai, WordPress/php-ai-client, WordPress/mcp-adapter, and WordPress/abilities-api; and the Gutenberg / abilities-api cross-repo dependency watchlist. Upstream issues are census-level only (counts, states, diffs) — dossiers stay exclusive to WordPress/ai board issues. Do not reuse old counts. Reconcile the board against WordPress/ai open PRs using the five coverage classifications (direct-board-pr, linked-board-issue, routine, linked-off-board-issue, unexplained), update counts/status/milestone groupings, move issue dossiers between status sections as needed, refresh the repository radar and dependency watchlist, and add changelog entries. Do not apply Project #240 coverage requirements to php-ai-client, mcp-adapter, or abilities-api.

Note that wp-ai-roadmap-repositories.json and wp-ai-roadmap-dependencies.json both cover WordPress/abilities-api, deliberately and with different jobs — never sum the watchlist and the census. Also note abilities-api is pending archival (its API moved into Core and Gutenberg; issue #160 has unanimous maintainer agreement since 2026-01-29, still unactioned), so read its counts as archaeology rather than as a live backlog.

PR-to-issue mappings come from GitHub closingIssuesReferences (source "closing") first; fallback title/body/branch parsing and legacy bare numbers are lower-precedence and labeled with their source. Treat only "closing" links as authoritative when correcting dossiers.

Modes and exit codes:
- Normal runs are warning-only: exit 0 with validation problems reported in .validation and on stderr.
- ./wp-ai-roadmap-refresh.sh census --strict validates PR and issue pagination/schema completeness for every tracked repository without applying Project #240 coverage to the three upstream repositories.
- ./wp-ai-roadmap-refresh.sh --strict --json is the read-only audit: exit 2 (after emitting complete JSON) when any validation error exists, e.g. a substantive WordPress/ai PR with no board representation, an open WordPress/ai issue with no board card, an incomplete tracked-repository census, or an unreachable required dependency. Exit 1 means an operational failure prevented the report.
- An issue census can fail on its own without taking the PR/release census with it: that repository reports issues_available:false plus one issue-census-unavailable error, keeps its PR data, and skips only its issue snapshot so the prior baseline survives.
- A strict failure suppresses --save and --update-changelog ("persistence skipped"); persist snapshots with a normal-mode --save run.

Before finishing, verify with fresh live data:
- board title and short description (snapshots store only the item array, so a project-level rename is invisible to the diff and must be checked by hand)
- total board items
- Done/non-Done counts
- open issue count
- non-Done PR card count
- active and next milestone counts
- WordPress/ai open PR gap and the five classification counts
- per-repository open PR totals, open ISSUE totals, and latest releases for WordPress/ai, WordPress/php-ai-client, WordPress/mcp-adapter, and WordPress/abilities-api
- board issue coverage: every open WordPress/ai issue must have a Project #240 card (uncarded = strict error)
- dependency watchlist total and state split (16 registry items; required items must not be UNKNOWN)
- bash -n wp-ai-roadmap-refresh.sh
- deterministic tests: tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh, -prs.sh, -gap.sh, -strict.sh, -repositories.sh, -crlf.sh, -mergestate.sh, and -issues.sh (offline; mock gh)
- live smoke test: tests/wp-ai-roadmap-refresh-dependencies.sh (uses dependencies --strict --json)
```
