# personal-assistant-kit

A lightweight bootstrap for creating your own persistent personal AI assistant — powered by the LLM CLI you already use.

---

## What this is

A single shell script and one skill file. That's it.

You run `./pa-init.sh`, answer a few questions, and your chosen LLM CLI reads the `pa-creator` skill and builds your assistant for you — a self-contained directory with its own identity, memory, and skills. Once it's created, you can delete this repo. Your assistant keeps working without it.

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

**Claude Code:**
```
~/jarvis/                 ← your assistant (name is yours to choose)
├── CLAUDE.md             ← your assistant's identity, persona, and instructions
├── memory/
│   ├── memory.md         ← long-term memory, grows over sessions
│   └── HANDOFF.md        ← last session summary, picked up next time
└── skills/               ← custom skills you add over time
```

**Kiro:**
```
~/jarvis/
├── AGENTS.md             ← your assistant's identity, persona, and instructions
├── .kiro/
│   └── steering/         ← memory and skill instructions loaded each session
├── memory/
│   ├── memory.md
│   └── HANDOFF.md
└── skills/
```

---

## Requirements

- macOS, Linux, or Windows with WSL
- One of the supported LLM CLIs installed and authenticated:

| CLI | Provider | Install |
|---|---|---|
| [Claude Code](https://claude.ai/code) | Anthropic | `npm install -g @anthropic-ai/claude-code` |
| [Kiro](https://kiro.dev/docs/cli/installation/) | AWS | `curl -fsSL https://cli.kiro.dev/install | bash` |

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

Once created, your assistant:

- **Remembers you** across sessions via `memory.md` — preferences, context, corrections accumulate over time
- **Picks up where you left off** via `HANDOFF.md` — each session ends with a summary, the next one starts from it
- **Creates new skills** — ask your assistant to create a skill for any repeated workflow; it writes the `SKILL.md` for you
- **Validates skills** — ask your assistant to review a skill before using it
- **Evolves its persona** — the more you use it, the more it reflects how you work

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