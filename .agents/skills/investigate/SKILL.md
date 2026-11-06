---
name: investigate
description: "INTERACTIVE 4-phase bug investigation with user stop-and-validate at each step: locate → 3 ranked falsifiable hypotheses → targeted logs without fixing → minimal fix (3-strikes rule). team-dev --investigate mode. Triggers on 'investigate', 'why is this crashing', 'analyze this bug with me', 'root cause', 'let's look together'. For autonomous diagnosis without intermediate validation (agents, --fix), use debug."
model: claude-sonnet-5
user-invocable: true
type: utility
priority: high
scope: cross
dependencies: []
conflicts: [debug]
---

# Investigate — Structured 4-Phase Debugging

Before starting, confirm you have two things:
- **The symptom**: what's actually happening (error message, observed behavior, returned value…)
- **The expected behavior**: what should happen instead

If either is missing, ask for it explicitly before going further.

---

Before any fix, run through these 4 phases in order. **Stop at the end of each and wait for my validation** before moving to the next.

## PHASE 1: Locate and reproduce

From the symptom, explore the code (Read, Grep, Glob) to identify the 2–3 areas most likely to host the cause. List them with one justifying sentence each.

Then describe in 3 lines the minimal scenario that reliably reproduces this bug.

> If you can't reproduce it reliably, say so and propose a plan to get there.

**⏸ STOP — wait for validation before Phase 2.**

---

## PHASE 2: 3 ranked hypotheses on the root cause

Propose **3 hypotheses about the root cause** (not the symptom), ranked from most to least likely.

For each one:
1. Hypothesis in 1 sentence
2. Falsifiable prediction: "if this hypothesis is true, we'd observe _\<precise observation\>_; if we observe the opposite, we rule it out"

**⏸ STOP — wait for validation before Phase 3.**

---

## PHASE 3: Test hypothesis #1

Add targeted logs to verify hypothesis #1.

**Mandatory rule**:
- Prefix each log with `[DEBUG-xxxx]` (4 random characters) for bulk removal later
- **Don't propose a fix at this phase**
- State what I should observe to confirm or disprove the hypothesis

> **3-strikes rule**: if all 3 hypotheses turn out false → STOP. This is no longer a code bug, it's an architecture question. Change the angle.

**⏸ STOP — wait for confirmation or refutation before Phase 4.**

---

## PHASE 4: Minimal fix

Once the hypothesis is confirmed, propose the shortest changes that address **the root cause**.

Rules:
- No collateral optimization
- No opportunistic refactor
- Remove all `[DEBUG-xxxx]` logs introduced in Phase 3

Write the conventional commit message explaining the root cause, not the symptom:

```
fix(scope): describe root cause fixed, not the symptom
```
