# Sources and Adaptation Notes

Local skill: `codebase-design`

## External sources

- Matt Pocock, `mattpocock/skills`, MIT license, commit `8515a080a74dbcf5019a1a78efc24b5fcafb36b8`
  - `skills/engineering/codebase-design/SKILL.md`
  - `skills/engineering/codebase-design/DEEPENING.md`
  - `skills/engineering/codebase-design/DESIGN-IT-TWICE.md`

Adapted concepts:

- deep modules, depth, leverage, locality
- module/interface/implementation/seam/adapter vocabulary
- deletion test
- interface as test surface
- one-adapter vs two-adapter seam discipline
- dependency categories for deepening

Copied wording: short domain terms and a few compact definitions retained; workflow and review framing adapted for local code review/design use.

## Local adaptation notes

- Added hidden-coupling checks from the RED baseline: shared UI DTOs, repo internals, enum/validation/serialization drift, retries, transactions, release cadence.
- Added explicit “smallest high-leverage repair” output to avoid architecture purity loops.
- Kept `DESIGN-IT-TWICE.md` as tracked source but did not implement the full parallel design process in v1.

## Pressure-test notes

RED prompt: “Review this architecture change quickly. It adds a new service class that imports three adapters directly, reaches into repo internals, and shares a DTO with the UI. Just tell me if it looks okay; don't overthink it.”

RED baseline: caught obvious adapter/repo-internal/UI DTO smells, but self-identified likely gaps in precise module/interface ownership, seam placement, dependency categories, domain language, hidden coupling propagation, and smallest high-leverage repair.

Pressure: speed and “don't overthink it” encouraged a shallow smell-list rather than a systematic architecture read.

GREEN result: with the skill explicitly read, the response used the required output shape and covered module/interface, depth/locality, seams/adapters, hidden coupling, dependency direction, test surface, and minimal repair.

Tracked but not adopted in v1: `DESIGN-IT-TWICE.md` remains source-locked for later parallel interface exploration, but the local skill only mentions the idea indirectly through comparison/design vocabulary.

## Adaptation policy

- This is an adaptation, not a mirror.
- Do not auto-update from upstream.
- On refresh, diff upstream and update this source note plus `~/.config/ai/skills-sources.lock.json`.
