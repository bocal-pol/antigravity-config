---
name: team-dev
description: Main orchestrator of the development team — delegates to specialized agents depending on the mode, or orchestrates the full project lifecycle in --full mode. Invoke via /team-dev <mode> [context].
model: claude-opus-5
user-invocable: true
type: orchestrator
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Team Dev — Main Orchestrator

Analyzes the request and delegates to the appropriate specialized agent depending on the invoked mode.
In `--full` mode, orchestrates the entire project lifecycle in logical order.

Agents live in `.agents/` and are registered by the harness as `subagent_type`: launch them directly via the Agent tool, **without re-reading their file** (re-reading it would load it twice into context).

## Usage

```
# ─── Smart mode (recommended) ──────────────────────────────────────────
/team-dev --auto <description>         ← team-selector chooses the agents + POs
/team-dev --full <description>         ← end-to-end project with guided selection
/team-dev --audit [target]             ← post-dev multi-profile audit (read-only) → remediation plan

# ─── Domain modes (active) ───────────────────────────────────────────────
/team-dev --bootstrap [description]     ← intake kit (App Spec, Brand, Data Dict, Backlog, Integrations, Error Journal, + legal/accessibility draft if forms/payment/external users)
/team-dev --product [description]       ← full product cycle (analyst → PM → FA)
/team-dev --architecture [target]       ← architecture & ADRs
/team-dev --security [target]           ← full security audit
/team-dev --compliance [context]        ← GDPR / ISO 27001 / NIS2 compliance
/team-dev --gdpr [target]               ← GDPR audit + iterative correction cycle
/team-dev --pr-review [files]           ← code review / PR
/team-dev --sprint [objective]          ← sprint planning & backlog
/team-dev --release [version]           ← changelog & release
/team-dev --onboarding                  ← project startup guide
/team-dev --project-map [target]        ← interactive HTML codebase map (Floorplan plugin)
/team-dev --dev-tools [up|down|ps|logs|track|check] ← PostHog/Uptime Kuma dev-only (observability)
/team-dev --deps                        ← dependency updates
/team-dev --versions [target]           ← checks language/framework versions, proposes an update plan
/team-dev --qa-lead [target]            ← tests, E2E automation, perf
/team-dev --bug [file|description]      ← error validation + memory rules
/team-dev --fix [BUG-XXX,...]           ← cycle: re-test QA → user re-validation
/team-dev --investigate [description]   ← structured 4-phase root-cause analysis (hypotheses → logs → minimal fix)
/team-dev --documentation [target]      ← full documentation
/team-dev --frontend [target]           ← Angular / React development / migration
/team-dev --seo [target]                ← live SEO (open-seo/DataForSEO) or static artifacts (seo-geo) depending on context
/team-dev --no-slop [text]              ← anti-AI-slop prose edit/audit (edit or detect)
/team-dev --adhd                        ← enables action-first response mode for the session
/team-dev --backend [target]            ← Laravel / .NET / API development
/team-dev --mobile [target]             ← Flutter / React Native development
/team-dev --design [description]        ← UX/UI design & design system
/team-dev --illustrate [description]    ← generates an Excalidraw diagram + PNG/SVG export
/team-dev --infrastructure [description] ← infrastructure, DevOps, SRE, cloud
/team-dev --data [description]          ← data engineering, BI, ML
/team-dev --integration [description]   ← integration, ESB, Kafka, EDI, API Gateway
/team-dev --it-operations [context]     ← IT operations, ITIL support, CMDB
/team-dev --coordination [objective]    ← agile coordination & management
/team-dev --gamification [product]      ← Octalysis × D&D analysis + engagement mechanics roadmap
/team-dev --game-dev [mechanic]         ← video game dev (gameplay, shader, physics, game feel)
/team-dev --ask <skill> [context]       ← invoke a skill directly
/team-dev --query <question>            ← question about the architecture via the graph (read-only)
/team-dev --graph-impact <file>         ← measures the impact of a change on a file
```

#### Persona modes

Domain expertise backed by a persona. `team-selector` excludes them by default from a
development cycle — they're only invoked explicitly or on a domain keyword.

```bash
/team-dev --algorave [style]            ← Strudel live-coding, algorithmic patterns
/team-dev --survival [mission]          ← prepping, bivouac, hiking, survival garden
/team-dev --race-engineering [analysis] ← F1/FE/WEC strategy, Rubik's cube, algorithms
/team-dev --game-master [session]       ← tabletop RPG, board games, bivouac cooking, playlists
/team-dev --legal-compliance [case]     ← local legal compliance, safety, weapons, forestry
/team-dev --creativity-theory [topic]   ← idea-creation theories, idea box
/team-dev --pilgrimage-route [stage]    ← long-distance pilgrimage route planning
/team-dev --mentor [situation]          ← no-nonsense executive mentor, one action per week
/team-dev --socratic-method [topic]     ← maieutics, one question at a time, never the answer
/team-dev --trainer [topic]             ← step-by-step pedagogy, verified before moving on
/team-dev --paid-consultant [problem]   ← single costed recommendation, max 3 options, decisive
/team-dev --creative-director [work]    ← direct publish/fix/redo verdict, no leniency
/team-dev --ceo-decision [decision]     ← decisive call, 30-day metric, hard deadline
/team-dev --devils-advocate [project]   ← honest counter-argument before investing/hiring
```

### Short aliases

Accept either the alias or the long mode interchangeably: `/team-dev -back` is equivalent to `/team-dev --backend`.
Resolve the alias to its long mode **before** any other workflow step.

| Alias | Long mode | Alias | Long mode |
|-------|-----------|-------|-----------|
| `-prj` | `--product` | `-qa` | `--qa-lead` |
| `-arch` | `--architecture` | `-b` | `--bug` |
| `-sec` | `--security` | `-fx` | `--fix` |
| `-co` | `--compliance` | `-sprint` | `--sprint` |
| `-rg` | `--gdpr` | `-rel` | `--release` |
| `-rev` | `--pr-review` | `-doc` | `--documentation` |
| `-back` | `--backend` | `-ux` | `--design` |
| `-front` | `--frontend` | `-data` | `--data` |
| `-mob` | `--mobile` | `-integ` | `--integration` |
| `-infra` | `--infrastructure` | `-ops` | `--it-operations` |
| `-agile` | `--coordination` | | |

Routing modes (`--auto`, `--full`, `--audit`, `--bootstrap`) and utilities (`--ask`,
`--query`, `--graph-impact`) have no alias: write them out in full.

## Workflow

> **Actual execution order**: Phase 1 (argument analysis, no writes) → Phase 0d (disciplines) → Phases 0 / 0b / 0e (context, read-only) → Phase 0f (version check) → Phase 2 (dispatch). The historical numbering is kept for internal cross-references.

<SUBAGENT-STOP>

### Phase 0 — Project mapping (project-graph) — optional

**Condition**: Graphify is actually available. Check **once per session**, silently:

1. If `.claude/project-graph.md` already exists in the project → read it (next step), don't regenerate.
2. Otherwise, test for the CLI's presence: `graphify --version` (PowerShell: `Get-Command graphify`). Do **not** try `python -m graphify` nor suggest installation: on a machine without Python, the `python` command is a Microsoft Store shortcut that fails.
3. If the CLI is present → invoke `project-graph` (deferred writing until the plan is validated, see Phase 1).
4. If absent → `GRAPH_CONTEXT = null`, **no warning**, move to Phase 0b. Phases marked "graph-aware" then use their standard behavior.

**Expected output (if available)**: updated `.claude/project-graph.md`

#### GRAPH_CONTEXT extraction (graph-aware)

After invoking `project-graph`, if `.claude/project-graph.md` was successfully generated:

1. Read `.claude/project-graph.md` via `Read`.
2. Extract the following sections and memorize them as **GRAPH_CONTEXT** for the session's duration:
   - **`god_nodes`**: list of central concepts (`## God nodes` section)
   - **`communities`**: names and members of detected communities
   - **`hot_files`**: files or modules most referenced among the god nodes
   - **`suggested_questions`**: questions suggested by the graph (`## Suggested questions` section)

Example of memorized GRAPH_CONTEXT:
```
GRAPH_CONTEXT:
  god_nodes: ["UserService", "AuthModule", "ApiController"]
  communities:
    - "Auth & Security": [UserService, AuthModule, JwtHelper]
    - "API & Controllers": [ApiController, RouteManager, Middleware]
    - "Data & Persistence": [Repository, Database, MigrationRunner]
  hot_files: ["src/services/UserService.ts", "src/auth/AuthModule.ts"]
  suggested_questions:
    - "How does data flow between UserService and the database?"
```

> **Important**: If `/compact` occurs mid-session and GRAPH_CONTEXT is no longer available, any graph-aware phase must re-read `.claude/project-graph.md` before continuing.

**Silent fallback**: if `.claude/project-graph.md` is absent or its sections are empty, define `GRAPH_CONTEXT = null` with no message. All phases marked "graph-aware" will use their standard behavior.

### Phase 0b — Personal PO selection (all modes)

On every `team-dev` invocation (regardless of mode):

1. Read `~/.claude/personal-agents.json`.
2. For each PO with `"active": true`, check whether an `auto_suggest_if` keyword is present in the description/context provided by the user.
3. If **at least one PO is auto-suggested**, or if the mode is `--full` (never for `--auto` nor for a development mode with no PO keyword: the normal case is to **silently** skip this phase):
   - Display the list via AskUserQuestion:
     ```
     Personal POs to include in this session?

     [★ = auto-suggested based on your request]
     ☐ / ★ [PO label] — [Short description]
     ...
     ➕ [Create a new PO]
     → Reply with the wanted PO IDs, space-separated (e.g. "race-engineering communications"), "new" to create a PO, or "none"
     ```
