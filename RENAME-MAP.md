# Rename Map

Mapping from the source configuration's original names (some French, some code names/personas) to
this repository's clear English names.

Populated incrementally as each porting pass completes. See `PORTING-NOTES.md` for overall port
status.

## Agents

39 real agents ported, 20 pure aliases eliminated (an alias had no instructions of its own — it
only delegated to the real agent; merging it loses nothing).

| Original name | New name | Notes |
| --- | --- | --- |
| algorave-agent (alias) | algorave-agent | Alias eliminated, zack-delarocha-agent's content became the canonical file under this name |
| arcade-agent | game-dev-agent | — |
| architecture-agent (alias) | architecture-agent | Alias eliminated, vitruve-agent's content became the canonical file under this name |
| argus-agent | qa-lead-agent | — |
| atlas-agent | infrastructure-agent | — |
| avocat-du-diable-agent | devils-advocate-agent | — |
| backend-agent | backend-agent | Already clear, kept as-is |
| bard-agent | game-master-agent | Persona merges tabletop RPG + camp cooking |
| bard-chef-agent (alias) | — | Pure alias of bard-agent, eliminated |
| bolt-agent | sprint-agent | — |
| boussole-agent | product-agent | — |
| canaveral-agent | release-agent | — |
| cerbere-agent | security-agent | — |
| commercial-agent | sales-offers-agent | — |
| communication-agent | public-communications-agent | — |
| compostel-agent | pilgrimage-route-agent | References the Camino de Santiago |
| consultant-agent | paid-consultant-agent | — |
| coordination-agent (alias) | coordination-agent | Alias eliminated, maestro-agent's content became the canonical file under this name |
| data-agent (alias) | data-agent | Alias eliminated, pythie-agent's content became the canonical file under this name |
| design-agent (alias) | design-agent | Alias eliminated, iris-agent's content became the canonical file under this name |
| directeur-creatif-agent | creative-director-agent | — |
| documentation-agent (alias) | documentation-agent | Alias eliminated, gutenberg-agent's content became the canonical file under this name |
| formateur-agent | trainer-agent | — |
| frontend-agent | frontend-agent | Already clear, kept as-is |
| gamedev-agent (alias) | — | Pure alias of arcade-agent, eliminated |
| gutenberg-agent | documentation-agent | — |
| hermes-agent | integration-agent | — |
| ict-agent | ict-agent | Already clear, kept as-is |
| infra-agent (alias) | — | Pure alias of atlas-agent, eliminated |
| integration-agent (alias) | integration-agent | Alias eliminated, hermes-agent's content became the canonical file under this name |
| iris-agent | design-agent | — |
| itops-agent (alias) | — | Pure alias of sentinelle-agent, eliminated |
| maestro-agent | coordination-agent | — |
| marches-agent | public-procurement-agent | — |
| mentor-agent | mentor-agent | Already clear, kept as-is |
| mobile-agent (alias) | mobile-agent | Alias eliminated, nomade-agent's content became the canonical file under this name |
| nomade-agent | mobile-agent | — |
| pdg-agent | ceo-decision-agent | — |
| policier-agent | legal-compliance-agent | — |
| pr-review-agent (alias) | pr-review-agent | Alias eliminated, themis-agent's content became the canonical file under this name |
| product-agent (alias) | product-agent | Alias eliminated, boussole-agent's content became the canonical file under this name |
| pythie-agent | data-agent | — |
| qa-agent (alias) | — | Pure alias of argus-agent, eliminated |
| quartermaster-agent (alias) | — | Pure alias of survivaliste-agent, eliminated |
| race-engineer-agent (alias) | — | Pure alias of schumi-agent, eliminated |
| release-agent (alias) | release-agent | Alias eliminated, canaveral-agent's content became the canonical file under this name |
| rh-agent | hr-agent | — |
| schumi-agent | race-engineering-agent | — |
| security-agent (alias) | security-agent | Alias eliminated, cerbere-agent's content became the canonical file under this name |
| sensei-agent | productivity-coach-agent | — |
| sentinelle-agent | it-operations-agent | — |
| socle-agent | project-bootstrap-agent | — |
| socratique-agent | socratic-method-agent | — |
| sprint-agent (alias) | sprint-agent | Alias eliminated, bolt-agent's content became the canonical file under this name |
| survivaliste-agent | survival-logistics-agent | — |
| szikra-agent | creativity-theory-agent | "Szikra" = "spark" in Hungarian |
| themis-agent | pr-review-agent | — |
| vitruve-agent | architecture-agent | — |
| zack-delarocha-agent | algorave-agent | — |

Not ported: `team-dev` and `team-selector` are skills (`skills/team-dev/`, `skills/team-selector/`),
not agent files — they're handled by the skills porting pass, not this one.
`family-context` (scope: personal) is excluded entirely, per the shared anonymization rule.

## Skills

All 196 skills ported. Nearly all kept their original name (already in kebab-case, already
descriptive); only 3 were renamed for clarity or naming consistency with other ported skills.

| Original name | New name | Notes |
| --- | --- | --- |
| croquis-editorial | editorial-sketch | English name, kept its 6 `references/` files |
| investigue | investigate | English name |
| no | encode-correction | The short name "no" (as in "no, do it like this") doesn't translate; renamed to describe what it does — encoding a behavior correction |
