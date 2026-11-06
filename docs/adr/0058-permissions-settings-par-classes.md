# ADR 0058 — `settings.json` permissions by generic classes

- **Status**: accepted
- **Date**: 2026-09-17

## Context

The `permissions.allow` block in `settings.json` grew by one entry every time a command triggered a confirmation. After several months, it peaked at **91 ultra-specific entries**: precise `sed` lines, paths to since-deleted projects, and a `git push` to `master` — in other words, a permanent permission for an action the git workflow forbids (ADR 0020).

The file had become impossible to review, and nobody could say what it actually allowed. A permission granted for one session stayed in place indefinitely.

## Decision

### 1. Classes, not accumulation

`permissions.allow` holds about twenty **generic classes** — `Read`, `Glob`, `Grep`, `AskUserQuestion`, `Edit(~/.claude/skills/**)`, `Edit(~/.claude/agents/**)`, `Bash(git status*)`, `Bash(git diff*)` — not entries derived from a past command.

An entry that only ever matches one already-executed command has no place in the global file.

### 2. An explicit `deny` block

`permissions.deny` always carries the structuring prohibitions, chief among them pushes to `main` and `develop` (ADR 0020). An empty `deny` leaves the ban resting solely on the `pre-tool-use.sh` hook (ADR 0026) — a single defense layer for an irreversible action.

### 3. Project permissions go in the project

A permission that only concerns one repo goes in its own local settings file, not in the global configuration.

### 4. Periodic cleanup

On every `settings.json` refactor, replace accumulated entries with classes instead of adding one more.

## Positive consequences

- The file becomes readable again: what it allows is clear at a glance
- Deleted project paths disappear instead of piling up
- The explicit `deny` adds a second defense layer on irreversible actions

## Negative consequences / risks

- A generic class allows **more broadly** than a precise entry: `Edit(~/.claude/skills/**)` covers more than eleven individual `Edit(~/.claude/skills/<skill>/**)` entries. This is a readability-vs-granularity trade-off, accepted on a single-user environment.
- Confirmations return for anything outside the classes — MCP tools, project-specific commands, `Write` outside `~/.claude`. Accepted friction: those permissions go in the project's local settings file, not the global one.
- Cleanup is manual: without discipline, accumulation resumes

## Alternatives considered

- **Accumulating as you go**: the observed state at 95 entries, one of which contradicted the git workflow. Rejected.
- **No pre-granted permission at all**: a confirmation on every file read, unusable. Rejected.
- **Project-only permissions**: loses the common baseline shared by every session. Rejected; both levels coexist.

## Scope

The global `settings.json` and projects' local settings files. See also ADR 0017 (security modes), 0020 (git workflow), and 0026 (hooks).
