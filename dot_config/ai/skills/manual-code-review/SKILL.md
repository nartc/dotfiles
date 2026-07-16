---
name: manual-code-review
description: Use when reviewing a diff, branch, pull request, worktree, or code changes for spec compliance, standards, maintainability, regressions, or review findings without opening Plannotator.
---

# Manual Code Review

Review code on two separate axes so a clean implementation cannot hide missed requirements, and correct requirements cannot hide poor code.

## Review axes

- **Spec Review**: does the change implement the originating plan, issue, PRD, user request, or stated requirements?
- **Standards Review**: does the change meet repo conventions, maintainability, safety, testability, and baseline code-quality standards?

Keep the axes separate. Do not merge them into one approval signal.

## Workflow

1. **Pin scope.** Identify the diff or files under review: user-provided diff, PR URL, branch/fixed point, or current worktree. Done when the reviewed scope is explicit.
2. **Find spec source.** Locate the plan, issue, PRD, user request, or explicit requirements. If none exists, mark Spec Review as “no spec available” instead of implying compliance.
3. **Find standards sources.** Look for local standards: `AGENTS.md`, `CONTRIBUTING.md`, `CODING_STANDARDS.md`, existing nearby patterns, tests, or design docs. Done when standards are listed or marked absent.
4. **Run Spec Review.** Check missing/partial requirements, scope creep, and implementation that appears to satisfy wording but violates intent. Cite the spec/source for each finding.
5. **Run Standards Review.** Check correctness, regressions, safety, error handling, data flow, test coverage, maintainability, consistency, and the smell baseline below. Cite file/hunk evidence for each finding.
6. **Classify severity within each axis.** Use Critical, Important, Minor. Cosmetic preferences are Minor unless they hide correctness/maintenance risk.
7. **Report unverified scope.** Say what was not checked: tests not run, spec unavailable, runtime behavior not verified, or files outside scope.

## Smell baseline

Use these as judgment calls, not automatic violations. Repo standards override this baseline.

- Mysterious name: name does not reveal role.
- Duplicated code: same logic shape appears in multiple places.
- Feature envy: logic reaches into another module's data more than its own.
- Data clumps: fields or params repeatedly travel together.
- Primitive obsession: primitive/string stands in for a domain concept.
- Repeated switches: same branch cascade repeats across the change.
- Shotgun surgery: one logical change scatters edits across many files.
- Divergent change: one module changes for unrelated reasons.
- Speculative generality: abstraction or hooks added for unasked needs.
- Message chains: caller navigates too much object structure.
- Middle man: wrapper mostly delegates without adding leverage.
- Refused bequest: subtype/implementer ignores most inherited contract.

## Output shape

```markdown
## Spec Review

- Critical: ...
- Important: ...
- Minor: ...
- Not verified: ...

## Standards Review

- Critical: ...
- Important: ...
- Minor: ...
- Not verified: ...

Summary: <count/worst issue per axis; do not collapse into one pass/fail>
```

If doing only a quick pass, say so explicitly: “Quick Standards Review only; Spec Review not complete.”

## Common mistakes

- Saying “looks good” after only reading code quality, without checking requirements.
- Reporting style-only feedback while missing broken or missing behavior.
- Treating missing spec as spec pass.
- Letting one severe Standards issue mask a Spec pass, or one Spec miss mask useful Standards findings.
- Running Plannotator automatically. Use `plannotator-review` only when the user explicitly asks for browser-based Plannotator review.
