---
name: elara-mage-example
type: character
created: 2026-08-14
last_used: 2026-08-14
tags: [fantasy, mage, female, character-consistent, example]
compatible_with: [flux, sdxl, midjourney-v6]
---

# Elara — Example Mage

> Example template provided to illustrate the expected structure. Delete or replace with your own characters.

## Identity

- **Type**: character
- **Description**: Elven mage with silver hair, in her thirties, a mix of scholar and warrior, glowing runic mark on her forehead.
- **Intended usage context**: tabletop RPG campaign illustrations, character sheet front portraits, narrative scenes.

## Visual DNA

- **Medium/rendering**: semi-realistic digital illustration, visible brushstrokes, painterly style close to modern fantasy concept art.
- **Dominant palette**: deep blue + silver + violet accents, warm/cool contrast.
- **Artistic reference(s)**: a cross between Loish + Sam Yang + Baldur's Gate 3 concept art.
- **Non-negotiable distinctive trait**: glowing circular rune (blue-white) on the forehead, silver strand falling over the left eye.

## Positive Prompt (block to inherit)

```
elven mage woman in her thirties, silver hair cascading with one strand covering left eye,
glowing circular blue-white rune on forehead, sharp intelligent gaze, deep blue and violet
ceremonial robes with silver embroidery, painterly semi-realistic digital illustration,
loish and sam yang inspired style, dramatic rim lighting, cool color palette with warm accents,
highly detailed face, expressive brushwork, concept art quality
```

## Negative Prompt (block to inherit)

```
lowres, bad anatomy, extra fingers, deformed hands, watermark, signature, text, blurry,
jpeg artifacts, oversaturated, cartoon, chibi, anime style, western comic style,
multiple faces, cloned features, plastic skin, symmetrical scars
```

## Params

- **Default ratio**: 3:2 (narrative portrait) or 2:3 (full body)
- **CFG / Steps**: CFG 6.5 / Steps 40 / Sampler DPM++ 2M Karras (SDXL)
- **Reference seed**: `4728193056` — reuse to replay the same face.

## Variation history

| Date | Context / action | Seed | Output URL | Notes |
|------|-------------------|------|------------|-------|
| 2026-08-14 | Reference portrait, bust, dark studio study background | 4728193056 | *(example)* | Canonical reference. Rune well centered. |
| — | *(next variation here)* | — | — | — |

---

## How to replay this character

From this environment:

```
imagine template elara-mage-example
```

The skill will only ask for the **variation context** (e.g. "Elara in a burning library, casting a
protection spell, 45° low angle"), and will generate the final prompt by automatically inheriting
the visual DNA, positive, negative, and params above.

To maintain **character consistency**:
- Keep the **same seed** as the reference.
- **Never remove** tokens from the "Positive Prompt" block (silver hair cascading, rune, loish style).
- Only vary: environment, action, angle, light.
