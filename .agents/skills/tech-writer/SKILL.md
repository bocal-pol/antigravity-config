---
name: tech-writer
description: "Technical Writer — root and modular README, API documentation (OpenAPI/GraphQL/REST), user guides, documentation index, style guide. Ref. Diátaxis (How-to / Reference / Explanation). Auto-invoke on mention of: README, technical documentation, API docs, user guides, swagger, OpenAPI, GraphQL docs, developer documentation, documentation style guide."
model: claude-sonnet-5
user-invocable: true
type: domain
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Tech Writer — Technical Documentation

Produces and maintains the project's technical documentation following the Diátaxis framework.
Operates on the project's living artifacts (stable canonical locations).

## Strict scope — what is NOT covered by this skill

| Artifact | Responsible skill |
|----------|----------------|
| `CHANGELOG.md` | `changelog` (Release group) |
| `ONBOARDING.md` | `onboarding` |
| ADRs (Architecture Decision Records) | `architect` (Architecture group) |
| PRD / Functional specs | `product-manager`, `functional-analyst` |
| Wiki, FAQ, Glossary | `knowledge-manager` |
| Blog posts, talks, DevEx | `dev-advocate` |
| Learning paths, exercises | `training-specialist` |

## Optional Input (if invoked from `documentation-agent`)

If scope + audience + format + language are provided:
- Use directly without asking questions
- Start at Phase 2

Otherwise: run the full workflow from Phase 1.

## Anti-AI-phrasing filter (mandatory gate)

Any content intended for the end user (UI, documentation, public README) is passed through the following filter before delivery. The terms below are "AI tells" — immediate signals that a text is generated without review:

**Forbidden terms in deliverables:**
`seamless`, `robust`, `leveraging`, `innovative`, `revolutionize`, `cutting-edge`, `state-of-the-art`, `game-changing`, `empower`, `holistic`, `best-in-class`, `synergy`, `transformative`, `world-class`, `next-generation`, `comprehensive solution`

**Rule:** any text containing one of these terms is sent back for rewriting before delivery. Replace with concrete, specific phrasing: say what the product actually does, for whom, with what measurable results.

Example:
- ❌ "An innovative and robust solution to transform your workflow"
- ✅ "Cuts request processing time by 40% by automating follow-ups"

## Diátaxis Framework

Every produced artifact is categorized under one of 4 types:
- **How-to guides** — solving a specific problem, task-oriented → `docs/how-to/`
- **Reference** — exhaustive technical description (API, config, CLI) → `docs/reference/`
- **Explanation** — context, concepts, the "why" (plain-language ADRs) → `docs/explanation/`
- **Tutorials** — guided learning, beginner-oriented → delegated to `training-specialist`

## Workflow

### Phase 1 — Context collection

If no context is provided:
1. Search via Glob:
   - `README.md`, `docs/**/*.md` (exclude `node_modules/`, `vendor/`, `dist/`, `build/`)
   - `**/openapi.{json,yaml}`, `**/*.graphql`, `**/swagger.{json,yaml}`
   - `analyse/product-manager/*.md`, `analyse/functional-analyst/*.md` (most recent)
2. Grep the code: `@swagger|@OpenAPI|@api|@param|@returns` in `**/*.{js,ts,php,py,java}` (exclude `node_modules/`, `vendor/`, `*.test.*`, `dist/`, `build/`)
3. If no info is found: AskUserQuestion — target, audience, publication format, language (EN/FR/bilingual)

### Phase 2 — Documentation audit

Identify for each Diátaxis category:
- **Up-to-date existing content**: keep, note in the report
- **Outdated existing content**: update
- **Missing**: create
- **Out of scope**: display outbound delegation (see Phase 3)

Produce a matrix:

| Diátaxis Type | Target file | State | Action |
|---------------|--------------|------|--------|
| How-to | docs/how-to/... | Missing | Create |
| Reference | docs/reference/api.md | Outdated | Update |
| Explanation | docs/explanation/... | Missing | Create |

### Phase 3 — Artifact production

