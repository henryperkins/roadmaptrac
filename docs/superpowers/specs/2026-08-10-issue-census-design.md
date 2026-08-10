# Issue Census for Tracked Repositories

**Date:** 2026-08-10
**Status:** Approved design

## Goal

Close the coverage gap identified on 2026-08-10: the tracker censuses pull requests and releases for its tracked repositories but never their issues, and `WordPress/abilities-api` — the repository the roadmap itself calls "the strategic keystone" — is not censused at all.

At the time of writing that leaves **42 open pull requests and roughly 111 open issues** in WordPress-organization AI repositories outside the documents. This design brings four repositories to full coverage:

| Repository | Open PRs | Open issues | Coverage before | Coverage after |
|---|---:|---:|---|---|
| `WordPress/ai` | 36 | 50 | board + PR/release census + PR coverage audit | adds issue census + **issue coverage audit** |
| `WordPress/php-ai-client` | 26 | 35 | PRs + releases | adds issue census |
| `WordPress/mcp-adapter` | 19 | 46 | PRs + releases | adds issue census |
| `WordPress/abilities-api` | 14 | 8 | 5 curated watchlist items | full PR + issue + release census |

Everything else stays out of scope, explicitly: the three provider plugins, `php-mcp-schema`, `ai-provider-for-ollama` (dormant), `wp-ai-client` (archived), and whole-repository Gutenberg tracking.

## Non-goals

- Writing per-issue dossiers for upstream issues. Upstream issue coverage is **census-level**: structured records, counts, and diffs. The narrative dossier treatment in `wordpress-ai-open-issues.md` remains exclusive to `WordPress/ai` board issues.
- Importing upstream issues into Project #240, or applying Project #240 coverage rules to any repository other than the primary one.
- Replacing the curated dependency watchlist. The watchlist and the census answer different questions and deliberately overlap (see *Watchlist overlap*).
- Tracking closed issues. The census enumerates open issues only, exactly as the PR census enumerates open PRs; a closed issue leaves the census as a disappearance.
- Rewriting the Bash and jq implementation in another language.

## Architecture

The issue census is a third peer of the existing PR and release censuses inside `wp-ai-roadmap-refresh.sh`. It reuses the established shapes rather than inventing new ones: a paginated GraphQL query, a normalizing jq program producing `{items, validation}`, a diff jq program keyed on issue number, an independent snapshot prefix, and deterministic validation records.

One data change accompanies it: `wp-ai-roadmap-repositories.json` gains `WordPress/abilities-api`. That is the registry working as designed — adding a censused repository is a reviewable data change, not a shell edit.

## Issue Census

A paginated GraphQL query over `repository.issues(states: OPEN)` captures, per issue:

- number, title, URL, state, and creation/update timestamps;
- milestone title;
- labels (`first: 20`) and assignee logins (`first: 10`);
- author login and `__typename`; and
- comment `totalCount`.

Normalization produces records shaped like the board's own normalized items so the two can be joined without translation:

```json
{
  "id": "WordPress/mcp-adapter#245",
  "repo": "WordPress/mcp-adapter",
  "number": 245,
  "title": "Normalize _meta and annotations on every emitted DTO",
  "url": "https://github.com/WordPress/mcp-adapter/issues/245",
  "state": "OPEN",
  "milestone": null,
  "labels": ["bug"],
  "assignees": ["galatanovidiu"],
  "author": "galatanovidiu",
  "isBot": false,
  "comments": 3,
  "createdAt": "2026-07-24T09:11:02Z",
  "updatedAt": "2026-08-05T12:21:30Z"
}
```

The census enforces the same completeness invariants the PR census already does, with issue-specific codes:

- `issue-pagination-incomplete` when the final page still reports `hasNextPage`;
- `issue-duplicate` when a number appears on more than one page; and
- `issue-total-mismatch` when `issues.totalCount` does not equal the number of unique normalized nodes.

Labels and assignees are bounded connections. Unlike `closingIssuesReferences`, exceeding the bound is not a correctness problem for any consumer in this design, so truncation is recorded as an `issue-connection-truncated` **warning**, not an error.

### Fail-soft independence

The existing entry builder treats the PR census and release census as all-or-nothing: if either fails, the whole repository entry becomes `available: false`. The issue census must **not** join that contract, because an issue-fetch hiccup would then blank PR data that fetched successfully — a robustness regression.

