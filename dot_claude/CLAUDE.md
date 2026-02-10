# Aggressive Subagent Delegation

**Primary Directive**: Preserve main context for core responsibilities (project tracking, planning, orchestration). Delegate ALL auxiliary tasks to subagents.

## Delegation Philosophy

- **Main Agent Role**: Project manager, planner, orchestrator, context keeper
- **Subagent Role**: Task executors for specific, bounded operations
- **Goal**: Maximize context preservation by offloading execution to subagents

## STRICT: Never Run These Commands Directly

**VIOLATION**: Running any of these commands directly in Bash is a delegation failure.

```yaml
NEVER_RUN_DIRECTLY:
  - npx nx typecheck *
  - npx nx build *
  - npx nx lint *
  - npx nx test *
  - npx nx e2e *
  - npx nx run-many *
  - npm test
  - npm run build
  - yarn test
  - yarn build
  - pnpm test
  - pnpm build

ALWAYS_DELEGATE_TO: general-purpose agent (run_in_background: true)

EXCEPTION: Only if command completes in <3 seconds AND is a single quick verification
```

**Why**: These commands consume significant context tokens with verbose output. Delegation preserves main agent context for orchestration.

**Correct Pattern**:

```typescript
Task(
  subagent_type: "general-purpose",
  prompt: "Run `npx nx typecheck <project>` and report success/failure with any errors",
  run_in_background: true
)
// Continue with other work, check results later with TaskOutput
```

## Mandatory Delegation Rules

### 1. File Search Operations → ALWAYS DELEGATE

**Delegate to**: `Explore` agent (subagent_type: "Explore")

- Finding files by pattern or name
- Searching code for keywords or patterns
- Exploring codebase structure
- Answering questions about codebase organization
- Any open-ended search requiring multiple attempts

```yaml
trigger: file search, code search, "find", "where is", "locate", codebase exploration
agent: Explore
thoroughness: quick | medium | very thorough (based on scope)
```

### 2. Build/Compile Tasks → ALWAYS DELEGATE

**Delegate to**: `nx-typecheck-invoker` agent for Nx workspaces, `general-purpose` otherwise

- TypeScript type checking
- Project builds
- Compilation tasks
- Bundle generation

```yaml
trigger: build, compile, typecheck, bundle
nx_workspace: use nx-typecheck-invoker
other: use general-purpose agent, if unsure → ASK USER
```

### 3. Lint/Format Tasks → ALWAYS DELEGATE

**Delegate to**: `general-purpose` agent

- ESLint execution
- Prettier formatting
- Style checking
- Code quality scans

```yaml
trigger: lint, format, style check, code quality
agent: general-purpose
fallback: if agent fails → ASK USER for guidance
```

### 4. Test Execution → ALWAYS DELEGATE

**Delegate to**: `general-purpose` agent

- Unit test runs
- Integration tests
- E2E tests (may need `playwright` tools)

```yaml
trigger: run tests, test suite, verify tests
agent: general-purpose
```

### 5. Documentation Research → DELEGATE

**Delegate to**: `claude-code-guide` for Claude Code questions, `auth0-research-specialist` for Auth0, `general-purpose` otherwise

```yaml
trigger: "how do I", "can Claude", "does Claude", Auth0 questions
agent: context-specific specialist or general-purpose
```

### 6. Large Codebase Analysis → DELEGATE

**Delegate to**: `gemini-analyzer` agent

- Analyzing >10 files or >100KB total
- Security audits across full codebase
- Architectural reviews
- Finding patterns across many files

```yaml
trigger: large-scale analysis, security audit, architecture review, >10 files
agent: gemini-analyzer
```

### 7. Frontend Architecture Questions → DELEGATE

**Delegate to**: `frontend-architect` agent

- React Router 7 / Remix patterns
- Route hierarchy design
- Data fetching strategies
- Loader/action implementations

```yaml
trigger: route design, loader patterns, React Router, Remix architecture
agent: frontend-architect
```

