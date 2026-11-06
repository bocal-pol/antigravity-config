# Antigravity Instructions

## Canary — verify these instructions are loaded

Start **every response** with the word `canary` in lowercase, alone on the first line, before any
other content.

```text
canary
[normal response here]
```

Its absence signals that this file was not loaded, or was truncated. Failures in this environment
are silent — a hook that does not fire, a missing MCP server, a lost instruction produce no visible
error. This word is the only immediate signal.

## Session context (auto-loaded)

@primer.md
@hindsight.md

## Known limitations — unconfirmed Antigravity support

This repository is a best-effort port of a private AI coding-assistant configuration to the
Antigravity agentic IDE (Google/Gemini). A web search conducted on 2026-11-04 found **no single
stable, official specification** for Antigravity's project-local configuration format. Official
Gemini API docs ("Building managed agents") are the most reliable source found: they describe an
agent loading `.agents/AGENTS.md` as system instructions at startup, and skills discovered
automatically under `.agents/skills/<skill-name>/SKILL.md`. Third-party guides disagree on several
points — some use a singular `.agent/` directory instead of `.agents/`, and global config paths
under `~/.gemini/...` vary across IDE versions. This repository follows the official doc's paths
(`AGENTS.md`, `.agents/skills/`) as the most reliable choice, but the following elements have **no
confirmed Antigravity equivalent** and are carried over on a best-effort basis only:

- **Shell hooks** (`pre-tool-use.sh`, `stop.sh`, `skill-log.sh`, `memory.sh`) — copied as-is from
  the source configuration, but there is no confirmed mechanism in Antigravity equivalent to a
  pre-tool-use/session-start/stop hook system. Whether and how Antigravity would trigger these
  scripts is unverified.
- **The orchestrator-agent concept** with a `tools:` frontmatter key (an agent file under
  `.agents/<name>.md` that declares which tools it may call) — no confirmed Antigravity equivalent
  was found. Agent files are carried over as documentation of intent, not as a verified mechanism.
- **The Skill Router** (`.agents/router.json`) is a convention invented for the source assistant's
  own skill-invocation tool, not an Antigravity-native mechanism. Nothing confirms Antigravity reads
  or acts on it.
- **Frontmatter keys beyond `name`/`description`** — `model`, `type`, `priority`, `scope`,
  `dependencies`, `conflicts`, `allowed-tools`/`disallowed-tools` — are preserved on skill and agent
  files for documentation and future tooling purposes, but their interpretation (if any) by
  Antigravity is unconfirmed.

Treat every mechanism in this file beyond plain Markdown instructions and the `.agents/skills/`
discovery convention as **unverified** until confirmed against the actual IDE behavior. See
`PORTING-NOTES.md` for the full research summary.

## Skill conventions

Every `SKILL.md` should follow:

- `model`: a model identifier describing the intended tier (e.g. `gemini-pro`, `gemini-flash`) —
  see "Known limitations" above regarding whether Antigravity reads this field at all.
- **Never a `tools:` key in a `SKILL.md`** — that is an *agent* frontmatter key
  (`.agents/<name>.md`), not a skill key, mirroring the convention of the source configuration this
  repository is ported from.
- Paths: project-local `.agents/` directory only, never an absolute user path.
- If orchestrable: an "Optional input" section + skip re-memorization + conditional persistence.
- Grep: systematically exclude `node_modules/`, `vendor/`, `*.test.*`.
- Child skills: documented input/output + a ⚠️ fallback.
- Dependency between skills: an **explicit** instruction such as "call the skill named `name`" (one
  call per skill, two calls for two skills) — never a slash-command reference embedded in prose.

### Required metadata (SKILL.md frontmatter)

Every `SKILL.md` should include the following fields in its YAML frontmatter:

```yaml
name: laravel-developer          # unique identifier, kebab-case
type: framework                  # orchestrator | framework | domain | utility | context | specialized
priority: high                   # high | medium | low
scope: backend                   # backend | frontend | infra | mobile | data | security | cross
dependencies:                    # skills or MCP servers required before invocation
  - context7-mcp
conflicts:                       # mutually exclusive skills (same active domain)
  - dotnet-developer
  - generic-backend
```

