# ADR 0025 — Canary: instruction-drift detection

- **Status**: accepted — **amended on 2026-09-17 by ADR 0065**
- **Date**: 2026-07-13

> **Amendment (ADR 0065)**: the mechanism is kept and **stays in the shared `AGENTS.md`** — it
> serves everyone using it, not just its author, since it signals that instructions were indeed
> loaded. Only **the word changes**: the previous one also named an agent, so it could legitimately
> appear in a response without being the canary. A canary must be a word with no other reason to
> appear.

## Context

Claude Code can drift from its instructions without the user noticing immediately. Long sessions or heavily loaded contexts increase the risk of forgetting customized conventions.

## Decision

Start **every response** with the word `canary` in lowercase, alone on the first line, before any other content.

```text
canary
[normal response here]
```

The absence of `canary` on line 1 is an immediate signal that Claude Code has drifted from its instructions.

## Positive consequences

- Instant drift detection with no need to analyze the response
- Minimal token cost, no impact on response quality
- Still works after context compaction

## Negative consequences / risks

- No automatic correction mechanism — the user must flag the drift
- A detection signal only, not prevention

## Alternatives considered

- **No signal**: drift goes undetected. Rejected.
- **A full sentence**: too verbose, hurts readability. Rejected.

## Scope

Cross-cutting — every Claude Code response.
