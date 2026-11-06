---
name: sdd-tasks
description: "Spec-Driven Development — Tasks Phase. Consumes spec.md + plan.md and produces tasks.md (testable, independent, ordered tasks traced back to spec). Invoke from project-bootstrap-agent after the feature backlog. Auto-invoke on mention of: SDD tasks, sdd-tasks, tasks.md spec-kit, SDD decomposition."
model: claude-sonnet-5
user-invocable: false
type: utility
priority: high
scope: cross
dependencies:
  - sdd-specify
  - sdd-plan
conflicts: []
---

# SDD Tasks — Traceable Task Decomposition

Produces `tasks.md`: every task is testable, independent, and traced to a criterion in `spec.md`.

## SDD Principle

An SDD task is not a generic ticket. It carries:

- its traceability to `spec.md` (which criterion it satisfies)
- its done condition, verifiable without ambiguity
- its independence (can be assigned and delivered alone)

## Optional Input (invoked from project-bootstrap-agent)

If FEATURE_BACKLOG and PLAN are provided as input, use them directly.
Otherwise, read in order: `spec/plan.md`, `spec/spec.md`, `intake/feature-backlog.md`.
If no file is found: `⚠️ Run sdd-specify then sdd-plan first`.

## Workflow

### Phase 1 — Reading upstream artifacts

Read `spec/spec.md` (acceptance criteria), `spec/plan.md` (stack, ADRs), `intake/feature-backlog.md` (MoSCoW features), and the data model if it exists: `intake/data-dictionary.md` (columns *Type*, *Required*, *PII*, *Validation rules*) or any `data-model.md` referenced by `plan.md`.
Extract: list of Must-have features + global acceptance criteria + field constraints per entity.

### Phase 2 — Task decomposition

For each Must-have feature, produce 2-5 atomic tasks.

Breakdown rules:

- One task = one modified component (backend OR frontend OR infra, not all three)
- Estimate ≤ 5 story points (otherwise break it down further)
- Done condition expressed behaviorally ("the API returns X when Y")
- **Field constraints quoted verbatim**: for every field of the data model that the task creates or modifies, copy the constraint exactly as written in the dictionary (max length, required/nullable, enum values, validation rule, PII). A constraint left to the implementer's judgment is reinvented silently — closing that gap is the point of this rule.

### Phase 3 — Writing tasks.md

Produce `spec/tasks.md` in the following format:

```markdown
# Tasks — [Project name]
> Traced to spec.md — [spec date] | plan.md — [plan date]

## Statuses: ⬜ To do | 🔄 In progress | ✅ Delivered | ❌ Blocked

---

## Feature: [Feature name] (Must-have)
> Spec ref.: Acceptance criterion §X

### TASK-001 — [Short title]
- **Component**: Backend / Frontend / Infra / Data
- **Estimate**: N story points
- **Status**: ⬜ To do
- **Done condition**: [Observable and verifiable behavior]
- **Data constraints**: [Entity.field — constraint copied from the dictionary, e.g. `email`: required, max 254, RFC 5322 format, PII] (or "none")
- **Depends on**: TASK-XXX (or "none")
- **Spec ref.**: §X — [Relevant acceptance criterion]

### TASK-002 — [Short title]
...

---

## Summary

| Feature | # tasks | Total SP | Spec coverage |
|---------|---------|----------|----------------|
| ...     | N       | N        | ✅ / ⚠️        |

**Total project: N tasks — N story points**
```

### Phase 4 — Traceability check

For every acceptance criterion in `spec.md`, verify at least one task references it.
Uncovered criteria → `⚠️ Uncovered criteria` section at the bottom of `tasks.md`.

### Phase 5 — Persistence (conditional)

- **Standalone**: write `spec/tasks.md` via Write
- **Orchestrated** (from project-bootstrap-agent): return the Markdown content without writing — persistence is handled by the orchestrator

### Phase 6 — Report

Display:

```
✅ SDD Tasks complete
- spec/tasks.md — [N] tasks, [N] story points, [N] features covered
- Spec traceability: [N/N] criteria covered
→ Ready for sprint-agent (implementation)
```
