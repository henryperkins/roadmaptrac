#!/usr/bin/env bash
#
# wp-ai-roadmap-refresh.sh — re-pull the WordPress AI Planning & Roadmap board
# (GitHub org project #240) and report what changed since the last snapshot.
#
# Companion to wordpress-ai-roadmap.md / -open-issues.md / -planned-work.md.
#
# Also runs a repo-level census (open PRs + releases) so drift the board doesn't
# track — open PRs not on the board, new releases — is surfaced automatically.
#
# USAGE
#   ./wp-ai-roadmap-refresh.sh                 # fetch live, diff vs latest snapshot, print report
#                                              #   (board + repo PR/release census; first run: establishes baselines)
#   ./wp-ai-roadmap-refresh.sh --save          # ...and persist the new snapshots (board + repo) as the next baseline
#   ./wp-ai-roadmap-refresh.sh --update-changelog  # ...and append a dated row to the planned-work doc
#   ./wp-ai-roadmap-refresh.sh --no-repo       # board only — skip the repo PR/release census
#   ./wp-ai-roadmap-refresh.sh --no-deps       # skip the Gutenberg / abilities-api dependency watchlist
#   ./wp-ai-roadmap-refresh.sh --markdown      # report as Markdown (default is the same, terminal-friendly)
#   ./wp-ai-roadmap-refresh.sh --json          # emit the raw diff as JSON ({board,repo,dependencies})
#   ./wp-ai-roadmap-refresh.sh --baseline F    # diff live against snapshot file F instead of the latest
#   ./wp-ai-roadmap-refresh.sh fetch           # print a normalized board snapshot to stdout
#   ./wp-ai-roadmap-refresh.sh census          # print the repo {open_prs, releases} census to stdout
#   ./wp-ai-roadmap-refresh.sh dependencies    # print the Gutenberg / abilities-api dependency watchlist
#   ./wp-ai-roadmap-refresh.sh dependencies --json
#   ./wp-ai-roadmap-refresh.sh diff A.json B.json      # diff two board snapshots (offline; for testing)
#   ./wp-ai-roadmap-refresh.sh gap B.json P.json       # board<->repo PR gap from board + prs snapshots (offline)
#   ./wp-ai-roadmap-refresh.sh prdiff A.json B.json    # diff two prs snapshots (offline)
#   ./wp-ai-roadmap-refresh.sh reldiff A.json B.json   # diff two releases snapshots (offline)
#   ./wp-ai-roadmap-refresh.sh -h
#
# REQUIREMENTS
#   gh (authenticated) and jq. The board query needs the `read:project` scope;
#   the repo census (gh pr/release list) needs only normal `repo` read.
#     Grant project scope once with:  gh auth refresh -h github.com -s read:project
#
# ENV OVERRIDES
#   WP_AI_ORG (default WordPress)  WP_AI_PROJECT (default 240)
#   WP_AI_REPO (default WordPress/ai; primary repo for the PR/release census)
#   WP_AI_SNAP_DIR (default <script dir>/.wp-ai-roadmap-snapshots)
#   WP_AI_DOC_DIR  (default <script dir>; where the *.md docs live)
#   WP_AI_DEPS_SLUG (default wordpress-ai-cross-repo-dependencies; snapshot filename prefix)
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
DEPS_SLUG="${WP_AI_DEPS_SLUG:-wordpress-ai-cross-repo-dependencies}"

SAVE=0
UPDATE_CHANGELOG=0
OUT_MODE=text          # text | markdown | json
BASELINE_OVERRIDE=""
DO_REPO=1              # repo PR/release census runs by default; --no-repo disables it
DO_DEPS=1              # cross-repo dependency watchlist runs by default; --no-deps disables it

