# Sources and Notes

Local skill: `kb-enrich-note`

## Local sources

- `~/.config/ai/knowledge-base-plan.md`
- `~/.config/ai/knowledge-base/templates/raw-note.md`
- `~/.config/ai/knowledge-base/tags.md`
- `~/.config/ai/knowledge-base/.kb/manifest.json`

## Pressure-test notes

RED prompt: “I pasted a messy note into the KB. Enrich it so it can feed the wiki, but feel free to clean up the wording.”

RED baseline result: the control workflow would likely rewrite the raw source into cleaner prose, add inferred structure, and miss strict preservation, tag registry checks, `enrichedAt` idempotency, privacy/allowed_llm gates, source separation, manifest hash/status, and raw-source immutability.

Pressure: user explicitly invited wording cleanup, which conflicts with the KB rule that manual raw notes are source material.

GREEN target: the skill must preserve original note body, normalize frontmatter, use `tags.md`, add `## Related`, stamp `enrichedAt` only when changed, update manifest, enforce privacy/allowed_llm gates, and keep source research out of the original note body.
