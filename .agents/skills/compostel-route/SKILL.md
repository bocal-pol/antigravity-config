---
name: compostel-route
description: "Splits the Camino de Santiago into daily stages by leg. Produces distances, elevation gain, GPX waypoints, route crossings. A generalized worked example (from a Belgium-to-Spain route) illustrates the method; substitute your own leg's towns and itinerary."
model: claude-sonnet-5
type: framework
priority: high
scope: cross
dependencies: []
conflicts: []
---

# Compostel Route — Stage Mapping

Splits the route into reasonable daily stages, with estimated elevation gain, main waypoints, and
GPX references. Each stage should suit a walker who already has 200-500 km in their legs (gradual
ramp-up at the start of a leg).

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **15-22 km days** | 25 km max at peak fitness, never two 25 km days in a row |
| **Ramp-up** | The first 3 days of a leg = short stages (12-16 km) |
| **Elevation matters** | +500 m of ascent = -3 km of equivalent distance |
| **Waypoints, not tracks** | Generate waypoint GPX files (towns, water points, lodging) — continuous tracks come from official sources |
| **Official waymarking** | Shell + yellow arrow; refer to the relevant association for waymarking freshness |

## Workflow

### Phase 1 — Parameters

Collect via AskUserQuestion if not provided:
1. Leg (by country or region)
2. Specific route if several options exist (e.g. one historic variant vs. another)
3. Target pace (relaxed 15-18 km/day | standard 18-22 km/day | fast 22-27 km/day)
4. Desired rest days (0 | 1 per week | 2 per week)

### Phase 2 — Master table

Produce the stage table with, for each day:

| Column | Content |
|---------|---------|
| Day | D01, D02… |
| From → To | Start and end towns |
| Distance | km, rounded |
| Elevation | +xxx m / -xxx m estimated |
| Route | Name of the route/variant |
| Expected night | Type (lodging/wild camp) + suggestion |
| Key POI | 1 single major point, to avoid overload |

### Phase 3 — Detailed stage sheets

One sheet per stage in `stages/DXX_town-town.md`, or a single compact
`stages/stages-<leg>.md`. Each sheet contains:

- Route description (scenery, difficulties, technical sections)
- Waymarking to follow
- Known water points (fountains, cemeteries, cafés)
- Shortcut / extension options for bad weather
- Where to eat (cross-reference with `compostel-food`)
- Where to sleep (cross-reference with `compostel-lodging`)
- What to see (cross-reference with `compostel-poi`)

### Phase 4 — GPX

Generate `gpx/waypoints-<leg>.gpx` — waypoints for the stage towns + notable points in GPX 1.1
format (readable in Komoot, Locus, Gaia, Garmin).

XML structure:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="compostel-route" xmlns="http://www.topografix.com/GPX/1/1">
  <wpt lat="LAT" lon="LON">
    <name>NAME</name>
    <desc>DESC + cumulative distance</desc>
    <sym>Waypoint</sym>
  </wpt>
  ...
</gpx>
```

Also produce `gpx/README.md` with:
- Explanation: these GPX files are waypoints, NOT tracks
- Links to official sources for downloading continuous tracks — look up the relevant national
  Camino association and hiking-federation GR/GPX sources for your leg

### Phase 5 — Cross-references

Verify the deliverables are consistent with the other skills:
- Every stage has a lodging suggestion → see `compostel-lodging`
- Every stage has a meal suggestion → see `compostel-food`
- Every stage has a POI → see `compostel-poi`

## Worked example — Illustrative leg

The structure below shows the expected shape of a stage table; replace the towns, distances, and
points of interest with your own leg's actual route before use — this is a generic placeholder,
not a validated itinerary.

| D | From → To | Km | D+ | Night type | Key POI |
|---|--------|-----|-----|-----------|---------|
| 1 | Town A → Town B | 20 | 200 | Pilgrim hostel | Romanesque church |
| 2 | Town B → Town C | 18 | 150 | Parish donativo | Historic collegiate |
| 3 | Town C → Town D | 22 | 250 | Legal wild camp | River valley viewpoint |
| 4 | Town D → Town E | 15 | 100 | Municipal hostel | Citadel |

## Fallback

If the user wants an adjustment (injury, bad weather, wanting to linger somewhere): propose a
rebalancing (merging short stages, splitting long ones, a rest day).

## Optional input

- Leg (by country or region)
- Specific route variant
- Pace (`relaxed` | `standard` | `fast`)
- Constraint (`with child`, `knee injury`, `weekends only`)
