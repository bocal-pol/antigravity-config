# ADR 0065 — Slimming down the steering file: one rule, one source

- **Status**: accepted
- **Date**: 2026-09-17

## Context

The main steering file (`AGENTS.md`) had grown to **977 lines**, loaded in full on every session alongside `primer.md` (48 lines) and `hindsight.md` (56 lines) — **1,081 lines of preamble before the first question**, multiplied by every session and every colleague once the repo was shared.

A sharing audit showed this volume wasn't density, it was redundancy:

- **381 consecutive lines** (39% of the file) detailed six product rules — SaveMe, Sidebar,
  Keyboard shortcuts, the Lazy Principle, the Impact readout, the Ikea effect — which only concern
  deliveries with an interface, and each of which was **already documented in an ADR**.
- The Skill Router table copied `skills/.router.json` line for line, two lines after declaring that
  file "the single source of truth."
- **Twelve convention blocks** appeared in at least two of the three files loaded together, ten in
  all three.
- Two `hindsight.md` entries were promoted **verbatim** into rules in the steering file, so the
  same information loaded twice.

## Decision

### 1. One rule, one source, everything else points to it

| Subject | Single source |
| --- | --- |
| Skill, agent, git, security, cost conventions | the main steering file (`AGENTS.md`) |
| Detail of the six product rules | `PRODUCT-RULES.md` (new) |
| Skill Router priorities | `skills/.router.json` |
| The reasoning behind a decision | `docs/adr/` |
| How to contribute | `CONTRIBUTING.md` |

`README.md` becomes descriptive and points elsewhere; `primer.md` is reduced to what no other file
says — the repo's purpose, how it's mounted as a git checkout, its counters.

### 2. `PRODUCT-RULES.md`

The 381 lines move out of the steering file, which keeps a one-line-per-rule table with a link to
the corresponding ADR and a one-sentence reminder. The file is meant to be read **before shipping**
a screen, a form, a navigation, or a user action.

Its scope is now made explicit, which it wasn't before: these rules don't apply to internal
interface-less tools, to APIs, or to MVPs under two weeks old. Stacked together and declared
"cross-cutting, all projects," they had made it nearly impossible to call a screen done.

### 3. The canary moves to a local, gitignored file

Claude Code automatically loads a local steering file if one exists and ignores it otherwise — a
native mechanism, with no `@import` whose behavior on a missing file isn't documented. The file is
gitignored.

**Decision revised the same day**: the canary **stays in the shared steering file**. It doesn't
detect a deliberate drift, it signals that instructions did load — and that matters for everyone,
not just its author. Only the word changes, to `canary`: the previous one also named an agent, so
it could legitimately appear in a response without being the canary. See the amended ADR 0025.

The local file remains the right place for any machine-specific instruction, though, and the
mechanism is documented in the steering file as such.

### 4. Purging `hindsight.md`

**A lesson promoted to a rule in the steering file is removed from the journal.** The rule is
written at the top of the file. The two affected entries (session revocation, passwords in `.env`)
were removed and replaced by two new lessons, genuinely drawn from this session.

### 5. Agent / skill naming

The hierarchy named its leaves after **skills** (`laravel-developer`) while the same file's
obligations addressed **agents** — to the point that two sections contradicted each other about who
"the backend" was. The hierarchy now names agents at every level, with the skills they invoke in
parentheses.

## Positive consequences

- Session preamble: **1,081 → 720 lines**, a third less on every session for every person.
- A changed rule now only needs changing in one place.
- The product rules' scope is finally explicit.

## Negative consequences / risks

- A cross-reference is only read if it's followed: a product rule could be forgotten where it used
  to sit in plain sight. The steering file's reminder table exists for that, and the ADRs remain the
  authoritative reference.
- The steering file still sits at 602 lines. Most of what's left is genuinely cross-cutting
  convention; trimming further would mean cutting rules, not moving text.
- A gitignored local file isn't backed up.

## Alternatives considered

- **ADR cross-references alone, no `PRODUCT-RULES.md`**: ADRs explain *why* a decision was made, not
  *how* to apply it; completion checklists wouldn't have belonged there. Rejected.
- **Leaving it as-is**: an accepted cost, but multiplied by every colleague once the repo is shared.
  Rejected.
- **An `@import` to a gitignored personal file**: Claude Code's behavior on a missing import isn't
  documented; the local-file mechanism covers the case natively. Rejected.

## Scope

The steering file, `primer.md`, `hindsight.md`, `README.md`, `PRODUCT-RULES.md`, and the local
machine-specific file. See also ADR 0010 to 0013, 0036, 0037 (the six product rules), and 0063
(sharing the repo).
