# Product rules — interface conventions

> Detail of the product rules applied to projects with an interface. `AGENTS.md` keeps only a
> summary and points here: these rules only concern front-end and back-office deliveries, and
> loading them in full in every session would add a large preamble cost to all other sessions.

**When to read this file**: before shipping a screen, a form, a navigation, or a user action. The
completion checklists it contains are blocking for these deliverables.

---
## SaveMe — non-modal feedback for reversible actions (cross-cutting rule, all projects)

Not every user action needs a confirmation modal. Actions with no financial or legal consequence
use the **SaveMe** pattern: a self-dismissing toast with an undo button, backed by a persistent
history. Modals remain reserved for destructive operations or external-impact actions.

### Decision criterion: business criticality

| Criticality | Pattern | Examples |
| --------- | ------- | -------- |
| None / low — no financial or legal consequence | **SaveMe** (toast + history) | Archive, change a status, pin, remove a tag, deactivate |
| High — irreversible destruction or external distribution | **Confirmation modal** | Permanently delete, send, publish, pay, sign |

### SaveMe behavior

1. **Self-dismissing toast** (5-8s): a message describing the action performed + a clickable
   **Undo** button during that window.
2. **Persisted in history**: the action stays accessible via a bell icon or a "Recent actions"
   sidebar — the user can undo even after the toast disappears.
3. **Deferred execution**: the action is actually executed server-side once the window expires (or
   immediately if the history ensures reversibility via soft-delete).

### SaveMe message format

```text
[What was just done] — [Button: Undo]
e.g.: "Card archived"  — Undo
e.g.: "Tag removed"    — Undo
```

Writing rules: past-tense action, short subject, never a question mark (this is not a
confirmation).

### Checklist before marking "done"

- [ ] The toast shows the action label + the Undo button
- [ ] The window is between 5 and 8 seconds (globally configurable)
- [ ] Undoing via the toast or via history produces the same result
- [ ] The server-side action is soft (reversible) during the undo window
- [ ] High-criticality actions always use a modal (never a SaveMe)
- [ ] The action history is accessible without leaving the current page

### What SaveMe does NOT replace

- Confirmation modals for: permanent deletion, sending an email/notification, publishing, payment,
  electronic signature, changing access rights.
- Error alerts (SaveMe is only for reversible successes).

## Sidebar — information architecture (cross-cutting rule, back-office and navigation interfaces)

Every navigation sidebar must respect three non-negotiable constraints: grouping by intent, a
7-entry root limit, and highlighting the primary feature.

### 1. Group by intent, not by technical feature

Menu entries reflect what the operator wants to **accomplish**, not the name of tables, modules, or
controllers.

| ❌ Wrong (features) | ✅ Right (intent) |
| ---------------------------- | ----------------------- |
| Users / Roles / Permissions | Access management |
| Invoices / Payments / Credits | Billing |
| Requests / Validations / Closures | Request processing |
| Products / Categories / Tags | Catalog |

Two grouping modes depending on the app's nature:

- **By user goal** — "What does the operator want to do?" (Management, Configuration, Reporting…)
- **By workflow** — steps of the same business process grouped even if technically separate
  (Intake → Validation → Closure = a single "Processing" group)

### 2. Maximum 7 root-level spaces

