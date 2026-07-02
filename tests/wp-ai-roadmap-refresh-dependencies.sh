#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

json="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" dependencies --json)"

jq -e '
  type == "object"
  and (.summary.total >= 16)
  and (.summary.by_repo["WordPress/gutenberg"] >= 1)
  and (.summary.by_repo["WordPress/abilities-api"] >= 1)
  and ([ .items[] | select(.id == "WordPress/gutenberg#70710") ] | length == 1)
  and ([ .items[] | select(.id == "WordPress/abilities-api#84") ] | length == 1)
' <<<"$json" >/dev/null

printf 'dependency smoke test passed\n'
