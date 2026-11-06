# ADR 0070 — A conditional legal-compliance track in project-bootstrap-agent

- **Status**: accepted
- **Date**: 2026-10-30

## Context

ADR 0056 treated the project-bootstrap kit's 6 deliverables as exhaustive. In practice, legal
compliance (`compliance-officer`, `legal-pages`) and accessibility (`accessibility-lead`) only ever
came in late: during `team-dev --full`'s quality-loop phase (after the data model and forms were
already coded) or during a standalone audit, after the fact. Fixing data minimization or adding a
form consent checkbox after the fact costs a rework of the data model and the UI; thinking about it
at bootstrap time, while the Data Dictionary and App Spec are still being written, costs one extra
question.

## Decision

`project-bootstrap-agent` gains a **conditional Phase 6b**: if the App Spec or Data Dictionary
indicates external forms, payment, or external users with personal data, `project-bootstrap-agent`
invokes `compliance-officer` (legal bases + minimization, a lightweight pass) then `legal-pages`,
and persists the result as a **draft** in `intake/legal-compliance.md` — explicitly not final. The
quality-loop phase of `team-dev --full` (`compliance-officer --gdpr`) **finalizes** this draft
instead of starting from scratch. An internal project with no public exposure silently skips this
phase (no legal track to produce).

This decision complements ADR 0056 (which remains valid for the 6 fixed deliverables) without
replacing it: the bootstrap kit now counts 6 fixed deliverables + 1 conditional one.

## Positive consequences

- Data minimization and form consent get thought through before the data model and forms are coded,
  not fixed in a rework.
- The `team-dev --full` compliance phase becomes a faster finalization (legal bases already drafted)
  rather than a first production pass.
- A project that stops after bootstrap (without chaining into the full cycle) still has a first draft
  of legal documents on hand, instead of nothing.

## Negative consequences / risks

- Lengthens bootstrap by one more conditional step — a project misqualified in Phase 1
  (forms/payment not anticipated) can trigger or skip this phase incorrectly.
- The draft produced at bootstrap can go stale if the legal bases change mid-project before the
  quality-loop finalization — hence the obligation to mark it explicitly "draft," never final.
- `compliance-officer`/`legal-pages` get invoked twice on the same project (bootstrap + quality
  loop) — accepted as the cost of triggering early, the second pass being a targeted finalization,
  not a repeated full audit.

## Alternatives considered

- **Keeping the current late trigger** (quality-loop / audit only): simpler, but doesn't address the
  expressed need to think about compliance at design time rather than catch-up — rejected.
- **Making the legal track unconditional in `project-bootstrap-agent`**: would produce useless
  documents for internal tools with no public exposure — rejected; the trigger stays conditional on
  actually detecting forms/payment/external users.

## Scope

Applies to `agents/project-bootstrap-agent.md` and the bootstrap/quality-loop phases of
`skills/team-dev/SKILL.md`. Complements [ADR 0056](0056-kit-amorcage-socle-agent.md) (the bootstrap
kit) and ties into [ADR 0035](0035-compliance-rgpd-team-dev-full.md) (GDPR compliance integrated
into the full cycle) and [ADR 0069](0069-legal-pages-multi-juridiction-ue.md) (multi-jurisdiction
`legal-pages`).
