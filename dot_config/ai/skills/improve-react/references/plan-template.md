# React Improvement Plan Template

Use this structure for every `improve-react` plan. Assume the executor has no conversation context; include exact code, target behavior, and repository evidence.

```markdown
# NNN — <Short imperative title>

- **Status**: TODO
- **Commit**: <output of `git rev-parse --short HEAD` when written>
- **Severity**: HIGH | MEDIUM | LOW
- **Category**: Bugs and correctness | Performance | Accessibility | Security | Maintainability and architecture
- **Rule**: <plugin>/<rule-id> | Beyond the scan
- **Source recipe**: <verified canonical rule prompt URL | Not applicable>
- **Estimated scope**: <file count and rough size>

## Problem

Cite every location as `path/to/file.tsx:123`. Include the relevant current code and explain the user impact, execution frequency, and why this work is worth doing now.

    // src/features/search/SearchBox.tsx:18 — current
    useEffect(() => {
      setResults(filter(items, query));
    }, [items]);

## Evidence and confidence

- Scanner evidence: <diagnostic id and version | unavailable>
- Manual evidence: <call path, reproduction, or architectural trace>
- Confidence: HIGH | MEDIUM | LOW
- Runtime evidence still needed: <none | exact profiling/reproduction step>

## Target

Show the exact target state. For a rule-backed finding, adapt the verified canonical rule recipe to this code and cite the source prompt. Keep repository conventions and public behavior explicit.

    // target
    useEffect(() => {
      setResults(filter(items, query));
    }, [items, query]);

## Repository conventions to follow

- Imitate one concrete exemplar: `path/to/exemplar.tsx:42`.
- Preserve local naming, import placement, state ownership, and test style.
- Preserve public APIs, analytics hooks, accessibility semantics, and route behavior unless the target explicitly changes them.

## Steps

1. At `path/to/file.tsx:123`, make one concrete edit and preserve named surrounding behavior.
2. Add or update the focused test at `path/to/file.test.tsx:45` when repository conventions cover this behavior.
3. Run the named focused checks and inspect the resulting diff for unrelated churn.

## Boundaries

- Keep the change within the listed files and symbols.
- Add no dependency unless the plan explicitly requires and justifies it.
- Keep the change behavior-preserving unless the target names an intentional behavior change.
- Stop and report drift when the current code no longer matches the commit stamp or quoted excerpt.

## Dependencies and ordering

- Depends on: <plan ids or none>
- Blocks: <plan ids or none>
- Recommended order rationale: <one sentence>

## Verification

- **Mechanical**:
  - Run the repository's focused lint and tests: `<exact commands>`.
  - Run typecheck only when explicitly requested or before push, ship, or pull request: `<exact command if applicable>`.
  - When React Doctor is safely available, run its changed-scope check and confirm the targeted diagnostic clears without a score regression.
- **Behavioral**: Interact with `<specific route or control>` and confirm `<observable behavior>`.
- **Performance, when applicable**: Record before and after in React DevTools Profiler and use Highlight Updates to verify the affected subtree no longer re-renders unnecessarily.
- **Done when**: <diagnostic/evidence target>, required checks pass, and the named behavioral observation matches the target.

## Risks and rollback

- Risk: <specific regression surface>
- Rollback: <smallest safe revert or feature fallback>
```

## Author Checks

- Keep one finding per plan unless multiple findings share every affected file and fix pattern.
- Quote only enough current code to remove executor ambiguity.
- Record unresolved product decisions as blockers rather than silently choosing behavior.
- Update the plan-directory README with status, recommended execution order, and dependencies.