4. If the user answers **"new"** or **"create"** or **"+"**:
   - Invoke the `po-creator` skill immediately.
   - After creation, re-run the Phase 0b question with the updated list (the new PO will be included).
5. Memorize the list of selected POs for dispatching to subsequent phases.

**⚠️ Fallback**: if `personal-agents.json` is not found or declares no PO with `active: true`,
**entirely skip Phase 0b, silently**. No question, no warning, no "Create a
new PO" option: without a PO, this question is moot and would clutter every invocation.
A user who wants to create their first PO invokes `/po-creator` themselves.

> For persona modes (`--game-dev`, `--algorave`, `--survival`, `--race-engineering`, `--game-master`, `--legal-compliance`, `--pilgrimage-route`, `--mentor`, `--socratic-method`, `--trainer`, `--paid-consultant`, `--creative-director`, `--ceo-decision`, `--devils-advocate`) and modes with an implicit PO, the PO is already explicit: skip Phase 0b.

> **POs with no dedicated mode** (`productivity-coach`, `hr`, `public-communications`, `sales-offers`): there is no `--productivity-coach` / `--hr` / `--ask public-communications` / `--ask sales-offers` mode. These personas activate via Phase 0b (manual selection, including in `--full`) or via `--ask <id> [context]`. Check `personal-agents.json` for their `auto_suggest_if`. **`sales-offers` never does what it proposes without explicit sign-off**: even when selected in `--full`, it produces a proposal to validate, never an implementation.

> ⚠️ **`--creativity-theory` is deliberately absent from the list above.** The creativity-theory persona has a dedicated mode **and** remains auto-suggested in Phase 0b: its cross-cutting nature (idea system design, incubation, feedback loop) makes it relevant from technical modes too — typically `--frontend` or `--backend` on an idea-management screen. Don't add it to the list of modes that skip Phase 0b.

### Phase 0c — Cross-cutting hooks: `refacto`, `/security-review` & `/compact`

Two built-in commands are invoked automatically at opportune moments, regardless of mode.

**`refacto`** — structural refactoring of produced code:
- After any mode generating or modifying code (`--backend`, `--frontend`, `--mobile`, and the `--build` / `--update` sub-modes) → run on the produced or modified files.
- In `--full`: right after the Development group (step 6), before the security pass.
- **⚠️ Fallback**: if `refacto` is unavailable, continue without refactoring and display `⚠️ refacto unavailable — manual architecture review required`.

**`/security-review`** — security pass on produced code:
- After any mode generating or modifying code (`--backend`, `--frontend`, `--mobile`, and the `--build` / `--update` sub-modes) → run on the diff or produced files.
- In `--full`: right after the Development group, before Release.
- Before `--release`: no version ships without a security pass.
- Surface P0/P1 findings and address them (or log them to the action plan) before continuing.
- **Declared control ≠ implemented control**: when the produced code relies on an ADR or a security section of `ARCHITECTURE.md`, the pass verifies that every **declared** control (header, timeout, throttle, sanitizer, `state`, revocation, secret) has an implementation (file:line) **and** a test pinning it. An ADR without a test is not a protection (audit lesson from 2026-09-09).
- **SSO / IdP consumer** — as soon as a development touches delegated authentication (callback, provisioner, admin panel), apply the S1-S10 checklist from `security-audit` (Phase 2c): the entire IdP access block applied (`can_access`, `status`, not just `role`); decision before provisioning; `state` verified server-side before login; timeouts ≤ 10s; central revocation (back-channel / IdP logout, no privileged `remember`); cached role re-resolved; GDPR erasure compatible with re-login; authorization attributes outside `$fillable`; local revocation **and** IdP refusal tests (missing / suspended profile). The auth task isn't "done" while any line is KO.
- **Priority-0 backlog**: any uncorrected P0/P1 finding in the session is entered **at the top** of the project's `BACKLOG.md` (`SEC — Security (priority 0)` section), never just in the report.
- **⚠️ Fallback**: if `/security-review` is unavailable, invoke the `security-audit` skill and note it.

**`/compact`** — reduces accumulated context:
- At the end of each mode (logical task completed).
- Between two heavy `--full` / `--audit` steps, after an agent that read or produced a lot.
- After a large MCP request or reading many files.

**`retro`** — agentic environment retrospective:
- **Continuously, during each phase/mode**: as soon as a delegated agent encounters a user correction on its approach, a skill gap, or a repeated pattern — call `retro` for a short capture immediately, without waiting for the end of the cycle. This is the same instruction `retro` natively carries in its description; `team-dev` just relays it to the agents it orchestrates.
- **At the end of a mode** that produced code, or after a session marked by a long search, a costly tool call, or an error a check would have caught — in addition to continuous captures, not instead of them.
- **Before** the end-of-session `/compact` (the transcript must still be in context).
- Validated candidates go into `~/.claude/memory/skill-observations/log.md` (consumed by `improve-skills`) or `hindsight.md`. The global `Stop` hook (`stop.sh`) automatically displays, at the end of **any** session (not just `team-dev --full`), a grouped and prioritized report of pending observations — no manual invocation needed to see there's something to address.
- **⚠️ Fallback**: if `retro` is unavailable, log frictions manually in the observations log.

### Phase 0d — Coding discipline (`karpathy-guidelines` + `ponytail`)

Before any mode generating or modifying code (`--backend`, `--frontend`, `--mobile`, the `--build` / `--update` sub-modes, and `--pr-review`), **call the Skill tool twice** — with `karpathy-guidelines`, then with `ponytail` (one call per skill, never both names in a single call):

**1. `karpathy-guidelines`** — general discipline:
- **Think before coding** — make assumptions explicit; present multiple interpretations rather than silently picking one.
- **Simplicity first** — the minimum code that solves the problem, nothing speculative.
- **Surgical changes** — only touch what's necessary, respect existing style, don't refactor what isn't broken.
- **Goal-driven execution** — define verifiable success criteria (tests), loop until validated.

**2. `ponytail`** (`full` mode by default) — concrete gate **"before writing, go down the ladder"**: must it exist? → already there? → stdlib? → native? → dependency? → one line? → otherwise minimum. Lazy about solutions, never about reading (trace the real flow first). Guardrails never cut corners: validation, error handling, security, a11y. Also minimize the **interface** (deep modules), not just lines.

**Ahead of a significant change**: call the Skill tool with `cadrage` (alignment interview + shared vocabulary `CONTEXT.md` / `CONTEXT-MAP.md` + ADR) **before** implementing. Skip if the change is trivial.

**When fixing a bug** (`--fix`, or a dev fixing something): call the Skill tool with `debug` — reproduce → minimize → ranked hypotheses → instrument → fix → regression test → cleanup.

**Working branch** (`git-workflow`): before any code, read `git branch --show-current`. If the branch is `main`, `master`, or `develop`: call the Skill tool with `git-workflow` to create `feature/<slug>` from an up-to-date `develop`, **before** launching the stack agent. No code is produced on a protected branch — the `pre-tool-use.sh` hook would block the push, but the work would already be in the wrong place.

**Completion gates** (`unlazy`): before launching the stack agent, call the Skill tool with `unlazy` to write `.claude/tmp/GATES-<mode>-<slug>.md` (one observable criterion per deliverable, with `CHECK:` and `EXPECT:`). The mode is only declared complete once every gate carries an explicit `EVIDENCE:` or `ABANDON:`; the final report reflects the gates' state. Skip if the request is a trivial one-line fix.

> **⚠️ Fallback**: if `karpathy-guidelines`, `ponytail`, `cadrage`, `debug`, `git-workflow`, or `unlazy` is unavailable, apply their memorized principles (upstream alignment + discipline + decision ladder + guardrails + debug methodology + feature branch + verifiable criteria).

### Phase 0e — Topological analysis (DOMAIN_MAP)

**Condition**: only run if `GRAPH_CONTEXT ≠ null`. Otherwise, silent skip and `DOMAIN_MAP = null`.

From `GRAPH_CONTEXT.communities`, semantically map each community to team-dev agents via the correspondence table below. Matching is **semantic** (not exact): Claude applies judgment to map variants like "Identity Management" → keywords `auth`/`user`.

| Keywords in the community name | Mapped agents |
|-------------------------------------|--------------|
| `auth`, `security`, `permission`, `user`, `access`, `credential`, `identity` | `security-agent`, `backend-agent`, `compliance-officer` |
| `api`, `endpoint`, `controller`, `route`, `rest`, `graphql`, `http` | `backend-agent`, `integration-agent`, `pr-review-agent` |
| `frontend`, `component`, `ui`, `view`, `template`, `page`, `css`, `angular`, `react` | `frontend-agent`, `design-agent`, `accessibility-lead` |
| `mobile`, `screen`, `navigation`, `flutter`, `native`, `app`, `ios`, `android` | `mobile-agent` |
| `data`, `database`, `model`, `schema`, `repository`, `migration`, `orm`, `sql` | `backend-agent`, `data-agent`, `data-architect` |
| `infra`, `deploy`, `docker`, `kubernetes`, `pipeline`, `ci/cd`, `devops`, `cloud` | `infrastructure-agent`, `devops`, `sre` |
| `integration`, `event`, `queue`, `kafka`, `esb`, `message`, `webhook`, `bus` | `integration-agent` |
| `test`, `qa`, `spec`, `coverage`, `e2e`, `unit`, `fixture` | `qa-lead-agent` |
| `docs`, `readme`, `documentation`, `guide`, `wiki`, `changelog` | `documentation-agent` |

For each community in `GRAPH_CONTEXT.communities`:
- Check whether real project files belong to this community
- Mark **active** if code is present, **absent** otherwise

Produce and memorize **DOMAIN_MAP**:

```
DOMAIN_MAP:
  active communities (code present in the project):
    - "Auth & Security" → [security-agent, backend-agent, compliance-officer]
    - "API & Controllers" → [backend-agent, integration-agent, pr-review-agent]
    - "Data & Persistence" → [backend-agent, data-agent]
  absent communities (exclude or deprioritize):
    - "Mobile" → [mobile-agent]  ← no Flutter/RN files detected
```

