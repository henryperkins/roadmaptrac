# WordPress AI — Cross-Repo Dependencies

> Live watchlist for roadmap-critical Gutenberg and Abilities API work that affects the `WordPress/ai` roadmap but is not counted in Project #240 totals.
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-12 |
> | **Scope** | 16 tracked dependencies = 11 Gutenberg items + 5 abilities-api items |
> | **State split** | 10 open · 3 closed · 3 merged *(unchanged vs 2026-07-09)* |
> | **Source command** | `./wp-ai-roadmap-refresh.sh dependencies --json` |

This document intentionally tracks a **curated dependency watchlist**, not every open Gutenberg or abilities-api issue. Gutenberg is too broad for whole-repo tracking to be useful here; the watchlist follows only items that are explicitly referenced by the WordPress AI roadmap, issue dossiers, or planned-work risk notes.

## Why This Exists

Project #240 is still the canonical source for `WordPress/ai` roadmap counts. The cross-repo watchlist captures upstream blockers and enabling work that can change the delivery path without changing Project #240:

- **Gutenberg**: Abilities and workflows, Guidelines/Skills, Media Editor, focal-point/media APIs, DataViews/admin UX, snackbar/toast accessibility.
- **abilities-api**: ability filtering, safety metadata, post-type CRUD abilities, core abilities scope, and ability meta.

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
| [`WordPress/gutenberg#73771`](https://github.com/WordPress/gutenberg/issues/73771) | Issue | OPEN | — | Media Editor | #238, #325 | 2026-07-08 |
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
```

Use `--save` on the normal refresh to persist a dependency snapshot under `.wp-ai-roadmap-snapshots/wordpress-ai-cross-repo-dependencies-*.json`, so later runs can report state/list changes.

## Changelog

| Date | Change |
|---|---|
| 2026-07-12 | Live refresh vs the 2026-07-09 baseline snapshot. **No state, milestone, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged; abilities-api 5, Gutenberg 11). **1 title change + 1 activity bump**, both on `WordPress/gutenberg#77230`: retitled "Guidelines built on Knowledge in WordPress **7.1**" → "…WordPress **7.2**", and its Updated cell bumped 2026-07-01 → 2026-07-11. Context: the `WordPress/ai` **v1.2.0** lane advanced (6 more board-Done, incl. the #508 "Suggest Reply" experiment) and two more core-ability PRs opened upstream-adjacent (#856 `core/read-settings` snapshot ordering, #858 `core/read-nav-menus`), but no watchlisted Gutenberg/abilities-api dependency changed state. |
| 2026-07-09 | Live refresh vs the 2026-07-03 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged; abilities-api 5, Gutenberg 11). 1 item had new upstream activity; bumped Updated cell: `WordPress/gutenberg#73771` → 2026-07-08. Context: the `WordPress/ai` **v1.2.0** lane opened its first 10 board-Done items this window (incl. the new `core/read-users` Ability, PR #774, merged), but no watchlisted Gutenberg/abilities-api dependency changed state. |
| 2026-07-03 | Live refresh vs the 2026-07-02 baseline snapshot. **No state, milestone, title, list, or activity changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged; abilities-api 5, Gutenberg 11). No `Updated` cells bumped (no upstream activity in the window). Context: `WordPress/ai` de-carded 7 already-Done issues from Project #240 this window, but no watchlisted Gutenberg/abilities-api dependency changed. |
| 2026-07-02 | Live refresh vs the 2026-06-30 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 2 items had new upstream activity; bumped Updated cells: `WordPress/gutenberg#73771` → 2026-07-01, `#77230` → 2026-07-01. Context: `WordPress/ai` shipped **v1.1.0** (2026-07-01) in this window, but no watchlisted Gutenberg/abilities-api dependency changed state. |
| 2026-06-30 | Live refresh vs the 2026-06-26 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 3 items had new upstream activity; bumped Updated cells: `WordPress/gutenberg#73771` → 2026-06-30, `#77230` → 2026-06-30, `#77816` → 2026-06-29. |
| 2026-06-26 | Live refresh vs the 2026-06-25 baseline snapshot. **No state, milestone, title, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 1 item had new upstream activity; bumped Updated cell: `WordPress/gutenberg#77994` → 2026-06-25. |
| 2026-06-25 | Live refresh vs the 2026-06-20 baseline snapshot. **No state, milestone, or list changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 1 title change: `WordPress/gutenberg#77230` retitled "Guidelines: Evolve CPT to enable support for skills, memory, and plans via taxonomy" → "Guidelines built on Knowledge in WordPress 7.1". 3 items had new upstream activity; bumped Updated cells: `#70710` → 2026-06-22, `#77230` → 2026-06-22, `#77994` → 2026-06-24. |
| 2026-06-20 | Live refresh vs the 2026-06-19 baseline snapshot. **No state, milestone, or title changes** — watchlist holds at 16 dependencies (10 open · 3 closed · 3 merged). 2 items had new upstream activity (`WordPress/gutenberg#74234`, `#70710`); bumped #74234's Updated cell to 2026-06-19. |
| 2026-06-19 | Initial Gutenberg + abilities-api dependency watchlist. Added 16 tracked dependencies and wired the refresh script to fetch, diff, render, and snapshot them separately from Project #240 counts. |
