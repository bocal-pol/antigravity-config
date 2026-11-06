---
name: format-explodedview
type: format
category: technical-product
tags: [technical, product, assembly]
compatible_with: [z-image-turbo, flux, sdxl, midjourney-v6]
---

# Exploded view — Explodedview

## Effect
Separates and spreads apart all the subject's parts with leader lines and labels, reveals the assembly hierarchy.

## Imposed structure (non-negotiable)
- Neutral light gray studio background
- Parts aligned in assembly order, spread along an axis
- Thin leader lines to numbered callouts
- Soft even lighting, clean product render

## Positive Prompt (English skeleton)
`exploded view diagram of {{subject}}, all components separated and floating with thin leader
lines to numbered callouts, clean studio product render, neutral light gray background, soft
even lighting, high detail, ordered by assembly hierarchy`

## Negative Prompt
`assembled solid object, cluttered background, missing labels, blurry, watermark, low detail`

## Variables to collect
1. Exact subject (mechanical / electronic / organic object)?
2. Number of parts to detail (few / many)?

## Combinable with
- `blueprint`, `specsheet`, `wireframe`

## Example
Subject "mechanical watch" → case, movement, hands, glass separated with numbered labels 1-8.
