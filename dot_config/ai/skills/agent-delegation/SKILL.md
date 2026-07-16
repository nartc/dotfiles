---
name: agent-delegation
description: Use only when the main agent has completed discovery and a task has genuinely concurrent validation or isolated implementation work that benefits from subagents. Do not use for exploration, research, planning, or review.
---

# Agent Delegation

Subagents are an exception. Keep discovery, decisions, synthesis, and review in the primary session.

## Delegation gate

Delegate only when **every** condition holds:

1. Work items are truly independent and gain wall-clock time by running at once.
2. The main agent has already explored the relevant code and made the needed design decisions.
3. Each worker has a bounded, inspectable contract with no shared-file or ordering conflict.
4. The work is either independent verification or isolated implementation.

Use direct tools instead for searching, reading, docs lookup, research, brainstorming, planning, audits, review, and codebase understanding. A large context or long task alone is not a delegation reason.

## Allowed cases

- Run independent lint, focused test, build, or explicitly requested typecheck commands concurrently.
- Implement separate modules or files after the main agent has defined the interface, paths, constraints, and acceptance checks.
- Execute an independent, bounded implementation or validation task in a separate repository after the main agent has established the cross-repo contract.

Keep tiny edits and a single validation command direct. Never send two agents to edit the same file or tightly coupled files. Always inspect the resulting diff or command output before reporting completion.

## Workflow

1. **Explore directly.** Establish the relevant paths, conventions, interfaces, and task dependencies in the primary session.
2. **Classify execution.** Mark work direct, sequential, or genuinely parallel. Do not create agents for a read-only or reasoning step.
3. **Slice contracts.** For each allowed worker, provide exact scope, constraints, relevant paths, expected output, and validation. Done when the agent can work without deciding design.
4. **Dispatch only independent execution.** Launch the permitted implementation or verification workers together. Do not start dependent work early.
5. **Inspect results.** Read summaries, inspect meaningful diffs or command output, and resolve conflicts or uncertainty manually.
6. **Synthesize.** Report changes, verification evidence, and remaining risks; agent output is not proof of correctness.

## Do not delegate

- Searching for files, call sites, patterns, or documentation.
- Library research, codebase learning, audits, reviews, brainstorming, or architecture/product decisions.
- A single command or any work the main agent can complete directly without blocking other execution.
- Concurrent edits to the same file or tightly coupled code.
- Tasks that need secrets or credentialed data not approved for that task.
- Work whose diff or output cannot be inspected before use.

## Prompt template

```markdown
Task: <one-sentence outcome>

Scope:
- Paths/repos:
- Allowed actions: edit allowed | validation only
- Do not touch:

Context:
- User goal:
- Relevant decisions:
- Upstream findings:

Expected output:
- Findings/changes:
- Verification performed:
- Risks/unknowns:
```

## Common mistakes

- Treating subagent completion as proof of correctness.
- Hiding important decisions inside a subagent prompt.
- Dispatching dependent tasks at the same time.
- Asking multiple agents to mutate the same surface.
- Reporting raw agent output instead of synthesizing it.
