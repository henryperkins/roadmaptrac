# WordPress AI — Planning & Roadmap (Living Document)

> **Source board:** [github.com/orgs/WordPress/projects/240](https://github.com/orgs/WordPress/projects/240) — *"WordPress AI Planning & Roadmap"*
> *"A project board to provide oversight into the various focus areas of the WordPress AI team."*
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-08-14 (latest board-item activity: 2026-08-14) |
> | **Items captured** | 279 (full board, via GraphQL Projects API) |
> | **Plugin** | [`WordPress/ai`](https://github.com/WordPress/ai) — the official "AI" Showcase Plugin on WordPress.org |
> | **Latest shipped** | **v1.2.0** (shipped 2026-07-14) — 18th release; release issue [#864](https://github.com/WordPress/ai/issues/864) closed after plugin checks, tests, local testing, GitHub release, and WordPress.org deployment |
> | **In active development** | **v1.3.0** (17 Done / 2 open; 19 carded; release issue [#924](https://github.com/WordPress/ai/issues/924) In progress, target 2026-08-17) · **Next:** v1.4.0 (19 open: 11 issues + 8 PRs) · **Backlog:** Future Release (41 open) |
> | **Maintained by** | _(you)_ — see [§10 How to refresh](#10-how-to-refresh-this-document) to regenerate the data |

**How to read this doc:** [§1 Composition](#1-board-composition) · [§2 Releases](#2-release-cadence) · [§3 Product model](#3-product-architecture) · [§4 Shipped](#4-shipped-done) · [§5 In progress](#5-in-progress) · [§6 Roadmap bets](#6-planned-roadmap--strategic-bets) · [§7 Undecided/blocked](#7-unplanned--undecided--blocked) · [§8 Strategic read & risks](#8-strategic-read--risks) · [§9 Full open-issue tracker](#9-appendix--full-open-issue-tracker-48) · [§10 Refresh](#10-how-to-refresh-this-document) · [§11 Changelog](#11-changelog)

> **📚 Companion documents (4-doc set):**
> 1. **This file** — strategy, board composition, release cadence, and the at-a-glance open-issue tracker.
> 2. **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** — deep per-issue dossiers, grouped by status. *(Current to 2026-08-14: all 48 board-open issues, plus #84 as a removed-board reference and 50 recently board-Done issues retained for reference.)*
> 3. **[`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md)** — the release-ordered delivery plan for all 65 non-Done cards, including 16 open board-tracked PRs and stale merged PR #484.
> 4. **[`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md)** — the 16-item Gutenberg + abilities-api dependency watchlist (11 + 5; 9 open / 4 closed / 3 merged), plus full PR/issue/release censuses for all four tracked repositories.

### Status legend (board's own taxonomy)
`Triage` → unsorted/new · `In discussion / Needs decision` → debated, **not** committed · `Backlog` / `To do` → planned · `In progress` → being built · `Needs review` → review-ready · `Done` → shipped/merged

---

## Executive summary

Project #240 remains the operational tracker for the [`WordPress/ai`](https://github.com/WordPress/ai) Showcase Plugin (278 of 279 cards; the other card is Google-provider issue #23). The plugin continues to organize user-facing AI capabilities as toggleable experiments over shared Connectors, AI Client, Abilities API, MCP, and request-log infrastructure.

This is a **shipping window** — the first since the 1.2.0 transition: **v1.3.0 went 5 Done / 21 open → 17 Done / 2 open**, its release issue **#924** is In progress with a 2026-08-17 target, and the lane that was bypassed twice — **v1.4.0 — was finally loaded**, 2 → **19 open**.

**Nine cards reached Done and all nine are real.** Seven issues closed by merged PRs — **#233** (`AI_Service` deprecation, PR #905), **#690** (uninstall cleanup, PR #692), **#863** (Abilities toggle, PR #881), **#866** (post-meta `wpai_` prefix, PR #867), **#876** (permalink slugs, PR #897), **#906** (reserved log-type API, PR #914) — plus **#307**, closed **`NOT_PLANNED`**: the `AGENTS.md` proposal was declined after the April docs-first debate. Two PR cards merged — the request-log a11y fix **#889** and dependabot **#920**. Five further PRs arrived **already-Done under 1.3.0** (**#892** vendored embeddings, **#909** encryption docs, **#915** inline-HTML preservation, **#930** Editorial Updates fixes, **#934** wp-version bump) alongside merged #919/#921. Board totals rose **269 → 279**: 13 in, 3 out — the removals are translation issue **#187** (shipped earlier via #747, de-carded), spam **#900**, and **PR card #459**, whose PR stays open and `closing`-linked to #421 but whose checks went FAILURE.

**v1.4.0 is the dated lane again, and it is real work now.** Thirteen cards re-milestoned out of the nearly-shipped 1.3.0 lane (#514, #600, #660, #683, #732, #736, #741, #764, #777, #832, #845, #858, #875), joined by PR cards **#888** (Text to Speech) and the polish pair **#916/#917**, plus board-new issue **#933** (connector validity is capability-aware, not text-only) — **19 cards, 11 issues + 8 PRs**. What stays in 1.3.0 is exactly the release residue: C2PA detection **#421** and release issue **#924**.

**The visibility gap collapsed from six unexplained PRs to one — and the six left by being tracked, not by vanishing.** **#888**, **#892**, **#909**, **#915**, **#916**, **#917** all received board cards this window — **#892/#909/#915 merged under 1.3.0**, while **#888/#916/#917** remain open under 1.4.0. The single remaining unexplained PR is **#941** "Content Translation: Add user-triggered retry" (yogeshbhutkar, repo-milestoned 1.4.0, no closing reference): the census is **28 open PRs = 16 direct + 11 linked + 0 routine + 0 off-board + 1 unexplained**. Issue coverage is now **47 of 47 open issues carded** — enforced by the audit, not asserted.

**Review throughput is unchanged and remains the binding constraint.** All 28 open PRs are BLOCKED (12) or DIRTY (16), **none carries an approving review**, 17 have failing checks, 11 carry CHANGES_REQUESTED, and 7 are drafts. The window's six readiness changes are dominated by regressions: #459, #681, #858, #888 went BLOCKED → DIRTY, and #916/#917 picked up CHANGES_REQUESTED with failing checks.

**Upstream moved in a release-bearing way for the first time.** `WordPress/mcp-adapter` shipped **v0.6.0 (2026-08-12) and v0.6.1 (2026-08-13)** — its first releases since April — after its DTO-cluster and release-tooling PRs merged (#171, #223, #252, #263), and its open PR count fell 18 → **12**. `WordPress/php-ai-client` rose 26 → **28** on **#274** (embeddings must take an explicit model) and **#275** (provider-plugin updates), staying at 1.4.0. `WordPress/abilities-api` is frozen at 14 PRs / 8 issues / v0.4.0 — still pending archival. The dependency watchlist logged its first state change in four windows: **`gutenberg#73771` OPEN → CLOSED** (the Media Editor modal task tracker; 16 items now 9 open / 4 closed / 3 merged).

The forward roadmap still converges on four bets: (A) Abilities as the universal tool layer — the standalone-abilities toggle (#863) shipped this window and #923 now asks for agent identity; (B) a provider-agnostic Connectors ecosystem, where #933 and #940 are the newest live defects; (C) an editorial lifecycle expanding into review, linking, slugs, translation, and agentic refinement; and (D) conversational/site-agent and semantic-search surfaces. The delivery lanes are **v1.3.0 (release in progress)** and a loaded **v1.4.0 (19 cards)**; **Future Release holds 41**.

---

## 1. Board composition

| Dimension | Breakdown |
|---|---|
| **Total items** | **279** = 222 PRs + 57 issues |
| **By status** | Done **214** · In progress **23** · In discussion/Needs decision **21** · Needs review **8** · Backlog **6** · To do **4** · Triage **3** |
| **Open work** | **65 non-Done cards** = 48 open issues + 17 PR cards *(16 open; #484 is merged but still board-Needs review)* |
| **By repo** | `WordPress/ai` **278** · `WordPress/ai-provider-for-google` **1** (#23). `WordPress/abilities-api` #84 is not on Project #240. |
| **Cross-repo dependency scope** | Separate watchlist: **16** dependencies (9 open, 4 closed, 3 merged), tracked in [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md). |
| **Full repository census** | Open PRs / open issues / latest release — `WordPress/ai`: **28 / 47 / 1.2.0** · `php-ai-client`: **28 / 34 / 1.4.0** · `mcp-adapter`: **12 / 41 / v0.6.1** · `abilities-api`: **14 / 8 / v0.4.0** *(pending archival)*. Project #240 coverage applies only to `WordPress/ai`, where **all 47 open issues are carded** — now enforced, not observed. |
| **"Team" field** | No Team values are returned in the current Projects API snapshot; use repo + labels/status for classification. |
| **"Priority" field** | Barely used; prioritization is expressed through Status + Milestone. |
| **Board views** | Prioritized backlog · AI plugin · Status board · Roadmap (timeline) · Bugs 🐛 · My items |

**Caveat for maintainers:** "Done" (**214**) is overwhelmingly merged PRs; the forward-looking signal lives in the **48 open issues** and **17 non-Done PR cards**. Total item count is not a scope proxy — it *rose* this window because the 1.3.0 delivery wave carded and Done'd real work (+13 in, −3 out; PR/issue mix shifted 214/55 → **222/57**). **"Done" remains not a delivery proxy either:** the +12 Done delta includes #307 closed `NOT_PLANNED` (AGENTS.md declined) and the standing cases of PR **#621** (closed unmerged 2026-07-28, still Done) and dependabot **#922** (closed unmerged, still Done) — but unlike the last two windows, this window's Done delta is **overwhelmingly delivered work**: nine cards Done by merged PRs or deliberate closure.

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
| **1.2.0** | 9 | ✅ 8 Done / 1 open | **Shipped 2026-07-14.** The one non-Done card is external Google-provider issue #23, not unfinished `WordPress/ai` release work. |
| **1.3.0** | 19 | 🚀 17 Done / 2 open | **In its release window:** seven issues closed by merged PRs (#233, #690, #863, #866, #876, #906, plus #307 `NOT_PLANNED`), two PR cards merged (#889, #920), and five PRs arrived Done (#892, #909, #915, #930, #934). Remaining: C2PA detection #421 and release issue **#924** (target **2026-08-17**). |
| **1.4.0** | 19 | 🚧 0 Done / 19 open | **The next lane, finally loaded:** 11 issues + 8 PRs. Thirteen cards re-milestoned in from the 1.3.0 lane, joined by PR cards #888/#916/#917 and board-new #933. Two issues remain undecided (#27, #324); the rest carry code. |
| **Future Release** | 41 | 📋 0 Done / 41 open | Long-range backlog: 33 issues + 8 PRs. Gained #923 (agent users), PR card #931, and Triage #890/#918; gave up #600/#736 to 1.4.0, and #294/#302/#307 left by milestone-clearing on Done. |
| _(no milestone)_ | 31 | 30 Done / 1 open | Board-new In-discussion issue **#940** (custom settings endpoint vs `/wp/v2/settings`); #294/#302/#307 had their milestones cleared as Done, and #890/#918 moved to Future Release. |

*Sums to 279 cards.*

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
- ~~**`AI_Service`** layer~~ — **deprecated, and the card is closed.** Introduced in 0.2.1 (#101) as shared internal routing that experiments would migrate onto (#233), it was never adopted. PR [#905](https://github.com/WordPress/ai/pull/905) **merged 2026-08-11**: the class and the `get_ai_service()` helper stay, marked deprecated, after dkotter noted both are public surface a third party could be calling. **#233 closed against it**, closing out the last window's only "board contradicted by its own implementation" case. All experiments call `wp_ai_client_prompt()` directly.

Every roadmap item is a **new Experiment**, an **enhancement to one**, or **infrastructure/governance** beneath them.

---

## 4. Shipped (Done)

Board-Done now reads **214** — up 12 in the first genuinely delivery-heavy window since the 1.2.0 transition. **v1.3.0 went 5 Done → 17 Done**, and the only remaining non-Done cards in that lane are C2PA detection #421 and release issue #924.

The nine cards that *moved* into Done:

- **#233 Refactor experiments to leverage `AI_Service` layer** — closed 2026-08-11 by merged PR **#905**, which **deprecates** the layer rather than deleting it. This closes the two-window saga of the card whose premise reversed: the title still says "leverage," but the work is retirement, the tracking is correct, and the card is Done.
- **#690 Plugin does not clean up database table and options on uninstall** — closed 2026-08-11 by merged PR **#692**: an `uninstall.php` plus an opt-in "Remove all data on uninstall" checkbox.
- **#863 New Experiment: Abilities toggle** — closed 2026-08-12 by merged PR **#881**: standalone abilities gain deliberate enablement controls, the plugin-side half of the governance question that `mcp-adapter#254` resolved upstream.
- **#866 Standardize post meta key naming with `wpai_`** — closed 2026-08-12 by merged PR **#867** (with the migration).
- **#876 New Experiment: Suggest permalink slugs** — closed 2026-08-11 by merged PR **#897**, ending the 1.4.0 → Future Release → 1.3.0 round trip with delivery.
- **#906 Request Logging: no public API for the reserved `mcp_tool`/`ability` types** — closed 2026-08-13 by merged PR **#914**: namespaced `WordPress\AI\log_ai_request()`, a public log-manager accessor, and a single source of truth for log types.
- **#307 Add AGENTS.md to streamline contributor onboarding** — closed 2026-08-10 **`NOT_PLANNED`**: after the April debate (justlevine against a committed public `AGENTS.md` on WordPress.org properties, in favor of an `AGENTS.md.example`; gziolo's onboarding evidence), the proposal was declined rather than shipped, and its milestone was cleared. One of this window's Done cards is therefore a *decision not to build* — deliberate, not a delivery miss.
- **PR #889** (request-log provider/model a11y) and **PR #920** (dependabot npm-dev bump) — merged, Done.

Five further PR cards **arrived already-Done under 1.3.0**: **#892** (embeddings support vendored from the PHP AI Client behind `SDK_Overlay` — the third-window uncarded load-bearing feature, finally carded and merged), **#909** (encryption-experiment docs + caller attribution), **#915** (Content Resizing preserves inline HTML), **#930** (Editorial Updates fixes for Pullquote/value-based blocks), and **#934** (wp-version bump), alongside the merged dependabot pair #919/#921.

Three cards were removed: translation issue **#187** (shipped earlier via #747 — de-carded Done), webinar spam **#900** (de-carded Done), and **PR card #459**. That last removal is the one to read carefully: the C2PA Monitor PR is **still open**, still authoritatively `closing`-linked to #421 — but it lost its board card, and its checks went SUCCESS → FAILURE. The C2PA read path is now represented on the board only by its issue.

**v1.2.0 remains the latest tagged release (2026-07-14)** while v1.3.0 runs its release checklist (#924 targets 2026-08-17). The only non-Done card still labeled 1.2.0 is Google-provider issue #23 in another repository.

The durable shipped foundation remains:

- Toggleable experiments over shared Connectors and the WordPress AI Client.
- Abilities Explorer and an expanding set of read/manage abilities.
- MCP integration and request-log observability.
- Type Ahead, Suggest Reply, Content Classification, generation, summarization, and editorial workflows.
- Repeated accessibility, internationalization, lifecycle, and provider-approval hardening.

---

## 5. In progress

The active build wave has **moved to v1.4.0**, loaded this window with 19 non-Done cards (11 issues + 8 PRs), while v1.3.0 runs out its release. The lane's clusters:

- **Abilities and platform:** `core/manage-settings` (#764), `core/read-nav-menus` (#858), native vector search (#683), and — board-new — **#931**, gziolo's draft comparing the core read abilities against the REST API.
- **Editorial and content:** comment-value scoring (#514, PR #681), Markdown feeds (#845, PR #855), internal-link suggestions (#875, PR #887), and board-new PR cards **#888** (Text to Speech, Needs review) and **#916/#917** (classification error copy, resize Accept focus).
- **Reliability and lifecycle:** provider-approval error copy (#660, PR #759), non-SDK request logging (#732, PR #757), admin-page flicker (#741), role/user access controls (#736, PR #749), the `Enable AI` toggle removal (#600, To do), and board-new **#933** (connector validity must be capability-aware; PR #935 by whyisjake).
- **Maintenance:** dependency alignment (#777/#832) and wp-7.0 compatibility.

**What remains in 1.3.0 is exactly the release residue:** C2PA manifest detection **#421** — whose authoritative PR **#459 lost its board card this window** and whose checks went FAILURE — and release issue **#924**, whose checklist shows the pre-release review/punt pass complete except #459 and the release steps not yet started (target **2026-08-17**).

**v1.4.0 was refilled by re-milestoning, not by new decisions.** Thirteen cards moved 1.3.0 → 1.4.0 as the release lane narrowed; #600 also arrived from Future Release, retitled from a bug report ("header toggle doesn't reflect aggregate state") into a product decision ("**Remove** the `Enable AI` header toggle…"), and moved In discussion → To do with a Help Wanted label. Two issues remain genuinely undecided — #27 (provider discovery) and #324 (agentic Refine) — while the rest carry live PRs or review-ready work.

One unmilestoned card now sits outside every lane: board-new In-discussion issue **#940** (a custom settings endpoint to bypass the `/wp/v2/settings` revalidation bug), filed 2026-08-14 and carrying this window's latest board-item activity. #890 and #918 left the unmilestoned tier for Future Release.

The repo has **28 open PRs**: 16 are represented by open board PR cards, 11 link authoritatively to board issues, and exactly **one** — **#941** "Content Translation: Add user-triggered retry" — has no board representation at all (see [§7](#7-unplanned--undecided--blocked)). There are no routine untracked PRs: the dependabot PRs are carded. **Nothing in the repository is mergeable:** all 28 open PRs are BLOCKED (12) or DIRTY (16), none carries an approving review, 17 have failing checks, 11 carry CHANGES_REQUESTED, and 7 are drafts.

The full-repository censuses expose upstream movement without folding it into Project #240: **28 open PRs in `WordPress/php-ai-client`** (+2: #274 forces an explicit model for embeddings, #275 updates the AI provider plugins) and **12 in `WordPress/mcp-adapter`** (−6, with **v0.6.0 and v0.6.1 shipped 2026-08-12/13** after its DTO cluster merged). **`WordPress/abilities-api`** holds at 14 PRs / 8 issues / v0.4.0, still **pending archival** (see the [cross-repo doc](./wordpress-ai-cross-repo-dependencies.md)). Their complete normalized PR records, issue records, readiness fields, releases, diffs, and independent snapshots are emitted by `wp-ai-roadmap-refresh.sh`; only the primary `WordPress/ai` census is joined to the roadmap board.

*(Full per-issue detail is in [§9](#9-appendix--full-open-issue-tracker-48).)*

---

## 6. Planned roadmap — strategic bets

Four converging directions. Most sit in **"Future Release"** (uncommitted) unless noted.

### A. Abilities API as the universal tool layer → Platform & Standards
The keystone bet: **`name + description + JSON Schema + implementation`** as the primitive that bridges WordPress into every agent standard.

- **#40 Core Abilities** *(Triage)* — the foundational `core/*` ability set (CRUD posts/pages/users/media/settings, plugin activate/update; destructive actions excluded for v1). **Key debate:** collapse per-post-type CRUD into one `create_post(post_type)` (consensus *yes* — MCP tool caps: 128 OpenAI / 512 Google) vs. granular abilities for Command Palette UX. Owners: gziolo, jorgefilipecosta. *Foundational, core-dependent.*
- **#348 Unified AI Management Layer for Core** — a single Core plane for structured **permissions + usage metering/budgets + capability-aware provider routing**, consolidating ~6 fragmented community plugins; hooks the existing `wp_ai_client_prevent_prompt` filter (zero breaking changes). **Open:** allow- vs **deny-by-default** (commenters favor deny). ⭐ *Major bet.*
- **#354 Unified Abilities exposure controls** — central per-"surface" control over which abilities are exposed where (every MCP server auto-becomes a surface); overlaps #348. Warns: without this, every plugin ships its own surface → mess.
- **#736 Per-feature role/user access controls** *(In progress, 1.4.0; PR #749 by Infinite-Null — DIRTY with CHANGES_REQUESTED)* — expose role/user access controls per Experiment/feature; complements the #348/#354 governance cluster at the feature granularity. Moved into the loaded 1.4.0 lane this window.
- **#923 Introduce agent users** *(In discussion, Future Release; gziolo)* — give AI agents an auditable identity by extending the user concept (no interactive login, excluded from listings by default, role-capped) instead of borrowing human credentials. Filed 2026-08-10 off the August core-AI chat and the "trust ladder" framing; drew production evidence from webmyc (1,276 sites, **50.2% of 241,614 tool calls carry no usable agent identifier**), refinement questions from JasonTheAdams (min-of caps, query back-compat, role design), and an `actor`-primitive counterproposal from chubes4. Complements #354/#736 and upstream `mcp-adapter#176/#228`.
- **#21 Supporting thousands of abilities** *(Question)* — exposing every ability 1:1 as an MCP tool degrades model selection. Proposes a **layered-tool pattern** (3 tools: `get_abilities_by_category` / `get_ability_info` / `use_ability`) with a category taxonomy.
- **#430 Skills in a WordPress admin context** — map "Skills" into WP (Command Palette `/audit-accessibility`); gziolo is evolving the **Guidelines CPT → Skills** in Gutenberg. **Open:** split user-authored prompts/workflows from full agent Skills with script execution (script bundling is the blocker). ⭐ *Major bet, cross-repo (Gutenberg).*
- **#448 WebMCP experiment** — integrate `navigator.modelContext.registerTool` so a browser-native agent can drive WP. **Risk:** WebMCP is an **unstable W3C Community Group draft**, no browser ship commitment; lean on a polyfill + Experiment status for easy retirement. ⚠️ *Speculative.*
- **#37 MCP usage & request routing** — make the plugin a **reference MCP implementation** (route an Experiment via MCP; reusable adapter; provider switching).
- Supporting: **#233** (*✅ Done — merged PR [#905](https://github.com/WordPress/ai/pull/905) deprecates the layer, not deletes it, and the card closed against it*), **#203** (extensibility hook for Ability Table columns, Future Release), **#32** (AI Playground debug tool), plus **`core/read-content`** (#739, merged Done in 1.2.0), **`core/manage-settings`** (#764, 1.4.0), **`core/read-nav-menus`** (#858, 1.4.0), and the standalone-abilities toggle (**#863, ✅ Done via merged PR #881**). **#307** (AGENTS.md) was closed `NOT_PLANNED` — declined, not shipped. **`core/read-users`** (#774) merged earlier; off-board #856 is no longer open. Abilities Explorer custom-provider support (#883) shipped via PR #884 and was de-carded. The experiment `register()` → `init()` rename (#145) shipped board-Done earlier. Upstream `WordPress/abilities-api` **#84** (generic CRUD across post types; client vs server `execute_callback`) remains open, but is no longer on Project #240.

### B. Connectors, Providers & Model Management
Direction settled: **thin core Connectors screen discovering independent per-provider plugins** (the bundle-everything path, PR #148, was abandoned).

- **#502 Provider plugin discovery/curation/labeling** — the strategic parent. Three unresolved axes: discovery model (hardcoded list vs WP.org Plugins API vs `connector` tag), curation/"vetted" concept, and official-vs-third-party labeling.
- **#27 Surface additional provider plugins on Connectors** *(1.4.0)* — list third-party providers + "progressive provider selection" (hide UI when a valid provider exists); host pre-config via constants/filters. **Strong demand for OpenRouter** (one key, many models).
- **#262 Provider-level model bucketing** — replace hard-coded model priority lists with a user-facing **provider preference** (not specific models); future capability tiers (fast/cheap vs high-reasoning). *Scope being questioned now that a per-experiment "developer mode" already exposes provider+model.*
- **#191 Settings + provider import/export** *(✅ shipped — PR #734 merged 2026-07-24 under 1.3.0; de-carded from the board this window)* — portability for agencies/hosts/multisite finally landed; the secure-credential-handling debate that held it up is resolved in the merged implementation.
- **#632** *(board-Done / closed)* deactivate a connector without losing its key · **#660** *(Needs review / 1.4.0; PR #759)* clearer "blocked by Connector Approvals" error · **#815** *(1.2.0, board-Done via PR #830 and now de-carded)* surface an admin notice when Connector Approvals still needs the AI plugin granted access to a connected provider (WPORG support report; related to #660).
- **#933 Connector validity is capability-aware, not text-only** *(board-new, In progress / 1.4.0; whyisjake, PR #935)* — `has_valid_ai_credentials()` asks only "can this connector generate text?", so a speech- or image-only connector is told it may be invalid even when correctly configured. First surfaced as the wording/verdict mismatch behind that notice; affects any site whose only connector is non-text.
- **#940 Custom settings endpoint vs `/wp/v2/settings`** *(board-new, In discussion, unmilestoned)* — Core revalidates stored AI keys on any settings POST/PUT, and a transient provider failure wipes the key. Extracted from PR #881's review thread (core.trac#65867, `wordpress-develop#13031`); dkotter confirms it is biting him regularly and prefers a plugin-side fix (custom endpoint or a timeout bump) while upstream lands later.

### C. Content & Editorial Experiments (the authoring lifecycle)
Expanding from per-field generators toward full co-authoring.

- **#297 Content Generation** — native Block Editor **co-author** (first drafts from title, expand sections, rewrite selection; `/ai` slash command, ghost-typing, accept/reject diffs). Well-specified, awaiting design (karmatosed). ⭐ *Major bet.*
- **#324 Evolve "Refine" → agentic/collaborative editorial** *(1.4.0)* — a "WordPress AI" user editing live via Gutenberg **Real-Time Collaboration**; deferred to let RTC stabilize. ⭐ *Major bet.*
- **#338 Analytics-aware content & amplification** *(In progress; assignee zeus2611)* — content-gap mining (low-engagement on-site searches) + traffic-surge social amplification, via a `Stats_Provider` adapter (**Jetpack Stats first**); split into two sub-issues. ⭐ *Major bet — closes ideation→distribution loop.* Draft PR **#929** (shared `Stats_Provider` layer + dashboard widget, "1/2 for #338") opened this window — the first code on this card.
- **#625 Social Content Generation** *(**moved In discussion → In progress** this window; assignee Malayt04)* — platform-specific posts (Bluesky/Mastodon/LinkedIn) from post content; persist to meta; hooks for Jetpack Social/Blog2Social. Also has no PR yet.
- **#508 "Suggest Reply"** for comments + Activity widget *(shipped in 1.2.0 via PR #724; now de-carded from the board)* — the 1.2.0 lane's first genuinely new experiment (re-introduces #155's removed feature properly; human review, **not** auto-reply).
- **#875 Internal-link suggestions** *(In progress / 1.4.0)* and **#876 permalink-slug suggestions** *(✅ Done via merged PR #897)* — the newest editorial pair. #876 landed after the 1.4.0 → Future Release → 1.3.0 round trip; #875 carried over into the loaded 1.4.0 lane with PR #887 (Infinite-Null) still CHANGES_REQUESTED. Where #875 surfaces in the editor is still the open product question.
- **Reusable control layer:** tone (#186), multilingual rewriting/translation (#187, *✅ board-Done under 1.3.0 — PR #747 merged 2026-07-28*), persona/voice (#188).
- Enhancements: **#614** bulk summary generation *(Done in 1.2.0)* · **#90** consolidate Title Generation options · **#507** Editorial Updates → Visual Revisions *(✅ shipped — PR #861 merged 2026-07-24; de-carded this window)* · **#452** classification relevance *(✅ shipped — PR #633 merged 2026-07-21; de-carded this window)*.

### D. Agentic / Chat / Site-Agent + Media
The biggest **directional shift** — from single-task helpers to a conversational agent that takes actions. Three convergent issues:

- **#142 Frontend chat agent** — "chat with my site" for public **visitors** (RAG over owner-selected content + FAQ, citations). Designed proposal; needs an embeddings/indexing pipeline (shared with #282).
- **#282 Admin "AI Workspace"** — full-screen wp-admin multi-step chat (Site-Editor-styled, DataViews), capability-gated Search/RAG middleware, actionable artifacts ("Create Draft"). Most fleshed-out spec; assigned karmatosed for mockups.
- **#189 Site Agent** — natural language → **explicit, verifiable WP actions** (create posts, install plugins, change settings). Opt-in, disabled by default, capability-respecting, fully auditable. ⭐ *Major bet (idea-stage).*
- **#190 Site-wide insights** — read-only cross-content analysis (themes/gaps/trends); the safe data layer feeding the agentic surfaces.

**Media & Vision:** focus-aware crop suggestions (#238) · integrate media experiments with Gutenberg's experimental **Media Editor** (#325) · **C2PA** provenance detection on upload (#421, *1.3.0, In progress* — PR #459 remains its authoritative closing PR, but **#459 lost its board card this window** and its checks went FAILURE) · alt-text button placement (#425, **Blocked**; the volunteer implementation PR #885 was closed unmerged on 2026-07-20, so the issue is again unimplemented).

**Search/RAG:** two parallel efforts. Native vector search (#683, draft PR, 1.4.0) is the board-tracked MariaDB-backed semantic-search/RAG experiment with fallback post-meta embeddings; separately, **#844 semantic search in wp-admin** remains In progress behind PR #891. Underneath both, PR **#892** **merged this window** — it vendors PHP AI Client embedding support into the plugin behind an `SDK_Overlay`, needed because the core route (`wordpress-develop#12530`) slipped from WP 7.1 to 7.2. Three windows uncarded, then carded and merged: the embeddings substrate is now in `develop`, and #683/#844/#891 inherit it.

**Extensibility & community:** custom prompt-template hooks (#192, *✅ shipped — PR #770 merged 2026-07-20; de-carded*) · developer-only request/response log panel (#193, *✅ closed 2026-08-05 as already delivered by PR #437 and re-milestoned to 1.0.0*) · Comment Moderation value/relevance scoring (#514, PR #681, 1.4.0) · low/no-tech educational content for the WP 6.9 launch (#47) · **#918**, an AI-generated `/llms.txt` site index for agent consumption (Triage, now Future Release; the differentiator claimed over existing SEO-plugin implementations is that descriptions are AI-generated via `core/read-content` and the summarization abilities).

---

## 7. Unplanned / undecided / blocked

- **21 In discussion / Needs decision cards** = 19 issues + exploratory PRs #211 and #224. Up from 20: board-new **#923** (agent users) and **#940** (settings endpoint) arrived while **#600** left for To do — and #923 is the most substantive governance discussion filed in several windows.
- **3 Triage issues, all now under Future Release:** #40 (Core Abilities), #890 (mobile right-sidebar component, still no labels/comments after three weeks), and **#918** (AI-generated `/llms.txt`; the standard-settledness question jeffpaul asked remains unanswered).
- **Blocked direction:** #425 still depends on a usable Media Editor surface; PR #494 remains the corresponding blocked implementation — and its `#238` link is still the **only** fallback-parsed relationship left anywhere in the census.
- **Review-ready issues: three, all under 1.4.0** — **#660** (provider-approval error copy, PR #759), **#514** (comment value/relevance, PR #681), and **#732** (non-SDK request logging, PR #757), the latter two moved In progress → Needs review this window. All three of their PRs are unmergeable.
- **Board hygiene:** merged PR #484 still shows Needs review under 0.9.0; PR #621 shows Done despite being closed unmerged; dependabot PR **#922** remains Done though closed unmerged — and **PR card #459 was removed** this window while its PR is still open (now the only representation of C2PA work is issue #421).
- **⚠️ Roadmap-visibility gap — six down to one, and the six left by being tracked:** every one of last window's unexplained PRs — **#888**, **#892**, **#909**, **#915**, **#916**, **#917** — received a board card this window (**#892/#909/#915 merged under 1.3.0; #888/#916/#917 now open under 1.4.0**). The single remaining gap is **#941** "Content Translation: Add user-triggered retry" (yogeshbhutkar, repo-milestoned 1.4.0) — a follow-up to the shipped translation experiment that retries only failed blocks, with no closing reference and no board issue. It is the current strict-audit failure, and it is a materially smaller risk than any entry in the six-PR set it replaced.
- **Key open decisions:** ability governance/granularity (#40/#348/#354, plus the new agent-identity dimension #923), WebMCP standard risk (#448), provider discovery (#27/#502), where internal-link suggestions surface (#875, 1.4.0), connector-validity semantics (#933), whether #918's `llms.txt` proposal is in scope for this plugin, the custom-settings-endpoint question (#940), and whether #621's abandoned uploads-URL hardening is worth reopening.

---

## 8. Strategic read & risks

**Where it is heading:** discrete AI helpers are becoming a governed, agent-capable WordPress platform. Abilities provide the action primitive; Connectors and model preferences provide provider independence; editorial experiments provide user-facing workflows; search/RAG, MCP/WebMCP, and site-agent ideas connect those layers.

**Watch-items / risks:**

1. **External dependencies** — WordPress core, the AI Client, Gutenberg Media Editor/RTC/Guidelines work, and abilities-api can change delivery paths without changing Project #240. This window closed one such loop — the embeddings substrate (#892) merged after three windows uncarded — and opened a new one: mcp-adapter shipped **v0.6.0/v0.6.1** while php-ai-client #274/#275 keep moving the client layer underneath the plugin.
2. **Governance before write abilities — the toggle shipped; the identity question arrived.** #863 closed via merged PR #881, so standalone-ability enablement is now deliberate — and #888 (Text to Speech, now carded under 1.4.0) brings two new abilities into that regime. The next governance frontier is **#923 (agent users)**: who the agent is, before how much it may do, with real production evidence (50.2% of tool calls unattributable) already on the thread.
3. **Backlog-to-commitment gap — narrowed by shipping, not by labelling.** This window the 1.3.0 lane actually drained: 21 non-Done → 2, with seven issues closed by merged PRs. The residue is honest: one feature (#421) and the release checklist (#924). The new risk is the inverse of last window's — **v1.4.0's 19 cards are 13 re-milestoned items plus newcomers**, loaded while two of its issues (#27/#324) are still undecided and #875's product question is still open.
4. **Compatibility regressions** — two live ones this window, both connector-shaped: **#933** (speech/image-only connectors falsely reported invalid) and **#940** (any settings save can wipe a stored AI key when provider validation transiently fails — dkotter says it is happening to him regularly). The latter is the first plugin-side workaround for a core bug that upstream will only fix next release.
5. **Board ≠ repo — the gap collapsed, and it closed by tracking, not by merging away.** 28 open PRs = 16 direct + 11 linked + **1 unexplained (#941)**. All six of last window's unexplained PRs got cards; three of them merged. The caution now inverts: the one unexplained PR is *small*, but the boundary between "board-tracked" and "not" moved without a stated policy — #889/#888/#892 were carded, while #459 was **de-carded** mid-flight. The board's carding decisions remain the thing to watch, not the gap count.
6. **Board status is not delivery status** — #484 remains non-Done despite being merged; #621 and #922 are Done despite being closed unmerged; and this window #307 reached Done by being **declined** (`NOT_PLANNED`). The Done delta is finally mostly real delivery, but the exceptions above are still counted.
7. **Board totals are not scope** — the board rose 269 → 279 while the mix shifted 214/55 → 222/57, driven by carded-and-Done'd 1.3.0 PRs. Read `.board.added`/`.board.removed` and the milestone deltas, not the total.
8. **Review throughput is the binding constraint, and it did not move.** Zero of 28 open PRs carry an approving review, all are BLOCKED (12) or DIRTY (16), 17 have failing checks, 11 carry CHANGES_REQUESTED, and the window's readiness changes are mostly regressions (#459/#681/#858/#888 → DIRTY; #916/#917 CHANGES_REQUESTED). The 1.3.0 release wave merged work *despite* this because maintainers pushed through the queue themselves; the same queue is now what 1.4.0 is waiting on.

---

## 9. Appendix — full open-issue tracker (48)

> 📄 Deep dossiers live in [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md). The current scope is **48 board-open issues**: 47 in `WordPress/ai` plus Google-provider issue #23. PR cards are tracked separately in [`wordpress-ai-planned-work.md`](./wordpress-ai-planned-work.md).

Grouped by current board status. Theme tags are editorial aids; Status and Milestone come from Project #240.

### In discussion / Needs decision (19)

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
| [#643](https://github.com/WordPress/ai/issues/643) | Future | Bug | — | "AI" plugin 1.0.1 – Connectors and AI settings pages load blank (JavaScript error) on WordPress 7.0 |
| [#741](https://github.com/WordPress/ai/issues/741) | 1.4.0 | Bug/Infra | prasadkarmalkar | AI Admin Pages Exhibit Visible Flicker During Initial Render |
| [#791](https://github.com/WordPress/ai/issues/791) | Future | Content | — | Add loading animation/custom cursor for Type Ahead |
| [#923](https://github.com/WordPress/ai/issues/923) | Future | Platform | gziolo | **Board-new** — Introduce agent users to give AI agents an auditable identity |
| [#940](https://github.com/WordPress/ai/issues/940) | — | Bug/Infra | — | **Board-new** — Custom endpoint for settings save to bypass the core `/wp/v2/settings` revalidation bug |

### In progress (13)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#203](https://github.com/WordPress/ai/issues/203) | Future | Platform | — | Add extensibility hook for custom Ability Table columns |
| [#238](https://github.com/WordPress/ai/issues/238) | Future | Agentic/Media | TylerB24890 | Add focus-aware crop suggestions |
| [#325](https://github.com/WordPress/ai/issues/325) | Future | Agentic/Media | TylerB24890 | Integrate media features and experiments with Gutenberg's experimental Media Editor |
| [#338](https://github.com/WordPress/ai/issues/338) | Future | Content | zeus2611 | New Experiments: Analytics-aware content and amplification recommendations *(moved from In discussion; no PR yet)* |
| [#421](https://github.com/WordPress/ai/issues/421) | 1.3.0 | Agentic/Media | — | WordPress should detect C2PA manifests on upload |
| [#625](https://github.com/WordPress/ai/issues/625) | Future | Content | Malayt04 | New Experiment: Social Content Generation for platform-specific social posts *(moved from In discussion; no PR yet)* |
| [#689](https://github.com/WordPress/ai/issues/689) | Future | Infra | i-anubhav-anand | Add a user-facing control for automatic log cleanup |
| [#736](https://github.com/WordPress/ai/issues/736) | 1.4.0 | Platform | — | Expose role/user access controls per feature/experiment *(moved into the loaded 1.4.0 lane)* |
| [#844](https://github.com/WordPress/ai/issues/844) | Future | Agentic/Media | priyanshuhaldar007 | New Experiment: Semantic search in wp admin |
| [#845](https://github.com/WordPress/ai/issues/845) | 1.4.0 | Infra | dkotter | New Experiment: Markdown feeds (powered by `html-to-md`) |
| [#875](https://github.com/WordPress/ai/issues/875) | 1.4.0 | Content | Infinite-Null | New Experiment: Suggest internal links within post content *(carried into the 1.4.0 lane)* |
| [#924](https://github.com/WordPress/ai/issues/924) | 1.3.0 | Release | dkotter, jeffpaul | **Board-new** — Release version 1.3.0 *(target 2026-08-17)* |
| [#933](https://github.com/WordPress/ai/issues/933) | 1.4.0 | Bug/Providers | whyisjake | **Board-new** — Connector validity check assumes text generation, so speech-only and image-only connectors report as invalid |

### Backlog (6)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#142](https://github.com/WordPress/ai/issues/142) | Future | Agentic/Media | — | Frontend chat agent powered by site content |
| [#186](https://github.com/WordPress/ai/issues/186) | Future | Content | — | Add tone adjustment controls for AI-generated content |
| [#188](https://github.com/WordPress/ai/issues/188) | Future | Content | — | Add persona-driven content generation experiments |
| [#189](https://github.com/WordPress/ai/issues/189) | Future | Agentic/Media | — | Explore an admin Site Agent for executing WordPress actions |
| [#282](https://github.com/WordPress/ai/issues/282) | Future | Agentic/Media | karmatosed | Chat experiment: Integration outside the editor and outside single-task AI use |
| [#297](https://github.com/WordPress/ai/issues/297) | Future | Content | karmatosed | New experiment: Content Generation |

### To do (4)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#32](https://github.com/WordPress/ai/issues/32) | Future | Infra | — | Add AI Playground interface (prompt testing & debug tools) |
| [#190](https://github.com/WordPress/ai/issues/190) | Future | Agentic/Media | yogeshbhutkar | Add site-wide AI-powered content insights |
| [#339](https://github.com/WordPress/ai/issues/339) | Future | Bug | — | AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin |
| [#600](https://github.com/WordPress/ai/issues/600) | 1.4.0 | Bug/Infra | — | Remove `Enable AI` header toggle, allow feature/experiment toggles (and group toggles) to control plugin functionality *(moved from In discussion; retitled + Help Wanted)* |

### Triage (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#40](https://github.com/WordPress/ai/issues/40) | Future | Platform | gziolo, jorgefilipecosta | WordPress Core Abilities |
| [#890](https://github.com/WordPress/ai/issues/890) | Future Release | UI/Mobile | — | Add mobile right sidebar display component |
| [#918](https://github.com/WordPress/ai/issues/918) | Future Release | Platform | — | Feature: AI-generated `llms.txt`, a curated LLM-friendly site index served at `/llms.txt` |

### Needs review (3)

| # | Milestone | Theme | Assignee | Summary |
|---|---|---|---|---|
| [#514](https://github.com/WordPress/ai/issues/514) | 1.4.0 | Content | — | Add comment value / relevance to Comment Moderation experiment *(moved from In progress; PR #681)* |
| [#660](https://github.com/WordPress/ai/issues/660) | 1.4.0 | Providers | — | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals |
| [#732](https://github.com/WordPress/ai/issues/732) | 1.4.0 | Bug/Infra | — | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible *(moved from In progress; PR #757)* |

**Removed-board reference:** [`WordPress/abilities-api#84`](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not counted in Project #240.

---

## 10. How to refresh this document

> ⚙️ **Automated path:** [`wp-ai-roadmap-refresh.sh`](./wp-ai-roadmap-refresh.sh) does everything below in one command — re-pulls the board, diffs against the last snapshot (added / newly-Done / merged / status & milestone moves / removed), fetches the full PR/release census for all repositories declared through [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json), refreshes the curated dependency watchlist, and can append a changelog row (`--update-changelog`). Run with no args for a read-only report; add `--save` to roll all board, repository, release, and dependency baselines forward. The manual recipe below is what it automates.
>
> **Normal vs. strict refresh.** The default (normal) refresh is *warning-only*: any data-quality or coverage problem — an unreachable dependency, a substantive open PR with no board representation — is reported in the output (`.validation` in JSON, stderr lines otherwise) but never blocks the board report, and the run exits `0`. `./wp-ai-roadmap-refresh.sh --strict [--json]` runs the same read-only pipeline as an **audit**: it emits the complete report first, then exits `2` when any validation error remains (exit `1` is reserved for operational failures that prevented a report at all). A strict failure also suppresses `--save` and `--update-changelog` ("persistence skipped"), so a red audit never rolls the baseline forward.
>
> Strict is a **scheduled visibility audit, not a merge gate**: whether every substantive `WordPress/ai` PR is linked to Project #240 depends on upstream contributor behavior, so a persistent red result means *unresolved roadmap visibility* (work in flight that the board doesn't show), not a broken tracker. Point-in-time coverage: 28 open PRs = 16 direct board PR cards + 11 linked to board issues (**all 11 via authoritative `closing` references**; the only fallback-parsed relationship left anywhere is #494 → #238 on a direct board PR card) + 0 routine dependency PRs + 0 linked-off-board + **1 unexplained (#941 — the current strict-audit failure)**. All six of last window's unexplained PRs (#888, #892, #909, #915, #916, #917) were carded this window — #892/#909/#915 merged under 1.3.0 — so the gap fell six to one by tracking, not by merging away.
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
| 2026-08-14 | **Live refresh vs the 2026-08-10 11:11 UTC baseline — a shipping window: v1.3.0 drained to its release checklist, and v1.4.0 was finally loaded.** Board **269 → 279** = 222 PRs + 57 issues (mix 214/55 → 222/57); Done **202 → 214**; non-Done **67 → 65** = **48** open issues (was 51) + **17** PR cards (16 open + stale merged #484). **Nine cards reached Done, and all nine are real delivery or a deliberate decision:** seven issues closed by merged PRs — **#233** (`AI_Service` deprecation, PR #905), **#690** (uninstall cleanup, #692), **#863** (abilities toggle, #881), **#866** (`wpai_` meta prefix, #867), **#876** (permalink slugs, #897), **#906** (reserved log-type API, #914) — plus **#307 closed `NOT_PLANNED`** (the AGENTS.md proposal was declined after the April debate), and PR cards **#889/#920** merged. Five more PRs arrived already-Done under 1.3.0 (**#892**, **#909**, **#915**, **#930**, **#934**). Removed: translation issue **#187** (shipped earlier via #747, de-carded Done), webinar spam **#900**, and **PR card #459** — whose PR stays open and `closing`-linked to #421 but whose checks went FAILURE. **Tier moves: ① v1.3.0 26 → 19 carded (5 Done / 21 open → 17 Done / 2 open)** — the residue is C2PA **#421** plus release issue **#924** (target **2026-08-17**); **① v1.4.0 2 → 19** (11 issues + 8 PRs) — thirteen cards re-milestoned in from 1.3.0 (#514, #600, #660, #683, #732, #736, #741, #764, #777, #832, #845, #858, #875), joined by PR cards #888/#916/#917 and board-new **#933**; **② Future Release 42 → 41** (33 issues + 8 PRs; gained #923/#931/#890/#918, lost #600/#736 to 1.4.0 and #294/#302/#307 by milestone-clearing on Done); **④ Unscheduled 2 → 1** with board-new **#940** (custom settings endpoint vs `/wp/v2/settings`), #890/#918 now Future Release; **③ straggler #484 unchanged**. Status moves: **#600** In discussion → To do (retitled "Remove `Enable AI` header toggle…" + Help Wanted), **#514/#732** In progress → Needs review, #876 → Done. Delivery-readiness by status: In progress **29 → 23**, In discussion **20 → 21**, Needs review **6 → 8**, Backlog **6**, To do **3 → 4**, Triage **3**. **The visibility gap collapsed 6 → 1, and the six left by being tracked:** all of last window's unexplained PRs (#888/#892/#909/#915/#916/#917) were carded this window — **#892/#909/#915 merged under 1.3.0**; the sole remaining unexplained PR is **#941** "Content Translation: Add user-triggered retry" (yogeshbhutkar, repo-milestoned 1.4.0). Issue coverage is **47 of 47 open issues carded** — enforced by the audit. Readiness is unchanged in kind: 28 open PRs = **0 approvals**, 11 CHANGES_REQUESTED, BLOCKED 12 / DIRTY 16, 17 failing checks, 7 drafts; the window's six readiness changes are mostly regressions (#459/#681/#858/#888 → DIRTY, #916/#917 CHANGES_REQUESTED). **Upstream shipped for the first time:** `mcp-adapter` released **v0.6.0 (2026-08-12) and v0.6.1 (2026-08-13)** after its DTO cluster merged (#171/#223/#252/#263); open PRs 18 → **12**, open issues 46 → **41** (new #280 HTTP transport). `php-ai-client` 26 → **28** (**#274** explicit embedding model, **#275** provider-plugin updates), issues 35 → **34**. `abilities-api` frozen at 14 PRs / 8 issues / v0.4.0 (still pending archival). The dependency watchlist logged its **first state change in four windows**: `gutenberg#73771` OPEN → CLOSED (16 items now 9 open / 4 closed / 3 merged). Script passes `bash -n`, the eight offline suites, `census --strict`, `dependencies --strict --json`, and the live dependency smoke test; `--strict --json` exits 2 for exactly #941. |
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
- "WordPress AI" board == the WordPress/ai Showcase Plugin in practice (278/279 items).
- Roadmap signal = open ISSUES plus the non-Done PR lane; PRs are most of the 202 Done cards.
- Board total can FALL without scope loss: post-release the team de-cards finished milestone cards in bulk (10 removed 2026-07-27, 6 on 2026-08-10). A RISE can be real delivery — 2026-08-14 was 269 → 279 with 13 added (5 already-Done 1.3.0 PRs carded) and 3 removed. Always read .board.added and .board.removed, never the count alone.
- Dependabot PRs are carded now, so `routine` reads 0 while dependency PRs still enter Done (2 merged + 1 closed-unmerged on 2026-08-10). Routine==0 does not mean "no dependency churn".
- Priority field is barely used; track via Status + Milestone.
- Strategic bets (⭐): #348, #40, #430, #297, #324, #338, #189, #282. Risk (⚠️): #448 (WebMCP), #643 (live regression).
- Watch core deps: WP 6.9 Abilities API, WP 7.0 AI Client, Gutenberg RTC/Media Editor/Guidelines→Skills, abilities-api repo.
-->