### Phase 0f — Version check (version-checker)

**Condition**: only for `--full`, `--backend`, `--frontend`, `--mobile`,
`--infrastructure`, `--release`, `--versions` modes, and the `--build`/`--update` sub-modes. Silent
skip for any other mode (personas, `--ask`, `--audit`, `--data`, `--design`, `--deps` which already has
its own dependency flow).

1. **Daily cache**: read `.claude/tmp/version-checker-cache.json` if it exists. If its date
   matches today **and** no manifest (`composer.json`, `package.json`,
   `*.csproj`, `pubspec.yaml`, `requirements.txt`/`pyproject.toml`, `go.mod`, `Gemfile`,
   `pom.xml`) has changed since (`git diff --name-only` over the last 24h) → reuse the
   cached result, jump to step 3.
2. Otherwise, call the Skill tool with `version-checker`. Write the result to
   `.claude/tmp/version-checker-cache.json` (`{date, major_gap, table}`).
3. If `major_gap = false`: display a status line (`✅ Versions up to date`) and continue
   directly to Phase 1 — no blocking.
4. If `major_gap = true` (major gap or EOL stack): display the returned table, then ask
   via AskUserQuestion:
   ```
   Version gaps detected:
   [version-checker table]
   → "update": call the Skill tool with `version-updater` and present the plan before
     continuing
   → "continue": proceed with the requested task without updating this session
   → "ignore": stop suggesting for this project — write `dismissed: true` to the cache
   ```
5. If "update" is chosen: present the `version-updater` plan, then resume the
   original task at Phase 1/2 (the plan is never applied automatically — it's up to the
   user to re-run the relevant dev mode once they approve the plan).

**⚠️ Fallback**: if `version-checker` is unavailable, display
`⚠️ version-checker unavailable — manual check recommended` and continue without blocking.

</SUBAGENT-STOP>

### Phase 1 — Argument analysis (no EnterPlanMode)

The session already starts in plan mode (`defaultMode: plan` in `settings.json`): **do not call `EnterPlanMode`**. First resolve short aliases, then identify the mode and context. If no mode is provided, display the available modes and ask via AskUserQuestion.

As long as the plan is not validated by the user, no phase writes a file — neither `.claude/project-graph.md`, nor GATES, nor a report: Phases 0* are limited to reading and memorizing. Writing begins at Phase 2.

### Phase 2 — Dispatch by mode

#### Dispatch convention

Every file in `.agents/` is already registered by the harness as a `subagent_type`; its frontmatter sets the model and tools. Launch:

```
Agent(subagent_type: "<name>-agent",
      prompt: "<Target|Description>: <value provided, otherwise "current project">
               Context: <outputs from previous phases, GATES, project constraints>")
```

**Never `Read` the agent's file to inject it into the prompt**: it would be loaded twice (main context + subagent prompt). If the harness doesn't know the `subagent_type` (agent absent from the machine), apply the relevant mode's fallback.

#### `--auto <description>`

Free mode — the user describes their need without choosing a mode. `team-selector` chooses the agents.

**Graph-aware**: if `GRAPH_CONTEXT ≠ null`, build an enriched description before passing to `team-selector`:

```
[USER DESCRIPTION]

--- Topological context (GRAPH_CONTEXT) ---
God nodes (central project concepts): [GRAPH_CONTEXT.god_nodes]
Hot zones (most impactful files): [GRAPH_CONTEXT.hot_files]
Active domains in this project: [DOMAIN_MAP.active_communities and their agents]
Absent domains (to exclude): [DOMAIN_MAP.absent_communities and their agents]
Key architectural question: [GRAPH_CONTEXT.suggested_questions[0]]
```

This enriched description lets `team-selector` focus its selection on the "hot" areas of the code and exclude upfront agents whose domain is absent from the project.

**⚠️ Fallback**: if `GRAPH_CONTEXT = null`, pass only the user's raw description (standard behavior).

1. Invoke the `team-selector` skill, passing it the description (`auto` mode).
2. Wait for the selection report (Core / Optional / Excluded table + included POs).
3. Present via AskUserQuestion:
   ```
   Proposed selection — confirm or modify:
   [Core/Optional/Excluded table from team-selector]
   → "ok" to launch | "modify: add X, remove Y" to adjust
   ```
4. After confirmation, run each **Core** agent in the sequence recommended by `team-selector`, then the retained **Optional** ones.
5. Invoke the POs selected in Phase 0b at the end of the sequence (or in parallel if non-dependent).

**Expected output**: report `reports/auto/YYYY-MM-DD_auto-[slug].md`
**⚠️ Fallback**: if `team-selector` is unavailable, display the available modes and ask via AskUserQuestion

---

#### `--full <description>`

Full-team mode — simulates the entire development team and all constraints (quality, security, GDPR compliance). Goal: **zero manual intervention** after launch. If an anomaly is detected (bug, GDPR violation, security finding), the cycle fixes and re-audits automatically until everything is clean.

The project description is mandatory — ask via AskUserQuestion if absent.

**⚠️ Fallback**: if `team-selector` is unavailable, run the full sequence with no filter.

**Entry blocker**: if `product-agent` AND `analyst` are both unavailable → stop:
`⛔ --full requires the Product group. Install at minimum: analyst, product-manager, functional-analyst`

---

##### Phase A-1 — State and resumption

`--full` chains about twenty agent launches: an interruption (missed `/compact`, closure, agent error) shouldn't force redoing everything. State lives in **`.claude/tmp/team-dev-full-state.md`** (gitignored), a file read at startup and updated at each step.

**At startup**:

1. If the file exists and its `description` matches the current request (or the user confirms via AskUserQuestion "Resume the run interrupted on <date> at step <N>?") → **resume mode**: `done` steps are skipped, their deliverables reinjected into context from the recorded paths; execution restarts at the first `running` or `failed` step. Phase A0 choices and the Phase A selection are read back from the file, not re-asked.
2. Otherwise → create the file with all steps `pending`.

**Format**:

```markdown
# team-dev --full — state
description: "<project description>"
started: 2026-09-17T14:02
updated: 2026-09-17T15:40
options_A0: [no-ai-slop, green-it]
selection_A: { core: [product-agent, architecture-agent, backend-agent, qa-lead-agent], optional: [design-agent], excluded: [game-dev-agent] }

| Step | Agent / Skill | Status | Deliverables | Timestamp | Note |
| --- | --- | --- | --- | --- | --- |
| B0 | project-bootstrap-agent | done | intake/app-spec.md, intake/feature-backlog.md | 14:05 | |
| B1 | sprint-agent | done | planning/sprint-01.md | 14:12 | |
| B2 | product-agent | failed | — | 14:30 | Agent interrupted (context) |
| B3 | design-agent | pending | | | |
| C.1 | qa-lead / compliance / security | pending | | | iteration 1 |
```

**During execution** — invariant rule: write `running` **before** launching a step, then `done` + deliverable paths (or `failed` + note, or `skipped` + reason) **immediately after**, before any other action. A step without a state update is a step not done. Loop C adds one `C.<n>` row per iteration with each auditor's P0/P1 counts.

**At closure** (after D6): mark `completed`, copy the file to `reports/full-project/YYYY-MM-DD_full-project-state.md` (versionable trace), then delete `.claude/tmp/team-dev-full-state.md`.

**⚠️ Fallback**: if the file is unreadable or inconsistent (unknown status, different description and resumption refused) → archive it as `.claude/tmp/team-dev-full-state.<timestamp>.bak` and start over, flagging it.

---

##### Phase A0 — Optional skills menu

Before launching the sequence, present via AskUserQuestion (multiSelect) **all non-automatic optional skills** with their explicit WHY. The user isn't expected to know skill names — each option explains why to choose it.

```
Which optional skills to activate for this session?
(Reply with space-separated IDs, e.g. "i-have-adhd no-ai-slop", or "none")

── RESPONSE MODE & STYLE ──────────────────────────────
☐ i-have-adhd
  → "I read better in numbered steps. Remove preambles, number
     every step, cap lists at 5 items, next action < 2 min
     each turn." (Active for the whole session from now on.)

── QUALITY OF GENERATED PROSE ─────────────────────────
☐ no-ai-slop
  → "Docs must sound human, not AI." After documentation (D1),
     pass all prose deliverables through the anti-AI-slop filter: remove
     binary contrasts, throat-clearing, fake-deep kickers, forbidden
     words (delve, leverage, robust…)

── ADVANCED SEO ───────────────────────────────────────────
☐ open-seo  (requires an openseo.so account + configured MCP)
  → "I want real SEO data, not just static files."
     At B3.5: live keyword research, site audit, backlinks, rank tracking
     via DataForSEO. Without selection: seo-geo generates robots.txt / sitemap /
     llms.txt / Schema.org (always present by default).

── USER ENGAGEMENT ───────────────────────────────────────
☐ octalysis-dnd  (relevant if the project has end users)
  → "I want to improve product engagement with game design."
     After design-agent (B3): Octalysis × D&D analysis,
     engagement mechanics roadmap applied to the product.

── GREEN IT ───────────────────────────────────────
☐ green-it  (relevant if the project has CSR or green IT criteria)
  → "The project must meet responsible-computing criteria."
     After architecture (B4): eco-design, energy, data,
     hosting audit, recommendations.

── ETHICAL AI ───────────────────────────────────────────
☐ ethical-ai  (relevant if the project integrates AI or ML)
  → "I want an audit of AI bias and governance."
     After architecture (B4): bias audit, AI Act compliance, governance.
```

