# ADR 0071 — Perceived performance: immediate responsiveness and success confirmation

- **Status**: accepted
- **Date**: 2026-10-30

## Context

ADR 0003 covers rendering asynchronous data (Loading/Error/Empty/Success) and ADR 0005 covers error
message format. Neither covers the split second **between the user's click and the first visual
feedback**: a button that doesn't change state until the server response arrives feels slow even
when the server responds quickly, and leaves the door open to a double submission. Likewise, a task
offloaded to a job/queue (see the "Resilience under load" rule) only gets progress feedback if an
exact percentage is known — a long-running task with no `%` (report generation, a large import)
stays silent until it finishes, which looks like a frozen interface. Finally, a successfully
completed important action (a payment, a submitted application, account creation) has no dedicated
confirmation pattern: the SaveMe pattern is reserved for reversible, undoable actions, not for
acknowledging a significant, legitimate, non-reversible step.

## Decision

Every interface with a user action applies, as a complement to ADR 0003 and ADR 0005 (never
duplicating them):

1. **Immediate reaction to a click (< 100ms)**: a "pressed"/pending visual state shown before any
   server response, the button disabled immediately to prevent double submission.
2. **A loading state** for any content fetch — refer back to the "UI state components" rule
   (ADR 0003), not restated here.
3. **Long-task progress extended beyond a known `%`**: a task offloaded to a job/queue with no exact
   percentage shows an indeterminate indicator **and** a step label ("Step 2/4: generating the
   PDF...") or a status poll — never total silence after it's triggered.
4. **Explicit confirmation of successfully completed important steps**, a pattern distinct from
   SaveMe: a persistent banner or success screen (not a toast lasting a few seconds), with a success
   symbol and, where relevant, the next proposed action.
5. **An error message with no over-disclosure**: the 3-part rule (ADR 0005) stays the reference,
   with an explicit added guard — the "why" never reveals an exploitable technical or sensitive
   detail (a stack trace, whether an account exists, the database structure, a server path).

### Completion criteria

A screen is only "done" if a click produces immediate visual feedback, every long task (whether its
`%` is known or not) shows continuous progress, successfully completed important steps are
explicitly confirmed, and no error message discloses exploitable technical information.

## Positive consequences

- A feeling of speed even on a slow network — visual feedback no longer depends on server latency.
- Eliminates a class of double-submission bugs (a duplicated payment, a form sent twice).
- Long tasks with no known `%` stop looking like a frozen interface.

## Negative consequences / risks

- Implementation overhead: a "pressed" state distinct from the existing "loading" state, a new
  success-banner component to add to the design system.
- Risk of over-notification if "important step" is poorly calibrated — not everything deserves a
  persistent banner, only genuinely significant steps (a payment, a submission, account creation),
  not every minor save (which stays covered by SaveMe).

## Alternatives considered

- **Extending the SaveMe pattern to important successes**: SaveMe implies an undo window,
  incompatible with an action already executed and non-reversible (a payment, a submission) —
  rejected, a distinct pattern is needed.
- **Changing nothing, a spinner is enough for tasks with no `%`**: leaves the user with no sense of
  duration or real progress on long tasks — rejected.

## Scope

All projects with an interface (web, mobile). Out of scope: an API with no interface, purely
server-side batch processing with no associated UI. Complements
[ADR 0003](0003-ui-states-4-etats-obligatoires.md) and
[ADR 0005](0005-messages-erreur-3-parties.md), ties into
[ADR 0006](0006-resilience-sous-charge.md) (offloading long tasks to a job/queue) and
[ADR 0011](0011-saveme-pattern-feedback-non-modal.md) (SaveMe, for reversible actions).
