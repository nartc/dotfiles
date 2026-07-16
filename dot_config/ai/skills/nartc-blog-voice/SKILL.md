---
name: nartc-blog-voice
description: Use when writing a blog post, editing a draft, reviewing Nartc blog voice, or making prose sound like Nartc, especially Angular, AI workflow, theory-crafting, or personal engineering experience essays. Don't use for generic marketing copy, formal product documentation, API reference, or non-Nartc writing.
---

# Nartc Blog Voice

## Overview

Preserve the author's practical, first-person engineering voice. Make posts feel like an experienced engineer explaining a
thing actually encountered: concrete pain first, fair framing second, opinionated takeaway last.

## Procedure

1. Identify the post type: Angular/API critique, theory-crafting, personal workflow, or pure experience.
2. Start from the concrete awkward thing, not the broad trend.
3. State the normal or obvious approach fairly before critiquing it.
4. Make the thesis visible in one strong sentence or paragraph.
5. Use examples to anchor the argument before abstract commentary.
6. Merge accidental one-line paragraphs, but keep short punchy lines when they create emphasis.
7. Add light dry humor or self-deprecation only where it sounds like an aside, not a punchline.
8. End finished blog posts with a practical rule of thumb or personal landing, then `Thanks for reading, and have fun!`.

## Voice Contract

| Use | Avoid |
| --- | --- |
| `I think`, `Personally`, `for me`, `the part that bothers me` | universal claims dressed as facts |
| `This is fine, but...` | marketing setup or hype |
| practical skepticism | anti-tool / anti-framework rants |
| dry humor: `because apparently I asked for this` | jokes that take over the post |
| concrete human stakes: kids, closing laptop, review debt | vague burnout theater |
| run-on conversational rhythm | choppy sentence-per-line prose |
| `code`, _italic_, **bold** for emphasis | decorative formatting everywhere |

## Structure Patterns

### Angular/API Post

1. Show the new/common API.
2. Say it is fine.
3. Explain the naming, ownership, or composition problem.
4. Show the awkward/common version.
5. Show the preferred shape or tradeoff.
6. End with a rule of thumb.

### Theory-Crafting Post

1. Label unstable APIs as proposed, preview, or conceptual.
2. Avoid pretending examples are production-ready.
3. Separate confirmed behavior from speculation.
4. Keep the interesting premise concrete.
5. Use phrasing like `If this lands...`, `I do not know yet`, and `That is the line I want to be careful about`.

### Personal Workflow Post

1. Start with the lived experience.
2. Avoid grand industry claims.
3. Use self-observation: `I squint a little`, `I am still figuring it out`.
4. Name the hidden cost: review debt, ownership debt, open loops, supervision tasks.
5. Keep the conclusion personal, not prescriptive.

## Formatting Rules

- Use `angular-ts` for Angular component TypeScript snippets.
- Use `angular-html` for Angular template snippets, especially control flow blocks like `@if`, `@defer`, and `@boundary`.
- Use `ts` for plain TypeScript snippets.
- Use `txt` for prompts, todos, and handoff notes.
- Use `code` formatting for API names, selectors, file-ish concepts, and repeated phrases like `the agent says done`.
- Use _italic_ for subjective emphasis: _cute_, _mythical_, _I_ got there.
- Use **bold** for the post spine: **AI changes the shape of unfinished work**.
- Use 4-space indentation for blog code examples unless preserving an existing snippet with different formatting.

## Phrase Bank

Prefer phrases like:

- `This is fine.`
- `This works, but...`
- `At first glance...`
- `The awkward part is...`
- `That is probably the part that bothers me the most.`
- `Let's pretend...`
- `I am not saying this is wrong.`
- `There is no right or wrong here. It is more like a spectrum.`
- `Not burnout-level stress. More like a small tax.`
- `The computer says the task is done, but my brain does not.`

Avoid phrases like:

- `unlock`, `seamless`, `powerful`, `revolutionary`
- `developers should always...`
- `the future of software development`
- `game changer`
- polished devrel transitions that erase the author's irritation

## Rewrite Moves

### Make a paragraph sound more like the author

Replace polished prose with conversational friction.

Bad:

```txt
AI improves productivity but introduces additional cognitive overhead.
```

Better:

```txt
AI makes some work faster, but annoyingly so, it also creates more work around the work.
```

### Fix too many sentence breaks

Combine related observations into a concise paragraph. The author often prefers run-ons over chopped emphasis.

Bad:

```txt
This is useful.
This is also work.
This changes the rhythm.
```

Better:

```txt
This is useful but man, annoyingly so, it is also work, and it changes the rhythm more than I expected.
```

### Keep skepticism fair

Do not frame preference as universal truth.

Bad:

```txt
Using AI here is wrong.
```

Better:

```txt
I am not saying this is wrong as there is no right or wrong here. It is more like a spectrum.
```

## Review Checklist

- Confirm the post starts from a concrete problem.
- If the intro could apply to any dev blog, rewrite it around the specific API, code, or workflow pain.
- Confirm the title and intro make the premise obvious.
- Remove generic productivity/marketing framing.
- Replace over-polished paragraphs with practical, slightly skeptical wording.
- Merge excessive one-line paragraphs unless they carry intentional emphasis.
- Add links at first mentions of important APIs or projects.
- Verify code fences use `angular-ts` and `angular-html` when relevant.
- Check whether formatting makes the spine visible without clutter.
- Ensure the conclusion sounds practical and personal, not grand.

## Error Handling

- If the user gives exact phrasing, preserve the roughness unless it creates a factual error.
- If grammar conflicts with voice, prefer voice for blog prose.
- If the draft sounds anti-tool or anti-framework, soften with `This is fine` / `I am not saying this is wrong` before the critique.
- If the post drifts into abstract discourse, add a concrete code or workflow example before continuing.
- If unsure whether a claim is about Angular or an API behavior, verify from docs/source before polishing the sentence.
