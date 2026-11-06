---
name: team-selector
description: "Smart agent AND skill selector — framing interview, then produces the optimal combination to activate (Core / Optional / Excluded): team-dev orchestrator agents, directly invocable skills, and mode sequence. Reads the frontmatter of available agents + skills/SKILLS_INDEX.md + personal-agents.json for personal POs. Automatically invoked by team-dev --full and --auto. Also user-invocable to explore before launching a session. Auto-invoke on: \"which agents to activate\", \"which skills to use\", \"what team for X\", \"how to organize for X\", \"select the right agents\", \"team-dev auto\"."
model: claude-sonnet-5
user-invocable: true
type: orchestrator
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Team Selector — Smart Agent Router

Analyzes a request and builds the optimal combination of agents for `team-dev`.
Prevents activating out-of-scope agents. Integrates personal PO selection.

> **Principle**: 3 well-chosen agents beat a 12-agent run where 8 serve no purpose.

## Input (if invoked from `team-dev`)

Receive:
- `[DESCRIPTION]` — the request in natural language
- `[MODE]` — `full` or `auto` (determines whether the selection is returned for validation or executed directly)

Otherwise: collect via AskUserQuestion.

## Workflow

### Phase 1 — Framing interview

If invoked from `team-dev` with `[DESCRIPTION]` already provided: go directly to Phase 2, unless
the description is too vague to decide (e.g. "improve my project") — in that case, ask
only the questions below whose answer is missing, not the full interview.

If invoked standalone: ask via `AskUserQuestion`, in a single wave if possible — don't
spread over multiple back-and-forths what can be asked at once:

```
Team Selector — Framing the need:

1. Nature of the work: new project (from scratch) · feature on existing code ·
   bug fix · audit/review · redesign · one-off task (docs, release, dependencies...) ?

2. Domains touched (check all that apply):
   [ ] Backend  [ ] Frontend  [ ] Mobile  [ ] Infra/Cloud  [ ] Data  [ ] Security
   [ ] Design/UX  [ ] Compliance (GDPR/ISO/NIS2)  [ ] Documentation  [ ] Other: ___

3. What must exist at the end for the work to be complete — not just "it works,"
   but the concrete expected deliverables: working code? tests? documentation? deployment?
   verified compliance? audit report?

4. Known constraints:
   [ ] Time constraint (need it fast, minimize number of steps)
   [ ] Specific technical context: ___
   [ ] Deliberately limited scope (e.g. just docs, just security)
   [ ] None

5. Desired autonomy level: you execute and show me the result · you propose the
   breakdown and I decide before execution · I just want the list, I'll execute myself?
```

Dig into any vague answer to question 3 before moving to Phase 2 — a poorly defined
deliverable produces an incomplete breakdown in output, exactly the flaw this skill must avoid.

### Phase 2 — Reading the agent catalog

Via Glob, list all `.agents/*.md` files.
For each file found, read the first 4 lines (name + description frontmatter).
Build an in-memory catalog: `{ name, description, file }`.

**Exclude from the catalog any file whose `description` starts with `Alias of `.**
These files are compatibility aliases: they carry an old agent name and delegate
fully to the real agent. Keeping them would create two entries for a single capability,
with no criterion to differentiate them — that's what made selection non-deterministic.

If the user explicitly names an alias (e.g. "use backend-agent"), resolve it to its
target and announce it: "`backend-agent` is an alias of `backend-agent` — this is what's being activated."

### Phase 3 — Reading personal POs

Read `~/.claude/personal-agents.json`.

**⚠️ Fallback**: if this file is absent or declares no PO with `active: true`, skip phases 3
and 5 **silently** — no question, no warning. An environment with no PO is valid.

For each PO with `"active": true`:
- Check whether any `auto_suggest_if` keyword appears in the request description (case-insensitive)
- Mark the PO as `auto_suggested` if a match is found, otherwise `available`

### Phase 4 — Agent classification

Apply the following reasoning to EACH agent in the catalog:

#### Domain profiles of orchestrator agents

| Agent | Primary domain | Activate if |
|-------|------------------|-----------|
| `product-agent` | Product, requirements, user stories | Almost always — defines the "what" |
| `architecture-agent` | Technical architecture, ADRs, stack | As soon as a system needs building or modifying |
| `security-agent` | Application security, pentest | Sensitive data, authentication, public API, finance |
| `qa-lead-agent` | Tests, quality, automation | Almost always for a software deliverable |
| `design-agent` | UX/UI, wireframes, design system | A user interface is present |
| `documentation-agent` | Technical docs, guides, API | A deliverable requiring documentation |
| `coordination-agent` | Agile, sprint, team planning | Planning, project management, a real team |
| `infrastructure-agent` | Infrastructure, network, cloud, DevOps | Deployment, servers, network, containers |
| `game-dev-agent` | Video games, gameplay, shaders | Explicitly a video game |
| `algorave-agent` | Live coding, algorithmic music | Explicitly procedural music / algorave |
| `sprint-agent` | Sprint planning only | One-off agile planning need |
| `release-agent` | Release, changelog | Version delivery |
| `project-bootstrap-agent` | Bootstrap: App Spec, Brand Brief, Data Dictionary, Backlog | New project with no intake kit — before `product-agent` |
| `backend-agent` | Backend development Laravel / .NET / API | Server code to write or review — `composer.json` or `*.csproj` present |
| `frontend-agent` | Frontend development Angular / React | Web interface to code — `package.json` with `@angular/core` or `react` |
| `mobile-agent` | Mobile development Flutter / React Native | `pubspec.yaml` or React Native detected |
| `integration-agent` | REST/GraphQL integration, ESB, Kafka, EDI, API management | Connectors, messaging, third-party API contracts |
| `data-agent` | Data engineering, BI, ML | Pipelines, warehouse, dashboards, models |
| `it-operations-agent` | IT operations, ITIL support, CMDB | Operations, runbooks, incidents, changes |
| `pr-review-agent` | Code / PR review | Existing code to review before merge |
| `compliance-officer` (skill) | GDPR, ISO 27001, NIS2 | Personal data, regulated sector, regulatory audit |

