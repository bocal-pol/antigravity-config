# ADR 0072 — The `ai-visitor-simulation` skill: a hybrid UX simulation, systematically wired into team-dev

- **Status**: accepted
- **Date**: 2026-10-30

## Context

Two external projects approach AI visitor simulation for UX testing from opposite angles: one judges
static screenshots with 100 personas by default (broad but shallow, no real interaction); the other
has 4 personas by default actually navigate in a headless browser via a dedicated daemon (deep but
narrow, requiring an extra installation). Neither integrates into an existing development pipeline —
both are standalone tools invoked by hand. This repo already has `mcp__playwright__*` tools
configured in its runtime environment, which neither source project assumes.

## Decision

The `ai-visitor-simulation` skill combines both approaches rather than choosing one over the other:

1. **A hybrid method**: a first screenshot-based look across every persona (broad, cheap — inherited
   from the screenshot-judging approach), then real navigation via `mcp__playwright__*` (already
   available in this environment, no installation needed) on a representative ~10% sample (deep,
   costly but bounded — inherited from the live-navigation approach).
2. **100 personas by default**, not 4: a deliberate user choice against the initial recommendation
   (6 by default) to limit cost — broad coverage is judged a higher priority than token economy for
   this specific skill, with a `--fast` mode (20 personas) for in-progress development iterations.
3. **Automatic integration** into `team-dev --full`, a new step in the closing phase, between the
   anti-AI-slop filter and the Release step — not a menu option like `accessibility-lead`. Explicitly
   skipped if the project exposes no user interface (a pure API, an internal tool with no frontend).

## Positive consequences

- Broad coverage (100 opinions) and real depth (actual interaction, not just reading a screenshot) in
  the same skill, with no external dependency to install.
- Every `team-dev --full` run on a project with an interface produces UX feedback before Release,
  alongside security and accessibility checks — production is no longer the first time UX gets looked
  at by an outside eye (even a simulated one).
- The `ux-tests/ai-visitor-simulation/` folder accumulates a history of comparable runs over time.

## Negative consequences / risks

- Non-trivial, systematic token cost: every `team-dev --full` run on a project with an interface
  triggers roughly 5 subagents (batches of 20) plus the real-navigation sample — an accepted overhead
  by deliberate choice, not an oversight.
- AI-generated feedback isn't a real user test — risk of overconfidence if the report is taken as
  definitive validation rather than a first filter (hence the standing reminder at the top of every
  report).
- The closing phase gets one step longer for any project with an interface, including small internal
  projects with a simple UI where the signal provided is weaker.

## Alternatives considered

- **Defaulting to 6 personas, scalable on demand**: initially recommended to limit cost, rejected by
  the user in favor of broad coverage by default.
- **A menu option (like `accessibility-lead`)**: initially recommended to avoid imposing the cost on
  every full run, rejected in favor of systematic execution.
- **Static screenshots only, or live navigation only**: each method alone reproduced its source
  project's limits (breadth with no depth, or depth with no coverage) — rejected in favor of the
  hybrid.

## Scope

All projects with a user interface orchestrated via `team-dev --full`. Out of scope: an API with no
interface, internal tools with no frontend (explicitly skipped), pages behind complex authentication
not supplied as input. Ties into [ADR 0071](0071-perceived-performance-responsiveness.md)
(perceived performance, the same family of UX concern) without duplicating it, and delegates
accessibility to `accessibility-lead` rather than reimplementing it.
