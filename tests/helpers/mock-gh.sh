#!/usr/bin/env bash
set -euo pipefail

state_dir="${WP_AI_TEST_STATE_DIR:?}"
mode="${WP_AI_TEST_DEP_MODE:-all-ok}"
mkdir -p "$state_dir"

if [ "${1:-}" = api ] && [ "${2:-}" = graphql ] \
  && [[ "$*" == *pullRequests* ]]; then
  cat "${WP_AI_TEST_PR_PAGES:?}"
  exit 0
fi

if [ "${1:-}" = release ] && [ "${2:-}" = list ]; then
  if [ -n "${WP_AI_TEST_RELEASES:-}" ]; then
    cat "$WP_AI_TEST_RELEASES"
  else
    printf '[]\n'
  fi
  exit 0
fi

if [ "${1:-}" = api ] && [[ "${2:-}" == repos/*/issues/* ]]; then
  endpoint="$2"
  number="${endpoint##*/}"
  counter="$state_dir/${endpoint//\//_}.count"
  attempts=0
  [ ! -f "$counter" ] || attempts="$(<"$counter")"
  attempts=$((attempts + 1))
  printf '%s\n' "$attempts" > "$counter"

  case "$mode:$number:$attempts" in
    required-fail-once:1:1|required-fail:1:*|optional-fail:2:*)
      printf 'mock dependency failure for %s\n' "$endpoint" >&2
      exit 1
      ;;
  esac

  printf '{"number":%s,"title":"Dependency %s","state":"open","updated_at":"2026-07-17T00:00:00Z","labels":[],"html_url":"https://github.com/Example/deps/issues/%s","milestone":null}\n' \
    "$number" "$number" "$number"
  exit 0
fi

printf 'unexpected mock gh invocation: %s\n' "$*" >&2
exit 1
