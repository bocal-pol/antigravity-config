---
name: diagram-improve
description: "Analyzes a diagram design repo (GitHub or local) to identify patterns, palettes and conventions to adopt, then improves the existing skills/agents that produce diagrams (illustrate, architect, graphify, threejs-3d, ux-designer, architecture-agent, design-agent). Updates the relevant ADRs and audit reports. Invoke with: 'improve our diagram skills', 'analyze this diagram repo', 'diagram-improve <url>', or a GitHub URL of a design repo."
model: claude-sonnet-5
user-invocable: true
argument-hint: "[repo-url] [--apply] [--audit-doc <path>]"
type: utility
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Diagram Improve

Analyzes a diagram design repo and improves the skills/agents that produce diagrams in this ecosystem.

## Workflow

### Phase 1 — Context gathering

If args are provided (repo URL, `--apply`, `--audit-doc`): use directly.
Otherwise, AskUserQuestion (a single grouped question):
1. URL or path of the design repo to analyze
2. Mode: report only, or apply changes directly (`--apply`)
3. Scope of skills to improve (all diagram skills, or a specific list)
4. Path of the audit report to update (e.g. `docs/YYYY-MM-DD_audit-*.md`)

### Phase 2 — Design repo analysis (WebFetch)

Sequential fetch:
1. Main GitHub page: `https://github.com/<owner>/<repo>` — README, folder structure
2. Detected key files: README.md, DESIGN.md, examples/, diagrams/, `.drawio`, `.mermaid`, `.excalidraw`, `.d2`, SVG sprites

Build a summary sheet:
- **Supported diagram formats** (drawio, mermaid, excalidraw, d2, inline SVG…)
- **Color palette** (primary, semantic, background colors)
- **Typographic conventions** (font, size, roughness, style)
- **Recurring structural patterns** (C4, flow, matrix, stack, timeline…)
- **Documented style guides or anti-patterns**

### Phase 3 — Audit of existing skills

Glob `~/.claude/skills/*/SKILL.md`, then Grep each result for keywords:
`diagram|draw|mermaid|drawio|excalidraw|C4|svg|graphify|threejs|illustrate|graphml`

For each candidate skill, Read and compare against the Phase 2 sheet:
- Divergent palette → note the gap
- Missing format → note the gap
- Visual convention not followed → note the recommendation
- Incomplete frontmatter (missing type/priority/scope/model) → flag S1

Produce a summary table:
`Skill | Produced format | Palette gap | Convention gap | Recommended action`

### Phase 4 — Application (if `--apply` or confirmation after the report)

For each skill to improve:
1. Read the existing SKILL.md (Read)
2. Apply the changes (Write):
   - Palette: replace divergent colors with the reference repo's
   - Visual conventions: update roughness, fontFamily, recommended style
   - Formats: document newly supported formats
   - Missing frontmatter: fill in `model`, `type`, `priority`, `scope`, `dependencies`, `conflicts`
3. Mandatory dual write: `~/.claude/skills/<name>/SKILL.md` AND the mirror repo `claude-config/skills/<name>/SKILL.md`

Priority fixes (independent of the analyzed repo):
- **graphify S1**: add full frontmatter if missing (model: claude-sonnet-5, type: utility, priority: high, scope: cross, dependencies: [], conflicts: [project-graph])
- **graphify / project-graph S14**: add `conflicts: [project-graph]` in graphify and `conflicts: [graphify]` in project-graph

### Phase 5 — Docs and ADR update

1. Update the audit report (`--audit-doc` or the latest `docs/*_audit-*.md`):
   - Add a `## Diagram improvements — YYYY-MM-DD` section
   - List each modified skill + summary of fixed gaps
   - Check off S1 and S14 items if applied

2. Create an ADR if the conventions from the repo are structural and hard to reverse:
   - Threshold: at least 3 impacted skills + a non-obvious palette or format decision
   - Path: `docs/adr/NNNN-unified-diagram-conventions.md` (read the latest number via Glob)
   - Short format (1 to 3 sentences): decision + reason + consequences

3. Update `~/.claude/skills/SKILLS_INDEX.md`: add `diagram-improve` to the Utilities section

### Phase 6 — Final report (if standalone)

Produce `docs/diagram-improve/YYYY-MM-DD_diagram-improve.md`:
- Analyzed repo URL
- Extracted conventions sheet
- Audited skills table (before/after state)
- Created ADR (link if applicable)
- Uncovered gaps

If invoked from an orchestrator agent: return the summary table as inline Markdown, skip the file report and memorization.
</content>
