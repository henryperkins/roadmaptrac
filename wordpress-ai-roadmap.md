# WordPress AI — Planning & Roadmap (Living Document)

> **Source board:** [github.com/orgs/WordPress/projects/240](https://github.com/orgs/WordPress/projects/240) — *"WordPress AI Planning & Roadmap"*
> *"A project board to provide oversight into the various focus areas of the WordPress AI team."*
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-18 (latest board-item activity: 2026-07-18) |
> | **Items captured** | 283 (full board, via GraphQL Projects API) |
> | **Plugin** | [`WordPress/ai`](https://github.com/WordPress/ai) — the official "AI" Showcase Plugin on WordPress.org |
> | **Latest shipped** | **v1.2.0** (shipped 2026-07-14) — 18th release; release issue [#864](https://github.com/WordPress/ai/issues/864) closed after plugin checks, tests, local testing, GitHub release, and WordPress.org deployment |
> | **In active development** | **v1.3.0** (22 open / 3 Done; 25 carded; no due date) · **Next:** v1.4.0 (4 discussion-stage issues) · **Backlog:** Future Release (43 open) |
> | **Maintained by** | _(you)_ — see [§10 How to refresh](#10-how-to-refresh-this-document) to regenerate the data |

**How to read this doc:** [§1 Composition](#1-board-composition) · [§2 Releases](#2-release-cadence) · [§3 Product model](#3-product-architecture) · [§4 Shipped](#4-shipped-done) · [§5 In progress](#5-in-progress) · [§6 Roadmap bets](#6-planned-roadmap--strategic-bets) · [§7 Undecided/blocked](#7-unplanned--undecided--blocked) · [§8 Strategic read & risks](#8-strategic-read--risks) · [§9 Full open-issue tracker](#9-appendix--full-open-issue-tracker-57) · [§10 Refresh](#10-how-to-refresh-this-document) · [§11 Changelog](#11-changelog)

> **📚 Companion documents (4-doc set):**
> 1. **This file** — strategy, board composition, release cadence, and the at-a-glance open-issue tracker.
> 2. **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** — deep per-issue dossiers, grouped by status. *(Current to 2026-07-18: all 57 board-open issues, plus #84 as a removed-board reference and 33 recently board-Done issues retained for reference.)*
> 3. **[`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md)** — the release-ordered delivery plan for all 74 non-Done cards, including 16 open board-tracked PRs and stale merged PR #484.
> 4. **[`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md)** — the 16-item Gutenberg + abilities-api dependency watchlist (11 + 5), plus full PR/release censuses for `WordPress/php-ai-client` and `WordPress/mcp-adapter`.

### Status legend (board's own taxonomy)
`Triage` → unsorted/new · `In discussion / Needs decision` → debated, **not** committed · `Backlog` / `To do` → planned · `In progress` → being built · `Needs review` → review-ready · `Done` → shipped/merged

---

## Executive summary

Project #240 remains the operational tracker for the [`WordPress/ai`](https://github.com/WordPress/ai) Showcase Plugin (282 of 283 cards; the other card is Google-provider issue #23). The plugin continues to organize user-facing AI capabilities as toggleable experiments over shared Connectors, AI Client, Abilities API, MCP, and request-log infrastructure.

The major change in this window is a release transition: **v1.2.0 shipped on 2026-07-14**, and most unfinished work moved to **v1.3.0**. Nine baseline cards moved to Done, including bulk summaries (#614), E2E locator hardening (#778), the configurable image-generation timeout (#853), and merged PRs #739/#758/#857. Four new cards arrived already Done (#864/#865/#870/#872), while six new open issues entered the roadmap: the Abilities toggle (#863), meta-key normalization (#866), two unmilestoned compatibility bugs (#869/#874), and two 1.4.0 editorial experiments (#875/#876).

A same-day follow-up refresh added unmilestoned In-progress issue **#883** (custom providers are absent from the Abilities Explorer filter and statistics) and two off-board implementation PRs. **#884 authoritatively closes #883**; **#885 only title-matches #425 through fallback parsing**, so it is tracked as non-authoritative relationship evidence. The board is now 283 cards, and the primary repository census is 37 open PRs.

The forward roadmap still converges on four bets: (A) Abilities as the universal tool layer, now including opt-in controls for standalone abilities; (B) a provider-agnostic Connectors ecosystem; (C) an editorial lifecycle that expands from single-field generators into review, linking, slugs, translation, and agentic refinement; and (D) conversational/site-agent and semantic-search surfaces. The near-term delivery lane is **v1.3.0 (22 non-Done cards)**, followed by **v1.4.0 (4 discussion-stage issues)**; **Future Release remains 43 cards**.

The repository radar now covers the full open-PR and release streams for the two foundational upstream repositories alongside `WordPress/ai`: **`WordPress/php-ai-client` has 20 open PRs and latest release 1.4.0 (2026-07-15); `WordPress/mcp-adapter` has 12 open PRs and latest release v0.5.0 (2026-04-15)**. These are census-only signals: their PRs are not required to appear on Project #240 and do not create roadmap-coverage failures.

---

## 1. Board composition

| Dimension | Breakdown |
|---|---|
| **Total items** | **283** = 209 PRs + 74 issues |
| **By status** | Done **209** · In progress **26** · In discussion/Needs decision **24** · Backlog **8** · Needs review **7** · To do **6** · Triage **3** |
| **Open work** | **74 non-Done cards** = 57 open issues + 17 PR cards *(16 open; #484 is merged but still board-Needs review)* |
| **By repo** | `WordPress/ai` **282** · `WordPress/ai-provider-for-google` **1** (#23). `WordPress/abilities-api` #84 is not on Project #240. |
| **Cross-repo dependency scope** | Separate watchlist: **16** dependencies (10 open, 3 closed, 3 merged), tracked in [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md). |
| **Full repository census** | `WordPress/ai`: **37** open PRs / release **1.2.0** · `WordPress/php-ai-client`: **20** / **1.4.0** · `WordPress/mcp-adapter`: **12** / **v0.5.0**. Project #240 coverage applies only to `WordPress/ai`. |
| **"Team" field** | No Team values are returned in the current Projects API snapshot; use repo + labels/status for classification. |
| **"Priority" field** | Barely used; prioritization is expressed through Status + Milestone. |
| **Board views** | Prioritized backlog · AI plugin · Status board · Roadmap (timeline) · Bugs 🐛 · My items |

**Caveat for maintainers:** "Done" (**209**) is overwhelmingly merged PRs; the forward-looking signal lives in the **57 open issues** and **17 non-Done PR cards**.

---

## 2. Release cadence

The plugin has shipped **18 releases**, most recently **v1.2.0 on 2026-07-14**. The board now uses v1.3.0 as the active delivery lane and v1.4.0 for the next set of discussion-stage editorial experiments; neither has a due date.

| Milestone | Board cards | State | Meaning |
|---|---:|---|---|
| 0.1.0 → 0.9.0 | 134 | 133 Done / 1 stale | Build-out history; #484 is merged but still board-Needs review under 0.9.0. |
| 1.0.0 | 3 | ✅ Done | Stability milestone aligned with WordPress 7.0 / the Abilities API. |
| 1.0.1 | 8 | ✅ Done | Prior patch release. |
| 1.0.2 | 3 | ✅ Done | Prior patch release (2026-06-16); several already-Done cards were later removed from the board. |
| 1.1.0 | 11 | ✅ Done | Shipped 2026-07-01; all remaining cards are Done. |
| **1.2.0** | 21 | ✅ 20 Done / 1 open | **Shipped 2026-07-14.** The one non-Done card is external Google-provider issue #23, not unfinished `WordPress/ai` release work. |
| **1.3.0** | 25 | 🚧 3 Done / 22 open | **Active lane:** 14 issues + 8 open PRs. No due date. |
| **1.4.0** | 4 | 💬 4 open | Next editorial-experiment lane: #27, #324, #875, #876; all are In discussion. |
| **Future Release** | 45 | 📋 2 Done / 43 open | Long-range backlog: 35 issues + 8 PRs remain non-Done. |
| _(no milestone)_ | 29 | 26 Done / 3 open | Triage bugs #869/#874 plus In-progress Abilities Explorer enhancement #883. |

*Sums to 283 cards.*

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

Board-Done now stands at **209**. Since the 2026-07-13 baseline, nine existing cards moved to Done: PRs #294, #302, #594, #739, #758, and #857; issues #614, #778, and #853. Three of those PRs merged (#739 `core/read-content`, #758 Request-Log REST filtering, #857 commit-access docs); #294/#302/#594 closed without merge. The board also added four already-Done issues: release tracker #864, duplicate Type-Ahead payload regression #865, experiment-order adjustment #870, and Content Classification focus fix #872.

**v1.2.0 shipped on 2026-07-14.** Its release checklist recorded passing plugin checks, automated tests, local testing, GitHub release creation, and WordPress.org deployment. The release includes the preceding Type-Ahead fixes, Suggest Reply, bulk summaries, Core Abilities work, accessibility/E2E hardening, and Connector/request-log improvements. The only non-Done card still labeled 1.2.0 is Google-provider issue #23 in another repository.

The durable shipped foundation remains:

- Toggleable experiments over shared Connectors and the WordPress AI Client.
- Abilities Explorer and an expanding set of read/manage abilities.
- MCP integration and request-log observability.
- Type Ahead, Suggest Reply, Content Classification, generation, summarization, and editorial workflows.
- Repeated accessibility, internationalization, lifecycle, and provider-approval hardening.

---

## 5. In progress

The active build wave is now **v1.3.0**: 22 non-Done cards (14 issues + 8 PRs). Its main clusters are:

- **Abilities and platform:** the standalone-abilities toggle (#863, To do), `core/manage-settings` (#764), `core/read-nav-menus` (#858), native vector search (#683), and role/user controls (#736).
- **Editorial and content:** translation (#187), taxonomy relevance (#452), comment-value scoring (#514), Editorial Updates → Visual Revisions (#507), Markdown feeds (#845), and post-meta prefix normalization (#866).
- **Reliability and lifecycle:** provider-approval error copy (#660), plugin uninstall cleanup (#690), non-SDK request logging (#732), and admin-page flicker (#741).
- **Maintenance:** dependency alignment (#777/#832), alt-text URL matching (#621), and a Suggest Reply screencast update (#882).

Two unmilestoned bugs remain in Triage: #869 reports provider data appearing only in the block-editor iframe in one environment, and #874 documents Yoast meta-description interoperability failures across post types and when Yoast AI is disabled. Unmilestoned issue #883 is already In progress through authoritative closing PR #884, which adds dynamic custom-provider filtering and corrects statistics to count abilities by origin.

The repo has **37 open PRs**: 16 are represented by open board PR cards, while 21 are untracked by a PR card (19 substantive + 2 routine dependency updates). The two additions are #884 (authoritative closing link to #883) and #885 (fallback-title link to #425). Several untracked PRs implement board issues, so board status must not be read as the complete code-in-flight view.

Two additional full-repository censuses expose upstream implementation and release movement without folding it into Project #240: **20 open PRs in `WordPress/php-ai-client`** and **12 in `WordPress/mcp-adapter`**. Their complete normalized PR records, readiness fields, releases, diffs, and independent snapshots are emitted by `wp-ai-roadmap-refresh.sh`; only the primary `WordPress/ai` census is joined to the roadmap board.

*(Full per-issue detail is in [§9](#9-appendix--full-open-issue-tracker-57).)*

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
- Supporting: **#233** (refactor experiments onto `AI_Service`), **#203** (extensibility hook for Ability Table columns, now Future Release), **#307** (AGENTS.md), **#32** (AI Playground debug tool), plus **`core/read-content`** (#739, merged Done in 1.2.0), **`core/manage-settings`** (#764, 1.3.0), **`core/read-nav-menus`** (#858, 1.3.0), and the new standalone-abilities toggle (#863). **`core/read-users`** (#774) merged earlier; off-board #856 is no longer open. The experiment `register()` → `init()` rename (#145) shipped board-Done earlier. Upstream `WordPress/abilities-api` **#84** (generic CRUD across post types; client vs server `execute_callback`) remains open, but is no longer on Project #240.

### B. Connectors, Providers & Model Management
Direction settled: **thin core Connectors screen discovering independent per-provider plugins** (the bundle-everything path, PR #148, was abandoned).

- **#502 Provider plugin discovery/curation/labeling** — the strategic parent. Three unresolved axes: discovery model (hardcoded list vs WP.org Plugins API vs `connector` tag), curation/"vetted" concept, and official-vs-third-party labeling.
- **#27 Surface additional provider plugins on Connectors** *(1.4.0)* — list third-party providers + "progressive provider selection" (hide UI when a valid provider exists); host pre-config via constants/filters. **Strong demand for OpenRouter** (one key, many models).
- **#262 Provider-level model bucketing** — replace hard-coded model priority lists with a user-facing **provider preference** (not specific models); future capability tiers (fast/cheap vs high-reasoning). *Scope being questioned now that a per-experiment "developer mode" already exposes provider+model.*
- **#191 Settings + provider import/export** *(now In progress)* — portability for agencies/hosts/multisite; secure credential handling unresolved (env-var support floated).
- **#632** *(now board-Done / closed)* deactivate a connector without losing its key · **#660** *(Needs review / 1.3.0)* clearer "blocked by Connector Approvals" error · **#815** *(1.2.0, now board-Done — PR #830 merged 2026-07-10)* surface an admin notice when Connector Approvals still needs the AI plugin granted access to a connected provider (WPORG support report; related to #660).

### C. Content & Editorial Experiments (the authoring lifecycle)
Expanding from per-field generators toward full co-authoring.

- **#297 Content Generation** — native Block Editor **co-author** (first drafts from title, expand sections, rewrite selection; `/ai` slash command, ghost-typing, accept/reject diffs). Well-specified, awaiting design (karmatosed). ⭐ *Major bet.*
- **#324 Evolve "Refine" → agentic/collaborative editorial** *(1.4.0)* — a "WordPress AI" user editing live via Gutenberg **Real-Time Collaboration**; deferred to let RTC stabilize. ⭐ *Major bet.*
- **#338 Analytics-aware content & amplification** — content-gap mining (low-engagement on-site searches) + traffic-surge social amplification, via a `Stats_Provider` adapter (**Jetpack Stats first**); split into two sub-issues. ⭐ *Major bet — closes ideation→distribution loop.*
- **#625 Social Content Generation** — platform-specific posts (Bluesky/Mastodon/LinkedIn) from post content; persist to meta; hooks for Jetpack Social/Blog2Social.
- **#508 "Suggest Reply"** for comments + Activity widget *(shipped board-Done under 1.2.0 — PR #724 merged 2026-07-10)* — the 1.2.0 lane's first genuinely new experiment (re-introduces #155's removed feature properly; human review, **not** auto-reply).
- **Reusable control layer:** tone (#186), multilingual rewriting/translation (#187, *now Needs review, 1.3.0* — full-article PoC by yogeshbhutkar; draft PR #747), persona/voice (#188).
- Enhancements: **#614** bulk summary generation *(Done in 1.2.0)* · **#90** consolidate Title Generation options · **#507** Editorial Updates → Visual Revisions *(Needs review / 1.3.0)* · **#452** classification relevance *(1.3.0)*.

### D. Agentic / Chat / Site-Agent + Media
The biggest **directional shift** — from single-task helpers to a conversational agent that takes actions. Three convergent issues:

- **#142 Frontend chat agent** — "chat with my site" for public **visitors** (RAG over owner-selected content + FAQ, citations). Designed proposal; needs an embeddings/indexing pipeline (shared with #282).
- **#282 Admin "AI Workspace"** — full-screen wp-admin multi-step chat (Site-Editor-styled, DataViews), capability-gated Search/RAG middleware, actionable artifacts ("Create Draft"). Most fleshed-out spec; assigned karmatosed for mockups.
- **#189 Site Agent** — natural language → **explicit, verifiable WP actions** (create posts, install plugins, change settings). Opt-in, disabled by default, capability-respecting, fully auditable. ⭐ *Major bet (idea-stage).*
- **#190 Site-wide insights** — read-only cross-content analysis (themes/gaps/trends); the safe data layer feeding the agentic surfaces.

**Media & Vision:** focus-aware crop suggestions (#238) · integrate media experiments with Gutenberg's experimental **Media Editor** (#325) · **C2PA** provenance detection on upload (#421, *1.3.0*, well-specified) · alt-text button placement (#425, **Blocked**).

**Search/RAG:** native vector search (#683 draft PR, now milestoned 1.3.0) adds a board-tracked experiment for MariaDB-backed semantic search/RAG with fallback post-meta embeddings.

**Extensibility & community:** custom prompt-template hooks (#192) · developer-only request/response log panel (#193) · Comment Moderation value/relevance scoring (#514) · low/no-tech educational content for the WP 6.9 launch (#47).

---

## 7. Unplanned / undecided / blocked

- **24 In discussion / Needs decision cards** = 22 issues + exploratory PRs #211 and #224. This increased with #600 moving back from In progress and new 1.4.0 ideas #875/#876.
- **3 Triage issues:** #40 (Core Abilities, Future Release), #869 (provider-data iframe/top-window mismatch, unmilestoned), and #874 (Yoast meta-description interoperability, unmilestoned).
- **Blocked direction:** #425 still depends on a usable Media Editor surface; PR #494 remains the corresponding blocked implementation.
- **Review-ready issues:** #187, #507, and #660 are now Needs review under 1.3.0.
- **Board hygiene:** merged PR #484 still shows Needs review under 0.9.0.
- **Key open decisions:** ability governance/granularity (#40/#348/#354/#863), WebMCP standard risk (#448), provider discovery (#27/#502), and where new internal-link/slug suggestions should surface (#875/#876).

---

## 8. Strategic read & risks

**Where it is heading:** discrete AI helpers are becoming a governed, agent-capable WordPress platform. Abilities provide the action primitive; Connectors and model preferences provide provider independence; editorial experiments provide user-facing workflows; search/RAG, MCP/WebMCP, and site-agent ideas connect those layers.

**Watch-items / risks:**

1. **External dependencies** — WordPress core, the AI Client, Gutenberg Media Editor/RTC/Guidelines work, and abilities-api can change delivery paths without changing Project #240.
2. **Governance before write abilities** — #863 makes the safety question concrete: standalone/read abilities are currently always registered, while future write abilities need deliberate enablement and discoverability controls.
3. **Backlog-to-commitment gap** — Future Release still contains 43 non-Done cards, but 1.3.0 now provides a defined 22-card active lane and 1.4.0 a four-issue next lane.
4. **Compatibility regressions** — #869 needs a clean-environment reproduction; #874 may require a Yoast-specific data-store integration because the generic REST-meta path is post-type-limited.
5. **Board ≠ repo** — 21 of 37 open PRs lack a PR card. Issue cards often carry the roadmap intent while implementing PRs remain off-board.
6. **Stale/closed cards** — #484 remains non-Done despite being merged; newly added cards can also arrive already Done, so counts require state + board-status reconciliation.

---

## 9. Appendix — full open-issue tracker (57)

> 📄 Deep dossiers live in [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md). The current scope is **57 board-open issues**: 56 in `WordPress/ai` plus Google-provider issue #23. PR cards are tracked separately in [`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md).

Grouped by current board status. Theme tags are editorial aids; Status and Milestone come from Project #240.

### In discussion / Needs decision (22)

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
| [#875](https://github.com/WordPress/ai/issues/875) | 1.4.0 | Content | — | New Experiment: Suggest internal links within post content |
| [#876](https://github.com/WordPress/ai/issues/876) | 1.4.0 | Content | — | New Experiment: Suggest permalink slugs |

### In progress (15)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#191](https://github.com/WordPress/ai/issues/191) | 1.3.0 | Providers | coderGtm | Add import/export support for AI settings and provider configuration |
| [#192](https://github.com/WordPress/ai/issues/192) | Future | Infra | the-hercules | Add extension points for custom prompt templates |
| [#203](https://github.com/WordPress/ai/issues/203) | Future | Platform | — | Add extensibility hook for custom Ability Table columns |
| [#238](https://github.com/WordPress/ai/issues/238) | Future | Agentic/Media | TylerB24890 | Add focus-aware crop suggestions |
| [#307](https://github.com/WordPress/ai/issues/307) | Future | Platform | gziolo | Add AGENTS.md to streamline contributor onboarding |
| [#325](https://github.com/WordPress/ai/issues/325) | Future | Agentic/Media | TylerB24890 | Integrate media features and experiments with Gutenberg's experimental Media Editor |
| [#452](https://github.com/WordPress/ai/issues/452) | 1.3.0 | Content | saarnilauri | Content Classification: Improve relevance of taxonomy suggestions |
| [#514](https://github.com/WordPress/ai/issues/514) | 1.3.0 | Content | — | Add comment value / relevance to Comment Moderation experiment |
| [#689](https://github.com/WordPress/ai/issues/689) | Future | Infra | i-anubhav-anand | Add a user-facing control for automatic log cleanup |
| [#690](https://github.com/WordPress/ai/issues/690) | 1.3.0 | Infra | hbhalodia | Plugin does not clean up database table and options on uninstall |
| [#732](https://github.com/WordPress/ai/issues/732) | 1.3.0 | Bug/Infra | — | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible |
| [#736](https://github.com/WordPress/ai/issues/736) | 1.3.0 | Platform | — | Expose role/user access controls per feature/experiment |
| [#845](https://github.com/WordPress/ai/issues/845) | 1.3.0 | Infra | dkotter | New Experiment: Markdown feeds (powered by `html-to-md`) |
| [#866](https://github.com/WordPress/ai/issues/866) | 1.3.0 | Bug/Infra | hbhalodia | Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix |
| [#883](https://github.com/WordPress/ai/issues/883) | — | Platform | — | Abilities Explorer: provider filter dropdown doesn't include custom providers |

### Backlog (8)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#142](https://github.com/WordPress/ai/issues/142) | Future | Agentic/Media | — | Frontend chat agent powered by site content |
| [#186](https://github.com/WordPress/ai/issues/186) | Future | Content | — | Add tone adjustment controls for AI-generated content |
| [#188](https://github.com/WordPress/ai/issues/188) | Future | Content | — | Add persona-driven content generation experiments |
| [#189](https://github.com/WordPress/ai/issues/189) | Future | Agentic/Media | — | Explore an admin Site Agent for executing WordPress actions |
| [#193](https://github.com/WordPress/ai/issues/193) | Future | Infra | — | Add developer-only log panel for inspecting AI provider responses |
| [#282](https://github.com/WordPress/ai/issues/282) | Future | Agentic/Media | karmatosed | Chat experiment: Integration outside the editor and outside single-task AI use |
| [#297](https://github.com/WordPress/ai/issues/297) | Future | Content | karmatosed | New experiment: Content Generation |
| [#844](https://github.com/WordPress/ai/issues/844) | Future | Agentic/Media | — | New Experiment: Semantic search in wp admin |

### To do (6)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#32](https://github.com/WordPress/ai/issues/32) | Future | Infra | — | Add AI Playground interface (prompt testing & debug tools) |
| [#190](https://github.com/WordPress/ai/issues/190) | Future | Agentic/Media | yogeshbhutkar | Add site-wide AI-powered content insights |
| [#233](https://github.com/WordPress/ai/issues/233) | Future | Platform | — | Refactor experiments to leverage AI_Service layer |
| [#339](https://github.com/WordPress/ai/issues/339) | Future | Bug | — | AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin |
| [#421](https://github.com/WordPress/ai/issues/421) | 1.3.0 | Agentic/Media | — | WordPress should detect C2PA manifests on upload |
| [#863](https://github.com/WordPress/ai/issues/863) | 1.3.0 | Platform | — | New Experiment: Abilities toggle |

### Triage (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#40](https://github.com/WordPress/ai/issues/40) | Future | Platform | gziolo, jorgefilipecosta | WordPress Core Abilities |
| [#869](https://github.com/WordPress/ai/issues/869) | — | Bug/Providers | — | window.aiProviderData is only attached to the block-editor iframe snapshot, never to the top window, causing "requires an AI Connector" false positives |
| [#874](https://github.com/WordPress/ai/issues/874) | — | Bug/Content | — | Meta Description: Issue with Yoast plugin for Meta Description experiment |

### Needs review (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#187](https://github.com/WordPress/ai/issues/187) | 1.3.0 | Content | yogeshbhutkar | Support multilingual rewriting and translation via AI |
| [#507](https://github.com/WordPress/ai/issues/507) | 1.3.0 | Content | zeus2611 | Iterate on Editorial Updates end flow to Visual Revisions |
| [#660](https://github.com/WordPress/ai/issues/660) | 1.3.0 | Providers | — | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals |

**Removed-board reference:** [`WordPress/abilities-api#84`](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not counted in Project #240.

---

## 10. How to refresh this document

> ⚙️ **Automated path:** [`wp-ai-roadmap-refresh.sh`](./wp-ai-roadmap-refresh.sh) does everything below in one command — re-pulls the board, diffs against the last snapshot (added / newly-Done / merged / status & milestone moves / removed), fetches the full PR/release census for all repositories declared through [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json), refreshes the curated dependency watchlist, and can append a changelog row (`--update-changelog`). Run with no args for a read-only report; add `--save` to roll all board, repository, release, and dependency baselines forward. The manual recipe below is what it automates.
>
> **Normal vs. strict refresh.** The default (normal) refresh is *warning-only*: any data-quality or coverage problem — an unreachable dependency, a substantive open PR with no board representation — is reported in the output (`.validation` in JSON, stderr lines otherwise) but never blocks the board report, and the run exits `0`. `./wp-ai-roadmap-refresh.sh --strict [--json]` runs the same read-only pipeline as an **audit**: it emits the complete report first, then exits `2` when any validation error remains (exit `1` is reserved for operational failures that prevented a report at all). A strict failure also suppresses `--save` and `--update-changelog` ("persistence skipped"), so a red audit never rolls the baseline forward.
>
> Strict is a **scheduled visibility audit, not a merge gate**: whether every substantive `WordPress/ai` PR is linked to Project #240 depends on upstream contributor behavior, so a persistent red result means *unresolved roadmap visibility* (work in flight that the board doesn't show), not a broken tracker. Point-in-time coverage: 37 open PRs = 16 direct board PR cards + 17 linked to board issues (15 authoritative closing references + 2 source-labeled fallbacks) + 2 routine dependency PRs + 2 unexplained (#877, #878 — the current strict-audit failures).

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
- "WordPress AI" board == the WordPress/ai Showcase Plugin in practice (282/283 items).
- Roadmap signal = open ISSUES plus the non-Done PR lane; PRs are most of the 209 Done cards.
- Priority field is barely used; track via Status + Milestone.
- Strategic bets (⭐): #348, #40, #430, #297, #324, #338, #189, #282. Risk (⚠️): #448 (WebMCP), #643 (live regression).
- Watch core deps: WP 6.9 Abilities API, WP 7.0 AI Client, Gutenberg RTC/Media Editor/Guidelines→Skills, abilities-api repo.
-->
