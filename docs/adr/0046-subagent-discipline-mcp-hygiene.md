# ADR 0046 — Subagent discipline and MCP hygiene

- **Status**: accepted
- **Date**: 2026-09-17

## Context

ADR 0016 (model tiering) and ADR 0019 (session hygiene) cover two of the five cost-optimization levers. Two others stayed untracked, and they're the costliest in practice: the reflex to delegate to a subagent by default, and keeping unneeded MCP servers permanently active.

A subagent opens its own context window and bills its own requests: delegating a task the main agent could handle directly doubles the cost with no gain. Symmetrically, MCP tool results stay in context for the whole session — a server activated "just in case" on a pure-code session drags its weight until the end.

## Decision

### Subagent discipline

**Don't spawn a subagent by default.** A subagent is only justified if one of three conditions holds:

1. the work is genuinely parallelizable;
2. it's a broad multi-file read that should be isolated from the main context;
3. the scope exceeds a single context window.

Otherwise, handle it directly.

**One orchestration level at a time**: don't stack subagents that re-spawn subagents with no real need (see the 3-level hierarchy, ADR 0014).

### MCP hygiene

- Don't activate an MCP server (Notion, Playwright...) on a session that doesn't need it.
- After a large MCP request, `/compact` to avoid carrying the residual weight (see ADR 0019).

## Positive consequences

- Removes delegation cost on tasks the main agent handles just as well alone
- The one-orchestration-level cap makes a session's cost predictable
- Context stays available for real work rather than unused tool results

## Negative consequences / risks

- The "genuinely parallelizable" criterion requires judgment: under-delegating saturates the main context, exactly what ADR 0019 tries to avoid
- Deactivating an MCP makes it unavailable mid-session, requiring a restart if it becomes needed
- Handling a broad exploration directly can cost more than isolating it — the rule has accepted exceptions

## Alternatives considered

- **Always delegating to subagents**: the initial state, doubles the cost with no gain on simple tasks. Rejected.
- **Banning subagents outright**: loses the real benefit on broad explorations and parallelizable work. Rejected.
- **Keeping every MCP server active permanently**: immediate convenience, permanent context cost. Rejected (see ADR 0053).

## Scope

All sessions. Complements ADR 0016 and 0019 without replacing them. Source: the "Token & cost optimization" section of `AGENTS.md`.
