# WordPress AI — Planned (Not-Yet-Shipped) Work

> The **delivery plan** for every Project #240 card not in Done. It includes issue cards and board-tracked PRs, ordered by milestone. ⚠️ **Scope caveat:** `WordPress/ai` has **36 open PRs**, while Project #240 has PR cards for only 15 of them; see [Board vs. repo](#board-vs-repo-pr-coverage-five-classifications). Full census-only tracking for `WordPress/php-ai-client` and `WordPress/mcp-adapter` appears below and does not expand Project #240 scope.
>
> Part of a 4-doc set: [`wordpress-ai-roadmap.md`](./wordpress-ai-roadmap.md) (strategy + tracker) · [`wordpress-ai-open-issues.md`](./wordpress-ai-open-issues.md) (issue dossiers) · [`wordpress-ai-cross-repo-dependencies.md`](./wordpress-ai-cross-repo-dependencies.md) (upstream dependencies + repository radar) · **this file** (release-ordered delivery plan + PR census).
>
> | | |
> |---|---|
> | **Data snapshot** | 2026-08-10 (board + live PR/release checks) |
> | **Scope** | **67 non-Done cards** = 51 open issues + 15 open board-tracked PRs + stale merged PR #484 |
> | **Latest shipped** | **v1.2.0** (2026-07-14; 18th release) |
> | **Repository radar** | Open PRs / open issues — `php-ai-client`: **26 / 35** (1.4.0) · `mcp-adapter`: **18 / 46** (v0.5.0) · `abilities-api`: **14 / 8** (v0.4.0, ⚠️ pending archival). Census-only; no Project #240 coverage gate. |
> | **Active / next** | **v1.3.0:** 21 open (13 issues + 8 PRs) · **v1.4.0:** 2 issues (both In discussion) · **Future Release:** 40 open |
> | **For issue detail** | See the [open-issues dossier](./wordpress-ai-open-issues.md). |

## How "planned" is tracked here

This file mirrors **board status**, not a promise that every card will ship. "Done" is excluded; all other statuses are included and grouped by milestone.

### Commitment ladder (67 non-Done cards)

| Tier | Cards | Interpretation |
|---|---:|---|
| **v1.3.0** | **21** | Active delivery lane, reloaded: 13 issues + 8 PRs (was 15) — gained #233, #875, #876, #906 by milestone move plus dependabot PR card #920 |
| **v1.4.0** | **2** | Next lane, **unchanged and skipped over**: still only In-discussion #27/#324, still with no code — the cards that left it last window came back into 1.3.0, not here |
| **Future Release** | **40** | Unscheduled backlog: 33 issues + 7 PRs — it gave up #233/#875/#876 and gained nothing |
| **1.2.0 residual** | **1** | Google-provider issue #23 remains board-open after the plugin release shipped |
| **Unmilestoned** | **2** | Triage cards #890 (mobile right sidebar) and board-new #918 (AI-generated `llms.txt`) |
| **Stale shipped-milestone card** | **1** | PR #484 is merged but still board-Needs review under 0.9.0 |

> **The dated lane grew without the work advancing.** All five of this window's milestone moves pulled cards *toward* a release: #875/#876 returned from Future Release after nine days, #233 came in from Future Release, and #906 was milestoned from nothing. Not one card left a lane by shipping. Read the 15 → 21 rise as re-labelling, exactly as last window's 18 → 15 fall was re-scheduling.

### Delivery readiness at a glance

| Board status | Cards |
|---|---:|
| In progress | **29** |
| Needs review | **6** |
| Backlog | **6** |
| To do | **3** |
| Triage | **3** |
| In discussion / Needs decision | **20** |

> "In discussion" is directional, not committed. The board's active implementation signal is the combination of In progress/Needs review cards and the live repository PR census.

---

## 🚀 New experiments & features in the pipeline

### Code already in flight (15 open board-tracked PRs)