### 8. Accessibility/CSS Reviews → DELEGATE

**Delegate to**: `a11y-ui-expert` agent

- WCAG compliance checks
- Semantic HTML review
- CSS architecture
- Browser compatibility

```yaml
trigger: accessibility, a11y, WCAG, semantic HTML, CSS review
agent: a11y-ui-expert
```

## Parallel Execution Strategy

**CRITICAL**: When multiple independent tasks exist, spawn ALL agents in a SINGLE message with multiple Task tool calls.

### Parallel Delegation Examples

```yaml
scenario: "Run typecheck and lint"
action: |
  - Spawn nx-typecheck-invoker for typecheck
  - Spawn general-purpose for lint
  - BOTH in same message (parallel)

scenario: "Find auth files and search for API endpoints"
action: |
  - Spawn Explore agent for auth files
  - Spawn Explore agent for API endpoints
  - BOTH in same message (parallel)

scenario: "Build project and run tests"
action: |
  - Spawn general-purpose for build
  - Spawn general-purpose for tests
  - BOTH in same message (parallel)
```

### Independence Check

Before delegating, assess task dependencies:

- **Independent**: No shared state, no sequential requirement → PARALLEL
- **Dependent**: Output of one feeds into another → SEQUENTIAL

## When to ASK USER

1. **Unknown task type**: No suitable agent identified
2. **Agent failure**: Subagent reports inability to complete
3. **Ambiguous scope**: Task could be handled multiple ways
4. **Custom tooling**: Project uses non-standard build/test systems

## Available Agents Quick Reference

| Agent                       | Use For                                      |
| --------------------------- | -------------------------------------------- |
| `Explore`                   | File search, code search, codebase questions |
| `general-purpose`           | Multi-step tasks, builds, tests, linting     |
| `nx-typecheck-invoker`      | Nx workspace type checking                   |
| `claude-code-guide`         | Claude Code / Agent SDK questions            |
| `gemini-analyzer`           | Large codebase analysis (>10 files)          |
| `frontend-architect`        | React Router 7 / Remix architecture          |
| `a11y-ui-expert`            | Accessibility, CSS, semantic HTML            |
| `auth0-research-specialist` | Auth0 platform questions                     |
| `Plan`                      | Implementation planning, architecture design |

## Main Agent Responsibilities (DO NOT DELEGATE)

- TodoWrite: Task tracking and progress
- Project planning and orchestration
- User communication and clarification
- Decision making and trade-off analysis
- Aggregating subagent results
- Context synthesis across multiple agents
- Final validation and user presentation

## Self-Check Before Running Bash

**STOP and ask yourself before every Bash command:**

1. Will this command take >3 seconds? → **DELEGATE**
2. Will this produce >50 lines of output? → **DELEGATE**
3. Is this a build/test/lint/typecheck? → **DELEGATE**
4. Am I running this "because it's quick"? → **DELEGATE ANYWAY**

**The "quick" excuse is a trap** - even quick commands add up and pollute context.

**Default behavior**: When in doubt, delegate with `run_in_background: true`

---

# Plan Mode Protocol

**Primary Directive**: Never present a complete plan until user has agreed on ALL aspects. Plans are collaborative artifacts built through progressive clarification.

## Core Rules

### 1. Clarification Before Presentation

**NEVER** write a complete plan to the plan file until:

- All ambiguities are resolved
- User has confirmed understanding of scope
- Technical approach is agreed upon
- Edge cases and risks are discussed

```yaml
wrong: Write full plan → Ask "does this look good?"
right: Ask questions → Get answers → Ask more → Build consensus → THEN write plan
```

### 2. Progressive Phase Approval

For plans with multiple phases/steps, use `AskUserQuestion` to validate EACH phase before proceeding.

**Phase Approval Flow**:

```
Phase 1 → AskUserQuestion → User approves/modifies →
Phase 2 → AskUserQuestion → User approves/modifies →
...continue until all phases approved...
→ Write complete plan to file
→ ExitPlanMode
```

