#!/usr/bin/env bash
#
# jq shim that reproduces native jq.exe on Windows: its stdout is in text mode,
# so every emitted LF becomes CRLF. Bash's `read` strips the \n but keeps the
# \r, which silently taints any value the script reads out of jq output.
#
# Put this on PATH as `jq` (ahead of the real one) to reproduce the Windows
# failure on Linux, where the real jq emits LF and the bug is invisible.
#
# WP_AI_TEST_REAL_JQ must be an absolute path to the genuine jq, resolved before
# PATH was shadowed -- otherwise this shim would re-invoke itself forever.
set -uo pipefail

real_jq="${WP_AI_TEST_REAL_JQ:?WP_AI_TEST_REAL_JQ must point at the real jq}"
cr=$'\r'

# Collapse any trailing CRs to exactly one, so the shim is idempotent whether
# the underlying jq already emits CRLF (Windows) or plain LF (Linux), and
# pipefail still surfaces jq's own exit status -- the script relies on `jq -e`
# returning 1 for false.
"$real_jq" "$@" | sed "s/${cr}*\$/${cr}/"