**Choice wiring**:
- `no-ai-slop` → add step **D1.5** after documentation-agent (D1)
- `open-seo` → note; at B3.5 use `open-seo` instead of `seo-geo`
- `octalysis-dnd` → pre-validate B3.6 (skip the intermediate B3.6 question)
- `green-it` → add step **B4.5** after architecture-agent (B4)
- `ethical-ai` → add step **B4.6** after architecture-agent (B4)

**⚠️ Fallback**: if a selected skill is unavailable at execution time, display `⚠️ <skill> unavailable — step skipped` and continue.

---

##### Phase A — Selection (team-selector)

Invoke `team-selector` (`full` mode) → get the Core / Optional / Excluded table.
Exclude from the sequence agents classified **❌ Excluded**.

---

##### Phase B — Construction (linear, once)

Run in order. Each step receives the description + outputs from previous steps.
For each agent: `Agent(subagent_type: "<agent>", prompt: description + outputs from previous steps)`.
In resume mode (Phase A-1), `done` steps are skipped and their deliverables re-read from the state file; each step passes through `running` → `done` / `failed` / `skipped` in that file.

| # | Group | Agent / Skill | Triggered | If unavailable |
|---|--------|--------------|-----------|-----------------|
| B0 | Intake / Bootstrap | `project-bootstrap-agent` | Always | ⚠️ Skip |
| B1 | Framing | `sprint-agent` | Always | ⚠️ Skip |
| B2 | Product | `product-agent` | Always | ⛔ Stop |
| B3 | Design | `design-agent` | Always | ⚠️ Skip |
| B3.5 | SEO / GEO / LLM discovery | `open-seo` → `seo-geo` | Always (`open-seo` if selected in A0, otherwise `seo-geo`) | ⚠️ Skip + note |
| B3.6 | Gamification | `octalysis-dnd` | If selected in A0 (pre-validated) or opt-in B3.6 | ⚠️ Skip |
| B3.7 | Advanced accessibility | `accessibility-lead` | Always | ⚠️ Skip |
| B4 | Architecture | `architecture-agent` | Always | ⚠️ Skip |
| B4.5 | Eco-design | `green-it` | If `green-it` selected in A0 | ⚠️ Skip |
| B4.6 | Ethical AI | `ethical-ai` | If `ethical-ai` selected in A0 | ⚠️ Skip |
| B5 | Development | `backend-agent` · `frontend-agent` · `mobile-agent` (depending on stack) | Always | ⚠️ Skip |
| B6 | Infrastructure | `infrastructure-agent` | Always | ⚠️ Skip |
| B7 | Data | `data-agent` | Always | ⚠️ Skip |

**B5 — Development**: there is no single development agent. Choose the agent(s)
based on the stack detected by `architecture-agent` in B4:

| Detected stack | Agent |
|----------------|-------|
| Laravel / PHP · .NET | `backend-agent` |
| Angular · React | `frontend-agent` |
| Flutter · React Native | `mobile-agent` |
| Integration / ESB / messaging | `integration-agent` |

If the project covers multiple stacks, run them in sequence (never two agents of the same
domain in parallel, see the agent hierarchy in `AGENTS.md`).

**B3.6 — Gamification**:
- If `octalysis-dnd` was selected in **Phase A0** → invoke directly, without re-asking.
- If not selected in A0 → silent skip (the user already made their choice).

Invoke `octalysis-dnd`, passing it the product context from `product-agent`.

After B5 (or if B5 is skipped): apply the `refacto` hook on produced files, then `/security-review` (Phase 0c).

---

##### Phase C — Quality loop (repeat until zero blocking finding)

The loop runs as long as there's at least one open P0/P1 finding in **any** of the three auditors.
Each iteration completes all three audits then dispatches corrections to the relevant developer.
Each iteration is logged in the state file (`C.<n>` row, P0/P1 counts per auditor, dispatched corrections); on resume, the loop restarts at the interrupted iteration with the trackers already present on disk.

```
WHILE (P0/P1 bugs OR GDPR P0/P1 violations OR P0/P1 security findings):

  C1 — QA (qa-lead-agent)
       → Agent(subagent_type: "qa-lead-agent", prompt: target + accumulated context)
       → Read the produced QA report
       → If P0/P1 bugs: log them in quality/bug-tracker/bugs.md

  C2 — GDPR compliance (compliance-officer --gdpr)
       → Invoke compliance-officer in --gdpr mode
       → Read .claude/gdpr-violations.md
       → If P0/P1 violations: mark them "To fix"
       → If `intake/legal-compliance.md` exists (draft placed by project-bootstrap-agent
         Phase 6b at bootstrap time), this step **finalizes** that draft instead of
         starting from scratch: re-cuts legal bases/DPO if they've changed since
         bootstrap, then re-runs `legal-pages` to move the status from `TO BE DETERMINED`/draft
         to final.
       → Otherwise, compliance-officer itself invokes legal-pages (Phase R4.5) as soon as
         legal bases and DPO are settled → legal/cookie-consent-spec.md,
         privacy-policy.md, legal-notice.md, terms.md/sales-terms.md. If absent at the end
         of C2 on a project with public exposure, log them as a P1 item in the GDPR tracker rather
         than closing the loop.

  C3 — Security (security-agent)
       → Agent(subagent_type: "security-agent", prompt: target + accumulated context)
         (includes the declared-vs-implemented matrix, the SSO S1-S10
          checklist and the dynamic scenarios D-HDR / D-SSO-1..5 / D-REV / D-IDOR /
          D-ESC / D-ENUM / D-XSS / D-JSON / D-CSRF / D-CORS / D-RATE / D-ANON)
       → Read the produced security report
       → If P0/P1 findings: log them in security/findings.md
         AND at the top of the project's BACKLOG.md (SEC — priority 0 section)
       → Re-verify each P0/P1 with a direct command before dispatch
         (an agent finding that isn't re-verified stays "not confirmed")

  C4 — Dispatch corrections (graph-aware)
       → Consolidate all open P0/P1 items (bugs + GDPR + security)
       → If `GRAPH_CONTEXT ≠ null`: compute each P0 item's impact via graph traversal
           (limited to the first 3 god nodes of GRAPH_CONTEXT to avoid N×M calls):
           For each file listed in a P0 item:
           a. Run `graphify path "<impacted_file>" "<god_node>"` (1 to 3 calls max)
           b. Score impact based on distance to the nearest god node:
              - file IS a god node → CRITICAL impact (absolute priority)
              - distance ≤ 2 hops → HIGH impact
              - distance 3-4 hops → MODERATE impact
              - distance 5+ hops or no path → LOW impact
           c. Sort P0 items by descending score (CRITICAL > HIGH > MODERATE > LOW)
           P1 items keep their standard order (increasing effort)
       → Identify the relevant stack (Laravel/.NET → backend-agent, Angular/React → frontend-agent, Flutter/RN → mobile-agent)
       → For each relevant agent: Agent(subagent_type: "<agent>", prompt: list of items sorted by descending impact)
       → Wait for correction confirmation before looping back
       → ⚠️ Fallback: if GRAPH_CONTEXT = null or `graphify path` fails, dispatch items in standard order (P0 before P1, no graph-impact sort)

  C5 — Targeted re-audit
       → Re-run only the auditors whose items were corrected
       → Update trackers (bugs.md, gdpr-violations.md, findings.md)
       → If new P0/P1 appear: add them to the ongoing cycle

END OF LOOP when all trackers show zero open P0/P1
```

**Guardrail**: if the loop exceeds 5 iterations without reducing the P0/P1 count, stop and display:
`⚠️ Cycle stuck after 5 iterations — present the residual items and ask for a decision via AskUserQuestion`

P2/P3 findings are logged in the final report but **don't block** the loop.

---

##### Phase D — Closure (linear, once)

Run **each step D1 through D6 in order, without exception** after exiting loop C — "Always"
in the table below means a real invocation, not an optional mention. Same state
rules as Phase B (resume, `done`/`failed`/`skipped` in the state file); after D6, mark
the run `completed` and archive the state file (Phase A-1).

Two invocation mechanisms depending on the step's nature — don't confuse them:
- **Agent** (`documentation-agent`, `release-agent`): `Agent(subagent_type: "<agent>", prompt: description + accumulated outputs from previous phases)`.
- **Pure skill** (`no-ai-slop`, `onboarding`, `memory-rituel`, `explain-diff`, `retro`, `threat-intelligence`): **call the Skill tool with `<name>`**, passing it the accumulated context (produced files, launched agents, decisions made) — never a `/name` slipped into prose.

| # | Group | Agent / Skill | Triggered | If unavailable |
|---|--------|--------------|-----------|-----------------|
| D0 | Security watch (OWASP + stack CVE) | `threat-intelligence` | Always, `project` mode — call the Skill tool with `threat-intelligence`, passing it the stack detected in B4/B5 | ⚠️ Skip |
| D1 | Documentation | `documentation-agent` | Always — `Agent(subagent_type: "documentation-agent", ...)` | ⚠️ Skip |
| D1.5 | Anti-AI-slop prose filter | `no-ai-slop` | If `no-ai-slop` selected in A0 — call the Skill tool with `no-ai-slop` | ⚠️ Skip |
| D1.7 | Virtual visitor test (UX before production) | `visiteurs` | Always if the app exposes a user interface — call the Skill tool with `visiteurs`, passing it the app's URL (dev/staging) and `intake/app-spec.md` if available. Explicit skip if the project has no interface (pure API, internal tool with no front) | ⚠️ Skip |
| D2 | Release | `release-agent` | Always — `Agent(subagent_type: "release-agent", ...)` | ⚠️ Skip |
| D3 | Onboarding | `onboarding` | Always — call the Skill tool with `onboarding` | ⚠️ Skip |
| D4 | Memory | `memory-rituel` | Always — call the Skill tool with `memory-rituel` | ⚠️ Skip |
| D5 | Pedagogical closure | `explain-diff` | Always — call the Skill tool with `explain-diff`, passing it the mode used, agents launched, and decisions made during the run | ⚠️ Skip |
| D6 | Environment retrospective (consolidation — continuous capture already active in phases B/C) | `retro` | Always — call the Skill tool with `retro` | ⚠️ Skip |

