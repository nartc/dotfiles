# Global AI Tooling Inventory

Current policy: **hybrid**.

- Research/docs tools may stay globally available.
- Credentialed, destructive, or broad local-code-execution tools are reviewed per harness and should be enabled only when intentionally needed.
- Shared instructions live at `~/.config/ai/agents.md` and are symlinked by OpenCode, Claude, and Codex.
- Portable personal skills live at `~/.config/ai/skills`; runtime-visible skill folders should be symlinks unless a skill is truly harness-specific.
- Declarative AI configuration is persisted by Chezmoi: `dot_config/ai`, `dot_config/opencode`, `dot_claude`, `dot_codex`, and `dot_agents` under `~/.local/share/chezmoi`.
- Do not track standalone credentials, histories, sessions, caches, databases, downloaded/vendor plugin contents, or knowledge-base data. The private tracked Codex config currently preserves its embedded project-trust, marketplace, and hook-state sections. `~/.codex/rules/default.rules` is excluded because it is a history-specific permission allowlist, not a portable policy.

## OpenCode

### Models

- Default everyday agent: `balanced`, using `openai/gpt-5.6-terra` with the `xhigh` reasoning variant for quick chat, configuration, and focused code changes.
- Capability-focused `orchestrator` and other complex-work agents: `openai/gpt-5.6-sol`.
- Small model and lightweight specialist agents: `openai/gpt-5.6-terra`.

### MCP

| Server | Status | Notes |
|---|---:|---|
| `grep-app` | enabled | public code search |
| `exa` | enabled | web/research search |
| `context7` | enabled | library docs lookup |
| `linear` | disabled | credentialed/project-management; enable per task |
| `grafana` | disabled | credentialed observability; enable per task |
| `blender` | disabled | local code execution in Blender; enable per task |

Removed: `github`, `agent-code-reviewer`, `paper`.

### Plugins

| Plugin | Status | Notes |
|---|---:|---|
| `@plannotator/opencode@0.22.0` | enabled | pinned review/annotation workflow |
| `@polygraph/opencode-plugin@0.4.24` | not configured globally | add only when Polygraph OpenCode plugin tools are needed |
| `superpowers` pinned to `896224c...` | removed | replaced by local/Matt skills plus global delegation policy |

Removed: duplicate old `polygraph-opencode-plugin@latest`, local `opencode-guided-review` startup plugin.

## Claude Code

### Plugins

| Plugin | Status | Notes |
|---|---:|---|
| `document-skills@anthropic-agent-skills` | enabled | Office/PDF work |
| `example-skills@anthropic-agent-skills` | disabled | replaced with selected personal skills where useful |
| `rust-analyzer-lsp@claude-plugins-official` | enabled | keep only if Rust work matters |
| `nx@nx-claude-plugins` | enabled | Nx projects |
| `codex@openai-codex` | enabled | Claude-to-Codex delegation |
| `polygraph@polygraph-plugins` | enabled | Polygraph session work |

Removed stale/missing plugin refs: `notion-workspace-plugin@notion-plugin-marketplace`, `polygraph@nx-claude-plugins`.

Removed broken MCP: `local-pr-reviewer`.

Removed global mutating Bash allow rules: `git remote add`, `git fetch`, `git cherry-pick`, `npx nx sync-artifacts`.

## Codex

### Models

- Active model: `gpt-5.6-sol`.
- Reasoning effort: `max`, preserving the pre-existing quality-first setting. Compare with `xhigh` on representative tasks before lowering it.

### Plugins

| Plugin | Status | Notes |
|---|---:|---|
| `superpowers@openai-curated` | removed | replaced by local/Matt skills plus global delegation policy |
| `browser@openai-bundled` | enabled | browser control is intentionally available with the configured `node_repl` integration |
| `rust-analyzer-lsp@claude-plugins-official` | enabled | keep only if Rust work matters |
| `documents@openai-primary-runtime` | enabled | Codex-native artifacts |
| `pdf@openai-primary-runtime` | enabled | Codex-native artifacts |
| `spreadsheets@openai-primary-runtime` | enabled | Codex-native artifacts |
| `presentations@openai-primary-runtime` | enabled | Codex-native artifacts |
| `template-creator@openai-primary-runtime` | enabled | Codex-native artifact templates |
| `document-skills@anthropic-agent-skills` | disabled | duplicate of OpenAI primary runtime artifacts |
| `example-skills@anthropic-agent-skills` | disabled | broad/overlapping example pack |
| `codex@openai-codex` | disabled | Claude-oriented plugin; redundant inside Codex |

