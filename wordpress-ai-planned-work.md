# WordPress AI — Planned (Not-Yet-Shipped) Work

> The **delivery plan**: every board item that is *planned but not shipped* — i.e., **not in "Done"** — organized by release/milestone. Unlike the other two docs, this one **includes the board-tracked PRs** (19 genuinely open + 1 stale merged card) and is ordered by *when* work is expected to land. ⚠️ **Scope caveat:** the repo currently has **37 open PRs** — this doc mirrors the *proj240 board*, which tracks only a subset (see [Board vs. repo](#board-vs-repo-open-prs-not-on-the-board)).
>
> Part of a 4-doc set: **[`wordpress-ai-roadmap.md`](./wordpress-ai-roadmap.md)** (strategy + tracker) · **[`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md)** (per-issue dossiers) · **[`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md)** (Gutenberg + abilities-api dependency watchlist) · **this file** (release-ordered delivery plan + open PRs).
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-07-12 (board + live PR/release checks) |
> | **Scope** | **73 non-Done board cards** = 53 open issues + 19 open board-tracked PRs + 1 stale merged card (#484) |
> | **Latest shipped** | **v1.1.0** (2026-07-01 — 17th release; PR [#560](https://github.com/WordPress/ai/pull/560) merged, release issue [#805](https://github.com/WordPress/ai/issues/805) closed) · **Active:** v1.2.0 (14 Done / 28 open — the live build wave, still landing board-Done work; milestone due 2026-07-30) · **Next:** Future Release backlog (43 open; no dated milestone beyond 1.2.0) |
> | **For issue detail** | see the [open-issues dossier](./wordpress-ai-open-issues.md) (linked per item) |

---

## How "planned" is tracked here

Two board fields define planning, and they're **independent**:
- **Milestone** = *when* (commitment to a release).
- **Status** = *how far along* (In discussion → Triage → Backlog → To do → In progress → Needs review → Done).

So an item can be "In progress" yet unscheduled, or milestoned yet still "In discussion." This doc tiers by **commitment**, then shows status within each tier.

### Commitment ladder (non-Done items)

| Tier | Milestones | Items | What it means |
|---|---|---|---|
| **① Committed — dated release** | 1.2.0 | **28** (17 iss + 11 PR) | The firm plan; slated for the next numbered release. **v1.1.0 shipped 2026-07-01; 1.2.0 is the sole active build wave, still landing board-Done work (14 Done / 28 open).** |
| **② Planned backlog — unscheduled** | Future Release | **43** (35 iss + 8 PR) | Accepted direction, queued, no release assigned |
| **③ Straggler** | 0.9.0 | **1** (stale merged-card PR) | #484 is already merged but still non-Done on the board — see flag #1 |
| **④ Unscheduled (no milestone)** | — | **1** | **#853** (Generate_Image Ability hardcoded timeout, Triage, no milestone — see flag #12). #809 (nested-block fix) and spam #848 both closed board-Done this refresh. |

### Delivery readiness at a glance (non-Done, by status)

| Closest-to-ship → furthest | Count |
|---|---|
| **Needs review** (in code review) | 8 |
| **In progress** (actively being built) | 28 |
| **To do** (queued, scoped) | 6 |
| **Backlog** (planned, not started) | 8 |
| **In discussion / Needs decision** (proposed, undecided) | 21 |
| **Triage** (unsorted) | 2 |
| **Total** | **73** |

> Reading tip: Tiers ① and ② Backlog/To do/In progress/Needs review are the genuinely *planned* pipeline. The 21 "In discussion / Needs decision" items are *proposed* — directionally planned but not committed (kept here for completeness, clearly marked).

---

## 🚀 New experiments & features in the pipeline

The single most useful synthesis: **what new capabilities are coming**, split by whether code exists yet.

### Code already in flight (open PRs)
| Feature | PR | Milestone | Status | One-liner |
|---|---|---|---|---|
| **C2PA Monitor** | [#459](https://github.com/WordPress/ai/pull/459) | 1.2.0 | Needs review | Read-only detection/capture of Content Credentials on upload |
| **Content Provenance** | [#294](https://github.com/WordPress/ai/pull/294) | Future | Needs review ⚠️ | C2PA signing of post **text** via invisible Unicode |
| **Image Provenance** | [#302](https://github.com/WordPress/ai/pull/302) | Future | Needs review | C2PA signing of **images** + CDN edge-worker templates |
| **WebMCP Adapter** | [#224](https://github.com/WordPress/ai/pull/224) | Future | Discussion (draft) | Surfaces Abilities as in-browser WebMCP tools (closes #448) |
| **Service Account** | [#211](https://github.com/WordPress/ai/pull/211) | Future | Discussion (draft) | Auditable machine/automation user role |
| **Suggest Image Crops** | [#494](https://github.com/WordPress/ai/pull/494) | Future | In progress (Blocked) | Vision focal-point + crop suggestions (implements #238) |
| **Native Vector Search / RAG** | [#683](https://github.com/WordPress/ai/pull/683) | 1.2.0 | In progress (draft) | MariaDB vector-search experiment with post-meta fallback embeddings |
| **`core/read-content` ability** | [#739](https://github.com/WordPress/ai/pull/739) | 1.2.0 | In progress | Read-only ability to fetch/query posts of ability-exposed types (part of #40; mirrors core `WP_Content_Abilities`) |
| **`core/manage-settings` ability** | [#764](https://github.com/WordPress/ai/pull/764) | 1.2.0 | Needs review | Write counterpart to `core/settings` (#691) — atomic, all-or-nothing settings updates (part of #40) |
| **Chrome DevTools agent integration** | [#760](https://github.com/WordPress/ai/pull/760) | Future | Needs review (PoC) | Exposes AI Features + a recent-run log to Chrome DevTools for agents |
| **Ability Explorer payload AI-gen** | [#695](https://github.com/WordPress/ai/pull/695) | Future | In progress (draft) | Natural-language → valid JSON payload in the Ability Test Runner |

> 🛡️ **The C2PA / content-provenance suite is the largest in-flight theme by code volume** (#294 ≈ +9.9k LOC, #302 ≈ +6.3k, #459 ≈ +3.2k). #459 (read) + #294 (text sign) + #302 (image sign) form a deliberate family; #302 is stacked on #294. See [the PR dossiers](#future-release--open-prs-6) for the signature-verification caveat on #294.

> 🚀 **Shipped in v1.1.0 (2026-07-01):** the entire 1.1.0 lane went public this refresh — headlined by **Type Ahead** (#151, ghost-text autocomplete) and **Connector API-key encryption** ([PR #560](https://github.com/WordPress/ai/pull/560), merged 2026-06-30, the last open 1.1.0 PR). Type Ahead's follow-up #776 (provider/model overrides + Guidelines) and the late-June board-Done hardening (#775, #785/#786/#787, #796) shipped too. The release-tracking issue #805 is closed. Separately, the credentials-gate issue **#197** closed board-Done on 2026-07-01 (milestone cleared; its off-board PR #799 closed **unmerged**), so it resolved *without* shipping in the 1.1.0 payload. ⚠️ A **post-release regression** was filed against Type Ahead — **#816** (its front-end `wp-editor` enqueue intermittently breaks WooCommerce block checkout); it was fast-tracked and **closed board-Done under 1.2.0 on 2026-07-09** (fix PR #820), together with sibling Type-Ahead fixes **#839** (Escape-restart) and **#846** (ghost-text overlap) and the Title-Generation crash **#833** — see §① v1.2.0.

### Proposed (issues, mostly no code yet) — see dossiers for detail
Content Generation co-author ([#297](./wordpress-ai-open-issues.md#297--new-experiment-content-generation-)) · Social Content Generation ([#625](https://github.com/WordPress/ai/issues/625)) · Analytics-aware content + amplification ([#338](https://github.com/WordPress/ai/issues/338)) · Frontend chat agent ([#142](https://github.com/WordPress/ai/issues/142)) · Admin AI Workspace ([#282](https://github.com/WordPress/ai/issues/282)) · Site Agent ([#189](https://github.com/WordPress/ai/issues/189)) · Site-wide insights ([#190](https://github.com/WordPress/ai/issues/190)) · Comment value/relevance ([#514](https://github.com/WordPress/ai/issues/514)) — ⚙ **now has open [PR #681](https://github.com/WordPress/ai/pull/681)** · AI Playground ([#32](https://github.com/WordPress/ai/issues/32)) · plus the reusable control layer: Tone ([#186](https://github.com/WordPress/ai/issues/186)) / Multilingual ([#187](https://github.com/WordPress/ai/issues/187)) / Persona ([#188](https://github.com/WordPress/ai/issues/188)). **Recently:** Semantic search in wp-admin ([#844](https://github.com/WordPress/ai/issues/844), blocked on #683) · Markdown feeds via `html-to-md` ([#845](https://github.com/WordPress/ai/issues/845)) — ⚙ **now In progress with [PR #855](https://github.com/WordPress/ai/pull/855)**. *(The "Suggest Reply" experiment [#508] shipped board-Done under 1.2.0 this refresh — PR #724 merged.)*

### Board vs. repo: open PRs not on the board

> ⚠️ This doc mirrors the **proj240 board** (19 open board-tracked PRs + stale #484), but `WordPress/ai` currently has **37 open PRs** — **18 are not on the board** (all substantive; **0 routine** — the earlier dependabot bumps got carded/closed and #831 now pins NPM deps + tells dependabot to ignore `@wordpress`). The table below is a live 2026-07-12 refresh. The third column is the mapped issue's current **board** status/milestone; `—` means no issue ref was parsed from the PR title/body (best-effort). Regenerate any time with `./wp-ai-roadmap-refresh.sh` (or inspect via `census` / `gap`).

| Open PR (live) | Implements | Board state of that issue |
|---|---|---|
| #633 Content Classification: improve relevance of taxonomy suggestions | #452 | In progress/1.2.0 |
| #650 Add bulk "Generate AI Summary" action to the posts list table | #614 | In progress/1.2.0 |
| #681 Feat 514: add comment value score | #514 | In progress/1.2.0 |
| #686 [issue #660] Add context-aware error message in Block Editor | #660 | In progress/1.2.0 |
| #692 Feature: Cleanup plugin data on uninstall via user opt in | #690 | In progress/1.2.0 |
| #714 (draft) Abilities Explorer: Add a filter to customize the Ability Table class and expose ability meta | #203 | In progress/1.2.0 |
| #734 feat: add settings import/export functionality | #191 | In progress/1.2.0 |
| #735 Logging: replace "Purge All Logs" with age-based delete control | #689 | In progress/Future Release |
| #747 Feat[Experiment]: Add AI-Powered Content Translation | — | — |
| #749 Feat/add role user access controls | #736 | In progress/1.2.0 |
| #757 fix(logging): capture generations that bypass the SDK HTTP transporter | #732 | In progress/1.2.0 |
| #759 [issue #660] feat: Update generalised error message for all features | #660 | In progress/1.2.0 |
| #770 Prompt template extension points | #192 | In progress/Future Release |
| #798 Clarify global AI toggle as a master switch (#600) | #600, #617 | In progress/1.2.0; #617 not on board |
| #851 PoC: Test upcoming embedding changes | — | — |
| #855 Markdown feeds experiment | #845 | In progress/Future Release |
| #856 Register initial settings before core/read-settings snapshots them | — | — |
| #858 Abilities API: add core/read-nav-menus ability | — | — |

**Substantive open PRs still off the board (18):** most map to a board issue (or are an alternate take on one): #633/#452 taxonomy relevance · #650/#614 bulk summary · #681/#514 comment value · #686 & #759/#660 editor error copy · #692/#690 uninstall cleanup · #714/#203 Ability Table column hook · #734/#191 settings import/export · #735/#689 Request-Log age-based delete · #747 AI-powered content translation (relates to #187) · #749/#736 role/user access controls · #757/#732 non-SDK-transport logging · #770/#192 prompt-template hooks · #798/#600 global-toggle master switch · **#851** PoC exercising upcoming embedding changes (no issue parsed) · **#855/#845** Markdown-feeds experiment (issue now In progress/Future Release) · **#856** register initial settings before `core/read-settings` snapshots them (no issue parsed; core-ability groundwork) · **#858** `core/read-nav-menus` ability (no issue parsed; part of the #40 cluster). **This refresh #724/#810/#830/#842 merged** — closing #508/#809/#815/#793 board-Done — and left the untracked set; board-new PRs #855/#856/#858 joined. The set stays all-substantive (0 routine — #831 pins NPM deps + tells dependabot to ignore `@wordpress`).

> **Board-tracked open PRs (19)**, covered in the tables above: #211, #224, #294, #302, #459, #494, #594, #621, #683, #695, #739, #758, #760, #764, #765, #777, #789, #832, #857 — plus stale merged #484. **Changes vs the 2026-07-09 snapshot:** dependabot PR **#837** (npm-prod-minor-patch bump) **merged board-Done**, and **#857** (Add/commit access docs, Needs review) was newly carded — so the board-tracked open-PR count holds at 19 (plus stale #484).
> **Why the gap:** WordPress/ai doesn't add every PR to proj240. **Fixed 2026-06-16:** `wp-ai-roadmap-refresh.sh` now runs a repo census (`gh pr list` + `gh release list`) on every run, regenerates the table above, and flags new releases — so this gap surfaces automatically. Inspect with `./wp-ai-roadmap-refresh.sh census` or `gap <board.json> <prs.json>`.

---

## ① Committed — dated releases

### v1.1.0 — ✅ Shipped 2026-07-01 — 0 not-Done

> **v1.1.0 shipped on 2026-07-01** — the 17th release. Its final two open cards closed in this refresh: encryption PR **[#560](https://github.com/WordPress/ai/pull/560)** merged (2026-06-30; +2880/-0, 19 files — encrypts every AI Connector API key at rest and decrypts on use, so WP 7.0's Connectors API no longer stores provider keys in plain text; follow-up to the #467 discussion) and the release-tracking issue **[#805](https://github.com/WordPress/ai/issues/805)** closed board-Done. Type Ahead (#151) and the late-June hardening (empty-state gating, button sizing, translations, Snackbar reposition, Type Ahead overrides, Abilities-Explorer/E2E quality) rode this release. (The credentials gate **#197** also closed board-Done on 2026-07-01, but its off-board PR #799 closed **unmerged** and its milestone was cleared — resolved *without* shipping in 1.1.0.) **Nothing remains non-Done on the 1.1.0 lane.** ⚠️ Post-release, front-end regression **#816** was filed against Type Ahead — see §④ below.

### v1.2.0 — Active release — the build wave — 28 not-Done (17 issues + 11 PRs)

> On 2026-06-30, 1.2.0 absorbed the bulk of the former 1.1.0 lane: as 1.1.0 wound down, most still-open hardening issues and the C2PA/abilities PRs were re-milestoned here. With v1.1.0 shipped, v1.2.0 is the **sole active dated release** and **kept landing board-Done work — now 14 Done / 28 open** (4 more cards closed this refresh: **#508** "Suggest Reply" experiment, **#793** Customize-experiments tool, **#815** Connector-Approvals notice, and dependabot **#837**). Non-Done **31 → 28** (17 iss + 11 PR): issues #508/#793/#815 and dependabot PR #837 went board-Done; new PR card **#857** (Add/commit access docs, Needs review) joined.

**Issues (17)** — full detail in the [dossier](./wordpress-ai-open-issues.md):

| # | Status | Title |
|---|---|---|
| [#187](https://github.com/WordPress/ai/issues/187) | Needs review | Multilingual rewriting/translation via AI (draft PR #747) |
| [#191](https://github.com/WordPress/ai/issues/191) | In progress | Settings import/export (PR #734) |
| [#203](https://github.com/WordPress/ai/issues/203) | In progress | Ability Table column extensibility hook (draft PR #714) |
| [#452](https://github.com/WordPress/ai/issues/452) | In progress | Content Classification: improve taxonomy relevance (PR #633) |
| [#514](https://github.com/WordPress/ai/issues/514) | In progress | Comment value/relevance in Comment Moderation (PR #681) |
| [#600](https://github.com/WordPress/ai/issues/600) | In progress | "Enable AI" header toggle aggregate-state (PR #798) |
| [#614](https://github.com/WordPress/ai/issues/614) | In progress | Bulk summary generation on edit.php (PR #650) |
| [#660](https://github.com/WordPress/ai/issues/660) | In progress | Clearer "blocked by Connector Approvals" editor error (PRs #686/#759) |
| [#690](https://github.com/WordPress/ai/issues/690) | In progress | `uninstall.php` to clean DB table + options (PR #692) |
| [#732](https://github.com/WordPress/ai/issues/732) | In progress | Request Logs miss non-SDK-transport providers (draft PR #757) |
| [#736](https://github.com/WordPress/ai/issues/736) | In progress | Per-feature role/user access controls (draft PR #749) |
| [#778](https://github.com/WordPress/ai/issues/778) | In progress | E2E: prefer user-facing Playwright locators |
| [#421](https://github.com/WordPress/ai/issues/421) | To do | Detect C2PA manifests on upload (impl. by PR #459) |
| [#507](https://github.com/WordPress/ai/issues/507) | To do | Editorial Updates end flow → Visual Revisions (@zeus2611) |
| [#23](https://github.com/WordPress/ai-provider-for-google/issues/23) | In discussion | [Bug] Google Image Generation `candidates[0].content` |
| [#324](https://github.com/WordPress/ai/issues/324) | In discussion | ⭐ Evolve Refine → agentic/collaborative editorial (gated on Gutenberg RTC) |
| [#741](https://github.com/WordPress/ai/issues/741) | In discussion | AI/Connectors admin-page flicker (@prasadkarmalkar) |

**PRs (11):**

#### PR #459 — Add C2PA Monitor experiment  ·  *Needs review · CHANGES_REQUESTED · CONFLICTING · +3151/-0, 16 files · moved 1.1.0 → 1.2.0*
[Link](https://github.com/WordPress/ai/pull/459) · @lnispel
**Delivers.** Read-only infra detecting C2PA Content Credentials in uploaded JPEG/PNG/WebP at `add_attachment` (before subsize generation destroys them). Streaming container walks (JPEG APP11/JUMBF reassembly, PNG `caBX`, WebP RIFF `C2PA`) with byte caps; writes raw manifest to a sidecar + a `_wpai_monitor_record` postmeta; SHA-256 hashing; fail-open. Claim decoding, admin UI, crypto verification deferred. (Read-only sibling to the #294/#302 signing work; conceptually implements issue [#421](https://github.com/WordPress/ai/issues/421).)
**Blockers.** dkotter requested changes: set `capability` to `none`; move README under `docs/experiments`; reset `@since` to `x.x.x`; translate error strings; **reconsider sidecar security** (`.htaccess` only protects Apache → prefer non-public storage).

#### PR #594 — Add Stylelint  ·  *In progress · REVIEW_REQUIRED · CONFLICTING · +532/-206, 23 files · moved 1.1.0 → 1.2.0*
[Link](https://github.com/WordPress/ai/pull/594) · @simison
**Delivers.** Tooling: WordPress/Gutenberg Stylelint config + PostCSS that injects WPDS design-token fallbacks for classic builds, an `npm run lint:css` CI step, stylesheet reformatting, and legacy-token migration. No feature impact.
**Blockers.** mirka (design-system) gave a positive non-approving review (suggested packaging into `@wordpress/stylelint-config`, deferred). Awaiting an approving review from a repo regular.

#### PR #621 — Fix alt text upload URL matching  ·  *In progress · CONFLICTING · +61/-1, 3 files · moved 1.1.0 → Future → 1.2.0*
[Link](https://github.com/WordPress/ai/pull/621) · @1d0u
**Delivers.** Correctness/security fix in `Alt_Text_Generation`: replaces a substring check with an exact/prefix-boundary check so only the configured uploads base URL resolves to local files (prevents lookalike-URL spoofing). Adds a regression test.
**Blockers.** Copilot raised two concerns; author rebutted with reruns. dkotter asked for `@since` fixes and to split out an unrelated E2E change. Merge-state **CONFLICTING**; awaiting re-review. Re-milestoned to 1.2.0 on 2026-06-30 (after an earlier 1.1.0 → Future Release slip).

#### PR #683 — Add native vector search  ·  *In progress · draft · CONFLICTING · +8565/-4, 37 files · moved Future → 1.2.0*
[Link](https://github.com/WordPress/ai/pull/683) · @artpi
**Delivers.** A new opt-in `rag-search` experiment for semantic search/RAG. Primary path uses MariaDB 11.8+ `VECTOR(1536)` storage plus a cosine vector index and OpenAI `text-embedding-3-small`; fallback stores embeddings in post meta and searches in memory for smaller sites. Adds indexing lifecycle hooks, one-hour dirty-post cron scheduling, transactional replace-by-post behavior where possible, cleanup hooks, `wp ai rag` WP-CLI utilities, public-search augmentation, and related-posts output.
**Blockers.** Draft; merge-state **CONFLICTING** (needs rebase). Still needs review and a future migration to embeddings supplied by the WP AI Client once available. Operationally gated on supported MariaDB and an authenticated OpenAI connector for the vector-index path. Re-milestoned Future → 1.2.0 on 2026-06-25.

#### PR #739 — Add core/read-content ability  ·  *In progress · not draft · MERGEABLE · REVIEW_REQUIRED · +2357/-5, 7 files · moved 1.1.0 → 1.2.0*
[Link](https://github.com/WordPress/ai/pull/739) · @jorgefilipecosta · part of #40
**Delivers.** The read-only `core/read-content` ability (renamed from `core/content` to match the `read-` naming used by `core/read-users`), mirroring core's `WP_Content_Abilities` (companion core PR wordpress-develop#12195) so the two stay in sync. Fetches a single post by `id`/`slug` or queries multiple posts filtered by `post_type`/`status`/`author`/`parent`, with a `fields` selector and pagination; output `{ posts, total, total_pages }`. Defense-in-depth security (coarse capability gate + an authoritative per-row `read_post`, password-protected content withheld from non-editors, uniform not-found responses). Ships a self-contained `Show_In_Abilities` polyfill on curated core post types; independent of #691.
**Blockers.** Mergeable, awaiting review. Part of the #40 Core Abilities set alongside `core/settings` (#691), `core/manage-settings` (#764), and `core/read-users` (#774).

#### PR #764 — Add a core/manage-settings ability  ·  *Needs review · not draft · MERGEABLE · REVIEW_REQUIRED · +408/-11, 3 files*
[Link](https://github.com/WordPress/ai/pull/764) · @jorgefilipecosta · part of #40
**Delivers.** The write-oriented `core/manage-settings` ability — the counterpart to the read-only `core/settings` added in #691. Takes a map of setting name → new value (reusing each setting's own value schema, `additionalProperties: false`); permission `manage_options`; annotations `readonly:false, destructive:false, idempotent:true`. **Atomic, all-or-nothing**: the Abilities API validates the whole input against the schema before any `update_option()` fires, matching `WP_REST_Settings_Controller::update_item()`.
**Blockers.** Mergeable, awaiting review. Pairs with `core/settings` (#691) and `core/read-content` (#739).

#### PR #758 — fix(logging): register the operation REST filter param  ·  *In progress · draft · +50/-0, 2 files · part of the #732 logging cluster*
[Link](https://github.com/WordPress/ai/pull/758) · @i-anubhav-anand
**Delivers.** Registers the `operation` query parameter on the AI Request Log REST endpoint (`/ai/v1/logs`) — the only filter the admin UI sends that was missing from `AI_Request_Log_Controller::get_collection_params()`, so it bypassed REST argument validation.
**Blockers.** Draft; small, self-contained correctness fix in the Request-Log area.

#### PR #777 — dev: Update Composer deps and remediate PHPStan smells  ·  *In progress · draft · +106/-36, 13 files*
[Link](https://github.com/WordPress/ai/pull/777) · @justlevine
**Delivers.** Tooling hygiene: bumps Composer dependencies to their latest versions and fixes the resulting PHPStan errors (including updating `php-stubs/wordpress-stubs`). No feature impact.
**Blockers.** Draft; awaiting review.

#### PR #789 — Update bundled wp deps (theme, ui, dataviews, admin-ui)  ·  *In progress · not draft · +629/-538, 4 files*
[Link](https://github.com/WordPress/ai/pull/789) · @simison
**Delivers.** Refreshes the bundled `@wordpress/*` packages (theme, ui, dataviews, admin-ui) pulled from Gutenberg. Dependency maintenance; no feature impact.
**Blockers.** Awaiting review.

#### PR #832 — chore(deps): drop @wordpress dependencies to wp-7.0 versions  ·  *In progress · draft · +12969/-8969, 3 files · milestone 1.2.0 · board-new*
[Link](https://github.com/WordPress/ai/pull/832) · @justlevine
**Delivers.** Dependency alignment: pins the bundled `@wordpress/*` packages to the versions shipping in **WP 7.0** (rather than newer Gutenberg majors), part of the wp-7.0 compatibility pass alongside #789 and the dependabot `@wordpress` bumps (#824–#827). The large diff is the regenerated lockfile.
**Blockers.** Draft; no feature impact. Complements #831 (which now pins NPM deps and tells dependabot to ignore `@wordpress`).

#### PR #857 — Add/commit access docs  ·  *Needs review · not draft · milestone 1.2.0 · board-new*
[Link](https://github.com/WordPress/ai/pull/857) · @jeffpaul
**Delivers.** Repo-ops / documentation: adds committer and commit-access docs to the repository (contributor-governance groundwork, not a user feature). Carded on the board under 1.2.0. *(Replaces the now-merged dependabot PR #837 in this list — #837 bumped the `npm-prod-minor-patch` group and closed board-Done 2026-07-10.)*
**Blockers.** Awaiting review.

---

## ② Planned backlog — unscheduled

### Future Release — open PRs (8)

> The bulk of the in-flight *experimental* code lives here, not in a dated release — provenance, WebMCP, service accounts, crop suggestions, plus two newly board-tracked explorations: the Chrome DevTools agent PoC (#760) and AI-assisted payload generation in the Ability Explorer (#695). The alt-text URL-matching fix (#621) moved on to 1.2.0; native vector search #683 is at 1.2.0. **This refresh:** PR #765 (Repo Automator) moved **down** here from 1.2.0.

#### PR #294 — Content Provenance experiment (C2PA 2.3 §A.7 text authentication) ⚠️  ·  *Needs review · CHANGES_REQUESTED · +9899/-441, 43 files*
[Link](https://github.com/WordPress/ai/pull/294) · @erik-sv · label [Type] Enhancement
**Delivers.** A new **Content Provenance** experiment that embeds cryptographic C2PA 2.3 manifests into post text as invisible Unicode variation selectors. Auto-signs on publish/update (`c2pa.created`/`c2pa.edited` + ingredient edit-chains), hash-guarded against re-signing. Three tiers: Local (self-signed EC P-256), Connected (CA-verified provider registry), BYOK (publisher PEM). Ships `c2pa/sign` + `c2pa/verify` Abilities, a Gutenberg shield-badge sidebar, `/.well-known/c2pa`, a frontend badge, and a **pure-PHP C2PA stack** (CBOR/COSE_Sign1/JUMBF). 192 tests.
**Blockers (architectural). ⚠️** dkotter: (1) **verify only does a hash `strpos` — it never validates the COSE signature/cert chain, so the "verified" badge is a false assurance** (must implement real verification or relabel as integrity-only); (2) invisible Unicode originally lived in `post_content`, **exploding other plugins' AI token usage (~800 → ~90k tokens)** — author says fixed by moving bytes to post meta (2026-04-22). Suggested splitting per signing tier; leadership reassigned to JasonTheAdams.

#### PR #302 — Image Provenance experiment + CDN worker templates  ·  *Needs review · REVIEW_REQUIRED · +6308/-1, 34 files*
[Link](https://github.com/WordPress/ai/pull/302) · @erik-sv · label [Type] Enhancement
**Delivers.** A new **Image Provenance** experiment signing JPEG/PNG/WebP/GIF on `add_attachment` (manifest JSON + canonical URL in post meta), injecting a `C2PA-Manifest-URL` response header on singular pages, REST lookup endpoints, and **CDN edge-worker templates** (Cloudflare KV, AWS Lambda@Edge, Fastly Compute@Edge) to propagate the header downstream.
**Blockers.** **Stacked on #294** (reuses its signer classes) — #294 must merge first and its blockers gate this. lnispel reviewed (comments); jeffpaul reiterated the contamination concern and reassigned to JasonTheAdams. No approval yet.

#### PR #224 — Add WebMCP adapter experiment  ·  *In discussion · draft · REVIEW_REQUIRED · mergeability UNKNOWN · +2371/-55, 9 files*
[Link](https://github.com/WordPress/ai/pull/224) · @Jameswlepage · **Closes #448**
**Delivers.** A `webmcp-adapter` experiment exposing layered `navigator.modelContext` (WebMCP) tools in wp-admin for discovering/inspecting/executing Abilities. Adds `is_available()`/`get_unavailable_reason()` to `Abstract_Experiment`, gates on Abilities API availability, enforces server-side option sanitization.
**Blockers.** Functionally validated (abilities executed via WebMCP in Chrome Canary) but **held by spec instability** — WebMCP is a fast-moving W3C CG draft (tool-registration shape already changed). swissspidy recommended stepping back to discussion issue #448 and exploring declarative form-exposure first. Current mergeability returned **UNKNOWN**.

#### PR #211 — Add Service Account experiment  ·  *In discussion · draft · REVIEW_REQUIRED · +3853/-0, 8 files*
[Link](https://github.com/WordPress/ai/pull/211) · @Jameswlepage
**Delivers.** Exploratory **Service Account** experiment: a real, creatable user type for non-interactive/automation access (Claude Code, automation, APIs). Adds a Service role, Users → Add New customizations, a Service Accounts list view, and REST CRUD + application-password regeneration.
**Blockers.** Genuinely exploratory — the author frames it as a **"do we need this?"** question; provider-specific labels would need removing if it advances. Draft, no reviews — a concept for decision, not a merge candidate.

#### PR #494 — Focus-aware crop suggestions (implements #238)  ·  *In progress · [Status] Blocked · +2152/-315, 9 files*
[Link](https://github.com/WordPress/ai/pull/494) · @TylerB24890
**Delivers.** A `Suggest_Image_Crops` experiment + Ability: feeds an image (data URI) to a vision model that returns focal point + crop-window coordinates in Focal-Point-Picker space. Adds a shared `Resolves_Image_Reference` trait and refactors `Alt_Text_Generation` to use it. Customizable aspect ratios via filter.
**Blockers.** **[Status] Blocked** — the Gutenberg Media Editor modal isn't yet extensible (epic gutenberg#73771); no UI surface until `registerImageEditorPanel()` (name TBD) lands. Backend Ability works standalone via the Abilities Explorer. Related: #325, PR [#446](https://github.com/WordPress/ai/pull/446) (already merged in 1.0.0).

#### PR #760 — Chrome DevTools agent integration (PoC)  ·  *Needs review · not draft · MERGEABLE · +474/-0, 16 files*
[Link](https://github.com/WordPress/ai/pull/760) · @dkotter
**Delivers.** A third-party integration exposing the site's available AI Features — plus a lightweight log of which Features ran recently — to Chrome DevTools for agents, which recently added 3P-tool support. A deliberately basic proof-of-concept to validate the surface.
**Blockers.** PoC framing — a "does this direction have legs?" exploration rather than a finished feature; mergeable, awaiting review.

#### PR #695 — Ability Explorer: AI-assisted payload generation (Test Ability screen)  ·  *In progress · draft · +357/-38, 5 files*
[Link](https://github.com/WordPress/ai/pull/695) · @Arkenon
**Delivers.** Adds AI-assisted payload generation to the Ability Test Runner: users describe a test scenario in natural language and the tool generates a valid JSON payload from the selected ability's input schema — lowering the bar to exercise abilities with complex inputs.
**Blockers.** Draft; merge-state UNKNOWN; awaiting review.

#### PR #765 — Add Repo Automator action  ·  *In progress · not draft · MERGEABLE · REVIEW_REQUIRED · +41/-0, 1 file · moved 1.2.0 → Future Release*
[Link](https://github.com/WordPress/ai/pull/765) · @jeffpaul
**Delivers.** Repo-ops tooling, not a user feature: a `.github/workflows/repo-automator.yml` running 10up/action-repo-automator on the `develop` branch to auto-label, comment, and assign reviewers on PRs/issues — operational support for the rising issue/PR volume (jeffpaul + dkotter).
**Blockers.** Awaiting review; no feature impact. Re-milestoned 1.2.0 → Future Release this refresh.

### Future Release — issues (35), grouped by theme

> Full dossiers in the [open-issues reference](./wordpress-ai-open-issues.md). Compact index here.

- **Platform / Abilities / MCP / Skills (10):** [#40](https://github.com/WordPress/ai/issues/40) Core Abilities ⭐ · [#348](https://github.com/WordPress/ai/issues/348) Unified AI Management Layer ⭐ · [#354](https://github.com/WordPress/ai/issues/354) Unified abilities exposure controls · [#21](https://github.com/WordPress/ai/issues/21) scale to thousands of abilities · [#37](https://github.com/WordPress/ai/issues/37) MCP routing reference · [#430](https://github.com/WordPress/ai/issues/430) Skills in admin ⭐ · [#448](https://github.com/WordPress/ai/issues/448) WebMCP (⚙ PR #224) · [#233](https://github.com/WordPress/ai/issues/233) refactor onto/away-from AI_Service · [#307](https://github.com/WordPress/ai/issues/307) AGENTS.md onboarding · [#32](https://github.com/WordPress/ai/issues/32) AI Playground *(#203 Ability Table column hook moved to 1.2.0)*
- **Providers / Connectors / Models (3):** [#502](https://github.com/WordPress/ai/issues/502) provider plugin discovery/labeling · [#262](https://github.com/WordPress/ai/issues/262) provider-level model bucketing · [#27](https://github.com/WordPress/ai/issues/27) surface additional provider plugins on Connectors *(moved 1.1.0 → Future)* *(#191 settings import/export moved to 1.2.0)*
- **Content & editorial experiments (7):** [#297](https://github.com/WordPress/ai/issues/297) Content Generation ⭐ · [#625](https://github.com/WordPress/ai/issues/625) Social Content · [#338](https://github.com/WordPress/ai/issues/338) Analytics-aware ⭐ · [#90](https://github.com/WordPress/ai/issues/90) Title Gen consolidation · [#186](https://github.com/WordPress/ai/issues/186) tone · [#188](https://github.com/WordPress/ai/issues/188) persona · [#791](https://github.com/WordPress/ai/issues/791) Type Ahead loading-state cursor/animation *(new)* *(#508 Suggest Reply, #514 comment value, #187 multilingual all moved to 1.2.0)*
- **Agentic / chat / media (8):** [#142](https://github.com/WordPress/ai/issues/142) frontend chat · [#282](https://github.com/WordPress/ai/issues/282) AI Workspace ⭐ · [#189](https://github.com/WordPress/ai/issues/189) Site Agent ⭐ · [#190](https://github.com/WordPress/ai/issues/190) site insights · [#238](https://github.com/WordPress/ai/issues/238) focus-aware crop (⚙ PR #494) · [#325](https://github.com/WordPress/ai/issues/325) Media Editor integration · [#425](https://github.com/WordPress/ai/issues/425) alt-text button placement (Blocked) · [#844](https://github.com/WordPress/ai/issues/844) semantic search in wp-admin *(board-new; blocked on #683)*
- **Dev / infra / community (5):** [#192](https://github.com/WordPress/ai/issues/192) custom prompt templates (In progress; ⚙ PR #770) · [#193](https://github.com/WordPress/ai/issues/193) dev log panel · [#47](https://github.com/WordPress/ai/issues/47) educational content · [#689](https://github.com/WordPress/ai/issues/689) manual Request Log cleanup control (⚙ PR #735) · [#845](https://github.com/WordPress/ai/issues/845) Markdown feeds via `html-to-md` *(now In progress; ⚙ PR #855)* *(#736 role/user access controls moved to 1.2.0)*
- **Bug / admin UX / observability (2):** [#339](https://github.com/WordPress/ai/issues/339) connection-alive error (needs re-test) · [#643](https://github.com/WordPress/ai/issues/643) WP 7.0 blank Connectors/settings pages (likely core/environment JS) *(#732 non-SDK-transport logging and #741 admin-page flicker both moved to 1.2.0)*

---

## ③ Straggler — 1

**Stale card (1):**
- **PR #484** — "Ignore .wp-env.test.override.json" — board shows *Needs review / milestone 0.9.0*, but the GitHub API reports it **already MERGED**. It has effectively shipped; the board card is stale. → *Board hygiene item (see Work for Later).*

**Removed-board reference:** [WordPress/abilities-api#84](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later, but no longer appears on Project #240 as of the 2026-06-19 refresh.

---

## ④ Unscheduled — 1

> One non-Done card carries **no milestone** this refresh:
>
> - **[#853](https://github.com/WordPress/ai/issues/853)** — *Triage* — the Image Generation ability issues its provider request with a **hardcoded timeout** rather than a configurable/filterable value, so slow image models (or constrained hosts) can exceed the window and fail even when generation would otherwise succeed, with no supported way to raise the limit. Board-new (filed 2026-07-10); not yet triaged to a milestone.
>
> *(This refresh the previously-unmilestoned **#809** (nested-block detection) closed board-Done via PR #810, and the **spam #848** was closed board-Done ("completed") — both left this tier. See §① v1.2.0 and the Recently board-Done set in the [open-issues dossier](./wordpress-ai-open-issues.md).)*

---

## ⚠️ Data-quality flags (verify before acting)

1. **PR #484 is merged**, not open — **verified merged 2026-04-29 (by gziolo, milestone 0.9.0)**; stale "Needs review" card on the board. Now reflected in Scope as a "stale merged card."
2. **#643** ("live regression") is **probably not a plugin bug** — the reporter's follow-ups show the native block editor + multiple independent React admin UIs all render blank with `wp.data`/`privateApis` errors, pointing to corrupted/inconsistent WP 7.0 **core** JS. It now sits in Future Release / In discussion, but remains user-facing on the current release.
3. **#294 "Content Provenance" verification is integrity-only**, not cryptographic — the green "verified" badge currently overstates assurance (no COSE signature/cert-chain validation). Blocks shipping as-is.
4. **#339** repro is unconfirmed on current versions — needs re-test on AI ≥0.9.0 / WP 7.0 RC2-3 / Gutenberg 23.1.0; likely a provider-plugin issue, not core plugin.
5. **`closingIssuesReferences` was unavailable** via `gh pr view`; PR→issue links were parsed from PR bodies (so a few may be incomplete).
6. **Three more issues moved board-Done in the 2026-06-30 refresh** — #145 (rename experiment `register()`), #767 (locale-aware content gate), and #771 (Content Classification pill) are no longer counted as planned work; they join the open-issues "Recently board-Done" set. Separately, three already-Done 1.0.2 items (#699, #704, #718) were **de-carded** from Project #240 this refresh.
7. **Board ≠ repo** — the board tracks 19 currently open PRs plus stale #484, while the repo has **37 open** (live 2026-07-12); **18 open PRs are not on the board** (all substantive; **0 routine** — the dependabot bumps got carded/closed and #831 pins NPM deps + tells dependabot to ignore `@wordpress`). See [Board vs. repo](#board-vs-repo-open-prs-not-on-the-board). `wp-ai-roadmap-refresh.sh` diffs the *board* only, so the repo census remains important.
8. **Latest shipped is now v1.1.0** (2026-07-01) — the 17th release; encryption PR #560 merged (2026-06-30) and release-tracking issue #805 closed board-Done. The prior public patch was v1.0.2 (2026-06-16). v1.2.0 is now the sole active dated milestone; there is no dated release beyond it yet.
9. **#145 closed board-Done** on 2026-06-30 — its implementation PR #159 had closed without merge on 2026-06-17, and the issue itself was subsequently closed directly.
10. **#84 is no longer on Project #240** — the `WordPress/abilities-api` issue remains open upstream under milestone Later and is still conceptually tied to #40, but it is no longer counted as current board work.
11. **#816 was a live post-1.1.0 regression (now resolved)** — the Type Ahead experiment (shipped in v1.1.0, 2026-07-01) enqueued on `enqueue_block_assets` with **no `is_admin()` guard**, so `wp-editor` and the `core/editor` data store loaded on the **front end** and intermittently broke WooCommerce block checkout (its Store API cart resolver keys off `!! select('core/editor')`). It was fast-tracked and **closed board-Done under 1.2.0 on 2026-07-09** (fix PR #820); sibling Type-Ahead fixes #839/#846 and the Title-Generation crash #833 shipped to the same lane. A **1.1.1 patch** decision may still be warranted, since the regression affects the public 1.1.0 release and 1.2.0 has no ship date yet.
12. **#848 (spam) was closed board-Done this refresh** — the SEO/link-spam card ("How AI-Powered Cloud Services in India…", author `keywordcoded-glitch`, body links `prodevans.com`) was **closed 2026-07-10** (state reason "completed"). It now shows as a **Done** card rather than being removed from Project #240, so it no longer inflates the Triage bucket or the open-issue count. No further action needed; the new Triage bug **#853** (Generate_Image hardcoded timeout) is a legitimate issue, not spam.

---

## 🔭 Work for Later (deferred follow-ups)

> Recorded as a backlog rather than actioned now (per request). Each is a discrete next task.

- [x] **1.1.0 release watch** — ✅ **v1.1.0 shipped 2026-07-01.** Encryption PR **#560** merged (2026-06-30) and release issue **#805** closed board-Done; Type Ahead (#151) rode the release, and the remaining 1.1.0 hardening work had been re-milestoned to 1.2.0 in the prior refresh. (The credentials gate #197 closed board-Done post-release with its PR #799 **unmerged** — not part of the 1.1.0 payload.) **Release focus is now 1.2.0** (now 14 Done / 28 open; no date set yet).
- [x] **Review/land #816 fix (post-1.1.0 regression)** — ✅ **closed board-Done under 1.2.0 on 2026-07-09** (fix PR #820); sibling Type-Ahead fixes #839 (Escape-restart) / #846 (ghost-text overlap) and the Title-Generation crash #833 shipped to the same lane. A **1.1.1 patch** decision may still be warranted since it affects the public 1.1.0 release and 1.2.0 has no ship date yet.
- [x] **Land #818/#819 (AI-Home alt-text a11y)** — ✅ **closed board-Done under 1.2.0 on 2026-07-09** (fix PR #819); part of the 2026-07-03 a11y/E2E wave (#817/#828 ARIA-selector refactors).
- [x] **Land #809/#810 (Content-Summary nested blocks)** — ✅ **PR #810 merged and #809 closed board-Done 2026-07-10** (remained unmilestoned through close).
- [ ] **C2PA / provenance suite consolidation** — 3 overlapping PRs (#459 read, #294 text-sign, #302 image-sign), 2 authors (erik-sv, lnispel), reassigned to JasonTheAdams. Needs an owner + decision: merge order, shared signer code, and resolving #294's signature-verification blocker before any ships.
- [ ] **Confirm PR-only experiments have backing issues** — Service Account (#211) is introduced by a PR with no linked tracking issue; decide whether it needs one (it's a "do we need this?" draft). Type Ahead (#151) shipped without one — its follow-up #776 (provider/model overrides + Guidelines) is also issue-less.
- [ ] **Escalate/triage #643** as a WP 7.0 core-integrity question, not a plugin bug; confirm with a clean-core repro.
- [ ] **Re-test #339** on current versions and route to the correct provider plugin if confirmed.
- [ ] **Board hygiene** — fix the stale PR #484 card (merged but shows Needs review).
- [ ] **Track #683 native vector search** — now board-tracked, milestoned **1.2.0**, and large (+8.5k LOC, CONFLICTING); confirm whether it needs a backing issue, WP AI Client embeddings dependency issue, or separate RAG/search experiment framing.
- [ ] **Add the open PRs to the issues dossier** (19 open board-tracked + 18 repo-open substantive untracked, or keep PRs only here) and add **bidirectional cross-links** across the 4 docs per item.
- [x] **Build a `gh`-powered refresh/diff script** — ✅ **done:** [`wp-ai-roadmap-refresh.sh`](./wp-ai-roadmap-refresh.sh). Re-pulls the board and diffs vs the last snapshot (added · newly-Done · merged · status/milestone moves · removed); `--save` rolls the baseline forward, `--update-changelog` appends a dated row. A real baseline was established 2026-06-15. **Extended 2026-06-16:** also runs a repo-level census (open PRs + releases), surfaces the board↔repo PR gap with best-effort issue mapping, and diffs PR/release sibling snapshots — `census` / `gap` / `prdiff` / `reldiff` subcommands, default-on with `--no-repo` to skip. **Extended 2026-06-19:** also runs a Gutenberg + abilities-api dependency watchlist (`dependencies` subcommand; default-on with `--no-deps` to skip).
- [ ] **Enrich PRs with CI/merge state over time** (mergeable status was UNKNOWN/CONFLICTING at fetch; re-check before relying on readiness).

---

## Changelog

| Date | Change |
|---|---|
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