Human working memory is limited to 7 ± 2 items (Miller's Law). The root sidebar never exceeds 7
entries.

**If the need exceeds 7:**

- Group mandatorily into **submenus** or **collapsible sections**.
- The root level stays ≤ 7, always.
- Never add an 8th item without removing or merging an existing one.

Recommended order of the 7 slots:

```text
1. [Primary feature] ← always first
2-5. Business-intent groups (3-4 max)
6. Reporting / Overview (if relevant)
7. Configuration / Settings ← always last
```

### 3. Highlighting the primary feature

Two combined, mandatory mechanisms:

**Primary item first, visually distinct:**

- Position 1 at the top of the sidebar.
- Differentiated visual treatment: accent color, slightly larger icon, or a permanent selection
  background.
- Never bury the primary feature inside a subgroup.

**Pinned quick-action button:**

- A `+ [New primary action]` button pinned at the top of the sidebar, always visible.
- Independent from navigation — the operator can create without navigating first.
- Example: `+ New request`, `+ New case`, `+ Create user`.
- Style: primary button (accent color), an "add" icon.

```text
┌─────────────────────────┐
│  + New request          │  ← pinned quick-action button
├─────────────────────────┤
│ ● Dashboard              │  ← primary item (accent)
│   Processing             │
│   Access management      │
│   Billing                 │
│   Reporting               │
│   Settings                 │
└─────────────────────────┘
```

### Agent obligations

**backend-agent (back-office admin panel)** — before shipping a navigation:

- Count root items: if > 7, group before shipping.
- Verify that labels describe an intent, not a model name.
- Position the primary item in slot 1 with distinct styling.
- Add a quick-action button for the back-office's primary action.

**frontend-agent (frontend)** — same rules for web-app sidebars.

### Sidebar completion criteria

- [ ] Number of root items ≤ 7
- [ ] No label matches the name of a table or technical model
- [ ] The primary feature's item is in position 1 with distinct visual treatment
- [ ] A quick-action button is pinned at the top of the sidebar
- [ ] Settings/Configuration items are in last position

## Keyboard shortcuts — full coverage + command palette (cross-cutting rule, all projects with an interface)

Every mouse-accessible action must have a keyboard shortcut. Advanced users should never need the
mouse for their common workflows. This rule applies to both frontend AND back-office.

### Required coverage level

1. **Global actions** — navigation between sections, create, save, cancel.
2. **Contextual actions** — every button, menu, and table action.
3. **Command palette** (`Cmd+K` / `Ctrl+K`) — universal entry point for any action, searchable by
   label.

### Shortcut conventions (cross-app standards)

| Action | Shortcut (Mac) | Shortcut (Win/Linux) |
| ------ | --------------- | --------------------- |
| Create a new item | `⌘N` | `Ctrl+N` |
| Save / Submit | `⌘Enter` | `Ctrl+Enter` |
| Cancel / Close | `Escape` | `Escape` |
| Search | `⌘K` or `/` | `Ctrl+K` or `/` |
| Delete (item focused) | `⌘Delete` | `Ctrl+Delete` |
| Edit (item focused) | `E` | `E` |
| Navigate between sections | `G` then a letter (`G` + `H` = Home) | same |

Single-letter shortcuts (`E`, `D`, `G`…) only activate when focus is not inside an input field.

### Discoverability — two mandatory mechanisms

#### Hover tooltip

```text
[Button: Archive]
Tooltip: "Archive  ⌘⇧A"
```

- Always show the shortcut to the right of the label in the tooltip.
- Format: action label + space + key combination.
- Use macOS symbols (⌘, ⇧, ⌥) on the frontend; `Ctrl`, `Shift`, `Alt` on the back-office.

#### Centralized reference panel

- Accessible via `?` or `Ctrl+?` — lists every active shortcut in the current context.
- Organized by section: Navigation / Actions / Forms / Table.
- Filterable by search.

### Back-office rules (admin panel)

#### Data tables

| Key | Action |
| ------ | ------ |
| `↑` / `↓` | Navigate between rows |
| `E` | Edit the focused row |
| `D` | Delete the focused row (triggers a modal or SaveMe depending on criticality) |
| `Space` | Select / deselect the row |
| `Enter` | Open the detail view |
| `Escape` | Deselect all |

#### Back-office forms

- `Tab` / `Shift+Tab`: strict, logical tab order (never a visual jump).
- `Ctrl+Enter`: submit the form.
- `Escape`: cancel and go back (with SaveMe if data was modified).
- Every form section accessible via a navigation shortcut (`G` + letter).

### Frontend rules (Angular / React / Flutter)

- Implement via a centralized shortcut-handling service/hook — never scattered keydown listeners
  across components.
- The service manages context priority: modal > drawer > page.
- Shortcuts are automatically disabled when focus is inside a text input, textarea, or
  contenteditable element.
- The command palette (`Cmd+K`) is a global component mounted at the app root.

### Shortcut agent obligations

**frontend-agent (frontend)** — before shipping a form or a list, verify that:

- A centralized shortcut service exists in the project.
- Every primary action has a registered shortcut.
- Tooltips show the shortcuts.
- The command palette is wired up.

**backend-agent (back-office)** — before shipping an admin resource:

- Keyboard navigation active on the table (↑↓, E, D, Space, Enter).
- Correct tab order on all forms.
- `Ctrl+Enter` to submit, `Escape` to cancel.

### Shortcut completion criteria

- [ ] A centralized shortcut service/hook exists (no scattered listeners)
- [ ] All primary actions have a documented shortcut
- [ ] Tooltips show the shortcut next to each action's label
- [ ] The command palette (`Cmd+K` / `Ctrl+K`) is functional and searchable
- [ ] The `?` panel lists every active shortcut in the current context
- [ ] Full keyboard navigation on back-office tables (↑↓, E, D, Space, Enter)
- [ ] Strict tab order on all forms (frontend AND back-office)
- [ ] Single-letter shortcuts are disabled when focus is in an input field

## Lazy Principle — zero unnecessary input (cross-cutting rule, B2C/B2B projects with an interface)

The user should never enter data they have already provided, that can be deduced from context, or
that has no real business value. This rule applies to every input point: creation/edit forms,
modals, filters, inline-edit.

### Decision hierarchy — in this order

Before showing a field, answer these questions:

1. **Is the data already in the database for this user?** → pre-fill silently, do not show the
   field (unless the user must explicitly validate it).
2. **Can a reliable contextual default be inferred?** → pre-select, leave visible but non-blocking.
3. **Does the data have real business value for this flow?** → if not, remove the field, even if
   technically available in the database.
4. **Has the user already entered this data in the same session?** → reuse it without re-asking.
5. **Only then** → show an input field, with the most appropriate component for the data type.

### Mandatory contextual defaults

| Field | Expected default |
| ----- | -------------- |
| Creation/start date | Today |
| Status at creation | Draft / In progress (depending on domain) |
| Assigned to | Logged-in user |
| Organization / team | Current session organization |
| Currency / language | Preference stored in the profile |

### Mandatory components by data type

Forbid free-text input when a specialized component exists:

| Data type | Required component |
| -------------- | ---------------- |
| Date, time, range | Date picker / time picker / range picker |
| Duration | Duration picker (not a free-text field) |
| Status / category / type | Select or segmented control (not free text) |
| Color | Color picker |
| Location / address | Geographic autocomplete |
| User / member | People picker with search |
| Amount / price | Formatted numeric input with fixed currency |

### Autocomplete and suggestions

- Free-text fields referencing existing data (tags, names, labels) must offer an **autocomplete**
  based on the user's history or the most frequent values in context.
- Suggestion order: (1) recently used by this user, (2) most frequent in the project, (3)
  alphabetical order.

### Rules for required fields (*)

- A field can only be required if its **missing value genuinely blocks** business processing.
- A required field with a reliable default must **not be visually marked required** — it is
  pre-filled, the user can modify it but is not forced to touch it.
- Never a required field whose value will be ignored server-side.

### Agent obligations

**frontend-agent**: before coding a form, list every field and justify each one against the
hierarchy above. Any field without a business justification is removed.

**backend-agent**: creation endpoints accept optional fields with server-side defaults. Never reject
a request for a missing field that has a known default.

### Completion criteria

- [ ] No form field re-asks for data already present in the user's profile
- [ ] All contextual defaults are pre-filled when the form opens
- [ ] Each data type uses the specialized component (picker, select, autocomplete) — no free-text
      input for structured data
- [ ] Required fields with no real business value have been removed
- [ ] Autocomplete is active on every field referencing existing data

## Hick's Law — action hierarchy on screen (cross-cutting rule, all projects with an interface)

Decision time grows with the number of options of comparable visual weight (Hick-Hyman law,
`T = a + b·log₂(n+1)`). On screen, this translates into 4 action-hierarchy rules.

### The 4 rules

1. **A single, obvious primary action per screen.** If two actions seem equally legitimate to the
   user, that is a screen-design problem to solve — not a signal to add a second button of equal
   weight.
2. **The primary button visually dominates** what surrounds it: size, filled vs. outlined, position.
   A secondary button treated with the same fill as the main CTA cancels the hierarchy.
3. **Advanced options hidden by default**, collapsed under a disclosure (accordion, "Advanced
   options," secondary tab) — never shown flat next to the primary action just because they exist.
4. **Never two actions of equal weight side by side.** Two full buttons of the same size on the same
   row, even in different colors, force a comparison before the choice. One of the two yields in
   visual weight (ghost button, text link) or the two are merged.

A fifth reflex — do not show an option with no business value — is already covered by the **Lazy
Principle** above for forms; apply the same principle to actions and menu items rather than
duplicating a second decision hierarchy.

### Grouping (chunking) rather than removal

Hick's Law penalizes a lack of structure, not functional richness: a 20-item menu organized into 4
groups of 5 is decided faster in practice than a flat list of 20 (the user first picks a group, then
an item within it — the sum of two logarithmic times is less than the time of a single flat
choice). Before removing a useful option to reduce `n`, first try grouping it with related options.

### Agent obligations

- **frontend-agent / mobile-agent / design-agent**: before shipping a screen with more than one
  clickable action, identify the primary action and justify the visual treatment of the others
  (secondary, tertiary, hidden). A screen with two visually equivalent CTAs is a finding to fix
  before delivery.
- **ux-designer**: wireframes annotate the action hierarchy (primary / secondary / hidden by
  default) just like component states.

### Completion criteria

- [ ] Each screen has a primary action identifiable without hesitation in under a second
- [ ] The primary button has strictly greater visual weight than other actions on the screen
- [ ] No advanced option is shown by default next to the primary action
- [ ] No pair of equal-visual-weight buttons coexists on the same screen
- [ ] Options with no business value have been removed (Lazy Principle), not just hidden

## Impact radar — transparency for cascading deletions (cross-cutting rule, all projects)

Any deletion modal whose action impacts other elements must show an **impact radar**: a verbalized,
readable summary of the real consequences before confirmation. The user sees real names — not
anonymous counters.

### Trigger

Show the impact radar **as soon as at least one related element will be affected** by the deletion.
If there is no impact: show no section (no "No elements affected" message — the modal stays simple).

### Verbalized format (real names, grouped by type)

```text
⚠️ This deletion will also affect:

Tasks (3)
  • Contract review
  • Q3 schedule update
  • Deliverable validation

Files (2)
  • client_brief_v2.pdf
  • signed_contract.docx
```

Presentation rules:

- **Always real names** — never "3 tasks" alone without identifying them.
- **Grouped by entity type** (Tasks, Files, Users, Contracts…).
- **Warning icon** (⚠️ or equivalent) to visually mark the impact zone.
- **Read-only** — the user reviews, they cannot modify the deletion scope from the radar.
- **Truncation** beyond 5 items per group: show the first 5 + "… and N more" (no infinite scroll
  inside a modal).

### Modal structure with impact radar

```text
┌─────────────────────────────────────────────┐
│  Delete [Item name]?                        │
│                                             │
│  ⚠️ This deletion will also affect:         │
│  Tasks (3)                                 │
│    • Contract review                        │
│    • Q3 schedule update                     │
│    • Deliverable validation                 │
│                                             │
│  This action is irreversible.               │
│                                             │
│           [Cancel]  [Delete]                │
└─────────────────────────────────────────────┘
```

### Backend obligations

To feed the impact radar, the backend must expose a **dry-run** endpoint or logic before deletion:

- Compute dependencies without executing the deletion.
- Return related entities grouped by type with readable labels.
- Fast response (< 500ms) — the modal opens with no perceptible delay.

### Impact radar completion criteria

- [ ] The impact radar shows if and only if at least one related element exists
- [ ] Real names of the elements are shown (not only IDs or counters)
- [ ] Truncation at 5 items per group is in place with the "… and N more" message
- [ ] The confirmation button is labeled "Delete" (red/destructive), not "OK" or "Confirm"
- [ ] A dry-run endpoint or method is available server-side
- [ ] The radar is read-only (no checkboxes, no selection)

## Ikea effect — progressive ownership (B2C / consumer projects)

Users feel more ownership over what they have partially built or personalized. This rule applies to
any project with consumer (B2C) end users. It does **not** apply to internal tools, interface-less
APIs, single-client B2B projects, or validation MVPs (< 2 weeks).

### Blocking prerequisite

**Without a working authentication system → do not implement personalization.** Flag the gap and
recommend adding auth first. Personalization without an account is ephemeral (localStorage) and
creates frustration on reconnection.

### Personalization scope (by priority)

1. **Visual identity** — profile picture, avatar, personal color/theme.
2. **Content & data** — favorites, shortcuts, pinned widgets, item order.
3. **Behavioral** — language, notifications, display density, interface preferences.

### Timing: optional onboarding + contextual nudges

- **Onboarding**: 1 to 3 light steps on first launch (e.g. "Add a photo," "Choose your theme") — all
  skippable, none blocking.
- **Nudges**: contextual suggestions at the right moment (e.g. after the 3rd login: "Personalize
  your dashboard"), never intrusive.
- **Zero mandatory friction**: never block app access to force personalization.

### Checklist before marking "done" (applicable projects)

- [ ] At least one visual-identity point implemented (avatar or theme)
- [ ] Preferences are persisted server-side (not only in localStorage)
- [ ] A contextual nudge exists to guide discovery (no hidden menu)
- [ ] Personalization is accessible from the user profile at all times
- [ ] Personalization data survives a logout/login (manual or automated test)

## Legal pages & consent — default legal compliance (cross-cutting rule, all projects with an interface)

Any application with external forms, payment, or external users collecting personal data publishes
and maintains its legal documents, collects only necessary data, obtains explicit consent when
required, and respects accessibility — by default, not retrofitted before going to production.

### Trigger

Applies as soon as one of these criteria is true: an external data-collection form, payment
(one-off or recurring), an external user account, or a third-party tracker/script. Does not apply
to internal tools with no public exposure nor to interface-less APIs (an exclusion common to every
rule in this file, restated in the introduction).

### Expected behavior

1. **Published and up-to-date documents** — privacy policy, legal notices, terms of service
   (including a refund policy beyond the legal withdrawal period), a cookie-consent banner —
   produced with the text of the publishing country (localize per jurisdiction) — never a generic
   page copy-pasted with no adaptation to the project.
2. **Editable without going back through the assistant** — if the stack is Laravel/Filament, these
   documents are administered via a versioned content pattern with publication history, not frozen
   in a Markdown file generated only once.
3. **Non-pre-checked form consent** — any form collecting non-essential data shows an explicit
   consent checkbox, never pre-checked, with the minimal required legal mention (purpose, legal
   basis, duration, rights).
4. **Verified minimization** — no field is collected without a declared purpose in the data
   dictionary or app spec; a gap is flagged by a compliance-review process, not ignored.
5. **WCAG 2.1 AA accessibility** — especially on the consent banner and consent forms (contrast,
   keyboard navigation, screen-reader announcement), audited before production.

### Obligations by agent

- **project-bootstrap-agent**: drafts these documents as early as bootstrap if the trigger above is
  detected — not waiting until the end of the project.
- **backend-agent** (Filament back-office): scaffolds the versioned legal-document pattern when the
  stack is Laravel; never a static, non-editable file if Filament is already used for the rest of
  the administration.
- **frontend-agent**: implements the consent banner and form consent checkboxes compliant with the
  project's cookie-consent spec, with non-essential scripts conditioned accordingly.
- **design-agent / ux-designer**: delegates the audit of the banner and consent forms to an
  accessibility review, just like the rest of the interface.

### Checklist before marking "done"

- [ ] Privacy policy, legal notices, terms of service (+ refund policy if payment) published and
      up to date for the project's publishing country
- [ ] Documents editable via an admin panel if the stack is Laravel (not only frozen Markdown
      files)
- [ ] Every form collecting non-essential data shows explicit, non-pre-checked consent
- [ ] No collected field is without a declared purpose (minimization verified)
- [ ] The consent banner and consent forms have been accessibility-audited (WCAG 2.1 AA)

### Exclusions

Internal tools with no public exposure, interface-less APIs, validation MVPs under two weeks — same
exclusions as the other rules in this file.

## Perceived performance — immediate responsiveness and success confirmation (cross-cutting rule, all projects with an interface)

Beyond loading states and error messages already covered elsewhere, five reflexes guarantee a sense
of speed regardless of actual network latency.

### Trigger

Any interface with a clickable action or an asynchronous task (request, submission, a long task
offloaded to a job/queue). Does not apply to interface-less APIs nor to purely server-side batch
processing with no associated UI.

### The 5 reflexes

1. **Immediate reaction to a click (< 100ms)** — a "pressed"/pending visual state shows before any
   server response; the button disables immediately to prevent double submission. Never leave a
   clickable button with no visual feedback during network wait.
2. **A loading state for any content fetch** — refer to the UI-state-components rule (frontend
   skeleton/spinner/progress-bar conventions). Not reformulated here.
3. **Progress for long tasks, even with no known `%`** — a task offloaded to a job/queue shows an
   indeterminate indicator **and** a step text ("Step 2/4: generating PDF…") or a status poll. Never
   total silence between triggering and finishing a long task.
4. **Explicit confirmation of successfully completed important steps** — a pattern distinct from
   **SaveMe** (which assumes a reversible, cancellable action): for a significant but non-reversible
   step (payment completed, case submitted, account created), show a **persistent** success banner
   or screen (not a toast lasting a few seconds), with a success symbol and the next suggested
   action if relevant. Do not confuse with SaveMe: a minor save remains a cancellable toast, not a
   success banner.
5. **Error messages with no over-disclosure** — the 3-part error-message rule remains the reference;
   additional guard: the "why" never reveals exploitable technical or sensitive detail (stack trace,
   whether an account exists, database structure, server path, framework name/version).

### Obligations by agent

- **frontend-agent / mobile-agent** (web + mobile): implements the "pressed"/pending state on every
  clickable action, the polling/step-text for long tasks with no `%`, and the success-banner
  component for important steps — distinct from the SaveMe toast.
- **backend-agent / infrastructure-agent**: any task offloaded to a job/queue exposes a status
  endpoint or channel (polling, websocket, SSE) allowing the frontend to show progress — a job with
  no queryable status cannot satisfy this rule on the UI side.
- **design-agent / ux-designer**: annotates the "pressed" state and the success banner in wireframes
  just like the 4 UI states, and visually distinguishes this pattern from the SaveMe toast.

### Checklist before marking "done"

- [ ] Every action button gives visual feedback in under 100ms, before any server response
- [ ] An action button disables immediately after the first click (no double submission possible)
- [ ] Any long task with no known `%` shows an indeterminate indicator + a step text or a queryable
      status
- [ ] Successfully completed important steps (payment, submission, account creation) show a
      persistent confirmation, not an ephemeral toast
- [ ] No error message reveals exploitable technical or sensitive detail

### Exclusions

Interface-less APIs, purely server-side batch processing with no associated UI.
