---
name: encode-correction
description: Claude behavior correction — encodes a correction into the right environment file (AGENTS.md, memory, skill, settings). Invoke via /encode-correction [description of the behavior to correct]. Auto-invoke when the user says "no not like that", "stop doing", "don't do that anymore", "I don't want you to", "correct your behavior", "encode this", "remember this", "I want you to always", "I want you to never".
model: claude-sonnet-5
user-invocable: true
argument-hint: "[description of the behavior to correct]"
type: utility
priority: low
scope: cross
dependencies: []
conflicts: []
---

# /encode-correction — Behavior Correction

Immediately encodes a correction into the right file so the behavior doesn't recur.

## Workflow

### Step 1 — Capture the correction

If an argument is provided: use it directly as the description.

Otherwise, ask via AskUserQuestion:

```
/encode-correction — Which correction to encode?

Describe the behavior to correct:
  → What Claude did: ___
  → What it should have done instead: ___
  → Always / Never / In this context: ___
```

### Step 2 — Classify the correction

Determine where to encode it based on the nature of the correction:

| Type | Criterion | Target file |
|------|---------|--------------|
| **Global rule** | Always/never applicable across all projects | `AGENTS.md` at the repo root |
| **Behavioral preference** | Response style, tone, format, habits | `~/.claude/memory/feedback_behavior.md` (or this environment's equivalent memory store) |
| **Skill rule** | Correction specific to one skill (angular-developer, team-dev…) | `.agents/skills/<name>/SKILL.md` |
| **Wrong skill** | The wrong skill triggered automatically | Note in the offending skill + `AGENTS.md` if systemic |

> If the correction is ambiguous: prefer `AGENTS.md` for "always/never" rules, and the feedback memory for preferences.

### Step 3 — Read the target file

Read the target file **before** making any change, so as not to overwrite existing content.

### Step 4 — Encode the correction

#### If target = `AGENTS.md`

Add under a `## Behavior Corrections` section (create it if absent):

```markdown
## Behavior Corrections

- **[Date YYYY-MM-DD]**: [Short, actionable rule]
  - Don't: [forbidden behavior]
  - Do instead: [expected behavior]
```

#### If target = feedback memory

Create or update `~/.claude/memory/feedback_behavior.md` with frontmatter:

```markdown
---
name: feedback_behavior
description: User-validated behavior corrections — rules to apply systematically
type: feedback
---

## [Rule title]

[Rule as one imperative sentence]

**Why:** [What the user said, or the implicit reason]
**How to apply:** [When and how to apply this rule]
```

Then add the pointer in `~/.claude/memory/MEMORY.md` if not already present.

#### If target = a specific skill

1. Read `.agents/skills/<name>/SKILL.md`
2. Locate the relevant phase
3. Add or edit a line `> **Correction**: [rule]` before the relevant code block
4. If the correction invalidates a code example: update the example

### Step 5 — Confirm

Show a short summary:

```
Correction encoded

File modified: [path]
Rule added: "[exact text of the encoded rule]"
```

No long summary. Just what changed.
