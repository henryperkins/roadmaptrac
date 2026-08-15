# WordPress AI — Open Issues Dossier (Companion Reference)

> Deep per-issue documentation for all **48 open issues** (status rechecked 2026-08-14) on the [WordPress AI Planning & Roadmap board (#240)](https://github.com/orgs/WordPress/projects/240).
> Companion to [`wordpress-ai-roadmap.md`](./wordpress-ai-roadmap.md) and [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md). Each dossier records the problem, approach, open decisions, dependencies, and discussion.
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-08-14 |
> | **Scope** | 48 current open-issue dossiers + 1 removed-board reference (#84) + 50 recently board-Done dossiers retained for reference. Excludes 17 non-Done PR cards, the rest of the 214 Done cards, and census-only upstream issues. |
> | **Repos** | Board dossiers: `WordPress/ai` (47 open issues) · `WordPress/ai-provider-for-google` (#23). Removed-board reference: `WordPress/abilities-api` #84. `WordPress/php-ai-client` and `WordPress/mcp-adapter` are tracked separately as full PR/issue/release censuses, not imported as issue dossiers. |
> | **Each dossier** | Status · Milestone · Labels · Assignees · Last updated · Comment count · Link, then Problem → Approach → Open decisions → Dependencies → Discussion |

**Grouped by board status:** [In discussion / Needs decision (19)](#in-discussion--needs-decision-19) · [In progress (13)](#in-progress-13) · [Backlog (6)](#backlog-6) · [To do (4)](#to-do-4) · [Triage (3)](#triage-3) · [Needs review (3)](#needs-review-3) · [Recently board-Done (50 retained)](#recently-board-done-since-the-2026-06-15-snapshot) · [Removed from Project #240](#removed-from-project-240-reference)

> ⭐ = major strategic bet · ⚠️ = notable risk / live regression. "Status" reflects the board; "Milestone" is the release target.

**Movement in the 2026-08-14 window:** the 1.3.0 delivery wave closed seven dossiered issues by merged PRs — **#233** (`AI_Service` deprecation, PR #905), **#690** (uninstall cleanup, #692), **#863** (abilities toggle, #881), **#866** (`wpai_` meta prefix, #867), **#876** (permalink slugs, #897), **#906** (reserved log-type API, #914) — and declined **#307** (`NOT_PLANNED`); all seven moved to *Recently board-Done*. **#514** and **#732** moved In progress → Needs review; **#600** moved In discussion → To do (retitled "Remove `Enable AI` header toggle…" with a Help Wanted label). Board-new dossiers: **#923** (agent users) and **#940** (custom settings endpoint) in In discussion, **#924** (1.3.0 release) and **#933** (connector validity) In progress. #736/#845/#875 re-milestoned 1.3.0 → 1.4.0, #890/#918 → Future Release.

---

## In discussion / Needs decision (19)

*The genuinely uncommitted questions — debated, not promised. Most platform-level bets live here.*

### #21 — How to best support hundreds or thousands of abilities
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Question · **Assignee(s):** — · **Updated:** 2026-05-25 · **Comments:** 11
**Link:** https://github.com/WordPress/ai/issues/21

**Problem / goal.** LLM tool selection degrades sharply past ~10 tools, yet sites with many plugins could register hundreds or thousands of abilities. Surfacing abilities 1-to-1 as MCP tools (or model function declarations) will overwhelm models. Needs a discovery/scaling strategy so the AI's effective surface area stays small.

**Proposed approach.** A Layered Tool Pattern (à la Square MCP): start with a tiny tool surface that expands via discovery. Originally proposed three tools — `get_abilities_by_category`, `get_ability_info`, `use_ability` — backed by a required category taxonomy on ability registration. Later discussion converged on the now-dominant `find_tool` + `call_tool` (semantic search) pattern as the recommended Experiment to scope this to.

**Open decisions / blockers.**
- Whether scaling logic belongs in Core's Abilities API vs. as an MCP-Adapter/AI-plugin implementation detail.
- UX cost of multiple tool calls for simple tasks; balancing layered discovery against native MCP categorization (modelcontextprotocol#1300).
- Whether the experiment exposes generic `find_tool`/`call_tool` or WP-specific `find_ability`/`use_ability`; what metadata semantic discovery needs; which abilities stay always-exposed.

**Dependencies.** Abilities API registry filtering (Trac #64990); MCP Adapter; #40; modelcontextprotocol#1300; external prior art (Square, GitHub remote MCP server).

**Discussion highlights.** JasonTheAdams framed it and argued the limit is model-general, not MCP-specific. justlevine cautioned against letting MCP's current immaturity drive a generic abstraction, recommending MCP limitations be handled inside the MCP Adapter while the registry gets independent discoverability. By the May 2026 contributor call, justlevine reported the ecosystem converging on a single semantic `find_tool`/`call_tool` pattern; gziolo linked research on architecting tools for AI agents at scale. jeffpaul flagged it for an AI-call agenda; a community member shared an external adapter handling 1518 abilities across 42 categories.

### #23 — [Bug]: Image Generation fails with "Unexpected Google API response: Missing the candidates[0].content key"
**Status:** In discussion / Needs decision · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-05-13 · **Comments:** 2 · **Repo:** `WordPress/ai-provider-for-google`
**Link:** https://github.com/WordPress/ai-provider-for-google/issues/23

**Problem / goal.** Using "Generate Image" in the Image block (WP 7.0 RC, Google/Gemini provider, on WordPress Playground), clicking Generate fails immediately with `Unexpected Google API response: Missing the "candidates[0].content" key`; no image is produced. Suspected: the Gemini API response format changed, the request was silently rejected, or the provider's parsing mishandles it.

**Proposed approach.** None specified yet — root cause unconfirmed.

**Open decisions / blockers.** API format change vs. silent rejection vs. parser bug not yet diagnosed.

**Dependencies.** Google Gemini API; AI Provider for Google plugin; WP 7.0 RC; reproduced on Playground.

**Discussion highlights.** Originally filed on `WordPress/ai`; jeffpaul (cc felixarntz, JasonTheAdams) judged it "almost certainly a bug in the provider plugin" and transferred it to the provider repo. No fix posted yet.

### #27 — Display additional AI provider plugins on Connectors page (alongside default Anthropic, Google, and OpenAI ones)
**Status:** In discussion / Needs decision · **Milestone:** 1.4.0 · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-16 · **Comments:** 12
**Link:** https://github.com/WordPress/ai/issues/27

**Problem / goal.** Enable developers, agencies, and hosts to pre-configure AI providers that are auto-recognized, supporting "progressive provider selection" (use existing configured providers; only prompt for configuration when none applies) and reducing manual setup. Evolved toward surfacing additional provider plugins on the Connectors page beyond the default Anthropic/Google/OpenAI.

**Proposed approach.** Configuration via constants, filters, or config files for pre-configured providers; modular per-feature detection; hide the provider-selection UI when a valid pre-configured provider exists. justlevine recommends provider settings live in wp-ai-client and settings-layer logic in AI Experiments, deeming config files overkill. Later direction (jeffpaul): display select **vetted** provider plugins on Connectors, gated by a requirements checklist.

**Open decisions / blockers.**
- Where logic lives: AI Experiments plugin vs. WP AI Client.
- Whether AI Experiments becomes a dependency plugin giving advanced users one settings screen.
- How the plugin "knows" the population of provider plugins.
- Inclusion criteria/checklist for which provider plugins to list.

**Dependencies.** wp-ai-client; encapsulated feature architecture; WP.org plugins API; related to #148/#502. Punted from v0.2.0 originally.

**Discussion highlights.** jeffpaul listed 10 existing WP.org AI provider plugins (Alibaba Cloud, Azure AI Foundry, Grok, Hugging Face, llama.cpp, Mistral, mittwald, **Ollama**, **OpenRouter**, Open WebUI) and proposed eligibility rules (supports ≥1 plugin feature; offers a free/open-source model; new WP-org-hosted providers auto-qualify). phil-sola requested **OpenRouter** (one key, many models). jeffpaul asked to add the checklist decision to an upcoming AI call.

### #37 — MCP usage across features and request routing
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-06-19 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/37

**Problem / goal.** Expand and validate the plugin's use of MCP for routing AI requests and discovering provider capabilities, so it demonstrates best practices for integrating both the WP AI Client SDK and the underlying PHP AI Client SDK across features and providers.

**Proposed approach.** Implement MCP-based routing for at least one feature (e.g., Alt Text or Content Summarization); build a reusable adapter layer; demonstrate capability discovery, provider switching, and performance monitoring via MCP; document MCP-vs-direct-SDK guidance in `/docs/mcp-adapters.md`; validate WP AI Client ↔ PHP AI Client interop over MCP.

**Open decisions / blockers.** — (acceptance criteria defined; no discussion, assignee, or recent activity)

**Dependencies.** WP AI Client SDK; PHP AI Client SDK; MCP Adapter; Alt Text / Content Summarization experiments.

**Discussion highlights.** — (no comments; predates much of the later MCP-Adapter/AI_Service direction; last touched Feb 2026.)

### #47 — Low-/no-tech educational content
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** Good first issue, [Type] Task, Help Wanted · **Assignee(s):** — · **Updated:** 2026-04-08 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/47

**Problem / goal.** Create low-/no-tech educational content for site owners to promote the AI Experiments plugin alongside WP 6.9 — usable in the 6.9 about page/blog post and in WP AI team outreach. Placeholder to be fleshed out with a checklist/sub-issues.

**Proposed approach.** Iterate on content scope, then track via checklist/sub-issues on this placeholder.

**Open decisions / blockers.** karmatosed suggested moving direct tickets to later versions and punting on 6.9 for now.

**Dependencies.** Related issue #48; WP 6.9 release/marketing timing.

**Discussion highlights.** karmatosed volunteered to help, surfaced #48, and recommended deferring concrete tickets past 6.9.

### #90 — Clarify and consolidate Title Generation options in UI and Experiment settings
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design Feedback, Help Wanted, [Experiment] Title Generation · **Assignee(s):** — · **Updated:** 2026-02-20 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/90

**Problem / goal.** Following #10, the Title Generation experiment needs clearer definition of where/how its options are exposed. The current design shows a dropdown on the editor "Generate" button for title modes; options could also live in AI Experiments settings, or both. Keep the UI simple while offering advanced control.

**Proposed approach.** Review the in-editor Title Generation dropdown; explore experiment-level configuration for default mode; align behaviors so editor actions and experiment settings don't conflict. Design reference image attached.

**Open decisions / blockers.**
- In-editor dropdown only, experiment-setting defaults, or both?
- Which modes the dropdown should include (current: "Sentence case", "Title case"; others?).
- Do these modes make sense in non-English languages?
- Should the dropdown override or inherit experiment-level settings?

**Dependencies.** Title Generation experiment; follows #10.

**Discussion highlights.** jeffpaul moved it to Future Release to discuss with folks like karmatosed how best to allow Title Generation customizations (editor vs. settings) before returning it to a numbered milestone.

### #262 — Provider-Level Model Bucketing for Model Selection
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-07 · **Comments:** 5
**Link:** https://github.com/WordPress/ai/issues/262

**Problem / goal.** Model selection is hardcoded in `helpers.php` via three static priority lists (text/image/vision). Intentional (prevents surprise upgrades breaking things or inflating costs) but: users with multiple keys can't see which provider handles which task; there's no UI preference (only PHP filters); hardcoded model names are brittle.

**Proposed approach.** **Provider-level bucketing**: users pick a preferred *provider* (Anthropic/Google/OpenAI) per task type (text, image), while the internal model priority order within each provider stays intact (preserving stability). Defaults preset from current logic, so unconfigured behavior is unchanged. zeus2611 proposed a concrete lightest-touch version: an "Advanced" collapsible at the bottom of Settings → AI Experiments with two dropdowns (Text Generation Provider, Image Generation Provider). Longer-term: capability-tier buckets (fast/cheap vs high-reasoning) with an escape hatch.

**Open decisions / blockers.**
- Whether redundant now that a per-Experiment **developer mode** already exposes provider/model selection (jeffpaul questioned remaining scope).
- Reviewer sign-off pending.

**Dependencies.** `helpers.php` priority logic; settings UI; overlaps the Playground (#32), which needs dynamic model input.

**Discussion highlights.** jeffpaul supports it but insists it stay behind Advanced Settings (most users enter one provider and take defaults). zeus2611 agreed and offered to scope a PR.

### #324 — Evolve Refine from Notes into collaborative and agentic editorial workflows
**Status:** In discussion / Needs decision · **Milestone:** 1.4.0 · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-13 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/324

**Problem / goal.** Today Review Notes and Refine from Notes are separate manual steps, limiting a cohesive, collaborative, automated editorial workflow. Following #289, explore iterations balancing automation with user control and transparency.

**Proposed approach.** Four exploratory threads (may split): (1) **Real-Time Collaboration with a "WordPress AI" user** — refinements appear as live, attributable edits like any collaborator (real user or RTC virtual user); (2) **unified "Review & Refine" agentic flow** — AI generates Notes → user reviews/accepts → AI applies in one pass; (3) integration with **Chat Workspace (#282)** surfacing named agent actions ("Review my draft", "Refine my draft") from both Post Editor and Chat; (4) note-resolution + revision traceability — a "WordPress AI" confirming comment + link to a visual revision/diff per update (may need an auto-save per Note).

**Open decisions / blockers.**
- Whether "WordPress AI" must be a real user or RTC supports a virtual user.
- Whether to interject review points mid-process.
- Auto-save-per-Note requirement for diffs.

**Dependencies.** Gutenberg RTC (must stabilize post-WP 7.0; full inclusion targeted WP 7.1); Chat Workspace #282; follow-up to #289.

**Discussion highlights.** jeffpaul moved it out a couple releases to let Gutenberg RTC stabilize, avoiding pinning a specific Gutenberg version until WP 7.1 ships RTC.

### #348 — Feature Request: Unified AI Management Layer for WordPress Core
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-04-09 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/348

**Problem / goal.** WP 7.0 ships strong AI foundations (AI Client, Abilities API, Connectors UI, MCP Adapter) but lacks a centralized management layer tying together permission control, usage metering, provider routing, and capability discovery. These are solved piecemeal by separate plugins (ai-router, ai-valve, AI Not, disable-ai-toolkit, Enable Abilities for MCP) that don't compose — an admin would need 3–5 plugins for basic permission + routing + metering with no guarantee they interoperate.

**Proposed approach.** A `wp-ai-management` layer between the prompt pipeline and provider execution, hooking the existing `wp_ai_client_prevent_prompt` filter (zero breaking changes), with four subsystems on a shared data model: (1) **structured 4-layer permissions** (master→plugin→feature→capability) with explicit `wp_register_ai_consumer()` plugin identity instead of call-stack inspection; (2) **usage metering/budgets** via a custom `ai_usage_log` table with global/per-plugin/per-role limits + alerts; (3) **capability-aware, admin-configurable provider routing** that configures (not bypasses) `using_model_preference()`; (4) a **machine-readable unified capability registry** with a REST discovery endpoint. Full REST + WP-CLI surface; phased plan (Foundation → Budgets & Routing → Capability Intelligence) targeting 7.1–7.2.

**Open decisions / blockers.**
- Permission default **allow vs. deny** (proposal + commenter favor deny/opt-in).
- Admin UI location: dedicated Settings → AI Management vs. tabs on Connectors.
- Cost-estimation ownership: Core cost table vs. provider plugins supplying pricing.
- Whether routing may *override* a plugin's model preference.
- Custom table vs. options API for high-volume usage logging (retention/auto-purge).

**Dependencies.** AI Client (`wp_ai_client_prevent_prompt`, `using_model_preference`, `ModelMetadata`); Abilities API; MCP Adapter; consolidates #342 (permissions) and #345 (usage safeguards); relates to #149 (observability), Trac #64872/#64873.

**Discussion highlights.** Authored by HILAYTRIVEDI as a fully-architected spec. nikolas4175-godaddy (author of the #342 four-layer model) endorsed **default-deny**, favored Connectors-page tabs, argued Core should expose the cost/usage display interface while provider plugins own pricing, held that admin/user preference must always beat plugin preference, and backed the custom usage table.

### #354 — Unifiied Abilities exposure controls
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-04-08 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/354

**Problem / goal.** After building several ability consumers, there's a need for unified control over **which abilities are available where**. Abilities come from plugins of varying quality, and users need to decide (e.g.) "expose these abilities to Claude via MCP, but those to my on-site AI agent." Without a central mechanism, every plugin with a "surface" ships its own version, fragmenting the ecosystem.

**Proposed approach.** Introduce a "Surface" concept: plugins register a consumer surface (`wp_abilities_register_consumer`-style); registering auto-generates a WP-Admin UI to pick which abilities are available on that surface; the abilities API can be queried per surface; every MCP server automatically becomes a surface. Full-catalog access remains available.

**Open decisions / blockers.**
- Exact registration API and how surfaces translate to query args (category/namespace/meta) + ecosystem-scoped hooks.
- Overlap with the broader management layer in #348.

**Dependencies.** Abilities API registry filtering for `wp_get_abilities()` (Trac #64990); MCP Adapter; WooCommerce + WebMCP adapters (already built ad-hoc filtering); related to #348.

**Discussion highlights.** gziolo connected this to Trac #64990, whose "Observed need" section documents the exact fragmentation (MCP adapter, WooCommerce, WebMCP adapter all rolling their own filtering). He argued a registered surface should translate into `$args` + per-surface visibility hooks so `wp_get_abilities()` becomes the single query point.

### #425 — Update placement of Alt Text generation buttons
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Good first issue, [Status] Blocked, Help Wanted · **Assignee(s):** — · **Updated:** 2026-05-18 · **Comments:** 6
**Link:** https://github.com/WordPress/ai/issues/425

**Problem / goal.** Move the Alt Text generation button closer to the Alt Text field. On the Edit Media page and Attachment details view, place it just under the "Alternative Text" textarea and remove the redundant standalone Alt Text metabox.

**Proposed approach.** Reposition the button inline beneath the alt-text field in both surfaces and delete the duplicate control. **Blocker:** core exposes no hook to inject content near the Backbone-rendered textarea, so only JS insertion works. Contributors filed core tickets to add proper hooks: **Trac #65086** and **wordpress-develop PR #11748** (action hooks for the media-modal attachment view); once merged, the button renders cleanly. Open `WordPress/ai` PR **#885** attempts the placement update, but GitHub exposes no closing reference: the refresh can associate it only through `fallback-title`, so it is candidate implementation evidence rather than an authoritative issue correction.

**Open decisions / blockers.**
- **[Status] Blocked**: awaiting Trac #65086 / wordpress-develop#11748.
- Button copy stays explicit (jeffpaul rejected icon-only/tooltip except in the block toolbar).
- Candidate PR #885 is BLOCKED and currently has failing Plugin Check and JavaScript-quality jobs; it needs both relationship clarification and implementation review.

**Dependencies.** WordPress core media templates/hooks (Trac #65086, wordpress-develop#11748); candidate plugin PR #885 (`fallback-title`, not `closing`).

**Discussion highlights.** CacheMeOwside flagged the missing hook; dhruvang21 suggested an AI beaker icon + loading animation; jeffpaul preferred explicit button copy and proposed animating the plugin icon instead; dhruvang21 opened PR #11748. PR #885 arrived on 2026-07-18 without updating the issue thread or declaring a closing relationship.

### #430 — Skills in a WordPress admin context
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-04-27 · **Comments:** 9
**Link:** https://github.com/WordPress/ai/issues/430

**Problem / goal.** Explore how "skills" — modular capabilities passed as context ad-hoc for domain-specific/repetitive workflows — fit into WordPress. Spans how agencies set up reusable skills for clients, how plugins provide skills, and how users create their own. Obvious entry: Command Palette integration (`/audit-accessibility`, `/rewrite-for-experts`).

**Proposed approach.** None finalized. Emerging consensus to split two tiers: plugins/devs define **full agent skills with script execution**; users save **reusable prompts/workflows/context** (possibly skills installable as a plugin type). gziolo is evolving the **Guidelines CPT → skills** (Gutenberg #77230, refactor PR #77643), noting Guidelines already model the split — "Site" guideline always loaded (like `AGENTS.md`), context-specific guidelines loaded on demand (like Skills).

**Open decisions / blockers.**
- What *kind* of skills: reusable prompts/context (doable now) vs. real agent skills bundling scripts (the latter the likely blocker).
- Relationship to Gutenberg "workflows" (#70710); justlevine warns visual workflow-building is far beyond WP scope.
- Whether to keep reusable-prompts and agent-skills under one umbrella or split.
- Site-level user scripts on top of plugin-bundled skills (jeryj found no path).
- Governance: a "skills linter"/standards, conflict detection, per-skill evals.

**Dependencies.** Gutenberg #70710 (workflows), #77230, PR #77643; Guidelines CPT / Content Guidelines experiment; WP AI Client tool calling + abilities; Command Palette; external Claude/Chrome agent-skills.

**Discussion highlights.** justlevine drew the prompts-vs-agent-skills distinction. swissspidy backed splitting the tiers and treating skills as installable plugins, each with an eval. derseitenschneider shared a detailed "Skill Blocks" experiment (CPT-stored prompt + scope, per-block diff review, each skill registered as a WP Ability dispatching through `wp_ai_client_prompt()`, provider-agnostic). gziolo/justlevine confirmed the "*like* AGENTS.md / *like* Skills" analogies are intentional, not claims of identity.

### #448 — Add WebMCP experiment
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-04-21 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/448

**Problem / goal.** Integrate WebMCP as an experiment. WebMCP lets a browser's built-in agent call page-registered tools, with the browser mediating between site and agent (no JSON-RPC). Two WP audiences: logged-in wp-admin users and front-end visitors. Initially explored in PR #224.

**Proposed approach.** Likely lean on a third-party JS polyfill (`@mcp-b/webmcp-polyfill`) to experiment cross-browser, since the Abilities API's name + description + JSON-Schema + implementation shape maps cleanly onto both WebMCP's `ModelContextTool` and MCP tools. Experiment status lets the team retire it easily.

**Open decisions / blockers.**
- ⚠️ Spec is volatile: a **Draft Community Group Report** (W3C Web ML CG), not Standards Track; API churned heavily (`provideContext`/`clearContext` removed Mar 5; `unregisterTool` → AbortSignal-based Mar 27); declarative HTML/CSS surface entirely TODO.
- Discovery, multi-agent negotiation, and headless are explicit non-goals.
- Polyfill can't replicate native browser-agent mediation (trust model, permission UIs) and lacks `callTool`/listing.
- Browser support thin: Chrome early DevTrial (M146+, **not** intent-to-ship); Edge "stay tuned"; Firefox/Safari "No signal."

**Dependencies.** Abilities API (tool source feeding both MCP and WebMCP); webmachinelearning/webmcp spec; `@mcp-b/*` polyfill; PR #224.

**Discussion highlights.** swissspidy recommended the GoogleChromeLabs webmcp-tools demos and underscored the two WP audiences. justlevine supported outsourcing polyfill maintenance under Experiment status (easy to retire) but warned both MCP and WebMCP are explorative and moving in different directions — cautioning against diverting resources from more practical features.

### #502 — Define how AI provider plugins are discovered, labeled, and surfaced in Connectors
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-05-05 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/502

**Problem / goal.** Define a model for how AI provider plugins are discovered, labeled, and surfaced in the core Connectors screen (WP 7.0). Picking up from #148 (which explored bundling providers), the direction shifted toward individual provider plugins. There's no defined mechanism for discovery, official-vs-third-party differentiation, or surfacing from the WP.org ecosystem. **The strategic parent of #27.**

**Proposed approach.** None finalized — frames three open axes: (1) **discovery model** (hardcoded list vs WP.org Plugins API vs tag-based, e.g. "connector"); (2) **curation/eligibility** + a possible "featured"/"vetted" concept; (3) **official-vs-third-party labeling** to reduce confusion and support burden. Directional signals: individual provider plugins, leverage the WP.org plugins API, prototype in the AI plugin before core adoption.

**Open decisions / blockers.** All three axes undecided.

**Dependencies.** Core Connectors screen (WP 7.0); WordPress.org Plugins API; related to #148/#27.

**Discussion highlights.** richardmorrison reported the same gap: a greyed-out "Not Available" state is unhelpful; suggests at minimum telling users they must install an AI Connector plugin.

### #643 — "AI" plugin 1.0.1 – Connectors and AI settings pages load blank (JavaScript error) on WordPress 7.0
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-06-18 · **Comments:** 3
**Link:** https://github.com/WordPress/ai/issues/643

**Problem / goal.** On WP 7.0 the plugin's config pages render completely blank — Settings → Connectors (`options-connectors.php`) and Settings → AI (`options-general.php?page=ai-wp-admin`). The React container `#options-connectors-wp-admin-app` stays empty; the UI never mounts, so no provider/API key can be entered. (WP 7.0, AI 1.0.1, AI Provider for Anthropic 1.0.3.)

**JS error specifics.** Two errors per load: (1) `Error: You tried to opt-in to unstable APIs as module "@wordpress/route"...` — from `private-apis.min.js` and `script-modules/route/index.min.js`; (2) `TypeError: Cannot read properties of undefined (reading 'privateApis')` — from `block-library.min.js`. Later diagnosis points to an environment/core-level cause: "AI Services" (felixarntz, 0.7.4) also loads blank (plus `Minified React error #130`), and the native block editor (`post-new.php`) is blank too with `jQuery.Deferred exception: Cannot read properties of undefined (reading 'getEditedPostAttribute')` — i.e. `wp.data` never initializes. Suggests shared `@wordpress/*` script-module deps in `wp-includes/js/dist/` are inconsistent (incomplete/corrupted WP 7.0 update or a plugin/theme dequeuing core scripts).

**Proposed approach.** None specified yet. Reporter's next step was reinstalling/repairing core via "Reinstall version 7.0"; maintainer follow-up asks whether the issue should move to Core Trac.

**Open decisions / blockers.**
- Whether this is a plugin bug or a broken-core-JS environment issue — evidence (block editor + multiple independent React admin UIs all blank) points to the latter.
- Conflict test done: deactivating Easy MCP AI, Extendify, Site Assistant didn't change the symptom.

**Dependencies.** Core `@wordpress/*` script modules (`@wordpress/route` private-APIs opt-in, block-library, react-dom, wp.data); WP 7.0 core integrity.

**Discussion highlights.** Two self-follow-ups by the reporter (polipsicomorfico) progressively reframe it from a plugin bug to a core/environment JS-dependency problem; jeffpaul asked for further triage and suggested Core Trac may be the right home.

### #741 — AI Admin Pages Exhibit Visible Flicker During Initial Render
**Status:** In discussion / Needs decision · **Milestone:** 1.4.0 *(was 1.3.0)* · **Labels:** [Type] Bug · **Assignee(s):** prasadkarmalkar · **Updated:** 2026-07-14 · **Comments:** 7
**Link:** https://github.com/WordPress/ai/issues/741

**Problem / goal.** AI-related admin screens briefly flash to a black/blank state during navigation and initial render. Repro is on AI 1.0.2 in WordPress Playground / Chrome: standard WP admin pages transition normally, but the **AI** and **Connectors** pages show a dark intermediate screen before content renders. Functional behavior still works, but the flash makes the AI screens feel slower and inconsistent with core admin pages.

**Proposed approach.** Root cause hypothesis from the first comment: inline critical styles in the generated AI admin page set `#wpwrap` to `background: var(--wpds-color-fg-content-neutral, #1e1e1e)`. Before the boot module mounts into `.boot-layout-container`, the CSS variable is unavailable, so the fallback paints the whole wrapper dark. Fix likely belongs in the boot/routes source that generates the page, not in the generated output.

**Open decisions / blockers.**
- Confirm whether the fallback/background is the only cause across AI and Connectors pages.
- Identify the source file for the generated admin-page critical styles.
- Check related Gutenberg work before changing AI plugin code; jeffpaul pointed to gutenberg#74572 as the closest quick find but not necessarily the remembered fix.

**Dependencies.** AI admin boot/routes build; WPDS color variables; generated admin page critical styles; related Gutenberg Connectors-screen work.

**Discussion highlights.** Trushiv04 reproduced locally and narrowed the likely cause to the `#wpwrap` critical-style fallback. jeffpaul believes a related Gutenberg fix exists for Connectors and recommends finding/mimicking it for the AI settings page.

### #791 — Add loading animation/custom cursor for Type Ahead
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-09 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/791

**Problem / goal.** With the Type Ahead experiment now merged (PR #151), the question is whether the native blinking cursor is enough feedback while AI ghost-text is being fetched. The proposal — raised from the #151 review thread — is to explore a loading animation or custom cursor that signals Type Ahead is "waiting/working," rather than leaving the standard cursor.

**Proposed approach.** None committed yet: deliberately gather community feedback on the live Type Ahead experience first, then trial explorations via PRs (loading animation vs. custom cursor) only if usage shows the cue is needed.

**Open decisions / blockers.** Whether any visual cue is warranted at all (vs. keeping the native cursor); which form (animation vs. cursor) reads best without being distracting.

**Dependencies.** Type Ahead experiment (merged PR #151); related follow-up #776 (provider/model overrides + Guidelines).

**Discussion highlights.** Opened by jeffpaul off the #151 review discussion as a "let's watch and see" enhancement; no comments yet.

### #923 — Introduce agent users to give AI agents an auditable identity
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** gziolo · **Updated:** 2026-08-11 · **Comments:** 5
**Link:** https://github.com/WordPress/ai/issues/923

**Problem / goal.** AI agents currently interact with WordPress only by borrowing a human identity — an application password over MCP, Abilities REST, or WP-CLI `--user` — so every `permission_callback` answers what a *user* may do, never what an *agent* may do, and nothing distinguishes agents from humans in `post_author`, activity logs, or `wp_ability_invoked`. A site owner cannot answer what an agent changed yesterday, or revoke an agent's access without touching a human account. Filed 2026-08-10 off the August core-AI chat's trust-ladder discussion and the February MCP workaround doc.

**Proposed approach.** Extend the user concept rather than invent a parallel identity system: a deliberately provisioned, marked account with **no interactive login** (application passwords or similar), excluded by default from user listings and author dropdowns, whose existing role is the capability ceiling. The current model stays valid; external/autonomous agents get accounts that can be granted, audited, and revoked independently of any human. Builds on shipped primitives: `permission_callback` enforcement, `wp_get_abilities()` filtering, and `wp_ability_invoked` as the audit hook. Explicitly out of scope: credential expiry/OAuth, trust tiers, and approval workflows.

**Open decisions / blockers.** JasonTheAdams' refinement list: authentication (are application passwords sufficient?), keeping user queries backwards-compatible, structuring agent-on-behalf-of-user acting, taking the **min of agent and user capabilities**, flag-vs-polymorphic user type, and whether distinct Agent roles are needed. chubes4 counterproposes a generic `actor` primitive (identity separate from the user account, multiple humans authorized per identity).

**Dependencies.** #354 (unified exposure controls) and #736 (per-feature role/user controls) as the governance siblings; upstream `WordPress/mcp-adapter#176`/`#228` approval/audit workflows; Application Passwords scoping.

**Discussion highlights.** jeffpaul ties it to the RTC direction in #324 (an agent user making content updates inside a conversation). webmyc contributes the strongest evidence: 1,276 production sites, where **50.2% of 241,614 tool calls over 90 days carry no usable agent identifier** — and a shipped lesson that agents must resolve to a real user (capabilities collapse and `wp_kses_post` strips content under `wp_set_current_user(0)`), plus that min-of-caps enforcement drifts when the exposed list and the enforced list live in two places.

### #940 — Introduce new custom endpoint for settings save and bypass core `/wp/v2/settings` endpoint for saving AI options
**Status:** In discussion / Needs decision · **Milestone:** — · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-08-14 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/940

**Problem / goal.** Core revalidates stored AI credentials whenever anything POSTs/PUTs to `/wp/v2/settings`; if the provider validation transiently fails (timeout, rate limit), the stored API key is **overwritten with an empty string even though it was never submitted**. Extracted from PR #881's review thread, with upstream `core.trac#65867` and `wordpress-develop#13031` already filed.

**Proposed approach.** Undecided — the issue exists to settle whether the AI plugin should introduce its own settings endpoint and bypass `/wp/v2/settings` for AI options, or wait for the core fix (which cannot land before the next WordPress release).

**Open decisions / blockers.** Custom endpoint vs. in-place mitigation. dkotter reports the bug hits him regularly (the OpenAI models endpoint times out at Core's default 5s), wiping his key on unrelated settings saves — he favors addressing it plugin-side now, and notes a **timeout increase** may be a quicker fix than a new endpoint. This window's latest board-item activity.

**Dependencies.** `/wp/v2/settings` validation path; core.trac#65867 / `wordpress-develop#13031`; Connectors credential storage.

**Discussion highlights.** Filed by hbhalodia (cc jeffpaul/dkotter); dkotter's reply doubles as the reproduction report.

---

## In progress (13)

*Actively being implemented or investigated.*

### #203 — Add extensibility hook for custom Ability Table columns
**Status:** In progress · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Help Wanted, [Experiment] Abilities Explorer · **Assignee(s):** — · **Updated:** 2026-07-15 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/203

**Problem / goal.** Third-party plugins can't add custom columns to the Abilities Explorer table without forking core files. Concretely, WordCamp Kolhapur 2026 wants to show which abilities support MCP directly in the table.

**Proposed approach.** Add an `ai_abilities_explorer_table_class` filter so a custom `$table_class` (extending `Ability_Table`) can be swapped in; and expose `meta` at the top level of `Ability_Handler::format_single_ability()` (not just inside `raw_data`) so columns like an MCP-support indicator can read `meta['mcp']['public']`. Optional per-column action hooks. Full example subclass provided.

**Open decisions / blockers.**
- Whether to solve via a PHP filter now or wait for the planned TypeScript + DataViews/DataForms rewrite of the Explorer, where extensibility could come from DataViews itself.

**Dependencies.** `Ability_Table.php`, `Ability_Handler.php`, the admin page; future DataViews/DataForms migration.

**Discussion highlights.** jeffpaul said the next Abilities Explorer iteration focuses on TypeScript + DataViews/DataForms and suggested folding this extensibility into that work — effectively deferring the standalone filter.

### #238 — Add focus-aware crop suggestions
**Status:** In progress · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design, [Experiment] Image Generation · **Assignee(s):** TylerB24890 · **Updated:** 2026-05-19 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/238

**Problem / goal.** Users who adjust image crops spend time manually finding the best crop/focal point, especially for featured/responsive images. The Gutenberg focal point selector (gutenberg#75221) creates a natural surface for AI-assisted suggestions.

**Proposed approach.** Add "Suggest focal point" and "Suggest crops" actions tied to the focal point selector in the Gutenberg Media Editor and Media Library Edit screen. Detect primary subject(s), then recommend a focal point + 2–3 crop presets (square/portrait/landscape). Save focal-point metadata; optionally store suggested crops as metadata.

**Open decisions / blockers.**
- No UI yet: blocked on the Focal Point Picker not yet integrated into the Media Editor; currently testable only via the Abilities Explorer.
- Needs Design outstanding.

**Dependencies.** Gutenberg focal point selector (gutenberg#75221); Gutenberg Media Editor; vision-capable model. Related: #325.

**Discussion highlights.** TylerB24890 built the experiment in PR #494 (vision-based suggestions, no UI yet, exercisable through the Abilities Explorer).

### #325 — Integrate media features and experiments with Gutenberg's experimental Media Editor
**Status:** In progress · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** TylerB24890 · **Updated:** 2026-05-19 · **Comments:** 9
**Link:** https://github.com/WordPress/ai/issues/325

**Problem / goal.** Media AI features currently target the post editor and Media Library. The plugin should also inject its media AI experiments into Gutenberg's experimental Media Editor (gutenberg#72734) when active.

**Proposed approach.** If the Media Editor experiment is active, interject media AI features (initial focus: Alt Text). Because the Media Editor exposes no filters/Slots-Fills, integration goes through DataViews via `registerEntityField()`. A race exists (`registerEntityField()` runs async; last-registered wins; a 1ms timeout workaround is fragile and loses ordering). Final PoC (PR #446) subscribes to the `postType` state change to `attachment`. Two paths: ship the workaround interim, or request Gutenberg add field filters/extension points (preferred long-term).

**Open decisions / blockers.**
- No stable extension API in the Media Editor; Gutenberg says it's too early to add filters/slots until cropping direction settles.
- Everything kept as an Experiment (not a Feature).
- New global targets: `window.__experimentalMediaEditor` and `window.__experimentalMediaEditorModal`.

**Dependencies.** Gutenberg Media Editor (#72734), task tracking (#73771), Modal experiment, clarification PR #77994; DataViews/`registerEntityField`; AI PRs #446 (alt text), #494 (crop).

**Discussion highlights.** andrewserong: too early for stable extension points; don't treat experiments as stable API. ramonjd: extensions should target the image surface/source state, not crop UI; crop stays a native core tool; documented a programmatic crop pipeline for AI-agent integration. jeffpaul confirmed AI-side integrations stay Experiments to drive testing.

### #338 — New Experiments: Analytics-aware content and amplification recommendations
**Status:** In progress *(was In discussion / Needs decision)* · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design, Help Wanted · **Assignee(s):** zeus2611 · **Updated:** 2026-07-09 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/338

**Problem / goal.** Extend the plugin upstream (what to write before opening the editor) and downstream (acting on post-publish signals) by integrating analytics plugins to surface two editorial recommendations driven by real search-traffic data.

**Proposed approach.** A `Stats_Provider` adapter connects installed analytics plugins (Jetpack Stats, MonsterInsights, Matomo, Site Kit, Burst/Koko). **Experiment 1 — Content Gap Suggestions:** read on-site search queries, filter zero/low-engagement results, send anonymized query patterns to AI for post title + outline recommendations, surfaced in a "Content Opportunities" dashboard widget. **Experiment 2 — Traffic Surge Amplification:** detect posts spiking (e.g., 2× rolling 7-day average in 24h), draft platform-appropriate social copy. All output requires human review; prefer sending derived patterns, not raw stats.

**Open decisions / blockers.**
- Split into two sub-issues (Gap carries the shared adapter/anonymization layer; Amplification builds on it).
- v1 provider scope: **Jetpack-first** agreed.
- Surface: dashboard widget agreed for Gap.
- WP Search Log fallback **dropped** for v1 (DB write per search) — require an analytics plugin instead.

**Dependencies.** Installed analytics plugins; AI Client; (potential) social-share plugins.

**Discussion highlights.** zeus2611 volunteered, proposed the two-sub-issue split + anonymization layer; jeffpaul answered the design questions (Jetpack-first, dashboard widget, skip search-log fallback).

**⚠️ Status-move caveat (2026-08-10).** Moved In discussion → In progress **with no implementing PR and no new comments** — the last activity on the issue is still 2026-07-09. The design questions above are answered, so the move is defensible as "assigned and agreed," but nothing distinguishes it from #625, which moved the same day on the same basis. **Update (2026-08-14):** draft PR **#929** ("Content Gap Suggestions: shared `Stats_Provider` layer + dashboard widget (1/2 for #338)", zeus2611) opened — the first code on this card.

### #421 — WordPress should detect C2PA manifests on upload
**Status:** In progress *(was To do)* · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-20 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/421

**Problem / goal.** WP extracts EXIF/IPTC/partial XMP at upload via `wp_read_image_metadata()` but doesn't detect **C2PA Content Credentials**. C2PA manifests now ship from AI generators (DALL-E 3, Firefly, Gemini, Copilot), cameras (Pixel, Galaxy S25, Leica, Sony, Nikon), and providers (Cloudflare Images), carrying machine-readable provenance. WP's GD/Imagick pipeline destroys manifests during subsize generation, so the only read window is at upload, before processing.

**Proposed approach.** A read-only experiment via `Abstract_Feature`, toggleable. At upload it hooks the attachment pipeline, reads the original via `wp_get_original_image_path()`, and captures a structured postmeta record (`_wpai_monitor_record`): curated EXIF/IPTC/XMP; C2PA presence (JPEG APP11, PNG `caBX`, WebP RIFF `C2PA`); and a C2PA claim summary (claim generator, digital source type, action history) decoded from the JUMBF manifest store. Introduces shared **JUMBF box-reading + CBOR-decoding** utilities (none exist today), reusable by other C2PA experiments (ref #294).

**Open decisions / blockers.**
- Constraints: read-only; fail-open (upload always succeeds); no external deps/HTTP; <500ms median on <15MB images.
- Out of scope: signing/verification, preserving manifests through processing, display UI.
- Display UI / `cr` overlay deferred (requires passing C2PA conformance first).
- Board PR **#459** ("Add C2PA Monitor experiment", lnispel) carries CHANGES_REQUESTED from dkotter: set `capability` to `none`, move the README under `docs/experiments`, reset `@since`, translate error strings, and reconsider sidecar security (an `.htaccess` guard only protects Apache).

**Dependencies.** WP attachment pipeline; new JUMBF + CBOR utilities; reference implementations in #294.

**Discussion highlights.** jeffpaul wants a fast-follow adding display UI with the `cr` overlay. lukenispel: reading/storing/displaying is straightforward, but the CR icon needs a conformant validator/generator first; offered to draft the display work, gated on conformance. **Relationship correction (2026-07-27):** PR #459 is now confirmed as this issue's **authoritative `closing` PR** via GitHub's `closingIssuesReferences`, not merely a conceptual sibling as earlier docs recorded — which is why the card moved To do → In progress. The signing PRs #294/#302 remain closed unmerged, so read-only detection is the whole live C2PA path. **Movement (2026-08-14):** **PR card #459 was removed from the board** while the PR stays open and still `closing`-linked here, and its checks went FAILURE — this issue is now the only board representation of the C2PA read path, and it is one of the two cards standing between 1.3.0 and its release.

### #625 — New Experiment: Social Content Generation for platform-specific social posts
**Status:** In progress *(was In discussion / Needs decision)* · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design · **Assignee(s):** Malayt04 · **Updated:** 2026-07-16 · **Comments:** 3
**Link:** https://github.com/WordPress/ai/issues/625

**Problem / goal.** Publishers manually rewrite content per social platform after publishing (tone, formatting, character limits, hashtags, imagery, alt text) — time-consuming and inconsistent at volume. No workflow yet transforms published content into social-ready promotional copy.

**Proposed approach.** A "Social Content Generation" Experiment analyzes a post's title, excerpt, content, and media to generate tailored copy for **Bluesky, Mastodon, and LinkedIn**, accounting for each platform's expectations, plus hashtags and recommended media. Exposed initially via a post-editor "Generate Social Posts" action (review/edit before use). Future: more networks, multiple variations, scheduling, syndication.

**Open decisions / blockers.**
- Which existing social plugins to target so output flows gracefully into their publishing.
- Additional platforms beyond the initial three.

**Dependencies.** AI provider abstractions; optional image-generation/vision; downstream social plugins (Jetpack Social, Blog2Social).

**Discussion highlights.** Contributor Malayt04 volunteered a concrete design: a collapsible "Social Content" sidebar + post-publish prompt; persist to post meta `_wpai_social_content`; checkbox-based per-network generation (only checked networks, individual regeneration) to save tokens; hooks so third-party social plugins can fetch/inject the copy.

**⚠️ Status-move caveat (2026-08-10).** Moved In discussion → In progress and **assigned to Malayt04**, the contributor who proposed the design — but with **no implementing PR** and no activity since 2026-07-16. Both of its listed open decisions (which social plugins to target, which platforms beyond the initial three) are still unanswered, so this is a claim of ownership rather than work underway. Same pattern as #338.

### #689 — Add a user-facing control for automatic log cleanup
**Status:** In progress · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** i-anubhav-anand · **Updated:** 2026-06-18 · **Comments:** 7
**Link:** https://github.com/WordPress/ai/issues/689

**Problem / goal.** There's no admin-UI way to configure automatic log cleanup for AI Request Logs; the only mechanism is a manually-added PHP filter. Today users can only keep everything forever or hit "Purge" and lose all logs at once.

**Proposed approach.** The original idea was an automatic retention-period setting (7 / 30 / 90 days, or forever). Discussion has shifted toward a **manual, user-initiated** cleanup control: replace "Purge All Logs" with a dropdown for Older than 30 / 90 / 365 days / All logs plus a Delete button and confirmation flow. No cron, no persistent retention policy.

**Open decisions / blockers.**
- Needs review of the manual cleanup UX/API in PR #735.
- Automatic retention remains disfavored for now: long-term logs are useful for month/year usage comparison, and the product direction avoids surfacing developer-style controls by default.

**Dependencies.** AI Request Logs feature; prior Request Logging PR (source of removed retention code).

**Discussion highlights.** Core tension: product simplicity / hide-developer-controls vs. discoverability. The compromise converged on a manual "delete older than" action; i-anubhav-anand picked it up and opened PR #735.

### #736 — Expose role/user access controls per feature/experiment
**Status:** In progress · **Milestone:** 1.4.0 *(was 1.3.0, then Future Release)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-31 · **Comments:** 9
**Link:** https://github.com/WordPress/ai/issues/736

**Problem / goal.** Site owners with many editors have no way to limit AI features to specific roles or users — there are no AI-related capabilities exposed in the role-editor screens. Originates from a wordpress.org support request ("limit-use-to-certain-roles"). Goal: let admins fine-tune which roles/users can access each feature/experiment.

**Proposed approach.** Mirror the existing per-experiment provider/model selection in the top-right ellipses menu: add a **role-and-user multi-select** there so admins can scope each feature/experiment to chosen roles or specific users, defaulting to the set of roles the plugin already supports (possibly hard-coded as the default).

**Open decisions / blockers.**
- How to show unsaved changes and confirmation: dkotter wants a Save button and snackbar notice similar to individual Feature settings.
- Role selector UI: multi-select works, but checkboxes may be clearer when admins do not know exact role names.
- Default role set remains TBD.

**Dependencies.** Per-experiment settings UI (the provider/model ellipses menu); WP roles/capabilities. Governance-cluster sibling to the unified management layer (#348) and per-surface exposure controls (#354) — at feature/experiment granularity.

**Discussion highlights.** Infinite-Null shared an initial implementation and demo with per-feature role/user controls in AI settings, open as **PR #749** (+893/−106, 18 files). dkotter said the direction looked correct and requested save-state UX, snackbar feedback, and possibly checkboxes for roles. PR #749 picked up CHANGES_REQUESTED and the card was re-milestoned 1.3.0 → Future Release (2026-07-31), then back into the **1.4.0** lane this window as v1.3.0 closed out — the requested UX work is what keeps it from shipping.

### #844 — New Experiment: Semantic search in wp admin
**Status:** In progress *(was Backlog)* · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** priyanshuhaldar007 · **Updated:** 2026-07-21 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/844

**Problem / goal.** The built-in wp-admin posts search matches exact words, so recalling "that post about pricing changes" when the post was titled "Updates to our plans" returns nothing — a small daily friction that compounds on sites with hundreds of posts. The in-progress native vector search (#683) solves this for **front-end visitors**, but site managers hit the same wall inside wp-admin.

**Proposed approach.** A new admin-side semantic-search experiment reusing the embeddings/index built for #683, applied to the posts list in wp-admin. Implementation is now in flight as **PR #891** ("Feat: Add semantic search experiment to AI plugin", priyanshuhaldar007) — +1,757 lines across 9 files, an authoritative `closing` reference.

**Open decisions / blockers.**
- The issue was filed as **blocked on #683** (native vector search) landing first, since #683 was to provide the embedding pipeline. **PR #891 opened anyway, ahead of #683**, which is still a draft with a DIRTY branch. Review should establish whether #891 carries its own embedding path or is expected to rebase onto #683's — otherwise the two experiments risk shipping duplicate indexing machinery.
- PR #891 is BLOCKED with failing checks.
- Off-board PR **#892** (PHP AI Client embeddings vendored behind an `SDK_Overlay`) is the third moving part in this area and has no board card at all.

**Dependencies.** #683 (native vector search experiment) and its embedding store; the wp-admin posts list table; increasingly, the embedding support brought over in #892.

**Discussion highlights.** Filed by jeffpaul as the admin-side counterpart to #683.

### #845 — New Experiment: Markdown feeds (powered by `html-to-md`)
**Status:** In progress · **Milestone:** 1.4.0 *(was 1.3.0)* · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** dkotter · **Updated:** 2026-07-14 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/845

**Problem / goal.** Markdown output makes content easier for AI tools, agents, search/indexing workflows, static exports, and plaintext-preferring readers to consume. A prior implementation (#194) explored the surface — Markdown feed output, singular Markdown views, autodiscovery links, `Accept: text/markdown` support, settings toggles, filters, and tests — but maintained its own converter.

**Proposed approach.** A new **Markdown Feeds** experiment exposing content as Markdown, using [`dmsnell/html-to-md`](https://github.com/dmsnell/html-to-md) as the conversion layer rather than a bespoke converter, revisiting the #194 direction. Implementation now in flight as off-board **PR #855** ("Markdown feeds experiment", @dkotter, *Closes #845*).

**Open decisions / blockers.** Which parts of the #194 surface (feeds vs. singular views vs. `Accept`-header negotiation) make the first cut; reliance on the external `html-to-md` library.

**Dependencies.** `dmsnell/html-to-md`; prior art in #194; WP feed / REST plumbing.

**Discussion highlights.** Filed by jeffpaul; Help Wanted. dkotter picked it up and opened PR #855, moving it Backlog → In progress.

### #875 — New Experiment: Suggest internal links within post content
**Status:** In progress · **Milestone:** 1.4.0 *(1.4.0 → Future Release → 1.3.0 → 1.4.0 in three windows)* · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** Infinite-Null · **Updated:** 2026-07-31 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/875

**Problem / goal.** Authors miss useful internal links because they cannot manually recall all related site content, weakening navigation, engagement, and SEO.

**Proposed approach.** Suggest up to five review-only in-content links, using the post's own anchor text and existing posts/pages. Support a pre-publish flow plus an on-demand Notes-style flow; never auto-insert links. Implementation is now in flight as **PR #887** ("Experiment: Add Internal link suggestions", Infinite-Null) — +2,050 lines across 15 files, an authoritative `closing` reference.

**Open decisions / blockers.** The product questions that kept this In discussion are **still not closed**: whether to reuse Editorial Notes/Updates plumbing or build a separate experiment; whether a site index is required; how to handle paragraph-level Notes on WP 6.9–7.0 vs inline Notes on 7.1+; and whether to show rationale for each suggestion. PR #887 still carries **CHANGES_REQUESTED** and has gone **DIRTY** this window.

**Dependencies.** Content discovery/indexing, Editorial Notes/Updates patterns, inline Notes availability, AI Client.

**Discussion highlights.** Filed board-new on 2026-07-17 with no comments; two comments and the implementation PR arrived the following window. **Milestone churn is the defining feature of this card:** 1.4.0 → Future Release (2026-07-31) → 1.3.0 → **1.4.0** (this window), three reversals, while PR #887 never cleared review and in fact regressed to DIRTY. The scheduling has moved four times; the work has not moved at all.

### #924 — Release version 1.3.0
**Status:** In progress · **Milestone:** 1.3.0 · **Labels:** — · **Assignee(s):** dkotter, jeffpaul · **Updated:** 2026-08-13 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/924

**Problem / goal.** The release tracker for v1.3.0, following the standard pre/post-release checklist. **Target release date: 2026-08-17.**

**Proposed approach.** The board's own release runbook: a pre-release review/punt pass over every 1.3.0 PR, then branch/version/`@since`/changelog/credits/readme work, a no-FF merge into `develop` and `trunk`, build + E2E checks, the GitHub release, and post-release milestone close/punt/announcement.

**Open decisions / blockers.** One pre-release item remains unchecked: **"Review and merge/punt #459"** (C2PA Monitor). Everything else is checked — the punts already dispatched #888, #887, #858, #764, #777, #789, #832, #683, #681, #759, #916, #757, #917, #798 to 1.4.0/Future Release, and the merges (#928, #897, #892, #881, #692, #909, #905, #889, #867, #915, #914, #930, #932) are in. None of the actual release steps has started.

**Dependencies.** `docs/RELEASE_INSTRUCTIONS.md`; the release PR; CI/E2E; milestone 22.

**Discussion highlights.** — (one comment; the issue body is the checklist. This is the reason two cards remain in 1.3.0.)

### #933 — Connector validity check assumes text generation, so speech-only and image-only connectors report as invalid
**Status:** In progress · **Milestone:** 1.4.0 · **Labels:** Help Wanted · **Assignee(s):** whyisjake · **Updated:** 2026-08-13 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/933

**Problem / goal.** `has_valid_ai_credentials()` decides connector validity by asking a single question — *can it generate text?* — so a site whose only connector is speech- or image-only is told its connectors "may be invalid," when they are correctly configured and working. The UI already distinguishes "no connectors" from "configured but not valid," and a non-text connector lands in the wrong branch: the verdict and the wording mismatch.

**Proposed approach.** Three directions offered, not prescriptive: (1) keep the text gate but reword the notice to name the missing capability; (2) split *valid* (authenticates and registers any capability) from *sufficient for a feature* (decided per feature, the way image generation already is via PRs #679/#748); (3) report per-capability status on the settings screen. **Implementation in flight:** PR **#935** "Fix: make connector validity capability-aware instead of text-only" (whyisjake, authoritative `Closes #933`).

**Open decisions / blockers.** Which of the three directions ships; the reporter volunteered a PR if maintainers pick.

**Dependencies.** `includes/helpers.php` `has_valid_ai_credentials()`; the AI Client SDK capability model (TTS, speech, image, video, embeddings); prior art PRs #679/#748.

**Discussion highlights.** Filed with a complete reproduction against WP 7.0.4 + AI 1.2.0 + an ElevenLabs non-text connector, and a precise pointer to the `is_supported_for_text_generation()` gate. The report also names the widening exposure: non-text connector plugins are just starting to appear.

---

## Backlog (6)

*Accepted direction, not yet scheduled for active delivery.*

### #142 — Frontend chat agent powered by site content
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design · **Assignee(s):** — · **Updated:** 2026-07-14 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/142

**Problem / goal.** Optional experiment exposing a public-facing "chat with my site" UI that answers visitor questions using the site's own published content (plus owner-supplied references) via RAG on the existing WP AI Client stack. Targets site visitors; doubles as a reference pattern for Abilities API + WP AI Client serving public UX.

**Proposed approach.** Floating chat bubble (likely a block for Site Editor placement). Owners choose indexed content. Pipeline: chunk posts/pages, embed passages, store in DB; incremental reindex on post changes. A reusable retrieval Ability returns top-k chunks with metadata (title, excerpt, permalink). Chat endpoint assembles question + retrieved passages, routes each turn through WP AI Client; responses cite/link back to source content.

**Open decisions / blockers.**
- Embeddings as JSON vs dedicated vector column?
- Streaming required for v1 or single-shot acceptable?
- Expose a "developer mode" to override the default prompt?
- v1: index only public content (avoid permission complexity); ship one UI pattern (bubble); analytics minimal/deferred.

**Dependencies.** WP AI Client; Abilities API; local embeddings table. Out of scope v1: admin-only assistants, multi-channel messaging, advanced bot workflows.

**Discussion highlights.** —

### #186 — Add tone adjustment controls for AI-generated content
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-03-10 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/186

**Problem / goal.** Add tone/style controls (casual, formal, technical) to AI-generated/rewritten editor content, letting users guide voice without manual prompt editing. Built on existing Abilities + prompt infra.

**Proposed approach.** Define supported tone options + UI selection; ensure tone consistently influences output; work across relevant editor experiments; stay extensible. Contributor proposal: a `tones.js` config, a `ToneSelector` component in a `PluginDocumentSettingPanel` sidebar, an "Apply to" scope selector (selection / paragraph / whole post), and inline accept-or-discard review.

**Open decisions / blockers.**
- Is tone a **modifier** for existing experiments (Title, Excerpt, Alt Text, Summary) or a **standalone** body-content rewrite (which needs new rewrite functionality)?
- Which subset of text-generation experiments to target.
- Whether tone modes make sense cross-language.

**Dependencies.** Existing Abilities + prompt infra; relates to Content Generation #297 (Change Tone) and Personas #188.

**Discussion highlights.** itsgajendraSingh volunteered + shared wireframes. jeffpaul requested wireframes/userflows before implementation and pinged karmatosed on whether tone should target each text option or a subset.

### #188 — Add persona-driven content generation experiments
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-01-17 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/188

**Problem / goal.** Introduce personas/voices (roles, audiences, brand voices) that influence AI-generated content and are reusable across experiments — giving content teams a consistent voice without re-specifying it each time.

**Proposed approach.** Define and select personas, consistently applied to influence output style/tone, reusable across experiments, extensible by plugins/themes.

**Open decisions / blockers.** —

**Dependencies.** Reusable content-control layer; conceptually adjacent to Tone Adjustment #186.

**Discussion highlights.** —

### #189 — Explore an admin Site Agent for executing WordPress actions
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-01-17 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/189

**Problem / goal.** Explore a conversational Site Agent letting administrators perform WordPress actions through natural-language prompts — creating posts, installing plugins, updating settings, exporting content. Targets admins who want to operate by intent rather than navigating UI.

**Proposed approach.** Map natural-language prompts to explicit, verifiable WordPress actions, designed with strong security, permissions, and auditability from the start; may gate behind filters/flags. Acceptance: prompts map to explicit verifiable actions; all actions respect roles/capabilities; execution is transparent and auditable; opt-in and disabled by default.

**Open decisions / blockers.**
- Whether to gate behind filters/flags.
- No design or technical mechanism specified yet (high-level exploration).

**Dependencies.** WP capabilities/roles; an action-execution + audit layer. Related to the AI Workspace (#282) middleware/tools model and prompt extensibility (#192).

**Discussion highlights.** —

### #282 — Chat experiment: Integration outside the editor and outside single-task AI use
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design · **Assignee(s):** karmatosed · **Updated:** 2026-03-11 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/282

**Problem / goal.** A global, conversational "AI Workspace" screen in wp-admin (styled after the Site Editor) for multi-step, context-aware interactions beyond single-field helpers — content planning, gap analysis, multi-post generation, site querying, code snippets. Bridges discrete editorial tasks and broader site management.

**Proposed approach.** Full-screen React app under "AI Experiments"; a Block Editor toolbar "Open in Workspace" hands off current post context. Central chat feed; context-scope selector — "Site Context" (RAG) vs "General Knowledge" (base model). Actionable artifacts ("Create Draft Post", "Copy Code"); data results render via **DataViews** for click-through editing. **Security middleware**: model never touches the DB directly; a PHP layer enforces `current_user_can()` per tool — denials returned to the AI. **RAG-lite** two-step retrieval with hard limits: Search Tool returns ≤20 titles/excerpts; AI reads full bodies of ≤5 posts; large audits rejected gracefully. Needs a strong-reasoning, function-calling model. Co-pilot tone: asks clarifying questions; **never executes destructive actions** — lists items for manual deletion.

**Open decisions / blockers.**
- Show a modal confirmation summary before bulk `wp_insert_post` calls? (Recommendation: Yes.)
- Context token limits / graceful failure for huge libraries.
- Mobile degradation (likely non-MVP).

**Dependencies.** WP AI Client; DataViews/DataForms; function-calling model; PHP middleware/capabilities. Overlaps Site Agent (#189) and insights (#190).

**Discussion highlights.** jeffpaul tentatively assigned karmatosed for mockups. Product definition by linawiezkowiak, lwoodmansee, rachaelcortellessa; technical review by dkotter.

### #297 — New experiment: Content Generation
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design · **Assignee(s):** karmatosed · **Updated:** 2026-03-11 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/297

**Problem / goal.** Cure "blank page syndrome" by letting users generate full post content or expand ideas natively in the Block Editor as a **co-authoring** experience — reducing time-to-publish.

**Proposed approach.** Three entry points: an empty-state "Generate Draft" button, a top-toolbar "Sparkle" AI Assistant icon (popover/command bar), and a `/ai` slash command. The Command Bar has a multi-line input, a Context Pill (Post Title / Selected Block), Generate/Cancel, and preset chips (Write Intro, Outline, Conclusion). A "Rewriter" adds an "AI Edit" button to the inline selection toolbar with Quick Actions (Shorten, Expand, Fix Grammar, Change Tone) + custom prompts. Context (title + existing content up to token limit) goes via the AI Client. Output is Markdown/HTML parsed into native Block Objects; streaming uses a "ghost typing" effect with Stop. Review: floating Keep/Try Again/Discard; rewrites show a purple "diff" state with Accept/Reject.

**Open decisions / blockers.**
- Toolbar icon choice (Sparkle tentative).
- Whether native WP markup is feasible vs. a Markdown/HTML intermediary.
- Just-in-time auth: trigger Connectors if available, else error to Settings → Connectors.

**Dependencies.** AI Client (text-gen); Gutenberg block parsing/toolbar; Connectors; relates to Content Resizing + Tone Adjustment (#186).

**Discussion highlights.** Product definition by linawiezkowiak, lwoodmansee, rachaelcortellessa; technical review by dkotter. jeffpaul tentatively assigned karmatosed for mockups.

---

## To do (4)

*Queued work with a defined next action.*

### #32 — Add AI Playground interface (prompt testing & debug tools)
**Status:** To do · **Milestone:** Future Release · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-05-04 · **Comments:** 3
**Link:** https://github.com/WordPress/ai/issues/32

**Problem / goal.** An optional "AI Playground" admin screen for advanced users to test prompts, inspect responses, and tweak model settings (temperature, max tokens), with debug info (raw response, token count, latency). Disabled by default.

**Proposed approach.** A module under `/features/ai-playground/` with prompt input/response UI, model config controls, response/debug inspection, block-editor-matching responsive UI, and developer hooks. Persisted advanced settings; debug info only when enabled.

**Open decisions / blockers.**
- Reuse Felix Arntz's existing AI Services Playground (several thousand LOC to port + review) vs. build from scratch.
- Requires new plumbing: a general-purpose REST endpoint for prompting + a REST endpoint to list models.
- Which subset of AI Services Playground features to port.

**Dependencies.** WP AI Client (general prompt + list-models REST endpoints, which felixarntz offered to implement); felixarntz's ai-services plugin as reference.

**Discussion highlights.** felixarntz noted the high complexity and offered to contribute his implementation; recommended stakeholders install AI Services (Tools → AI Playground) and report which features to port. JasonTheAdams confirmed that's the goal; felixarntz said building from scratch has no real upside.

### #190 — Add site-wide AI-powered content insights
**Status:** To do · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** yogeshbhutkar · **Updated:** 2026-06-30 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/190

**Problem / goal.** Explore AI insights analyzing content across the whole site — themes, gaps, trends, opportunities. Distinct from editor-level assistance; for site owners/editors planning strategy. Experimental; avoids automated changes.

**Proposed approach.** Early concept: introduce insight verticals based on post metadata, trading some precision for lower context size. First iteration may stay synchronous, persist the latest run, and start with a smaller subset of insight verticals before expanding.

**Open decisions / blockers.**
- Which insight verticals make the v1 cut (current mockup may include too many).
- How much metadata/context is enough to produce useful insights without excessive cost.
- Admin presentation details and performance/cost approach still need documentation.

**Dependencies.** WP AI Client; multi-post/content-type querying. Overlaps the "Strategic Content Planning"/"Site Querying" use cases of #282; could share its RAG-lite retrieval.

**Discussion highlights.** yogeshbhutkar shared a high-fidelity mockup and proposed metadata-driven insight verticals. dkotter liked the concept and design direction, while noting usefulness needs validation and v1 should probably trim the number of insight types.

### #339 — AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin
**Status:** To do · **Milestone:** Future Release · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-05-07 · **Comments:** 6
**Link:** https://github.com/WordPress/ai/issues/339

**Problem / goal.** Despite a green-checked API key, the plugin shows a red error. Generating an image surfaces a `text_generation` error (`No models found that support text_generation`) even though the action is image generation — reporter questions whether the message is even correct. (WP7 RC1, AI 0.6, Gutenberg 22.7.1, PHP 8.3.23.)

**Proposed approach.** None specified yet (triage).

**Open decisions / blockers.**
- Root cause likely in the AI **Provider** plugin (e.g. AI Provider for Google), not this plugin — dkotter notes the `No models found...` check comes from the AI Client; the provider may need updating for the latest Gemini models.
- Reproduction inconsistent (sethrubenstein hit it locally with Google 1.0.3 + Anthropic 1.0.2, but not on a remote server; deactivating Gutenberg had no effect).
- Needs re-test on current versions (AI 0.9.0+, WP 7.0 RC2/RC3, Gutenberg 23.1.0).

**Dependencies.** AI Client (owns the model check); AI Provider plugins (Google ≥1.0.3, Anthropic ≥1.0.2); Gutenberg; WP 7.0; possibly Gemini model support.

**Discussion highlights.** Mismatched-error symptom (image action → text_generation error); possibly environment-specific. dkotter cc'd felixarntz; awaiting confirmation it still reproduces.

### #600 — Remove `Enable AI` header toggle, allow feature/experiment toggles (and group toggles) to control plugin functionality
**Status:** To do *(was In discussion / Needs decision)* · **Milestone:** 1.4.0 *(was Future Release)* · **Labels:** [Type] Bug, Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-15 · **Comments:** 5
**Link:** https://github.com/WordPress/ai/issues/600

**Problem / goal.** The header `Enable AI` toggle is binary and misrepresents partial configuration: when only some sub-features are enabled it still renders fully ON, indistinguishable from all-enabled. **Retitled this window** from a bug report ("header toggle doesn't reflect aggregate state") into a product decision: **remove** the global toggle and let feature/experiment toggles (and group toggles) control plugin functionality.

**Proposed approach.** **A** — tri-state header toggle (Off / Partial / On); **B (now the stated direction)** — drop the global header toggle and give each section its own master tri-state toggle, pairing with Enable all / Disable all.

**Open decisions / blockers.**
- gziolo: toggle is confusing ("why install AI to disable AI?") — reflect "AI enabled" state or rename to "Disable AI".
- dkotter: distinguish disabling AI features while non-AI features (Abilities Explorer, Request Logging, Connector Approval) stay on.

**Dependencies.** **PR [#798](https://github.com/WordPress/ai/pull/798)** ("Clarify global AI toggle as a master switch") was its closing PR and is now **closed unmerged**; the retitle supersedes the toggle-as-master-switch approach. The card moved In discussion → To do with a Help Wanted label.

**Discussion highlights.** dkotter explains the toggle is a quick exit path (disliked results, rate/usage thresholds) but concedes manual disable or plugin deactivation is comparable effort. The retitle turns the design question into a scoped, help-wanted task.

---

## Triage (3)

*New or foundational items awaiting scope/priority decisions.*

### #40 — WordPress Core Abilities
**Status:** Triage · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** gziolo, jorgefilipecosta · **Updated:** 2026-07-17 · **Comments:** 39
**Link:** https://github.com/WordPress/ai/issues/40

**Problem / goal.** Define the foundational set of abilities bundled with the Abilities API as it lands in Core. The proposed catalog (under the `core` namespace) spans site/settings, users, posts/pages, media, comments, taxonomy, menus, themes, and plugins — safe, broadly useful, and **non-destructive by default**. Deleting content, installing/uninstalling plugins/themes, and theme switching are explicitly out of scope for the initial set.

**Proposed approach.** Curated `namespace/ability-name` abilities mirroring REST/WP-CLI conventions. Strong consensus for **unified CRUD operating on any public post type via a `post_type` input param** (rather than per-type abilities) to stay under provider tool limits. **Core-first** development: abilities proposed against `wordpress-develop` (Get Posts #10665, Get Settings #10747, Get User #10775), with nested-namespace support added so names like `core/post/get` are allowed.

**Open decisions / blockers.**
- Generic CRUD vs. post-type-specific granularity (LLMs confuse "post" the type with "post" the umbrella term).
- Curated per-domain settings abilities vs. a generic `core/get-settings`/`update-settings` pair; resolved toward broad-first with a no-duplication rule.
- Guardrails for destructive/plugin-management actions (elicitation, allowlists, trash/undo) — deferred; hints tracked in abilities-api#62.
- `show_in_abilities` flag design and whether process should require an Experiments-plugin release before Core commit.

**Dependencies.** WordPress Core (wordpress-develop PRs #10665/#10747/#10775/#10848/#10954/#10976); Gutenberg #74234, #70710 (workflows), DataViews/DataForms schemas; MCP Adapter layered tooling (mcp-adapter#48); abilities-api #38/#62/#84/#105/#106; #21.

**Discussion highlights.** swissspidy mapped the CP-vs-MCP tension (granular "Create a new page" for humans, one `create_post` tool for machines) and flagged i18n issues with string concatenation. JasonTheAdams shared TEC/GiveWP MCP findings — single CRUD tools fared poorly, settling on read/create-update/delete. johnbillion sharply questioned shipping `show_in_abilities` into 7.0 beta without API-design review. justlevine and jorgefilipecosta debated core-first vs. Experiments-first process. gziolo initially favored curated settings abilities, then reversed to broad-first after consulting Automattic AI experts, preserving `core/get-site-info` for back-compat.

### #918 — Feature: AI-generated `llms.txt` — a curated, LLM-friendly site index served at `/llms.txt`
**Status:** Triage · **Milestone:** Future Release *(was unmilestoned)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-08-07 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/918

**Problem / goal.** LLMs and agents reading a site directly have no concise map of what it is about or which pages matter: raw HTML is noisy and token-expensive, and `sitemap.xml` lists every URL with no priority, summary, or context. [`llms.txt`](https://llmstxt.org/) is an emerging convention — a single Markdown file at `/llms.txt` — that does for models what `robots.txt` and `sitemap.xml` did for crawlers. Producing one on WordPress today means hand-maintaining a file that goes stale on the next edit, or adopting an SEO plugin.

**Proposed approach.** Three phases. **Phase 1 (MVP):** an enable/disable setting on the existing experiment-settings framework, assembly from the site's own data (title/tagline → `# H1` + `>` summary, then `##` sections of `- [Title](url): description` entries for selected post types and taxonomies), and serving at `/llms.txt` — with the dynamic-endpoint-vs-static-file question explicitly left open. **Phase 2:** source selection, manual overrides (edit the intro, pin or exclude entries), and developer filters for the entry list, per-entry description, and rendered output. **Phase 3 — the stated differentiator:** use a configured AI connector to generate the per-entry descriptions and site summary, reusing `core/read-content` to gather content safely plus the existing summarization/classification experiments to prioritize it; optionally a `/llms-full.txt` companion and an `ai/generate-llms-txt` Ability so agents can regenerate it.

**Open decisions / blockers.** The issue is unusually candid about its own risks: dynamic endpoint vs static file (caching/CDN invalidation), regeneration strategy (publish hooks vs cron vs on-demand) and the connector cost it implies, hard caps and the `## Optional` overflow section for large sites, multisite/i18n/privacy handling, and tracking the llmstxt.org spec as it stabilizes. It also flags **prior art** — Yoast and other SEO plugins already ship basic `llms.txt` generation — and proposes detecting an existing file or SEO-plugin implementation and deferring rather than clobbering it.

⚠️ **The unstated question is scope.** Every other item on this board is an Experiment acting on a post, or infrastructure beneath one. This proposes a **site-wide public endpoint** — closer to core or SEO-plugin territory than to the Experiment model. The issue argues the opposite (it is an AI-consumption artifact, the plugin already owns `core/read-content` and the summarization abilities, and it works regardless of SEO stack), and that argument is a reasonable one — but it needs a maintainer decision before implementation, not after.

**Dependencies.** Experiment settings framework; `core/read-content` Ability; summarization/classification experiments; AI connectors; rewrite/`template_redirect` plumbing.

**Discussion highlights.** Filed 2026-08-07 by hbhalodia — the same contributor behind #863 and PR #881. One comment, from jeffpaul the same day: *"@justlevine what's the current state of recommendation on this sort of a file being served from sites?"* — i.e. the first maintainer response is a question about whether the **standard itself** is settled enough to build on, which is the right gate and is still unanswered.

### #890 — Add mobile right sidebar display component
**Status:** Triage · **Milestone:** Future Release *(was unmilestoned)* · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-23 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/890

**Problem / goal.** Filed by aabhishekchuobey-ops on 2026-07-23: mobile users lack a functional, responsive right-sidebar surface for the plugin's AI features, so there is no mobile-optimized way to reach the information and navigation the desktop sidebar provides.

**Proposed approach.** A mobile-responsive right-sidebar component that adapts layout by viewport (mobile-first), renders as a collapsible/expandable panel to preserve screen space, retains desktop functionality, and optimizes for touch interaction.

**Open decisions / blockers.** Everything. The issue arrived with no labels, no milestone, no assignee, and no comments, and it does not identify which specific AI surface it targets (AI Home, Connectors, the editor sidebar, the Abilities Explorer, or all of them). It also does not distinguish plugin-owned UI from Gutenberg-owned editor chrome, which determines whether this is even actionable in `WordPress/ai` rather than upstream. Needs triage before it can be scoped.

**Dependencies.** Undetermined — likely the plugin's admin UI shell and, depending on scope, Gutenberg's editor sidebar behavior on small viewports.

**Discussion highlights.** None; unchanged for a fourth window except gaining the Future Release milestone.

---

## Needs review (3)

*Issue work with an implementation ready for review.*

### #660 — UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals
**Status:** Needs review · **Milestone:** 1.4.0 *(was 1.3.0)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-13 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/660

**Problem / goal.** When an AI request (e.g., title generation) is blocked by Connector Approvals, the editor error ("Please ensure you have a connected provider that supports text generation") wrongly implies invalid keys / failed connection / unsupported model — when the provider is connected but awaiting administrator authorization.

**Proposed approach.** Make the error context-aware: state the connector is pending authorization and link to the approval page (`/wp-admin/tools.php?page=connector-approvals`). Suggested copy provided; before/after screenshots included.

**Open decisions / blockers.** —

**Dependencies.** Connector Approvals feature; WP 7.0/Gutenberg editor; reproduced with AI Provider for Google.

**Discussion highlights.** —

### #514 — Add comment value / relevance to Comment Moderation experiment
**Status:** Needs review *(was In progress)* · **Milestone:** 1.4.0 *(was 1.3.0)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-14 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/514

**Problem / goal.** The Comment Moderation experiment (PR #155) introduced sentiment/toxicity analysis with extensibility hooks. Review discussion surfaced interest in evaluating a comment's overall **value/relevance** — spammy/engagement-bait, off-topic, generic "thanks"/"+1"/low-context comments — to help prioritize moderation and surface high-quality discussion.

**Proposed approach.** Extend Comment Moderation with a "Comment Value / Relevance" analysis on the existing pipeline: store a normalized score; add a Comments-screen column + Activity dashboard pill; allow bulk processing; optionally flag low-value comments; provide filters/hooks for custom scoring and thresholds.

**Open decisions / blockers.** Existing hooks cover system instructions + response schema, but additional JS extensibility may be needed for the full admin experience. Implementing PR **#681** carries CHANGES_REQUESTED.

**Dependencies.** Comment Moderation experiment / PR #155 (analysis pipeline, system-instruction and response-schema hooks).

**Discussion highlights.** — *(moved In progress → Needs review as 1.3.0 closed out, re-milestoned into 1.4.0.)*

### #732 — AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible
**Status:** Needs review *(was In progress)* · **Milestone:** 1.4.0 *(was 1.3.0)* · **Labels:** Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-13 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/732

**Problem / goal.** The AI Request Logging experiment taps requests by decorating the SDK's HTTP transporter, so a request is logged **iff** it flows through `HttpTransporter::send()`. Any provider that performs its own HTTP is therefore never logged, despite being a first-class provider reachable via `wp_ai_client_prompt()` and listed in Connectors — the Request Log silently under-reports.

**Root cause.** `Logging_Integration::wrap_transporter()` swaps in a `Logging_Http_Transporter` decorator, and logging lives entirely inside that decorator's `send()`. Provider attribution compounds the gap: `Log_Data_Extractor::detect_provider()` infers the provider from the request **host**, so a provider talking to `127.0.0.1` couldn't be attributed even if its request were seen.

**Proposed approach.** Add a provider-agnostic fallback alongside the transporter decorator — also listen to the core generation events, which fire for every provider regardless of transport: `wp_ai_client_before_generate_result` / `wp_ai_client_after_generate_result` (bridged from the SDK's `BeforeGenerateResultEvent` / `AfterGenerateResultEvent`). A flag reset in the before-event and set by `Logging_Http_Transporter::send()` prevents double-logging.

**Open decisions / blockers.** **Known limitation:** the SDK's after-event fires on **success only**, so failed custom-transport generations stay a separate gap needing an SDK-level error event. Implementing PR **#757** ("capture generations that bypass the SDK HTTP transporter") is now review-ready.

**Dependencies.** AI Request Logging experiment (`Logging_Integration`, `Logging_Http_Transporter`, `Log_Data_Extractor`, `AI_Request_Log_Manager`); WP AI Client generation events. Prior art: #680; composes with (does not duplicate) #906, which shipped this window.

**Discussion highlights.** — (Filed by henryperkins with a code-level root cause, motivated by a third-party `codex` provider brokered through a localhost sidecar and absent from the log. Moved In progress → Needs review this window.)

---

## Recently board-Done (since the 2026-06-15 snapshot)

**50 issue dossiers retained for reference.** These are excluded from the 48-open-issue count. Note that many of these cards have since been **de-carded** from Project #240 in post-release cleanup passes (ten on 2026-07-27, seven by the 2026-08-01 refresh — #614, #778, #853, #864, #865, #870, #872 — six more on 2026-08-10: #191, #192, #452, #507, #874, #883, and **#187** on 2026-08-14); they are kept here because the work shipped, not because the card still exists.

> ⚠️ **"Board-Done" is a board status, not a delivery guarantee.** Most of this section corresponds to merged work, but four entries do not: **#900** was webinar spam, **#193** was closed because the work had *already* shipped years earlier under a different PR, **#869** was closed **`NOT_PLANNED`** as not reproducible, and **#307** was closed **`NOT_PLANNED`** because the `AGENTS.md` proposal was declined. Separately, PR card **#621** was closed *unmerged* on 2026-07-28 and still marked board-Done, as was dependabot PR **#922** on 2026-08-10 — see the [planned-work data-quality flags](./wordpress-ai-planned-work.md#-data-quality-flags-verify-before-acting).

### #233 — Refactor experiments to leverage AI_Service layer
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement, Help Wanted, [Experiment] ×6 · **Assignee(s):** — · **Updated:** 2026-08-11 · **Comments:** 1 · *(board-Done / closed 2026-08-11 as `COMPLETED` by merged PR #905)*
**Link:** https://github.com/WordPress/ai/issues/233

**How it closed.** The card whose premise reversed in July — filed as "adopt the `AI_Service` layer everywhere," answered as "remove it" after PR #898 closed unmerged — closed against merged **PR #905**, which **deprecates** the class and `get_ai_service()` rather than deleting them (dkotter: both are public surface). The two-window "board actively contradicted by its own implementation" case ends here: tracking fixed, wording no longer matters, the card is Done. The stale-title footnote that headed this dossier is retired with it.

### #307 — Add AGENTS.md to streamline contributor onboarding
**Status:** Done · **Milestone:** — *(cleared)* · **Labels:** — · **Assignee(s):** gziolo · **Updated:** 2026-08-10 · **Comments:** 6 · *(board-Done / closed 2026-08-10 as `NOT_PLANNED`)*
**Link:** https://github.com/WordPress/ai/issues/307

**How it closed.** Declined rather than shipped. The April debate (justlevine against committing a public `AGENTS.md` to WordPress.org properties, in favor of an `AGENTS.md.example`; gziolo's concrete onboarding evidence; jeffpaul's docs-first prerequisite) ended with the proposal closed `NOT_PLANNED` on 2026-08-10, its milestone cleared. Retained context: onboarding remains the pain it described — docs-first cleanup (#225/#308) is the surviving path.

### #690 — Plugin does not clean up database table and options on uninstall
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement · **Assignee(s):** hbhalodia · **Updated:** 2026-08-11 · **Comments:** 1 · *(board-Done / closed 2026-08-11 as `COMPLETED` by merged PR #692)*
**Link:** https://github.com/WordPress/ai/issues/690

**How it closed.** PR **#692** merged: `uninstall.php` drops `wp_wpai_request_logs` and removes all `wpai_*` options behind an opt-in "Remove all data on uninstall" checkbox — resolving the privacy/guidelines gap named in the dossier.

### #863 — New Experiment: Abilities toggle
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** hbhalodia · **Updated:** 2026-08-12 · **Comments:** 11 · *(board-Done / closed 2026-08-12 as `COMPLETED` by merged PR #881)*
**Link:** https://github.com/WordPress/ai/issues/863

**How it closed.** PR **#881** merged, giving standalone abilities deliberate enablement controls in the Abilities Explorer. The plugin-side half of ability governance shipped; the open design questions the dossier carried (group vs per-ability toggle, what stays visible while disabled) were answered in implementation, and the upstream half had already landed via `mcp-adapter#254`.

### #866 — Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Bug · **Assignee(s):** hbhalodia · **Updated:** 2026-08-12 · **Comments:** 2 · *(board-Done / closed 2026-08-12 as `COMPLETED` by merged PR #867)*
**Link:** https://github.com/WordPress/ai/issues/866

**How it closed.** PR **#867** merged with the migration: `ai_generated` / `ai_generated_summary` / `ai_note` renamed to `wpai_*` across PHP, editor JS, tests, and uninstall behavior — the orphaned-data risk the dossier flagged was resolved by shipping the migration in the same PR.

### #876 — New Experiment: Suggest permalink slugs
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** milindmore22 · **Updated:** 2026-08-11 · **Comments:** 2 · *(board-Done / closed 2026-08-11 as `COMPLETED` by merged PR #897)*
**Link:** https://github.com/WordPress/ai/issues/876

**How it closed.** PR **#897** merged, ending the 1.4.0 → Future Release → 1.3.0 milestone round trip with delivery. The dossier's caution — the PR's own "Prototype" framing — resolved in the good direction: the prototype became the shipped experiment. Its sibling #875 (internal links) stays open in 1.4.0, still carrying the same open product question.

### #906 — Request Logging: no public API to record the reserved `mcp_tool` and `ability` log types
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement · **Assignee(s):** azizulhasan · **Updated:** 2026-08-13 · **Comments:** 1 · *(board-Done / closed 2026-08-13 as `COMPLETED` by merged PR #914)*
**Link:** https://github.com/WordPress/ai/issues/906

**How it closed.** PR **#914** merged: namespaced `WordPress\AI\log_ai_request()`, `Logging_Integration::get_log_manager()`, `AI_Request_Log_Manager::get_types()` as the single source of truth, and a `wpai_ai_request_logged` action. The flagged behavior change shipped as described — `log()` now refuses unknown types via `_doing_it_wrong()`. This was the cleanest issue → card → PR → authoritative-link chain on the board, and it delivered.

### #193 — Add developer-only log panel for inspecting AI provider responses
**Status:** Done · **Milestone:** 1.0.0 *(was Future Release)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-08-05 · **Comments:** 3 · *(board-Done / closed 2026-08-05 as `COMPLETED` — already delivered by PR #437)*
**Link:** https://github.com/WordPress/ai/issues/193

**Problem / goal.** Developers debugging AI features had no way to inspect raw request/response payloads. Proposed a developer-only log panel for deep inspection, building on the AI Request Logs feature but oriented to low-level debugging rather than usage tracking. Acceptance: raw data viewable by authorized users; clearly marked developer-only; sensitive data handled responsibly; logging toggleable.

**How it closed.** Not by new work. The closing comment reads *"I concur, marking this closed by #437"* — the capability had been in the product since the 1.0.0 era, and the card was re-milestoned **Future Release → 1.0.0** on the way out so it files against the release that actually shipped it. It had been sitting in Backlog the entire time.

⚠️ **Read this as backlog cleanup, not delivery.** It is one of only two cards that moved into Done in the 2026-08-10 window, and neither represents work completed in that window. A velocity metric taken off board-Done transitions will count this as an item delivered on 2026-08-05.

### #869 — window.aiProviderData is only attached to the block-editor iframe snapshot, never to the top window, causing "requires an AI Connector" false positives
**Status:** Done · **Milestone:** — · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-08-05 · **Comments:** 5 · *(board-Done / closed 2026-08-05 as **`NOT_PLANNED`** — not reproducible)*
**Link:** https://github.com/WordPress/ai/issues/869

**Problem / goal.** In one WordPress 7.0.1 setup, `window.aiProviderData` appeared only inside the block-editor iframe snapshot and not the top window, producing false "requires an AI Connector" errors even with valid credentials. The reporter's diagnosis was specific: `Asset_Loader::add_global_data()` queues data in a static array and attaches it — via `wp_add_inline_script( ..., 'before' )` — only to the **first** plugin script that `Asset_Loader::enqueue_script()` processes in that request, then clears the queue. On a post-edit screen, that first script turned out to be the iframe-bound one.

**How it closed.** *"Closing as this is not reproducible, but @jannefleischer once you're back from vacation (enjoy!) please let us know if you're still seeing issues here."* A maintainer had observed the reverse behavior on `develop`, and the reporter was away and could not retest.

⚠️ **Not disproved, only unreproduced.** The `Asset_Loader` mechanism described above was never shown to be wrong; third-party-plugin interference remains the leading hypothesis for why it manifested in one environment. This document flagged for three consecutive windows that #869 needed a clean-environment reproduction — it was retired for exactly that reason rather than fixed. Treat it as dormant: a reproduction reopens it.

### #187 — Support multilingual rewriting and translation via AI
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement · **Assignee(s):** yogeshbhutkar · **Updated:** 2026-07-28 · **Comments:** 4 · *(board-Done / closed 2026-07-28 via merged PR #747)*
**Link:** https://github.com/WordPress/ai/issues/187

**Problem / goal.** Explore AI-powered translation and multilingual rewriting for post content — translating between languages or rewriting to a specific language variant.

**Approach as shipped.** Landed as an experiment coexisting with WordPress i18n practices, aligned with Gutenberg's Multilingual phase 4. The implementation direction moved during review from block-level translation to **full-article translation** with batch processing similar to Editorial Notes, with explicit user-controlled language selection, clear separation from core i18n tooling, and opt-in non-destructive behavior.

**Resolution.** **PR [#747](https://github.com/WordPress/ai/pull/747) ("Feat[Experiment]: Add AI-Powered Content Translation", yogeshbhutkar) merged 2026-07-28**, closing this issue via an authoritative `closing` reference. It is the v1.3.0 lane's first experiment to land since the six issues that closed in the previous window.

**Dependencies.** WordPress i18n practices/tooling; Gutenberg Multilingual phase 4.

**Discussion highlights.** yogeshbhutkar shared a working PoC. dkotter questioned the block-level use case and suggested starting with full-article translation or folding block translation into Content Resizing. yogeshbhutkar refactored toward full-article, batch-style processing, opened PR #747, and carried it through review to merge.

### #900 — [Spam, closed] "Why Red Hat OpenShift AI Is Becoming Essential for Enterprise AI"
**Status:** Done · **Milestone:** — · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-28 · **Comments:** 1 · *(opened, carded, closed, and marked Done on 2026-07-28)*
**Link:** https://github.com/WordPress/ai/issues/900

**Problem / goal.** None — promotional content for a third-party Red Hat OpenShift AI training webinar, with registration links and hashtags. No connection to the WordPress AI plugin.

**Resolution.** Closed the same day it was opened and moved to Done on the board. Recorded here only so that "two cards added this window" is not misread as two units of intake: **#906 is the sole substantive addition**. This is the second spam card in three windows (see #848), so a recurring pattern rather than a one-off.

### #145 — Rename experiment register() method to better reflect initialization
**Status:** Done · **Milestone:** — *(was 1.1.0)* · **Labels:** [Type] Enhancement · **Assignee(s):** juanmaguitar · **Updated:** 2026-06-30 · **Comments:** 4 · *(board-Done / closed 2026-06-30)*
**Link:** https://github.com/WordPress/ai/issues/145

**Problem / goal.** The experiment lifecycle conflated registration (adding to `Experiment_Registry`) with initialization/launch (running logic once enabled); naming the launch method `register()` blurred the two and made `Experiment_Loader` harder to read.

**Resolution / retained context.** Agreed direction was to rename the boot method `register()` → `init()` (keeping "register" for registry insertion only). The first implementation PR #159 closed without merge on 2026-06-17; the issue itself closed board-Done on 2026-06-30 (milestone dropped from 1.1.0).

### #197 — Disable features until valid AI credentials are entered
**Status:** Done · **Milestone:** — *(was on the 1.1.0/1.2.0 hardening lane; cleared on close)* · **Labels:** [Type] Enhancement, Good first issue, Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-01 · **Comments:** 5 · *(board-Done / closed 2026-07-01)*
**Link:** https://github.com/WordPress/ai/issues/197

**Problem / goal.** Users could enable Experiments without valid credentials — the title-generation button then appeared in the editor but Regenerate errored. Goal: gate AI-dependent features on credential validation while leaving non-AI Experiments (e.g. Abilities Explorer) always available.

**Resolution / retained context.** Moved **board-Done on 2026-07-01** with its milestone cleared. Its tracked off-board PR **#799** ("Gate provider-backed features until valid credentials exist") was **closed unmerged** the same day (both ~15:08–15:09 UTC, ~15 h *after* the 1.1.0 release cut at 00:07 UTC), so #197 resolved **without shipping in the 1.1.0 payload** — closed as done via other means / de-scoped rather than by a merged PR. Direction had settled on a per-Experiment "setup required" state (exposing `hasCredentials` / `hasValidCredentials` / `credentialsPageURL`) over a hard global gate.

### #390 — Generate Review Notes and Generate Summary options present even with no post content
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** [Type] Enhancement · **Assignee(s):** coderGtm · **Updated:** 2026-06-17 · **Comments:** 16 · *(board-Done 2026-06-17)*
**Link:** https://github.com/WordPress/ai/issues/390

**Problem / goal.** On a new/empty post, AI actions ("Generate Summary", "Generate Review Notes") appeared despite no content. Reclassified from bug to enhancement: integrations should fail gracefully and only become usable once meaningful content exists.

**Resolution / retained context.** The agreed direction was to keep the UI visible but disable AI actions until a content threshold is met, with helper text and a filterable threshold. The issue moved board-Done on 2026-06-17.

### #391 — Regenerate option is being shown even though there's no content yet
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 4 · *(board-Done 2026-06-17)*
**Link:** https://github.com/WordPress/ai/issues/391

**Problem / goal.** The "Regenerate" option for Title generation was visible on a brand-new post before content existed.

**Resolution / retained context.** Closely coupled to #390: gate the Regenerate control on sufficient post content rather than title focus alone. The issue moved board-Done on 2026-06-17.

### #508 — New Experiment: "Suggest Reply" for Comments and Activity widget
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** [Type] Enhancement · **Assignee(s):** dkotter · **Updated:** 2026-07-10 · **Comments:** 4 · *(board-Done / closed 2026-07-10 via PR #724; moved Backlog → In progress → Needs review → Done)*
**Link:** https://github.com/WordPress/ai/issues/508

**Problem / goal.** #155 removed the "Reply with AI" action from the Comments screen over UX/placement concerns, yet moderators/editors still benefit from assisted replies aligned with Guidelines and post context. A new Experiment adds a "Suggest reply" capability on the Comments screen (row action) and the Activity dashboard widget — a reviewable suggestion generated from the comment + associated post + Guidelines (human review/insert/edit; **not** auto-reply).

**Resolution / retained context.** Merged as **PR #724** (Infinite-Null) on 2026-07-10 and closed board-Done under **1.2.0** — the 1.2.0 lane's first genuinely new *experiment* (vs. hardening). The shipped flow opens the modal first for a pre-generation Tone selector + a Guidelines field, then Generate (per dkotter's review); supersedes the removed #155 action.

### #571 — Content Classification: Make character count locale-aware
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 0 · *(board-Done 2026-06-17)*
**Link:** https://github.com/WordPress/ai/issues/571

**Problem / goal.** Content Classification required >150 words to enable, but CJK languages do not use spaces between words, leaving "Suggest Categories" disabled for Japanese/Chinese content.

**Resolution / retained context.** Direction was to adopt locale-aware word/character counting, mirroring Gutenberg's `post-time-to-read` pattern. Closed alongside sibling #578.

### #578 — Content Resizing: "shorten" does not detect the character length of Japanese text
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 0 · *(board-Done 2026-06-17)*
**Link:** https://github.com/WordPress/ai/issues/578

**Problem / goal.** The "shorten" Content Resizing action required a paragraph >5 words, which misfired for Japanese/CJK content with no spaces.

**Resolution / retained context.** Same locale-aware word/character-count fix as #571. The issue moved board-Done on 2026-06-17.

### #632 — Be able to deactivate a connector and not lose settings
**Status:** Done · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-23 · **Comments:** 1 · *(board-Done / closed 2026-06-23)*
**Link:** https://github.com/WordPress/ai/issues/632

**Problem / goal.** A user wanted to test different AI providers but could not deactivate a connection without deleting its API key (no copy to re-enter); they needed to disable a connector while retaining its saved settings.

**Resolution / retained context.** Resolved as a per-connector activate/deactivate toggle that retains stored configuration; the issue moved board-Done and closed on 2026-06-23 (implementation tracked in PR #661). Earlier discussion debated whether the behavior belongs in the AI plugin vs. Core Connectors (jeffpaul floated moving it to Core Trac).

### #678 — Editorial Updates cannot match existing Notes after editor reload
**Status:** Done · **Milestone:** 1.0.2 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 0 · *(board-Done 2026-06-17)*
**Link:** https://github.com/WordPress/ai/issues/678

**Problem / goal.** Pending Editorial Notes still offered "Apply Editorial Updates" after editor reload, but the action failed with "No blocks found matching the existing Notes" because block-matching metadata did not survive reload.

**Resolution / retained context.** Closed on the board after the prior snapshot. Although its milestone is 1.0.2, it closed after the 1.0.2 release timestamp, so treat it as board-Done rather than newly released unless the release artifact is re-cut.

### #699 — AI Request Logs: "Copy Log ID" gives no feedback when copied
**Status:** Done · **Milestone:** 1.0.2 · **Labels:** [Type] Bug · **Assignee(s):** hbhalodia · **Updated:** 2026-06-15 · **Comments:** 3 · *(shipped in 1.0.2, 2026-06-16; closed via PR #700)*
**Link:** https://github.com/WordPress/ai/issues/699

**Problem / goal.** In the Request Logs detail modal (`LogDetailModal.tsx`), "Copy Log ID" copies the ID but gives no visual/accessible feedback — the label doesn't change and nothing is announced. By contrast `MetaDescriptionModal` swaps its label to "Copied!" and announces via assistive tech.

**Proposed approach.** Mirror the MetaDescription pattern: track transient `hasCopied`, swap label to "Copied!", announce via `@wordpress/a11y` `speak()`, reset after a timeout. Refactor into a shared hook `src/hooks/use-copy-to-clipboard-feedback.ts` consumed by both modals to remove duplicated boilerplate.

**Open decisions / blockers.**
- Snackbar vs. inline "Copied!" label: a `Snackbar` notice would be more Gutenberg-consistent but won't work on the Request Logs page (not an editor context, not subscribed to notices). Recommendation: proceed with the PR's **inline** approach.
- Snackbar a11y caveat noted (Gutenberg #16549, #77816).

**Dependencies.** `@wordpress/a11y`, `@wordpress/compose`, `@wordpress/element`; related PR #696. Files: LogDetailModal.tsx, MetaDescriptionModal.tsx, new shared hook.

**Discussion highlights.** Drafted/implemented with Claude Code; Snackbar idea explored then set aside due to the non-editor context limitation.

### #701 — UI: Inconsistent button sizing
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 0 · *(board-Done 2026-06-17)*
**Link:** https://github.com/WordPress/ai/issues/701

**Problem / goal.** Buttons rendered at inconsistent heights and some did not take full available width. Root cause: missing opt-in to the `__next40pxDefaultSize` prop on several component usages.

**Resolution / retained context.** Direction was to add `__next40pxDefaultSize` to lagging usages and possibly enforce via `components-no-missing-40px-size-prop`. The issue moved board-Done on 2026-06-17.

### #721 — DataViews strings in the Request Log settings panel are not translated
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 0 · *(board-Done 2026-06-17)*
**Link:** https://github.com/WordPress/ai/issues/721

**Problem / goal.** DataViews strings on the Request Log settings panel stayed English even when the site language was Japanese, despite translations existing on translate.wordpress.org.

**Resolution / retained context.** Expected fix: ensure Request Log DataViews settings strings load from the correct plugin/core JavaScript translation context. The issue moved board-Done on 2026-06-17.

### #750 — Disable guest comments from Comment Moderation AI analysis
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** [Type] Enhancement · **Assignee(s):** Intenzi · **Updated:** 2026-06-22 · **Comments:** 0 · *(board-Done / closed 2026-06-22; milestoned 1.1.0)*
**Link:** https://github.com/WordPress/ai/issues/750

**Problem / goal.** The Comment Moderation experiment ran AI sentiment/toxicity analysis on every comment, including anonymous/guest ones — letting comment spam drive API-token exhaustion (a "Denial of Wallet" risk), with no way to auto-analyze only logged-in users. Follow-up to PR #516 discussion.

**Resolution / retained context.** Resolved by adding a Comment Moderation toggle controlling whether guest/anonymous comments are auto-analyzed (default on to preserve behavior); implemented in **PR #751** (@Intenzi) and moved board-Done on 2026-06-22 under milestone 1.1.0.

### #752 — AI Request Logs: "Last 30 Days" summary uses a calendar month, not 30 days
**Status:** Done · **Milestone:** — · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-06-22 · **Comments:** 0 · *(board-Done / closed 2026-06-22; unmilestoned)*
**Link:** https://github.com/WordPress/ai/issues/752

**Problem / goal.** On the AI Request Logs screen the "Last 30 Days" dropdown drove the summary cards (server-side calendar month, 28–31 days) and the logs table (browser-computed fixed 30 days) with different windows, so their counts could disagree.

**Resolution / retained context.** Resolved by making the summary endpoint use a fixed 30-day window for `period=month`, matching the table; implemented in **PR #753** (@i-anubhav-anand) and moved board-Done on 2026-06-22. Sits alongside the earlier-closed Request-Log fixes #666/#667/#670.

### #767 — AI feature buttons remain disabled for sufficient non-space-delimited content in word-based locales
**Status:** Done · **Milestone:** 1.1.0 *(re-milestoned 1.2.0 → 1.1.0)* · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-30 · **Comments:** 0 · *(board-Done / closed 2026-06-30)*
**Link:** https://github.com/WordPress/ai/issues/767

**Problem / goal.** The locale-aware content-length gate from PR #581 keyed off the WP/user locale rather than the post content's own script, so an English-locale author writing Japanese/Chinese/Korean/Thai content saw AI feature buttons stay disabled despite plenty of meaningful content.

**Resolution / retained context.** Settled on gating by the content's own script (character-based) rather than the UI locale. The issue moved board-Done and closed on 2026-06-30, re-milestoned into the 1.1.0 release; sits alongside the earlier CJK fixes #571 / #578.

### #771 — Suggested Tags/Categories pill is removed irrespective of failure (Content Classification)
**Status:** Done · **Milestone:** 1.1.0 *(was unmilestoned)* · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-30 · **Comments:** 0 · *(board-Done / closed 2026-06-30 via PR #772)*
**Link:** https://github.com/WordPress/ai/issues/771

**Problem / goal.** The Content Classification experiment removed a suggested Tag/Category pill on click and never restored it if the add request failed (network/nonce/backend error), silently discarding a usable AI suggestion.

**Resolution / retained context.** Resolved by restoring the suggestion pill to its original position on failure; implemented in **PR #772** and moved board-Done on 2026-06-30 under milestone 1.1.0. Adjacent to relevance work #452.

### #793 — New Developer Tool: Customize experiments
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-10 · **Comments:** 0 · *(board-Done / closed 2026-07-10 via PR #842; moved To do → In progress → Done)*
**Link:** https://github.com/WordPress/ai/issues/793

**Problem / goal.** Enabling some experiments immediately surfaced advanced settings (e.g. Content Classification's taxonomy strategy / maximum suggestions), adding cognitive load for the non-technical site owners the plugin targets. Added a **"Customize experiments"** toggle under the Developer Tools (⋮) menu — disabled by default — keeping advanced per-experiment settings hidden until opted in.

**Resolution / retained context.** Merged as **PR #842** ("Add Advanced Settings toggle to Developer Tools menu", which also re-surfaces the Type Ahead settings from #151) and closed board-Done under **1.2.0** on 2026-07-10.

### #805 — Release version 1.1.0
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** — · **Assignee(s):** dkotter, jeffpaul · **Updated:** 2026-07-01 · **Comments:** 0 · *(board-Done / closed 2026-07-01 — release cut)*
**Link:** https://github.com/WordPress/ai/issues/805

**Problem / goal.** The release-tracking checklist for **v1.1.0**: pre-release PR review/merge-or-punt decisions plus the standard steps (cut `release/1.1.0` from `develop`, bump `WPAI_VERSION` in `ai.php` + `readme.txt`, update `@since`/changelogs/CREDITS/`.gitattributes`).

**Resolution / retained context.** **v1.1.0 shipped 2026-07-01** (17th release) and the tracker closed board-Done. The last gating PR — #560 (Connector key encryption) — merged 2026-06-30; #739 (`core/read-content`) and #798/#799 (global-toggle / credential gating) were punted off the release. Filed and driven by dkotter + jeffpaul; the release beat its original 2026-07-30 target by roughly four weeks.

### #809 — Enhancement/Fix: Content Summarization block found inside nested blocks
**Status:** Done · **Milestone:** — · **Labels:** — · **Assignee(s):** Intenzi · **Updated:** 2026-07-10 · **Comments:** 0 · *(board-Done / closed 2026-07-10 via PR #810; unmilestoned)*
**Link:** https://github.com/WordPress/ai/issues/809

**Problem / goal.** The Content Summarization "Regenerate Summary" flow only scanned **top-level** blocks for the existing `ai-generated-summary` group, so a summary moved inside a nested Group/Column wasn't found and a **second** summary block was inserted instead of updating the existing one.

**Resolution / retained context.** Fixed by recursing into `innerBlocks` when detecting the existing summary group; merged as **PR #810** (Intenzi, *Closes #809*) and closed board-Done on 2026-07-10. Remained **unmilestoned** through close.

### #815 — Connector Approvals doesn't immediately flag need to grant AI plugin access to a provider
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** [Type] Bug, Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-10 · **Comments:** 0 · *(board-Done / closed 2026-07-10 via PR #830; moved To do → In progress → Done)*
**Link:** https://github.com/WordPress/ai/issues/815

**Problem / goal.** When Connector Approvals was first enabled, **no admin notice** told the user they must approve the AI plugin's access to a connected provider — the gap only surfaced later as a "no available connector" error when using an AI feature (a WPORG support report; lightly related to #660).

**Resolution / retained context.** Surfaced the "grant the AI plugin access to your provider(s)" notice immediately on enabling Connector Approvals; merged as **PR #830** ("Fix/815 grant ai plugin access") and closed board-Done under **1.2.0** on 2026-07-10.

### #816 — Type-Ahead experiment loads wp-editor on the front end, intermittently breaking WooCommerce block checkout
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-09 · **Comments:** 0 · *(board-Done / closed 2026-07-09; moved Triage → In progress → Done)*
**Link:** https://github.com/WordPress/ai/issues/816

**Problem / goal.** The **Type Ahead** experiment (shipped v1.1.0) registered its assets on `enqueue_block_assets`, which also fires on the **front end**, pulling the full block-editor stack (incl. the `core/editor` store) onto public pages. WooCommerce's Store API cart resolver checks `!! select( 'core/editor' )` to detect the editor, so the publicly-registered store **intermittently corrupted block-based checkout** (reproduced on the sample Beanie/Cap cart) — a post-1.1.0 regression.

**Resolution / retained context.** Curtailed the front-end asset registration so `core/editor` is no longer registered publicly; closed board-Done under **1.2.0** on 2026-07-09 (off-board fix PR #820). The highest-severity item of the 1.2.0 opening batch.

### #818 — Missing alt text on feature card image in AI Home stage
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-07-09 · **Comments:** 0 · *(board-Done / closed 2026-07-09; was unmilestoned, closed under 1.2.0)*
**Link:** https://github.com/WordPress/ai/issues/818

**Problem / goal.** The feature-card image in `routes/ai-home/stage.tsx` rendered with an empty `alt`, failing **WCAG 1.1.1 (Non-text Content)** for screen-reader users.

**Resolution / retained context.** Populated `alt` with a descriptive value derived from the feature; closed board-Done under 1.2.0 on 2026-07-09 (off-board fix PR #819), part of the a11y/E2E hardening wave.

### #833 — Title Generation: uncaught TypeError (MutationObserver.observe called with null)
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-09 · **Comments:** 0 · *(board-new 2026-07-05; board-Done / closed 2026-07-09)*
**Link:** https://github.com/WordPress/ai/issues/833

**Problem / goal.** With Title Generation enabled, opening the block editor threw `TypeError: Failed to execute 'observe' on 'MutationObserver': parameter 1 is not of type 'Node'` — a race in `TitleToolbarWrapper.tsx` where `setupObserver()` fired on a fixed 500 ms timer before the editor-canvas iframe body was ready.

**Resolution / retained context.** Guard the observer against a null target / wait for the canvas body; closed board-Done under 1.2.0 on 2026-07-09. Filed by soydiloreto with the stack trace and source lines.

### #839 — Type Ahead: Suggestion restarts immediately after Escape dismissal
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-07-07 · **Comments:** 0 · *(board-new + board-Done / closed 2026-07-07)*
**Link:** https://github.com/WordPress/ai/issues/839

**Problem / goal.** Pressing Escape to dismiss a Type Ahead ghost-text suggestion, with the caret at the end of the block, immediately restarted the caret-driven suggestion flow and fired another network request — dismissal should not trigger a fresh request until the user shows renewed writing intent.

**Resolution / retained context.** Suppressed re-request on Escape until new input; closed board-Done under 1.2.0 on 2026-07-07. Filed by yogeshbhutkar.

### #846 — Type Ahead: Ghost text placement and empty-block placeholder overlap
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-07-09 · **Comments:** 0 · *(board-new + board-Done / closed 2026-07-09)*
**Link:** https://github.com/WordPress/ai/issues/846

**Problem / goal.** Two related Type Ahead empty-paragraph bugs: ghost text could anchor **above the title/first block** when a response was in-flight on the first line (the overlay should fall back to the editable-container bounds when the caret rect is outside the block container), and the block **placeholder and ghost text could overlap**.

**Resolution / retained context.** Corrected the overlay anchoring / placeholder handling; closed board-Done under 1.2.0 on 2026-07-09. Filed by yogeshbhutkar with screen recordings.

### #848 — [Spam, closed] "How AI-Powered Cloud Services in India Are Transforming Modern Enterprises"
**Status:** Done *(closed as "completed")* · **Milestone:** — · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-10 · **Comments:** 0 · *(board-Done / closed 2026-07-10)*
**Link:** https://github.com/WordPress/ai/issues/848

**Problem / goal.** Not a roadmap item — **SEO / link spam** (promotional copy linking `prodevans.com`, filed by throwaway account `keywordcoded-glitch`). It landed in Triage 2026-07-09 and inflated the open-issue count.

**Resolution / retained context.** **Closed 2026-07-10** (state reason "completed"), so it now shows as a board-Done card rather than being removed from Project #240 — no longer inflating the Triage bucket or the open-issue count. Retained here only so the board↔doc counts reconcile.

### #614 — Add support for bulk summary generation
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** [Type] Enhancement · **Assignee(s):** prasadkarmalkar · **Updated:** 2026-07-13 · **Comments:** 6
**Link:** https://github.com/WordPress/ai/issues/614

**Problem / goal.** Content Summarization is only reachable from the post-editor panel, making it tedious to summarize many existing posts (each requires opening the editor). Goal: summarize multiple posts at once.

**Proposed approach.** Add a "generate summary" action to the Bulk Actions dropdown on `/wp-admin/edit.php`, saving the summary to post content and post meta. prasadkarmalkar built a POC (screencast) and planned a draft PR; existing summaries are regenerated/replaced. jeffpaul suggested pairing the bulk option with a **WP-CLI command** and noted other experiments may warrant similar bulk+CLI support.

**Open decisions / blockers.**
- Concern (coderGtm): AI "slop" risk and ballooning costs at scale; but valuable as a standardized bulk-AI pattern.
- Regeneration policy: POC regenerates every post (including ones with existing summaries) rather than skipping.

**Dependencies.** — (plugin doubles as a reference implementation; standardized bulk-AI approach seen as valuable.)

**Discussion highlights.** Bulk + CLI pairing favored; regenerate-all confirmed by prasadkarmalkar. justin-jiajia later nudged the draft PR toward review-readiness.

### #778 — E2E: Prefer user-facing attributes
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-14 · **Comments:** 3
**Link:** https://github.com/WordPress/ai/issues/778

**Problem / goal.** Some Playwright E2E tests locate elements via CSS classes / DOM structure, which can break under design or refactoring changes even when the user experience is unchanged. Playwright recommends user-facing locators (`getByRole`, etc.) that reflect how users and assistive technology actually interact with the UI.

**Proposed approach.** A tracker issue: replace brittle class/structure-based locators with role-based, user-facing locators across the E2E suite where it makes sense (e.g. `page.getByRole( 'tab', { name: 'Post' } )`), with related PRs linked from the issue body as each spec is migrated (Content Summarization, Excerpt Generation, Content Classification, …).

**Open decisions / blockers.** Per-spec scope and which locators have a genuine user-facing equivalent; coordinating the several contributors each taking an individual spec.

**Dependencies.** The Playwright E2E suite; mirrors the approach already used in specs #762 / #773.

**Discussion highlights.** Contributors are self-assigning individual experiment specs (Infinite-Null on Excerpt Generation; hasanmehmood on Content Classification, following the #762/#773 pattern); yogeshbhutkar is coordinating reviews.

### #853 — Generate_Image Ability uses a hardcoded timeout value
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-14 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/853

**Problem / goal.** The Image Generation ability issues its provider request with a fixed, hardcoded timeout rather than a configurable/filterable value. Slow image models (or constrained hosts) can exceed the hardcoded window and fail even when the generation would otherwise have succeeded, with no supported way to raise the limit.

**Proposed approach.** None finalized (Triage). Likely expose the timeout as a filterable value and/or align it with the provider / AI-Client request-timeout configuration so site owners on slower models can extend it.

**Open decisions / blockers.** Not yet triaged to a milestone; exact configuration surface (constant vs. filter vs. per-provider) undecided.

**Dependencies.** The Image Generation experiment/ability; provider request-timeout handling in the WP AI Client / provider plugins.

**Discussion highlights.** — (board-new; no comments yet.)

### #864 — Release version 1.2.0
**Status:** Done · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** dkotter, jeffpaul · **Updated:** 2026-07-14 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/864

**Problem / goal.** Track and execute the v1.2.0 release.

**Outcome.** The release branch/checklist completed, plugin checks and tests passed, local testing passed, the GitHub release was published on 2026-07-14, and the build was deployed to WordPress.org.

**Open decisions / blockers.** The Make/AI announcement checkbox remained open in the issue at snapshot time; release delivery itself is complete.

**Dependencies.** Release instructions, CI, Plugin Check, WordPress.org deployment.

**Discussion highlights.** Maintainers recorded the passing checks, release URL, and deployment confirmation.

### #865 — Type-ahead experiment loads the whole block editor (~1.5MB JS) on every frontend page
**Status:** Done · **Milestone:** — · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-07-14 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/865

**Problem / goal.** Type Ahead loaded roughly 1.5 MB of block-editor JavaScript on every front-end page, including logged-out visits.

**Outcome.** Closed as already fixed by #816 / PR #820; the fix gates the editor-only assets away from public pages and shipped in v1.2.0.

**Open decisions / blockers.** None for this duplicate report.

**Dependencies.** Type Ahead asset registration; #816; PR #820.

**Discussion highlights.** A maintainer pointed the reporter to the existing fix and requested verification against `develop`.

### #870 — Adjust order of Admin Experiments
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement, Good first issue, Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-16 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/870

**Problem / goal.** Related admin experiments were separated in the settings order.

**Outcome.** Reordered Key Encryption next to Connector Approvals and Suggest Reply next to Comment Moderation; closed board-Done under 1.3.0.

**Open decisions / blockers.** A broader alphabetical ordering for Editor Experiments may still be considered.

**Dependencies.** Admin experiment ordering.

**Discussion highlights.** No comments.

### #872 — Improve keyboard focus management for content classification suggestions
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-07-16 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/872

**Problem / goal.** Content Classification lost keyboard focus whenever generation controls or accepted/dismissed suggestions were removed from the DOM.

**Outcome.** Closed board-Done under 1.3.0 after focus-management work.

**Open decisions / blockers.** None recorded.

**Dependencies.** Content Classification suggestion UI and keyboard focus behavior.

**Discussion highlights.** No comments.

### #191 — Add import/export support for AI settings and provider configuration
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement · **Assignee(s):** coderGtm · **Updated:** 2026-07-24 · **Comments:** 7 · *(board-Done / closed 2026-07-24)*
**Link:** https://github.com/WordPress/ai/issues/191

**Problem / goal.** Provide import/export of AI settings and provider configuration for portability across environments — valuable for agencies, hosts, and multisite. Security and credential handling had to be resolved first.

**Resolution / retained context.** Closed by **PR #734** ("feat: add settings import/export functionality", coderGtm), merged 2026-07-24 under 1.3.0. The shipped spec is the one the thread converged on: export only **non-sensitive** configuration (no API keys), letting secrets resolve from env vars/host/settings so the export is a plain JSON file reusable across dev/staging/prod; import behind a confirm-before-apply dialog rather than a full preview screen; non-sensitive details surfaced through WordPress Site Health. The issue sat In progress for roughly six weeks — the credential-handling debate, not the implementation, was the long pole.

**Dependencies.** WordPress Site Health; WP-managed API key storage (keys are managed by WP/AI Client, not the plugin).

**Discussion highlights.** coderGtm (assignee) argued against bundling keys (security + per-env replacement friction); dkotter agreed, endorsed Site Health integration, and preferred a simple confirm dialog over a preview.

### #192 — Add extension points for custom prompt templates
**Status:** Done · **Milestone:** 1.3.0 *(was Future Release)* · **Labels:** [Type] Enhancement · **Assignee(s):** the-hercules · **Updated:** 2026-07-20 · **Comments:** 1 · *(board-Done / closed 2026-07-20)*
**Link:** https://github.com/WordPress/ai/issues/192

**Problem / goal.** Introduce extension points letting developers define, override, or extend the prompt templates used by experiments — customization without forking. Target: developers.

**Resolution / retained context.** Closed by **PR #770** ("Prompt template extension points", the-hercules), merged 2026-07-20. The card was **pulled from Future Release into 1.3.0 as it closed**, which is the tell that the maintainers treated the merged hook API as release-worthy rather than backlog cleanup. Acceptance was met: templates are extendable/overridable via hooks, scoped and predictable, working across multiple experiments.

**Dependencies.** AI experiment prompt-assembly layer. Enables/complements customization in agentic experiments (#189, #282, #142 "developer mode").

**Discussion highlights.** Minimal thread — the hook/filter API was defined in the PR rather than debated in the issue.

### #452 — Content Classification: Improve relevance of taxonomy suggestions
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** saarnilauri · **Updated:** 2026-07-21 · **Comments:** 1 · *(board-Done / closed 2026-07-21)*
**Link:** https://github.com/WordPress/ai/issues/452

**Problem / goal.** Category/tag suggestions from the Content Classification experiment were frequently irrelevant. Surfaced via Miriam Schwab (Elementor) feedback; dkotter framed it as expected early feedback on one of the newest experiments, and the issue doubled as a running feedback collector.

**Resolution / retained context.** Closed by **PR #633** ("Content Classification: improve relevance of taxonomy suggestions", saarnilauri), merged 2026-07-21 under 1.3.0. The volunteer who reported the candidate fix carried it through to merge. Because the issue was also serving as a feedback collector, further relevance complaints will need a fresh issue.

**Dependencies.** —

**Discussion highlights.** Feedback from Elementor's Miriam Schwab; dkotter framed it as early, expected feedback; saarnilauri offered and landed the fix.

### #507 — Iterate on Editorial Updates end flow to Visual Revisions
**Status:** Done · **Milestone:** 1.3.0 · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** zeus2611 · **Updated:** 2026-07-24 · **Comments:** 4 · *(board-Done / closed 2026-07-24)*
**Link:** https://github.com/WordPress/ai/issues/507

**Problem / goal.** At the end of the "Refine from Notes"/Editorial Updates flow, a toast linked to the **legacy** revisions screen. Since the plugin requires WP 7.0, it should instead point to the new **Visual Revisions** screen.

**Resolution / retained context.** Closed by **PR #861** ("Link Editorial Updates success notice to visual revisions", zeus2611), merged 2026-07-24 under 1.3.0. The shipped approach is the one agreed in-thread: keep the existing revision lookup and `getRevisionReviewAction()` shape, then branch the toast — dispatch `editorStore.setCurrentRevisionId(lastRevisionId)` when `disableVisualRevisions` is false, otherwise fall back to `revision.php?revision=...`. **Retained risk:** the visual path depends on a private-but-stable WP 7.0 editor-store action rather than a public URL, so a core change to that action would silently break this flow.

**Dependencies.** WP 7.0 core Visual Revisions; Editorial Updates revision lookup in `useEditorialUpdates.ts`; editor store `setCurrentRevisionId`.

**Discussion highlights.** zeus2611 originally waited for WP 7 to finalize. kiranmagic7 mapped the current source path, and zeus2611 agreed to use `setCurrentRevisionId(lastRevisionId)` behind the `disableVisualRevisions: false` gate instead of waiting for a public URL.

### #874 — Meta Description: Issue with Yoast plugin for Meta Description experiment
**Status:** Done · **Milestone:** 1.3.0 *(was no milestone)* · **Labels:** [Type] Bug · **Assignee(s):** hbhalodia · **Updated:** 2026-07-20 · **Comments:** 5 · *(board-Done / closed 2026-07-20)*
**Link:** https://github.com/WordPress/ai/issues/874

**Problem / goal.** The Meta Description experiment conflicted with Yoast SEO: updates worked for posts but not pages/CPTs, and could stop working for posts when Yoast AI was disabled.

**Resolution / retained context.** Closed by **PR #886** ("Fix: Meta Description: Issue with Yoast plugin for Meta Description experiment", hbhalodia), merged 2026-07-20 — four days after filing, and milestoned into 1.3.0 on the way out. The investigation is the durable part: the Yoast meta-description box binds to Yoast's own `yoast-seo/editor` store, **not** `core/editor` post meta, and only Yoast's AI feature mounts a bridge copying `core/editor` meta across — which is why `editPost({ meta })` appeared to work only while Yoast AI was on. Separately, `_yoast_wpseo_*` meta is REST-exposed for the **`post`** post type only; for pages and CPTs it is registered with a sanitize callback and no REST, so `editPost` never round-trips and the value is dropped on save. Both layers share the same `post`-only design decision. The reporter also filed the detail upstream as `Yoast/wordpress-seo#23458`.

**Dependencies.** Yoast SEO editor store and metabox save path; WordPress REST meta; upstream Yoast issue #23458.

**Discussion highlights.** Five comments carry an unusually complete root-cause write-up (two-store architecture, the AI-only sync bridge, the post-type REST limitation) before any code was proposed. Note the contrast with sibling bug #869, which is still in Triage for want of a clean reproduction — #874 closed fast precisely because the reporter did the diagnosis.

### #883 — Abilities Explorer: provider filter dropdown doesn't include custom providers
**Status:** Done · **Milestone:** — · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-07-24 · **Comments:** 1 · *(board-Done / closed 2026-07-24)*
**Link:** https://github.com/WordPress/ai/issues/883

**Problem / goal.** The Abilities Explorer already recognized an ability's custom `meta['provider']` label in its Provider column and `?provider=` query handling, but the visible filter was hard-coded to Core/Plugin/Theme, so users could not select a custom provider. The overview statistics had a related defect: custom provider labels could make plugin abilities disappear from every origin card even though the Total stayed correct.

**Resolution / retained context.** Closed by **PR #884** ("Abilities Explorer: support custom providers in the filter dropdown and statistics", azizulhasan), merged 2026-07-24. The design separates **provider label** from **origin**: `meta['provider']` remains the display/filter value while prefix-derived Core/Plugin/Theme origin drives the fixed three overview cards — so filter options grow with the ecosystem but the stat cards stay at three. Implemented with `get_unique_providers()`, `detect_origin()`, a normalized `origin` field, and integration tests. The issue lived its whole life unmilestoned and closed that way, six days after being filed.

**Dependencies.** `Ability_Table::extra_tablenav()` and statistics; `Ability_Handler::detect_provider()` / `get_provider_label()`; the dynamic-category-filter pattern from #344/#355.

**Discussion highlights.** azizulhasan expanded the initial filter-only proposal after finding that the same hard-coded provider buckets caused statistics drift — the scope grew because the root cause was shared. The author reported a live test with 112 abilities, 82 of them under a custom provider.

---

## Removed from Project #240 (reference)

### #84 — Create abilities for CRUD operations that work with all post types
**Board status:** Removed from Project #240 as of the 2026-06-19 refresh · **Upstream issue state:** Open · **Milestone:** Later · **Labels:** — · **Assignee(s):** jorgefilipecosta · **Updated:** 2025-10-30 · **Comments:** 0 · **Repo:** `WordPress/abilities-api`
**Link:** https://github.com/WordPress/abilities-api/issues/84

**Problem / goal.** Sub-issue of WordPress/ai#40, scoped to the `abilities-api` repo. Define/register CRUD abilities that apply uniformly across all post types (built-in and custom), so tools/plugins/UIs can perform those operations consistently rather than via piecemeal capabilities.

**Proposed approach.** A base CRUD schema, parameterized per post type, respecting existing REST permission callbacks. Server-side uses `get_post()`/`get_posts()`/`wp_update_post()`/`wp_delete_post()`. The **client may override `execute_callback`** to use `@wordpress/core-data` + entities (`getEntityRecords`, `editEntityRecord`) — preserving optimistic updates, undo/redo, and the editor save workflow instead of always hitting the server.

**Open decisions / blockers.**
- Generic CRUD vs. post-type-specific granularity (create-book vs create-page).
- Exact server vs. client implementation split and when each applies.

**Dependencies.** Parent WordPress/ai#40; `@wordpress/core-data`/entities; WP REST permission callbacks.

**Discussion highlights.** No comments; design points copied from the #40 thread by gziolo as a dedicated implementation-tracking sub-issue. It still appears on a separate "WordPress Abilities API: planning" project item, but no longer on the WordPress AI Planning & Roadmap board (#240).

---

## Maintenance

To refresh this dossier, re-run the data pull in [`wordpress-ai-roadmap.md` §10](./wordpress-ai-roadmap.md#10-how-to-refresh-this-document), then for any issue whose `updatedAt` changed, re-read it:

```bash
gh issue view WordPress/ai#<N> --json number,title,body,state,labels,milestone,assignees,createdAt,updatedAt,url,comments
```

(`#23` → `WordPress/ai-provider-for-google`; #84 is retained only as a removed-board reference from `WordPress/abilities-api`.)

The full `WordPress/php-ai-client` and `WordPress/mcp-adapter` repository censuses intentionally do not add their issue backlogs here. Their open PR and release activity is summarized in [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md) and emitted in full by `./wp-ai-roadmap-refresh.sh census`.

**Changelog**

| Date | Change |
|---|---|
| 2026-08-14 | Live Project #240 refresh — the 1.3.0 delivery wave. Open issues **51 → 48**: In discussion **18 → 19**, In progress **18 → 13**, Needs review **3** (membership changed), Backlog **6**, To do **3 → 4**, Triage **3** (milestones changed). **Moved 7 dossiers to Recently board-Done** (43 → **50** retained), six closed by merged PRs — **#233** (`AI_Service` deprecation, PR #905), **#690** (uninstall cleanup, #692), **#863** (abilities toggle, #881), **#866** (`wpai_` meta prefix, #867), **#876** (permalink slugs, #897), **#906** (reserved log-type API, #914) — plus **#307 closed `NOT_PLANNED`** (the AGENTS.md proposal declined). **Dossiered 4 board-new issues:** **#923** (agent users — the auditable-identity governance discussion, with production evidence that 50.2% of webmyc's 241,614 tool calls carry no usable agent identifier), **#940** (custom settings endpoint vs `/wp/v2/settings`; dkotter reproduces the key-wiping bug), **#924** (1.3.0 release tracker, target 2026-08-17, only #459 left on the pre-release list), and **#933** (connector validity is capability-aware, not text-only; PR #935). **Relocated:** **#514** and **#732** In progress → Needs review; **#600** In discussion → To do, retitled "Remove `Enable AI` header toggle…" with a Help Wanted label. **Re-milestoned:** #660/#736/#845/#875 → 1.4.0, #890/#918 → Future Release. #187 (translation) de-carded Done from the board and noted in the retention header. | 
| 2026-08-01 | Live Project #240 refresh. **Open issues hold at 52** while the status mix shifted by one: In progress **16 → 17**, Needs review **2 → 1**, and In discussion **20**, Backlog **7**, To do **4**, Triage **3** unchanged. **Moved 2 dossiers to Recently board-Done** (39 → **41** retained): **#187** (multilingual rewriting/translation) closed 2026-07-28 by **merged PR #747** — the v1.3.0 lane's first experiment to land since the six that closed last window, and the reason Needs review fell to 1; and **#900**, promotional webinar spam opened, carded, closed, and marked Done all on 2026-07-28, recorded only so "two cards added" is not misread as two units of intake (second spam card in three windows, after #848). **Dossiered 1 board-new issue: #906** (Request Logging has no public API for the reserved `mcp_tool`/`ability` log types) — filed 2026-07-29 with an exact root cause (the REST enum and TS client advertise three types; the only writer hardcodes `ai_client`; every manager accessor is `private`), agreed to by dkotter the same day, and implemented by **PR #914** on 2026-08-01 with a proper `Closes #906`. Its dossier flags one behavior change: `log()` now refuses unknown types via `_doing_it_wrong()`, so existing callers passing custom types would lose rows. **3 dossiers re-milestoned out of dated lanes into Future Release**, all still In progress: **#736** (1.3.0 → Future Release; PR #749 picked up CHANGES_REQUESTED), **#875** and **#876** (1.4.0 → Future Release; PRs #887/#897 both picked up CHANGES_REQUESTED). Last window's note on #875/#876 — that their move to In progress reflected code appearing rather than decisions closing — is now confirmed by the re-milestoning, and both dossiers say so. **#233 rewritten: its premise reversed.** Adoption PR #898 closed unmerged 2026-07-27, and off-board PR **#905** now *deletes* the `AI_Service` layer as dead code, answering jeffpaul's April question in the opposite direction from the card's title. Because #905 declares no `closing` reference, the board still shows "Refactor experiments to leverage AI_Service layer / In progress"; the dossier now leads with a stale-title warning. Board totals **274 → 269**; Done **207 → 203**; non-Done PR cards **15 → 14**. **7 already-Done cards de-carded** (#614/#778/#853/#864/#865/#870/#872) — all previously dossiered here and all retained, with the Recently board-Done heading updated and a new caveat that board-Done ≠ merged (PR #621 was closed unmerged yet marked Done). `WordPress/ai` open issues hold at 51 (+ #23 on `ai-provider-for-google`). |
| 2026-07-27 | Live Project #240 refresh — the largest dossier reshuffle since the 1.2.0 transition. Open issues **57 → 52**: In discussion **22 → 20**, In progress **15 → 16**, Backlog **8 → 7**, To do **6 → 4**, Needs review **3 → 2**, Triage **3** (membership changed). **Moved 6 dossiers to Recently board-Done** (33 → **39** retained), all closed by merged PRs: **#191** (settings import/export, PR #734, 2026-07-24 — the credential-handling debate, not the code, was the six-week long pole), **#192** (prompt-template extension points, PR #770, 2026-07-20 — pulled Future Release → 1.3.0 *as* it closed), **#452** (taxonomy relevance, PR #633, 2026-07-21), **#507** (Editorial Updates → Visual Revisions, PR #861, 2026-07-24 — retains a dependency on a private WP 7.0 editor-store action), **#874** (Yoast meta-description interop, PR #886, 2026-07-20, milestoned — → 1.3.0 on close; the dossier keeps the full two-store/REST-subtype root cause and upstream `Yoast/wordpress-seo#23458`), and **#883** (Abilities Explorer custom providers + statistics, PR #884, 2026-07-24). **5 dossiers relocated into In progress** as authoritative closing PRs opened against them: **#233** (To do → In progress, PR #898), **#421** (To do → In progress; **relationship correction** — PR #459 is confirmed as its `closing` PR, not the conceptual sibling earlier docs described), **#844** (Backlog → In progress, PR #891 — opened *ahead of* its stated #683 blocker, flagged as a duplicate-indexing risk), **#875** and **#876** (both In discussion → In progress, PRs #887/#897; their product questions remain open, so the moves reflect code starting, not decisions closing). **Dossiered 1 board-new Triage issue:** **#890** (mobile right-sidebar component — no labels, milestone, assignee, comments, or target surface; needs triage before scoping). Board totals **283 → 274**; Done **209 → 207**; non-Done PR cards **17 → 15**. **10 already-Done cards de-carded** from Project #240 (#508/#793/#809/#815/#816/#818/#833/#839/#846 + spam #848) — all previously dossiered here and all retained, with a note added to the Recently board-Done heading explaining that retained ≠ still carded. `WordPress/ai` open issues 56 → 51 (+ #23 on `ai-provider-for-google`). |
| 2026-07-20 | Live Project #240 recheck: dossier membership and board counts unchanged — **57 open issues** (In discussion 22, In progress 15, Backlog 8, To do 6, Triage 3, Needs review 3), Done 209, non-Done PR cards 17. No status, milestone, or membership moves since 2026-07-18. Bumped #876's Updated cell to 2026-07-20 (a non-status thread edit; still In discussion / 1.4.0, 0 comments); #883's implementing-PR note (#884) remains current. Cross-repo note: board PR #858 (`core/read-nav-menus`) moved merge DIRTY → BLOCKED, tracked in the planned-work file. |
| 2026-07-18 | Same-day live Project #240 refresh. Open issues **56 → 57** and In progress **14 → 15** with new unmilestoned dossier **#883** (Abilities Explorer custom-provider filtering/statistics), authoritatively implemented by PR #884. Board totals **282 → 283**; Done stays 209; non-Done PR cards stay 17. Re-read #425 and recorded PR #885 only as `fallback-title` candidate evidence because it has no GitHub closing reference. |
| 2026-07-18 | Rechecked Project #240: dossier membership and board counts are unchanged. Clarified that the new full `WordPress/php-ai-client` and `WordPress/mcp-adapter` tracking is PR/release census-only; their issue backlogs are not imported into this board-scoped dossier. |
| 2026-07-17 | Authoritative PR-mapping pass (GitHub closing references now drive the refresh tooling): recorded open PR **#798** as the closing PR on the **#600** dossier and noted that its previously tabulated #617 link was parser noise. No other dossier's PR relationships changed (#187↔#747 was already recorded). |
| 2026-07-17 | Live Project #240 refresh. Open issues **53 → 56**: In discussion **19 → 22**, In progress **17 → 14**, Backlog 8, To do 6, Triage **2 → 3**, Needs review **1 → 3**. Moved #600 to In discussion; #507/#660 to Needs review; #614/#778/#853 to Recently board-Done. Added six open dossiers (#863/#866/#869/#874/#875/#876) and four board-new Done dossiers (#864/#865/#870/#872), taking retained Done references **26 → 33**. v1.2.0 shipped; active milestones reorganized around 1.3.0/1.4.0. Board **279 → 282**, Done **206 → 209**, non-Done PR cards **20 → 17**. |
| 2026-06-15 | Initial dossier — full deep-read of all 58 open issues (body + comments) across 6 thematic agent passes. |
| 2026-06-16 | Status patch (no re-read). Fixed #84 Updated-date typo (2026-10-30 → 2025-10-30). Regrouped per board moves: #191, #508, #689 → In progress; #699 → Recently shipped (1.0.2). |
| 2026-06-16 | Dossiered the 2 board-new issues from live reads: **#732** (Triage — AI Request Log misses non-SDK-transport providers) and **#736** (Backlog — per-feature role/user access controls). Counts: Triage 2→3, Backlog 10→11. Now covers all **59** open issues + #699 (shipped). |
| 2026-06-18 | Metadata/status refresh from the live project board. Open issues now **53**: In discussion 17, In progress 14, Backlog 11, To do 6, Triage 4, Needs review 1. Moved #390, #391, #571, #578, #678, #701, and #721 to **Recently board-Done**; added new Triage dossier #741; refreshed substantive discussion notes for #187, #190, #197, #507, #508, #614, #689, and #736. |
| 2026-06-19 | Live Project #240 metadata refresh. Current board open issues now **52**: In discussion 20, In progress 12, Backlog 12, To do 6, Triage 1, Needs review 1. Regrouped #632/#643/#741 → In discussion, #732 → Backlog, updated #689's Future Release milestone, and moved abilities-api #84 to a removed-board reference. |
| 2026-06-19 | Fresh live recheck: open-issue dossier counts unchanged at **52** current board-open issues: In discussion 20, In progress 12, Backlog 12, To do 6, Triage 1, Needs review 1. |
| 2026-06-19 | Added the cross-repo dependency watchlist as the upstream home for Gutenberg and abilities-api items referenced by issue dossiers, including abilities-api #84. |
| 2026-06-20 | Live Project #240 refresh. Open issues **52 → 54**: In discussion 20, In progress **16**, Backlog **10**, To do 6, Triage 1, Needs review 1. Promoted #187 (multilingual) and #736 (role/user access controls) from Backlog → In progress; added dossiers for two board-new **unmilestoned** In-progress bug fixes — #750 (disable AI moderation of guest comments, PR #751) and #752 (Request-Log "Last 30 Days" window mismatch, PR #753). Three closed Request-Log bug issues #666/#667/#670 (milestone 1.0.2) were **de-carded** from the board (closed 2026-06-05; never dossiered as open). Done total now **180**. |
| 2026-06-25 | Live Project #240 refresh. Open issues **54 → 53**: In discussion 20, In progress **17**, Backlog **8**, To do 6, Triage 1, Needs review 1. Promoted #192 (custom prompt-template hooks, PR #770) and #732 (non-SDK-transport logging, draft PR #757) from Backlog → In progress; retagged #741 (admin-page flicker) to milestone 1.1.0; added dossiers for two board-new **unmilestoned** bugs — #767 (locale-aware content gate disables AI buttons for CJK content; In discussion) and #771 (Content Classification suggestion pill lost on add-failure; In progress, draft PR #772). Moved #632 (deactivate-connector), #750 (guest-comment moderation), and #752 (Request-Log 30-day window) to **Recently board-Done** (11 retained). Done total now **183**. |
| 2026-06-26 | Live Project #240 refresh. Open issues hold at **53**: In discussion / Needs decision **20 → 19**, To do **6 → 7** (In progress 17, Backlog 8, Triage 1, Needs review 1 unchanged). **#767** (locale-aware content gate) moved **In discussion → To do** and was milestoned **1.2.0** — its dossier relocated accordingly. PR **#151** (Type Ahead experiment) merged board-Done off the 1.1.0 lane (a PR card, not dossiered here), and board-Done bug **#697** (excerpt focus loss; closed 2026-06-11) was de-carded from Project #240. Board totals **250 → 249**; Done holds at **183**; non-Done PR cards **14 → 13**. |
| 2026-06-30 | Live Project #240 refresh. Open issues **53 → 54**: Needs review **1 → 2** (In discussion 19, In progress 17, Backlog 8, To do 7, Triage 1 unchanged). Status moves: **#187** and **#508** In progress → **Needs review** (draft PR #747 / PR #724); **#197** To do → In progress (draft PR #799); **#690** Needs review → In progress. Dossiered **4 board-new open issues** — #778 (E2E user-facing locators), #791 (Type Ahead loading cursor), #793 ("Customize experiments" Developer Tool), #805 (Release 1.1.0 tracker, target 2026-07-30). Moved **#145**, **#767**, **#771** to **Recently board-Done** (11 → **14** retained) as they closed board-Done on 2026-06-30. Large **1.1.0 → 1.2.0 re-milestone wave**: #191, #203, #452, #514, #600, #614, #690, #732, #736 (In progress) + #187/#508 (Needs review) + #507 (To do) + #741 (In discussion) all moved to 1.2.0; **#27** moved 1.1.0 → Future. Already-Done **#699/#704/#718** (1.0.2) were de-carded from Project #240 (#699 kept here as a shipped reference). Board totals **249 → 269**; Done **183 → 195**; non-Done PR cards **13 → 20**. |
| 2026-07-03 | Live Project #240 refresh. Open issues **55 → 56**: In progress **17 → 19**, Triage **2 → 1** (In discussion 19, Backlog 7, To do 8, Needs review 2 unchanged). **#816** (Type-Ahead front-end `wp-editor`/WooCommerce regression) moved **Triage → In progress** (fix PR #820) — dossier relocated accordingly. **Dossiered 1 board-new open issue:** #818 (missing alt text on the AI Home feature-card `<img>`; In progress, unmilestoned, PR #819). **7 already-Done issues de-carded from the board** (#390/#391/#571/#578/#678 from 1.1.0, #589/#727 from 1.0.2) — the five previously dossiered here are retained for reference. Board totals **271 → 265**; Done **196 → 189**; non-Done PR cards hold at **20**. `WordPress/ai` open issues 54 → 55 (+ #23 on `ai-provider-for-google`). |
| 2026-07-02 | Live Project #240 refresh. Open issues **54 → 55**: Backlog **8 → 7**, To do **7 → 8**, Triage **1 → 2** (In discussion 19, In progress 17, Needs review 2 unchanged). **v1.1.0 shipped 2026-07-01** — moved **#197** (credentials gate; closed board-Done with off-board PR #799 closed **unmerged**, so not in the 1.1.0 payload) and **#805** (release tracker) to **Recently board-Done** (14 → **16** retained). Dossiered **3 board-new open issues** — #809 (Content-Summary nested-block detection, In progress, off-board PR #810), #815 (Connector-Approvals access-notice gap, To do / 1.2.0), #816 (Type-Ahead front-end `wp-editor` load breaks WooCommerce block checkout, Triage — post-1.1.0 regression). **#190** moved Backlog → To do. Board totals **269 → 271**; Done **195 → 196**; non-Done PR cards hold at **20**. `WordPress/ai` open issues 53 → 54 (+ #23 on `ai-provider-for-google`). |
| 2026-07-09 | Live Project #240 refresh. Open issues **56 → 57**: Backlog **7 → 9**, To do **8 → 6**, Triage **1 → 2** (In discussion 19, In progress 19, Needs review 2 unchanged). **v1.2.0 opened its first board-Done batch:** moved **#816** (Type-Ahead front-end/WooCommerce regression) and **#818** (AI-Home alt-text a11y) from In progress → **Recently board-Done**, and added three board-new-and-closed bug dossiers there — **#833** (Title-Generation MutationObserver crash), **#839** (Type-Ahead Escape-restart), **#846** (Type-Ahead ghost-text overlap) — so retained board-Done **16 → 21**. **#793** ("Customize experiments") and **#815** (Connector-Approvals notice) moved To do → **In progress**. **Dossiered 2 board-new Backlog experiments:** #844 (semantic search in wp-admin, blocked on #683) and #845 (Markdown feeds via `html-to-md`). **Flagged spam:** #848 (Triage) — SEO/link spam pending board removal. **5 already-Done issues de-carded** from Project #240: #750/#755/#763/#768 (1.1.0) + #752 (no-milestone) — #750/#752 remain retained. Board totals **265 → 277**; Done **189 → 200**; non-Done PR cards hold at **20**. `WordPress/ai` open issues 55 → 56 (+ #23 on `ai-provider-for-google`). |
| 2026-07-12 | Live Project #240 refresh. Open issues **57 → 53**: In progress **19 → 17**, Backlog **9 → 8**, Needs review **2 → 1** (In discussion 19, To do 6, Triage 2 unchanged). **Moved 4 open issues to Recently board-Done** — **#508** "Suggest Reply" experiment (Needs review → Done, PR #724), **#793** Customize-experiments tool (In progress → Done, PR #842), **#815** Connector-Approvals notice (In progress → Done, PR #830), and **#809** nested-block fix (In progress → Done, PR #810) — plus the closed **spam #848** (Triage → Done, "completed"); retained board-Done **21 → 26**. **#845** (Markdown feeds) moved **Backlog → In progress** (implementing PR #855). **Dossiered 1 board-new Triage bug:** #853 (Generate_Image hardcoded timeout, no milestone). Board totals **277 → 279**; Done **200 → 206**; non-Done PR cards hold at **20**. `WordPress/ai` open issues 56 → 52 (+ #23 on `ai-provider-for-google`). |
