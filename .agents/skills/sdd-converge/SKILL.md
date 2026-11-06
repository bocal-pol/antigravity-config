---
name: sdd-converge
description: "Spec-Driven Development — Converge Phase. Compares delivered code to the spec.md / plan.md / tasks.md artifacts and produces a gap report. Invoke from sprint-agent at the end of a sprint. Auto-invoke on mention of: SDD convergence, sdd-converge, spec verification, spec gaps."
model: claude-sonnet-5
user-invocable: true
type: utility
priority: medium
scope: cross
dependencies:
  - sdd-specify
  - sdd-plan
  - sdd-tasks
conflicts: []
---

# SDD Converge — Spec/code convergence verification

Assesses whether the delivered code satisfies the SDD artifacts. Detects drift before it becomes costly.

## SDD principle

Convergence is not a punitive audit — it's a feedback loop.
Each identified gap is an opportunity to fix the spec, the plan, or the code.

## Optional input (invoked from sprint-agent)

Receive: list of delivered tasks (DELIVERED_TASKS).
Otherwise, read `spec/tasks.md` and filter tasks with status ✅ Delivered.

## Workflow

### Phase 1 — Reading the SDD artifacts

Read via Read, in order:

1. `spec/spec.md` → overall acceptance criteria
2. `spec/plan.md` → chosen stack, ADRs, standards
3. `spec/tasks.md` → tasks and their done conditions

If a file is missing, note `⚠️ [file] not found` and continue with those available.

### Phase 2 — Analysis of delivered code

For each ✅ Delivered task in `spec/tasks.md`:

1. Grep the relevant component (pattern from the task's done condition)
2. Check the done condition: is it satisfied in the code?
3. Check stack compliance: does the code use the technology decided in `plan.md`?
4. Check standards: are code conventions followed?

Exclude from greps: `node_modules/`, `vendor/`, `*.test.*`, `dist/`, `build/`

### Phase 3 — Analysis of overall acceptance criteria

For each criterion in `spec.md`:

- Identify the tasks that were supposed to cover it (via spec reference)
- If all those tasks are ✅ Delivered → criterion potentially satisfied
- If at least one is ⬜ or ❌ → criterion at risk

### Phase 4 — Convergence report

Produce `spec/convergence-YYYY-MM-DD.md`:

```markdown
# SDD Convergence Report — [Project name]
> Date: YYYY-MM-DD | Sprint: [N]

## Executive summary
- Tasks analyzed: N / N delivered
- Acceptance criteria covered: N / N
- Gaps detected: N (Critical: N | Minor: N)
- Stack drifts: N

## Convergent tasks ✅
| TASK     | Done condition | Verdict       |
|----------|------------------|---------------|
| TASK-001 | ...              | ✅ Satisfied |

## Detected gaps ⚠️

### Gap [N] — [Short title]
- **Task**: TASK-XXX
- **Expected done condition**: [...]
- **Finding in the code**: [...]
- **Severity**: Critical / Minor
- **Recommended action**: Fix the code | Update the spec | Create a new task

## Stack drifts 🔴
| plan.md decision | Actual usage detected | Risk |
|------------------|--------------------|--------|
| ...              | ...                | ...    |

## Acceptance criteria at risk ⚠️
- §X — [Criterion]: tasks not delivered (TASK-XXX, TASK-YYY)

## Recommendations for the next sprint
1. [Priority action]
2. [Secondary action]
```

### Phase 5 — Conditional persistence

- **Standalone**: write `spec/convergence-YYYY-MM-DD.md` via Write
- **Orchestrated** (from sprint-agent): return the Markdown report without writing — persistence handled by the orchestrator

### Phase 6 — Terminal report

Display:

```
✅ SDD Converge complete
- Spec coverage: N/N criteria
- Gaps: N critical, N minor
- Stack drifts: N
→ [If critical gaps] Action required before delivery
→ [If 0 gaps] Ready for release (release-agent)
```
