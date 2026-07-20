# WordPress AI — Planned (Not-Yet-Shipped) Work

> The **delivery plan** for every Project #240 card not in Done. It includes issue cards and board-tracked PRs, ordered by milestone. ⚠️ **Scope caveat:** `WordPress/ai` has **37 open PRs**, while Project #240 has PR cards for only 16 of them; see [Board vs. repo](#board-vs-repo-pr-coverage-five-classifications). Full census-only tracking for `WordPress/php-ai-client` and `WordPress/mcp-adapter` appears below and does not expand Project #240 scope.
>
> Part of a 4-doc set: [`wordpress-ai-roadmap.md`](./wordpress-ai-roadmap.md) (strategy + tracker) · [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md) (issue dossiers) · [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md) (upstream dependencies + repository radar) · **this file** (release-ordered delivery plan + PR census).
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-20 (board + live PR/release checks) |
> | **Scope** | **74 non-Done cards** = 57 open issues + 16 open board-tracked PRs + stale merged PR #484 |
> | **Latest shipped** | **v1.2.0** (2026-07-14; 18th release) |
> | **Repository radar** | `WordPress/php-ai-client`: **20** open PRs / **1.4.0** · `WordPress/mcp-adapter`: **12** / **v0.5.0** (census-only; no Project #240 coverage gate) |
> | **Active / next** | **v1.3.0:** 22 open (14 issues + 8 PRs) · **v1.4.0:** 4 discussion-stage issues · **Future Release:** 43 open |
> | **For issue detail** | See the [open-issues dossier](./wordpress-ai-open-issues.md). |

## How "planned" is tracked here

This file mirrors **board status**, not a promise that every card will ship. "Done" is excluded; all other statuses are included and grouped by milestone.

### Commitment ladder (74 non-Done cards)

| Tier | Cards | Interpretation |
|---|---:|---|
| **v1.3.0** | **22** | Active delivery lane: 14 issues + 8 PRs |
| **v1.4.0** | **4** | Next lane; all four issues remain In discussion |
| **Future Release** | **43** | Unscheduled backlog: 35 issues + 8 PRs |
| **1.2.0 residual** | **1** | Google-provider issue #23 remains board-open after the plugin release shipped |
| **Unmilestoned** | **3** | Triage bugs #869/#874 plus In-progress Abilities Explorer enhancement #883 |
| **Stale shipped-milestone card** | **1** | PR #484 is merged but still board-Needs review under 0.9.0 |

### Delivery readiness at a glance

| Board status | Cards |
|---|---:|
| In progress | **26** |
| Needs review | **7** |
| Backlog | **8** |
| To do | **6** |
| Triage | **3** |
| In discussion / Needs decision | **24** |

> "In discussion" is directional, not committed. The board's active implementation signal is the combination of In progress/Needs review cards and the live repository PR census.

---

## 🚀 New experiments & features in the pipeline

### Code already in flight (16 open board-tracked PRs)

| PR | Milestone | Board status | Live readiness (draft · review · merge · checks) |
|---|---|---|---|
| [#211](https://github.com/WordPress/ai/pull/211) Add Service Account experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks FAILURE |
| [#224](https://github.com/WordPress/ai/pull/224) Add WebMCP adapter experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks SUCCESS |
| [#459](https://github.com/WordPress/ai/pull/459) Add C2PA Monitor experiment | 1.3.0 | In progress | review CHANGES_REQUESTED · merge BLOCKED · checks SUCCESS |
| [#494](https://github.com/WordPress/ai/pull/494) [Feature]: Issue 238 \| Focus-aware crop suggestions | Future Release | In progress | review — · merge DIRTY · checks SUCCESS |
| [#621](https://github.com/WordPress/ai/pull/621) Fix alt text upload URL matching | 1.3.0 | In progress | review — · merge DIRTY · checks FAILURE |
| [#683](https://github.com/WordPress/ai/pull/683) Add native vector search | 1.3.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#695](https://github.com/WordPress/ai/pull/695) Add: AI-assisted payload generation to the Ability Explorer - Test Ability Screen | Future Release | In progress | draft · review CHANGES_REQUESTED · merge BLOCKED · checks FAILURE |
| [#760](https://github.com/WordPress/ai/pull/760) PoC: Basic integration with Chrome DevTools for agents | Future Release | Needs review | review — · merge BLOCKED · checks SUCCESS |
| [#764](https://github.com/WordPress/ai/pull/764) Add a core/manage-settings ability | 1.3.0 | In progress | review — · merge DIRTY · checks SUCCESS |
| [#765](https://github.com/WordPress/ai/pull/765) Add Repo Automator action | Future Release | In progress | review — · merge BLOCKED · checks FAILURE |
| [#777](https://github.com/WordPress/ai/pull/777) dev: Update Composer deps and remediate PHPStan smells | 1.3.0 | In progress | draft · review — · merge DIRTY · checks SUCCESS |
| [#789](https://github.com/WordPress/ai/pull/789) Update bundled wp deps (theme, ui, dataviews, admin-ui) | Future Release | In progress | review — · merge DIRTY · checks FAILURE |
| [#832](https://github.com/WordPress/ai/pull/832) chore(deps): drop @wordpress dependencies to wp-7.0 versions | 1.3.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#851](https://github.com/WordPress/ai/pull/851) PoC: Test upcoming embedding changes | Future Release | In progress | review — · merge BLOCKED · checks FAILURE |
| [#858](https://github.com/WordPress/ai/pull/858) Abilities API: add core/read-nav-menus ability | 1.3.0 | Needs review | review — · merge BLOCKED · checks SUCCESS |
| [#882](https://github.com/WordPress/ai/pull/882) Add/sr screenshot | 1.3.0 | Needs review | review — · merge BLOCKED · checks SUCCESS |

> The active feature/platform work includes C2PA monitoring (#459), native vector search (#683), WebMCP (#224), service accounts (#211), focus-aware crops (#494), Ability Explorer payload generation (#695), Core abilities (#764/#858), and the embeddings PoC (#851). Maintenance and documentation cards share the same board lane.

### Board vs. repo: PR coverage (five classifications)

The repo has **37 open PRs**. Every open PR now gets exactly one coverage classification, joined to Project #240 by repository-qualified `repo#number` keys:

| Classification | Count | Meaning |
|---|---:|---|
| `direct-board-pr` | **16** | The PR itself is a Project #240 card (table above) |
| `linked-board-issue` | **17** | Off-board PR linked to an on-board issue (15 via authoritative GitHub closing references, 2 via labeled fallbacks) |
| `routine` | **2** | Dependency/bot maintenance (#879, #880) — roadmap-exempt |
| `linked-off-board-issue` | **0** | Links only to an issue that is not on the board |
| `unexplained` | **2** | **No identifiable roadmap relationship: [#877](https://github.com/WordPress/ai/pull/877), [#878](https://github.com/WordPress/ai/pull/878)** |

PR→issue mappings come from GitHub `closingIssuesReferences` first (source `closing`, authoritative); restricted title/body/branch fallback parsing (`fallback-*`) applies only to non-routine PRs. Corrections vs. the previous regex-guessed table: **#747 does close [#187](https://github.com/WordPress/ai/issues/187)** (the old parser missed it), and **#798 authoritatively closes only [#600](https://github.com/WordPress/ai/issues/600)** (the previously listed #617 was changelog-text noise).

| Open PR (live) | Implements (source) | Board state · assignees | Classification | Readiness (review · checks) |
|---|---|---|---|---|
| [#633](https://github.com/WordPress/ai/pull/633) Content Classification: improve relevance of taxonomy suggestions | [#452](https://github.com/WordPress/ai/issues/452) `closing` | In progress/1.3.0 · saarnilauri | linked-board-issue | — · FAILURE |
| [#681](https://github.com/WordPress/ai/pull/681) Feat 514: add comment value score | [#514](https://github.com/WordPress/ai/issues/514) `closing` | In progress/1.3.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#692](https://github.com/WordPress/ai/pull/692) Feature: Cleanup plugin data on plugin uninstall | [#690](https://github.com/WordPress/ai/issues/690) `closing` | In progress/1.3.0 · hbhalodia | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#734](https://github.com/WordPress/ai/pull/734) feat: add settings import/export functionality | [#191](https://github.com/WordPress/ai/issues/191) `closing` | In progress/1.3.0 · coderGtm | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#735](https://github.com/WordPress/ai/pull/735) Logging: replace "Purge All Logs" with age-based delete control | [#689](https://github.com/WordPress/ai/issues/689) `closing` | In progress/Future Release · i-anubhav-anand | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#747](https://github.com/WordPress/ai/pull/747) Feat[Experiment]: Add AI-Powered Content Translation | [#187](https://github.com/WordPress/ai/issues/187) `closing` | Needs review/1.3.0 · yogeshbhutkar | linked-board-issue | — · SUCCESS |
| [#749](https://github.com/WordPress/ai/pull/749) Feat/add role user access controls | [#736](https://github.com/WordPress/ai/issues/736) `closing` | In progress/1.3.0 | linked-board-issue | — · SUCCESS |
| [#757](https://github.com/WordPress/ai/pull/757) fix(logging): capture generations that bypass the SDK HTTP transporter | [#732](https://github.com/WordPress/ai/issues/732) `closing` | In progress/1.3.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#759](https://github.com/WordPress/ai/pull/759) [issue #660] feat: Update generalised error message for all features | [#660](https://github.com/WordPress/ai/issues/660) `closing` | Needs review/1.3.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#770](https://github.com/WordPress/ai/pull/770) Prompt template extension points | [#192](https://github.com/WordPress/ai/issues/192) `closing` | In progress/Future Release · the-hercules | linked-board-issue | — · SUCCESS |
| [#798](https://github.com/WordPress/ai/pull/798) Clarify global AI toggle as a master switch (#600) | [#600](https://github.com/WordPress/ai/issues/600) `closing` | In discussion / Needs decision/Future Release | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#855](https://github.com/WordPress/ai/pull/855) Markdown feeds experiment | [#845](https://github.com/WordPress/ai/issues/845) `closing` | In progress/1.3.0 · dkotter | linked-board-issue | — · FAILURE |
| [#861](https://github.com/WordPress/ai/pull/861) Link Editorial Updates success notice to visual revisions | [#507](https://github.com/WordPress/ai/issues/507) `closing` | Needs review/1.3.0 · zeus2611 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#867](https://github.com/WordPress/ai/pull/867) Fix: Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix | [#866](https://github.com/WordPress/ai/issues/866) `closing` | In progress/1.3.0 · hbhalodia | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#877](https://github.com/WordPress/ai/pull/877) Fix: Focus inline reply textarea after generating suggestion | — | — | **unexplained** | — · SUCCESS |
| [#878](https://github.com/WordPress/ai/pull/878) Code Quality: Clean up unnecessary `any` type casts | — | — | **unexplained** | — · SUCCESS |
| [#879](https://github.com/WordPress/ai/pull/879) fix(deps-dev): bump the composer-dev-minor-patch group with 2 updates | — | — | routine | — · SUCCESS |
| [#880](https://github.com/WordPress/ai/pull/880) fix(deps): bump the npm-prod-minor-patch group with 2 updates | — | — | routine | — · FAILURE |
| [#881](https://github.com/WordPress/ai/pull/881) (draft) Feature: Nex Experiment Abilities Toggle | [#863](https://github.com/WordPress/ai/issues/863) `fallback-branch` | To do/1.3.0 | linked-board-issue | — · FAILURE |
| [#884](https://github.com/WordPress/ai/pull/884) Abilities Explorer: support custom providers in the filter dropdown and statistics | [#883](https://github.com/WordPress/ai/issues/883) `closing` | In progress/no milestone | linked-board-issue | — · SUCCESS |
| [#885](https://github.com/WordPress/ai/pull/885) Solution (#425): Update placement of Alt Text generation buttons | [#425](https://github.com/WordPress/ai/issues/425) `fallback-title` | In discussion / Needs decision/Future Release | linked-board-issue | — · FAILURE |

> **Coverage risk:** the two **unexplained** PRs (#877 inline-reply focus fix, #878 `any`-cast cleanup) are the current `--strict` audit failures — real work in flight that Project #240 does not show. There are no linked-off-board-issue PRs this window. Since the 2026-07-18 16:34 UTC repo snapshot, no PR entered or left the census; the only readiness change is board PR #858's merge state (**DIRTY → BLOCKED**, checks still green). Among the linked PRs, #884 authoritatively closes #883, while #885's relationship to #425 is only a `fallback-title` match and is not treated as an authoritative dossier correction. The live gap — including PR readiness changes (draft/review/merge/checks transitions) between snapshots — is generated by `./wp-ai-roadmap-refresh.sh`; run `--strict --json` for the audit form that exits `2` while any unexplained/off-board substantive PR remains.

### Full-repository PR/release radar

These upstream repositories are fully enumerated by the refresh script, including normalized open PR records, readiness changes, release history/diffs, validation, and independent PR/release snapshots. They are **census-only**: their work can affect the WordPress AI delivery path, but their PRs are not expected to have Project #240 cards.

| Repository | Open PRs | Latest release | Relationship to this roadmap |
|---|---:|---|---|
| [`WordPress/php-ai-client`](https://github.com/WordPress/php-ai-client) | **20** | **1.4.0** (2026-07-15) | Provider-agnostic PHP AI client used by the WordPress AI stack; embedding, streaming, model-selection, schema, and provider work can change plugin capabilities. |
| [`WordPress/mcp-adapter`](https://github.com/WordPress/mcp-adapter) | **12** | **v0.5.0** (2026-04-15) | Bridges Abilities to MCP; transport, exposure, approval, schema, session, and server-registration work affects agent integrations. |

Membership lives in [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json). Run `./wp-ai-roadmap-refresh.sh census --strict` for the complete live census; the existing five-way board-coverage classification remains exclusive to `WordPress/ai`.

---

## ① Dated release lanes

### v1.2.0 — ✅ Shipped 2026-07-14 — 1 residual board-open issue

The `WordPress/ai` release shipped and milestone #19 is closed. Project #240 still has one non-Done 1.2.0 card in another repository:

| Issue | Status | Summary |
|---|---|---|
| [#23](https://github.com/WordPress/ai-provider-for-google/issues/23) | In discussion / Needs decision | [Bug]: Image Generation fails with "Unexpected Google API response: Missing the candidates[0].content key" |

This is provider follow-up, not unfinished code in the released plugin.

### v1.3.0 — Active — 22 non-Done (14 issues + 8 PRs)

| Issue | Status | Summary |
|---|---|---|
| [#187](https://github.com/WordPress/ai/issues/187) | Needs review | Support multilingual rewriting and translation via AI |
| [#191](https://github.com/WordPress/ai/issues/191) | In progress | Add import/export support for AI settings and provider configuration |
| [#421](https://github.com/WordPress/ai/issues/421) | To do | WordPress should detect C2PA manifests on upload |
| [#452](https://github.com/WordPress/ai/issues/452) | In progress | Content Classification: Improve relevance of taxonomy suggestions |
| [#507](https://github.com/WordPress/ai/issues/507) | Needs review | Iterate on Editorial Updates end flow to Visual Revisions |
| [#514](https://github.com/WordPress/ai/issues/514) | In progress | Add comment value / relevance to Comment Moderation experiment |
| [#660](https://github.com/WordPress/ai/issues/660) | Needs review | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals |
| [#690](https://github.com/WordPress/ai/issues/690) | In progress | Plugin does not clean up database table and options on uninstall |
| [#732](https://github.com/WordPress/ai/issues/732) | In progress | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible |
| [#736](https://github.com/WordPress/ai/issues/736) | In progress | Expose role/user access controls per feature/experiment |
| [#741](https://github.com/WordPress/ai/issues/741) | In discussion / Needs decision | AI Admin Pages Exhibit Visible Flicker During Initial Render |
| [#845](https://github.com/WordPress/ai/issues/845) | In progress | New Experiment: Markdown feeds (powered by `html-to-md`) |
| [#863](https://github.com/WordPress/ai/issues/863) | To do | New Experiment: Abilities toggle |
| [#866](https://github.com/WordPress/ai/issues/866) | In progress | Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix |

#### Open PRs (8)

#### PR #459 — Add C2PA Monitor experiment · *In progress · not draft · BLOCKED · CHANGES_REQUESTED · +3140/-0, 16 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/459) · @lnispel
**Delivers.** Read-only infra detecting C2PA Content Credentials in uploaded JPEG/PNG/WebP at `add_attachment` (before subsize generation destroys them). Streaming container walks (JPEG APP11/JUMBF reassembly, PNG `caBX`, WebP RIFF `C2PA`) with byte caps; writes raw manifest to a sidecar + a `_wpai_monitor_record` postmeta; SHA-256 hashing; fail-open. Claim decoding, admin UI, crypto verification deferred. (Read-only sibling to the #294/#302 signing work; conceptually implements issue [#421](https://github.com/WordPress/ai/issues/421).)
**Blockers.** dkotter requested changes: set `capability` to `none`; move README under `docs/experiments`; reset `@since` to `x.x.x`; translate error strings; **reconsider sidecar security** (`.htaccess` only protects Apache → prefer non-public storage).

#### PR #621 — Fix alt text upload URL matching · *In progress · not draft · UNKNOWN · +61/-1, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/621) · @1d0u
**Delivers.** Correctness/security fix in `Alt_Text_Generation`: replaces a substring check with an exact/prefix-boundary check so only the configured uploads base URL resolves to local files (prevents lookalike-URL spoofing). Adds a regression test.
**Blockers.** Copilot raised two concerns; author rebutted with reruns. dkotter asked for `@since` fixes and to split out an unrelated E2E change. Current merge state is **UNKNOWN**; awaiting re-review. Now scheduled for 1.3.0.

#### PR #683 — Add native vector search · *In progress · draft · DIRTY · +8565/-4, 37 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/683) · @artpi
**Delivers.** A new opt-in `rag-search` experiment for semantic search/RAG. Primary path uses MariaDB 11.8+ `VECTOR(1536)` storage plus a cosine vector index and OpenAI `text-embedding-3-small`; fallback stores embeddings in post meta and searches in memory for smaller sites. Adds indexing lifecycle hooks, one-hour dirty-post cron scheduling, transactional replace-by-post behavior where possible, cleanup hooks, `wp ai rag` WP-CLI utilities, public-search augmentation, and related-posts output.
**Blockers.** Draft; merge-state **CONFLICTING** (needs rebase). Still needs review and a future migration to embeddings supplied by the WP AI Client once available. Operationally gated on supported MariaDB and an authenticated OpenAI connector for the vector-index path. Now scheduled for 1.3.0.

#### PR #764 — Add a core/manage-settings ability · *In progress · not draft · DIRTY · +408/-11, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/764) · @jorgefilipecosta
**Delivers.** The write-oriented `core/manage-settings` ability — the counterpart to the read-only `core/settings` added in #691. Takes a map of setting name → new value (reusing each setting's own value schema, `additionalProperties: false`); permission `manage_options`; annotations `readonly:false, destructive:false, idempotent:true`. **Atomic, all-or-nothing**: the Abilities API validates the whole input against the schema before any `update_option()` fires, matching `WP_REST_Settings_Controller::update_item()`.
**Blockers.** The branch is currently DIRTY against `develop` and needs refresh/review. It pairs with `core/settings` (#691) and the now-merged `core/read-content` (#739).

#### PR #777 — dev: Update Composer deps and remediate PHPStan smells · *In progress · draft · UNKNOWN · +106/-36, 13 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/777) · @justlevine
**Delivers.** Tooling hygiene: bumps Composer dependencies to their latest versions and fixes the resulting PHPStan errors (including updating `php-stubs/wordpress-stubs`). No feature impact.
**Blockers.** Draft; awaiting review.

#### PR #832 — chore(deps): drop @wordpress dependencies to wp-7.0 versions · *In progress · draft · UNKNOWN · +12969/-8969, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/832) · @justlevine
**Delivers.** Dependency alignment: pins the bundled `@wordpress/*` packages to the versions shipping in **WP 7.0** (rather than newer Gutenberg majors), part of the wp-7.0 compatibility pass alongside #789 and the dependabot `@wordpress` bumps (#824–#827). The large diff is the regenerated lockfile.
**Blockers.** Draft; no feature impact. Complements #831 (which now pins NPM deps and tells dependabot to ignore `@wordpress`).

#### PR #858 — Abilities API: add core/read-nav-menus ability · *Needs review · not draft · BLOCKED · +870/-0, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/858) · @Builder106
**Delivers.** A read-only `core/read-nav-menus` ability that lists menus and theme-location assignments or fetches one menu by ID, slug, or location with its items. It uses `edit_theme_options`, follows the existing read-users/read-settings pattern, and is intended to land here before a WordPress Core proposal.

**Blockers.** GitHub now reports the PR as **BLOCKED** (checks are green, but no approving review is recorded), where it previously showed a dirty branch. The permission boundary and eventual Core ownership remain the substantive review points.

#### PR #882 — Add/sr screenshot · *Needs review · not draft · BLOCKED · +3/-2, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/882) · @jeffpaul
**Delivers.** A small documentation/media update adding a screencast GIF for the Suggest Reply admin experiment.

**Blockers.** The PR is BLOCKED in GitHub's merge-state signal and has no recorded review decision. Its body still contains placeholder sections, so it needs cleanup/review before merge.

### v1.4.0 — Next — 4 discussion-stage issues

| Issue | Status | Summary |
|---|---|---|
| [#27](https://github.com/WordPress/ai/issues/27) | In discussion / Needs decision | Display additional AI provider plugins on Connectors page (alongside default Anthropic, Google, and OpenAI ones) |
| [#324](https://github.com/WordPress/ai/issues/324) | In discussion / Needs decision | Evolve Refine from Notes into collaborative and agentic editorial workflows |
| [#875](https://github.com/WordPress/ai/issues/875) | In discussion / Needs decision | New Experiment: Suggest internal links within post content |
| [#876](https://github.com/WordPress/ai/issues/876) | In discussion / Needs decision | New Experiment: Suggest permalink slugs |

These are not implementation-ready commitments yet: provider discovery (#27), agentic Refine/RTC (#324), internal-link suggestions (#875), and permalink-slug suggestions (#876) still need product/design decisions.

---

## ② Planned backlog — Future Release (43)

### Issues (35)

| Issue | Status | Summary |
|---|---|---|
| [#21](https://github.com/WordPress/ai/issues/21) | In discussion / Needs decision | How to best support hundreds or thousands of abilities |
| [#32](https://github.com/WordPress/ai/issues/32) | To do | Add AI Playground interface (prompt testing & debug tools) |
| [#37](https://github.com/WordPress/ai/issues/37) | In discussion / Needs decision | MCP usage across features and request routing |
| [#40](https://github.com/WordPress/ai/issues/40) | Triage | WordPress Core Abilities |
| [#47](https://github.com/WordPress/ai/issues/47) | In discussion / Needs decision | Low-/no-tech educational content |
| [#90](https://github.com/WordPress/ai/issues/90) | In discussion / Needs decision | Clarify and consolidate Title Generation options in UI and Experiment settings |
| [#142](https://github.com/WordPress/ai/issues/142) | Backlog | Frontend chat agent powered by site content |
| [#186](https://github.com/WordPress/ai/issues/186) | Backlog | Add tone adjustment controls for AI-generated content |
| [#188](https://github.com/WordPress/ai/issues/188) | Backlog | Add persona-driven content generation experiments |
| [#189](https://github.com/WordPress/ai/issues/189) | Backlog | Explore an admin Site Agent for executing WordPress actions |
| [#190](https://github.com/WordPress/ai/issues/190) | To do | Add site-wide AI-powered content insights |
| [#192](https://github.com/WordPress/ai/issues/192) | In progress | Add extension points for custom prompt templates |
| [#193](https://github.com/WordPress/ai/issues/193) | Backlog | Add developer-only log panel for inspecting AI provider responses |
| [#203](https://github.com/WordPress/ai/issues/203) | In progress | Add extensibility hook for custom Ability Table columns |
| [#233](https://github.com/WordPress/ai/issues/233) | To do | Refactor experiments to leverage AI_Service layer |
| [#238](https://github.com/WordPress/ai/issues/238) | In progress | Add focus-aware crop suggestions |
| [#262](https://github.com/WordPress/ai/issues/262) | In discussion / Needs decision | Provider-Level Model Bucketing for Model Selection |
| [#282](https://github.com/WordPress/ai/issues/282) | Backlog | Chat experiment: Integration outside the editor and outside single-task AI use |
| [#297](https://github.com/WordPress/ai/issues/297) | Backlog | New experiment: Content Generation |
| [#307](https://github.com/WordPress/ai/issues/307) | In progress | Add AGENTS.md to streamline contributor onboarding |
| [#325](https://github.com/WordPress/ai/issues/325) | In progress | Integrate media features and experiments with Gutenberg's experimental Media Editor |
| [#338](https://github.com/WordPress/ai/issues/338) | In discussion / Needs decision | New Experiments: Analytics-aware content and amplification recommendations |
| [#339](https://github.com/WordPress/ai/issues/339) | To do | AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin |
| [#348](https://github.com/WordPress/ai/issues/348) | In discussion / Needs decision | Feature Request: Unified AI Management Layer for WordPress Core |
| [#354](https://github.com/WordPress/ai/issues/354) | In discussion / Needs decision | Unifiied Abilities exposure controls |
| [#425](https://github.com/WordPress/ai/issues/425) | In discussion / Needs decision | Update placement of Alt Text generation buttons |
| [#430](https://github.com/WordPress/ai/issues/430) | In discussion / Needs decision | Skills in a WordPress admin context |
| [#448](https://github.com/WordPress/ai/issues/448) | In discussion / Needs decision | Add WebMCP experiment |
| [#502](https://github.com/WordPress/ai/issues/502) | In discussion / Needs decision | Define how AI provider plugins are discovered, labeled, and surfaced in Connectors |
| [#600](https://github.com/WordPress/ai/issues/600) | In discussion / Needs decision | `Enable AI` header toggle doesn't reflect aggregate state of sub-features |
| [#625](https://github.com/WordPress/ai/issues/625) | In discussion / Needs decision | New Experiment: Social Content Generation for platform-specific social posts |
| [#643](https://github.com/WordPress/ai/issues/643) | In discussion / Needs decision | "AI" plugin 1.0.1 – Connectors and AI settings pages load blank (JavaScript error) on WordPress 7.0 |
| [#689](https://github.com/WordPress/ai/issues/689) | In progress | Add a user-facing control for automatic log cleanup |
| [#791](https://github.com/WordPress/ai/issues/791) | In discussion / Needs decision | Add loading animation/custom cursor for Type Ahead |
| [#844](https://github.com/WordPress/ai/issues/844) | Backlog | New Experiment: Semantic search in wp admin |

### Open PRs (8)

#### PR #211 — Add Service Account experiment · *In discussion / Needs decision · draft · UNKNOWN · +3853/-0, 8 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/211) · @Jameswlepage
**Delivers.** Exploratory **Service Account** experiment: a real, creatable user type for non-interactive/automation access (Claude Code, automation, APIs). Adds a Service role, Users → Add New customizations, a Service Accounts list view, and REST CRUD + application-password regeneration.
**Blockers.** Genuinely exploratory — the author frames it as a **"do we need this?"** question; provider-specific labels would need removing if it advances. Draft, no reviews — a concept for decision, not a merge candidate.

#### PR #224 — Add WebMCP adapter experiment · *In discussion / Needs decision · draft · DIRTY · +2371/-55, 9 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/224) · @Jameswlepage
**Delivers.** A `webmcp-adapter` experiment exposing layered `navigator.modelContext` (WebMCP) tools in wp-admin for discovering/inspecting/executing Abilities. Adds `is_available()`/`get_unavailable_reason()` to `Abstract_Experiment`, gates on Abilities API availability, enforces server-side option sanitization.
**Blockers.** Functionally validated (abilities executed via WebMCP in Chrome Canary) but **held by spec instability** — WebMCP is a fast-moving W3C CG draft (tool-registration shape already changed). swissspidy recommended stepping back to discussion issue #448 and exploring declarative form-exposure first. Current merge state is **DIRTY** and the branch needs an update before review.

#### PR #494 — [Feature]: Issue 238 | Focus-aware crop suggestions · *In progress · not draft · UNKNOWN · +2152/-315, 9 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/494) · @TylerB24890
**Delivers.** A `Suggest_Image_Crops` experiment + Ability: feeds an image (data URI) to a vision model that returns focal point + crop-window coordinates in Focal-Point-Picker space. Adds a shared `Resolves_Image_Reference` trait and refactors `Alt_Text_Generation` to use it. Customizable aspect ratios via filter.
**Blockers.** **[Status] Blocked** — the Gutenberg Media Editor modal isn't yet extensible (epic gutenberg#73771); no UI surface until `registerImageEditorPanel()` (name TBD) lands. Backend Ability works standalone via the Abilities Explorer. Related: #325, PR [#446](https://github.com/WordPress/ai/pull/446) (already merged in 1.0.0).

#### PR #695 — Add: AI-assisted payload generation to the Ability Explorer - Test Ability Screen · *In progress · draft · BLOCKED · CHANGES_REQUESTED · +357/-38, 5 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/695) · @Arkenon
**Delivers.** Adds AI-assisted payload generation to the Ability Test Runner: users describe a test scenario in natural language and the tool generates a valid JSON payload from the selected ability's input schema — lowering the bar to exercise abilities with complex inputs.
**Blockers.** Draft; currently BLOCKED with CHANGES_REQUESTED; address review feedback before another mergeability check.

#### PR #760 — PoC: Basic integration with Chrome DevTools for agents · *Needs review · not draft · UNKNOWN · +474/-0, 16 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/760) · @dkotter
**Delivers.** A third-party integration exposing the site's available AI Features — plus a lightweight log of which Features ran recently — to Chrome DevTools for agents, which recently added 3P-tool support. A deliberately basic proof-of-concept to validate the surface.
**Blockers.** PoC framing — a "does this direction have legs?" exploration rather than a finished feature. Current merge state is UNKNOWN; product direction and review are still needed.

#### PR #765 — Add Repo Automator action · *In progress · not draft · UNKNOWN · +48/-0, 1 file · Future Release*
[Link](https://github.com/WordPress/ai/pull/765) · @jeffpaul
**Delivers.** Repo-ops tooling, not a user feature: a `.github/workflows/repo-automator.yml` running 10up/action-repo-automator on the `develop` branch to auto-label, comment, and assign reviewers on PRs/issues — operational support for the rising issue/PR volume (jeffpaul + dkotter).
**Blockers.** Awaiting review; no feature impact. Remains in Future Release.

#### PR #789 — Update bundled wp deps (theme, ui, dataviews, admin-ui) · *In progress · not draft · DIRTY · +629/-538, 4 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/789) · @simison
**Delivers.** Refreshes the bundled `@wordpress/*` packages (theme, ui, dataviews, admin-ui) pulled from Gutenberg. Dependency maintenance; no feature impact.
**Blockers.** Currently DIRTY against `develop`; refresh dependencies before review.

#### PR #851 — PoC: Test upcoming embedding changes · *In progress · not draft · UNKNOWN · +1404/-6, 8 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/851) · @dkotter
**Delivers.** A deliberately non-mergeable PoC for upcoming PHP AI Client embedding support. It pulls in in-progress provider/client branches and adds `wp ai embeddings generate` to test text or post-content embeddings, provider selection, and chunking.

**Blockers.** The author explicitly marks it "not meant to be merged." It depends on WordPress/php-ai-client#244 plus provider embedding PRs; Codecov reports no patch coverage for the temporary command/dependency loader.

---

## ③ Straggler — 1

- **[PR #484](https://github.com/WordPress/ai/pull/484) — "Ignore .wp-env.test.override.json"** is already merged (2026-04-29) but remains board-Needs review under 0.9.0. It is a board-hygiene item, not pending delivery.

**Removed-board reference:** [WordPress/abilities-api#84](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not part of Project #240.

---

## ④ Unscheduled — 3

| Issue | Status | Summary |
|---|---|---|
| [#869](https://github.com/WordPress/ai/issues/869) | Triage | window.aiProviderData is only attached to the block-editor iframe snapshot, never to the top window, causing "requires an AI Connector" false positives |
| [#874](https://github.com/WordPress/ai/issues/874) | Triage | Meta Description: Issue with Yoast plugin for Meta Description experiment |
| [#883](https://github.com/WordPress/ai/issues/883) | In progress | Abilities Explorer: provider filter dropdown doesn't include custom providers |

- **#869** needs a clean-environment/develop-branch reproduction; current discussion suggests the top-window failure may be environment-specific.
- **#874** traces two Yoast interoperability paths: the Yoast editor store is the save/UI source of truth, and Yoast REST-exposes its meta only for the `post` subtype. The supported integration contract still needs deciding.
- **#883** has authoritative closing PR #884, which dynamically adds custom providers to the filter and keeps overview statistics grouped by Core/Plugin/Theme origin; checks are green, but GitHub still reports the PR as BLOCKED pending review/merge eligibility.

---

## ⚠️ Data-quality flags (verify before acting)

1. **PR #484 is merged**, not open, despite its board status.
2. **Board ≠ repo:** 37 open PRs = 16 direct-board-pr + 17 linked-board-issue + 2 routine + 0 linked-off-board-issue + **2 unexplained (#877, #878 — the current strict-audit failures)**.
3. **1.2.0 is shipped and its GitHub milestone is closed**, but external provider issue #23 still carries that milestone and remains board-open.
4. **#869 is not yet a clean-environment repro.** The reporter could not retest `develop`; do not treat it as a confirmed universal regression.
5. **#874 may require Yoast-specific integration.** `core/editor` meta and the `yoast-seo/editor` store have different save paths; the REST-meta path is scoped to posts.
6. **The provenance shape changed:** signing PRs #294/#302 closed without merge; only the read/monitoring PR #459 remains open and is now 1.3.0.
7. **Merge-state fields are volatile.** BLOCKED/DIRTY/UNKNOWN values in this snapshot should be rechecked before prioritization.
8. **Cross-repo signals are separate:** neither the 16-item Gutenberg/abilities-api dependency watchlist nor the full `php-ai-client` / `mcp-adapter` PR-release censuses are included in Project #240 counts; coverage validation applies only to `WordPress/ai`.

---

## 🔭 Work for Later

- [x] **Ship v1.2.0** — released 2026-07-14 and deployed to WordPress.org.
- [ ] **Close or re-milestone provider issue #23** now that the plugin's 1.2.0 milestone is closed.
- [ ] **Resolve standalone-ability governance (#863)** before additional write/destructive abilities expand the always-registered surface.
- [ ] **Decide the remaining C2PA path:** #459 is open; #294/#302 closed without merge.
- [ ] **Rebase/review the v1.3.0 PR lane**, especially DIRTY #683/#764 and BLOCKED #459/#858/#882.
- [ ] **Clarify #851's PoC lifecycle** when PHP AI Client embedding support lands; it explicitly should not merge as-is.
- [ ] **Reproduce #869 cleanly** and define the Yoast integration contract for #874.
- [ ] **Fix board hygiene** for merged PR #484.
- [ ] **Decide whether off-board PRs should receive PR cards** or remain represented only through their backing issue cards.
- [x] **Maintain the refresh workflow** — `wp-ai-roadmap-refresh.sh` passes syntax and the strict 16-ID dependency smoke test in this refresh.

---

## Changelog

| Date | Change |
|---|---|
| 2026-07-20 | **Live board + repo refresh vs the 2026-07-18 16:34 UTC baseline.** Non-Done scope holds at **74** = 57 open issues + 16 open board PRs + stale merged #484; every status total (In progress 26, In discussion 24, Needs review 7, Backlog 8, To do 6, Triage 3) and milestone tier (**1.3.0 22**, **1.4.0 4**, **Future Release 43**) is unchanged. Repo gap steady at **37 open PRs** = 16 direct + 17 linked + 2 routine + 0 linked-off-board + 2 unexplained (#877/#878). **Only readiness change:** board PR **#858** (`core/read-nav-menus`, 1.3.0, Needs review) moved **merge DIRTY → BLOCKED** (checks still SUCCESS); no PR entered or left the census. Upstream radar unchanged (`php-ai-client` **20 / 1.4.0**, `mcp-adapter` **12 / v0.5.0**); dependency watchlist holds at 16 (10 open / 3 closed / 3 merged). Script passes `bash -n`, the five offline fixture suites, and the live 16-ID dependency smoke test; snapshots rolled forward. |
| 2026-07-18 | **Same-day live refresh vs `proj240-20260718T022045Z.json`.** Board **282 → 283** and non-Done **73 → 74** with new unmilestoned In-progress issue #883; Done stays 209. `WordPress/ai` open PRs **35 → 37**: #884 authoritatively closes #883, while #885 has only a `fallback-title` relationship to #425. Coverage is 16 direct + 17 linked + 2 routine + 0 linked-off-board + 2 unexplained; #877/#878 remain the only strict-audit failures. No upstream census, release, or dependency-watchlist change. |
| 2026-07-18 | **Added full upstream repository radar.** `wp-ai-roadmap-refresh.sh` now enumerates, validates, diffs, renders, and snapshots every open PR and release for `WordPress/php-ai-client` (**20 open; 1.4.0**) and `WordPress/mcp-adapter` (**12 open; v0.5.0**). These are census-only signals; the five-way Project #240 coverage model remains scoped to `WordPress/ai` (35 open PRs). Board scope and dependency membership are unchanged. |
| 2026-07-17 | **Tracker upgrade: authoritative PR coverage model.** PR→issue mappings now come from GitHub `closingIssuesReferences` (source-labeled; restricted fallback grammar for the rest), and every open PR gets one of five classifications: **16 direct-board-pr + 15 linked-board-issue + 2 routine + 0 linked-off-board-issue + 2 unexplained (#877, #878)**. Corrections from authoritative data: #747 closes #187 (previously unmapped); #798 closes only #600 (#617 was parser noise). PR tables now carry review/merge/checks readiness and board-issue assignees; `--strict` audit exits 2 while unexplained substantive PRs remain. |
| 2026-07-17 | **Live board + repo refresh vs 2026-07-13 baseline.** Scope remains **73 non-Done**, now 56 issues + 16 open board PRs + stale #484. **v1.2.0 shipped 2026-07-14**; active work moved to **v1.3.0 (22)**, with **v1.4.0 (4)** and Future Release (43) behind it. Nine baseline cards moved Done; six new open issues and three new open PR cards entered the board. Repo: 35 open PRs / 19 without PR cards (17 substantive + 2 routine). Dependencies remain 16 (10 open / 3 closed / 3 merged). |
| 2026-07-12 | **Live board + repo refresh vs 2026-07-09 baseline.** Non-Done scope **77 → 73** = 53 open issues + 19 open board-tracked PRs + stale #484. **🚧 v1.2.0 kept shipping — 10 Done / 31 open → 14 Done / 28 open** (closed: #508 "Suggest Reply" experiment/PR #724, #793 Customize-experiments tool/#842, #815 Connector-Approvals notice/#830, dependabot #837; plus no-milestone #809 nested-block fix/#810). Tier ① 1.2.0 non-Done **31 → 28** (17 iss + 11 PR): issues #508/#793/#815 + PR #837 went board-Done; new PR card **#857** (Add/commit access docs, Needs review) carded. **Status move:** #845 (Markdown feeds) **Backlog → In progress** (implementing off-board PR #855). **Tier ② Future Release holds at 43** (#845 moved within it). **Tier ④ 2 → 1:** #809 and spam #848 closed board-Done; board-new bug **#853** (Generate_Image hardcoded timeout, Triage) added. Delivery-readiness by status: Needs review 9→8, In progress 30→28, Backlog 9→8, To do 6, Triage 2, In discussion 21 unchanged. Board totals **277 → 279**; Done **200 → 206**. Repo gap **38 → 37 open / 18 untracked** (all substantive, 0 routine); #724/#810/#830/#842 merged out, board-new #855/#856/#858 in. Latest shipped still **v1.1.0** (2026-07-01) — a **1.1.1** patch for the Type-Ahead regression remains undecided. Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged; 1 title change + activity bump — `gutenberg#77230` → "…7.2", 2026-07-11). |
| 2026-07-09 | **Live board + repo refresh vs 2026-07-03 baseline.** Non-Done scope **76 → 77** = 57 open issues + 19 open board-tracked PRs + stale #484. **🚧 v1.2.0 opened its first board-Done batch — 0 Done / 32 → 10 Done / 31 open** (closed: #774 core/read-users, #814 template fix, #816 WooCommerce regression, #818 alt-text, #821/#831 CI/deps, #833 Title-Gen crash, #838 screenshots, #839/#846 Type-Ahead fixes). Tier ① 1.2.0 non-Done **32 → 31** (20 iss + 11 PR): PR #765 (Repo Automator) re-milestoned 1.2.0 → **Future Release**; PRs #832 (drop `@wordpress` deps to wp-7.0) + #837 (npm bump) newly carded. **Status moves To do → In progress:** #793, #815. **Tier ② Future Release 40 → 43** (33i+7PR → 35i+8PR): board-new experiment issues #844 (semantic search in wp-admin) + #845 (Markdown feeds via `html-to-md`) + PR #765 in. **Tier ④ 3 → 2:** #816/#818 closed board-Done; #809 remains; **spam #848** (Triage, no milestone) landed — pending removal (flag #12). Delivery-readiness by status: Needs review 10→9, In progress 29→30, To do 8→6, Backlog 7→9, Triage 1→2 (In discussion 21 unchanged). Board totals **265 → 277**; Done **189 → 200**. **5 already-Done issues de-carded** (#750/#755/#763/#768 from 1.1.0 + #752 no-milestone). Repo gap narrowed to **38 open / 19 untracked** (all substantive, 0 routine — dependabot PRs carded, #831 pins/ignores `@wordpress`). Latest shipped still **v1.1.0** (2026-07-01). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged; 1 activity bump `gutenberg#73771` → 2026-07-08). |
| 2026-07-03 | **Live board + repo refresh vs 2026-07-02 baseline.** Non-Done scope **75 → 76** = 56 open issues + 19 open board-tracked PRs + stale #484. **#816** (Type-Ahead front-end/WooCommerce regression) moved **Triage → In progress** (fix PR #820); board-new **#818** (AI-Home alt-text a11y, In progress, PR #819) added → **Tier ④ (no milestone) 2 → 3** (#809, #816, #818). Delivery-readiness by status: In progress **27 → 29**, Triage **2 → 1** (Needs review 10, To do 8, Backlog 7, In discussion 21 unchanged). **7 already-Done issues de-carded from the board** (#390/#391/#571/#578/#678 from 1.1.0, #589/#727 from 1.0.2) — all shipped, none were planned work, so Tiers ①/②/③ are unchanged (1.2.0 **32**, Future Release **40**, straggler #484). Board totals **271 → 265**; Done **196 → 189**. Repo gap widened to **47 open / 28 untracked** (21 substantive + 7 routine dependabot #821–#827) — new off-board PRs #817/#819/#820/#828/#829. Latest shipped still **v1.1.0** (2026-07-01). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged). |
| 2026-07-02 | **Live board + repo refresh vs 2026-06-30 baseline.** Non-Done scope **74 → 75** = 55 open issues + 19 open board-tracked PRs + stale #484. **🚀 v1.1.0 shipped 2026-07-01** (17th release): encryption PR #560 merged (2026-06-30), release issue #805 closed board-Done, and credentials gate #197 closed board-Done — **Tier ① is now 1.2.0 only (32 = 20 iss + 12 PR)** as the 1.1.0 lane emptied. 4 new open cards: #809 (Content-Summary nested-block detection, In progress, off-board PR #810), #814 (feature-request-template fix, Needs review PR, 1.2.0), #815 (Connector-Approvals notice gap, To do, 1.2.0), #816 (Type-Ahead front-end/WooCommerce regression, Triage). **Tier ④ (no milestone) 0 → 2** (#809, #816). #190 moved Backlog → To do. Delivery-readiness by status: Needs review 9→10, In progress 28→27, To do 7→8, Backlog 8→7, Triage 1→2 (In discussion 21 unchanged). Board totals **269 → 271**; Done **195 → 196** (#701/#721 de-carded from the 1.1.0 lane; #632/#197 milestones cleared into no-milestone-Done, 18→22). Repo gap holds at **35 open / 16 untracked** (16 substantive + 0 routine); off-board #810 opened (Closes #809), #560 merged, #799 closed. Latest shipped **v1.0.2 → v1.1.0** (2026-07-01). Dependency watchlist unchanged at 16 (10 open / 3 closed / 3 merged). |
| 2026-06-30 | **Live board + repo refresh vs 2026-06-26 baseline.** Non-Done scope **66 → 74** = 54 open issues + 19 open board-tracked PRs + stale #484. **1.1.0 all but shipped: 14 Done/13 open → 27 Done/2 open**, with the release now tracked in **#805** (target **30 July 2026**); only encryption PR #560 remains on the 1.1.0 lane. **Big re-milestone wave 1.1.0 → 1.2.0** — #459/#594/#621/#739/#765 PRs and issues #197/#452/#507/#600/#614/#690/#741 (plus #187/#508 → Needs review) moved down; **v1.2.0 is now the active build wave at 0 Done / 31 open** (20 iss + 11 PR). Tier ① **20 → 33**; Tier ② Future Release **44 → 40** (#27 in from 1.1.0, #791 new; #191/#203/#514/#732/#736 out to 1.2.0); **Tier ④ now empty** — #771 merged board-Done. 3 issues newly board-Done (#145, #767, #771); already-Done #699/#704/#718 de-carded from Project #240. Board totals **249 → 269**; Done **183 → 195**. Six off-board PRs became board-tracked (#560/#695/#758/#760/#774/#777) and #789 was added; repo gap now **35 open / 16 untracked** (16 substantive + 0 routine); #798/#799 newly opened off-board (punted from 1.1.0). Latest shipped still **v1.0.2** (2026-06-16). |
| 2026-06-26 | **Live board + repo refresh vs 2026-06-25 baseline.** Non-Done scope **67 → 66** = 53 open issues + 12 open board-tracked PRs + stale #484. **PR #151 (Type Ahead) merged board-Done** into 1.1.0 — removed from the in-flight table and the v1.1.0 PR list (5 → 4 PRs). **#767** milestoned **1.2.0** and moved **In discussion → To do** — relocated from Tier ④ (now **1**: only #771) into v1.2.0 (now **7** = 5 iss + 2 PR). Tier ① holds at **20** (now 14 iss + 6 PR). Board totals **250 → 249** (board-Done bug #697 de-carded); Done holds at **183**. Repo PR gap refreshed to **37 open / 25 untracked** (24 substantive + 1 routine #722); board-tracked open PRs now **12**. Newly opened off-board: #773–#777 (incl. #774 `core/users` ability, #776 Type Ahead follow-up). Latest shipped still **v1.0.2** (2026-06-16). v1.1.0 now **past due** (14 Done / 13 open). |
| 2026-06-25 | **Live board + repo refresh vs 2026-06-20 baseline.** Non-Done scope **65 → 67** = 53 open issues + 13 open board-tracked PRs + stale #484. Tier ① Committed **15 → 20** (13 iss + 7 PR): 1.1.0 now **14 not-Done** (9 iss + 5 PR), 1.2.0 now **6** (4 iss + 2 PR). Milestone moves: #614 & #741 → 1.1.0; #683 → 1.2.0; #621 1.1.0 → Future Release. Tier ② Future Release **47 → 44** (38 iss + 6 PR). New board PRs dossiered: #739 (`core/content`, 1.1.0), #764 (`core/manage-settings`, 1.2.0), #765 (Repo Automator, 1.1.0). Tier ④ swapped to board-new bugs **#767** (In discussion) + **#771** (In progress, draft PR #772); the prior pair #750/#752 moved board-Done (with #632). Repo PR gap refreshed to **33 open / 20 untracked** (19 substantive + 1 routine #722); board-tracked open PRs now 13. Status moves Backlog → In progress: #192 (PR #770), #732 (draft PR #757). Latest shipped still **v1.0.2** (2026-06-16). |
| 2026-06-20 | **Live board + repo refresh vs 2026-06-19 baseline.** Non-Done scope **63 → 65** = 54 open issues + 10 open board-tracked PRs + stale #484. Status moves Backlog → In progress: #187, #736 (In progress 17→21; Backlog 12→10). Added a new **④ Unscheduled** tier for board-new **unmilestoned** In-progress bug fixes #750 (PR #751) + #752 (PR #753). Repo PR gap refreshed to **35 open / 25 untracked** (20 substantive + 5 routine); added untracked rows #743/#747/#748/#749/#751/#753 and dropped #734's stale "draft" marker. Committed (15) and Future Release (47) tiers unchanged; latest shipped still **v1.0.2** (2026-06-16). |
| 2026-06-19 | Added Gutenberg + abilities-api to tracked scope via [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md). The refresh script now fetches 16 curated dependencies and reports/snapshots them separately from Project #240 and `WordPress/ai` repo counts. |
| 2026-06-19 | Fresh live recheck: planned-work counts unchanged. Verified **63 non-Done board cards** = 52 open issues + 10 open board-tracked PRs + stale #484; repo remains **26 open PRs / 16 untracked** (14 substantive + 2 routine); latest shipped remains **v1.0.2**. |
| 2026-06-19 | Live board + repo PR refresh. Planned scope remains **63 non-Done board cards**, but composition is now **52 open issues + 10 open board-tracked PRs + stale #484**. Future Release backlog increased to **47** (41 issues + 6 PRs) with draft PR #683 now board-tracked; unmilestoned open work is now **0** and only stale PR #484 remains as a straggler. Refreshed repo-open PR gap to **26 open / 16 untracked** (14 substantive + 2 routine), regrouped #632/#643/#741/#732/#689 under Future Release, and moved `WordPress/abilities-api#84` to removed-board reference. |
| 2026-06-18 | Live board + repo PR refresh. Planned scope is now **63 non-Done board cards** = 53 open issues + 9 open board-tracked PRs + stale #484. Dated-release commitment is now **15** (11 issues + 4 PRs); Future/Later backlog remains **42** (37 issues + 5 PRs); unmilestoned/stragglers remain **6**. Removed board-Done items #390, #391, #571, #578, #678, #701, #721 from planned sections; added #732/#741 to unmilestoned triage; removed now-Done PR #481 from Future PRs; refreshed repo-open PR gap to **26 open / 17 untracked**. |
| 2026-06-16 | Extended `wp-ai-roadmap-refresh.sh` with a repo-level census (open PRs + releases): board↔repo gap, issue mapping, sibling-snapshot diffs, copy-paste block. Regenerated the *Board vs. repo* table from live output — **40 open · 10 board-tracked · 30 untracked (26 substantive + 4 routine)**. |
| 2026-06-16 | Review + live GitHub verification: reframed "11 open PRs" → board-tracked (10 open + stale #484); added *Board vs. repo* section (repo has ~40 open PRs; ~15 implement listed issues; #508/#514 now have PRs); flagged #699 shipped (v1.0.2) + corrected the wrong #696 link; bumped latest-shipped → v1.0.2. |
| 2026-06-16 | Auto-refresh vs proj240-20260615T031850Z.json: 3 added, 1 newly Done, 0 merged, 3 status moves, 15 milestone moves. |
| 2026-06-15 | Initial planned-work view — all 69 not-Done items by release; full dossiers for the 11 open PRs; surfaced new experiments (Type Ahead, Service Account, WebMCP adapter, C2PA Monitor/Content/Image Provenance, Suggest Image Crops). |
