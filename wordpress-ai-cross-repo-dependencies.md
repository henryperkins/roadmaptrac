# WordPress AI — Cross-Repo Dependencies & Repository Radar

> Live cross-repository signals that affect the `WordPress/ai` roadmap but are not counted in Project #240 totals: a curated Gutenberg/Abilities dependency watchlist plus full PR/release censuses for the PHP AI Client and MCP Adapter.
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-20 |
> | **Scope** | 16 tracked dependencies = 11 Gutenberg items + 5 abilities-api items; full repository census for `WordPress/php-ai-client` and `WordPress/mcp-adapter` |
> | **State split** | 10 open · 3 closed · 3 merged *(unchanged vs the 2026-07-18 16:34 UTC baseline)* |
> | **Membership source** | `wp-ai-roadmap-dependencies.json` (versioned registry; `WP_AI_DEPS_FILE` overrides) |
> | **Repository source** | `wp-ai-roadmap-repositories.json` (additional full-census repositories; `WP_AI_REPOS_FILE` overrides) |
> | **Source commands** | `./wp-ai-roadmap-refresh.sh census --strict` · `./wp-ai-roadmap-refresh.sh dependencies --strict --json` |

The dependency section intentionally tracks a **curated watchlist**, not every open Gutenberg or abilities-api issue. Gutenberg is too broad for whole-repo tracking to be useful here; the watchlist follows only items explicitly referenced by the WordPress AI roadmap, issue dossiers, or planned-work risk notes. The PHP AI Client and MCP Adapter are narrower foundational repositories, so they receive a separate **full open-PR/release census** without importing their issue backlogs or imposing Project #240 coverage rules.

Watchlist **membership lives in `wp-ai-roadmap-dependencies.json`**, not in shell code. Each registry item declares `id` (`owner/repo#number`), `theme`, `aiRefs` (the WordPress AI issue numbers it affects, stored as integers), `note`, and `required`. Adding or removing a dependency is a reviewable JSON data change; the schema is validated on every run (`schemaVersion` 1, unique IDs, positive-integer `aiRefs`).

## Why This Exists

Project #240 is still the canonical source for `WordPress/ai` roadmap counts. The cross-repo watchlist captures upstream blockers and enabling work that can change the delivery path without changing Project #240:

- **Gutenberg**: Abilities and workflows, Guidelines/Skills, Media Editor, focal-point/media APIs, DataViews/admin UX, snackbar/toast accessibility.
- **abilities-api**: ability filtering, safety metadata, post-type CRUD abilities, core abilities scope, and ability meta.

## Full-Repository PR/Release Census

The refresh script enumerates every open PR and the release stream for these repositories on every normal/full census. Records include draft/review/merge/check state, activity timestamps, authoritative closing-issue references, PR/release diffs, per-repository validation, and independent snapshots.

