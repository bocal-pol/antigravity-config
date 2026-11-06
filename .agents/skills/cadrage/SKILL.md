---
name: cadrage
description: "Upstream alignment before any non-trivial change: a 6-axis discovery interview (intent, scope, edge cases, alternatives, unknowns, security risks) resolving every decision branch, then a shared vocabulary (CONTEXT.md, or CONTEXT-MAP.md in multi-context setups) and an ADR for hard decisions. Use before implementing a new feature, a redesign, or a structuring decision, and when the user says 'scope this', 'before we implement', 'let's align', 'what do we mean by'. Don't use for an obvious rename or fix."
model: claude-sonnet-5
user-invocable: true
argument-hint: "[description of the change]"
type: utility
priority: high
scope: cross
dependencies: []  # paid-consultant-agent/devils-advocate-agent/mentor-agent/ceo-decision-agent: conditional, Phase 1bis only
conflicts: []
---

# cadrage — Upstream alignment & shared vocabulary (essence)

An **alignment gate before any significant change**: a discovery interview that resolves every
decision branch, **then** documents hard decisions (ADR) and builds a **shared domain vocabulary**
(`CONTEXT.md`). Reduces misalignment *and* verbosity — variables, functions, and files end up named
with the same language.

> Essence extracted from a `grilling` + `domain-modeling` methodology — no plugin, no imposed
> tracker. Complements `ponytail` (before writing, go down the decision ladder) and
> `karpathy-guidelines` (think before coding) upstream: **before even deciding what to write, align
> on the what and the why.**

## When to use it

- Before any **non-trivial** change (feature, redesign, structuring decision).
- Invoked by `team-dev` before dev modes on a significant change, or directly via
  `/cadrage <description>`.
- Skip if the change is trivial/mechanical (a rename, an obvious fix) — don't ritualize the
  unnecessary (ponytail spirit).
- For a structuring **non-technical** decision (investment, hiring, an offer, budget), Phase 1bis
  weighs 4 leadership personas on the same decision before concluding.

## Workflow

### Phase 1 — Alignment interview (grilling)

Interview **until every decision branch is resolved** — don't stop at the first level. Via
`AskUserQuestion`, in waves:

1. **Intent**: what real problem? for whom? what observable success?
2. **Scope**: what's in / explicitly out? constraints (perf, security, deadline)?
3. **Edge cases**: what happens when [empty input / concurrency / network failure / insufficient
   permissions]?
4. **Alternatives**: what approaches were discarded, and why? what would make this choice bad?
5. **Unknowns**: what isn't decided yet and blocks implementation?
6. **Security risks** (OWASP A04 — Insecure Design): does this feature touch auth, access rights,
   personal data, a payment flow, or user-entered content? If so, what's the most obvious abuse
   case (who could misuse this feature, and how) and what control prevents it — server validation,
   authorization, rate limiting, encryption? If the answer is "we'll see while coding", that's an
   unresolved branch like any other: it belongs to design, not to after-the-fact implementation. For
   a structuring architecture decision rather than an isolated feature, prefer Phase 2bis (STRIDE
   threat modeling) of the `architect` skill, which covers trust boundaries more thoroughly.

Conduct rules:
- **Facts are the agent's job, decisions are the user's.** Anything verifiable in the environment
  (files, dependencies, config, current behavior) is looked up with `Grep`/`Glob`/`Read` — never
  asked of the user. Only **choices** are submitted to them.
- **Ask the whole unblocked frontier in each wave**: every question whose prerequisites are already
  settled, all at once. A question whose answer depends on another still-open one waits for the next
  wave.
- Dig into every vague answer before moving on. A "we'll see" decision = an unresolved branch →
  keep going.

### Phase 1bis — Multi-angle deliberation (non-technical structuring decisions)

**Trigger condition**: the decision scoped in Phase 1 is strategic/business in nature rather than
purely technical — e.g. an investment choice, a hire, launching an offer, a budget trade-off, a
product pivot. Do **not** trigger for a pure architecture or stack decision (it stays covered by the
5 axes + ADR above). When in doubt, ask the user if they want this phase rather than skipping it or
imposing it silently.

Two-step flow — three independent angles, then an informed closing of the three:

**Step 1 — independent angles (in parallel)**: call the Agent tool with each of the following three
agents, in the same message so they run in parallel. Each receives the same brief (intent + scope +
edge cases from Phase 1) and doesn't see the other two's answers — the goal is three genuinely
independent readings, not a sequential discussion.

