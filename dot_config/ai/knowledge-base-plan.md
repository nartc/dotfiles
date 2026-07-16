# Personal/Work LLM Knowledge Base Plan

## Source notes

- Ben Holmes' X Article body was not fetchable directly by tools, but the user pasted the full text into the session.
- Article-specific additions: raw markdown notes, `/enrich-note`, shared `tags.md`, `enrichedAt` idempotency, per-topic `wikis/`, `/refresh-wiki`, scheduled loops, and generated HTML visualizations.
- Karpathy's `llm-wiki` gist was fetched and remains the verified source for the underlying compile-not-retrieve pattern.

Core idea: do not treat the knowledge base as raw-file RAG. Treat agents as explorers, compilers, and bookkeepers. The primary workflow is agent-led capture: point agents at a repo area or work topic, let them investigate, and have them write durable distilled artifacts into the global KB. Manual raw notes remain supported, but secondary.

## Goals

- Plain markdown, git-friendly, local-first.
- One durable home for personal AI workflow knowledge and work knowledge that should not disappear into chat history.
- Primary capture is agent-led codebase/work exploration: point agents at a repo area and have them map architecture, flows, conventions, and gotchas into the KB.
- Manual raw notes are secondary: if used, they can be messy, voice-transcribed, headerless markdown.
- Enrichment before wiki compilation: tags, source URLs, repo metadata, timestamps, and related links make raw artifacts useful before they become wiki knowledge.
- Per-topic compiled wikis, not one giant undifferentiated wiki.
- No vector DB/RAG infrastructure until scale proves `index.md` + file search is insufficient.
- Safe handling for work-private material: private by default, no secrets, no accidental publication.

## Non-goals for v1

- No automatic Slack/Linear/GitHub ingestion.
- No scheduled agents until manual enrichment and wiki refresh are boring and idempotent.
- No embedding/vector search.
- No publishing or sharing workflow.
- No cloud automation/Oz/Obsidian Sync until local workflow proves useful and work-private boundaries are explicit.
- No dumping entire transcripts as “knowledge”. Capture distilled decisions, runbooks, patterns, and source references instead.

## Root

Use a dedicated local folder under the canonical AI config root:

```text
~/.config/ai/knowledge-base/
```

Reason: the user's preference is that all AI-related agent config, skills, and durable agent-facing memory live under `~/.config/ai`. Treat `knowledge-base/` as data, not config: keep publication, git, sync, and work-private handling explicit.

## Ownership model

- Human owns capture intent, privacy decisions, `tags.md` review, and high-level control docs.
- Agents may create raw capture artifacts under `raw/work/codebase-explorations/` and `raw/work/topic-captures/` through documented capture workflows.
- Agents enrich manual raw notes in place only through the `enrich-note` workflow.
- Agents own `wikis/<name>/`, each wiki's `index.md`, and each wiki's `log.md` edits, but only through documented workflows.
- Agents may suggest saving query outputs; humans decide whether they become durable pages.
- Manual `raw/` content is human-authored source material. Agents may add metadata, `## Related`, and enrichment timestamps; they must not rewrite the original note body unless explicitly asked.
- Agent-authored raw capture artifacts are distilled notes, not transcript dumps or code dumps. They must cite exact repo files/commits or source paths for durable claims.

## Folder structure

```text
~/.config/ai/knowledge-base/
  AGENTS.md                 # operational contract for agents
  README.md                 # human orientation
  tags.md                   # shared tag registry, maintained conservatively

  inbox/                    # unclassified captures; not ingested automatically

  raw/                      # source-like capture artifacts
    handwritten/            # optional manual notes
      public/
      personal/
      work/
    source-clippings/       # articles, docs, pasted external sources
      public/
      personal/
      work/
    work/
      codebase-explorations/# primary agent-authored repo/area maps
      topic-captures/       # agent-authored work-topic captures not tied to one repo
      meeting-distillations/# optional later; distilled, not transcript dumps

  wikis/                    # one compiled wiki per area of interest
    agent-workflows/
      AGENTS.md             # wiki-specific schema and maintenance rules
      index.md              # content catalog for this wiki
      log.md                # append-only activity log for this wiki
      sources/              # one page per ingested raw note/source
      concepts/             # reusable concepts/frameworks
      entities/             # people, orgs, teams, tools, services
      projects/             # active/past workstreams
      decisions/            # ADR-style decisions
      patterns/             # repeated engineering/workflow heuristics
      runbooks/             # operational procedures and gotchas
      syntheses/            # durable answers/research outputs
      questions/            # open questions and research gaps
    work-polygraph/
      AGENTS.md
      index.md
      log.md
      sources/
      concepts/
      entities/
      projects/
      decisions/
      patterns/
      runbooks/
      syntheses/
      questions/

  visualizations/           # generated HTML views, later phase
    notes-burndown/
    thought-constellation/
    work-map/

  templates/
    raw-note.md
    codebase-exploration.md
    topic-capture.md
    source.md
    concept.md
    entity.md
    project.md
    decision.md
    pattern.md
    runbook.md
    synthesis.md
    question.md

  .kb/
    manifest.json           # tracked note/wiki status, hashes, visibility
```

