---
name: editorial-sketch
description: "Generates narrative companion illustrations for an article, post, or doc: black-and-white sketch, pure white background, recurring character, a few handwritten red/orange/blue annotations, one visual metaphor per image. Auto-invoke on: article illustration, companion image, sketch, visual metaphor, illustration shot list, blog image, Notion illustration. Do not use for technical diagrams (architecture, flowchart, C4) — see the `illustrate` skill for that."
model: claude-sonnet-5
user-invocable: true
type: specialized
priority: low
scope: cross
dependencies:
  - hf-image
conflicts:
  - illustrate
---

# Editorial Sketch — Narrative companion illustrations

Port and translation of the Codex skill "Ian Xiaohei Illustrations"
([github.com/helloianneo/ian-xiaohei-illustrations](https://github.com/helloianneo/ian-xiaohei-illustrations)),
adapted to this repository's conventions.

## Positioning

This skill designs and generates 16:9 illustrations to accompany text (article, post, doc, Notion
page). The goal is **not** to produce a commercial illustration, a PPT infographic, or a cute
drawing, but to turn a judgment, a process, a structure, a state, or a metaphor from the text into a
hand-drawn image — clear, a little strange, memorable.

**This is not a technical diagramming tool.** For an architecture diagram, a flowchart, a C4, or any
diagram that must stay legible as technical documentation, use the `illustrate` skill (Excalidraw).
The two skills are deliberately in conflict: never activate both on the same image.

The default recurring character is a small, solid-black figure with white dot eyes, thin legs, and a
neutral expression. It's not a mascot or a decorative sticker: it's a small, serious operator
carrying out an absurd but coherent action at the heart of the image.

In one sentence: **don't just "illustrate a text" — draw the key cognitive action it contains.**

## Suited for

- Writing articles that need companion images
- Knowledge content, methodology, AI workflows
- Turning an abstract judgment into a concrete metaphor
- A lighter, stranger, more identifiable style than a PPT infographic

## Not suited for

- Commercial illustration, brand key visual, polished flat-design illustration
- Classic PPT infographic, complex architecture diagram, flowchart → use `illustrate`
- Childish cartoon style, cute mascot, sticker style
- Compressing a long article or an entire course into a single image
- A need for a strictly editable source vector file

## What this skill produces

By default:

- A horizontal 16:9 companion illustration
- A shot list of 4 to 8 images for an article
- For each image: theme, central idea, structure type, character's action, suggested annotations
  in the source text's language
- Final PNG, saved to `assets/<article-slug>-illustrations/`

By default, this skill does not produce:

- PPTX / PDF / Keynote
- SVG / HTML / editable Canvas
- Commercial poster or cover key visual
- Text-heavy infographic

## Visual style

- Pure white background — no paper texture, no beige, no shadow, no gradient
- Thin, hand-drawn, slightly shaky black line
- Lots of white space — the main subject takes up only about 40-60% of the image
- A few handwritten annotations in red, orange, blue
- One image = one single central action, structure, state, or metaphor
- The character must take part in the central action, never stay as mere decoration
- Strange, creative, uncluttered — never saccharine or childish

## Read as needed

Don't load everything at once — read according to the task:

- `references/style-dna.md`: style DNA, colors, text, forbidden elements
- `references/character.md`: appearance, personality, action repertoire, character taboos
- `references/composition-patterns.md`: structure types, original metaphor method, anti-copying rule
- `references/prompt-template.md`: prompt template for image-by-image generation
- `references/qa-checklist.md`: checks and iterations after generation
- `references/calling-agents.md`: list of agents/skills authorized for automatic mode (without prompt validation)
- `assets/examples/` : low-frequency visual calibration only — never copy the composition

## Image generation

This skill relies on the `hf-image` MCP (Z-Image-Turbo, see `AGENTS.md` section "Hugging Face —
image & video generation").

**Default mode (direct user invocation)**: never generate automatically — propose the prompt built
from `references/prompt-template.md`, then wait for explicit confirmation before calling the
generation tool.

**Exception — invocation from a documentation or reporting agent**: when this skill is called by an
orchestrator agent to illustrate its user documentation or consolidated report (see the list in
`references/calling-agents.md`), generation happens **without waiting for intermediate validation**
on each prompt — the calling agent already has implicit approval to produce its final deliverable.
The prompt is still built per `references/prompt-template.md`, and the shot list and delivery report
remain mandatory (see "Output format" section). This exception is strictly limited to this skill and
this use case; it does not change the general rule in `AGENTS.md` for other Hugging Face skills
(`imagine`, `animate`, `design-agent`, `ux-designer`, etc.), which still require systematic
validation.

## Workflow

### 1. Digest the text

Read the text, link, Notion page, Markdown file, or screenshot content provided. Extract:

- the central idea
- paragraphs that carry a cognitive shift
- passages that would benefit from being explained in an image
- passages that should stay text-only

Don't spread images evenly. Prioritize "cognitive anchor points": a key judgment, two breaking
points, an input/output loop, a sort, a before/after, multiple reuse of the same element, a
transmission path, a common trap, a character's state change.

### 2. Propose an illustration strategy first

If the user only asks to "analyze where to illustrate / think about spots that need an image,"
produce a shot list. For each image, specify:

- after which paragraph to place it
- the image's theme
- the central idea
- the structure type
- what the character does in the image
- suggested elements
- suggested annotation keywords

4 to 8 images by default. Short article: 1 to 3 images. Long article: don't exceed 9 images without
reason. Enough beats overloaded — don't turn the text into a picture book.

### 3. Image-by-image generation

If the user explicitly asks to "generate / produce / make the images," don't stop to re-confirm the
underlying strategy — but **propose each prompt and wait for validation** before the MCP call (see
"Image generation" above). Generate each image separately via `hf-image`. Never assemble multiple
images into a single composition.

Each image tells only one central structure. The prompt must always include (see
`references/prompt-template.md`):

- horizontal 16:9 companion illustration
- pure white background
- hand-drawn black line
- a few handwritten red/orange/blue annotations (in the source text's language)
- lots of white space
- the character as the subject of the central action
- forbidden: PPT look, commercial illustration, cute-childish, complex architecture, title in the
  top-left corner

Don't copy old compositions. Examples only calibrate style density and how the character takes
part — don't directly reuse a composition already seen (see `references/composition-patterns.md`),
unless the user explicitly asks to reproduce a specific image. Each time, reinvent a strange but
coherent metaphor from the current text.

### 4. Verification and iteration

After generation, check against `references/qa-checklist.md`. If there's an issue, regenerate or
edit locally, prioritizing:

- the character is merely decorative
- the image is too cluttered
- it looks too much like a flowchart / PPT
- too much text or typos in the annotations
- a title like "common trap / workflow / architecture" appears in the top-left corner
- the style is too cute, childish, rigid
- the background isn't a clean white

### 5. Saving and delivery

If the user is working in a project space, copy the final image to:

```text
assets/<article-slug>-illustrations/
```

Name in order:

```text
01-subject-name.png
02-subject-name.png
```

Keep the originally generated files — never overwrite an existing asset unless explicitly asked to
replace it.

## Output format

The strategy output (before generation) must be short and precise. The delivery after generation
must indicate:

- how many images were generated
- each one's purpose
- the save path
- which images are the strongest, which are optional

Don't produce a long theoretical explanation of the style — let the images speak.
