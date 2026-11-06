---
name: taste
description: "Anti-slop framework for interfaces — 3 dials (Design Variance, Motion Intensity, Visual Density 1-10) + style selection among 50 active styles. Auto-invoke on: improve visual taste, generic interface, flat design, visual slop, lack of personality, glassmorphism style, brutalism, claymorphism, neumorphism, high-end, minimalist."
model: claude-sonnet-5
user-invocable: true
type: domain
priority: high
scope: frontend
dependencies: []
conflicts: []
argument-hint: "[variance <1-10>] [motion <1-10>] [density <1-10>] [style <name>] [audit-only]"
---

# Taste — Anti-Slop Design Framework

Improves the visual personality of an interface via three calibratable dials and a style repertoire.
Based on bocal-pol/taste-skill (fork of Leonxlnx/taste-skill).

> **Boundary with `impeccable`**: `taste` sets the stylistic ambition (where to go). `impeccable` verifies the result isn't slop (what to avoid). The two complement each other: taste sets the direction, impeccable checks the result.

## Optional Input (if invoked from `design-agent` or `ux-designer`)

If dials and the target style are provided (from `DESIGN.md`), skip Phase 1 and apply directly in Phase 2.

## The 3 dials

### Design Variance (1-10)
**1** = conventional layouts, strict grid, zero surprise
**5** = a few distinctive elements, slightly asymmetric composition
**10** = experimental, broken grid, unusual compositions, expressive typography

### Motion Intensity (1-10)
**1** = no animation, instant transitions
**5** = standard interaction feedback (hover, focus, toast) — 150-300ms ease-out
**10** = kinetic — scroll-driven, staggered entrances, morphing, multi-layer parallax

### Visual Density (1-10)
**1** = lots of white space, one idea per screen, airy typography
**5** = standard dashboard density — balanced information + breathing room
**10** = very dense, small typography, tight grid, maximum info per cm²

## Available styles (50 active)

