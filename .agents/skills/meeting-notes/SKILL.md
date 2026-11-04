---
name: meeting-notes
description: "Structures the minutes of a project meeting outside the Scrum ceremony framework: attendees, decisions made, actions assigned with a deadline. Auto-invoke on mention of: minutes, meeting, meeting notes, decisions made, client meeting, DPO meeting, vendor meeting."
model: claude-haiku-4-5-20251001
user-invocable: true
type: utility
priority: low
scope: cross
dependencies: []
conflicts: []
---

# Meeting Notes — Meeting Minutes

Structures the minutes of any project meeting that isn't a Scrum ceremony already tooled by
`scrum-master` (Sprint Planning, Daily, Review, Retrospective) — typically a client meeting, a
check-in with the DPO, a vendor exchange, a steering committee, or any ad hoc meeting.

## Scope — when to use this skill rather than `scrum-master`

| Situation | Skill |
|---|---|
| Tooled Scrum ceremony (Planning, Daily, Review, Retro) | `scrum-master` |
| Client meeting, steering committee, DPO check-in, vendor exchange, ad hoc meeting | `meeting-notes` (this skill) |

Both produce persisted, consultable artifacts — no meeting should disappear into a calendar event
with no trace.

## Optional input (orchestrable)

If invoked with already-structured context (attendees, raw notes, relevant project), use it
directly without re-asking the Phase 1 questions.

## Workflow

### Phase 1 — Collection

If not provided as input, ask via **AskUserQuestion**:
1. Relevant project (to attach the entry to).
2. Attendees (names/roles).
3. Meeting type: client / DPO-compliance / vendor / steering committee / other.
4. Raw notes or an oral summary of what was said.

### Phase 2 — Structuring

Extract three distinct categories from the raw notes, without mixing them:
- **Decisions made**: what was settled during the meeting (not a mere discussion).
- **Actions**: each action with an owner and a deadline — an action with no owner or deadline isn't
  an action, it's an intention; flag it as incomplete rather than omitting it.
- **Open points**: what remains open, to be addressed at a future meeting.

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
[Scheduled date, or "To be scheduled"]
```

### Phase 4 — Conditional persistence

- **Standalone**: create the directory via Bash (`mkdir -p meetings`), write
  `meetings/YYYY-MM-DD_[type]-[project-slug].md`.
- **Orchestrated**: return the Markdown content, persistence handled by the caller.

Explicitly attach the entry to a project in the filename — the goal is that a project management
tool can list a given project's meeting history without having to parse the content.

## Note for the GDPR/DPO track

A `DPO-compliance` meeting (e.g. DPO contact made, a legal basis validated) should be referenced
from `compliance-officer` as evidence of due diligence — mention the path of the file produced here
in the GDPR report rather than duplicating its content.

## Skip memory

The `meetings/*.md` minutes are versioned project deliverables, not memories — don't record them in
`~/.claude/memory/`.
