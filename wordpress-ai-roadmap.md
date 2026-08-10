# WordPress AI — Planning & Roadmap (Living Document)

> **Source board:** [github.com/orgs/WordPress/projects/240](https://github.com/orgs/WordPress/projects/240) — *"WordPress AI Planning & Roadmap"*
> *"A project board to provide oversight into the various focus areas of the WordPress AI team."*
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-08-10 (latest board-item activity: 2026-08-10) |
> | **Items captured** | 269 (full board, via GraphQL Projects API) |
> | **Plugin** | [`WordPress/ai`](https://github.com/WordPress/ai) — the official "AI" Showcase Plugin on WordPress.org |
> | **Latest shipped** | **v1.2.0** (shipped 2026-07-14) — 18th release; release issue [#864](https://github.com/WordPress/ai/issues/864) closed after plugin checks, tests, local testing, GitHub release, and WordPress.org deployment |
> | **In active development** | **v1.3.0** (21 open / 5 Done; 26 carded; no due date) · **Next:** v1.4.0 (2 issues, both In discussion) · **Backlog:** Future Release (40 open) |
> | **Maintained by** | _(you)_ — see [§10 How to refresh](#10-how-to-refresh-this-document) to regenerate the data |

**How to read this doc:** [§1 Composition](#1-board-composition) · [§2 Releases](#2-release-cadence) · [§3 Product model](#3-product-architecture) · [§4 Shipped](#4-shipped-done) · [§5 In progress](#5-in-progress) · [§6 Roadmap bets](#6-planned-roadmap--strategic-bets) · [§7 Undecided/blocked](#7-unplanned--undecided--blocked) · [§8 Strategic read & risks](#8-strategic-read--risks) · [§9 Full open-issue tracker](#9-appendix--full-open-issue-tracker-51) · [§10 Refresh](#10-how-to-refresh-this-document) · [§11 Changelog](#11-changelog)

> **📚 Companion documents (4-doc set):**
> 1. **This file** — strategy, board composition, release cadence, and the at-a-glance open-issue tracker.
> 2. **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** — deep per-issue dossiers, grouped by status. *(Current to 2026-08-10: all 51 board-open issues, plus #84 as a removed-board reference and 43 recently board-Done issues retained for reference.)*
> 3. **[`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md)** — the release-ordered delivery plan for all 67 non-Done cards, including 15 open board-tracked PRs and stale merged PR #484.
> 4. **[`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md)** — the 16-item Gutenberg + abilities-api dependency watchlist (11 + 5), plus full PR/release censuses for `WordPress/php-ai-client` and `WordPress/mcp-adapter`.

### Status legend (board's own taxonomy)
`Triage` → unsorted/new · `In discussion / Needs decision` → debated, **not** committed · `Backlog` / `To do` → planned · `In progress` → being built · `Needs review` → review-ready · `Done` → shipped/merged

---

## Executive summary

Project #240 remains the operational tracker for the [`WordPress/ai`](https://github.com/WordPress/ai) Showcase Plugin (268 of 269 cards; the other card is Google-provider issue #23). The plugin continues to organize user-facing AI capabilities as toggleable experiments over shared Connectors, AI Client, Abilities API, MCP, and request-log infrastructure.

This is a **bookkeeping window.** No feature shipped, but the board's *accuracy* improved more than in any recent window: the dated lane was reloaded, and the two worst coverage failures from last window resolved.

**Nothing was delivered, and both cards that reached Done say so.** Board totals held at **269**, with six cards out and six in. The six removals are already-Done issues de-carded in the sixth post-release hygiene pass (#191, #192, #452, #507, #874 from 1.3.0, plus unmilestoned #883). Only two cards newly reached Done and **neither is delivery**: **#193** (developer-only log panel) was closed as *already implemented* — "marking this closed by #437" — and retro-milestoned **Future Release → 1.0.0**, meaning a card sat in the backlog while the feature had been in the product since the 1.0.0 era; and **#869** (the `window.aiProviderData` iframe mismatch) was closed **`NOT_PLANNED` as not reproducible**, three windows after this document first flagged that it needed a clean-environment repro. Of the six additions, four are dependabot PRs (#919, #921 merged; #922 closed unmerged; #920 open) and one is a new Triage issue, **#918** (AI-generated `llms.txt`).

**The dated lane was reloaded — last window's re-milestoning reversed.** All five milestone moves pulled work *toward* a release. **#875** and **#876** (internal links, permalink slugs), pushed out of 1.4.0 into Future Release only nine days ago, came back as **1.3.0**; **#233** moved in from Future Release; **#906** was milestoned from nothing. v1.3.0 goes 15 → **21 non-Done** (13 issues + 8 PRs) and Future Release falls 44 → **40**. v1.4.0 is untouched at **2** undecided issues with still no code — the lane that emptied last window was not refilled, it was bypassed.

**Coverage held at six unexplained PRs, but half the set turned over and the two most damaging entries cleared.** The census rose 33 → **36 open PRs**; classification is **15 direct + 15 linked + 0 routine + 0 off-board + 6 unexplained**. Resolved: **#905** was retitled from *remove* to **"Deprecate the AI_Service layer"** after dkotter argued for backward compatibility, and — decisively — it now declares **`Closes #233`**, so last window's "the board can be actively wrong" case is corrected at the source; #233 is now In progress under 1.3.0 with an authoritative closing PR. **#889** was given a board PR card. **#913 merged on 2026-08-07 — but merged uncarded**, so the default-model switch and the `wpai_meta_description_result_temperature` deprecation reached `develop` without ever appearing on Project #240. Still uncarded: **#888** (Text to Speech, +4,216) and **#892** (vendored embeddings, +4,394), now in their third window, plus **#909**. New: **#915**, **#916**, **#917** — three small contributor polish PRs on Content Resizing and Content Classification, a materially lighter class of gap than the strategy reversal it replaced.

**Nothing in the repository is mergeable, and that has not moved.** All 36 open PRs are BLOCKED (24) or DIRTY (12), **none carries an approving review**, 16 have failing checks, and CHANGES_REQUESTED holds at **14**. Only three genuine readiness changes occurred all window: #881 came out of draft, #887 went DIRTY, and #914's checks turned green.

The forward roadmap still converges on four bets: (A) Abilities as the universal tool layer, now including opt-in controls for standalone abilities; (B) a provider-agnostic Connectors ecosystem; (C) an editorial lifecycle that expands from single-field generators into review, linking, slugs, translation, and agentic refinement; and (D) conversational/site-agent and semantic-search surfaces. The near-term delivery lane is **v1.3.0 (21 non-Done cards)**; **v1.4.0 holds 2 undecided issues**, and **Future Release holds 40 cards**.

The repository radar covers the full open-PR and release streams for the two foundational upstream repositories alongside `WordPress/ai`, and this window they moved in **opposite directions** for the first time: **`WordPress/php-ai-client` rose 24 → 26 open PRs** with latest release 1.4.0 (2026-07-15) — new **#273** adds an *automatic function-call resolution loop* to the client itself, an agentic primitive landing one layer beneath the plugin — while **`WordPress/mcp-adapter` fell 20 → 19** with latest release v0.5.0 (2026-04-15), as its overlapping DTO-normalization cluster began resolving (#262 merged, #260 promptly conflicted). Upstream also recorded the **first APPROVED reviews the radar has seen** (php-ai-client #231/#250/#254), against zero on all 36 `WordPress/ai` PRs. These are census-only signals: their PRs are not required to appear on Project #240 and do not create roadmap-coverage failures.

---

## 1. Board composition

| Dimension | Breakdown |
|---|---|
| **Total items** | **269** = 214 PRs + 55 issues |
| **By status** | Done **202** · In progress **29** · In discussion/Needs decision **20** · Backlog **6** · Needs review **6** · To do **3** · Triage **3** |
| **Open work** | **67 non-Done cards** = 51 open issues + 16 PR cards *(15 open; #484 is merged but still board-Needs review)* |
| **By repo** | `WordPress/ai` **268** · `WordPress/ai-provider-for-google` **1** (#23). `WordPress/abilities-api` #84 is not on Project #240. |
| **Cross-repo dependency scope** | Separate watchlist: **16** dependencies (10 open, 3 closed, 3 merged), tracked in [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md). |
| **Full repository census** | `WordPress/ai`: **36** open PRs / release **1.2.0** · `WordPress/php-ai-client`: **26** / **1.4.0** · `WordPress/mcp-adapter`: **19** / **v0.5.0**. Project #240 coverage applies only to `WordPress/ai`. |
| **"Team" field** | No Team values are returned in the current Projects API snapshot; use repo + labels/status for classification. |
| **"Priority" field** | Barely used; prioritization is expressed through Status + Milestone. |
| **Board views** | Prioritized backlog · AI plugin · Status board · Roadmap (timeline) · Bugs 🐛 · My items |

**Caveat for maintainers:** "Done" (**202**) is overwhelmingly merged PRs; the forward-looking signal lives in the **51 open issues** and **16 non-Done PR cards**. Total item count is not a scope proxy — it is *flat* this window only because six de-cardings and six additions happened to cancel out, while the PR/issue mix shifted 209/60 → **214/55**. **Nor is "Done" a delivery proxy:** this window it absorbed a card closed as already-implemented years earlier (#193 → 1.0.0), a card closed `NOT_PLANNED` (#869), and a dependabot PR closed unmerged (#922) — alongside the standing case of PR card **#621**, closed unmerged on 2026-07-28 and still Done.

---

## 2. Release cadence

The plugin has shipped **18 releases**, most recently **v1.2.0 on 2026-07-14**. The board uses v1.3.0 as the active delivery lane and v1.4.0 for the next set of editorial experiments; neither has a due date.

| Milestone | Board cards | State | Meaning |
|---|---:|---|---|
| 0.1.0 → 0.9.0 | 134 | 133 Done / 1 stale | Build-out history; #484 is merged but still board-Needs review under 0.9.0. |
| 1.0.0 | 4 | ✅ Done | Stability milestone aligned with WordPress 7.0 / the Abilities API. Gained #193 this window — closed as already-implemented by PR #437 and filed against the release that actually shipped it. |
| 1.0.1 | 8 | ✅ Done | Prior patch release. |
| 1.0.2 | 3 | ✅ Done | Prior patch release (2026-06-16); several already-Done cards were later removed from the board. |
| 1.1.0 | 11 | ✅ Done | Shipped 2026-07-01; all remaining cards are Done. |
| **1.2.0** | 9 | ✅ 8 Done / 1 open | **Shipped 2026-07-14**, then trimmed 21 → 13 → 9 across two de-carding passes. The one non-Done card is external Google-provider issue #23, not unfinished `WordPress/ai` release work. |
| **1.3.0** | 26 | 🚧 5 Done / 21 open | **Active lane, reloaded:** 13 issues + 8 open PRs. Gained #233 (from Future Release), #875/#876 (back from Future Release after only nine days) and #906 (from no milestone), plus dependabot PR cards #919/#920/#921. Done fell 8 → 5 because five already-Done cards were de-carded. No due date. |
| **1.4.0** | 2 | 🚧 0 Done / 2 In discussion | Next editorial-experiment lane, still only the undecided #27 and #324 — **no card in this lane is being built**, and the window's reloading went to 1.3.0 rather than here. |
| **Future Release** | 42 | 📋 2 Done / 40 open | Long-range backlog: 33 issues + 7 PRs remain non-Done. It gave up #233/#875/#876 to 1.3.0 and gained nothing. |
| _(no milestone)_ | 30 | 28 Done / 2 open | Triage bugs #890 (mobile right sidebar) and board-new #918 (AI-generated `llms.txt`). #869 closed, #906 milestoned into 1.3.0, #883 de-carded; dependabot PR #922 arrived Done. |

*Sums to 269 cards.*

---

## 3. Product architecture

The mental model that explains every item on the board:

**Experiments (user-facing, toggleable AI features):**
Title Generation · Excerpt Generation · Alt Text Generation · Image Generation · Content Summarization · Content Classification · Content Resizing · Comment Moderation · "Refine"/Editorial Updates (Notes) · Abilities Explorer

**Shared infrastructure:**
- **Connectors** — the screen where AI **provider plugins** register (Anthropic / Google / OpenAI by default).
- **Abilities API** (WP core) — the tool/capability layer; **the strategic keystone** (maps to MCP, WebMCP, Skills, Command Palette).
- **WP AI Client** (WP 7.0 core) — the in-core prompt/model client features call.
- **AI Request Logs** — observability (the dominant recent theme).
- **MCP** adapters — expose abilities to external agents.
- ~~**`AI_Service`** layer~~ — **being deprecated.** Introduced in 0.2.1 (#101) as shared internal routing that experiments would migrate onto (#233), it was never adopted. PR [#905](https://github.com/WordPress/ai/pull/905) began as an outright deletion and was **softened to deprecation** this window — the class and the `get_ai_service()` helper stay, marked deprecated, after dkotter noted both are public surface a third party could be calling. All experiments call `wp_ai_client_prompt()` directly. **#905 now declares `Closes #233`**, so the board finally reflects the decision: #233 is In progress under 1.3.0 with an authoritative closing PR, even though its title still says "leverage" rather than "retire."

Every roadmap item is a **new Experiment**, an **enhancement to one**, or **infrastructure/governance** beneath them.

---

## 4. Shipped (Done)

Board-Done now reads **202** — down from 203 because **six already-Done cards were de-carded** while five cards entered Done, and **none of the five is delivered work this window**.

The two cards that *moved* into Done:

- **#193 Add developer-only log panel for inspecting AI provider responses** — **closed as already built.** The closing comment is "I concur, marking this closed by **#437**", and the card was simultaneously re-milestoned **Future Release → 1.0.0**. The developer log panel has been in the product since the 1.0.0 era; the card simply outlived its own delivery by several releases while sitting in Backlog. Filed correctly on the way out, but it represents cleanup, not output.
- **#869 `window.aiProviderData` iframe/top-window mismatch** — **closed `NOT_PLANNED`**: "Closing as this is not reproducible… please let us know if you're still seeing issues." This document flagged for three consecutive windows that #869 lacked a clean-environment reproduction; it was retired for exactly that reason, with an explicit invitation to the reporter to reopen. Treat it as unresolved-but-unactionable rather than fixed.

Three further cards *arrived* already-Done, all dependabot: **#919** (vipwpcs 3.0.1 → 3.1.0) and **#921** (`@wordpress/admin-ui` + `ui`) merged; **#922** (`@wordpress/block-library` 9.48.1 → 10.1.0) was **closed unmerged** and still shows Done.

The six de-carded cards are shipped 1.3.0 work plus one unmilestoned fix: #191, #192, #452, #507, #874, #883. This is the sixth such post-release hygiene pass; it moves no work.

**Read this window's Done delta carefully.** Nothing was built. One card was closed because the work predated it, one because it could not be reproduced, one because its dependency bump was abandoned, and two because bots merged dependency updates. Board-Done is a status column, not a delivery ledger.

**v1.2.0 remains the latest release (2026-07-14).** Its release checklist recorded passing plugin checks, automated tests, local testing, GitHub release creation, and WordPress.org deployment. The only non-Done card still labeled 1.2.0 is Google-provider issue #23 in another repository.

The durable shipped foundation remains:

- Toggleable experiments over shared Connectors and the WordPress AI Client.
- Abilities Explorer and an expanding set of read/manage abilities.
- MCP integration and request-log observability.
- Type Ahead, Suggest Reply, Content Classification, generation, summarization, and editorial workflows.
- Repeated accessibility, internationalization, lifecycle, and provider-approval hardening.

---

## 5. In progress

The active build wave is still **v1.3.0**, and it grew sharply this window to 21 non-Done cards (13 issues + 8 PRs). Its main clusters are:

- **Abilities and platform:** the standalone-abilities toggle (#863, now In progress, PR #881 **out of draft**), `core/manage-settings` (#764), `core/read-nav-menus` (#858), native vector search (#683), and the `AI_Service` retirement (#233, PR #905).
- **Editorial and content:** comment-value scoring (#514, PR #681), Markdown feeds (#845, PR #855), post-meta prefix normalization (#866, PR #867), and the two experiments pulled back into the lane — internal-link suggestions (#875, PR #887) and permalink slugs (#876, PR #897).
- **Reliability and lifecycle:** provider-approval error copy (#660, PR #759), plugin uninstall cleanup (#690, PR #692), non-SDK request logging (#732, PR #757), the reserved-log-type API (#906, PR #914), and admin-page flicker (#741).
- **Provenance:** C2PA manifest detection (#421), with PR #459 as its authoritative closing PR, still carrying CHANGES_REQUESTED.
- **Maintenance:** dependency alignment (#777/#832), request-log a11y (#889), and dependabot card #920.

**Six cards joined this lane and none left by shipping.** #233, #875, #876 and #906 were milestoned in, and dependabot cards #919/#920/#921 were carded (two immediately Done). The lane is fuller than it has been since 1.2.0, but its composition is unchanged work re-labelled, not new delivery.

**v1.4.0 was skipped over, not refilled.** It still holds only #27 (provider discovery) and #324 (agentic Refine), both long-undecided, both with no code. The two experiments that left it last window came back into **1.3.0** rather than returning here — so the next editorial lane remains a container with nothing in it that anyone is building.

Two unmilestoned cards now sit outside any lane: Triage bug **#890** (a mobile right-sidebar proposal, still unscoped after three weeks) and board-new **#918**, a proposal for an AI-generated **`llms.txt`** — a curated Markdown site index at `/llms.txt` following the emerging standard, pitched as the agent-facing counterpart to `robots.txt`/`sitemap.xml`. #906 left this tier by being milestoned into 1.3.0, and #869 left by being closed.

The repo has **36 open PRs**: 15 are represented by open board PR cards, while 21 are untracked by a PR card (all substantive — there are no routine dependency PRs untracked this window, because the dependabot PRs are carded). Several untracked PRs implement board issues, so board status must not be read as the complete code-in-flight view — and **six** untracked PRs have no board representation at all (see [§7](#7-unplanned--undecided--blocked)).

Two additional full-repository censuses expose upstream implementation and release movement without folding it into Project #240: **26 open PRs in `WordPress/php-ai-client`** (+2, none closed: #271 fixing the `isSupported()` bool contract, and #273 adding an automatic function-call resolution loop plus `withMessages()` to `PromptBuilder`) and **19 in `WordPress/mcp-adapter`** (−1, its first decline: #262 merged and #256 closed unmerged against draft #277 opening, with the comprehensive #260 going DIRTY as a result). Neither has cut a release for three windows. Their complete normalized PR records, readiness fields, releases, diffs, and independent snapshots are emitted by `wp-ai-roadmap-refresh.sh`; only the primary `WordPress/ai` census is joined to the roadmap board.

*(Full per-issue detail is in [§9](#9-appendix--full-open-issue-tracker-51).)*

---

## 6. Planned roadmap — strategic bets

Four converging directions. Most sit in **"Future Release"** (uncommitted) unless noted.

### A. Abilities API as the universal tool layer → Platform & Standards
The keystone bet: **`name + description + JSON Schema + implementation`** as the primitive that bridges WordPress into every agent standard.

- **#40 Core Abilities** *(Triage)* — the foundational `core/*` ability set (CRUD posts/pages/users/media/settings, plugin activate/update; destructive actions excluded for v1). **Key debate:** collapse per-post-type CRUD into one `create_post(post_type)` (consensus *yes* — MCP tool caps: 128 OpenAI / 512 Google) vs. granular abilities for Command Palette UX. Owners: gziolo, jorgefilipecosta. *Foundational, core-dependent.*
- **#348 Unified AI Management Layer for Core** — a single Core plane for structured **permissions + usage metering/budgets + capability-aware provider routing**, consolidating ~6 fragmented community plugins; hooks the existing `wp_ai_client_prevent_prompt` filter (zero breaking changes). **Open:** allow- vs **deny-by-default** (commenters favor deny). ⭐ *Major bet.*
- **#354 Unified Abilities exposure controls** — central per-"surface" control over which abilities are exposed where (every MCP server auto-becomes a surface); overlaps #348. Warns: without this, every plugin ships its own surface → mess.
- **#736 Per-feature role/user access controls** *(In progress, Future Release; PR #749 by Infinite-Null — DIRTY with CHANGES_REQUESTED)* — expose role/user access controls per Experiment/feature; complements the #348/#354 governance cluster at the feature granularity. The only one of last window's three re-milestoned cards **not** pulled back into a dated lane.
- **#21 Supporting thousands of abilities** *(Question)* — exposing every ability 1:1 as an MCP tool degrades model selection. Proposes a **layered-tool pattern** (3 tools: `get_abilities_by_category` / `get_ability_info` / `use_ability`) with a category taxonomy.
- **#430 Skills in a WordPress admin context** — map "Skills" into WP (Command Palette `/audit-accessibility`); gziolo is evolving the **Guidelines CPT → Skills** in Gutenberg. **Open:** split user-authored prompts/workflows from full agent Skills with script execution (script bundling is the blocker). ⭐ *Major bet, cross-repo (Gutenberg).*
- **#448 WebMCP experiment** — integrate `navigator.modelContext.registerTool` so a browser-native agent can drive WP. **Risk:** WebMCP is an **unstable W3C Community Group draft**, no browser ship commitment; lean on a polyfill + Experiment status for easy retirement. ⚠️ *Speculative.*
- **#37 MCP usage & request routing** — make the plugin a **reference MCP implementation** (route an Experiment via MCP; reusable adapter; provider switching).
- Supporting: **#233** (*now 1.3.0, In progress — and correctly linked: PR [#905](https://github.com/WordPress/ai/pull/905) declares `Closes #233` and **deprecates** rather than deletes the layer, after its predecessor #898 closed unmerged*), **#203** (extensibility hook for Ability Table columns, Future Release), **#307** (AGENTS.md), **#32** (AI Playground debug tool), plus **`core/read-content`** (#739, merged Done in 1.2.0), **`core/manage-settings`** (#764, 1.3.0), **`core/read-nav-menus`** (#858, 1.3.0), and the standalone-abilities toggle (**#863, now In progress under 1.3.0**, with PR **#881 out of draft** and now carrying an authoritative `Closes #863`). **`core/read-users`** (#774) merged earlier; off-board #856 is no longer open. Abilities Explorer custom-provider support (#883) shipped via PR #884 and was de-carded this window. The experiment `register()` → `init()` rename (#145) shipped board-Done earlier. Upstream `WordPress/abilities-api` **#84** (generic CRUD across post types; client vs server `execute_callback`) remains open, but is no longer on Project #240.

### B. Connectors, Providers & Model Management
Direction settled: **thin core Connectors screen discovering independent per-provider plugins** (the bundle-everything path, PR #148, was abandoned).

- **#502 Provider plugin discovery/curation/labeling** — the strategic parent. Three unresolved axes: discovery model (hardcoded list vs WP.org Plugins API vs `connector` tag), curation/"vetted" concept, and official-vs-third-party labeling.
- **#27 Surface additional provider plugins on Connectors** *(1.4.0)* — list third-party providers + "progressive provider selection" (hide UI when a valid provider exists); host pre-config via constants/filters. **Strong demand for OpenRouter** (one key, many models).
- **#262 Provider-level model bucketing** — replace hard-coded model priority lists with a user-facing **provider preference** (not specific models); future capability tiers (fast/cheap vs high-reasoning). *Scope being questioned now that a per-experiment "developer mode" already exposes provider+model.*
- **#191 Settings + provider import/export** *(✅ shipped — PR #734 merged 2026-07-24 under 1.3.0; de-carded from the board this window)* — portability for agencies/hosts/multisite finally landed; the secure-credential-handling debate that held it up is resolved in the merged implementation.
- **#632** *(board-Done / closed)* deactivate a connector without losing its key · **#660** *(Needs review / 1.3.0; PR #759)* clearer "blocked by Connector Approvals" error · **#815** *(1.2.0, board-Done via PR #830 and now de-carded)* surface an admin notice when Connector Approvals still needs the AI plugin granted access to a connected provider (WPORG support report; related to #660).

### C. Content & Editorial Experiments (the authoring lifecycle)
Expanding from per-field generators toward full co-authoring.

- **#297 Content Generation** — native Block Editor **co-author** (first drafts from title, expand sections, rewrite selection; `/ai` slash command, ghost-typing, accept/reject diffs). Well-specified, awaiting design (karmatosed). ⭐ *Major bet.*
- **#324 Evolve "Refine" → agentic/collaborative editorial** *(1.4.0)* — a "WordPress AI" user editing live via Gutenberg **Real-Time Collaboration**; deferred to let RTC stabilize. ⭐ *Major bet.*
- **#338 Analytics-aware content & amplification** *(**moved In discussion → In progress** this window; assignee zeus2611)* — content-gap mining (low-engagement on-site searches) + traffic-surge social amplification, via a `Stats_Provider` adapter (**Jetpack Stats first**); split into two sub-issues. ⭐ *Major bet — closes ideation→distribution loop.* No PR yet, so the status move reflects intent rather than code.
- **#625 Social Content Generation** *(**moved In discussion → In progress** this window; assignee Malayt04)* — platform-specific posts (Bluesky/Mastodon/LinkedIn) from post content; persist to meta; hooks for Jetpack Social/Blog2Social. Also has no PR yet.
- **#508 "Suggest Reply"** for comments + Activity widget *(shipped in 1.2.0 via PR #724; now de-carded from the board)* — the 1.2.0 lane's first genuinely new experiment (re-introduces #155's removed feature properly; human review, **not** auto-reply).
- **#875 Internal-link suggestions** and **#876 permalink-slug suggestions** *(**both pulled back into 1.3.0** after nine days in Future Release; both In progress)* — the newest editorial pair, with implementation PRs #887 (Infinite-Null, now DIRTY) and #897 (milindmore22), both still CHANGES_REQUESTED. The round trip 1.4.0 → Future Release → 1.3.0 in two windows is scheduling churn, not progress: where these surface in the editor is still the open product question, and neither PR has cleared review.
- **Reusable control layer:** tone (#186), multilingual rewriting/translation (#187, *✅ board-Done under 1.3.0 — PR #747 merged 2026-07-28*), persona/voice (#188).
- Enhancements: **#614** bulk summary generation *(Done in 1.2.0)* · **#90** consolidate Title Generation options · **#507** Editorial Updates → Visual Revisions *(✅ shipped — PR #861 merged 2026-07-24; de-carded this window)* · **#452** classification relevance *(✅ shipped — PR #633 merged 2026-07-21; de-carded this window)*.

### D. Agentic / Chat / Site-Agent + Media
The biggest **directional shift** — from single-task helpers to a conversational agent that takes actions. Three convergent issues:

- **#142 Frontend chat agent** — "chat with my site" for public **visitors** (RAG over owner-selected content + FAQ, citations). Designed proposal; needs an embeddings/indexing pipeline (shared with #282).
- **#282 Admin "AI Workspace"** — full-screen wp-admin multi-step chat (Site-Editor-styled, DataViews), capability-gated Search/RAG middleware, actionable artifacts ("Create Draft"). Most fleshed-out spec; assigned karmatosed for mockups.
- **#189 Site Agent** — natural language → **explicit, verifiable WP actions** (create posts, install plugins, change settings). Opt-in, disabled by default, capability-respecting, fully auditable. ⭐ *Major bet (idea-stage).*
- **#190 Site-wide insights** — read-only cross-content analysis (themes/gaps/trends); the safe data layer feeding the agentic surfaces.

**Media & Vision:** focus-aware crop suggestions (#238) · integrate media experiments with Gutenberg's experimental **Media Editor** (#325) · **C2PA** provenance detection on upload (#421, *1.3.0, now In progress* — PR #459 is its authoritative closing PR) · alt-text button placement (#425, **Blocked**; the volunteer implementation PR #885 was closed unmerged on 2026-07-20, so the issue is again unimplemented).

**Search/RAG:** two parallel efforts. Native vector search (#683, draft PR, 1.3.0) is the board-tracked MariaDB-backed semantic-search/RAG experiment with fallback post-meta embeddings; separately, **#844 semantic search in wp-admin** moved Backlog → In progress behind PR #891. Underneath both, off-board PR **#892** vendors PHP AI Client embedding support into the plugin behind an `SDK_Overlay` — needed because the core route (`wordpress-develop#12530`) slipped from WP 7.1 to 7.2.

**Extensibility & community:** custom prompt-template hooks (#192, *✅ shipped — PR #770 merged 2026-07-20; de-carded this window*) · developer-only request/response log panel (#193, *✅ closed 2026-08-05 as already delivered by PR #437 and re-milestoned to 1.0.0*) · Comment Moderation value/relevance scoring (#514, PR #681) · low/no-tech educational content for the WP 6.9 launch (#47) · **board-new #918**, an AI-generated `/llms.txt` site index for agent consumption (Triage, unmilestoned; the differentiator claimed over existing SEO-plugin implementations is that descriptions are AI-generated via `core/read-content` and the summarization abilities).

---

## 7. Unplanned / undecided / blocked

- **20 In discussion / Needs decision cards** = 18 issues + exploratory PRs #211 and #224. Down from 22: **#338** and **#625** both moved to In progress, the first movement out of this status in three windows — though neither has a PR, so the moves record intent, not code.
- **3 Triage issues:** #40 (Core Abilities, Future Release), #890 (mobile right-sidebar display component, unmilestoned, still no discussion after three weeks), and board-new **#918** (AI-generated `/llms.txt`, unmilestoned; its one comment is jeffpaul asking whether the standard itself is settled enough to build on). #869 left Triage by being closed `NOT_PLANNED`.
- **Blocked direction:** #425 still depends on a usable Media Editor surface; PR #494 remains the corresponding blocked implementation — and its `#238` link is now the **only** fallback-parsed relationship left anywhere in the census.
- **Review-ready issues: three, up from one, all under 1.3.0** — **#660** (provider-approval error copy, PR #759), plus **#866** (post-meta `wpai_` prefix, PR #867) and **#906** (reserved log-type API, PR #914), both moved In progress → Needs review this window. All three of their PRs are unmergeable.
- **Board hygiene:** merged PR #484 still shows Needs review under 0.9.0; PR #621 shows Done despite being closed unmerged; and dependabot PR **#922** joined them this window — closed unmerged, carded, and marked Done the same day.
- **⚠️ Roadmap-visibility gap — same size, materially lighter contents:** **six** open PRs still have no board representation, but the composition changed for the better. Cleared: **#905** now declares `Closes #233` (and was softened from deleting the `AI_Service` layer to deprecating it), **#889** was given a board PR card, and **#913 merged** — though it merged *uncarded*, so a change to the default Anthropic/Google/OpenAI models plus the deprecation of the public `wpai_meta_description_result_temperature` filter entered `develop` with no board trace at all. Carried over for a third window: **#888** (a complete Text to Speech experiment registering `ai/speech-generation` and `ai/speech-import` abilities, gated on `ai-provider-for-openai#42` / `ai-provider-for-google#31`) and **#892** (PHP AI Client embeddings vendored via `SDK_Overlay`), plus **#909** (encryption-experiment docs and caller attribution). New: **#915** (Content Resizing preserves inline HTML — a two-line fix swapping `getBlockText` for `getBlockHTML`), **#916** (Content Classification taxonomy-specific error copy), and **#917** (focus the Accept button when Content Resizing finishes). The three newcomers are ordinary contributor polish; the residual risk is concentrated in #888 and #892, which remain large, load-bearing, and invisible.
- **Key open decisions:** ability governance/granularity (#40/#348/#354/#863 — the upstream half moved when `mcp-adapter#254` merged, and #863 is now In progress with a non-draft PR), WebMCP standard risk (#448), provider discovery (#27/#502), where internal-link/slug suggestions should surface (#875/#876, now scheduled into 1.3.0 with the product question still open), whether Text to Speech (#888) becomes a carded experiment, whether #918's `llms.txt` proposal is in scope for this plugin, and whether #621's abandoned uploads-URL hardening is worth reopening.

---

## 8. Strategic read & risks

**Where it is heading:** discrete AI helpers are becoming a governed, agent-capable WordPress platform. Abilities provide the action primitive; Connectors and model preferences provide provider independence; editorial experiments provide user-facing workflows; search/RAG, MCP/WebMCP, and site-agent ideas connect those layers.

**Watch-items / risks:**

1. **External dependencies** — WordPress core, the AI Client, Gutenberg Media Editor/RTC/Guidelines work, and abilities-api can change delivery paths without changing Project #240. The WP 7.1 → 7.2 slip of core embedding support (`wordpress-develop#12530`) already pushed the plugin to vendor PHP AI Client embedding code itself (#892). The pattern is repeating one layer up: php-ai-client **#273** now adds an *automatic function-call resolution loop* to the client, the agentic primitive the plugin's own chat/site-agent bets (#142/#282/#189) would otherwise have to build.
2. **Governance before write abilities** — #863 makes the safety question concrete: standalone/read abilities are currently always registered, while future write abilities need deliberate enablement and discoverability controls. #888 would add two more (`ai/speech-generation`, `ai/speech-import`) outside that conversation. Both halves moved this window: upstream `mcp-adapter#254` merged last window, and the plugin-side toggle #863 is now In progress under 1.3.0 with PR #881 out of draft — but the PR has failing checks and no review.
3. **Backlog-to-commitment gap — narrowed on paper only.** Future Release fell 44 → 40 as #233/#875/#876 were pulled into 1.3.0, which grew 15 → 21. No card moved because it was closer to done; the same work is now labelled with a release. v1.4.0 remains two undecided issues with no implementation at all, and was skipped over by this window's reloading.
4. **Compatibility regressions** — #869 was closed `NOT_PLANNED` as not reproducible after three windows of waiting for a clean-environment repro. The underlying `Asset_Loader::add_global_data()` behavior it described was never disproved, only never reproduced; if the reporter returns with a repro this comes back.
5. **Board ≠ repo — improving, but the merge-without-a-card case is now proven.** 21 of 36 open PRs lack a PR card and **6 have no roadmap link at all**. The qualitative picture improved sharply — #905 now links to #233, #889 is carded — but **#913 demonstrated the failure mode end to end**: it changed user-facing model defaults, deprecated a public filter, and **merged into `develop` without ever appearing on the board**. The gap is no longer just work the board can't see; it is work the board never saw and now never will.
6. **Board status is not delivery status** — #484 remains non-Done despite being merged; #621 is Done despite being closed unmerged; **#922** repeated that pattern this window; and #193 reached Done for work delivered several releases earlier. Counts require reconciling board status against `state`/`mergedAt`.
7. **Board totals are not scope** — the board was *flat* at 269 this window while six cards left and six arrived, and the PR/issue mix moved 209/60 → 214/55. A stable total can hide complete turnover; check `.board.added`/`.board.removed`, not the count.
8. **Review throughput is the binding constraint, and it did not move.** Zero of 36 open PRs carry an approving review, all are BLOCKED (24) or DIRTY (12), 16 have failing checks, and CHANGES_REQUESTED holds at 14. The whole window produced three readiness changes. Upstream makes the contrast concrete: `php-ai-client` recorded **three APPROVED reviews** in the same period, the first the radar has ever seen on either upstream repository.

---

## 9. Appendix — full open-issue tracker (51)

> 📄 Deep dossiers live in [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md). The current scope is **51 board-open issues**: 50 in `WordPress/ai` plus Google-provider issue #23. PR cards are tracked separately in [`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md).

Grouped by current board status. Theme tags are editorial aids; Status and Milestone come from Project #240.

### In discussion / Needs decision (18)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#21](https://github.com/WordPress/ai/issues/21) | Future | Platform | — | How to best support hundreds or thousands of abilities |
| [#23](https://github.com/WordPress/ai-provider-for-google/issues/23) | 1.2.0 | Bug/Providers | — | [Bug]: Image Generation fails with "Unexpected Google API response: Missing the candidates[0].content key" |
| [#27](https://github.com/WordPress/ai/issues/27) | 1.4.0 | Providers | — | Display additional AI provider plugins on Connectors page (alongside default Anthropic, Google, and OpenAI ones) |
| [#37](https://github.com/WordPress/ai/issues/37) | Future | Platform | — | MCP usage across features and request routing |
| [#47](https://github.com/WordPress/ai/issues/47) | Future | Community | — | Low-/no-tech educational content |
| [#90](https://github.com/WordPress/ai/issues/90) | Future | Content | — | Clarify and consolidate Title Generation options in UI and Experiment settings |
| [#262](https://github.com/WordPress/ai/issues/262) | Future | Providers | — | Provider-Level Model Bucketing for Model Selection |
| [#324](https://github.com/WordPress/ai/issues/324) | 1.4.0 | Content | — | Evolve Refine from Notes into collaborative and agentic editorial workflows |
| [#348](https://github.com/WordPress/ai/issues/348) | Future | Platform | — | Feature Request: Unified AI Management Layer for WordPress Core |
| [#354](https://github.com/WordPress/ai/issues/354) | Future | Platform | — | Unifiied Abilities exposure controls |
| [#425](https://github.com/WordPress/ai/issues/425) | Future | Agentic/Media | — | Update placement of Alt Text generation buttons |
| [#430](https://github.com/WordPress/ai/issues/430) | Future | Platform | — | Skills in a WordPress admin context |
| [#448](https://github.com/WordPress/ai/issues/448) | Future | Platform | — | Add WebMCP experiment |
| [#502](https://github.com/WordPress/ai/issues/502) | Future | Providers | — | Define how AI provider plugins are discovered, labeled, and surfaced in Connectors |
| [#600](https://github.com/WordPress/ai/issues/600) | Future | Bug/Infra | — | `Enable AI` header toggle doesn't reflect aggregate state of sub-features |
| [#643](https://github.com/WordPress/ai/issues/643) | Future | Bug | — | "AI" plugin 1.0.1 – Connectors and AI settings pages load blank (JavaScript error) on WordPress 7.0 |
| [#741](https://github.com/WordPress/ai/issues/741) | 1.3.0 | Bug/Infra | prasadkarmalkar | AI Admin Pages Exhibit Visible Flicker During Initial Render |
| [#791](https://github.com/WordPress/ai/issues/791) | Future | Content | — | Add loading animation/custom cursor for Type Ahead |

### In progress (18)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#203](https://github.com/WordPress/ai/issues/203) | Future | Platform | — | Add extensibility hook for custom Ability Table columns |
| [#233](https://github.com/WordPress/ai/issues/233) | 1.3.0 | Platform | — | ⚠️ Refactor experiments to leverage AI_Service layer — *title still says "leverage"; closing PR #905 deprecates the layer instead (now `closing`-linked, was 1.4.0-era Future Release)* |
| [#238](https://github.com/WordPress/ai/issues/238) | Future | Agentic/Media | TylerB24890 | Add focus-aware crop suggestions |
| [#307](https://github.com/WordPress/ai/issues/307) | Future | Platform | gziolo | Add AGENTS.md to streamline contributor onboarding |
| [#325](https://github.com/WordPress/ai/issues/325) | Future | Agentic/Media | TylerB24890 | Integrate media features and experiments with Gutenberg's experimental Media Editor |
| [#338](https://github.com/WordPress/ai/issues/338) | Future | Content | zeus2611 | New Experiments: Analytics-aware content and amplification recommendations *(moved from In discussion; no PR yet)* |
| [#421](https://github.com/WordPress/ai/issues/421) | 1.3.0 | Agentic/Media | — | WordPress should detect C2PA manifests on upload |
| [#514](https://github.com/WordPress/ai/issues/514) | 1.3.0 | Content | — | Add comment value / relevance to Comment Moderation experiment |
| [#625](https://github.com/WordPress/ai/issues/625) | Future | Content | Malayt04 | New Experiment: Social Content Generation for platform-specific social posts *(moved from In discussion; no PR yet)* |
| [#689](https://github.com/WordPress/ai/issues/689) | Future | Infra | i-anubhav-anand | Add a user-facing control for automatic log cleanup |
| [#690](https://github.com/WordPress/ai/issues/690) | 1.3.0 | Infra | hbhalodia | Plugin does not clean up database table and options on uninstall |
| [#732](https://github.com/WordPress/ai/issues/732) | 1.3.0 | Bug/Infra | — | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible |
| [#736](https://github.com/WordPress/ai/issues/736) | Future | Platform | — | Expose role/user access controls per feature/experiment *(still Future Release — the one re-milestoned card not pulled back)* |
| [#844](https://github.com/WordPress/ai/issues/844) | Future | Agentic/Media | priyanshuhaldar007 | New Experiment: Semantic search in wp admin |
| [#845](https://github.com/WordPress/ai/issues/845) | 1.3.0 | Infra | dkotter | New Experiment: Markdown feeds (powered by `html-to-md`) |
| [#863](https://github.com/WordPress/ai/issues/863) | 1.3.0 | Platform | hbhalodia | New Experiment: Abilities toggle *(moved from To do; PR #881 out of draft and now `closing`-linked)* |
| [#875](https://github.com/WordPress/ai/issues/875) | 1.3.0 | Content | Infinite-Null | New Experiment: Suggest internal links within post content *(pulled back from Future Release)* |
| [#876](https://github.com/WordPress/ai/issues/876) | 1.3.0 | Content | milindmore22 | New Experiment: Suggest permalink slugs *(pulled back from Future Release)* |

### Backlog (6)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#142](https://github.com/WordPress/ai/issues/142) | Future | Agentic/Media | — | Frontend chat agent powered by site content |
| [#186](https://github.com/WordPress/ai/issues/186) | Future | Content | — | Add tone adjustment controls for AI-generated content |
| [#188](https://github.com/WordPress/ai/issues/188) | Future | Content | — | Add persona-driven content generation experiments |
| [#189](https://github.com/WordPress/ai/issues/189) | Future | Agentic/Media | — | Explore an admin Site Agent for executing WordPress actions |
| [#282](https://github.com/WordPress/ai/issues/282) | Future | Agentic/Media | karmatosed | Chat experiment: Integration outside the editor and outside single-task AI use |
| [#297](https://github.com/WordPress/ai/issues/297) | Future | Content | karmatosed | New experiment: Content Generation |

### To do (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#32](https://github.com/WordPress/ai/issues/32) | Future | Infra | — | Add AI Playground interface (prompt testing & debug tools) |
| [#190](https://github.com/WordPress/ai/issues/190) | Future | Agentic/Media | yogeshbhutkar | Add site-wide AI-powered content insights |
| [#339](https://github.com/WordPress/ai/issues/339) | Future | Bug | — | AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin |

### Triage (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#40](https://github.com/WordPress/ai/issues/40) | Future | Platform | gziolo, jorgefilipecosta | WordPress Core Abilities |
| [#890](https://github.com/WordPress/ai/issues/890) | — | UI/Mobile | — | Add mobile right sidebar display component |
| [#918](https://github.com/WordPress/ai/issues/918) | — | Platform | — | **Board-new** — Feature: AI-generated `llms.txt`, a curated LLM-friendly site index served at `/llms.txt` |

### Needs review (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#660](https://github.com/WordPress/ai/issues/660) | 1.3.0 | Providers | — | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals |
| [#866](https://github.com/WordPress/ai/issues/866) | 1.3.0 | Bug/Infra | hbhalodia | Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix *(moved from In progress; PR #867)* |
| [#906](https://github.com/WordPress/ai/issues/906) | 1.3.0 | Infra | azizulhasan | Request Logging: no public API to record the reserved `mcp_tool` and `ability` log types *(moved from In progress and milestoned into 1.3.0; PR #914)* |

**Removed-board reference:** [`WordPress/abilities-api#84`](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not counted in Project #240.

---

## 10. How to refresh this document

> ⚙️ **Automated path:** [`wp-ai-roadmap-refresh.sh`](./wp-ai-roadmap-refresh.sh) does everything below in one command — re-pulls the board, diffs against the last snapshot (added / newly-Done / merged / status & milestone moves / removed), fetches the full PR/release census for all repositories declared through [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json), refreshes the curated dependency watchlist, and can append a changelog row (`--update-changelog`). Run with no args for a read-only report; add `--save` to roll all board, repository, release, and dependency baselines forward. The manual recipe below is what it automates.
>
> **Normal vs. strict refresh.** The default (normal) refresh is *warning-only*: any data-quality or coverage problem — an unreachable dependency, a substantive open PR with no board representation — is reported in the output (`.validation` in JSON, stderr lines otherwise) but never blocks the board report, and the run exits `0`. `./wp-ai-roadmap-refresh.sh --strict [--json]` runs the same read-only pipeline as an **audit**: it emits the complete report first, then exits `2` when any validation error remains (exit `1` is reserved for operational failures that prevented a report at all). A strict failure also suppresses `--save` and `--update-changelog` ("persistence skipped"), so a red audit never rolls the baseline forward.
>
> Strict is a **scheduled visibility audit, not a merge gate**: whether every substantive `WordPress/ai` PR is linked to Project #240 depends on upstream contributor behavior, so a persistent red result means *unresolved roadmap visibility* (work in flight that the board doesn't show), not a broken tracker. Point-in-time coverage: 36 open PRs = 15 direct board PR cards + 15 linked to board issues (**all 15 via authoritative `closing` references** — the last fallback-parsed link, #881→#863 by branch name, was replaced by a real `Closes` this window) + 0 routine dependency PRs + 6 unexplained (#888, #892, #909, #915, #916, #917 — the current strict-audit failures). Three failures cleared (#889 carded, #905 `closing`-linked, #913 merged) and three new ones opened, so the count held at six while the set half turned over.
>
> **Cold-query caveat, now handled by the script.** GitHub computes PR mergeability lazily, so a first census can answer `mergeStateStatus: "UNKNOWN"` for PRs nothing has touched — this window's first run reported 27 of 36 that way. `fetch_pr_census()` now re-asks once and keeps whichever answer knows more, warns (`pr-mergestate-unknown`, never an error) if any PR stays cold, and the PR diff ignores transitions into or out of `UNKNOWN`. Without that, one cold run reports every open PR as newly unreadable *and* persists the sentinel into the baseline, so the next window reports them all again in reverse.

**Prerequisite:** a `gh` login whose token has the `read:project` scope (fine-grained PATs scoped to a personal account **cannot** read the WordPress org project — even though it's public; use a classic-token login):

```bash
gh auth refresh -h github.com -s read:project
```

**1. Pull the full board** (paginated GraphQL → raw JSON). Save this query as `proj240.graphql`:

```graphql
query($org: String!, $number: Int!, $endCursor: String) {
  organization(login: $org) {
    projectV2(number: $number) {
      title shortDescription url
      items(first: 100, after: $endCursor) {
        totalCount pageInfo { hasNextPage endCursor }
        nodes {
          type
          fieldValues(first: 25) { nodes { __typename
            ... on ProjectV2ItemFieldSingleSelectValue { name field { ... on ProjectV2FieldCommon { name } } }
            ... on ProjectV2ItemFieldTextValue   { text field { ... on ProjectV2FieldCommon { name } } }
            ... on ProjectV2ItemFieldDateValue   { date field { ... on ProjectV2FieldCommon { name } } }
            ... on ProjectV2ItemFieldNumberValue { number field { ... on ProjectV2FieldCommon { name } } }
            ... on ProjectV2ItemFieldIterationValue { title startDate field { ... on ProjectV2FieldCommon { name } } } } }
          content { __typename
            ... on Issue { number title url state stateReason repository { nameWithOwner }
              labels(first:20){nodes{name}} assignees(first:10){nodes{login}} milestone{title}
              createdAt updatedAt closedAt comments{totalCount} }
            ... on PullRequest { number title url state isDraft repository { nameWithOwner }
              labels(first:20){nodes{name}} assignees(first:10){nodes{login}} milestone{title}
              createdAt updatedAt closedAt mergedAt }
            ... on DraftIssue { title assignees(first:10){nodes{login}} } } } } } } }
```

```bash
gh api graphql --paginate -f query="$(cat proj240.graphql)" -F org=WordPress -F number=240 > proj240_raw.json
```

**2. Normalize to flat items** (flattens custom fields into a `fields` object):

```bash
jq -s '[ .[].data.organization.projectV2.items.nodes[] ] | map({
  type:.type, itype:.content.__typename, number:.content.number, title:.content.title,
  url:.content.url, repo:.content.repository.nameWithOwner, state:.content.state,
  mergedAt:.content.mergedAt, milestone:.content.milestone.title,
  labels:[.content.labels.nodes[]?.name], assignees:[.content.assignees.nodes[]?.login],
  fields:( [ .fieldValues.nodes[] | select(.field.name!=null) |
    {key:.field.name, value:(.text // .name // (.date|tostring) // (.number|tostring) // .title)} ] | from_entries ) })' \
  proj240_raw.json > proj240_items.json
```

**3. Re-derive the key views:**

```bash
# Status distribution
jq -r 'group_by(.fields.Status)[] | "\(length)\t\(.[0].fields.Status)"' proj240_items.json
# All open issues (the roadmap), by status + milestone
jq -r '[.[]|select(.itype=="Issue" and .fields.Status!="Done")] | sort_by(.fields.Status,(.number)) | .[] |
  "[\(.fields.Status)] \(.milestone//"—") #\(.number) \(.title)"' proj240_items.json
# Milestone × Done/Open
jq -r 'group_by(.milestone)[] | "\(.[0].milestone//"(none)")\tTot:\(length)\tDone:\([.[]|select(.fields.Status=="Done")]|length)"' proj240_items.json
```

When refreshing: update the **Data snapshot** date in the header, re-check the §2 milestone table and §9 tracker, and add a §11 changelog entry.

---

## 11. Changelog

| Date | Change |
|---|---|
| 2026-08-10 | **Live refresh vs the 2026-08-01 14:58 UTC baseline — a bookkeeping window: nothing shipped, but the board got measurably more accurate.** Board **flat at 269**, with total turnover underneath: **6 removed** (already-Done #191/#192/#452/#507/#874 from 1.3.0 + unmilestoned #883 — the sixth post-release de-carding pass) and **6 added**, so the mix moved **209 PRs + 60 issues → 214 + 55**. Done **203 → 202**; non-Done **66 → 67** = **51** open issues (was 52) + **16** PR cards (15 open + stale merged #484). Status: In progress **26 → 29**, In discussion **22 → 20**, Needs review **4 → 6**, Backlog **7 → 6**, To do **4 → 3**, Triage **3**. **Neither newly-Done card is delivery:** **#193** (developer log panel) was closed "by #437" — work already in the product — and retro-milestoned **Future Release → 1.0.0**; **#869** (provider-data iframe mismatch) was closed **`NOT_PLANNED` as not reproducible** after three windows of waiting on a clean-environment repro. Additions were four dependabot PRs (#919/#921 merged, **#922 closed unmerged yet marked Done**, #920 open), a11y PR **#889** (finally carded — it was an unexplained PR last window), and one board-new Triage issue **#918** (AI-generated `/llms.txt` site index). **All five milestone moves pulled work toward a release, reversing last window:** #875 and #876 came back from Future Release into **1.3.0** only nine days after being pushed out of 1.4.0; #233 moved in from Future Release; #906 was milestoned from nothing. **1.3.0 23 → 26 carded (8 Done/15 open → 5 Done/21 open = 13 issues + 8 PRs); Future Release 46 → 42 (44 → 40 open); 1.4.0 untouched at 2 undecided issues with no code — the reloading skipped it.** Status moves: **#338** and **#625** In discussion → In progress (neither has a PR), **#863** To do → In progress, **#760** Needs review → In progress, **#866** and **#906** In progress → Needs review. Repo census **33 → 36 open PRs** = **15 direct + 15 linked + 0 routine + 0 off-board + 6 unexplained**, and **all 15 issue links are now authoritative `closing` references** — the last fallback (#881→#863 by branch) became a real `Closes`. **The unexplained count held at six while half the set turned over, and the two worst entries resolved:** **#905** was retitled *remove* → **"Deprecate the AI_Service layer"** after dkotter argued the class and `get_ai_service()` are public surface, and now declares **`Closes #233`** — so last window's "the board can be actively wrong" case is corrected and #233 sits In progress under 1.3.0 with an authoritative closing PR; **#889** was carded; **#913 merged 2026-08-07 — uncarded**, so a default-model switch and the deprecation of the public `wpai_meta_description_result_temperature` filter entered `develop` with no board trace at all. Carried for a third window: **#888**, **#892**; still uncarded: **#909**. New and materially lighter: **#915** (Content Resizing preserves inline HTML), **#916** (taxonomy-specific classification errors), **#917** (focus Accept on completion). **Readiness did not move:** all 36 open PRs BLOCKED (24) or DIRTY (12), **zero approvals**, 16 failing checks, CHANGES_REQUESTED flat at **14**; only three real changes all window (#881 out of draft, #887 → DIRTY, #914 checks green). Upstream radar reversed direction for the first time: `php-ai-client` **24 → 26** (**#271** `isSupported()` bool contract, **#273** automatic function-call resolution loop + `withMessages()`) with the **first three APPROVED reviews the radar has recorded** (#231/#250/#254); `mcp-adapter` **20 → 19**, its first decline (#262 merged and #256 closed unmerged against draft #277 opening; #260 BLOCKED → DIRTY as the predicted overlap collided). No release anywhere for three windows. Dependency watchlist static at **16** (10 open/3 closed/3 merged) for a third window. **Tooling fix:** the census now detects GitHub's lazily-computed `mergeStateStatus: "UNKNOWN"` (27 of 36 PRs on this window's cold run), re-queries once, warns rather than errors if it persists, and ignores UNKNOWN transitions in the PR diff — without it this refresh would have logged 24 phantom readiness changes and saved them as the baseline. Script passes `bash -n`, **seven** offline fixture suites (new `-mergestate.sh`), and the live 16-ID dependency smoke test; all eight snapshots rolled forward. |
| 2026-08-01 | **Live refresh vs the 2026-07-27 08:51 UTC baseline — a re-scheduling window in which the board drifted out of sync with the repository.** Board **274 → 269** = 209 PRs + **60** issues; Done **207 → 203**; non-Done **67 → 66** (52 open issues, flat, + 15 → **14** PR cards). Status: In progress **26** and In discussion **22** flat, Needs review **5 → 4**, Backlog **7**, To do **4**, Triage **3**. The total fell through **7 de-cardings** (#614/#778/#853/#864/#865/#870/#872), not descoping. **Only three cards reached Done and only one shipped:** **#187** (multilingual rewriting/translation) closed 2026-07-28 via merged PR **#747**; PR card **#621** was **closed unmerged** after weeks of contributor silence yet marked Done with its 1.3.0 milestone stripped, so its uploads-URL hardening is *not* in `develop`; and **#900** was webinar spam carded, closed, and Done'd the same day. Two cards added — spam #900 and substantive **#906** (Request Logging has no public API for the reserved `mcp_tool`/`ability` types; PR **#914** followed on 2026-08-01 with a proper `Closes #906`). **Milestone moves ran three-to-one against the dated lanes:** #736 (1.3.0 → Future Release) and #875/#876 (1.4.0 → Future Release), all three still In progress with PRs that each drew CHANGES_REQUESTED, plus #621's milestone stripped on close. **1.3.0 27 → 23 carded (9 Done/18 open → 8 Done/15 open); 1.4.0 4 → 2, both In discussion — nothing in that lane is being built; Future Release 43 → 46 (41 → 44 open).** Repo census **32 → 33 open PRs** = **13 direct + 14 linked + 0 routine + 0 off-board + 6 unexplained** — the visibility gap doubled and changed in kind: alongside carried-over #888/#892/#889, new **#905** *deletes* the `AI_Service` layer, resolving card **#233** opposite to its own title after adoption PR #898 closed unmerged; **#913** switches default Anthropic/Google/OpenAI models, removes temperature setting, and deprecates the public `wpai_meta_description_result_temperature` filter; **#909** rewrites encryption-experiment docs and fixes caller attribution. None declares a `closing` reference. **Readiness worsened:** all 33 open PRs BLOCKED (21) or DIRTY (12), zero approvals, 17 failing checks, CHANGES_REQUESTED **11 → 14**. Upstream radar: `php-ai-client` **21 → 24** (#266/#267/#269, the last adding OCR/document parsing) / 1.4.0; `mcp-adapter` **16 → 20** (#251 and #254 merged; #258/#259 and the overlapping #260/#262/#263/#264 cluster opened) / v0.5.0 — neither cut a release. Dependency watchlist static at **16** (10 open/3 closed/3 merged) for a second window. §3 now marks `AI_Service` as being removed; §8 adds review throughput as a named risk. Script passes `bash -n`, the six offline fixture suites, and the live 16-ID dependency smoke test; all eight snapshots rolled forward. |
| 2026-07-27 | **Live refresh vs the 2026-07-20 06:15 UTC baseline — the post-1.2.0 cleanup-and-execute window.** Board **283 → 274** = 209 PRs + **65** issues; Done **209 → 207**; non-Done **74 → 67** (57 → **52** open issues + 17 → **15** PR cards). The drop is board hygiene, not descoping: **10 already-Done cards de-carded** (#508/#793/#809/#815/#816/#818/#833/#839/#846 from the shipped 1.2.0 lane + spam #848) against **1 added** (unmilestoned Triage issue **#890**, mobile right-sidebar component). **8 cards newly Done — six of them 1.3.0 issues closed by merged PRs:** #191←#734 (settings import/export), #192←#770 (prompt-template extension points), #452←#633 (taxonomy relevance), #507←#861 (Editorial Updates → Visual Revisions), #874←#886 (Yoast meta-description interop, root-caused to Yoast's own store + `post`-only REST meta), #883←#884 (Abilities Explorer custom providers + statistics); plus PR cards #882 (merged) and #851 (PoC closed unmerged). **5 status moves, all into In progress** as implementation PRs opened: #233←#898, #421←#459, #844←#891, #875←#887, #876←#897 — so **v1.4.0 is no longer purely discussion-stage**. **3 milestone moves:** #192 Future Release → 1.3.0, #874 — → 1.3.0, #851 Future Release → —. Status totals: In progress **26** (unchanged), In discussion **24 → 22**, Backlog **8 → 7**, Needs review **7 → 5**, To do **6 → 4**, Triage **3**. Milestones: 1.2.0 **21 → 13** (12 Done / 1 open), **1.3.0 25 → 27 (9 Done / 18 open)**, 1.4.0 **4** (2 In progress / 2 In discussion), Future Release **45 → 43** (41 non-Done), no-milestone **29 → 28**. Repo census **37 → 32 open PRs** = **14 direct + 15 linked + 0 routine + 0 off-board + 3 unexplained**; 12 PRs left (10 merged incl. the former audit failures **#877/#878**; #851 and #885 closed unmerged) and 7 opened. **The new unexplained set is materially bigger than the old one:** #888 adds a whole **Text to Speech** experiment (+4,216/28 files, two new abilities, gated on `ai-provider-for-openai#42` / `ai-provider-for-google#31`), #892 vendors **PHP AI Client embeddings** behind an `SDK_Overlay` (+4,394 lines) because core embedding support slipped WP 7.1 → 7.2 (`wordpress-develop#12530`), and #889 is a request-log a11y fix whose body still has an unfilled `Closes #<issue-number>`. Latest release unchanged at **v1.2.0** (2026-07-14; 18 shipped). Upstream radar moved: `php-ai-client` **20 → 21** open PRs (new #264) / 1.4.0; `mcp-adapter` **12 → 16** (new #251/#252/#254/#256) / v0.5.0. Dependency watchlist **completely static** at 16 (10 open / 3 closed / 3 merged) — no membership, state, milestone, title, or activity change. Latest board-item activity 2026-07-27 (#875). Strict audit exits `2` for #888/#889/#892; snapshots rolled forward. |
| 2026-07-20 | **Live refresh vs the 2026-07-18 16:34 UTC baseline.** No board movement: **283 items / 209 Done / 74 non-Done** (57 open issues + 17 PR cards), with every status and milestone split unchanged (1.3.0 **22** open · 1.4.0 **4** · Future Release **43**). `WordPress/ai` holds at **37 open PRs** = 16 direct + 17 linked + 2 routine + 0 linked-off-board + **2 unexplained (#877, #878)**; the only census delta is board PR **#858** (`core/read-nav-menus`), whose merge state moved **DIRTY → BLOCKED** (checks still green). Upstream radar unchanged (`php-ai-client` **20 / 1.4.0**, `mcp-adapter` **12 / v0.5.0**) and the dependency watchlist holds at **16** (10 open / 3 closed / 3 merged). Latest board-item activity advanced to 2026-07-20 (a non-status edit on 1.4.0 issue #876). Strict audit still exits `2` only for #877/#878; snapshots rolled forward. |
| 2026-07-18 | **Same-day live refresh vs the 2026-07-18 02:20 UTC baseline.** Board **282 → 283**; Done holds at **209**; non-Done **73 → 74** with new unmilestoned In-progress issue **#883**. `WordPress/ai` open PRs **35 → 37** with #884 (authoritatively closes #883) and #885 (fallback-title match to #425); coverage is now 16 direct + 17 linked + 2 routine + 0 linked-off-board + 2 unexplained. The strict audit still exits 2 only for #877/#878. Upstream repository censuses and the 16-item dependency watchlist are unchanged. |
| 2026-07-18 | **Expanded full-repository tracking.** Added declarative PR/release censuses for `WordPress/php-ai-client` (**20 open PRs; latest 1.4.0, 2026-07-15**) and `WordPress/mcp-adapter` (**12 open PRs; latest v0.5.0, 2026-04-15**) alongside the existing `WordPress/ai` census (**35; 1.2.0**). The new repositories receive normalized PR data, validation, diffs, Markdown summaries, and independent snapshots, but no Project #240 coverage requirement. Live board and dependency counts are unchanged: 282 items / 209 Done / 73 non-Done; dependency watchlist 16 (10 open / 3 closed / 3 merged). |
| 2026-07-17 | **Tracker upgrade: authoritative PR relationships + strict audit mode.** The refresh script now reads open PRs via paginated GraphQL with GitHub `closingIssuesReferences` as the authoritative PR→issue link source (fallback title/body/branch parsing is grammar-restricted and disabled for routine PRs), classifies every open PR into one of five coverage buckets (direct-board-pr / linked-board-issue / routine / linked-off-board-issue / unexplained), tracks PR readiness changes (draft/review/merge/checks), and moves the dependency watchlist into the `wp-ai-roadmap-dependencies.json` registry with resilient UNKNOWN-placeholder fetches. New `--strict` audit exits `2` on coverage/data errors after emitting the report and suppresses persistence. Live coverage at upgrade: 35 open PRs = 16 direct + 15 issue-linked + 2 routine + **2 unexplained (#877, #878)**. |
| 2026-07-17 | **Live board + repo refresh vs 2026-07-13 baseline.** Board **279 → 282**; Done **206 → 209**; non-Done remains **73**, now **56 issues + 17 PR cards** (16 open + stale merged #484). **v1.2.0 shipped 2026-07-14**; unfinished work reorganized into **1.3.0 (22 open)** and **1.4.0 (4 open)**. Added 13 cards, removed 10 already-Done cards, and moved nine baseline cards to Done. Repo census: **35 open PRs**, 19 untracked by PR card (17 substantive + 2 routine). Dependency watchlist remains 16 (10 open / 3 closed / 3 merged); Gutenberg #73771 was retitled and updated. |
| 2026-06-15 | Initial creation. Snapshot of all 245 board items; deep-read of all 58 open issues. Latest shipped v1.0.1; v1.1.0 in flight (due ~2026-06-25). |
| 2026-06-15 | Added companion **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** — full per-issue dossiers for all 58 open issues (body + discussion + decisions + dependencies). |
| 2026-06-15 | Added companion **[`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md)** — release-ordered delivery plan for all 69 not-shipped items incl. the 11 open PRs; surfaced in-flight experiments (Type Ahead, Service Account, WebMCP adapter, C2PA Monitor/Content/Image Provenance, Suggest Image Crops) and a deferred "Work for Later" backlog. |
| 2026-06-16 | **Refresh vs 2026-06-15 baseline** (245 → 247 items). **v1.0.2 shipped** (16th release) — a patch milestone carved out of 1.1.0 (14 items) plus #699 (from 1.2.0), so 1.1.0 → 15 open / 0 Done and 1.2.0 → 5. #699 Done. Status moves → In progress: #191, #508, #689. Board-new: #732 (Triage — Request-Log transport gap), #736 (Backlog — per-feature access controls). #641 removed from board. **Corrected §7 no-milestone list** (#690 is 1.1.0, #339 is Future Release). Companion dossiers / planned-work tables not regenerated this pass. |
| 2026-06-18 | **Refresh vs 2026-06-16 baseline** (247 → 245 items). Latest release still **v1.0.2**; board latest activity 2026-06-18. Open work now **63 non-Done items** = 53 open issues + 10 non-Done PRs. Board-Done since prior docs: #390, #391, #571, #578, #678, #701, #721. Board-new: #741 (Triage — AI/Connectors admin-page flicker). 1.1.0 now 17 items = 6 Done / 11 open; 1.2.0 now 4 open. |
| 2026-06-19 | Live GitHub refresh. Board is now **246 items** = 174 PRs + 72 issues; Done **183**, open work still **63** but now **52 issues + 11 PR cards** (10 open + stale merged #484). 1.1.0 is **8 Done / 11 open**; Future Release is **47**. Regrouped #632/#643/#741 → In discussion, #732 → Backlog, added board-tracked draft PR #683 (native vector search), and moved `WordPress/abilities-api#84` to a removed-board reference. |
| 2026-06-19 | Fresh live recheck against Project #240 plus the `WordPress/ai` repo census: no count/status drift from the earlier 2026-06-19 refresh. Verified **246** items = 174 PRs + 72 issues; Done **183** / non-Done **63**; latest release remains **v1.0.2** (2026-06-16). |
| 2026-06-19 | Expanded tracked landscape with a separate Gutenberg + abilities-api dependency watchlist: 16 dependencies (11 Gutenberg, 5 abilities-api; 10 open, 3 closed, 3 merged). Project #240 counts remain unchanged and separate. |
| 2026-06-20 | **Live refresh vs 2026-06-19 baseline** (246 → 245 items = 174 PRs + 71 issues). Done **180** / non-Done **65** (54 open issues + 11 PR cards). Three closed Request-Log bug issues (#666/#667/#670, milestone 1.0.2) left the board → 1.0.2 14→11, Done issues 20→17. Two board-new **unmilestoned** In-progress bug fixes added: #750 (guest-comment moderation, PR #751) + #752 (Request-Log 30-day window, PR #753). Status moves Backlog → In progress: #187, #736. In progress 12→16 issues; Backlog 12→10. 1.1.0 holds at 8 Done / 11 open; Future Release **47**; latest release still **v1.0.2** (2026-06-16). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged). |
| 2026-06-25 | **Live refresh vs 2026-06-20 baseline** (245 → 250 items = 178 PRs + 72 issues). Done **183** / non-Done **67** (53 open issues + 14 PR cards = 13 open PRs + stale merged #484). Status moves: In progress 21→23, Backlog 10→8, Needs review 5→7. **Newly board-Done:** #632 (deactivate-connector settings retention), #750 (guest-comment moderation), #752 (Request-Log 30-day window). **Board-new open bugs (unmilestoned):** #767 (locale-aware content gate disables AI buttons for CJK content; In discussion) + #771 (Content Classification suggestion pill lost on add-failure; In progress, draft PR #772). Status moves Backlog → In progress: #192 (PR #770), #732 (draft PR #757). Milestone moves: #614 & #741 → 1.1.0, #683 → 1.2.0, #621 → Future Release, #750 → 1.1.0. Removed from board (closed Done): #662, #668, #684, #693. Milestones: 1.0.2 **11→8** (#662/#668/#693 left), **1.1.0 now 27 = 13 Done / 14 open** (due 2026-06-25, today), 1.2.0 **4→6**, Future Release **47→45**. Done issues 17→19. Latest release still **v1.0.2** (2026-06-16; 16 shipped). New board PRs: #739 (core/content ability), #764 (core/manage-settings ability), #765 (Repo Automator), #766 (editor support in readmes, Done). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged); `WordPress/gutenberg#77230` retitled. |
| 2026-06-30 | **Live refresh vs 2026-06-26 baseline** (249 → 269 items = 193 PRs + 76 issues). Done **183 → 195** / non-Done **66 → 74** (54 open issues + 20 PR cards = 19 open PRs + stale merged #484). **1.1.0 all but shipped: 14 Done/13 open → 27 Done/2 open**, release now tracked in **#805** (target **2026-07-30**); the bulk of 1.1.0's remaining work was **re-milestoned to 1.2.0**, which becomes the active build wave at **0 Done / 31 open**. **3 issues newly board-Done:** #145 (register() rename), #767 (CJK content gate), #771 (Content-Classification pill). 4 new open issues: #778 (E2E locators), #791 (Type Ahead cursor), #793 (Customize-experiments tool), #805 (release tracker). Status moves: #187/#508 In progress → Needs review; #197 To do → In progress; #690 Needs review → In progress; #765 Needs review → In progress. 23 milestone moves (mostly 1.1.0 → 1.2.0). Status totals: In progress 22→28, Needs review 7→9 (In discussion 21, Backlog 8, To do 7, Triage 1 unchanged). Milestones: 1.0.2 **8→5** (#699/#704/#718 de-carded), no-milestone **17→18** (now all Done). Latest release still **v1.0.2** (2026-06-16; 16 shipped). Repo census: **35 open PRs / 16 untracked** (16 substantive + 0 routine); six former off-board PRs (#560/#695/#758/#760/#774/#777) became board-tracked. Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged); 3 activity bumps (`gutenberg#73771`, `#77230` → 2026-06-30, `#77816` → 2026-06-29). |
| 2026-06-26 | **Live refresh vs 2026-06-25 baseline** (250 → 249 items = 178 PRs + 71 issues). Done holds at **183** / non-Done **67 → 66** (53 open issues + 13 PR cards = 12 open PRs + stale merged #484). **PR #151 (Type Ahead) merged board-Done** into 1.1.0 (OPEN → MERGED; In progress → Done) — the experiment's first appearance in Done. **#767** (locale-aware content gate) moved **In discussion → To do** and was milestoned **1.2.0**. Board-Done bug **#697** (excerpt focus loss; closed 2026-06-11) **de-carded** from the board. Status: In progress 23→22, In discussion/Needs decision 22→21, To do 6→7 (Done/Backlog/Needs review/Triage unchanged). Milestones: **1.1.0 now 14 Done / 13 open** (due 2026-06-25, **now past**), 1.2.0 **6→7**, no-milestone **19→17** (16 Done / 1 open). Done issues 19→18. Latest release still **v1.0.2** (2026-06-16; 16 shipped). Repo census: **37 open PRs / 25 untracked** (24 substantive + 1 routine); newly opened off-board #773–#777 (incl. #774 `core/users`, #776 Type Ahead follow-up). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged); 1 activity bump (`WordPress/gutenberg#77994` → 2026-06-25). |
| 2026-07-03 | **Live refresh vs 2026-07-02 baseline** (271 → 265 items = 194 PRs + 71 issues). Done **196 → 189** / non-Done **75 → 76** (55 → **56** open issues + 20 non-Done PR cards). **7 already-Done issues de-carded from the board:** #390/#391/#571/#578/#678 (1.1.0) and #589/#727 (1.0.2) — all shipped, just no longer board cards, so 1.1.0 **27 → 22** and 1.0.2 **5 → 3**. **1 status move:** #816 (Type-Ahead front-end regression) **Triage → In progress** (fix PR #820). **1 board-new issue:** #818 (missing alt text on the AI Home feature-card `<img>`; In progress, no milestone, PR #819). Status totals: In progress **27 → 29**, Triage **2 → 1** (In discussion 21, Needs review 10, Backlog 7, To do 8 unchanged). Milestones: no-milestone **22 → 23** (20 Done / 3 open — #809, #816, #818); 1.2.0 holds at **32**, Future Release at **40**. Repo census: **47 open PRs / 28 untracked** (21 substantive + 7 routine dependabot; 19 board-tracked) — up from 35/16 as PRs #817/#819/#820 (+ dependabot #821–#827, #828, #829) opened. Latest release still **v1.1.0** (2026-07-01; 17 shipped). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged). |
| 2026-07-02 | **Live refresh vs 2026-06-30 baseline** (269 → 271 items = 194 PRs + 77 issues). Done **195 → 196** / non-Done **74 → 75** (55 open issues + 20 PR cards = 19 open PRs + stale merged #484). **🚀 v1.1.0 SHIPPED (2026-07-01)** — the 17th release: encryption PR **#560** merged (2026-06-30), release issue **#805** closed board-Done, and the credentials gate **#197** closed board-Done (milestone cleared). **1.1.0 29 → 27** (all Done; de-carded #701/#721 left the milestone); **1.2.0 is now the sole active build wave, 31 → 32 open**. 4 new open items: **#809** (Content-Summary nested-block detection, In progress, PR #810), **#814** (feature-request-template markdown fix, Needs review PR, 1.2.0), **#815** (Connector-Approvals access-notice gap, To do, 1.2.0), **#816** (Type-Ahead front-end `wp-editor` load breaks WooCommerce checkout — Triage, unmilestoned; a post-1.1.0 regression). Status moves: **#190** Backlog → To do. Status totals: In progress 28→27, Needs review 9→10, Backlog 8→7, To do 7→8, Triage 1→2 (In discussion 21 unchanged). Milestones: no-milestone **18 → 22** (20 Done / 2 open — milestone-cleared #197 + #632 joined Done; #809 + #816 are the 2 open); Future Release holds at **40** (#632's milestone cleared on close). Repo census: **35 open PRs / 16 untracked** (16 substantive + 0 routine); off-board #810 opened (Closes #809), #799 closed. Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged); 2 activity bumps (`WordPress/gutenberg#73771`, `#77230` → 2026-07-01). |
| 2026-07-09 | **Live refresh vs 2026-07-03 baseline** (265 → 277 items = 205 PRs + 72 issues). Done **189 → 200** / non-Done **76 → 77** (56 → **57** open issues + 20 non-Done PR cards = 19 open + stale merged #484). **🚧 v1.2.0 opened its first board-Done batch (0 Done / 32 → 10 Done / 31 open; 41 cards):** #774 (core/read-users ability, merged), #814 (feature-request-template markdown fix), #816 (Type-Ahead front-end/WooCommerce regression, closed), #818 (AI-Home alt-text a11y), #833 (Title-Generation MutationObserver crash), #838 (screenshots), #839 (Type-Ahead Escape-restart), #846 (Type-Ahead ghost-text overlap), plus CI/dep PRs #821/#831. **5 already-Done issues de-carded:** #750/#755/#763/#768 (1.1.0) + #752 (no-milestone) → 1.1.0 **22 → 18**. **Milestone move:** PR #765 (Add Repo Automator action) 1.2.0 → Future Release. **Status moves To do → In progress:** #793 (Customize-experiments tool), #815 (Connector-Approvals notice). **2 board-new Backlog experiments** (Future Release): #844 (semantic search in wp-admin), #845 (Markdown feeds via `html-to-md`). **Spam:** #848 (Triage, no milestone) landed 2026-07-09 — pending removal. Status totals: Done 189→200, In progress 29→30, Backlog 7→9, To do 8→6, Triage 1→2, Needs review 10→9 (In discussion 21 unchanged). Milestones: Future Release **40 → 43** (33i+7PR → 35i+8PR), no-milestone **23 → 27** (25 Done / 2 open — #809, #848). Repo census: **38 open PRs / 19 untracked** (all substantive, 0 routine — dependabot PRs now carded and #831 pins/ignores `@wordpress`); latest release still **v1.1.0** (2026-07-01; 17 shipped). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged); 1 activity bump (`gutenberg#73771` → 2026-07-08). |
| 2026-07-12 | **Live refresh vs 2026-07-09 baseline** (277 → 279 items = 206 PRs + 73 issues). Done **200 → 206** / non-Done **77 → 73** (57 → **53** open issues + 20 non-Done PR cards = 19 open + stale merged #484). **🚧 v1.2.0 kept shipping (10 Done / 31 open → 14 Done / 28 open; 41 → 42 cards):** +4 board-Done — **#508** "Suggest Reply" experiment (PR #724 merged 2026-07-10, the lane's first genuinely new experiment), **#793** Customize-experiments tool (#842), **#815** Connector-Approvals notice (#830), dependabot **#837** — plus the no-milestone **#809** nested-block fix (#810). **1 new PR card:** #857 (Add/commit access docs, Needs review, 1.2.0). **Board-new / moved:** #853 (Generate_Image hardcoded-timeout bug) added to **Triage** (no milestone); **#845** (Markdown feeds) moved **Backlog → In progress** as implementing off-board PR #855 opened. **Spam #848 closed** board-Done (as "completed"), leaving Triage. Status totals: Done 200→206, In progress 30→28, Backlog 9→8, Needs review 9→8, To do 6, Triage 2 (now #40 + #853), In discussion 21 unchanged. Milestones: 1.2.0 **41 → 42**, no-milestone **27 → 28** (27 Done / 1 open — #853), Future Release holds at **43** (#845 moved within it). Repo census: **38 → 37 open PRs / 18 untracked** (all substantive, 0 routine); #724/#810/#830/#842 merged out, board-new PRs #855/#856/#858 in. Latest release still **v1.1.0** (2026-07-01; 17 shipped) — a **1.1.1** patch for the shipped Type-Ahead regression remains undecided. Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged); 1 title change + 1 activity bump (`gutenberg#77230` retitled "…WordPress 7.1" → "…7.2", → 2026-07-11). |

<!--
MAINTENANCE NOTES (not rendered):
- "WordPress AI" board == the WordPress/ai Showcase Plugin in practice (268/269 items).
- Roadmap signal = open ISSUES plus the non-Done PR lane; PRs are most of the 202 Done cards.
- Board total can FALL without scope loss: post-release the team de-cards finished milestone cards in bulk (10 removed 2026-07-27, 6 on 2026-08-10). A FLAT total can also hide full turnover — 2026-08-10 was 6 out / 6 in. Always read .board.added and .board.removed, never the count alone.
- Dependabot PRs are carded now, so `routine` reads 0 while dependency PRs still enter Done (2 merged + 1 closed-unmerged on 2026-08-10). Routine==0 does not mean "no dependency churn".
- Priority field is barely used; track via Status + Milestone.
- Strategic bets (⭐): #348, #40, #430, #297, #324, #338, #189, #282. Risk (⚠️): #448 (WebMCP), #643 (live regression).
- Watch core deps: WP 6.9 Abilities API, WP 7.0 AI Client, Gutenberg RTC/Media Editor/Guidelines→Skills, abilities-api repo.
-->
