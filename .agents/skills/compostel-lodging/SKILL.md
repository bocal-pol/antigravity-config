---
name: compostel-lodging
description: Pilgrim lodging — pilgrim hostels, donativos, youth hostels, refuges + legal wild camping by country. Delegates legality questions to a local legal/compliance skill depending on jurisdiction.
model: claude-sonnet-5
type: framework
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Compostel Lodging — Where to Sleep Along the Way

Produces `lodging/notebook-<leg>.md` with, for each stage: lodging options, rates, contacts, legal
wild-camping rules.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Three families** | Pilgrim hostel / donativo — commercial refuge/youth hostel — legal wild camp |
| **Strict legality** | Wild camp only in authorized zones, never private forest without permission |
| **Fresh contact info** | Phone numbers + hours + booking when needed; mention the verification date |
| **Default 50/50 mix** | Alternate indoor/outdoor nights for rest and hygiene |
| **Fallback options** | Always mention a plan B (hostile weather, hostel closed) |

## Workflow

### Phase 1 — Parameters

Collect via AskUserQuestion if not provided:
1. Leg
2. Desired wild-camp / lodging ratio (100% wild camp | 50/50 | 25/75 | 100% lodging)
3. Nightly budget: donativo (€5-15) | hostel (€15-25) | comfort lodging (€25-40) | no constraint
4. Desired comfort: spartan | shower priority | wifi essential | shared meal

### Phase 2 — Survey by stage

For each stage (cross-referenced with `compostel-route`):

```
### DXX — Town X (arrival after km)

**Recommended pilgrim hostel**
- Name: [Name]
- Address: [Address]
- Contact: [Phone] · [Email]
- Rate: [€ or donativo]
- Beds: [number]
- Shower · Wifi · Kitchen · Credential stamp: ✅/❌
- Note: [arrival hours, languages, specifics]

**Alternative hostel / youth hostel**
- ...

**Nearby legal wild camp**
- Zone: [name + approximate GPS]
- Legal framework: [local legal/compliance skill for your jurisdiction, or an official source]
- Distance from the hostel: [X km before/after]
- Water: [a source or fountain within 1 km]
- Note: [risks, views, quiet]

**Plan B**
- [If full, if closed, if heavy rain]
```

### Phase 3 — Legal wild-camping framework

**Delegate to a jurisdiction-appropriate legal/compliance skill** with the brief:
- Context: a long-distance pilgrimage along a specific route
- Question: where can one legally wild camp along this leg (public forests, marked areas, farm
  camping)
- Requested format: a short legal memo (Legal Framework / Risk / Action Plan / Field Note)

General principles across jurisdictions typically worth checking:
- National/regional forestry or environmental codes on bivouacking (often: tolerated from dusk to
  dawn outside restricted zones — nature reserves, fire-risk areas, listed sites)
- Local forestry-authority or national-park rules may differ from general law
- Some regions ban wild camping almost entirely and rely instead on a dense network of
  municipal/parish/private hostels (donativo, low-cost, or private) as the default lodging answer

### Phase 4 — Cross-references

- Verify every `compostel-route` stage has **at least two options** (hostel + wild camp, or
  hostel + hostel)
- Flag to `compostel-planner` any at-risk days (no lodging within 30 km)
- Mention days where wild camping is **impossible** (strict ban, dense urban area) → force lodging

## Worked example — Illustrative leg

The table below shows the expected shape of a lodging survey; replace with your own leg's actual
options before use — this is a generic placeholder, not verified lodging data.

| Stage | Main hostel | Type | Contact type | Wild-camp tolerance |
|-------|----------------|------|--------------|-------------------|
| Town A | Youth hostel | Youth hostel | Online booking | No |
| Town B | Parish hostel | Donativo | Local parish | River bank tolerated (discreet) |
| Town C | Pilgrim association hostel | Pilgrim hostel | Local association | Municipal campsite |

⚠️ Contacts and availability change — **verify 2 weeks before departure**.

## Fallback

If the delegated legal skill is unavailable → use the relevant national forestry/environment
authority's public guidance on bivouacking directly, and explicitly cite "source not re-verified,
check with the local authority before departure".

## Optional input

- Leg
- Wild-camp/lodging ratio
- Special constraint: "no dormitory" / "solo woman" / "dog" / "no religious lodging"
