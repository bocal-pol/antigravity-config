---
name: user-call
description: Non-technical phone support for end users — generates simple jargon-free questions to ask the user, translates their answers into a technical diagnosis, guides step-by-step with simple visual instructions.
model: claude-sonnet-5
user-invocable: true
aliases: ["/uc"]
argument-hint: "[quick description of the reported problem]"
type: framework
priority: medium
scope: cross
dependencies:
  - incident-pattern
conflicts: []
---

# User Call — Non-Technical User Phone Support

Assists during phone calls with end users who have no technical background. Translates answers into a diagnosis, generates simple visual instructions.

## Phase 0 — Technician briefing (internal, not read to the user)

Collect:
1. Problem reported by the user (in their own words)
2. Is the user at their PC during the call?
3. Can remote control be taken (TeamViewer, RDP)?
4. Urgency (fully blocked / partially functional)?

## Phase 0b — incident-pattern pre-check

Silently check `tickets/task-list.md`. If a similar pattern is detected → display the alert before continuing.

## Phase 1 — Questions to read verbatim to the user

```
"Hello, I'm [your name] from IT support. I'll help you resolve your issue."

"To help you, I need you to answer a few simple questions."

1. "Is your computer turned on and can you see your desktop?"
2. "How long have you had this problem?"
3. "What exactly is happening — what do you see, or what isn't working?"
4. "Is there an error message? If so, can you read it to me?"
5. "Did this start after something specific? (restart, update, installation...)"
```

## Phase 2 — Translating answers into a diagnosis

After receiving the answers, analyze and translate them into a technical diagnosis.

## Phase 3 — Visual instructions (to read to the user)

Rules:
- One action at a time, confirmed before the next
- Describe visually (e.g. "the blue button at the bottom left" rather than "click Start")
- No jargon: "the clock at the bottom right" rather than "the taskbar"
- Confirm at each step: "Do you see that?"

## Phase 4 — Actions available without admin rights

| Problem | Action without rights |
|---|---|
| Printer offline | Turn the printer off/on, remove and re-add it |
| Frozen application | Alt+F4, then reopen |
| Disappeared window | Alt+Tab or look in the taskbar |
| Unrecognized USB device | Unplug/replug, try another port |
| No sound | Click the sound icon, check volume and output |
| Slow internet | Restart the browser, clear the cache |
| Slow PC | Restart the PC (not just close the lid) |
| Black screen | Press a keyboard key, check the screen cable |

## Phase 5 — Escalation

If unresolved:
```
"I'll check this on my end and call you back / take remote control.
In the meantime, here's what I'm asking you to do: [a simple action or nothing].
Your ticket number is [XX]."
```

## Phase 6 — Summary

Call `bulletin-service append` with the call summary.
