---
name: kb-lint
description: Use when checking, auditing, linting, repairing, or health-checking the local AI knowledge base for metadata, links, privacy, staleness, tags, indexes, logs, or provenance issues.
---

# Lint Knowledge Base

Audit `~/.config/ai/knowledge-base` for health issues. Fix only deterministic mechanical problems; turn judgment calls into questions.

## Rules

- Resolve KB root in order: explicit override, KB config file if present, otherwise `~/.config/ai/knowledge-base`.
- Read KB `AGENTS.md` first.
- Never publish, sync, move, delete, or broadly rewrite KB content without explicit approval.
- Do not expose secrets or sensitive snippets in the report; name paths and redact values.
- Mechanical fixes must be deterministic, reversible, and convention-backed.
- Judgment calls become `wikis/<name>/questions/` entries or a report section, not silent edits.

## Checks

- Manual raw notes missing frontmatter, tags, `## Related`, or current `enrichedAt` according to `.kb/manifest.json` content hash/status when available.
- Codebase captures missing repo identity, remote/branch/commit, scope, evidence, or suggested wiki updates.
- Source/wiki pages missing required frontmatter or citations.
- `tags.md` drift, duplicates, casing variants, or unused/undefined tags.
- Broken markdown links, wikilinks, anchors, image refs, and unapproved absolute local paths in links/body. Absolute local paths are allowed in repo metadata fields when they describe local source identity.
- Orphan pages not reachable from wiki `index.md`.
- `index.md` entries missing or stale.
- `log.md` parseability and missing refresh entries.
- Thin pages with claims but no sources.
- Duplicated/overlapping concepts.
- Stale claims superseded by newer sources.
- Contradictions lacking explicit notes.
- Secrets, tokens, private keys, credentialed logs, raw customer/person identifiers, and sensitive snippets. Report paths only; redact values.
- Privacy leaks across `public`, `personal-private`, and `work-private`.
- Derived pages with less-restrictive `visibility` than any cited source.
- Derived pages with less-restrictive `allowed_llm` than any cited source.
- `allowed_llm: local-only` bodies that would need hosted-model reading; report path-only in hosted/unknown runtimes.

## Workflow

1. **Scope.** Identify root, wiki(s), and whether fixes are allowed or report-only.
2. **Safety preflight.** Scan for obvious secrets/private data before quoting content.
3. **Inventory.** List wikis from `.kb/manifest.json` and actual `wikis/` folders; note mismatches.
4. **Run checks.** Inspect metadata, links, tags, indexes, logs, citations, provenance, staleness, and privacy boundaries.
5. **Classify findings.** Mechanical fix | judgment question | user-approval-required.
6. **Apply mechanical fixes only if requested.** Examples: add missing index link when target is obvious, fix broken relative path casing, normalize duplicate tag casing, add missing log parse markers when source is known.
7. **Record judgment questions.** Create or propose `wikis/<name>/questions/<slug>.md` for concept merges, privacy classification, deletion, stale claim interpretation, or canonical taxonomy choices.
8. **Report.** Summarize fixed issues, unresolved questions, privacy risks, stale areas, and next recommended KB actions.

## Output shape

```markdown
KB lint result:
- root:
- scope:

Fixed mechanical issues:
- ...

Needs user judgment:
- ...

Privacy / allowed_llm risks:
- ...

Staleness / provenance gaps:
- ...

Next actions:
- ...
```

## Common mistakes

- Auto-merging concepts because names look similar.
- Adding frontmatter values that are not deterministic.
- Quoting secrets/private data in a lint report.
- Treating orphan pages as safe to delete.
- Regenerating hand-maintained indexes without knowing the source of truth.
