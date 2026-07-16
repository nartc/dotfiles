---
name: ai-config
description: Use when a task mentions ~/.config/ai, global or personal AI configuration, shared agent instructions, portable skills, harness-specific skills, or AI setup shared across OpenCode, Claude, and Codex. Don't use for normal application code or project-only AI configuration.
---

# AI Config

Treat `~/.config/ai` as the canonical source for the machine's shared AI setup. Read it before explaining or changing that setup instead of relying on memory or runtime copies.

## Workflow

1. **Open the source of truth.** Use an explicitly supplied root when present; otherwise use `~/.config/ai`. List the root, then read `agents.md` and `tooling-inventory.md`. Finish with the current policies and ownership boundaries understood.
2. **Classify the task.** Read only the relevant canonical area:
   - Shared behavior: `agents.md`
   - Portable skills: `skills/<name>/SKILL.md`
   - Runtime-only behavior: `harness/<runtime>/`
   - Knowledge-base work: `knowledge-base/` and the matching KB skill
   - Adapted skill provenance: `skills-sources.lock.json` and the skill's `references/sources.md`
3. **Consult the right skill guides.** For creating, editing, adapting, or reviewing a skill, load both `skill-authoring` and `skill-creator` before drafting. When a change is runtime-specific, load an available runtime customization skill—for OpenCode, use `customize-opencode`—or inspect that runtime's canonical harness files when no such skill exists. Finish with the required metadata, provenance, and validation rules identified.
4. **Trace deployment.** Inspect current symlinks or runtime configuration before assuming where canonical files appear. Prefer `~/.config/ai/skills` for portable skills and `harness/<runtime>/skills` for runtime-specific skills. Avoid editing generated, vendor-managed, or compatibility copies when a canonical source exists.
5. **Protect existing work.** Read each target before editing. Check repository status when the source root is version-controlled. Keep changes narrow and preserve unrelated content.
6. **Edit the canonical file.** Make the requested change in `~/.config/ai`, then update `tooling-inventory.md` only when ownership, topology, or documented inventory changes. Update `skills-sources.lock.json` and source notes only when external material is adapted.
7. **Validate the result.** Run the smallest relevant checks. For skills, validate metadata from `~/.config/ai/skills`, inspect the final `SKILL.md`, and confirm runtime visibility through the expected symlink or configured path. Finish only when each check passes or its limitation is reported.
8. **Report clearly.** Name the canonical files changed, runtime visibility, checks run, unresolved risks, and whether a runtime restart is needed.

## Error Handling

- If `~/.config/ai` is missing or unreadable, stop and report that the source of truth could not be loaded.
- If canonical documents conflict, show the conflict and ask only when it materially changes the safe edit.
- If an expected runtime symlink is missing, report it rather than silently creating a new deployment scheme outside the requested scope.
- If files contain credentials or private data, avoid exposing them and inspect only what the task requires.
