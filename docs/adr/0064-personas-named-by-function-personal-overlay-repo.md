# ADR 0064 — Personas named by function, and an overlaid repo for personal profile data

- **Status**: accepted
- **Date**: 2026-09-17
- **Complements**: ADR 0049 (`personal-agents.json` registry), ADR 0062 (`~/.claude` as a git checkout), ADR 0063 (MIT license)

## Context

Opening the source repo to colleagues (ADR 0063) forced a call on what could stay versioned in the shared repo. A sharing audit had flagged as "personal" seven persona agents, their seventeen satellite skills, the `personal-agents.json` registry, and a `family-context` skill.

A first pass moved everything to a separate repo. On review, **that was too broad**: an agent that can calculate a Bug Out Bag or compare tire strategies is domain expertise, not personal data. What actually caused the problem wasn't the subject, it was **the name**: several personas carried the first or last name of a real person close to the author.

The real criterion, then, isn't "private vs. professional" but: **does this file identify someone, or does it describe a skill?**

## Decision

### 1. A persona is named after its function

Any agent named after a real person is renamed for what it does. Five were renamed on 2026-09-17: the legal-compliance, survival, HR, backend, and frontend agents carried the name or first name of someone close to the author. They became `legal-compliance-agent`, `survival-logistics-agent`, `hr-agent`, `backend-agent`, and `frontend-agent` — and the communications agent became `public-communications-agent`.

The old names aren't repeated here: that's exactly what the rule forbids. Git history keeps the trace for whoever needs to dig it up.

The rename covers the filename, the `name` field, the description, titles, and **every occurrence of the name in the body** — not just the header. A pre-rename alias also carried a surname: it was deleted rather than repointed.

Personas named after a nickname, a public figure, or an archetype (the racing-engineer, bard, algorave, pilgrimage-route, and creativity-theory personas) stay unchanged: they identify no one close to the author.

### 2. The agents and their skills stay in the shared repo

Seven persona agents, their aliases, their fifteen satellite skills (the pilgrimage-* and creativity-theory-* families, `strudel-patterns`), `i-have-adhd`, and `personal-agents.json` are reusable content. They stay versioned here, with two guardrails:

- `team-selector` excludes persona agents from a development cycle by default.
- `personal-agents.json` stays the routing registry; a colleague replaces it with their own via `/po-creator`.

### 3. Exactly one file leaves: `family-context`

It's the only content that describes no skill at all — family profile, children, named musical tastes, location. It lives in a separate private repo.

It moves from `scope: cross` / `priority: high` to **`scope: personal` / `priority: low`**, and its `description` explicitly forbids auto-invocation. Under its old scope, it was eligible to load in **any** session, including a professional one.

Agents that read it do so as an **optional dependency**: its absence produces no warning.

### 4. Mounting: an overlaid bare repo, not a subfolder

Claude Code only reads skills at the path `~/.claude/skills/<name>/SKILL.md`. A file placed in `~/.claude/personal/skills/` would never load, and two git repos can't have their `.git` directory in the same place.

Hence the **dotfiles pattern**: a **bare** repo at a separate path, whose working tree is `~/.claude`.

```bash
git clone --bare <personal-repo-url> ~/.claude-personal.git
git --git-dir=$HOME/.claude-personal.git --work-tree=$HOME/.claude config status.showUntrackedFiles no
git --git-dir=$HOME/.claude-personal.git --work-tree=$HOME/.claude checkout
```

The two repos share the same directory tree: the shared repo lists the personal path in its `.gitignore`, the personal repo disables `showUntrackedFiles`. Files stay physically in place — **no copy, no symlink, so no dual-write to maintain**, which is exactly the failure mode ADR 0062 removed.

### 5. `scope: personal`

A new value for the `scope` field, reserved for content from the personal repo. No skill in the shared repo should carry it. The frontmatter validator accepts it, and only judges files **tracked by git** — otherwise it would flag personal skills present on disk but belonging to the other repo.

## Positive consequences

- No real person's name in the shared repo.
- Domain expertise stays shareable instead of being exiled along with the private data.
- `family-context` can no longer load in a professional session.
- A single file to manage in the second repo: the double-checkout friction stays marginal.

## Negative consequences / risks

- **Two repos on every machine**, with two distinct commands. A shell alias reduces the friction without removing it — for a single file, the cost/benefit ratio is debatable and will need re-evaluating if the personal repo doesn't grow.
- The renamed personas **change invocation mode**. The old modes aren't kept as aliases: they carried exactly the names the rule forbids. A prompt or script that used the old mode no longer works, and that's accepted.
- **Already-published history isn't cleaned up by this decision.** The old names and `family-context` remain present in earlier commits on both remotes. Addressing that is a separate history-rewrite operation.

## Alternatives considered

- **Moving everything to the personal repo**: the first attempt, reverted. Exiled reusable expertise and emptied `team-dev` of half its modes over a naming issue alone. Rejected.
- **Keeping everything with no renaming**: would leave real people's first names in a repo meant to be shared. Rejected.
- **`git rm --cached` + `.gitignore` alone** for `family-context`: the simplest option, but the file would lose its history and backup. Rejected.
- **Windows junctions / symlinks**: work for a skill folder, not for a standalone agent file, which would require a symlink and therefore developer mode. Rejected.
- **A deployment script** copying the personal repo into `~/.claude`: reintroduces the dual-write that ADR 0062 documents three incidents about. Rejected.

## Scope

`~/.claude` as a whole. See also ADR 0049, 0062, and 0063.