## Required frontmatter

Every raw source and compiled page should carry enough metadata for agents to reason safely.

```yaml
---
title: Example
visibility: public | personal-private | work-private
source_type: article | meeting-note | incident | code-review | codebase-exploration | topic-capture | decision | runbook | chat-distillation | other
origin: url-or-human-note
source: human-readable source label or absent
url: source URL or absent
repo: owner/repo or local path or absent
repo_remote: git remote URL or absent
repo_branch: git branch or absent
repo_commit: git commit SHA or absent
scope: files/directories/packages explored or absent
captured_at: YYYY-MM-DD
allowed_llm: hosted-ok | local-only | ask
enrichedAt: ISO-8601 timestamp or absent
status: raw | enriched | compiled | superseded
confidence: low | medium | high
---
```

Derived pages inherit the most restrictive `visibility` and `allowed_llm` from their sources. For manual raw notes, `enrichedAt` is the idempotency marker. The enrichment loop should skip notes with unchanged content and a current `enrichedAt`. For codebase captures, `repo_commit` and source citations are the staleness boundary; later captures from newer commits should supersede or update earlier claims instead of pretending the old map is timeless.

## Tag registry

`tags.md` is a shared registry, not a tag dump.

Rules:

- Reuse existing tags before adding new ones.
- Add new tags only when a note clearly needs a durable retrieval axis.
- Prefer medium/topic tags such as `podcast`, `video`, `book`, `agent-workflows`, `polygraph`, `grafana`, `ai-hardware` over one-off novelty tags.
- Each tag gets one line: tag name, category, and description.
- Remove or merge near-duplicates during lint, not during normal enrichment.

## Page types

- **source**: provenance, concise summary, key claims, affected pages, citations.
- **concept**: cross-source synthesis, current understanding, contradictions, related pages.
- **entity**: person/org/tool/service/team/project profile.
- **project**: goal, status, decisions, open questions, linked sources/runbooks.
- **decision**: context, options, decision, consequences, reversibility.
- **pattern**: repeated preference or heuristic worth reusing in future agent sessions.
- **runbook**: exact procedure, commands, caveats, failure modes, verification.
- **synthesis**: durable answer from a query; saved only if reusable.
- **question**: unresolved gap, evidence so far, next source/check.

## Core workflows

### 1. Capture codebase area

Primary workflow. Use when the user wants to understand a repo area and preserve the findings for future team or AI conversations.

1. Capture intent: write the question, target repo, target directories/files, and desired wiki, usually `wikis/work-polygraph` or `wikis/agent-workflows`.
2. Privacy preflight: check repo/work sensitivity, `allowed_llm`, secrets risk, customer/person identifiers, and whether hosted models are acceptable.
3. Record repo identity: local path, remote URL, branch, commit SHA, package/app name, and selected scope.
4. Dispatch focused exploration agents when the scope is broad:
   - structure/file map
   - control/data flow
   - domain vocabulary
   - tests/checks/commands
   - gotchas/open questions
5. Synthesize a raw capture artifact under `raw/work/codebase-explorations/YYYY-MM-DD-<repo>-<area>.md`.
6. Include only durable understanding, not transcript dumps or code dumps.
7. Cite claims with exact evidence: `repo@commit:path/to/file.ts#symbol` or `repo@commit:path/to/file.ts:line` when line numbers are stable enough.
8. Add suggested wiki updates: pages to create/update under projects, concepts, entities, decisions, runbooks, syntheses, and questions.
9. Refresh the target wiki from the capture artifact.

