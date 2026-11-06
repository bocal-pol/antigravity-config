# Architecture Decision Records

Structuring decisions of this ecosystem and the cross-cutting conventions applied to every project.

- **73 ADRs** — 0001 to 0073, one superseded (0032) and one partially superseded (0048 §2 by 0062)
- A file duplicated under number 0025 (a leftover from renaming the canary word, ADR 0065) was
  removed on 2026-10-30 — its history stays documented in the amendment of
  [0025](0025-canari-detection-derive.md) itself, no information lost
- **Template**: [0000-template.md](0000-template.md) — includes the "when an ADR is warranted" rule
- An ADR is never deleted: an abandoned decision moves to `superseded by` or `deprecated` status

---

## Security, secrets, and compliance

| # | Title | Status | Scope |
| --- | --- | --- | --- |
| [0001](0001-session-revocation-auth-logout.md) | Mandatory session revocation after logout | accepted | Auth — front + back |
| [0002](0002-secrets-hors-env.md) | Secrets outside `.env`: a secrets manager is mandatory | accepted | All projects |
| [0034](0034-semgrep-sast-ci-scan.md) | Semgrep SAST + CI-Scan: security gates on PRs | accepted | CI |
| [0035](0035-compliance-rgpd-team-dev-full.md) | GDPR Compliance Officer integrated into `team-dev --full` | accepted | Orchestration |
| [0039](0039-consentement-cookies-granulaire.md) | Mandatory granular cookie consent | accepted | Public web |
| [0044](0044-dependances-lignee-maintenue-audit.md) | Dependencies: maintained lineage and an end-of-session audit | accepted | All projects |
| [0045](0045-verification-findings-sous-agents.md) | Direct re-verification of Critical/High findings | accepted | Audits |
| [0058](0058-permissions-settings-par-classes.md) | `settings.json` permissions by generic classes | accepted | Config |
| [0059](0059-laravel-garde-fous-securite.md) | Laravel: API Resources, auth by default, secret-free logs | accepted | Laravel backend |
| [0069](0069-legal-pages-multi-juridiction-ue.md) | `legal-pages`: multi-jurisdiction EU support | accepted | Legal pages |

## Frontend, UX, and design

| # | Title | Status | Scope |
| --- | --- | --- | --- |
| [0003](0003-ui-states-4-etats-obligatoires.md) | 4 mandatory UI states for any asynchronous render | accepted — canonical | Frontend |
| [0005](0005-messages-erreur-3-parties.md) | Mandatory 3-part error messages | accepted | UI + API |
| [0007](0007-icones-solar.md) | Solar icon library: single standard | accepted | All projects |
| [0010](0010-effet-ikea-appropriation-progressive.md) | Ikea effect: progressive ownership | accepted | B2C |
| [0011](0011-saveme-pattern-feedback-non-modal.md) | SaveMe: non-modal feedback for reversible actions | accepted | UI |
| [0012](0012-radio-impact-suppression-cascade.md) | Impact readout: transparency for cascading deletions | accepted | UI + back |
| [0013](0013-principe-flemmard-zero-saisie-inutile.md) | Lazy Principle: zero unnecessary input | accepted | Forms |
| [0032](0032-4-etats-ui-loading-error-empty-success.md) | 4 UI states: Loading / Error / Empty / Success | **superseded by 0003** | — |
| [0033](0033-seo-geo-bootstrap-phase-0.md) | SEO/GEO bootstrap: Phase 0 before any frontend dev | accepted | Public frontend |
| [0036](0036-raccourcis-clavier-couverture-complete.md) | Keyboard shortcuts: full coverage + command palette | accepted | Any interface |
| [0037](0037-sidebar-architecture-information.md) | Sidebar: intents, max 7, lead feature | accepted | Back-office + front |
| [0040](0040-contexte-design-par-projet.md) | `DESIGN.md`, `PRODUCT.md`, and the Surface-mode taxonomy | accepted | Frontend projects |
| [0060](0060-diagram-design-systeme-reference.md) | `diagram-design` as the visual reference system | accepted | Diagrams |
| [0061](0061-taste-anti-slop-design-dials.md) | `taste`: anti-slop dials and visual styles | accepted | Frontend |
| [0068](0068-loi-de-hick-hierarchie-actions.md) | Hick's Law: on-screen action hierarchy | accepted | Any interface |
| [0071](0071-performance-percue-reactivite-confirmation.md) | Perceived performance: immediate responsiveness and success confirmation | accepted | Any interface |
| [0072](0072-visiteurs-simulation-ux-team-dev.md) | `ai-visitor-simulation`: a hybrid UX simulation, wired into `team-dev` | accepted | Projects with an interface |

