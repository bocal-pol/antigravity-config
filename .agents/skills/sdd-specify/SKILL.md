---
name: sdd-specify
description: "Spec-Driven Development — Specify Phase. Produces spec.md (problem, users, constraints without tech stack) and constitution.md (project principles). Invoke from product-agent before writing the PRD; brownfield mode: constitution from evidence, first change bounded. Auto-invoke on mention of: SDD specification, spec-kit, spec.md, spec driven, adopting SDD on an existing project."
model: claude-sonnet-5
user-invocable: false
type: utility
priority: high
scope: cross
dependencies: []
conflicts: []
---

# SDD Specify — Problem-Oriented Specification

Produces the two foundational artifacts of Spec-Driven Development **before** any technical choice.

## SDD Principle

The spec describes **what** and **why** — never **how** (stack, framework, database).
It becomes the contract every downstream agent consumes.

## Optional Input (invoked from product-agent)

If a PROJECT_CONTEXT is provided as input, use it directly without asking questions.
If an `intake/` folder exists, read `intake/app-spec.md` and `intake/feature-backlog.md` as the priority source.

## Brownfield Mode (existing project)

If the repository already contains application code, **do not retro-specify the whole system** — unless that inventory is the requested deliverable. Rules:

1. **Constitution from evidence**: principles come from the README, ADRs, the contributing guide, and existing CI config (e.g. "preserve public API compatibility", "every migration has a rollback plan"). Never invent a principle to fill the template: an unrealistic rule produces noise in the plan/converge phases.
2. **One bounded first change**: the first `spec.md` describes a feature, a fix, or a modernization slice reviewed independently. Existing code remains the *implementation context*, not the subject of the spec.
3. **Explicit compatibility boundaries**: the spec names what must stay intact (filters, authorizations, existing API responses) in "Non-negotiable constraints" and "Out of scope".
4. **Spec aging decided**: at the end, have the user decide how the artifacts will live on — a folder frozen per feature (history), `spec.md` as a living contract with downstream artifact regeneration, or reconciliation from code via `sdd-converge`. Record the choice in `constitution.md` (Governance rules).

## Workflow

### Phase 1 — Collection (if no context provided)

Via AskUserQuestion, a single grouped question:

- What concrete problem does this project solve?
- Who are the main users (roles, usage context)?
- What measurable outcomes are expected?
- What constraints are non-negotiable (regulatory, budget, deadlines)?

### Phase 2 — Writing spec.md

Produce `spec/spec.md` in the following format:

```markdown
# Specification — [Project name]

## Problem
[Description of the problem solved — 3-5 sentences, no technical solution]

## Users
| Role | Usage context | Primary need |
|------|---------------|--------------|
| ...  | ...           | ...          |

## Expected outcomes
- [ ] Measurable outcome 1
- [ ] Measurable outcome 2

## Non-negotiable constraints
- Regulatory: ...
- Budget: ...
- Deadlines: ...
- Compatibility: ...

## Out of scope
- [What this project does NOT do — explicit]

## Global acceptance criteria
- [ ] Criterion 1 (verifiable, no tool reference)
- [ ] Criterion 2
```

### Phase 3 — Writing constitution.md

Produce `spec/constitution.md` in the following format:

```markdown
# Constitution — [Project name]

## Guiding principles
1. [Principle 1 — e.g. "User data never leaves the home jurisdiction"]
2. [Principle 2 — e.g. "Every action is reversible within 30 days"]

## Development values
- Simplicity > unnecessary sophistication
- Security by design, not as an afterthought
- [Project-specific value]

## Governance rules
- Technical decisions: require a documented ADR
- Exceptions to principles: require PO + Tech Lead sign-off
```

### Phase 4 — Persistence (conditional)

- **Standalone**: write `spec/spec.md` and `spec/constitution.md` via Write
- **Orchestrated** (input received from product-agent): return both Markdown contents without writing — persistence is handled by the orchestrator

### Phase 5 — Report

Display:

```
✅ SDD Specify complete
- spec/spec.md         — [N] acceptance criteria, [N] constraints
- spec/constitution.md — [N] guiding principles
→ Ready for sdd-plan (architecture-agent)
```
