# ADR 0011 — SaveMe: non-modal feedback pattern for reversible actions

- **Status**: accepted
- **Date**: 2026-08-24

## Context

Interfaces accumulate confirmation modals for every action, even the most trivial ones. This pattern creates friction: the user clicks "Confirm" reflexively, without reading. Conversely, zero feedback leaves the user uncertain. A third path is needed for low-criticality actions.

## Decision

Introduce the **SaveMe** pattern: a self-dismissing toast (5–8s) with an Undo button, paired with a persistent history of recent actions (a bell icon or sidebar). The routing criterion is **business criticality**: any action with no financial or legal consequence goes through SaveMe, everything else stays a modal.

| Criticality | Pattern |
| --------- | ------- |
| Low — no financial/legal consequence | SaveMe |
| High — irreversible destruction, external publishing, financial/legal impact | Modal |

**SaveMe examples**: archiving, changing a status, pinning, removing a tag, deactivating.
**Modal examples**: permanently deleting, sending, publishing, paying, signing.

## Positive consequences

- Reduces modal fatigue
- The user stays in their workflow
- The action history provides a re-engagement and trust surface

## Negative consequences / risks

- Requires a soft-delete or deferred-execution implementation server-side
- The action history must be persisted and accessible

## Alternatives considered

- **A toast alone, no undo**: irreversible. Rejected.
- **A modal for everything**: excessive friction. Rejected.
- **Global undo (Ctrl+Z)**: not suited to multi-tab web apps. Rejected.

## Scope

All projects with a user interface (web, mobile).
