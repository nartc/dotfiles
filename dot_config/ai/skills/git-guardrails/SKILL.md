---
name: git-guardrails
description: Use when performing git cleanup, staging, committing, branch rewriting, cherry-picking, resetting, cleaning, pushing, force-pushing, or configuring safeguards for destructive git operations.
---

# Git Guardrails

Protect user work and shared history. Permission to “clean up” is not permission to destroy local changes, rewrite history, bypass hooks, or push.

## Before any git mutation

Run/read these first when inside a repo:

1. `git status --short --branch`
2. `git diff`
3. `git diff --staged`
4. `git log --oneline -10`

Stop if the worktree has unrelated user changes. Ask before touching them.

## Explicit approval required

Ask before:

- `git reset --hard`, `git reset --merge`, broad `git checkout .`, broad `git restore .`
- `git clean`, branch deletion, tag deletion
- rebases, squashes, amends, and any `git cherry-pick` before applying commits or mutating the worktree/history
- `git fetch` or other remote network operations unless directly requested for the current task
- commits, pushes, force pushes, PR creation, publishing, releases
- changing remotes or git config
- bypassing hooks or using `--no-verify`

For shared-history rewrites, require explicit user approval and prefer `--force-with-lease` over `--force`.

## Safe cleanup pattern

1. Inspect status/diff/staged/log.
2. State the intended operation, its reason, and its risk.
3. If destructive or history-rewriting, ask for explicit confirmation.
4. Preserve a recovery path when feasible: backup branch, stash name, patch file, or commit reference.
5. Stage only intended paths/hunks. Avoid `git add .` in dirty worktrees.
6. Inspect staged diff before commit.
7. Check diff for secrets, tokens, `.env`, credentials, generated auth files, private logs, and customer data.
8. Do not bypass failing hooks. Fix, report, or ask.
9. Report why each mutation was needed and what it accomplished, alongside final status, commit hashes, and commands run. Do not provide only a command or change inventory.

## Risk table

| Operation | Default stance |
| --- | --- |
| `status`, `diff`, `log`, `show` | Read-only, OK. |
| `add <specific paths>`, `restore --staged <paths>` | OK after confirming intent. |
| `commit` | Only when explicitly requested. |
| `fetch` | Explicit approval unless directly requested for the current task; remote access may use credentials. |
| `reset --hard`, `clean`, branch delete | Explicit approval and recovery path first. |
| `rebase`, `amend`, `cherry-pick` cleanup | Explicit approval before applying; preserve recovery path when feasible. |
| `push`, `force-push`, PR/release | Explicit approval every time. |

## Runtime-specific safeguards

- Keep behavioral guardrails in this skill and global instructions.
- Put command-blocking hooks/permission rules in runtime-specific config only.
- Do not copy Claude-specific hooks into OpenCode/Codex blindly.
- If adding hooks, document exact scope, blocked patterns, test command, and rollback path.

## Common mistakes

- Treating “whatever you need” as consent for destructive git.
- Acting after `status` only, without diff/staged/log.
- Using `git add .` and committing unrelated files.
- Force-pushing because history was rewritten locally.
- Bypassing hooks to “finish”.
- Reporting “clean” without showing final status and verification.
