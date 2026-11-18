---
name: repomix-mcp
description: "Pack a third-party repo or a large monorepo into one file (XML/MD/JSON, Tree-sitter compression) for fast review before analysis. Auto-invoke on mention of: repomix, pack a repo, bundle a repository, ingest a third-party repo, analyze a large monorepo, consolidated repo context."
model: claude-sonnet-5-5
user-invocable: true
type: utility
priority: low
scope: cross
dependencies: []
conflicts: []
---

# Repomix — Repo Packing for LLM Analysis

Condenses an entire repository (local or remote) into one file. Use it to study an external
architecture quickly (architecture agent) or to audit a monorepo too large for file-by-file
reading (security agent).

## When to use it

- Study a third-party repo's architecture before you extract a transposable pattern.
- Audit a monorepo whose size exceeds what a targeted file search can reasonably cover.
- Give a sub-agent a compact repo context instead of letting it read an unfamiliar repo file by
  file.

## When not to use it

- The current working repo — targeted file search tools stay more precise and cheaper in tokens
  for a repo you already explore.
- Any code change task — repomix is a read/consolidate tool, never a write tool.

## Method

### Via CLI (default)

```bash
# Local repo
npx repomix --style xml -o <output-path>/repo.xml <repo-path>

# Remote repo (clone + pack in one call)
npx repomix --remote https://github.com/<org>/<repo> --style xml -o <output-path>/repo.xml
```

- Default to `--style xml` (best structure for model re-reading); use `md`/`json` only when the
  next step requires it explicitly.
- Always write the output under a temporary working directory — never at the root of the current
  repo.
- For a large remote repo, add `--compress` (Tree-sitter compression: signatures only) when only
  the overall architecture matters, not function bodies.

### Via MCP server (if configured)

If a `repomix` MCP server is declared for the session, prefer its tools
(`pack_remote_repository`, `grep_repomix_output`) over the CLI call — this avoids a disk
round-trip for a one-off read.

### Reading the result

Read the packed file in chunks on a large repo rather than all at once; search the packed file
directly to target a section.

## ⚠️ Fallback — if `repomix` is not installed and no MCP server is available

State explicitly: `⚠️ repomix unavailable — falling back to file-by-file analysis, slower on a large repo.`
Return to standard exploration (fetch the README, then targeted file search on key files) rather
than blocking the task.

## Cleanup

The packed file is a temporary artifact: delete it at the end of the task if it was written inside
a versioned project's working tree.

## ⚠️ Unconfirmed in Antigravity

This skill assumes a `repomix` MCP server can be declared the same way other MCP servers are in
this port. No Antigravity-specific MCP registration mechanism was confirmed at port time — see
`PORTING-NOTES.md`. The CLI path (`npx repomix`) has no such dependency and works regardless.
