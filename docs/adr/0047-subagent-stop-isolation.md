# ADR 0047 — `<SUBAGENT-STOP>`: isolating root-agent-only instructions

- **Status**: accepted
- **Date**: 2026-09-17

## Context

The bootstraps injected at startup contain systemic orchestration instructions: route through the Skill Router, run the 5-axis alignment interview, write acceptance gates, chain brainstorm → plan → worktree. These instructions make sense for the root agent, which drives the entire session.

A Level-2 agent dispatched for a specific subtask read them too, though — and re-ran the whole alignment chain to "add an endpoint." The orchestration cost was paid once per leaf, and `AskUserQuestion` interviews cascaded from agents that should never have talked to the user at all.

## Decision

In any skill or agent bootstrap, instructions meant **for the root agent only** are wrapped in a delimited block:

```text
<SUBAGENT-STOP>
[Instructions that only apply to the root agent — skill router, alignment, verification...]
</SUBAGENT-STOP>
```

A dispatched (Level-2) agent ignores this block and doesn't invoke the full chain for a bounded subtask.

**Application rule**: any systemic orchestration skill — upfront alignment, brainstorming, `unlazy` — must be wrapped in this tag within the bootstraps injected at startup.

## Positive consequences

- A subtask costs the price of a subtask, not of a full session
- No more `AskUserQuestion` interviews triggered from leaf agents
- The boundary between coordination and execution becomes readable in the bootstrap text itself

## Negative consequences / risks

- A purely textual convention: nothing enforces it technically, an agent can ignore it
- A misplaced block deprives the root agent of an instruction it needs, or lets one leak to the leaves
- Requires discipline on every new orchestration skill — an omission is silent

## Alternatives considered

- **Two separate bootstrap files** (root / leaf): two sources of truth to keep in sync, guaranteed drift. Rejected.
- **Having the agent detect its own level**: unreliable, an agent doesn't always know whether it's been dispatched. Rejected.
- **Isolating nothing**: the initial state, the orchestration chain re-run per leaf. Rejected.

## Scope

All bootstrap skills and agents in the ecosystem. Complements ADR 0014 (3-level hierarchy) by sealing it. Source: the "`<SUBAGENT-STOP>` convention" section of `AGENTS.md`.
