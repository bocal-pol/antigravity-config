# ADR 0029 — Karpathy Guidelines: behavioral guardrails before code

- **Status**: accepted
- **Date**: 2026-07-13

## Context

LLM agents make systematic mistakes: overcomplicating solutions, modifying beyond the requested scope, making implicit assumptions that never get surfaced. These behaviors cause regressions and out-of-scope deliveries.

## Decision

Invoke `karpathy-guidelines` (6 principles) systematically before any code review, refactor, or detected sign of over-engineering:

1. **Think before coding** — understand the full problem before writing
2. **Simplicity first** — the simplest solution that works
3. **Surgical changes** — only modify what was asked
4. **Goal-driven execution** — stay on the intent, not the details
5. **Surface assumptions** — make implicit suppositions visible
6. **Nothing speculative** — no code for hypothetical future needs

`team-dev` automatically invokes karpathy-guidelines before the `--backend`, `--frontend`, `--mobile` modes.

## Positive consequences

- Fewer regressions tied to out-of-scope changes
- Implicit assumptions become explicit decisions
- More focused, more maintainable code

## Alternatives considered

- **Code review alone**: happens too late, doesn't prevent mistakes. Complementary, not sufficient alone.

## Scope

Cross-cutting — all development agents, every review/refactor.
