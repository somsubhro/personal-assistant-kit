#!/bin/bash

set -e

# ─────────────────────────────────────────────────────────────
# pa-init.sh — bootstrap a personal AI assistant
# ─────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$SCRIPT_DIR/skills/pa-creator"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${BOLD}personal-assistant-kit${RESET}"
echo -e "${DIM}Create your own personal AI assistant${RESET}"
echo ""

# ─────────────────────────────────────────────────────────────
# Step 1: Choose CLI
# ─────────────────────────────────────────────────────────────

echo -e "Which LLM CLI do you use?"
echo ""
echo "  1) Claude Code"
echo "  2) Kiro CLI"
echo ""
read -p "Choose (1 or 2): " cli_choice

case "$cli_choice" in
    1)
        CLI_CMD="claude"
        CLI_LABEL="Claude Code"
        ;;
    2)
        CLI_CMD="kiro-cli"
        CLI_LABEL="Kiro CLI"
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${RESET}"
        exit 1
        ;;
esac

# Check if the CLI is installed
if ! command -v "$CLI_CMD" &> /dev/null; then
    echo ""
    echo -e "${RED}$CLI_LABEL is not installed.${RESET}"
    case "$CLI_CMD" in
        claude)
            echo -e "Install it with: ${CYAN}curl -fsSL https://claude.ai/install.sh | bash${RESET}"
            ;;
        kiro-cli)
            echo -e "Install it with: ${CYAN}curl -fsSL https://cli.kiro.dev/install | bash${RESET}"
            ;;
    esac
    exit 1
fi

echo ""
echo -e "${GREEN}✓${RESET} $CLI_LABEL found"

# ─────────────────────────────────────────────────────────────
# Step 2: Choose assistant name
# ─────────────────────────────────────────────────────────────

echo ""
read -p "What do you want to name your assistant? " assistant_name

