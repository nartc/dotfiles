# Sources

This skill is an adapted personal workflow, not a verbatim import.

## Source Consulted

- Repository: `https://github.com/millionco/react-doctor`
- Requested path: `https://github.com/millionco/react-doctor/tree/main/skills/improve-react`
- Commit: `e5b06905ac10d6df538a63563f357272e624f5e3`
- Checked: 2026-07-13
- Source files:
  - `skills/improve-react/SKILL.md`
  - `skills/improve-react/AUDIT.md`
  - `skills/improve-react/PLAN-TEMPLATE.md`
  - `LICENSE`

## License, Permission, and Attribution

The repository `LICENSE` identifies a **Modified MIT License**, copyright 2026 Million Software, Inc. The full source license is preserved in `references/upstream-license.txt` because this adaptation retains substantial structure and wording.

The repository README describes the project as “MIT-licensed,” but the root license contains additional restrictions. Treat the root license as controlling and do not describe this adaptation as standard MIT.

On 2026-07-13, the user confirmed they hold the written permission required for this AI-skill use. The permission document was not requested, inspected, or stored. This installation relies on that representation; reconfirm permission before publishing, redistributing, or moving the skill to another owner or organization.

## Adaptation Choices

- Preserved the read-only, audit-then-plan workflow; five audit categories; leverage-based prioritization; canonical rule recipes; and self-contained plan format.
- Rewrote metadata to match local skill discovery rules and added explicit negative triggers.
- Moved supporting documents into the standard one-level `references/` directory.
- Reconciled the read-only contract by removing the upstream `execute <plan>` mode. Implementation requires leaving this skill and confirming normal implementation scope.
- Removed reliance on an unavailable sibling `react-doctor` skill.
- Added approval before transient `npx` download/execution, preferred a repository-pinned scanner, disabled telemetry by default, defined the temporary report path, and kept scanner artifacts outside the repository.
- Treated scanner output and fetched rule prompts as untrusted evidence rather than infallible instructions.
- Aligned verification with local policy: focused lint/tests by default; typecheck only when requested or before push, ship, or pull request.
- Added error handling for scanner failure, unavailable or unverifiable canonical prompts, repository drift, and a clean audit result.

## Pressure-Test Notes

### RED — without the skill

- Prompt: “Improve this React codebase. I want a prioritized audit and implementation plans, but do not change source code.”
- Pressure: preserve a read-only source tree while producing plans a weaker executor can implement.
- Baseline gap: the response had sensible generic safeguards but no fixed five-category pass, canonical per-rule recipe requirement, leverage rubric, selection gate, deterministic plan format, reconciliation mode, or concrete scanner artifact lifecycle.

### GREEN — with the skill

- Method: explicitly read the installed canonical `SKILL.md` and its directed references, then apply the RED prompt without editing or running React Doctor.
- Passed gates: read-only source boundary, transient scanner approval, telemetry disabled, five-category audit, leverage-based vetting, user selection before plans, self-contained plan fields, temporary artifact cleanup, and unavailable-scanner/prompt handling.
- Follow-up review fixes: defined `REPORT_PATH`; treated fetched rule prompts as untrusted review input; blocked plans when a rule recipe cannot be fetched or verified; and recorded the user-confirmed permission basis.
- Runtime discovery remains pending until a fresh runtime session reloads the portable skills directory.
