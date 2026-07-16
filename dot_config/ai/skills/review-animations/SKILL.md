---
name: review-animations
description: Use when reviewing animation, motion, transitions, Framer Motion/Motion code, CSS animations, hover effects, reduced-motion handling, easing, duration, transform-origin, or animation performance. Don't use for general code review or non-motion UI critique.
license: MIT
metadata:
  sources: "Adapted from emilkowalski/skills@1274a05; attribution notes in references/sources.md"
---

# Review Animations

## Overview

Review motion against a high craft bar. Approval is earned. Animation that runs but feels sluggish, fires too often, lands from the wrong origin, causes motion sickness, or drops frames is a regression.

Baseline failure this skill fixes: agents flag obvious reduced-motion and dashboard-density issues, but under-check exact values, origin/physicality, interruptibility, GPU path, hover gating, and whether the strongest fix is deleting the animation.

## Scope

Use this only for animation/motion review. For general code review, use a general reviewer.

## Procedures

**Step 1: Scope the motion**
1. Identify the animated surface: dashboard, form, marketing page, popover, tooltip, modal, drawer, list, card, gesture, or hover effect.
2. Identify frequency: keyboard/100+ per day, tens per day, occasional, or rare.

**Step 2: Decide whether motion should exist**
1. Delete or block motion for keyboard-triggered and 100+/day actions.
2. Reduce motion for repeated dashboard/list/card interactions.
3. Allow expressive motion only for rare, explanatory, or marketing contexts.

**Step 3: Return the required output**

Start with a markdown table. If the caller explicitly asks for applicability first, answer that one line before the table.

| Before | After | Why |
| --- | --- | --- |
| `transition: all 300ms` | `transition: transform 200ms var(--ease-out)` | avoids animating unintended properties off-GPU |

Then add a verdict:
- **Block** — feel-breaking, a11y, high-frequency, or performance issue
- **Revise** — motion direction is valid but needs tuning
- **Approve** — purpose, timing, a11y, and performance are sound

Use `file:line` when reviewing real code. If no code location exists, say `conceptual`.

**Step 4: Apply the standards**

## Non-Negotiables

1. **Purpose:** animation needs a reason: spatial consistency, feedback, state indication, explanation, or reducing jarring changes.
2. **Frequency:** 100+/day or keyboard actions get no animation. Tens/day gets reduced. Rare moments may delight.
3. **Timing:** UI motion usually stays under 300ms.
4. **Easing:** entering/exiting uses `ease-out` or a strong custom curve. `ease-in` on UI is a block.
5. **Physicality:** no `scale(0)`; use `scale(0.9–0.97)` plus opacity.
6. **Origin:** popovers/dropdowns/tooltips scale from trigger origin; modals stay centered.
7. **Interruptibility:** rapidly-triggered UI uses transitions/springs that retarget, not keyframes that restart.
8. **Performance:** animate `transform` and `opacity`; avoid layout properties.
9. **Accessibility:** honor `prefers-reduced-motion`; gate hover motion behind hover-capable pointers.
10. **Cohesion:** motion matches product personality. Dashboards are crisp; playful surfaces can bounce.

## Default Fix Values

Use these unless the product has established tokens:

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
```

| Element | Duration |
| --- | --- |
| button press | 100–160ms |
| tooltip/popover | 125–200ms |
| dropdown/select | 150–250ms |
| modal/drawer | 200–500ms |
| stagger gap | 30–80ms |

## Escalation Triggers

Block or strongly flag:
- `transition: all`
- `scale(0)` entry
- `ease-in` on UI
- animation on keyboard shortcuts or command palettes
- UI duration >300ms without reason
- missing reduced-motion handling for movement
- hover motion not gated to `@media (hover: hover) and (pointer: fine)`
- animating `width`, `height`, `margin`, `padding`, `top`, `left`
- Framer Motion `x`/`y`/`scale` on motion that runs under page load or dense lists
- stagger delays that grow without cap (`i * 0.12` across unbounded lists)
- repeated `whileInView` animations in dense dashboards

## Motion/Framer Checks

For Motion/Framer Motion reviews, check:
- `useReducedMotion()` or equivalent branch removes transform/position motion.
- `whileInView` has an intentional `viewport` policy. Dense dashboards should usually use `viewport={{ once: true }}` or no viewport reveal.
- Variant-level and component-level `transition` values do not fight each other; verify against installed library docs/source when behavior matters.
- Unbounded stagger is capped. Prefer parent stagger or `Math.min(i, 4) * 0.04` over `i * 0.12` for unknown list sizes.
- Springs use low bounce for product UI. Prefer `{ type: "spring", duration: 0.5, bounce: 0.1-0.2 }` or crisp duration/easing for dashboards; flag high stiffness + low damping if it reads bouncy.
- Hover transforms on cards stay subtle (`scale: 1.01-1.02`) and are gated to hover-capable pointers.
- Dense lists should default to static. If animation remains, use small distance (`y: 8-12`), opacity, once-only reveal, and no blocking delay.

## Remedial Hierarchy

Prefer earlier fixes:

1. Delete motion that has no purpose or is high-frequency.
2. Reduce distance, scale, delay, or repetition.
3. Fix easing/duration.
4. Fix origin and physicality.
5. Make it interruptible.
6. Move it to GPU-safe properties.
7. Add reduced-motion and hover gating.
8. Add polish: stagger, blur bridge, `@starting-style`, spring only when justified.

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Treating "looks cool" as enough | require a purpose |
| Animating dashboards like marketing pages | delete/reduce motion for scanability |
| Infinite per-index delay | cap or use parent stagger with small groups |
| Missing reduced motion | remove transform/position motion, keep gentle opacity/color |
| Hover scale on touch | gate hover media query |
| Guessing feel from code only | request slow-motion/device review when uncertain |

## Error Handling

- If the animation library version is unknown, flag version-sensitive assumptions and ask to verify installed docs/source.
- If no screenshot or recording is available, review code-level risks and request slow-motion/device review for feel-sensitive decisions.
- If source attribution or adoption context is needed, read `references/sources.md`.

## Source Notes

Adapted from Emil Kowalski's `review-animations` and `STANDARDS.md`, commit `1274a0584c4fe9e94304a4e29094cefe5eb51dbe`. See `references/sources.md`.
