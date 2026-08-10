#!/usr/bin/env bash
set -euo pipefail

state_dir="${WP_AI_TEST_STATE_DIR:?}"
mode="${WP_AI_TEST_DEP_MODE:-all-ok}"
mkdir -p "$state_dir"

if [ "${1:-}" = api ] && [ "${2:-}" = graphql ] \
  && [[ "$*" == *projectV2* ]]; then
  cat "${WP_AI_TEST_BOARD_PAGES:?}"
  exit 0
fi

if [ "${1:-}" = api ] && [ "${2:-}" = graphql ] \
  && [[ "$*" == *pullRequests* ]]; then
  if [ -n "${WP_AI_TEST_PR_PAGES_DIR:-}" ]; then
    owner=""
    name=""
    previous=""
    for argument in "$@"; do
      if [ "$previous" = "-F" ]; then
        case "$argument" in
          owner=*) owner="${argument#owner=}" ;;
          name=*) name="${argument#name=}" ;;
        esac
      fi
      previous="$argument"
    done
    cat "$WP_AI_TEST_PR_PAGES_DIR/$owner-$name.jsonl"
  elif [ -n "${WP_AI_TEST_PR_PAGES_RETRY:-}" ]; then
    # Serve the cold-query fixture once, then the settled one, so a test can
    # exercise the mergeStateStatus:UNKNOWN retry.
    counter="$state_dir/pr-pages.count"
    attempts=0
    [ ! -f "$counter" ] || attempts="$(<"$counter")"
    attempts=$((attempts + 1))
    printf '%s\n' "$attempts" > "$counter"
    if [ "$attempts" -eq 1 ]; then
      cat "${WP_AI_TEST_PR_PAGES:?}"
    else
      cat "$WP_AI_TEST_PR_PAGES_RETRY"
    fi
  else
    cat "${WP_AI_TEST_PR_PAGES:?}"
  fi
  exit 0
fi

# Must come after the pullRequests branch: the PR query carries
# `closingIssuesReferences(`, which does not contain the lowercase `issues(`
# marker, so the two selectors stay disjoint.
if [ "${1:-}" = api ] && [ "${2:-}" = graphql ] \
  && [[ "$*" == *"issues("* ]]; then
  if [ -n "${WP_AI_TEST_ISSUE_FAIL:-}" ]; then
    printf 'mock issue census failure\n' >&2
    exit 1
  fi
  if [ -n "${WP_AI_TEST_ISSUE_PAGES_DIR:-}" ]; then
    owner=""
    name=""
    previous=""
    for argument in "$@"; do
      if [ "$previous" = "-F" ]; then
        case "$argument" in
          owner=*) owner="${argument#owner=}" ;;
          name=*) name="${argument#name=}" ;;
        esac
      fi
      previous="$argument"
    done
    cat "$WP_AI_TEST_ISSUE_PAGES_DIR/$owner-$name.jsonl"
  elif [ -n "${WP_AI_TEST_ISSUE_PAGES:-}" ]; then
    cat "$WP_AI_TEST_ISSUE_PAGES"
  else
    # Default: an empty but well-formed census, so suites that predate the
    # issue census keep passing without carrying issue fixtures.
    printf '{"data":{"repository":{"issues":{"totalCount":0,"pageInfo":{"hasNextPage":false,"endCursor":null},"nodes":[]}}}}\n'
  fi
  exit 0
fi

if [ "${1:-}" = release ] && [ "${2:-}" = list ]; then
  if [ -n "${WP_AI_TEST_RELEASES_DIR:-}" ]; then
    repo=""
    previous=""
    for argument in "$@"; do
      if [ "$previous" = "--repo" ]; then repo="$argument"; fi
      previous="$argument"
    done
    cat "$WP_AI_TEST_RELEASES_DIR/${repo//\//-}.json"
  elif [ -n "${WP_AI_TEST_RELEASES:-}" ]; then
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
