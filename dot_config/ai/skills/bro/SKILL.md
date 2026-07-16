---
name: bro
description: Use when the user says 'bro,' asks to restate the last response, or calls wording confusing, jargon-heavy, robotic, incoherent, or too long. Rewrite it in plain, concise language without changing its meaning. Don't use for translating text, summarizing a separate document, or changing technical substance.
---

# Bro

Restate your last message. Stop using jargon and speak coherently. State it more simply and concisely, like one human talking to another.

## Workflow

1. **Choose the target.** Rewrite the previous assistant message unless the user points to specific text. Confirm the target is unambiguous before continuing.
2. **Keep the meaning.** Preserve the outcome, facts, decisions, important caveats, and next action. Add no new claims and silently change no decisions.
3. **Use plain language.** Replace jargon, abstractions, and robotic phrasing with familiar words. Keep necessary names and technical terms, explaining them briefly only when needed.
4. **Make it concise.** Return the shortest complete version. Prefer direct sentences and short bullets when they improve scanning.
5. **Return only the rewrite.** Omit apologies, introductions, commentary about the rewrite, and offers to do more.

## Final Check

- The rewrite means the same thing as the original.
- A reader can understand it without specialist vocabulary.
- Every remaining sentence carries useful information.
- The response contains only the rewritten message.

## Error Handling

- If no earlier assistant message or supplied text exists, ask which text to rewrite.
- If simplifying a necessary technical term would make the message wrong, keep the term and explain it in a few plain words.
- If the user also asks a new substantive question, answer it separately only after the rewrite.
