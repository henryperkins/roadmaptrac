# WordPress AI — Planned (Not-Yet-Shipped) Work

> The **delivery plan** for every Project #240 card not in Done. It includes issue cards and board-tracked PRs, ordered by milestone. ⚠️ **Scope caveat:** `WordPress/ai` has **33 open PRs**, while Project #240 has PR cards for only 13 of them; see [Board vs. repo](#board-vs-repo-pr-coverage-five-classifications). Full census-only tracking for `WordPress/php-ai-client` and `WordPress/mcp-adapter` appears below and does not expand Project #240 scope.
>
> Part of a 4-doc set: [`wordpress-ai-roadmap.md`](./wordpress-ai-roadmap.md) (strategy + tracker) · [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md) (issue dossiers) · [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md) (upstream dependencies + repository radar) · **this file** (release-ordered delivery plan + PR census).
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-08-01 (board + live PR/release checks) |
> | **Scope** | **66 non-Done cards** = 52 open issues + 13 open board-tracked PRs + stale merged PR #484 |
> | **Latest shipped** | **v1.2.0** (2026-07-14; 18th release) |
> | **Repository radar** | `WordPress/php-ai-client`: **24** open PRs / **1.4.0** · `WordPress/mcp-adapter`: **20** / **v0.5.0** (census-only; no Project #240 coverage gate) |
> | **Active / next** | **v1.3.0:** 15 open (9 issues + 6 PRs) · **v1.4.0:** 2 issues (both In discussion) · **Future Release:** 44 open |
> | **For issue detail** | See the [open-issues dossier](./wordpress-ai-open-issues.md). |

## How "planned" is tracked here

This file mirrors **board status**, not a promise that every card will ship. "Done" is excluded; all other statuses are included and grouped by milestone.

### Commitment ladder (66 non-Done cards)

| Tier | Cards | Interpretation |
|---|---:|---|
| **v1.3.0** | **15** | Active delivery lane: 9 issues + 6 PRs (was 18; #187 shipped, #736 and PR #621 left the lane) |
| **v1.4.0** | **2** | Next lane, now **smaller than last window**: #875/#876 were re-milestoned to Future Release, leaving only In-discussion #27/#324 |
| **Future Release** | **44** | Unscheduled backlog: 37 issues + 7 PRs — it absorbed all three re-milestoned cards |
| **1.2.0 residual** | **1** | Google-provider issue #23 remains board-open after the plugin release shipped |
| **Unmilestoned** | **3** | Triage bugs #869 (provider-data iframe mismatch) and #890 (mobile right sidebar), plus new In-progress #906 (public logging API) |
| **Stale shipped-milestone card** | **1** | PR #484 is merged but still board-Needs review under 0.9.0 |

> **The dated lanes shrank without the work shrinking.** Three of this window's four milestone moves pushed cards *out* of a dated release and into Future Release (#736, #875, #876); only one card left a lane by shipping (#187). Read the 18 → 15 and 4 → 2 drops as re-scheduling, not delivery.

### Delivery readiness at a glance

| Board status | Cards |
|---|---:|
| In progress | **26** |
| Needs review | **4** |
| Backlog | **7** |
| To do | **4** |
| Triage | **3** |
| In discussion / Needs decision | **22** |

> "In discussion" is directional, not committed. The board's active implementation signal is the combination of In progress/Needs review cards and the live repository PR census.

---

## 🚀 New experiments & features in the pipeline

### Code already in flight (13 open board-tracked PRs)

| PR | Milestone | Board status | Live readiness (draft · review · merge · checks) |
|---|---|---|---|
| [#211](https://github.com/WordPress/ai/pull/211) Add Service Account experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks FAILURE |
| [#224](https://github.com/WordPress/ai/pull/224) Add WebMCP adapter experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks SUCCESS |
| [#459](https://github.com/WordPress/ai/pull/459) Add C2PA Monitor experiment | 1.3.0 | In progress | review CHANGES_REQUESTED · merge BLOCKED · checks SUCCESS |
| [#494](https://github.com/WordPress/ai/pull/494) [Feature]: Issue 238 \| Focus-aware crop suggestions | Future Release | In progress | review — · merge DIRTY · checks SUCCESS |
| [#683](https://github.com/WordPress/ai/pull/683) Add native vector search | 1.3.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#695](https://github.com/WordPress/ai/pull/695) Add: AI-assisted payload generation to the Ability Explorer - Test Ability Screen | Future Release | In progress | review CHANGES_REQUESTED · merge BLOCKED · checks FAILURE |
| [#760](https://github.com/WordPress/ai/pull/760) PoC: Basic integration with Chrome DevTools for agents | Future Release | Needs review | review — · merge BLOCKED · checks SUCCESS |
| [#764](https://github.com/WordPress/ai/pull/764) Add a core/manage-settings ability | 1.3.0 | In progress | review — · merge DIRTY · checks SUCCESS |
| [#765](https://github.com/WordPress/ai/pull/765) Add Repo Automator action | Future Release | In progress | review — · merge BLOCKED · checks FAILURE |
| [#777](https://github.com/WordPress/ai/pull/777) dev: Update Composer deps and remediate PHPStan smells | 1.3.0 | In progress | draft · review — · merge DIRTY · checks SUCCESS |
| [#789](https://github.com/WordPress/ai/pull/789) Update bundled wp deps (theme, ui, dataviews, admin-ui) | Future Release | In progress | review — · merge DIRTY · checks FAILURE |
| [#832](https://github.com/WordPress/ai/pull/832) chore(deps): drop @wordpress dependencies to wp-7.0 versions | 1.3.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#858](https://github.com/WordPress/ai/pull/858) Abilities API: add core/read-nav-menus ability | 1.3.0 | Needs review | review — · merge BLOCKED · checks SUCCESS |

> The active feature/platform work includes C2PA monitoring (#459), native vector search (#683), WebMCP (#224), service accounts (#211), focus-aware crops (#494), Ability Explorer payload generation (#695), and Core abilities (#764/#858). Maintenance and documentation cards share the same board lane. **This table is unchanged apart from one departure — and that departure did not ship.** PR **#621** (alt-text upload URL matching) was **closed unmerged on 2026-07-28**, then marked board-**Done** with its 1.3.0 milestone stripped. It was closed for contributor inactivity, not completion: dkotter had asked for real reproduction steps and a conflict resolution, jeffpaul punted it a release on 2026-07-13, and after several silent weeks dkotter closed it with "happy to re-open if there's still a desire." The hardening it carried — exact/prefix-boundary matching of the uploads base URL instead of a substring check, guarding against lookalike-URL resolution — is therefore **not** in `develop`, and no successor PR was opened. See data-quality flag 2. **No other board PR changed readiness this window**, and none of the 13 is in a mergeable state.

### Board vs. repo: PR coverage (five classifications)

The repo has **33 open PRs**. Every open PR gets exactly one coverage classification, joined to Project #240 by repository-qualified `repo#number` keys:

| Classification | Count | Meaning |
|---|---:|---|
| `direct-board-pr` | **13** | The PR itself is a Project #240 card (table above) |
| `linked-board-issue` | **14** | Off-board PR linked to an on-board issue (13 via authoritative GitHub closing references, 1 via a labeled fallback) |
| `routine` | **0** | Dependency/bot maintenance — none open this window |
| `linked-off-board-issue` | **0** | Links only to an issue that is not on the board |
| `unexplained` | **6** | **No identifiable roadmap relationship: [#888](https://github.com/WordPress/ai/pull/888), [#889](https://github.com/WordPress/ai/pull/889), [#892](https://github.com/WordPress/ai/pull/892), [#905](https://github.com/WordPress/ai/pull/905), [#909](https://github.com/WordPress/ai/pull/909), [#913](https://github.com/WordPress/ai/pull/913)** |

PR→issue mappings come from GitHub `closingIssuesReferences` first (source `closing`, authoritative); restricted title/body/branch fallback parsing (`fallback-*`) applies only to non-routine PRs. The single remaining fallback is #881 → #863 via branch name.

| Open PR (live) | Implements (source) | Board state · assignees | Classification | Readiness (review · checks) |
|---|---|---|---|---|
| [#681](https://github.com/WordPress/ai/pull/681) Feat 514: add comment value score | [#514](https://github.com/WordPress/ai/issues/514) `closing` | In progress/1.3.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#692](https://github.com/WordPress/ai/pull/692) Feature: Cleanup plugin data on plugin uninstall | [#690](https://github.com/WordPress/ai/issues/690) `closing` | In progress/1.3.0 · hbhalodia | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#735](https://github.com/WordPress/ai/pull/735) Logging: replace "Purge All Logs" with age-based delete control | [#689](https://github.com/WordPress/ai/issues/689) `closing` | In progress/Future Release · i-anubhav-anand | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#749](https://github.com/WordPress/ai/pull/749) Feat/add role user access controls | [#736](https://github.com/WordPress/ai/issues/736) `closing` | In progress/Future Release | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#757](https://github.com/WordPress/ai/pull/757) fix(logging): capture generations that bypass the SDK HTTP transporter | [#732](https://github.com/WordPress/ai/issues/732) `closing` | In progress/1.3.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#759](https://github.com/WordPress/ai/pull/759) [issue #660] feat: Update generalised error message for all features | [#660](https://github.com/WordPress/ai/issues/660) `closing` | Needs review/1.3.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#798](https://github.com/WordPress/ai/pull/798) Clarify global AI toggle as a master switch (#600) | [#600](https://github.com/WordPress/ai/issues/600) `closing` | In discussion / Needs decision/Future Release | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#855](https://github.com/WordPress/ai/pull/855) Markdown feeds experiment | [#845](https://github.com/WordPress/ai/issues/845) `closing` | In progress/1.3.0 · dkotter | linked-board-issue | — · FAILURE |
| [#867](https://github.com/WordPress/ai/pull/867) Fix: Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix | [#866](https://github.com/WordPress/ai/issues/866) `closing` | In progress/1.3.0 · hbhalodia | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#881](https://github.com/WordPress/ai/pull/881) (draft) Feature: Nex Experiment Abilities Toggle | [#863](https://github.com/WordPress/ai/issues/863) `fallback-branch` | To do/1.3.0 | linked-board-issue | — · FAILURE |
| [#887](https://github.com/WordPress/ai/pull/887) Experiment: Add Internal link suggestions | [#875](https://github.com/WordPress/ai/issues/875) `closing` | In progress/Future Release · Infinite-Null | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#888](https://github.com/WordPress/ai/pull/888) New Text to Speech experiment | — | — | **unexplained** | — · FAILURE |
| [#889](https://github.com/WordPress/ai/pull/889) Fixed - Improved accessibility and keyboard usability for request logs provider/model details | — | — | **unexplained** | CHANGES_REQUESTED · FAILURE |
| [#891](https://github.com/WordPress/ai/pull/891) Feat: Add semantic search experiment to AI plugin | [#844](https://github.com/WordPress/ai/issues/844) `closing` | In progress/Future Release | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#892](https://github.com/WordPress/ai/pull/892) Bring over embeddings support from the PHP AI Client | — | — | **unexplained** | — · FAILURE |
| [#897](https://github.com/WordPress/ai/pull/897) Prototype : Implement slug generation feature with UI and tests | [#876](https://github.com/WordPress/ai/issues/876) `closing` | In progress/Future Release · milindmore22 | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#905](https://github.com/WordPress/ai/pull/905) Remove unused ai service class | — | — | **unexplained** | — · SUCCESS |
| [#909](https://github.com/WordPress/ai/pull/909) Update documentation around the encryption experiment and address a few bugs | — | — | **unexplained** | — · SUCCESS |
| [#913](https://github.com/WordPress/ai/pull/913) Update our preferred models | — | — | **unexplained** | — · SUCCESS |
| [#914](https://github.com/WordPress/ai/pull/914) Logging: add a public API for recording MCP tool and ability requests | [#906](https://github.com/WordPress/ai/issues/906) `closing` | In progress/— · azizulhasan | linked-board-issue | — · FAILURE |

> **Coverage risk — the unexplained set doubled, and it now includes the decisions, not just the features.** Last window's three failures (#888, #889, #892) are all still open and unresolved; three more joined them, all authored by maintainers, and one of them **reverses a board card's premise**:
>
> - **[#905](https://github.com/WordPress/ai/pull/905) Remove unused ai service class** (theaminulai, +62/-61 across 5 files) deletes `includes/Services/AI_Service.php`, its test, and the `get_ai_service()` helper. This is the resolution of long-running board issue **[#233](https://github.com/WordPress/ai/issues/233) "Refactor experiments to leverage AI_Service layer"** — but in the *opposite* direction from the card's title: per jeffpaul's question on #233 and dkotter's review on #898, the layer was never adopted, adds nothing over calling `wp_ai_client_prompt()` directly, and is being removed rather than adopted. Its predecessor **PR #898 was closed unmerged on 2026-07-27** for that reason. #905 says "See #233" in its body but declares no `closing` reference, so the board still shows #233 as In progress/Future Release with an intent that its own implementation PR now contradicts. **This is the most consequential coverage gap of the six** — a strategy reversal that the board cannot see.
> - **[#888](https://github.com/WordPress/ai/pull/888) New Text to Speech experiment** (dkotter, +4,216/-1 across 28 files) registers two new abilities — `ai/speech-generation` and `ai/speech-import` — chunks content to stay under provider limits, imports generated audio into the Media Library, and renders a front-end player with per-post opt-out. Gated on provider work in `ai-provider-for-openai#42` / `ai-provider-for-google#31`. **An entire new experiment with no board card**, now in its second window uncarded.
> - **[#892](https://github.com/WordPress/ai/pull/892) Bring over embeddings support from the PHP AI Client** (dkotter, +4,394 across 19 files) vendors the client's embedding code into `includes/Vendor/AiClient` behind a new `SDK_Overlay` class. It exists because embedding support landed in php-ai-client 1.4.0 while its core route (`wordpress-develop#12530`) slipped **WP 7.1 → 7.2**. Successor to closed PoC #851 and likely substrate for #683/#844 — load-bearing and uncarded for a second window.
> - **[#913](https://github.com/WordPress/ai/pull/913) Update our preferred models** (dkotter, 13 files) switches the default Anthropic / Google / OpenAI text-and-vision models to `claude-sonnet-5`, `gemini-3.6-flash`, and `gpt-5.6-luna`, and **removes custom temperature setting entirely** (GPT-5.5+ rejects temperature unless reasoning is off). It also **deprecates the `wpai_meta_description_result_temperature` filter**. A user-visible default change plus a public-filter deprecation, with no card and no linked issue.
> - **[#909](https://github.com/WordPress/ai/pull/909)** (dkotter, +500/-17 across 9 files) rewrites the encryption-experiment documentation after users misread its guarantees — it does *not* wall API keys off from other plugins — and fixes caller attribution so log hooks record the calling plugin rather than always the AI plugin. Documentation-plus-fix, no card.
> - **[#889](https://github.com/WordPress/ai/pull/889)** (murshed) remains a genuine request-log accessibility/keyboard fix whose body still contains the unfilled template line `Closes #<issue-number>` — a one-line authoring slip, unchanged for two windows and still the cheapest of the six to resolve.
>
> There are no `routine` or `linked-off-board-issue` PRs this window. Three PRs left the census (#747 merged, closing #187; #621 and #898 closed unmerged) and four opened. **The one bright spot in coverage:** new PR **#914** arrived with a proper `Closes #906` reference against a board card filed three days earlier — the whole issue → card → PR → link chain executed correctly, which is exactly what the six unexplained PRs skip. Note also that **#749, #887, and #897 all picked up CHANGES_REQUESTED** this window, the only readiness movement in the repo. The live gap is generated by `./wp-ai-roadmap-refresh.sh`; run `--strict --json` for the audit form that exits `2` while any unexplained/off-board substantive PR remains.

### Full-repository PR/release radar

These upstream repositories are fully enumerated by the refresh script, including normalized open PR records, readiness changes, release history/diffs, validation, and independent PR/release snapshots. They are **census-only**: their work can affect the WordPress AI delivery path, but their PRs are not expected to have Project #240 cards.

| Repository | Open PRs | Latest release | Relationship to this roadmap |
|---|---:|---|---|
| [`WordPress/php-ai-client`](https://github.com/WordPress/php-ai-client) | **24** *(+3)* | **1.4.0** (2026-07-15) | Provider-agnostic PHP AI client used by the WordPress AI stack; embedding, streaming, model-selection, schema, and provider work can change plugin capabilities. Three PRs opened and none closed this window: **#266** (preserve Guzzle HTTP error responses), **#267** (avoid `file_exists()` on oversized strings), and **#269** (**text extraction / OCR / document parsing**, +1,618 lines — a new client-level modality). Its shipped 1.4.0 embedding support is still what off-board PR #892 vendors into the plugin. |
| [`WordPress/mcp-adapter`](https://github.com/WordPress/mcp-adapter) | **20** *(+4)* | **v0.5.0** (2026-04-15) | Bridges Abilities to MCP; transport, exposure, approval, schema, session, and server-registration work affects agent integrations. **#251** and **#254** merged on 2026-07-27 — the latter makes MCP exposure inherit public ability exposure upstream, resolving last window's flag against the plugin-side governance thread (#863/#354). Six opened: #258 (resource meta), #259 (nullable singletons / WP-CLI alias), and one DTO-normalization workstream counted four times — draft **#260** plus overlapping same-scope cuts **#262**/**#263**/**#264**, all four against upstream issue #245. Readiness: #244 BLOCKED → DIRTY. Twenty open PRs against an April release. |

Membership lives in [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json). Run `./wp-ai-roadmap-refresh.sh census --strict` for the complete live census; the existing five-way board-coverage classification remains exclusive to `WordPress/ai`.

---

## ① Dated release lanes

### v1.2.0 — ✅ Shipped 2026-07-14 — 1 residual board-open issue

The `WordPress/ai` release shipped and milestone #19 is closed. Project #240 still has one non-Done 1.2.0 card in another repository:

| Issue | Status | Summary |
|---|---|---|
| [#23](https://github.com/WordPress/ai-provider-for-google/issues/23) | In discussion / Needs decision | [Bug]: Image Generation fails with "Unexpected Google API response: Missing the candidates[0].content key" |

This is provider follow-up, not unfinished code in the released plugin.

### v1.3.0 — Active — 15 non-Done (9 issues + 6 PRs)

The lane went **9 Done / 18 open → 8 Done / 15 open**, and only one of the three departures was delivery. **#187 (multilingual rewriting and translation) shipped** — PR #747 merged 2026-07-28 and closed it, the lane's first experiment to land since the six that closed last window. The other two left without shipping: **#736** (role/user access controls) was re-milestoned to Future Release while its PR #749 picked up CHANGES_REQUESTED, and **PR #621** was closed unmerged and marked Done. The Done count fell from 9 to 8 because two already-Done 1.3.0 cards (#870, #872) were de-carded in the same pass.

What remains is the harder half: one review-blocked UX issue, four infrastructure/logging items, and the C2PA and Abilities-toggle experiments.

| Issue | Status | Summary |
|---|---|---|
| [#421](https://github.com/WordPress/ai/issues/421) | In progress | WordPress should detect C2PA manifests on upload |
| [#514](https://github.com/WordPress/ai/issues/514) | In progress | Add comment value / relevance to Comment Moderation experiment |
| [#660](https://github.com/WordPress/ai/issues/660) | Needs review | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals |
| [#690](https://github.com/WordPress/ai/issues/690) | In progress | Plugin does not clean up database table and options on uninstall |
| [#732](https://github.com/WordPress/ai/issues/732) | In progress | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible |
| [#741](https://github.com/WordPress/ai/issues/741) | In discussion / Needs decision | AI Admin Pages Exhibit Visible Flicker During Initial Render |
| [#845](https://github.com/WordPress/ai/issues/845) | In progress | New Experiment: Markdown feeds (powered by `html-to-md`) |
| [#863](https://github.com/WordPress/ai/issues/863) | To do | New Experiment: Abilities toggle |
| [#866](https://github.com/WordPress/ai/issues/866) | In progress | Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix |

#### Open PRs (6)

#### PR #459 — Add C2PA Monitor experiment · *In progress · not draft · BLOCKED · CHANGES_REQUESTED · +3140/-0, 16 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/459) · @lnispel
**Delivers.** Read-only infra detecting C2PA Content Credentials in uploaded JPEG/PNG/WebP at `add_attachment` (before subsize generation destroys them). Streaming container walks (JPEG APP11/JUMBF reassembly, PNG `caBX`, WebP RIFF `C2PA`) with byte caps; writes raw manifest to a sidecar + a `_wpai_monitor_record` postmeta; SHA-256 hashing; fail-open. Claim decoding, admin UI, crypto verification deferred. (Read-only sibling to the #294/#302 signing work; conceptually implements issue [#421](https://github.com/WordPress/ai/issues/421).)
**Blockers.** dkotter requested changes: set `capability` to `none`; move README under `docs/experiments`; reset `@since` to `x.x.x`; translate error strings; **reconsider sidecar security** (`.htaccess` only protects Apache → prefer non-public storage).

#### PR #683 — Add native vector search · *In progress · draft · DIRTY · +8565/-4, 37 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/683) · @artpi
**Delivers.** A new opt-in `rag-search` experiment for semantic search/RAG. Primary path uses MariaDB 11.8+ `VECTOR(1536)` storage plus a cosine vector index and OpenAI `text-embedding-3-small`; fallback stores embeddings in post meta and searches in memory for smaller sites. Adds indexing lifecycle hooks, one-hour dirty-post cron scheduling, transactional replace-by-post behavior where possible, cleanup hooks, `wp ai rag` WP-CLI utilities, public-search augmentation, and related-posts output.
**Blockers.** Draft; merge-state **CONFLICTING** (needs rebase). Still needs review and a future migration to embeddings supplied by the WP AI Client once available. Operationally gated on supported MariaDB and an authenticated OpenAI connector for the vector-index path. Now scheduled for 1.3.0.

#### PR #764 — Add a core/manage-settings ability · *In progress · not draft · DIRTY · +408/-11, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/764) · @jorgefilipecosta
**Delivers.** The write-oriented `core/manage-settings` ability — the counterpart to the read-only `core/settings` added in #691. Takes a map of setting name → new value (reusing each setting's own value schema, `additionalProperties: false`); permission `manage_options`; annotations `readonly:false, destructive:false, idempotent:true`. **Atomic, all-or-nothing**: the Abilities API validates the whole input against the schema before any `update_option()` fires, matching `WP_REST_Settings_Controller::update_item()`.
**Blockers.** The branch is currently DIRTY against `develop` and needs refresh/review. It pairs with `core/settings` (#691) and the now-merged `core/read-content` (#739).

#### PR #777 — dev: Update Composer deps and remediate PHPStan smells · *In progress · draft · DIRTY · +106/-36, 13 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/777) · @justlevine
**Delivers.** Tooling hygiene: bumps Composer dependencies to their latest versions and fixes the resulting PHPStan errors (including updating `php-stubs/wordpress-stubs`). No feature impact.
**Blockers.** Draft; awaiting review.

#### PR #832 — chore(deps): drop @wordpress dependencies to wp-7.0 versions · *In progress · draft · DIRTY · +12969/-8969, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/832) · @justlevine
**Delivers.** Dependency alignment: pins the bundled `@wordpress/*` packages to the versions shipping in **WP 7.0** (rather than newer Gutenberg majors), part of the wp-7.0 compatibility pass alongside #789 and the dependabot `@wordpress` bumps (#824–#827). The large diff is the regenerated lockfile.
**Blockers.** Draft; no feature impact. Complements #831 (which now pins NPM deps and tells dependabot to ignore `@wordpress`).

#### PR #858 — Abilities API: add core/read-nav-menus ability · *Needs review · not draft · BLOCKED · +870/-0, 3 files · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/858) · @Builder106
**Delivers.** A read-only `core/read-nav-menus` ability that lists menus and theme-location assignments or fetches one menu by ID, slug, or location with its items. It uses `edit_theme_options`, follows the existing read-users/read-settings pattern, and is intended to land here before a WordPress Core proposal.

**Blockers.** GitHub now reports the PR as **BLOCKED** (checks are green, but no approving review is recorded), where it previously showed a dirty branch. The permission boundary and eventual Core ownership remain the substantive review points.

### v1.4.0 — Next — 2 issues (both In discussion)

| Issue | Status | Summary | Implementing PR |
|---|---|---|---|
| [#27](https://github.com/WordPress/ai/issues/27) | In discussion / Needs decision | Display additional AI provider plugins on Connectors page (alongside default Anthropic, Google, and OpenAI ones) | — |
| [#324](https://github.com/WordPress/ai/issues/324) | In discussion / Needs decision | Evolve Refine from Notes into collaborative and agentic editorial workflows | — |

**This lane halved, and last window's optimism is what got corrected.** #875 (internal links) and #876 (permalink slugs) were **re-milestoned out of 1.4.0 into Future Release**. Last window they had just moved to In progress on the strength of freshly-opened PRs #887 and #897, and this file warned that the moves reflected code appearing, not product questions being answered. That reading held: both PRs have since picked up **CHANGES_REQUESTED**, both issues kept their open decisions, and both cards left the dated lane. They stay In progress under Future Release, so the work continues — it is simply no longer scheduled.

What remains in 1.4.0 is the residue: provider discovery (#27) and agentic Refine/RTC (#324), both genuinely undecided, with no code at all and no movement this window. **v1.4.0 currently contains nothing that anyone is building.**

---

## ② Planned backlog — Future Release (44)

**Three cards arrived here by re-milestoning, not by triage:** #736 (role/user access controls) from 1.3.0, and #875 / #876 (internal links, permalink slugs) from 1.4.0. All three are **In progress with live PRs** (#749, #887, #897 respectively), so this tier now holds active implementation work that simply has no release attached to it. Read "Future Release" here as *unscheduled*, not *inactive*.

### Issues (37)

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
| [#193](https://github.com/WordPress/ai/issues/193) | Backlog | Add developer-only log panel for inspecting AI provider responses |
| [#203](https://github.com/WordPress/ai/issues/203) | In progress | Add extensibility hook for custom Ability Table columns |
| [#233](https://github.com/WordPress/ai/issues/233) | In progress | Refactor experiments to leverage AI_Service layer — ⚠️ **premise reversed:** implementing PR #898 closed unmerged, and off-board PR [#905](https://github.com/WordPress/ai/pull/905) now *deletes* the `AI_Service` layer instead. Card title and status no longer describe the work. |
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
| [#736](https://github.com/WordPress/ai/issues/736) | In progress | Expose role/user access controls per feature/experiment *(re-milestoned from 1.3.0)* |
| [#791](https://github.com/WordPress/ai/issues/791) | In discussion / Needs decision | Add loading animation/custom cursor for Type Ahead |
| [#844](https://github.com/WordPress/ai/issues/844) | In progress | New Experiment: Semantic search in wp admin |
| [#875](https://github.com/WordPress/ai/issues/875) | In progress | New Experiment: Suggest internal links within post content *(re-milestoned from 1.4.0)* |
| [#876](https://github.com/WordPress/ai/issues/876) | In progress | New Experiment: Suggest permalink slugs *(re-milestoned from 1.4.0)* |

### Open PRs (7)

#### PR #211 — Add Service Account experiment · *In discussion / Needs decision · draft · DIRTY · +3853/-0, 8 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/211) · @Jameswlepage
**Delivers.** Exploratory **Service Account** experiment: a real, creatable user type for non-interactive/automation access (Claude Code, automation, APIs). Adds a Service role, Users → Add New customizations, a Service Accounts list view, and REST CRUD + application-password regeneration.
**Blockers.** Genuinely exploratory — the author frames it as a **"do we need this?"** question; provider-specific labels would need removing if it advances. Draft, no reviews — a concept for decision, not a merge candidate.

#### PR #224 — Add WebMCP adapter experiment · *In discussion / Needs decision · draft · DIRTY · +2371/-55, 9 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/224) · @Jameswlepage
**Delivers.** A `webmcp-adapter` experiment exposing layered `navigator.modelContext` (WebMCP) tools in wp-admin for discovering/inspecting/executing Abilities. Adds `is_available()`/`get_unavailable_reason()` to `Abstract_Experiment`, gates on Abilities API availability, enforces server-side option sanitization.
**Blockers.** Functionally validated (abilities executed via WebMCP in Chrome Canary) but **held by spec instability** — WebMCP is a fast-moving W3C CG draft (tool-registration shape already changed). swissspidy recommended stepping back to discussion issue #448 and exploring declarative form-exposure first. Current merge state is **DIRTY** and the branch needs an update before review.

#### PR #494 — [Feature]: Issue 238 | Focus-aware crop suggestions · *In progress · not draft · DIRTY · +2152/-315, 9 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/494) · @TylerB24890
**Delivers.** A `Suggest_Image_Crops` experiment + Ability: feeds an image (data URI) to a vision model that returns focal point + crop-window coordinates in Focal-Point-Picker space. Adds a shared `Resolves_Image_Reference` trait and refactors `Alt_Text_Generation` to use it. Customizable aspect ratios via filter.
**Blockers.** **[Status] Blocked** — the Gutenberg Media Editor modal isn't yet extensible (epic gutenberg#73771); no UI surface until `registerImageEditorPanel()` (name TBD) lands. Backend Ability works standalone via the Abilities Explorer. Related: #325, PR [#446](https://github.com/WordPress/ai/pull/446) (already merged in 1.0.0).

#### PR #695 — Add: AI-assisted payload generation to the Ability Explorer - Test Ability Screen · *In progress · not draft · BLOCKED · CHANGES_REQUESTED · +357/-38, 5 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/695) · @Arkenon
**Delivers.** Adds AI-assisted payload generation to the Ability Test Runner: users describe a test scenario in natural language and the tool generates a valid JSON payload from the selected ability's input schema — lowering the bar to exercise abilities with complex inputs.
**Blockers.** **Came out of draft this window** but remains BLOCKED with CHANGES_REQUESTED and failing checks; address review feedback before another mergeability check.

#### PR #760 — PoC: Basic integration with Chrome DevTools for agents · *Needs review · not draft · BLOCKED · +474/-0, 16 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/760) · @dkotter
**Delivers.** A third-party integration exposing the site's available AI Features — plus a lightweight log of which Features ran recently — to Chrome DevTools for agents, which recently added 3P-tool support. A deliberately basic proof-of-concept to validate the surface.
**Blockers.** PoC framing — a "does this direction have legs?" exploration rather than a finished feature. Checks are green but the PR is BLOCKED with no approving review; product direction and review are still needed.

#### PR #765 — Add Repo Automator action · *In progress · not draft · BLOCKED · +48/-0, 1 file · Future Release*
[Link](https://github.com/WordPress/ai/pull/765) · @jeffpaul
**Delivers.** Repo-ops tooling, not a user feature: a `.github/workflows/repo-automator.yml` running 10up/action-repo-automator on the `develop` branch to auto-label, comment, and assign reviewers on PRs/issues — operational support for the rising issue/PR volume (jeffpaul + dkotter).
**Blockers.** Awaiting review; no feature impact. Remains in Future Release.

#### PR #789 — Update bundled wp deps (theme, ui, dataviews, admin-ui) · *In progress · not draft · DIRTY · +629/-538, 4 files · Future Release*
[Link](https://github.com/WordPress/ai/pull/789) · @simison
**Delivers.** Refreshes the bundled `@wordpress/*` packages (theme, ui, dataviews, admin-ui) pulled from Gutenberg. Dependency maintenance; no feature impact.
**Blockers.** Currently DIRTY against `develop`; refresh dependencies before review.

> **The `AI_Service` thread resolved against this lane's own card.** Off-board PR **#898** ("Refactor experiments to leverage ai service layer"), which last window was the fresh authoritative closing PR for **#233**, was **closed unmerged on 2026-07-27**. Its replacement, off-board PR **#905**, *removes* `AI_Service` entirely — jeffpaul's long-unanswered "should we refactor it out instead?" question on #233 was answered, and the answer was yes. Board card #233 still reads "Refactor experiments to leverage AI_Service layer / In progress", which is now the opposite of what is being built. Because #905 declares no `closing` reference, nothing propagates that decision to the board.
>
> **Still open from last window:** PR **#851** ("PoC: Test upcoming embedding changes") was closed unmerged on 2026-07-22 exactly as its author intended, and its purpose is still carried by off-board PR **#892**, which vendors the released php-ai-client 1.4.0 embedding code into `includes/Vendor/AiClient` behind an `SDK_Overlay`. That successor remains **uncarded** — the embeddings thread has now spent two full windows untracked-but-load-bearing.

---

## ③ Straggler — 1

- **[PR #484](https://github.com/WordPress/ai/pull/484) — "Ignore .wp-env.test.override.json"** is already merged (2026-04-29) but remains board-Needs review under 0.9.0. It is a board-hygiene item, not pending delivery.

**Removed-board reference:** [WordPress/abilities-api#84](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not part of Project #240.

---

## ④ Unscheduled — 3

| Issue | Status | Summary |
|---|---|---|
| [#869](https://github.com/WordPress/ai/issues/869) | Triage | window.aiProviderData is only attached to the block-editor iframe snapshot, never to the top window, causing "requires an AI Connector" false positives |
| [#890](https://github.com/WordPress/ai/issues/890) | Triage | Add mobile right sidebar display component |
| [#906](https://github.com/WordPress/ai/issues/906) | **In progress** | Request Logging: no public API to record the reserved `mcp_tool` and `ability` log types |

- **#906 is the exception in this tier and the cleanest card on the board this window.** Filed 2026-07-29 by azizulhasan with a precise diagnosis — the log's REST read contract and its TypeScript client both advertise `ai_client | mcp_tool | ability`, but the only writer hardcodes `ai_client`, and every accessor to the manager is `private`, so an external MCP or ability surface can only write by constructing its own `AI_Request_Log_Manager` and bypassing the experiment-enabled check. dkotter agreed the same day ("happy to review a PR when it's ready"); **PR [#914](https://github.com/WordPress/ai/pull/914) opened 2026-08-01 with a proper `Closes #906`**, adding `log_ai_request()`, a `get_types()` single source of truth that the REST enum derives from, type validation on `log()`, and a `wpai_ai_request_logged` action. It is unmilestoned only because nobody has assigned it a release — not because it is unscoped. Note the flagged behavior change: `log()` now refuses unknown types via `_doing_it_wrong()`, so any existing caller passing a custom type would start losing rows.
- **#906 composes with, and does not duplicate, #732.** #732 covers provider *transports* that bypass the SDK HTTP path (PR #757 in flight); #906 covers log *types* the schema already reserves but nothing can produce.
- **#869** still needs a clean-environment/develop-branch reproduction; current discussion suggests the top-window failure may be environment-specific. Open in Triage since 2026-07-15 with no movement this window.
- **#890** arrived 2026-07-23 with no labels, milestone, assignee, or comments, and still does not say which AI surface it targets or whether the responsibility sits in `WordPress/ai` at all rather than in Gutenberg's editor chrome. Unchanged this window. Triage before scoping.

---

## ⚠️ Data-quality flags (verify before acting)

1. **PR #484 is merged**, not open, despite its board status.
2. **"Done" does not mean shipped — PR #621 is the proof.** It was closed **unmerged** on 2026-07-28 after weeks of contributor silence (dkotter: "happy to re-open"), then marked board-**Done** with its 1.3.0 milestone stripped. Its uploads-base-URL hardening is not in `develop` and has no successor PR. Any velocity or completion metric read off board-Done status will count this as delivered. Check `state`/`mergedAt`, not board status.
3. **Board ≠ repo, and the gap doubled:** 33 open PRs = 13 direct-board-pr + 14 linked-board-issue + 0 routine + 0 linked-off-board-issue + **6 unexplained (#888, #889, #892, #905, #909, #913 — the current strict-audit failures)**. The count still understates it: two are ~4,200–4,400-line maintainer features, one changes user-facing model defaults and deprecates a public filter, and one reverses a board card's stated direction.
4. **A board card can be actively contradicted by its own implementation.** #233 reads "Refactor experiments to leverage AI_Service layer / In progress"; PR #898 (which adopted the layer) closed unmerged, and PR #905 now deletes the layer. #905 declares no `closing` reference, so the board will not learn this on its own. Treat #233's title and status as stale.
5. **A falling board total is not lost scope.** The board went 274 → 269 because seven already-Done cards were de-carded (six 1.2.0/1.3.0 items plus unmilestoned #865); check `.board.removed` before reading any drop as descoping.
6. **A shrinking dated lane is not delivery.** v1.3.0 went 18 → 15 and v1.4.0 went 4 → 2, but only #187 shipped; #736, #875, and #876 were re-milestoned into Future Release and #621 was closed unmerged. Three of four milestone moves this window pushed work *out* of a dated release.
7. **1.2.0 is shipped and its GitHub milestone is closed**, but external provider issue #23 still carries that milestone and remains board-open.
8. **Board-added ≠ real work.** #900 ("Why Red Hat OpenShift AI Is Becoming Essential…") is webinar spam that was carded, closed, and marked Done the same day. It is one of the two cards added this window; only #906 is substantive. Exclude spam before reading "cards added" as intake.
9. **#869 is not yet a clean-environment repro.** The reporter could not retest `develop`; do not treat it as a confirmed universal regression.
10. **#890 is unscoped.** No labels, milestone, assignee, comments, or named target surface — do not plan against it until triage identifies whether it is even a `WordPress/ai` concern.
11. **The provenance shape is settled but review-blocked:** signing PRs #294/#302 closed without merge; the read/monitoring PR #459 is the sole live path, is the **authoritative closing PR for #421**, and carries CHANGES_REQUESTED including a sidecar-storage security objection.
12. **#844 opened ahead of its stated blocker.** The issue was filed as blocked on #683 for its embedding pipeline, yet PR #891 opened while #683 is still a DIRTY draft — and #891 has now picked up CHANGES_REQUESTED. Verify the two are not building duplicate indexing machinery, and factor in #892's vendored embedding layer.
13. **Merge-state fields are volatile** and should be rechecked before prioritization — but the aggregate is worth stating plainly and it has not improved: **every one of the 33 open `WordPress/ai` PRs is BLOCKED (21) or DIRTY (12); none carries an APPROVED review; 17 have failing checks and 14 carry CHANGES_REQUESTED** (up from 11). Nothing in the repository is currently in a mergeable state. Review capacity and branch freshness, not contribution volume, remain the bottleneck.
14. **GitHub's `mergeStateStatus` can transiently read `UNKNOWN`.** It is computed asynchronously, so a census taken immediately after a board change may report `UNKNOWN` for many PRs and then real values minutes later — which surfaces as a burst of spurious `readiness_changed` rows. The 2026-08-01 baseline was captured with real values (21 BLOCKED / 12 DIRTY, zero UNKNOWN). If a run reports wholesale `→ UNKNOWN` transitions, re-run before treating it as movement.
15. **Cross-repo signals are separate:** neither the 16-item Gutenberg/abilities-api dependency watchlist nor the full `php-ai-client` / `mcp-adapter` PR-release censuses are included in Project #240 counts; coverage validation applies only to `WordPress/ai`.

---

## 🔭 Work for Later

- [x] **Ship v1.2.0** — released 2026-07-14 and deployed to WordPress.org.
- [x] **Clarify #851's PoC lifecycle** — closed unmerged 2026-07-22 as designed; succeeded by #892.
- [x] **Define the Yoast integration contract for #874** — root-caused to Yoast's `yoast-seo/editor` store plus `post`-only REST meta registration, fixed in merged PR #886, and filed upstream as `Yoast/wordpress-seo#23458`.
- [x] **Settle the `AI_Service` direction (#233)** — answered this window, against the card: #898 closed unmerged, and #905 removes the layer as dead code. *Follow-up below: the board hasn't been told.*
- [ ] **Correct board card #233** to reflect removal rather than adoption, or close it against #905. Its title, status, and the actual work now disagree.
- [ ] **Card the uncarded features — now six, not three.** #888 (Text to Speech) and #892 (vendored embeddings) have gone two windows uncarded; #905 (AI_Service removal), #913 (default model change + public-filter deprecation), #909 (encryption docs + caller-attribution fix), and #889 (log a11y) joined them. Still the single highest-value board-hygiene action, and now twice the size.
- [ ] **Unblock the review queue.** All 33 open PRs are BLOCKED or DIRTY with zero approvals; triage which of the 14 CHANGES_REQUESTED PRs are close to landing.
- [ ] **Decide whether #621's hardening still matters.** It was closed for contributor inactivity, not because the concern was dismissed — if the uploads-URL boundary check is worth having, it needs a new PR; if not, say so on the issue.
- [ ] **Reconcile the three embeddings efforts** — #683 (draft, board-tracked), #891/#844 (opened ahead of its #683 blocker, now CHANGES_REQUESTED), and #892 (uncarded `SDK_Overlay` vendoring) — before duplicate indexing machinery ships.
- [ ] **Give v1.4.0 content or retire the lane.** Both of its In-progress cards were re-milestoned out; what remains (#27, #324) has no code and no decisions.
- [ ] **Milestone #906/#914.** The cleanest issue→card→PR chain on the board is sitting unmilestoned in tier ④.
- [ ] **Close or re-milestone provider issue #23** now that the plugin's 1.2.0 milestone is closed.
- [ ] **Resolve standalone-ability governance (#863)** before additional write/destructive abilities expand the always-registered surface — #888 would add two more (`ai/speech-generation`, `ai/speech-import`) outside that conversation. Upstream, `mcp-adapter#254` merged this window and now inherits public ability exposure for MCP, so the upstream half moved while the plugin half did not.
- [ ] **Land the C2PA path:** #459 is the confirmed closing PR for #421 and needs its CHANGES_REQUESTED items addressed, including the sidecar-storage security objection.
- [ ] **Rebase/review the v1.3.0 PR lane**, especially DIRTY #683/#764/#777/#832 and BLOCKED #459/#858.
- [ ] **Reproduce #869 cleanly** and triage #890 into a defined scope. Neither moved this window.
- [ ] **Fix board hygiene** for merged PR #484.
- [ ] **Decide whether off-board PRs should receive PR cards** or remain represented only through their backing issue cards.
- [x] **Maintain the refresh workflow** — `wp-ai-roadmap-refresh.sh` passes `bash -n`, the six offline fixture suites, and the live 16-ID dependency smoke test in this refresh.

---

## Changelog

| Date | Change |
|---|---|
| 2026-08-01 | **Live board + repo refresh vs the 2026-07-27 08:51 UTC baseline.** Non-Done scope **67 → 66** = **52** open issues (flat) + **13** open board PRs + stale merged #484. **Only one card shipped, but four milestones moved — three of them backwards.** Tier moves: **① v1.3.0 18 → 15** (11i+7PR → 9i+6PR) — #187 (multilingual rewriting/translation) closed via merged PR **#747**, #736 re-milestoned to Future Release, and PR card **#621 closed unmerged yet marked board-Done**; **① v1.4.0 4 → 2** — **#875 and #876 re-milestoned out to Future Release**, exactly reversing last window's "no longer discussion-only" note, and both their PRs (#887/#897) picked up CHANGES_REQUESTED; **② Future Release 41 → 44** (34i+7PR → 37i+7PR), absorbing all three re-milestoned cards, which stay In progress with live PRs; **④ Unscheduled 2 → 3** with board-new **#906** (public API for the reserved `mcp_tool`/`ability` log types, In progress, PR **#914** opened 2026-08-01 with a proper `Closes #906`); **③ straggler #484 unchanged**. Delivery-readiness by status: In progress **26** (flat), In discussion **22** (flat), Needs review **5 → 4**, Backlog **7**, To do **4**, Triage **3**. Board totals **274 → 269**; Done **207 → 203** — seven already-Done cards de-carded (#614/#778/#853/#864/#870/#872 + unmilestoned #865), offset by newly-Done #187/#621 and same-day spam card **#900**. Repo gap **32 → 33 open PRs** = **13 direct + 14 linked + 0 routine + 0 off-board + 6 unexplained**; three PRs left (#747 merged; #621 and #898 closed unmerged) and four opened. **The unexplained set doubled and now includes a strategy reversal:** off-board **#905** deletes the `AI_Service` layer — answering jeffpaul's long-open question on **#233** in the opposite direction from that card's title, after its predecessor #898 closed unmerged — while **#913** changes default models to `claude-sonnet-5`/`gemini-3.6-flash`/`gpt-5.6-luna`, removes temperature setting, and deprecates the public `wpai_meta_description_result_temperature` filter; **#909** rewrites encryption-experiment docs and fixes caller attribution; #888/#892/#889 remain uncarded for a second window. None declares a `closing` reference, so none of it reaches the board. **Repo-wide readiness got worse, not better:** all 33 open PRs are BLOCKED (21) or DIRTY (12), none APPROVED, 17 failing checks, **CHANGES_REQUESTED 11 → 14** (#749, #887, #897 added — the window's only readiness movement). Upstream radar: `php-ai-client` **21 → 24** (new #266/#267/#269, the last adding OCR/document-parsing) / 1.4.0; `mcp-adapter` **16 → 20** (#251 and #254 merged; #258/#259 plus the overlapping #260/#262/#263/#264 DTO-normalization cluster opened, all four against upstream issue #245; #244 BLOCKED → DIRTY) / v0.5.0. Dependency watchlist static at 16 (10 open / 3 closed / 3 merged) for a second window. **New data-quality flags:** board-Done ≠ shipped (#621), a card can be contradicted by its own implementation (#233/#905), spam can enter as a board card (#900), and GitHub's `mergeStateStatus` reads `UNKNOWN` transiently — the persisted baseline was captured with real values. Script passes `bash -n`, the six offline fixture suites, and the live 16-ID dependency smoke test; snapshots rolled forward. |
| 2026-07-27 | **Live board + repo refresh vs the 2026-07-20 06:15 UTC baseline.** Non-Done scope **74 → 67** = **52** open issues + **14** open board PRs + stale merged #484. Tier moves: **① v1.3.0 22 → 18** (14i+8PR → 11i+7PR) as six issues closed via merged PRs — #191←#734, #192←#770, #452←#633, #507←#861, #874←#886, #883←#884 — and PR cards #882 (merged) / #851 (closed unmerged) left the lane; **① v1.4.0 holds at 4 but is no longer discussion-only** — #875←#887 and #876←#897 moved In discussion → In progress, while #27/#324 stay undecided; **② Future Release 43 → 41** (35i+8PR → 34i+7PR) with #192 re-milestoned out to 1.3.0, #851 de-milestoned on close, and #233/#844 moving To do/Backlog → In progress behind PRs #898/#891; **④ Unscheduled 3 → 2** — #874 and #883 closed, board-new Triage issue **#890** (mobile right sidebar, unlabeled/unscoped) added; **③ straggler #484 unchanged**. Delivery-readiness by status: In progress **26** (flat), In discussion **24 → 22**, Needs review **7 → 5**, Backlog **8 → 7**, To do **6 → 4**, Triage **3**. Board totals **283 → 274**; Done **209 → 207** — the fall is **10 already-Done 1.2.0 cards de-carded** (#508/#793/#809/#815/#816/#818/#833/#839/#846 + spam #848), not descoping. Repo gap **37 → 32 open PRs** = **14 direct + 15 linked + 0 routine + 0 off-board + 3 unexplained**; 12 PRs left (10 merged incl. former audit failures #877/#878; #851/#885 closed unmerged) and 7 opened. **New coverage risk is qualitatively worse:** #888 (Text to Speech experiment, +4,216/28 files, two new abilities, gated on `ai-provider-for-openai#42`/`ai-provider-for-google#31`) and #892 (PHP AI Client embeddings vendored behind `SDK_Overlay`, +4,394, forced by the WP 7.1 → 7.2 slip of `wordpress-develop#12530`) are large maintainer features with no board card; #889 is an a11y fix with an unfilled `Closes #<issue-number>`. **Authoritative correction:** PR #459 `closing`-links #421 — previously recorded as merely conceptual. **Repo-wide readiness note added:** all 32 open PRs are BLOCKED (19) or DIRTY (13), none APPROVED, 17 failing checks, 11 CHANGES_REQUESTED. Upstream radar: `php-ai-client` **20 → 21** (new #264; #254 readiness change) / 1.4.0; `mcp-adapter` **12 → 16** (new #251/#252/#254/#256) / v0.5.0. Dependency watchlist static at 16 (10 open / 3 closed / 3 merged). Script passes `bash -n`, the six offline fixture suites, and the live 16-ID dependency smoke test; snapshots rolled forward. |
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
