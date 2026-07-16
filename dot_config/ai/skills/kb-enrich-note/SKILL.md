---
name: kb-enrich-note
description: Use when enriching a raw manual note, pasted note, source clipping, or handwritten/voice note in the local AI knowledge base before wiki refresh.
---

# Enrich Knowledge Base Note

Prepare a raw manual note for wiki compilation without rewriting the source material.

## Rules

- Resolve KB root in order: explicit override, KB config file if present, otherwise `~/.config/ai/knowledge-base`.
- Preserve the original note body. Do not rewrite prose inside `# Note` unless the user explicitly asks for source rewriting.
- Enrichment may add/update frontmatter, tags, source/url fields, `## Related`, and manifest metadata.
- Respect `allowed_llm`: stop for `local-only` in hosted/unknown runtimes; ask before detailed use of any `allowed_llm: ask` note, especially personal-private or work-private notes.
- Redact or stop on secrets, credentials, customer data, private logs, or unnecessary personal data.
- Use `tags.md` as the registry; add tags reluctantly.

## Workflow

1. **Locate note.** Confirm the raw note path and KB root.
2. **Privacy preflight.** Check `visibility`, `allowed_llm`, secrets/customer/person identifiers, and source sensitivity before reading/rewriting anything substantial.
3. **Check idempotency.** If frontmatter has current `enrichedAt` and manifest hash/status shows unchanged content, report no-op instead of restamping.
4. **Preserve body.** Keep original note text intact. Add missing `# Note` wrapper only if needed and without changing body wording.
5. **Normalize frontmatter.** Add missing required fields from `templates/raw-note.md`; preserve unknown existing fields.
6. **Tag from registry.** Read `tags.md`; reuse existing tags. Add a new tag only when it creates durable retrieval value, and update `tags.md` with category/description.
7. **Research source only when safe.** If the note came from a public source and URL/source is missing, research enough to fill `source` and `url`. Keep source-derived facts separate from the user's note body.
8. **Find related material.** Search wiki indexes and raw notes for genuinely related content.
9. **Update `## Related`.** Add wikilinks/source links with short reasons.
10. **Stamp enrichment.** Set `enrichedAt` to current ISO-8601 time only when note/frontmatter/tags/Related content changes; do not restamp for manifest-only repair. Set `status: enriched` when ready for wiki refresh.
11. **Update manifest.** Update `.kb/manifest.json` with note path, content hash if available, enrichment status, timestamp, visibility, and target wiki hints.
12. **Report next action.** State whether to run `kb-refresh-wiki` and which wiki/page is likely affected.

## Output report

```markdown
Enriched note: `<path>`
Preserved body: yes | no, why
Frontmatter changed:
Tags changed:
Related links changed:
Manifest updated:
Privacy/staleness notes:
Next KB action:
```

## Common mistakes

- Rewriting messy raw notes into polished wiki prose.
- Adding tags without checking `tags.md`.
- Restamping `enrichedAt` on unchanged notes.
- Blending public source research into the user's original note body.
- Updating the note but not the manifest.
- Ignoring `allowed_llm` because the note is local.
