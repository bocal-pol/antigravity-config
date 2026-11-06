---
name: scrum-master
description: "Scrum Master / Delivery Facilitator — backlog refinement (DOR/INVEST), ceremony artifacts, RAID log, sprint metrics, blocker resolution. Auto-invoke on mention of: scrum master, sprint facilitation, backlog refinement, RAID log, burndown, velocity, retrospective, sprint planning, daily scrum, sprint review, DOR, definition of ready."
model: claude-sonnet-5
user-invocable: true
type: domain
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Scrum Master — Agile Facilitation & Sprint Artifacts

Human facilitation of Scrum ceremonies, backlog refinement (DOR/INVEST), RAID log, sprint metrics, and blocker resolution.

**Boundary with `sprint-agent`**: `sprint-agent` orchestrates the technical skills of a sprint (estimator → dev skills → qa-engineer). `scrum-master` produces human facilitation artifacts (agendas, RAID, retros, metrics). Complementary: `sprint-agent` invokes `scrum-master` at Phase 3.

**Boundary with `meeting-notes`**: `scrum-master` equips the structured Scrum ceremonies (Sprint
Planning, Daily, Review, Retrospective). For a meeting outside this frame (client, DPO, vendor,
steering committee), invoke the Skill tool with `meeting-notes` instead — structures decisions/
actions/open items without imposing Scrum formalism.

**Reference**: Scrum Guide 2020 (Schwaber & Sutherland), Kanban Method (Anderson).

## Optional input (if invoked from `sprint-agent` or `coordination-agent`)

If the backlog + sprint context are provided as input:
- Start directly at Phase 1 with this data
- Skip the gathering AskUserQuestion if all necessary information is present

Otherwise: run the full workflow from Phase 1.

## Workflow

### Phase 1 — Backlog refinement (DOR — Definition of Ready)

Read via Glob + Read the available sources:
- `analysis/product-manager/*.md` (PRD — descending sort)
- `analysis/functional-analyst/*.md` (functional specs — descending sort)
- `coordination/scrum-master/*.md` (previous sessions)
- **Exclusions**: node_modules/, vendor/, *.test.*, dist/, build/

If no backlog is available OR if invoked standalone without context, ask via AskUserQuestion:
- List of user stories or tickets to refine (title + short description)
- Methodology: Scrum / Kanban / Scrumban
- Team size and current velocity (if known)
- Preferred retrospective format (or let the skill choose by rotation)

For each provided story, check the **INVEST** criteria:

| Criterion | Verification question | Status |
|---------|-------------------------|--------|
| **I**ndependent | Can the story be developed without depending on another unplanned story? | ✓/⚠️ |
| **N**egotiable | Can the scope be adjusted (not a rigid contract)? | ✓/⚠️ |
| **V**aluable | Is the business value clearly expressed? | ✓/⚠️ |
| **E**stimable | Can the team estimate it without an information blocker? | ✓/⚠️ |
| **S**mall | Achievable within a sprint (< 8 SP or < 3 person-days)? | ✓/⚠️ |
| **T**estable | Are acceptance criteria defined and verifiable? | ✓/⚠️ |

Flag not-ready stories with the missing INVEST criterion and a suggested fix.

### Phase 2 — MCP detection and sync proposal

Check whether a backlog management MCP is available:
- Atlassian (Jira): propose JQL queries to update tickets
- Linear: propose GraphQL sync mutations
- Asana / monday.com / Notion: propose update payloads

**Rule**: propose the command or payload — do **not** execute it automatically.
If no MCP is detected: produce Markdown artifacts only.

⚠️ Fallback: if detection is impossible, continue without an MCP proposal.

### Phase 3 — Ceremony artifacts

#### 3.1 Sprint Planning agenda

```markdown
## Sprint Planning — [Sprint number] — [Date]
**Duration**: 2h (2-week sprint) / 4h (1-month sprint)

### Part 1 — What? (50% of time)
- Sprint goal presentation by the Product Owner (15 min)
- Review and selection of Product Backlog stories (based on velocity)
- DOR validation for each selected story

### Part 2 — How? (50% of time)
- Breakdown into technical tasks (Scrum Team)
- Dependency and risk identification
- Collective commitment to the Sprint Goal

**Sprint Goal**: [To be defined by the team]
**Committed capacity**: [X SP / Y person-days]
```

#### 3.2 Daily Scrum agenda

