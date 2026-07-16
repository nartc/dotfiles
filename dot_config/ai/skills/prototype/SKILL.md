---
name: prototype
description: Use when building throwaway UI, state, logic, interaction, or design probes to answer a specific question before committing to production implementation.
---

# Prototype

A prototype is throwaway code or artifact that answers one design question. The answer may survive; the prototype shell should not drift into production by accident.

## Hard gates

1. **Name the question.** What decision should this prototype answer? If the question is vague, ask before building.
2. **Choose the branch.** Logic/state prototypes expose behavior; UI prototypes compare variants. Do not mix them unless the question requires both.
3. **Mark throwaway boundaries.** Path, filename, route, notes, or comments must say prototype/spike/throwaway.
4. **Define done state.** Done when the question has an answer, not when the prototype looks production-ready.
5. **Verify the artifact.** Run or view the prototype with the stated command. If blocked, report the blocker and do not call the question answered.
6. **Choose fate.** Delete, rewrite as production code, or archive notes. Prototype code does not ship without normal implementation/review discipline.

## Logic/state prototype

Use for state machines, reducers, data shapes, APIs, workflows, or business rules.

- Keep core logic pure and portable: reducer, state machine, pure functions, or small module.
- Put terminal/UI shell around the logic only to drive cases by hand.
- Surface full relevant state after every action.
- Use in-memory state unless persistence is the question.
- Provide one command to run via the project’s existing tooling.
- Keep notes beside the prototype: question, assumptions, observed answer, cleanup decision.

## UI prototype

Use for layout, information architecture, interaction feel, dashboard/page variants, or visual direction.

- Prefer mounting variants inside an existing real page/route so density, data, auth, and app chrome are present.
- Use a throwaway route only when no natural host exists.
- Default to 3 structurally different variants; cap at 5.
- Variants must differ in layout/flow/information hierarchy, not just color/copy.
- Switch variants with a stable URL param or equivalent; make comparison easy.
- Hide prototype switchers from production builds or keep them in explicitly throwaway routes.
- Capture the winning direction and why; delete losing variants/switcher when done.

## Artifact location

Prefer the closest safe place to the real context:

- logic/state: near the module being explored, with `prototype`, `spike`, or `throwaway` in the path/name
- UI: existing route/page with gated variants, or a clearly throwaway prototype route
- notes: `NOTES.md`, issue comment, ADR, KB capture, or commit message; choose the smallest durable place

If editing production-adjacent files, keep the diff obviously reversible.

## Report format

```markdown
Prototype question:
Branch: logic/state | UI | mixed (why)
Artifact path:
Run/view command:
Throwaway boundary:
Verification:
What it proved:
What remains uncertain:
Fate: delete | rewrite | keep notes only | productionize with normal review
```

## Anti-patterns

- Building before naming the question.
- Calling production code a prototype to skip tests/review.
- Letting a throwaway route, switcher, or TUI shell linger.
- Wiring prototypes to real mutations or production persistence unless that is the question.
- Over-polishing, abstracting, or adding “future flexibility”.
- Keeping a winning prototype without rewriting/reviewing it as production code.
