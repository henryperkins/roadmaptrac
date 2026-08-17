#!/usr/bin/env bash
#
# wp-ai-roadmap-refresh.sh — re-pull the WordPress AI Planning & Roadmap board
# (GitHub org project #240) and report what changed since the last snapshot.
#
# Companion to wordpress-ai-roadmap.md / -open-issues.md / -planned-work.md.
#
# Also runs repository-level censuses (open PRs + releases) so drift the board
# doesn't track — open PRs not on the board, new releases — is surfaced.
#
# USAGE
#   ./wp-ai-roadmap-refresh.sh                 # fetch live, diff vs latest snapshot, print report
#                                              #   (board + repo PR/release census; first run: establishes baselines)
#   ./wp-ai-roadmap-refresh.sh --save          # ...and persist the new snapshots (board + repo) as the next baseline
#   ./wp-ai-roadmap-refresh.sh --update-changelog  # ...and append a dated row to the planned-work doc
#   ./wp-ai-roadmap-refresh.sh --strict        # read-only audit: exit 2 (after the report) on any
#                                              #   validation error; suppresses --save/--update-changelog
#   ./wp-ai-roadmap-refresh.sh --no-repo       # board only — skip all repository PR/release censuses
#   ./wp-ai-roadmap-refresh.sh --no-deps       # skip the Gutenberg / abilities-api dependency watchlist
#   ./wp-ai-roadmap-refresh.sh --markdown      # report as Markdown (default is the same, terminal-friendly)
#   ./wp-ai-roadmap-refresh.sh --json          # emit JSON ({board,repo,repositories,dependencies,validation};
#                                              #   --no-repo/--no-deps drop their keys, validation always present)
#   ./wp-ai-roadmap-refresh.sh --baseline F    # diff live against snapshot file F instead of the latest
#   ./wp-ai-roadmap-refresh.sh fetch           # print a normalized board snapshot to stdout
#   ./wp-ai-roadmap-refresh.sh census          # print the primary repo census plus all tracked repositories
#   ./wp-ai-roadmap-refresh.sh census --strict # exit 2 if any tracked PR fetch is incomplete or malformed
#   ./wp-ai-roadmap-refresh.sh dependencies    # print the Gutenberg / abilities-api dependency watchlist
#   ./wp-ai-roadmap-refresh.sh dependencies --json
#   ./wp-ai-roadmap-refresh.sh dependencies --strict --json   # exit 2 if a required dependency is UNKNOWN
#   ./wp-ai-roadmap-refresh.sh diff A.json B.json      # diff two board snapshots (offline; for testing)
#   ./wp-ai-roadmap-refresh.sh gap B.json P.json       # board<->repo PR gap from board + prs snapshots (offline)
#   ./wp-ai-roadmap-refresh.sh prdiff A.json B.json    # diff two prs snapshots (offline)
#   ./wp-ai-roadmap-refresh.sh reldiff A.json B.json   # diff two releases snapshots (offline)
#   ./wp-ai-roadmap-refresh.sh issuediff A.json B.json # diff two issues snapshots (offline)
#   ./wp-ai-roadmap-refresh.sh -h
#
# REQUIREMENTS
#   gh (authenticated) and jq. The board query needs the `read:project` scope;
#   repository censuses (GraphQL PR reads + release list) need normal `repo` read.
#     Grant project scope once with:  gh auth refresh -h github.com -s read:project
#
# ENV OVERRIDES
#   WP_AI_ORG (default WordPress)  WP_AI_PROJECT (default 240)
#   WP_AI_REPO (default WordPress/ai; primary repo for the PR/release census)
#   WP_AI_REPOS_FILE (default <script dir>/wp-ai-roadmap-repositories.json;
#                     additional full-repository PR/release census registry)
#   WP_AI_SNAP_DIR (default <script dir>/.wp-ai-roadmap-snapshots)
#   WP_AI_DOC_DIR  (default <script dir>; where the *.md docs live)
#   WP_AI_DEPS_SLUG (default wordpress-ai-cross-repo-dependencies; snapshot filename prefix)
#   WP_AI_DEPS_FILE (default <script dir>/wp-ai-roadmap-dependencies.json; dependency registry)
#
set -euo pipefail

# ----------------------------- config ---------------------------------------
ORG="${WP_AI_ORG:-WordPress}"
PROJECT="${WP_AI_PROJECT:-240}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SNAP_DIR="${WP_AI_SNAP_DIR:-$SCRIPT_DIR/.wp-ai-roadmap-snapshots}"
DOC_DIR="${WP_AI_DOC_DIR:-$SCRIPT_DIR}"
PLANNED_DOC="$DOC_DIR/wordpress-ai-planned-work.md"
REPO="${WP_AI_REPO:-WordPress/ai}"     # primary repo for the PR/release census
REPO_SLUG="${REPO//\//-}"              # WordPress/ai -> WordPress-ai (used in snapshot filenames)
REPOS_FILE="${WP_AI_REPOS_FILE:-$SCRIPT_DIR/wp-ai-roadmap-repositories.json}"
DEPS_SLUG="${WP_AI_DEPS_SLUG:-wordpress-ai-cross-repo-dependencies}"
DEPS_FILE="${WP_AI_DEPS_FILE:-$SCRIPT_DIR/wp-ai-roadmap-dependencies.json}"
STRICT=0

SAVE=0
UPDATE_CHANGELOG=0
OUT_MODE=text          # text | markdown | json
BASELINE_OVERRIDE=""
DO_REPO=1              # all repository PR/release censuses run by default
DO_DEPS=1              # cross-repo dependency watchlist runs by default; --no-deps disables it

# ----------------------------- helpers --------------------------------------
die() { printf 'error: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "'$1' not found in PATH"; }

# Read jq output line-by-line through this, never plain `jq`. The native
# Windows jq.exe opens stdout in text mode, so every LF it writes becomes CRLF;
# `while IFS= read -r x` then strips the \n and keeps the \r, silently leaving a
# control character on the end of every value. That tainted repository slugs
# used as gh arguments and snapshot filenames (`-F name=ai$'\r'`,
# `prs-WordPress-ai$'\r'-current.json`), so census/--save/--strict failed on
# Windows while passing on Linux. Deleting CRs is safe for these callers: they
# read raw slugs and compact JSON, and jq escapes any real CR inside a string as
# \r rather than emitting a bare one. No-op where jq already writes LF.
# `jq -b` also fixes this at the source, but is not relied on here because the
# flag's availability varies by jq build. See tests/wp-ai-roadmap-refresh-crlf.sh.
jq_lines() { jq "$@" | tr -d '\r'; }

usage() { awk 'NR==1{next} /^#/{sub(/^# ?/,"");print;next} {exit}' "$0"; exit 0; }

# GraphQL query: paginated full board (same shape as the doc's §10 recipe).
GQL_QUERY='query($org: String!, $number: Int!, $endCursor: String) {
  organization(login: $org) {
    projectV2(number: $number) {
      items(first: 100, after: $endCursor) {
        totalCount pageInfo { hasNextPage endCursor }
        nodes {
          fieldValues(first: 25) { nodes {
            ... on ProjectV2ItemFieldSingleSelectValue { name field { ... on ProjectV2FieldCommon { name } } } } }
          content {
            __typename
            ... on Issue { number title url state repository { nameWithOwner }
              milestone { title } assignees(first: 10){ nodes { login } } updatedAt }
            ... on PullRequest { number title url state isDraft repository { nameWithOwner }
              milestone { title } assignees(first: 10){ nodes { login } } updatedAt mergedAt }
            ... on DraftIssue { title } } } } } } }'