## Backend, API, and infrastructure

| # | Title | Status | Scope |
| --- | --- | --- | --- |
| [0004](0004-api-response-codes-semantiques.md) | Semantic HTTP codes and a unified response format | accepted | API |
| [0006](0006-resilience-sous-charge.md) | Resilience under load: mandatory checklist | accepted | Back + infra + mobile |
| [0031](0031-dto-architect-source-unique.md) | DTO Architect: the single source of truth for DTO conventions | accepted | Cross-stack |
| [0041](0041-termine-infrastructure-consommateur.md) | Infra "done": service + consumer + proof | accepted | Infra |
| [0067](0067-logging-architect-skill-transverse.md) | Logging Architect: a cross-cutting skill instead of one per stack | accepted | Cross-stack |
| [0042](0042-monorepo-extraction-shared.md) | Monorepo: extract to `shared/` before duplicating | accepted | Monorepos |
| [0043](0043-nouveau-service-harnais-test.md) | New service: inherit the test harness from the sibling | accepted | Monorepos |

## Working method

| # | Title | Status | Scope |
| --- | --- | --- | --- |
| [0008](0008-cadrage-alignement-amont.md) | Upfront alignment: before any non-trivial change | accepted | All projects |
| [0009](0009-unlazy-acceptance-gates.md) | Unlazy: acceptance gates before any substantial task | accepted | All projects |
| [0019](0019-hygiene-session-compaction.md) | Session hygiene and context compaction | accepted | Sessions |
| [0028](0028-ponytail-minimal-code.md) | Ponytail: minimal-code discipline before writing | accepted | Any code |
| [0029](0029-karpathy-guidelines-gardes-fous.md) | Karpathy Guidelines: behavioral guardrails | accepted | Any code |
| [0030](0030-spec-driven-development.md) | Integrated Spec-Driven Development (SDD) workflow | accepted | Product chain |
| [0038](0038-retro-retrospective-environnement.md) | Retro: end-of-session environment retrospective | accepted | Sessions |
| [0046](0046-discipline-subagents-hygiene-mcp.md) | Subagent discipline and MCP hygiene | accepted | Sessions |
| [0056](0056-kit-amorcage-socle-agent.md) | The project-bootstrap kit produced by `project-bootstrap-agent` | accepted | New projects |
| [0070](0070-socle-agent-volet-conformite-legale.md) | `project-bootstrap-agent`: a conditional legal-compliance track (complements 0056) | accepted | New projects |

## Orchestration — agents and skills

| # | Title | Status | Scope |
| --- | --- | --- | --- |
| [0014](0014-architecture-3-niveaux-orchestration.md) | 3-level orchestration architecture | accepted | Ecosystem |
| [0015](0015-skill-router-weighted.md) | Centralized Skill Router with a weighted strategy | accepted | Ecosystem |
| [0016](0016-tiering-modeles-haiku-sonnet-opus.md) | Model tiering: Haiku / Sonnet / Opus | accepted | All skills |
| [0018](0018-logging-skill-selection.md) | Structured logging of skill selection | accepted | Observability |
| [0021](0021-frontmatter-skill-md-obligatoire.md) | Mandatory frontmatter metadata in SKILL.md | accepted | All skills |
| [0025](0025-canari-detection-derive.md) | Canary: instruction-drift detection | accepted — word changed by 0065 | All sessions |
| [0047](0047-subagent-stop-isolation.md) | `<SUBAGENT-STOP>`: isolating root-agent instructions | accepted | Bootstraps |
| [0049](0049-registre-personal-agents.md) | The `personal-agents.json` registry and PO creation | accepted | Personal POs |
| [0050](0050-conventions-ecriture-skill-md.md) | SKILL.md writing conventions outside the frontmatter | accepted | All skills |
| [0052](0052-points-entree-hors-team-dev.md) | Business entry points outside the `team-dev` hierarchy | accepted | ICT + procurement |
| [0054](0054-skills-metier-projet-specifiques.md) | Project-specific domain skills in the global config | accepted | Creativity-theory, pilgrimage |