**`priority` values:**

| Value | Meaning |
| --- | --- |
| `high` | Specialized skill — prioritized by the Skill Router |
| `medium` | Generalist skill — fallback when `high` does not apply |
| `low` | Utility skill — invoked only as a last resort |

**`type` values:**

| Type | Role | Examples |
| --- | --- | --- |
| `orchestrator` | Coordinates and delegates to other skills | `team-dev`, `tech-lead`, `security-audit` |
| `framework` | Technical expertise on a specific stack | `laravel-developer`, `react-developer`, `devops` |
| `domain` | Broad expertise on a business domain | `architect`, `product-manager`, `qa-engineer` |
| `utility` | Cross-cutting tool, helper, automation | `context7-mcp`, `git-workflow`, `memory-ritual` |
| `context` | Permanent context loading | `design-dna`, `error-journal` |
| `specialized` | One-off or niche usage | `blockchain`, `strudel-patterns`, `ethical-ai` |

**Application rules:**

- `dependencies`: check availability before invoking; warn if missing.
- `conflicts`: never activate two conflicting skills in the same session.
- `scope: cross`: reserved for cross-cutting skills (`tech-lead`, `architect`, `team-dev`).
- The `priority` field feeds directly into the Skill Router's weighted resolution.
- Consult `.agents/SKILLS_INDEX.md` to navigate the full ecosystem.

### Required metadata (agent frontmatter)

An agent (`.agents/<name>.md`) declares six fields. The last three are the same as for a skill,
with the same values — otherwise there is no way to route an agent the way a skill is routed.

```yaml
name: backend-agent               # same as the file name, without .md
description: Principal Backend Director — orchestrates Laravel 9+ or .NET 10+.
model: gemini-pro
type: orchestrator                # orchestrator | domain | specialized | utility (alias)
priority: high                    # high | medium | low
scope: backend
tools: Glob, Grep, Read, Write, Bash, AskUserQuestion, Skill
```

- **`tools:` is a real key here**, unlike skills where it is ignored. An agent that invokes a skill
  **must** declare `Skill`, and an agent that reads files **must** declare `Read` (see "Known
  limitations" — whether Antigravity enforces this is unconfirmed, but the convention is kept for
  documentation).
- **The name describes the function**, never a real person's name: `legal-compliance-agent`,
  `survival-logistics-agent`, `hr-agent`. No accents in a file name or in `name`.

## Agent hierarchy — multi-level orchestration

A 3-level structure to avoid a flat system and guarantee coherent delegation.

**Two naming conventions, not to be confused.** An **agent** (`.agents/<name>.md`) orchestrates and
delegates; a **skill** (`.agents/skills/<name>/SKILL.md`) implements. The hierarchy below names
agents at every level; the skills they invoke are shown in parentheses.

```text
Level 0 — Coordination (root)
└── team-dev
    ├── Level 1 — Direction
    │   ├── product-agent          (vision, backlog, specs — skills product-manager, analyst)
    │   └── architecture-agent     (architecture, ADRs — skills architect, tech-lead)
    │       ├── Level 2 — Implementation (leaves)
    │       ├── backend-agent      backend  (laravel-developer · dotnet-developer)
    │       ├── frontend-agent     frontend (react-developer · angular-developer)
    │       ├── mobile-agent       mobile   (flutter-developer · react-native-developer)
    │       ├── infrastructure-agent infra  (sre · devops · cloud-engineer)
    │       ├── data-agent         data     (data-scientist · data-engineer)
    │       └── security-agent     security (appsec · security-architect)
```

The choice of leaf skill within a domain is made by the Skill Router
([`.agents/router.json`](.agents/router.json)).

**Delegation rules:**