# Normalize concatenated GraphQL pages -> a single sorted array keyed by stable id.
NORMALIZE_JQ='
  [ .[].data.organization.projectV2.items.nodes[] ]
  | map({
      id: ((.content.repository.nameWithOwner // "draft") + "#" + ((.content.number // .content.title) | tostring)),
      type: (.content.__typename // "Unknown"),
      number: .content.number,
      title: (.content.title // "(untitled)"),
      url: .content.url,
      repo: .content.repository.nameWithOwner,
      state: .content.state,
      mergedAt: .content.mergedAt,
      milestone: .content.milestone.title,
      updatedAt: .content.updatedAt,
      status: ([ .fieldValues.nodes[]? | select(.field.name == "Status") | .name ] | first),
      assignees: [ .content.assignees.nodes[]?.login ]
    })
  | sort_by(.id)'

# Diff two normalized arrays ($base[0] vs $cur[0]) -> structured diff JSON.
DIFF_JQ='
  def byid: reduce .[] as $x ({}; .[$x.id] = $x);
  ($base[0] | byid) as $B
  | ($cur[0]  | byid) as $C
  | ($C | keys) as $ck
  | ($B | keys) as $bk
  | {
      meta: { base_label: $bl, cur_label: $cl,
              base_count: ($base[0] | length), cur_count: ($cur[0] | length) },
      added: [ $ck[] | select($B[.] == null) | $C[.]
               | {id, type, title, status, milestone, url} ],
      removed: [ $bk[] | select($C[.] == null) | $B[.]
                 | {id, type, title, status, milestone} ],
      newly_done: [ $ck[] | select($B[.] != null and ($B[.].status != "Done") and ($C[.].status == "Done"))
                    | {id:., type:$C[.].type, title:$C[.].title, milestone:$C[.].milestone} ],
      newly_merged: [ $ck[] | select($B[.] != null and $C[.].type == "PullRequest"
                                      and ($B[.].mergedAt == null) and ($C[.].mergedAt != null))
                      | {id:., title:$C[.].title} ],
      status_changed: [ $ck[] | select($B[.] != null and ($B[.].status != $C[.].status)
                                        and (($C[.].status == "Done") | not))
                        | {id:., type:$C[.].type, title:$C[.].title,
                           from:($B[.].status // "—"), to:($C[.].status // "—")} ],
      milestone_changed: [ $ck[] | select($B[.] != null and (($B[.].milestone // "") != ($C[.].milestone // "")))
                           | {id:., title:$C[.].title,
                              from:($B[.].milestone // "—"), to:($C[.].milestone // "—")} ],
      state_changed: [ $ck[] | select($B[.] != null and ($B[.].state != $C[.].state))
                       | {id:., title:$C[.].title, from:($B[.].state // "—"), to:($C[.].state // "—")} ]
    }'

# Render a diff JSON (stdin) -> human/Markdown report.
RENDER_JQ='
  def fmt(a; f): [ a[] | f ] | join("\n");
  def total: (.added|length)+(.newly_done|length)+(.newly_merged|length)
             +(.status_changed|length)+(.milestone_changed|length)+(.state_changed|length)+(.removed|length);
  "# WordPress AI board — change report",
  "",
  "_Baseline:_ \(.meta.base_label)   →   _Current:_ \(.meta.cur_label)",
  "_Item totals:_ \(.meta.base_count) → \(.meta.cur_count)",
  "",
  "**Summary:** \(.added|length) added · \(.newly_done|length) newly Done · \(.newly_merged|length) merged · \(.status_changed|length) status moves · \(.milestone_changed|length) milestone moves · \(.state_changed|length) state changes · \(.removed|length) removed",
  ( if (.added|length)>0 then "\n## ➕ Added (\(.added|length))\n" + fmt(.added; "- `\(.id)` (\(.type)) — \(.title)  _[\(.status // "—") / \(.milestone // "—")]_") else empty end ),
  ( if (.newly_done|length)>0 then "\n## ✅ Newly Done / shipped (\(.newly_done|length))\n" + fmt(.newly_done; "- `\(.id)` (\(.type)) — \(.title)  _[\(.milestone // "—")]_") else empty end ),
  ( if (.newly_merged|length)>0 then "\n## 🔀 Newly merged PRs (\(.newly_merged|length))\n" + fmt(.newly_merged; "- `\(.id)` — \(.title)") else empty end ),
  ( if (.status_changed|length)>0 then "\n## 🔁 Status changes (\(.status_changed|length))\n" + fmt(.status_changed; "- `\(.id)` — \(.title): _\(.from)_ → **\(.to)**") else empty end ),
  ( if (.milestone_changed|length)>0 then "\n## 🎯 Milestone changes (\(.milestone_changed|length))\n" + fmt(.milestone_changed; "- `\(.id)` — \(.title): _\(.from)_ → **\(.to)**") else empty end ),
  ( if (.state_changed|length)>0 then "\n## 🔄 Open/closed changes (\(.state_changed|length))\n" + fmt(.state_changed; "- `\(.id)` — \(.title): \(.from) → \(.to)") else empty end ),
  ( if (.removed|length)>0 then "\n## ➖ Removed from board (\(.removed|length))\n" + fmt(.removed; "- `\(.id)` — \(.title)") else empty end ),
  ( if total==0 then "\n_No changes since baseline._" else empty end )'

# --------------- repo census: jq programs (open PRs + releases) --------------
# Paginated open-PR query. closingIssuesReferences is authoritative; fallback
# parsing (exact grammar below) applies only to substantive PRs.
PR_GQL_QUERY='query($owner: String!, $name: String!, $endCursor: String) {
  repository(owner: $owner, name: $name) {
    pullRequests(first: 100, after: $endCursor, states: OPEN) {
      totalCount
      pageInfo { hasNextPage endCursor }
      nodes {
        number title url body isDraft headRefName updatedAt
        reviewDecision mergeStateStatus
        author { __typename login }
        commits(last: 1) {
          nodes { commit { statusCheckRollup { state } } }
        }
        closingIssuesReferences(first: 20) {
          totalCount
          nodes { number repository { nameWithOwner } }
        }
      }
    }
  }
}'

# Normalize slurped PR GraphQL pages -> {items,validation}. Links merge with
# source precedence closing > fallback-title > fallback-body > fallback-branch
# > legacy, unique by repo+number, deterministically sorted.
PR_CENSUS_JQ='
  def source_rank:
    {"closing":0,"fallback-title":1,"fallback-body":2,"fallback-branch":3,"legacy":4}[.source];
  def unique_links:
    group_by([.repo,.number])
    | map(sort_by(source_rank) | first)
    | sort_by(.repo,.number);
  def is_routine:
    (.author.__typename=="Bot")
    or ((.author.login // "") | test("dependabot";"i"))
    or ((.title // "") | test("^(fix\\(deps\\)|build\\(deps\\)|chore\\(deps\\)|ci:)";"i"));

  def title_links($text; $repo):
    ([
      ($text // "")
      | match("(?:^|[^A-Za-z0-9_/-])#([1-9][0-9]*)(?=$|[^0-9])";"gi")
      | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-title"}
    ] + [
      ($text // "")
      | match("\\b(?:issue|feat|feature)[ :_#-]+([1-9][0-9]*)(?=$|[^0-9])";"gi")
      | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-title"}
    ]);

  def branch_links($text; $repo): [
    ($text // "")
    | match("(?:^|/)(?:issue|feat|feature)[/_-]#?([1-9][0-9]*)(?:$|[/_-])";"gi")
    | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-branch"}
  ];

  def relationship:
    "\\b(?:fix|fixes|fixed|close|closes|closed|resolve|resolves|resolved|implement|implements|implemented|track|tracks|tracked|relates[ ]+to|related[ ]+to|issue)[\\t ]*:?[\\t ]+";

  def body_links($text; $repo):
    ([
      ($text // "")
      | match(relationship + "https://github\\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/issues/([1-9][0-9]*)";"gi")
      | {
          repo:(.captures[0].string + "/" + .captures[1].string),
          number:(.captures[2].string|tonumber),
          source:"fallback-body"
        }
    ] + [
      ($text // "")
      | match(relationship + "([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)#([1-9][0-9]*)";"gi")
      | {
          repo:.captures[0].string,
          number:(.captures[1].string|tonumber),
          source:"fallback-body"
        }
    ] + [
      ($text // "")
      | match(relationship + "#([1-9][0-9]*)";"gi")
      | {repo:$repo,number:(.captures[0].string|tonumber),source:"fallback-body"}
    ]);

  def normalize_pr($repo):
    . as $pr
    | is_routine as $routine
    | ([ .closingIssuesReferences.nodes[]?
         | {repo:.repository.nameWithOwner, number:.number, source:"closing"} ]) as $closing
    | (($closing
        + (if $routine then []
           else title_links($pr.title; $repo)
                + body_links($pr.body; $repo)
                + branch_links($pr.headRefName; $repo)
           end))
       | unique_links) as $links
    | {
        id: ($repo + "#" + (.number|tostring)),
        repo: $repo,
        number: .number,
        title: .title,
        url: .url,
        isDraft: .isDraft,
        author: (.author.login // "?"),
        isBot: (.author.__typename == "Bot"),
        routine: $routine,
        reviewDecision: .reviewDecision,
        mergeStateStatus: .mergeStateStatus,
        checkState: (.commits.nodes[0].commit.statusCheckRollup.state // null),
        updatedAt: .updatedAt,
        issueLinks: $links,
        issues: ($links | map(select(.repo == $repo) | .number) | unique)
      };

  . as $pages
  | [ $pages[] | .data.repository.pullRequests.nodes[]? ] as $nodes
  | ([ $pages[] | .data.repository.pullRequests.totalCount ] | unique) as $totals
  | ($nodes | map(.number)) as $numbers
  | ([
      (($numbers | group_by(.) | map(select(length > 1) | .[0]))[]
        | {code:"pr-duplicate",
           message:"Duplicate PR number across pages",
           context:{number:.}}),
      (if ($pages | last | .data.repository.pullRequests.pageInfo.hasNextPage) == true
        then {code:"pr-pagination-incomplete",
              message:"PR pagination did not reach the final page",
              context:{pages:($pages|length)}}
        else empty end),
      (if (($totals|length) != 1) or ($totals[0] != ($numbers|unique|length))
        then {code:"pr-total-mismatch",
              message:"Reported PR total does not equal unique normalized nodes",
              context:{totals:$totals, nodes:($numbers|unique|length)}}
        else empty end),
      ($nodes[]
        | select(((.closingIssuesReferences.totalCount // 0) > 20)
                 or ((.closingIssuesReferences.totalCount // 0)
                     != ((.closingIssuesReferences.nodes // [])|length)))
        | {code:"pr-closing-refs-truncated",
           message:"closingIssuesReferences truncated or count mismatch",
           context:{number:.number,
                    totalCount:.closingIssuesReferences.totalCount,
                    returned:((.closingIssuesReferences.nodes // [])|length)}})
    ] | sort_by(.code, (.context|tostring))) as $errors
  | ([ $nodes[]
       | select(.mergeStateStatus == "UNKNOWN")
       | {code:"pr-mergestate-unknown",
          message:"GitHub has not finished computing mergeability; readiness diff suppressed for this PR",
          context:{number:.number}} ]
     | sort_by(.context.number)) as $warnings
  | {
      items: ([ $nodes[] | normalize_pr($repo) ] | sort_by(.number)),
      validation: {ok:(($errors|length)==0), errors:$errors, warnings:$warnings}
    }'

# ------------------ issue census: jq programs (open issues) ------------------
# Peer of the PR census. Open issues only: a closed issue leaves the census as a
# disappearance, exactly as a merged PR does, so `no_longer_open` covers both.
ISSUE_GQL_QUERY='query($owner: String!, $name: String!, $endCursor: String) {
  repository(owner: $owner, name: $name) {
    issues(first: 100, after: $endCursor, states: OPEN) {
      totalCount
      pageInfo { hasNextPage endCursor }
      nodes {
        number title url state createdAt updatedAt
        milestone { title }
        labels(first: 20) { totalCount nodes { name } }
        assignees(first: 10) { totalCount nodes { login } }
        author { __typename login }
        comments { totalCount }
      }
    }
  }
}'

# Normalize slurped issue GraphQL pages -> {items,validation}. Records mirror the
# normalized board shape, so the two join on repo#number without translation.
ISSUE_CENSUS_JQ='
  def normalize_issue($repo):
    {
      id: ($repo + "#" + (.number|tostring)),
      repo: $repo,
      number: .number,
      title: .title,
      url: .url,
      state: .state,
      milestone: (.milestone.title // null),
      labels: [ .labels.nodes[]?.name ],
      assignees: [ .assignees.nodes[]?.login ],
      author: (.author.login // "?"),
      isBot: (.author.__typename == "Bot"),
      comments: (.comments.totalCount // 0),
      createdAt: .createdAt,
      updatedAt: .updatedAt
    };

  . as $pages
  | [ $pages[] | .data.repository.issues.nodes[]? ] as $nodes
  | ([ $pages[] | .data.repository.issues.totalCount ] | unique) as $totals
  | ($nodes | map(.number)) as $numbers
  | ([
      (($numbers | group_by(.) | map(select(length > 1) | .[0]))[]
        | {code:"issue-duplicate",
           message:"Duplicate issue number across pages",
           context:{number:.}}),
      (if ($pages | last | .data.repository.issues.pageInfo.hasNextPage) == true
        then {code:"issue-pagination-incomplete",
              message:"Issue pagination did not reach the final page",
              context:{pages:($pages|length)}}
        else empty end),
      (if (($totals|length) != 1) or ($totals[0] != ($numbers|unique|length))
        then {code:"issue-total-mismatch",
              message:"Reported issue total does not equal unique normalized nodes",
              context:{totals:$totals, nodes:($numbers|unique|length)}}
        else empty end)
    ] | sort_by(.code, (.context|tostring))) as $errors
  # Bounded label/assignee connections. Unlike closingIssuesReferences, nothing
  # here depends on completeness, so truncation is a warning, not an error.
  | ([ $nodes[]
       | . as $n
       | ( if ((.labels.totalCount // 0) > ((.labels.nodes // [])|length))
             then {code:"issue-connection-truncated",
                   message:"Issue label connection truncated",
                   context:{number:$n.number, connection:"labels",
                            totalCount:$n.labels.totalCount,
                            returned:((.labels.nodes // [])|length)}}
             else empty end ),
         ( if ((.assignees.totalCount // 0) > ((.assignees.nodes // [])|length))
             then {code:"issue-connection-truncated",
                   message:"Issue assignee connection truncated",
                   context:{number:$n.number, connection:"assignees",
                            totalCount:$n.assignees.totalCount,
                            returned:((.assignees.nodes // [])|length)}}
             else empty end )
     ] | sort_by(.code, (.context|tostring))) as $warnings
  | {
      items: ([ $nodes[] | normalize_issue($repo) ] | sort_by(.number)),
      validation: {ok:(($errors|length)==0), errors:$errors, warnings:$warnings}
    }'

# diff two normalized issue arrays -> opened / no-longer-open / changed.
# labels and assignees compare as SETS so reordering is silent, while from/to
# report the original arrays. Each field is compared only when both records
# carry it, so older snapshots produce no schema-migration noise, and an
# updatedAt bump alone is never a change.
ISSUEDIFF_JQ='
  def change($b; $c; $key):
    if ($b|has($key)) and ($c|has($key)) and ($b[$key] != $c[$key])
    then {($key):{from:$b[$key],to:$c[$key]}}
    else {}
    end;
  def set_change($b; $c; $key):
    if ($b|has($key)) and ($c|has($key))
       and ((($b[$key] // []) | sort) != (($c[$key] // []) | sort))
    then {($key):{from:$b[$key],to:$c[$key]}}
    else {}
    end;
  ($base[0]) as $B | ($cur[0]) as $C
  | ([ $B[].number ]) as $bn | ([ $C[].number ]) as $cn
  | (reduce $B[] as $x ({}; .[$x.number|tostring] = $x)) as $bidx
  | { newly_opened:   [ $C[] | select(.number as $n | ($bn|index($n))==null)
                        | {number,title,milestone} ],
      no_longer_open: [ $B[] | select(.number as $n | ($cn|index($n))==null)
                        | {number,title} ],
      changed: ([
        $C[]
        | . as $c
        | ($bidx[$c.number|tostring] // null) as $b
        | select($b != null)
        | (change($b; $c; "title")
           * change($b; $c; "milestone")
           * set_change($b; $c; "labels")
           * set_change($b; $c; "assignees")) as $changes
        | select(($changes|length) > 0)
        | {number:$c.number, title:$c.title, changes:$changes}
      ] | sort_by(.number)) }'

# board snapshot ($board[0]) + normalized issues ($issues[0]) -> coverage.
# PRIMARY REPOSITORY ONLY. Enforced at the call site, not here, so an upstream
# repository can never reach this rule: php-ai-client / mcp-adapter /
# abilities-api issues are not roadmap cards and must not be reported as
# missing ones.
ISSUE_GAP_JQ='
  def key($repo; $number): $repo + "#" + ($number|tostring);
  ($board[0]) as $B
  | ($issues[0]) as $I
  | (reduce ($B[] | select(.type=="Issue")) as $item
      ({}; .[key($item.repo;$item.number)]=true)) as $cards
  | ([ $I[] | select($cards[key(.repo;.number)] == null) ]) as $uncarded
  | ([ $uncarded[]
       | {code:"issue-roadmap-coverage-missing",
          message:"Open issue has no roadmap board card",
          context:{id:.id, number:.number}} ]
     | sort_by(.code, (.context|tostring))) as $errors
  | {
      repo: $repo,
      open_total: ($I|length),
      carded: (($I|length) - ($uncarded|length)),
      uncarded: ($uncarded | map({id,number,title,url,milestone,updatedAt})),
      validation: {ok:(($errors|length)==0), errors:$errors, warnings:[]}
    }'

# Normalize `gh release list --json ...` -> compact records (oldest..newest).
REL_NORMALIZE_JQ='
  map({ tag: .tagName, name: .name, isDraft: .isDraft, isPrerelease: .isPrerelease, publishedAt: .publishedAt })
  | sort_by(.publishedAt // "")'

# board snapshot ($board[0]) + normalized PRs ($prs[0]) -> board<->repo gap.
# Board cards and issue links join on canonical repository#number keys; legacy
# bare `issues` numbers are interpreted as $repo. Every open PR gets exactly
# one of five classifications, and coverage errors name the non-routine PRs
# with no board representation.
GAP_JQ='
  def key($repo; $number): $repo + "#" + ($number|tostring);
  def legacy_links($pr):
    [$pr.issues[]? | {repo:$repo,number:.,source:"legacy"}];
  def links($pr):
    if ($pr.issueLinks // [] | length)>0
    then $pr.issueLinks
    else legacy_links($pr)
    end;
  ($board[0]) as $B
  | ($prs[0]) as $P
  | ([ $B[] | select(.type=="PullRequest" and .repo==$repo) ]) as $boardprs
  | (reduce ($B[] | select(.type=="Issue")) as $item
      ({}; .[key($item.repo;$item.number)]={
        status:$item.status,
        milestone:$item.milestone,
        assignees:($item.assignees // [])
      })) as $board_issues
  | (reduce ($B[] | select(.type=="PullRequest")) as $item
      ({}; .[key($item.repo;$item.number)]=$item)) as $board_prs
  | [$P[] as $pr
      | (links($pr) | unique_by([.repo,.number,.source])
          | sort_by(.repo,.number,.source)) as $links
      | [$links[]
          | . as $link
          | ($board_issues[key($link.repo;$link.number)] // null) as $board
          | $link + {
              onBoard:($board!=null),
              status:$board.status,
              milestone:$board.milestone,
              assignees:($board.assignees // [])
            }] as $mapped
      | (($pr.repo // $repo) as $pr_repo
          | $board_prs[key($pr_repo;$pr.number)] != null) as $direct
      | ([$mapped[] | select(.onBoard and .source=="closing")] | length>0)
          as $authoritative_board
      | ([$mapped[] | select(.onBoard)] | length>0) as $any_board
      | (if $direct then "direct-board-pr"
         elif $authoritative_board then "linked-board-issue"
         elif ($pr.routine // false) then "routine"
         elif $any_board then "linked-board-issue"
         elif ($links|length)>0 then "linked-off-board-issue"
         else "unexplained"
         end) as $classification
      | $pr + {
          repo:($pr.repo // $repo),
          issueLinks:$links,
          mappedIssues:$mapped,
          classification:$classification
        }
    ] as $classified
  | (reduce $classified[] as $pr
      ({
        "direct-board-pr":[],
        "linked-board-issue":[],
        "routine":[],
        "linked-off-board-issue":[],
        "unexplained":[]
      };
      .[$pr.classification] += [$pr])) as $classes
  | {
      repo:$repo,
      open_total:($classified|length),
      board_pr_cards_total: ($boardprs|length),
      board_pr_cards: ([ $boardprs[] | select(.state=="OPEN") ]|length),
      board_non_done_pr_cards: ([ $boardprs[] | select(.status!="Done") ]|length),
      classifications:$classes,
      classification_counts:($classes|with_entries(.value=(.value|length))),
      untracked:[$classified[]|select(.classification!="direct-board-pr")],
      substantive:[
        $classified[]
        | select(.classification!="direct-board-pr" and ((.routine // false)|not))
      ],
      routine_count:([
        $classified[]
        | select(.classification!="direct-board-pr" and (.routine // false))
      ]|length),
      tracked_open:([$classified[]|select(.classification=="direct-board-pr")]|length)
    }
  | . as $out
  | ([
      ($classified[]
        | select((.classification=="linked-off-board-issue" or .classification=="unexplained")
                 and ((.routine // false)|not))
        | {code:"pr-roadmap-coverage-missing",
           message:"Substantive open PR has no roadmap board representation",
           context:{id:.id, number:.number, classification:.classification}})
    ]) as $coverage_errors
  | ([
      (if (($out.classification_counts | [.[]] | add) // 0) != $out.open_total
        then {code:"validation-inconsistent",
              message:"classification counts do not sum to open_total",
              context:{sum:(($out.classification_counts | [.[]] | add) // 0),
                       open_total:$out.open_total}}
        else empty end),
      (if ($out.tracked_open + ($out.untracked|length)) != $out.open_total
        then {code:"validation-inconsistent",
              message:"tracked plus untracked does not equal open_total",
              context:{tracked_open:$out.tracked_open,
                       untracked:($out.untracked|length),
                       open_total:$out.open_total}}
        else empty end),
      (if ($out.routine_count + ($out.substantive|length)) != ($out.untracked|length)
        then {code:"validation-inconsistent",
              message:"routine plus substantive does not equal untracked",
              context:{routine_count:$out.routine_count,
                       substantive:($out.substantive|length),
                       untracked:($out.untracked|length)}}
        else empty end),
      (if ([$out.classifications[][].number] | sort) != ([$classified[].number] | sort)
        then {code:"validation-inconsistent",
              message:"classification membership does not partition the open PRs",
              context:{classified:([$out.classifications[][].number] | sort),
                       open:([$classified[].number] | sort)}}
        else empty end)
    ]) as $invariant_errors
  | (($coverage_errors + $invariant_errors)
      | sort_by(.code, (.context|tostring))) as $errors
  | $out + {validation:{ok:(($errors|length)==0), errors:$errors, warnings:[]}}'

# diff two normalized PR arrays -> opened / no-longer-open / readiness changes.
# Readiness compares isDraft, reviewDecision, mergeStateStatus, and checkState,
# each only when both records have the key, so legacy snapshots produce no
# schema-migration noise. An updatedAt change alone is not a readiness change.
PRDIFF_JQ='
  def change($b; $c; $key):
    if ($b|has($key)) and ($c|has($key)) and ($b[$key] != $c[$key])
    then {($key):{from:$b[$key],to:$c[$key]}}
    else {}
    end;
  # GitHub computes mergeability lazily and answers UNKNOWN until the background
  # job lands, so a transition into or out of UNKNOWN records when we asked, not
  # a change in the PR. Suppress it the way has($key) suppresses schema noise --
  # otherwise one cold census reports every open PR as newly unreadable, and the
  # snapshot it saves reports them all again in reverse next window.
  def merge_change($b; $c):
    if ($b.mergeStateStatus == "UNKNOWN") or ($c.mergeStateStatus == "UNKNOWN")
    then {}
    else change($b; $c; "mergeStateStatus")
    end;
  ($base[0]) as $B | ($cur[0]) as $C
  | ([ $B[].number ]) as $bn | ([ $C[].number ]) as $cn
  | (reduce $B[] as $x ({}; .[$x.number|tostring] = $x)) as $bidx
  | { newly_opened:   [ $C[] | select(.number as $n | ($bn|index($n))==null) | {number,title,isDraft} ],
      no_longer_open: [ $B[] | select(.number as $n | ($cn|index($n))==null) | {number,title} ],
      readiness_changed: ([
        $C[]
        | . as $c
        | ($bidx[$c.number|tostring] // null) as $b
        | select($b != null)
        | (change($b; $c; "isDraft")
           * change($b; $c; "reviewDecision")
           * merge_change($b; $c)
           * change($b; $c; "checkState")) as $changes
        | select(($changes|length) > 0)
        | {number:$c.number, title:$c.title, changes:$changes}
      ] | sort_by(.number)) }'

# diff two normalized release arrays -> new releases.
RELDIFF_JQ='
  ($base[0]) as $B | ($cur[0]) as $C
  | ([ $B[].tag ]) as $bt
  | { new_releases: [ $C[] | select(.tag as $t | ($bt|index($t))==null)
                      | {tag,name,publishedAt,isDraft,isPrerelease} ] }'

# render the combined repo report object -> developer radar + copy-paste block.
# Order: what changed -> already underway -> uncovered work -> routine count.
RENDER_REPO_JQ='
  def fmt(a; f): [ a[] | f ] | join("\n");
  def show: if . == null then "—" else tostring end;
  def age_days:
    if . == null then null
    else (try (((now - fromdateiso8601) / 86400) | floor) catch null) end;
  def state_bits:
    [ "Review: \(.reviewDecision // "—")",
      "Merge: \(.mergeStateStatus // "—")",
      "Checks: \(.checkState // "—")",
      ((.updatedAt | age_days) as $d
        | if $d == null then empty else "Active: \($d)d ago" end)
    ] | join(" · ");
  def issue_map(iss):
    [ iss[] | "\(.repo)#\(.number) [\(.source)]"
      + (if .onBoard
         then " (board: \(.status // "—") / \(.milestone // "—")"
              + (if ((.assignees // [])|length)>0
                 then " / " + ((.assignees // [])|join(", ")) else "" end)
              + ")"
         else " (not on board)" end) ] | join(", ");
  def pr_line:
    "- " + (if .isDraft then "(draft) " else "" end)
    + "#\(.number) \(.title) — @\(.author // "?")\n  \(state_bits)"
    + (if ((.mappedIssues // [])|length)>0
       then "\n  → " + issue_map(.mappedIssues) else "" end);
  (.gap.classifications // {}) as $classes
  | (.gap.classification_counts // {}) as $counts
  | "",
  "## 📦 Releases (repo: \(.gap.repo))",
  ( if .rel.latest_shipped then "Latest shipped: **\(.rel.latest_shipped.tag)** (\((.rel.latest_shipped.publishedAt // "")[0:10]))" else "Latest shipped: (none found)" end ),
  ( if (.rel.new_releases|length)>0 then "New since baseline: " + ([ .rel.new_releases[] | "\(.tag) (\((.publishedAt // "")[0:10]))" ] | join(", ")) else empty end ),
  "",
  "## 🔀 What changed (open PRs)",
  ( if .pr_diff == null then "_(no PR baseline yet)_"
    else (
      ( if (.pr_diff.newly_opened|length)>0 then "Newly opened: " + ([ .pr_diff.newly_opened[] | "#\(.number)" ] | join(", ")) else empty end ),
      ( if (.pr_diff.no_longer_open|length)>0 then "No longer open (merged/closed): " + ([ .pr_diff.no_longer_open[] | "#\(.number)" ] | join(", ")) else empty end ),
      ( if ((.pr_diff.readiness_changed // [])|length)>0 then
          "Readiness changes:\n" + fmt(.pr_diff.readiness_changed;
            "- #\(.number) \(.title // ""): "
            + ([ .changes | to_entries[]
                 | "\(.key) \(.value.from|show) → \(.value.to|show)" ] | join(", ")))
        else empty end ),
      ( if ((.pr_diff.newly_opened|length)==0 and (.pr_diff.no_longer_open|length)==0
            and ((.pr_diff.readiness_changed // [])|length)==0)
        then "_(no PR census changes since baseline)_" else empty end )
    ) end ),
  "",
  # Issue-side peer of the PR coverage audit. Primary repository only: an
  # uncarded open issue here is a strict-audit failure, exactly as an uncarded
  # substantive PR is.
  ( if .issue_gap == null then empty
    else (
      "## 🗂️ Board issue coverage (repo: \(.issue_gap.repo))",
      "\(.issue_gap.carded) of \(.issue_gap.open_total) open issues have a Project #240 card.",
      ( if (.issue_gap.uncarded|length)>0
        then "",
             "**Uncarded open issues (\(.issue_gap.uncarded|length)):**",
             fmt(.issue_gap.uncarded;
               "- #\(.number) \(.title)"
               + (if .milestone then "  _[\(.milestone)]_" else "" end)
               + "  \(.url // "")")
        else "_Every open issue is represented on the board._" end ),
      ""
    ) end ),
  "## 🚧 Already underway (\((($counts["direct-board-pr"] // 0) + ($counts["linked-board-issue"] // 0))) of \(.gap.open_total) open PRs board-tracked)",
  ( if (($classes["direct-board-pr"] // [])|length)>0 then
      "\n### Direct board PR cards (\($counts["direct-board-pr"] // 0))\n"
      + fmt($classes["direct-board-pr"]; pr_line)
    else empty end ),
  ( if (($classes["linked-board-issue"] // [])|length)>0 then
      "\n### Linked to board issues (\($counts["linked-board-issue"] // 0))\n"
      + fmt($classes["linked-board-issue"]; pr_line)
    else empty end ),
  ( if ((($classes["direct-board-pr"] // [])|length)==0
        and (($classes["linked-board-issue"] // [])|length)==0)
    then "_(none)_" else empty end ),
  "",
  "## 🔍 Not represented on the board (\((($counts["linked-off-board-issue"] // 0) + ($counts["unexplained"] // 0))) substantive PRs)",
  ( if (($classes["linked-off-board-issue"] // [])|length)>0 then
      "\n### Linked only to off-board issues (\($counts["linked-off-board-issue"] // 0))\n"
      + fmt($classes["linked-off-board-issue"]; pr_line)
    else empty end ),
  ( if (($classes["unexplained"] // [])|length)>0 then
      "\n### Unexplained open PRs (\($counts["unexplained"] // 0))\n"
      + fmt($classes["unexplained"]; pr_line)
    else empty end ),
  ( if ((($counts["linked-off-board-issue"] // 0) + ($counts["unexplained"] // 0))==0)
    then "_(none — every substantive open PR is represented on the board)_" else empty end ),
  ( if (.gap.routine_count // 0)>0
    then "\n## 🔁 Routine PRs: \(.gap.routine_count) (dependency/bot maintenance; roadmap-exempt)"
    else empty end ),
  "",
  "## 📋 Copy-paste block (for wordpress-ai-planned-work.md)",
  "```markdown",
  ( if .rel.latest_shipped then "> | **Latest shipped** | \(.rel.latest_shipped.tag) (\((.rel.latest_shipped.publishedAt // "")[0:10])) · **Active:** v1.1.0 · **Next:** v1.2.0 |   <!-- adjust Active/Next by hand -->" else empty end ),
  "",
  "| Open PR (live) | Implements | Board state of that issue |",
  "|---|---|---|",
  fmt(.gap.substantive;
      "| #\(.number)" + (if .isDraft then " (draft)" else "" end) + " \(.title) | "
      + (if ((.mappedIssues // [])|length)>0 then ([ .mappedIssues[] | "\(.repo)#\(.number) [\(.source)]" ] | join(", ")) else "—" end) + " | "
      + (if ((.mappedIssues // [])|length)>0 then ([ .mappedIssues[] | (if .onBoard then "\(.status // "—")/\(.milestone // "—")" else "not on board" end) ] | join("; ")) else "—" end)
      + " |"),
  "```"'

# Render the primary plus additional repository censuses as a compact radar.
# Project #240 coverage remains in RENDER_REPO_JQ for the primary repository;
# this section reports PR/release activity without imposing board coverage on
# the two upstream repositories.
RENDER_REPOSITORIES_JQ='
  def latest:
    if .latest_shipped == null then "—"
    else "`\(.latest_shipped.tag)` (\((.latest_shipped.publishedAt // "")[0:10]))"
    end;
  def changes:
    if (.available | not) then "unavailable"
    elif .pr_diff == null then "baseline missing"
    else
      "+\(.pr_diff.newly_opened|length) opened · "
      + "-\(.pr_diff.no_longer_open|length) no longer open · "
      + "\((.pr_diff.readiness_changed // [])|length) readiness"
    end;
  def release_changes:
    if (.available | not) then "unavailable"
    elif .release_diff == null then "baseline missing"
    elif (.release_diff.new_releases|length)==0 then "none"
    else ([.release_diff.new_releases[].tag] | join(", "))
    end;
  def issue_count:
    if (.issues_available | not) then "—" else (.open_issues|length|tostring) end;
  def issue_changes:
    if (.available | not) then "unavailable"
    elif (.issues_available | not) then "unavailable"
    elif .issue_diff == null then "baseline missing"
    else
      "+\(.issue_diff.newly_opened|length) opened · "
      + "-\(.issue_diff.no_longer_open|length) no longer open · "
      + "\((.issue_diff.changed // [])|length) changed"
    end;
  def issue_movement:
    [ .[]
      | select(.issue_diff != null)
      | select(((.issue_diff.newly_opened|length)
                + (.issue_diff.no_longer_open|length)
                + ((.issue_diff.changed // [])|length)) > 0)
      | "",
        "### \(.repo)",
        ( .issue_diff.newly_opened[]?
          | "- opened  #\(.number) \(.title)\(if .milestone then "  _[\(.milestone)]_" else "" end)" ),
        ( .issue_diff.no_longer_open[]?
          | "- closed  #\(.number) \(.title)" ),
        ( (.issue_diff.changed // [])[]?
          | "- changed #\(.number) \(.title) — "
            + ([.changes | to_entries[] | .key] | join(", ")) )
    ];
  "",
  "## Tracked repository PR/issue/release census",
  "",
  "Project #240 coverage validation applies only to the primary `\($primary)` repository.",
  "",
  "| Repository | Open PRs | Open issues | Latest release | PR changes | Issue changes | New releases |",
  "|---|---:|---:|---|---|---|---|",
  (.[] | "| `\(.repo)` | \(.open_prs|length) | \(issue_count) | \(latest) | \(changes) | \(issue_changes) | \(release_changes) |"),
  (issue_movement as $m
    | if ($m|length)>0
      then "", "## Issue movement (tracked repositories)", $m[]
      else empty end)'

# Cross-repo dependency watchlist for roadmap-critical Gutenberg and
# abilities-api items, declared in $DEPS_FILE (wp-ai-roadmap-dependencies.json).
# Whole-repo Gutenberg tracking is intentionally avoided: that repository is
# too broad for a useful roadmap signal.
load_dependency_registry() {
  local file="$1"
  [ -r "$file" ] || die "dependency registry not readable: $file"

  if ! jq -e . "$file" >/dev/null 2>&1; then
    jq -n --arg file "$file" '{
      items: [],
      validation: {
        ok: false,
        errors: [{
          code: "dependency-registry-invalid",
          message: "Dependency registry is not valid JSON",
          context: {file:$file}
        }],
        warnings: []
      }
    }'
    return 0
  fi

  jq '
    def diagnostic($message; $context): {
      code:"dependency-registry-invalid",
      message:$message,
      context:$context
    };
    . as $registry
    | ([
        if (.schemaVersion != 1)
          then diagnostic("schemaVersion must equal 1"; {actual:.schemaVersion}) else empty end,
        if ((.items | type) != "array" or (.items | length) == 0)
          then diagnostic("items must be a nonempty array"; {}) else empty end,
        (([.items[]?.id] | group_by(.) | map(select(length > 1) | .[0]))[]?
          | diagnostic("dependency IDs must be unique"; {id:.})),
        (.items[]? as $item
          | if (
              ($item.id | type) != "string"
              or ($item.id | test("^[^/]+/[^#]+#[1-9][0-9]*$") | not)
              or ($item.theme | type) != "string" or ($item.theme | length) == 0
              or ($item.note | type) != "string" or ($item.note | length) == 0
              or ($item.required | type) != "boolean"
              or ($item.aiRefs | type) != "array"
              or ([$item.aiRefs[]? | select(type != "number" or . <= 0 or floor != .)] | length) > 0
              or (($item.aiRefs | unique | length) != ($item.aiRefs | length))
            )
            then diagnostic("dependency item does not match schema"; {id:($item.id // null)})
            else empty
            end)
      ] | sort_by(.code, (.context|tostring))) as $errors
    | {
        items: (if ($errors|length)==0 then $registry.items else [] end),
        validation: {ok:($errors|length==0), errors:$errors, warnings:[]}
      }
  ' "$file"
}

# Merge fetched dependency records with registry diagnostics -> {items,validation}.
# Emitted IDs must equal the validated registry IDs exactly (UNKNOWN placeholders
# included); a required UNKNOWN item is an error, an optional one a warning.
DEPS_VALIDATE_JQ='
  def diagnostic($code; $message; $item): {
    code:$code,
    message:$message,
    context:{id:$item.id, endpoint:$item.fetchError.endpoint}
  };
  . as $items
  | ($registry[0]) as $reg
  | [
      $items[]
      | select(.state=="UNKNOWN")
      | if .required
          then diagnostic("dependency-required-unreachable"; "Required dependency is unreachable"; .)
          else diagnostic("dependency-optional-unreachable"; "Optional dependency is unreachable"; .)
        end
    ] as $unknown
  | ([$reg.items[].id] | sort) as $expected_ids
  | ([$items[].id] | sort) as $emitted_ids
  | (if $expected_ids == $emitted_ids then [] else [{
        code:"dependency-validation-inconsistent",
        message:"Emitted dependency IDs do not match the validated registry",
        context:{expected:$expected_ids, emitted:$emitted_ids}
      }] end) as $inconsistent
  | ($reg.validation.errors + $inconsistent
     + [$unknown[]|select(.code=="dependency-required-unreachable")]) as $errors
  | ($reg.validation.warnings
     + [$unknown[]|select(.code=="dependency-optional-unreachable")]) as $warnings
  | {
      items: ($items | sort_by(.repo, .number)),
      validation: {
        ok: (($errors|length)==0),
        errors: ($errors | sort_by(.code, (.context|tostring))),
        warnings: ($warnings | sort_by(.code, (.context|tostring)))
      }
    }'

DEPS_DIFF_JQ='
  def byid: reduce .[] as $x ({}; .[$x.id] = $x);
  ($base[0] | byid) as $B
  | ($cur[0]  | byid) as $C
  | ($C | keys) as $ck
  | ($B | keys) as $bk
  | {
      meta: { base_label: $bl, cur_label: $cl,
              base_count: ($base[0] | length), cur_count: ($cur[0] | length) },
      added: [ $ck[] | select($B[.] == null) | $C[.]
               | {id, type, title, state, milestone, url, theme, aiRefs} ],
      removed: [ $bk[] | select($C[.] == null) | $B[.]
                 | {id, type, title, state, milestone, theme, aiRefs} ],
      state_changed: [ $ck[] | select($B[.] != null and ($B[.].state != $C[.].state))
                       | {id:., type:$C[.].type, title:$C[.].title,
                          from:($B[.].state // "—"), to:($C[.].state // "—"), url:$C[.].url} ],
      milestone_changed: [ $ck[] | select($B[.] != null and (($B[.].milestone // "") != ($C[.].milestone // "")))
                           | {id:., title:$C[.].title,
                              from:($B[.].milestone // "—"), to:($C[.].milestone // "—"), url:$C[.].url} ],
      title_changed: [ $ck[] | select($B[.] != null and ($B[.].title != $C[.].title))
                       | {id:., from:$B[.].title, to:$C[.].title, url:$C[.].url} ],
      updated: [ $ck[] | select($B[.] != null and ($B[.].updatedAt != $C[.].updatedAt))
                 | {id:., title:$C[.].title, from:$B[.].updatedAt, to:$C[.].updatedAt, url:$C[.].url} ]
    }'

RENDER_DEPS_JQ='
  def entries(o): [ o | to_entries[] | "\(.key) \(.value)" ] | join(" · ");
  def fmt(a; f): [ a[] | f ] | join("\n");
  def ai_ref:
    tostring | if startswith("#") then . else "#" + . end;
  def ai_refs:
    [.[] | ai_ref] | join(", ");
  "",
  "## Cross-repo dependency watchlist",
  "Tracked dependencies: \(.summary.total) (" + entries(.summary.by_repo) + ")",
  "States: " + entries(.summary.by_state),
  ( if .diff == null then
      "Dependency baseline: none yet (run with --save to persist one)."
    else
      "Changes since \(.diff.meta.base_label): \(.diff.added|length) added · \(.diff.removed|length) removed · \(.diff.state_changed|length) state changes · \(.diff.milestone_changed|length) milestone changes · \(.diff.title_changed|length) title changes · \(.diff.updated|length) updated"
    end ),
  ( if (.diff != null and (.diff.state_changed|length)>0) then
      "\n### Dependency state changes\n" + fmt(.diff.state_changed; "- `\(.id)` \(.from) -> \(.to): \(.title)")
    else empty end ),
  ( if (.diff != null and (.diff.added|length)>0) then
      "\n### Added dependencies\n" + fmt(.diff.added; "- `\(.id)` (\(.type), \(.state)) — \(.title)")
    else empty end ),
  ( if (.diff != null and (.diff.removed|length)>0) then
      "\n### Removed dependencies\n" + fmt(.diff.removed; "- `\(.id)` (\(.type), \(.state)) — \(.title)")
    else empty end ),
  "",
  "### Open dependencies",
  ( [ .items[] | select(.state == "OPEN") ] as $open
    | if ($open|length) > 0
      then fmt($open;
        "- `\(.id)` (\(.type)) — \(.title)  _[\(.theme); AI refs: \(.aiRefs|ai_refs)]_")
      else "_(none)_"
      end )'

fetch_normalized() {
  local raw err
  err="$(mktemp)"
  raw="$(gh api graphql --paginate -f query="$GQL_QUERY" -F org="$ORG" -F number="$PROJECT" 2>"$err")" || {
    printf 'error: gh query failed:\n' >&2; cat "$err" >&2; rm -f "$err"; exit 1; }
  rm -f "$err"
  [ -n "$raw" ] || die "gh returned no data"
  printf '%s' "$raw" | jq -s -e '.[0].data.organization.projectV2 != null' >/dev/null 2>&1 \
    || die "project #$PROJECT not readable — does your gh token have the read:project scope? (gh auth refresh -h github.com -s read:project)"
  printf '%s' "$raw" | jq -s "$NORMALIZE_JQ"
}

compute_diff() { # baseline_file current_file base_label cur_label
  jq -n --arg bl "$3" --arg cl "$4" \
        --slurpfile base "$1" --slurpfile cur "$2" "$DIFF_JQ"
}

append_changelog() { # diff_json_file base_label [repo_extra]
  local total summary row extra
  extra="${3:-}"
  total="$(jq '[.added,.newly_done,.newly_merged,.status_changed,.milestone_changed,.state_changed,.removed]|map(length)|add' "$1")"
  if [ "$total" -eq 0 ] && [ -z "$extra" ]; then echo "changelog: no changes — nothing appended." >&2; return 0; fi
  [ -f "$PLANNED_DOC" ] || die "planned-work doc not found: $PLANNED_DOC"
  summary="$(jq -r '"\(.added|length) added, \(.newly_done|length) newly Done, \(.newly_merged|length) merged, \(.status_changed|length) status moves, \(.milestone_changed|length) milestone moves"' "$1")"
  row="| $(date -u +%Y-%m-%d) | Auto-refresh vs ${2}: ${summary}${extra}. |"
  awk -v row="$row" '
    /^## Changelog/ { inchg=1 }
    { print }
    inchg && /^\|---/ && !done { print row; done=1 }
  ' "$PLANNED_DOC" > "$PLANNED_DOC.tmp" && mv "$PLANNED_DOC.tmp" "$PLANNED_DOC"
  echo "changelog: appended row to $PLANNED_DOC" >&2
}

# --------------------- repo: open-PR + release census ------------------------
load_repository_registry() {
  local file="$1"
  if [ ! -r "$file" ]; then
    jq -n --arg file "$file" --arg primary "$REPO" '{
      repositories:[$primary],
      validation:{
        ok:false,
        errors:[{
          code:"repository-registry-invalid",
          message:"Repository registry is not readable",
          context:{file:$file}
        }],
        warnings:[]
      }
    }'
    return 0
  fi

  if ! jq -e . "$file" >/dev/null 2>&1; then
    jq -n --arg file "$file" --arg primary "$REPO" '{
      repositories:[$primary],
      validation:{
        ok:false,
        errors:[{
          code:"repository-registry-invalid",
          message:"Repository registry is not valid JSON",
          context:{file:$file}
        }],
        warnings:[]
      }
    }'
    return 0
  fi

  jq --arg primary "$REPO" '
    def diagnostic($message; $context): {
      code:"repository-registry-invalid",
      message:$message,
      context:$context
    };
    . as $registry
    | ([
        if .schemaVersion != 1
          then diagnostic("schemaVersion must equal 1"; {actual:.schemaVersion})
          else empty end,
        if (.repositories | type) != "array"
          then diagnostic("repositories must be an array"; {})
          else empty end,
        (.repositories[]?
          | select((type != "string") or (test("^[^/[:space:]]+/[^/[:space:]]+$") | not))
          | diagnostic("repository must use owner/name form"; {repo:.})),
        (([.repositories[]?] | group_by(.) | map(select(length > 1) | .[0]))[]?
          | diagnostic("repositories must be unique"; {repo:.})),
        (.repositories[]? | select(. == $primary)
          | diagnostic("additional repositories must not repeat the primary repository"; {repo:.}))
      ] | sort_by(.code, (.context|tostring))) as $errors
    | {
        repositories: ([$primary] + (if ($errors|length)==0 then $registry.repositories else [] end)),
        validation:{
          ok:(($errors|length)==0),
          errors:$errors,
          warnings:[]
        }
      }
  ' "$file"
}

pr_census_query() { # repository owner name -> raw paginated GraphQL pages
  local repo="$1" owner="$2" name="$3" raw err
  err="$(mktemp)"
  raw="$(gh api graphql --paginate -f query="$PR_GQL_QUERY" -F owner="$owner" -F name="$name" 2>"$err")" || {
    printf 'error: PR census query failed for %s:\n' "$repo" >&2; cat "$err" >&2; rm -f "$err"; return 1; }
  rm -f "$err"
  [ -n "$raw" ] || { printf 'error: PR census returned no data for %s\n' "$repo" >&2; return 1; }
  printf '%s' "$raw"
}

# Count nodes whose mergeability GitHub has not computed yet.
PR_UNKNOWN_MERGE_JQ='[ .[] | .data.repository.pullRequests.nodes[]?
  | select(.mergeStateStatus == "UNKNOWN") ] | length'

fetch_pr_census() { # repository -> {items,validation} for open PRs
  local repo="${1:-$REPO}" owner name raw retry unknown retry_unknown
  owner="${repo%%/*}"; name="${repo#*/}"
  raw="$(pr_census_query "$repo" "$owner" "$name")" || return 1
  # GitHub computes mergeability lazily: asking is what schedules the job, so a
  # cold query answers UNKNOWN for PRs it has not gotten to yet. Ask a second
  # time and keep whichever answer knows more -- recording the sentinel would
  # both misreport readiness and persist into the snapshot as a fake baseline.
  unknown="$(printf '%s' "$raw" | jq -s "$PR_UNKNOWN_MERGE_JQ")"
  if [ "$unknown" -gt 0 ]; then
    sleep "${WP_AI_MERGESTATE_RETRY_DELAY:-2}"
    if retry="$(pr_census_query "$repo" "$owner" "$name")"; then
      retry_unknown="$(printf '%s' "$retry" | jq -s "$PR_UNKNOWN_MERGE_JQ")"
      if [ "$retry_unknown" -lt "$unknown" ]; then
        raw="$retry"; unknown="$retry_unknown"
      fi
    fi
    [ "$unknown" -eq 0 ] || printf \
      'warning: %s: %s open PR(s) still report mergeStateStatus UNKNOWN after retry\n' \
      "$repo" "$unknown" >&2
  fi
  printf '%s' "$raw" | jq -s --arg repo "$repo" "$PR_CENSUS_JQ"
}

issue_census_query() { # repository owner name -> raw paginated GraphQL pages
  local repo="$1" owner="$2" name="$3" raw err
  err="$(mktemp)"
  raw="$(gh api graphql --paginate -f query="$ISSUE_GQL_QUERY" -F owner="$owner" -F name="$name" 2>"$err")" || {
    printf 'error: issue census query failed for %s:\n' "$repo" >&2; cat "$err" >&2; rm -f "$err"; return 1; }
  rm -f "$err"
  [ -n "$raw" ] || { printf 'error: issue census returned no data for %s\n' "$repo" >&2; return 1; }
  printf '%s' "$raw"
}

fetch_issue_census() { # repository -> {items,validation} for open issues
  local repo="${1:-$REPO}" owner name raw
  owner="${repo%%/*}"; name="${repo#*/}"
  raw="$(issue_census_query "$repo" "$owner" "$name")" || return 1
  printf '%s' "$raw" | jq -s --arg repo "$repo" "$ISSUE_CENSUS_JQ"
}

fetch_releases() { # repository -> normalized release array
  local repo="${1:-$REPO}"
  gh release list --repo "$repo" \
     --json tagName,name,isDraft,isPrerelease,publishedAt --limit 30 \
  | jq "$REL_NORMALIZE_JQ"
}

fetch_repository_census_entry() { # repository -> fail-soft census entry
  local repo="$1" prs releases issues issues_ok
  prs="$(mktemp)"; releases="$(mktemp)"; issues="$(mktemp)"
  if fetch_pr_census "$repo" >"$prs" && fetch_releases "$repo" >"$releases"; then
    # Issues are fetched independently on purpose: folding them into the
    # all-or-nothing PR/release contract would let one issue-fetch hiccup blank
    # PR data that arrived fine. A failure here degrades the issue half only.
    issues_ok=1
    fetch_issue_census "$repo" >"$issues" || issues_ok=0
    if [ "$issues_ok" = 0 ]; then
      jq -n '{items:[],validation:{ok:true,errors:[],warnings:[]}}' >"$issues"
    fi
    jq -n --arg repo "$repo" --argjson issues_ok "$issues_ok" \
          --slurpfile p "$prs" --slurpfile r "$releases" --slurpfile i "$issues" '
      ($p[0].validation // {ok:true,errors:[],warnings:[]}) as $pv
      | ($i[0].validation // {ok:true,errors:[],warnings:[]}) as $iv
      | (if $issues_ok == 1 then [] else [{
          code:"issue-census-unavailable",
          message:"Repository issue census is unavailable",
          context:{repo:$repo}
        }] end) as $ierr
      | (($pv.errors + $iv.errors)
          | map(.context=((.context // {}) + {repo:$repo}))) as $errors
      | (($pv.warnings + $iv.warnings)
          | map(.context=((.context // {}) + {repo:$repo}))) as $warnings
      | (($errors + $ierr)
          | unique_by([.code,(.context|tostring)])
          | sort_by(.code,(.context|tostring))) as $allerrors
      | {
          repo:$repo,
          available:true,
          issues_available:($issues_ok == 1),
          open_prs:$p[0].items,
          open_issues:$i[0].items,
          releases:$r[0],
          validation:{
            ok:(($allerrors|length)==0),
            errors:$allerrors,
            warnings:($warnings | sort_by(.code,(.context|tostring)))
          }
        }'
  else
    # The repository-census-unavailable error already says everything is
    # missing; adding issue-census-unavailable here would double-report it.
    jq -n --arg repo "$repo" '{
      repo:$repo,
      available:false,
      issues_available:false,
      open_prs:[],
      open_issues:[],
      releases:[],
      validation:{
        ok:false,
        errors:[{
          code:"repository-census-unavailable",
          message:"Repository PR/release census is unavailable",
          context:{repo:$repo}
        }],
        warnings:[]
      }
    }'
  fi
  rm -f "$prs" "$releases" "$issues"
}

fetch_repository_censuses() { # -> {repositories,validation}
  local registry registry_file entries_file repo
  registry="$(load_repository_registry "$REPOS_FILE")"
  registry_file="$(mktemp)"; entries_file="$(mktemp)"
  printf '%s\n' "$registry" >"$registry_file"

  while IFS= read -r repo; do
    fetch_repository_census_entry "$repo" >>"$entries_file"
  done < <(jq_lines -r '.repositories[]' <<<"$registry")

  jq -n --slurpfile registry "$registry_file" --slurpfile entries "$entries_file" '
    ($registry[0].validation // {ok:true,errors:[],warnings:[]}) as $rv
    | ([$rv.errors[], $entries[].validation.errors[]]
        | unique_by([.code,(.context|tostring)])
        | sort_by(.code,(.context|tostring))) as $errors
    | ([$rv.warnings[], $entries[].validation.warnings[]]
        | unique_by([.code,(.context|tostring)])
        | sort_by(.code,(.context|tostring))) as $warnings
    | {
        repositories:$entries,
        validation:{ok:(($errors|length)==0),errors:$errors,warnings:$warnings}
      }'
  rm -f "$registry_file" "$entries_file"
}

build_repository_reports() { # census_file temp_dir -> enriched repository array
  local census_file="$1" temp_dir="$2"
  local reports_file repo slug entry prs_file releases_file issues_file
  local prs_base releases_base issues_base
  local prdiff_file reldiff_file issuediff_file
  local prdiff_json reldiff_json issuediff_json
  reports_file="$temp_dir/repository-reports.jsonl"
  : >"$reports_file"

  while IFS= read -r entry; do
    # jq_lines, not jq: this slug becomes a filename, and a CRLF-emitting jq
    # would write prs-WordPress-ai$'\r'-current.json while the report assembly
    # below looks for the clean name. `$(…)` strips the trailing \n, not the \r.
    repo="$(jq_lines -r '.repo' <<<"$entry")"
    slug="${repo//\//-}"
    prs_file="$temp_dir/prs-$slug-current.json"
    releases_file="$temp_dir/releases-$slug-current.json"
    issues_file="$temp_dir/issues-$slug-current.json"
    prdiff_file="$temp_dir/prdiff-$slug.json"
    reldiff_file="$temp_dir/reldiff-$slug.json"
    issuediff_file="$temp_dir/issuediff-$slug.json"
    prdiff_json=null
    reldiff_json=null
    issuediff_json=null

    if jq -e '.available' >/dev/null <<<"$entry"; then
      jq '.open_prs' <<<"$entry" >"$prs_file"
      jq '.releases' <<<"$entry" >"$releases_file"
      prs_base="$(latest_snap "prs-$slug")"
      releases_base="$(latest_snap "releases-$slug")"
      if [ -n "$prs_base" ]; then
        diff_prs "$prs_base" "$prs_file" >"$prdiff_file"
        prdiff_json="$(<"$prdiff_file")"
      fi
      if [ -n "$releases_base" ]; then
        diff_releases "$releases_base" "$releases_file" >"$reldiff_file"
        reldiff_json="$(<"$reldiff_file")"
      fi
      # Only write the issue snapshot candidate when the census succeeded:
      # persisting [] over a good baseline would report every issue closed.
      if jq -e '.issues_available' >/dev/null <<<"$entry"; then
        jq '.open_issues' <<<"$entry" >"$issues_file"
        issues_base="$(latest_snap "issues-$slug")"
        if [ -n "$issues_base" ]; then
          diff_issues "$issues_base" "$issues_file" >"$issuediff_file"
          issuediff_json="$(<"$issuediff_file")"
        fi
      fi
    fi

    jq -c \
      --argjson prdiff "$prdiff_json" \
      --argjson reldiff "$reldiff_json" \
      --argjson issuediff "$issuediff_json" '
      . + {
        pr_diff:$prdiff,
        release_diff:$reldiff,
        issue_diff:$issuediff,
        latest_shipped:([
          .releases[]
          | select((.isDraft|not) and (.isPrerelease|not))
        ] | sort_by(.publishedAt // "") | last)
      }' <<<"$entry" >>"$reports_file"
  done < <(jq_lines -c '.repositories[]' "$census_file")

  jq -s '.' "$reports_file"
}

board_pr_gap() { # board_file prs_file -> gap JSON
  jq -n --arg repo "$REPO" --slurpfile board "$1" --slurpfile prs "$2" "$GAP_JQ"
}

# PRIMARY REPOSITORY ONLY. Never call this for a registry repository: upstream
# issues are not Project #240 cards and must never be reported as missing ones.
board_issue_gap() { # board_file issues_file -> issue gap JSON
  jq -n --arg repo "$REPO" --slurpfile board "$1" --slurpfile issues "$2" "$ISSUE_GAP_JQ"
}

diff_prs()      { jq -n --slurpfile base "$1" --slurpfile cur "$2" "$PRDIFF_JQ"; }
diff_releases() { jq -n --slurpfile base "$1" --slurpfile cur "$2" "$RELDIFF_JQ"; }
diff_issues()   { jq -n --slurpfile base "$1" --slurpfile cur "$2" "$ISSUEDIFF_JQ"; }

build_repo_json() { # gap_file prdiff_file(or "") reldiff_file(or "") relcur_file census_file issuegap_file(or "") issuediff_file(or "") -> combined repo JSON
  # repo.validation is the deterministic union of the PR census validation, the
  # board<->PR coverage validation, and the board<->issue coverage validation.
  local issuegap_json issuediff_json
  issuegap_json="$([ -n "${6:-}" ] && cat "$6" || echo null)"
  issuediff_json="$([ -n "${7:-}" ] && cat "$7" || echo null)"
  jq -n \
     --slurpfile gap "$1" \
     --slurpfile relcur "$4" \
     --slurpfile census "$5" \
     --argjson prd "$([ -n "$2" ] && cat "$2" || echo null)" \
     --argjson rld "$([ -n "$3" ] && cat "$3" || echo null)" \
     --argjson igap "$issuegap_json" \
     --argjson idiff "$issuediff_json" \
     '
      def norm($v): ($v // {ok:true, errors:[], warnings:[]});
      (norm($census[0].validation)) as $cv
      | (norm($gap[0].validation)) as $gv
      | (norm($igap.validation)) as $iv
      | ([$cv.errors[], $gv.errors[], $iv.errors[]]
          | unique_by([.code,(.context|tostring)])
          | sort_by(.code,(.context|tostring))) as $errors
      | ([$cv.warnings[], $gv.warnings[], $iv.warnings[]]
          | unique_by([.code,(.context|tostring)])
          | sort_by(.code,(.context|tostring))) as $warnings
      | { gap: $gap[0],
          issue_gap: $igap,
          pr_diff: $prd,
          issue_diff: $idiff,
          rel: { latest_shipped: ([ $relcur[0][] | select((.isDraft|not) and (.isPrerelease|not)) ] | sort_by(.publishedAt // "") | last),
                 new_releases: ($rld.new_releases // []) },
          validation: {ok:(($errors|length)==0), errors:$errors, warnings:$warnings} }'
}

# Fetch ENDPOINT via `gh api`, allowing MAX_ATTEMPTS tries (required items get
# two, optional items one). Prints the response JSON on success; on exhaustion
# returns 1 with the final attempt's stderr text left in ERR_FILE.
fetch_dependency_endpoint() { # endpoint max_attempts err_file
  local endpoint="$1" max="$2" err_file="$3"
  local attempt=1 out
  while :; do
    if out="$(gh api "$endpoint" 2>"$err_file")"; then
      printf '%s' "$out"
      return 0
    fi
    [ "$attempt" -lt "$max" ] || return 1
    attempt=$((attempt + 1))
  done
}

# Build the UNKNOWN placeholder for an unreachable registry item, preserving
# its configured metadata plus a structured fetchError.
unknown_dependency_record() { # item_json repo number endpoint attempts err_file
  local item="$1" repo="$2" number="$3" endpoint="$4" attempts="$5" err_file="$6"
  local message
  message="$(cat "$err_file" 2>/dev/null || true)"
  printf '%s' "$item" | jq -c \
    --arg repo "$repo" \
    --argjson number "$number" \
    --arg endpoint "$endpoint" \
    --argjson attempts "$attempts" \
    --arg message "$message" '
      {
        id: .id,
        repo: $repo,
        number: $number,
        type: "Unknown",
        title: "(unreachable dependency)",
        state: "UNKNOWN",
        isDraft: null,
        mergedAt: null,
        milestone: null,
        updatedAt: null,
        labels: [],
        url: ("https://github.com/" + $repo + "/issues/" + ($number|tostring)),
        theme: .theme,
        aiRefs: .aiRefs,
        note: .note,
        required: .required,
        fetchError: {
          code: "github-fetch-failed",
          endpoint: $endpoint,
          attempts: $attempts,
          message: $message
        }
      }'
}

fetch_dependencies() { # -> {items,validation}; every registry entry emits a record
  local registry
  registry="$(load_dependency_registry "$DEPS_FILE")" || return 1
  if ! jq -e '.validation.ok' >/dev/null 2>&1 <<<"$registry"; then
    # Invalid registry: make no GitHub requests; emit its diagnostics as-is.
    printf '%s\n' "$registry"
    return 0
  fi

  local reg_file items_file err_file
  reg_file="$(mktemp)"; items_file="$(mktemp)"; err_file="$(mktemp)"
  printf '%s\n' "$registry" > "$reg_file"

  local item id repo number max_attempts endpoint issue pr
  while IFS= read -r item; do
    # jq_lines for both: the id becomes a `gh api` endpoint (argv) and the
    # required flag is compared against a literal, so a trailing CR from a
    # text-mode jq would 404 the fetch and silently demote required items.
    id="$(jq_lines -r '.id' <<<"$item")"
    repo="${id%#*}"
    number="${id##*#}"
    if [ "$(jq_lines -r '.required' <<<"$item")" = true ]; then max_attempts=2; else max_attempts=1; fi

    endpoint="repos/$repo/issues/$number"
    if ! issue="$(fetch_dependency_endpoint "$endpoint" "$max_attempts" "$err_file")"; then
      printf 'warning: dependency %s unreachable (%s) — recording UNKNOWN\n' "$id" "$endpoint" >&2
      unknown_dependency_record "$item" "$repo" "$number" "$endpoint" "$max_attempts" "$err_file" >> "$items_file"
      continue
    fi
    if jq -e 'has("pull_request")' >/dev/null <<<"$issue"; then
      endpoint="repos/$repo/pulls/$number"
      if ! pr="$(fetch_dependency_endpoint "$endpoint" "$max_attempts" "$err_file")"; then
        printf 'warning: dependency %s unreachable (%s) — recording UNKNOWN\n' "$id" "$endpoint" >&2
        unknown_dependency_record "$item" "$repo" "$number" "$endpoint" "$max_attempts" "$err_file" >> "$items_file"
        continue
      fi
    else
      pr="null"
    fi
    # $issue/$pr are piped in as one JSON object on stdin, not passed via
    # --argjson: a large payload on the command line overflows the argv length
    # limit on Windows (Git Bash), aborting the census with "Argument list too
    # long". printf is a shell builtin, so building the object bypasses argv
    # entirely and behaves identically on every platform.
    printf '{"issue":%s,"pr":%s,"item":%s}' "$issue" "$pr" "$item" | jq -c \
      --arg repo "$repo" '
        .issue as $issue | .pr as $pr | .item as $it |
        def norm_state:
          if $pr != null and ($pr.merged == true) then "MERGED"
          else (($issue.state // "unknown") | ascii_upcase)
          end;
        {
          id: $it.id,
          repo: $repo,
          number: ($issue.number | tonumber),
          type: (if $pr != null then "PullRequest" else "Issue" end),
          title: $issue.title,
          state: norm_state,
          isDraft: (if $pr != null then ($pr.draft // false) else null end),
          mergedAt: (if $pr != null then $pr.merged_at else null end),
          milestone: $issue.milestone.title,
          updatedAt: $issue.updated_at,
          labels: [ $issue.labels[]?.name ],
          url: $issue.html_url,
          theme: $it.theme,
          aiRefs: $it.aiRefs,
          note: $it.note,
          required: $it.required
        }' >> "$items_file"
  done < <(jq_lines -c '.items[]' <<<"$registry")

  local merge_status=0
  jq -s --slurpfile registry "$reg_file" "$DEPS_VALIDATE_JQ" "$items_file" || merge_status=$?
  rm -f "$reg_file" "$items_file" "$err_file"
  return "$merge_status"
}

compute_dependency_diff() { # baseline_file current_file base_label cur_label
  jq -n --arg bl "$3" --arg cl "$4" \
        --slurpfile base "$1" --slurpfile cur "$2" "$DEPS_DIFF_JQ"
}

build_dependency_json() { # result_file({items,validation}) diff_file(or "")
  jq \
    --argjson diff "$([ -n "$2" ] && cat "$2" || echo null)" '
      .items as $items
      | {
          items: $items,
          summary: {
            total: ($items | length),
            by_repo: (reduce $items[] as $d ({}; .[$d.repo] = ((.[$d.repo] // 0) + 1))),
            by_state: (reduce $items[] as $d ({}; .[$d.state] = ((.[$d.state] // 0) + 1)))
          },
          diff: $diff,
          validation: .validation
        }' "$1"
}

latest_snap() { ls -1 "$SNAP_DIR/$1"-*.json 2>/dev/null | sort | tail -1 || true; }

# ----------------------------- arg parsing ----------------------------------
case "${1:-}" in
  -h|--help) usage ;;
  fetch) need gh; need jq; fetch_normalized; exit 0 ;;
  diff)
    need jq
    [ $# -eq 3 ] || die "usage: $0 diff <baseline.json> <current.json>"
    [ -f "$2" ] || die "no such file: $2"; [ -f "$3" ] || die "no such file: $3"
    compute_diff "$2" "$3" "$(basename "$2")" "$(basename "$3")" | jq -r "$RENDER_JQ"
    exit 0 ;;
  census) need gh; need jq
    shift
    while [ $# -gt 0 ]; do
      case "$1" in
        --strict) STRICT=1 ;;
        *) die "usage: $0 census [--strict]" ;;
      esac
      shift
    done
    tr="$(mktemp)"
    fetch_repository_censuses >"$tr"
    census_json="$(jq -n --arg primary "$REPO" --slurpfile c "$tr" '
      ($c[0].repositories | map(select(.repo==$primary)) | first) as $primary_census
      | {
          open_prs:($primary_census.open_prs // []),
          releases:($primary_census.releases // []),
          repositories:$c[0].repositories,
          validation:$c[0].validation
        }')"
    rm -f "$tr"
    printf '%s\n' "$census_json"
    if [ "$STRICT" = 1 ] && ! jq -e '.validation.ok' >/dev/null <<<"$census_json"; then
      exit 2
    fi
    exit 0 ;;
  dependencies) need gh; need jq
    shift
    DEP_OUT=markdown
    while [ $# -gt 0 ]; do
      case "$1" in
        --strict) STRICT=1 ;;
        --json) DEP_OUT=json ;;
        --markdown|--md) DEP_OUT=markdown ;;
        *) die "usage: $0 dependencies [--strict] [--json|--markdown]" ;;
      esac
      shift
    done
    td="$(mktemp)"
    fetch_dependencies > "$td"
    dep_json="$(build_dependency_json "$td" "")"
    rm -f "$td"
    case "$DEP_OUT" in
      json) printf '%s\n' "$dep_json" ;;
      markdown) jq -r "$RENDER_DEPS_JQ" <<<"$dep_json" ;;
    esac
    # Human diagnostics go to stderr in every output mode; markdown otherwise
    # exits 2 with no stated reason.
    jq -r '
      (.validation.errors[]? | "validation error: \(.code): \(.message) \(.context|tostring)"),
      (.validation.warnings[]? | "validation warning: \(.code): \(.message) \(.context|tostring)")
    ' <<<"$dep_json" >&2
    if [ "$STRICT" = 1 ] && ! jq -e '.validation.ok' >/dev/null <<<"$dep_json"; then
      exit 2
    fi
    exit 0 ;;
  gap) need jq
    shift
    if [ "${1:-}" = "--strict" ]; then STRICT=1; shift; fi
    [ $# -eq 2 ] || die "usage: $0 gap [--strict] <board.json> <prs.json>"
    [ -f "$1" ] || die "no such file: $1"; [ -f "$2" ] || die "no such file: $2"
    gap_json="$(board_pr_gap "$1" "$2")" || die "gap: could not read board/PR snapshots"
    printf '%s\n' "$gap_json"
    if [ "$STRICT" = 1 ] && ! jq -e '.validation.ok' >/dev/null <<<"$gap_json"; then
      exit 2
    fi
    exit 0 ;;
  prdiff) need jq
    [ $# -eq 3 ] || die "usage: $0 prdiff <base-prs.json> <cur-prs.json>"
    [ -f "$2" ] || die "no such file: $2"; [ -f "$3" ] || die "no such file: $3"
    diff_prs "$2" "$3"; exit 0 ;;
  reldiff) need jq
    [ $# -eq 3 ] || die "usage: $0 reldiff <base-rel.json> <cur-rel.json>"
    [ -f "$2" ] || die "no such file: $2"; [ -f "$3" ] || die "no such file: $3"
    diff_releases "$2" "$3"; exit 0 ;;
  issuediff) need jq
    [ $# -eq 3 ] || die "usage: $0 issuediff <base-issues.json> <cur-issues.json>"
    [ -f "$2" ] || die "no such file: $2"; [ -f "$3" ] || die "no such file: $3"
    diff_issues "$2" "$3"; exit 0 ;;
esac

while [ $# -gt 0 ]; do
  case "$1" in
    --save) SAVE=1 ;;
    --update-changelog) UPDATE_CHANGELOG=1 ;;
    --strict) STRICT=1 ;;
    --markdown|--md) OUT_MODE=markdown ;;
    --json) OUT_MODE=json ;;
    --no-repo) DO_REPO=0 ;;
    --no-deps|--no-dependencies) DO_DEPS=0 ;;
    --baseline) shift; BASELINE_OVERRIDE="${1:-}"; [ -n "$BASELINE_OVERRIDE" ] || die "--baseline needs a file"; [ -f "$BASELINE_OVERRIDE" ] || die "--baseline: no such file: $BASELINE_OVERRIDE" ;;
    -h|--help) usage ;;
    *) die "unknown option: $1 (try -h)" ;;
  esac
  shift
done

# ----------------------------- main -----------------------------------------
need gh; need jq
mkdir -p "$SNAP_DIR"

TMP_CUR=""; DIFF_FILE=""; TMP_PR_CENSUS=""; TMP_PRS=""; TMP_REL=""; TMP_DEPS=""
TMP_REPOSITORY_CENSUS=""; TMP_REPO_DIR=""; REPOSITORIES_JSON=""
PRIMARY_REPO_AVAILABLE=0
PRIMARY_ISSUES=""
REPO_FAILED=0; DEPS_FAILED=0
cleanup() { rm -f "$TMP_CUR" "$DIFF_FILE" "$TMP_PR_CENSUS" "$TMP_PRS" "$TMP_REL" "$TMP_DEPS" "$TMP_REPOSITORY_CENSUS"; [ -n "$TMP_REPO_DIR" ] && rm -rf "$TMP_REPO_DIR"; return 0; }
trap cleanup EXIT

TMP_REPO_DIR="$(mktemp -d)"
TMP_CUR="$(mktemp)"
fetch_normalized > "$TMP_CUR"
CUR_LABEL="live@$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Repository censuses are fetched independently and fail soft. Only the primary
# repository is joined to Project #240; auxiliary repositories are activity
# radars and never create roadmap-coverage errors.
if [ "$DO_REPO" = 1 ]; then
  TMP_REPOSITORY_CENSUS="$(mktemp)"
  if fetch_repository_censuses >"$TMP_REPOSITORY_CENSUS" 2>/dev/null; then
    build_repository_reports "$TMP_REPOSITORY_CENSUS" "$TMP_REPO_DIR" \
      >"$TMP_REPO_DIR/repositories.json"
    REPOSITORIES_JSON="$TMP_REPO_DIR/repositories.json"
    if jq -e --arg repo "$REPO" \
      '.repositories[] | select(.repo==$repo and .available)' \
      "$TMP_REPOSITORY_CENSUS" >/dev/null; then
      PRIMARY_REPO_AVAILABLE=1
      TMP_PRS="$TMP_REPO_DIR/prs-$REPO_SLUG-current.json"
      TMP_REL="$TMP_REPO_DIR/releases-$REPO_SLUG-current.json"
      # build_repository_reports only writes this when the issue census
      # succeeded, so its presence is the signal that issue coverage is joinable.
      [ ! -f "$TMP_REPO_DIR/issues-$REPO_SLUG-current.json" ] \
        || PRIMARY_ISSUES="$TMP_REPO_DIR/issues-$REPO_SLUG-current.json"
      TMP_PR_CENSUS="$(mktemp)"
      jq --arg repo "$REPO" '
        .repositories[] | select(.repo==$repo)
        | {items:.open_prs,validation:.validation}
      ' "$TMP_REPOSITORY_CENSUS" >"$TMP_PR_CENSUS"
    else
      echo "warning: primary repository census for $REPO is unavailable — continuing with other repository reports." >&2
    fi
  else
    echo "warning: repository censuses failed — continuing with board report only." >&2
    DO_REPO=0
    REPO_FAILED=1
    rm -f "$TMP_REPOSITORY_CENSUS"
    TMP_REPOSITORY_CENSUS=""
  fi
fi

# dependency watchlist (default-on; fail-soft so the board pipeline never regresses)
if [ "$DO_DEPS" = 1 ]; then
  TMP_DEPS="$(mktemp)"
  if fetch_dependencies > "$TMP_DEPS" 2>/dev/null; then :; else
    echo "warning: dependency watchlist fetch failed — continuing with board report only." >&2
    DO_DEPS=0; DEPS_FAILED=1; rm -f "$TMP_DEPS"; TMP_DEPS=""
  fi
fi

BASELINE="$BASELINE_OVERRIDE"
[ -n "$BASELINE" ] || BASELINE="$(latest_snap "proj$PROJECT")"

# First run (no board baseline yet): run the full pipeline against a self-diff
# so the report, validation, and strict gate all apply, then establish the
# baselines in the shared persistence block below.
FIRST_RUN=0
if [ -z "$BASELINE" ]; then
  FIRST_RUN=1
  BASE_LABEL="(first run)"
  BASELINE="$TMP_CUR"
else
  BASE_LABEL="$(basename "$BASELINE")"
fi

DIFF_FILE="$(mktemp)"
compute_diff "$BASELINE" "$TMP_CUR" "$BASE_LABEL" "$CUR_LABEL" > "$DIFF_FILE"

# assemble the repo report (gap is live; PR/release diffs only when a sibling baseline exists)
REPO_JSON=""; REPO_EXTRA=""; DEPS_JSON=""; DEPS_EXTRA=""
if [ "$PRIMARY_REPO_AVAILABLE" = 1 ]; then
  board_pr_gap "$TMP_CUR" "$TMP_PRS" > "$TMP_REPO_DIR/gap.json"
  PRDF=""; RLDF=""; IGAP=""; IDIFF=""
  [ ! -f "$TMP_REPO_DIR/prdiff-$REPO_SLUG.json" ] || PRDF="$TMP_REPO_DIR/prdiff-$REPO_SLUG.json"
  [ ! -f "$TMP_REPO_DIR/reldiff-$REPO_SLUG.json" ] || RLDF="$TMP_REPO_DIR/reldiff-$REPO_SLUG.json"
  [ ! -f "$TMP_REPO_DIR/issuediff-$REPO_SLUG.json" ] || IDIFF="$TMP_REPO_DIR/issuediff-$REPO_SLUG.json"
  # Issue coverage is joined for the primary repository only, and only when its
  # issue census succeeded — an unavailable census must not read as "no issues
  # are carded".
  if [ -n "$PRIMARY_ISSUES" ]; then
    board_issue_gap "$TMP_CUR" "$PRIMARY_ISSUES" > "$TMP_REPO_DIR/issue-gap.json"
    IGAP="$TMP_REPO_DIR/issue-gap.json"
  fi
  build_repo_json "$TMP_REPO_DIR/gap.json" "$PRDF" "$RLDF" "$TMP_REL" "$TMP_PR_CENSUS" "$IGAP" "$IDIFF" > "$TMP_REPO_DIR/repo.json"
  REPO_JSON="$TMP_REPO_DIR/repo.json"
  REPO_EXTRA="$(jq -r '", \(.gap.substantive|length) untracked PRs" + (if (.rel.new_releases|length)>0 then ", \(.rel.new_releases|length) new releases" else "" end)' "$REPO_JSON")"
fi

if [ "$DO_DEPS" = 1 ]; then
  jq '.items' "$TMP_DEPS" > "$TMP_REPO_DIR/dependencies-items.json"
  DEPS_BASE="$(latest_snap "$DEPS_SLUG")"
  DEPS_DIFF=""
  if [ -n "$DEPS_BASE" ]; then
    compute_dependency_diff "$DEPS_BASE" "$TMP_REPO_DIR/dependencies-items.json" "$(basename "$DEPS_BASE")" "$CUR_LABEL" > "$TMP_REPO_DIR/dependencies-diff.json"
    DEPS_DIFF="$TMP_REPO_DIR/dependencies-diff.json"
  fi
  build_dependency_json "$TMP_DEPS" "$DEPS_DIFF" > "$TMP_REPO_DIR/dependencies.json"
  DEPS_JSON="$TMP_REPO_DIR/dependencies.json"
  DEPS_EXTRA="$(jq -r 'if .diff == null then ", dependency watchlist baseline missing" else ", \((.diff.state_changed|length)+(.diff.added|length)+(.diff.removed|length)) dependency state/list changes" end' "$DEPS_JSON")"
fi

# Aggregate validation: deterministic union of the repo and dependency
# subsystem diagnostics, plus a stable marker when a fail-soft subsystem
# was unavailable entirely.
UNAVAILABLE="[]"
if [ "$REPO_FAILED" = 1 ]; then
  UNAVAILABLE="$(jq -c --arg repo "$REPO" '. + [{code:"repo-subsystem-unavailable",message:"Repository PR/release census unavailable",context:{repo:$repo}}]' <<<"$UNAVAILABLE")"
fi
if [ "$DEPS_FAILED" = 1 ]; then
  UNAVAILABLE="$(jq -c '. + [{code:"dependency-subsystem-unavailable",message:"Dependency watchlist unavailable",context:{}}]' <<<"$UNAVAILABLE")"
fi
AGG_FILE="$TMP_REPO_DIR/validation.json"
jq -n \
  --slurpfile r "${REPO_JSON:-/dev/null}" \
  --slurpfile c "${TMP_REPOSITORY_CENSUS:-/dev/null}" \
  --slurpfile d "${DEPS_JSON:-/dev/null}" \
  --argjson extra "$UNAVAILABLE" '
  def diagnostics($object):
    ($object.validation // {errors:[],warnings:[]});
  [diagnostics($r[0] // {}), diagnostics($c[0] // {}), diagnostics($d[0] // {})] as $parts
  | {
      errors: (([$parts[].errors[]] + $extra)
        | unique_by([.code,(.context|tostring)])
        | sort_by(.code,(.context|tostring))),
      warnings: ([$parts[].warnings[]]
        | unique_by([.code,(.context|tostring)])
        | sort_by(.code,(.context|tostring)))
    }
  | .ok=(.errors|length==0)
' > "$AGG_FILE"
# jq_lines: this is compared against the literal `true`, so a CR would make a
# clean report look like a strict failure.
VALIDATION_OK="$(jq_lines -r '.ok' "$AGG_FILE")"

case "$OUT_MODE" in
  json)
    jq -n \
      --slurpfile b "$DIFF_FILE" \
      --slurpfile r "${REPO_JSON:-/dev/null}" \
      --slurpfile repos "${REPOSITORIES_JSON:-/dev/null}" \
      --slurpfile d "${DEPS_JSON:-/dev/null}" \
      --slurpfile v "$AGG_FILE" \
      '{board:$b[0]}
       + (if ($r|length)>0 then {repo:$r[0]} else {} end)
       + (if ($repos|length)>0 then {repositories:$repos[0]} else {} end)
       + (if ($d|length)>0 then {dependencies:$d[0]} else {} end)
       + {validation:$v[0]}' ;;
  *)
    jq -r "$RENDER_JQ" "$DIFF_FILE"
    if [ -n "$REPO_JSON" ]; then jq -r "$RENDER_REPO_JQ" "$REPO_JSON"; fi
    if [ -n "$REPOSITORIES_JSON" ]; then jq -r --arg primary "$REPO" "$RENDER_REPOSITORIES_JQ" "$REPOSITORIES_JSON"; fi
    if [ -n "$DEPS_JSON" ]; then jq -r "$RENDER_DEPS_JQ" "$DEPS_JSON"; fi ;;
esac

# Human diagnostics go to stderr so stdout stays a pure report/JSON stream.
jq -r '
  (.errors[] | "validation error: \(.code): \(.message) \(.context|tostring)"),
  (.warnings[] | "validation warning: \(.code): \(.message) \(.context|tostring)")
' "$AGG_FILE" >&2

# Strict gate: report first, then refuse all persistence (including first-run
# baseline establishment) on audit violations.
if [ "$STRICT" = 1 ] && [ "$VALIDATION_OK" != true ]; then
  if [ "$SAVE" = 1 ] || [ "$FIRST_RUN" = 1 ]; then
    printf 'persistence skipped: strict validation failed\n' >&2
  fi
  [ "$UPDATE_CHANGELOG" = 0 ] || printf 'changelog skipped: strict validation failed\n' >&2
  exit 2
fi

[ "$UPDATE_CHANGELOG" = 1 ] && append_changelog "$DIFF_FILE" "$BASE_LABEL" "$REPO_EXTRA$DEPS_EXTRA"

if [ "$SAVE" = 1 ] || [ "$FIRST_RUN" = 1 ]; then
  TS="$(date -u +%Y%m%dT%H%M%SZ)"
  SNAP_VERB="Saved snapshot"
  [ "$FIRST_RUN" = 0 ] || SNAP_VERB="Baseline established"
  DEST="$SNAP_DIR/proj$PROJECT-$TS.json"; cp "$TMP_CUR" "$DEST"
  # Status messages go to stderr so stdout stays pure report/JSON — otherwise
  # `--json --save` appends these plain-text lines after the JSON and any
  # downstream `jq` consumer chokes on the trailing garbage.
  echo "$SNAP_VERB: $DEST (now the baseline for next run)." >&2
  if [ -n "$REPOSITORIES_JSON" ]; then
    while IFS= read -r tracked_repo; do
      tracked_slug="${tracked_repo//\//-}"
      cp "$TMP_REPO_DIR/prs-$tracked_slug-current.json" "$SNAP_DIR/prs-$tracked_slug-$TS.json"
      cp "$TMP_REPO_DIR/releases-$tracked_slug-current.json" "$SNAP_DIR/releases-$tracked_slug-$TS.json"
      # An unavailable issue census leaves no current file, so its previous
      # baseline survives untouched — writing [] over it would report every
      # issue closed on the next run.
      if [ -f "$TMP_REPO_DIR/issues-$tracked_slug-current.json" ]; then
        cp "$TMP_REPO_DIR/issues-$tracked_slug-current.json" "$SNAP_DIR/issues-$tracked_slug-$TS.json"
        echo "$SNAP_VERB (repo): prs-$tracked_slug-$TS.json, issues-$tracked_slug-$TS.json, releases-$tracked_slug-$TS.json." >&2
      else
        echo "$SNAP_VERB (repo): prs-$tracked_slug-$TS.json, releases-$tracked_slug-$TS.json (issue snapshot skipped: census unavailable)." >&2
      fi
    done < <(jq_lines -r '.[] | select(.available) | .repo' "$REPOSITORIES_JSON")
  fi
  if [ "$DO_DEPS" = 1 ]; then
    # Registry removal is the only thing that may remove a dependency from
    # history: an invalid registry yields items:[], and persisting that would
    # wipe the watchlist baseline. UNKNOWN placeholders (complete item set)
    # remain saveable per the design.
    if jq -e '[.validation.errors[]?.code] | index("dependency-registry-invalid") == null' "$TMP_DEPS" >/dev/null; then
      jq '.items' "$TMP_DEPS" > "$SNAP_DIR/$DEPS_SLUG-$TS.json"
      echo "$SNAP_VERB (dependencies): $DEPS_SLUG-$TS.json." >&2
    else
      echo "dependency snapshot skipped: registry invalid — keeping the previous baseline." >&2
    fi
  fi
fi

exit 0
