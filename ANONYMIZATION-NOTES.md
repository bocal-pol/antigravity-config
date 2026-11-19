# Anonymization notes

Record of content deliberately generalized or altered during porting, beyond the mechanical
email/path/secret checks — judgment calls worth a second look.

## Compostel skills (7 files: food, gear, lodging, planner, poi, prep, route)

**What was changed**: the source skills describe a specific, real Belgium-to-Spain pilgrimage route
with mandatory stage towns explicitly marked as "imposed by the user" in the source, named
lodging establishments with phone/contact references, and a detailed personal itinerary database
(specific town-by-town POIs, lodging, and food specialties).

This is the maintainer's personal route-planning project, not generic reusable content — publishing
the exact route, establishment names, and contact details would expose personal travel plans on a
public repository.

**What was kept**: the full methodology and workflow of each skill (parameter collection, stage
table structure, GPX generation approach, the three-tier lodging taxonomy, the kcal/resupply
logic, the gear-weighing discipline) — this part is generic and reusable regardless of which
pilgrimage route someone is actually planning.

**What was replaced**: the concrete Belgium-specific database (named towns, named gîtes/hostels
with contact info, named points of interest, the specific 2260 km three-country route) was replaced
with a short "worked example — illustrative leg" section using generic placeholder town names
(Town A, Town B...) to show the expected output shape without exposing the real route. Agent
delegation references were also generalized from named personas (`policier-agent`, `bard-agent`,
`survivaliste-agent`) to functional descriptions ("a local legal/compliance skill", "a game-master-
style skill", "the survival-logistics skill"), consistent with how `pilgrimage-route-agent` was
already handled in the agents-porting pass on this same branch lineage.

## General pattern applied across this batch

- Belgian-public-sector-specific regulatory/procurement content (`bon-commande`, `budget-plan`,
  `cahier-charges`) was generalized to jurisdiction-neutral procurement/budgeting language, with an
  explicit note to substitute the reader's own jurisdiction's thresholds — consistent with the
  precedent already set for `accessibility-lead`'s RGAA reference.
- `compliance-officer`'s reference to "FR/BE legal obligations" for health-data retention was
  generalized to "jurisdiction-specific legal obligations" since GDPR itself is EU-wide, not
  Belgium-specific, but that one retention-period detail was locally sourced.
- `bug-validator`'s example tracker table used a real first name as a placeholder value in two rows
  — replaced with a generic `[name]` placeholder.
- `brag`'s 17MB of bundled binary music/SFX assets were NOT ported (out of scope for a text-porting
  pass, and too large) — only its SKILL.md, slim.md, and references/*.md were copied (verbatim,
  already in English, no personal content found).

## Codex delegation skills (5 skills: codex-bridge, codex-delegate, codex-review, codex-explore, transfer)

- The source text says the Windows sandbox of Codex is blocked "on this workstation". That phrase
  refers to one machine. It became "observed" (a plain statement without a machine reference). The
  claim itself stays: it explains why Codex runs inside WSL. Worth a second look: it is a field
  observation by the maintainer, not a documented fact about Codex.
- The source mentions a past review where a "P1" finding was downgraded. It is kept as a generic
  example, without the project name.
- The source skills name the original assistant in several places ("Claude", `~/.claude/...`,
  `AskUserQuestion`). These became "the assistant" and mirror paths. The `model:` frontmatter line is
  kept, as for every other skill in this mirror.
- No email, no personal path, no machine identifier was found in the five skills or in the script.
  Paths are generic (`~/.agents/...`, `.agents/...`). The `/mnt/c/...` strings are placeholders.

### Animated icons rule (frontend-agent, root rules)
The source rule names the private monorepo's shared icon module by its package scope and mentions its design
system package by name. The mirror says "shared icon module" and "design system" instead, and shows the import
path as a placeholder.
