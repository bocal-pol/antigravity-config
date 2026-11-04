---
name: meeting-notes
description: "Structures the minutes of a project meeting outside the Scrum cadence: attendees, decisions made, actions assigned with a deadline. Auto-invoke on mention of: meeting minutes, meeting, meeting notes, decisions made, client meeting, DPO meeting, supplier meeting."
model: claude-haiku-4-5-20251001
user-invocable: true
type: utility
priority: low
scope: cross
dependencies: []
conflicts: []
---

# Meeting Notes — Meeting Minutes

Structures the minutes of any project meeting that isn't a Scrum ceremony covered by
`scrum-master` (Sprint Planning, Daily, Review, Retrospective) — typically a client meeting,
a check-in with the DPO, a supplier exchange, a steering committee, or any ad hoc meeting.

## Scope — when to use this skill instead of `scrum-master`

| Situation | Skill |
|---|---|
| Tooled Scrum ceremony (Planning, Daily, Review, Retro) | `scrum-master` |
| Client meeting, steering committee, DPO check-in, supplier exchange, ad hoc meeting | `meeting-notes` (this skill) |

Both produce persisted, searchable artifacts — no meeting should vanish into a calendar event
without a trace.

## Optional input (orchestrable)

If invoked with context already structured (attendees, raw notes, relevant project), use it
directly without re-asking the Phase 1 questions.

## Workflow

### Phase 1 — Collection

If not provided as input, ask via **AskUserQuestion**:
1. Relevant project (to link the entry to it).
2. Attendees (names/roles).
3. Meeting type: client / DPO-compliance / supplier / steering committee / other.
4. Raw notes or a verbal summary of what was discussed.

### Phase 2 — Structuring

Extract three distinct categories from the raw notes, without mixing them:
- **Decisions made**: what was actually settled during the meeting (not just discussed).
- **Actions**: each action with an owner and a deadline — an action without an owner or
  deadline isn't an action, it's an intention; flag it as incomplete rather than omitting it.
- **Open points**: what remains open, to be addressed in a future meeting.

### Phase 3 — Drafting

```markdown
# Minutes — [Meeting type] — [Project] — YYYY-MM-DD

## Attendees
- ...

## Decisions made
| # | Decision | Scope |
|---|----------|--------|

## Actions
| # | Action | Owner | Deadline | Status |
|---|--------|-------|----------|--------|

## Open points
- ...

## Next meeting
[Scheduled date, or "To be planned"]
```

### Phase 4 — Conditional persistence

- **Standalone**: create the folder via Bash (`mkdir -p meetings`), write
  `meetings/YYYY-MM-DD_[type]-[project-slug].md`.
- **Orchestrated**: return the Markdown content, persistence handled by the caller.

Explicitly link the entry to a project in the file name — the goal is that a project-management
application can list a given project's meeting history without having to parse the content.

## Note on the GDPR/DPO angle

A `DPO-compliance` meeting (e.g. DPO contact made, a legal basis validated) should be referenced
from `compliance-officer` as evidence of due diligence — mention the path of the file produced
here in the GDPR report rather than duplicating its content.

## Skip memorization

`meetings/*.md` minutes are versioned project deliverables, not memories — do not log them in
`~/.claude/memory/`.
