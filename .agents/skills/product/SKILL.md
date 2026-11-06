---
name: product
description: "Full product orchestrator — sequentially invokes analyst, product-manager, and functional-analyst to produce a complete package (Project Brief + PRD + Functional Specs). Auto-invoke on mention of: complete product package, full analysis, brief + PRD + specs, run the product analysis."
model: claude-sonnet-5
user-invocable: true
type: orchestrator
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Product — Product Analysis Orchestrator

Produces a complete product package (Project Brief + PRD + Functional Specs) by sequentially orchestrating three specialized skills.

## Optional input (if invoked from team-dev)

If a project context is provided as input by `team-dev`, use it directly at Phase 2 — skip Phase 1.

## Workflow

### Phase 1 — Project context gathering

Via AskUserQuestion, ask a single grouped question:
- Project name
- Main goal (problem solved)
- Primary target user
- Known constraints (budget, timeline, tech stack)

Store the answer as `<project_context>`.

### Phase 2 — Project Brief (analyst)

Invoke the `analyst` skill with `<project_context>` as input.

**Expected output**: Markdown content of the Project Brief
**⚠️ Fallback**: if `analyst` is unavailable, ask the user to provide a Project Brief or manually create `project-brief.md`, then move to Phase 3

Store the output as `<project_brief>`.

### Phase 3 — PRD (product-manager)

Invoke the `product-manager` skill with `<project_brief>` as input.

**Expected output**: Markdown content of the PRD with user stories and MoSCoW prioritization
**⚠️ Fallback**: if `product-manager` is unavailable, write `<project_brief>` to `project-brief.md` and stop with the message `⚠️ product-manager unavailable — Project Brief saved, PRD to be created manually`

Store the output as `<prd>`.

### Phase 4 — Functional specifications (functional-analyst)

Invoke the `functional-analyst` skill with `<prd>` as input.

**Expected output**: Markdown content of the functional specifications
**⚠️ Fallback**: if `functional-analyst` is unavailable, write `<project_brief>` and `<prd>` to their respective files and stop with `⚠️ functional-analyst unavailable — Brief and PRD saved, specs to be created manually`

Store the output as `<specs>`.

### Phase 5 — Package persistence

Write the three files at the root of the current project:
- `project-brief.md` ← `<project_brief>`
- `prd.md` ← `<prd>`
- `functional-specs.md` ← `<specs>`

If invoked from `team-dev`: report that persistence is done and return the paths of the created files.

### Phase 6 — Memory consolidation

Invoke the `memory-rituel` skill to consolidate the project context into memory.

**⚠️ Fallback**: if `memory-rituel` is unavailable, display `⚠️ memory-rituel unavailable — memory consolidation must be done manually`

### Phase 7 — Report

Display:
```
Product package created:
- project-brief.md
- prd.md
- functional-specs.md
```