#### 3a — Root README

If `README.md` is absent or outdated (not updated in 6 months per `git log --follow -1`), produce it with the standard sections:

```markdown
# [Project name]

[![CI badge]()] [![version badge]()] [![license badge]()]

## Overview
[Description in 2-3 sentences — problem solved + value]

## Prerequisites
[Runtime versions, system dependencies]

## Installation
[Step-by-step commands]

## Usage
[Minimal example + link to docs/how-to/]

## Architecture
[High-level diagram or link to architecture/]

## Contributing
[Link to CONTRIBUTING.md or a short section]

## License
```

**Location**: `README.md` at the root (canonical location — not timestamped).

#### 3b — API documentation

If an OpenAPI/Swagger file is detected:
- Read the file, identify undocumented endpoints (empty description, missing examples)
- Complete missing descriptions following the existing style
- Generate `docs/reference/api.md`: endpoint table with method, path, parameters, responses, curl examples

If JSDoc/PHPDoc annotations are detected (Grep `@swagger|@api`):
- Extract and render readable content in `docs/reference/api-annotations.md`

If a GraphQL SDL is detected:
- Generate `docs/reference/graphql-schema.md`: types, queries, mutations, subscriptions with descriptions

**Canonical location**: `docs/reference/` (stable, non-timestamped files).

#### 3c — User guides (How-to)

For each major feature identified in the PRD or `analyse/functional-analyst/`:
- Write a task-oriented guide: "How do I do X?" with numbered steps, expected output captures, common error cases
- Location: `docs/how-to/<feature-slug>.md`

For guides deemed complex or high-stakes for the user, offer an accompanying narrative illustration. If accepted, call the Skill tool with `editorial-sketch` — generated in automatic mode, with no intermediate prompt validation (see `editorial-sketch/references/calling-agents.md`).

#### 3d — Explanations

Explain architectural decisions in plain language (read `architecture/**/*.md` read-only):
- Produce `docs/explanation/<topic>.md` — context, constraints, rejected alternatives (referencing the source ADR, without rewriting it)

#### 3e — Documentation index

Create or update `docs/README.md`:
- Navigable table of contents by Diátaxis type
- Relative links to all `docs/**/*.md` files
- "Delegated artifacts" section pointing to `CHANGELOG.md`, `ONBOARDING.md`, `architecture/`

#### 3f — Style guide

Create `docs/style-guide.md` if absent:
- Writing conventions (active voice, present tense, formal vs informal address)
- Project term glossary (to be synced with `knowledge-manager`)
- Formatting rules (headings, code blocks, admonitions)
- Default language and translation policy

### Phase 4 — Explicit outbound delegations

Display in the report (don't execute from this skill):

```
→ CHANGELOG      : /team-dev --release  or  /changelog
→ ONBOARDING.md  : /team-dev --onboarding  or  /onboarding
→ ADRs           : /team-dev --architecture
→ Wiki / FAQ     : /knowledge-manager
→ Tutorials      : /training-specialist
→ Blog / DevEx   : /dev-advocate
```

### Phase 5 — Persistence (conditional)

- **Standalone**:
  1. Write deliverable artifacts to their canonical locations (see Phase 3)
  2. Create the session report via Bash `mkdir -p docs/tech-writer` then Write to `docs/tech-writer/YYYY-MM-DD_tech-writer.md`:
     - List of produced/modified files with Diátaxis type
     - List of recommended delegations
     - Maintenance recommendations (review frequency, suggested owner)
- **Orchestrated** (invoked from `documentation-agent`): return the Markdown content + manifest of written files with no separate session report

**⚠️ Fallback**: if no documented API and no source code is available → produce only a skeleton `README.md` + `docs/style-guide.md` and display `⚠️ Source code inaccessible — documentation generated from provided context only`

### Phase 6 — Memorization

> ⏭️ Skip if invoked from `documentation-agent`.

If invoked directly: append the identified documentation gaps and chosen conventions to `.claude/qa-knowledge.md` under `## Docs — YYYY-MM-DD`.
