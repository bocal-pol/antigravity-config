#!/usr/bin/env bash
# skill-log.sh — PreToolUse hook (matcher: Skill)
#
# Deterministic log of skill invocations into logs/skill-selection.log.
#
# NOTE (unconfirmed Antigravity support): this hook's trigger contract was
# designed for a different assistant's tool-call lifecycle (JSON on stdin,
# tool_name and tool_input.skill / tool_input.args fields). See
# PORTING-NOTES.md. Kept as a best-effort artifact. Never blocks (exit 0),
# writes nothing to stderr.
set -uo pipefail

INPUT=$(cat)

SKILL=$(printf '%s' "$INPUT" | sed -n 's/.*"skill"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)
[ -z "$SKILL" ] && exit 0

ARGS=$(printf '%s' "$INPUT" | sed -n 's/.*"args"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1 | cut -c1-120)
PROJECT=$(basename "$(pwd)")
LOG="$HOME/.agents/logs/skill-selection.log"

mkdir -p "$(dirname "$LOG")" 2>/dev/null
printf '%s\tskill: %s\tproject: %s\targs: %s\n' \
  "$(date '+%Y-%m-%d %H:%M:%S')" "$SKILL" "$PROJECT" "$ARGS" >> "$LOG" 2>/dev/null

exit 0