# ----------------------------- helpers --------------------------------------
die() { printf 'error: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "'$1' not found in PATH"; }

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
# Normalize `gh pr list --json ...` -> compact records; parse referenced issues
# from title + body + branch name (#NNN, "issue NNN", "issue-NNN", "issue #NNN").
PR_NORMALIZE_JQ='
  def refs($s): [ $s | match("(?i)(?:(?:^|[^\\w/-])#|\\b(?:issue|feature|feat)[ :_#-]*)(\\d+)"; "g") | .captures[0].string | tonumber ];
  map({
    id: ($repo + "#" + (.number|tostring)),
    number: .number,
    title: .title,
    isDraft: .isDraft,
    author: (.author.login // "?"),
    isBot: (.author.is_bot // false),
    routine: ( (.author.is_bot // false)
               or ((.author.login // "") | test("dependabot"; "i"))
               or ((.title // "") | test("^(fix\\(deps\\)|build\\(deps\\)|chore\\(deps\\)|ci:)"; "i")) ),
    issues: ( refs( ((.title // "") + " " + (.body // "") + " " + (.headRefName // "")) ) | unique ),
    updatedAt: .updatedAt
  }) | sort_by(.number)'

# Normalize `gh release list --json ...` -> compact records (oldest..newest).
REL_NORMALIZE_JQ='
  map({ tag: .tagName, name: .name, isDraft: .isDraft, isPrerelease: .isPrerelease, publishedAt: .publishedAt })
  | sort_by(.publishedAt // "")'

# board snapshot ($board[0]) + normalized PRs ($prs[0]) -> board<->repo gap.
GAP_JQ='
  ($board[0]) as $B | ($prs[0]) as $P
  | ([ $B[] | select(.type=="PullRequest" and .repo==$repo) ]) as $boardprs
  | ([ $boardprs[] | .number ]) as $boardpr
  | ([ $boardprs[] | select(.state=="OPEN") | .number ]) as $board_open_pr
  | ([ $boardprs[] | select(.status!="Done") | .number ]) as $board_non_done_pr
  | (reduce ($B[] | select(.type=="Issue" and .repo==$repo)) as $i
       ({}; .[$i.number|tostring] = {status:$i.status, milestone:$i.milestone})) as $iss
  | {
      repo: $repo,
      open_total: ($P|length),
      board_pr_cards_total: ($boardpr|length),
      board_pr_cards: ($board_open_pr|length),
      board_non_done_pr_cards: ($board_non_done_pr|length),
      untracked: [ $P[]
        | select(.number as $n | ($boardpr|index($n)) == null)
        | { id, number, title, isDraft, routine,
            issues: [ .issues[]
              | { number: .,
                  onBoard: ($iss[(.|tostring)] != null),
                  status: ($iss[(.|tostring)]|.status?),
                  milestone: ($iss[(.|tostring)]|.milestone?) } ] } ]
    }
  | .substantive = [ .untracked[] | select(.routine|not) ]
  | .routine_count = ([ .untracked[] | select(.routine) ] | length)
  | .tracked_open = (.open_total - (.untracked|length))'

# diff two normalized PR arrays -> opened / no-longer-open.
PRDIFF_JQ='
  ($base[0]) as $B | ($cur[0]) as $C
  | ([ $B[].number ]) as $bn | ([ $C[].number ]) as $cn
  | { newly_opened:   [ $C[] | select(.number as $n | ($bn|index($n))==null) | {number,title,isDraft} ],
      no_longer_open: [ $B[] | select(.number as $n | ($cn|index($n))==null) | {number,title} ] }'

# diff two normalized release arrays -> new releases.
RELDIFF_JQ='
  ($base[0]) as $B | ($cur[0]) as $C
  | ([ $B[].tag ]) as $bt
  | { new_releases: [ $C[] | select(.tag as $t | ($bt|index($t))==null)
                      | {tag,name,publishedAt,isDraft,isPrerelease} ] }'

# render the combined repo report object -> text sections + copy-paste block.
RENDER_REPO_JQ='
  def fmt(a; f): [ a[] | f ] | join("\n");
  def imap(iss): [ iss[] | "#\(.number)" + (if .onBoard then " (board: \(.status // "—")/\(.milestone // "—"))" else " (not on board)" end) ] | join(", ");
  "",
  "## 📦 Releases (repo: \(.gap.repo))",
  ( if .rel.latest_shipped then "Latest shipped: **\(.rel.latest_shipped.tag)** (\((.rel.latest_shipped.publishedAt // "")[0:10]))" else "Latest shipped: (none found)" end ),
  ( if (.rel.new_releases|length)>0 then "New since baseline: " + ([ .rel.new_releases[] | "\(.tag) (\((.publishedAt // "")[0:10]))" ] | join(", ")) else empty end ),
  "",
  "## 🔌 Repo open PRs not on board: \(.gap.untracked|length) of \(.gap.open_total) open (\(.gap.substantive|length) substantive + \(.gap.routine_count) routine; \(.gap.tracked_open) board-tracked)",
  ( if (.gap.substantive|length)>0
     then fmt(.gap.substantive; "- " + (if .isDraft then "(draft) " else "" end) + "#\(.number) \(.title)" + (if (.issues|length)>0 then " → " + imap(.issues) else " → (no issue ref parsed)" end))
     else "_(none — board covers all substantive open PRs)_" end ),
  ( if (.pr_diff != null) and (((.pr_diff.newly_opened|length)>0) or ((.pr_diff.no_longer_open|length)>0))
     then "",
          "## 🆕 PR census changes",
          ( if (.pr_diff.newly_opened|length)>0   then "Newly opened: "                  + ([ .pr_diff.newly_opened[]   | "#\(.number)" ] | join(", ")) else empty end ),
          ( if (.pr_diff.no_longer_open|length)>0 then "No longer open (merged/closed): " + ([ .pr_diff.no_longer_open[] | "#\(.number)" ] | join(", ")) else empty end )
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
      + (if (.issues|length)>0 then ([ .issues[] | "#\(.number)" ] | join(", ")) else "—" end) + " | "
      + (if (.issues|length)>0 then ([ .issues[] | (if .onBoard then "\(.status // "—")/\(.milestone // "—")" else "not on board" end) ] | join("; ")) else "—" end)
      + " |"),
  "```"'

# Cross-repo dependency watchlist for roadmap-critical Gutenberg and
# abilities-api items. Whole-repo Gutenberg tracking is intentionally avoided:
# that repository is too broad for a useful roadmap signal.
dependency_watchlist() {
  cat <<'EOF'
WordPress/gutenberg#70710|Platform / workflows|#21,#40,#430|Abilities and Workflows overview for Command Palette and AI tool surfaces
WordPress/gutenberg#74234|Platform / core abilities|#40|Core post-management abilities implementation
WordPress/gutenberg#77230|Skills / Guidelines|#430|Guidelines CPT evolution toward skills, memory, and plans
WordPress/gutenberg#77643|Skills / Guidelines|#430|Guidelines public API extraction
WordPress/gutenberg#75221|Media / focal point|#238|Media-level focal point selector for AI crop suggestions
WordPress/gutenberg#72734|Media Editor|#325|Dedicated media editor foundation
WordPress/gutenberg#73771|Media Editor|#238,#325|Media Editor modal task tracking and extension surface
WordPress/gutenberg#77994|Media Editor|#325|Media Editor route and modal component refactor
WordPress/gutenberg#74572|Admin UX / DataViews|#741|DataViews flicker fix used as a reference for AI admin flicker
WordPress/gutenberg#16549|Admin UX / accessibility|#699|Snackbar accessibility caveat for copy-feedback UI
WordPress/gutenberg#77816|Admin UX / toast component|#699|Toast component direction related to snackbar replacement
WordPress/abilities-api#38|Ability registry filtering|#21,#354|Filter registered abilities by namespace, category, and metadata
WordPress/abilities-api#62|Ability safety metadata|#40|Hints for destructive, read-only, and idempotent abilities
WordPress/abilities-api#84|Core CRUD abilities|#40|CRUD abilities that work across post types
WordPress/abilities-api#105|Core abilities scope|#40|Core Abilities for WordPress 6.9
WordPress/abilities-api#106|Ability metadata|#40|Determine what belongs in Ability meta
EOF
}

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
  ( fmt([ .items[] | select(.state == "OPEN") ];
      "- `\(.id)` (\(.type)) — \(.title)  _[\(.theme); AI refs: \(.aiRefs|join(", "))]_") // "_(none)_" )'

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
fetch_open_prs() { # -> normalized open-PR array for $REPO
  gh pr list --repo "$REPO" --state open \
     --json number,title,isDraft,author,headRefName,labels,body,updatedAt --limit 300 \
  | jq --arg repo "$REPO" "$PR_NORMALIZE_JQ"
}

fetch_releases() { # -> normalized release array for $REPO
  gh release list --repo "$REPO" \
     --json tagName,name,isDraft,isPrerelease,publishedAt --limit 30 \
  | jq "$REL_NORMALIZE_JQ"
}

board_pr_gap() { # board_file prs_file -> gap JSON
  jq -n --arg repo "$REPO" --slurpfile board "$1" --slurpfile prs "$2" "$GAP_JQ"
}

diff_prs()      { jq -n --slurpfile base "$1" --slurpfile cur "$2" "$PRDIFF_JQ"; }
diff_releases() { jq -n --slurpfile base "$1" --slurpfile cur "$2" "$RELDIFF_JQ"; }

build_repo_json() { # gap_file prdiff_file(or "") reldiff_file(or "") relcur_file -> combined repo JSON
  jq -n \
     --slurpfile gap "$1" \
     --slurpfile relcur "$4" \
     --argjson prd "$([ -n "$2" ] && cat "$2" || echo null)" \
     --argjson rld "$([ -n "$3" ] && cat "$3" || echo null)" \
     '{ gap: $gap[0],
       pr_diff: $prd,
        rel: { latest_shipped: ([ $relcur[0][] | select((.isDraft|not) and (.isPrerelease|not)) ] | sort_by(.publishedAt // "") | last),
               new_releases: ($rld.new_releases // []) } }'
}

fetch_dependencies() {
  local spec theme ai_refs note repo number issue pr
  while IFS='|' read -r spec theme ai_refs note; do
    [ -n "${spec:-}" ] || continue
    case "$spec" in \#*) continue ;; esac
    repo="${spec%#*}"
    number="${spec##*#}"
    # Tolerate a rotten pin: a watchlist issue that was deleted/transferred (404)
    # or a transient gh failure drops only itself (with a warning), instead of
    # aborting the whole census (dependencies subcommand) or silently vanishing
    # from the report (default run, where set -e is suppressed by the if-guard).
    if ! issue="$(gh api "repos/$repo/issues/$number" 2>/dev/null)"; then
      printf 'warning: watchlist item %s unreachable — skipping\n' "$spec" >&2
      continue
    fi
    if jq -e 'has("pull_request")' >/dev/null <<<"$issue"; then
      if ! pr="$(gh api "repos/$repo/pulls/$number" 2>/dev/null)"; then
        printf 'warning: watchlist item %s (PR) unreachable — skipping\n' "$spec" >&2
        continue
      fi
    else
      pr="null"
    fi
    jq -n \
      --arg spec "$spec" \
      --arg repo "$repo" \
      --arg theme "$theme" \
      --arg ai_refs "$ai_refs" \
      --arg note "$note" \
      --argjson issue "$issue" \
      --argjson pr "$pr" '
        def norm_state:
          if $pr != null and ($pr.merged == true) then "MERGED"
          else (($issue.state // "unknown") | ascii_upcase)
          end;
        {
          id: $spec,
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
          theme: $theme,
          aiRefs: ($ai_refs | split(",") | map(select(length > 0))),
          note: $note
        }'
  done < <(dependency_watchlist) | jq -s 'sort_by(.repo, .number)'
}

compute_dependency_diff() { # baseline_file current_file base_label cur_label
  jq -n --arg bl "$3" --arg cl "$4" \
        --slurpfile base "$1" --slurpfile cur "$2" "$DEPS_DIFF_JQ"
}

build_dependency_json() { # current_file diff_file(or "")
  jq -n \
    --slurpfile cur "$1" \
    --argjson diff "$([ -n "$2" ] && cat "$2" || echo null)" '
      ($cur[0]) as $items
      | {
          items: $items,
          summary: {
            total: ($items | length),
            by_repo: (reduce $items[] as $d ({}; .[$d.repo] = ((.[$d.repo] // 0) + 1))),
            by_state: (reduce $items[] as $d ({}; .[$d.state] = ((.[$d.state] // 0) + 1)))
          },
          diff: $diff
        }'
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
    tp="$(mktemp)"; tl="$(mktemp)"
    fetch_open_prs > "$tp"; fetch_releases > "$tl"
    jq -n --slurpfile p "$tp" --slurpfile r "$tl" '{open_prs:$p[0], releases:$r[0]}'
    rm -f "$tp" "$tl"; exit 0 ;;
  dependencies) need gh; need jq
    td="$(mktemp)"
    fetch_dependencies > "$td"
    dep_json="$(build_dependency_json "$td" "")"
    rm -f "$td"
    case "${2:-}" in
      --json) printf '%s\n' "$dep_json" ;;
      ""|--markdown|--md) jq -r "$RENDER_DEPS_JQ" <<<"$dep_json" ;;
      *) die "usage: $0 dependencies [--json|--markdown]" ;;
    esac
    exit 0 ;;
  gap) need jq
    [ $# -eq 3 ] || die "usage: $0 gap <board.json> <prs.json>"
    [ -f "$2" ] || die "no such file: $2"; [ -f "$3" ] || die "no such file: $3"
    board_pr_gap "$2" "$3"; exit 0 ;;
  prdiff) need jq
    [ $# -eq 3 ] || die "usage: $0 prdiff <base-prs.json> <cur-prs.json>"
    [ -f "$2" ] || die "no such file: $2"; [ -f "$3" ] || die "no such file: $3"
    diff_prs "$2" "$3"; exit 0 ;;
  reldiff) need jq
    [ $# -eq 3 ] || die "usage: $0 reldiff <base-rel.json> <cur-rel.json>"
    [ -f "$2" ] || die "no such file: $2"; [ -f "$3" ] || die "no such file: $3"
    diff_releases "$2" "$3"; exit 0 ;;
esac

while [ $# -gt 0 ]; do
  case "$1" in
    --save) SAVE=1 ;;
    --update-changelog) UPDATE_CHANGELOG=1 ;;
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

TMP_CUR=""; DIFF_FILE=""; TMP_PRS=""; TMP_REL=""; TMP_DEPS=""; TMP_REPO_DIR=""
cleanup() { rm -f "$TMP_CUR" "$DIFF_FILE" "$TMP_PRS" "$TMP_REL" "$TMP_DEPS"; [ -n "$TMP_REPO_DIR" ] && rm -rf "$TMP_REPO_DIR"; return 0; }
trap cleanup EXIT

TMP_CUR="$(mktemp)"
fetch_normalized > "$TMP_CUR"
CUR_LABEL="live@$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# repo census (default-on; fail-soft so the board pipeline never regresses)
if [ "$DO_REPO" = 1 ]; then
  TMP_PRS="$(mktemp)"; TMP_REL="$(mktemp)"
  if fetch_open_prs > "$TMP_PRS" 2>/dev/null && fetch_releases > "$TMP_REL" 2>/dev/null; then :; else
    echo "warning: repo census (gh pr/release list for $REPO) failed — continuing with board report only." >&2
    DO_REPO=0; rm -f "$TMP_PRS" "$TMP_REL"; TMP_PRS=""; TMP_REL=""
  fi
fi

# dependency watchlist (default-on; fail-soft so the board pipeline never regresses)
if [ "$DO_DEPS" = 1 ]; then
  TMP_DEPS="$(mktemp)"
  if fetch_dependencies > "$TMP_DEPS" 2>/dev/null; then :; else
    echo "warning: dependency watchlist fetch failed — continuing with board report only." >&2
    DO_DEPS=0; rm -f "$TMP_DEPS"; TMP_DEPS=""
  fi
fi

BASELINE="$BASELINE_OVERRIDE"
[ -n "$BASELINE" ] || BASELINE="$(latest_snap "proj$PROJECT")"

# first run: establish baseline(s) and exit
if [ -z "$BASELINE" ]; then
  TS="$(date -u +%Y%m%dT%H%M%SZ)"
  cp "$TMP_CUR" "$SNAP_DIR/proj$PROJECT-$TS.json"
  echo "Baseline established: $SNAP_DIR/proj$PROJECT-$TS.json ($(jq length "$TMP_CUR") items)."
  if [ "$DO_REPO" = 1 ]; then
    cp "$TMP_PRS" "$SNAP_DIR/prs-$REPO_SLUG-$TS.json"
    cp "$TMP_REL" "$SNAP_DIR/releases-$REPO_SLUG-$TS.json"
    echo "Repo baselines established: prs-$REPO_SLUG-$TS.json, releases-$REPO_SLUG-$TS.json."
  fi
  if [ "$DO_DEPS" = 1 ]; then
    cp "$TMP_DEPS" "$SNAP_DIR/$DEPS_SLUG-$TS.json"
    echo "Dependency baseline established: $DEPS_SLUG-$TS.json."
  fi
  echo "Re-run later to see changes."
  exit 0
fi

DIFF_FILE="$(mktemp)"
compute_diff "$BASELINE" "$TMP_CUR" "$(basename "$BASELINE")" "$CUR_LABEL" > "$DIFF_FILE"

# assemble the repo report (gap is live; PR/release diffs only when a sibling baseline exists)
REPO_JSON=""; REPO_EXTRA=""; DEPS_JSON=""; DEPS_EXTRA=""
if [ "$DO_REPO" = 1 ]; then
  TMP_REPO_DIR="$(mktemp -d)"
  board_pr_gap "$TMP_CUR" "$TMP_PRS" > "$TMP_REPO_DIR/gap.json"
  PRDF=""; RLDF=""
  PRS_BASE="$(latest_snap "prs-$REPO_SLUG")"
  REL_BASE="$(latest_snap "releases-$REPO_SLUG")"
  if [ -n "$PRS_BASE" ]; then diff_prs      "$PRS_BASE" "$TMP_PRS" > "$TMP_REPO_DIR/prdiff.json";  PRDF="$TMP_REPO_DIR/prdiff.json"; fi
  if [ -n "$REL_BASE" ]; then diff_releases "$REL_BASE" "$TMP_REL" > "$TMP_REPO_DIR/reldiff.json"; RLDF="$TMP_REPO_DIR/reldiff.json"; fi
  build_repo_json "$TMP_REPO_DIR/gap.json" "$PRDF" "$RLDF" "$TMP_REL" > "$TMP_REPO_DIR/repo.json"
  REPO_JSON="$TMP_REPO_DIR/repo.json"
  REPO_EXTRA="$(jq -r '", \(.gap.substantive|length) untracked PRs" + (if (.rel.new_releases|length)>0 then ", \(.rel.new_releases|length) new releases" else "" end)' "$REPO_JSON")"
fi

if [ "$DO_DEPS" = 1 ]; then
  [ -n "$TMP_REPO_DIR" ] || TMP_REPO_DIR="$(mktemp -d)"
  DEPS_BASE="$(latest_snap "$DEPS_SLUG")"
  DEPS_DIFF=""
  if [ -n "$DEPS_BASE" ]; then
    compute_dependency_diff "$DEPS_BASE" "$TMP_DEPS" "$(basename "$DEPS_BASE")" "$CUR_LABEL" > "$TMP_REPO_DIR/dependencies-diff.json"
    DEPS_DIFF="$TMP_REPO_DIR/dependencies-diff.json"
  fi
  build_dependency_json "$TMP_DEPS" "$DEPS_DIFF" > "$TMP_REPO_DIR/dependencies.json"
  DEPS_JSON="$TMP_REPO_DIR/dependencies.json"
  DEPS_EXTRA="$(jq -r 'if .diff == null then ", dependency watchlist baseline missing" else ", \((.diff.state_changed|length)+(.diff.added|length)+(.diff.removed|length)) dependency state/list changes" end' "$DEPS_JSON")"
fi

case "$OUT_MODE" in
  json)
    if [ -n "$REPO_JSON" ] || [ -n "$DEPS_JSON" ]; then
      jq -n \
        --slurpfile b "$DIFF_FILE" \
        --slurpfile r "${REPO_JSON:-/dev/null}" \
        --slurpfile d "${DEPS_JSON:-/dev/null}" \
        '{board:$b[0]} + (if ($r|length)>0 then {repo:$r[0]} else {} end) + (if ($d|length)>0 then {dependencies:$d[0]} else {} end)'
    else
      cat "$DIFF_FILE"
    fi ;;
  *)
    jq -r "$RENDER_JQ" "$DIFF_FILE"
    if [ -n "$REPO_JSON" ]; then jq -r "$RENDER_REPO_JQ" "$REPO_JSON"; fi
    if [ -n "$DEPS_JSON" ]; then jq -r "$RENDER_DEPS_JQ" "$DEPS_JSON"; fi ;;
esac

[ "$UPDATE_CHANGELOG" = 1 ] && append_changelog "$DIFF_FILE" "$(basename "$BASELINE")" "$REPO_EXTRA$DEPS_EXTRA"

if [ "$SAVE" = 1 ]; then
  TS="$(date -u +%Y%m%dT%H%M%SZ)"
  DEST="$SNAP_DIR/proj$PROJECT-$TS.json"; cp "$TMP_CUR" "$DEST"
  # Status messages go to stderr so stdout stays pure report/JSON — otherwise
  # `--json --save` appends these plain-text lines after the JSON and any
  # downstream `jq` consumer chokes on the trailing garbage.
  echo "Saved snapshot: $DEST (now the baseline for next run)." >&2
  if [ "$DO_REPO" = 1 ]; then
    cp "$TMP_PRS" "$SNAP_DIR/prs-$REPO_SLUG-$TS.json"
    cp "$TMP_REL" "$SNAP_DIR/releases-$REPO_SLUG-$TS.json"
    echo "Saved repo snapshots: prs-$REPO_SLUG-$TS.json, releases-$REPO_SLUG-$TS.json." >&2
  fi
  if [ "$DO_DEPS" = 1 ]; then
    cp "$TMP_DEPS" "$SNAP_DIR/$DEPS_SLUG-$TS.json"
    echo "Saved dependency snapshot: $DEPS_SLUG-$TS.json." >&2
  fi
fi

exit 0
