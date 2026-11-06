---
name: compostel-prep
description: Cross-cutting preparation for a long-distance Camino de Santiago pilgrimage — physical fitness, pilgrim credential, foot health, weather/season, overall budget. Valid for the whole journey to Santiago.
model: claude-haiku-4-5-20251001
type: utility
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Compostel Prep — Cross-Cutting Preparation for a Long Camino

A mechanical skill producing five short, actionable sheets. Stable content, infrequently updated,
hence the Haiku choice.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Whole-journey vision** | Every piece of advice targets holding up over 4-5 months of walking, not just the first leg |
| **Actionable** | Each sheet ends with a dated checklist (D-90, D-60, D-30, D-7) |
| **Concrete numbers** | Kcal, costs, dates, distances — never vague |

## Workflow

### Phase 1 — Context

Read the project context if present (`travel-plan-<leg>.md`, `overview-santiago.md`) to align
dates and parameters.

### Phase 2 — Generate the 5 sheets

Create the `prep/` folder and write five files:

1. **`prep/physical-fitness.md`** — a 12-week training plan before departure, progressive outings
   5→25 km with a pack, back + core strengthening, ankle mobility, RPE scale
2. **`prep/credential-and-papers.md`** — pilgrim credential, where to obtain it at the start,
   spare credentials for a long route, the Compostela certificate at Santiago, travel health
   insurance, emergency contacts, power of attorney, will (for a long trip)
3. **`prep/foot-health-pharmacy.md`** — a weighed, detailed first-aid kit, feet (breaking in
   shoes, blisters, nails, technical socks), joints (knee/ankle), thermoregulation
   (heatwave/hypothermia), local plants worth knowing
4. **`prep/weather-season.md`** — optimal departure window, temperature projections by leg,
   seasonal risks, useful offline weather apps
5. **`prep/budget.md`** — budget per leg + overall budget, expense sources (lodging, groceries,
   restaurants, local transport, replacement gear), money-saving tips, cash vs. card budget

### Phase 3 — Summary checklist

At the end, produce a consolidated checklist `prep/checklist-d-x.md`:

```markdown
# Checklist D-x before departure

## D-90 (3 months)
- [ ] Firm departure date decided
- [ ] Pack + tent + shoes purchased
- [ ] Training started, 3 outings/week
- [ ] Pilgrim credential obtained

## D-60 (2 months)
- [ ] 15 km outings with a loaded pack
- [ ] Stove + tent tested
- [ ] Tetanus vaccination checked
- [ ] Repatriation insurance subscribed

## D-30 (1 month)
- [ ] 25 km test outing with a full pack
- [ ] Shoes broken in ≥ 100 km
- [ ] Emergency numbers in phone + on paper
- [ ] Chronic-condition prescriptions packed

## D-7
- [ ] D-7 weather checked
- [ ] Day 1-2 supplies bought
- [ ] Day 1 lodging confirmed (if booked)
- [ ] Family contact — communication plan

## D-1
- [ ] Pack weighed one last time (≤ 12 kg)
- [ ] Shower + nails + clean socks
- [ ] Carb-rich meal (pasta)
- [ ] Early to bed
```

## Fallback

No external dependency. Self-contained content based on national hiking-federation and pilgrim-
association recommendations.

## Optional input

- Planned departure date (to calibrate the D-x markers)
- Starting fitness level (sedentary | occasionally active | regularly athletic)
- Known medical constraints
