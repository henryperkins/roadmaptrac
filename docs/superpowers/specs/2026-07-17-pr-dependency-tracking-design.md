# Pull Request and Dependency Tracking Improvements

**Date:** 2026-07-17
**Status:** Approved design

## Goal

Improve the roadmap refresh system so a plugin or theme developer can quickly determine:

- what changed in WordPress AI development;
- what work is already assigned, implemented, or planned;
- which open pull requests represent code already in flight;
- which upstream changes may affect extension development; and
- where incomplete tracking creates a risk of duplicated or mistimed work.

The system remains read-only. It reports GitHub project and repository state but never adds, edits, or removes project cards.

## Non-goals

- Automatically synchronizing pull requests into Project #240.
- Replacing Project #240 as the canonical roadmap source.
- Tracking every issue in Gutenberg or every repository in the WordPress organization.
- Rewriting the Bash and jq implementation in another language.
- Fully generating every narrative roadmap dossier from machine data.

## Operating Modes

Normal mode remains warning-only so an upstream data problem does not prevent a useful board report.

An optional `--strict` flag turns actionable data-quality and coverage gaps into a nonzero exit status. Strict mode is intended for CI and explicit audits. It performs no GitHub writes.

Because coverage depends on upstream `WordPress/ai` contributor behavior, strict coverage is initially a scheduled audit signal, not a required merge gate for this repository. A persistent red result means unresolved roadmap visibility, not a broken tracker. Teams may promote it to a required gate only after adopting the coverage policy; this design adds no waiver or allowlist mechanism.

Strict mode fails when any of these conditions applies:

- pull-request pagination is incomplete or returned data is malformed;
- the dependency registry is invalid or contains duplicate identifiers;
- a required dependency cannot be fetched;
- a substantive open pull request has neither a direct Project #240 PR card nor a link to an on-board issue; or
- the generated validation contract is internally inconsistent.

A routine pull request is exempt from roadmap-coverage failure. A substantive pull request linked only to an off-board issue remains a coverage error because the work is not represented in Project #240.

Coverage validation requires a board snapshot. `census --strict` therefore validates PR fetch completeness, pagination, and schema only. The normal full refresh joins the census to the live board and applies the strict coverage rule. Offline `gap` output always includes coverage validation for its supplied board and PR snapshots. `gap BOARD.json PRS.json` emits the validation result but remains warning-only; `gap --strict BOARD.json PRS.json` emits the same JSON and exits with the strict-violation status when coverage errors exist.

## Architecture

Retain `wp-ai-roadmap-refresh.sh` as the single command-line entry point and continue using Bash, jq, GitHub CLI, normalized JSON snapshots, and the existing Markdown documents.

Add one declarative registry at the repository root:

- `wp-ai-roadmap-dependencies.json`

Add focused shell tests and JSON fixtures under `tests/`. The main script consumes the registry and continues to expose the current `fetch`, `census`, `dependencies`, `diff`, `gap`, `prdiff`, and `reldiff` commands.

## Dependency Registry

The registry has a versioned top-level object and an `items` array. Each item contains:

```json
{
  "id": "WordPress/gutenberg#70710",
  "theme": "Platform / workflows",
  "aiRefs": [21, 40, 430],
  "note": "Abilities and Workflows overview for Command Palette and AI tool surfaces",
  "required": true
}
```

Validation requires:

- `schemaVersion` to equal `1`;
- a nonempty `items` array;
- unique IDs in `owner/repository#number` form;
- nonempty `theme` and `note` strings;
- unique positive integer `aiRefs`; and
- a Boolean `required` value.

The existing 16-item watchlist moves into the registry without changing membership. Adding or removing a dependency becomes a reviewable data change instead of a shell-code edit.

The environment override `WP_AI_DEPS_FILE` may select another registry. This supports fixtures and controlled experiments while defaulting to the repository file.

## Dependency Fetching and Output

The fetcher validates the complete registry before making GitHub requests. It then attempts every configured item.

Each failed GitHub request needed to resolve a required dependency is retried exactly once before the item becomes `UNKNOWN`. The retry is immediate, so the command remains bounded and fixture tests can assert the exact two-attempt contract. Optional dependencies receive one attempt.

A successful record preserves the current fields and adds `required`. An unreachable item does not disappear. It produces a placeholder with its configured metadata, `state: "UNKNOWN"`, and a structured `fetchError` value.

Dependency JSON retains `items`, `summary`, and `diff`, and adds:

