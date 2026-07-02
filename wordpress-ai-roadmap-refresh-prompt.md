# WordPress AI Roadmap Refresh Prompt

```text
In /home/dev/roadmaptrac, refresh the WordPress AI roadmap docs from live GitHub data.

Update:
- wordpress-ai-roadmap.md
- wordpress-ai-planned-work.md
- wordpress-ai-open-issues.md
- wordpress-ai-cross-repo-dependencies.md
- wp-ai-roadmap-refresh.sh, only if the refresh script has drift or a bug

Re-pull GitHub Project #240, the WordPress/ai repo PR/release census, and the Gutenberg / abilities-api cross-repo dependency watchlist. Do not reuse old counts. Reconcile the board against repo-open PRs, update counts/status/milestone groupings, move issue dossiers between status sections as needed, refresh the dependency watchlist, and add changelog entries.

Before finishing, verify with fresh live data:
- total board items
- Done/non-Done counts
- open issue count
- non-Done PR card count
- repo open PR gap
- latest release
- dependency watchlist total and state split
- bash -n wp-ai-roadmap-refresh.sh
```