Instead each entry carries an independent `issues_available` Boolean. A failed issue fetch yields `open_issues: []`, `issues_available: false`, and an `issue-census-unavailable` error scoped to that repository, while `available`, `open_prs`, and `releases` are unaffected. `available: false` implies `issues_available: false`.

## Issue Diff Contract

`issuediff BASE.json CUR.json` is the issue-side peer of `prdiff`, keyed on issue number:

- `newly_opened` — present in current, absent from baseline;
- `no_longer_open` — present in baseline, absent from current (closed, transferred, or deleted); and
- `changed` — a record per issue whose `milestone`, `title`, `labels`, or `assignees` differ.

`labels` and `assignees` are compared as **sets**, so reordering is not a change. As in `PRDIFF_JQ`, a field is compared only when it exists in both records, so older snapshots cannot generate schema-migration noise, and an `updatedAt` change alone is never a `changed` record.

## Board Issue Coverage

The PR census already answers "is this pull request visible on Project #240?" through five classifications. The issue census makes the same question askable of issues, and the answer today is the tracker's strongest single claim: **all 50 open `WordPress/ai` issues are carded.** Nothing currently proves that on each run; a human checked it by hand.

A new join produces `repo.issue_gap`, computed **only for the primary repository**:

```json
{
  "repo": "WordPress/ai",
  "open_total": 50,
  "carded": 50,
  "uncarded": [],
  "validation": {"ok": true, "errors": [], "warnings": []}
}
```

Open repository issues are joined to board issue cards by canonical `repository#number`, the same key the PR coverage join uses. Every open issue with no board card produces an `issue-roadmap-coverage-missing` **error**, so a `--strict` run exits `2` — consistent with how an uncarded substantive PR is treated today, and making "the board sees every open issue in the primary repository" an enforced invariant rather than an observation.

This rule is exclusive to `WP_AI_REPO`. Upstream repositories are censused without any Project #240 expectation, and their entries never contribute coverage diagnostics. That restriction is the same one the PR audit already honors and is load-bearing: php-ai-client, mcp-adapter, and abilities-api issues are not roadmap cards and must never be reported as missing ones.

There is no waiver or allowlist mechanism, matching the PR audit's deliberate absence of one.

## Snapshots

Issue snapshots use the prefix `issues-<owner>-<name>-<UTC timestamp>.json` and hold the normalized item array, exactly as PR snapshots do. Baselines remain per-prefix and independent, so an issue baseline can exist before a repository has a PR baseline or vice versa.

`--save` therefore writes **14** files where it previously wrote 8:

| Prefix | Count | Change |
|---|---:|---|
| `proj240-*` | 1 | — |
| `prs-<slug>-*` | 4 | was 3 |
| `releases-<slug>-*` | 4 | was 3 |
| `issues-<slug>-*` | 4 | new |
| `wordpress-ai-cross-repo-dependencies-*` | 1 | — |

An unavailable issue census skips only its own snapshot, leaving the previous issue baseline intact — the same protection the dependency snapshot already has against an invalid registry. Writing an empty array over a good baseline would silently report every issue as closed on the next run.

## Watchlist overlap

`WordPress/abilities-api` will now appear in both the dependency watchlist (5 curated items) and the repository census (8 open issues, 14 open PRs). This overlap is intentional and the two must not be summed:

- the **watchlist** carries curation the census cannot derive — `theme`, `aiRefs` mapping each item to the WordPress AI issues it affects, a `note`, and `required` — and tracks items through closure (3 of its 5 abilities-api items are CLOSED);
- the **census** tracks the live open set with no curation and no memory of closed work.

Two watchlist items (`#38`, `#84`) are open issues and so appear in both. Documentation must state the overlap wherever both numbers appear.

## Validation Invariants

The issue census and coverage join enforce:

- GraphQL `issues.totalCount` equals the number of unique normalized issue nodes across all pages;
- every normalized issue number is unique;
- `issue_gap.carded + (issue_gap.uncarded | length)` equals `issue_gap.open_total`;
- coverage errors identify exactly the open primary-repository issues with no board card;
- no repository other than `WP_AI_REPO` contributes an `issue-roadmap-coverage-missing` diagnostic; and
- an entry with `issues_available: false` reports exactly one `issue-census-unavailable` error and an empty `open_issues` array.