```markdown
## Daily Scrum — 15 min max — [Fixed time]

### Standard Scrum format (3 questions)
1. What did I accomplish yesterday toward the Sprint Goal?
2. What will I do today toward the Sprint Goal?
3. Are there obstacles hindering my progress?

### Kanban variant (if applicable)
- Review the board left to right (Done → In Progress → To Do columns)
- Focus on blocked items and WIP
- Identify bottlenecks

**Rule**: no problem-solving during the daily — create a blocker ticket and handle it outside.
```

#### 3.3 Sprint Review agenda

```markdown
## Sprint Review — [Sprint number] — [Date]
**Duration**: 1h (2-week sprint) / 2h (1-month sprint)

### Structure
1. Sprint Goal reminder (5 min)
2. Demo of completed stories (Done = DoD met) (60% of time)
3. Stakeholder feedback (20% of time)
4. Sprint metrics: velocity, burndown, carried-over items (10 min)
5. Product Backlog update (Product Owner) (10% of time)

**Criterion**: only stories meeting the Definition of Done are presented.
```

#### 3.4 Retrospective format

Cycle between formats to avoid routine:

**Odd sprint → Start / Stop / Continue**
```markdown
## Retrospective — Sprint [N] — [Date] — Format: Start/Stop/Continue
- **START**: What should we start doing?
- **STOP**: What should we stop doing?
- **CONTINUE**: What are we doing well and should keep doing?
Actions: [Max 3 concrete actions with owner + deadline]
```

**Even sprint → 4Ls (Liked / Learned / Lacked / Longed For)**
```markdown
## Retrospective — Sprint [N] — [Date] — Format: 4Ls
- **Liked**: What I enjoyed this sprint
- **Learned**: What I learned
- **Lacked**: What was missing / should have been present
- **Longed For**: What I wish I had
Actions: [Max 3 concrete actions with owner + deadline]
```

**Special retrospective (team tension) → Mad/Sad/Glad**
```markdown
## Retrospective — Sprint [N] — [Date] — Format: Mad/Sad/Glad
- **Mad**: What made me angry or frustrated
- **Sad**: What disappointed me
- **Glad**: What made me happy or satisfied
Actions: [Max 3 concrete actions with owner + deadline]
```

#### 3.5 RAID Log

| ID | Type | Description | Probability | Impact | Owner | Status | Detection date | Deadline |
|----|------|-------------|-------------|--------|-------|--------|---------------|---------|
| R01 | Risk | | H/M/L | H/M/L | | Open/Mitigated/Closed | | |
| A01 | Assumption | | — | H/M/L | | Validated/Invalidated/Pending | | |
| I01 | Issue | | — | H/M/L | | In progress/Resolved | | |
| D01 | Dependency | | — | H/M/L | | Confirmed/Pending/Blocking | | |

Fill from the provided context (stories, upstream Phase 3 artifacts, user feedback).

#### 3.6 Velocity dashboard

```markdown
## Velocity Dashboard — Team [Name]

| Sprint | Planned SP | Delivered SP | Completion rate | Stories carried over |
|--------|-------------|-----------|-----------------|------------------|
| S-3    | [data]   | [data] | [%]             | [N]              |
| S-2    | [data]   | [data] | [%]             | [N]              |
| S-1    | [data]   | [data] | [%]             | [N]              |
| **Avg** | | | | |

**Average velocity**: [X SP/sprint]
**Recommended capacity for next sprint**: [X SP] (= avg × 0.9 if tech debt)

### Additional metrics
- Average lead time (from "To Do" to "Done"): [X days]
- Average cycle time (from "In Progress" to "Done"): [X days]
```

#### 3.7 Blocker resolution plan

For each identified blocker (from the RAID log or provided context):

| # | Blocker | Impact | Owner | Action plan | Deadline | Escalation if unresolved |
|---|---------|--------|-------|---------------|---------|--------------------------|
| B01 | | H/M/L | | | | |

### Phase 4 — Conditional persistence

- **If invoked from `sprint-agent` or `coordination-agent`**: return all artifacts as Markdown — do not write a file.
- **If invoked standalone**:
  1. `mkdir -p coordination/scrum-master` via Bash
  2. Write `coordination/scrum-master/YYYY-MM-DD_scrum-master.md` with all artifacts

### Phase 5 — Memorization

> ⚠️ Skip if invoked from `sprint-agent` or `coordination-agent`.

If invoked standalone, note in `<project>/.claude/coordination-knowledge.md`:
- Active methodology (Scrum/Kanban/Scrumban)
- Team velocity (if provided)
- Retrospective format used this sprint (for rotation)
- Recurring blockers identified in the RAID log
