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
