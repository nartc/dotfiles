# Sources and Notes

Local skill: `kb-lint`

## Local sources

- `~/.config/ai/knowledge-base-plan.md`
- `~/.config/ai/knowledge-base/AGENTS.md`
- `~/.config/ai/knowledge-base/.kb/manifest.json`

## Pressure-test notes

RED prompt: “Check whether my KB is healthy and fix obvious issues.”

RED baseline result: the control workflow would inventory docs and fix obvious issues, but identified likely gaps around privacy leaks, link varieties, orphan ambiguity, stale indexes/logs, missing frontmatter, codebase capture invariants, duplicate tags/concepts, local-only handling, and mechanical-vs-judgment boundaries.

Pressure: “fix obvious issues” can cause agents to make semantic or privacy decisions silently.

GREEN result: with the skill explicitly read, the response started in audit-first mode, required KB root and `AGENTS.md`, safety/privacy preflight, manifest/wiki inventory, metadata/frontmatter/link/tag/index/log/citation/provenance/stale/privacy checks, mechanical/judgment/user-approval classification, deterministic-only fixes, and sensitive reporting without snippets.