Codebase capture artifact sections:

```markdown
# Question

# Scope

# Repo identity

# Architecture map

# Important files and symbols

# Control/data flow

# Domain vocabulary

# Conventions

# Tests/checks/commands

# Gotchas

# Open questions

# Evidence

# Suggested wiki updates
```

### 2. Enrich manual note

Secondary workflow. Use for handwritten, voice-transcribed, clipped, or pasted markdown notes before they feed any wiki.

1. Privacy preflight: check `visibility`, `allowed_llm`, secrets, customer/person identifiers, proprietary logs.
2. Preserve the note body. Add or update frontmatter only.
3. Add tags from `tags.md`; coin new tags reluctantly and update `tags.md` when doing so.
4. If the note came from a public source, research and record `source` and `url` when findable.
5. Grep/search other raw notes and wiki indexes for genuinely related notes.
6. Add/update a `## Related` section with wikilinks.
7. Stamp `enrichedAt` with the current ISO-8601 time.
8. Update `.kb/manifest.json` with note hash and enrichment status.

### 3. Refresh wiki

Use for compiling enriched manual notes or agent-authored capture artifacts into one or more per-topic wikis.

1. Read the target wiki's `AGENTS.md`, `index.md`, and recent `log.md` entries.
2. Find new/changed enriched notes or capture artifacts relevant to that wiki.
3. Create or update `wikis/<name>/sources/<slug>.md`.
4. Run association impact analysis: which concepts/entities/projects/decisions/runbooks are affected?
5. Update affected pages with citations and contradiction notes instead of silently overwriting old claims.
6. Update the target wiki's `index.md`.
7. Append the target wiki's `log.md` entry with parseable prefix:

```markdown
## [YYYY-MM-DD] refresh | note title

- raw: `raw/work/YYYY-MM-DD-source.md`
- wiki: `wikis/work-polygraph`
- updated: `wikis/work-polygraph/sources/source.md`, `wikis/work-polygraph/projects/example.md`
- notes: short summary
```

Use one source/note/capture artifact at a time for work-private material unless explicitly batching.

### 4. Query

1. Identify the relevant wiki or wikis.
2. Read the relevant wiki's `AGENTS.md` and `index.md` first.
3. Load only relevant compiled pages.
4. Load raw notes or capture artifacts only when exact provenance/detail is needed.
5. Answer with `[[wiki-links]]` and source citations.
6. If the answer is durable synthesis, ask whether to save it under `wikis/<name>/syntheses/` or `wikis/<name>/questions/`.

### 5. Lint / health check

Run periodically or after several refreshes.

Checks:

- raw notes missing frontmatter, tags, related links, or `enrichedAt`
- codebase captures missing repo identity, commit, scope, evidence, or suggested wiki updates
- tag registry drift or duplicate tags
- broken links
- orphan pages
- thin pages that need sources
- duplicated/overlapping concepts
- stale claims superseded by newer sources
- contradictions lacking explicit notes
- `index.md` entries missing or stale
- `log.md` parseability
- privacy leaks across `public`, `personal-private`, and `work-private`

Agents may fix mechanical issues. Judgment calls become `wikis/<name>/questions/` entries.

### 6. Backfill from chat/work

Use only for distilled knowledge:

- decisions made
- repeated workflows
- runbooks/gotchas
- product/team/project context
- unresolved questions

Do not ingest full private transcripts unless explicitly requested. Create a short raw distillation or topic capture, enrich it, then refresh relevant wikis.

### 7. Automations, later

Only automate after manual runs are idempotent.

- `enrich-notes-loop`: walk recent raw notes, skip notes whose content hash matches manifest and whose `enrichedAt` is current.
- `refresh-wiki`: walk `wikis/`, update each wiki from relevant new/changed enriched notes and capture artifacts, then lint.
- Local schedule first. Cloud/Oz-style runner only after sync, secrets, and work-private boundaries are explicit.

### 8. Visualizations, later

Generate static or live HTML views from markdown after the first wikis have enough data:

- notes burndown: activity graph of note-taking/enrichment over time
- thought constellation: graph clustered by most-used tags and backlinks
- work map: projects/services/environments/runbooks graph for work-private wiki

Visualizations are outputs, not source of truth. They read from markdown and can be regenerated.

