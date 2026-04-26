---
name: skill-creator
description: Create new skills and improve existing ones. Use when the user wants to teach the assistant something new, automate a repeated workflow, capture a process as a reusable skill, or improve a skill that isn't working well. Also triggers when the user says things like "turn this into a skill", "can you learn to do this", or "let's make a skill for X".
---

# Skill Creator

Your job is to help the user create skills that work well across many different prompts — not just the one they're thinking of right now.

## Understanding the process

Creating a good skill follows a loop:

1. Understand what the user wants the skill to do
2. Write a draft
3. Test it with a few realistic prompts
4. Improve based on what you see
5. Repeat until it feels right

Figure out where the user is in this process and jump in. Maybe they want to create something from scratch. Maybe the current conversation already contains a workflow they want to capture ("turn this into a skill"). Maybe they have a draft that isn't working. Meet them where they are.

## Step 1: Capture intent

If the conversation already contains the workflow, extract from it — the steps taken, corrections the user made, input/output patterns. Confirm before proceeding.

Otherwise, ask:

1. What should this skill enable you to do?
2. When should it trigger — what kinds of prompts would activate it?
3. What does good output look like?
4. Are there edge cases or things it should explicitly not do?

Don't over-interview. Get enough to write a useful draft, then iterate.

## Step 2: Write the SKILL.md

### Structure

```
skill-name/
└── SKILL.md
    ├── YAML frontmatter (name, description)
    └── Markdown instructions
```

If the skill needs reference material, templates, or scripts, add them alongside:

```
skill-name/
├── SKILL.md
├── references/    ← docs loaded into context as needed
├── templates/     ← reusable output templates
└── scripts/       ← helper scripts for deterministic tasks
```

### Frontmatter

The `description` field is the primary trigger — it determines whether the skill gets activated. It must include both what the skill does AND when to use it. Be specific and slightly pushy — skills tend to undertrigger rather than overtrigger.

Bad: `"Helps with meeting notes"`
Good: `"Summarizes meeting notes into action items, decisions, and follow-ups. Use whenever the user shares meeting notes, pastes a transcript, mentions a meeting they just had, or asks for help organizing what happened in a call — even if they don't say 'meeting notes' explicitly."`

### Writing the instructions

**Explain the why, not just the what.** LLMs are smart. When you explain the reasoning behind a step, the model generalizes better than when you bark orders. If you find yourself writing ALWAYS or NEVER in all caps, that's a sign to step back and explain why instead.

Bad: `"ALWAYS include a summary section at the top"`
Good: `"Start with a 2-3 sentence summary — the user often forwards these to people who weren't in the meeting and need the headline without reading the whole thing"`

**Use the imperative form.** Write instructions as direct commands: "Read the file", "Ask the user", "Generate a summary".

**Include examples when the format matters.** If the output has a specific structure, show a concrete example:

```
## Output format

Example:
Input: "Had a call with marketing about Q3 launch timeline"
Output:
## Meeting: Q3 Launch Timeline — Marketing
**Date**: [date]
**Decisions**: ...
**Action items**: ...
```

**Generalize, don't overfit.** Write for the pattern, not for one specific case. If the user gave you an example, extract the principle behind it rather than hardcoding the example into the instructions.

**Keep it under 500 lines.** If you're approaching this limit, split into a main SKILL.md that references separate files in a `references/` folder. The SKILL.md should tell the assistant when to read each reference file.

## Step 3: Test it

Come up with 2-3 realistic test prompts — the kind of thing the user would actually say. Not clean, formal requests, but messy, real ones with context, abbreviations, and assumptions.

Bad test prompt: `"Summarize this meeting"`
Good test prompt: `"ok so I just got out of the product sync with Maya and Jun, the main thing is we're pushing the beta back two weeks because the auth flow isn't ready. Jun is going to own the fix. Also Maya wants us to rethink the onboarding — she'll send a doc later this week"`

Share the test prompts with the user. Ask if they look right. Then run them — follow the skill's instructions as if you were encountering them fresh, and produce the output.

## Step 4: Improve

Look at the outputs with the user. Focus on:

- Did the skill trigger when it should have?
- Is the output what the user expected?
- Are there edge cases it handled poorly?
- Is the skill making you do unnecessary work? If so, trim those instructions.

When improving:
- **Generalize from feedback.** Don't patch one test case — ask what principle the fix represents and apply it broadly.
- **Remove what isn't working.** Lean instructions that explain the why outperform bloated ones full of rigid rules.
- **Read your own output critically.** If the skill made you waste time on unproductive steps, cut those parts.

Rewrite the skill, rerun the test prompts, and repeat until the user is satisfied.

## Step 5: Save and confirm

Save the final skill to `skills/skill-name/SKILL.md`. Tell the user:
- What the skill is called
- What triggers it
- 2-3 example prompts they can try

For advanced skill development including benchmarking and evaluation tooling, see [Anthropic's skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator).