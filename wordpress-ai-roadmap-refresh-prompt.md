# WordPress AI Roadmap Refresh Prompt

```text
In /home/henry/roadmaptrac, review wp-ai-roadmap-refresh.sh and refresh the WordPress AI roadmap docs from live GitHub data.

Update:
- wordpress-ai-roadmap.md
- wordpress-ai-planned-work.md
- wordpress-ai-open-issues.md
- wordpress-ai-cross-repo-dependencies.md
- wp-ai-roadmap-refresh.sh, only if the refresh script has drift or a bug
- wp-ai-roadmap-dependencies.json, only when dependency watchlist membership changes (this JSON registry is the watchlist source of truth; do not edit shell code to add/remove a dependency)

Re-pull GitHub Project #240, the WordPress/ai repo PR/release census, and the Gutenberg / abilities-api cross-repo dependency watchlist. Do not reuse old counts. Reconcile the board against repo-open PRs using the five coverage classifications (direct-board-pr, linked-board-issue, routine, linked-off-board-issue, unexplained), update counts/status/milestone groupings, move issue dossiers between status sections as needed, refresh the dependency watchlist, and add changelog entries.

PR-to-issue mappings come from GitHub closingIssuesReferences (source "closing") first; fallback title/body/branch parsing and legacy bare numbers are lower-precedence and labeled with their source. Treat only "closing" links as authoritative when correcting dossiers.

Modes and exit codes:
- Normal runs are warning-only: exit 0 with validation problems reported in .validation and on stderr.
- ./wp-ai-roadmap-refresh.sh --strict --json is the read-only audit: exit 2 (after emitting complete JSON) when any validation error exists, e.g. a substantive open PR with no board representation or an unreachable required dependency. Exit 1 means an operational failure prevented the report.
- A strict failure suppresses --save and --update-changelog ("persistence skipped"); persist snapshots with a normal-mode --save run.

Before finishing, verify with fresh live data:
- total board items
- Done/non-Done counts
- open issue count
- non-Done PR card count
- active and next milestone counts
- repo open PR gap and the five classification counts
- latest release
- dependency watchlist total and state split (16 registry items; required items must not be UNKNOWN)
- bash -n wp-ai-roadmap-refresh.sh
- deterministic tests: tests/wp-ai-roadmap-refresh-dependencies-fixtures.sh, -prs.sh, -gap.sh, -strict.sh (offline; mock gh)
- live smoke test: tests/wp-ai-roadmap-refresh-dependencies.sh (uses dependencies --strict --json)
```
