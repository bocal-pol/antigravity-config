# Pending work — skills batch A (`feature/port-skills-wt1`)

Out of 41 assigned skills, **12 ported** before this fork paused to conserve context budget for
accurate, individually-reviewed translation:

ai-agent-security, ai-product-engineer, analyst, analytics-engineer, angular-developer, animate,
api-finder (+ `references/public-apis.md`), app-spec, appsec, ar-vr-developer, architect,
backend-updater

## Remaining 29 skills, not yet ported

bi-developer, blockchain, bon-commande, brag, brand-brief, budget-plan, bug-validator,
bulletin-analyser, bulletin-service, cadrage, cahier-charges, changelog, ci-scan,
claude-code-audit, cloud-architect, cloud-engineer, cloud-security, code-reviewer,
comment-analyzer, compliance-officer, compostel-food, compostel-gear, compostel-lodging,
compostel-planner, compostel-poi, compostel-prep, compostel-route, computer-vision,
data-engineer

## Why this batch paused

Isolated worktree (`C:\Projet\CLaude\antigravity-config-wt1`, no shared-checkout collision this
time — the earlier 4-forks-one-directory incident does NOT apply here). Each file is read in full
and translated completely (not summarized) before writing, which is the correct but
context-expensive approach for a faithful port. 12 of 41 files done at a sustainable quality level;
continuing in the same conversation risked exhausting context before committing cleanly.

Agent name renames applied where referenced in ported content (resolved from first principles since
`RENAME-MAP.md` was empty and `.agents/*.md` not yet present on this branch lineage — agents land on
a separate `feature/port-agents` branch not yet merged here):
`cerbere-agent`→`security-agent`, `pythie-agent`→`data-agent`, `boussole-agent`→`product-agent`,
`socle-agent`→`project-bootstrap-agent`, `vitruve-agent`→`architecture-agent`,
`iris-agent`→`design-agent`, `marches-agent`→`public-procurement-agent`,
`consultant-agent`→`paid-consultant-agent`, `avocat-du-diable-agent`→`devils-advocate-agent`,
`pdg-agent`→`ceo-decision-agent`, `canaveral-agent`→`release-agent`,
`atlas-agent`→`infrastructure-agent`, `themis-agent`→`pr-review-agent`,
`gutenberg-agent`→`documentation-agent`, `bard-agent`→`game-master-agent`,
`survivaliste-agent`→`survival-logistics-agent`, `policier-agent`→`legal-compliance-agent`,
`frontend-agent`/`backend-agent`/`mentor-agent` unchanged.

**These renames are NOT yet confirmed against the actual agents branch** — once
`feature/port-agents` is merged, re-grep all ported skills for the OLD agent names to confirm no
mismatch with whatever the agents fork actually chose.

## Recommendation for whoever picks this up

- The remaining 29 include several multi-file skill families: `compostel-*` (6 skills, likely share
  a common theme — Camino de Santiago trip planning) — port as a logical group, they likely
  cross-reference each other.
- `bulletin-analyser`/`bulletin-service` are small utility skills — check for French-specific IT
  bulletin/patch terminology needing generalization.
- `cadrage` is referenced throughout `CLAUDE.md`/`claude-config` conventions as a core upstream
  discipline — port carefully, it's heavily cross-referenced.
- No known renaming conflicts among the 29 remaining — none matched an already-renamed skill name
  found in `.agents/skills/` during this batch's work.

## Git state

Branch `feature/port-skills-wt1`, commits:
- `2f92c4a` feat(skills): port ai-agent-security through analytics-engineer
- `aa3502f` feat(skills): port angular-developer through app-spec
- `93410d9` feat(skills): port appsec through backend-updater

Pushed to `origin/feature/port-skills-wt1` up to this file's own commit.
