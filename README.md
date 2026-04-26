# personal-assistant-kit

A lightweight bootstrap for creating your own persistent personal AI assistant — powered by the LLM CLI you already use.

---

## What this is

A single shell script and one skill file. That's it.

You run `./pa-init.sh`, answer a few questions, and your chosen LLM CLI reads the `pa-creator` skill and builds your assistant for you — a self-contained directory with its own identity, memory, and skills. Once it's created, you can delete this repo. Your assistant keeps working without it.

The LLM is smart enough on day one. What makes session 50 dramatically better than session 1 is the accumulated context: preferences, people, project history, noise filters, carried-forward items. The assistant is the interface; the memory system is the product.

---

## How it works

```
1. Clone this repo
2. Run ./pa-init.sh
3. Choose your LLM CLI (Claude Code or Kiro)
4. The pa-creator skill loads into your CLI
5. Your LLM interviews you and generates your assistant
6. An alias is registered — type your assistant's name to start a session
7. Delete this repo if you want. Your assistant is self-contained.
```

---

## What gets created

```
~/assistant-name/
├── CLAUDE.md / AGENTS.md   ← identity, reasoning framework, and behavioral instructions
├── PERSONA.md              ← voice, tone, emotional register — evolves silently over time
├── PREFERENCES.md          ← what the user likes, dislikes, and noise filters
├── ACTIONS.md              ← single source of truth for open action items
├── HANDOFF.md              ← last session summary, picked up next time
├── accomplishments.md      ← notable deliverables, calibrated to your level
├── memory/
│   ├── memory.md           ← long-term memory, grows over sessions
│   └── people.md           ← key people and relationships
├── logs/
│   ├── daily/              ← one file per day with carried-forward tracking
│   └── weekly/             ← weekly reviews with pattern analysis
├── projects/               ← one file per project, created as you mention them
├── checklists/
│   └── morning-checklist.md
├── drafts/                 ← ephemeral content (messages, emails) — use and delete
├── docs/                   ← reference material
├── notes/                  ← ideas and scratch space
└── skills/                 ← custom skills you add over time
    ├── skill-creator/
    └── skill-reviewer/
```

---

## Requirements

- macOS, Linux, or Windows with WSL
- One of the supported LLM CLIs installed and authenticated:

| CLI | Provider | Install |
|---|---|---|
| [Claude Code](https://claude.ai/code) | Anthropic | `npm install -g @anthropic-ai/claude-code` |
| [Kiro](https://kiro.dev/docs/cli/installation/) | AWS | `curl -fsSL https://cli.kiro.dev/install \| bash` |

---

## Quickstart

```bash
git clone https://github.com/somsubhro/personal-assistant-kit
cd personal-assistant-kit
./pa-init.sh
```

That's it. Follow the prompts.

---

## What the assistant can do out of the box

**Thinks, not just records.** The assistant has a reasoning framework — it understands the ask, checks what it knows, thinks step by step, and is direct about uncertainty. It challenges you when it helps and synthesizes across sessions instead of just reading files back.

**Tracks your actions.** `ACTIONS.md` is the single source of truth for open items across all projects. The assistant adds items when commitments are made, tracks due dates with countdowns, and flags stale items. The morning briefing pulls directly from it.

**Remembers you.** Preferences, people, project history, and noise filters accumulate over time. The assistant learns what not to surface — meeting RSVPs, automated notifications, threads that aren't yours — and stops showing them without being told.

**Picks up where you left off.** Every session ends with a handoff and a daily log. The daily log includes a "Carried Forward" section with countdown timers so nothing slips through the cracks.

**Evolves its own persona.** `PERSONA.md` starts as a factory setting from your interview and evolves silently. When you say "too much detail" or respond better to a certain format, the assistant updates itself without announcing it.

**Runs weekly reviews.** At the start of each week, the assistant reviews daily logs, surfaces patterns, calls out what slipped, and proposes priorities. It interprets, not just lists.

**Tracks accomplishments.** Notable deliverables get logged automatically — shipped features, closed projects, resolved hard problems. Useful for performance reviews and self-awareness.

**Creates and uses skills.** Ask your assistant to create a skill for any repeated workflow. Skills are opinionated — they hardcode IDs, URLs, and defaults so you don't provide the same context every time.

**Works with MCPs (optional).** If you have MCP servers set up (calendar, email, Slack, task boards), the assistant discovers and incorporates them into its routine. No MCPs? Everything works with local files.

---

## Skills

Skills are plain markdown files (`SKILL.md`) that tell your assistant how to handle specific tasks. They live in `~/your-assistant/skills/`.

You don't write them manually. You ask your assistant:

```
"create a skill for summarizing my meeting notes"
"create a skill for reviewing my PRs"
```

Your assistant builds the skill, you validate it, and it's available from the next session onward.

---

## Why this approach

Most personal assistant frameworks require you to maintain a running service, manage a database, or keep a Python environment alive. This kit does none of that.

Your assistant is just a directory with markdown files. The LLM CLI you already use is the runtime. There are no moving parts to maintain.

---

## Roadmap

Support for additional LLM CLIs (Gemini CLI, Codex CLI) is planned. The `pa-creator` skill is model-agnostic — the same instructions work with any capable LLM. What changes per CLI is the context filename and the launch command.

---

## License

MIT