```json
{
  "validation": {
    "ok": true,
    "errors": [],
    "warnings": []
  }
}
```

Summary counts are always derived from emitted items. Normal mode warns about unreachable dependencies. Strict mode emits the complete diagnostic report and then exits nonzero when a required dependency is unknown.

An unreachable optional dependency is a warning in both modes and does not cause strict failure. An invalid registry prevents dependency requests; JSON mode still emits an empty, internally consistent result with registry errors in `validation` so CI receives a parseable diagnosis.

## Pull Request Census

Replace the `gh pr list` census with a paginated GitHub GraphQL query. The query captures:

- number, title, URL, author, branch, draft state, and update time;
- review decision and merge state;
- the latest commit check-rollup state when available; and
- GitHub `closingIssuesReferences(first: 20)`, including its `totalCount`, repository, and issue number.

The reported PR total must equal the number of normalized nodes after pagination. Each closing-reference `totalCount` must equal its returned node count; more than 20 references is reported as truncation instead of being silently accepted.

### Routine heuristic

The normalized `isBot` value is derived from GraphQL `author.__typename == "Bot"`; it does not depend on the `gh pr list` convenience field `author.is_bot`.

A PR has `routine: true` when any one of these exact, case-insensitive rules matches:

- `author.__typename` is `Bot`;
- the author login contains `dependabot`; or
- the title starts with `fix(deps)`, `build(deps)`, `chore(deps)`, or `ci:`.

These rules preserve the current routine/substantive contract. The `routine` Boolean remains on every normalized PR independently of its coverage classification, supplies the strict-mode exemption, and disables fallback issue parsing. Fixture tests cover bot typename detection, dependabot login detection, each accepted title prefix, and near-miss titles.

### Issue-link precedence

GitHub closing references are authoritative. Fallback parsing is disabled whenever `routine` is true. For substantive PRs, it accepts only this case-insensitive grammar:

- **Title:** `(?:^|[^A-Za-z0-9_/-])#([1-9][0-9]*)` or `\b(?:issue|feat|feature)[ :_#-]+([1-9][0-9]*)`, with the captured digits followed by end-of-string or a non-digit.
- **Branch:** `(?:^|/)(?:issue|feat|feature)[/_-]#?([1-9][0-9]*)(?:$|[/_-])`. This accepts `feature/430-fix` and `issue-660-message` but not a bare leading number.
- **Body:** one of the exact relationship forms `fix`, `fixes`, `fixed`, `close`, `closes`, `closed`, `resolve`, `resolves`, `resolved`, `implement`, `implements`, `implemented`, `track`, `tracks`, `tracked`, `relates to`, `related to`, or `issue`; optional horizontal space plus an optional colon; at least one horizontal space; then exactly one of `#NNN`, `owner/repository#NNN`, or `https://github.com/owner/repository/issues/NNN`, where `NNN` is a positive decimal integer.

Accepted sources are `closing`, `fallback-title`, `fallback-body`, `fallback-branch`, and `legacy`, in that precedence order. The fallback never accepts an arbitrary body `#NNN`, a changelog bullet, a bare branch such as `430-add-thing`, a semantic version, or a branch such as `update-php-8.2-compat`. Fixture tests include every accepted form and those near misses.

Each normalized PR retains the backward-compatible `issues` number array containing only links whose repository equals `WP_AI_REPO`, and adds:

```json
{
  "issueLinks": [
    {
      "repo": "WordPress/ai",
      "number": 452,
      "source": "closing"
    }
  ]
}
```

When the same issue is found through more than one method, the source-precedence order selects one record. Links are unique by repository plus issue number and deterministically sorted by those two fields.

### PR diff contract

`prdiff` preserves `newly_opened` and `no_longer_open` and adds `readiness_changed`. A readiness record is emitted when any of `isDraft`, `reviewDecision`, `mergeStateStatus`, or `checkState` differs between snapshots; it contains the PR number and a before/after value for each field that changed. A field is compared only when it exists in both records, so a legacy snapshot does not generate schema-migration noise. An `updatedAt` change alone is not a readiness change.

## Roadmap Coverage Classification

Board PR cards and issue cards are indexed by canonical `repository#number`, not by bare number. Direct PR coverage and every `issueLinks` join compare both repository and number, so cross-repository Project #240 cards cannot collide with `WordPress/ai` issues.

