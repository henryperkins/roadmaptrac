#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BOARD="$ROOT_DIR/tests/fixtures/board-pr-coverage.json"
PRS="$ROOT_DIR/tests/fixtures/prs-pr-coverage.json"

set +e
normal="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" gap "$BOARD" "$PRS")"
normal_status=$?
strict="$("$ROOT_DIR/wp-ai-roadmap-refresh.sh" gap --strict "$BOARD" "$PRS")"
strict_status=$?
set -e

[ "$normal_status" -eq 0 ]
[ "$strict_status" -eq 2 ]
jq -e '
  .open_total==6
  and .classification_counts=={
    "direct-board-pr":1,
    "linked-board-issue":2,
    "routine":1,
    "linked-off-board-issue":1,
    "unexplained":1
  }
  and ([.classifications["linked-off-board-issue"][].number] == [203])
  and ([.classifications.unexplained[].number] == [204])
  and ([.classifications["linked-board-issue"][]|select(.number==205)]
    | .[0].issueLinks[0].repo=="WordPress/ai"
      and .[0].issueLinks[0].source=="legacy")
  and (.tracked_open + (.untracked|length) == .open_total)
  and (.routine_count + (.substantive|length) == (.untracked|length))
  and (
    [.classifications[][].number] | sort
    == ([200,201,202,203,204,205] | sort)
  )
  and ((.classification_counts | [.[]] | add) == .open_total)
  and (.validation.ok|not)
  and ((.validation.errors|length)>0)
  and ([.validation.errors[].context.number] | sort == [203,204])
' <<<"$normal" >/dev/null

diff -u <(jq -S . <<<"$normal") <(jq -S . <<<"$strict")

printf 'PR coverage fixture tests passed\n'
