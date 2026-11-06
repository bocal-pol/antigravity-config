# ADR 0008 — Upfront alignment: mandatory before any non-trivial change

- **Status**: accepted
- **Date**: 2026-08-24

## Context

Implementations were being started with no defined scope, edge cases, or alternatives. Result: costly back-and-forth, features shipped off-target from the real need, structuring decisions made along the way with no traceability.

## Decision

Before any non-trivial change (a new feature, a redesign, a structuring decision), run the `upfront-alignment` discipline: a 5-axis interview via `AskUserQuestion` before any implementation.

### The 5 axes

1. **Intent** — what real problem, for whom, what observable success?
2. **Scope** — what's in / explicitly out, constraints?
3. **Edge cases** — empty input, concurrency, network failure, insufficient permissions?
4. **Alternatives** — approaches considered and rejected, and why?
5. **Unknowns** — what isn't decided and blocks implementation?

### Deliverables

- `CONTEXT.md` at the project root — a glossary of domain terms
- `docs/adr/NNNN-title.md` — an ADR for each structuring decision
- An alignment summary + a green light or blocking unknowns

### Allowed skip

A rename, an obvious fix, a mechanical change (typo, dependency bump), or if the alignment pass was already done in the same session.

## Positive consequences

- Reduces back-and-forth and re-implementations
- Decisions are tracked in ADRs — readable by any agent or developer
- The shared vocabulary (`CONTEXT.md`) reduces misunderstandings between agents

## Alternatives considered

- **Implement directly and adjust**: fast but costly in corrections. Rejected for non-trivial changes.
- **A formal spec document**: too heavy for everyday changes. Replaced by the lightweight 5-axis interview.

## Scope

All projects, all agents. Triggered automatically by `team-dev` before dev modes on a significant change.

## 2026-09-11 amendment — aligning with upstream practice (grilling + domain-modeling, August 2026)

- **Facts vs. decisions**: the agent itself looks up any verifiable fact in the environment; only decisions go to the user. Each wave surfaces the whole frontier of unblocked questions.
- **Multi-context**: a monorepo or a domain with several bounded contexts uses a root `CONTEXT-MAP.md` pointing to one `CONTEXT.md` per context. `CONTEXT.md` stays a pure glossary (no implementation, no generic concepts).
- **ADR criteria**: an ADR is proposed only if the decision is hard to reverse, surprising without context, and the result of a real trade-off. A 1-to-3-sentence ADR is valid.
- The skill gets a model-oriented `description:` frontmatter field, previously missing.
