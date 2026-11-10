#!/usr/bin/env bash
# pre-tool-use.sh — PreToolUse hook
#
# Three guard-rails:
#   1. No AI co-authorship in a commit message.
#   2. No direct push to a protected branch (main, develop), nor a force-push.
#   3. No bypassing of git hooks (--no-verify, -n on commit, or a hijacked
#      core.hooksPath).
#
# NOTE (unconfirmed Antigravity support): this hook's trigger contract was
# designed for a different assistant's tool-call lifecycle (JSON on stdin with
# `tool_name` and `tool_input.command` fields). Whether Antigravity invokes
# this script at all, and with what contract, is unverified — see
# PORTING-NOTES.md. Kept here as a best-effort artifact.
# Exit codes: 0 = no objection · 2 = BLOCKED, stderr returned to the caller.
set -uo pipefail

INPUT=$(cat)

TOOL=$(printf '%s' "$INPUT" | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
case "$TOOL" in
  Bash|PowerShell|"") ;;
  *) exit 0 ;;
esac

# ─── Isolate the actual command ───────────────────────────────────────────────
# `tool_input.command` is a JSON field — extracted so we only grep the
# command itself, never the raw JSON. Without this, a commit message that
# merely TALKS ABOUT a dangerous flag (e.g. a commit explaining why
# `--no-verify` is forbidden) gets blocked by the hook itself.
COMMAND=$(printf '%s' "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(\([^"\\]\|\\.\)*\)".*/\1/p')

# Strip any quoted content (single or double quotes): that is where commit
# messages live, and they must never be mistaken for flags of the command
# itself. Imperfect on a complex nested shell, but sufficient for the two
# patterns grepped below — not a full shell parser by design.
SCAN=$(printf '%s' "$COMMAND" | sed -E 's/"[^"]*"//g; s/'"'"'[^'"'"']*'"'"'//g')

# ─── 1. Co-authorship forbidden ───────────────────────────────────────────────
# Repository rule: a single author and contributor on every commit.
# This check deliberately stays on $INPUT (not $SCAN): the co-authorship to
# detect is precisely INSIDE the commit message, between quotes.
if printf '%s' "$INPUT" | grep -qiE 'co-authored-by[^"]*(claude|anthropic|gemini|antigravity)|generated with \['; then
  echo "Commit refused: it contains AI co-authorship." >&2
  echo "Cause: the repository convention enforces a single author." >&2
  echo "Fix: remove the Co-authored-by line and any generation mention." >&2
  exit 2
fi

# ─── 2. Protected branches and force-push ─────────────────────────────────────
# The separator allows a space and `:` (for `HEAD:main`) but not `/`, so a
# branch named `feature/main-...` is not blocked.
#
# `origin` is a required literal in this pattern, not optional: the rule
# targets the main repo remote, never a secondary mirror-replication remote a
# contributor might have configured locally — pushing main/develop to such a
# remote is exactly what a replication mechanism is supposed to do.
#
# Exemption: GIT_ALLOW_PROTECTED_PUSH=1, for history-maintenance operations
# explicitly approved by the user. Use this path rather than disabling the
# file.
PROTECTED='git[[:space:]]+push([^"]*)[[:space:]:]origin[[:space:]]+(-f[[:space:]]+|--force[[:space:]]+)?(main|develop)([[:space:]:"\\]|$)'
FORCE='git[[:space:]]+push([^"]*)(--force([[:space:]]|$)|--force-with-lease|[[:space:]]-f([[:space:]]|$))'

if [ "${GIT_ALLOW_PROTECTED_PUSH:-}" != "1" ]; then
  if printf '%s' "$SCAN" | grep -Eq "$PROTECTED"; then
    echo "Direct push to a protected branch (main, develop) refused." >&2
    echo "Cause: the repository convention reserves these branches for integration." >&2
    echo "Fix: create a feature/*, bugfix/*, or hotfix/* branch, then open a Pull Request." >&2
    echo "Intentional maintenance: rerun the command with GIT_ALLOW_PROTECTED_PUSH=1." >&2
    exit 2
  fi

  if printf '%s' "$SCAN" | grep -Eq "$FORCE"; then
    echo "Force-push refused." >&2
    echo "Cause: a force-push rewrites shared history and can erase a collaborator's work." >&2
    echo "Fix: if the rewrite is intentional, rerun with GIT_ALLOW_PROTECTED_PUSH=1." >&2
    exit 2
  fi
fi

# ─── 3. Bypassing git hooks ────────────────────────────────────────────────────
# `--no-verify` (commit/push), a standalone `-n` on `git commit` (the flag's
# short alias), and a hijacked `core.hooksPath=` via `-c` or `GIT_CONFIG_*`:
# three ways to silently disable pre-commit/commit-msg/pre-push.
NO_VERIFY='git[[:space:]]+(commit|push|merge|cherry-pick|rebase|am)([^"]*)(--no-verify|[[:space:]]-n([[:space:]]|$))'
HOOKS_PATH_OVERRIDE='core\.hookspath[[:space:]]*='

if [ "${GIT_ALLOW_PROTECTED_PUSH:-}" != "1" ]; then
  if printf '%s' "$SCAN" | grep -Eq "$NO_VERIFY"; then
    echo "Command refused: git hook bypass (--no-verify / -n)." >&2
    echo "Cause: this flag disables pre-commit, commit-msg, or pre-push silently." >&2
    echo "Fix: fix the hook failure's root cause rather than bypassing it." >&2
    echo "Intentional maintenance: rerun the command with GIT_ALLOW_PROTECTED_PUSH=1." >&2
    exit 2
  fi

  if printf '%s' "$SCAN" | grep -qiE "$HOOKS_PATH_OVERRIDE"; then
    echo "Command refused: core.hooksPath override." >&2
    echo "Cause: redirects git to a different hooks folder, bypassing the repository's own." >&2
    echo "Fix: do not modify core.hooksPath from an automated session." >&2
    echo "Intentional maintenance: rerun the command with GIT_ALLOW_PROTECTED_PUSH=1." >&2
    exit 2
  fi
fi

exit 0
