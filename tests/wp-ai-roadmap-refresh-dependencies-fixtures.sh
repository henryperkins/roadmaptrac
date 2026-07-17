#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT_DIR/wp-ai-roadmap-dependencies.json"

[ -f "$REGISTRY" ] || {
  printf 'FAIL: dependency registry is missing\n' >&2
  exit 1
}

jq -e '
  .schemaVersion == 1
  and (.items | length == 16)
  and ([.items[].id] | unique | length == 16)
  and all(.items[];
    (.id | test("^[^/]+/[^#]+#[1-9][0-9]*$"))
    and (.theme | type == "string" and length > 0)
    and (.note | type == "string" and length > 0)
    and (.required | type == "boolean")
    and (.aiRefs | type == "array"
      and all(.[]; type == "number" and . > 0 and floor == .)
      and (unique | length) == length))
' "$REGISTRY" >/dev/null

printf 'dependency registry contract passed\n'
