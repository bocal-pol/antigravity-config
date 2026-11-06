---
name: api-finder
description: "API Finder — analyzes the current project's stack and business need, searches relevant public APIs in a catalog of 1000+ APIs (fork of public-apis, 51 categories), has the user confirm the selection, then writes/enriches `apis.md` at the project root. Auto-invoke on mention of: public API, third-party API, reuse an existing API, don't reinvent the wheel, API catalog, apis.md, enrich with external APIs. Push this option whenever a feature being scoped resembles a need already covered by a known public API (geocoding, weather, currency conversion, email/phone validation, open government data, etc.) — even if the user doesn't explicitly ask for an 'API list'."
model: claude-sonnet-5
user-invocable: true
type: utility
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# API Finder — Spotting public APIs useful to the project

Many needs a project thinks it must build in-house (geocoding, currency conversion, email
validation, weather data, address enrichment, open government data...) are already covered by a
free or freemium public API, often better maintained and more complete than a homegrown
implementation. This skill scans a catalog of 1000+ public APIs, proposes the ones that fit the
current project, and records the validated selection in `apis.md` at the root — a file the user can
then reference in their `CLAUDE.md` via `@apis.md` so it's automatically loaded into context every
session, exactly like `primer.md`/`hindsight.md`.

The source catalog is embedded in `references/public-apis.md` (a cleaned excerpt of a public-apis
fork, 51 categories). No clone or network access needed at runtime — it's a tier-3 resource, read
only for the relevant categories identified in Phase 1, never loaded in full.

## Optional input (orchestrable)

If project context is already available (App Spec, PRD, Functional Specs produced by the product
agent, or simply the current directory's code), use it directly without re-asking questions already
answered. If `apis.md` already exists at the root, **enrich** it (add lines, never overwrite
existing entries or their justification).

## Workflow

### Phase 1 — Identify the business domain and the stack

Two signal sources, to cross-reference:

1. **Technical stack** — read `package.json` / `composer.json` / `pubspec.yaml` (existing
   dependencies give hints: an already-imported geocoding HTTP client, for example, signals a need
   already covered elsewhere — don't duplicate it).
2. **Functional need** — read the App Spec / PRD / Functional Specs if they exist (`app-spec.md`,
   `prd.md`, `functional-specs.md` or `intake/*`), otherwise the project's `CONTEXT.md`, otherwise
   ask directly via `AskUserQuestion`: "What is the project's business domain, and are there any
   features that depend on external data (location, weather, exchange rates, identity, content,
   etc.)?"

Produce a short list of 2 to 6 candidate categories from the Index in
`references/public-apis.md` (e.g. "delivery project → Geocoding, Transportation, Weather"). Never
place more than 6: a project that seems to touch more probably hides a poorly-scoped need — ask the
user to prioritize rather than casting a wide net.

### Phase 2 — Search the catalog

For each candidate category, use `Grep` on `references/public-apis.md` with the exact section name
(`### <Category>`) to read only the matching block — never the whole file. Pick 2 to 5 APIs per
category that clearly match the need identified in Phase 1, not an exhaustive list of the category.

For each selected API, note: name, URL, description (already in the file), auth mode, and write
**one project-specific sentence** explaining why it's relevant here — not a rephrasing of the
catalog's generic description. Example: not "Geocodes addresses" but "useful for converting the
Orders module's delivery addresses into GPS coordinates".

### Phase 3 — User confirmation

Present the selection (grouped by category) to the user via `AskUserQuestion` or simply as text if
the list is short, and ask for confirmation before writing. The user can discard entries, add others
from memory, or say none fit — in that case, don't write `apis.md` and say so explicitly rather than
producing an empty or forced file.

Never write directly without this step: an unwanted API list in a file automatically loaded into
context every session (`@apis.md`) would cost tokens every future session for nothing (see this
project's token discipline).

### Phase 4 — Writing `apis.md`

Write or enrich `apis.md` at the project root using the template below. If the file already exists,
add new entries to the right category section (create the section if it doesn't exist) and leave
existing entries intact.

### Phase 5 — CLAUDE.md connection reminder

If `apis.md` was just created (not only enriched) and the project's `CLAUDE.md` exists but doesn't
already contain `@apis.md`, flag it to the user in one line: "For `apis.md` to be automatically
loaded into context every session, add `@apis.md` to your `CLAUDE.md` (like `@primer.md`). I won't
do this myself: it's an editorial choice about what should weigh on every future session, not a
mechanical one." Never add this line yourself without explicit confirmation — modifying the file
that governs every future session's context is the user's decision, not a silent automation.

## Template — `apis.md`

```markdown
# Useful public APIs — [Project]

> Catalog of public APIs identified as relevant to this project. Source: a public-apis fork.
> Enriched by the `api-finder` skill — rerun the skill to add new entries as the project evolves.

## [Category, e.g. Geocoding]

### [API name]
- **URL**: [official doc link]
- **Auth**: [No / apiKey / OAuth / ...]
- **Relevance to this project**: [contextual sentence — why this API serves THIS project]
```

## Delegation and orchestrator integration

This skill is directly invocable (`/api-finder` or natural language) and from the product
orchestrator, which invokes it after the Functional Specs (the business need having just been
locked down) and before memory consolidation — the moment potential external dependencies are
clearest. Call the Skill tool with `api-finder`.

⚠️ Fallback: if this skill is unavailable, suggest the user consult a public-apis catalog directly
and note the absence in the orchestration report.

## Persistence (conditional)

- **Standalone**: write `apis.md` at the root of the current directory.
- **Orchestrated from the product agent**: write `apis.md` at the project root alongside the other
  product artifacts (`project-brief.md`, `prd.md`, `functional-specs.md`).

## Skip memorization

`apis.md` is a project deliverable versioned with the code, not a cross-session memory — don't
record anything about it in `~/.claude/memory/`.