## Work-private rules

- Work content defaults to `visibility: work-private` and `allowed_llm: ask`.
- Never store tokens, credentials, cookies, private keys, or raw customer identifiers.
- Redact or alias customer/person names unless the exact name is required for local work.
- Do not push, publish, sync, or share work-private pages without explicit approval.
- Do not send `allowed_llm: local-only` sources to hosted models.
- Derived pages inherit the strictest source visibility.
- Cloud automation is opt-in per wiki and disabled for `work-private` until explicitly approved.

## Initial work knowledge candidates

The first useful work captures should be narrow and reusable:

1. Codebase map for Polygraph `prepare.data` flow and adjacent routes/API calls.
2. Codebase map for Polygraph production monitoring and client-error reporting flow.
3. Grafana/gcx workflows that are easy to forget.
4. Agent/Polygraph shipping conventions and pitfalls.
5. Nx/RedPanda/Polygraph project glossary: teams, services, environments, dashboards, common routes.
6. “Things agents keep getting wrong at work” as patterns/runbooks.

## Initial wikis

Start with two focused wikis instead of one global wiki:

1. `wikis/agent-workflows`: AI workflow notes, agent skills, orchestration patterns, review/check habits, tool conventions.
2. `wikis/work-polygraph`: Polygraph/Grafana/Nx work knowledge, runbooks, incident taxonomy, service glossary, shipping pitfalls.

Add more wikis only after these have useful indexes and repeated queries.

## Implementation slices

### Slice 1: scaffold the KB contract

Create the folder tree, root `AGENTS.md`, `README.md`, `tags.md`, first two `wikis/<name>/AGENTS.md`, `index.md`, `log.md`, templates, and `.kb/manifest.json`.

Acceptance checks:

- root exists at chosen location
- all top-level folders exist
- `tags.md` exists with initial conservative tags
- `wikis/agent-workflows` and `wikis/work-polygraph` exist
- templates exist for each page type
- each wiki `log.md` has parseable example entry
- privacy rules are explicit in root and wiki `AGENTS.md`

### Slice 2: create portable KB skills

Create skills under `~/.config/ai/skills`:

- `kb-capture-codebase`
- `kb-enrich-note`
- `kb-refresh-wiki`
- `kb-query`
- `kb-lint`
- optional later: `kb-backfill-chat`

Each skill should read the KB root from a small config file, not hardcode paths if avoidable.

### Slice 3: prove the primary codebase loop manually

Run `kb-capture-codebase` on one focused repo area:

1. target one repo path and one area, such as Polygraph `prepare.data`
2. record remote, branch, commit, selected directories/files
3. dispatch focused exploration agents if the area spans multiple modules
4. create one raw capture under `raw/work/codebase-explorations/`
5. refresh `wikis/work-polygraph`
6. query the wiki for a team-conversation summary
7. save only genuinely reusable output

### Slice 4: prove the secondary manual-note loop

Enrich and refresh 5 small sources:

1. one public article about LLM wikis
2. one personal agent-workflow preference note
3. one work runbook/gotcha, redacted
4. one decision from the config/skills cleanup
5. one current-project glossary note

Then run one query and one lint pass. Save only genuinely reusable output.

### Slice 5: add loops only after manual idempotency

Create `kb-enrich-notes-loop` and `kb-refresh-wiki-loop` only after Slices 3 and 4 prove hashes, `enrichedAt`, repo commits, and wiki logs prevent repeated churn.

### Slice 6: add local search only if needed

Start with `index.md`, `grep`, and file search. Add `qmd` or a tiny search script only after the manual loop feels too slow.

### Slice 7: work capture workflow

Define a repeatable “capture work knowledge” ritual:

- source template for incidents/runbooks
- redaction checklist
- allowed-LLM decision
- review-before-save step

### Slice 8: visualizations

Generate one static HTML view from notes after there is enough data:

1. notes burndown, if journaling/capture habit matters first
2. thought constellation, if tag/link exploration matters first
3. work map, if work knowledge/navigation matters first

## Open questions for morning

1. Should work-private sources be stored in a separate git repo from personal/public sources?
2. Which first codebase area should be captured?
3. Should Obsidian, Hubble.md, or a plain editor be the default viewer?
4. Should the first visualization be notes burndown, thought constellation, or work map?
