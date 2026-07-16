# Sources and Notes

Local skill: `kb-query`

## Local sources

- `~/.config/ai/knowledge-base/AGENTS.md`
- `~/.config/ai/knowledge-base/README.md`
- `~/.config/ai/knowledge-base-plan.md`

## Pressure-test notes

RED prompt: “Check my KB before answering: what do we know about Polygraph prepare.data?”

RED baseline result: the control workflow knew to search the KB, but identified likely gaps around proving KB root, wiki-first lookup, limiting raw captures, source/staleness citations, privacy metadata, and not hallucinating when no capture exists.

Pressure: the topic is known-ish, so an agent may answer from memory instead of KB evidence.

GREEN target: the skill must force KB root, control docs, wiki-first lookup, variant search, raw-only-when-needed, privacy/staleness checks, source citations, and “no KB material found” behavior.
