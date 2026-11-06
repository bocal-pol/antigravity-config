# ADR 0049 — The `personal-agents.json` registry and guided PO creation

- **Status**: accepted
- **Date**: 2026-09-17

## Context

The ecosystem hosts personal Product Owners — persona experts in a domain that has nothing technical about it: legal compliance, prepping, HR, institutional communications, motorsport, tabletop RPGs. They don't belong to the `team-dev` hierarchy (ADR 0014), which organizes software-development roles.

With no registry, `team-selector` had to guess their existence by listing `agents/` files and reading their frontmatter — costly, and unable to tell a personal PO apart from an orchestration agent.

## Decision

### 1. A single declarative registry

`personal-agents.json` at the root, read by `team-selector`. A PO is one block:

| Field | Role |
| --- | --- |
| `id` | short identifier |
| `agent_file` | the file in `agents/` (no extension) |
| `mode` | the `team-dev` invocation mode (`--ask hr`, `--ask communication`...) |
| `label` / `description` | what `team-selector` shows the user |
| `domains` | areas of expertise |
| `auto_suggest_if` | keywords that trigger an automatic suggestion |
| `active` | `false` disables the PO **without deleting it** |

### 2. Guided creation via `po-creator`

The `po-creator` skill walks through defining a new PO (persona, domain, keywords), generates the agent file, and registers it.

⚠️ **Known limitation**: `po-creator` doesn't record the five integration points. `README.md`, `team-dev/SKILL.md`, and `skills/SKILLS_INDEX.md` must be updated by hand after creating any PO.

### 3. The registry is the source of truth

Adding a PO without registering it makes it invisible to `team-selector`, even though its agent file exists.

## Positive consequences

- `team-selector` reads a single structured file instead of scanning 54 agent files
- `auto_suggest_if` lets it propose the right expert without the user knowing the mode's name
- `active: false` lets a PO be pulled from rotation without losing its work

## Negative consequences / risks

- The registry and the agent files can drift apart — nothing checks that `agent_file` points to an existing file
- The three extra manual integration points are regularly forgotten
- `auto_suggest_if` lists grow and eventually overlap between POs

## Alternatives considered

- **Discovery via agent-file frontmatter**: costly on every selection and unable to distinguish a PO from an orchestrator. Rejected.
- **Registering POs in the Skill Router** (`.router.json`): the router arbitrates technical domains by weighted priority, a mechanism unrelated to persona suggestion. Rejected.
- **One PO = one skill**: would lose the notion of a persona invocable via a `team-dev` mode. Rejected.

## Scope

The ecosystem's personal POs and `team-selector`. See also ADR 0014 (team-dev hierarchy) and ADR 0052 (entry points outside the hierarchy).
