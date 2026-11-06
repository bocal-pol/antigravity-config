---
name: spotify-playlist-cover
type: style
created: 2026-08-15
last_used: 2026-08-15
tags: [spotify, playlist, illustration, flat-cartoon, retro, 70s]
compatible_with: [z-image-turbo, flux, midjourney-v6, sdxl]
---

# Spotify Playlist Cover — Master template

## Identity
- Type: style
- Description: Spotify playlist covers as flat retro-70s cartoon illustrations. Solid background by genre/situation, stereotyped bust-level character, Spotify logo + name in cream.
- Usage context: use alongside the `spotify-playlist-catalog.md` catalog. Provide the playlist name → catalog lookup → prompt → HF generation.

## Visual DNA

### Invariant elements ⚠️ NON-NEGOTIABLE

| Element | Value |
|---|---|
| Format | 1:1 square, 1024×1024 |
| Drawing style | Flat 2D cartoon illustration, thick brown-black outline, minimal shading, slightly rough rendering (not 100% clean vector) |
| Style palette | Muted/earthy colors — no bright saturated colors |
| Skin tone | Warm sand (~#C8956C), chocolate-brown shadows |
| Text color | Cream beige (#E8D5B7) |
| Font | Bold rounded/condensed uppercase, occupies ~30% of the canvas height |
| Spotify logo | Small circle with 3 horizontal waves, cream (#E8D5B7), top-left corner (~8% of width) |
| Framing | Bust: head + shoulders + upper torso, centered, cropped at mid-chest |
| Background | Solid flat color, very light grain allowed — no gradient |
| Overall rendering | Retro 70s/80s poster, vintage editorial illustration |

### Variable elements (from the catalog)

| Variable | Source |
|---|---|
| `{GENRE_NAME}` | Playlist name in uppercase |
| `{BG_COLOR}` | Hex or description of the background color |
| `{CHARACTER}` | Description of the character archetype |
| `{PROP}` | Optional prop/utensil — empty if none |

### Prop rule
Rare addition, only if the utensil is strongly identity-defining:
- ✅ Headphones → Trip Hop, Ambient, Lo-Fi
- ✅ Spatula/ladle → Cooking
- ✅ Book → Reading
- ✅ Coffee cup → Work/Focus
- ❌ Generic or decorative prop → always omit

## Positive Prompt (base block)

```
flat 2D cartoon illustration, retro 70s poster art style, editorial illustration,
{CHARACTER}, {PROP},
cropped at upper chest level, centered composition,
solid flat {BG_COLOR} background, no gradient,
warm sandy skin tone #C8956C, thick dark brown-black outlines, slightly rough hand-drawn quality,
muted earthy color palette, minimal flat shading, no 3D rendering,
cream beige bold uppercase condensed text "{GENRE_NAME}" top left area,
small circular spotify logo with 3 horizontal waves top left corner cream color #E8D5B7,
square format 1:1, full-bleed image with no border and no frame,
the character has a full head of hair with a clearly drawn hairstyle (color and shape), definitely not bald, scalp fully covered with hair
```

⚠️ **Always include**:
- The illustration must fill the entire frame (full-bleed), **with no border or frame** around the image ("no border, no frame" on the positive side AND "border, frame, white margin" on the negative side).
- **EXPLICITLY DESCRIBE A HAIRSTYLE** (color + shape) for every character, and force **"full head of hair clearly drawn, definitely not bald, scalp fully covered with hair"** on the positive side. The model often renders characters **bald** (bare skin-colored scalp, no hair at all) — this is failure mode #1. On the negative side: **"bald, bare scalp, shaved head, hairless, no hair, balding"** (unless baldness is actually intended). Also make sure the whole head is visible with a little space above it.

## Negative Prompt (standard block)

```
photorealistic, photograph, clean vector clipart, bright saturated colors, neon,
gradients, texture background, multiple characters, deformed hands, extra limbs,
watermark, signature, blurry, 3D render, cel-shading anime, manga,
text errors, multiple faces, bad anatomy, hyperrealistic skin,
border, frame, white margin, decorative frame around the image,
bald, bald head, bare scalp, shaved head, hairless, no hair, balding,
top of head cut off, flat-topped head, framing too tight at the top
```

## Params

- Ratio: 1:1 (1024×1024)
- Steps: 8 (Z-Image-Turbo default)
- Guidance / CFG: 7.5
- HF Space: `mcp__hf-image__gr1_z_image_turbo_generate`
- Resolution param: `1024x1024 ( 1:1 )`

## Confirmed visual references

These three covers validate the target style:
- TRASH METAL — brick-red background #B03A2A, angry metalhead
- TRIP HOP — teal background #4A8B9A, serene person + headphones
- TWEE POP — rose-salmon background #D9706B, cute young girl, retro look

## Variation history

| Date | Playlist | Type | BG Color | Seed | Notes |
|------|----------|------|----------|------|-------|
| 2026-08-15 | SHARED QUIET MOMENT | Situation (parent and child) | #6B8B5E sage green | — (Gemini) | Generated on Gemini. 2 characters (parent + young child), exchanged gaze. Validated — slightly more detail than references but consistent. |
| 2026-08-15 | NU METAL | Genre | #3D4E4E green-slate gray | — (Gemini) | Generated on Gemini. Shaved head, goatee, hoodie, chain. Best style consistency so far — clean thick outline ideal. |
| 2026-08-15 | METALCORE | Genre | #2E4A5A cold steel-blue | — (Gemini) | Generated on Gemini. Undercut, gauge earring, neck/arm tattoos, beard, clenched teeth. Excellent "metal family" consistency with the references. |
| 2026-08-15 | CODING | Situation (backend dev) | #2F4A44 dark pine green | — (Gemini) | Generated on Gemini. Hoodie, glasses, headphones, coffee. Slight extra decor (laptop/chair) + angled pose vs. references, but validated as "pretty good." |
| 2026-08-15 | YUCK | Situation (musical disgust) | #8B9A45 acid olive-green | — (Gemini) | Generated on Gemini. Comic grimace, mustache, earbud removed with fingertips. Excellent — humor well rendered. |
| 2026-08-15 | FUNERAL | Situation (reflection/mourning) | #55606E slate blue-gray | — (Gemini) | Generated on Gemini. Reflective woman, closed eyes, white lily held with both hands. Sober, dignified register. Note: specify "styled mid-length hair" in the prompt (otherwise renders bald). |
| 2026-08-15 | WORKOUT | Situation (sport/gym) | #C85A2A burnt orange | — (Gemini) | Generated on Gemini. Athletic man, tank top, sweat, towel around neck, dumbbell mid-curl. Very punchy, slightly wider framing (arms visible). |
