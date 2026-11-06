# ADR 0024 — Cross-session memory system (primer, hindsight, memory-ritual)

- **Status**: accepted
- **Date**: 2026-07-01

## Context

Every Claude Code session started from scratch: project context had to be rediscovered, conventions re-explained, past mistakes repeated. There was no memory across sessions.

## Decision

A persistent 3-component memory system, loaded automatically:

- **`primer.md`**: permanent project context (purpose, stack, architecture, references) — loaded via `@primer.md` in `AGENTS.md`
- **`hindsight.md`**: a journal of lessons learned (dated entries, format: context + lesson) — loaded via `@hindsight.md`
- **`memory/`**: a directory of memos structured by type (user, feedback, project, reference) with a `MEMORY.md` index

### Consolidation via `/memory-ritual`

Explicit invocation of `/memory-ritual`: merge duplicates, archive what's stale, promote repeated patterns into rules, reorganize `MEMORY.md`.

## Positive consequences

- Full continuity across sessions — no more context rediscovery
- `hindsight.md` prevents the same mistakes from repeating
- Recurring patterns become permanent rules

## Negative consequences / risks

- `MEMORY.md` is capped at ~200 lines (truncated beyond that)
- Memories can go stale — verify validity before acting on them

## Alternatives considered

- **No memory**: constant rediscovery, costly. Rejected.
- **Inline memory in `AGENTS.md`**: file too large. Rejected.

## Scope

Cross-cutting — all sessions, all projects.
