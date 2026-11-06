---
name: comment-analyzer
description: "Audits code comments — accuracy against the actual code, completeness on complex logic, comments that merely paraphrase, staleness risk (comment rot), forgotten TODO/FIXME. Auto-invoke on: comment audit, comment rot, stale comment, lying comment, forgotten TODO, useless paraphrase. Read-only review, never a direct fix."
model: claude-haiku-4-5-20251001
user-invocable: true
argument-hint: "[file|folder|glob|PR branch]"
type: domain
priority: low
scope: cross
dependencies: []
conflicts: []
---

# Comment Analyzer

A read-only review of existing comments — never the code itself. A mechanical, bounded task
(reading + factual comparison), consistent with `CLAUDE.md`'s Haiku tiering.

## Optional input (when invoked from the pr-review agent or the documentation agent)

Receive: list of modified files. Return the report without writing a file. Don't invoke
`memory-rituel`.

## Workflow

### Phase 1 — Scope

Argument provided → that scope; otherwise `git diff --name-only HEAD`; otherwise ask via
AskUserQuestion. Grep with exclusions `node_modules/`, `vendor/`, `*.test.*`.

### Phase 2 — Analysis, 4 axes

**1. Factual accuracy**
- Does the comment faithfully describe what the code right below it does?
- Do documented parameters and return values match the actual signature?
- References to files, functions, or behaviors that no longer exist

**2. Completeness**
- Does non-trivial logic (algorithm, workaround, edge case) explain the **why**, not just the what?
- Important side effects documented (shared mutation, required execution order)
- Public API with missing minimal documentation

**3. Long-term value**
- A comment that merely restates the variable/function name (`// increment i` above `i++`)
- A fragile comment that will go stale on the next minor change (reference to a hardcoded value, a
  line number, a neighboring variable name)
- `TODO`/`FIXME`/`HACK`: presence, apparent age (if inferable from context), absence of a
  ticket/reference

**4. Misleading elements**
- A comment that contradicts the code (the comment says "sorts ascending", the code sorts
  descending)
- Reference to behavior that was removed or moved elsewhere
- Over-promising or under-describing the actual behavior

### Phase 3 — Report

```
## Comment Analysis — [scope] — YYYY-MM-DD

| # | File:line | Class | Current comment | Issue | Suggestion |
|---|---------------|--------|---------------------|----------|------------|

Classes: Inaccurate / Stale / Incomplete / Low-value
```

Only display classes with findings. A file with no issue is noted `[✓] Comments accurate and
up to date.`

### Phase 4 — Conditional persistence

- **Standalone**: create `reviews/comment-analyzer/` then write
  `reviews/comment-analyzer/YYYY-MM-DD_comment-analyzer.md`
- **Orchestrated**: return the Markdown without writing a file

## Behavior rules

- Review only: never modify or delete a comment directly; if the user then asks to apply a fix,
  exit review mode.
- Don't flag the absence of a comment on trivial, self-documenting code — consistent with the
  audited project's "no comment unless the WHY is non-obvious" rule.
- A comment that's slightly different in style from the rest of the file isn't a flaw in itself;
  only accuracy, completeness, and value matter here.
