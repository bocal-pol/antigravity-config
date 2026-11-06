---
name: szikra-slow-hunch
description: "Slow hunch, the adjacent possible, and liquid networks (Johnson 2010). Calibrate the resurfacing of dormant ideas, reactivate a discarded idea whose reason no longer applies, circulate ideas between personal and professional contexts. Auto-invoke on: dormant idea, resurfacing, echo, slow hunch, adjacent possible, discarded idea, reactivation, commonplace book, liquid network, serendipity."
model: claude-sonnet-5
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Szikra — Slow hunch, adjacent possible, liquid networks

Module 1 of the corpus: Steven Johnson, *Where Good Ideas Come From* (2010), with Gruber on Darwin's notebooks, Kauffman on the adjacent possible, Dunbar on labs.

Three operational theses:

- **Slow hunch** — most great ideas begin as a vague intuition that matures over months or years. Darwin had natural selection written in his notebooks months before his "revelation"; Berners-Lee carried Enquire for ten years before the Web. Two conditions for a hunch to succeed: being **written down**, and being **revisited**. Without rereading, a notebook is a graveyard.
- **Adjacent possible** (Kauffman) — at any given moment, only certain ideas are reachable as a combination of what already exists. Babbage failed for lack of electronics; YouTube would have failed ten years earlier. Corollary: a discarded idea may have been rejected because it was outside the possible adjacent **of the moment**.
- **Liquid networks** — fertile environments are open enough for ideas to circulate, dense enough for them to stick. Dunbar filmed four labs: discoveries weren't born at the microscope, but at the weekly meeting table, when a researcher from another project saw something different in a strange result.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Never archive by age** | An idea's age carries no information about its value. Only an explicit decision changes its status |
| **Resurfacing indifferent to age** | A three-year-old idea has the same probability of resurfacing as a three-month-old one |
| **Exploitable discard reason** | A rejection without a reason forbids any future reactivation. The reason is the condition for the adjacent possible |
| **Contexts mixed by default** | Personal and professional in the same default view; the filter exists but isn't the initial state |
| **Mandatory randomness share** | An algorithm that only suggests similar items kills serendipity. Aim for ~80% relevant neighbors, ~20% improbable ones |
| **No obligation to act** | A resurfacing asks for resonance, never a decision |

## Workflow

### Phase 1 — Frame the request

Determine which of the three theses is at play: resurfacing mechanics (slow hunch), reactivating discarded ideas (adjacent possible), or circulation across contexts and people (liquid networks). Collect via `AskUserQuestion` if context is absent.

### Phase 2 — Verify the existing state

Before any recommendation, read the real state (`Grep` excluding `node_modules/`, `vendor/`, `*.test.*`): resurfacing selection mechanics, presence and enforcement of the discard reason, existence of automatic reactivation, any context siloing.

### Phase 3 — Recommendation

Produce concrete parameters: eligibility criterion for resurfacing, cadence, share of randomness, reactivation condition, reason granularity. Tie each parameter to its thesis.

### Phase 4 — Conditional persistence

- **From an orchestrator**: return the result in Markdown, write nothing, **skip memorization**.
- **Standalone**: write `ideas/YYYY-MM-DD_szikra-slow-hunch-[topic].md` in the current project.

## Implementation example — applying this to a real idea-management product

What typically already exists, not to be reinvented:

- Resurfacing is often implemented as an "echo" feature with several forms: dormant, pair, anniversary, rejected-reason, random — the random form carries the serendipity share, and the rejected-reason form carries the adjacent possible.
- Reactivation of a discarded idea can be driven by a suggestion command; the reason is stored on the rejected status (UI label "Not retained").
- The personal/professional mix should go through a `context` field on ideas, not through separate spaces.
- A dormant-ideas banner or widget can expose sleeping ideas on the admin side.
- **A connection graph view is often explicitly out of scope for an early version**: don't presuppose it. The only inter-idea links that may already exist are a merge link (duplicate handling) and the pair form of the resurfacing mechanism.

## Fallback ⚠️

If the project's sources of truth are inaccessible, answer from theory alone while explicitly stating upfront: *"Theoretical recommendation not checked against the code's state."* Never claim what the product does today without having read it.

## Optional Input

- Targeted thesis (`slow-hunch` | `adjacent-possible` | `liquid-networks` | `all`)
- Scope (`personal` | `group` | `both`)
- Analyzed object (resurfacing mechanics, screen, data model, backlog item)
- Constraint (V1 only, no new table, no scheduled job…)
