---
name: codebase-design
description: Use when designing, reviewing, or refactoring code architecture, module interfaces, seams, adapters, dependency direction, testability, hidden coupling, or AI-navigable codebase structure.
---

# Codebase Design

Use this vocabulary to review or design modules with leverage: useful behaviour behind a small interface, placed at a clean seam, testable through that interface.

## Core vocabulary

- **Module**: anything with an interface and implementation: function, class, package, route, workflow, or subsystem.
- **Interface**: everything a caller must know: types, invariants, order constraints, error modes, config, performance, side effects.
- **Implementation**: what sits behind the interface.
- **Seam**: where behaviour can change without editing the caller. Use “seam” instead of overloaded “boundary”.
- **Adapter**: a concrete implementation plugged into a seam.
- **Depth**: leverage at the interface; lots of behaviour for little caller knowledge.
- **Locality**: change, bugs, and verification concentrate in one place.

## Review workflow

1. **Classify the module.** Name its interface, implementation, callers, dependencies, and intended responsibility. Done when each is explicit.
2. **Score depth.** Ask what callers must know versus what behaviour they get. Done when pass-through/shallow areas are named.
3. **Place seams.** Identify where behaviour genuinely varies. Done when each seam has a reason and expected adapters.
4. **Trace coupling.** Follow imports, shared DTOs, repo internals, enums, validation, serialization, transactions, retries, and release cadence. Done when hidden coupling risks are concrete.
5. **Check dependency direction.** Concrete adapters should live at composition/infrastructure edges; domain/application logic should depend on stable interfaces or public module APIs. Done when every suspect dependency is classified as acceptable, inverted, or moved to a seam.
6. **Check test surface.** Tests should cross the module interface and assert observable outcomes. Testing past the interface means the module shape is suspect. Done when the recommended test surface is named.
7. **Find the smallest high-leverage repair.** Prefer one local change that restores depth/locality over broad abstraction churn. Done when the first repair is smaller than a broad layering/refactor proposal.
8. **Report with vocabulary.** State the design issue, why it matters, the minimal repair, and what not to overbuild. Done when the report uses module/interface/seam/adapter/depth/locality where relevant.

## Design heuristics

- Deletion test: if deleting the module makes complexity vanish, it was pass-through; if complexity reappears across callers, it earned its keep.
- One adapter means a hypothetical seam. Two adapters usually make a real seam.
- Accept dependencies; do not create concrete external dependencies deep inside logic.
- Return results and observable outcomes; avoid hidden side effects where possible.
- Map UI, transport, and persistence DTOs at seams; do not let them become domain language by accident.
- Internal seams may exist for implementation/testing, but do not expose them through the external interface without caller value.

## Dependency categories

| Category | Design move |
| --- | --- |
| In-process | Merge/deepen and test through the new interface. |
| Local-substitutable | Use a local stand-in in tests; keep seam internal. |
| Remote but owned | Define a port at the seam; production adapter uses HTTP/gRPC/queue; tests use in-memory adapter. |
| True external | Inject a port and use a mock/fake adapter in tests. |

## Output shape

Use this concise structure:

```markdown
Design read:
- Module/interface:
- Depth/locality:
- Seam/adapters:
- Coupling risks:
- Test surface:
- Minimal repair:
- Avoid overbuilding:
```

## Common mistakes

- Calling every problem a “layer violation” without naming the module/interface/seam.
- Adding interfaces for one adapter.
- Moving logic around but leaving caller knowledge unchanged.
- Treating TypeScript `interface` as the whole interface.
- Sharing DTOs across UI/domain/persistence because it is convenient now.
- Recommending architecture purity instead of the smallest high-leverage repair.
