---
name: handoff
description: Use when summarizing current work for another agent, session, pane, model, or future continuation, including goals, files, decisions, verification, risks, next steps, and suggested skills.
---

# Handoff

Create a compact, transport-independent handoff that lets a fresh agent continue without relying on chat memory.

## Rules

- Preserve durable state, not transcript noise.
- Do not claim verification that was not run.
- Redact secrets, tokens, credentials, private customer data, and unnecessary personal data.
- Reference existing artifacts by path/URL instead of duplicating their contents.
- Include enough detail that “keep it short” does not erase critical state.
- This skill creates the handoff content only; transport-specific skills decide whether to paste, save, send, or submit it.

## Format

```markdown
# Handoff

## Objective

- <what the next agent is trying to accomplish>

## Current state

- <what has been done and what remains>

## Decisions / constraints / invariants

- <decisions made, user preferences, safety rules, things not to change>

## Files / locations / sources

- `<path or URL>`: <why it matters>

## Verification evidence

- `<command/check/review>`: <result>
- Not run: <checks intentionally not run and why>

## Open questions / risks

- <unknowns, stale assumptions, pending review items>

## Acceptance criteria / done state

- <how the next agent knows the next slice is complete>

## Suggested skills / agents

- `<skill or agent>`: <when to use it>

## Next prompt

Continue from this handoff. First verify referenced files/state, then proceed with: <specific next action>
```

## Workflow

1. Identify the next session's purpose. If the user gave a focus, tailor the handoff to that focus.
2. Gather durable facts: objective, current state, changed files, decisions, constraints, verification evidence, risks, acceptance criteria, and next steps.
3. Remove duplicate content already captured in plans, PRDs, ADRs, KB notes, commits, or diffs; reference those artifacts instead.
4. Redact sensitive information.
5. Write the handoff in the format above.
6. State the intended transport separately: chat response, temp file, tmux paste, PR comment, or other.

## Common mistakes

- Too short: omits files, decisions, verification, or risks.
- Too long: dumps transcript instead of durable state.
- Verification theater: says “done/passing” without evidence.
- Transport coupling: bakes tmux, Slack, or file-saving behavior into the content format.
- Missing next prompt: leaves the next agent to infer what to do.
