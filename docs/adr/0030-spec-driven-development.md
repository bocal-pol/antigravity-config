# ADR 0030 — Integrated Spec-Driven Development (SDD) workflow

- **Status**: accepted
- **Date**: 2026-08-21

## Context

Vague or missing specifications created a gap between what was expected and what was delivered. Code and specs drifted apart quickly, making compliance audits impossible.

## Decision

Integrate SDD as a cross-cutting discipline through 4 sequenced skills:

1. **`sdd-specify`** → `spec.md` + `constitution.md` (inputs: goals, constraints, vocabulary)
2. **`sdd-plan`** → `plan.md` with ADRs and decision traceability
3. **`sdd-tasks`** → `tasks.md` with testable tasks traced spec↔task
4. **`sdd-converge`** → a convergence report (spec vs. delivered code)

Integrated agents: `product-agent`, `architecture-agent`, `project-bootstrap-agent`, `sprint-agent` invoke the corresponding phases.

SDD phases are mandatory before development if the specification is non-trivial. Skipping is allowed for mechanical changes.

## Positive consequences

- Provable spec↔code traceability before acceptance
- The convergence report acts as an objective delivery gate
- ADRs are produced during the plan phase, not after

## Negative consequences / risks

- Initial overhead for small features (mitigated by the allowed skip)
- Requires discipline to keep `spec.md` up to date

## Alternatives considered

- **Development with no spec**: inevitable drift on projects longer than 2 weeks. Rejected.
- **A Word/Confluence spec**: not versioned, not linked to the code. Rejected.

## Scope

Cross-cutting — all projects with non-trivial specifications.

## 2026-09-11 amendment — aligning with spec-kit 1.0.1 → 1.0.6

Two upstream changes ported into the core disciplines:

- **Field constraints quoted verbatim** (`sdd-tasks`, upstream #4430): each task copies the data model's constraints (`intake/data-dictionary.md` or `data-model.md`) — length, required, enum, validation, PII — instead of leaving them to the implementer, who silently reinvents them.
- **Existing-project mode** (`sdd-specify`, upstream "existing projects" guide, 2026-08-21): the constitution is drawn from the repo's own evidence, the first change is bounded with explicit compatibility boundaries, there's no retro-specifying the entire system, and an explicit choice of spec-aging model.

Not adopted: the workflow engine, the bundler, the presets/extensions/integrations, and the community catalogs (roughly 130 of 141 upstream commits), which belong to the `specify` CLI's tooling rather than the discipline itself. Upstream's `/speckit.converge` (June 2026, append-only on `tasks.md`) stays distinct from our `sdd-converge` (a gap report); the "spec of specs" approach (epic roadmap, July 2026) is documented upstream and available if a project needs it.
