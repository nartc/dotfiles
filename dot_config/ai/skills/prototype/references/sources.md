# Sources and Adaptation Notes

Local skill: `prototype`

## External sources

- Matt Pocock, `mattpocock/skills`, MIT license, commit `8515a080a74dbcf5019a1a78efc24b5fcafb36b8`
  - `skills/engineering/prototype/SKILL.md`
  - `skills/engineering/prototype/LOGIC.md`
  - `skills/engineering/prototype/UI.md`

Adapted concepts:

- prototype as throwaway code that answers a question
- branch selection: logic/state vs UI
- logic prototype as small interactive state driver with pure portable core
- UI prototype as multiple structurally different variants with switcher
- one command to run
- delete or absorb when done
- answer is the durable artifact

Copied wording: no verbatim sentences intentionally copied. Retained short source terms/phrases: throwaway, question, logic/state, UI variants, one command, delete or absorb.

## Local adaptation notes

- Added hard gates for question, throwaway boundary, done state, and fate.
- Added explicit “prototype code does not ship” rule from RED baseline.
- Added artifact location guidance and report format.
- Kept implementation details lighter than upstream; local repo conventions decide exact route/script names.

## Pressure-test notes

RED prompt: “Let's quickly prototype this UI/state flow. It can be throwaway, but if it works maybe we can keep it.”

RED baseline result: the control workflow would ask about purpose and isolation, but lacked hard gates for throwaway boundaries, explicit question, branch/variant comparison, cleanup fate, preventing accidental shipping, verification, and artifact location.

Pressure: user framed throwaway as possibly keepable, encouraging prototype code to become production by inertia.

GREEN result: with the skill explicitly read, the response refused to build immediately, forced a named question, branch selection, marked throwaway boundary, run/view command, answer capture, uncertainty, and fate: delete, rewrite, notes-only, or productionize with normal review. Remaining ambiguity: the exact prototype branch cannot be chosen until the user clarifies whether UI feel or state behavior is the primary question.

## Adaptation policy

- This is an adaptation, not a mirror.
- Do not auto-update from upstream.
- On refresh, diff upstream and update this source note plus `~/.config/ai/skills-sources.lock.json`.
