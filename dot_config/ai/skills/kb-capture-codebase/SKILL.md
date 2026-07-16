---
name: kb-capture-codebase
description: Use when the user asks to capture, map, document, preserve, or add a repo area, codebase flow, subsystem, architecture path, runbook, or work topic into the local AI knowledge base.
---

# Capture Codebase Knowledge

Capture focused repo understanding into `~/.config/ai/knowledge-base` so future agents can reuse it.

## Rules

- KB root: `~/.config/ai/knowledge-base`.
- Global KB only by default. Do not create repo-local docs unless the user asks.
- Work-private by default: `visibility: work-private`, `allowed_llm: ask`.
- Never store secrets, tokens, private keys, credentialed logs, raw customer data, or full transcripts.
- Durable claims need evidence: `repo@commit:path:line` or `repo@commit:path#symbol`.
- Do not run tests/builds unless explicitly asked. Record discovered commands and whether they were run.

## Workflow

1. Capture intent: repo path, question/flow, scope, target wiki.
2. Privacy preflight: sensitivity, hosted-model allowance, secret/PII risk.
3. Record repo identity: local path, remote URL, branch, commit SHA, dirty status, selected scope.
4. Explore narrowly. For broad areas, dispatch focused agents for structure, flow, domain vocabulary, tests/checks, and gotchas.
5. Write one raw artifact at `raw/work/codebase-explorations/YYYY-MM-DD-<repo>-<area>.md` using `templates/codebase-exploration.md`.
6. Update the relevant wiki, usually `wikis/work-polygraph` or `wikis/agent-workflows`:
   - add source link under `sources/` only if useful
   - update concepts/projects/runbooks/patterns/questions with reusable knowledge
   - append `log.md`
7. Report changed KB files and stale/unknown areas.

## Capture quality bar

Include:

- question and scope
- repo identity and commit boundary
- architecture map
- important files/symbols
- control/data flow
- domain vocabulary
- conventions
- tests/checks/commands discovered
- gotchas
- open questions
- evidence list
- suggested wiki updates

Avoid:

- copying large code blocks
- dumping search results
- unsourced architecture claims
- treating a quick scan as complete truth
- mixing multiple unrelated areas in one capture

## If the user says “be quick”

Still record repo identity, privacy defaults, source evidence, and open questions. Speed reduces scope, not provenance.
