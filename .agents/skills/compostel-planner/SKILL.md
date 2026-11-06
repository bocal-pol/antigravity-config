---
name: compostel-planner
description: Orchestrator for a long-distance Camino de Santiago pilgrimage project. Coordinates the compostel-* skills (route, gear, lodging, food, poi, prep) to produce a complete, coherent travel plan. Parameterizable by leg. Invoke via /compostel-planner [leg].
model: claude-sonnet-5
type: orchestrator
priority: high
scope: cross
dependencies:
  - compostel-route
  - compostel-gear
  - compostel-lodging
  - compostel-food
  - compostel-poi
  - compostel-prep
conflicts: []
---

# Compostel Planner — Pilgrimage Orchestrator

Coordinates the full preparation of a complete, multi-leg Camino de Santiago pilgrimage. A journey
of this kind typically splits into several legs by country or region, each with its own route,
distance, and waymarked paths — substitute your own leg breakdown, distances, and route names
before use.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Whole-journey vision** | Every decision (pack, shoes, health) is calibrated for the full distance, not just the current leg |
| **Progressiveness** | Stages grow in distance over time (short days at the start of each leg, longer once in shape) |
| **Legal wild camping** | Always verify legality — delegate to a local legal/compliance skill or official sources depending on jurisdiction |
| **Solo/Duo dual variant** | Pack weight and calories are presented in two configurations when relevant |
| **GPX honesty** | Generated waypoints are fine; continuous tracks → refer to official sources (never invent a track) |

## Workflow

### Phase 1 — Context

Collect via AskUserQuestion if not provided:
1. Leg to prepare
2. Season / estimated departure date
3. Configuration: Solo | Duo
4. Desired wild-camp/lodging ratio (100% wild camp | 50/50 mixed | lodging priority)

### Phase 2 — Project mapping

Read existing deliverables if any:
- `travel-plan-<leg>.md`
- `overview-full-route.md`
- `stages/`, `gear/`, `lodging/`, `food/`, `poi/`, `prep/`

Identify what already exists (don't rewrite it), what needs updating, what's missing.

### Phase 3 — Delegation to specialized skills

Invoke in this logical order (each skill produces its own deliverables):

1. **`compostel-route`** → `stages/` + `gpx/`: stage breakdown, distances, waypoints
2. **`compostel-poi`** → `poi/heritage-<leg>.md`: cross-referenced with the stages to integrate
   visits
3. **`compostel-lodging`** → `lodging/notebook-<leg>.md`: cross-referenced with the stages to
   validate overnight points
4. **`compostel-food`** → `food/notebook-<leg>.md` + specialties: cross-referenced with the
   stages for resupply
5. **`compostel-gear`** → `gear/inventory.md`: weighed list, solo + duo (mostly leg-independent)
6. **`compostel-prep`** → `prep/`: physical fitness, credential, foot health, weather, budget
   (cross-cutting)

### Phase 4 — Consolidation

Produce two master files:

**`overview-full-route.md`** (project root) — whole-journey view:
- Recap of each leg with distance and duration
- Turning points (border crossings, shoe replacement, medical milestones)
- Overall budget and gear progression

**`travel-plan-<leg>.md`** (project root) — current leg summary:
- Master stage table (day, from → to, distance, elevation, planned night, key POI)
- Links to each detailed sheet in `stages/`
- Pack summary (solo / duo weight)
- Next actions (obtain credential, order missing gear, test shoes)

### Phase 5 — Final report

Display to the user:
- The tree of produced files
- Remaining manual actions (official GPX downloads, bookings, purchases)
- Suggestions for future sessions: `/compostel-gear` to adjust after a field test,
  `/compostel-planner <next-leg>` as the next leg approaches

## Fallbacks

- If a child skill is unavailable → display `⚠️ compostel-<name> unavailable — deliverable
  skipped, to produce manually or in a future session`
- If supporting agents don't respond → the child skills must produce baseline content without
  them (a degraded mode documented in each skill)

## Optional input

Can receive as input:
- A leg
- A focus (`gear` | `route` | `lodging` | ...) to relaunch only part of the plan
- A special constraint (injury, tight budget, fixed dates)
