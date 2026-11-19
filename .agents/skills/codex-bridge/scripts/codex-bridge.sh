#!/usr/bin/env bash
# Codex bridge wrapper. Some shells do not expand "node ~/..." but they expand "bash ...".
# Usage: bash .agents/skills/codex-bridge/scripts/codex-bridge.sh check
D="$(cd "$(dirname "$0")" && pwd)"
exec node "$D/codex-bridge.mjs" "$@"
