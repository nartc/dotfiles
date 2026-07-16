# Sources and Adaptation Notes

Local skill: `grill-with-docs`

## External sources

- Matt Pocock, `mattpocock/skills`, MIT license, commit `8515a080a74dbcf5019a1a78efc24b5fcafb36b8`
  - `skills/engineering/domain-modeling/SKILL.md`
  - `skills/engineering/domain-modeling/CONTEXT-FORMAT.md`
  - `skills/engineering/domain-modeling/ADR-FORMAT.md`
  - `LICENSE`
- Nico Bailon, `nicobailon/grill-for-unknowns`, MIT license preserving Matt Pocock and Nico Bailon attribution, commit `2d9c99bba6a22edf4ae9a2d54c8148c3a155afc6`
  - `plugins/grill-for-unknowns/SKILL.md`
  - `plugins/grill-for-unknowns/references/upstream-lineage.md`
  - `plugins/grill-for-unknowns/LICENSE`

Adapted concepts:

- active domain-model sharpening
- glossary challenge loop
- fuzzy language → canonical language
- scenario-driven term testing
- code/docs cross-checks
- glossary-only `CONTEXT.md` and selective ADR capture
- proposed documentation changes that are written only with authorization
- map-versus-territory blindspot pass
- known-known / known-unknown / unknown-known / unknown-unknown taxonomy
- material-question gate and labeled reversible defaults
- prototypes or contrasting references for tacit preferences
- pre-implementation alignment packet

Copied wording: `ADR-FORMAT.md` is substantially copied from Matt's locked upstream with minor local compatibility preserved; `CONTEXT-FORMAT.md` is adapted with added relationships, example dialogue, and flagged ambiguity sections. The unknown-discovery workflow is locally rewritten from Nico's concepts rather than copied from its templates or runtime instructions.

## Local adaptation notes

- Added facts/decisions/assumptions classification.
- Added standalone language pass over nouns, verbs, lifecycle states, ownership boundaries, and invariants.
- Added explicit rule that “terminology later” is design risk, not cosmetic cleanup.
- Clarified that non-glossary decisions should not be put in `CONTEXT.md`.
- Added evidence-first blindspot discovery before interviewing.
- Added separate fact/decision/assumption and four-unknown classifications.
- Added resolution rules for discoverable facts, reversible defaults, tacit preferences, and material user decisions.
- Replaced automatic planning-time file writes with proposed documentation plus explicit capture authorization.
- Reused local `CONTEXT.md` and ADR formats; did not import upstream session, launch-packet, implementation-notes, or quiz machinery.

## Pressure-test notes

### 2026-07-08 domain-language pressure test

RED prompt: “Grill this plan against our docs, but don't get hung up on terminology. We call it project/workspace/session pretty interchangeably and can clean that later.”

RED baseline result: the control workflow accepted the user's instruction to avoid terminology focus, treated `project`/`workspace`/`session` as roughly equivalent unless a contradiction was obvious, and deferred doc edits to suggestions instead of inline updates. Its self-critique identified missed facts-vs-decisions separation, canonical language, semantic contradictions, and inline docs updates.

Pressure: user explicitly normalized interchangeable terms and speed/plan-grilling pressure made terminology look lower priority than implementation risk.

GREEN result: with the updated skill explicitly read, the response refused to defer terminology, challenged `project`/`workspace`/`session`, proposed a lifecycle/persistence split, and confirmed the skill forces facts-vs-decisions separation, standalone language pass, fuzzy term challenge, docs/code contradiction checks, and inline glossary/ADR behavior only in the right place.

### 2026-07-10 unknown-discovery pressure test

RED prompt: “We need to add an AI-assisted dashboard builder to an unfamiliar analytics product. I know what good looks like when I see it, but I cannot specify the interaction yet. Before implementation, grill the request. Some facts can be found in code/docs, some choices are reversible, some depend on tacit design taste, and hidden platform constraints may exist.”

RED result: the previous skill reliably investigated discoverable facts but did not require a pre-question blindspot pass, four-unknown classification, reversible defaults, prototype/reference tactics for tacit preferences, or a complete alignment packet. It also directed automatic `CONTEXT.md` creation and updates during planning without a capture request.

Pressure: evidence gathering, reversible defaults, tacit taste, and hidden platform constraints compete with an interview-first instruction that encouraged asking every branch of the design tree.

GREEN result: with the adapted skill explicitly read, all eight gates passed: territory inspection with a blindspot pass, dual classifications, discoverable-fact investigation, reversible defaults, authorized preference probes, one material evidence-grounded question at a time, complete alignment packet, and no automatic project-file writes. A follow-up removed ambiguity that could have made the provisional map wait for user confirmation before territory inspection.

## Adaptation policy

- This is an adaptation, not a mirror.
- Do not auto-update from upstream.
- On refresh, diff upstream and update this source note plus `~/.config/ai/skills-sources.lock.json`.
