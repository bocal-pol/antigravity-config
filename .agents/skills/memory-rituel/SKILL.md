---
name: memory-rituel
description: Consolidation ritual for the current project's Claude memory system. Triggers on /memory-rituel, or if the user says "consolidate my memory", "memory is disorganized", "clean up the memories". Merges duplicates, archives stale entries, promotes repeated patterns into rules, and reorganizes MEMORY.md with a table of contents by type.
model: claude-sonnet-5
user-invocable: true
type: utility
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Memory Ritual

Consolidate and reorganize the Claude memory system of the current project in 4 sequential phases.

## Optional input (if invoked from `security-audit`)

If context is provided (CVEs/vulnerabilities from `appsec` and `pentest`):
- Integrate these entries into `.claude/security-knowledge.md` before Phase 1
- Treat this file like any other memory file in the following phases

## Workflow

**Initialization:** The memory folder is `.claude/memory/` at the root of the current project (working directory). Glob all `*.md` files in that folder. Also include `.claude/security-knowledge.md` if it exists. Read MEMORY.md and each memory file. If the folder doesn't exist, create it by writing the first file into it.

**Multi-folder fragmentation (checkouts/worktrees of the same repo):** the harness derives the memory folder from the absolute path of the cwd, not the git root — two checkouts, or a parent/subfolder of the same logical repo (e.g. `~/.claude` and a secondary clone path), produce two disjoint memories. In Phase 0, list `ls ~/.claude/projects/` (or the current profile's equivalent) and flag any folder whose name suggests the same repo as the current project. Propose cross-reading its MEMORY.md to spot a duplicate to merge manually — no automatic cross-folder merging, the risk of blending two genuinely distinct contexts is too high to automate.

### Phase 1 — Merging duplicates

Identify files that cover the same subject (same person, same rule, same project fact). For each similar group:
- Write a single merged file with the union of the information, frontmatter updated
- For the absorbed files: copy their content to `.claude/memory/archive/_merged_<original-name>.md` via Write, then overwrite the original with a line `[Merged into <destination-file>.md]`. Remove their entry from MEMORY.md.

### Phase 2 — Archiving

Mark as obsolete: completed milestones, past deadlines, resolved incidents, stale references. For each obsolete file:
- Write to `.claude/memory/archive/<file-name>`
- Remove its entry from MEMORY.md — the original stays on disk but is no longer indexed

When in doubt, keep rather than archive.

### Phase 3 — Promotion into rules

Grep across all active memory files to detect patterns repeated in 2+ files:
- `feedback_*` files → promote into behavioral rules
- `security-knowledge.md` → promote recurring vulnerabilities into development rules in a `rules_security.md` file
- `bug_rule_*.md` files → handle as follows:
  - Merge rules covering the same error type (same root cause) into a single `bug_rule_merged_<topic>.md` file
  - If the same bug pattern appears in 3+ distinct rules → promote into a behavioral rule `feedback_bug_<topic>.md` and archive the source rules
  - Keep all non-redundant rules as active memories (type `feedback`) — they don't auto-archive, except via explicit merging

### Phase 4 — Reorganizing MEMORY.md

Rewrite MEMORY.md with:
- A table of contents grouped by type: `user`, `feedback`, `project`, `reference`
- One line per active memory: `- [Title](file.md) — one-line hook`
- A compact `## Archives` section listing archived files
- Total under 200 lines

### Phase 5 — Synthesis into `hindsight.md`

Read `~/.claude/hindsight.md`.

Among the `feedback_*` files active after Phase 3, identify those whose content contains a **recurring pattern** (mentioned in 2+ distinct feedback entries, or whose rule was promoted from duplicates in Phase 3). For each pattern identified:

1. Check that an equivalent entry doesn't already exist in `hindsight.md` (compare title and context in substance, not word for word).
2. If absent: add an entry in the format:
   ```
   ### YYYY-MM-DD — <Short lesson title>
   - **Context**: <concrete situation drawn from the feedback>
   - **Lesson**: <actionable rule to remember>
   ```
3. Insert the new entry at the end of the `## Entries` section, respecting chronological order.

Don't duplicate: if the substance is already covered in `hindsight.md`, skip it. Don't synthesize one-off or very project-specific feedback — only cross-cutting, reusable-across-sessions lessons.

**Final report:** One line per phase stating what was merged, archived, promoted, synthesized into hindsight.md, and the final count of active memories.