| Repository | Open PRs | Latest shipped | Roadmap relevance |
|---|---:|---|---|
| [`WordPress/php-ai-client`](https://github.com/WordPress/php-ai-client) | **20** | **1.4.0** (2026-07-15) | Uniform provider-agnostic PHP client beneath WordPress AI features; changes to models, modalities, schemas, streaming, embeddings, and provider selection can alter the plugin's implementation path. |
| [`WordPress/mcp-adapter`](https://github.com/WordPress/mcp-adapter) | **12** | **v0.5.0** (2026-04-15) | Abilities-to-MCP bridge; transport, exposure, approval, session, schema, and server-registration changes can alter external-agent integrations. |

Project #240 coverage validation remains exclusive to the primary `WordPress/ai` repository. A PHP AI Client or MCP Adapter PR may be important upstream work without requiring a Project #240 PR card.

## Dependency Watchlist

| Dependency | Type | State | Milestone | Theme | AI refs | Updated |
|---|---:|---:|---|---|---|---:|
| [`WordPress/abilities-api#38`](https://github.com/WordPress/abilities-api/issues/38) | Issue | OPEN | Later | Ability registry filtering | #21, #354 | 2025-10-15 |
| [`WordPress/abilities-api#62`](https://github.com/WordPress/abilities-api/issues/62) | Issue | CLOSED | pre WP 6.9 | Ability safety metadata | #40 | 2025-10-09 |
| [`WordPress/abilities-api#84`](https://github.com/WordPress/abilities-api/issues/84) | Issue | OPEN | Later | Core CRUD abilities | #40 | 2025-10-30 |
| [`WordPress/abilities-api#105`](https://github.com/WordPress/abilities-api/issues/105) | Issue | CLOSED | pre WP 6.9 | Core abilities scope | #40 | 2025-10-24 |
| [`WordPress/abilities-api#106`](https://github.com/WordPress/abilities-api/issues/106) | Issue | CLOSED | WP 6.9 | Ability metadata | #40 | 2025-10-24 |
| [`WordPress/gutenberg#16549`](https://github.com/WordPress/gutenberg/issues/16549) | Issue | OPEN | — | Admin UX / accessibility | #699 | 2026-02-23 |
| [`WordPress/gutenberg#70710`](https://github.com/WordPress/gutenberg/issues/70710) | Issue | OPEN | — | Platform / workflows | #21, #40, #430 | 2026-06-22 |
| [`WordPress/gutenberg#72734`](https://github.com/WordPress/gutenberg/issues/72734) | Issue | OPEN | — | Media Editor | #325 | 2026-06-09 |
| [`WordPress/gutenberg#73771`](https://github.com/WordPress/gutenberg/issues/73771) | Issue | OPEN | — | Media Editor | #238, #325 | 2026-07-17 |
| [`WordPress/gutenberg#74234`](https://github.com/WordPress/gutenberg/pull/74234) | PullRequest | OPEN | — | Platform / core abilities | #40 | 2026-06-19 |
| [`WordPress/gutenberg#74572`](https://github.com/WordPress/gutenberg/pull/74572) | PullRequest | MERGED | Gutenberg 22.7 | Admin UX / DataViews | #741 | 2026-02-26 |
| [`WordPress/gutenberg#75221`](https://github.com/WordPress/gutenberg/issues/75221) | Issue | OPEN | — | Media / focal point | #238 | 2026-02-04 |
| [`WordPress/gutenberg#77230`](https://github.com/WordPress/gutenberg/issues/77230) | Issue | OPEN | — | Skills / Guidelines | #430 | 2026-07-11 |
| [`WordPress/gutenberg#77643`](https://github.com/WordPress/gutenberg/pull/77643) | PullRequest | MERGED | Gutenberg 23.1 | Skills / Guidelines | #430 | 2026-04-29 |
| [`WordPress/gutenberg#77816`](https://github.com/WordPress/gutenberg/issues/77816) | Issue | OPEN | — | Admin UX / toast component | #699 | 2026-06-29 |
| [`WordPress/gutenberg#77994`](https://github.com/WordPress/gutenberg/pull/77994) | PullRequest | MERGED | Gutenberg 23.2 | Media Editor | #325 | 2026-06-25 |

## Refresh Notes

Run the normal refresh to include this watchlist in the JSON/Markdown report:

```bash
./wp-ai-roadmap-refresh.sh
```

Run the dependency-only path when you only need the cross-repo state:

```bash
./wp-ai-roadmap-refresh.sh dependencies
./wp-ai-roadmap-refresh.sh dependencies --json
./wp-ai-roadmap-refresh.sh dependencies --strict --json   # audit mode
```

Run the repository-only path for all three full PR/release censuses:

```bash
./wp-ai-roadmap-refresh.sh census
./wp-ai-roadmap-refresh.sh census --strict
```

Use `--save` on the normal refresh to persist the dependency snapshot plus independent `prs-<owner>-<repo>-*.json` and `releases-<owner>-<repo>-*.json` baselines for every available repository, so later runs can report state, readiness, and release changes.

### Fetch behavior, UNKNOWN placeholders, and strict mode

- Every registry item is attempted on every run. A failed GitHub request for a **required** item is retried exactly once (two attempts total); **optional** items get one attempt.
- An unreachable item never disappears from the report. It is emitted as a placeholder with `state: "UNKNOWN"`, its configured theme/refs/note, and a structured `fetchError` (`{code, endpoint, attempts, message}`). The dependency diff therefore reports a temporary outage as a state change to `UNKNOWN`, not as a removed dependency — registry removal is the only thing that removes an item.
- The JSON result carries `validation` (`{ok, errors, warnings}`): a required `UNKNOWN` item is an error, an optional `UNKNOWN` item is a warning, and an invalid registry produces `dependency-registry-invalid` errors with an empty item list.
- Normal mode is warning-only and always exits `0` when a report was produced. `dependencies --strict --json` emits the same JSON first and then exits `2` when any validation error exists (exit `1` is an operational failure, e.g. an unreadable registry file).
- `aiRefs` are stored as integers in the registry and new snapshots; historical snapshots with `"#NNN"` strings remain readable, and renderers always print exactly one `#` prefix either way.

## Changelog

| Date | Change |
|---|---|
| 2026-07-20 | **Live recheck vs the 2026-07-18 16:34 UTC baseline.** No dependency membership, state, milestone, title, or activity changes: the watchlist holds at **16** (10 open · 3 closed · 3 merged; 11 Gutenberg + 5 abilities-api), every `Updated` cell steady, and no required item UNKNOWN. Upstream repository radar also unchanged — `WordPress/php-ai-client` **20 / 1.4.0** and `WordPress/mcp-adapter` **12 / v0.5.0**. Primary `WordPress/ai` movement (board PR #858 merge DIRTY → BLOCKED) is recorded in the roadmap and planned-work files, not counted as cross-repo drift. |
| 2026-07-18 | **Same-day live recheck vs the 2026-07-18 02:20 UTC baseline.** No dependency membership, state, milestone, title, or activity changes: the watchlist remains 16 (10 open · 3 closed · 3 merged; 11 Gutenberg + 5 abilities-api), with no required item UNKNOWN. The upstream repository radar is also unchanged at `WordPress/php-ai-client` **20 / 1.4.0** and `WordPress/mcp-adapter` **12 / v0.5.0**. Primary `WordPress/ai` movement is documented in the roadmap and planned-work files rather than counted as cross-repo drift. |
| 2026-07-18 | **Added full PR/release census tracking for two foundational repositories.** `WordPress/php-ai-client` starts at **20 open PRs / release 1.4.0 (2026-07-15)**; `WordPress/mcp-adapter` starts at **12 / v0.5.0 (2026-04-15)**. Membership lives in `wp-ai-roadmap-repositories.json`; both receive validation, diffs, rendering, and independent snapshots. They remain census-only and do not affect Project #240 coverage or the 16-item dependency watchlist. |
| 2026-07-17 | **Tooling: watchlist membership moved to the `wp-ai-roadmap-dependencies.json` registry** (schema-validated; `required` flag per item; integer `aiRefs`). Fetches are now resilient — required items retry once and unreachable items surface as `UNKNOWN` placeholders with a `fetchError` instead of vanishing — and `dependencies --strict --json` exits `2` when a required item is unreachable or the registry is invalid. Watchlist data itself unchanged (16 dependencies; 10 open · 3 closed · 3 merged). |
| 2026-07-17 | Live refresh vs the 2026-07-13 baseline snapshot. **No state, milestone, or list changes** — watchlist remains 16 dependencies (10 open · 3 closed · 3 merged; abilities-api 5, Gutenberg 11). `WordPress/gutenberg#73771` was retitled "Media Editor Modal task tracking" → "WordPress 7.1 Iteration: Media Editor Modal task tracking" and its Updated cell advanced 2026-07-08 → 2026-07-17. |
| 2026-07-12 | Live refresh vs the 2026-07-09 baseline snapshot. **No state, milestone, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged; abilities-api 5, Gutenberg 11). **1 title change + 1 activity bump**, both on `WordPress/gutenberg#77230`: retitled "Guidelines built on Knowledge in WordPress **7.1**" → "…WordPress **7.2**", and its Updated cell bumped 2026-07-01 → 2026-07-11. Context: the `WordPress/ai` **v1.2.0** lane advanced (6 more board-Done, incl. the #508 "Suggest Reply" experiment) and two more core-ability PRs opened upstream-adjacent (#856 `core/read-settings` snapshot ordering, #858 `core/read-nav-menus`), but no watchlisted Gutenberg/abilities-api dependency changed state. |
| 2026-07-09 | Live refresh vs the 2026-07-03 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged; abilities-api 5, Gutenberg 11). 1 item had new upstream activity; bumped Updated cell: `WordPress/gutenberg#73771` → 2026-07-08. Context: the `WordPress/ai` **v1.2.0** lane opened its first 10 board-Done items this window (incl. the new `core/read-users` Ability, PR #774, merged), but no watchlisted Gutenberg/abilities-api dependency changed state. |
| 2026-07-03 | Live refresh vs the 2026-07-02 baseline snapshot. **No state, milestone, title, list, or activity changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged; abilities-api 5, Gutenberg 11). No `Updated` cells bumped (no upstream activity in the window). Context: `WordPress/ai` de-carded 7 already-Done issues from Project #240 this window, but no watchlisted Gutenberg/abilities-api dependency changed. |
| 2026-07-02 | Live refresh vs the 2026-06-30 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 2 items had new upstream activity; bumped Updated cells: `WordPress/gutenberg#73771` → 2026-07-01, `#77230` → 2026-07-01. Context: `WordPress/ai` shipped **v1.1.0** (2026-07-01) in this window, but no watchlisted Gutenberg/abilities-api dependency changed state. |
| 2026-06-30 | Live refresh vs the 2026-06-26 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 3 items had new upstream activity; bumped Updated cells: `WordPress/gutenberg#73771` → 2026-06-30, `#77230` → 2026-06-30, `#77816` → 2026-06-29. |
| 2026-06-26 | Live refresh vs the 2026-06-25 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 1 item had new upstream activity; bumped Updated cell: `WordPress/gutenberg#77994` → 2026-06-25. |
| 2026-06-25 | Live refresh vs the 2026-06-20 baseline snapshot. **No state, milestone, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 1 title change: `WordPress/gutenberg#77230` retitled "Guidelines: Evolve CPT to enable support for skills, memory, and plans via taxonomy" → "Guidelines built on Knowledge in WordPress 7.1". 3 items had new upstream activity; bumped Updated cells: `#70710` → 2026-06-22, `#77230` → 2026-06-22, `#77994` → 2026-06-24. |
| 2026-06-20 | Live refresh vs the 2026-06-19 baseline snapshot. **No state, milestone, or title changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 2 items had new upstream activity (`WordPress/gutenberg#74234`, `#70710`); bumped #74234's Updated cell to 2026-06-19. |
| 2026-06-19 | Initial Gutenberg + abilities-api dependency watchlist. Added 16 tracked dependencies and wired the refresh script to fetch, diff, render, and snapshot them separately from Project #240 counts. |
