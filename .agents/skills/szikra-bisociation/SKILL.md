---
name: szikra-bisociation
description: "Koestler's bisociation (1964) and forced creativity techniques. Design an idea pairing, a forced connection, apply the 7 SCAMPER operators, calibrate randomness in link suggestions. Auto-invoke on: bisociation, pair of the day, forced connection, SCAMPER, random input, thinking matrix, idea association, cross two ideas, link suggestion, controlled randomness."
model: claude-sonnet-5
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Szikra — Bisociation

Module 2 of the corpus: Arthur Koestler, *The Act of Creation* (1964).

**The thesis**: *association* connects two elements within the same matrix — the same set of tacit rules. *Bisociation* makes **two independent matrices** collide. Routine thought is associative; only the bisociative act produces something new. Archimedes: "measuring a crown's volume" and "my bath is overflowing" are two matrices; neither contained the solution — their meeting did. Gutenberg: the wine press and the coin seal.

**The triptych** — the same mechanism produces three effects depending on register: *Ha!* (laughter, aggressive-defensive register), *Aha!* (discovery, neutral register), *Ah…* (aesthetic emotion, contemplative register).

**Why it's hard**: a matrix is made of tacit rules, invisible from the inside. The more expert one is, the more solid the matrix — that's the price of competence. One cannot *want* to bisociate; one can only mechanically put oneself in a position to do so.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **The similar never bisociates** | A link suggestion based on similarity alone is an anti-pattern. The gap between matrices is the resource |
| **Randomness dosage** | Aim for ~80% relevant neighbors, ~20% improbable ones. Zero randomness = a sterile recommendation engine |
| **One single question** | A pairing is presented with an open question ("is there something between these two?"), never with a generated answer |
| **One-gesture response** | Three outcomes max: link, ignore, postpone. No mandatory input |
| **Measurable distance** | Usable distance axes: context (personal/professional), capture period, category, space, author |
| **Framework, not generation** | SCAMPER provides seven angles of attack, not seven proposals written in the user's place |

## The seven SCAMPER operators

Bob Eberle (1971), based on Osborn's questions. Apply to an open idea to pull it out of its matrix.

| Operator | Question asked of the idea |
|-----------|-------------------------|
| **S**ubstitute | Which element can be replaced by another? |
| **C**ombine | Which other idea could it merge with? |
| **A**dapt | What to copy from a domain that solves a related problem? |
| **M**odify | What happens by changing scale, frequency, intensity? |
| **P**ut to another use | To whom else, for what else, would this serve? |
| **E**liminate | What remains if we remove the element considered essential? |
| **R**eorganize / reverse | What if the order, or the direction, were reversed? |

Related techniques: *forced connection* (linking the problem to a randomly drawn object), de Bono's *random input* (a random word from the dictionary), Osborn's brainstorming (1953).

## Workflow

### Phase 1 — Identify the matrices in play

Explicitly name the two frames one is trying to collide. If only one frame is identifiable, the request is associative, not bisociative: flag it — it won't produce anything new.

### Phase 2 — Choose the device

| Need | Device |
|--------|-----------|
| Make two existing ideas meet | Pair drawn at random on a distance axis |
| Unblock an isolated idea | The 7 SCAMPER operators |
| Inject from outside | Forced connection / random input |
| Calibrate a suggestion engine | Relevant/improbable ratio, distance axes |

### Phase 3 — Produce

For a pair: the two ideas, the chosen distance axis, the open question, the three outcomes.
For SCAMPER: the seven angles applied to the real idea, formulated as questions.
For an engine: the neighborhood criteria, the ratio, the anti-similarity safeguards.

### Phase 4 — Conditional persistence

- **From an orchestrator**: return in Markdown, write nothing, **skip memorization**.
- **Standalone**: write `ideas/YYYY-MM-DD_szikra-bisociation-[topic].md` in the current project.

## Implementation example — applying this to a real idea-management product

- A pairing feature can be implemented as one of several forms of a periodic resurfacing mechanism (a "duo" form among others like dormant, anniversary, rejected-reason, or random resurfacing).
- A `context` field (`personal` | `professional`) on captured ideas is the strongest available distance axis: two matrices in Koestler's sense. That's the theoretical argument against siloing ideas into separate airtight spaces.
- Other usable axes without a new table: capture date, categories, tags, origin space.
- Resurfacing selection should be **deterministic server-side** (reproducible seed): any "randomness" must go through this mechanism, never a client-side draw.
- Verify the existing implementation before proposing changes (`Grep`, excluding `node_modules/`, `vendor/`, `*.test.*`).

## Fallback ⚠️

If the code state is inaccessible, produce the theoretical device while prefixing: *"Device not checked against the existing implementation."* Never propose recreating a pairing mechanism without having verified it doesn't already exist.

## Optional Input

- Desired device (`pair` | `scamper` | `forced-connection` | `suggestion-engine`)
- The two ideas, or the idea to unblock
- Imposed distance axis (`context` | `time` | `category` | `space` | `author`)
- Constraint (no new table, no job, V1 only…)
