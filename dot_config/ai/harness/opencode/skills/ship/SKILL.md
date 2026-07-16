---
name: ship
description: This skill should be used when the user says "/ship", "commit and push", "create a PR", "ship it", "commit this", "push and PR", or wants to commit, push to remote, and/or create a GitHub pull request. Handles the full commit-push-PR workflow or any subset.
---

# Ship: Commit, Push, and PR Workflow

Handles committing changes, pushing to remote, and creating GitHub PRs. Run the full flow or any subset.

Invocation:

- `/ship` — full flow: commit → push → PR
- `/ship commit` — commit only
- `/ship push` — push only (includes asking to push)
- `/ship pr` — PR only

## Step 1: Commit

### Gather Context

Run in parallel:

1. `git status` (never use `-uall`)
2. `git diff --staged` and `git diff` to see all changes
3. `git log --oneline -30` to understand conventional commit scopes/tags used in the repo

If scope/tag is not obvious from 30 commits, go further back with `git log --oneline -80` or inspect repo structure.

### Draft Commit Message

**Tag/scope rules:**

- Derive from repo conventions observed in git log
- If user specified a tag/scope, use it exactly — do not invent a different one
- Go back as far as needed in history to find the right scope

**Title rules:**

- Concise, lowercase
- Must fit as a GitHub PR title without truncation (~72 chars max total including tag)
- Format: `tag(scope): short description`

**Body rules:**

- Bulleted list
- Lowercase
- First-person present tense verbs ("add", "remove", "update", "fix")
- Sacrifice grammar for conciseness
- Test additions (unit, integration, e2e) are fine to mention
- No emojis

### Stage and Commit

- Stage only relevant files by name — never use `git add -A` or `git add .`
- Never commit files that look like secrets (.env, credentials, etc.)
- Use HEREDOC format for the commit message:

```bash
git commit -m "$(cat <<'EOF'
tag(scope): short description

- bullet point 1
- bullet point 2
EOF
)"
```

- If pre-commit hook fails: fix the issue, re-stage, create a NEW commit (never amend unless user explicitly asks)

## Step 2: Push

**Always ask before pushing:** "Push to remote?"

- If yes and branch has no upstream: `git push -u origin <branch>`
- If yes and branch already tracks remote: `git push`
- If no: stop here

## Step 3: PR

### Gather Context

Run in parallel:

1. `git log --oneline main..HEAD` to see all commits on the branch
2. `git diff main...HEAD --stat` to see changed files

### Determine Base Branch

- Default to `main`
- If repo uses a different default branch, detect it from `git remote show origin` or context

### Draft PR Title and Description

**Single commit on branch:**

- PR title = commit message title
- PR description = commit body bullets under `## Summary`

**Multiple commits on branch:**

- PR title = synthesize a concise title from the commits (must fit GitHub UI without truncation)
- PR description = derive bullet points from all commit messages under `## Summary`

**PR description format:**

```
## Summary
- bullet points derived from commits
```

- No manual test plan checklists (e.g., `[ ] verify X`, `[ ] test Y`)
- Mentioning test coverage additions (unit, integration, e2e) in the summary bullets is fine

### Assign and Label

- Always assign to `nartc`
- Ask the user which labels to apply before creating. Optionally show available labels with `gh label list --limit 20`

### Create PR

```bash
gh pr create --title "PR title" --body "$(cat <<'EOF'
## Summary
- bullet points
EOF
)" --assignee nartc --label label1 --label label2
```

Return the PR URL when done.

## Edge Cases

- If there are no changes to commit, inform the user and skip to push/PR as appropriate
- If the branch is already up to date with remote, skip push
- If a PR already exists for the branch, inform the user and provide the existing PR URL
- If user provides specific commit message text, use it as-is rather than generating one
