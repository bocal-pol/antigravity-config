# image-templates — Reusable template library

Persistence folder for the [`imagine`](../SKILL.md) skill.
Three families coexist here, distinguished by file prefix:

| Family | Prefix | Who writes it | Content |
|---|---|---|---|
| **Personal** | *(none)* | You, via `/imagine` Phase 5 or manually | A reusable character/style/scene/pack (character-consistent). |
| **Bundled formats** | `format-` | The skill (versioned in this repo) | ~27 structural templates (imposed layout: blueprint, xray, explodedview...). |
| **Bundled modifiers** | `modifiers-` | The skill (versioned in this repo) | ~19 catalogs of pure aesthetic keywords (ghibli, cyberpunk, watercolor...), one file per category, in table form. |

**The `format-` and `modifiers-` prefixes are reserved.** Never name a personal template with one of
these prefixes (collision with the skill's bundled catalog). Don't manually edit `format-*`/
`modifiers-*` files except to propose a new format/modifier to the repo (in that case, a PR as with
anything else in this repo).

## Personal template types

| Type | Usage |
|------|-------|
| `character` | A recurring character (physique, outfit, visual DNA) to replay across several scenes. |
| `style` | A reusable visual signature (palette + medium + artistic school) applicable to any subject. |
| `scene` | A recurring environment / location (studio, a specific forest, planet, city). |
| `pack` | A coherent set (e.g. a comic's full cast, a poster series, a campaign). |

## Naming convention

- One `.md` file per personal template, in kebab-case, **with no reserved prefix**.
- Examples: `elara-mage.md`, `noir-cinematic.md`, `orbital-station-hope.md`, `cast-arcane-vibes.md`.
- Bundled files follow their own convention: `format-<slug>.md` (one format = one file)
  and `modifiers-<category>.md` (one file = a table of several modifiers for one category).

## Minimal schema

```markdown
---
name: <slug>
type: character | style | scene | pack
created: YYYY-MM-DD
last_used: YYYY-MM-DD
tags: [tag1, tag2]
compatible_with: [flux, sdxl, midjourney-v6]
---

# <Readable Name>

## Identity
## Visual DNA
## Positive Prompt
## Negative Prompt
## Params
## Variation history
```

See `EXAMPLE-template.md` for a complete, concrete example.

## How to use a template

From this environment:

```
imagine template elara-mage
```

The skill loads the template, displays the visual DNA, asks for the variation context (action,
angle, scene mood), then synthesizes the prompt by inheriting the template's Positive Prompt +
Negative Prompt + Params.

## How to create a template

Two paths:

1. **From a successful generation**: after `imagine deep`, at Phase 5 the skill offers "Save as a
   template?". Answer yes → it generates the file automatically.
2. **Manually**: copy `EXAMPLE-template.md`, rename it, edit the sections.

## Versioning

- Never a silent overwrite. If a template evolves significantly → `<name>-v2.md`.
- Otherwise → add a line to the `## Variation history` section.