## Environment and configuration

| # | Title | Status | Scope |
| --- | --- | --- | --- |
| [0017](0017-security-modes-safe-dev-audit.md) | Security modes: safe / dev / audit | accepted | All sessions |
| [0020](0020-workflow-git-conventional-commits.md) | Global Git workflow and Conventional Commits | accepted | All repos |
| [0073](0073-validation-locale-avant-pr.md) | Mandatory local validation before any Pull Request (complements 0020) | accepted | All repos |
| [0022](0022-context7-documentation-a-jour.md) | Context7 MCP: systematic up-to-date documentation | accepted | Third-party libraries |
| [0023](0023-hugging-face-mcp-image-video.md) | Hugging Face MCP: image / video generation | accepted | Media |
| [0024](0024-memory-system-primer-hindsight.md) | Cross-session memory system | accepted | Ecosystem |
| [0026](0026-hooks-globaux-stop-pretooluse.md) | Global hooks (SessionStart, Stop, PreToolUse) | accepted — amended 2026-09-17 | Global config |
| [0027](0027-hygiene-fichiers-temporaires.md) | Temporary file hygiene | accepted | All projects |
| [0048](0048-depot-miroir-claude-config.md) | The source repo as a versioned mirror of `~/.claude` | **§2 superseded by 0062** | Ecosystem |
| [0051](0051-memoire-logs-partages-private-collision.md) | `<private>` and collision-safe shared-log writes | accepted | Memory + logs |
| [0053](0053-parc-mcp-activation-selective.md) | The MCP fleet: a versioned scope and selective activation | accepted | MCP tooling |
| [0057](0057-nommage-memoire-et-rapports.md) | Naming conventions for memory and reports | accepted | Memory |
| [0062](0062-claude-dir-checkout-git.md) | `~/.claude` is a git checkout, not a copy | accepted | Ecosystem |
| [0063](0063-mit-license-shared-publication.md) | MIT license and contribution governance | accepted | Shared repo |
| [0064](0064-separation-depot-personnel.md) | Personas named by function, an overlaid repo for personal profile | accepted | `~/.claude` |
| [0065](0065-allegement-claude-md.md) | Slimming down the steering file: one rule, one source | accepted | Instructions |
| [0066](0066-api-finder-snapshot-statique.md) | `api-finder`: a static snapshot rather than a runtime clone | accepted | Skills |

## Domain-specific

| # | Title | Status | Scope |
| --- | --- | --- | --- |
| [0055](0055-marches-publics-belges-conventions.md) | Public-procurement domain conventions | accepted — dated thresholds | Illustrated with one EU jurisdiction |

---

## Dependency chains worth knowing

Some ADRs complement each other and read together:

- **Orchestration** — 0014 (hierarchy) → 0015 (router) → 0047 (leaf isolation) → 0052 (ICT/procurement exception)
- **Session cost** — 0016 (tiering) + 0019 (compaction) + 0046 (subagents & MCP) + 0053 (the MCP fleet)
- **Skills** — 0021 (frontmatter) + 0050 (SKILL.md body)
- **Memory** — 0024 (system) + 0051 (`<private>`, collision-safe) + 0057 (naming)
- **Before execution** — 0008 (alignment, before deciding) then 0009 (gates, before implementing)
- **Monorepo** — 0042 (duplication) + 0043 (test harness)
- **Secrets & config** — 0002 (secrets) + 0026 (hooks) + 0058 (permissions)
- **Git workflow** — 0020 (branches, commits) + 0073 (local validation before a PR)
- **Legal compliance** — 0069 (multi-jurisdiction `legal-pages`) → 0070 (`project-bootstrap-agent` bootstrap, complements 0056)
- **Perceived UX before production** — 0071 (responsiveness/confirmation) + 0072 (AI visitor simulation), both complementary to 0003/0005/0006/0011 without duplicating them
