---
name: github-org-cleanup
description: GitHub org cleanup without gh CLI. Use when deleting Polygraph demo org repositories while keeping template repositories.
---

# GitHub Org Cleanup

Use the bundled script. It deletes every repository in the target org **except** the template repository keep list.

Script path:

```bash
~/.config/opencode/skills/github-org-cleanup/scripts/delete-non-template-repos.mjs
```

## Defaults

- Default org: `Polygraph-Demo-Test`
- Default `Polygraph-Demo-Test` template repos to keep:
  - `poly-frontend`
  - `poly-backend`
  - `poly-design`
- PAT env derived from org:
  - org name containing `test` → `Test`
  - otherwise → `Prod`
- 1Password item:
  - `op://Chau Personal/Polygraph Demo PAT/<Test|Prod>/read`
  - `op://Chau Personal/Polygraph Demo PAT/<Test|Prod>/write`
- Dry-run uses `read`.
- Delete mode uses `write`.

## Commands

Preview:

```bash
node ~/.config/opencode/skills/github-org-cleanup/scripts/delete-non-template-repos.mjs
```

Delete after reviewing preview:

```bash
node ~/.config/opencode/skills/github-org-cleanup/scripts/delete-non-template-repos.mjs \
  --delete \
  --yes
```

## Safety

- Refuses to run unless the org has a built-in template keep list or `--keep` is passed.
- Dry-run by default.
- Deletion requires `--delete --yes`.
- Delete mode refuses to continue if GitHub org cannot be mapped to `Test` or `Prod`.
- `GITHUB_TOKEN` overrides 1Password only when set explicitly.
