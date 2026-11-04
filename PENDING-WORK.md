# Pending work — skills batch 4 (`feature/port-skills-4`)

Out of 51 assigned skills, **5 ported** before this fork ran out of usable context budget for a
faithful, individually-reviewed translation:

- `friction-retro` (renamed from `retro`)
- `script-helper`
- `silent-failure-hunter`
- `software-deploy`
- `switch-audit`

## Remaining 46 skills, not yet ported

refacto, rpa-developer, scrum-master, sdd-converge, sdd-plan, sdd-specify, sdd-tasks,
security-architect, security-audit, semgrep, seo-geo, service-designer, sre, strix,
strudel-patterns, sysadmin, szikra-bisociation, szikra-boucle-retour, szikra-incubation,
szikra-lifecycle, szikra-securite-psy, szikra-slow-hunch, szikra-zettelkasten, task-tracker, taste,
**team-dev** (1362 lines — the root orchestrator skill, largest and most critical in the whole
repo), **team-selector** (333 lines), tech-lead, tech-translator, tech-writer, technical-artist,
threat-intelligence, threejs-3d, training-specialist, unlazy, user-call, ux-designer, ux-researcher,
ux-writer, version-checker, version-updater, visiteurs, vulnerability-management, web-search,
web-vanilla, windows-admin

## Why this batch stopped short

This batch's total source content is ~12,400 lines across 51 files, including several very large
ones (`team-dev` 1362 lines, `ux-designer` 587, `sre` 580, `refacto` 678, `sysadmin` 410,
`threejs-3d` 382, `team-selector` 333, `ux-writer` 326). A faithful translation — reading each file
in full, translating it completely rather than summarizing, applying the renaming convention, and
anonymizing — consumes far more context per file than the short skills ported here. This fork's
context budget was exhausted after 5 files; continuing would have meant either stopping mid-file
(risking a corrupted/partial commit) or producing rushed, unreviewed translations on the remaining
46 — explicitly against the instruction to never claim "done" with unverified work.

**Operational note for whoever runs the next pass**: this repository's working directory is shared
across multiple concurrently-running forks, each switching branches in the same checkout. This
caused a real incident during this batch — a `git reset --hard` issued while believing to be on
`feature/port-skills-4` actually ran against `feature/port-skills-1` (switched by another fork
moments earlier), destroying an uncommitted file (`switch-audit`) that had to be rewritten from
memory. **Always run `git branch --show-current` immediately before and after any `git add`/`commit`
or destructive command in this shared checkout** — don't trust that the branch you checked out
minutes ago is still checked out now.

## Recommendation for whoever picks this up

- Split the remaining 46 into smaller batches, prioritizing by size: the ~20 short skills (under 120
  lines: `szikra-*`, `task-tracker`, `tech-translator`, `unlazy`, `user-call`, `version-checker`,
  `version-updater`, `visiteurs`, `vulnerability-management`, `web-search`, `web-vanilla`,
  `windows-admin`, `sdd-*`) first, then the medium ones, then the large ones.
- **`team-dev` and `team-selector` deserve their own dedicated fork** — they are the root
  orchestration skills and almost certainly reference every old agent name
  (`vitruve-agent`, `cerbere-agent`, `boussole-agent`, etc.) throughout their delegation logic. Every
  one of those references must be updated to the new names (see `RENAME-MAP.md`). Treating them
  together with a stack of unrelated skills risks rushing exactly the file that needs the most care.
- None of the renaming decisions proposed in this fork's original directive for `visiteurs`,
  `user-call`, `szikra-*`, `retro`→`friction-retro`, `taste` have been verified against the other
  batches' `RENAME-MAP.md` entries — check for conflicts before finalizing.

## Git state

Branch `feature/port-skills-4`, commits:
- `a3db161` feat(skills): port batch 4 skills (friction-retro through software-deploy)
- `1b35e09` feat(skills): port switch-audit skill

Pushed to `origin/feature/port-skills-4` up to this file's own commit.