### MCP

| Server | Status | Notes |
|---|---:|---|
| `node_repl` | configured globally | supports the enabled browser integration; revisit whether it should move to per-task config |
| `blender` | removed from global config | keep package installed; add only for Blender tasks |

Codex has a tracked Stop hook that invokes the local Plannotator command. Its hook-state hashes remain runtime state in `config.toml`.

## External skill/resource curation

### Skill source of truth

- Canonical portable skills: `~/.config/ai/skills`.
- Runtime compatibility symlink: `~/.agents/skills -> ~/.config/ai/skills`.
- Harness-specific skills live under `~/.config/ai/harness/<runtime>/skills` and are symlinked into that runtime only.
- OpenCode's runtime skill dir should only contain OpenCode-specific symlinks; portable skills are discovered through `~/.agents/skills` to avoid duplicate OpenCode skill names.
- Codex system skills under `~/.codex/skills/.system` are vendor-managed and stay in place.
- Vendor/plugin-managed skill caches stay where the owning plugin manages them; do not edit those directly.
- Adapted third-party skills should include `references/sources.md` with source repo/path/commit and adaptation notes.

Runtime-specific canonical roots:

- OpenCode: `~/.config/ai/harness/opencode/skills`
- Claude: `~/.config/ai/harness/claude/skills`
- Codex: `~/.config/ai/harness/codex/skills` only when a Codex-specific authored skill is needed; current `ship-pg` points to portable `~/.config/ai/skills/ship-pg`.

### Adopted selected skills

- `~/.config/ai/skills/ui-taste-review`: adapted from Emil + TasteSkill for UI/design review, product-fit polish, preservation checks, and anti-slop critique.
- `~/.config/ai/skills/review-animations`: adapted from Emil's animation review standards for motion-specific code review.
- `~/.config/ai/skills/skill-authoring`: adapted from Matt Pocock, local skill-creator, and historical Superpowers process discipline for creating/reviewing skills; Superpowers reference is provenance only, not an active dependency.
- `~/.config/ai/skills/codebase-design`: adapted from Matt Pocock deep-module vocabulary for architecture review/design.
- `~/.config/ai/skills/grill-with-docs`: adapted from Matt Pocock domain modeling and Nico Bailon's `grill-for-unknowns` for terminology, evidence-first blindspot discovery, unknowns classification, material questions, reversible defaults, and alignment packets.
- `~/.config/ai/skills/manual-code-review`: adapted from Matt Pocock two-axis code review for Spec Review vs Standards Review without automatic Plannotator.
- `~/.config/ai/skills/handoff`: adapted from Matt Pocock handoff into a portable transport-independent handoff content format.
- `~/.config/ai/skills/wayfinder`: adapted from Matt Pocock wayfinder into a local `docs/agents/wayfinder/` map and ticket convention.
- `~/.config/ai/skills/prototype`: adapted from Matt Pocock prototype for throwaway UI/state/logic probes with cleanup gates.
- `~/.config/ai/skills/git-guardrails`: adapted from Matt Pocock Claude git hook guardrails into runtime-neutral git safety behavior.
- `~/.config/ai/skills/improve-react`: adapted with user-confirmed permission from `millionco/react-doctor` into a read-only, leverage-prioritized React codebase audit and self-contained planning workflow.
- `~/.config/ai/skills/agent-delegation`: local exception-only workflow for genuinely parallel validation and isolated implementation after main-agent discovery.
- `~/.config/ai/skills/ai-config`: local source-of-truth lookup workflow for shared AI instructions, portable skills, runtime-specific configuration, and deployment paths.
- `~/.config/ai/skills/bro`: local plain-language rewrite workflow for terse feedback such as "bro" or requests to restate a confusing response.
- `~/.config/ai/skills/kb-query`: local KB lookup workflow for wiki-first, cited, privacy-aware answers from `~/.config/ai/knowledge-base`.
- `~/.config/ai/skills/kb-refresh-wiki`: local KB compilation workflow for source/capture to wiki pages with citations, index, log, and contradiction notes.
- `~/.config/ai/skills/kb-enrich-note`: local KB enrichment workflow for raw manual notes while preserving source bodies and manifest/idempotency metadata.
- `~/.config/ai/skills/kb-lint`: local KB health-check workflow for metadata, links, privacy, staleness, tags, indexes, logs, and provenance.