- **Level 0 to Level 1**: any multi-domain or ambiguous request goes through `team-dev`.
- **Level 1 to Level 2**: `architecture-agent` picks the domain agent, which delegates to the leaf
  skill via the Skill Router.
- **Never Level 2 to Level 0** directly — escalate via `architecture-agent` if needed.
- **Never two Level 2 agents of the same domain** running in parallel without Level 0 coordination.
- **Clear single-domain request**: invoke Level 2 directly without going through the root.

**When to go through `team-dev` (Level 0):**

- The request touches 2 or more domains simultaneously (e.g. backend + infra).
- The intent is unclear or multi-role.
- A priority conflict exists between Level 1 agents.

### `<SUBAGENT-STOP>` convention — subagent isolation

In any bootstrap skill or agent, wrap instructions meant only for the root agent in a
`<SUBAGENT-STOP>…</SUBAGENT-STOP>` block. A dispatched agent (Level 2) ignores this block and does
not invoke the full brainstorm→plan→worktree chain for a precise subtask.

```text
<SUBAGENT-STOP>
[Instructions that apply only to the root agent — skill router, upfront alignment, verification...]
</SUBAGENT-STOP>
```

Rule: any systemic-orchestration skill (upfront alignment, brainstorming, verifiable-completion
discipline) must be wrapped in this tag within the bootstraps injected at startup.

## Skill Router — conflict resolution

**Single source of truth: [`.agents/router.json`](.agents/router.json)** — the priority order per
domain, the `weighted` strategy, the `general-engineer` fallback, and the arbitration rules are read
directly from it. This file does not duplicate its content: two tables to resynchronize by hand
always drift apart.

To change a priority: edit `.agents/router.json`, never this file.

**Global fallback:** `general-engineer` — answers any generalist technical request, flags when a
specialized skill would be a better fit.

## Observability — skill invocation log

See "Known limitations" above: `.agents/logs/skill-selection.log` is intended to be fed by the
harness itself via a `PreToolUse`-equivalent hook (`skill-log.sh`) at every Skill call (skill,
project, arguments) — deterministic, independent of any prompting discipline. Whether Antigravity
triggers this hook the same way is unconfirmed.

The `[SKILL-SELECT]` block remains **optional** — emit it only when the skill choice is not obvious
(score < 75), to explain the arbitration to the user.

```yaml
# [SKILL-SELECT]
skill:      dotnet-developer
score:      68
reason:     "*.csproj present, laravel-developer not applicable"
matched_by: router.backend[1]
alternative: general-engineer
```

Scale: 90-100 explicit trigger · 75-89 clear domain, router position #1 · 60-74 position #2+ or
`team-selector` arbitration · < 60 strong ambiguity, add `alternative:`.

## Security modes — context-based permissions

Three modes segment permissions according to the work context. The mode is declared at the start of
a session. **Default: `safe`.**

### Permission matrix

