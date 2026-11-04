# Porting notes

This repository is ported from a private AI coding-assistant configuration (built for a different
CLI-based assistant) into a best-effort format for the **Antigravity** agentic IDE (Google/Gemini).

## Why "best-effort"

A web search conducted on 2026-11-04 found **no single, stable, official specification** for
Antigravity's project-local configuration format.

- **Most reliable source found**: official Gemini API documentation ("Building managed agents").
  It describes an agent automatically loading `.agents/AGENTS.md` (or `/.agents/AGENTS.md`) as
  system instructions at startup, and skills placed under `.agents/skills/<skill-name>/SKILL.md`,
  discovered and registered automatically by the framework.
- **Third-party guides** (IDE-specific blog posts, less authoritative) disagree with each other and
  with the official docs on several points:
  - Some use a singular `.agent/` directory instead of the plural `.agents/`.
  - Global (cross-project) configuration paths vary across IDE versions and across guides
    (different `~/.gemini/...` subpaths cited by different sources).
  - No source found describes a stable frontmatter schema for custom agent files, nor a hook system
    equivalent to a `PreToolUse`/`SessionStart`/`Stop` lifecycle.

Given this, the decision taken for this port was: **follow the official doc's two most-cited paths**
(`AGENTS.md` at the root, `.agents/skills/<name>/SKILL.md`) as the backbone, and carry over
everything else — orchestrator agents, hooks, the Skill Router — as **documentation of intent**,
clearly marked as unverified, rather than omitting them. See the "Known limitations" section of
`AGENTS.md` for the authoritative, in-repo list of what is unconfirmed.

## Status of this port

**Phase 1 (this commit): repository structure + root documentation.**

Completed in this phase:

- `AGENTS.md` (ported from the source's global instructions file)
- `primer.md`, `hindsight.md` (ported and translated)
- `README.md`, `PRODUCT-RULES.md`, `CONTRIBUTING.md`, `SECURITY.md`, `CHANGELOG.md`
- `LICENSE`, `.gitignore`, `.gitattributes`, `keybindings.json`, `.mcp.json`, `settings.json`
- Hook scripts ported to `.agents/scripts/`: `pre-tool-use.sh`, `stop.sh`, `skill-log.sh`,
  `memory.sh`, `play-alert.ps1` — each marked with an unconfirmed-support note at its top.
- Repository skeleton: `.agents/`, `.agents/skills/`, `docs/adr/`, `logs/` (with `.gitkeep`).

**Not yet done, left to subsequent porting passes:**

- Agents (`.agents/*.md`) — the orchestrator-agent files themselves.
- Skills (`.agents/skills/*/SKILL.md`) — the full skill library.
- `.agents/router.json` (ported from the source's Skill Router config).
- `.agents/SKILLS_INDEX.md` (navigation index).
- `docs/adr/*.md` (architecture decision records).
- Final cross-reference verification across the whole repository, once agents and skills exist, to
  confirm no stale old-name reference remains (see `hindsight.md`, 2026-06-23 entry, for why this
  step cannot be skipped on a mass rename).

## Explicitly NOT ported in this phase

- **`install.ps1`** (627 lines in the source) — deeply tied to the source's own checkout-based
  installation mechanism for a different assistant's config directory. Does not make sense to port
  as-is for Antigravity; an Antigravity-appropriate installation guide, if any, should be written
  fresh rather than translated.
- **`personal-agents.json`** — a registry of personal persona agents and their trigger keywords.
  Left out of this phase pending a decision on which (if any) persona agents are appropriate to
  carry into a public repository, and review for any personally-identifying content.
- **`image-templates/`** (~30 template files) — a bundled catalog of image-generation prompt
  templates. Left for a later pass; not reviewed for privacy or relevance to Antigravity yet.

## Privacy filtering applied during this port

Because the source configuration is **private** and this repository is **public**, porting also meant
filtering, not just translating. Applied throughout this phase:

- No email addresses, institutional domain names, or employer hints from the source were carried
  over.
- The source repository's own name and "Claude Code"/Anthropic-specific branding were generalized
  to "a private AI coding-assistant configuration" / "the source configuration" wherever they
  appeared as incidental detail (kept only where genuinely necessary to explain a technical
  convention's origin, and even then de-branded).
- The user's real name appears **only** in `LICENSE` (standard copyright attribution) — nowhere else
  in examples, anecdotes, or hindsight entries, which were generalized to "the repository owner" /
  "a user" phrasing during translation.
- No absolute local file paths, account identifiers, or employer-specific context (e.g. a specific
  public-sector domain) were carried over; `CHANGELOG.md` was rewritten fresh for this repository
  rather than translating the source's detailed internal migration history, which named internal
  project codenames.
- `settings.json`'s `model` field was dropped (it referenced a model identifier from the other
  assistant, meaningless here) rather than translated to a guessed Gemini equivalent.

If a future porting pass finds a case of doubt not covered by the rules above, it should be flagged
here rather than decided unilaterally — see the agent-hierarchy and privacy-filtering rules in
`AGENTS.md`.