### Portable personal skills moved into `~/.config/ai/skills`

- `fix-client-errors`
- `grill-with-docs`
- `nartc-blog-voice`
- `polygraph-prod-monitoring`
- `ship-pg`
- `skill-creator`

### Harness-specific skill sources

- OpenCode-only: `github-org-cleanup`, `ship`, `tmux-handoff` live under `~/.config/ai/harness/opencode/skills` and are symlinked into `~/.config/opencode/skills`.
- Claude wrappers: `plannotator-annotate`, `plannotator-last`, and `plannotator-review` live under `~/.config/ai/harness/claude/skills` and are symlinked into `~/.claude/skills`. Portable `improve-react` is symlinked directly from `~/.claude/skills/improve-react` to `~/.config/ai/skills/improve-react`.
- Codex: `~/.codex/skills/ship-pg` is a symlink to portable `~/.config/ai/skills/ship-pg`; `~/.codex/skills/.system` remains untouched.

### Adopt later as selected skills/references

- `emilkowalski/skills`: consider `animation-vocabulary` later if motion naming becomes useful.
- `tasteskill.dev`: use as a UI/marketing-page reference, not a global rule. Adopt only durable checks: brief inference, design dials, coherence locks, redesign preservation audit, reduced-motion/a11y preflight.
- X/loop resources: defer. Loops are not yet part of the working mental model; revisit only after a concrete recurring/autonomous workflow exists.

### Skill adaptation backlog

Preferred order:

1. Done: `skill-authoring` at `~/.config/ai/skills/skill-authoring`, consolidating Matt Pocock `writing-great-skills`, local `skill-creator`, and historical Superpowers writing discipline as provenance only.
2. Done: `codebase-design` at `~/.config/ai/skills/codebase-design`, adapting Matt Pocock deep-module vocabulary for architecture review/design.
3. Done: updated `grill-with-docs` with Matt `domain-modeling` and Nico Bailon's unknown-discovery ideas: facts vs decisions, canonical language, blindspot passes, tacit-preference prototypes, reversible defaults, and alignment packets.
4. Done: added `manual-code-review` with Spec Review vs Standards Review framing. Keep `plannotator-review` as explicit browser-based/manual review only.
5. Done: added portable `handoff` content format and updated OpenCode-specific `tmux-handoff` to use it.
6. Done: `wayfinder` local file convention under `docs/agents/wayfinder/` with `map.md` and `tickets/*.md`.
7. Done: `prototype` throwaway exploration workflow for UX/state/logic probes.
8. Done: `git-guardrails` runtime-neutral destructive-git safety behavior; do not copy Claude hooks blindly.
9. Done: removed active Superpowers plugins from OpenCode and Codex. Keep useful behavior via local/Matt skills and global instructions, not Superpowers skill names:
   - no `using-superpowers` replacement
   - no heavy `verification-before-completion`; use pragmatic evidence in summaries, lint/focused tests normally, typecheck only when explicitly requested or before push/ship/PR
   - no mandatory TDD ritual; add/update focused tests for behavior changes and regressions
    - subagent use is exception-only: use it for genuinely parallel verification or isolated implementation after main-agent discovery, never generic exploration or research
   - planning/design uses `wayfinder`, `grill-with-docs`, `manual-code-review`, and possibly Matt `to-issues` later

Do not create `agent-loop-workflows` until a concrete recurring/autonomous workflow exists.

### Knowledge base plan

- Drafted at `~/.config/ai/knowledge-base-plan.md`.
- Based on the user-pasted full text of Ben Holmes' **Build a Self-Updating LLM Knowledge Base** and Karpathy's `llm-wiki` gist.
- Knowledge base root is `~/.config/ai/knowledge-base/` by user preference; treat it as data with explicit privacy/git/sync handling.

### Skip or keep explicit-only

- David Ondrej tool-specific skills unless the backing tool is installed and used.
- DeepAPI/Pi/cmux/browser-harness workflows until the toolchain is intentionally adopted.
- Fable pricing/API-only claims until confirmed by official provider docs/account console.

## Remaining decisions

- Whether `rust-analyzer-lsp` should stay enabled in Claude/Codex.
- Whether OpenCode local `opencode-guided-review` should be re-enabled for specific review-heavy work.
- Whether Claude model override `claude-fable-5[1m]` is intentional and still available.
- Whether Claude notification hooks and `skipDangerousModePermissionPrompt` should remain true.
