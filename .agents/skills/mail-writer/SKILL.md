---
name: mail-writer
description: Drafting professional emails in a formal administrative register — management, suppliers, colleagues, partners. Formal / neutral / urgent registers depending on context.
model: claude-sonnet-5
user-invocable: true
aliases: []
argument-hint: "[email subject]"
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Mail Writer — Professional Email Drafting

Drafts professional emails adapted to context (public-sector register by default, adjustable).

## Phase 0 — Framing

1. Recipient (management / supplier / colleague / external partner)
2. Subject in one sentence
3. Tone (formal / neutral / direct / urgent)
4. Key points to include
5. Expected action (for information / reply / approval / action)

## Opening lines

| Recipient | Opening |
|---|---|
| Management (director, head of department) | "Dear [Title]," |
| Colleague (same level) | "Dear colleague," |
| Supplier | "Dear Sir or Madam," |
| Informal/technical | "Hi [First name]," |

## Structure

```
Subject: [...]

[Opening line],

[Context in 1-2 sentences]

[Body — structured points, max 3 paragraphs]

[Expected action — specific, with a deadline if applicable]

[Closing line]

[Signature]
```

## Closing lines

| Register | Closing |
|---|---|
| Formal, to management | "Please accept my highest regards." |
| Formal, standard | "I look forward to your reply. Best regards," |
| Neutral | "Best regards," |
| Urgent | "Thank you for your prompt attention to this request," |

## Optional save

`documents/mails/YYYY-MM-DD_[short-subject].md`
