---
name: grill-with-docs
description: Use when a complex plan or unfamiliar task needs docs/source-grounded pressure testing, domain-language clarification, material unknown discovery, or blindspot analysis before implementation.
---

# Grill with Docs and Unknowns

Inspect the real territory before interviewing the user. Resolve discoverable facts directly, surface hidden constraints, and ask only the material questions whose answers could change the implementation.

Stay in analysis or planning until material unknowns are resolved or accepted as labeled assumptions. Do not edit project files unless the user asks to implement or capture the resulting documentation.

## Workflow

1. **Restate the map.** Summarize the intended outcome, constraints, existing plan, and what currently appears known as provisional context. Do not wait for confirmation unless ambiguity blocks inspection. Done when the starting model and its uncertainties are explicit.
2. **Read the territory.** Inspect relevant docs, source, tests, schemas, config, history, prior attempts, and existing conventions. State unavailable evidence rather than guessing. Done when discoverable facts are separated from access gaps.
3. **Run a blindspot pass.** Look for constraints, failure modes, edge cases, and prior art that neither the plan nor user has raised. Rank only findings that could materially alter scope, UX, architecture, data, permissions, safety, cost, or rollout. Done when each material blindspot has evidence and a cheap resolution path.
4. **Classify the uncertainties.** Use facts, decisions, assumptions, and the four unknown types below when they improve the analysis; this is not a requirement to create a ledger file. Done when each material uncertainty has a resolution method or decision owner.
5. **Resolve by shape.** Investigate discoverable facts, default low-risk reversible choices, prototype tacit preferences, and ask the user only for material decisions. Done when the next unresolved item requires user judgment rather than more agent investigation.
6. **Grill one decision at a time.** Ask one grounded question, explain its impact, and recommend a default. Wait for the answer before moving to dependent decisions. Done when no unresolved user decision could materially change the plan.
7. **Sharpen domain language.** Test important nouns, verbs, lifecycle states, ownership boundaries, and invariants against docs and code. Done when overloaded terms have a canonical meaning, replacement, or explicit open question.
8. **Return an alignment packet.** Summarize verified facts, decisions, labeled assumptions, blockers, invariants, verification expectations, and conditions that require revisiting the plan. Ask for implementation confirmation when implementation was not already authorized. Done when another agent or future session could act without silently inventing product or architecture decisions.

## Unknowns classification

Use both classifications; they answer different questions.

- **Fact:** documented or observed in code, docs, tests, or config.
- **Decision:** a choice being made now.
- **Assumption:** an unverified default that remains visible and testable.

Then classify the knowledge gap:

- **Known known:** requirement or behavior already verified; restate with evidence.
- **Known unknown:** an explicit unresolved decision; investigate, default, or ask.
- **Unknown known:** tacit preference or knowledge the user can recognize but not yet verbalize; expose through contrasting references, examples, sketches, or a cheap throwaway prototype.
- **Unknown unknown:** an unanticipated constraint or possibility; expose through the blindspot pass, prior art, failure history, and domain expertise.

Do not force the taxonomy into every response. Present it explicitly only when ambiguity is large enough that the classification improves decisions.

## Resolution rules

- If code, docs, tests, config, or a focused tool call can answer the question, investigate instead of asking.
- If an uncertainty is low-risk, reversible, and local, recommend a conservative default and record it as an assumption.
- If the answer changes product behavior, architecture, permissions, data semantics, migration, cost, or acceptance criteria, ask the user.
- If the user will know the right result only when shown, compare meaningfully different references or propose the cheapest prototype that can expose the preference. Create the prototype only when authorized, then capture reactions as explicit criteria before real integration work.
- If several questions exist, keep a private queue and ask only the next material question whose dependencies are resolved.

Use this compact question shape:

```md
Question: <one material decision>
Why it matters: <what changes based on the answer>
Evidence: <relevant code/doc/test/reference>
Recommendation: <default and rationale>
```

## Domain awareness

During territory inspection, look for root or context-specific `CONTEXT.md`, a root `CONTEXT-MAP.md`, and `docs/adr/`. Use the map to identify bounded contexts and the relevant glossary or ADR scope.

Do not treat terminology as cosmetic. Fuzzy terms hide ownership, lifecycle, authorization, persistence, and release-boundary decisions.

- Compare user language with `CONTEXT.md`, code identifiers, product copy, and docs.
- Propose a precise canonical term for vague or overloaded language.
- If terms are claimed to be interchangeable, test lifecycle, ownership, permissions, persistence, and caller scenarios. A difference in any scenario means they are distinct concepts.
- Use concrete edge cases to test relationships and boundaries.
- Surface contradictions between the proposed model and actual code or docs.

## Capturing shared understanding

Report proposed documentation changes in the alignment packet by default. Write them only when the user asks for capture or has already authorized documentation edits.

When capture is authorized:

- Put crystallized domain terms in the relevant `CONTEXT.md` using [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).
- Keep `CONTEXT.md` glossary-only: no implementation plan, scratch notes, or architecture decisions.
- Put non-glossary decisions in the alignment packet unless they meet all ADR criteria below.

Offer an ADR using [ADR-FORMAT.md](./ADR-FORMAT.md) only when the decision is:

1. hard to reverse,
2. surprising without context, and
3. the result of a real trade-off.

If any criterion is missing, keep it as a session decision rather than creating an ADR.

## Alignment packet

Return only sections that carry useful information:

- **Verified facts:** evidence-backed current reality.
- **Decisions:** user-approved commitments and rationale.
- **Assumptions/defaults:** reversible choices plus how to verify them.
- **Remaining blockers:** unresolved decisions and their owner.
- **Domain language and invariants:** canonical terms and boundaries the implementation must preserve.
- **Verification expectations:** evidence needed to show the implementation works.
- **Stop/revisit conditions:** assumptions or discoveries that invalidate the plan.
- **Proposed documentation:** glossary or ADR changes to write only if capture is authorized.
