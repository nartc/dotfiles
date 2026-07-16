---
name: wayfinder
description: Use when a repo, feature, migration, or workstream is too large or foggy for one agent session and needs a durable map of decisions, investigation tickets, frontier work, or repo entry points.
---

# Wayfinder

Create a lightweight local map so future agents know the destination, frontier, and where to start without turning discovery into a documentation project.

## Local convention

Default files inside the repo under review:

```text
docs/agents/wayfinder/
  map.md
  tickets/
    0001-short-question.md
```

Create these lazily. If the repo already has a better agent-doc convention, use it and record the path in the map.

## When to use

- The work is too large for one agent session.
- The repo has confusing entry points or ownership boundaries.
- A feature/migration has unresolved decisions blocking implementation.
- Multiple agents may need to work through investigations over time.

If the way is already clear and the work fits one session, do not create a map. Use a normal plan or handoff instead.

## Map shape

`map.md` is an index, not a store. It links to tickets and captures only low-resolution state.

```markdown
# Wayfinder Map

## Destination

<what reaching the end means>

## Scope boundary

<repo/path/workstream included and excluded>

## Evidence base

- `<path>`: <what this map learned from>

## Decisions so far

- [<ticket title>](tickets/0001-example.md) — <one-line gist>

## Frontier

- [<open unblocked ticket>](tickets/0002-example.md) — <why this is next>

## Not yet specified

- <in-scope fog not sharp enough for a ticket yet>

## Out of scope

- <deliberately excluded work and why>

## Update rules

- Update this map only when the destination, scope, frontier, decisions, or primary entry points change.
- Do not mirror file trees or package manifests already owned elsewhere.
```

## Ticket shape

Each ticket answers one question sized for one agent session.

```markdown
# <short question title>

## Question

<decision or investigation this ticket resolves>

## Type

research | prototype | grilling | task

## Status

open | claimed | resolved | out-of-scope

## Evidence to inspect

- `<path or URL>`

## Blocked by

- `<ticket path>` or `none`

## Answer / resolution

<filled only when resolved>

## New tickets or fog surfaced

- <optional>
```

## Workflow

1. **Name the destination.** Ask what the map is finding the way to. Done when scope can be judged in/out.
2. **Set boundary.** Decide repo/workspace path and whether this is whole-repo wayfinding or one workstream. Done when paths included/excluded are explicit.
3. **Read evidence narrowly.** Inspect top-level docs/configs and task-relevant entry points. Done when every map claim has a source path or is marked inferred.
4. **Chart only visible frontier.** Create tickets only for sharp questions. Put vague in-scope fog under “Not yet specified”. Blocked tickets stay out of `## Frontier` until blockers resolve.
5. **Prefer decisions, not deliverables.** Tickets resolve uncertainty. Implementation starts after the way is clear unless a ticket is a task that unblocks a decision.
6. **Keep maintenance cheap.** One map page plus small tickets. No exhaustive trees, no copied manifests, no broad architecture encyclopedia.
7. **Work one ticket per session.** Claim it, resolve it, update the map, graduate newly visible fog, then stop or hand off.

## Common mistakes

- Chat-only map: future agents cannot find it.
- Exhaustive repo inventory: rots immediately.
- Pre-slicing fog into fake tickets before questions are sharp.
- Mixing resolved decisions into multiple files instead of linking one ticket.
- Doing implementation while pretending to map.
- Missing update rules, causing either staleness or doc-maintenance sprawl.
