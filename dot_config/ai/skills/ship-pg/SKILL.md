---
name: ship-pg
description: Commit and ship a branch through Polygraph. Use when the user says "ship for poly", "ship for polygraph", or wants to commit, push branch with Polygraph, set git upstream, and create a PR for the Polygraph session.
---

# ship-pg

Use this skill to commit local changes, push with Polygraph, set git upstream, then create a PR with Polygraph.

## Flow

1. Commit local changes using the commit workflow below.
2. Push branch with Polygraph.
3. Set upstream with git.
4. Create PR with Polygraph for the Polygraph session.

Do not implement the Polygraph push/PR mechanics here; use the Polygraph workflow/tooling for those steps.

## Commit workflow

### Gather context

Run in parallel:

1. `git status` (never use `-uall`)
2. `git diff --staged` and `git diff`
3. `git log --oneline -30`

If scope/tag is not obvious from 30 commits, go further back with `git log --oneline -80` or inspect repo structure.

### Draft commit message

Tag/scope:

- Derive from repo conventions observed in git log.
- If user specified a tag/scope, use it exactly.
- Go back as far as needed in history to find the right scope.

Title:

- Concise, lowercase.
- Must fit as a GitHub PR title without truncation (~72 chars max total including tag).
- Format: `tag(scope): short description`.

Body:

- Bulleted list.
- Lowercase.
- First-person present tense verbs (`add`, `remove`, `update`, `fix`).
- Sacrifice grammar for conciseness.
- Test additions may be mentioned.
- No emojis.

### Stage and commit

- Stage only relevant files by name; never use `git add -A` or `git add .`.
- Never commit files that look like secrets (`.env`, credentials, tokens, keys).
- Use HEREDOC format:

```bash
git commit -m "$(cat <<'EOF'
tag(scope): short description

- bullet point 1
- bullet point 2
EOF
)"
```

- If a pre-commit hook fails: fix the issue, re-stage, create a new commit. Never amend unless the user explicitly asks.

## After commit

Continue with:

1. push branch with Polygraph
2. set upstream with git
3. create PR with Polygraph for the Polygraph session

Return the PR URL when done.
