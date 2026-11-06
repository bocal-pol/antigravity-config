---
name: szikra-boucle-retour
description: "Why suggestion boxes fail (Robinson & Schroeder 2004, Fairbank & Williams 2001, Frese et al. 1999). Design the acknowledgment receipt, the mandatory rejection reason, decisions made close to the ground, response delay as an indicator. Auto-invoke on: feedback loop, acknowledgment receipt, rejection reason, suggestion system, response delay, validation committee, participation, small ideas, emptying suggestion box, proposer feedback."
model: claude-sonnet-5
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Szikra — Feedback Loop

Module 5 of the corpus: Alan Robinson & Dean Schroeder, *Ideas Are Free* (2004) and *The Idea-Driven Organization* (2014); Fairbank & Williams (2001) on motivation; Frese, Teng & Wijnen (1999) on participation predictors.

The formal suggestion system dates back to 1898 (Eastman Kodak). Toyota launched its *Creative Idea Suggestion System* in 1951; by the 1980s it was reaching millions of suggestions per year with an implementation rate above 90%. The comparison with Western systems of the same era is cruel: a few suggestions per employee per decade, at best a third adoption rate, and boxes that end up empty or filled with complaints.

### The four causes of failure

1. **Absence of a feedback loop** — the number-one cause. The employee submits, then nothing. After two or three vanished ideas, they stop proposing: silence is read, rationally, as contempt. **Response delay is a direct predictor** of suggestion volume — systems that respond in days survive, those that respond in months die.
2. **Opaque criteria** — an idea rejected without a reason teaches the proposer nothing. They don't know whether to propose bigger, smaller, or elsewhere. Intrinsic motivation needs a competence signal.
3. **The managerial bottleneck** — routing every idea to a central committee overwhelms the committee, blows up the delay, and breaks the loop. Toyota pushed the decision to the lowest possible level: a team leader approves and implements a small idea the same day.
4. **The bias toward big ideas** — a documented contrarian finding. Financially rewarding "high-impact" ideas produces few ideas, often unverifiable, and attribution conflicts. Most of the potential lies in **small ideas** — the ones not worth a bonus but which, accumulated, change everything.

Frese adds an individual predictor: those who propose the most are those who feel in control of their work **and** have seen their previous ideas succeed. Participation is self-sustaining once the loop works.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Immediate acknowledgment** | Upon submission, even automatic, even minimal. Never absent |
| **Every transition = a response** | Any status change on a shared idea is a message to its proposer |
| **Mandatory reason on rejection** | Three words suffice, but the field cannot be empty. This is what makes the criterion legible and future reactivation possible |
| **Decision close to the ground** | No central committee. The space owner or the periodic review decides |
| **Visible response delay** | A discreet average-delay indicator makes the bottleneck visible before it kills the tool |
| **No bonus, no race for the big idea** | Count ideas that became real, never designate "brilliant" ideas |

## What works, in summary

Immediate acknowledgment · fast decision made close to the ground · systematic reason, including for rejections · public visibility of ideas and their fate · valuing the quantity of small ideas over the rarity of big ones.

## Workflow

### Phase 1 — Identify the object

Designing a transition notification · wording an acknowledgment · reason rule · decision circuit · space health indicator · diagnosing a dying space. Collect via `AskUserQuestion` if absent.

### Phase 2 — Verify the existing state

Read the real state (`Grep`, excluding `node_modules/`, `vendor/`, `*.test.*`): which transitions notify the proposer, is the reason enforced server-side, who has the right to decide, what delay is measured.

### Phase 3 — Diagnosis or recommendation

For a diagnosis, go through the four causes one by one and rule on each. For a design, produce: notification triggers, message content, reason validation constraint, decision-maker role matrix, delay indicator definition.

### Phase 4 — Conditional persistence

- **From an orchestrator**: return in Markdown, write nothing, **skip memorization**.
- **Standalone**: write `ideas/YYYY-MM-DD_szikra-boucle-retour-[topic].md` in the current project.

## Implementation example — applying this to a real idea-management product

- Real statuses typically look like `raw · in_reflection · to_deepen · selected · converted · rejected · archived`, with transitions passing through a dedicated state machine and transition service, and a full history table (`from_status`, `to_status`, `changed_by`, `reason`).
- The reason is carried by a `status_reason` field, with `status_changed_at` and `status_changed_by`. Verify the constraint is enforced **server-side** on rejection, not just in the form.
- Notifications use an in-app/database channel.
- The decision is local by construction: space roles like `member · contributor · moderator · admin` — no central committee.
- A `converted` status ("Became a project") materializes the idea becoming real — that's the counter to favor, never a quality score.
- No negative vote in the model: reactions limited to `like`, `adhere`, `rating`. See also `szikra-securite-psy`.

## Fallback ⚠️

Without access to the sources, produce the theoretical diagnosis while prefixing: *"Diagnosis not checked against the actually implemented transitions."* Never claim a notification exists without having verified it — this is precisely the point where a gap costs the most.

## Optional Input

- Object (`notifications` | `reason` | `decision-circuit` | `indicator` | `space-diagnosis`)
- Transition or status concerned
- Imposed decision-maker role
- Constraint (V1 only, no new channel, no migration…)