**Glassmorphism** — transparency, backdrop blur, semi-opaque borders
**Claymorphism** — puffy shapes, soft colored shadows, pastel colors
**Brutalism** — strong black/white, massive type, no drop shadow, thick borders
**Neumorphism** — subtle embossing, monochromatic palette, inner/outer shadows
**Minimalist-UI** — one accent, dominant typography, maximal whitespace
**High-End Visual Design** — italic serif typography, earthy palette, full-page photography
**Industrial Brutalist UI** — metallic textures, condensed typography, grey/orange palette
**Stitch Design** — stitching, textile materials, warm and handcrafted
**Futurism** — thin lines, neon cyan/magenta palette, scanlines
**Organic** — biomorphic shapes, natural palette, handwritten typography
**Corporate Flat** — extended Material Design, systematic z-index shadow, bright colors
**Retro/Vaporwave** — pink-purple-cyan 80s palette, perspective grid, noise
**Dark Premium** — near-black background (#0a0a0a), gold/silver accents, light typography
**Swiss International** — strict grid, Helvetica/Neue Haas, red and black
**Coquette** — ribbons, powder pink, fine serif, floral ornaments
**Techy/Dev** — monospace, terminals, syntax highlighting, dark background
*(+ 34 additional styles in the full repertoire)*

## Workflow

### Phase 1 — Current state assessment

Read `DESIGN.md` at the project root (if present) — retrieve the `taste:` section:

```yaml
taste:
  variance: 5
  motion: 4
  density: 4
  style: minimalist-ui
```

If absent or dials undefined, collect via AskUserQuestion:

```
Taste dial calibration:

1. Design Variance (1-10, default 5):
   Toward 1 = predictable layouts | Toward 10 = experimental/surprising

2. Motion Intensity (1-10, default 4):
   Toward 1 = static | Toward 10 = kinetic/scroll-driven

3. Visual Density (1-10, default 4):
   Toward 1 = airy/minimalist | Toward 10 = dense/compact

4. Target style (optional, leave blank if undefined):
   glassmorphism / claymorphism / brutalism / neumorphism /
   minimalist-ui / high-end / industrial-brutalist / stitch /
   futurism / organic / dark-premium / swiss / retro / techy / ...

5. Project Surface-mode:
   [ ] Persuade  [ ] Operate  [ ] Read  [ ] Experience
```

### Phase 2 — Reading the target

Read the UI files to improve via Glob + Read. Exclude `node_modules/`, `vendor/`, `*.test.*`.

If no target is specified, work on the most representative component (landing / hero / main dashboard).

### Phase 3 — Per-dial adjustments

Apply transformations according to target values. Each adjustment starts from the delta between current state and target.

**Design Variance → Target ≥ 7:**
- Break the symmetric grid in at least one section (column offset, clip-path)
- Use expressive typography for headings (weight 900, variable font, or unexpected serif)
- Introduce an element laid out "outside" the grid (absolute-positioned decoration)
- Rotate some text or elements (`transform: rotate(-2deg)`)

**Design Variance → Target ≤ 3:**
- Reinforce strict alignment (rigid 12-column grid)
- Limit colors to 2 + neutral
- Remove any non-functional decoration

**Motion Intensity → Target ≥ 7:**
- Add scroll-driven animations (`animation-timeline: view()` or GSAP ScrollTrigger)
- Stagger lists (150ms between elements)
- Parallax on background elements (translateY / scale based on scrollY)
- Page transitions: fade + slide 200ms ease-out

**Motion Intensity → Target ≤ 2:**
- Remove all transitions except immediate feedback ones (≤ 100ms)
- Keep only: hover button, focus ring, toast appear

**Visual Density → Target ≥ 7:**
- Reduce section padding to ≤ 32px
- Body font size 13-14px with line-height 1.4
- 4+ column grid on desktop
- Compact tables and lists with no row gap

**Visual Density → Target ≤ 3:**
- Section padding ≥ 80px
- Body 18-20px with line-height 1.7
- Max 1 interactive element above the fold
- Generous white space between each block

### Phase 4 — Style application

If a target style is defined, apply its visual characteristics:

**Glassmorphism:**
```css
background: rgba(255, 255, 255, 0.1);
backdrop-filter: blur(16px);
border: 1px solid rgba(255, 255, 255, 0.2);
box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
```
⚠️ Never apply on a white background — requires a colored/gradient backdrop.

**Brutalism:**
- Pure white (#ffffff) or black (#0a0a0a) background
- Ultra-bold condensed typography (weight 900, font-stretch: condensed)
- 2-4px black borders with no border-radius
- Zero box-shadow, zero gradient

**Dark Premium:**
- Background `#0a0a0a` (not pure black)
- Golden accents `oklch(80% 0.15 85)` or silver `oklch(75% 0.02 240)`
- Light typography (weight 300) for body, regular for headings
- Micro-details: separators `1px solid rgba(255,255,255,0.08)`

**Minimalist-UI:**
- Palette: 1 accent color + white + neutral grey
- Typography as architecture: hierarchy via size, not color
- Perfectly flat surface (0 shadow, 0 gradient, 0 excessive border-radius)

For other styles: apply the style's characteristic patterns (textures, palettes, associated typography).

### Phase 5 — Anti-slop verification (via impeccable)

After application, call the `impeccable` skill with the `audit` command on the modified files.

If `impeccable` is unavailable: manually check the 8 critical AI-slop rules:
- ❌ Purple-to-blue gradient
- ❌ Bounce/elastic easing on nav
- ❌ Inter/Arial with no personality
- ❌ Gray text on colored background
- ❌ Pure (untinted) black/grey
- ❌ Card nesting ≥ 3 levels
- ❌ Grey text (#808080) on white
- ❌ Single full-rounded purple button on white background

### Phase 6 — Update DESIGN.md

Write or update the `taste:` section in `DESIGN.md`:

```yaml
## Taste

```yaml
taste:
  variance: <value>
  motion: <value>
  density: <value>
  style: <style-name>
  updated: YYYY-MM-DD
```
```

### Phase 7 — Conditional persistence

- **If invoked from `design-agent`**: return the adjustments in Markdown, don't write a report.
- **If invoked standalone**: return the adjustments inline in the conversation + update `DESIGN.md`.
