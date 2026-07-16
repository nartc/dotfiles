---
name: kb-refresh-wiki
description: Use when compiling new or changed knowledge-base captures, notes, or sources into a wiki under the local AI knowledge base.
---

# Refresh Knowledge Base Wiki

Compile enriched notes or agent-authored captures into `~/.config/ai/knowledge-base/wikis/<name>` without losing provenance or overwriting contradictions.

## Rules

- Default KB root: `~/.config/ai/knowledge-base`; use an explicitly supplied KB root if the user overrides it.
- Work-private material is one source/capture at a time unless the user explicitly asks to batch.
- Read target wiki `AGENTS.md`, `index.md`, and recent `log.md` before editing.
- Every durable claim needs a source/capture citation.
- Update source pages, affected wiki pages, index, and log together.
- Do not silently overwrite old claims. Record contradiction/staleness notes.
- Do not copy raw captures wholesale into wiki pages.

## Workflow

1. **Pick target wiki.** Identify `wikis/<name>` and read its `AGENTS.md`, `index.md`, and recent `log.md`.
2. **Select source.** Choose one new/changed enriched note or capture artifact. For work-private content, stop after one unless batching was approved.
3. **Check no-op boundary.** Before editing, check existing `sources/<slug>.md`, recent `log.md`, and source metadata. For manual notes, use `enrichedAt`/hash if available. For codebase captures, use `repo_commit` and `scope`. If unchanged and already compiled, stop and report no-op.
4. **Privacy preflight.** If `allowed_llm: local-only` and the current model/runtime is hosted or unknown, stop. If `allowed_llm: ask`, ask before compiling detailed content. If secrets, credentialed logs, raw customer/person identifiers, or unredacted data are present, stop for redaction. Source and affected pages inherit the strictest `visibility` and `allowed_llm` from their inputs.
5. **Create/update source page.** Write `wikis/<name>/sources/<slug>.md` with required frontmatter, provenance, key claims, affected pages, citations, and limitations.
6. **Run association impact analysis.** Identify affected concepts, entities, projects, decisions, patterns, runbooks, syntheses, and questions.
7. **Update affected pages.** Add concise sourced knowledge. Preserve older claims with contradiction or superseded notes when needed.
8. **Update index.** Ensure new/changed pages are reachable from `index.md`.
9. **Append log.** Add a parseable entry to `log.md`.
10. **Report idempotency.** State which raw source was processed, which pages changed, and whether rerunning should be a no-op.

## Log format

```markdown
## [YYYY-MM-DD] refresh | <source title>

- raw: `<raw/source path>`
- wiki: `wikis/<name>`
- updated: `<wiki page>`, `<wiki page>`
- notes: <short summary, contradiction/staleness notes if any>
```

## Source page shape

```markdown
---
title: "<source title>"
visibility: public | personal-private | work-private
source_type: codebase-exploration | topic-capture | article | meeting-note | other
origin: "<raw path or source>"
source: "<human-readable source label>"
url:
repo:
repo_remote:
repo_branch:
repo_commit:
scope:
captured_at: "<YYYY-MM-DD>"
allowed_llm: hosted-ok | local-only | ask
enrichedAt:
status: compiled
confidence: low | medium | high
tags: []
---

# <source title>

## Provenance

- raw: `<path>`
- captured/enriched: `<date>`
- visibility / allowed_llm:
- repo / commit / scope, if applicable:

## Key claims

- <claim> — citation `<raw path#section>`

## Affected pages

- `<wiki page>` — <change made>

## Limits / contradictions

- <staleness, missing evidence, conflicting source>
```

## Common mistakes

- Folding multiple work-private captures into one blended summary.
- Updating topic pages but forgetting source page, index, or log.
- Removing stale claims instead of marking superseded/contradicted.
- Dropping repo commit/scope from codebase captures.
- Creating a wiki page that cannot be traced back to raw evidence.
