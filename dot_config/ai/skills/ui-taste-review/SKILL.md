---
name: ui-taste-review
description: Use when reviewing frontend UI, landing pages, dashboards, components, visual polish, spacing, copy hierarchy, interaction quality, or AI-generated generic/slop aesthetics. Don't use for backend/API logic, non-visual refactors, or accessibility-only audits.
license: MIT
metadata:
  sources: "Adapted from emilkowalski/skills@1274a05 and tasteskill.dev; attribution notes in references/sources.md"
---

# UI Taste Review

## Overview

Review UI for intent, coherence, usability, accessibility, and craft. Do not optimize for novelty alone. The goal is product-fit polish: an interface that feels deliberate, works across breakpoints, preserves behavior, and avoids generic AI-generated sameness.

Baseline failure this skill fixes: agents catch obvious mobile/accessibility issues, but under-emphasize rhythm, visual density, brand fit, copy specificity, preservation of existing conversion paths, and whether the aesthetic direction is coherent.

## When to Use

Use for:
- frontend components, pages, dashboards, landing pages, portfolios, marketing sites
- visual redesigns and "make this look better" requests
- UI code review, screenshots, prototypes, or design-system polish
- copy/hierarchy/CTA/layout critiques

Do not use for:
- backend/API logic
- non-visual refactors
- dense enterprise UI where marketing-page rules would reduce usability
- accessibility-only audits; use a dedicated a11y workflow when available

## Procedures

**Step 1: Classify the UI surface**
1. Identify whether the work is a marketing surface, product dashboard, form flow, design-system component, or visual redesign.
2. Apply marketing-page taste checks only when they fit the surface. Prioritize scanability and trust for dashboards/admin UI.

**Step 2: State the design read**
1. State the inferred brief in one sentence:

   > This should feel like [audience] using [product] to achieve [outcome], with a [visual tone] personality.

2. If the audience, product, or outcome cannot be inferred, ask instead of inventing.

**Step 3: Review with the required shape**

Return the design read first, then the table. If the caller explicitly asks for applicability first, answer that one line before the design read.

| Area | Current | Change | Why |
| --- | --- | --- | --- |
| Direction | `generic SaaS purple gradient` | choose a product-specific visual thesis | avoids interchangeable AI output |

Add after the table:
- **Preserve:** routes, form field names, analytics hooks, legal copy, brand assets, conversion paths; list actual violations separately from general reminders
- **Risk:** regressions or unknowns that need implementation/screenshot verification
- **Verdict:** `block`, `revise`, or `ship`

Verdict criteria:
- `block`: conversion path broken, behavior/API/analytics changed without approval, mobile primary action unusable, accessibility regression, or brand/product direction is too generic to evaluate.
- `revise`: direction is plausible but hierarchy, coherence, copy, responsiveness, or motion needs changes.
- `ship`: product fit is clear, preservation checks pass, primary breakpoints work, and remaining issues are minor.

**Step 4: Apply taste checks**

### Design dials

Make tradeoffs explicit:

| Dial | Conservative | Experimental |
| --- | --- | --- |
| Layout | predictable grid | asymmetric/composed |
| Motion | static/subtle | expressive/storytelling |
| Density | airy | information-rich |
| Tone | utilitarian | editorial/playful/luxury/raw |

Pick values that fit the product, not reviewer preference.

### Coherence locks

Check these before proposing details:
- one type scale strategy
- one accent system
- one radius/shape language
- one motion personality
- one page-level composition idea
- sections do not feel randomly generated

Operational checks:
- rhythm: section types alternate intentionally; not every section is hero/text/cards
- visual density: important content has stronger weight than supporting content
- brand fit: type/color/motion choices can be explained from product/audience, not trend defaults
- copy specificity: headline names a user, pain, capability, or outcome

### Anti-slop signals

Flag:
- centered hero + vague AI copy + purple/blue blobs with no product reason
- three equal cards everywhere
- generic "transform your workflow" / "unlock insights" copy
- effects applied uniformly instead of where hierarchy needs them
- CTAs below fold on mobile
- desktop nav wrapping or exceeding ~80px height
- repeated layout families on long pages

### Preservation audit

For redesigns, do not silently change:
- URLs/routes
- nav labels
- form field names
- conversion events and analytics attributes
- logos, legal copy, pricing facts
- accessibility semantics and keyboard behavior

If a change is necessary, call it out as a product decision.

### Accessibility and motion preflight

Check:
- contrast and focus states
- heading order and form labels
- mobile/touch layout
- reduced-motion behavior
- hover effects gated to hover-capable pointers
- no scroll listener updating React state for decorative effects

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Making everything bold/animated | Reserve emphasis for hierarchy |
| Applying marketing taste to admin UI | Prioritize scanability and trust |
| Chasing originality over product fit | Start from audience/outcome |
| Critiquing aesthetics only | Include preservation, mobile, a11y, copy, behavior |
| Importing taste rules as laws | Treat TasteSkill/Emil as references, not universal truth |

## Error Handling

- If no screenshot or implementation is available, review only visible requirements and list what must be verified visually.
- If a requested aesthetic conflicts with product usability, state the conflict and propose a product-fit alternative.
- If the review needs source attribution or adoption context, read `references/sources.md`.

## Source Notes

Adapted from:
- Emil Kowalski skills repository, `emil-design-eng`, commit `1274a0584c4fe9e94304a4e29094cefe5eb51dbe`
- TasteSkill v2 docs and guide, consulted July 2026

See `references/sources.md` for attribution and adoption notes.