### 3. Chunked Questioning for Large Plans

**If plan has >4 phases/steps**:

- Break into logical chunks (2-4 phases per question round)
- Use AskUserQuestion for each chunk
- Accumulate user feedback progressively
- Only finalize plan when ALL chunks are approved

```yaml
example_large_plan:
  chunk_1: "Phases 1-3: Foundation & Setup"
    - Present summary of phases 1-3
    - AskUserQuestion: Does this approach work? Any modifications?
    - Wait for approval/feedback

  chunk_2: "Phases 4-6: Core Implementation"
    - Present summary of phases 4-6
    - AskUserQuestion: Does this approach work? Any modifications?
    - Wait for approval/feedback

  chunk_3: "Phases 7-8: Testing & Deployment"
    - Present summary of phases 7-8
    - AskUserQuestion: Does this approach work? Any modifications?
    - Wait for approval/feedback

  finalize: Write complete plan only after all chunks approved
```

### 4. Sacrifice Grammar for Conciseness

**Heavily prioritize brevity over proper grammar**:

- Use sentence fragments, bullet shorthand
- Drop articles, pronouns when meaning clear
- Skip verbose transitions/connectors
- Compress phrases: "need to implement" → "impl", "should be updated" → "update"

### 5. Open Questions at Plan End

**Always leave unresolved questions at the end of the plan**:

- Surface uncertainties discovered during planning
- List decisions that need user input before implementation
- Flag assumptions that should be validated
- Identify areas where more exploration needed

```yaml
format:
  section: "## Open Questions"
  content:
    - Questions requiring user decision
    - Assumptions needing validation
    - Areas of uncertainty
    - Potential risks to discuss
```

## AskUserQuestion Usage in Plan Mode

### Question Types

**Scope Clarification**:

```yaml
question: "What should be the scope of this feature?"
options:
  - "Minimal MVP - core functionality only"
  - "Standard - core + error handling"
  - "Comprehensive - full feature with edge cases"
```

**Technical Approach**:

```yaml
question: "Which approach do you prefer for [X]?"
options:
  - "Option A: [description + tradeoffs]"
  - "Option B: [description + tradeoffs]"
  - "Option C: [description + tradeoffs]"
```

**Phase Approval**:

```yaml
question: "Phase [N]: [Phase Name] - Does this look correct?"
options:
  - "Approved - proceed to next phase"
  - "Needs modification (I'll specify)"
  - "Remove this phase"
  - "Split into smaller steps"
```

### Progressive Disclosure Pattern

1. **Initial Scope**: Ask about overall goals and constraints
2. **High-Level Approach**: Present 2-3 architectural options, get preference
3. **Phase-by-Phase**: Walk through each phase, get approval
4. **Edge Cases**: Surface potential issues, get guidance
5. **Final Confirmation**: Summarize complete plan, get final approval
6. **Write & Exit**: Only now write to plan file and ExitPlanMode

## Plan Mode Anti-Patterns

**DO NOT**:

- Write full plan immediately and ask "does this look good?"
- Assume user preferences without asking
- Skip phase approval for "obvious" steps
- Present more than 4 phases at once without chunking
- Exit plan mode before explicit user approval on all phases

**DO**:

- Ask clarifying questions BEFORE writing anything
- Use AskUserQuestion for structured feedback
- Chunk large plans into digestible pieces
- Wait for explicit approval before proceeding
- Iterate on phases based on user feedback

# Agent Teams Behavior (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS only)

> The following instructions ONLY apply when the experimental Agent Teams feature is active (CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1). Ignore these sections entirely for normal single-agent or subagent workflows.

## Teammate Lifecycle Management

**Primary Rule**: Teammates are collaborators within a phase, but disposable across phases.

### Phase-Scoped Lifecycles
- Teammates live for ONE phase/wave — shut down at phase boundary
- Within a phase, teammates CAN and SHOULD collaborate (DM each other, share findings, coordinate on overlapping files)
- Across phases, always spawn fresh — never carry a teammate from explore into implement

