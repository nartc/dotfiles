---
description: Explain that guided-review is disabled globally and point to Plannotator review
---

The local guided-review plugin is disabled globally because it executes local TypeScript at OpenCode startup.

Use `/plannotator-review` for the default review flow, or re-enable `/Users/nartc/code/github/nartc/agents/packages/opencode-guided-review/src/index.ts` in `~/.config/opencode/opencode.json` for a task that specifically needs Flue-guided annotations.