#### Bounded development request (the most frequent case)

```
IF the request is a precise development task (endpoint, screen, component, migration, fix):
  → stack agent: CORE — backend-agent / frontend-agent / mobile-agent depending on detected files
    (composer.json or *.csproj → backend · package.json angular/react → frontend · pubspec.yaml → mobile)
  → qa-lead-agent: CORE (deliverable testing)
  → product-agent, architecture-agent: OPTIONAL — only if the need or architecture is unclear
  → security-agent: OPTIONAL — CORE if auth, personal data, or a public API is touched
  → everything else: EXCLUDED
```

Never propose the whole team for a single endpoint: 2-3 agents are enough.

#### Automatic exclusion rules

```
IF the request is a standard business application (todo, CRM, e-commerce, dashboard...):
  → game-dev-agent: EXCLUDED (not a game)
  → any persona agent (algorave, survival-logistics, race-engineering, game-master, legal-compliance, pilgrimage-route): EXCLUDED

IF the request is a video game:
  → product-agent: CORE (defines the game design document)
  → game-dev-agent: CORE
  → design-agent: OPTIONAL (if interface/menus are present)
  → algorave-agent: EXCLUDED (unless procedural music is explicitly mentioned)

IF the request is music / live coding:
  → algorave-agent: CORE
  → game-dev-agent: EXCLUDED
  → infrastructure-agent: EXCLUDED (unless streaming deployment)

IF the request is pure infrastructure (network, servers):
  → infrastructure-agent: CORE
  → design-agent: EXCLUDED (no interface)
  → game-dev-agent: EXCLUDED

IF the request mentions "documentation only":
  → documentation-agent: CORE
  → All others: OPTIONAL or EXCLUDED depending on context
```

#### Classification levels

- **✅ Core**: indispensable agent — its absence produces an incomplete or risky deliverable
- **🟡 Optional**: useful agent depending on scope — ask for confirmation
- **❌ Excluded**: out-of-domain agent — don't activate, explain why

#### Reasoning examples

**Request**: "Web task-management app for a small business"
```
✅ Core     : product-agent (requirements), architecture-agent (stack), qa-lead-agent (tests)
🟡 Optional : design-agent (interface present but unspecified), security-agent (multi-user?)
              documentation-agent (if client delivery)
❌ Excluded : game-dev-agent (not a game)
              infrastructure-agent (unless cloud deployment is requested)
```

**Request**: "Develop a 2D platformer game in Godot 4"
```
✅ Core     : game-dev-agent (gameplay, shaders, physics, game feel)
🟡 Optional : design-agent (game menus and UI), qa-lead-agent (gameplay tests)
❌ Excluded : product-agent (replaced by a GDD within game-dev-agent)
              infrastructure-agent, documentation-agent (out of immediate scope)
```

**Request**: "Add PDF invoice export to the back-office"
```
✅ Core     : backend-agent (server-side generation, async job)
🟡 Optional : qa-lead-agent (render testing), design-agent (button and action states)
❌ Excluded : product-agent, architecture-agent (bounded scope, no architecture decision)
              game-dev-agent (out of domain)
```

> Rule from the 2026-09-17 audit: **a bounded development task mobilizes 2-3 agents, not eight.**
> Widening the selection "just in case" costs one context window per agent for no extra deliverable.

### Phase 4bis — Directly invocable skills (complement to agents)

An orchestrator agent already invokes internally some of the relevant skills (e.g. `security-agent`
calls `appsec`/`semgrep`) — don't re-list them separately, that would be a duplicate entry for the
same capability. This phase covers two cases Phase 4's agent selection doesn't address:

1. **A one-off need that doesn't justify any orchestrator agent** — e.g. "check if my dependencies
   are up to date" doesn't deserve launching the full `infrastructure-agent`: `/dependency-updater` or
   `/version-checker` alone is enough.
2. **A cross-cutting skill that adds alongside the agent sequence** without any agent already
   invoking it automatically for this exact scope — e.g. `/legal-pages` on a project with public
   exposure but no pass through `compliance-officer`, or `/onboarding` at the end of a project.

