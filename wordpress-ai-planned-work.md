# WordPress AI — Planned (Not-Yet-Shipped) Work

> The **delivery plan** for every Project #240 card not in Done. It includes issue cards and board-tracked PRs, ordered by milestone. ⚠️ **Scope caveat:** `WordPress/ai` has **28 open PRs**, while Project #240 has PR cards for 16 of them; see [Board vs. repo](#board-vs-repo-pr-coverage-five-classifications). Full census-only tracking for `WordPress/php-ai-client` and `WordPress/mcp-adapter` appears below and does not expand Project #240 scope.
>
> Part of a 4-doc set: [`wordpress-ai-roadmap.md`](./wordpress-ai-roadmap.md) (strategy + tracker) · [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md) (issue dossiers) · [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md) (upstream dependencies + repository radar) · **this file** (release-ordered delivery plan + PR census).
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-08-14 (board + live PR/issue/release checks) |
> | **Scope** | **65 non-Done cards** = 48 open issues + 16 open board-tracked PRs + stale merged PR #484 |
> | **Latest shipped** | **v1.2.0** (2026-07-14; 18th release) |
> | **Repository radar** | Open PRs / open issues — `php-ai-client`: **28 / 34** (1.4.0) · `mcp-adapter`: **12 / 41** (v0.6.1) · `abilities-api`: **14 / 8** (v0.4.0, ⚠️ pending archival). Census-only; no Project #240 coverage gate. |
> | **Active / next** | **v1.3.0:** 2 open (release residue: #421 + #924, target 2026-08-17) · **v1.4.0:** 19 open (11 issues + 8 PRs) · **Future Release:** 41 open |
> | **For issue detail** | See the [open-issues dossier](./wordpress-ai-open-issues.md). |

## How "planned" is tracked here

This file mirrors **board status**, not a promise that every card will ship. "Done" is excluded; all other statuses are included and grouped by milestone.

### Commitment ladder (65 non-Done cards)

| Tier | Cards | Interpretation |
|---|---:|---|
| **v1.3.0** | **2** | **In its release window.** The lane drained 21 → 2 as seven issues closed by merged PRs; what remains is C2PA #421 and release issue #924 (target 2026-08-17) |
| **v1.4.0** | **19** | **The next lane, finally loaded:** 11 issues + 8 PRs. Thirteen cards re-milestoned in from 1.3.0, plus #888/#916/#917 and board-new #933 |
| **Future Release** | **41** | Unscheduled backlog: 33 issues + 8 PRs — gained #923/#931/#890/#918, lost #600/#736 to 1.4.0 |
| **1.2.0 residual** | **1** | Google-provider issue #23 remains board-open after the plugin release shipped |
| **Unmilestoned** | **1** | Board-new In-discussion issue #940 (custom settings endpoint vs `/wp/v2/settings`) |
| **Stale shipped-milestone card** | **1** | PR #484 is merged but still board-Needs review under 0.9.0 |

> **The dated lane finally shipped its way down instead of re-labelling.** Last window the 1.3.0 growth was pure re-milestoning; this window it drained 21 → 2 by delivery (seven issues closed by merged PRs, two PR cards merged, five PRs arrived Done). The milestone churn moved one lane right: 1.4.0 absorbed the residue of 1.3.0 plus newcomers, so its 2 → 19 rise is the same re-labelling plus real intake — read it as a loaded queue, not as decisions made.

### Delivery readiness at a glance

| Board status | Cards |
|---|---:|
| In progress | **23** |
| Needs review | **8** |
| Backlog | **6** |
| To do | **4** |
| Triage | **3** |
| In discussion / Needs decision | **21** |

> "In discussion" is directional, not committed. The board's active implementation signal is the combination of In progress/Needs review cards and the live repository PR census.

---

## 🚀 New experiments & features in the pipeline

### Code already in flight (16 open board-tracked PRs)

| PR | Milestone | Board status | Live readiness (draft · review · merge · checks) |
|---|---|---|---|
| [#211](https://github.com/WordPress/ai/pull/211) Add Service Account experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks FAILURE |
| [#224](https://github.com/WordPress/ai/pull/224) Add WebMCP adapter experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks SUCCESS |
| [#494](https://github.com/WordPress/ai/pull/494) [Feature]: Issue 238 \| Focus-aware crop suggestions | Future Release | In progress | review — · merge DIRTY · checks SUCCESS |
| [#683](https://github.com/WordPress/ai/pull/683) Add native vector search | 1.4.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#695](https://github.com/WordPress/ai/pull/695) Add: AI-assisted payload generation to the Ability Explorer - Test Ability Screen | Future Release | In progress | review CHANGES_REQUESTED · merge BLOCKED · checks FAILURE |
| [#760](https://github.com/WordPress/ai/pull/760) PoC: Basic integration with Chrome DevTools for agents | Future Release | In progress | review — · merge BLOCKED · checks SUCCESS |
| [#764](https://github.com/WordPress/ai/pull/764) Add a core/manage-settings ability | 1.4.0 | In progress | review — · merge DIRTY · checks SUCCESS |
| [#765](https://github.com/WordPress/ai/pull/765) Add Repo Automator action | Future Release | In progress | review — · merge BLOCKED · checks FAILURE |
| [#777](https://github.com/WordPress/ai/pull/777) dev: Update Composer deps and remediate PHPStan smells | 1.4.0 | In progress | draft · review — · merge DIRTY · checks SUCCESS |
| [#789](https://github.com/WordPress/ai/pull/789) Update bundled wp deps (theme, ui, dataviews, admin-ui) | Future Release | In progress | review — · merge DIRTY · checks FAILURE |
| [#832](https://github.com/WordPress/ai/pull/832) chore(deps): drop @wordpress dependencies to wp-7.0 versions | 1.4.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#858](https://github.com/WordPress/ai/pull/858) Abilities API: add core/read-nav-menus ability | 1.4.0 | Needs review | review — · merge DIRTY · checks SUCCESS |
| [#888](https://github.com/WordPress/ai/pull/888) New Text to Speech experiment | 1.4.0 | **Needs review** *(newly carded)* | review — · merge DIRTY · checks FAILURE |
| [#916](https://github.com/WordPress/ai/pull/916) Content Classification: Dynamicize taxonomy error messages | 1.4.0 | **Needs review** *(newly carded)* | review CHANGES_REQUESTED · merge BLOCKED · checks FAILURE |
| [#917](https://github.com/WordPress/ai/pull/917) Content Resizing: Focus Accept button when suggested content generation completes | 1.4.0 | **Needs review** *(newly carded)* | review CHANGES_REQUESTED · merge BLOCKED · checks FAILURE |
| [#931](https://github.com/WordPress/ai/pull/931) Compare the core read abilities against the REST API | Future Release | **In progress** *(board-new)* | draft · review — · merge BLOCKED · checks FAILURE |

> The active feature/platform work includes native vector search (#683), WebMCP (#224), service accounts (#211), focus-aware crops (#494), Ability Explorer payload generation (#695), Core abilities (#764/#858), and the board-new REST-parity audit #931. **Two cards left the table by shipping (#889, #920), four joined it (#888, #916, #917, #931), and one left it by de-carding (#459).** **#888** — an unexplained PR for three straight windows — was finally carded under 1.4.0; the six-PR coverage gap is down to one. **#459** was removed from the board while its PR stays open (still `closing`-linked to #421), so the C2PA read path is now represented only by its issue. **No board PR is mergeable:** all 16 are BLOCKED or DIRTY, none has an approving review.

### Board vs. repo: PR coverage (five classifications)

The repo has **28 open PRs**. Every open PR gets exactly one coverage classification, joined to Project #240 by repository-qualified `repo#number` keys:

| Classification | Count | Meaning |
|---|---:|---|
| `direct-board-pr` | **16** | The PR itself is a Project #240 card (table above) |
| `linked-board-issue` | **11** | Off-board PR linked to an on-board issue — **all 11 via authoritative GitHub closing references**, no fallbacks |
| `routine` | **0** | Dependency/bot maintenance — no open dependabot PR is untracked |
| `linked-off-board-issue` | **0** | Links only to an issue that is not on the board |
| `unexplained` | **1** | **No identifiable roadmap relationship: [#941](https://github.com/WordPress/ai/pull/941) "Content Translation: Add user-triggered retry"** |

PR→issue mappings come from GitHub `closingIssuesReferences` first (source `closing`, authoritative); restricted title/body/branch fallback parsing (`fallback-*`) applies only to non-routine PRs. **Every issue-linked PR now uses an authoritative `closing` reference** — the only fallback-parsed relationship left anywhere in the census is #494 → #238 on a direct board PR card.

| Open PR (live) | Implements (source) | Board state · assignees | Classification | Readiness (review · checks) |
|---|---|---|---|---|
| [#459](https://github.com/WordPress/ai/pull/459) Add C2PA Monitor experiment | [#421](https://github.com/WordPress/ai/issues/421) `closing` | In progress/1.3.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#681](https://github.com/WordPress/ai/pull/681) Feat 514: add comment value score | [#514](https://github.com/WordPress/ai/issues/514) `closing` | Needs review/1.4.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#735](https://github.com/WordPress/ai/pull/735) Logging: replace "Purge All Logs" with age-based delete control | [#689](https://github.com/WordPress/ai/issues/689) `closing` | In progress/Future Release · i-anubhav-anand | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#749](https://github.com/WordPress/ai/pull/749) Feat/add role user access controls | [#736](https://github.com/WordPress/ai/issues/736) `closing` | In progress/1.4.0 | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#757](https://github.com/WordPress/ai/pull/757) fix(logging): capture generations that bypass the SDK HTTP transporter | [#732](https://github.com/WordPress/ai/issues/732) `closing` | Needs review/1.4.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#759](https://github.com/WordPress/ai/pull/759) [issue #660] feat: Update generalised error message for all features | [#660](https://github.com/WordPress/ai/issues/660) `closing` | Needs review/1.4.0 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#855](https://github.com/WordPress/ai/pull/855) Markdown feeds experiment | [#845](https://github.com/WordPress/ai/issues/845) `closing` | In progress/1.4.0 · dkotter | linked-board-issue | — · FAILURE |
| [#887](https://github.com/WordPress/ai/pull/887) Experiment: Add Internal link suggestions | [#875](https://github.com/WordPress/ai/issues/875) `closing` | In progress/1.4.0 · Infinite-Null | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#891](https://github.com/WordPress/ai/pull/891) Feat: Add semantic search experiment to AI plugin | [#844](https://github.com/WordPress/ai/issues/844) `closing` | In progress/Future Release · priyanshuhaldar007 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#929](https://github.com/WordPress/ai/pull/929) Content Gap Suggestions: shared Stats_Provider layer + dashboard widget (1/2 for #338) *(draft)* | [#338](https://github.com/WordPress/ai/issues/338) `closing` | In progress/Future Release · zeus2611 | linked-board-issue | — · SUCCESS |
| [#935](https://github.com/WordPress/ai/pull/935) Fix: make connector validity capability-aware instead of text-only | [#933](https://github.com/WordPress/ai/issues/933) `closing` | In progress/1.4.0 | linked-board-issue | — · SUCCESS |
| [#941](https://github.com/WordPress/ai/pull/941) Content Translation: Add user-triggered retry | — | — | **unexplained** | — · SUCCESS |

> **Coverage risk — six down to one, and the six left by being tracked.** Every one of last window's unexplained PRs received a board card this window: **#888** (Text to Speech, now Needs review under 1.4.0), **#892** (vendored embeddings — carded and **merged** under 1.3.0), **#909** (encryption docs — carded and merged), **#915** (inline HTML — carded and merged), **#916** and **#917** (classification error copy, resize Accept focus — carded under 1.4.0). The two load-bearing entries that sat uncarded for three windows are now either merged (#892) or tracked (#888); the audit is red on exactly one, materially smaller item.
>
> **[#941](https://github.com/WordPress/ai/pull/941) Content Translation: Add user-triggered retry** (yogeshbhutkar) is the new unexplained PR. It adds a "Retry" action to the translation-failure notice so users re-translate only the failed blocks instead of the whole post, tracks failed-block client IDs, and ships a changelog entry — a follow-up to the shipped translation experiment (#187/#747), repo-milestoned **1.4.0**, with no `closing` reference and no board issue. The same contributor maintains the site-wide insights card #190, so this is not a drive-by.
>
> **The inverse caution now applies: a falling unexplained count can mean carding policy, not linkage.** #889/#888/#892 were carded this window while **#459 was de-carded** mid-flight — the board's PR-carding decisions moved in both directions without a stated policy. And last window's worst case is still the one to remember: **#913 merged uncarded**, permanently invisible. Four PRs opened (#929 draft, #931 draft, #935, #941), twelve left the census (eleven merged into the 1.3.0 wave, one closed unmerged — #798), and **every one of the 11 issue-linked PRs uses an authoritative `closing` reference**. The live gap is generated by `./wp-ai-roadmap-refresh.sh`; run `--strict --json` for the audit form that exits `2` while any unexplained/off-board substantive PR remains.

### Full-repository PR/release radar

These upstream repositories are fully enumerated by the refresh script, including normalized open PR records, readiness changes, release history/diffs, validation, and independent PR/release snapshots. They are **census-only**: their work can affect the WordPress AI delivery path, but their PRs are not expected to have Project #240 cards.

| Repository | Open PRs | Latest release | Relationship to this roadmap |
|---|---:|---|---|
| [`WordPress/php-ai-client`](https://github.com/WordPress/php-ai-client) | **28** *(+2)* · 34 open issues | **1.4.0** (2026-07-15) | Provider-agnostic PHP AI client used by the WordPress AI stack; embedding, streaming, model-selection, schema, and provider work can change plugin capabilities. Two opened, none closed: **#274** "Force a model to be passed when generating embeddings instead of relying on the model resolver" and **#275** "Update the AI Provider plugins to their latest versions" (both dkotter). Issue #215 (modality-combination utility) closed; streaming/embeddings/custom-auth issues re-milestoned. Its shipped 1.4.0 embedding support is now what merged PR #892 vendored into the plugin. |
| [`WordPress/abilities-api`](https://github.com/WordPress/abilities-api) | **14** · 8 open issues | **v0.4.0** (2025-10-30) | ⚠️ **Pending archival — treat as archaeology, not a backlog.** Newly censused this window. The Abilities API shipped into Core and Gutenberg, and issue **#160** carries unanimous maintainer agreement to archive the standalone repo (jeffpaul asked dd32/desrosj to action it on 2026-02-04; still open). No open PR has been touched since **2026-01-21**. Several stranded PRs bear directly on live roadmap questions — **#85** `wp_query_abilities` and **#115**/**#119** ability filtering against #21 and #354, **#150** input/output validation filters against #348 — but nobody is reviewing them. Real Abilities work is now in `wordpress-develop` and `gutenberg`, neither of which is censused. |
| [`WordPress/mcp-adapter`](https://github.com/WordPress/mcp-adapter) | **12** *(−6)* · 41 open issues | **v0.6.1** (2026-08-13) | Bridges Abilities to MCP; transport, exposure, approval, schema, session, and server-registration work affects agent integrations. **Shipped its first releases since April: v0.6.0 (2026-08-12) and v0.6.1 (2026-08-13)** after release-tooling (#171) and the DTO cluster (#223, #252, #263) merged; five further PRs closed unmerged (#173, #217, #218, #238, #264). Three opened: draft **#281** (exact-revision 2026 `tools/call`), **#285** (readme.txt rebuild), and draft **#287** (descriptor-backed dual-revision runtime). Issue **#280** (real HTTP transport) opened; six issues closed with the merged work. |

Membership lives in [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json). Run `./wp-ai-roadmap-refresh.sh census --strict` for the complete live census; the existing five-way board-coverage classification remains exclusive to `WordPress/ai`.

---

## ① Dated release lanes

### v1.2.0 — ✅ Shipped 2026-07-14 — 1 residual board-open issue

The `WordPress/ai` release shipped and milestone #19 is closed. Project #240 still has one non-Done 1.2.0 card in another repository:

| Issue | Status | Summary |
|---|---|---|
| [#23](https://github.com/WordPress/ai-provider-for-google/issues/23) | In discussion / Needs decision | [Bug]: Image Generation fails with "Unexpected Google API response: Missing the candidates[0].content key" |

This is provider follow-up, not unfinished code in the released plugin.

### v1.3.0 — Release window — 2 non-Done (2 issues)

The lane went **5 Done / 21 open → 17 Done / 2 open** by delivery, not by re-milestoning: seven issues closed by merged PRs (**#233** via #905, **#690** via #692, **#863** via #881, **#866** via #867, **#876** via #897, **#906** via #914, plus **#307** declined `NOT_PLANNED`), two PR cards merged (**#889**, **#920**), and five PRs arrived Done (#892, #909, #915, #930, #934). **v1.2.0 remains the latest tagged release** while release issue #924 runs the checklist toward **2026-08-17**.

| Issue | Status | Summary |
|---|---|---|
| [#421](https://github.com/WordPress/ai/issues/421) | In progress | WordPress should detect C2PA manifests on upload — PR #459 is still its `closing` PR, but **the PR lost its board card this window** and its checks went FAILURE (see the untracked-PR table above) |
| [#924](https://github.com/WordPress/ai/issues/924) | In progress | Release version 1.3.0 — every pre-release item is checked except "Review and merge/punt #459" |

### v1.4.0 — Next — 19 non-Done (11 issues + 8 PRs)

**The lane was finally loaded.** 2 → 19: thirteen cards re-milestoned in from 1.3.0 as that lane drained (#514, #600, #660, #683, #732, #736, #741, #764, #777, #832, #845, #858, #875), joined by PR cards **#888/#916/#917** and board-new **#933**. Two of its issues remain undecided (#27, #324); the rest carry live PRs or review-ready work.

| Issue | Status | Summary | Implementing PR |
|---|---|---|---|
| [#27](https://github.com/WordPress/ai/issues/27) | In discussion / Needs decision | Display additional AI provider plugins on Connectors page | — |
| [#324](https://github.com/WordPress/ai/issues/324) | In discussion / Needs decision | Evolve Refine from Notes into collaborative and agentic editorial workflows | — |
| [#741](https://github.com/WordPress/ai/issues/741) | In discussion / Needs decision | AI Admin Pages Exhibit Visible Flicker During Initial Render | — |
| [#600](https://github.com/WordPress/ai/issues/600) | To do | Remove `Enable AI` header toggle, allow feature/experiment toggles (and group toggles) to control plugin functionality *(retitled; Help Wanted)* | — |
| [#736](https://github.com/WordPress/ai/issues/736) | In progress | Expose role/user access controls per feature/experiment | [#749](https://github.com/WordPress/ai/pull/749) |
| [#845](https://github.com/WordPress/ai/issues/845) | In progress | New Experiment: Markdown feeds (powered by `html-to-md`) | [#855](https://github.com/WordPress/ai/pull/855) |
| [#875](https://github.com/WordPress/ai/issues/875) | In progress | New Experiment: Suggest internal links within post content | [#887](https://github.com/WordPress/ai/pull/887) |
| [#933](https://github.com/WordPress/ai/issues/933) | In progress | Connector validity check assumes text generation, so speech-only and image-only connectors report as invalid | [#935](https://github.com/WordPress/ai/pull/935) |
| [#514](https://github.com/WordPress/ai/issues/514) | Needs review | Add comment value / relevance to Comment Moderation experiment | [#681](https://github.com/WordPress/ai/pull/681) |
| [#660](https://github.com/WordPress/ai/issues/660) | Needs review | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals | [#759](https://github.com/WordPress/ai/pull/759) |
| [#732](https://github.com/WordPress/ai/issues/732) | Needs review | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible | [#757](https://github.com/WordPress/ai/pull/757) |

#### Open PRs (8)

#### PR #683 — Add native vector search · *In progress · draft · DIRTY · +8565/-4, 37 files · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/683) · @artpi
**Delivers.** A new opt-in `rag-search` experiment for semantic search/RAG. Primary path uses MariaDB 11.8+ `VECTOR(1536)` storage plus a cosine vector index and OpenAI `text-embedding-3-small`; fallback stores embeddings in post meta and searches in memory for smaller sites. Adds indexing lifecycle hooks, one-hour dirty-post cron scheduling, transactional replace-by-post behavior where possible, cleanup hooks, `wp ai rag` WP-CLI utilities, public-search augmentation, and related-posts output.
**Blockers.** Draft; merge-state **CONFLICTING** (needs rebase). Still needs review and a future migration to embeddings supplied by the WP AI Client once available. Operationally gated on supported MariaDB and an authenticated OpenAI connector for the vector-index path. Now scheduled for 1.4.0.

#### PR #764 — Add a core/manage-settings ability · *In progress · not draft · DIRTY · +408/-11, 3 files · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/764) · @jorgefilipecosta
**Delivers.** The write-oriented `core/manage-settings` ability — the counterpart to the read-only `core/settings` added in #691. Takes a map of setting name → new value (reusing each setting's own value schema, `additionalProperties: false`); permission `manage_options`; annotations `readonly:false, destructive:false, idempotent:true`. **Atomic, all-or-nothing**: the Abilities API validates the whole input against the schema before any `update_option()` fires, matching `WP_REST_Settings_Controller::update_item()`.
**Blockers.** The branch is currently DIRTY against `develop` and needs refresh/review. It pairs with `core/settings` (#691) and the now-merged `core/read-content` (#739).

#### PR #777 — dev: Update Composer deps and remediate PHPStan smells · *In progress · draft · DIRTY · +106/-36, 13 files · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/777) · @justlevine
**Delivers.** Tooling hygiene: bumps Composer dependencies to their latest versions and fixes the resulting PHPStan errors (including updating `php-stubs/wordpress-stubs`). No feature impact.
**Blockers.** Draft; awaiting review.

#### PR #832 — chore(deps): drop @wordpress dependencies to wp-7.0 versions · *In progress · draft · DIRTY · +12969/-8969, 3 files · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/832) · @justlevine
**Delivers.** Dependency alignment: pins the bundled `@wordpress/*` packages to the versions shipping in **WP 7.0** (rather than newer Gutenberg majors), part of the wp-7.0 compatibility pass alongside #789 and the dependabot `@wordpress` bumps (#824–#827). The large diff is the regenerated lockfile.
**Blockers.** Draft; no feature impact. Complements #831 (which now pins NPM deps and tells dependabot to ignore `@wordpress`).

#### PR #858 — Abilities API: add core/read-nav-menus ability · *Needs review · not draft · DIRTY · +870/-0, 3 files · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/858) · @Builder106
**Delivers.** A read-only `core/read-nav-menus` ability that lists menus and theme-location assignments or fetches one menu by ID, slug, or location with its items. It uses `edit_theme_options`, follows the existing read-users/read-settings pattern, and is intended to land here before a WordPress Core proposal.

**Blockers.** GitHub now reports the PR as **DIRTY** (it moved BLOCKED → DIRTY this window; checks are green, but no approving review is recorded). The permission boundary and eventual Core ownership remain the substantive review points.

#### PR #888 — New Text to Speech experiment · *Needs review · not draft · DIRTY · checks FAILURE · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/888) · @dkotter
**Delivers.** A complete Text to Speech experiment (+4,216/−1 across 28 files) registering two new abilities — `ai/speech-generation` and `ai/speech-import` — chunking content to stay under provider limits, importing generated audio into the Media Library, and rendering a front-end player with per-post opt-out. Gated on provider work in `ai-provider-for-openai#42` / `ai-provider-for-google#31`.
**Blockers.** **Newly carded this window** after three windows as an unexplained PR — the six-PR coverage gap's largest entry is now tracked. Still DIRTY with failing checks and no approving review, and it expands the standalone-ability surface the #863 toggle now governs.

#### PR #916 — Content Classification: Dynamicize taxonomy error messages · *Needs review · not draft · BLOCKED · CHANGES_REQUESTED · checks FAILURE · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/916) · @Infinite-Null
**Delivers.** Replaces hardcoded "taxonomy" phrasing with the actual taxonomy label (+63/−5), so the Categories panel stops saying "No taxonomy suggestions were generated."
**Blockers.** Newly carded; picked up CHANGES_REQUESTED and failing checks this window.

#### PR #917 — Content Resizing: Focus Accept button when suggested content generation completes · *Needs review · not draft · BLOCKED · CHANGES_REQUESTED · checks FAILURE · 1.4.0*
[Link](https://github.com/WordPress/ai/pull/917) · @Infinite-Null
**Delivers.** Moves focus to **Accept** when generation completes (+6/−3), instead of letting it land on a link inside the "Original" pane.
**Blockers.** Newly carded; picked up CHANGES_REQUESTED and failing checks this window.

---

## ② Planned backlog — Future Release (41)

**One net card arrived, and the tier's shape changed at the edges.** Board-new **#923** (agent users) and PR card **#931** (REST-parity audit) joined; **#890** and **#918** moved in from unmilestoned Triage; **#600** and **#736** left for 1.4.0, and **#307** left by closing `NOT_PLANNED`. Seven issue cards here are still In progress (#203, #238, #325, #338, #625, #689, #844) — four with live PRs (#238/#494, #338/#929, #689/#735, #844/#891) — so read "Future Release" as *unscheduled*, not *inactive*.

### Issues (33)

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
| [#203](https://github.com/WordPress/ai/issues/203) | In progress | Add extensibility hook for custom Ability Table columns |
| [#238](https://github.com/WordPress/ai/issues/238) | In progress | Add focus-aware crop suggestions |
| [#262](https://github.com/WordPress/ai/issues/262) | In discussion / Needs decision | Provider-Level Model Bucketing for Model Selection |
| [#282](https://github.com/WordPress/ai/issues/282) | Backlog | Chat experiment: Integration outside the editor and outside single-task AI use |
| [#297](https://github.com/WordPress/ai/issues/297) | Backlog | New experiment: Content Generation |
| [#325](https://github.com/WordPress/ai/issues/325) | In progress | Integrate media features and experiments with Gutenberg's experimental Media Editor |
| [#338](https://github.com/WordPress/ai/issues/338) | **In progress** | New Experiments: Analytics-aware content and amplification recommendations *(draft PR #929 opened this window)* |
| [#339](https://github.com/WordPress/ai/issues/339) | To do | AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin |
| [#348](https://github.com/WordPress/ai/issues/348) | In discussion / Needs decision | Feature Request: Unified AI Management Layer for WordPress Core |
| [#354](https://github.com/WordPress/ai/issues/354) | In discussion / Needs decision | Unifiied Abilities exposure controls |
| [#425](https://github.com/WordPress/ai/issues/425) | In discussion / Needs decision | Update placement of Alt Text generation buttons |
| [#430](https://github.com/WordPress/ai/issues/430) | In discussion / Needs decision | Skills in a WordPress admin context |
| [#448](https://github.com/WordPress/ai/issues/448) | In discussion / Needs decision | Add WebMCP experiment |
| [#502](https://github.com/WordPress/ai/issues/502) | In discussion / Needs decision | Define how AI provider plugins are discovered, labeled, and surfaced in Connectors |
| [#625](https://github.com/WordPress/ai/issues/625) | **In progress** | New Experiment: Social Content Generation for platform-specific social posts *(moved from In discussion; no PR yet)* |
| [#643](https://github.com/WordPress/ai/issues/643) | In discussion / Needs decision | "AI" plugin 1.0.1 – Connectors and AI settings pages load blank (JavaScript error) on WordPress 7.0 |
| [#689](https://github.com/WordPress/ai/issues/689) | In progress | Add a user-facing control for automatic log cleanup |
| [#791](https://github.com/WordPress/ai/issues/791) | In discussion / Needs decision | Add loading animation/custom cursor for Type Ahead |
| [#844](https://github.com/WordPress/ai/issues/844) | In progress | New Experiment: Semantic search in wp admin |
| [#923](https://github.com/WordPress/ai/issues/923) | In discussion / Needs decision | **Board-new** — Introduce agent users to give AI agents an auditable identity |
| [#890](https://github.com/WordPress/ai/issues/890) | Triage | Add mobile right sidebar display component *(moved in from unmilestoned)* |
| [#918](https://github.com/WordPress/ai/issues/918) | Triage | Feature: AI-generated `llms.txt`, a curated LLM-friendly site index served at `/llms.txt` *(moved in from unmilestoned)* |

### Open PRs (8)

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

#### PR #931 — Compare the core read abilities against the REST API · *In progress · draft · BLOCKED · checks FAILURE · Future Release*
[Link](https://github.com/WordPress/ai/pull/931) · @gziolo
**Delivers.** A board-new audit comparing the shipped `core/read-*` abilities against the REST API to surface semantic drift between the two surfaces.
**Blockers.** Draft, failing checks, no review.

> **The `AI_Service` thread landed — and closed.** Card **#233** re-milestoned Future Release → 1.3.0 last window, and this window **merged PR #905 closed it**, deprecating the layer rather than deleting it. Nothing of that thread remains in this tier.
>
> **The embeddings thread also resolved.** PR **#892** — the `SDK_Overlay` vendoring of php-ai-client 1.4.0 embedding support that spent three windows uncarded — was **carded and merged under 1.3.0 this window**, leaving this tier for the 1.3.0 Done column. Upstream keeps moving beneath it: php-ai-client **#274/#275** landed after the vendoring decision, and #273's automatic function-call loop remains the next capability the plugin does not have.

---

## ③ Straggler — 1

- **[PR #484](https://github.com/WordPress/ai/pull/484) — "Ignore .wp-env.test.override.json"** is already merged (2026-04-29) but remains board-Needs review under 0.9.0. It is a board-hygiene item, not pending delivery.

**Removed-board reference:** [WordPress/abilities-api#84](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not part of Project #240.

---

## ④ Unscheduled — 1

| Issue | Status | Summary |
|---|---|---|
| [#940](https://github.com/WordPress/ai/issues/940) | In discussion / Needs decision | **Board-new** — Introduce new custom endpoint for settings save and bypass core `/wp/v2/settings` endpoint for saving AI options |

- **This tier shrank to one card by milestone, not resolution.** **#890** and **#918** moved to **Future Release** (Triage), so the only unmilestoned open card is board-new **#940** — a live defect: Core revalidates stored AI keys on any `/wp/v2/settings` POST/PUT, and a transient provider failure wipes the key. dkotter reproduces it regularly and favors a plugin-side fix (custom endpoint or a timeout bump) while `core.trac#65867` / `wordpress-develop#13031` wait for the next core release. It is this window's latest board-item activity.
- **#906**, the former unscheduled card, shipped via merged PR #914 under 1.3.0; **#869** remains closed `NOT_PLANNED` as not reproducible, dormant rather than fixed.

---

## ⚠️ Data-quality flags (verify before acting)

1. **PR #484 is merged**, not open, despite its board status.
2. **"Done" does not mean shipped — PR #621 is the proof.** It was closed **unmerged** on 2026-07-28 after weeks of contributor silence (dkotter: "happy to re-open"), then marked board-**Done** with its 1.3.0 milestone stripped. Its uploads-base-URL hardening is not in `develop` and has no successor PR. Any velocity or completion metric read off board-Done status will count this as delivered. Check `state`/`mergedAt`, not board status.
3. **Board ≠ repo — and a gap can close by *carding*, not just by merging.** 28 open PRs = 16 direct-board-pr + 11 linked-board-issue + 0 routine + 0 linked-off-board-issue + **1 unexplained (#941 — the current strict-audit failure)**. The count fell six → one, and all six left by being **carded** (five then merged). Last window's warning still stands in reverse: #913 merged uncarded and is permanently invisible, and this window **#459 was de-carded while open** — the carding boundary moved both directions without a stated policy.
4. ~~**A board card can be actively contradicted by its own implementation.**~~ **Closed out.** PR #905 merged and **#233 closed** against it — the `AI_Service` layer is deprecated, not deleted, and the two-window stale-title saga ended with the card Done.
5. **A rising board total can be delivery, not intake.** The board rose 269 → 279 while five of the 13 additions were already-Done 1.3.0 PRs being carded. Read `.board.added`/`.board.removed` and the milestone deltas — 1.3.0 fell 26 → 19 because it shipped, not because it was trimmed.
6. **A shrinking dated lane is finally delivery.** v1.3.0 went 21 → 2 open by merged PRs (#233/#690/#863/#866/#876/#906, #889/#920) — the first time in four windows that a lane contracted by shipping rather than re-milestoning. The re-labelling moved to 1.4.0 (2 → 19), where it now sits as a queue.
7. **1.2.0 is shipped and its GitHub milestone is closed**, but external provider issue #23 still carries that milestone and remains board-open.
8. **Board-added ≠ real work, but this window is the honest kind.** Five of the 13 additions were already-Done 1.3.0 PRs being carded after the fact (#892, #909, #915, #930, #934); four are substantive new items (#923, #924, #933, #940) and three are new PR cards (#888, #916, #917). The dependabot pattern is still present in Done (#919/#921 merged, **#922 closed unmerged yet Done**).
9. **A `NOT_PLANNED` close is not a fix — and now it is also a decision.** #869 was closed as not reproducible and remains dormant rather than fixed; **#307** was closed `NOT_PLANNED` because the `AGENTS.md` proposal was **declined**. Both count toward Done; neither is delivered functionality.
10. **#890 is unscoped, and #918 is unscoped in a different way — and both now sit in Future Release.** #890 still has no labels, assignee, comments, or named target surface after four windows. #918 is well-argued but proposes a site-wide public `/llms.txt` endpoint that may not fit the per-post Experiment model; its standard-settledness question is still unanswered.
11. **The provenance shape is settled but the path got narrower:** signing PRs #294/#302 closed without merge; the read/monitoring PR #459 remains the sole live path and the authoritative closing PR for #421 — but **its board card was removed this window** and its checks went FAILURE, leaving #421 as the only board representation of C2PA work and one of the two cards blocking the 1.3.0 release.
12. **#844 opened ahead of its stated blocker.** The issue was filed as blocked on #683 for its embedding pipeline, yet PR #891 opened while #683 is still a DIRTY draft — and #891 has now picked up CHANGES_REQUESTED. The third part resolved: **#892 merged this window**, so the vendored embedding layer is now `develop` code; verify #683/#891 do not duplicate indexing machinery on top of it.
13. **Merge-state fields are volatile** and should be rechecked before prioritization — but the aggregate is worth stating plainly and it did not move: **every one of the 28 open `WordPress/ai` PRs is BLOCKED (12) or DIRTY (16); none carries an APPROVED review; 17 have failing checks, 11 carry CHANGES_REQUESTED, and 7 are drafts**. The window's six readiness changes are mostly regressions (#459/#681/#858/#888 → DIRTY, #916/#917 CHANGES_REQUESTED). The 1.3.0 wave merged *despite* this queue; 1.4.0 is now waiting on it.
14. **GitHub's `mergeStateStatus` transiently reads `UNKNOWN` — the script now handles it, so don't hand-correct for it.** Mergeability is computed lazily and *asking* is what schedules the job, so a cold census reports `UNKNOWN` for PRs nothing has touched: this window's first run said 27 of 36. `fetch_pr_census()` now re-queries once (`WP_AI_MERGESTATE_RETRY_DELAY`, default 2s), keeps whichever answer knows more, emits a `pr-mergestate-unknown` **warning** — never an error, since uncomputed mergeability is not a coverage failure — for any PR still cold, and `PRDIFF_JQ` ignores transitions into or out of `UNKNOWN`. Both halves matter: without the retry the report is wrong, and without the diff guard the *saved snapshot* is wrong and replays the phantom churn in reverse next window. Regression-tested by `tests/wp-ai-roadmap-refresh-mergestate.sh`.
15. **Cross-repo signals are separate:** neither the 16-item Gutenberg/abilities-api dependency watchlist nor the full `php-ai-client` / `mcp-adapter` / `abilities-api` PR-issue-release censuses are included in Project #240 counts; coverage validation applies only to `WordPress/ai`.
16. **Do not sum the dependency watchlist and the repository census.** `WordPress/abilities-api` now appears in both by design: the watchlist carries curation the census cannot derive (`theme`, `aiRefs`, `note`, `required`) and follows items through closure, while the census tracks only the live open set. Items `#38` and `#84` are open issues counted in both.
17. **`abilities-api` counts are archaeology, not backlog.** The repository is pending archival (issue #160, unanimous agreement since January, still unactioned) because the API moved into Core and Gutenberg. Its 14 open PRs and 8 open issues are stranded, not planned. Do not read them as capacity, and do not treat a stale abilities-api PR as a live dependency.
18. **Every open `WordPress/ai` issue is now required to be carded.** An uncarded one is an `issue-roadmap-coverage-missing` error that fails `--strict`, the issue-side peer of the PR coverage rule. Current state is **47 of 47 carded** (was 50/50). If that ever goes red, the board has stopped seeing an issue that exists in the repository.

---

## 🔭 Work for Later

- [x] **Ship v1.2.0** — released 2026-07-14 and deployed to WordPress.org.
- [x] **Clarify #851's PoC lifecycle** — closed unmerged 2026-07-22 as designed; succeeded by #892.
- [x] **Define the Yoast integration contract for #874** — root-caused to Yoast's `yoast-seo/editor` store plus `post`-only REST meta registration, fixed in merged PR #886, and filed upstream as `Yoast/wordpress-seo#23458`.
- [x] **Settle the `AI_Service` direction (#233)** — closed by merged PR #905 (deprecation, not deletion).
- [x] **Milestone #906/#914** — shipped: #906 closed by merged PR #914 under 1.3.0.
- [x] **Card the uncarded features** — #888/#892/#909/#915/#916/#917 all received board cards this window (#892/#909/#915 merged under 1.3.0). The gap is now one, new PR **#941**.
- [ ] **Unblock the review queue.** All 28 open PRs are BLOCKED or DIRTY with zero approvals; triage which of the 11 CHANGES_REQUESTED PRs are close to landing. Six readiness changes in a four-day window, mostly regressions.
- [ ] **Decide whether #621's hardening still matters.** It was closed for contributor inactivity, not because the concern was dismissed — if the uploads-URL boundary check is worth having, it needs a new PR; if not, say so on the issue.
- [ ] **Reconcile the embeddings efforts** — #892 (vendored `SDK_Overlay`) is now merged; verify #683 and #891/#844 don't build duplicate indexing machinery on top of it.
- [x] **Give v1.4.0 content or retire the lane.** Answered by loading it: 19 cards (11 issues + 8 PRs), thirteen re-milestoned from 1.3.0 plus newcomers.
- [ ] **Answer the #875 product question** — #876 shipped; #875 sits in 1.4.0 after its fourth milestone label with PR #887 still CHANGES_REQUESTED.
- [ ] **Triage #918** — decide whether a site-wide public `/llms.txt` endpoint belongs in an experiments plugin before it accrues an implementation PR the way #875/#876 did.
- [ ] **Close or re-milestone provider issue #23** now that the plugin's 1.2.0 milestone is closed.
- [x] **Resolve standalone-ability governance (#863)** — shipped via merged PR #881. The next question is #923 (agent identity) and #888's two new abilities under that regime.
- [ ] **Land the C2PA path:** #459 is still the confirmed closing PR for #421 but **lost its board card** and its checks went FAILURE — it is now the only unchecked item on the 1.3.0 release checklist.
- [ ] **Rebase/review the v1.4.0 PR lane**, especially DIRTY #683/#764/#777/#832/#858/#888.
- [ ] **Triage #890 into a defined scope** — four windows with no labels, assignee, or comments (now Future Release).
- [x] **Reproduce #869 cleanly** — closed `NOT_PLANNED` on 2026-08-05 as not reproducible, with the reporter invited to reopen. Dormant, not disproved.
- [ ] **Fix board hygiene** for merged PR #484 — and for **#922**, a dependabot PR closed unmerged that still shows Done.
- [ ] **Decide whether off-board PRs should receive PR cards** — this window #888/#892 were carded while **#459 was de-carded mid-flight**; the carding policy moved both ways and still is not stated.
- [ ] **Ship v1.3.0** — release issue #924 targets 2026-08-17; only "Review and merge/punt #459" remains on the pre-release list.
- [ ] **Triage #941** — the sole unexplained PR (Content Translation retry), repo-milestoned 1.4.0; card it or link it to a board issue.
- [ ] **Fix the two live connector defects** — #933 (validity must be capability-aware; PR #935 open) and #940 (settings saves can wipe API keys; custom endpoint vs timeout).
- [x] **Maintain the refresh workflow** — `wp-ai-roadmap-refresh.sh` passes `bash -n`, **eight** offline fixture suites, `census --strict`, `dependencies --strict --json`, and the live 16-ID dependency smoke test in this refresh (including the issue-census and mergeState-UNKNOWN handling from the last two windows).

---

## Changelog

| Date | Change |
|---|---|
| 2026-08-14 | **Live board + repo refresh vs the 2026-08-10 11:11 UTC baseline — the 1.3.0 delivery wave and the loading of 1.4.0.** Non-Done scope **67 → 65** = **48** open issues (was 51) + **16** open board-tracked PRs (was 15) + stale merged #484. **The dated lane contracted by shipping for the first time in four windows:** **① v1.3.0 21 → 2** (release residue #421 + #924) as seven issues closed by merged PRs (#233/#690/#863/#866/#876/#906, plus #307 declined `NOT_PLANNED`), two PR cards merged (#889/#920), and five PRs arrived Done (#892/#909/#915/#930/#934); release issue **#924 targets 2026-08-17** with only "Review and merge/punt #459" left. **① v1.4.0 2 → 19** (11i+8PR) — thirteen cards re-milestoned in from 1.3.0 plus #888/#916/#917 and board-new #933; **② Future Release 40 → 41** (33i+8PR: gained #923/#931/#890/#918, lost #600/#736 to 1.4.0 and #307 to closure); **④ Unscheduled 2 → 1** with board-new #940; **③ straggler #484 unchanged**. Delivery-readiness by status: In progress **29 → 23**, In discussion **20 → 21**, Needs review **6 → 8**, Backlog **6**, To do **3 → 4**, Triage **3**. Code in flight **15 → 16 open board PRs**: #888/#916/#917/#931 carded, #889/#920 shipped out, **#459 de-carded while open** (now tracked only as a linked PR). Repo gap **36 → 28 open PRs** = **16 direct + 11 linked + 0 routine + 0 off-board + 1 unexplained (#941)**; all six of last window's unexplained PRs were carded — #892/#909/#915 merged under 1.3.0 — every one of the 11 issue links is an authoritative `closing` reference, and 12 PRs left the census (11 merged, #798 closed unmerged). **Readiness flat and dire:** 0 approvals, 11 CHANGES_REQUESTED, BLOCKED 12 / DIRTY 16, 17 failing checks, 7 drafts — the six readiness changes are mostly regressions (#459/#681/#858/#888 → DIRTY, #916/#917 CHANGES_REQUESTED). Upstream radar: `php-ai-client` **26 → 28** (#274/#275) / 1.4.0; `mcp-adapter` **18 → 12** with **v0.6.0 + v0.6.1 shipped (2026-08-12/13)** after its DTO cluster merged; `abilities-api` frozen at 14/8/v0.4.0. **Flags reworked:** the gap closed by *carding* (flag 3), #233/#905 saga closed out (flag 4), the growing lane inverted into a draining lane (flag 6), and issue coverage now **47/47** (flag 18). Script passes `bash -n`, eight offline suites, `census --strict`, `dependencies --strict --json`, and the live dependency smoke test; `--strict --json` exits 2 for exactly #941. |
| 2026-08-10 | **Live board + repo refresh vs the 2026-08-01 14:58 UTC baseline — nothing shipped, but tracking accuracy improved sharply.** Non-Done scope **66 → 67** = **51** open issues (was 52) + **15** open board PRs (was 13) + stale merged #484. **Not one card left a lane by shipping.** Tier moves: **① v1.3.0 15 → 21** (9i+6PR → 13i+8PR) entirely by re-milestoning — **#875/#876 came back from Future Release nine days after leaving 1.4.0**, **#233** arrived from Future Release now that PR #905 authoritatively closes it, **#906** was milestoned from nothing, and PR cards **#889** (newly carded) + dependabot **#920** joined; **① v1.4.0 unchanged at 2** and skipped over — the reloading went to 1.3.0 instead, so it has now spent two windows with no code; **② Future Release 44 → 40** (37i+7PR → 33i+7PR), losing #233/#875/#876 and gaining nothing, with **#736** the only one of last window's three re-milestoned cards not pulled back; **④ Unscheduled 3 → 2** — #906 milestoned out, **#869 closed `NOT_PLANNED` as not reproducible**, board-new Triage issue **#918** (AI-generated `/llms.txt` site index) added; **③ straggler #484 unchanged**. Status moves: **#338** and **#625** In discussion → In progress (neither has a PR), **#863** To do → In progress, **#760** Needs review → In progress, **#866** and **#906** In progress → Needs review. Delivery-readiness by status: In progress **26 → 29**, In discussion **22 → 20**, Needs review **4 → 6**, Backlog **7 → 6**, To do **4 → 3**, Triage **3**. Board totals **flat at 269** with full turnover underneath — 6 de-carded (#191/#192/#452/#507/#874 + #883) against 6 added, shifting the mix **209 PRs + 60 issues → 214 + 55**; Done **203 → 202**. **Neither newly-Done card is delivery:** #193 closed "by #437" (work already shipped, retro-milestoned to **1.0.0**) and #869 closed `NOT_PLANNED`; three more arrived already-Done as dependabot PRs (#919/#921 merged, **#922 closed unmerged yet Done**). Repo gap **33 → 36 open PRs** = **15 direct + 15 linked + 0 routine + 0 off-board + 6 unexplained**; seven opened, four left. **Coverage: same count, half the set replaced, two worst entries resolved.** **#905** retitled *remove* → **"Deprecate the AI_Service layer"** and now declares **`Closes #233`** (dkotter: the class and `get_ai_service()` are public surface); **#889** carded; **#913 merged 2026-08-07 — uncarded**, taking a default-model switch and the `wpai_meta_description_result_temperature` deprecation into `develop` with no board trace. Carried: #888, #892 (third window), #909. New and much lighter: **#915** (+2/−2, `getBlockText` → `getBlockHTML` so Content Resizing really preserves inline HTML), **#916** (taxonomy-specific classification errors), **#917** (focus Accept on completion). **All 15 issue links are now authoritative `closing` references** — #881 → #863 upgraded from branch-name inference. **Readiness flat:** all 36 open PRs BLOCKED (24) or DIRTY (12), zero approvals, 16 failing checks, CHANGES_REQUESTED steady at **14**; three real changes all window (#881 out of draft, #887 → DIRTY, #914 checks green). Upstream radar reversed: `php-ai-client` **24 → 26** (**#271** `isSupported()` bool contract, **#273** automatic function-call resolution loop + `withMessages()`) with the **first three APPROVED reviews the radar has recorded** (#231/#250/#254); `mcp-adapter` **20 → 18**, its first decline — #262 merged, #256 closed unmerged, **#277** opened and merged the same day, and **#260 BLOCKED → DIRTY**, the exact collision predicted when the DTO cluster was flagged as overlapping. Dependency watchlist static at 16 (10 open / 3 closed / 3 merged) for a third window; no release anywhere for three windows. **Flags reworked:** flag 4 (card contradicted by its implementation) **resolved**; new flag 3 warns that an unexplained PR can leave the set by *merging* rather than by being tracked; flag 5 inverted for a flat-but-churning total; flag 14 rewritten now that the script handles `mergeStateStatus: "UNKNOWN"` itself. **Tooling:** the cold census reported 27 of 36 PRs as UNKNOWN; `fetch_pr_census()` now re-queries once, warns rather than errors if it persists, and the PR diff ignores UNKNOWN transitions — without it this refresh would have logged 24 phantom readiness changes and saved them as the baseline. Script passes `bash -n`, **seven** offline fixture suites (new `-mergestate.sh`), and the live 16-ID dependency smoke test; snapshots rolled forward. |
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
