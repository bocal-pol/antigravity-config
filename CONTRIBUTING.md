# Contributing to `antigravity-config`

This repository is a shared Antigravity environment: **skills** (capabilities invoked by name),
**agents** (orchestrators that coordinate several skills), and the conventions that govern them. A
contribution that is accepted here runs for everyone who uses this configuration in their own
project.

Hence the underlying rule: **a skill that never self-invokes, or that references something that
does not exist, produces no visible error**. Failures in this environment are silent. That is why
validation focuses as much on frontmatter as on content.

---

## 1. Before writing

| You want to… | Do this instead |
| --- | --- |
| Add a capability | Check [`.agents/SKILLS_INDEX.md`](.agents/SKILLS_INDEX.md) that it does not already exist under another name |
| Correct a behavior | Encode the correction directly in the relevant file (AGENTS.md, memory, or skill) |
| Create a skill | Draft a `SKILL.md` following the anatomy below |
| Change a cross-cutting rule | Open an issue first: it affects every session for every user |

Duplicates are the most costly defect in this repository: two skills with overlapping triggers make
auto-invocation non-deterministic. If your capability overlaps an existing one, prefer enriching it,
or declare a cross `conflicts:` between the two.

---

## 2. Anatomy of a `SKILL.md`

A skill lives at `.agents/skills/<name>/SKILL.md`. The folder name and the `name` field must match.

```yaml
---
name: laravel-developer
description: "Laravel Developer — Laravel 9+, Eloquent, Sanctum... Auto-invoke on: Laravel, Eloquent, Artisan, migration, controller."
model: gemini-pro
type: framework
priority: high
scope: backend
dependencies:
  - context7-mcp
conflicts:
  - dotnet-developer
---
```

All **seven fields are required**.

| Field | Constraints |
| --- | --- |
| `name` | kebab-case, identical to the folder name |
| `description` | **Oriented toward concrete triggers** — it decides whether the assistant proposes the skill spontaneously. Quote it as soon as it contains a `: ` or starts with a special character |
| `model` | A model tier identifier (see "Known limitations" in `AGENTS.md` for Antigravity support) |
| `type` | `orchestrator` · `framework` · `domain` · `utility` · `context` · `specialized` |
| `priority` | `high` (specialized, prioritized by the router) · `medium` (generalist) · `low` (last resort) |
| `scope` | `backend` · `frontend` · `infra` · `mobile` · `data` · `security` · `cross` (reserved for cross-cutting skills) |
| `dependencies` | Required skills or MCP servers. Check their availability before invoking, warn if absent |
| `conflicts` | Skills never activated at the same time (same domain) |

### Forbidden frontmatter

- **Never a `tools:` key** — that is an *agent* key, plainly ignored in a skill.
- `allowed-tools:` **pre-authorizes** (lifts confirmation), it does not restrict. Use only with an
  explicit justification. To restrict, use `disallowed-tools:`.
- An `argument-hint:` starting with `[` must be **quoted**: in YAML, an unquoted `[…]` parses as a
  sequence, breaking the value.

### Content rules

- **Paths**: project-local `.agents/` directory only. **No absolute user path**.
- **Grep**: systematically exclude `node_modules/`, `vendor/`, `*.test.*`.
- **Dependency between skills**: write explicitly "call the skill named `name`," one call per skill.
  Never a slash-command reference embedded in prose — it triggers nothing.
- **Child skill**: document its input, its output, and a ⚠️ fallback if the child is absent.

---

## 3. Anatomy of an agent

An agent lives at `.agents/<name>.md`. It orchestrates, it does not implement.

```yaml
---
name: backend-agent
description: Principal Backend Director — orchestrates Laravel 9+ or .NET 10+ depending on the project.
model: gemini-pro
tools: Glob, Grep, Read, Write, Bash, AskUserQuestion, Skill
---
```

Unlike skills, `tools:` is a **real** key here. Two verified pitfalls:

- An agent that invokes a skill **must** declare the `Skill` tool, or the invocation fails.
- An agent that reads files **must** declare `Read`.

### Hierarchy — delegation never flows upward

```text
Level 0 — Coordination    team-dev
Level 1 — Direction       product-agent (product) · architecture-agent (architecture)
Level 2 — Implementation  backend · frontend · mobile · infrastructure · integration · data · design · qa-lead · security…
```

A single-domain request goes directly to level 2. A request touching two or more domains goes
through `team-dev`. A level-2 agent never calls level 0.

---

## 4. Git workflow

`main` and `develop` are protected — direct push is refused by the `pre-tool-use.sh` hook *and* by
permission settings.

```bash
git checkout develop
git pull origin develop
git checkout -b feature/short-name
```

One branch = one objective. Prefixes: `feature/*`, `bugfix/*`, `hotfix/*`.

Merging happens **via Pull Request to `develop`**, never locally.

### Commit messages — strict Conventional Commits

Format: `type(scope): short description`

Types: `feat` · `fix` · `refactor` · `docs` · `test` · `chore`

Rules: imperative present tense · no leading capital · no trailing period · 72 characters max · one
commit = one intent.

```text
feat(auth): add JWT authentication      # valid
Added authentication system             # invalid
```

**No `Co-Authored-By:` trailer and no "Generated with…" line** in a commit message or PR
description. Each commit has a single, human author.

---

## 5. Versioning

The repository is versioned at the repository level, not per skill:

- [`CHANGELOG.md`](CHANGELOG.md) in Keep a Changelog format, updated at each release.
- Semver tags on `main`: `v1.2.0`.
- **No `version:` field per skill** — dozens of files to maintain by hand for information `git log`
  already gives.

---

## 6. Before opening the PR

- [ ] The skill or agent is invocable and does what its `description` states.
- [ ] No absolute path, no secret, no personal data.
- [ ] No reference to a nonexistent skill, agent, or file.
- [ ] `.agents/SKILLS_INDEX.md` updated if you add a skill.
- [ ] An ADR in `docs/adr/` if the decision is hard to reverse, surprising without context, and the
      result of a real trade-off — one to three sentences suffice.
- [ ] Commits follow the convention above.

---

## 7. What does not belong here

- Personal data, account credentials, organization names.
- Machine-specific files: they go in a local, git-ignored settings file.
- Personal agents or skills: they live in a separate, private repository, not here.
- Temporary files at the root: use a git-ignored temp directory.