**D0 and the rest of loop C**: if `threat-intelligence` (D0) finds an active CVE
(affected version overlapping the installed stack), it's logged in `BACKLOG.md` (SEC section) as an
ordinary `security-agent` finding — but **is not re-dispatched into the loop C** that just
closed: a CVE is fixed via a version update (`dependency-updater`/`version-updater`),
never via an ad hoc code patch. Mentioning it in the final report is enough; its handling belongs
to a subsequent `/team-dev --deps` or `--versions`.

**Guardrail against silent skipping**: before producing the final report (below), verify that
lines D1 through D6 (as well as D1.5 and D1.7 when they apply) appear in the state
file with a `done`/`failed`/`skipped` status — never absent. A step marked "Always" with no
corresponding state line is an execution bug, not a legitimate skip: re-run it before closing
the run.

---

**Expected output**: master report `reports/full-project/YYYY-MM-DD_full-project.md`:

```markdown
# Full project — [Description] — YYYY-MM-DD

## Selection (team-selector)
[Core/Optional/Excluded table]

## Phase B — Construction
| # | Group | Status | Deliverables |
|---|--------|--------|-----------|
| B1 | Framing | ✅/⏭️ | ... |
...

## Phase C — Quality loop
| Iteration | QA | GDPR | Security | Applied corrections |
|-----------|----|----|----------|----------------------|
| 1 | X P0/P1 bugs | Y violations | Z findings | backend-agent: A, B, C |
| 2 | 0 | 0 | 0 | — |

## Phase D — Closure
| # | Group | Status | Deliverables |
|---|--------|--------|-----------|
| D0 | Security watch (OWASP + CVE) | ✅/⏭️/❌ | ... |
| D1 | Documentation | ✅/⏭️/❌ | ... |
| D1.5 | Anti-AI-slop filter | ✅/⏭️/❌ | ... |
| D1.7 | Virtual visitor test | ✅/⏭️/❌ | ... |
| D2 | Release | ✅/⏭️/❌ | ... |
| D3 | Onboarding | ✅/⏭️/❌ | ... |
| D4 | Memory | ✅/⏭️/❌ | ... |
| D5 | Pedagogical closure | ✅/⏭️/❌ | ... |
| D6 | Environment retrospective | ✅/⏭️/❌ | ... |

## Residual P2/P3 findings (non-blocking)
[List with estimated effort — to plan via --sprint]

## Published legal documents (legal-pages, via project-bootstrap-agent B0 then finalized in compliance-officer C2)
- Cookie banner / privacy policy / legal notice / terms of service:
  [✅ Generated and finalized | 📝 Unfinalized bootstrap draft | ⏭️ Not applicable — internal tool | ⚠️ Unavailable]
- Editable Filament pattern (if Laravel): [✅ Scaffolded | ⏭️ Not applicable — non-Laravel stack]

## Produced deliverables (full paths)
...
```

**⚠️ Global fallback**: if more than half the B steps error out → stop, list what was produced, recommend running the individual modes. The state file is kept: `/team-dev --full <same description>` resumes where the run stopped.

---

#### `--bootstrap [description]`

