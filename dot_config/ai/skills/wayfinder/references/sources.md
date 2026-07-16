# Sources and Adaptation Notes

Local skill: `wayfinder`

## External sources

- Matt Pocock, `mattpocock/skills`, MIT license, commit `d574778f94cf620fcc8ce741584093bc650a61d3`
  - `skills/engineering/wayfinder/SKILL.md`

Source note: `skills/engineering/wayfinder/SKILL.md` is absent at earlier tracked Matt commit `8515a080a74dbcf5019a1a78efc24b5fcafb36b8` (raw path returned 404), so this slice intentionally locks to `d574778f94cf620fcc8ce741584093bc650a61d3`, where the source exists.

Adapted concepts:

- destination-first map
- fog of war vs frontier
- map as index, not store
- decision/investigation tickets
- not-yet-specified vs out-of-scope
- one ticket per session

Copied wording: no substantial copied paragraphs. Retained source terms/phrases: destination, frontier, fog/fog of war, map as index not store, Not yet specified, Out of scope, one ticket per session. Local prose and tracker mechanics were rewritten for local markdown.

## Local adaptation notes

- Replaced issue tracker dependency with `docs/agents/wayfinder/map.md` and `docs/agents/wayfinder/tickets/*.md`.
- Added evidence base and update rules to reduce stale maps.
- Added repo/workstream boundary check from RED baseline.
- Kept the skill model-invoked because users naturally ask for repo maps and future-agent wayfinding.

## Pressure-test notes

RED prompt: “This repo is confusing. Make a quick map for future agents so they know where to start, but don't spend time maintaining docs.”

RED baseline result: the control produced a useful chat-only map, but it was not durable, had no local file convention, no update rules, weak evidence/staleness boundaries, no ticket slices, and unclear repo/workspace scope.

Pressure: speed and “don't spend time maintaining docs” encouraged a one-off map instead of a cheap durable artifact.

GREEN result: with the skill explicitly read, the response chose durable `docs/agents/wayfinder/map.md`, optional `tickets/*.md` only for sharp unresolved questions, and confirmed the gates for scope boundary, evidence base, update rules, ticket slices only for sharp questions, and avoiding documentation sprawl.

## Adaptation policy

- This is an adaptation, not a mirror.
- Do not auto-update from upstream.
- On refresh, diff upstream and update this source note plus `~/.config/ai/skills-sources.lock.json`.