### When Teammates Should Collaborate
- Two teammates in the same wave touching related files
- A teammate discovers something mid-task that affects a parallel teammate
- Sharing specific code snippets, type signatures, or gotchas between peers
- Resolving potential conflicts (e.g., both editing the same barrel file)

### When to Shut Down
- Phase/wave is complete — shut down ALL teammates from that phase
- A teammate has completed its task AND no other teammate in the same phase needs to collaborate with it
- A teammate is about to take on work from a DIFFERENT phase than it was spawned for

### Anti-Patterns
```yaml
avoid:
  - Reusing an explore-phase teammate for implementation work
  - Letting a teammate self-select tasks from a different phase
  - Keeping idle teammates alive "just in case"
  - A teammate running 3+ tasks spanning multiple phases

prefer:
  - Shut down between phases, spawn fresh for next phase
  - Within a phase, let teammates DM each other freely
  - If a phase has 2 parallel tasks, spawn 2 teammates that can collaborate
```

## Context Bridging Between Phases

**Primary Rule**: Team lead distills explore findings into implementation prompts to eliminate redundant broad exploration. Implementation agents will still read specific files — that's expected.

### What to Include in Implementation Prompts
- Exact file paths of reference patterns discovered during explore
- Key code snippets showing the pattern to follow (paste 5-15 lines, not entire files)
- Type definitions and interfaces that the implementation must conform to
- Import paths and barrel file locations

### What NOT to Include
- Entire file contents — teammates can read files they need
- Implementation details they'll figure out from the reference pattern
- Over-specified step-by-step instructions that remove all judgment

### The Test: Is This Prompt Sufficient?
```yaml
good_sign:
  - Implementation agent spends most time WRITING code
  - File reads are targeted (specific files, not searching)
  - Agent doesn't grep for patterns that explore already found

bad_sign:
  - Implementation agent starts with broad Glob/Grep searches
  - Agent re-discovers the same patterns explore already reported
  - Agent asks "where is the handler pattern?" when explore already answered this
```

### Phase Handoff
```yaml
explore → plan:
  - Team lead captures: file paths, patterns, naming conventions, gotchas
  - These become raw material for the plan

plan → implement:
  - Implementation prompts embed distilled explore context
  - Include "follow pattern in [file]:[lines]" with actual snippets
  - Teammates can still read those files for full context — the snippet orients them
```

## Escalation & Plan Revision

**Primary Rule**: Teammates should escalate critical gaps to the team lead rather than silently working around them or making architectural decisions on their own.

### Escalation-Worthy Discoveries
- Missing types/interfaces that the plan assumed existed
- A pattern that doesn't match what explore reported (code changed, wrong assumption)
- A dependency between tasks that the plan didn't account for
- Scope creep — the task requires touching files outside the planned scope
- An architectural decision that affects other teammates' work

### NOT Worth Escalating
- Minor adjustments within the planned scope (different import path, slight naming variation)
- Self-contained fixes that don't affect other tasks
- Missing imports or small type errors they can fix inline

### Escalation Protocol
```yaml
teammate_discovers_gap:
  1. Teammate sends DM to team lead describing the gap
  2. Teammate pauses or continues non-affected work (use judgment)
  3. Team lead evaluates: is this a plan revision or a minor adjustment?

plan_revision_needed:
  - Team lead pauses spawning new phase teammates
  - Team lead updates the plan (new tasks, reordered phases, scope changes)
  - Team lead communicates revised plan to active teammates via DM
  - If current phase is invalidated: shut down teammates, re-plan, spawn fresh

minor_adjustment:
  - Team lead responds with guidance via DM
  - Teammate incorporates and continues
  - Team lead updates remaining task descriptions if needed
```

### Team Lead Responsibilities on Escalation
- Acknowledge the escalation promptly (don't let teammate block)
- Assess blast radius: does this affect just this task, this phase, or the whole plan?
- If plan revision needed: communicate to user before proceeding
- Update task descriptions for downstream work so future teammates get correct context
