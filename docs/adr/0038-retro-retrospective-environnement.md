# ADR 0038 — Retro: end-of-session agent-environment retrospective

- **Status**: accepted
- **Date**: 2026-09-11

## Context

Friction the agent ran into during a session (a long search for lack of a pointer, an error a check would have caught, a costly tool call, an `AGENTS.md` instruction with no effect) only got logged by reflex, in `skill-observations/log.md`, and only when it touched a skill. Everything else was lost at the end of the session, and the steering files (`AGENTS.md`, `primer.md`) just kept growing.

## Decision

Add a `retro` skill (adapted from Matt Pocock's upstream skill, 2026-08-24) invoked at the end of `team-dev` (Phase D6 of `--full` mode, end-of-session for the other modes) and on demand. It re-reads the session's primary sources and proposes improvements to the **agent's environment** across 7 categories: navigation, automated checks, code standards, the global steering file, tool economy, no-ops, information access. After approval, it persists findings into `skill-observations/log.md` (collision-safe protocol), `hindsight.md`, or a proposed diff on the steering files.

Guiding principle: **standards are enforced in review, not in implementation** (the reviewing agent is under less context pressure). Any steering sentence that doesn't change behavior relative to the default is a no-op to be removed entirely.

## Positive consequences

- A closed loop: `retro` feeds `improve-skills` (weekly review) instead of a randomly-filled log.
- Downward pressure on the steering file: every instruction is periodically subjected to the no-op test.
- Friction unrelated to any specific skill (tools, access, checks) finally has somewhere to go.

## Alternatives considered

- **Extend `improve-skills`**: it reviews `SKILL.md` structure, not the lived session; mixing the two would have drowned out the weekly review. Rejected; `improve-skills` only receives the "no-ops & negation" criterion.
- **Extend `explain-diff`**: aimed at human learning from the produced code, not the agent's environment. Rejected.

## Scope

Cross-cutting — all projects, every `team-dev` mode that produces code or ran into notable friction.
