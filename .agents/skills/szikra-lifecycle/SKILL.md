---
name: szikra-lifecycle
description: "Audit a feature, screen, or data model against the 10-point design checklist from the theoretical synthesis (module 7) and against the real state machine. Produces a compliant / gap / blocker verdict per point. Auto-invoke on: idea-box audit, idea lifecycle, idea state machine, design checklist, feature review, idea status, idea transition, terminal state."
model: claude-sonnet-5
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Szikra — Lifecycle Audit

Module 7 of the corpus: the synthesis. Overlaying what Johnson demands (don't bury), Wallas (tolerate openness), Luhmann (link rather than classify), Robinson & Schroeder (make the fate visible), and Edmondson (don't judge the person) yields a state machine whose **particularity is twofold**: the incubation state is central and has no duration, and the "discarded" state is not terminal.

This is the cross-cutting diagnostic tool — invoke it first when a request spans several topics, before going deeper with the module skills.

## The six states and their foundation

| State | What it means | What the tool must do | Foundation |
|------|-------------------|---------------------------|-----------|
| **Spark** | Raw capture, possibly illegible | Nothing. No sorting required, no deadline | Slow hunch (Johnson) · fleeting notes (Ahrens) |
| **Waiting / maturing** | Reread once, in the durable corpus, with no decision | Spaced resurfacing, backlinks, pairing. Never an alert or overdue counter | Incubation (Wallas, Sio & Ormerod) · Zeigarnik · Zettelkasten |
| **In discussion** | Shared voluntarily in a group space | Acknowledgment receipt, comments, possible anonymity | Liquid network (Johnson) · Edmondson · debate (Nemeth) |
| **Retained** | Decision to follow up | Visible reason, notification to the proposer | Feedback loop (Robinson & Schroeder) |
| **Discarded** | No follow-up *for now*, mandatory reason | Stays in the corpus; reactivatable if the reason no longer applies | Adjacent possible (Johnson) · visible criteria (Fairbank & Williams) |
| **Transformed** | Became a project, goal, or task | Link preserved back to the original idea | Platforms (Johnson) · small ideas (Robinson & Schroeder) |

## The design checklist — 10 points

This is the audit reference. Each point receives a verdict.

1. An idea is never archived by age; only an explicit decision removes it from the cycle.
2. The waiting state is the default state and carries no deadline, alert, or counter.
3. Personal and professional contexts are mixed by default; weak links remain visible.
4. Every open idea shows "what points here"; any global view is filtered to the neighborhood.
5. A periodic resurfacing brings back dormant ideas, with some randomness.
6. Reminders are spaced, arrive outside of task mode, and only ask for resonance — never a decision.
7. "Discarded" requires a reason and becomes active again once that reason no longer applies.
8. In groups: immediate acknowledgment, fast local decision, visible average response delay.
9. In groups: private draft by default, possible anonymity, no negative vote, non-judgmental statuses.
10. A space's health indicator is the number of members who submitted at least one idea this month.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **No terminal state** | A state one cannot exit is a blocker, whatever the technical justification |
| **No time-triggered transition** | An automatic transition based on age is a blocker |
| **Verdict per point** | The 10 points are reviewed one by one. An unverifiable point is declared `not verified`, never `compliant` |
| **Proof required** | Each verdict cites the file, enum, ADR, or label it's based on. A verdict without proof is not a verdict |
| **Separate gap from blocker** | `gap` = divergence from theory, negotiable. `blocker` = violates a state machine invariant |
| **Don't invent the scope** | A point about a feature out of V1 scope is declared `out of scope`, not `gap` |

## Workflow

### Phase 1 — Define the audited object

Feature · screen · data model · endpoint · locale labels · backlog item. Collect via `AskUserQuestion` if absent, with scope (`personal` | `group` | `both`).

### Phase 2 — Read the real state

Mandatory before any verdict. Read, in the target repository (`Grep`, excluding `node_modules/`, `vendor/`, `*.test.*`):

- the status enum and the state machine (allowed transitions);
- the project's context documentation for V1 scope and decisions;
- the relevant ADR;
- the labels in the target locale(s);
- the existence of scheduled jobs or commands touching statuses.

### Phase 3 — Go through the 10 points

For each: verdict (`compliant` | `gap` | `blocker` | `out of scope` | `not verified`), proof, and recommendation if the verdict isn't `compliant`.

### Phase 4 — Synthesis

Summary table, then blockers first, gaps next, ordered by increasing fix cost. End with points left open without forcing a ruling.

### Phase 5 — Conditional persistence

- **From an orchestrator**: return in Markdown, write nothing, **skip memorization**.
- **Standalone**: write `ideas/YYYY-MM-DD_szikra-lifecycle-[object].md` in the current project.

## Implementation example — mapping theory to a real codebase

The course's vocabulary is **not** the code's vocabulary. Audit against the code.

| The course | Typical code mapping | UI label |
|----------|--------------------------------------|------------|
| Spark | `raw` | "Raw spark" |
| Maturing | `in_reflection` (+ `to_deepen`) | "In reflection" |
| In discussion | *not a status* — carried by sharing (`shared_at`, `shared_by`) toward a group space | — |
| Retained | `selected` | — |
| Discarded | `rejected` (mandatory `status_reason`) | "Not retained" |
| Transformed | `converted` | "Became a project" |
| — | `archived` | — |

Product-specific watch points:

- **`archived` is the riskiest status**: verify no automatic path leads there by age, and that one can exit it. This is invariant #1.
- **Point 4 (backlinks) and point 3 (weak links) may be out of V1 scope**: a graph view is often explicitly excluded in early versions. Declare these `out of scope`, not `gap`, when that's the case.
- Point 5 is typically covered by a resurfacing/echo mechanism with several forms (dormant, pair, anniversary, rejected-reason, random).
- Point 7 may be partially covered by a reactivation-suggestion command — verify the trigger condition.
- Point 9 relies on pseudonymized anonymity and the absence of negative votes in the reaction model (`like`, `adhere`, `rating`).
- History and traceability: a status-history table, a state machine class, a transition service.

## Fallback ⚠️

If the repository is not accessible, **do not produce an audit**: an audit without proof is misleading. Return instead the annotated 10-point checklist with the questions to ask, stating: *"Audit impossible — project sources inaccessible. Checklist provided as a grid."*

## Optional Input

- Audited object (feature, screen, table, endpoint, locale, backlog item)
- Scope (`personal` | `group` | `both`)
- Points to explicitly ignore (with justification)
- Output level (`summary` | `detailed`)
