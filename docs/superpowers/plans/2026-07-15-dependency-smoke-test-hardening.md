# Dependency Smoke-Test Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the live dependency smoke test reject incomplete or inconsistent dependency JSON and support direct execution.

**Architecture:** Keep the existing one-file Bash smoke test and replace its lower-bound checks with a strict `jq` contract. The contract compares the returned IDs with the curated watchlist and independently derives all summary counts from `.items`; the Git executable bit supplies direct invocation.

**Tech Stack:** Bash, jq, Git, GitHub CLI through `wp-ai-roadmap-refresh.sh`

## Global Constraints

- Preserve the test's live end-to-end call to `wp-ai-roadmap-refresh.sh dependencies --json`.
- Require exactly the 16 dependency IDs approved in the design.
- Require `summary.total`, `summary.by_repo`, and `summary.by_state` to equal values derived from `.items`.
- Keep `set -euo pipefail` and `jq -e` failure behavior.
- Track `tests/wp-ai-roadmap-refresh-dependencies.sh` as mode `100755`.

---

## File Structure

- Modify `tests/wp-ai-roadmap-refresh-dependencies.sh`: fetch live dependency JSON, validate its complete contract, and report success.
- Retain `docs/superpowers/specs/2026-07-15-dependency-smoke-test-hardening-design.md`: approved design rationale.
- Add `docs/superpowers/plans/2026-07-15-dependency-smoke-test-hardening.md`: implementation and verification record.

### Task 1: Harden and Publish the Dependency Smoke Test

**Files:**
- Modify: `tests/wp-ai-roadmap-refresh-dependencies.sh:8-15`
- Modify mode: `tests/wp-ai-roadmap-refresh-dependencies.sh` from `100644` to `100755`
- Test: `tests/wp-ai-roadmap-refresh-dependencies.sh`

**Interfaces:**
- Consumes: JSON emitted by `wp-ai-roadmap-refresh.sh dependencies --json` with top-level `items` and `summary` fields.
- Produces: exit status `0` plus `dependency smoke test passed` only for the exact dependency set with coherent summary counts; nonzero otherwise.

- [ ] **Step 1: Reproduce both defects before editing**

Run:

```bash
./tests/wp-ai-roadmap-refresh-dependencies.sh
```

Expected: exit `126` with `Permission denied`.

Run this negative contract test against the current predicate:

```bash
if jq -n -e '
  {
    summary: {
      total: 16,
      by_repo: {
        "WordPress/gutenberg": 1,
        "WordPress/abilities-api": 1
      },
      by_state: {OPEN: 2}
    },
    items: [
      {id: "WordPress/gutenberg#70710", repo: "WordPress/gutenberg", state: "OPEN"},
      {id: "WordPress/abilities-api#84", repo: "WordPress/abilities-api", state: "OPEN"}
    ]
  }
  | (type == "object"
     and (.summary.total >= 16)
     and (.summary.by_repo["WordPress/gutenberg"] >= 1)
     and (.summary.by_repo["WordPress/abilities-api"] >= 1)
     and ([ .items[] | select(.id == "WordPress/gutenberg#70710") ] | length == 1)
     and ([ .items[] | select(.id == "WordPress/abilities-api#84") ] | length == 1))
' >/dev/null; then
  printf 'RED: malformed dependency payload was accepted\n' >&2
  exit 1
fi
```

Expected: exit `1` with `RED: malformed dependency payload was accepted`, proving the old predicate accepts a payload containing only two items.

- [ ] **Step 2: Replace the lower-bound predicate with the strict contract**

Replace the `jq -e` invocation with:

```bash
jq -e '
  [
    "WordPress/gutenberg#70710",
    "WordPress/gutenberg#74234",
    "WordPress/gutenberg#77230",
    "WordPress/gutenberg#77643",
    "WordPress/gutenberg#75221",
    "WordPress/gutenberg#72734",
    "WordPress/gutenberg#73771",
    "WordPress/gutenberg#77994",
    "WordPress/gutenberg#74572",
    "WordPress/gutenberg#16549",
    "WordPress/gutenberg#77816",
    "WordPress/abilities-api#38",
    "WordPress/abilities-api#62",
    "WordPress/abilities-api#84",
    "WordPress/abilities-api#105",
    "WordPress/abilities-api#106"
  ] as $expected_ids
  | .items as $items
  | ($items | map(.id) | sort) as $actual_ids
  | ($items | reduce .[] as $item
      ({}; .[$item.repo] = ((.[$item.repo] // 0) + 1))) as $by_repo
  | ($items | reduce .[] as $item
      ({}; .[$item.state] = ((.[$item.state] // 0) + 1))) as $by_state
  | type == "object"
    and ($actual_ids == ($expected_ids | sort))
    and (.summary.total == ($items | length))
    and (.summary.by_repo == $by_repo)
    and (.summary.by_state == $by_state)
' <<<"$json" >/dev/null
```