# Normalize: lowercase, replace spaces with hyphens
assistant_name=$(echo "$assistant_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

ASSISTANT_DIR="$HOME/$assistant_name"

if [ -d "$ASSISTANT_DIR" ]; then
    echo ""
    echo -e "${RED}Directory $ASSISTANT_DIR already exists.${RESET}"
    read -p "Continue anyway? (y/n): " overwrite
    if [ "$overwrite" != "y" ]; then
        echo "Aborted."
        exit 0
    fi
fi

# ─────────────────────────────────────────────────────────────
# Step 3: Create assistant directory and seed context
# ─────────────────────────────────────────────────────────────

mkdir -p "$ASSISTANT_DIR"

# Copy references so the skill can access its templates during setup
cp -r "$SKILL_DIR/references" "$ASSISTANT_DIR/.pa-creator-references"

if [ "$CLI_CMD" = "claude" ]; then
    # ── Claude Code ──────────────────────────────────────────
    # Claude Code reads CLAUDE.md automatically from the working directory.
    # We copy the pa-creator skill as CLAUDE.md so it runs on first launch.

    cp "$SKILL_DIR/SKILL.md" "$ASSISTANT_DIR/CLAUDE.md"

    # Append reference paths and cleanup instructions
    cat >> "$ASSISTANT_DIR/CLAUDE.md" << 'EOF'

---

## Reference file locations

The reference templates for skill-creator and skill-reviewer are at:
- `.pa-creator-references/skill-creator-template.md`
- `.pa-creator-references/skill-reviewer-template.md`

Read from these paths when generating the user's skills.

After setup is complete and the assistant directory is fully scaffolded, delete the `.pa-creator-references/` directory and remove this section from this file. Replace the entire contents of this file with the generated assistant context.
EOF

    # The alias launches Claude Code in the assistant directory
    ALIAS_CMD="alias $assistant_name=\"cd $ASSISTANT_DIR && claude\""

elif [ "$CLI_CMD" = "kiro-cli" ]; then
    # ── Kiro CLI ─────────────────────────────────────────────
    # Kiro CLI doesn't auto-load AGENTS.md from arbitrary directories.
    # Instead, we create a custom agent that loads the pa-creator skill
    # via the prompt field (file:// URI) and reference templates as resources.
    # We launch it with: kiro-cli chat --agent pa-creator

    mkdir -p "$ASSISTANT_DIR/.kiro/steering"
    mkdir -p "$ASSISTANT_DIR/.kiro/agents"

    # Copy the pa-creator skill as a prompt file the agent will load
    cp "$SKILL_DIR/SKILL.md" "$ASSISTANT_DIR/.pa-creator-prompt.md"

    # Append reference paths and Kiro-specific instructions
    cat >> "$ASSISTANT_DIR/.pa-creator-prompt.md" << 'EOF'

---

## Reference file locations

The reference templates for skill-creator and skill-reviewer are at:
- `.pa-creator-references/skill-creator-template.md`
- `.pa-creator-references/skill-reviewer-template.md`

Read from these paths when generating the user's skills.

## Kiro-specific setup notes

You are running inside Kiro CLI. When generating the assistant:
- Use `AGENTS.md` as the main identity file (always loaded automatically by Kiro from the workspace root)
- Place memory management, routines, and evolution instructions in `.kiro/steering/` as separate focused files
- Skills go in `.kiro/skills/` with the standard `SKILL.md` format — Kiro supports `skill://` resource loading
- After setup is complete, delete `.pa-creator-references/`, `.pa-creator-prompt.md`, and `.kiro/agents/pa-creator.json` — they are bootstrap artifacts
- The final assistant should work with the Kiro default agent loading `AGENTS.md` and `.kiro/steering/` automatically
EOF

    # Create the custom agent JSON for the bootstrap
    cat > "$ASSISTANT_DIR/.kiro/agents/pa-creator.json" << 'AGENT'
{
  "name": "pa-creator",
  "description": "Bootstrap agent that creates a personal assistant. Used once during setup, then deleted.",
  "prompt": "file://../../.pa-creator-prompt.md",
  "tools": ["read", "write", "shell"],
  "allowedTools": ["read", "write"],
  "resources": [
    "file://.pa-creator-references/skill-creator-template.md",
    "file://.pa-creator-references/skill-reviewer-template.md"
  ]
}
AGENT

    # The alias launches kiro-cli in the assistant directory (using default agent, not pa-creator)
    ALIAS_CMD="alias $assistant_name=\"cd $ASSISTANT_DIR && kiro-cli\""
fi

echo ""
echo -e "${GREEN}✓${RESET} Assistant directory created at ${CYAN}$ASSISTANT_DIR${RESET}"

# ─────────────────────────────────────────────────────────────
# Step 4: Register shell alias
# ─────────────────────────────────────────────────────────────

# Determine shell config file
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

if [ -n "$SHELL_CONFIG" ]; then
    # Check if alias already exists
    if grep -q "alias $assistant_name=" "$SHELL_CONFIG" 2>/dev/null; then
        echo -e "${DIM}Alias '$assistant_name' already exists in $SHELL_CONFIG${RESET}"
    else
        echo "" >> "$SHELL_CONFIG"
        echo "# personal-assistant-kit: $assistant_name" >> "$SHELL_CONFIG"
        echo "$ALIAS_CMD" >> "$SHELL_CONFIG"
        echo -e "${GREEN}✓${RESET} Alias registered in ${CYAN}$SHELL_CONFIG${RESET}"
    fi
else
    echo ""
    echo -e "${RED}Could not detect shell config file.${RESET}"
    echo -e "Add this to your shell config manually:"
    echo ""
    echo -e "  ${CYAN}$ALIAS_CMD${RESET}"
fi

# ─────────────────────────────────────────────────────────────
# Step 5: Launch the CLI for first-time setup
# ─────────────────────────────────────────────────────────────

INIT_PROMPT="Read your context file and follow the pa-creator instructions. You are setting up a new personal assistant for the first time. Start the interview now."

echo ""
echo -e "${BOLD}Launching $CLI_LABEL to set up your assistant...${RESET}"
echo -e "${DIM}The pa-creator skill will interview you and build everything.${RESET}"
echo -e "${DIM}When it's done, you can delete this repo.${RESET}"
echo ""
echo -e "${DIM}─────────────────────────────────────────────────${RESET}"
echo ""

cd "$ASSISTANT_DIR"

if [ "$CLI_CMD" = "claude" ]; then
    claude "$INIT_PROMPT"
elif [ "$CLI_CMD" = "kiro-cli" ]; then
    kiro-cli chat --agent pa-creator "$INIT_PROMPT"
fi