| PR | Milestone | Board status | Live readiness (draft · review · merge · checks) |
|---|---|---|---|
| [#211](https://github.com/WordPress/ai/pull/211) Add Service Account experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks FAILURE |
| [#224](https://github.com/WordPress/ai/pull/224) Add WebMCP adapter experiment | Future Release | In discussion / Needs decision | draft · review — · merge DIRTY · checks SUCCESS |
| [#459](https://github.com/WordPress/ai/pull/459) Add C2PA Monitor experiment | 1.3.0 | In progress | review CHANGES_REQUESTED · merge BLOCKED · checks SUCCESS |
| [#494](https://github.com/WordPress/ai/pull/494) [Feature]: Issue 238 \| Focus-aware crop suggestions | Future Release | In progress | review — · merge DIRTY · checks SUCCESS |
| [#683](https://github.com/WordPress/ai/pull/683) Add native vector search | 1.3.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#695](https://github.com/WordPress/ai/pull/695) Add: AI-assisted payload generation to the Ability Explorer - Test Ability Screen | Future Release | In progress | review CHANGES_REQUESTED · merge BLOCKED · checks FAILURE |
| [#760](https://github.com/WordPress/ai/pull/760) PoC: Basic integration with Chrome DevTools for agents | Future Release | **In progress** *(was Needs review)* | review — · merge BLOCKED · checks SUCCESS |
| [#764](https://github.com/WordPress/ai/pull/764) Add a core/manage-settings ability | 1.3.0 | In progress | review — · merge DIRTY · checks SUCCESS |
| [#765](https://github.com/WordPress/ai/pull/765) Add Repo Automator action | Future Release | In progress | review — · merge BLOCKED · checks FAILURE |
| [#777](https://github.com/WordPress/ai/pull/777) dev: Update Composer deps and remediate PHPStan smells | 1.3.0 | In progress | draft · review — · merge DIRTY · checks SUCCESS |
| [#789](https://github.com/WordPress/ai/pull/789) Update bundled wp deps (theme, ui, dataviews, admin-ui) | Future Release | In progress | review — · merge DIRTY · checks FAILURE |
| [#832](https://github.com/WordPress/ai/pull/832) chore(deps): drop @wordpress dependencies to wp-7.0 versions | 1.3.0 | In progress | draft · review — · merge DIRTY · checks FAILURE |
| [#858](https://github.com/WordPress/ai/pull/858) Abilities API: add core/read-nav-menus ability | 1.3.0 | Needs review | review — · merge BLOCKED · checks SUCCESS |
| [#889](https://github.com/WordPress/ai/pull/889) Fixed - Improved accessibility and keyboard usability for request logs provider/model details | 1.3.0 | **In progress** *(newly carded)* | review CHANGES_REQUESTED · merge BLOCKED · checks FAILURE |
| [#920](https://github.com/WordPress/ai/pull/920) fix(deps-dev): bump the npm-dev-minor-patch group with 4 updates | 1.3.0 | **Needs review** *(newly carded, dependabot)* | review — · merge BLOCKED · checks SUCCESS |

> The active feature/platform work includes C2PA monitoring (#459), native vector search (#683), WebMCP (#224), service accounts (#211), focus-aware crops (#494), Ability Explorer payload generation (#695), and Core abilities (#764/#858). Maintenance and documentation cards share the same board lane. **Two PRs joined this table and none left.** **#889** — an unexplained PR in each of the last two windows — was finally given a board card under 1.3.0, closing the cheapest of the six coverage gaps by carding rather than by fixing its unfilled `Closes #<issue-number>` line. **#920** is a dependabot card, part of a four-PR bot batch (#919/#921 merged, #922 closed unmerged, all three already Done). One board status moved: **#760** (Chrome DevTools PoC) went **Needs review → In progress**, which for a PoC awaiting product direction reads as a downgrade of expectation rather than progress. **No board PR changed merge/review readiness this window**, and none of the 15 is in a mergeable state.

### Board vs. repo: PR coverage (five classifications)

The repo has **36 open PRs**. Every open PR gets exactly one coverage classification, joined to Project #240 by repository-qualified `repo#number` keys:

| Classification | Count | Meaning |
|---|---:|---|
| `direct-board-pr` | **15** | The PR itself is a Project #240 card (table above) |
| `linked-board-issue` | **15** | Off-board PR linked to an on-board issue — **all 15 via authoritative GitHub closing references**, no fallbacks |
| `routine` | **0** | Dependency/bot maintenance — the open dependabot PR (#920) is carded, so it classifies as `direct-board-pr`, not `routine` |
| `linked-off-board-issue` | **0** | Links only to an issue that is not on the board |
| `unexplained` | **6** | **No identifiable roadmap relationship: [#888](https://github.com/WordPress/ai/pull/888), [#892](https://github.com/WordPress/ai/pull/892), [#909](https://github.com/WordPress/ai/pull/909), [#915](https://github.com/WordPress/ai/pull/915), [#916](https://github.com/WordPress/ai/pull/916), [#917](https://github.com/WordPress/ai/pull/917)** |

PR→issue mappings come from GitHub `closingIssuesReferences` first (source `closing`, authoritative); restricted title/body/branch fallback parsing (`fallback-*`) applies only to non-routine PRs. **Every issue-linked PR now uses an authoritative `closing` reference** — last window's sole fallback, #881 → #863 by branch name, was replaced with a real `Closes`. The only fallback-parsed relationship left anywhere in the census is #494 → #238 on a direct board PR card.

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
| [#867](https://github.com/WordPress/ai/pull/867) Fix: Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix | [#866](https://github.com/WordPress/ai/issues/866) `closing` | **Needs review**/1.3.0 · hbhalodia | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#881](https://github.com/WordPress/ai/pull/881) Feature: Nex Experiment Abilities Toggle | [#863](https://github.com/WordPress/ai/issues/863) `closing` *(was `fallback-branch`)* | In progress/1.3.0 · hbhalodia | linked-board-issue | — · FAILURE |
| [#887](https://github.com/WordPress/ai/pull/887) Experiment: Add Internal link suggestions | [#875](https://github.com/WordPress/ai/issues/875) `closing` | In progress/1.3.0 · Infinite-Null | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#888](https://github.com/WordPress/ai/pull/888) New Text to Speech experiment | — | — | **unexplained** | — · FAILURE |
| [#891](https://github.com/WordPress/ai/pull/891) Feat: Add semantic search experiment to AI plugin | [#844](https://github.com/WordPress/ai/issues/844) `closing` | In progress/Future Release · priyanshuhaldar007 | linked-board-issue | CHANGES_REQUESTED · FAILURE |
| [#892](https://github.com/WordPress/ai/pull/892) Bring over embeddings support from the PHP AI Client | — | — | **unexplained** | — · FAILURE |
| [#897](https://github.com/WordPress/ai/pull/897) Prototype : Implement slug generation feature with UI and tests | [#876](https://github.com/WordPress/ai/issues/876) `closing` | In progress/1.3.0 · milindmore22 | linked-board-issue | CHANGES_REQUESTED · SUCCESS |
| [#905](https://github.com/WordPress/ai/pull/905) Deprecate the AI_Service layer | [#233](https://github.com/WordPress/ai/issues/233) `closing` *(new this window)* | In progress/1.3.0 | linked-board-issue | — · SUCCESS |
| [#909](https://github.com/WordPress/ai/pull/909) Update documentation around the encryption experiment and address a few bugs | — | — | **unexplained** | — · SUCCESS |
| [#914](https://github.com/WordPress/ai/pull/914) Logging: add a public API for recording MCP tool and ability requests | [#906](https://github.com/WordPress/ai/issues/906) `closing` | Needs review/1.3.0 · azizulhasan | linked-board-issue | — · SUCCESS |
| [#915](https://github.com/WordPress/ai/pull/915) Content Resizing: Preserve inline HTML | — | — | **unexplained** | — · SUCCESS |
| [#916](https://github.com/WordPress/ai/pull/916) Content Classification: Dynamicize taxonomy error messages | — | — | **unexplained** | — · SUCCESS |
| [#917](https://github.com/WordPress/ai/pull/917) Content Resizing: Focus Accept button when suggested content generation completes | — | — | **unexplained** | — · SUCCESS |

> **Coverage risk — same count, half the set replaced, and the two most damaging entries resolved.** Three of last window's six failures cleared, three new ones opened, and the residue is a much lighter class of gap.
>
> **Cleared this window:**
>
> - **[#905](https://github.com/WordPress/ai/pull/905)** was retitled *"Remove unused ai service class"* → **"Deprecate the AI_Service layer"** and now declares **`Closes #233`**. Both halves of last window's complaint are answered: the approach softened (the class and `get_ai_service()` are **deprecated, not deleted**, after dkotter pointed out both are public surface a third party could already be calling), and the board is now told — **#233 moved to 1.3.0 and carries an authoritative closing PR**. Its title still says "leverage" rather than "retire," which is now a wording problem rather than a tracking one.
> - **[#889](https://github.com/WordPress/ai/pull/889)** was given a board PR card under 1.3.0. Note *how* it cleared: the unfilled `Closes #<issue-number>` template line in its body is still there — the gap was closed by carding the PR, not by fixing the reference.
> - **[#913](https://github.com/WordPress/ai/pull/913) merged on 2026-08-07 — uncarded.** This is the failure mode completing, not resolving. The default Anthropic / Google / OpenAI models changed, custom temperature setting was removed, and the public `wpai_meta_description_result_temperature` filter was deprecated — all now in `develop`, and Project #240 never showed any of it. It leaves the census by merging, so the audit goes quiet on it permanently. **This is the one to remember when the unexplained count looks reassuring.**
>
> **Carried over, and these are the load-bearing ones:**
>
> - **[#888](https://github.com/WordPress/ai/pull/888) New Text to Speech experiment** (dkotter, +4,216/-1 across 28 files) registers two new abilities — `ai/speech-generation` and `ai/speech-import` — chunks content to stay under provider limits, imports generated audio into the Media Library, and renders a front-end player with per-post opt-out. Gated on provider work in `ai-provider-for-openai#42` / `ai-provider-for-google#31`. **An entire new experiment with no board card**, now in its third window uncarded and carrying a `[Status] Blocked` label.
> - **[#892](https://github.com/WordPress/ai/pull/892) Bring over embeddings support from the PHP AI Client** (dkotter, +4,394 across 19 files) vendors the client's embedding code into `includes/Vendor/AiClient` behind a new `SDK_Overlay` class. It exists because embedding support landed in php-ai-client 1.4.0 while its core route (`wordpress-develop#12530`) slipped **WP 7.1 → 7.2**. Successor to closed PoC #851 and likely substrate for #683/#844 — load-bearing and uncarded for a third window.
> - **[#909](https://github.com/WordPress/ai/pull/909)** (dkotter, +500/-17 across 9 files) rewrites the encryption-experiment documentation after users misread its guarantees — it does *not* wall API keys off from other plugins — and fixes caller attribution so log hooks record the calling plugin rather than always the AI plugin.
>
> **New, and materially lighter — all three are ordinary contributor polish on shipped experiments:**
>
> - **[#915](https://github.com/WordPress/ai/pull/915) Content Resizing: Preserve inline HTML** (yogeshbhutkar, **+2/-2**) swaps the toolbar's `getBlockText` helper for the shared `getBlockHTML`, so links, emphasis, and code survive the transform. The docs and system prompts already claimed this behavior; the two-line change makes it true.
> - **[#916](https://github.com/WordPress/ai/pull/916) Content Classification: Dynamicize taxonomy error messages** (Infinite-Null, +63/-5) replaces hardcoded "taxonomy" phrasing with the actual taxonomy label, so the Categories panel stops saying "No taxonomy suggestions were generated."
> - **[#917](https://github.com/WordPress/ai/pull/917) Content Resizing: Focus Accept button** (Infinite-Null, +6/-3) moves focus to **Accept** when generation completes, instead of letting it land on a link inside the "Original" pane.
>
> There are no `linked-off-board-issue` PRs, and `routine` reads **0** only because the open dependabot PR is carded — dependency churn is still happening (#919/#921 merged, #922 closed unmerged, all three board-Done). Four PRs left the census (#913 merged; #919/#921 merged; #922 closed unmerged) and seven opened. **Linkage quality improved across the board:** every one of the 15 issue-linked PRs now uses an authoritative `closing` reference, with #881 → #863 upgraded from branch-name inference to a real `Closes`. The live gap is generated by `./wp-ai-roadmap-refresh.sh`; run `--strict --json` for the audit form that exits `2` while any unexplained/off-board substantive PR remains.

### Full-repository PR/release radar

These upstream repositories are fully enumerated by the refresh script, including normalized open PR records, readiness changes, release history/diffs, validation, and independent PR/release snapshots. They are **census-only**: their work can affect the WordPress AI delivery path, but their PRs are not expected to have Project #240 cards.

| Repository | Open PRs | Latest release | Relationship to this roadmap |
|---|---:|---|---|
| [`WordPress/php-ai-client`](https://github.com/WordPress/php-ai-client) | **26** *(+2)* · 35 open issues | **1.4.0** (2026-07-15) | Provider-agnostic PHP AI client used by the WordPress AI stack; embedding, streaming, model-selection, schema, and provider work can change plugin capabilities. Two opened, none closed: **#271** (`isSupported()` returns false instead of letting a `RuntimeException` escape when the output modality has no matching capability — `ModalityEnum::document()` is the reachable case) and **#273** (**an automatic function-call resolution loop plus `withMessages()` on `PromptBuilder`**, +1,255 — an agentic primitive at the client layer, directly relevant to the plugin's own chat/site-agent bets). **Three PRs reached APPROVED** — #231, #250, #254 — the first approving reviews the radar has recorded on either upstream repo. Its shipped 1.4.0 embedding support is still what off-board PR #892 vendors into the plugin. |
| [`WordPress/abilities-api`](https://github.com/WordPress/abilities-api) | **14** · 8 open issues | **v0.4.0** (2025-10-30) | ⚠️ **Pending archival — treat as archaeology, not a backlog.** Newly censused this window. The Abilities API shipped into Core and Gutenberg, and issue **#160** carries unanimous maintainer agreement to archive the standalone repo (jeffpaul asked dd32/desrosj to action it on 2026-02-04; still open). No open PR has been touched since **2026-01-21**. Several stranded PRs bear directly on live roadmap questions — **#85** `wp_query_abilities` and **#115**/**#119** ability filtering against #21 and #354, **#150** input/output validation filters against #348 — but nobody is reviewing them. Real Abilities work is now in `wordpress-develop` and `gutenberg`, neither of which is censused. |
| [`WordPress/mcp-adapter`](https://github.com/WordPress/mcp-adapter) | **18** *(−2)* · 46 open issues | **v0.5.0** (2026-04-15) | Bridges Abilities to MCP; transport, exposure, approval, schema, session, and server-registration work affects agent integrations. **First decline since joining the census**, and it is the DTO cluster resolving: **#262** (emit `mimeType` as declared) **merged 2026-08-05**, and **#256** (pre-tool-call completion) was **closed unmerged 2026-08-01**. Readiness: **#260** — the comprehensive draft that also declares `Closes #245` — went **BLOCKED → DIRTY**, precisely the collision predicted last window when the four-PR cluster was called overlapping rather than partitioning. **#263** and **#264** remain open against the same issue #245. One opened against those two departures: draft **#277**, a `wordpress/php-mcp-schema` v0.1.3 bump (created 2026-08-10 09:26 UTC, ten minutes before this refresh's snapshot) so unrecognized fields survive on open MCP schema types. Nineteen open PRs against an April release now nearly four months old. |

Membership lives in [`wp-ai-roadmap-repositories.json`](./wp-ai-roadmap-repositories.json). Run `./wp-ai-roadmap-refresh.sh census --strict` for the complete live census; the existing five-way board-coverage classification remains exclusive to `WordPress/ai`.

---

## ① Dated release lanes

### v1.2.0 — ✅ Shipped 2026-07-14 — 1 residual board-open issue

The `WordPress/ai` release shipped and milestone #19 is closed. Project #240 still has one non-Done 1.2.0 card in another repository:

| Issue | Status | Summary |
|---|---|---|
| [#23](https://github.com/WordPress/ai-provider-for-google/issues/23) | In discussion / Needs decision | [Bug]: Image Generation fails with "Unexpected Google API response: Missing the candidates[0].content key" |

This is provider follow-up, not unfinished code in the released plugin.

### v1.3.0 — Active — 21 non-Done (13 issues + 8 PRs)

The lane went **8 Done / 15 open → 5 Done / 21 open**. **Nothing left it by shipping**; the Done count fell because five already-Done 1.3.0 cards (#191, #192, #452, #507, #874) were de-carded, offset by dependabot PRs #919/#921 arriving Done.

The growth is entirely re-milestoning, and it reverses last window's direction: **#875** and **#876** returned from Future Release nine days after being pushed out of 1.4.0, **#233** came in from Future Release now that PR #905 authoritatively closes it, and **#906** was milestoned from nothing. Three dependabot cards (#919/#920/#921) and the newly-carded a11y PR **#889** were added on top.

What sits here now is the same work as last window plus four cards that changed label: two review-ready UX/infra issues, the logging and lifecycle cluster, the C2PA and Abilities-toggle experiments, and the two editorial experiments whose product questions are still open.

| Issue | Status | Summary |
|---|---|---|
| [#233](https://github.com/WordPress/ai/issues/233) | In progress | Refactor experiments to leverage AI_Service layer — ⚠️ title stale; closing PR #905 **deprecates** the layer *(in from Future Release)* |
| [#421](https://github.com/WordPress/ai/issues/421) | In progress | WordPress should detect C2PA manifests on upload |
| [#514](https://github.com/WordPress/ai/issues/514) | In progress | Add comment value / relevance to Comment Moderation experiment |
| [#660](https://github.com/WordPress/ai/issues/660) | Needs review | UX: Ambiguous error message in editor when a provider is blocked by Connector Approvals |
| [#690](https://github.com/WordPress/ai/issues/690) | In progress | Plugin does not clean up database table and options on uninstall |
| [#732](https://github.com/WordPress/ai/issues/732) | In progress | AI Request Logging only captures providers that use the SDK HTTP transporter; sidecar/custom-transport providers are invisible |
| [#741](https://github.com/WordPress/ai/issues/741) | In discussion / Needs decision | AI Admin Pages Exhibit Visible Flicker During Initial Render |
| [#845](https://github.com/WordPress/ai/issues/845) | In progress | New Experiment: Markdown feeds (powered by `html-to-md`) |
| [#863](https://github.com/WordPress/ai/issues/863) | In progress | New Experiment: Abilities toggle *(was To do; PR #881 out of draft)* |
| [#866](https://github.com/WordPress/ai/issues/866) | Needs review | Bug Inconsistency: Standardize post meta key naming with the `wpai_` prefix *(was In progress)* |
| [#875](https://github.com/WordPress/ai/issues/875) | In progress | New Experiment: Suggest internal links within post content *(back from Future Release)* |
| [#876](https://github.com/WordPress/ai/issues/876) | In progress | New Experiment: Suggest permalink slugs *(back from Future Release)* |
| [#906](https://github.com/WordPress/ai/issues/906) | Needs review | Request Logging: no public API to record the reserved `mcp_tool` and `ability` log types *(milestoned in from none; was In progress)* |

#### Open PRs (8)

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

#### PR #889 — Improved accessibility and keyboard usability for request-log provider/model details · *In progress · not draft · BLOCKED · CHANGES_REQUESTED · checks FAILURE · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/889) · @murshed
**Delivers.** Replaces the non-semantic clickable container behind the request logs' provider/model details popover with a proper semantic, keyboard-operable control, improving screen-reader and keyboard navigation and making the popover behavior explicit.
**Blockers.** **Newly carded this window** after two windows as an unexplained PR — but carding is all that changed: it still carries CHANGES_REQUESTED and failing checks, and its body still contains the unfilled template line `Closes #<issue-number>`, so the PR is on the board while its issue reference remains blank.

#### PR #920 — fix(deps-dev): bump the npm-dev-minor-patch group with 4 updates · *Needs review · not draft · BLOCKED · checks SUCCESS · 1.3.0*
[Link](https://github.com/WordPress/ai/pull/920) · @dependabot
**Delivers.** Routine dev-dependency maintenance: `@playwright/test` 1.61.1 → 1.62.1 plus `@wordpress/build`, `@wordpress/e2e-test-utils-playwright`, and `@wordpress/prettier-config`.
**Blockers.** None substantive — checks are green and it is BLOCKED only for want of an approving review. Listed here because dependabot PRs are carded in this repo, which is why the census reports `routine: 0` even in a window with four bot PRs.

### v1.4.0 — Next — 2 issues (both In discussion)

| Issue | Status | Summary | Implementing PR |
|---|---|---|---|
| [#27](https://github.com/WordPress/ai/issues/27) | In discussion / Needs decision | Display additional AI provider plugins on Connectors page (alongside default Anthropic, Google, and OpenAI ones) | — |
| [#324](https://github.com/WordPress/ai/issues/324) | In discussion / Needs decision | Evolve Refine from Notes into collaborative and agentic editorial workflows | — |

**This lane was skipped over, not refilled.** #875 (internal links) and #876 (permalink slugs) left 1.4.0 for Future Release last window; this window they were pulled back into a dated lane — but into **1.3.0**, not here. Both PRs (#887, #897) still carry **CHANGES_REQUESTED**, both issues still have their product questions open, and #887 has since gone DIRTY. So the pair completed a 1.4.0 → Future Release → 1.3.0 round trip in two windows without either PR clearing review: the scheduling moved twice and the work did not move at all.

What remains in 1.4.0 is the residue: provider discovery (#27) and agentic Refine/RTC (#324), both genuinely undecided, with no code at all and no movement this window either. **v1.4.0 has now spent two consecutive windows containing nothing that anyone is building** — and this window the team demonstrably preferred to load 1.3.0 rather than use it.

---

## ② Planned backlog — Future Release (40)

**Three cards left this tier and none arrived:** #233 (`AI_Service` retirement), #875 and #876 (internal links, permalink slugs) were all re-milestoned into **1.3.0**. Of last window's three re-milestoned arrivals, only **#736** (role/user access controls) stayed — it remains In progress with PR #749 DIRTY and CHANGES_REQUESTED. Six cards here are still In progress with live PRs (#238/#494, #625, #689/#735, #736/#749, #844/#891, plus #203 and #307 without), so read "Future Release" as *unscheduled*, not *inactive*.

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
| [#307](https://github.com/WordPress/ai/issues/307) | In progress | Add AGENTS.md to streamline contributor onboarding |
| [#325](https://github.com/WordPress/ai/issues/325) | In progress | Integrate media features and experiments with Gutenberg's experimental Media Editor |
| [#338](https://github.com/WordPress/ai/issues/338) | **In progress** | New Experiments: Analytics-aware content and amplification recommendations *(moved from In discussion; no PR yet)* |
| [#339](https://github.com/WordPress/ai/issues/339) | To do | AI 0.6 + WP7RC1 + Gutenberg 22.7.1 : can't keep connection alive within the AI plugin |
| [#348](https://github.com/WordPress/ai/issues/348) | In discussion / Needs decision | Feature Request: Unified AI Management Layer for WordPress Core |
| [#354](https://github.com/WordPress/ai/issues/354) | In discussion / Needs decision | Unifiied Abilities exposure controls |
| [#425](https://github.com/WordPress/ai/issues/425) | In discussion / Needs decision | Update placement of Alt Text generation buttons |
| [#430](https://github.com/WordPress/ai/issues/430) | In discussion / Needs decision | Skills in a WordPress admin context |
| [#448](https://github.com/WordPress/ai/issues/448) | In discussion / Needs decision | Add WebMCP experiment |
| [#502](https://github.com/WordPress/ai/issues/502) | In discussion / Needs decision | Define how AI provider plugins are discovered, labeled, and surfaced in Connectors |
| [#600](https://github.com/WordPress/ai/issues/600) | In discussion / Needs decision | `Enable AI` header toggle doesn't reflect aggregate state of sub-features |
| [#625](https://github.com/WordPress/ai/issues/625) | **In progress** | New Experiment: Social Content Generation for platform-specific social posts *(moved from In discussion; no PR yet)* |
| [#643](https://github.com/WordPress/ai/issues/643) | In discussion / Needs decision | "AI" plugin 1.0.1 – Connectors and AI settings pages load blank (JavaScript error) on WordPress 7.0 |
| [#689](https://github.com/WordPress/ai/issues/689) | In progress | Add a user-facing control for automatic log cleanup |
| [#736](https://github.com/WordPress/ai/issues/736) | In progress | Expose role/user access controls per feature/experiment *(re-milestoned from 1.3.0 last window and **not** pulled back this window)* |
| [#791](https://github.com/WordPress/ai/issues/791) | In discussion / Needs decision | Add loading animation/custom cursor for Type Ahead |
| [#844](https://github.com/WordPress/ai/issues/844) | In progress | New Experiment: Semantic search in wp admin |

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

> **The `AI_Service` thread left this lane entirely — and landed correctly.** Card **#233** was re-milestoned **Future Release → 1.3.0** this window, so it is no longer part of this tier. More importantly, its implementing PR **#905** now declares **`Closes #233`** and was retitled *"Remove unused ai service class"* → **"Deprecate the AI_Service layer"**: dkotter pointed out that `AI_Service` and `get_ai_service()` are public surface a third party could already be calling, so the class and helper stay and are marked deprecated rather than deleted. Both problems this file raised last window — an unlinked PR and a needlessly breaking approach — are resolved. Only the card's title is still stale.
>
> **Still open from last window:** PR **#851** ("PoC: Test upcoming embedding changes") was closed unmerged on 2026-07-22 exactly as its author intended, and its purpose is still carried by off-board PR **#892**, which vendors the released php-ai-client 1.4.0 embedding code into `includes/Vendor/AiClient` behind an `SDK_Overlay`. That successor remains **uncarded** — the embeddings thread has now spent three full windows untracked-but-load-bearing, and upstream has meanwhile moved on to a *further* capability the plugin does not have (php-ai-client **#273**, an automatic function-call resolution loop).

---

## ③ Straggler — 1

- **[PR #484](https://github.com/WordPress/ai/pull/484) — "Ignore .wp-env.test.override.json"** is already merged (2026-04-29) but remains board-Needs review under 0.9.0. It is a board-hygiene item, not pending delivery.

**Removed-board reference:** [WordPress/abilities-api#84](https://github.com/WordPress/abilities-api/issues/84) remains open upstream under milestone Later but is not part of Project #240.

---

## ④ Unscheduled — 2

| Issue | Status | Summary |
|---|---|---|
| [#890](https://github.com/WordPress/ai/issues/890) | Triage | Add mobile right sidebar display component |
| [#918](https://github.com/WordPress/ai/issues/918) | Triage | **Board-new** — Feature: AI-generated `llms.txt`, a curated LLM-friendly site index served at `/llms.txt` |

- **This tier shrank by resolution, not neglect.** **#906** was milestoned into **1.3.0** and moved to Needs review behind PR #914 — the cleanest issue → card → PR → link chain on the board finally got a release attached, closing the "milestone #906/#914" item that has sat in *Work for Later* since it was filed. **#869** was closed **`NOT_PLANNED`** on 2026-08-05: "Closing as this is not reproducible, but @jannefleischer once you're back from vacation please let us know if you're still seeing issues." The `Asset_Loader::add_global_data()` mechanism it described — queued global data attaching only to the *first* script processed in a request, which on a post-edit screen is the block-editor iframe — was never disproved, only never reproduced. Treat it as dormant rather than fixed; a repro brings it straight back.
- **#918** arrived 2026-08-07 from hbhalodia (the contributor behind #863 and PR #881) as a well-argued three-phase proposal: LLMs and agents currently read sites either by crawling raw HTML (noisy, token-expensive) or via sitemaps built for search crawlers (every URL, no priority or summary). [`llms.txt`](https://llmstxt.org/) is an emerging single-Markdown-file convention that does for agents what `robots.txt` and `sitemap.xml` do for crawlers; the differentiator claimed here is AI-*generated* descriptions via the plugin's own connectors and `core/read-content`. Labeled `[Type] Enhancement`, unmilestoned. **The scoping question is whether this belongs in an experiments plugin at all** — it is a site-wide public endpoint, not a per-post editorial feature, which puts it closer to core/SEO-plugin territory than to the Experiment model in [§3 of the roadmap](./wordpress-ai-roadmap.md#3-product-architecture). The sole comment is jeffpaul asking justlevine "what's the current state of recommendation on this sort of a file being served from sites?" — a question about whether the **standard** is settled enough to build on, still unanswered.
- **#890** arrived 2026-07-23 with no labels, milestone, assignee, or comments, and still does not say which AI surface it targets or whether the responsibility sits in `WordPress/ai` at all rather than in Gutenberg's editor chrome. Unchanged for three windows. Triage before scoping.

---

## ⚠️ Data-quality flags (verify before acting)

1. **PR #484 is merged**, not open, despite its board status.
2. **"Done" does not mean shipped — PR #621 is the proof.** It was closed **unmerged** on 2026-07-28 after weeks of contributor silence (dkotter: "happy to re-open"), then marked board-**Done** with its 1.3.0 milestone stripped. Its uploads-base-URL hardening is not in `develop` and has no successor PR. Any velocity or completion metric read off board-Done status will count this as delivered. Check `state`/`mergedAt`, not board status.
3. **Board ≠ repo — and a gap can close by *merging*, not by being tracked.** 36 open PRs = 15 direct-board-pr + 15 linked-board-issue + 0 routine + 0 linked-off-board-issue + **6 unexplained (#888, #892, #909, #915, #916, #917 — the current strict-audit failures)**. The count held at six, but **#913 left the set by merging on 2026-08-07 while still uncarded**, taking a default-model change and a public-filter deprecation into `develop` with no board record. A falling or flat unexplained count does not mean the work got tracked; check whether entries left by being carded/linked or by being merged.
4. ~~**A board card can be actively contradicted by its own implementation.**~~ **Resolved this window.** PR #905 now declares `Closes #233`, and #233 moved to 1.3.0. The approach also changed — #905 **deprecates** `AI_Service` and `get_ai_service()` rather than deleting them, after dkotter noted both are public surface. What remains is cosmetic: #233's title still reads "Refactor experiments to leverage AI_Service layer" when the work is retirement. Retitle or close it against #905.
5. **A flat board total can hide complete turnover.** The board stayed at 269 while six cards left and six arrived, and the PR/issue mix moved 209/60 → 214/55. Read `.board.added` and `.board.removed`, never the total alone — this is the same trap as the 274 → 269 fall last window, in the opposite direction.
6. **A growing dated lane is not delivery either.** v1.3.0 went 15 → 21, but nothing left it by shipping: #233/#875/#876/#906 were re-milestoned in and four dependabot cards were added. All five milestone moves this window pulled work *toward* a release, exactly inverting last window's three-out-of-four moving away. Neither direction reflects work completing.
7. **1.2.0 is shipped and its GitHub milestone is closed**, but external provider issue #23 still carries that milestone and remains board-open.
8. **Board-added ≠ real work.** Four of this window's six additions are dependabot PRs, three of which arrived already-Done (and one of those, **#922**, was *closed unmerged* yet still shows Done). Only **#918** is a substantive new proposal. Exclude bot cards before reading "cards added" as intake.
9. **A `NOT_PLANNED` close is not a fix.** #869 was closed as not reproducible, not as resolved — the reporter was on vacation and was explicitly invited to reopen. The `Asset_Loader::add_global_data()` behavior it described has not been shown to be wrong.
10. **#890 is unscoped, and #918 is unscoped in a different way.** #890 has no labels, milestone, assignee, comments, or named target surface after three windows. #918 is well-argued but proposes a site-wide public `/llms.txt` endpoint, which may not fit the per-post Experiment model at all — decide scope before treating either as plannable.
11. **The provenance shape is settled but review-blocked:** signing PRs #294/#302 closed without merge; the read/monitoring PR #459 is the sole live path, is the **authoritative closing PR for #421**, and carries CHANGES_REQUESTED including a sidecar-storage security objection.
12. **#844 opened ahead of its stated blocker.** The issue was filed as blocked on #683 for its embedding pipeline, yet PR #891 opened while #683 is still a DIRTY draft — and #891 has now picked up CHANGES_REQUESTED. Verify the two are not building duplicate indexing machinery, and factor in #892's vendored embedding layer.
13. **Merge-state fields are volatile** and should be rechecked before prioritization — but the aggregate is worth stating plainly and it did not move: **every one of the 36 open `WordPress/ai` PRs is BLOCKED (24) or DIRTY (12); none carries an APPROVED review; 16 have failing checks and 14 carry CHANGES_REQUESTED** (flat). Nothing in the repository is currently in a mergeable state, and the entire window produced three readiness changes (#881 out of draft, #887 → DIRTY, #914 checks green). For contrast, upstream `php-ai-client` recorded **three APPROVED reviews** in the same period.
14. **GitHub's `mergeStateStatus` transiently reads `UNKNOWN` — the script now handles it, so don't hand-correct for it.** Mergeability is computed lazily and *asking* is what schedules the job, so a cold census reports `UNKNOWN` for PRs nothing has touched: this window's first run said 27 of 36. `fetch_pr_census()` now re-queries once (`WP_AI_MERGESTATE_RETRY_DELAY`, default 2s), keeps whichever answer knows more, emits a `pr-mergestate-unknown` **warning** — never an error, since uncomputed mergeability is not a coverage failure — for any PR still cold, and `PRDIFF_JQ` ignores transitions into or out of `UNKNOWN`. Both halves matter: without the retry the report is wrong, and without the diff guard the *saved snapshot* is wrong and replays the phantom churn in reverse next window. Regression-tested by `tests/wp-ai-roadmap-refresh-mergestate.sh`.
15. **Cross-repo signals are separate:** neither the 16-item Gutenberg/abilities-api dependency watchlist nor the full `php-ai-client` / `mcp-adapter` / `abilities-api` PR-issue-release censuses are included in Project #240 counts; coverage validation applies only to `WordPress/ai`.
16. **Do not sum the dependency watchlist and the repository census.** `WordPress/abilities-api` now appears in both by design: the watchlist carries curation the census cannot derive (`theme`, `aiRefs`, `note`, `required`) and follows items through closure, while the census tracks only the live open set. Items `#38` and `#84` are open issues counted in both.
17. **`abilities-api` counts are archaeology, not backlog.** The repository is pending archival (issue #160, unanimous agreement since January, still unactioned) because the API moved into Core and Gutenberg. Its 14 open PRs and 8 open issues are stranded, not planned. Do not read them as capacity, and do not treat a stale abilities-api PR as a live dependency.
18. **Every open `WordPress/ai` issue is now required to be carded.** An uncarded one is an `issue-roadmap-coverage-missing` error that fails `--strict`, the issue-side peer of the PR coverage rule. Current state is 50 of 50 carded. If that ever goes red, the board has stopped seeing an issue that exists in the repository.

---

## 🔭 Work for Later

- [x] **Ship v1.2.0** — released 2026-07-14 and deployed to WordPress.org.
- [x] **Clarify #851's PoC lifecycle** — closed unmerged 2026-07-22 as designed; succeeded by #892.
- [x] **Define the Yoast integration contract for #874** — root-caused to Yoast's `yoast-seo/editor` store plus `post`-only REST meta registration, fixed in merged PR #886, and filed upstream as `Yoast/wordpress-seo#23458`.
- [x] **Settle the `AI_Service` direction (#233)** — answered, and now *tracked*: #905 declares `Closes #233`, the card moved to 1.3.0, and the approach softened from deletion to deprecation.
- [ ] **Retitle board card #233** — "Refactor experiments to leverage AI_Service layer" describes the opposite of what #905 does. Tracking is fixed; wording is not.
- [x] **Milestone #906/#914** — done: #906 is now 1.3.0 and Needs review.
- [ ] **Card the uncarded features — still three that matter.** #888 (Text to Speech) and #892 (vendored embeddings) are in their third uncarded window, joined by #909. Last window's other three cleared, but note *how*: #905 by linking, #889 by carding, and **#913 by merging uncarded** — which is the outcome to prevent, not to celebrate.
- [ ] **Unblock the review queue.** All 36 open PRs are BLOCKED or DIRTY with zero approvals; triage which of the 14 CHANGES_REQUESTED PRs are close to landing. Three readiness changes in a nine-day window is the clearest measure of the constraint.
- [ ] **Decide whether #621's hardening still matters.** It was closed for contributor inactivity, not because the concern was dismissed — if the uploads-URL boundary check is worth having, it needs a new PR; if not, say so on the issue.
- [ ] **Reconcile the three embeddings efforts** — #683 (draft, board-tracked), #891/#844 (opened ahead of its #683 blocker, now CHANGES_REQUESTED), and #892 (uncarded `SDK_Overlay` vendoring) — before duplicate indexing machinery ships.
- [ ] **Give v1.4.0 content or retire the lane.** It has now spent two windows holding only #27 and #324, with no code and no decisions — and this window the team pulled work into 1.3.0 rather than into it. That is a signal the lane is vestigial.
- [ ] **Stop the 1.4.0 → Future Release → 1.3.0 churn on #875/#876.** Two milestone reversals in two windows while both PRs sat at CHANGES_REQUESTED. Answer the product question (where these surface in the editor) before scheduling them a third time.
- [ ] **Triage #918** — decide whether a site-wide public `/llms.txt` endpoint belongs in an experiments plugin before it accrues an implementation PR the way #875/#876 did.
- [ ] **Close or re-milestone provider issue #23** now that the plugin's 1.2.0 milestone is closed.
- [ ] **Resolve standalone-ability governance (#863)** before additional write/destructive abilities expand the always-registered surface — #888 would add two more (`ai/speech-generation`, `ai/speech-import`) outside that conversation. Both halves have now moved: `mcp-adapter#254` merged upstream, and #863 is In progress under 1.3.0 with PR #881 out of draft — but #881 has failing checks and no review.
- [ ] **Land the C2PA path:** #459 is the confirmed closing PR for #421 and needs its CHANGES_REQUESTED items addressed, including the sidecar-storage security objection.
- [ ] **Rebase/review the v1.3.0 PR lane**, especially DIRTY #683/#764/#777/#832 and BLOCKED #459/#858/#889.
- [ ] **Triage #890 into a defined scope** — three windows with no labels, milestone, assignee, or comments.
- [x] **Reproduce #869 cleanly** — closed `NOT_PLANNED` on 2026-08-05 as not reproducible, with the reporter invited to reopen. Dormant, not disproved.
- [ ] **Fix board hygiene** for merged PR #484 — and for **#922**, a dependabot PR closed unmerged that still shows Done.
- [ ] **Decide whether off-board PRs should receive PR cards** or remain represented only through their backing issue cards. #889's carding this window sets a precedent worth making explicit.
- [x] **Maintain the refresh workflow** — `wp-ai-roadmap-refresh.sh` passes `bash -n`, **seven** offline fixture suites, and the live 16-ID dependency smoke test in this refresh. New this window: the census detects and re-queries GitHub's lazily-computed `mergeStateStatus: "UNKNOWN"` (see flag 14), covered by `tests/wp-ai-roadmap-refresh-mergestate.sh`.

---

## Changelog

| Date | Change |
|---|---|
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
