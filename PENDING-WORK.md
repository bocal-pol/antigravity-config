# Pending work — skills batch A (`feature/port-skills-wt1`)

**Status: COMPLETE.** All 41 assigned skills ported, translated, and pushed.

ai-agent-security, ai-product-engineer, analyst, analytics-engineer, angular-developer, animate,
api-finder (+ `references/public-apis.md`), app-spec, appsec, ar-vr-developer, architect,
backend-updater, bi-developer, blockchain, bon-commande, brag (+ slim.md + references/*.md, binary
assets NOT ported — see below), brand-brief, budget-plan, bug-validator, bulletin-analyser,
bulletin-service, cadrage, cahier-charges, changelog, ci-scan, claude-code-audit, cloud-architect,
cloud-engineer, cloud-security, code-reviewer, comment-analyzer, compliance-officer,
compostel-food, compostel-gear, compostel-lodging, compostel-planner, compostel-poi,
compostel-prep, compostel-route, computer-vision, data-engineer.

## Known gaps

- **`brag`'s binary assets** (17MB of bundled music/SFX under `assets/`) were deliberately NOT
  ported — out of scope for a text-porting pass and too large. Only the skill's Markdown files
  (SKILL.md, slim.md, references/*.md) were copied. If this skill needs to be fully functional on
  `antigravity-config`, someone will need to separately port `skills/brag/assets/` from the source
  repo (`c:\Projet\CLaude\claude-config\skills\brag\assets\`).
- **Compostel skills were generalized**, not ported verbatim — see `ANONYMIZATION-NOTES.md` for
  full detail. The source content described a specific personal pilgrimage route; the ported
  version keeps the methodology but replaces the real route/location database with a generic
  illustrative placeholder.

## Agent-name renames — NOT yet confirmed against the authoritative map

Agent renames applied where referenced in ported content were resolved from first principles
(`RENAME-MAP.md` was empty and no agent files existed yet on this branch lineage when this batch
started — agents land on a separate `feature/port-agents` branch). Mapping applied throughout this
batch:

`cerbere-agent`→`security-agent`, `pythie-agent`→`data-agent`, `boussole-agent`→`product-agent`,
`socle-agent`→`project-bootstrap-agent` (referred to as "the bootstrap agent" in prose),
`vitruve-agent`→`architecture-agent`, `iris-agent`→`design-agent`,
`marches-agent`→`public-procurement-agent` (generalized away, not referenced by name in the final
text), `consultant-agent`→`paid-consultant-agent` (referred to as "the paid-consultant agent"),
`avocat-du-diable-agent`→`devils-advocate-agent` (referred to as "the devil's-advocate agent"),
`mentor-agent`→unchanged, `pdg-agent`→`ceo-decision-agent` (referred to as "the CEO-decision
agent"), `canaveral-agent`→`release-agent`, `atlas-agent`→`infrastructure-agent`,
`themis-agent`→`pr-review-agent`, `gutenberg-agent`→`documentation-agent`,
`bard-agent`→`game-master-agent` (generalized to "a game-master-style skill" in compostel-food),
`survivaliste-agent`→`survival-logistics-agent` (referred to as "the survival-logistics skill" in
compostel-gear), `policier-agent`→`legal-compliance-agent` (generalized to "a local legal/compliance
skill" in compostel-lodging), `frontend-agent`/`backend-agent` unchanged.

**Action required once `feature/port-agents` merges**: grep all 41 files in this batch for the OLD
agent names (`vitruve-agent`, `cerbere-agent`, `boussole-agent`, `socle-agent`, `iris-agent`,
`marches-agent`, `consultant-agent`, `avocat-du-diable-agent`, `pdg-agent`, `canaveral-agent`,
`atlas-agent`, `themis-agent`, `gutenberg-agent`, `bard-agent`, `survivaliste-agent`,
`policier-agent`) to confirm none remain, and verify the NEW names used here actually match what
the merged agents branch chose — no cross-check was possible while this batch ran, since the
agents branch wasn't available in this worktree.

## Infrastructure note

This batch ran in an isolated `git worktree` (`C:\Projet\CLaude\antigravity-config-wt1`, branch
`feature/port-skills-wt1`), set up specifically to avoid the shared-checkout collision that
corrupted earlier parallel porting attempts (lost commits, mixed branches, a destructive
`git reset --hard` in a prior pass). No collision occurred this time — the worktree isolation
worked as intended. This worktree can be removed (`git worktree remove`) once this branch is
merged.

## Git state

Branch `feature/port-skills-wt1`, all work committed and pushed to
`origin/feature/port-skills-wt1` across 8 commits (ai-agent-security through analytics-engineer;
angular-developer through app-spec; appsec through backend-updater; bi-developer; blockchain
through bulletin-service; cadrage through claude-code-audit; cloud-architect through
cloud-security; code-reviewer through compliance-officer; plus this final commit with the
Compostel skills, computer-vision, data-engineer, and these notes).
