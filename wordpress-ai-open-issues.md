# WordPress AI — Open Issues Dossier (Companion Reference)

> Deep per-issue documentation for all **56 open issues** (status current to 2026-07-03) on the [WordPress AI Planning & Roadmap board (#240)](https://github.com/orgs/WordPress/projects/240), tracking the `WordPress/ai` Showcase Plugin.
> Companion to **[`wordpress-ai-roadmap.md`](./wordpress-ai-roadmap.md)** (the strategic overview + tracker) and **[`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md)** (Gutenberg + abilities-api upstream watchlist). This file is the *detailed dossier*: problem, proposed approach, open decisions, dependencies, and discussion for each issue.
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-03 |
> | **Scope** | 56 current open-issue dossiers + 1 removed-board reference (#84) + 16 recently board-Done issues retained for reference (#145, #197, #390, #391, #571, #578, #632, #678, #699, #701, #721, #750, #752, #767, #771, #805). Excludes 20 non-Done PR cards and the rest of the 189 Done items. *(Note: five of the retained board-Done issues — #390/#391/#571/#578/#678 — plus #589/#727 were de-carded from Project #240 on 2026-07-03; they remain closed/shipped and are kept here for reference.)* |
> | **Repos** | `WordPress/ai` (55 open issues) · `WordPress/ai-provider-for-google` (#23). `WordPress/abilities-api` #84 remains open upstream and is now tracked in the cross-repo dependency watchlist, but is no longer on Project #240. |
> | **Each dossier** | Status · Milestone · Labels · Assignees · Last updated · Comment count · Link, then Problem → Approach → Open decisions → Dependencies → Discussion |

**Grouped by board status** (count, current to 2026-07-03): [In discussion / Needs decision (19)](#in-discussion--needs-decision-19) · [In progress (19)](#in-progress-19) · [Backlog (7)](#backlog-7) · [To do (8)](#to-do-8) · [Triage (1)](#triage-1) · [Needs review (2)](#needs-review-2) · [Recently board-Done (16)](#recently-board-done-since-the-2026-06-15-snapshot) · [Removed from Project #240](#removed-from-project-240-reference)

> ⭐ = major strategic bet · ⚠️ = notable risk / live regression. "Status" reflects the **board's project status**; "Milestone" is the release target.

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

### #23 — [Bug] Image Generation fails: "Missing the candidates[0].content key" (Google provider)
**Status:** In discussion / Needs decision · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-05-13 · **Comments:** 2 · **Repo:** `WordPress/ai-provider-for-google`
**Link:** https://github.com/WordPress/ai-provider-for-google/issues/23

**Problem / goal.** Using "Generate Image" in the Image block (WP 7.0 RC, Google/Gemini provider, on WordPress Playground), clicking Generate fails immediately with `Unexpected Google API response: Missing the "candidates[0].content" key`; no image is produced. Suspected: the Gemini API response format changed, the request was silently rejected, or the provider's parsing mishandles it.

**Proposed approach.** None specified yet — root cause unconfirmed.

**Open decisions / blockers.** API format change vs. silent rejection vs. parser bug not yet diagnosed.

**Dependencies.** Google Gemini API; AI Provider for Google plugin; WP 7.0 RC; reproduced on Playground.

**Discussion highlights.** Originally filed on `WordPress/ai`; jeffpaul (cc felixarntz, JasonTheAdams) judged it "almost certainly a bug in the provider plugin" and transferred it to the provider repo. No fix posted yet.

### #27 — Display additional AI provider plugins on Connectors page
**Status:** In discussion / Needs decision · **Milestone:** Future Release *(moved from 1.1.0 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-16 · **Comments:** 10
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
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-02-09 · **Comments:** 0
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

### #90 — Clarify and consolidate Title Generation options
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
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-05-26 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/262

**Problem / goal.** Model selection is hardcoded in `helpers.php` via three static priority lists (text/image/vision). Intentional (prevents surprise upgrades breaking things or inflating costs) but: users with multiple keys can't see which provider handles which task; there's no UI preference (only PHP filters); hardcoded model names are brittle.

**Proposed approach.** **Provider-level bucketing**: users pick a preferred *provider* (Anthropic/Google/OpenAI) per task type (text, image), while the internal model priority order within each provider stays intact (preserving stability). Defaults preset from current logic, so unconfigured behavior is unchanged. zeus2611 proposed a concrete lightest-touch version: an "Advanced" collapsible at the bottom of Settings → AI Experiments with two dropdowns (Text Generation Provider, Image Generation Provider). Longer-term: capability-tier buckets (fast/cheap vs high-reasoning) with an escape hatch.

**Open decisions / blockers.**
- Whether redundant now that a per-Experiment **developer mode** already exposes provider/model selection (jeffpaul questioned remaining scope).
- Reviewer sign-off pending.

**Dependencies.** `helpers.php` priority logic; settings UI; overlaps the Playground (#32), which needs dynamic model input.

**Discussion highlights.** jeffpaul supports it but insists it stay behind Advanced Settings (most users enter one provider and take defaults). zeus2611 agreed and offered to scope a PR.

### #324 — Evolve Refine from Notes into collaborative and agentic editorial workflows ⭐
**Status:** In discussion / Needs decision · **Milestone:** 1.2.0 (due 2026-07-30) · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-05-18 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/324

**Problem / goal.** Today Review Notes and Refine from Notes are separate manual steps, limiting a cohesive, collaborative, automated editorial workflow. Following #289, explore iterations balancing automation with user control and transparency.

**Proposed approach.** Four exploratory threads (may split): (1) **Real-Time Collaboration with a "WordPress AI" user** — refinements appear as live, attributable edits like any collaborator (real user or RTC virtual user); (2) **unified "Review & Refine" agentic flow** — AI generates Notes → user reviews/accepts → AI applies in one pass; (3) integration with **Chat Workspace (#282)** surfacing named agent actions ("Review my draft", "Refine my draft") from both Post Editor and Chat; (4) note-resolution + revision traceability — a "WordPress AI" confirming comment + link to a visual revision/diff per update (may need an auto-save per Note).

**Open decisions / blockers.**
- Whether "WordPress AI" must be a real user or RTC supports a virtual user.
- Whether to interject review points mid-process.
- Auto-save-per-Note requirement for diffs.

**Dependencies.** Gutenberg RTC (must stabilize post-WP 7.0; full inclusion targeted WP 7.1); Chat Workspace #282; follow-up to #289.

**Discussion highlights.** jeffpaul moved it out a couple releases to let Gutenberg RTC stabilize, avoiding pinning a specific Gutenberg version until WP 7.1 ships RTC.

### #338 — New Experiments: Analytics-aware content and amplification recommendations ⭐
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design · **Assignee(s):** zeus2611 · **Updated:** 2026-04-09 · **Comments:** 2
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

### #348 — Feature Request: Unified AI Management Layer for WordPress Core ⭐
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

### #354 — Unified Abilities exposure controls
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-04-08 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/354

**Problem / goal.** After building several ability consumers, there's a need for unified control over **which abilities are available where**. Abilities come from plugins of varying quality, and users need to decide (e.g.) "expose these abilities to Claude via MCP, but those to my on-site AI agent." Without a central mechanism, every plugin with a "surface" ships its own version, fragmenting the ecosystem.

**Proposed approach.** Introduce a "Surface" concept: plugins register a consumer surface (`wp_abilities_register_consumer`-style); registering auto-generates a WP-Admin UI to pick which abilities are available on that surface; the abilities API can be queried per surface; every MCP server automatically becomes a surface. Full-catalog access remains available.

**Open decisions / blockers.**
- Exact registration API and how surfaces translate to query args (category/namespace/meta) + ecosystem-scoped hooks.
- Overlap with the broader management layer in #348.

**Dependencies.** Abilities API registry filtering for `wp_get_abilities()` (Trac #64990); MCP Adapter; WooCommerce + WebMCP adapters (already built ad-hoc filtering); related to #348.

**Discussion highlights.** gziolo connected this to Trac #64990, whose "Observed need" section documents the exact fragmentation (MCP adapter, WooCommerce, WebMCP adapter all rolling their own filtering). He argued a registered surface should translate into `$args` + per-surface visibility hooks so `wp_get_abilities()` becomes the single query point.

### #425 — Update placement of Alt Text generation buttons (Blocked)
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Good first issue, [Status] Blocked, Help Wanted · **Assignee(s):** — · **Updated:** 2026-05-18 · **Comments:** 6
**Link:** https://github.com/WordPress/ai/issues/425

**Problem / goal.** Move the Alt Text generation button closer to the Alt Text field. On the Edit Media page and Attachment details view, place it just under the "Alternative Text" textarea and remove the redundant standalone Alt Text metabox.

**Proposed approach.** Reposition the button inline beneath the alt-text field in both surfaces and delete the duplicate control. **Blocker:** core exposes no hook to inject content near the Backbone-rendered textarea, so only JS insertion works. Contributors filed core tickets to add proper hooks: **Trac #65086** and **wordpress-develop PR #11748** (action hooks for the media-modal attachment view); once merged, the button renders cleanly.

**Open decisions / blockers.**
- **[Status] Blocked**: awaiting Trac #65086 / wordpress-develop#11748.
- Button copy stays explicit (jeffpaul rejected icon-only/tooltip except in the block toolbar).

**Dependencies.** WordPress core media templates/hooks (Trac #65086, wordpress-develop#11748).

**Discussion highlights.** CacheMeOwside flagged the missing hook; dhruvang21 suggested an AI beaker icon + loading animation; jeffpaul preferred explicit button copy and proposed animating the plugin icon instead; dhruvang21 opened PR #11748.

### #430 — Skills in a WordPress admin context ⭐
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

### #448 — Add WebMCP experiment ⚠️
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

### #625 — New Experiment: Social Content Generation for platform-specific social posts
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design · **Assignee(s):** — · **Updated:** 2026-06-01 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/625

**Problem / goal.** Publishers manually rewrite content per social platform after publishing (tone, formatting, character limits, hashtags, imagery, alt text) — time-consuming and inconsistent at volume. No workflow yet transforms published content into social-ready promotional copy.

**Proposed approach.** A "Social Content Generation" Experiment analyzes a post's title, excerpt, content, and media to generate tailored copy for **Bluesky, Mastodon, and LinkedIn**, accounting for each platform's expectations, plus hashtags and recommended media. Exposed initially via a post-editor "Generate Social Posts" action (review/edit before use). Future: more networks, multiple variations, scheduling, syndication.

**Open decisions / blockers.**
- Which existing social plugins to target so output flows gracefully into their publishing.
- Additional platforms beyond the initial three.

**Dependencies.** AI provider abstractions; optional image-generation/vision; downstream social plugins (Jetpack Social, Blog2Social).

**Discussion highlights.** Contributor Malayt04 volunteered a concrete design: a collapsible "Social Content" sidebar + post-publish prompt; persist to post meta `_wpai_social_content`; checkbox-based per-network generation (only checked networks, individual regeneration) to save tokens; hooks so third-party social plugins can fetch/inject the copy.

### #643 — "AI" plugin 1.0.1: Connectors and AI settings pages load blank (JS error) on WordPress 7.0 ⚠️
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
**Status:** In discussion / Needs decision · **Milestone:** 1.2.0 *(moved Future Release → 1.1.0 2026-06-25 → 1.2.0 2026-06-30)* · **Labels:** [Type] Bug · **Assignee(s):** prasadkarmalkar · **Updated:** 2026-06-23 · **Comments:** 3 · *(board-new, filed 2026-06-17)*
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
**Status:** In discussion / Needs decision · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-26 · **Comments:** 0 · *(board-new, filed 2026-06-26)*
**Link:** https://github.com/WordPress/ai/issues/791

**Problem / goal.** With the Type Ahead experiment now merged (PR #151), the question is whether the native blinking cursor is enough feedback while AI ghost-text is being fetched. The proposal — raised from the #151 review thread — is to explore a loading animation or custom cursor that signals Type Ahead is "waiting/working," rather than leaving the standard cursor.

**Proposed approach.** None committed yet: deliberately gather community feedback on the live Type Ahead experience first, then trial explorations via PRs (loading animation vs. custom cursor) only if usage shows the cue is needed.

**Open decisions / blockers.** Whether any visual cue is warranted at all (vs. keeping the native cursor); which form (animation vs. cursor) reads best without being distracting.

**Dependencies.** Type Ahead experiment (merged PR #151); related follow-up #776 (provider/model overrides + Guidelines).

**Discussion highlights.** Opened by jeffpaul off the #151 review discussion as a "let's watch and see" enhancement; no comments yet.

---

## In progress (19)

*Actively being built. Now dominated by **1.2.0** hardening — most of this section was re-milestoned 1.1.0/Future → **1.2.0** on 2026-06-30 as 1.1.0 wound down to its release checklist — plus a few longer-horizon experiments. **This refresh (2026-07-03):** **#816** (Type-Ahead front-end regression) promoted Triage → In progress (fix PR #820), and board-new **#818** (missing alt text on the AI Home feature card, PR #819) added — both unmilestoned (board Tier ④), joining #809.*

### #191 — Add import/export support for AI settings and provider configuration
**Status:** In progress · **Milestone:** 1.2.0 *(moved Future Release → 1.2.0 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** coderGtm · **Updated:** 2026-06-11 · **Comments:** 7 · *(moved from In discussion / Needs decision, 2026-06-16)*
**Link:** https://github.com/WordPress/ai/issues/191

**Problem / goal.** Provide import/export of AI settings and provider configuration for portability across environments — valuable for agencies, hosts, and multisite. Security and credential handling must be carefully considered.

**Proposed approach.** Consensus: export only **non-sensitive** configuration (no API keys), letting secrets resolve from env vars/host/settings, so the export is a simple unencrypted JSON file reusable across dev/staging/prod. Import: choose file → "Are you sure?" confirmation before applying (a full preview screen deemed overkill for v1). Integrate non-sensitive details into WordPress Site Health export/status checks.

**Open decisions / blockers.** Spec settled to three items: (1) import/export non-sensitive config, (2) Site Health checks, (3) confirm-before-apply import. No remaining blockers; dkotter approved.

**Dependencies.** WordPress Site Health; WP-managed API key storage (keys are managed by WP/AI Client, not the plugin).

**Discussion highlights.** coderGtm (assignee) argued against bundling keys (security + per-env replacement friction); dkotter agreed, endorsed Site Health integration, and preferred a simple confirm dialog over a preview.

### #192 — Add extension points for custom prompt templates
**Status:** In progress · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-22 · **Comments:** 0 · *(moved from Backlog → In progress, 2026-06-25)*
**Link:** https://github.com/WordPress/ai/issues/192

**Problem / goal.** Introduce extension points letting developers define, override, or extend the prompt templates used by experiments — customization without forking. Target: developers.

**Proposed approach.** No specific hook design yet; acceptance: prompt templates extendable/overridable via hooks; scoped and predictable; works across multiple experiments; documented. Implementation now in flight as **PR #770** ("Prompt template extension points").

**Open decisions / blockers.** Specific hook/filter API being defined in PR #770.

**Dependencies.** AI experiment prompt-assembly layer. Enables/complements customization in agentic experiments (#189, #282, #142 "developer mode").

**Discussion highlights.** —

### #203 — Add extensibility hook for custom Ability Table columns
**Status:** In progress · **Milestone:** 1.2.0 *(moved Future Release → 1.2.0 2026-06-30)* · **Labels:** [Type] Enhancement, Help Wanted, [Experiment] Abilities Explorer · **Assignee(s):** — · **Updated:** 2026-05-07 · **Comments:** 1
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

### #307 — Add AGENTS.md to streamline contributor onboarding
**Status:** In progress · **Milestone:** Future Release · **Labels:** — · **Assignee(s):** gziolo · **Updated:** 2026-05-07 · **Comments:** 6
**Link:** https://github.com/WordPress/ai/issues/307

**Problem / goal.** New contributors must stitch together CONTRIBUTING.md, DEVELOPER_GUIDE.md, ARCHITECTURE_OVERVIEW.md, and package.json before coding. Two pain points: no single entry-point/routing file, and non-obvious command conventions (PHP via `wp-env`/npm scripts like `npm run lint:php`, not `composer lint`). gziolo found onboarding via Claude Code slow without a context file.

**Proposed approach.** Add a short `AGENTS.md` (currently gitignored under "AI files" since #172) that routes to the right doc per task and codifies workflow rules — a table-of-contents serving both humans and AI tools, not a duplication.

**Open decisions / blockers.**
- Ship `AGENTS.md` vs. first consolidating/improving existing docs (treated as a prerequisite).
- Committed `AGENTS.md` vs. an `AGENTS.md.example` template.
- Context-poisoning risk: one-time setup info injected into every session regardless of topic.

**Dependencies.** Doc-cleanup issues #225/#308; acknowledged existing-doc "AI slop" tech debt.

**Discussion highlights.** jeffpaul pushed to consolidate docs for both humans and agents, admitting some existing docs are AI slop. justlevine is on record against committing public `AGENTS.md` to WordPress.org properties (Trac #63901), preferring an `*.example`, but softened — after #225 cleans docs, a minimal `AGENTS.md` could give objective benefit; remains opposed to bringing it into wordpress-develop.

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

### #452 — Content Classification: Improve relevance of taxonomy suggestions
**Status:** In progress · **Milestone:** 1.2.0 *(moved 1.1.0 → 1.2.0 2026-06-30)* · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** — · **Updated:** 2026-06-16 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/452

**Problem / goal.** Category/tag suggestions from the Content Classification experiment are frequently irrelevant. Surfaced via Miriam Schwab (Elementor) feedback. As dkotter notes, this is one of the newest experiments and likely the first feedback, so there's room to adjust. Goal: improve real-world relevance and use the issue as a running feedback collector.

**Proposed approach.** Audit the classification prompt and explore built-in tuning/prompt improvements. saarnilauri opened a PR proposing a fix.

**Open decisions / blockers.** Pending review of the proposed PR.

**Dependencies.** —

**Discussion highlights.** Feedback from Elementor's Miriam Schwab; dkotter framed it as early, expected feedback; saarnilauri offered a candidate fix.

### #514 — Add comment value / relevance to Comment Moderation experiment
**Status:** In progress · **Milestone:** 1.2.0 *(moved Future Release → 1.2.0 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** dkotter · **Updated:** 2026-05-07 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/514

**Problem / goal.** The Comment Moderation experiment (PR #155) introduced sentiment/toxicity analysis with extensibility hooks. Review discussion surfaced interest in evaluating a comment's overall **value/relevance** — spammy/engagement-bait, off-topic, generic "thanks"/"+1"/low-context comments — to help prioritize moderation and surface high-quality discussion.

**Proposed approach.** Extend Comment Moderation with a "Comment Value / Relevance" analysis on the existing pipeline: store a normalized score; add a Comments-screen column + Activity dashboard pill; allow bulk processing; optionally flag low-value comments; provide filters/hooks for custom scoring and thresholds.

**Open decisions / blockers.** Existing hooks cover system instructions + response schema, but additional JS extensibility may be needed for the full admin experience.

**Dependencies.** Comment Moderation experiment / PR #155 (analysis pipeline, system-instruction and response-schema hooks).

**Discussion highlights.** —

### #600 — `Enable AI` header toggle doesn't reflect aggregate state of sub-features
**Status:** In progress · **Milestone:** 1.2.0 *(moved 1.1.0 → 1.2.0 2026-06-30)* · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-06-16 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/600

**Problem / goal.** The header `Enable AI` toggle is binary and misrepresents partial configuration: when only some sub-features are enabled it still renders fully ON (solid blue), indistinguishable from all-enabled. Repro: enable only a subset (e.g. Alt Text + Meta Description) → header still shows full ON. (WP 7.1, AI 1.0, Safari, block theme.)

**Proposed approach.** **A** — tri-state header toggle (Off / Partial / On); **B (preferred)** — drop the global header toggle and give each section its own master tri-state toggle scoped to that section, pairing with Enable all / Disable all, scaling as experiment groups grow.

**Open decisions / blockers.**
- Choose A vs B (B preferred).
- gziolo: toggle is confusing ("why install AI to disable AI?") — reflect "AI enabled" state or rename to "Disable AI".
- dkotter: ideally distinguish disabling AI features while non-AI features (Abilities Explorer, Request Logging, Connector Approval) stay on.

**Dependencies.** —

**Discussion highlights.** dkotter explains the toggle is a quick exit path (disliked results, rate/usage thresholds) but concedes manual disable or plugin deactivation is comparable effort. An off-topic comment was triaged out by jeffpaul.

### #614 — Add support for bulk summary generation
**Status:** In progress · **Milestone:** 1.2.0 *(moved Future Release → 1.2.0 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 6
**Link:** https://github.com/WordPress/ai/issues/614

**Problem / goal.** Content Summarization is only reachable from the post-editor panel, making it tedious to summarize many existing posts (each requires opening the editor). Goal: summarize multiple posts at once.

**Proposed approach.** Add a "generate summary" action to the Bulk Actions dropdown on `/wp-admin/edit.php`, saving the summary to post content and post meta. prasadkarmalkar built a POC (screencast) and planned a draft PR; existing summaries are regenerated/replaced. jeffpaul suggested pairing the bulk option with a **WP-CLI command** and noted other experiments may warrant similar bulk+CLI support.

**Open decisions / blockers.**
- Concern (coderGtm): AI "slop" risk and ballooning costs at scale; but valuable as a standardized bulk-AI pattern.
- Regeneration policy: POC regenerates every post (including ones with existing summaries) rather than skipping.

**Dependencies.** — (plugin doubles as a reference implementation; standardized bulk-AI approach seen as valuable.)

**Discussion highlights.** Bulk + CLI pairing favored; regenerate-all confirmed by prasadkarmalkar. justin-jiajia later nudged the draft PR toward review-readiness.

### #660 — UX: Ambiguous error message when a provider is blocked by Connector Approvals
**Status:** In progress · **Milestone:** 1.2.0 · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-11 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/660

**Problem / goal.** When an AI request (e.g., title generation) is blocked by Connector Approvals, the editor error ("Please ensure you have a connected provider that supports text generation") wrongly implies invalid keys / failed connection / unsupported model — when the provider is connected but awaiting administrator authorization.

**Proposed approach.** Make the error context-aware: state the connector is pending authorization and link to the approval page (`/wp-admin/tools.php?page=connector-approvals`). Suggested copy provided; before/after screenshots included.

**Open decisions / blockers.** —

**Dependencies.** Connector Approvals feature; WP 7.0/Gutenberg editor; reproduced with AI Provider for Google.

**Discussion highlights.** —

### #689 — Add a user-facing control for automatic log cleanup
**Status:** In progress · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** i-anubhav-anand · **Updated:** 2026-06-18 · **Comments:** 7 · *(moved from Triage, 2026-06-16)*
**Link:** https://github.com/WordPress/ai/issues/689

**Problem / goal.** There's no admin-UI way to configure automatic log cleanup for AI Request Logs; the only mechanism is a manually-added PHP filter. Today users can only keep everything forever or hit "Purge" and lose all logs at once.

**Proposed approach.** The original idea was an automatic retention-period setting (7 / 30 / 90 days, or forever). Discussion has shifted toward a **manual, user-initiated** cleanup control: replace "Purge All Logs" with a dropdown for Older than 30 / 90 / 365 days / All logs plus a Delete button and confirmation flow. No cron, no persistent retention policy.

**Open decisions / blockers.**
- Needs review of the manual cleanup UX/API in PR #735.
- Automatic retention remains disfavored for now: long-term logs are useful for month/year usage comparison, and the product direction avoids surfacing developer-style controls by default.

**Dependencies.** AI Request Logs feature; prior Request Logging PR (source of removed retention code).

**Discussion highlights.** Core tension: product simplicity / hide-developer-controls vs. discoverability. The compromise converged on a manual "delete older than" action; i-anubhav-anand picked it up and opened PR #735.

### #732 — AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible
**Status:** In progress · **Milestone:** 1.2.0 *(moved Future Release → 1.2.0 2026-06-30)* · **Labels:** Help Wanted · **Assignee(s):** — · **Updated:** 2026-06-18 · **Comments:** 0 · *(board-new, filed 2026-06-15; moved Backlog → In progress 2026-06-25, draft PR #757)*
**Link:** https://github.com/WordPress/ai/issues/732

**Problem / goal.** The AI Request Logging experiment taps requests by decorating the SDK's HTTP transporter, so a request is logged **iff** it flows through `HttpTransporter::send()`. Any provider that performs its own HTTP — rather than routing generation through `AiClient`'s transporter — is therefore never logged, despite being a first-class provider reachable via `wp_ai_client_prompt()` and listed in Connectors. The Request Log silently under-reports, which is surprising for something presented as a log of *every* AI request.

**Root cause.** `Logging_Integration::wrap_transporter()` swaps in a `Logging_Http_Transporter` decorator (`includes/Logging/Logging_Integration.php`), and logging lives entirely inside that decorator's `send()`. Provider attribution compounds the gap: `Log_Data_Extractor::detect_provider()` infers the provider from the request **host**, so a provider talking to `127.0.0.1` couldn't be attributed even if its request were seen.

**Proposed approach.** Add a **provider-agnostic fallback** alongside the transporter decorator — also listen to the core generation events, which fire for every provider regardless of transport: `wp_ai_client_before_generate_result` / `wp_ai_client_after_generate_result` (bridged from the SDK's `BeforeGenerateResultEvent` / `AfterGenerateResultEvent`). The after-event exposes everything a row needs — provider (`providerMetadata()->getId()`), model, token usage (`getResult()->getTokenUsage()`), and duration (before → after). To avoid double-logging transporter-based providers (which fire the event *and* pass through the decorator), the listener writes only when the transporter didn't already log the current generation (a flag reset in the before-event, set by `Logging_Http_Transporter::send()`).

**Open decisions / blockers.**
- **Known limitation:** the SDK's after-event fires on **success only** (no error event), so the fallback captures successful non-transporter generations but not failed ones — failed custom-transport generations stay a separate gap needing an SDK-level error event.
- Alternatives rejected: provider-side logging (couples every provider to `AI_Request_Log_Manager` internals — the reporter's current stopgap); hooking `pre_http_request` (too broad/noisy, can't reliably attribute the provider).

**Dependencies.** AI Request Logging experiment (`Logging_Integration`, `Logging_Http_Transporter`, `Log_Data_Extractor`, `AI_Request_Log_Manager`); WP AI Client generation events / SDK `Before`/`AfterGenerateResultEvent`. Prior art: #680 (thinking-token undercount — same "logger misses data" spirit).

**Discussion highlights.** — (no comments yet. Filed by henryperkins with a code-level root cause + proposed fix, motivated by a real third-party `codex` provider that brokers requests through a localhost sidecar for ChatGPT-managed auth and is entirely absent from the log; 1 👀.)

### #736 — Expose role/user access controls per feature/experiment
**Status:** In progress · **Milestone:** 1.2.0 *(moved Future Release → 1.2.0 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-19 · **Comments:** 3 · *(moved from Backlog → In progress, 2026-06-20; board-new 2026-06-16)*
**Link:** https://github.com/WordPress/ai/issues/736

**Problem / goal.** Site owners with many editors have no way to limit AI features to specific roles or users — there are no AI-related capabilities exposed in the role-editor screens. Originates from a wordpress.org support request ("limit-use-to-certain-roles"). Goal: let admins fine-tune which roles/users can access each feature/experiment.

**Proposed approach.** Mirror the existing per-experiment provider/model selection in the top-right ellipses menu: add a **role-and-user multi-select** there so admins can scope each feature/experiment to chosen roles or specific users, defaulting to the set of roles the plugin already supports (possibly hard-coded as the default).

**Open decisions / blockers.**
- How to show unsaved changes and confirmation: dkotter wants a Save button and snackbar notice similar to individual Feature settings.
- Role selector UI: multi-select works, but checkboxes may be clearer when admins do not know exact role names.
- Default role set remains TBD.

**Dependencies.** Per-experiment settings UI (the provider/model ellipses menu); WP roles/capabilities. Governance-cluster sibling to the unified management layer (#348) and per-surface exposure controls (#354) — at feature/experiment granularity.

**Discussion highlights.** Infinite-Null shared an initial implementation and demo with per-feature role/user controls in AI settings, now open as **draft PR #749** (+893/−106, 18 files). dkotter said the direction looked correct and requested save-state UX, snackbar feedback, and possibly checkboxes for roles.

### #690 — Plugin does not clean up database table and options on uninstall
**Status:** In progress · **Milestone:** 1.2.0 *(moved Needs review → In progress, 1.1.0 → 1.2.0, 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** hbhalodia · **Updated:** 2026-06-16 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/690

**Problem / goal.** On deletion the plugin leaves behind its custom table `wp_wpai_request_logs` and all `wpai_*` options permanently — there's no `uninstall.php` or `register_uninstall_hook()`. Because the log table stores request/response previews of user content and AI outputs, this raises **privacy** concerns and violates plugin-directory guidelines requiring data cleanup. Leftover options enumerated (e.g. `wpai_features_enabled`, `wpai_feature_{id}_enabled`, `wpai_version`, `wpai_connector_approvals`, `wpai_request_logs_schema_version`).

**Proposed approach.** Add `uninstall.php` dropping the custom table and removing all `wpai_*` options. Add a "Remove all data on uninstall" checkbox (unchecked by default) so users opt in. Cleanup runs on **uninstall only**, not deactivation.

**Open decisions / blockers.** — (implementation submitted; status moved back Needs review → In progress as review feedback is addressed).

**Dependencies.** WP plugin uninstall-methods guidelines; the Request Logs table/options schema. Implemented in **PR #692**.

**Discussion highlights.** hbhalodia reports the fix is ready for review as **PR #692**.

### #778 — E2E: Prefer user-facing attributes
**Status:** In progress · **Milestone:** 1.2.0 · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-06-30 · **Comments:** 3 · *(board-new, filed 2026-06-30)*
**Link:** https://github.com/WordPress/ai/issues/778

**Problem / goal.** Some Playwright E2E tests locate elements via CSS classes / DOM structure, which can break under design or refactoring changes even when the user experience is unchanged. Playwright recommends user-facing locators (`getByRole`, etc.) that reflect how users and assistive technology actually interact with the UI.

**Proposed approach.** A tracker issue: replace brittle class/structure-based locators with role-based, user-facing locators across the E2E suite where it makes sense (e.g. `page.getByRole( 'tab', { name: 'Post' } )`), with related PRs linked from the issue body as each spec is migrated (Content Summarization, Excerpt Generation, Content Classification, …).

**Open decisions / blockers.** Per-spec scope and which locators have a genuine user-facing equivalent; coordinating the several contributors each taking an individual spec.

**Dependencies.** The Playwright E2E suite; mirrors the approach already used in specs #762 / #773.

**Discussion highlights.** Contributors are self-assigning individual experiment specs (Infinite-Null on Excerpt Generation; hasanmehmood on Content Classification, following the #762/#773 pattern); yogeshbhutkar is coordinating reviews.

### #809 — Enhancement/Fix: Content Summarization block found inside nested blocks
**Status:** In progress · **Milestone:** — · **Labels:** — · **Assignee(s):** Intenzi · **Updated:** 2026-07-01 · **Comments:** 0 · *(board-new, filed 2026-07-01)*
**Link:** https://github.com/WordPress/ai/issues/809

**Problem / goal.** The Content Summarization experiment inserts an `ai-generated-summary` group block and, on "Regenerate Summary", tries to find and modify that block in place. But it only scans **top-level** blocks (`allBlocks.find( block => block.name === 'core/group' && block.attributes.aiGeneratedSummary === true )`), so if the summary was moved inside a nested container (Group/Column — a common layout), it isn't found and a **second** summary block is inserted instead of updating the existing one.

**Proposed approach.** Recurse into `innerBlocks` when detecting the existing summary group so regeneration updates the block wherever it sits in the tree.

**Open decisions / blockers.** —

**Dependencies.** The Content Summarization experiment's block-detection logic. Fix in flight as off-board **PR #810** ("Enhance Content Summary block detection to nested blocks", *Closes #809*, by Intenzi). Unmilestoned (board Tier ④).

**Discussion highlights.** Filed by Intenzi with the offending code snippet; PR #810 opened the same day.

### #816 — Type-Ahead experiment loads wp-editor on the front end, intermittently breaking WooCommerce block checkout ⚠️
**Status:** In progress *(moved Triage → In progress, 2026-07-03)* · **Milestone:** — · **Labels:** — · **Assignee(s):** — · **Updated:** 2026-07-02 · **Comments:** 0 · *(board-new, filed 2026-07-01; post-1.1.0 regression)*
**Link:** https://github.com/WordPress/ai/issues/816

**Problem / goal.** The **Type Ahead** experiment (shipped in v1.1.0) registers its assets on `enqueue_block_assets`, which fires on the **front end** as well as in the editor, with no `is_admin()` guard (`includes/Experiments/Type_Ahead/Type_Ahead.php` L70–73). The built `experiments/type-ahead` script declares `wp-editor` as a dependency, so every front-end page load pulls in the entire block-editor stack (`editor.min.js` + ~20 dependency scripts) and — critically — registers the `core/editor` data store on the front end.

**Impact.** WooCommerce's Store API cart resolver decides "am I in the editor?" via `!! select( 'core/editor' )`; with `core/editor` now present publicly, that check misfires and **intermittently corrupts block-based checkout** (reproduced on the sample Beanie/Cap cart). It is also a needless performance hit — the full editor bundle loads on every public page.

**Proposed approach.** Guard Type Ahead asset registration with `is_admin()` (or an editor-only hook), and/or drop the `wp-editor` dependency from the front-end build so `core/editor` isn't registered publicly.

**Open decisions / blockers.** Whether it warrants a **1.1.1 patch** since it affects a shipped release. A fix is now in flight as off-board **PR #820** ("feat: update Type Ahead experiment implementation").

**Dependencies.** The Type Ahead experiment (PR #151, shipped 1.1.0); its `enqueue_block_assets` hook and generated `type-ahead.asset.php` dependency list. Interacts with WooCommerce's Store API cart resolver. Related E2E-selector refactor in PR #817. Unmilestoned (board Tier ④).

**Discussion highlights.** Filed by xuanji86 with source-line references (`Type_Ahead.php` L70–73) and the WooCommerce cross-reference — a clear code-level root cause. Moved off Triage into active work with PR #820. See also planned-work Data-quality flag #11.

### #818 — Missing alt text on feature card image in AI Home stage
**Status:** In progress · **Milestone:** — · **Labels:** [Type] Bug · **Assignee(s):** — · **Updated:** 2026-07-02 · **Comments:** 0 · *(board-new, filed 2026-07-02)*
**Link:** https://github.com/WordPress/ai/issues/818

**Problem / goal.** The feature-card image in `routes/ai-home/stage.tsx` (L659) renders with an empty `alt` attribute — `<img alt="" loading="lazy" src={ feature.image } />`. Because the image conveys meaningful content (it illustrates the feature the card represents), the empty `alt` makes it inaccessible to screen-reader users and **fails WCAG 1.1.1 (Non-text Content)**.

**Proposed approach.** Populate `alt` with a descriptive value derived from the feature — e.g. `alt={ feature.label }`.

**Open decisions / blockers.** —

**Dependencies.** The AI Home stage component. Fix in flight as off-board **PR #819** ("Fix image ALT text issue"). Unmilestoned (board Tier ④). Part of the same 2026-07-03 wave of a11y/E2E hardening as the ARIA-selector refactors (#817, #828).

**Discussion highlights.** Filed with a code-line reference (`stage.tsx` L659), a screenshot, and reproduction steps (Settings → AI → inspect the image) on WordPress 7.0 / Chrome.

---

## Backlog (7)

*Planned, not yet started. The new-experiment proposals and the agentic/site-agent direction concentrate here. (#192 and #732 were promoted to In progress on 2026-06-25; #190 moved to To do on 2026-07-02.)*

### #142 — Frontend chat agent powered by site content ⭐
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Needs Design · **Assignee(s):** — · **Updated:** 2025-12-08 · **Comments:** 0
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

### #189 — Explore an admin Site Agent for executing WordPress actions ⭐
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-01-17 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/189

**Problem / goal.** Explore a conversational Site Agent letting administrators perform WordPress actions through natural-language prompts — creating posts, installing plugins, updating settings, exporting content. Targets admins who want to operate by intent rather than navigating UI.

**Proposed approach.** Map natural-language prompts to explicit, verifiable WordPress actions, designed with strong security, permissions, and auditability from the start; may gate behind filters/flags. Acceptance: prompts map to explicit verifiable actions; all actions respect roles/capabilities; execution is transparent and auditable; opt-in and disabled by default.

**Open decisions / blockers.**
- Whether to gate behind filters/flags.
- No design or technical mechanism specified yet (high-level exploration).

**Dependencies.** WP capabilities/roles; an action-execution + audit layer. Related to the AI Workspace (#282) middleware/tools model and prompt extensibility (#192).

**Discussion highlights.** —

### #193 — Add developer-only log panel for inspecting AI provider responses
**Status:** Backlog · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-01-17 · **Comments:** 0
**Link:** https://github.com/WordPress/ai/issues/193

**Problem / goal.** Developers debugging AI features have no way to inspect raw request/response payloads. Proposes a developer-only log panel for deep inspection, building on the AI Request Logs feature but oriented to low-level debugging rather than usage tracking.

**Proposed approach.** A permission-gated panel, disabled by default, surfacing raw request/response data. Acceptance: raw data viewable by authorized users; clearly marked developer-only; sensitive data handled responsibly; logging toggleable.

**Open decisions / blockers.** —

**Dependencies.** Builds on existing observability / request-logging work.

**Discussion highlights.** —

### #282 — Chat experiment: Integration outside the editor and outside single-task AI use ⭐
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

### #297 — New experiment: Content Generation ⭐
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

## To do (8)

*Planned and queued; concrete enough to start.*

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
**Status:** To do · **Milestone:** Future Release *(moved Backlog → To do, 2026-07-02)* · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-17 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/190

**Problem / goal.** Explore AI insights analyzing content across the whole site — themes, gaps, trends, opportunities. Distinct from editor-level assistance; for site owners/editors planning strategy. Experimental; avoids automated changes.

**Proposed approach.** Early concept: introduce insight verticals based on post metadata, trading some precision for lower context size. First iteration may stay synchronous, persist the latest run, and start with a smaller subset of insight verticals before expanding.

**Open decisions / blockers.**
- Which insight verticals make the v1 cut (current mockup may include too many).
- How much metadata/context is enough to produce useful insights without excessive cost.
- Admin presentation details and performance/cost approach still need documentation.

**Dependencies.** WP AI Client; multi-post/content-type querying. Overlaps the "Strategic Content Planning"/"Site Querying" use cases of #282; could share its RAG-lite retrieval.

**Discussion highlights.** yogeshbhutkar shared a high-fidelity mockup and proposed metadata-driven insight verticals. dkotter liked the concept and design direction, while noting usefulness needs validation and v1 should probably trim the number of insight types.

### #233 — Refactor experiments to leverage AI_Service layer
**Status:** To do · **Milestone:** Future Release · **Labels:** [Type] Enhancement, Help Wanted, + 6 [Experiment] labels · **Assignee(s):** — · **Updated:** 2026-04-23 · **Comments:** 1
**Link:** https://github.com/WordPress/ai/issues/233

**Problem / goal.** With #101 merged in 0.2.1 (introducing the shared `AI_Service` layer), the existing Experiments should be refactored to route through it for consistency, rather than each calling the AI client independently.

**Proposed approach.** Checklist to migrate each experiment onto `AI_Service`: Abilities Explorer, Alt Text, Content Summarization, Excerpt, Image, Title.

**Open decisions / blockers.**
- Whether to keep `AI_Service` at all: jeffpaul questioned whether, since it isn't used by newer experiments/PRs, it should instead be refactored **out** as a breaking change before WP 7.0.

**Dependencies.** #101 (AI_Service, shipped 0.2.1); the six tagged experiments.

**Discussion highlights.** Only comment is jeffpaul raising the strategic doubt — flipping the issue from "adopt the layer everywhere" to "possibly remove the layer." Direction unresolved.

### #339 — AI 0.6 + WP7RC1 + Gutenberg 22.7.1: can't keep connection alive within the AI plugin
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

### #421 — WordPress should detect C2PA manifests on upload
**Status:** To do · **Milestone:** 1.2.0 (due 2026-07-30) · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** — · **Updated:** 2026-05-19 · **Comments:** 2
**Link:** https://github.com/WordPress/ai/issues/421

**Problem / goal.** WP extracts EXIF/IPTC/partial XMP at upload via `wp_read_image_metadata()` but doesn't detect **C2PA Content Credentials**. C2PA manifests now ship from AI generators (DALL-E 3, Firefly, Gemini, Copilot), cameras (Pixel, Galaxy S25, Leica, Sony, Nikon), and providers (Cloudflare Images), carrying machine-readable provenance. WP's GD/Imagick pipeline destroys manifests during subsize generation, so the only read window is at upload, before processing.

**Proposed approach.** A read-only experiment via `Abstract_Feature`, toggleable. At upload it hooks the attachment pipeline, reads the original via `wp_get_original_image_path()`, and captures a structured postmeta record (`_wpai_monitor_record`): curated EXIF/IPTC/XMP; C2PA presence (JPEG APP11, PNG `caBX`, WebP RIFF `C2PA`); and a C2PA claim summary (claim generator, digital source type, action history) decoded from the JUMBF manifest store. Introduces shared **JUMBF box-reading + CBOR-decoding** utilities (none exist today), reusable by other C2PA experiments (ref #294).

**Open decisions / blockers.**
- Constraints: read-only; fail-open (upload always succeeds); no external deps/HTTP; <500ms median on <15MB images.
- Out of scope: signing/verification, preserving manifests through processing, display UI.
- Display UI / `cr` overlay deferred (requires passing C2PA conformance first).

**Dependencies.** WP attachment pipeline; new JUMBF + CBOR utilities; reference implementations in #294.

**Discussion highlights.** jeffpaul wants a fast-follow adding display UI with the `cr` overlay. lukenispel: reading/storing/displaying is straightforward, but the CR icon needs a conformant validator/generator first; offered to draft the display work, gated on conformance.

### #507 — Iterate on Editorial Updates end flow to Visual Revisions
**Status:** To do · **Milestone:** 1.2.0 *(moved 1.1.0 → 1.2.0 2026-06-30)* · **Labels:** [Type] Enhancement, Help Wanted · **Assignee(s):** zeus2611 · **Updated:** 2026-06-30 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/507

**Problem / goal.** At the end of the "Refine from Notes"/Editorial Updates flow, a toast links to the **legacy** revisions screen. Since the plugin requires WP 7.0, it should instead point to the new **Visual Revisions** screen, improving the AI-applied-changes review experience.

**Proposed approach.** Keep the existing revision lookup and `getRevisionReviewAction()` helper shape. Branch the toast action: if `disableVisualRevisions` is false, dispatch `editorStore.setCurrentRevisionId(lastRevisionId)` to open the visual path; otherwise keep the legacy `revision.php?revision=...` fallback.

**Open decisions / blockers.**
- The visual path depends on a private-but-stable WP 7.0 editor-store action rather than a public URL.
- Need to gate correctly on `disableVisualRevisions`.

**Dependencies.** WP 7.0 core Visual Revisions; existing Editorial Updates revision lookup in `useEditorialUpdates.ts`; editor store `setCurrentRevisionId`.

**Discussion highlights.** zeus2611 originally waited for WP 7 to finalize. kiranmagic7 mapped the current source path, and zeus2611 agreed to use `setCurrentRevisionId(lastRevisionId)` behind the `disableVisualRevisions: false` gate instead of waiting for a public URL.

### #793 — New Developer Tool: Customize experiments
**Status:** To do · **Milestone:** 1.2.0 · **Labels:** [Type] Enhancement · **Assignee(s):** — · **Updated:** 2026-06-26 · **Comments:** 0 · *(board-new, filed 2026-06-26)*
**Link:** https://github.com/WordPress/ai/issues/793

**Problem / goal.** The AI plugin targets non-technical site owners, yet enabling some experiments immediately surfaces advanced settings (e.g. Content Classification's taxonomy strategy + maximum suggestions), adding cognitive load — "turn it on" becomes "turn it on and then figure out what these settings mean." The proposal adds a **"Customize experiments"** option under the Developer Tools menu (the ⋮ in the AI settings header) to keep advanced per-experiment settings hidden by default.

**Proposed approach.** Add a Developer Tools toggle "Customize experiments" (description: "Show additional settings for experiments"), **disabled by default**. When off, hide advanced settings such as Content Classification's taxonomy strategy / maximum suggestions and the Type Ahead extras (re-surfacing the Type Ahead settings noted in the #151 discussion); when on, expose them. Title TBD — jeffpaul is unsure about "Customize experiments" and invites alternatives.

**Open decisions / blockers.**
- Final option label/description.
- Exactly which per-experiment settings move behind the toggle vs. stay visible by default.

**Dependencies.** The AI settings page Developer Tools (⋮) menu; Content Classification and Type Ahead settings UIs; relates to Type Ahead settings from PR #151.

**Discussion highlights.** Filed by jeffpaul with annotated screenshots; no comments yet.

### #815 — Connector Approvals doesn't immediately flag need to grant AI plugin access to a provider
**Status:** To do · **Milestone:** 1.2.0 · **Labels:** [Type] Bug, Help Wanted · **Assignee(s):** — · **Updated:** 2026-07-01 · **Comments:** 0 · *(board-new, filed 2026-07-01)*
**Link:** https://github.com/WordPress/ai/issues/815

**Problem / goal.** Originally reported on the WPORG support forum ("Enabling Experimental Features Breaks Open AI Connector"). When Connector Approvals is first enabled, **no admin notice** tells the user they must approve the AI plugin's access to a connected provider plugin. The gap only surfaces later as a "no available connector" error when they try to use an AI feature — after which the notice does appear. Lightly related to #660 (ambiguous "blocked by Connector Approvals" editor error).

**Proposed approach.** Surface the "grant the AI plugin access to your provider(s)" admin notice immediately on enabling Connector Approvals, rather than only after a failed generation.

**Open decisions / blockers.** —

**Dependencies.** The Connector Approvals flow and its admin-notice logic; overlaps #660.

**Discussion highlights.** Filed by jeffpaul from a WPORG support report (@vfontjr); no comments yet.

---

## Triage (1)

*Newly arrived / unsorted: just the foundational Core Abilities platform issue. (Board-new #816, the Type Ahead front-end regression, moved Triage → In progress on 2026-07-03 — its dossier is now in [In progress](#in-progress-19).)*

### #40 — WordPress Core Abilities ⭐
**Status:** Triage · **Milestone:** Future Release · **Labels:** [Type] Enhancement · **Assignee(s):** gziolo, jorgefilipecosta · **Updated:** 2026-05-07 · **Comments:** 37
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

---

## Needs review (2)

*Implementation submitted; PR open and awaiting review.*

### #187 — Support multilingual rewriting and translation via AI
**Status:** Needs review · **Milestone:** 1.2.0 *(moved In progress → Needs review, Future Release → 1.2.0, 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** yogeshbhutkar · **Updated:** 2026-06-26 · **Comments:** 4
**Link:** https://github.com/WordPress/ai/issues/187

**Problem / goal.** Explore AI-powered translation and multilingual rewriting for post content — translating between languages or rewriting to a specific language variant.

**Proposed approach.** Evaluate as an experiment that coexists with WordPress i18n practices, aligning with Gutenberg's Multilingual phase 4. Acceptance: AI translate/rewrite between languages; explicit user-controlled language selection; clear separation from core i18n tooling; opt-in and non-destructive. Early implementation direction moved from block-level translation toward **full-article translation** using batch processing similar to Editorial Notes.

**Open decisions / blockers.**
- Full-article translation vs. block-level translation (current feedback favors full article first).
- Whether translation belongs inside the existing Content Resizing/Rephrase feature or as a separate experiment.

**Dependencies.** WordPress i18n practices/tooling; Gutenberg Multilingual phase 4. Now advanced to Needs review via draft **PR #747** ("Add AI-Powered Content Translation").

**Discussion highlights.** yogeshbhutkar shared a working PoC. dkotter questioned the block-level use case and suggested starting with full-article translation or folding block translation into Content Resizing. yogeshbhutkar refactored toward full-article, batch-style processing and opened PR #747 for review.

### #508 — New Experiment: "Suggest Reply" for Comments and Activity widget
**Status:** Needs review · **Milestone:** 1.2.0 *(moved In progress → Needs review, Future Release → 1.2.0, 2026-06-30)* · **Labels:** [Type] Enhancement · **Assignee(s):** dkotter · **Updated:** 2026-06-30 · **Comments:** 4 · *(moved from Backlog, 2026-06-16)*
**Link:** https://github.com/WordPress/ai/issues/508

**Problem / goal.** #155 removed the "Reply with AI" action from the Comments screen over UX/placement concerns, yet moderators/editors still benefit from assisted replies — especially when responses should align with Guidelines, post context matters, and tone/consistency matter.

**Proposed approach.** A new Experiment adding a "Suggest reply" capability integrated into the Comments screen (row action/inline UI) and the Activity dashboard widget. Generates a suggested response from the comment content, associated post content, and Guidelines; lets users review/insert/edit before replying (**not** automated reply); includes "Regenerate reply."

**Open decisions / blockers.**
- Tone selection should occur **before** generation (avoid an extra request).
- Whether other pre-generation options are wanted in the modal.

**Dependencies.** Guidelines layer; post content context; supersedes the removed #155 action. Implemented in **PR #724** (now Needs review).

**Discussion highlights.** Infinite-Null built a POC (video) for the Comments-screen row action, generating from comment + post title + Guidelines; volunteered to implement. dkotter approved the direction but asked the modal open first, letting the user set Tone, then click Generate. Infinite-Null updated the flow accordingly and opened PR #724 for review, adding pre-generation Tone, a Guidelines field, and UI polish.

---

## Recently board-Done (since the 2026-06-15 snapshot)

*Closed or moved to board-Done after the snapshot — retained for reference, not counted in the open totals above. **v1.1.0 shipped 2026-07-01**, so the 1.1.0-milestone items below are now in a public release (#699 shipped earlier, in 1.0.2). The 2026-07-02 refresh added **#197** and **#805** here (16 retained). **2026-07-03:** five of these — **#390/#391/#571/#578/#678** — were de-carded from Project #240 (along with #589 and the 1.0.2 release-tracker #727, which were never dossiered here); they remain closed/shipped and are kept below purely as reference.*

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

### #805 — Release version 1.1.0
**Status:** Done · **Milestone:** 1.1.0 · **Labels:** — · **Assignee(s):** dkotter, jeffpaul · **Updated:** 2026-07-01 · **Comments:** 0 · *(board-Done / closed 2026-07-01 — release cut)*
**Link:** https://github.com/WordPress/ai/issues/805

**Problem / goal.** The release-tracking checklist for **v1.1.0**: pre-release PR review/merge-or-punt decisions plus the standard steps (cut `release/1.1.0` from `develop`, bump `WPAI_VERSION` in `ai.php` + `readme.txt`, update `@since`/changelogs/CREDITS/`.gitattributes`).

**Resolution / retained context.** **v1.1.0 shipped 2026-07-01** (17th release) and the tracker closed board-Done. The last gating PR — #560 (Connector key encryption) — merged 2026-06-30; #739 (`core/read-content`) and #798/#799 (global-toggle / credential gating) were punted off the release. Filed and driven by dkotter + jeffpaul; the release beat its original 2026-07-30 target by roughly four weeks.

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

**Changelog**

| Date | Change |
|---|---|
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
