---
name: tmux-handoff
description: Use when sending handoff context from one OpenCode TUI running in tmux to another OpenCode tmux pane, including cross-session context transfer.
---

# tmux-handoff

Use this skill to prepare and paste a compact handoff from the current opencode session into another opencode session running in a different tmux pane.

Default behavior: paste into the target pane for user review. Do **not** press Enter or auto-submit.

## Workflow

1. Build a concise handoff note using the portable `handoff` content format: objective, current state, decisions/constraints/invariants, files/sources, verification evidence, risks, acceptance criteria, suggested skills, and next prompt.
2. Discover candidate tmux panes.
3. Ask the user to choose a target pane unless they already provided a pane id like `%12` or a tmux target like `session:window.pane`.
4. Write the handoff note to a temp file.
5. Paste via a tmux buffer with bracketed paste enabled, not raw `send-keys`.
6. Clean up the temp file after paste.

## Handoff format

Use the portable `handoff` structure, then paste it via tmux. Minimum structure:

```markdown
# Handoff

## Objective

- ...

## Current state

- ...

## Decisions / constraints / invariants

- ...

## Files / locations / sources

- `path`: why it matters

## Verification evidence

- `command`: result summary
- Not run: checks intentionally not run and why

## Open questions / risks

- ...

## Acceptance criteria / done state

- ...

## Suggested skills / agents

- ...

## Next prompt

Continue from this handoff. First verify the referenced files/state, then proceed with: ...
```

Keep the note compact. Prefer durable facts over transcript dump. Include exact file paths, branch/repo/workdir if relevant, and anything the next session must not repeat.

## Discover panes

Run:

```bash
tmux list-panes -a -F '#{pane_id}\t#{session_name}:#{window_index}.#{pane_index}\t#{pane_current_command}\t#{pane_current_path}'
```

Prefer panes where `pane_current_command` looks like `opencode`, `node`, `bun`, or the user clearly identifies it. If unsure, ask.

## Paste safely

Use `paste-buffer -p` so tmux sends bracketed-paste markers.

```bash
tmpfile="$(mktemp -t opencode-handoff.XXXXXX.md)"
```

Then write the handoff note to `$tmpfile` using the file editing tool, not heredoc.

Then paste and clean up:

```bash
tmux load-buffer -b opencode-handoff "$tmpfile" && tmux paste-buffer -p -b opencode-handoff -t "$TARGET_PANE" && rm -f "$tmpfile"
```

After paste, ask whether to submit with Enter; only run `tmux send-keys Enter` after explicit user confirmation.

## User-facing summary after paste

Report:

- target pane
- any redactions/omissions
