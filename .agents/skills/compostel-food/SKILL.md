---
name: compostel-food
description: Resupply + regional specialties + hiking menus for a Camino de Santiago pilgrimage. Crosses the kcal/day logic (3000-3500) with gastronomic discovery. Delegates to a game-master-style skill for bivouac recipes and cultural specialties.
model: claude-sonnet-5
type: framework
priority: high
scope: cross
dependencies: []
conflicts: []
---

> **Associated agent**: this skill is designed to be routed by a game-master-style agent, which
> brings the domain framework. It remains invocable alone, but the answer will be less
> contextualized. This relationship doesn't go through `dependencies:`, which only references
> skills or MCPs.

# Compostel Food — Eating Along the Way

Combines three threads:

1. **Kcal** — 3000-3500 kcal/day/person (20 km walking with a 10 kg pack), digestible, high
   caloric density
2. **Resupply** — where to shop along the route (markets, grocers, bakeries)
3. **Regional** — local specialties to discover (delegated)

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Caloric density** | Prioritize at least 400 kcal/100g for carried food (dried fruit, nuts, dark chocolate, cured meat, hard cheese) |
| **One hot meal/day** | At least in the evening (morale + muscle recovery) |
| **Discovery when possible** | One specialty per main stage town |
| **Food safety** | Don't carry raw meat >6h; filter water for raw produce if the source is questionable |
| **Controlled cost** | €10-15/day/person average at the grocery store; restaurant splurges in town only |

## Workflow

### Phase 1 — Parameters

Collect via AskUserQuestion if not provided:
1. Leg
2. Configuration (Solo | Duo)
3. Diet: omnivore | vegetarian | vegan | gluten-free | other allergy
4. Daily food budget

### Phase 2 — 3-day sample menu (practical hiking)

Produce a reproducible sample menu plan:

```
### Standard day (20 km, 10 kg pack)

Breakfast (500-700 kcal)
- Oat porridge 80 g + dried fruit 50 g + nuts 30 g
- Or: bread 100 g + jam 30 g + cheese 40 g
- Instant coffee/tea

Morning snack (250 kcal)
- Cereal bar OR 30 g 70% dark chocolate + 30 g almonds

Cold lunch (600-800 kcal)
- Bread 150 g + cured meat 60 g + hard cheese 60 g + 1 tomato + 1 fresh fruit
- Or a cold wrap: tortilla + hummus + raw vegetables + cheese

Afternoon snack (250 kcal)
- Dried fruit 60 g + plain biscuits

Hot dinner (900-1200 kcal)
- Pasta/semolina/rice 150 g dry + olive oil 15 g + sun-dried tomatoes 30 g + parmesan 40 g + herbs
- Or precooked lentils + onions + oil
- Dessert: a fruit compote pouch + 2 chocolate squares

TOTAL: ~3000 kcal
```

### Phase 3 — Resupply by stage

Produce `food/resupply-notebook-<leg>.md` — one entry per stage with:

```
### DXX — Town X

**Market** (day + hours)
**Bakery**: name + hours
**Grocery / Supermarket**: chain + hours
**Fountain / water point**: location
**Recommended restaurant** (local specialty)
**Smart buy**: (local cheese, artisanal cured meat, a frozen local specialty to reheat, etc.)
```

### Phase 4 — Regional specialties

Delegate to the game-master-style skill with a brief:
- Context: a pilgrimage, gastronomic discovery while walking
- Requested format: per stage town, 1 to 3 signature specialties + where to try them + season +
  cost
- Tone: appetite-driven, cultural, inviting

Consolidate into `food/specialties-<region>.md`.

### Phase 5 — Resupply ration per stage

Calculate for each stage leg (between two towns with a grocery store):

```
Leg DXX → DXX+1
- Distance: XX km
- Meals to cover: D1 dinner + D2 breakfast + D2 lunch (if D2 has a grocery store)
- Resupply to do: at the market/grocery store in DXX
- Ration weight: ~800 g per person · per day
- Cost: ~€12-15 per person · per day
```

## Worked example — Illustrative specialties table

The table below shows the expected shape of a specialties catalog; replace with your own leg's
actual towns and dishes before use.

| Town | Signature specialties | Where |
|-------|---------------------------|-----|
| Town A | Local stew, a regional pastry | Historic café, Sunday market |
| Town B | A regional cheese tart, local syrup | Town-center bakeries, local grocers |
| Town C | A river fish dish, a local beer | Riverside brasseries |

## Fallback

If the delegated skill is unavailable: produce a simplified version based on the specialties
listed above, without detailed recipes.

## Optional input

- Leg
- Diet
- Configuration (solo/duo)
- Daily budget
- Focus: "specialties only" | "resupply only" | "7-day menus"