For backward compatibility, a bare number in the legacy normalized PR `issues` array is interpreted as belonging to the current `WP_AI_REPO` value and receives source `legacy`. This conversion happens in memory; historical snapshot files are not rewritten.

Every open pull request receives exactly one of five classification values through this decision order:

1. `direct-board-pr` when Project #240 contains its PR card;
2. `linked-board-issue` when an off-board PR has an authoritative `closing` link to an issue card on Project #240, even if the PR is routine;
3. `routine` for any remaining off-board automated or dependency-maintenance PR;
4. `linked-board-issue` when a remaining off-board substantive PR has a fallback or legacy link to an issue card on Project #240;
5. `linked-off-board-issue` when a remaining substantive PR links only to an issue outside the board; or
6. `unexplained` when no roadmap relationship can be identified.

The second step intentionally lets an authoritative GitHub closing relationship outrank routine classification so genuinely implementing work remains visible in the "already underway" view. Routine PRs never receive fallback links, and their independent `routine: true` flag still supplies the strict-coverage exemption.

The gap JSON includes counts and item arrays for all classifications plus the existing tracked, untracked, substantive, and routine fields. Existing snapshots with only an `issues` array remain readable through the legacy conversion rule.

The human report shows uncovered substantive work first. It includes mapping source, roadmap issue status, milestone, and assignees, plus PR draft state, review decision, merge state, check state, author, and last activity where available.

## Validation Invariants

Every `validation` object follows these rules:

- `ok` is true if and only if `errors` is empty; warnings do not make `ok` false;
- every error or warning has a stable `code`, human-readable `message`, and structured `context` object; and
- repeated inputs produce errors and warnings in deterministic code-and-context order.

The PR census and coverage join enforce these invariants:

- GraphQL `pullRequests.totalCount` equals the number of unique normalized PR nodes collected across all pages;
- every normalized PR number is unique;
- every bounded `closingIssuesReferences(first: 20)` connection has `totalCount` equal to its emitted node count and no more than 20 nodes;
- every open PR belongs to exactly one of the five coverage classifications;
- the five classification counts sum to `open_total` and equal the lengths of their corresponding arrays;
- `tracked_open + (untracked | length)` equals `open_total`;
- `routine_count + (substantive | length)` equals `(untracked | length)`; and
- coverage errors identify exactly the non-routine PRs classified as `linked-off-board-issue` or `unexplained`.

The dependency result enforces these invariants:

- emitted IDs equal the validated registry IDs exactly, including `UNKNOWN` placeholders;
- `summary.total` equals `(items | length)`;
- `summary.by_repo` and `summary.by_state` equal counts recomputed from `items`;
- every required `UNKNOWN` item creates an error; and
- every optional `UNKNOWN` item creates a warning and no error.

The full report's aggregate errors and warnings are the deterministic union of its subsystem validation entries, and its aggregate `ok` value follows the same errors-empty equivalence.

## Developer Radar

The pull-request and dependency sections should answer three questions in order:

1. **What changed?** Newly opened or closed PRs, review or merge-state changes, and dependency state changes.
2. **What is already underway?** Active PRs mapped to roadmap work, including ownership, milestone, status, and readiness.
3. **What could affect extension work?** Dependencies grouped by theme, with the configured reason and linked WordPress AI roadmap issues.

Unexplained work, off-board issue relationships, and unknown dependency states are explicit. PR and dependency records retain `updatedAt`, and the human report shows activity age in whole days so readers can assess staleness without an arbitrary threshold. Age alone is never a strict-mode error. The report must not imply certainty by omitting unavailable records.

## CLI Behavior

Supported strict invocations include:

```bash
./wp-ai-roadmap-refresh.sh --strict
./wp-ai-roadmap-refresh.sh --strict --json
./wp-ai-roadmap-refresh.sh census --strict
./wp-ai-roadmap-refresh.sh dependencies --strict --json
./wp-ai-roadmap-refresh.sh gap --strict BOARD.json PRS.json
```

For JSON output, stdout remains valid JSON even when strict validation fails. Standalone `census` and `dependencies` results place `validation` at their root. The full `{board,repo,dependencies}` result preserves subsystem validation and adds a top-level aggregate `validation` object used for the final exit decision. Human-readable warnings go to stderr. A strict validation exit occurs only after emitting the report; an operational failure may exit before a report exists.

Exit statuses have distinct meanings:

- `0`: the command completed; this includes warning-only normal-mode reports and strict reports with no errors;
- `1`: a usage, prerequisite, input-file, authentication, or whole-operation failure prevented the command from producing its promised report; and
- `2`: the command emitted a complete report but strict validation found audit violations.

