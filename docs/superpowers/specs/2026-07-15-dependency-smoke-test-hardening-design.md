# Dependency Smoke-Test Hardening Design

## Goal

Make the dependency smoke test reject incomplete or internally inconsistent JSON while preserving its live end-to-end coverage, and make the test directly executable.

## Design

Keep the existing test as a single Bash script that calls `wp-ai-roadmap-refresh.sh dependencies --json`. Strengthen its `jq -e` predicate so it:

- requires the returned item IDs to equal the complete 16-item dependency watchlist;
- recomputes `total`, `by_repo`, and `by_state` from `.items` and requires every reported summary value to match;
- therefore rejects missing, duplicate, unexpected, or miscounted dependencies.

The expected IDs remain explicit in the smoke test. This intentionally makes a watchlist addition, removal, or replacement require a corresponding test update, preventing an expanded watchlist from masking an unreachable dependency behind a lower-bound count.

Set the file mode to `100755` so the shebang-supported invocation `./tests/wp-ai-roadmap-refresh-dependencies.sh` works.

## Error Handling

Retain `set -euo pipefail` and `jq -e`. Any fetch failure, invalid JSON, contract mismatch, or false assertion exits nonzero; the success message is printed only after all checks pass.

## Verification

Before the change, demonstrate both reported failures: the current predicate accepts a synthetic two-item payload whose summary claims 16 items, and direct execution fails with permission denied. After the change:

- confirm that malformed synthetic payload is rejected;
- run `bash -n` for syntax validation;
- run the test directly against live GitHub data;
- confirm the tracked Git mode is `100755` and review the staged diff before committing.