All existing invariants carry forward unchanged. Every new `validation` object obeys the established rules: `ok` is true if and only if `errors` is empty, every diagnostic has a stable `code`, human-readable `message`, and structured `context`, and repeated inputs order diagnostics deterministically by code and context.

## CLI Behavior

New and changed surfaces:

```bash
./wp-ai-roadmap-refresh.sh issuediff A.json B.json   # offline issue diff (new)
./wp-ai-roadmap-refresh.sh census                    # entries gain open_issues + issues_available
./wp-ai-roadmap-refresh.sh census --strict           # adds issue completeness validation
./wp-ai-roadmap-refresh.sh --strict --json           # adds issue coverage to the audit
```

Exit-status meanings are unchanged: `0` completed, `1` an operational failure prevented the report, `2` a complete report contains strict violations. `--no-repo` continues to skip the repository censuses, issues included. No new flag is introduced; the issue census is not independently switchable, because a partially censused repository is exactly the ambiguity this change exists to remove.

`census --strict` validates issue fetch completeness and schema but applies no coverage rule, mirroring how it already treats PRs — coverage requires a board snapshot, which the standalone census does not fetch.

## Rendering

The Markdown repository table gains an **Open issues** column and an issue-change summary column, and a new section lists issue movement per repository (newly opened, no longer open, and changed, with the changed fields named). The JSON report gains `open_issues`, `issues_available`, and `issue_diff` per repository entry, plus `repo.issue_gap` for the primary repository.

The human report continues to lead with what changed, then what is underway, then what is uncovered.

## Testing

Add `tests/wp-ai-roadmap-refresh-issues.sh` with fixtures covering:

- multi-page issue pagination, duplicate issue numbers, and total-count mismatch;
- label/assignee connection truncation producing a warning, not an error;
- the diff contract: newly opened, no longer open, milestone change, title change, label set change, assignee set change, label reordering producing **no** change, and an `updatedAt`-only bump producing no change;
- schema-migration silence when a field is absent from one side;
- issue coverage classification against a board fixture, including a cross-repository number collision that must not be read as coverage;
- strict exit `2` for an uncarded open primary-repository issue, and exit `0` when an upstream repository has uncarded issues;
- fail-soft independence: a failing issue fetch leaves `open_prs` populated, sets `issues_available: false`, and emits exactly one `issue-census-unavailable` error; and
- an unavailable issue census skipping its snapshot while leaving the prior baseline in place.

Update `tests/wp-ai-roadmap-refresh-repositories.sh` for the four-repository membership. Every fixture reaching the main path exports a temporary `WP_AI_SNAP_DIR` and asserts the real snapshot directory is unchanged.

The offline suite grows from seven files to eight. The live dependency smoke test is unchanged.

## Documentation Updates

After implementation and verification:

- `wordpress-ai-cross-repo-dependencies.md` — the Repository Radar gains an `abilities-api` row and open-issue columns, plus a note that watchlist and census counts overlap and must not be summed;
- `wordpress-ai-roadmap.md` — the §1 full-repository-census row gains issue counts and the fourth repository;
- `wordpress-ai-planned-work.md` — the radar table gains the same, and the data-quality flags gain the watchlist/census overlap caveat;
- `wordpress-ai-open-issues.md` — unchanged in structure; upstream issues are census-only and get no dossiers;
- `CLAUDE.md` — snapshot count 8 → 14, the new `issuediff` subcommand, the new test file, and the tracked-repository list; and
- `wordpress-ai-roadmap-refresh-prompt.md` — the verification checklist gains per-repository open-issue totals and the issue coverage check.

## Success Criteria

The change is successful when:

- all four repositories report open PRs, open issues, and releases from one command;
- `abilities-api` movement is visible without hand-querying GitHub;
- an uncarded open `WordPress/ai` issue fails the strict audit, and the current state passes it;
- no upstream repository can produce a Project #240 coverage diagnostic;
- an issue-fetch failure degrades to a warning-bearing partial entry rather than blanking PR data or corrupting an issue baseline;
- issue snapshots diff cleanly against baselines written before this change existed (there are none, so the first run establishes them without reporting spurious churn); and
- the documents state upstream issue counts that a reader can reproduce from the report.
