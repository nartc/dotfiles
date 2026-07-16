---
name: skill-authoring
description: Use when creating, editing, adapting, consolidating, validating, or reviewing agent skills, SKILL.md files, skill metadata, source attribution, or discovery behavior. Do not use for normal app documentation or project README work.
---

# Skill Authoring

Create skills that make agent behavior predictable: the same process every run, with clear triggers, lean context, tested pressure scenarios, and tracked sources.

## Workflow

1. **Check fit.** Create or edit a skill only when reusable agent behavior is needed. Prefer project instructions for project-only conventions and scripts for deterministic checks.
2. **Preserve provenance.** For external ideas, record source URL/repo, commit/version/date, license, copied vs adapted concepts, any copied wording, and local changes. Update `~/.config/ai/skills-sources.lock.json` for every adapted source.
3. **Run RED.** Before drafting, run a pressure scenario without the new/changed skill. Capture the behavior gap. If no gap exists, stop or narrow the skill. A minimal RED note names the prompt, the missing behavior, and the exact pressure that caused it.
4. **Choose invocation.** Use a model-invoked skill when agents must discover it autonomously. Use user-invoked only when the human will explicitly call it and context load should be zero.
5. **Write metadata first.** `name` must be lowercase letters/numbers/single hyphens. `description` starts with `Use when`, lists trigger conditions, avoids first/second person, and does not summarize the workflow.
6. **Validate metadata.** From the canonical skills root `~/.config/ai/skills`, run `python3 skill-creator/scripts/validate-metadata.py --name <name> --description "<description>"`.
7. **Shape the body.** Put must-follow steps in `SKILL.md`; move bulky reference/templates/scripts to one-level `references/`, `assets/`, or `scripts/` only when a clear context pointer tells agents when to read them.
8. **Sharpen completion criteria.** Every ordered step ends with a checkable done condition. Prefer “metadata validator exits 0” over “metadata looks good”.
9. **Steer positively.** State target behavior directly. Use prohibitions only for hard guardrails, paired with what to do instead.
10. **Prune.** Remove no-ops, duplicate meanings, stale sediment, and branches unrelated to the trigger. Keep one source of truth for each rule.
11. **Run GREEN.** Re-run the pressure scenario with the skill loaded or explicitly read. The agent must now hit attribution, metadata, testing, source tracking, and verification gates. A minimal GREEN note lists which gates passed and any remaining ambiguity.
12. **Verify deployment.** Confirm metadata parses, support paths exist, source tracking is updated, and the skill is discoverable after runtime reload. If the current runtime does not hot-load skills, state discovery remains unverified until restart; before restart, verify only content/path behavior by explicit file-read scenario.

## Skill design checks

| Check | Pass condition |
| --- | --- |
| Trigger | The description names when to use the skill, not what steps it performs. |
| Predictability | The same input should lead agents through the same process shape. |
| Information hierarchy | Immediate steps are inline; conditional reference is behind clear pointers. |
| Completion criteria | Each step has an observable done state. |
| Provenance | External sources are attributed and source-locked. |
| Testing | RED and GREEN pressure scenarios were run and summarized. |
| Context load | Model-invoked descriptions are worth their permanent token cost. |

## Source adaptation rules

- Do not blindly copy external skills. Adapt concepts, keep only local-useful behavior, and preserve attribution.
- If copying substantial wording, confirm license allows it and cite the exact source path/commit.
- In `skills-sources.lock.json`, add/update a `skills[]` entry with `local_skill`, `local_path`, `source_repo`, `source_commit` or version, `source_paths`, `adoption_mode`, `license`, and `last_checked`.
- If source terms are useful, use them consistently instead of re-explaining the same concept repeatedly.
- If upstream changes later, diff upstream against the local skill; never auto-overwrite local adaptations.

## Common mistakes

- **Workflow in description:** agents may follow the summary and skip the body. Keep description trigger-focused.
- **Untested skill:** a skill that was not pressure-tested is undocumented hope. Run RED/GREEN.
- **Too much inline reference:** long `SKILL.md` files create sprawl. Disclose heavy reference behind explicit pointers.
- **Negative steering:** “don’t be verbose” activates verbosity. Say “write the shortest complete answer”.
- **Missing source lock:** future updates become guesswork. Track sources when adapting.
