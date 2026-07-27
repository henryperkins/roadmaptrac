# WordPress AI — Planning & Roadmap (Living Document)

> **Source board:** [github.com/orgs/WordPress/projects/240](https://github.com/orgs/WordPress/projects/240) — *"WordPress AI Planning & Roadmap"*
> *"A project board to provide oversight into the various focus areas of the WordPress AI team."*
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-27 (latest board-item activity: 2026-07-27) |
> | **Items captured** | 274 (full board, via GraphQL Projects API) |
> | **Plugin** | [`WordPress/ai`](https://github.com/WordPress/ai) — the official "AI" Showcase Plugin on WordPress.org |
> | **Latest shipped** | **v1.2.0** (shipped 2026-07-14) — 18th release; release issue [#864](https://github.com/WordPress/ai/issues/864) closed after plugin checks, tests, local testing, GitHub release, and WordPress.org deployment |
> | **In active development** | **v1.3.0** (18 open / 9 Done; 27 carded; no due date) · **Next:** v1.4.0 (4 issues, 2 now In progress) · **Backlog:** Future Release (41 open) |
> | **Maintained by** | _(you)_ — see [§10 How to refresh](#10-how-to-refresh-this-document) to regenerate the data |

**How to read this doc:** [§1 Composition](#1-board-composition) · [§2 Releases](#2-release-cadence) · [§3 Product model](#3-product-architecture) · [§4 Shipped](#4-shipped-done) · [§5 In progress](#5-in-progress) · [§6 Roadmap bets](#6-planned-roadmap--strategic-bets) · [§7 Undecided/blocked](#7-unplanned--undecided--blocked) · [§8 Strategic read & risks](#8-strategic-read--risks) · [§9 Full open-issue tracker](#9-appendix--full-open-issue-tracker-52) · [§10 Refresh](#10-how-to-refresh-this-document) · [§11 Changelog](#11-changelog)

> **📚 Companion documents (4-doc set):**
> 1. **This file** — strategy, board composition, release cadence, and the at-a-glance open-issue tracker.
> 2. **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** — deep per-issue dossiers, grouped by status. *(Current to 2026-07-27: all 52 board-open issues, plus #84 as a removed-board reference and 39 recently board-Done issues retained for reference.)*
> 3. **[`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md)** — the release-ordered delivery plan for all 67 non-Done cards, including 14 open board-tracked PRs and stale merged PR #484.
> 4. **[`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md)** — the 16-item Gutenberg + abilities-api dependency watchlist (11 + 5), plus full PR/release censuses for `WordPress/php-ai-client` and `WordPress/mcp-adapter`.

### Status legend (board's own taxonomy)
`Triage` → unsorted/new · `In discussion / Needs decision` → debated, **not** committed · `Backlog` / `To do` → planned · `In progress` → being built · `Needs review` → review-ready · `Done` → shipped/merged

---

## Executive summary

Project #240 remains the operational tracker for the [`WordPress/ai`](https://github.com/WordPress/ai) Showcase Plugin (273 of 274 cards; the other card is Google-provider issue #23). The plugin continues to organize user-facing AI capabilities as toggleable experiments over shared Connectors, AI Client, Abilities API, MCP, and request-log infrastructure.

This window is the **post-1.2.0 cleanup-and-execute phase**. The board *shrank* — 283 → 274 — but nothing was descoped: **ten already-Done 1.2.0 cards were de-carded in bulk** (#508, #793, #809, #815, #816, #818, #833, #839, #846, and spam #848), which is routine board hygiene after a release. Only one card was added: unmilestoned Triage issue **#890** (a mobile right-sidebar component proposal).

Meanwhile the **1.3.0 lane converted discussion into merges**. Six issues closed on the back of merged PRs — settings import/export (**#191**←#734), prompt-template extension points (**#192**←#770), taxonomy relevance (**#452**←#633), Editorial Updates → Visual Revisions (**#507**←#861), the Yoast meta-description interoperability bug (**#874**←#886), and the Abilities Explorer custom-provider gap (**#883**←#884) — taking 1.3.0 from 3 Done / 22 open to **9 Done / 18 open**. Five cards moved into In progress as implementation PRs opened against them: `AI_Service` refactor (**#233**←#898), C2PA detection (**#421**←#459, now an authoritative closing link), semantic search (**#844**←#891), and both 1.4.0 editorial experiments — internal links (**#875**←#887) and permalink slugs (**#876**←#897). v1.4.0 is therefore no longer purely discussion-stage.

The primary repository census fell from **37 to 32 open PRs**: twelve PRs left (ten merged, including the previously-unexplained #877/#878; #851 and #885 closed unmerged) and seven opened. Coverage is now **14 direct + 15 linked + 0 routine + 0 off-board + 3 unexplained**. The unexplained set turned over completely and is more consequential than the last one: **#888** adds an entire **Text to Speech** experiment (+4,216 lines, 28 files) and **#892** vendors **PHP AI Client embeddings** into the plugin (+4,394 lines) — both authored by a maintainer, neither represented on the board.

The forward roadmap still converges on four bets: (A) Abilities as the universal tool layer, now including opt-in controls for standalone abilities; (B) a provider-agnostic Connectors ecosystem; (C) an editorial lifecycle that expands from single-field generators into review, linking, slugs, translation, and agentic refinement; and (D) conversational/site-agent and semantic-search surfaces. The near-term delivery lane is **v1.3.0 (18 non-Done cards)**, followed by **v1.4.0 (4 issues, half of them now building)**; **Future Release holds 41 cards**.

The repository radar covers the full open-PR and release streams for the two foundational upstream repositories alongside `WordPress/ai`, and both moved this window: **`WordPress/php-ai-client` is now at 21 open PRs (was 20) with latest release 1.4.0 (2026-07-15); `WordPress/mcp-adapter` jumped to 16 open PRs (was 12) with latest release v0.5.0 (2026-04-15)**. These are census-only signals: their PRs are not required to appear on Project #240 and do not create roadmap-coverage failures.

---

## 1. Board composition

| Dimension | Breakdown |
|---|---|
| **Total items** | **274** = 209 PRs + 65 issues |
| **By status** | Done **207** · In progress **26** · In discussion/Needs decision **22** · Backlog **7** · Needs review **5** · To do **4** · Triage **3** |
| **Open work** | **67 non-Done cards** = 52 open issues + 15 PR cards *(14 open; #484 is merged but still board-Needs review)* |
| **By repo** | `WordPress/ai` **273** · `WordPress/ai-provider-for-google` **1** (#23). `WordPress/abilities-api` #84 is not on Project #240. |
| **Cross-repo dependency scope** | Separate watchlist: **16** dependencies (10 open, 3 closed, 3 merged), tracked in [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md). |
| **Full repository census** | `WordPress/ai`: **32** open PRs / release **1.2.0** · `WordPress/php-ai-client`: **21** / **1.4.0** · `WordPress/mcp-adapter`: **16** / **v0.5.0**. Project #240 coverage applies only to `WordPress/ai`. |
| **"Team" field** | No Team values are returned in the current Projects API snapshot; use repo + labels/status for classification. |
| **"Priority" field** | Barely used; prioritization is expressed through Status + Milestone. |
| **Board views** | Prioritized backlog · AI plugin · Status board · Roadmap (timeline) · Bugs 🐛 · My items |

**Caveat for maintainers:** "Done" (**207**) is overwhelmingly merged PRs; the forward-looking signal lives in the **52 open issues** and **15 non-Done PR cards**. Total item count is not a scope proxy — it fell by 9 this window purely because finished 1.2.0 cards were removed from the board.

---

## 2. Release cadence

The plugin has shipped **18 releases**, most recently **v1.2.0 on 2026-07-14**. The board uses v1.3.0 as the active delivery lane and v1.4.0 for the next set of editorial experiments; neither has a due date.

| Milestone | Board cards | State | Meaning |
|---|---:|---|---|
| 0.1.0 → 0.9.0 | 134 | 133 Done / 1 stale | Build-out history; #484 is merged but still board-Needs review under 0.9.0. |
| 1.0.0 | 3 | ✅ Done | Stability milestone aligned with WordPress 7.0 / the Abilities API. |
| 1.0.1 | 8 | ✅ Done | Prior patch release. |
| 1.0.2 | 3 | ✅ Done | Prior patch release (2026-06-16); several already-Done cards were later removed from the board. |
| 1.1.0 | 11 | ✅ Done | Shipped 2026-07-01; all remaining cards are Done. |
| **1.2.0** | 13 | ✅ 12 Done / 1 open | **Shipped 2026-07-14**, then trimmed 21 → 13 as eight already-Done cards were de-carded. The one non-Done card is external Google-provider issue #23, not unfinished `WordPress/ai` release work. |
| **1.3.0** | 27 | 🚧 9 Done / 18 open | **Active lane:** 11 issues + 7 open PRs. Gained #192 and #874 by milestone move; six of its issues closed this window. No due date. |
| **1.4.0** | 4 | 🚧 2 In progress / 2 In discussion | Next editorial-experiment lane: #27 and #324 still debated; #875 and #876 now have implementation PRs (#887, #897). |
| **Future Release** | 43 | 📋 2 Done / 41 open | Long-range backlog: 34 issues + 7 PRs remain non-Done. |
| _(no milestone)_ | 28 | 26 Done / 2 open | Triage bugs #869 (provider-data iframe mismatch) and #890 (mobile right sidebar). |

*Sums to 274 cards.*

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

Board-Done now reads **207** — down from 209 not because anything regressed, but because **ten already-Done cards were de-carded** while **eight cards newly reached Done**.

The eight newly-Done cards are the substance of this window, and six of them are 1.3.0 issues closed by merged PRs:

- **#191** Settings + provider import/export — PR #734 merged 2026-07-24 (coderGtm).
- **#192** Custom prompt-template extension points — PR #770 merged 2026-07-20 (the-hercules); re-milestoned Future Release → 1.3.0 on the way out.
- **#452** Content Classification taxonomy relevance — PR #633 merged 2026-07-21 (saarnilauri).
- **#507** Editorial Updates → Visual Revisions — PR #861 merged 2026-07-24 (zeus2611).
- **#874** Yoast meta-description interoperability — PR #886 merged 2026-07-20 (hbhalodia), after the reporter traced the failure to Yoast's own `yoast-seo/editor` store and `post`-only REST meta registration; also re-milestoned from no-milestone → 1.3.0.
- **#883** Abilities Explorer custom-provider filter + statistics — PR #884 merged 2026-07-24 (azizulhasan), which widened scope to fix `get_statistics()` bucketing as well.

The other two are PR cards: **#882** (Suggest Reply screencast) merged, and **#851** (the deliberately non-mergeable embeddings PoC) closed unmerged — its successor is now off-board PR #892.

The ten de-carded cards were all shipped 1.2.0 work plus the spam issue: #508, #793, #809, #815, #816, #818, #833, #839, #846, #848. This is the same post-release hygiene pass seen after 1.1.0; it moves no work.

**v1.2.0 remains the latest release (2026-07-14).** Its release checklist recorded passing plugin checks, automated tests, local testing, GitHub release creation, and WordPress.org deployment. The only non-Done card still labeled 1.2.0 is Google-provider issue #23 in another repository.

The durable shipped foundation remains:

- Toggleable experiments over shared Connectors and the WordPress AI Client.
- Abilities Explorer and an expanding set of read/manage abilities.
- MCP integration and request-log observability.
- Type Ahead, Suggest Reply, Content Classification, generation, summarization, and editorial workflows.
- Repeated accessibility, internationalization, lifecycle, and provider-approval hardening.

---

## 5. In progress

The active build wave is still **v1.3.0**, now leaner at 18 non-Done cards (11 issues + 7 PRs). Its main clusters are:

- **Abilities and platform:** the standalone-abilities toggle (#863, To do, draft PR #881), `core/manage-settings` (#764), `core/read-nav-menus` (#858), native vector search (#683), and role/user controls (#736, PR #749).
- **Editorial and content:** translation (#187, PR #747), comment-value scoring (#514, PR #681), Markdown feeds (#845, PR #855), and post-meta prefix normalization (#866, PR #867).
- **Reliability and lifecycle:** provider-approval error copy (#660, PR #759), plugin uninstall cleanup (#690, PR #692), non-SDK request logging (#732, PR #757), and admin-page flicker (#741).
- **Provenance:** C2PA manifest detection (#421) moved To do → In progress; PR #459 is now recognized as its **authoritative closing PR**, not merely a conceptual sibling.
- **Maintenance:** dependency alignment (#777/#832) and alt-text URL matching (#621).

**Beyond 1.3.0, four cards started building this window.** The `AI_Service` refactor (#233, PR #898) and semantic search (#844, PR #891) left To do/Backlog for In progress, and both 1.4.0 editorial experiments now have code: internal-link suggestions (#875, PR #887, +2,050 lines) and permalink-slug generation (#876, PR #897, +2,000 lines). v1.4.0 is half-committed rather than purely directional.

Two unmilestoned bugs sit in Triage: **#869** (provider data attached only to the block-editor iframe, needs a clean-environment repro) and board-new **#890** (a mobile right-sidebar component proposal, no discussion yet).

The repo has **32 open PRs**: 14 are represented by open board PR cards, while 18 are untracked by a PR card (all substantive — there are no routine dependency PRs open this window). Several untracked PRs implement board issues, so board status must not be read as the complete code-in-flight view — and three untracked PRs have no board representation at all (see [§7](#7-unplanned--undecided--blocked)).

Two additional full-repository censuses expose upstream implementation and release movement without folding it into Project #240: **21 open PRs in `WordPress/php-ai-client`** (+1: #264, model context-window metadata and proactive token-limit checks) and **16 in `WordPress/mcp-adapter`** (+4: #251 concurrent-session overwrites, #252 websocket-driver bump, #254 inherited public ability exposure, #256 pre-tool-call completion). Their complete normalized PR records, readiness fields, releases, diffs, and independent snapshots are emitted by `wp-ai-roadmap-refresh.sh`; only the primary `WordPress/ai` census is joined to the roadmap board.

*(Full per-issue detail is in [§9](#9-appendix--full-open-issue-tracker-52).)*

---

## 6. Planned roadmap — strategic bets

Four converging directions. Most sit in **"Future Release"** (uncommitted) unless noted.

### A. Abilities API as the universal tool layer → Platform & Standards
The keystone bet: **`name + description + JSON Schema + implementation`** as the primitive that bridges WordPress into every agent standard.

- **#40 Core Abilities** *(Triage)* — the foundational `core/*` ability set (CRUD posts/pages/users/media/settings, plugin activate/update; destructive actions excluded for v1). **Key debate:** collapse per-post-type CRUD into one `create_post(post_type)` (consensus *yes* — MCP tool caps: 128 OpenAI / 512 Google) vs. granular abilities for Command Palette UX. Owners: gziolo, jorgefilipecosta. *Foundational, core-dependent.*
- **#348 Unified AI Management Layer for Core** — a single Core plane for structured **permissions + usage metering/budgets + capability-aware provider routing**, consolidating ~6 fragmented community plugins; hooks the existing `wp_ai_client_prevent_prompt` filter (zero breaking changes). **Open:** allow- vs **deny-by-default** (commenters favor deny). ⭐ *Major bet.*
- **#354 Unified Abilities exposure controls** — central per-"surface" control over which abilities are exposed where (every MCP server auto-becomes a surface); overlaps #348. Warns: without this, every plugin ships its own surface → mess.
- **#736 Per-feature role/user access controls** *(In progress; PR #749 by Infinite-Null, now out of draft but DIRTY)* — expose role/user access controls per Experiment/feature; complements the #348/#354 governance cluster at the feature granularity.
- **#21 Supporting thousands of abilities** *(Question)* — exposing every ability 1:1 as an MCP tool degrades model selection. Proposes a **layered-tool pattern** (3 tools: `get_abilities_by_category` / `get_ability_info` / `use_ability`) with a category taxonomy.
- **#430 Skills in a WordPress admin context** — map "Skills" into WP (Command Palette `/audit-accessibility`); gziolo is evolving the **Guidelines CPT → Skills** in Gutenberg. **Open:** split user-authored prompts/workflows from full agent Skills with script execution (script bundling is the blocker). ⭐ *Major bet, cross-repo (Gutenberg).*
- **#448 WebMCP experiment** — integrate `navigator.modelContext.registerTool` so a browser-native agent can drive WP. **Risk:** WebMCP is an **unstable W3C Community Group draft**, no browser ship commitment; lean on a polyfill + Experiment status for easy retirement. ⚠️ *Speculative.*
- **#37 MCP usage & request routing** — make the plugin a **reference MCP implementation** (route an Experiment via MCP; reusable adapter; provider switching).
- Supporting: **#233** (refactor experiments onto `AI_Service` — *moved To do → In progress; PR #898 by theaminulai authoritatively closes it*), **#203** (extensibility hook for Ability Table columns, Future Release), **#307** (AGENTS.md), **#32** (AI Playground debug tool), plus **`core/read-content`** (#739, merged Done in 1.2.0), **`core/manage-settings`** (#764, 1.3.0), **`core/read-nav-menus`** (#858, 1.3.0), and the standalone-abilities toggle (#863, draft PR #881). **`core/read-users`** (#774) merged earlier; off-board #856 is no longer open. **Abilities Explorer custom-provider support (#883) shipped** via PR #884. The experiment `register()` → `init()` rename (#145) shipped board-Done earlier. Upstream `WordPress/abilities-api` **#84** (generic CRUD across post types; client vs server `execute_callback`) remains open, but is no longer on Project #240.

### B. Connectors, Providers & Model Management
Direction settled: **thin core Connectors screen discovering independent per-provider plugins** (the bundle-everything path, PR #148, was abandoned).

- **#502 Provider plugin discovery/curation/labeling** — the strategic parent. Three unresolved axes: discovery model (hardcoded list vs WP.org Plugins API vs `connector` tag), curation/"vetted" concept, and official-vs-third-party labeling.
- **#27 Surface additional provider plugins on Connectors** *(1.4.0)* — list third-party providers + "progressive provider selection" (hide UI when a valid provider exists); host pre-config via constants/filters. **Strong demand for OpenRouter** (one key, many models).
- **#262 Provider-level model bucketing** — replace hard-coded model priority lists with a user-facing **provider preference** (not specific models); future capability tiers (fast/cheap vs high-reasoning). *Scope being questioned now that a per-experiment "developer mode" already exposes provider+model.*
- **#191 Settings + provider import/export** *(✅ board-Done — PR #734 merged 2026-07-24 under 1.3.0)* — portability for agencies/hosts/multisite finally landed; the secure-credential-handling debate that held it up is resolved in the merged implementation.
- **#632** *(board-Done / closed)* deactivate a connector without losing its key · **#660** *(Needs review / 1.3.0; PR #759)* clearer "blocked by Connector Approvals" error · **#815** *(1.2.0, board-Done via PR #830 and now de-carded)* surface an admin notice when Connector Approvals still needs the AI plugin granted access to a connected provider (WPORG support report; related to #660).

### C. Content & Editorial Experiments (the authoring lifecycle)
Expanding from per-field generators toward full co-authoring.

- **#297 Content Generation** — native Block Editor **co-author** (first drafts from title, expand sections, rewrite selection; `/ai` slash command, ghost-typing, accept/reject diffs). Well-specified, awaiting design (karmatosed). ⭐ *Major bet.*
- **#324 Evolve "Refine" → agentic/collaborative editorial** *(1.4.0)* — a "WordPress AI" user editing live via Gutenberg **Real-Time Collaboration**; deferred to let RTC stabilize. ⭐ *Major bet.*
- **#338 Analytics-aware content & amplification** — content-gap mining (low-engagement on-site searches) + traffic-surge social amplification, via a `Stats_Provider` adapter (**Jetpack Stats first**); split into two sub-issues. ⭐ *Major bet — closes ideation→distribution loop.*
- **#625 Social Content Generation** — platform-specific posts (Bluesky/Mastodon/LinkedIn) from post content; persist to meta; hooks for Jetpack Social/Blog2Social.
- **#508 "Suggest Reply"** for comments + Activity widget *(shipped in 1.2.0 via PR #724; now de-carded from the board)* — the 1.2.0 lane's first genuinely new experiment (re-introduces #155's removed feature properly; human review, **not** auto-reply).
- **#875 Internal-link suggestions** and **#876 permalink-slug suggestions** *(both 1.4.0, both moved In discussion → In progress)* — the newest editorial pair, now with implementation PRs #887 (Infinite-Null) and #897 (milindmore22). Where these surface in the editor is still the open product question.
- **Reusable control layer:** tone (#186), multilingual rewriting/translation (#187, *Needs review, 1.3.0* — full-article PoC by yogeshbhutkar; PR #747, CHANGES_REQUESTED), persona/voice (#188).
- Enhancements: **#614** bulk summary generation *(Done in 1.2.0)* · **#90** consolidate Title Generation options · **#507** Editorial Updates → Visual Revisions *(✅ board-Done — PR #861 merged 2026-07-24)* · **#452** classification relevance *(✅ board-Done — PR #633 merged 2026-07-21)*.

### D. Agentic / Chat / Site-Agent + Media
The biggest **directional shift** — from single-task helpers to a conversational agent that takes actions. Three convergent issues:

- **#142 Frontend chat agent** — "chat with my site" for public **visitors** (RAG over owner-selected content + FAQ, citations). Designed proposal; needs an embeddings/indexing pipeline (shared with #282).
- **#282 Admin "AI Workspace"** — full-screen wp-admin multi-step chat (Site-Editor-styled, DataViews), capability-gated Search/RAG middleware, actionable artifacts ("Create Draft"). Most fleshed-out spec; assigned karmatosed for mockups.
- **#189 Site Agent** — natural language → **explicit, verifiable WP actions** (create posts, install plugins, change settings). Opt-in, disabled by default, capability-respecting, fully auditable. ⭐ *Major bet (idea-stage).*
- **#190 Site-wide insights** — read-only cross-content analysis (themes/gaps/trends); the safe data layer feeding the agentic surfaces.

**Media & Vision:** focus-aware crop suggestions (#238) · integrate media experiments with Gutenberg's experimental **Media Editor** (#325) · **C2PA** provenance detection on upload (#421, *1.3.0, now In progress* — PR #459 is its authoritative closing PR) · alt-text button placement (#425, **Blocked**; the volunteer implementation PR #885 was closed unmerged on 2026-07-20, so the issue is again unimplemented).

**Search/RAG:** two parallel efforts. Native vector search (#683, draft PR, 1.3.0) is the board-tracked MariaDB-backed semantic-search/RAG experiment with fallback post-meta embeddings; separately, **#844 semantic search in wp-admin** moved Backlog → In progress behind PR #891. Underneath both, off-board PR **#892** vendors PHP AI Client embedding support into the plugin behind an `SDK_Overlay` — needed because the core route (`wordpress-develop#12530`) slipped from WP 7.1 to 7.2.

**Extensibility & community:** custom prompt-template hooks (#192, *✅ board-Done — PR #770 merged 2026-07-20*) · developer-only request/response log panel (#193) · Comment Moderation value/relevance scoring (#514, PR #681) · low/no-tech educational content for the WP 6.9 launch (#47).

---

## 7. Unplanned / undecided / blocked

- **22 In discussion / Needs decision cards** = 20 issues + exploratory PRs #211 and #224. Down from 24: #875 and #876 graduated to In progress once their PRs opened.
- **3 Triage issues:** #40 (Core Abilities, Future Release), #869 (provider-data iframe/top-window mismatch, unmilestoned), and board-new #890 (mobile right-sidebar display component, unmilestoned, no discussion yet).
- **Blocked direction:** #425 still depends on a usable Media Editor surface; PR #494 remains the corresponding blocked implementation, and the community attempt #885 was closed unmerged this window.
- **Review-ready issues:** only #187 and #660 remain Needs review under 1.3.0 — #507 merged.
- **Board hygiene:** merged PR #484 still shows Needs review under 0.9.0.
- **⚠️ Roadmap-visibility gap (new and material):** three open PRs have no board representation at all — **#888** (a complete Text to Speech experiment registering `ai/speech-generation` and `ai/speech-import` abilities, gated on provider-plugin PRs `ai-provider-for-openai#42` / `ai-provider-for-google#31`), **#892** (PHP AI Client embeddings vendored via `SDK_Overlay`), and **#889** (request-log accessibility/keyboard fix, whose body still carries an unfilled `Closes #<issue-number>` template line). The first two are maintainer-authored feature work of ~4,200–4,400 lines each; a reader of Project #240 alone would not know either exists.
- **Key open decisions:** ability governance/granularity (#40/#348/#354/#863), WebMCP standard risk (#448), provider discovery (#27/#502), where internal-link/slug suggestions should surface (#875/#876), and whether Text to Speech (#888) becomes a carded experiment.

---

## 8. Strategic read & risks

**Where it is heading:** discrete AI helpers are becoming a governed, agent-capable WordPress platform. Abilities provide the action primitive; Connectors and model preferences provide provider independence; editorial experiments provide user-facing workflows; search/RAG, MCP/WebMCP, and site-agent ideas connect those layers.

**Watch-items / risks:**

1. **External dependencies** — WordPress core, the AI Client, Gutenberg Media Editor/RTC/Guidelines work, and abilities-api can change delivery paths without changing Project #240. This window made the cost concrete: the WP 7.1 → 7.2 slip of core embedding support (`wordpress-develop#12530`) pushed the plugin to vendor PHP AI Client embedding code itself (#892).
2. **Governance before write abilities** — #863 makes the safety question concrete: standalone/read abilities are currently always registered, while future write abilities need deliberate enablement and discoverability controls. #888 would add two more (`ai/speech-generation`, `ai/speech-import`) outside that governance conversation.
3. **Backlog-to-commitment gap** — Future Release still contains 41 non-Done cards, but 1.3.0 provides a defined 18-card active lane and 1.4.0 a four-issue next lane that is now half in progress.
4. **Compatibility regressions** — #869 still needs a clean-environment reproduction. The comparable #874 shows the pattern resolving well: it was root-caused to Yoast's own store/REST-registration design and fixed in PR #886 within four days.
5. **Board ≠ repo** — 18 of 32 open PRs lack a PR card, and 3 of those have no roadmap link at all. Issue cards often carry the roadmap intent while implementing PRs remain off-board; this window that gap swallowed two large maintainer-authored features.
6. **Stale/closed cards** — #484 remains non-Done despite being merged; newly added cards can also arrive already Done, so counts require state + board-status reconciliation.
7. **Board totals are not scope** — the board shed 9 cards this window (283 → 274) entirely through de-carding finished 1.2.0 work. Always reconcile a falling total against the removed list before reading it as lost scope.

---

## 9. Appendix — full open-issue tracker (52)

> 📄 Deep dossiers live in [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md). The current scope is **52 board-open issues**: 51 in `WordPress/ai` plus Google-provider issue #23. PR cards are tracked separately in [`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md).

Grouped by current board status. Theme tags are editorial aids; Status and Milestone come from Project #240.

### In discussion / Needs decision (20)

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
| [#338](https://github.com/WordPress/ai/issues/338) | Future | Content | zeus2611 | New Experiments: Analytics-aware content and amplification recommendations |
| [#348](https://github.com/WordPress/ai/issues/348) | Future | Platform | — | Feature Request: Unified AI Management Layer for WordPress Core |
| [#354](https://github.com/WordPress/ai/issues/354) | Future | Platform | — | Unifiied Abilities exposure controls |
| [#425](https://github.com/WordPress/ai/issues/425) | Future | Agentic/Media | — | Update placement of Alt Text generation buttons |
| [#430](https://github.com/WordPress/ai/issues/430) | Future | Platform | — | Skills in a WordPress admin context |
| [#448](https://github.com/WordPress/ai/issues/448) | Future | Platform | — | Add WebMCP experiment |
| [#502](https://github.com/WordPress/ai/issues/502) | Future | Providers | — | Define how AI provider plugins are discovered, labeled, and surfaced in Connectors |
| [#600](https://github.com/WordPress/ai/issues/600) | Future | Bug/Infra | — | `Enable AI` header toggle doesn't reflect aggregate state of sub-features |
| [#625](https://github.com/WordPress/ai/issues/625) | Future | Content | — | New Experiment: Social Content Generation for platform-specific social posts |
| [#643](https://github.com/WordPress/ai/issues/643) | Future | Bug | — | "AI" plugin 1.0.1 – Connectors and AI settings pages load blank (JavaScript error) on WordPress 7.0 |
| [#741](https://github.com/WordPress/ai/issues/741) | 1.3.0 | Bug/Infra | prasadkarmalkar | AI Admin Pages Exhibit Visible Flicker During Initial Render |
| [#791](https://github.com/WordPress/ai/issues/791) | Future | Content | — | Add loading animation/custom cursor for Type Ahead |

### In progress (16)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#203](https://github.com/WordPress/ai/issues/203) | Future | Platform | — | Add extensibility hook for custom Ability Table columns |
| [#233](https://github.com/WordPress/ai/issues/233) | Future | Platform | — | Refactor experiments to leverage AI_Service layer |
| [#238](https://github.com/WordPress/ai/issues/238) | Future | Agentic/Media | TylerB24890 | Add focus-aware crop suggestions |
| [#307](https://github.com/WordPress/ai/issues/307) | Future | Platform | gziolo | Add AGENTS.md to streamline contributor onboarding |
| [#325](https://github.com/WordPress/ai/issues/325) | Future | Agentic/Media | TylerB24890 | Integrate media features and experiments with Gutenberg's experimental Media Editor |
| [#421](https://github.com/WordPress/ai/issues/421) | 1.3.0 | Agentic/Media | — | WordPress should detect C2PA manifests on upload |
| [#514](https://github.com/WordPress/ai/issues/514) | 1.3.0 | Content | — | Add comment value / relevance to Comment Moderation experiment |
| [#689](https://github.com/WordPress/ai/issues/689) | Future | Infra | i-anubhav-anand | Add a user-facing control for automatic log cleanup |
| [#690](https://github.com/WordPress/ai/issues/690) | 1.3.0 | Infra | hbhalodia | Plugin does not clean up database table and options on uninstall |
| [#732](https://github.com/WordPress/ai/issues/732) | 1.3.0 | Bug/Infra | — | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible |
| [#736](https://github.com/WordPress/ai/issues/736) | 1.3.0 | Platform | — | Expose role/user access controls per feature/experiment |
| [#844](https://github.com/WordPress/ai/issues/844) | Future | Agentic/Media | — | New Experiment: Semantic search in wp admin |
| [#845](https://github.com/WordPress/ai/issues/845) | 1.3.0 | Infra | dkotter | New Experiment: Markdown feeds (powered by `html-to-md`) |
| [#866](https://github.com/WordPress/ai/issues/866) | 1.3.0 | Bug/Infra | hbhalodia | Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix |
| [#875](https://github.com/WordPress/ai/issues/875) | 1.4.0 | Content | — | New Experiment: Suggest internal links within post content |
| [#876](https://github.com/WordPress/ai/issues/876) | 1.4.0 | Content | — | New Experiment: Suggest permalink slugs |

### Backlog (7)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#142](https://github.com/WordPress/ai/issues/142) | Future | Agentic/Media | — | Frontend chat agent powered by site content |
| [#186](https://github.com/WordPress/ai/issues/186) | Future | Content | — | Add tone adjustment controls for AI-generated content |
| [#188](https://github.com/WordPress/ai/issues/188) | Future | Content | — | Add persona-driven content generation experiments |
| [#189](https://github.com/WordPress/ai/issues/189) | Future | Agentic/Media | — | Explore an admin Site Agent for executing WordPress actions |
| [#193](https://github.com/WordPress/ai/issues/193) | Future | Infra | — | Add developer-only log panel for inspecting AI provider responses |
| [#282](https://github.com/WordPress/ai/issues/282) | Future | Agentic/Media | karmatosed | Chat experiment: Integration outside the editor and outside single-task AI use |
| [#297](https://github.com/WordPress/ai/issues/297) | Future | Content | karmatosed | New experiment: Content Generation |

### To do (4)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#32](https://github.com/WordPress/ai/issues/32) | Future | Infra | — | Add AI Playground interface (prompt testing & debug tools) |
| [#190](https://github.com/WordPress/ai/issues/190) | Future | Agentic/Media | yogeshbhutkar | Add site-wide AI-powered content insights |
| [#339](https://github.com/WordPress/ai/issues/339) | Future | Bug | — | AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin |
| [#863](https://github.com/WordPress/ai/issues/863) | 1.3.0 | Platform | — | New Experiment: Abilities toggle |

### Triage (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#40](https://github.com/WordPress/ai/issues/40) | Future | Platform | gziolo, jorgefilipecosta | WordPress Core Abilities |
| [#869](https://github.com/WordPress/ai/issues/869) | — | Bug/Providers | — | window.aiProviderData is only attached to the block-editor iframe snapshot, never to the top window, causing "requires an AI Connector" false positives |
| [#890](https://github.com/WordPress/ai/issues/890) | — | UI/Mobile | — | Add mobile right sidebar display component |

### Needs review (2)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#187](https://github.com/WordPress/ai/issues/187) | 1.3.0 | Content | yogeshbhutkar | Support multilingual rewriting and translation via AI |
| [#660](https://github.com/WordPress/ai/issues/660) | 1.3.0 | Providers | — | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals |

**Removed-board reference:** [`WordPress/abilities-api#84`](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not counted in Project #240.

---

## 10. How to refresh this document

> ⚙️ **Automated path:** [`wp-ai-roadmap-refresh.sh`](./wp-ai-roadmap-refresh.sh) does everything below in one command — re-pulls the board, diffs against the last snapshot (added / newly-Done / merged / status & milestone moves / removed), fetches the full PR/release census for all repositories declared through [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json), refreshes the curated dependency watchlist, and can append a changelog row (`--update-changelog`). Run with no args for a read-only report; add `--save` to roll all board, repository, release, and dependency baselines forward. The manual recipe below is what it automates.
>
> **Normal vs. strict refresh.** The default (normal) refresh is *warning-only*: any data-quality or coverage problem — an unreachable dependency, a substantive open PR with no board representation — is reported in the output (`.validation` in JSON, stderr lines otherwise) but never blocks the board report, and the run exits `0`. `./wp-ai-roadmap-refresh.sh --strict [--json]` runs the same read-only pipeline as an **audit**: it emits the complete report first, then exits `2` when any validation error remains (exit `1` is reserved for operational failures that prevented a report at all). A strict failure also suppresses `--save` and `--update-changelog` ("persistence skipped"), so a red audit never rolls the baseline forward.
>
> Strict is a **scheduled visibility audit, not a merge gate**: whether every substantive `WordPress/ai` PR is linked to Project #240 depends on upstream contributor behavior, so a persistent red result means *unresolved roadmap visibility* (work in flight that the board doesn't show), not a broken tracker. Point-in-time coverage: 32 open PRs = 14 direct board PR cards + 15 linked to board issues (14 authoritative closing references + 1 source-labeled fallback, #881→#863 via branch name) + 0 routine dependency PRs + 3 unexplained (#888, #889, #892 — the current strict-audit failures). The prior failures #877/#878 both merged on 2026-07-20, which is the normal way a red audit clears.

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
- "WordPress AI" board == the WordPress/ai Showcase Plugin in practice (273/274 items).
- Roadmap signal = open ISSUES plus the non-Done PR lane; PRs are most of the 207 Done cards.
- Board total can FALL without scope loss: post-release the team de-cards finished milestone cards in bulk (10 removed 2026-07-27). Always check .board.removed before narrating a drop.
- Priority field is barely used; track via Status + Milestone.
- Strategic bets (⭐): #348, #40, #430, #297, #324, #338, #189, #282. Risk (⚠️): #448 (WebMCP), #643 (live regression).
- Watch core deps: WP 6.9 Abilities API, WP 7.0 AI Client, Gutenberg RTC/Media Editor/Guidelines→Skills, abilities-api repo.
-->
