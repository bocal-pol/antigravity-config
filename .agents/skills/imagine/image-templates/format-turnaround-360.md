---
name: format-turnaround-360
type: format
category: technical-product
tags: [technical, reference, angles]
compatible_with: [z-image-turbo, flux, sdxl, midjourney-v6]
---

# 360° turnaround — Turnaround

## Effect
Multi-angle reference sheet, same lighting/scale, for 3D or character-design consistency.

## Imposed structure (non-negotiable)
- Grid of views (4 or 8): front, three-quarter front, profile, three-quarter back, back, top, bottom, detail
- Uniform neutral background, identical lighting across all views, same scale

## Positive Prompt (English skeleton)
`360 degree turnaround reference sheet of {{subject}}, consistent views: front, three-quarter
front, side profile, three-quarter back, back, top, bottom, detail close-up, identical lighting
and scale across all views, neutral background, character/product reference sheet style`

## Negative Prompt
`inconsistent lighting between views, different scale, missing views, watermark, blurry`

## Variables to collect
1. Exact subject?
2. Number of views (4 simplified or 8 full)?

## Combinable with
- `specsheet`, `blueprint`

## Example
Subject "medieval armor character" → 8 consistent angles for a 3D reference.