1. **Call the Agent tool with the paid-consultant agent** — costs up to 3 options, decides, gives a
   2-week plan and a dated failure signal.
2. **Call the Agent tool with the devil's-advocate agent** — attacks the favored option's central
   assumption, ranks objections by probability × severity.
3. **Call the Agent tool with the mentor agent** — separates the presented problem from the
   underlying real problem, spots the repeating pattern.

**Step 2 — closing**: once the three answers are obtained, **call the Agent tool with the
CEO-decision agent**, passing it the three positions (consultant, devil's advocate, mentor) plus the
initial brief — it decides in a fixed format (decision, why, what we stop, a 30-day metric to watch,
a deadline) informed by all three angles, not blindly.

Produce a **deliberation summary** before moving to Phase 2:

```markdown
## Deliberation — [decision]

| Angle | Position |
|-------|----------|
| Consultant | [recommended option + why] |
| Devil's advocate | [attacked assumption + main objection] |
| Mentor | [real problem vs. presented problem] |
| CEO | [decision made + metric to watch + deadline] |

### Points of consensus
[What at least 3 of the 4 angles converge on]

### Unresolved tensions
[Disagreements between angles — to be explicitly decided by the user, never arbitrated on their
behalf]
```

**⚠️ Fallback**: if an agent is unavailable, note "not run — relaunch via `/team-dev --<mode>`" in
the table and continue with the remaining angles rather than blocking the scoping.

### Phase 2 — Reading the terrain

Before locking the vocabulary: `Grep`/`Glob` the codebase to spot terms **already in use** (classes,
modules, files). Reuse existing language rather than inventing new terms (consistency > novelty).

### Phase 3 — Shared vocabulary (`CONTEXT.md`)

`CONTEXT.md` is a **pure glossary** of domain-specific terms: name → unambiguous definition (one to
two sentences, what the term *is*), synonyms to avoid. No implementation details, no generic
programming concepts (timeouts, error types, utilities) even if the project uses many. Be decisive:
one retained word per concept, the others under "to avoid". Update **as the interview progresses**,
as soon as a term crystallizes, not in a batch at the end.

```markdown
# CONTEXT — Domain vocabulary

| Term | Definition | Synonyms to avoid |
|-------|-----------|--------------------|
| ...   | ...       | ...                |
```

**Structure based on the repo** (created lazily, at the first resolved term):
- **Single context** (most projects): one `CONTEXT.md` at the root.
- **Multiple contexts** (multi-service monorepo, distinct business domains): a `CONTEXT-MAP.md` at
  the root listing the contexts, where their `CONTEXT.md` lives (e.g.
  `services/billing/CONTEXT.md`), and how they talk to each other (events, shared types). If
  `CONTEXT-MAP.md` exists, follow it to find the right glossary; if a topic spans several contexts
  and it isn't clear, ask.

### Phase 4 — ADR for hard decisions

Propose an ADR in `docs/adr/NNNN-title.md` **only if all three conditions are met**:

1. **Hard to reverse** — changing course later genuinely costs something.
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth
   did they do that?".
3. **A real trade-off** — real alternatives existed and one was chosen for specific reasons.

Easy to reverse → it'll get reversed. Not surprising → no one will wonder. No alternative → nothing
to record beyond "we did the obvious thing". Typically: architectural shape, cross-context
integration patterns, lock-in technology choices, boundary decisions, deliberate deviations from the
obvious path, invisible constraints in the code, alternatives rejected for non-trivial reasons.

An ADR can fit in **1 to 3 sentences** (context, decision, why). The sections below are added only
if they bring something:

```markdown
# ADR NNNN — [Title]

- **Status**: accepted
- **Context**: the problem and the forces at play
- **Decision**: what was chosen
- **Consequences**: what it implies (positive AND negative) — if not obvious
- **Discarded alternatives**: and why — if the rejection is worth recording
```

### Phase 5 — Output

Return:
- The **alignment summary** (intent, scope, edge cases, identified security risks, remaining
  unknowns).
- Files created/updated (`CONTEXT.md` / `CONTEXT-MAP.md`, ADR).
- The **green light** or the remaining **blocking unknowns** before implementing — an abuse case
  with no identified control (axis 6) is a blocking unknown like any other.

## Fallback

If the skill is unavailable: run the interview from memory (intent → scope → edge cases →
alternatives → unknowns) and record at least the key vocabulary in `CONTEXT.md`.

## Skip memorization

The artifacts (`CONTEXT.md`, `CONTEXT-MAP.md`, ADR) are the deliverable — versioned in the project,
not in `~/.claude/memory/`.
