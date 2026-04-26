---
name: skill-reviewer
description: Reviews an existing skill for quality — clarity, trigger accuracy, and generalizability. Use when the user asks to review, critique, improve, or debug a skill that isn't working as expected. Also use when a skill seems to trigger too often, not often enough, or produces inconsistent output.
---

## Reviewing a skill

Read the SKILL.md completely, then evaluate each layer:

### Trigger (description field)
- Is it specific enough that the assistant knows when to use this skill vs. others?
- Does it include both what the skill does AND when to activate?
- Is it slightly pushy? Skills undertrigger more often than they overtrigger.
- Would near-miss prompts incorrectly activate it? Think about adjacent domains.

### Instructions (body)
- Are they written in imperative form?
- Do they explain the *why* behind important steps, or just bark orders?
- Are there ALWAYS/NEVER rules that could be replaced with reasoning?
- Would the instructions generalize to prompts beyond the ones the author tested?
- Is the skill trying to do too much? Could it be split into focused pieces?
- Are there edge cases that aren't handled?

### Output
- Is the expected output format clear?
- Is there an example where the format is non-obvious?

### Structure
- Is it under 500 lines? If not, should it use reference files?
- Are any bundled resources (scripts, templates) actually used by the instructions?

## Giving feedback

Be direct. Structure your review as:

**What works well:** 1-2 things that are solid — anchor the user before the critique.

**What to improve:** Specific, actionable suggestions. Don't just say "the description is vague" — rewrite it.

**Suggested revision:** If changes are significant, offer the revised SKILL.md or the specific sections to change. Show, don't just tell.

## Testing after review

Suggest 2-3 realistic test prompts — including at least one near-miss that should NOT trigger the skill. Offer to run them so the user can see the skill in action before and after your suggested changes.