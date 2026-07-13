# WordPress AI — Planning & Roadmap (Living Document)

> **Source board:** [github.com/orgs/WordPress/projects/240](https://github.com/orgs/WordPress/projects/240) — *"WordPress AI Planning & Roadmap"*
> *"A project board to provide oversight into the various focus areas of the WordPress AI team."*
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-12 (latest item activity: 2026-07-12) |
> | **Items captured** | 279 (full board, via GraphQL Projects API) |
> | **Plugin** | [`WordPress/ai`](https://github.com/WordPress/ai) — the official "AI" Showcase Plugin on WordPress.org |
> | **Latest shipped** | **v1.1.0** (shipped 2026-07-01) — 17th release; encryption PR [#560](https://github.com/WordPress/ai/pull/560) merged and release issue [#805](https://github.com/WordPress/ai/issues/805) closed. No new public release this window — a **1.1.1** patch for the shipped Type-Ahead regression is still undecided |
> | **In active development** | **v1.2.0** (28 open / 14 Done; 42 carded; milestone due **2026-07-30**) — kept landing board-Done work this window, incl. the **[#508](https://github.com/WordPress/ai/issues/508) "Suggest Reply" experiment**; the uncommitted roadmap backlog sits in **Future Release** (43) |
> | **Maintained by** | _(you)_ — see [§10 How to refresh](#10-how-to-refresh-this-document) to regenerate the data |

**How to read this doc:** [§1 Composition](#1-board-composition) · [§2 Releases](#2-release-cadence) · [§3 Product model](#3-product-architecture) · [§4 Shipped](#4-shipped-done) · [§5 In progress](#5-in-progress) · [§6 Roadmap bets](#6-planned-roadmap--strategic-bets) · [§7 Undecided/blocked](#7-unplanned--undecided--blocked) · [§8 Strategic read & risks](#8-strategic-read--risks) · [§9 Full open-issue tracker](#9-appendix--full-open-issue-tracker-53) · [§10 Refresh](#10-how-to-refresh-this-document) · [§11 Changelog](#11-changelog)

> **📚 Companion documents (4-doc set):**
> 1. **This file** — strategy, board composition, release cadence, and the at-a-glance open-issue tracker.
> 2. **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** — deep per-issue dossiers (problem · approach · decisions · dependencies · discussion), grouped by status. *(Current to 2026-07-12 — all 53 current board-open issues dossiered, plus #84 retained as a removed-board reference and 26 recently board-Done issues retained for reference.)*
> 3. **[`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md)** — the release-ordered delivery plan for all 73 non-Done board cards, including 19 open board-tracked PRs and stale merged PR #484.
> 4. **[`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md)** — live Gutenberg + abilities-api dependency watchlist for roadmap-critical upstream blockers/enablers. *(Initial scope: 16 tracked dependencies — 11 Gutenberg + 5 abilities-api.)*

### Status legend (board's own taxonomy)
`Triage` → unsorted/new · `In discussion / Needs decision` → debated, **not** committed · `Backlog` / `To do` → planned · `In progress` → being built · `Needs review` → PR open · `Done` → shipped/merged

---

## Executive summary

Despite the broad "WordPress AI" name, this board is operationally the **dev tracker for one plugin** — the `WordPress/ai` Showcase Plugin (278 of 279 items). The plugin is built as a set of **toggleable "Experiments"** (discrete AI features) sitting on **shared infrastructure** (Connectors, the WordPress Abilities API, the WP AI Client, AI Request Logs, MCP).

The team ships **fast** — 17 completed releases (0.1.0 → 1.1.0) — and is currently in a **stabilization wave** (1.1.0/1.2.0): provider/Connector polish, request-log retention and transport gaps, feature gating, lifecycle hygiene, and editor/admin UX bugs. As of the 2026-07-12 refresh **v1.1.0 remains the latest public release (shipped 2026-07-01)** — no new public release was cut this window — leaving **v1.2.0 as the sole active build wave, which kept landing board-Done work (28 open / 14 Done)**. **This window's board-Done batch** is headlined by the **#508 "Suggest Reply" experiment** (a new Comments/Activity-widget feature, PR #724 merged) alongside three 1.2.0 hardening closes — the **#793 "Customize experiments" Developer Tool**, the **#815 Connector-Approvals access notice**, and the **#809 Content-Summary nested-block fix** — building on the prior window's `core/read-users` Ability (#774, merged) and Type-Ahead post-release fixes (#816/#839/#846/#833). The lingering **spam card #848 was closed**, one new bug entered Triage (Generate_Image hardcoded timeout, #853), and the **Markdown-feeds experiment (#845) moved Backlog → In progress** as its implementing PR #855 opened. Several prior 1.1.0 hardening items (empty states, CJK counting, button sizing, translations, Snackbar reposition), Editorial Updates reload matching (#678), README board-link cleanup (#742), Type Ahead provider/model overrides (#776), Connector-key encryption (#560), and the latest June board-Done bug fixes — guest/anonymous comment-moderation gating (#750), the Request-Log "Last 30 Days" window (#752), connector-deactivation settings retention (#632), the experiment `register()` rename (#145), and the CJK content-gate and Content-Classification pill fixes (#767, #771) — have shipped board-Done, and **v1.1.0 is now the public release (2026-07-01)**. The **ambitious roadmap lives mostly in "Future Release"** and splits into four converging bets: (A) the **Abilities API as a universal tool layer** bridging WP to MCP/WebMCP/Skills, plus a Core governance/management plane; (B) a **provider-agnostic Connectors ecosystem** with model-preference controls; (C) an **editorial-lifecycle** of content experiments (co-authoring, agentic Refine, analytics-aware, social); and (D) a directional shift toward **agentic/conversational "site agents"** that take actions. The throughline: **single-task helpers → an agentic AI platform for WordPress.**

---

## 1. Board composition

| Dimension | Breakdown |
|---|---|
| **Total items** | **279** = 206 PRs + 73 issues |
| **By status** | Done **206** · In progress **28** · In discussion/Needs decision **21** · Needs review **8** · Backlog **8** · To do **6** · Triage **2** |
| **Open work** | **73 non-Done board items** = 53 open issues + 20 non-Done PR cards *(19 open; #484 is merged but still board-Needs review)* |
| **By repo** | `WordPress/ai` **278** · `WordPress/ai-provider-for-google` **1** (#23). `WordPress/abilities-api` #84 is no longer on Project #240. |
| **Cross-repo dependency scope** | Separate watchlist: **16** Gutenberg / abilities-api dependencies (10 open, 3 closed, 3 merged), tracked in [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md). These are not included in Project #240 totals. |
| **"Team" field** | No Team values are returned in the current Projects API snapshot; use repo + labels/status for classification. |
| **"Priority" field** | Barely used — only a handful of items ever set it (the GraphQL snapshot tracks Status, not Priority). **Prioritization happens via Status + Milestone, not Priority.** |
| **Board views** | Prioritized backlog · AI plugin · Status board · Roadmap (timeline) · Bugs 🐛 · My items |

**Caveat for maintainers:** "Done" (206) is overwhelmingly merged PRs; the *forward-looking roadmap signal lives in the 53 open issues*, not the PRs.

---

## 2. Release cadence

A very fast train of **17 fully-shipped releases**, with **1.1.0 the current public version** (shipped 2026-07-01). **1.2.0 is the sole active build wave** and kept landing board-Done work this window (28 open / 14 Done); the uncommitted roadmap backlog sits in Future Release (43).

| Milestone | Items | State | Meaning |
|---|---|---|---|
| 0.1.0 → 0.9.0 | ~134 | ✅ Done, except stale board item #484 | The build-out (0.1.0 biggest at 22 PRs; 0.7/0.8/0.9 each ~16–20). #484 (in 0.9.0) is merged but still not board-Done. |
| 1.0.0 | 3 | ✅ Done | Stability milestone, aligned with WP 7.0 / 6.9 Abilities API |
| 1.0.1 | 8 | ✅ Done | Prior patch release |
| **1.0.2** | 3 | ✅ Done | Prior patch (shipped 2026-06-16) — milestone carved out of 1.1.0; 5 → 3 this refresh as two already-Done issues (#589/#727) were de-carded from the board 2026-07-03 (earlier de-cards #699/#704/#718 left 2026-06-30) |
| **1.1.0** | 18 | ✅ Done | **Latest shipped (2026-07-01)** — 17th release; unchanged this refresh (18 Done / 0 open) |
| **1.2.0** | 42 | 🚧 14 Done / 28 open | **The sole active build wave** — +4 board-Done this window (#508 Suggest Reply experiment, #793 Customize-experiments tool, #815 Connector-Approvals notice, #837 dep bump) and one new PR card (#857); 10 → 14 Done, 41 → 42 cards |
| **Future Release** | 43 | 📋 43 open (35 issues + 8 PRs) | The real roadmap backlog; total unchanged this refresh — #845 (Markdown feeds) moved Backlog → In progress within it (implementing PR #855 opened) |
| _(no milestone)_ | 28 | 27 Done / 1 open | The 1 open is #853 (Generate_Image hardcoded timeout, Triage, board-new); #809 (nested-block fix) and spam #848 both closed board-Done this window |

*Sums to 279 (134 + 3 + 8 + 3 + 18 + 42 + 43 + 28).*

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
- **`AI_Service`** layer — shared internal routing all experiments are being migrated onto (#233).

Every roadmap item is a **new Experiment**, an **enhancement to one**, or **infrastructure/governance** beneath them.

---

## 4. Shipped (Done)

Board-Done now sits at **206** items (200 → 206 this window: the 1.2.0 lane closed four more cards — **#508** "Suggest Reply" experiment, **#793** Customize-experiments tool, **#815** Connector-Approvals notice, and dependabot PR **#837** — plus the no-milestone **#809** nested-block fix and the closed spam issue **#848**). The public shipped line is still the 17 releases through **1.1.0** (shipped 2026-07-01); the 1.1.0-targeted issues/PRs that moved Done through June are now in a public build, and the 1.2.0 lane remains the next wave of board-Done work not yet publicly released:

- **The Experiments framework** + the ~10 Experiments listed in §3.
- **Connectors** system — matured ~v0.5.0 (`wp_get_connectors`).
- **Abilities Explorer** (present by ~v0.3.0) and Abilities API integration.
- **MCP adapter** — wired very early (v0.1.1, via WP AI Client 0.2.0).
- **AI Request Logs** observability layer — the major v1.0.x → v1.1.0 theme.
- **v1.0.0** = the stability milestone aligned with **WordPress 7.0 / the 6.9 Abilities API**.
- **Recent board-Done hardening** — empty-content controls (#390, #391), CJK/character-count fixes (#571, #578), a11y focus-loss fix (#589), Editorial Updates reload matching (#678), button sizing (#701), Request Log settings translations (#721), README project-board link cleanup (#742), guest/anonymous comment-moderation gating (#750), the Request-Log "Last 30 Days" window (#752), and connector-deactivation settings retention (#632). *(#390/#391/#571/#578/#678 and #589, plus the 1.0.2 release-tracker #727, were de-carded from the board 2026-07-03 — still shipped, just no longer board cards.)* **In the 2026-06-30 refresh:** the experiment `register()` → `init()` rename (#145), the locale-aware content-gate fix for CJK content (#767), Content-Classification suggestion-pill restore (#771), Snackbar reposition (#800), Editorial-Note spinner scoping (#792), and the Title-Generation "Regenerate" label fix (#788). **New in the 2026-07-02 refresh:** Connector API-key encryption (PR #560, merged 2026-06-30) — cut into the 1.1.0 release. Separately, the "disable features until valid credentials" gate (#197) closed board-Done on 2026-07-01 (milestone cleared), but its off-board PR #799 closed **unmerged**, so #197 resolved *without* shipping in the 1.1.0 payload.
- **New experiment shipped** — **Type Ahead** (PR #151) — AI ghost-text autocomplete in the editor — merged into the **1.1.0** lane on 2026-06-25 and **shipped in the 1.1.0 public release (2026-07-01)**. Its follow-up PR **#776** (provider/model overrides + Guidelines support) merged board-Done on 2026-06-30. ⚠️ Post-release, a front-end asset-loading regression was filed against it — **#816** (Type Ahead enqueues `wp-editor` on the front end, intermittently breaking WooCommerce block checkout); it **closed board-Done under 1.2.0 on 2026-07-09**, along with two more Type-Ahead follow-ups — #839 (suggestion restarts immediately after Escape) and #846 (ghost-text/empty-block-placeholder overlap).

The 20 *Done issues* still carded (vs. PRs) are mostly **a11y fixes, Request-Log bugs, i18n, and generation-UX bugs** (hardening of already-shipped features) — now joined by the 1.2.0 lane's first genuinely new experiment, **"Suggest Reply" (#508)**.

---

## 5. In progress

The 1.1.0/1.2.0 wave is **polish & correctness on shipped features**, not new bets:

- **AI Request Logs** finishing: retention/cleanup controls (#689, In progress / Future Release) remain; translations (#721) moved board-Done; copy-feedback (#699) and header-overlap (#704) **shipped in 1.0.2** (both de-carded from the board 2026-06-30). A transport gap is now In progress / **1.2.0**: logging only captures SDK-HTTP-transport providers, leaving sidecar/custom-transport providers invisible (#732, draft PR #757), with a companion REST-filter fix (#758).
- **Board-new bug fixes shipped:** the two unmilestoned bugs tracked here in June both **moved board-Done on 2026-06-30** — the CJK content-gate fix (#767, raised by yogeshbhutkar; had moved to To do / 1.2.0) and the Content-Classification suggestion-pill restore (#771, draft PR #772 merged). Prior board-new In-progress/queued work: **E2E hardening** (#778, prefer user-facing Playwright locators), a **Type Ahead loading-cursor** exploration (#791, In discussion / Future), and a **"Customize experiments" Developer Tool** toggle (#793, now In progress / 1.2.0).
- **Board-new / moved this refresh (2026-07-12):** the 1.2.0 lane closed four cards board-Done — **#508** "Suggest Reply" (Needs review → Done, PR #724 merged 2026-07-10), the **"Customize experiments" Developer Tool** (#793 → Done, PR #842), the **Connector-Approvals access-notice gap** (#815 → Done, PR #830), and dependabot #837 — plus the no-milestone **Content-Summary nested-block detection** (#809 → Done, PR #810 by Intenzi). The lingering **spam issue #848** was closed (now board-Done, no longer Triage). One board-new bug entered **Triage** — **#853** (Generate_Image ability uses a hardcoded timeout, no milestone) — and the **Markdown-feeds experiment (#845)** moved **Backlog → In progress** as its implementing off-board PR **#855** (dkotter) opened.
- **Internationalization:** Content Classification (#571) & Content Resizing (#578) CJK/Japanese character-count fixes moved board-Done on 2026-06-17.
- **Empty-state bugs:** generate/regenerate actions with no content (#390, #391) moved board-Done; aggregate "Enable AI" toggle state (#600) remains In progress.
- **Editorial Updates:** completion flow → WP 7.0 **Visual Revisions** (#507, now To do / 1.2.0); Note↔block matching after reload (#678) moved board-Done under the 1.0.2 milestone.
- **Content Classification relevance** tuning (#452, now 1.2.0) — from Elementor / Miriam Schwab feedback.
- **Lifecycle hygiene:** real `uninstall.php` dropping logs table + options for privacy (#690, now 1.2.0); the "disable features until valid credentials" gate (#197) **closed board-Done on 2026-07-01** (milestone cleared; its off-board PR #799 closed **unmerged**, so it resolved without shipping in 1.1.0).
- **Admin page UX:** #741 reports a black/blank flicker on AI and Connectors admin pages in AI 1.0.2 on WordPress Playground (now 1.2.0 / In discussion); #643 remains open but is now Future Release / In discussion, with evidence pointing to a core/environment JS integrity issue.
- **DX / tooling:** the experiment `register()` → `init()` rename (#145) **shipped board-Done**; AGENTS.md onboarding (#307); native vector search/RAG is board-tracked as draft PR #683 under 1.2.0 / In progress; and the wave of Core-Abilities PRs continues — `core/read-content` (#739) and `core/manage-settings` (#764) remain in flight under 1.2.0 (`core/read-users` #774 merged earlier), joined this window by two more off-board core-ability PRs: **#856** (register initial settings before `core/read-settings` snapshots them) and **#858** (`core/read-nav-menus` ability).

*(Full per-issue detail in [§9](#9-appendix--full-open-issue-tracker-57).)*

---

## 6. Planned roadmap — strategic bets

Four converging directions. Most sit in **"Future Release"** (uncommitted) unless noted.

### A. Abilities API as the universal tool layer → Platform & Standards
The keystone bet: **`name + description + JSON Schema + implementation`** as the primitive that bridges WordPress into every agent standard.

- **#40 Core Abilities** *(Triage)* — the foundational `core/*` ability set (CRUD posts/pages/users/media/settings, plugin activate/update; destructive actions excluded for v1). **Key debate:** collapse per-post-type CRUD into one `create_post(post_type)` (consensus *yes* — MCP tool caps: 128 OpenAI / 512 Google) vs. granular abilities for Command Palette UX. Owners: gziolo, jorgefilipecosta. *Foundational, core-dependent.*
- **#348 Unified AI Management Layer for Core** — a single Core plane for structured **permissions + usage metering/budgets + capability-aware provider routing**, consolidating ~6 fragmented community plugins; hooks the existing `wp_ai_client_prevent_prompt` filter (zero breaking changes). **Open:** allow- vs **deny-by-default** (commenters favor deny). ⭐ *Major bet.*
- **#354 Unified Abilities exposure controls** — central per-"surface" control over which abilities are exposed where (every MCP server auto-becomes a surface); overlaps #348. Warns: without this, every plugin ships its own surface → mess.
- **#736 Per-feature role/user access controls** *(now In progress; draft PR #749 by Infinite-Null)* — expose role/user access controls per Experiment/feature; complements the #348/#354 governance cluster at the feature granularity.
- **#21 Supporting thousands of abilities** *(Question)* — exposing every ability 1:1 as an MCP tool degrades model selection. Proposes a **layered-tool pattern** (3 tools: `get_abilities_by_category` / `get_ability_info` / `use_ability`) with a category taxonomy.
- **#430 Skills in a WordPress admin context** — map "Skills" into WP (Command Palette `/audit-accessibility`); gziolo is evolving the **Guidelines CPT → Skills** in Gutenberg. **Open:** split user-authored prompts/workflows from full agent Skills with script execution (script bundling is the blocker). ⭐ *Major bet, cross-repo (Gutenberg).*
- **#448 WebMCP experiment** — integrate `navigator.modelContext.registerTool` so a browser-native agent can drive WP. **Risk:** WebMCP is an **unstable W3C Community Group draft**, no browser ship commitment; lean on a polyfill + Experiment status for easy retirement. ⚠️ *Speculative.*
- **#37 MCP usage & request routing** — make the plugin a **reference MCP implementation** (route an Experiment via MCP; reusable adapter; provider switching).
- Supporting: **#233** (refactor experiments onto `AI_Service`), **#203** (extensibility hook for Ability Table columns, now 1.2.0), **#307** (AGENTS.md), **#32** (AI Playground debug tool), plus the in-flight Core-Abilities PRs **`core/read-content`** (#739) and **`core/manage-settings`** (#764) under 1.2.0; **`core/read-users`** (#774) merged board-Done earlier, and two more core-ability PRs opened this window — **#858** (`core/read-nav-menus`) and **#856** (register initial settings before `core/read-settings` snapshots them). The experiment `register()` → `init()` rename (#145) shipped board-Done earlier. Upstream `WordPress/abilities-api` **#84** (generic CRUD across post types; client vs server `execute_callback`) remains open, but is no longer on Project #240.

### B. Connectors, Providers & Model Management
Direction settled: **thin core Connectors screen discovering independent per-provider plugins** (the bundle-everything path, PR #148, was abandoned).

- **#502 Provider plugin discovery/curation/labeling** — the strategic parent. Three unresolved axes: discovery model (hardcoded list vs WP.org Plugins API vs `connector` tag), curation/"vetted" concept, and official-vs-third-party labeling.
- **#27 Surface additional provider plugins on Connectors** *(Future Release; moved off 1.1.0)* — list third-party providers + "progressive provider selection" (hide UI when a valid provider exists); host pre-config via constants/filters. **Strong demand for OpenRouter** (one key, many models).
- **#262 Provider-level model bucketing** — replace hard-coded model priority lists with a user-facing **provider preference** (not specific models); future capability tiers (fast/cheap vs high-reasoning). *Scope being questioned now that a per-experiment "developer mode" already exposes provider+model.*
- **#191 Settings + provider import/export** *(now In progress)* — portability for agencies/hosts/multisite; secure credential handling unresolved (env-var support floated).
- **#632** *(now board-Done / closed)* deactivate a connector without losing its key · **#660** *(1.2.0)* clearer "blocked by Connector Approvals" error · **#815** *(1.2.0, now board-Done — PR #830 merged 2026-07-10)* surface an admin notice when Connector Approvals still needs the AI plugin granted access to a connected provider (WPORG support report; related to #660).

### C. Content & Editorial Experiments (the authoring lifecycle)
Expanding from per-field generators toward full co-authoring.

- **#297 Content Generation** — native Block Editor **co-author** (first drafts from title, expand sections, rewrite selection; `/ai` slash command, ghost-typing, accept/reject diffs). Well-specified, awaiting design (karmatosed). ⭐ *Major bet.*
- **#324 Evolve "Refine" → agentic/collaborative editorial** *(1.2.0)* — a "WordPress AI" user editing live via Gutenberg **Real-Time Collaboration**; deferred to let RTC stabilize. ⭐ *Major bet.*
- **#338 Analytics-aware content & amplification** — content-gap mining (low-engagement on-site searches) + traffic-surge social amplification, via a `Stats_Provider` adapter (**Jetpack Stats first**); split into two sub-issues. ⭐ *Major bet — closes ideation→distribution loop.*
- **#625 Social Content Generation** — platform-specific posts (Bluesky/Mastodon/LinkedIn) from post content; persist to meta; hooks for Jetpack Social/Blog2Social.
- **#508 "Suggest Reply"** for comments + Activity widget *(shipped board-Done under 1.2.0 — PR #724 merged 2026-07-10)* — the 1.2.0 lane's first genuinely new experiment (re-introduces #155's removed feature properly; human review, **not** auto-reply).
- **Reusable control layer:** tone (#186), multilingual rewriting/translation (#187, *now Needs review, 1.2.0* — full-article PoC by yogeshbhutkar; draft PR #747), persona/voice (#188).
- Enhancements: **#614** bulk summary generation *(1.2.0)* · **#90** consolidate Title Generation options · **#507** Editorial Updates → Visual Revisions *(1.2.0)* · **#452** classification relevance *(1.2.0)*.

### D. Agentic / Chat / Site-Agent + Media
The biggest **directional shift** — from single-task helpers to a conversational agent that takes actions. Three convergent issues:

- **#142 Frontend chat agent** — "chat with my site" for public **visitors** (RAG over owner-selected content + FAQ, citations). Designed proposal; needs an embeddings/indexing pipeline (shared with #282).
- **#282 Admin "AI Workspace"** — full-screen wp-admin multi-step chat (Site-Editor-styled, DataViews), capability-gated Search/RAG middleware, actionable artifacts ("Create Draft"). Most fleshed-out spec; assigned karmatosed for mockups.
- **#189 Site Agent** — natural language → **explicit, verifiable WP actions** (create posts, install plugins, change settings). Opt-in, disabled by default, capability-respecting, fully auditable. ⭐ *Major bet (idea-stage).*
- **#190 Site-wide insights** — read-only cross-content analysis (themes/gaps/trends); the safe data layer feeding the agentic surfaces.

**Media & Vision:** focus-aware crop suggestions (#238) · integrate media experiments with Gutenberg's experimental **Media Editor** (#325) · **C2PA** provenance detection on upload (#421, *1.2.0*, well-specified) · alt-text button placement (#425, **Blocked**).

**Search/RAG:** native vector search (#683 draft PR, now milestoned 1.2.0) adds a board-tracked experiment for MariaDB-backed semantic search/RAG with fallback post-meta embeddings.

**Extensibility & community:** custom prompt-template hooks (#192) · developer-only request/response log panel (#193) · Comment Moderation value/relevance scoring (#514) · low/no-tech educational content for the WP 6.9 launch (#47).

---

## 7. Unplanned / undecided / blocked

- **21 "In discussion / Needs decision"** = the genuinely *uncommitted* questions (19 issues + 2 PRs, #211 & #224). Most platform/provider bets (#348, #430, #448, #502, #262) live here, **not** in a dated milestone — debated, not promised. *(No membership change this refresh.)*
- **2 Triage:** the Core Abilities umbrella (#40) plus a board-new bug **#853** ("Generate_Image Ability uses a hardcoded timeout value", no milestone) filed 2026-07-10. The prior spam card #848 was **closed board-Done** this window (as "completed"), so it no longer inflates Triage or the open-issue count.
- **Blocked:** #425 (alt-text placement).
- **Unmilestoned board work (1):** one non-Done card carries no milestone this refresh — **#853** (Generate_Image hardcoded timeout, Triage). #809 (nested-block detection) and spam #848 both closed board-Done this window. #643 and #689 carry **Future Release**; everything else committed sits in 1.2.0. The only non-Done non-Future straggler under a shipped milestone is stale merged PR #484 under 0.9.0.
- **Design bottleneck:** 7 design-labeled issues (6 `Needs Design`, plus #90 `Needs Design Feedback`); several major experiments (#297, #324, #338, #625) gated on mockups (tentatively karmatosed).
- **Key open decisions:** allow- vs deny-by-default governance (#348); ability granularity (#40); WebMCP standard risk (#448); whether #262's scope is now redundant.

---

## 8. Strategic read & risks

**Where it's heading:** a deliberate arc from *discrete AI helpers* → *an agentic, conversational WordPress platform*, with the **Abilities API as the load-bearing keystone** (it maps cleanly to MCP, WebMCP, Skills, and the Command Palette), a **Core governance/management plane** (permissions, metering, routing), and a **provider-agnostic ecosystem**.

**Watch-items / risks:**
1. **Heavy external dependencies** — WP core 6.9 (Abilities API), 7.0 (AI Client), Gutenberg (RTC, Media Editor, Guidelines→Skills), and the `abilities-api` repo. Much of the roadmap can't move until core does.
2. **WebMCP (#448) is speculative** — built on an unstable W3C draft with no browser ship commitment (flagged internally).
3. **Backlog-to-commitment gap** — 43 "Future Release" + 21 "In discussion" items, but the near-term picture is firm: **1.2.0 now carries 42 cards and keeps shipping (14 Done / 28 open)** as the sole active build wave — this window it landed its first genuinely new experiment (#508 "Suggest Reply") on top of hardening — and **v1.1.0 remains the public release (2026-07-01)**. Still lots of vision in Future Release, but near-term scheduling is no longer thin.
4. **Unresolved foundational decisions** — deny-by-default governance (#348) and ability granularity (#40) gate the whole platform layer.
5. **Live regressions against shipped features** — #643 (blank Connectors/settings pages on WP 7.0) survived into 1.0.2 but likely points to broken core JS in the reporter's environment; #741 reports a black/blank flicker on AI/Connectors admin pages in AI 1.0.2 and now has a likely `#wpwrap` critical-style root cause plus Gutenberg cross-reference. **#816** was a front-end regression in the Type Ahead experiment that *shipped in 1.1.0* — it enqueued `wp-editor` on public pages and could intermittently corrupt WooCommerce block checkout; it was fast-tracked and **closed board-Done under 1.2.0 on 2026-07-09**, with sibling Type-Ahead fixes #839 (Escape-restart) and #846 (ghost-text overlap) shipped to the same lane.

---

## 9. Appendix — full open-issue tracker (53)

> 📄 **Deep per-issue dossiers** (problem · approach · open decisions · dependencies · discussion) for the open issues live in the companion file **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** *(current to 2026-07-12: all 53 current board-open issues + #84 removed-board reference + 26 recently board-Done issues retained for reference)*. The index table below is updated to the current **53**.

Grouped by board status. Theme tags: **Platform** (Abilities/MCP/Skills) · **Providers** · **Content** (editorial experiments) · **Agentic/Media** · **Infra/UX** · **Community** · **Bug**. ⭐ = major strategic bet · ⚠️ = notable risk.

### In discussion / Needs decision (19)
| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#21](https://github.com/WordPress/ai/issues/21) | Future | Platform | — | Layered-tool pattern to expose thousands of abilities to MCP without degrading tool selection |
| [#23](https://github.com/WordPress/ai-provider-for-google/issues/23) | 1.2.0 | Bug/Providers | — | Google provider Image Generation fails (`candidates[0].content` missing) |
| [#27](https://github.com/WordPress/ai/issues/27) | Future | Providers | — | Surface 3rd-party provider plugins + progressive provider selection; OpenRouter demand — moved 1.1.0 → Future |
| [#37](https://github.com/WordPress/ai/issues/37) | Future | Platform | — | Make plugin an MCP reference impl; route an Experiment via MCP; adapter layer |
| [#47](https://github.com/WordPress/ai/issues/47) | Future | Community | — | Low/no-tech educational content for the WP 6.9 launch |
| [#90](https://github.com/WordPress/ai/issues/90) | Future | Content | — | Consolidate Title Generation options (dropdown vs settings); case-handling |
| [#262](https://github.com/WordPress/ai/issues/262) | Future | Providers | — | Provider-level model bucketing (pick provider, not model); future capability tiers |
| [#324](https://github.com/WordPress/ai/issues/324) | 1.2.0 | Content | — | ⭐ Evolve Refine → agentic/collaborative editorial via Gutenberg RTC |
| [#338](https://github.com/WordPress/ai/issues/338) | Future | Content | zeus2611 | ⭐ Analytics-aware content gap + traffic-surge amplification (Jetpack Stats first) |
| [#348](https://github.com/WordPress/ai/issues/348) | Future | Platform | — | ⭐ Unified AI Management Layer for Core (permissions+metering+routing); allow vs deny default |
| [#354](https://github.com/WordPress/ai/issues/354) | Future | Platform | — | Unified per-surface Abilities exposure controls; overlaps #348 |
| [#425](https://github.com/WordPress/ai/issues/425) | Future | Agentic/Media | — | Alt Text button placement (**Blocked**) |
| [#430](https://github.com/WordPress/ai/issues/430) | Future | Platform | — | ⭐ Skills in WP admin (Guidelines CPT→Skills; prompts vs script-exec split) |
| [#448](https://github.com/WordPress/ai/issues/448) | Future | Platform | — | ⚠️ WebMCP experiment (unstable W3C draft; polyfill) |
| [#502](https://github.com/WordPress/ai/issues/502) | Future | Providers | — | Provider plugin discovery/curation/labeling (parent of #27) |
| [#625](https://github.com/WordPress/ai/issues/625) | Future | Content | — | Social Content Generation experiment (platform-specific posts) |
| [#643](https://github.com/WordPress/ai/issues/643) | Future | Bug | — | ⚠️ Connectors/settings blank on WP 7.0; likely core/environment JS integrity |
| [#741](https://github.com/WordPress/ai/issues/741) | 1.2.0 | Bug/Infra | prasadkarmalkar | AI/Connectors admin pages flicker black/blank during initial render — moved 1.1.0 → 1.2.0 |
| [#791](https://github.com/WordPress/ai/issues/791) | Future | Content | — | Type Ahead loading-state cursor/animation (enhancement; gather community feedback first) |

### In progress (17 issues)
| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#191](https://github.com/WordPress/ai/issues/191) | 1.2.0 | Providers | coderGtm | Import/export of AI settings + provider config (PR #734) — moved Future → 1.2.0 |
| [#192](https://github.com/WordPress/ai/issues/192) | Future | Infra | — | Extension points for custom prompt templates (PR #770) |
| [#203](https://github.com/WordPress/ai/issues/203) | 1.2.0 | Platform | — | Extensibility hook for Ability Table columns (filter + meta surface) — moved Future → 1.2.0 |
| [#238](https://github.com/WordPress/ai/issues/238) | Future | Agentic/Media | TylerB24890 | Focus-aware crop suggestions (vision; Gutenberg focal-point UI) |
| [#307](https://github.com/WordPress/ai/issues/307) | Future | Platform | gziolo | Add AGENTS.md contributor onboarding |
| [#325](https://github.com/WordPress/ai/issues/325) | Future | Agentic/Media | TylerB24890 | Integrate media experiments with Gutenberg experimental Media Editor |
| [#452](https://github.com/WordPress/ai/issues/452) | 1.2.0 | Content | — | Content Classification: improve taxonomy relevance (Elementor feedback) — moved 1.1.0 → 1.2.0 |
| [#514](https://github.com/WordPress/ai/issues/514) | 1.2.0 | Content | dkotter | Comment Moderation: add comment value/relevance scoring — moved Future → 1.2.0 |
| [#600](https://github.com/WordPress/ai/issues/600) | 1.2.0 | Bug/Infra | — | "Enable AI" header toggle doesn't reflect aggregate sub-feature state — moved 1.1.0 → 1.2.0 |
| [#614](https://github.com/WordPress/ai/issues/614) | 1.2.0 | Content | prasadkarmalkar | Bulk summary generation (Bulk Actions on edit.php; PR #650) — moved 1.1.0 → 1.2.0 |
| [#660](https://github.com/WordPress/ai/issues/660) | 1.2.0 | Providers | — | UX: ambiguous "provider blocked by Connector Approvals" error |
| [#689](https://github.com/WordPress/ai/issues/689) | Future | Infra | i-anubhav-anand | Manual age-based Request Log cleanup control (PR #735) |
| [#690](https://github.com/WordPress/ai/issues/690) | 1.2.0 | Infra | hbhalodia | `uninstall.php` to clean DB table + options (privacy; PR #692) — moved Needs review → In progress, 1.1.0 → 1.2.0 |
| [#732](https://github.com/WordPress/ai/issues/732) | 1.2.0 | Bug/Infra | — | AI Request Logs miss non-SDK-transport providers (draft PR #757) — moved Future → 1.2.0 |
| [#736](https://github.com/WordPress/ai/issues/736) | 1.2.0 | Platform | — | Per-feature role/user access controls (draft PR #749) — moved Future → 1.2.0 |
| [#778](https://github.com/WordPress/ai/issues/778) | 1.2.0 | Infra | — | E2E: prefer user-facing Playwright locators (`getByRole`) over CSS/DOM |
| [#845](https://github.com/WordPress/ai/issues/845) | Future | Infra | dkotter | New Experiment: Markdown feeds (via `html-to-md`); implementing PR #855 — moved Backlog → In progress |

### Backlog (8)
| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#142](https://github.com/WordPress/ai/issues/142) | Future | Agentic/Media | — | Frontend chat agent (RAG over site content; visitors) |
| [#186](https://github.com/WordPress/ai/issues/186) | Future | Content | — | Tone adjustment controls (cross-experiment) |
| [#188](https://github.com/WordPress/ai/issues/188) | Future | Content | — | Persona-driven content generation |
| [#189](https://github.com/WordPress/ai/issues/189) | Future | Agentic/Media | — | ⭐ Admin Site Agent executing WP actions (opt-in, audited) |
| [#193](https://github.com/WordPress/ai/issues/193) | Future | Infra | — | Developer-only AI request/response log panel |
| [#282](https://github.com/WordPress/ai/issues/282) | Future | Agentic/Media | karmatosed | ⭐ Chat "AI Workspace" outside the editor (multi-step, capability-gated) |
| [#297](https://github.com/WordPress/ai/issues/297) | Future | Content | karmatosed | ⭐ Content Generation co-author experiment |
| [#844](https://github.com/WordPress/ai/issues/844) | Future | Agentic/Media | — | New Experiment: semantic search in wp-admin (blocked on #683) |

### To do (6)
| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#32](https://github.com/WordPress/ai/issues/32) | Future | Infra | — | AI Playground (prompt testing/debug tools) |
| [#190](https://github.com/WordPress/ai/issues/190) | Future | Agentic/Media | — | Site-wide content insights (read-only) — moved Backlog → To do |
| [#233](https://github.com/WordPress/ai/issues/233) | Future | Platform | — | Refactor experiments onto the `AI_Service` layer |
| [#339](https://github.com/WordPress/ai/issues/339) | Future | Bug | — | WP7RC1/Gutenberg 22.7.1 — can't keep connection alive |
| [#421](https://github.com/WordPress/ai/issues/421) | 1.2.0 | Agentic/Media | — | Detect C2PA manifests on upload (provenance) |
| [#507](https://github.com/WordPress/ai/issues/507) | 1.2.0 | Content | zeus2611 | Editorial Updates end flow → Visual Revisions — moved 1.1.0 → 1.2.0 |

### Triage (2)
| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#40](https://github.com/WordPress/ai/issues/40) | Future | Platform | gziolo, jorgefilipecosta | ⭐ Core Abilities set (foundational; granularity debate) |
| [#853](https://github.com/WordPress/ai/issues/853) | — | Bug | — | Generate_Image Ability uses a hardcoded timeout value; no milestone — board-new |

### Needs review (1)
| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#187](https://github.com/WordPress/ai/issues/187) | 1.2.0 | Content | yogeshbhutkar | Multilingual rewriting/translation (full-article PoC; draft PR #747) |

**Removed-board reference:** [`WordPress/abilities-api#84`](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later, but no longer appears on Project #240 as of the 2026-06-19 refresh.
---

## 10. How to refresh this document

> ⚙️ **Automated path:** [`wp-ai-roadmap-refresh.sh`](./wp-ai-roadmap-refresh.sh) does everything below in one command — re-pulls the board, diffs against the last snapshot (added / newly-Done / merged / status & milestone moves / removed), and can append a changelog row (`--update-changelog`). Run with no args for a read-only report; add `--save` to roll the baseline forward. The manual recipe below is what it automates.

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
- "WordPress AI" board == the WordPress/ai Showcase Plugin in practice (278/279 items).
- Roadmap signal = open ISSUES, not PRs (PRs are mostly the 200 "Done").
- Priority field is barely used; track via Status + Milestone.
- Strategic bets (⭐): #348, #40, #430, #297, #324, #338, #189, #282. Risk (⚠️): #448 (WebMCP), #643 (live regression).
- Watch core deps: WP 6.9 Abilities API, WP 7.0 AI Client, Gutenberg RTC/Media Editor/Guidelines→Skills, abilities-api repo.
-->
