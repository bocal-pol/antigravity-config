# ADR 0026 — Global hooks (SessionStart, Stop, PreToolUse) in settings.json

- **Status**: accepted
- **Date**: 2026-08-21
- **Amended on**: 2026-09-17 — added `SessionStart`, undocumented until then; defense in depth with ADR 0058's `deny`

## Context

With no system hooks, nothing prevented an accidental `git push origin main`, skill-selection logs weren't rotated automatically at the end of a session, and cross-session memory wasn't reloaded at startup.

## Decision

Three systemic hooks in `settings.json`:

- **`SessionStart` (`memory.sh`)** — matcher `startup|clear|compact`: reloads cross-session memory at startup, after a `/clear`, and after a `/compact` — the three moments the context starts from scratch (see ADR 0024)
- **`PreToolUse` (`pre-tool-use.sh`)** — matcher `Bash|PowerShell`: intercepts tool calls before execution. Blocks pushes to `main`, `master`, and `develop`, force-pushes, and any Claude/Anthropic co-attribution in a commit message (ADR 0020), regardless of session or mode
- **`Stop` (`stop.sh`)** — run at the end of a session: closing reminders, `skill-selection.log` rotation, a list of uncommitted files

### Hook implementation contract

Claude Code passes hook context as **JSON on standard input** (`tool_name`, `tool_input.command`) —
there is no `CLAUDE_TOOL_NAME` environment variable. Only **`exit 2`** genuinely blocks the action;
`exit 1` is treated as a non-blocking error and lets it through. A hook that gets either of these two
points wrong fails silently: it blocks nothing and reports nothing.

### Explicit escape hatch

`GIT_ALLOW_PROTECTED_PUSH=1` lifts the push ban for the duration of a single command, for
maintenance operations approved by the user — creating the `develop` branch, for instance. This is
the path to take rather than disabling the file: it's traceable in the command and doesn't leave the
machine with no guardrail if someone forgets to restore it.

### Defense in depth with `permissions.deny`

The `PreToolUse` hook is **not the only safeguard**. `permissions.deny` blocks upstream, at the
permission level (ADR 0058):

```json
"deny": [
  "Bash(git push origin main*)",
  "Bash(git push origin master*)",
  "Bash(git push origin develop*)",
  "Bash(git push --force*)",
  "Bash(git push -f *)",
  "Read(**/.credentials.json)",
  "Read(**/.env)"
]
```

The two levels are complementary: `deny` covers the literal forms of the command, the hook covers bypasses via alternative syntax (`HEAD:main`, a renamed remote). Neither is sufficient alone.

## Positive consequences

- Double protection against direct pushes to protected branches: permission **and** hook
- The `deny` on `.credentials.json` and `.env` prevents reading secrets even on explicit request
- Logs rotate automatically — no log file growing without bound
- Memory is reloaded at the three moments the context restarts from scratch, including after `/compact`

## Negative consequences / risks

- The hooks are tied to the local machine — not portable as-is to other machines without an install script
- All three hooks depend on `bash`, even on a Windows machine: without Git Bash in `PATH`, they fail silently
- **The scripts live in `~/.claude/`, not in the repo.** Fixing a hook here changes nothing in behavior until it's deployed to both locations (ADR 0048). Observed on 2026-09-17: a hook fixed, tested, and committed while the old broken version kept running.
- `GIT_ALLOW_PROTECTED_PUSH=1` is a real escape hatch: it makes the ban bypassable by anyone who knows the variable. This is a deliberate trade-off — an explicit, traceable path beats disabling the file outright.
- The `deny` on `Read(**/.env)` also blocks legitimate reads of a misnamed `.env.example`, and forces routing through the user to diagnose a config

## Alternatives considered

- **Convention alone, no hook**: bypassable unintentionally. Rejected.
- **`deny` alone, no hook**: only covers literal command forms. Insufficient alone.
- **Hook alone, empty `deny`**: the prior state — a single defense layer on an irreversible action. Rejected.

## Scope

Infra — global Claude Code configuration (`settings.json`). See also ADR 0020 (git workflow), 0058 (class-based permissions), and 0002 (secrets).