This array equality rejects missing, duplicate, and unexpected IDs. The two reductions reject stale or fabricated repository and state totals.

- [ ] **Step 3: Set the executable bit**

Run:

```bash
chmod +x tests/wp-ai-roadmap-refresh-dependencies.sh
```

Expected: `git diff --summary` reports mode `100644 => 100755`.

- [ ] **Step 4: Verify the malformed payload is rejected by the new contract**

Run:

```bash
if jq -n -e '
  {
    summary: {
      total: 16,
      by_repo: {
        "WordPress/gutenberg": 1,
        "WordPress/abilities-api": 1
      },
      by_state: {OPEN: 2}
    },
    items: [
      {id: "WordPress/gutenberg#70710", repo: "WordPress/gutenberg", state: "OPEN"},
      {id: "WordPress/abilities-api#84", repo: "WordPress/abilities-api", state: "OPEN"}
    ]
  }
  | [
      "WordPress/gutenberg#70710",
      "WordPress/gutenberg#74234",
      "WordPress/gutenberg#77230",
      "WordPress/gutenberg#77643",
      "WordPress/gutenberg#75221",
      "WordPress/gutenberg#72734",
      "WordPress/gutenberg#73771",
      "WordPress/gutenberg#77994",
      "WordPress/gutenberg#74572",
      "WordPress/gutenberg#16549",
      "WordPress/gutenberg#77816",
      "WordPress/abilities-api#38",
      "WordPress/abilities-api#62",
      "WordPress/abilities-api#84",
      "WordPress/abilities-api#105",
      "WordPress/abilities-api#106"
    ] as $expected_ids
  | .items as $items
  | ($items | map(.id) | sort) as $actual_ids
  | ($items | reduce .[] as $item
      ({}; .[$item.repo] = ((.[$item.repo] // 0) + 1))) as $by_repo
  | ($items | reduce .[] as $item
      ({}; .[$item.state] = ((.[$item.state] // 0) + 1))) as $by_state
  | type == "object"
    and ($actual_ids == ($expected_ids | sort))
    and (.summary.total == ($items | length))
    and (.summary.by_repo == $by_repo)
    and (.summary.by_state == $by_state)
' >/dev/null; then
  printf 'FAIL: malformed dependency payload was accepted\n' >&2
  exit 1
else
  printf 'malformed dependency payload rejected\n'
fi
```

Expected: the shell exits `0` and prints `malformed dependency payload rejected`; the nested `jq` exits `1` because the two actual IDs do not equal the 16 expected IDs and `summary.total` does not equal the two-item array length.

- [ ] **Step 5: Verify syntax, live behavior, mode, and scope**

Run:

```bash
bash -n tests/wp-ai-roadmap-refresh-dependencies.sh
./tests/wp-ai-roadmap-refresh-dependencies.sh
git ls-files -s tests/wp-ai-roadmap-refresh-dependencies.sh
git diff --check
git status -sb
git diff -- tests/wp-ai-roadmap-refresh-dependencies.sh docs/superpowers/plans/2026-07-15-dependency-smoke-test-hardening.md
```

Expected:

- `bash -n` exits `0` without output.
- The direct smoke test exits `0` and prints `dependency smoke test passed` without warnings.
- `git ls-files -s` reports mode `100755` after staging in Step 6; before staging, `git diff --summary` reports the pending mode change.
- `git diff --check` exits `0`.
- Only the implementation plan and dependency smoke-test changes are uncommitted.

- [ ] **Step 6: Commit the implementation**

Run:

```bash
git add docs/superpowers/plans/2026-07-15-dependency-smoke-test-hardening.md tests/wp-ai-roadmap-refresh-dependencies.sh
git diff --cached --check
git diff --cached --stat
git commit -m "Harden dependency smoke test"
```

Expected: one commit containing the strict JSON contract, executable mode change, and this implementation plan.

- [ ] **Step 7: Re-run verification on the committed tree**

Run:

```bash
bash -n tests/wp-ai-roadmap-refresh-dependencies.sh
./tests/wp-ai-roadmap-refresh-dependencies.sh
git status -sb
```

Expected: both checks exit `0`; the smoke test prints `dependency smoke test passed`; the branch is clean and two commits ahead of `origin/main`.