Read `skills/SKILLS_INDEX.md` (Glob + Read, not a Grep of the entire `skills/` folder — the index
exists precisely to avoid scanning 186 files). For each Phase 1 answer (nature of the work,
domains, expected deliverables), cross-reference with the index's thematic sections and keep
skills whose role isn't already covered by an agent classified ✅ Core/🟡 Optional in Phase 4.

Classify with the same levels as Phase 4 (✅ Core / 🟡 Optional / ❌ Excluded), in a
separate list to avoid mixing two different granularities (agent = team, skill = one-off tool):

```
### Skills to invoke directly (outside the scope of selected agents)

| Priority | Skill | Invocation | Reason |
|----------|-------|-----------|--------|
| ✅ Core | `dependency-updater` | `/dependency-updater` | Standalone dependency update, no need for a full agent |
| 🟡 Optional | `onboarding` | `/onboarding` | Useful if the project gains a contributor, not immediately essential |
```

If no skill complements the agent selection (frequent case for a classic development
already covered by Core agents), don't display this section — never fill an empty table for
form's sake.

### Phase 5 — Personal PO selection

**List built dynamically** from `personal-agents.json` read in Phase 3 — never hardcoded,
the registry evolves. For each PO with `active: true`: a `[★ Auto-suggested]` line if an
`auto_suggest_if` keyword was found (cite the keyword), otherwise `[Available]`.

**Only ask the question if at least one PO is auto-suggested.** For a development request
with no PO keyword, silently skip this phase — that's the normal case.

Ask via AskUserQuestion:
```
Personal POs to include in this session?

[Check the relevant ones — auto-suggested ones are pre-checked]
☑ <label> — <short description> (detected: "<keyword>")
☐ <label> — <short description>
…

→ Or type "none" to ignore all POs
```

### Phase 6 — Selection report

Produce the following structured output:

```markdown
## Agent Selection — [Request title]

### Analysis
[2-3 sentences: project nature, domains involved, identified risks]

### Agents to activate

| Priority | Agent | team-dev mode | Role | Reason |
|----------|-------|--------------|------|--------|
| ✅ Core | `product-agent` | `--product` | Requirements, user stories, PRD | Mandatory entry point |
| ✅ Core | `architecture-agent` | `--architecture` | Stack, ADRs, constraints | Structuring technical decisions |
| ✅ Core | `qa-lead-agent` | `--qa-lead` | Tests, validation | An unvalidated deliverable isn't a finished deliverable |
| 🟡 Optional | `design-agent` | `--design` | UX/UI | Interface present but scope unspecified |
| 🟡 Optional | `security-agent` | `--security` | Security | Multi-user → data to protect |
| ❌ Excluded | `game-dev-agent` | `--game-dev` | — | Business app, not a game |

### Skills to invoke directly (outside the scope of selected agents)

*Section omitted if Phase 4bis found nothing to add — the normal case for a development already
covered by the agents above.*

| Priority | Skill | Invocation | Reason |
|----------|-------|-----------|--------|
| *(none)* | — | — | — |

### Included POs

*Section omitted if no PO is retained — the normal case for a development request.*

| PO | Mode | Reason for inclusion |
|----|------|--------------------|
| *(none)* | — | — |

### Recommended execution sequence
1. `--product` (product-agent) — feeds architecture
2. `--architecture` — feeds design + security
3. `--design` (if retained) — feeds the specs
4. `--security` (if retained)
5. Direct `/<skill>` calls (Phase 4bis), at the insertion points indicated by their reason
6. `--qa-lead` — closes the loop

### For the work to be complete
[Restate the answer to question 3 of Phase 1 and explicitly confirm that every announced
deliverable — code, tests, documentation, deployment, compliance, report — is covered by at least one
Core line in the selection above. An expected deliverable with no covering agent/skill is a gap
to flag here, not to pass over in silence.]

### Estimate
- Core agents: X | Optional retained: Y | Direct skills: Z | Total: N elements
- Estimated duration: ~[X] minutes

---
> Validate this selection or modify it before launching execution.
> To launch directly: each mode can be invoked separately via `/team-dev --[mode]`,
> each direct skill via `/<skill-name>`.
```

### Phase 7 — Output to team-dev

- **If invoked from `team-dev`**: return the structured selection as a context object for the following phases. Don't write a file. Don't execute the agents.
- **If invoked standalone**, comply with the autonomy level given in response to question 5
  of Phase 1:
  - **"you execute"**: display the report then directly chain the sequence's execution
    (agents via `Agent(...)`, skills via the Skill tool) without waiting for further confirmation.
  - **"you propose, I decide"** (default if the question wasn't asked, e.g. called from
    `team-dev`): display the report and wait for explicit validation before any execution —
    offer "Launch execution via team-dev? (`/team-dev --auto [description]`)".
  - **"list only"**: display only the report (Phase 6), offer no execution, don't
    re-ask the question at the end — the user said they execute themselves.

### Phase 8 — Memorization

> ⚠️ Skip if invoked from `team-dev`.

If notable selection patterns emerge (e.g. "for this project, gamedev always excluded"), note it in `~/.claude/projects/[project]/team-selector-patterns.md`.
