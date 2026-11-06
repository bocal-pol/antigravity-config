---
name: szikra-securite-psy
description: "Psychological safety (Edmondson 1999), organizational silence (Morrison & Milliken 2000), the value of debate (Nemeth 2004). Private draft, anonymity, non-judgmental status wording, refusal of negative voting, participation indicator. Auto-invoke on: psychological safety, organizational silence, anonymity, anonymous submission, private draft, negative vote, idea ranking, rejected status, daring to propose, fear of judgment, constructive criticism."
model: claude-sonnet-5
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Szikra — Psychological Safety

Module 6 of the corpus: Amy Edmondson, *Administrative Science Quarterly* (1999); Morrison & Milliken (2000); Detert & Burris (2007); Nemeth et al. (2004).

**The discovery** — studying hospital teams, Edmondson observed a paradox: the best-rated teams reported *more* errors. Not that they made more: they dared to report them. Hence the concept of **psychological safety** — the shared belief that one can take an interpersonal risk (ask a question, admit a mistake, propose a weird idea) without being humiliated or punished. It's a property **of the group**, not of individuals; it varies widely between teams in the same organization, and it predicts learning better than member competence does. Google's Project Aristotle (2015-2016) ranked it as the top factor in its teams' performance.

**Organizational silence** (Morrison & Milliken) is the flip side: employees hold back their ideas because they believe — often correctly — that speaking up is useless or dangerous. Silence is self-reinforcing: everyone sees others staying quiet and concludes that's the norm. Detert & Burris showed the decisive variable is the **perceived openness of the direct manager**.

**The nuance that matters** — safety does not mean absence of criticism. Nemeth et al. compared classic brainstorming groups (Osborn's "no criticism" rule) to groups allowed to debate: **the debating groups produced more ideas, and better ones**. The problem isn't criticism, it's criticism *of the person*. A safe team is one where you can say "I disagree with this idea" without anyone hearing "you're an idiot."

## What software can do

Software **does not create** psychological safety — that happens between people. But it **destroys** it very effectively: negative vote counters, public idea rankings, a red "rejected" status next to the proposer's name, a team-wide notification for every refusal. And it can **protect** it: separating the idea from its author, allowing a private draft, wording statuses without judgment.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Private draft by default** | Every idea starts visible only to its author. Sharing is an explicit gesture, never an initial state |
| **Possible anonymity** | At the proposer's choice, per idea. The space owner should not be able to lift anonymity casually either |
| **Statuses worded about the idea** | "Not retained for now — no budget," never a verdict on the author. Prefer "not now" to "rejected" |
| **No negative vote** | No thumbs down, no public ranking, no displayed average rating |
| **Debate yes, humiliation no** | A comment thread allows argued criticism (Nemeth) and is itself a form of feedback (Detert & Burris) |
| **Participation indicator** | A space's health metric is the **number of members who submitted at least one idea this month** — the direct inverse of organizational silence. Never the average idea rating |
| **"Raw idea" label** | Signal that a formulation is deliberately unfinished: the equivalent of "thinking out loud" |

## Workflow

### Phase 1 — Identify the object

Designing an anonymous submission · wording status labels · arbitrating a voting or ranking mechanism · defining a space indicator · auditing a group screen. Collect via `AskUserQuestion` if absent.

### Phase 2 — Verify the existing state

Read the real state (`Grep`, excluding `node_modules/`, `vendor/`, `*.test.*`): is anonymity reversible and by whom, which labels carry judgment, is there a negative vote or popularity sort, who gets notified of rejections.

### Phase 3 — Recommendation

Decide each point with its justification: default visibility, anonymity mechanics and reversibility, exact proposed labels, allowed and forbidden reactions, chosen indicator, scope of rejection notifications.

On labels, produce the exact wording word for word — that's where theory becomes concrete.

### Phase 4 — Conditional persistence

- **From an orchestrator**: return in Markdown, write nothing, **skip memorization**.
- **Standalone**: write `ideas/YYYY-MM-DD_szikra-securite-psy-[topic].md` in the current project.

## Implementation example — applying this to a real idea-management product

- **Anonymity should be pseudonymized**: an `is_anonymous` flag, with the author link isolated in a separate secrets table keyed by idea id. Lifting anonymity should be a traced admin-panel action — verify it stays exceptional and logged, not normalized.
- **No negative vote in the model**: reactions limited to `like`, `adhere`, `rating` (1-5). Any request to add a thumbs-down or a public ranking should be declined with reference to Edmondson.
- Existing labels to watch: a `rejected` status displayed as "Not retained" (not "Rejected") is the compliant wording. A `converted` status displays as "Became a project." Check every locale — a tone regression easily slips through translation.
- The rejection reason serves psychological safety as much as the feedback loop, by shifting judgment from the person to the constraint.
- Space roles: `member · contributor · moderator · admin`. Sharing a personal idea into a group space should be explicit (`shared_at`, `shared_by`, origin space reference).

## Fallback ⚠️

Without access to the sources, produce the principles while prefixing: *"Recommendation not checked against the real labels and anonymity model."* Never assume a negative vote exists or doesn't: that's the point where a misjudgment produces the worst recommendation.

## Optional Input

- Object (`anonymity` | `status-labels` | `reactions-votes` | `space-indicator` | `screen-audit`)
- Locale(s) concerned
- Observed role (`member` | `contributor` | `moderator` | `admin`)
- Constraint (V1 only, no migration, no new role…)