A fail-soft full refresh may represent a repository or dependency subsystem failure inside an otherwise complete board report; normal mode then exits `0`, while strict mode exits `2`. A board fetch failure, missing registry file, invalid flag, or unreadable offline snapshot exits `1` because the promised report cannot be constructed.

The default full refresh remains fail-soft: a repository or dependency failure is reported while the board portion remains usable. In strict mode, the same failure also determines the final nonzero exit status.

Validation and report emission happen before persistence. When strict validation fails, the command skips both `--save` snapshot writes and `--update-changelog`, reports that persistence was skipped on stderr, and exits after emitting the diagnostic report. In normal mode, `--save` may persist an `UNKNOWN` placeholder; the next successful fetch is then an explicit `UNKNOWN`-to-live-state recovery rather than removal-and-readdition churn.

## Snapshot Compatibility

Board, release, and dependency snapshot naming remains unchanged. New PR snapshots use the enriched schema. PR diffs continue to key on PR number, so old normalized snapshots remain valid baselines.

The dependency diff treats a temporarily unreachable configured item as `UNKNOWN`, not removed. Registry removal is the only condition that produces a removed dependency.

New dependency records store `aiRefs` as positive integers. Historical snapshots may contain `"#NNN"` strings; readers accept both forms, the dependency diff does not treat this representation change as roadmap churn, and every human renderer adds exactly one `#` prefix.

## Testing

Retain `tests/wp-ai-roadmap-refresh-dependencies.sh` as a live end-to-end smoke test and update it to use strict mode. It continues to verify the exact approved dependency IDs and recomputed summaries, and it additionally requires successful validation with no `UNKNOWN` required items.

Add deterministic fixture tests covering:

- multi-page GraphQL PR pagination, duplicate PRs, total-count validation, and a closing-reference count above the 20-node bound;
- GraphQL bot typename, dependabot login, exact routine title prefixes, and routine near misses;
- authoritative closing references taking precedence over fallback links;
- every accepted fallback title, body, and branch form plus the documented near misses;
- dependabot bodies containing unrelated issue numbers;
- PR readiness diffs and the rule that activity-only updates are not readiness changes;
- all five coverage classifications;
- repository-plus-number joins, cross-repository number collisions, and legacy PR numbers defaulting to `WP_AI_REPO`;
- every validation invariant and deterministic diagnostic ordering;
- valid, malformed, and duplicate dependency registry records;
- reachable, optional-unreachable, required-retry-success, and required-retry-exhausted dependencies;
- normal warning-only behavior;
- `gap` warning-only versus strict exit behavior;
- exit statuses `0`, `1`, and `2`;
- strict nonzero behavior while stdout remains parseable JSON;
- strict failure suppressing `--save` and `--update-changelog`; and
- syntax, formatting, and executable file modes.

Tests use a temporary mock `gh` executable and `WP_AI_DEPS_FILE` rather than live mutation or project writes. Any fixture that reaches the main refresh path must create and export an isolated temporary `WP_AI_SNAP_DIR`, install a cleanup trap, and assert that the repository's real snapshot directory is unchanged. Only the existing dependency smoke test requires live GitHub reads.

## Documentation Updates

After implementation and verification:

- update `wordpress-ai-planned-work.md` with the enriched PR coverage model and corrected authoritative mappings;
- update `wordpress-ai-cross-repo-dependencies.md` to identify the registry as the watchlist source of truth and explain unknown/error behavior;
- update `wordpress-ai-roadmap.md` and `wordpress-ai-roadmap-refresh-prompt.md` where their refresh or coverage instructions change; and
- update `wordpress-ai-open-issues.md` only if corrected PR relationships change an issue dossier.

The documentation refresh must use current live data and preserve the uncommitted 2026-07-17 roadmap work already present in the checkout.

## Success Criteria

The change is successful when:

- routine dependency PRs no longer acquire false roadmap links from changelog text;
- authoritative GitHub issue relationships appear in the PR census;
- every open PR has a clear coverage classification;
- dependency membership is readable and reviewable without editing shell code;
- a failed dependency fetch cannot masquerade as a removed dependency;
- normal mode remains useful during partial upstream failure;
- strict mode reliably exposes blind spots for CI or manual audits;
- existing snapshots and commands continue to work; and
- the roadmap documents make in-flight work and extension-impacting dependencies faster to understand.
