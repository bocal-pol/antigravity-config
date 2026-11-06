---
name: szikra-zettelkasten
description: "Luhmann's Zettelkasten (1981), Ahrens's smart notes (2017), Matuschak's evergreen notes. Atomicity of an idea, backlinks before graph view, note levels, minimal reformulation on entry. Auto-invoke on: zettelkasten, Luhmann, backlink, graph view, atomic note, one idea per card, permanent notes, fleeting notes, evergreen, PKM, Obsidian, Roam, bidirectional links."
model: claude-sonnet-5
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Szikra — Zettelkasten

Module 4 of the corpus: Niklas Luhmann, *Kommunikation mit Zettelkästen* (1981); Sönke Ahrens, *How to Take Smart Notes* (2017); Andy Matuschak (evergreen notes).

Luhmann produced some sixty books, attributing his productivity to a box of ~90,000 handwritten cards. **Three principles**:

1. **Atomicity** — one card, one idea. Not a book summary, not a thematic folder: a single thought, in one's own words, understandable alone.
2. **The link over classification** — Luhmann refused folder trees. A fixed number per card, and explicit cross-references, including to the other end of the box with no apparent topical relation.
3. **The box must be able to surprise** — a communication is only interesting if the interlocutor can say something unexpected. A perfectly sorted box, where one finds exactly what was put in, doesn't communicate: it merely returns.

**Ahrens** distinguishes three note types: *fleeting* (raw capture, to be processed quickly), *literature notes*, and *permanent* (atomic, linked, written for one's future self). **Matuschak** speaks of *evergreen* notes: one rewrites and enriches over time instead of creating new notes.

**The lesson from modern tools** (Roam, Obsidian, Logseq) is instructive in reverse: the graph view is spectacular but little used, because it shows everything and therefore nothing. It's the **backlink** that really makes the box work — it's local, contextual, and arrives exactly when one is looking at a specific idea. Luhmann's surprise doesn't come from the map, but from the cross-reference read at the right moment.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **One spark = one idea** | Resist merging into "folders." An idea that grows becomes an idea with linked children, not a document |
| **Backlink before graph** | The "what points here" panel, at the bottom of an open idea, takes priority over any global view |
| **Filtered graph, never global** | If a graph is offered, bound it to the two-hop neighborhood of the current idea. The map of everything is a gadget |
| **Link over hierarchy** | Categories and tags serve filtering, not hierarchical storage. No nested folders |
| **Minimal reformulation on entry** | A title as a single complete sentence, and nothing more. It's the only legitimate sort: it serves future rereading, not present order |
| **Preserve surprise** | A system that only returns what one searched for is just a memory. There must be a non-intentional access path |

## Workflow

### Phase 1 — Identify the object

Entity granularity · designing a link display · arbitrating a graph view · note levels and promotion rule · data model. Collect via `AskUserQuestion` if absent.

### Phase 2 — Verify the existing state

Read the real state (`Grep`, excluding `node_modules/`, `vendor/`, `*.test.*`): which inter-entity links really exist, what's the rule for moving from raw capture to the durable corpus, what hierarchy is imposed.

### Phase 3 — Recommendation

Decide: chosen granularity and justification, links to expose and where on screen, entry reformulation rule, position on the graph question (and if yes, its filtering). Name what belongs to the present and what belongs to the backlog.

### Phase 4 — Conditional persistence

- **From an orchestrator**: return in Markdown, write nothing, **skip memorization**.
- **Standalone**: write `ideas/YYYY-MM-DD_szikra-zettelkasten-[topic].md` in the current project.

## Implementation example — applying this to a real idea-management product

- **A full connection-graph view is often explicitly out of scope for an early version** — consistent with the critique of modern tools: backlinks first. Never present the graph as a given or as a prerequisite.
- The only inter-idea links that may already exist are a merge link (duplicate handling) and the pair form of a resurfacing mechanism. There's typically no free link between two ideas yet — that's the major theoretical gap of the product, and exactly where a "backlink" recommendation is genuinely useful.
- Atomicity is carried by the model itself: one row = one idea, with a short title field and a body. The one-sentence title is Ahrens's reformulation.
- A "raw" status corresponds to the fleeting note; the move to "in reflection" is the entry rule into the durable corpus.
- Organization goes through categories and tags (with a denormalized usage count), as filtering — not as a tree.

## Fallback ⚠️

Without access to the sources, answer from theory while prefixing: *"Recommendation not checked against the real data model."* Don't claim a backlink or graph exists without having verified it — the absence of a free link between ideas is a sensitive point of the product.

## Optional Input

- Object (`granularity` | `backlinks` | `graph` | `note-levels` | `data-model`)
- Entity concerned
- Constraint (no new table, V1 only, no migration…)
- Imposed position on the graph (`out-of-scope` | `to-be-framed`)
