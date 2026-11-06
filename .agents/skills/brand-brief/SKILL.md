---
name: brand-brief
description: "Brand Brief — brand identity brief for project bootstrap (mission, values, personality, tone & voice, positioning, visual identity logo/palette/type/imagery). Auto-invoke on mention of: brand brief, brand identity, brand guidelines, tone and voice, brand personality, brand book."
model: claude-sonnet-5
user-invocable: true
type: utility
priority: medium
scope: frontend
dependencies:
  - ux-writer
  - design-system
conflicts: []
---

# Brand Brief — Bootstrap brand identity

Produces a **brand identity brief** (`intake/brand-brief.md`): mission, personality, tone & voice,
and visual foundations to lock down **before** detailed design. Business owner: the design agent.

## Optional input (orchestrable)

If project/brand context is provided as input (from the bootstrap agent or `team-dev`), use it
without re-asking questions. If `intake/brand-brief.md` already exists, enrich it.

## Owning delegation

- **Voice & tone, microcopy** → delegate to `ux-writer` via `Skill`.
- **Visual tokens (palette, type, components)** → delegate to `design-system` via `Skill`.
- **Overall design orchestration** → the design agent (via `team-dev --design`).
⚠️ Fallback: if `ux-writer` / `design-system` are unavailable, produce the brief from memory using
the template.
⚠️ Never generate an image automatically: propose the prompt and wait for validation (see the
HF/`imagine` rule).

## Workflow

### Phase 1 — Collection
Grouped question via `AskUserQuestion`: brand name, mission, values (3), target audience, desired
personality, visual preferences (colors/type if known), reference brands.

### Phase 2 — Drafting
Fill in the template. `TO BE DETERMINED` for any undecided visual choice (don't invent arbitrary
HEX values without validation).

## Template — `intake/brand-brief.md`

```markdown
# Brand Brief — [Brand]

- **Mission**: why the brand exists
- **Vision**: where it wants to go
- **Elevator pitch**: 2 sentences

## Values & personality
- **Values**: 3 to 5
- **Archetype / personality**: (e.g. Creator, Sage, Rebel)
- **Positioning**: for [audience], [brand] is the [category] that [differentiation]

## Tone & voice
| Do | Don't |
|-------------|------------------|

## Visual identity
- **Logo**: usages, protection zones, versions (to validate with design)
- **Palette**: primary / secondary / neutrals — `#HEX` (TO BE DETERMINED if not validated)
- **Typography**: headings / body
- **Imagery style**: photo, illustration, iconography
- **To avoid**: …

## References / moodboard
- …
```

## Persistence (conditional)
- **Standalone**: `mkdir -p intake` then write `intake/brand-brief.md`.
- **Orchestrated**: return the Markdown, persistence handled by the bootstrap agent.

## Skip memorization
The `intake/brand-brief.md` artifact is the deliverable — versioned in the project, not in
`~/.claude/memory/`.
