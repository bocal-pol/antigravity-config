---
name: mail-writer
description: Drafting professional emails in an administrative register — management, vendors, colleagues, partners. Formal / neutral / urgent registers depending on context.
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

# Mail Writer — Drafting Professional Emails

Drafts professional emails adapted to context (public-sector administrative register by default, adjustable).

## Phase 0 — Scoping

1. Recipient (management / vendor / colleague / external partner)
2. Subject in one sentence
3. Tone (formal / neutral / direct / urgent)
4. Key points to include
5. Expected action (for information / reply / approval / action)

## Opening lines

| Recipient | Formula |
|---|---|
| Management (Director, department head) | "Dear [Title]," |
| Colleague (same level) | "Dear colleague," |
| Vendor | "Dear Sir/Madam," |
| Informal/technical | "Hi [First name]," |

## Structure

```
Subject: [...]

[Opening line],

[Context in 1-2 sentences]

[Body — structured points, max 3 paragraphs]

[Expected action — precise, with a deadline if applicable]

[Closing line]

[Signature]
```

## Closing lines

| Register | Formula |
|---|---|
| Formal, to management | "Please accept, [Title], the assurance of my highest consideration." |
| Formal, standard | "Looking forward to your reply, kind regards." |
| Neutral | "Best regards," |
| Urgent | "Thank you for your prompt attention to this request," |

## Optional save

`documents/mails/YYYY-MM-DD_[short-subject].md`
