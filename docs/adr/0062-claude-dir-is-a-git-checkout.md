# ADR 0062 — `~/.claude` is a git checkout of the repo, not a copy

- **Status**: accepted
- **Date**: 2026-09-17
- **Supersedes**: ADR 0048 §2 (manual dual-write)

## Context

ADR 0048 required writing every change "in both places": the source repo and `~/.claude`. Three incidents in three weeks showed this discipline doesn't hold:

- 23 pre-rename agent copies resurrected by a blind sync (a maintenance audit).
- A later audit batch marked "✅ fixed" while several core files had never actually reached the machine. The environment that was actually running still contained old flags and an old agent name from before a rename.
- Project memory already documented this failure mode, with no effect.

The problem is structural: a procedural fix ("remember to copy") doesn't survive fatigue or parallel sessions.

## Decision

1. **`~/.claude` is a git repo**: `git init` in place, `remote origin` set to the source repo,
   checked out to `develop` (or a `feature/*` branch for testing). No folder is moved:
   `.credentials.json`, `projects/`, `memory/`, `sessions/`, `skills/synced/`, local settings
   stay exactly where they are, covered by `.gitignore`.
2. **A single change flow**: `feature/*` branch → PR to `develop` → `git pull` inside
   `~/.claude`. A second clone (for a separate workspace) is just that — a working copy.
3. **Divergence is detected, not assumed**: a mirror-check script, run by the repo's `SessionStart`
   hook, compares `~/.claude`'s commit to the current worktree's and flags any modified or
   untracked file in `~/.claude`.
4. **What isn't versioned doesn't go in `~/.claude`**: per-project knowledge
   (`frontend-knowledge.md` and the like) is written in `<project>/.claude/`, never in the
   global configuration.

## Positive consequences

- A committed and pulled fix is **by construction** the one that's actually running
- `git status` inside `~/.claude` replaces manual hash comparison
- The machine's local history becomes visible (`git log`, `git diff`)

## Negative consequences / risks

- The runtime constantly writes into `~/.claude`: any new generated folder or file must be
  added to `.gitignore`, or `git status` becomes noisy (the hook flags it)
- Checking out a `feature/*` branch inside `~/.claude` changes the behavior of sessions
  currently under test — intentional, but worth remembering before opening a "serious" session
- The HTTPS remote requires a working credential helper (Git Credential Manager, already present)

## Alternatives considered

- **A symlink/junction from `~/.claude` to the repo** (rejected in ADR 0048): moving the live folder
  while a session is running locks files; `git init` in place avoids any move.
- **Periodic copy from the repo to the machine**: overwrites local additions with no warning. Rejected.
- **Keeping the dual-write**: three incidents in three weeks. Rejected.

## Scope

The `~/.claude` environment and the source repo. Any session that modifies a skill, an
agent, a hook, or `settings.json`.
