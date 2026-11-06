---
name: compostel-gear
description: Weighed backpack list for a long-distance Camino de Santiago pilgrimage with wild camping. Two variants (Solo, Duo). Base weight targets ≤ 8 kg solo / ≤ 6.5 kg per person in duo. Durability, repairability, and planned consumable replacement over a multi-month trip. Delegates to a survival-logistics skill for the Rule of 3 and kcal calculation.
model: claude-sonnet-5
type: framework
priority: high
scope: cross
dependencies: []
conflicts: []
---

> **Associated agent**: this skill is designed to be routed by a survival-logistics agent, which
> brings the domain framework. It remains invocable alone, but the answer will be less
> contextualized. This relationship doesn't go through `dependencies:`, which only references
> skills or MCPs.

# Compostel Gear — Ultra-Long Pilgrim Backpack

Generates a **weighed**, **categorized** gear list calibrated for a multi-month, long-distance
trek. Priority: durability and weight. Any added item must be justified by the Rule of 3 or by the
pilgrimage mission itself (20 km/day walking for 4 months straight).

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Base weight ≤ 8 kg solo** | Excluding water + food + daily consumables |
| **Multi-month durability** | High-end broken-in shoes; reinforced pack; not the cheapest tent |
| **Repairability** | Sewing kit, fabric tape, Tenacious Tape, Aquaseal glue |
| **Planned replacement** | A 2nd pair of shoes planned partway through; spare pilgrim credentials |
| **Duo pooling** | One tent for two, one stove for two, one cookset for two → ~1.5 kg saved per person |
| **Mandatory field test** | A 25 km outing with the loaded pack before the official departure |

## Workflow

### Phase 1 — Parameters

Collect via AskUserQuestion if not provided:
1. Configuration: Solo | Duo (generate both if requested)
2. Departure season
3. Gear budget: tight (< €1000) | medium (€1000-2000) | comfort (> €2000)
4. Gear already owned (audit): yes + list | no, starting from scratch

### Phase 2 — Delegation to survival logistics

Invoke the survival-logistics skill with the brief:
- Mission: a multi-month, long-distance pilgrimage, wild camping ~50% of nights
- Max weight: 12 kg total (8 kg base + water + day food)
- Configuration: solo and/or duo

Retrieve its weighed list by tier (Rule of 3) and its kcal calculation.

### Phase 3 — Categorization

Produce `gear/inventory.md` with 10 categories:

1. **Carrying** — pack, hip belt, whistle
2. **Sleep system** — tent/tarp, sleeping pad, sleeping bag
3. **Kitchen** — stove, cookset, spoon, water bottle
4. **Water** — capacity + filtration
5. **Walking clothes** — t-shirts, trousers, socks, shoes
6. **Camp clothes** — night change + fleece
7. **Rain/cold clothes** — hardshell, light gloves, beanie
8. **Hygiene + LNT** — soap, toothbrush, towel, trowel, paper
9. **Health** — first-aid kit + foot-care kit (pilgrimage-specific)
10. **Nav + admin** — phone, battery, maps, credential, ID, cash

For each item:
- Name + suggested brand
- Weight (grams) actual or estimated
- Indicative price
- Expected durability (km or months)
- Solo | Duo (pooled | ×2 | unchanged)
- Note (break-in required, purchasable en route, etc.)

Totals:
- Solo: base weight, fully-loaded weight (with 2L water + 1500 kcal), planned replacement.
- Duo: same, with pooling made explicit.

### Phase 4 — Pre-departure check

Produce `gear/pre-departure-check.md` — a D-30 checklist:

- [ ] Shoes broken in ≥ 100 km
- [ ] Pack tested loaded over 25 km
- [ ] Tent pitched and struck 5 times
- [ ] Stove lit at least 3 times
- [ ] Water filtration verified
- [ ] Credential obtained
- [ ] Travel health insurance card
- [ ] Emergency numbers saved + on paper
- [ ] Will / power of attorney if a long trip ← legal reminder
- [ ] Repatriation insurance subscribed
- [ ] Vaccinations up to date (tetanus)
- [ ] Long-term prescriptions packed (chronic conditions)

### Phase 5 — Consumables and en-route replacement

Plan in `gear/inventory.md` a "To rebuy en route" section:

- **2nd pair of shoes**: around 1500-2000 km in
- **Socks**: 500-800 km/pair → plan 2 spare pairs shipped ahead to a post-restante point
- **Blister pads**: restock at each major town
- **Gas canister**: can't fly with one — rebuy at each flight/train leg; on foot, replace every
  15-20 days
- **Pilgrim credentials**: rebuy at each major waypoint town along the route

## Fallback — If the survival-logistics skill is unavailable

Produce the list directly with these reference values (hiking market, recent years):

**Solo Pack — Target base weight 7.5 kg:**
- Carrying: a ~48L ultralight pack (1150 g)
- Tent: a 1-person ultralight tent (1050 g)
- Pad: an ultralight inflatable pad (350 g)
- Sleeping bag: an ultralight quilt/bag, +5°C comfort (500 g)
- Gas stove: a canister stove (73 g) + canister (180 g full)
- Cookset: a 750 mL titanium pot (100 g)
- Shoes: trail shoes or light hikers (~800 g/pair) — worn, not packed
- Poles: carbon trekking poles (300 g/pair)
- Clothes worn outside the pack (shoes, trousers, t-shirt, hat)
- Clothes in the pack: 1 t-shirt + 1 change + a light fleece + a hardshell (~800 g)
- Water: a 2L reservoir + a squeeze filter (170 g)
- First aid: ~250 g
- Nav/admin: phone + a power bank (180 g) + cables + credential + papers (~500 g)

**Duo Pack — 6.5 kg per person** = pooled tent (2-person instead of 2×1-person), single stove,
shared 1.3 L cookset, one main first-aid kit + a light personal kit per person.

## Optional input

- Configuration (`solo` | `duo` | `both`)
- Season
- Constraint (`tight-budget`, `bad-back`, `100%-wild-camp`)
- Existing gear (audit)
