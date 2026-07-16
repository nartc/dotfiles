# Sources and Notes

Local skill: `kb-refresh-wiki`

## Local sources

- `~/.config/ai/knowledge-base/AGENTS.md`
- `~/.config/ai/knowledge-base-plan.md`
- `~/.config/ai/knowledge-base/wikis/work-polygraph/AGENTS.md`
- `~/.config/ai/knowledge-base/wikis/work-polygraph/index.md`

## Pressure-test notes

RED prompt: “Refresh my work-polygraph wiki from the latest captures. Just fold everything in.”

RED baseline result: the control workflow planned to locate captures, inspect wiki structure, merge reusable facts into pages, update obvious index links, and do a final duplicate/stale pass. Its self-critique identified gaps around one-source-at-a-time work-private handling, wiki instructions/index/log, citations, contradiction notes, source pages, silent overwrites, and idempotency/staleness.

Pressure: “just fold everything in” encourages batching and provenance loss.

GREEN result: with the skill explicitly read, the response rejected blended “fold everything in” as the default, required target wiki control docs, per-capture privacy preflight, source pages, association impact analysis, cited updates, contradiction/staleness notes, index/log updates, and idempotency reporting. This follow-up tightened local-only/ask privacy gates, pre-edit no-op checks, required frontmatter, and parseable log format.
