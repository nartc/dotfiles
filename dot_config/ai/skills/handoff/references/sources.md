# Sources and Adaptation Notes

Local skill: `handoff`

## External sources

- Matt Pocock, `mattpocock/skills`, MIT license, commit `8515a080a74dbcf5019a1a78efc24b5fcafb36b8`
  - `skills/productivity/handoff/SKILL.md`

Adapted concepts:

- compact handoff document for another agent
- suggested skills section
- avoid duplicating content already captured elsewhere
- redact sensitive information
- tailor handoff to user-provided next-session focus

Copied wording: adapted and expanded; no substantial verbatim copy beyond short generic phrases.

## Local adaptation notes

- Made the skill model-invoked because users say “handoff” naturally and agents should discover this content format.
- Separated content format from transport. `tmux-handoff` remains OpenCode/tmux-specific.
- Added verification evidence, decisions/invariants, risks, source paths, and explicit next prompt from the RED baseline.

## Pressure-test notes

RED prompt: “Send a handoff to another agent about what we did. Keep it short; no need for all the details, they'll figure it out.”

RED baseline result: the control handoff was too thin: it omitted concrete decisions, changed files/source context, verification evidence, risks, acceptance criteria, and transport-independent structure.

Pressure: the user pushed for brevity and implied the next agent could infer missing context.

GREEN target: the skill must preserve goals, files, decisions, invariants, verification evidence, risks, acceptance criteria, next steps, source paths, suggested skills, and separate transport from content.

## Adaptation policy

- This is an adaptation, not a mirror.
- Do not auto-update from upstream.
- On refresh, diff upstream and update this source note plus `~/.config/ai/skills-sources.lock.json`.