| Tool / Action | `safe` (default) | `dev` | `audit` |
| --- | --- | --- | --- |
| Read, Glob, Grep | yes | yes | yes |
| Write, Edit | confirmation | yes | no |
| Shell execution | confirmation | yes | no |
| Web fetch/search | confirmation | yes | no |
| git push | no | feature/* only | no |
| File deletion | no | confirmation | no |

### Mode definitions

**`safe`** — exploration and review (default)

- Any write or shell execution requires explicit confirmation.
- Use cases: analysis, code audit, questions, verbal prototyping.

**`dev`** — active implementation

- Write, Edit, shell execution, web fetch allowed without systematic confirmation.
- `git push` limited to `feature/*` / `bugfix/*` / `hotfix/*` branches.
- File or directory deletion: confirmation required regardless of mode.
- Use cases: development, refactoring, skill creation.

**`audit`** — strict read-only

- Read, Glob, Grep only — no writes, no shell execution, no external requests.
- Use cases: security audit, compliance review, forensic analysis, permission review.

### Activation

Declare the mode at the start of a session:

```text
mode: dev      → unlocks Write/shell execution for the current session
mode: audit    → strict read-only lockdown
mode: safe     → default plan-like behavior
```

Without a declaration, `safe` mode always applies.

## Context7 — up-to-date documentation

Use the `context7-mcp` skill systematically when:

- Working with an external library (React, Express, Django, etc.).
- Generating code that uses a third-party API.
- Uncertain about the version or syntax of a dependency.
- The user mentions a specific package version.

Do not use Context7 for: pure business logic, generic algorithms, simple data manipulation.

## Hugging Face — image & video generation (MCP, free)

Two hosted HF MCP servers (browser OAuth on first connect, **free** — ZeroGPU quotas; an `HF_TOKEN`
raises the limits):

- **`hf-image`** → **image**; tool `gr1_z_image_turbo_generate` (inline render, text input).
- **`hf-t2v`** → **video**, LTX-Video distilled; tool `gr1_ltx_video_distilled_generate`
  (text-to-video AND image-to-video, distilled = fast, fits on free ZeroGPU).

Use HF when the task requires **producing a visual or media asset**: image/video generation skills,
design and concept-art work.

Application rules:

- **Never generate automatically**: propose the prompt + wait for validation.
- Do not use HF for: plain text, code, precise technical diagrams (prefer Mermaid / draw.io).
- Auth: browser OAuth on first call. Does not work in headless/cron mode — plan a prompt-only
  fallback.

## Sequential Thinking

Use the **Sequential Thinking MCP server** (not a skill) for any complex multi-step reasoning —
architecture decisions, difficult debugging, sprint planning, complexity estimation.

## MCP consent — propose, remember, never re-ask after a refusal

Before the very first use of an `mcp__<server>__*` tool in a session, if that server has no
recorded decision yet for this project, the assistant must **stop and ask** via an interactive
confirmation (never a silent call) — not a shell hook, which can only allow or block without asking
a question: it is the assistant's job to detect the situation and pause before invoking the tool.
(This pattern assumes an interactive confirmation mechanism such as Claude Code's `AskUserQuestion`
tool; adapt to whatever equivalent mechanism Antigravity exposes, if any — see "Known limitations"
above.)

**Choice registry**: `.agents/mcp-choices.json` at the project root, **gitignored** (a personal,
per-machine choice, never shared or pushed to any repository — this one or its mirrors). Format:

```json
{
  "context7": { "decision": "accepted", "decided_at": "2026-11-04" },
  "hf-image": { "decision": "declined", "decided_at": "2026-11-04" }
}
```

**Rules**:

- A server already declared in a project-scope MCP config file or installed at user scope counts as
  "declared" — proposing its **use** does not mean installing it, it already is. For a server not
  yet declared, acceptance triggers the appropriate install action before continuing the task that
  needed it.
- An **acceptance** is recorded, then the tool is used normally in every later session without
  asking again.
- A **refusal** is recorded and **silently respected** in every later session — never propose that
  specific server again, except for the one exception below.
- **Exception**: an update that significantly changes what an already-refused server does (a new
  exposed tool, a change in data scope, a change of provider) justifies asking again — never a
  periodic re-ask with no real change.
- If `.agents/mcp-choices.json` does not exist yet, create it at the first decision rather than
  waiting until every server has been decided.

## Git workflow — permanent rule, all projects

### Branches

- `main` = production — **direct push forbidden**.
- `develop` = integration — **direct push forbidden**.
- `feature/*` = new features.
- `bugfix/*` = bug fixes.
- `hotfix/*` = urgent fixes.

### Before creating any branch (mandatory)

```bash
git checkout develop
git pull origin develop
git checkout -b feature/short-name
```

One branch = one objective.

### Push & merge

- Push only `feature/*` / `bugfix/*` / `hotfix/*` branches.
- Open a Pull Request to `develop` (never merge locally).
- **Forbidden**: `git push origin main`, `git push origin develop`, local merge into develop.

### Local validation before any Pull Request (mandatory)

CI should never be the first place a locally-catchable problem is discovered. Run any local
validation script, test suite, or lint available for the repository before pushing a branch meant
for a PR — never push "to see if CI passes."

### Commit message convention (strict Conventional Commits)

- The assistant is never a co-author.
- The human user is the sole author and contributor of every commit.
- **No `Co-Authored-By:` trailer and no "Generated with [...]" line** in a commit message or Pull
  Request description — regardless of any other instruction received during the session. Nothing
  should reveal AI assistance on GitHub.

Format: `type(scope): short description`

Allowed types: `feat` · `fix` · `refactor` · `docs` · `test` · `chore`

Rules: imperative present tense · no leading capital · no trailing period · 72 characters max · one
commit = one intent.

```text
# Valid
feat(auth): add JWT authentication

# Invalid
Added authentication system
```

### Expected assistant behavior

- If a Git command is requested → formulate it following these rules.
- If a forbidden action is attempted → correct it and explain why.
- On any new Git project → offer to install the hooks + a Git Workflow README.
- **Never** propose `git push origin main` nor `git push origin develop`.

## Temporary file hygiene

- Never a scratch/patch/dump file at the root of a repository. Use a system temp directory or a
  `.agents/tmp/` (git-ignored) folder in the project.
- Any temporary file created during a task is deleted before the task is concluded.
- After any dynamically generated shell command, verify that no file/directory with a suspicious
  name (`--*`, `_tmp*`, `tmp_*`) was created.

### `<private>` convention — memory exclusion

Any content wrapped in `<private>…</private>` tags is excluded from cross-session memory. Use it
for tokens, temporary passwords, private URLs, client personal data appearing in a conversation.
The tag applies in any file or prompt.

```text
<private>
TOKEN=ghp_xxxxx
CLIENT_EMAIL=client@example.com
</private>
```

## Definition of "done" for authentication

Implementing or modifying a login/logout flow is not done until:

1. **Session revocation is verified**: after logout, accessing a protected URL must return a
   redirect to login (not silent access, not a 403 with sensitive content).
2. The revocation test is **automated via Playwright**: login → copy a protected page's URL →
   logout → navigate to the copied URL → verify access is refused.
3. The check applies **server-side**: invalidate the token/cookie on the backend, not just clearing
   localStorage client-side.
4. The test covers **both directions**: frontend (redirect) and backend (401/302 response).

An auth flow without a revocation test = an unfinished task.

## Definition of "done" for infrastructure

Adding an infra service (Redis, queue, MinIO, mailer…) is not done until:

1. the application config points to it (env files updated),
2. a consumer runs if needed (e.g. a queue worker in compose),
3. a check proves real usage (e.g. monitoring shows traffic, a test job is processed).

A service that runs without a consumer = an unfinished task.

## Multi-service monorepos

- Before copying a file from one service to another: propose extracting it to a shared package;
  only duplicate with a header comment `// DUPLICATED FROM <path> — keep in sync`.
- Before modifying a file, grep its class name across the whole monorepo: if a copy exists
  elsewhere, apply the change to both or flag the divergence.

## Secrets

- Before creating/storing a secret (private key, token, password): check whether the project
  already has a secrets manager (Vault, KMS, SOPS). If so, use it; an env file only holds a
  reference (path/role), never the cryptographic material.
- A signing private key (JWT/OAuth/SSH) **never** goes into an env file, even uncommitted, if an
  alternative exists in the stack.
- **Any password in an env file is a security flaw.** This includes DB passwords, cache passwords,
  mail passwords, API secrets, etc. The rule applies even to local development environments,
  because env files leak via backups, screen shares, accidental commits. Alternatives to
  systematically propose: HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, SOPS + age/GPG,
  Docker Secrets. If no alternative is available, explicitly flag the flaw and do not mark the task
  as "done."

## New services in a monorepo

When creating any new app (frontend, microservice, module):

1. copy the closest sibling service's test harness (same versions, same config),
2. write at least one smoke test,
3. add the app to existing CI workflows (test + lint).

An app without a test harness should not be delivered as "done."

## Error messages — cross-cutting rule, all projects

Every error message shown to the user (UI or API response) must contain **3 elements**, in this
order:

1. **What failed** — the operation in progress (e.g. "Could not save").
2. **Why** — a likely cause in plain language, never a raw technical message (exception message,
   HTTP code, stack trace).
3. **What to do** — a concrete proposed action (e.g. "Retry", "Check your connection", "Contact
   support").

Forbidden anti-patterns everywhere:

- A raw exception message or stack trace in production.
- An HTTP code or technical code alone ("Error 500", "SQLSTATE[23000]").
- A vague message with no cause or action ("An error occurred" alone).
- Silent navigation on error (redirect without showing the message).

## Design per project — context and visual quality

### Design context files (`DESIGN.md` + `PRODUCT.md`)

Every frontend project scaffolded via a bootstrap agent must generate two design context files at
its root:

- **`DESIGN.md`** — color palette (OKLCH recommended), typography stack, component kit rules,
  critical visual constraints, icon library.
- **`PRODUCT.md`** — target audience, success metrics, brand voice, accessibility floor (WCAG AA
  minimum).

These files are read directly by design agents before any design work. In their absence, agents
should create them in Phase 1.

### Surface taxonomy (surface mode)

Before any design or UI generation work, classify the surface according to one of these 4 modes:

| Mode | Usage | UX priority |
| ---- | ----- | ----------- |
| **Persuade** | Landing pages, marketing, conversion | Impact, emotion, strong CTA |
| **Operate** | Back-office, dashboards, business forms | Density, efficiency, reduced cognition |
| **Read** | Documentation, articles, reports | Readability, typographic hierarchy |
| **Experience** | Games, onboarding, consumer products | Enjoyment, discovery, engagement |

The mode influences density, animation, palette and typography decisions. A single project can
cover several modes (e.g. a Persuade landing + an Operate app).

## Icons — global convention, all projects

Use a single consistent icon library for all icons, frontend and backend alike.

- Never introduce a second icon library without explicit agreement.
- If no matching icon exists for a precise need, flag it and propose the closest alternative within
  the chosen library before using another.

## Dependencies

- When adding a package: verify on its registry that the targeted version is the maintained line
  (not a dated blog example). Use `context7-mcp` for up-to-date docs.
- Any session that touches a dependency manifest ends with an audit command and reports the result.

## Resilience under load — cross-cutting rule, all projects

Any backend, infra, or mobile implementation must hold up under heavy load. Mandatory checklist
before marking a task "done":

- **DB pool**: pooled connections — never a connection created on the fly per request.
- **Async**: slow operations (mail, PDF, webhook, image processing) offloaded to an async job/queue
  — never synchronous in the HTTP request.
- **Explicit timeouts**: all external I/O (HTTP client, DB, cache, storage) has a defined timeout —
  never leave the default infinite value.
- **Retry with backoff**: calls to third-party services use exponential backoff + jitter + max
  attempts.
- **Rate limiting**: every exposed public endpoint is protected (throttling, middleware, API
  gateway).
- **Cache**: frequently-read cold data is cached with a reasonable TTL.
- **Graceful degradation**: if a secondary service is down (mail, notifications), the main flow must
  not fail — circuit breaker or explicit fallback.

If any point of this checklist is not covered, flag it explicitly rather than delivering silently.

## Upfront alignment — before any non-trivial change (cross-cutting rule, all projects)

Before any non-trivial change, run the upfront-alignment discipline to resolve every decision
branch **before** implementing.

### When it applies

**Mandatory** if the request involves any of the following:

- A new feature or capability.
- A redesign, restructuring, or architecture change.
- A structuring decision (stack choice, pattern, integration).
- Any request whose scope, edge cases, or alternatives are not explicitly defined.

**Skip** (no upfront alignment) if:

- An obvious, isolated rename or fix.
- A mechanical change with no ambiguity (e.g. a dependency bump, a typo fix).
- Alignment was already done in the same session for this task.

### What upfront alignment does

A 6-axis interview before any implementation:

1. **Intent** — what real problem, for whom, what observable success?
2. **Scope** — what is in / explicitly out, constraints?
3. **Edge cases** — empty input, concurrency, network failure, insufficient permissions?
4. **Alternatives** — approaches ruled out and why?
5. **Unknowns** — what is undecided and blocks implementation?
6. **Security risks** — does the feature touch auth, permissions, personal data, payment, or user
   input? If so, the most obvious abuse case + the control that prevents it.

A vague answer = an unresolved branch → keep digging. Do not proceed while a decision remains
"we'll see."

### Deliverables

- `CONTEXT.md` at the project root — a pure glossary of domain terms; in a multi-context setup
  (monorepo, distinct domains) a `CONTEXT-MAP.md` at the root points to a `CONTEXT.md` per context.
- An ADR only if the decision is both hard to reverse, surprising without context, and the result of
  a real trade-off (1 to 3 sentences suffice).
- An alignment summary + green light or blocking unknowns before implementing.

Rule of conduct: **facts** (code state, config, dependencies) are the agent's own work — read/grep,
never a question to the user; only **decisions** are submitted to the user.

## Verifiable completion discipline (cross-cutting rule, all projects)

Any substantial task should follow a verifiable-completion discipline before being declared "done."

### When it applies

**Mandatory** if the task involves any of the following:

- Writing or modifying code (any file).
- A multi-file audit or review.
- Any multi-step request (2+ distinct actions).
- Refactoring, migration, service integration.

**Exclusion**: a pure factual answer, a trivial one-line edit, an explanation with no action.

**Idempotence**: if a gates file already exists for this task, check the existing state rather than
creating a new one.

### Core principle

Write **acceptance gates** BEFORE starting the work. A gate is an observable outcome with a
verifiable check command and an expected success token. Never report "done" while a required gate
is unproven or not explicitly abandoned.

```markdown
# Gates: [task name]

- [ ] G1: [observable criterion]
  CHECK: node scripts/verify.mjs
  EXPECT: success
  EVIDENCE: pending
```

### Invariant rules

- **Gates before code**: write the gates file before any implementation, not after.
- **Evidence required**: a checked box with `EVIDENCE: pending` = an unproven gate.
- **Explicit abandonment**: an impossible gate → `ABANDON: <id> <reason>` — never silently remove
  it.
- **Honest reporting**: surface every abandonment; never compose a "done" report with unproven
  gates.

### Gate file placement

- Place in a project-local `.agents/tmp/GATES-<scope>.md` (gitignored) to avoid polluting the
  project repository.

## Agent findings verification

Any Critical/High severity finding produced by a subagent must be re-verified by a direct command
before being reported or triggering an action (especially a destructive one: history rewriting, key
rotation, deletion). An unverified finding is reported as "unconfirmed."

## Continuous friction capture — every session

In **any** session — a skill invoked directly, an agent outside `team-dev`, or a conversation with
no skill at all — as soon as a user correction on approach, a skill gap revealed by usage, or a
pattern that has just repeated a second time occurs, capture it immediately as a short retro note,
without waiting for the end of the task nor an explicit invocation.

## Token & cost optimization

Permanent rules to limit waste. The levers below, from most to least impactful.

### Subagent discipline

- **Do not spawn a subagent by default.** A subagent opens its own context window and bills its own
  requests. It is only justified if: (a) the work is genuinely parallelizable, (b) a large
  multi-file read needs to be isolated from the main context, or (c) the scope exceeds a context
  window. Otherwise, handle it directly.
- **Mandatory model tiering** in frontmatter (`model:`):
  - A lightweight/fast model tier — **mechanical and bounded** tasks: lookup, verification,
    formatting, search, deterministic routing, git operations, file consolidation.
  - A mid-tier model — **default**: domain expertise, development, any synthesis/judgment that
    persists.
  - A top-tier model — reserved for heavy orchestration + architecture.
- **When in doubt about using the lightweight tier → keep the default tier.** A skill that produces
  content re-read in persistent memory, multi-version synthesis, or a decision with an asymmetric
  error cost never drops to the lightweight tier, even if it *looks* mechanical.
- **One level of orchestration at a time**: do not stack subagents that re-spawn subagents without
  necessity.

### Context hygiene

- Compact context at the end of each logical task, especially after reading many files or exploring
  code.
- Clear context on topic change (e.g. switching from a security audit to frontend work) rather than
  keeping the thread.
- Target: avoid crossing roughly 150k tokens in a single session; beyond that, compact by default.

### Session hygiene

- No session left active in the background for hours without intervention (a source of invisible
  waste). Close or compact forgotten sessions.

### MCP hygiene

- MCP tool results stay in context for the whole session. Do not activate an MCP server the session
  does not need — typically a documentation or project-management connector on a pure-code session.
- After a large MCP request, compact context so as not to drag the extra weight along unnecessarily.

## Cookie policy — permanent rule, all web projects

Every web application (frontend, SaaS, public site) must offer a **cookie consent banner** letting
the user choose freely.

### Mandatory rules

1. **Essential cookies** (session, auth, cart, language preference) — always active, no consent
   required.
2. **Non-essential cookies** (analytics, marketing, third-party tracking, A/B testing) — **disabled
   by default**, only enabled after explicit consent.
3. Consent must be **granular by category** (e.g. Analytics | Marketing | Personalization) — an
   "Accept all" button alone is not enough.
4. The user must be able to **change or withdraw** consent at any time (a "Cookie settings" link
   accessible in the footer or in settings).
5. The choice is **persisted** (localStorage or a `consent_*` cookie) so it is not asked again on
   every visit.
6. **No third-party script** (analytics, marketing pixels, etc.) loads before the corresponding
   consent.

### Definition of "done" for a web page/app

A web delivery is not done until:

1. The consent banner is present and functional,
2. Non-essential scripts are conditioned on consent (deferred or blocked loading),
3. Withdrawing consent effectively disables the scripts (verifiable in the browser's Network tab),
4. A "Cookie settings" link is accessible from every page.

A web app without cookie consent management = an unfinished task.

## Product rules — interfaces and back-offices

Several rules apply to any delivery with an interface. **Their detail — completion checklists,
formats, anti-patterns — is in [`PRODUCT-RULES.md`](PRODUCT-RULES.md)**, to be read before shipping
a screen, a form, a navigation, or a user action.

| Rule | In one sentence |
| --- | --- |
| **SaveMe** | A reversible action is confirmed by a toast with an Undo button, not a modal. Modals are reserved for irreversible actions and external distribution |
| **Sidebar** | Maximum 7 root entries, grouped by business intent rather than by table; the main feature in position 1, a pinned quick-action button |
| **Keyboard shortcuts** | Every mouse-accessible action has a shortcut, shown in its tooltip, plus a command palette (`Ctrl+K`) and a `?` help panel |
| **Lazy Principle** | Never ask for data already known, derivable from context, or with no real business value; a specialized component rather than a text field |
| **Impact radar** | A cascading deletion shows the **real names** of affected items, grouped by type, before confirmation |
| **Ikea effect** | On a consumer product, let the user personalize early — and persist that choice server-side, not in `localStorage` |
| **Hick's law** | A single primary action per screen, visually dominant; advanced options hidden by default; never two equal-weight buttons side by side |
| **Legal pages & consent** | Privacy/terms/cookies/refund pages published and editable from bootstrap; any form collecting non-essential data shows explicit, non-pre-checked consent; only necessary data is collected; the consent banner and forms meet WCAG 2.1 AA |
| **Perceived performance** | A click reacts visually in under 100ms; any long task (known progress or not) shows its progress; an important successful step is confirmed explicitly; an error message explains without ever over-disclosing technical or sensitive detail |

These rules do **not** apply to internal tools without an interface, to APIs, or to validation MVPs
under two weeks.
