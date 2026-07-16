---
name: kb-query
description: Use when the user asks to check, query, search, pull from, or answer using the local AI knowledge base before responding.
---

# Query Knowledge Base

Answer from `~/.config/ai/knowledge-base` first, then state exactly what the KB does or does not know.

## Rules

- KB root: `~/.config/ai/knowledge-base`.
- Read `AGENTS.md` before using KB material.
- Wiki-first lookup: `wikis/*/index.md` before raw notes/captures.
- Raw captures are for provenance/detail, not first-pass browsing.
- Respect `visibility` and `allowed_llm`: do not load `allowed_llm: local-only` material in hosted runtimes; for `allowed_llm: ask`, ask before quoting or using detailed work-private content unless the user has already approved this query.
- Do not answer from memory when the user asked for KB-backed knowledge.
- If no KB material exists, say that clearly and offer to capture it.

## Workflow

1. **Identify likely wiki.** Agent/workflow questions usually start at `wikis/agent-workflows`; Polygraph/work questions usually start at `wikis/work-polygraph`.
2. **Read control docs.** Read KB `AGENTS.md`, then target wiki `AGENTS.md` if present, then target wiki `index.md` and recent `log.md` entries.
3. **Search variants.** Search exact terms plus common variants: punctuation, route names, slugs, acronyms, and synonyms.
4. **Load compiled pages.** Read only relevant concepts, projects, runbooks, decisions, patterns, syntheses, or questions.
5. **Open raw only when needed.** Read raw captures/notes only for exact evidence, contradiction resolution, repo commit/source metadata, or stale claims.
6. **Check staleness.** For repo-derived claims, report captured commit/date/scope when present.
7. **Answer with citations.** Include `[[wiki-links]]` where useful, exact wiki/source paths, and note whether the answer is complete, stale, or absent.
8. **Offer capture/update.** If missing or stale, offer `kb-capture-codebase` or wiki refresh as the next step.

## Output shape

```markdown
KB answer:
<answer grounded in KB>

Sources:
- `<wiki/source/raw path>` — <what it supports>

Staleness / limits:
- <commit/date/scope gaps, missing captures, unverified areas>

Next KB action:
- <capture, refresh, save synthesis/question, or none>
```

## Common mistakes

- Broad searching raw files before reading wiki indexes.
- Returning general model knowledge when KB is empty.
- Omitting source paths or commit/date boundaries.
- Quoting sensitive work-private details unnecessarily.
- Treating stale captures as current code reality.
