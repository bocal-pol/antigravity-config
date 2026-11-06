---
name: compostel-poi
description: "Points of interest along the Camino de Santiago — religious heritage, civil heritage (fortifications, castles), notable landscapes, natural curiosities. Helps avoid missing anything between two stages. A generalized worked example illustrates the method; substitute your own leg's sites."
model: claude-sonnet-5
type: framework
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Compostel POI — What to See Along the Way

Catalogs notable points along the route, categorized and linked to their stage.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **On the route or within ≤ 1 km** | Don't suggest a detour > 3 km except for a major exception |
| **UNESCO / listed priority** | Flag World Heritage sites, historic monuments, major fortifications |
| **Verifiable opening hours** | Mention known hours + closing day (to be verified by the user before visiting) |
| **Wonder > exhaustiveness** | 1-3 POIs per stage, not 15 |
| **Pilgrim-friendly** | Flag churches that stamp the pilgrim credential, miraculous fountains, pilgrim-themed stained glass |

## Workflow

### Phase 1 — Parameters

Collect via AskUserQuestion if not provided:
1. Leg (by country or region)
2. Focus: religious priority | civil/history | nature/landscapes | mixed

### Phase 2 — Catalog by stage

Produce `poi/heritage-<leg>.md` with, for each stage:

```
### DXX — Town X

**Religious monument**
- Name + century
- What to see (rose window, tympanum, crypt, pilgrim relic, carved shell)
- Hours + known closing day
- Credential stamp available: ✅/❌

**Civil monument**
- Name + interest (fortification, town hall, covered market)

**Notable landscape**
- Viewpoint + orientation + ideal time (morning/evening)

**Local curiosity / secret**
- Something a casual tourist misses (hidden fresco, fountain, side path, artisan workshop)
```

### Phase 3 — Thematic threads

Also produce a cross-cutting reminder (recurring threads) at the top of the document:

- **Romanesque/Gothic thread**: river valleys often hold remarkable Romanesque churches
- **Fortification thread**: star forts, citadels, military heritage along the way
- **Legends thread**: local folklore tied to specific landmarks
- **Water thread**: pilgrim-associated springs and miraculous fountains

## Worked example — Illustrative leg

The structure below shows the expected shape of a POI catalog entry; replace with your own leg's
actual sites before use.

### D1 · Town A
- **Cathedral** (13th c.) — treasury + reliquary, stamp available at the sacristy
- **Historic market square** — symbol of civic liberties
- Curiosity: old town quarter, local tavern

### D4 · Town D
- **Citadel** — one of the largest in the region, panoramic views at the river confluence
- **Fine arts museum**
- **Cathedral** (18th c., classical style) + treasury

## Fallback

No external dependency — if hours information changes, add a disclaimer "to be verified by the
user, database last checked YYYY".

## Optional input

- Leg
- Focus (religious | civil | nature | mixed)
- Detail level (compact 1 per stage | standard 3 per stage | exhaustive)