Dispatch: `Agent(subagent_type: "project-bootstrap-agent", prompt: "DESCRIPTION: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: bootstrap kit `intake/` — `app-spec.md`, `brand-brief.md`, `data-dictionary.md`, `feature-backlog.md`, `integrations.md`, `error-journal.md` + `intake/README.md` (index + completeness status)
**⚠️ Fallback**: if the agent file is not found or the agent fails, sequentially invoke the skills `app-spec` → `brand-brief` → `data-dictionary` → `feature-backlog` → `integrations-catalog` → `error-journal` with shared context

#### `--product [description]`

Dispatch: `Agent(subagent_type: "product-agent", prompt: "DESCRIPTION: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: full product dossier — `analyse/analyst/YYYY-MM-DD_analyst.md`, `analyse/product-manager/YYYY-MM-DD_product-manager.md`, `analyse/functional-analyst/YYYY-MM-DD_functional-analyst.md`
**⚠️ Fallback**: if the agent file is not found or the agent fails, sequentially invoke the skills `analyst` → `product-manager` → `functional-analyst` with chained outputs

#### `--architecture [target]`

Dispatch: `Agent(subagent_type: "architecture-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `architecture/architecture-agent/YYYY-MM-DD_architecture-report.md` + `.drawio` files in `architecture/*/diagrams/`
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke the `architect` skill directly then display the list of activatable dimensions: `enterprise-architect`, `cloud-architect`, `security-architect`, `data-architect`, `integration-architect`, `tech-lead`

#### `--security [target]`

Dispatch: `Agent(subagent_type: "security-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated audit report `security/pentest/YYYY-MM-DD_pentest.md` **and** a `SEC — Security (priority 0)` section at the top of the project's `BACKLOG.md` (one item per finding, with a `CHECK` command). An audit not logged to the backlog is not done.
**Minimum scope**: declared-vs-implemented control matrix (ADR / ARCHITECTURE), S1-S10 SSO consumer checklist if auth is delegated, dynamic tests on the local stack (headers, IdP refusal for missing/suspended profile, callback without `state`, IdP logout, erase → relogin, per-role IDOR, XSS on any free-text field, CSRF, CORS, throttle), test suite health and CI coverage.
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke `appsec` directly or display `⚠️ security agent unavailable — manual audit required`

#### `--compliance [context]`

Invoke the `compliance-officer` skill (standard mode) with the provided context.
Covers GDPR + ISO 27001 + NIS2 in a single audit — no automatic correction cycle.
If the project has public exposure (site/app with external users), `compliance-officer`
itself invokes `legal-pages` in Phase 5.5 to produce the cookie banner, privacy
policy, legal notice and terms of service — no need to invoke it separately.

**Expected output**: report `security/compliance-officer/YYYY-MM-DD_compliance-officer.md` +
(if publicly exposed) `legal/privacy-policy.md`, `legal/legal-notice.md`,
`legal/cookie-consent-spec.md`, `legal/terms.md`
**⚠️ Fallback**: if `compliance-officer` is unavailable, display `⚠️ compliance-officer unavailable — manual audit required`

#### `--gdpr [target]`

Dedicated GDPR audit mode with an iterative correction cycle.
Invokes `compliance-officer` in `--gdpr` mode, then loops until there are no more open violations.

**Cycle:**

1. Invoke `compliance-officer --gdpr [target]` → produces `.claude/gdpr-violations.md` + report `security/compliance-officer/YYYY-MM-DD_gdpr-audit.md`. Once legal bases and the DPO are settled (skill's Phase R4.5), `compliance-officer` itself invokes `legal-pages` → cookie banner, privacy policy, legal notice, terms in `legal/`.
2. Read `.claude/gdpr-violations.md` — count open P0/P1 violations.
3. If P0/P1 violations > 0:
   a. Present via AskUserQuestion the list of violations + the concrete actions to take.
   b. Ask which developer agent should fix it (suggest `--backend`, `--frontend`, `--mobile` depending on the detected stack, or "manual" if out of code).
   c. Dispatch to the chosen agent: invoke `team-dev --backend [list of GDPR-XXX]` / `--frontend` / `--mobile`.
   d. The developer agent makes the corrections.
   e. Re-run `compliance-officer --gdpr [target]` — targeted re-audit on the corrected violations.
   f. Update the tracker: `Resolved ✅` if the pillar is validated, `Awaiting correction` if the re-test fails.
   g. Repeat until no P0/P1 violation remains open.
4. If only P2/P3 violations remain: display the summary and offer to plan corrections via `--sprint`.
5. End of cycle: no P0/P1 violation open → display `✅ GDPR audit complete — compliance achieved` and invoke `memory-rituel`.

**Expected output**: `.claude/gdpr-violations.md` (tracker) + final report `security/compliance-officer/YYYY-MM-DD_gdpr-audit.md`
**⚠️ Fallback**: if `compliance-officer` is unavailable, display `⚠️ compliance-officer unavailable — manual GDPR audit required`

#### `--pr-review [files]`

Dispatch: `Agent(subagent_type: "pr-review-agent", prompt: "Files: <provided list>")`.

**Expected output**: report `reviews/pr-review/YYYY-MM-DD_pr-review.md`
**⚠️ Fallback**: invoke `code-reviewer` directly if the agent is unavailable

**For a project-management tool consuming this report**: a Kanban card's "story"
column status in "PR / review" must reflect the PR's real status (open / in review / merged / CI
red), not a checkbox manually ticked by the developer — query the GitHub API (PR status +
check status) rather than trusting a human update, which drifts fast from reality. The `pr-review-agent` report documents the review's outcome, not the PR's live state: the two
are complementary, don't conflate them into the same column.

#### `--gamification [product]`

Invoke the `octalysis-dnd` skill with the provided product context.

**Expected output**: report `gamification/YYYY-MM-DD_octalysis-dnd_[product].md`
**⚠️ Fallback**: if `octalysis-dnd` is unavailable, display `⚠️ octalysis-dnd unavailable — manual gamification design required`

---

#### `--sprint [objective]`

Dispatch: `Agent(subagent_type: "sprint-agent", prompt: "Objective: <value provided>")`.

**Expected output**: estimated backlog + deliverable tracking
**⚠️ Fallback**: invoke `estimator` directly then note the missing skills

#### `--release [version]`

Dispatch: `Agent(subagent_type: "release-agent", prompt: "Version: <value provided>")`.

**Expected output**: report `reports/release/YYYY-MM-DD_release-agent.md`
**⚠️ Fallback**: invoke `changelog` + `dependency-updater` directly

#### `--onboarding`

Invoke the `onboarding` skill directly.

**Expected output**: `ONBOARDING.md` at the current project's root
**⚠️ Fallback**: display `⚠️ onboarding unavailable`

#### `--project-map [target] [--refresh] [--from-prd <file>]`

Invoke the `project-map` skill directly, with `target` (default: current directory) and the
provided options. Generates/refreshes an interactive HTML map of the codebase via the Claude
Code Floorplan plugin (parts, files, routes, security health check, guided flows).

**Expected output**: `floorplan/index.html` + architecture summary + high-severity Health items
**⚠️ Fallback**: display `⚠️ Floorplan plugin not installed — see skills/project-map/SKILL.md`

#### `--dev-tools [up|down|ps|logs [service]|track [submodule]|check]`

Invoke the `dev-observability` skill directly, with the provided action (default: `up` if no
action and containers are down, otherwise `ps`). Drives PostHog (analytics/feature flags) and Uptime
Kuma (monitoring) via a separate Docker compose, strictly dev-only — the skill itself locates
`compose.dev-apps.yaml` in the current project.

If the tool isn't yet configured on the project: offers to install it (delegated to
`infrastructure-agent`) unless already marked refused in `skills/dev-observability/refused.json` — a refusal
applies to all projects, not just the current one.

**Expected output**: container status (healthy before announcing "ready") + local URLs
(PostHog `:8010`, Uptime Kuma `:3001`)
**⚠️ Fallback**: display `⚠️ compose.dev-apps.yaml not found — tools not configured on this project`

#### `--deps`

Invoke the `dependency-updater` skill directly.

**Expected output**: report `reports/dependency-updater/YYYY-MM-DD_dependency-updater.md`
**⚠️ Fallback**: display `⚠️ dependency-updater unavailable`

#### `--versions [target]`

Invoke the `version-checker` skill. If a major gap or an EOL stack is detected, offer via
AskUserQuestion to invoke `version-updater` to produce the update plan.

**Expected output**: `reports/version-checker/YYYY-MM-DD_version-checker.md`, then
`reports/version-updater/YYYY-MM-DD_version-updater.md` if the plan is requested
**⚠️ Fallback**: display `⚠️ version-checker unavailable`

#### `--qa-lead [target]`

Dispatch: `Agent(subagent_type: "qa-lead-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `reports/qa/YYYY-MM-DD_qa-report.md`
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke the `qa-engineer` skill directly

#### `--bug [file or description]`

Invoke the `bug-validator` skill with the provided errors.

If a value is provided, pass it directly as input context (skill Phase 2).
If absent, the skill will ask for the list of errors via AskUserQuestion.

**Expected output**: report `quality/bug-validator/YYYY-MM-DD_bug-validator.md` + prevention rules written to memory
**⚠️ Fallback**: if `bug-validator` is unavailable, display `⚠️ bug-validator unavailable — manual validation required`

#### `--fix [BUG-XXX,BUG-XXX,...]`

Orchestrates the next step of the dev/QA cycle after one or more bugs have been fixed.

1. Read `quality/bug-tracker/bugs.md` — verify the given BUG-XXX items are in "Awaiting re-test" status.
   If no BUG-XXX is given: read the tracker and list all those in "Awaiting re-test" status, ask via AskUserQuestion which to re-test.
2. Run `qa-lead-agent` in targeted re-test mode: `Agent(subagent_type: "qa-lead-agent", prompt: "Target: --retest BUG-XXX,...")`.
3. After the re-test: read the produced report `reports/qa/YYYY-MM-DD_retest-*.md`.
4. Invoke `bug-validator` in `--retest` mode with the BUG-XXX items whose TC passed → user re-validation.
5. Update the tracker: `Resolved ✅` if validated, `Awaiting correction` if the re-test failed.
6. Display the cycle's final state.

**Next step if bugs remain**: repeat `/team-dev --fix [remaining BUG-XXX]` after a new dev correction.
**End of cycle**: when the tracker no longer contains any open bug → display `🎉 Cycle complete` and invoke `memory-rituel`.

**Expected output**: re-test report `reports/qa/YYYY-MM-DD_retest-[BUG-IDs].md` + updated tracker
**⚠️ Fallback**: if `qa-lead-agent` or `bug-validator` are unavailable, display the tracker's state and the manual steps

#### `--investigate [bug-description]`

Invoke the `investigue` skill with the provided bug description.

The skill runs a structured 4-phase sequential analysis with a stop and validation at each step: (1) locate and reproduce, (2) formulate 3 ranked falsifiable hypotheses, (3) add targeted `[DEBUG-xxxx]` logs without fixing, (4) minimal fix after confirmation. 3-strikes rule: if all 3 hypotheses are wrong, architectural re-evaluation.

**Expected output**: minimal patch + commit message `fix(scope): root cause`
**⚠️ Fallback**: if `investigue` is unavailable, invoke the `debug` skill directly

<!-- Possible evolution: before step 2, dispatch BUG-XXX items to the development
     agent matching the stack (backend-agent, frontend-agent or mobile-agent)
     and wait for correction confirmation before continuing. -->

#### `--audit [target]`

Post-development audit mode — orchestrates every profile relevant to the project **read-only**
to produce a consolidated report with a prioritized remediation plan. Used when code is already
written and a second targeted pass is wanted to strengthen it.

**Prerequisite**: source code present in the current project (otherwise, use `--product` or `--full`).
**Forced security mode**: `safe` throughout the sequence — audit agents must never
modify code, only produce findings.

##### Phase A — Relevant profile selection

Invoke the `team-selector` skill in `audit` mode with the target. Goal: identify **every agent
potentially useful** for the current project (exhaustive selection, not minimal), while
excluding those clearly out of scope (e.g. `game-dev-agent` for a corporate site, or any persona
agent from the personal repository).

##### Phase A.5 — Topological reconnaissance (graph-first)

**Condition**: only run if `graphify-out/graph.json` is present in the current project.

Before launching the agent sequence, identify risk areas via **3 Graphify queries run
in parallel** (single message):

**Query 1 — Security hotspots**:
```bash
graphify query "security vulnerability authentication authorization secret injection"
```
→ Extract the identified files and modules. These zones will be audited first by `security-agent`.

**Query 2 — Complex and coupled modules**:
```bash
graphify query "complexity coupling dependency tight cohesion"
```
→ Extract high-complexity or high-coupling modules. Priority for `architecture-agent` and `pr-review-agent`.

**Query 3 — External integration points**:
```bash
graphify query "external dependency third party library api integration webhook"
```
→ Identify entry/exit points toward the outside. Priority for `integration-agent` and `security-agent`.

Build **RISK_MAP**:
```
RISK_MAP:
  P0 zones (security + strong coupling): [list of files/modules]
  P1 zones (high complexity): [list]
  External integration points: [list]
  Exposed god nodes (in GRAPH_CONTEXT.god_nodes AND in a P0 zone): [list]
```

**Dynamically reorder Phase B's sequence** according to these rules:
1. Agents covering `RISK_MAP` P0 zones move to the front of the sequence (e.g. `security-agent` in position 1 if security hotspots are detected).
2. Agents in `DOMAIN_MAP.absent_communities` are marked `[out of scope]` and placed last (unless classified Core by `team-selector`).
3. Display the reordered sequence with justifications before launching the first agent:
   ```
   Reordered audit sequence (graph-aware):
   [1] security-agent — P0 zones detected: src/auth/**, src/api/**
   [2] architecture-agent — Complex modules: ServiceLayer, DataAccess
   [3] backend-agent — Exposed god node: ApiController
   ...
   [N] mobile-agent [out of scope — no mobile code detected]
   ```

**⚠️ Fallback**: if `graphify-out/graph.json` is absent or the queries fail, define `RISK_MAP = null` and run Phase B's sequence in its standard order.

##### Phase B — Chained sequential execution

For each selected agent, `Agent(subagent_type: "<agent>", prompt: …)` injecting into the prompt:
- the target (or "current project" if absent)
- the cumulative report from previous agents (concatenation of the sequence's outputs)
- the directive: `Mode: AUDIT (read-only). Do not modify any file. Only produce a findings report with severity P0/P1/P2/P3, file:line, estimated effort (h/d), impact.`

Launch via `Agent`, except step 8.5 which is a pure skill (see note in its heading below).
Logical sequence order (each step builds on previous ones):

| # | Agent | Axis | Audit focus |
|---|-------|-----|------------------|
| 1 | `product-agent` (or `analyst`) | Product | Functional gap vs initial specs, uncovered user stories, missed edge cases |
| 2 | `architecture-agent` | Architecture | Technical debt, missing ADRs, anti-patterns, coupling, complexity |
| 3 | `design-agent` | UX/UI | Design system consistency, mockup vs implementation gaps, micro-interactions |
| 4 | `backend-agent` | Backend code | Conventions, Result<T>/transactions, OpenAPI, validation (`--review` mode) |
| 5 | `frontend-agent` | Frontend code | OnPush/hooks, TanStack/Zustand/NGXS, strict TypeScript (`--review` mode) |
| 6 | `mobile-agent` | Mobile code | Null-safety, 60fps, accessibilityLabel/Semantics (`--review` mode) |
| 7 | `pr-review-agent` | Cross-cutting code | Final code review, readability, quality debt |
| 8 | `security-agent` | Security | OWASP Top 10, exposed secrets, vulnerable deps, hardening |
| 8.5 | `threat-intelligence` | Security watch | Active CVEs on the detected stack, OWASP version gap — **pure skill, not an agent**: call the Skill tool with `threat-intelligence` (`project` mode), not `Agent(...)` |
| 9 | `compliance-officer` | Compliance | GDPR, ISO 27001, NIS2, audit traceability |
| 10 | `infrastructure-agent` | Infra | Linux/K8s hardening, IaC drift, observability, 3-2-1 backup |
| 11 | `integration-agent` | Integration | API contracts, versioning, resilience, OpenAPI schemas |
| 12 | `data-agent` | Data | Pipeline quality, data GDPR, lineage, EXPLAIN ANALYZE |
| 13 | `it-operations-agent` | Ops | Runbooks, CMDB, ITIL Change/Problem |
| 14 | `qa-lead-agent` | Quality | Test coverage, missing E2E plans, perf, untested scenarios |
| 15 | `accessibility-lead` | A11y | WCAG 2.1 AA, local accessibility standards, keyboard navigation, contrast, ARIA |
| 16 | `documentation-agent` | Docs | README gaps, API, ADRs, onboarding |
| 17 | `dependency-updater` | Maintenance | Outdated versions, upcoming breaking changes |
| 18 | `green-it` | Footprint | SCI score, web eco-design |
| 19 | `ethical-ai` | AI | EU AI Act, bias, model card (if AI is in the project) |

For each unavailable agent or skill: display `⏭️ <name> unavailable — skip` and continue.
Save each individual report to `reports/audit/agents/YYYY-MM-DD_<agent-or-skill>.md`.

##### Phase C — Consolidation & master report

Produce `reports/audit/YYYY-MM-DD_post-dev-audit.md`:

```markdown
# Post-development audit — [target] — YYYY-MM-DD

## Executive summary
- Total findings: N (P0: x · P1: y · P2: z · P3: w)
- Total estimated effort: X days
- Axes in critical debt: [list]

## Audited scope
[Agents run + reason for inclusion via team-selector]

## Filtered agents (out of scope)
[Excluded agents + reason]

## Findings by axis
### [Axis] (Agent: <name>)
- **[P0]** Description — `file:line` — Effort: Xh — Impact: Y
- ...

## Priority × effort matrix
|                  | Low effort | Medium effort | High effort |
|------------------|---------------|--------------|--------------|
| **Critical P0**  | quick wins    | to plan      | to arbitrate |
| **Major P1**     | quick wins    | sprint N+1   | roadmap      |
| **Minor P2**     | backlog       | backlog      | nice-to-have |

## Remediation roadmap
### Iteration N+1 (P0 + quick P1 wins)
- [ ] [Finding] → `/team-dev --<mode> <context>`
...

### Iteration N+2 (remaining P1)
...

### Backlog (P2 / P3)
...

## Recommended next commands
- `/team-dev --backend reports/audit/YYYY-MM-DD_post-dev-audit.md` — address backend findings
- `/team-dev --frontend ...` — address frontend findings
- `/team-dev --security ...` — address security findings
- `/team-dev --qa-lead ...` — close the coverage gap
- ...
```

##### Phase D — Action plan file

Write `reports/audit/YYYY-MM-DD_action-plan.md` via `Write`:

```markdown
# Action Plan — Post-development audit [target] — YYYY-MM-DD

> Generated from: `reports/audit/YYYY-MM-DD_post-dev-audit.md`
> Total estimated effort: X days · Findings: N (P0: x · P1: y · P2: z · P3: w)

## Iteration N+1 — Critical P0 + quick P1 wins
> Goal: eliminate blocking debt and high impact/effort-ratio quick wins

| # | Priority | Axis | Action | team-dev command | Effort |
|---|----------|-----|--------|-------------------|--------|
| 1 | **P0** | [Axis] | [Finding description] | `/team-dev --<mode> <target>` | Xh |
| 2 | **P0** | ... | ... | ... | ... |
| 3 | **P1 ⚡** | ... | ... | ... | ... |

## Iteration N+2 — Remaining P1

| # | Priority | Axis | Action | team-dev command | Effort |
|---|----------|-----|--------|-------------------|--------|
...

## Backlog — P2 / P3

| # | Priority | Axis | Action | team-dev command | Effort |
|---|----------|-----|--------|-------------------|--------|
...

## Commands to run (in order)

\`\`\`bash
# Iteration N+1
/team-dev --<mode1> reports/audit/YYYY-MM-DD_post-dev-audit.md
/team-dev --<mode2> reports/audit/YYYY-MM-DD_post-dev-audit.md
...
\`\`\`
```

##### Phase E — Active todo list

Feed the session's task list (the harness's todo tool if available, otherwise a `## To address`
section at the top of the action plan) with **P0 and P1 findings only** (P2/P3 stay in the
plan file to avoid overloading the todo):

- `content` format: `[P0][Axis] Short finding description`
- `activeForm` format: `Handling [P0][Axis] Short description`
- Initial status: all `pending`
- Order: P0 first, then P1 sorted by increasing effort (quick wins first)

Example generated todo:
```json
[
  { "content": "[P0][Security] API secret exposed in config.env", "activeForm": "Handling [P0][Security] API secret exposed in config.env", "status": "pending" },
  { "content": "[P0][Architecture] Strong coupling between UserService and OrderService", "activeForm": "Handling [P0][Architecture] UserService/OrderService coupling", "status": "pending" },
  { "content": "[P1⚡][QA] Add E2E tests on the payment flow (2h)", "activeForm": "Adding E2E tests for payment flow", "status": "pending" }
]
```

##### Phase F — Summary

Display to the user:
1. The executive summary (P0/P1/P2/P3 counts + global effort)
2. Confirmation of created deliverables:
   - `reports/audit/YYYY-MM-DD_post-dev-audit.md` — master report (full findings)
   - `reports/audit/YYYY-MM-DD_action-plan.md` — prioritized action plan
   - Active todo list (N P0+P1 items)
3. The ordered list of `/team-dev --<mode>` commands to run for the N+1 pass

**Expected output**: master report `reports/audit/YYYY-MM-DD_post-dev-audit.md` + individual reports `reports/audit/agents/` + action plan `reports/audit/YYYY-MM-DD_action-plan.md` + active todo list

**⚠️ Fallback**:
- If `team-selector` is unavailable → run the full sequence with no filter, excluding by default `game-dev-agent` and any persona agent from the personal repository (none belongs in a development cycle)
- If more than half the agents are unavailable → stop, list what could be produced, recommend the individual audit modes (`--security`, `--qa-lead`, `--pr-review`, `--compliance`)
- If no source code is detected in the target → display `⚠️ --audit requires a developed project. Use --product or --full for a from-scratch project.`

#### `--backend [target]`

Dispatch: `Agent(subagent_type: "backend-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `backend/YYYY-MM-DD_backend-report.md` + generated endpoints/services/entities
**⚠️ Fallback**: if the agent file is not found, invoke `laravel-developer` or `dotnet-developer` directly depending on the framework detected in `composer.json` / `*.csproj`

After the agent's execution: invoke the `refacto` skill on produced or modified files.
**⚠️ Fallback**: if `refacto` is unavailable, display `⚠️ refacto unavailable — manual architecture review required`

---

#### `--frontend [target]`

Dispatch: `Agent(subagent_type: "frontend-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `frontend/YYYY-MM-DD_frontend-report.md` + generated components/stores/routes or migration report
**⚠️ Fallback**: if the agent file is not found, invoke `angular-developer` or `react-developer` directly depending on the framework detected in `package.json`

After the agent's execution: invoke the `refacto` skill on produced or modified files.
**⚠️ Fallback**: if `refacto` is unavailable, display `⚠️ refacto unavailable — manual architecture review required`

---

#### `--seo [target]`

Two cases depending on the request's nature:

**Case 1 — Live data** (audit, keywords, backlinks, rank tracking, competitor analysis):
1. Verify the `openseo` MCP is available (settings.json + OAuth).
2. If yes: invoke the `open-seo` skill with the target and appropriate workflow.
3. If the MCP is absent: warn and fall back to Case 2.

**Case 2 — Static artifacts** (robots.txt, sitemap, llms.txt, Schema.org, hreflang):
1. Invoke the `seo-geo` skill directly with the provided target.
2. `seo-geo` detects the framework, audits existing artifacts and generates the missing ones.

**Expected output (open-seo)**: DataForSEO live data, HTML audit report, keyword/backlink/position table
**Expected output (seo-geo)**: `public/robots.txt`, `public/sitemap.xml`, `public/llms.txt`, `public/llms-full.txt`, `public/*.webmanifest`, `SeoHead` component, Schema.org JSON-LD, GEO tags, hreflang
**⚠️ Fallback**: if neither `open-seo` nor `seo-geo` is available, display `⚠️ SEO unavailable — artifacts need to be created manually`

---

#### `--no-slop [text]`

1. Invoke the `no-ai-slop` skill with the provided text.
2. If the text starts with `detect` or if the `--detect` flag is present: use Detect mode (audit with no rewrite — lists patterns, doesn't rewrite).
3. Otherwise: Edit mode (minimal effective rewrite + "What changed" section).
4. If no text is provided: ask "Paste the draft to edit."

**Expected output (Edit)**: edited draft in full + list of actual changes
**Expected output (Detect)**: list of detected AI slop patterns with quotes and short corrections
**⚠️ Fallback**: if `no-ai-slop` is unavailable, apply memorized rules (remove: binary contrasts, throat-clearing, fake-deep kickers, em dash abuse, forbidden words: delve, leverage, utilize, robust, tapestry…)

---

#### `--adhd`

Action-first response mode, for the session's duration: action first, numbered steps,
lists ≤ 5 items, zero politeness, next action < 2 min every turn. To disable:
"stop adhd mode".

1. If the `i-have-adhd` skill is present (provided by the personal repository), invoke it.
2. Otherwise, directly apply the rules above — they're enough, the skill only details them.

---

#### `--mobile [target]`

Dispatch: `Agent(subagent_type: "mobile-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `mobile/YYYY-MM-DD_mobile-report.md` + generated screens/stores/navigation or migration report
**⚠️ Fallback**: if the agent file is not found, invoke `flutter-developer` or `react-native-developer` directly depending on the framework detected in `pubspec.yaml` / `package.json`

After the agent's execution: invoke the `refacto` skill on produced or modified files.
**⚠️ Fallback**: if `refacto` is unavailable, display `⚠️ refacto unavailable — manual architecture review required`

---

#### `--documentation [target]`

Dispatch: `Agent(subagent_type: "documentation-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `docs/documentation-agent/YYYY-MM-DD_documentation-report.md` + full set of artifacts in `docs/`
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke `tech-writer` directly and display the list of available skills: `tech-writer`, `knowledge-manager`, `dev-advocate`, `training-specialist`

#### `--data [scope]`

Dispatch: `Agent(subagent_type: "data-agent", prompt: "SCOPE: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: CDO report `data/data-agent/YYYY-MM-DD_data-report.md` + per-axis artifacts in `data/`
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke the skill matching the highest-priority axis directly and display the available list: `data-engineer`, `analytics-engineer`, `data-architect`, `data-scientist`, `ai-product-engineer`, `bi-developer`

#### `--design [description]`

Dispatch: `Agent(subagent_type: "design-agent", prompt: "DESCRIPTION: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `design/design-agent/YYYY-MM-DD_design-report.md` + per-dimension artifacts in `design/`
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke the skill matching the highest-priority dimension directly and display the available list: `ux-researcher`, `ux-designer`, `ux-writer`, `design-system`, `service-designer`

#### `--illustrate [description]`

Invoke the `illustre` skill with the description of the diagram to generate.

The skill produces a valid `.excalidraw` file (Excalidraw JSON) then attempts a PNG/SVG export via Python/Playwright if the environment allows it. If Python is absent, the `.excalidraw` file is the final output (openable in Excalidraw.com or the VS Code extension). Python references are in `.agents/skills/illustre/references/`.

**Expected output**: `<topic>.excalidraw` + `<topic>.png` + `<topic>.svg` (if Python/Playwright available)
**⚠️ Fallback**: if `illustre` is unavailable, use `graphify` for a Mermaid diagram or describe the structure verbally

#### `--coordination [target]`

Dispatch: `Agent(subagent_type: "coordination-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `coordination/coordination-agent/YYYY-MM-DD_coordination-report.md` + per-dimension artifacts in `coordination/`
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke the skill matching the highest-priority dimension directly and display the available list: `scrum-master`, `agile-coach`, `engineering-manager`, `delivery-manager`, `project-manager`, `program-manager`, `it-governance`

#### `--infrastructure [target]`

Dispatch: `Agent(subagent_type: "infrastructure-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `infrastructure/infrastructure-agent/YYYY-MM-DD_infra-report.md` + per-dimension artifacts in `infrastructure/`
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke the skill matching the highest-priority dimension directly and display the available list: `sysadmin`, `kubernetes-engineer`, `network-engineer`, `network-checker`, `devops`, `sre`, `cloud-engineer`

#### `--integration [target]`

Dispatch: `Agent(subagent_type: "integration-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `integration/YYYY-MM-DD_integration-report.md` + connectors + OpenAPI schemas
**⚠️ Fallback**: if the agent file is not found, invoke `integration-developer` or `integration-architect` directly

#### `--it-operations [target]`

Dispatch: `Agent(subagent_type: "it-operations-agent", prompt: "TARGET: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: consolidated report `itops/YYYY-MM-DD_itops-report.md` + runbooks + RFC + RCA
**⚠️ Fallback**: if the agent file is not found, invoke `it-support` directly

#### `--game-dev [mechanic]`

Dispatch: `Agent(subagent_type: "game-dev-agent", prompt: "MECHANIC: <value provided — otherwise "current project">")` — see *Dispatch convention* (Phase 2).

**Expected output**: Studio report `gamedev/[mechanic-name]/YYYY-MM-DD_[name].md` including code + shaders + feel vars
**⚠️ Fallback**: if the agent file is not found or the agent fails, invoke the skill matching the highest-priority dimension directly and display the available list: `lead-gameplay-programmer`, `technical-artist`, `game-designer`, `physics-engineer`

#### Persona modes — `--algorave` · `--survival` · `--race-engineering` · `--game-master` · `--legal-compliance` · `--creativity-theory` · `--pilgrimage-route` · `--mentor` · `--socratic-method` · `--trainer` · `--paid-consultant` · `--creative-director` · `--ceo-decision` · `--devils-advocate`

Dispatch: `Agent(subagent_type: "<name>-agent", prompt: "<LABEL>: <value provided — otherwise
"current project">")`, per the *Dispatch convention* (Phase 2). Each agent carries its own
output format and its own fallback.

**⚠️ Fallback**: if the agent file is not found, do **not** produce the deliverable in its place —
a persona with no context would give a generic answer presented as expert. Announce
the unavailability and suggest the matching satellite skill when one exists (`strudel-patterns`
for `--algorave`, `compostel-*` for `--pilgrimage-route`, `szikra-*` for `--creativity-theory`).

| Mode | Agent | Prompt label |
| --- | --- | --- |
| `--algorave` | `algorave-agent` | `STYLE` |
| `--survival` | `survival-logistics-agent` | `MISSION` |
| `--race-engineering` | `race-engineering-agent` | `ANALYSIS` |
| `--game-master` | `game-master-agent` | `SESSION` |
| `--legal-compliance` | `legal-compliance-agent` | `CASE` |
| `--creativity-theory` | `creativity-theory-agent` | `TOPIC` |
| `--pilgrimage-route` | `pilgrimage-route-agent` | `STAGE` |
| `--mentor` | `mentor-agent` | `SITUATION` |
| `--socratic-method` | `socratic-method-agent` | `TOPIC` |
| `--trainer` | `trainer-agent` | `TOPIC` |
| `--paid-consultant` | `paid-consultant-agent` | `PROBLEM` |
| `--creative-director` | `creative-director-agent` | `WORK` |
| `--ceo-decision` | `ceo-decision-agent` | `DECISION` |
| `--devils-advocate` | `devils-advocate-agent` | `PROJECT` |

#### `--ask <skill> [context]`

Invoke the named skill directly. Available skills: `analyst`, `product-manager`, `functional-analyst`, `code-reviewer`, `estimator`, `onboarding`, `compliance-officer`, `legal-pages`, `meeting-notes`, `strix` (local agentic pentest, also invoked from `security-agent` Phase 6b bis), `llm-fallback-free` (switches to a free LLM — Groq/OpenRouter/Gemini — when the Claude Code quota is reached), `claude-code-audit` (audits `settings.json`/hooks/permissions against official Anthropic practices), or any other installed skill.

**Expected output**: output of the invoked skill
**⚠️ Fallback**: if the requested skill is unavailable, display `⚠️ <skill> unavailable` and suggest an alternative skill if applicable

---

#### `--query <question>`

Wrapper around `graphify query` adapted to the team-dev context. Answers questions about the architecture, code, and dependencies directly from the current project's graph. **Modifies no file.**

**Prerequisite**: `graphify-out/graph.json` must exist in the current directory.

1. Verify `graphify-out/graph.json` exists.
2. Run `graphify query "<question>"` (BFS by default; add `--dfs` to trace a specific dependency).
3. Interpret the results and answer in natural language, citing the `source_location` of found nodes.
4. Suggest 2-3 follow-up questions based on the communities traversed in the answer.

**Example usage**:
```
/team-dev --query "which modules depend on authentication?"
/team-dev --query "what's the path between UserController and the database?"
/team-dev --query "what are the public entry points of the API?"
/team-dev --query "where are permissions managed?"
```

**Expected output**: text answer with file references + graph nodes + 2-3 follow-up questions
**⚠️ Fallback**: if `graphify-out/graph.json` is absent → `⚠️ Graph absent — run /graphify . or /team-dev project-graph first to build the graph`

---

#### `--graph-impact <file>`

Analyzes the potential impact of a change on a specific file, measuring its distance to god nodes via `graphify path`. Useful before deciding which agent to mobilize for a finding or a fix. **Modifies no file.**

**Prerequisite**: `graphify-out/graph.json` + god nodes available (from `GRAPH_CONTEXT` or `.claude/project-graph.md`).

1. If `GRAPH_CONTEXT` is no longer in session, re-read `.claude/project-graph.md` to retrieve the list of god nodes.
2. For each god node (max 5):
   - Run `graphify path "<file>" "<god_node>"`
   - Record distance (number of hops) and path
3. Compute the global impact score:

| Distance to the nearest god node | Score |
|-------------------------------------|-------|
| 0 (the file IS a god node) | **CRITICAL** |
| 1-2 hops | **HIGH** |
| 3-4 hops | **MODERATE** |
| 5+ hops or no path | **LOW** |

4. Display the impact report:

```markdown
## Impact report — <file>

| God Node | Distance | Partial path | Score |
|----------|----------|----------------|-------|
| UserService | 1 hop | file → UserService | HIGH |
| AuthModule | 3 hops | file → X → Y → AuthModule | MODERATE |
| ApiController | N/A | No path detected | LOW |

**Global score**: HIGH (1 god node within direct reach)
**Recommended agents**: backend-agent + security-agent (Auth & API domains impacted)
**Regression risk**: Modifying this file can propagate effects toward UserService — test UserService after any change.
```

**Expected output**: impact report in markdown + agent recommendation + regression warning
**⚠️ Fallback**: if `graphify-out/graph.json` is absent → `⚠️ Graph absent — run /graphify . first`

---

#### Unknown mode

If the provided mode is in no list above (neither long nor short alias):
```
⏭️ <mode> unknown. Available modes: see the Usage section.
   Alternative: /team-dev --ask <individual-skill> [context]
```
Never invent an agent nor try an unlisted `subagent_type`.

---

## Integrated modules & roadmap

Moved to [`ROADMAP.md`](ROADMAP.md) (same folder) to avoid loading ~260 lines of inventory on every invocation. To be read **on demand**: `Read .agents/skills/team-dev/ROADMAP.md` — never systematically.
