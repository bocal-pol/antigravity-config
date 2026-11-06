---
name: szikra-incubation
description: "Creative incubation (Wallas 1926, Poincaré 1908, Sio & Ormerod 2009, Zeigarnik effect). Calibrate the rhythm and tone of reminders, defend an open-ended waiting state with no deadline, prevent an idea box from becoming a task box. Auto-invoke on: incubation, let it rest, maturation, spaced reminder, idea notification, Zeigarnik effect, illumination, open idea, task inbox, overdue counter."
model: claude-sonnet-5
type: domain
priority: medium
scope: cross
dependencies: []
conflicts: []
---

# Szikra — Incubation

Module 3 of the corpus: Graham Wallas, *The Art of Thought* (1926); Henri Poincaré, "Mathematical invention," *Science and Method* (1908); Sio & Ormerod, *Psychological Bulletin* (2009); the Zeigarnik effect (1927).

**Wallas's four phases** — *preparation* (conscious work, accumulation, failure) → *incubation* (one consciously stops thinking about it; undirected mental work) → *illumination* (the click, often preceded by an "intimation," the diffuse feeling that an idea is coming) → *verification* (testing and formalizing; Poincaré reminds us that the omnibus intuitions are sometimes wrong).

**What the research says** — Sio & Ormerod meta-analyzed over a hundred experimental studies. The incubation effect is real, of moderate size, and **non-uniform**. It is stronger:
- on problems with **multiple solutions** (divergent thinking — exactly the case of an idea box) than on single-solution problems;
- when the period is filled with an **undemanding task**, rather than full rest or a difficult task;
- when **preparation was long**: one only incubates well what one has truly worked on.

**Zeigarnik effect** — interrupted tasks remain more active in memory than completed tasks. An idea deliberately left **open**, with no conclusion or definitive status, keeps working in the background. That's the psychological side of the slow hunch.

## Directives — Non-negotiable

| Directive | Application |
|-----------|-------------|
| **Waiting is a legitimate state** | "Letting it rest" is not an absence of status: it's the default state, and it demands nothing |
| **No deadline, no counter** | No due date, no "overdue" label, no alert badge, no urgency color on a dormant idea |
| **Growing spacing** | Reminders space out (a week, a month, a quarter). A too-frequent reminder becomes a task again |
| **Arrive outside of task mode** | On app opening or in a dedicated surface — never as an interruptive notification in the middle of something else |
| **Ask for resonance, not a decision** | The question is "does this resonate today?", never "what do we do with this?" |
| **"Not now" at no cost** | Postponing must be free: no visible dodge counter, no punitive follow-up |

## The central trap: the task box

The temptation, for any developer, is to treat an idea inbox like a task inbox: everything that comes in must be sorted, decided, closed. That's exactly what incubation forbids. An idea closed too fast no longer incubates; an idea marked "to handle" becomes a source of guilt.

Anti-patterns to explicitly refuse:

- an untreated-ideas counter presented as debt;
- "inbox zero" as a stated goal;
- mandatory sorting on entry before being able to deposit anything else;
- a due date, SLA, or escalating reminder on a personal idea;
- a default status that degrades on its own over time.

## Workflow

### Phase 1 — Identify the object

Reminder rhythm · wording a waiting state · auditing a screen suspected of task-like logic · arbitrating a "cleanup" request. Collect via `AskUserQuestion` if absent.

### Phase 2 — Verify the existing state

Read the real state (`Grep`, excluding `node_modules/`, `vendor/`, `*.test.*`): does an overdue counter exist, a deadline, a planned purge, an interruptive notification, an imperative label? Each occurrence is a gap to document.

### Phase 3 — Recommendation

Set the parameters: spacing cadence and progression, presentation surface, wording of the question asked, available outcomes, "not now" behavior. Tie each parameter to its experimental result (Sio & Ormerod for cadence and context, Zeigarnik for openness, Wallas for the targeted phase).

### Phase 4 — Conditional persistence

- **From an orchestrator**: return in Markdown, write nothing, **skip memorization**.
- **Standalone**: write `ideas/YYYY-MM-DD_szikra-incubation-[topic].md` in the current project.

## Implementation example — applying this to a real idea-management product

- The real waiting state is a status like "in reflection," with a "to deepen" variant for ideas worth exploring further. "In maturation" is not necessarily a status — it may just be a display label for the resurfacing feature ("dormant for N days"). Don't confuse the two registers.
- Spacing is carried by fields like `next_eligible_at`, `shown_count`, and `dismissed_count`: "not now" should already be modeled with no penalty.
- A "dormant" resurfacing form is the direct implementation of the spaced reminder; an "anniversary" form exploits temporal depth.
- The resurfacing should arrive on app open or in a dedicated surface — not as a push notification. This is consistent with Sio & Ormerod's finding on undemanding tasks: don't move it to an interruptive channel.
- Sorting and closure belong to other parts of the product; the idea-capture surface must tolerate the open-ended.

## Fallback ⚠️

Without access to the project's sources, produce the theoretical parameters while prefixing: *"Parameters not checked against the resurfacing implementation."* Never claim a counter or deadline exists (or doesn't) without having verified it.

## Optional Input

- Object (`reminder-cadence` | `waiting-state` | `screen-audit` | `cleanup-arbitration`)
- Scope (`personal` | `group`)
- Imposed cadence constraints (maximum frequency, available surface)
- Screen or file to audit
