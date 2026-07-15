#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

json="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --json)"

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

printf 'dependency smoke test passed\n'
