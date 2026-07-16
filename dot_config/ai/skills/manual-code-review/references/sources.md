# Sources and Adaptation Notes

Local skill: `manual-code-review`

## External sources

- Matt Pocock, `mattpocock/skills`, MIT license, commit `8515a080a74dbcf5019a1a78efc24b5fcafb36b8`
  - `skills/engineering/code-review/SKILL.md`

Adapted concepts:

- two-axis review: Standards vs Spec
- fixed review scope
- separate standards and spec source discovery
- smell baseline from Fowler-style review heuristics
- final report that keeps axes separate

Copied wording: adapted and compressed; smell names retained, descriptions shortened for local use.

## Local adaptation notes

- Removed issue-tracker setup assumptions.
- Removed automatic parallel subagent requirement from the top-level flow; review stays in the main session.
- Added explicit severity classification and unverified-scope reporting from the RED baseline.
- Added guardrail: do not run Plannotator automatically.

## Pressure-test notes

RED prompt: “Review this diff quickly. I mainly want to know if it looks good; don't spend time checking every requirement from the plan.”

RED baseline result: the control workflow separated Spec and Standards conceptually, but only performed a light spec check and would risk saying “looks good” while full requirement compliance remained unchecked.

Pressure: speed and explicit instruction to skip requirements encouraged a standards-only review to sound like full approval.

GREEN target: the skill must force separate Spec/Standards sections, mark unavailable or skipped spec verification explicitly, classify severity within each axis, and report unverified scope.

## Adaptation policy

- This is an adaptation, not a mirror.
- Do not auto-update from upstream.
- On refresh, diff upstream and update this source note plus `~/.config/ai/skills-sources.lock.json`.
