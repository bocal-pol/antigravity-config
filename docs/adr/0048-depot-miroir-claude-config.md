# ADR 0048 — The source repo as a versioned mirror of `~/.claude`

- **Status**: **partially superseded by [ADR 0062](0062-claude-dir-checkout-git.md)** — section 1 (the
  `.gitignore` contract) still holds; section 2 (manual dual-write) is abandoned: `~/.claude` is now
  itself a git checkout.
- **Date**: 2026-09-17

## Context

The Claude Code environment lives in `~/.claude`: skills, agents, hooks, `settings.json`, `AGENTS.md`. This folder is also a runtime working directory, which constantly writes sessions, transcripts, telemetry, shell snapshots, caches, and credentials into it. Versioning the folder as-is would publish personal data and secrets; not versioning it at all meant losing the ecosystem on every machine change.

A call had to be made: what does the repo contain, and how do the two locations stay in sync?

## Decision

### 1. The repo is a selective mirror of `~/.claude`

Deployed via `git clone` into `~/.claude`. The `.gitignore` is the contract defining what gets versioned:

- **Versioned** — `skills/`, `agents/`, `docs/adr/`, `AGENTS.md`, `primer.md`, `hindsight.md`, `settings.json`, `.mcp.json`, `install.ps1`
- **Excluded** — `.credentials.json`, `history.jsonl`, `sessions/`, `telemetry/`, `session-env/`, `shell-snapshots/`, `bash-audit.log`, `backups/`, `file-history/`, `ide/`, `memory/`, `plans/`, `plugins/`, `projects/`, `node_modules/`

The sorting rule: anything **transferable from one machine to another** is versioned; anything runtime, personal, or machine-specific isn't.

### 2. Mandatory dual write

Any creation or edit of a skill, an agent, `SKILLS_INDEX.md`, an ADR, or `team-dev/SKILL.md` is written **in both places**: `~/.claude/...` (what the runtime reads) and the git repo (what survives).

**Never blindly copy a folder onto the other** — the two locations have already drifted apart before. Safe procedure:

- apply the **same Edit operations** to both files;
- reserve `Copy-Item -Recurse` for **entirely new** folders;
- check for drift before acting (`Compare-Object`).

⚠️ Don't read/write these files via PowerShell 5.1, which interprets UTF-8 as ANSI and produces mojibake. Use Read/Edit/Write; `Copy-Item` stays safe (binary copy).

### 3. Bootstrapping a new machine via an install script

An idempotent, re-runnable script: system prerequisites, deploying the repo to `~/.claude`, mandatory then optional MCPs, tooling, a final check. Without a force-clone flag, it never overwrites an existing `~/.claude` — it backs it up to a timestamped folder instead.

## Positive consequences

- The full ecosystem redeploys to a fresh machine in a single command
- No secrets or session data in the git history
- The bootstrap procedure is executable, not just documented

## Negative consequences / risks

- **Dual-write is manual and fallible**: a change written on only one side is either invisible at runtime or lost on the next commit. This is this architecture's main risk.
- The `.gitignore` must be maintained: a new, unlisted runtime folder gets versioned by accident
- Drift between the two locations isn't detected on its own

## Alternatives considered

- **A symlink from `~/.claude` to the repo**: would remove the dual-write, but the runtime writes its session data into the folder, which would stay permanently dirty from git's point of view. Rejected.
- **Versioning all of `~/.claude`**: would publish credentials, transcripts, and telemetry. Rejected.
- **Periodic copy from repo to runtime**: would overwrite legitimate divergence with no warning. Rejected.

## Scope

The source repo and the `~/.claude` environment. Concerns any session that modifies a skill, an agent, or the ecosystem's documentation.
