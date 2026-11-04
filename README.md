# antigravity-config — Antigravity ecosystem

A personal Antigravity configuration — skills, orchestrator agents, and conventions automating
development, security, infrastructure, data, design, and project-management workflows.

This repository is a best-effort port of a private AI coding-assistant configuration, adapted for
the Antigravity agentic IDE (Google/Gemini). See [`PORTING-NOTES.md`](PORTING-NOTES.md) for what is
ported and what is uncertain, and [`RENAME-MAP.md`](RENAME-MAP.md) for every renamed agent and
skill.

Single entry point: see `.agents/team-dev.md`.

To contribute: [CONTRIBUTING.md](CONTRIBUTING.md) · Report a security issue:
[SECURITY.md](SECURITY.md) · License: [MIT](LICENSE) · Credits: [CREDITS.md](CREDITS.md)

---

## Structure

```text
antigravity-config/
├── AGENTS.md                # Global instructions: conventions, invocation rules
├── primer.md                # Permanent project context (purpose, counters, references)
├── hindsight.md             # Journal of lessons learned, dated entries
├── PORTING-NOTES.md         # What is ported from the source config, format uncertainties
├── RENAME-MAP.md            # Old name → new name, for every agent and skill
├── .agents/                 # Agents and skills, Antigravity-native layout
│   ├── <agent-name>.md      # Orchestrator agents
│   ├── skills/              # Skills, invoked by name
│   │   └── <skill-name>/SKILL.md
│   ├── router.json          # Skill Router priorities (see "Known limitations" in AGENTS.md)
│   └── SKILLS_INDEX.md      # Navigation map — every skill by type and scope
├── docs/adr/                # Architecture decisions, ported and translated
├── logs/                    # skill-selection.log — written by a logging hook (not versioned)
└── .gitignore                # Excludes credentials, sessions, runtime cache
```

> See [`AGENTS.md`](AGENTS.md) § "Known limitations" for which of the above mechanisms (hooks, the
> Skill Router, the `tools:` frontmatter key) have **no confirmed Antigravity support** and are
> carried over on a best-effort basis only.

---

## Orchestrator agents

Entry point via `team-dev` or direct invocation of a specific agent.

### Routing hierarchy

```text
Level 0 — team-dev (root)        → multi-domain or ambiguous requests
Level 1 — product-agent / architecture-agent  → product or technical direction
Level 2 — specialized skills     → implementation (laravel-developer, react-developer…)
Fallback — general-engineer      → no skill matches
```

For a clear single-domain request, invoke the Level 2 skill directly without going through
`team-dev`. See [`.agents/SKILLS_INDEX.md`](.agents/SKILLS_INDEX.md) to identify the right skill.

### Agent and skill catalog

The full, current list of agents and skills lives in `.agents/` and
[`.agents/SKILLS_INDEX.md`](.agents/SKILLS_INDEX.md) — this README does not duplicate it, to avoid
two lists drifting apart. [`RENAME-MAP.md`](RENAME-MAP.md) lists every agent and skill ported so far
with its old and new name.

> **Naming convention**: a persona agent is named after its **function**, never after a real
> person.

---

## `team-dev` modes

Short aliases are accepted in place of the long mode name.

```bash
# ─── Routing (no alias) ──────────────────────────────────────────────────────
team-dev --auto  <description>      # Smart routing via team-selector
team-dev --full  <description>      # Full lifecycle (automatic quality loop)
team-dev --audit [target]           # Post-dev multi-profile audit (read-only)
team-dev --bootstrap [description]  # Bootstrap kit (specs, backlog, data dictionary…)

# ─── Product · Architecture · Security ──────────────────────────────────────
team-dev --product       [description]  # Full product brief (product-agent)
team-dev --architecture  [target]       # C4 architecture + ADRs (architecture-agent)
team-dev --security      [target]       # OWASP audit + pentest (security-agent)
team-dev --compliance    [context]      # Regulatory compliance audit
team-dev --pr-review     [files]        # PR / code review

# ─── Development ─────────────────────────────────────────────────────────────
team-dev --backend        [target]        # Backend: Laravel 9+ / .NET 10+
team-dev --frontend       [target]        # Frontend: Angular / React
team-dev --mobile         [target]        # Mobile: Flutter / React Native
team-dev --infrastructure [description]   # Infra: Linux / Docker / K8s / network
team-dev --design         [description]   # UX/UI design & design system
team-dev --data           [description]   # Data Engineering + Science + BI
team-dev --integration    [description]   # REST/ESB/Kafka/EDI integration
team-dev --it-operations  [context]       # IT Ops — ITIL support, CMDB
team-dev --coordination   [objective]     # Agile coordination & management

# ─── Quality · Release · Docs ────────────────────────────────────────────────
team-dev --qa-lead      [target]        # Test plan + E2E
team-dev --sprint       [objective]     # Full sprint cycle
team-dev --release      [version]       # Release — changelog + security audit
team-dev --documentation [target]       # Documentation

# ─── Utilities (no alias) ────────────────────────────────────────────────────
team-dev --ask <skill> [context]    # Delegate directly to a skill
team-dev --onboarding               # Project onboarding guide
team-dev --deps                     # Dependency updates
```

---

## Installation

### 1. Point your Antigravity IDE at this configuration

See [`AGENTS.md`](AGENTS.md) for the expected `.agents/AGENTS.md` and `.agents/skills/` layout.
Clone this repository, then follow your Antigravity IDE's own documentation for loading a
project-local `.agents/` configuration — see [`PORTING-NOTES.md`](PORTING-NOTES.md) for the
uncertainty around exact Antigravity paths and behavior.

### 2. Recommended MCP servers

- **Context7** — up-to-date library documentation.
- **Sequential Thinking** — structured multi-step reasoning for architecture decisions and complex
  debugging.
- **Hugging Face (image/video)** — free image and video generation via Hugging Face Spaces, exposed
  as MCP tools.

### 3. Verify

Open the project in Antigravity and run a simple request through `team-dev --auto` (or your IDE's
equivalent invocation) to confirm the configuration loads.

---

## Conventions — where they are written

This README **describes** the ecosystem; it does not legislate. Rules have a single source, to
avoid two versions to resynchronize by hand.

| Topic | Single source |
| --- | --- |
| Security modes `safe` / `dev` / `audit` | [`AGENTS.md`](AGENTS.md) § Security modes |
| Git workflow, protected branches, Conventional Commits | [`AGENTS.md`](AGENTS.md) § Git workflow — and [`CONTRIBUTING.md`](CONTRIBUTING.md) to contribute here |
| Required skill frontmatter, model tiers, paths, grep exclusions | [`AGENTS.md`](AGENTS.md) § Skill conventions |
| Skill Router priorities by domain | [`.agents/router.json`](.agents/router.json) |
| Product rules (SaveMe, Sidebar, Lazy Principle…) | [`PRODUCT-RULES.md`](PRODUCT-RULES.md) |
| Architecture decisions and their rationale | [`docs/adr/`](docs/adr/README.md) |
| Format uncertainties specific to Antigravity | [`PORTING-NOTES.md`](PORTING-NOTES.md) |

---

## Cross-session memory

An AI assistant can accumulate durable rules, corrections, and preferences in a project-local
memory folder, indexed by a `MEMORY.md`. This is handled by the IDE/harness at startup, not by a
directive in this repository.

**This folder is not versioned** — it contains personal preferences and project state. A fresh
clone therefore starts with empty memory, by design.
