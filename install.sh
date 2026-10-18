#!/usr/bin/env bash
# ==============================================================================
# Claude Code PM Skill Installer
# Author: Shivp1413 (https://github.com/Shivp1413)
# Repository: https://github.com/Shivp1413/claude-code-pm-skill
# ==============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}"
echo "  ╔═══════════════════════════════════════════════════════════╗"
echo "  ║         Claude Code Project Manager (PM) Skill            ║"
echo "  ║               Orchestrator & Subagent Suite               ║"
echo "  ╚═══════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  echo -e "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -g, --global     Install globally to ~/.claude/ (available across all projects)"
  echo "  -l, --local      Install locally to ./.claude/ (current project only)"
  echo "  -u, --uninstall  Uninstall the PM skill and subagents"
  echo "  -h, --help       Show this help message"
  echo ""
}

TARGET_MODE=""
DO_UNINSTALL=false

for arg in "$@"; do
  case $arg in
    -g|--global) TARGET_MODE="global" ;;
    -l|--local) TARGET_MODE="local" ;;
    -u|--uninstall) DO_UNINSTALL=true ;;
    -h|--help) show_help; exit 0 ;;
    *) echo -e "${RED}Unknown option: $arg${RESET}"; show_help; exit 1 ;;
  esac
done

if [ -z "$TARGET_MODE" ]; then
  if [ -t 0 ]; then
    echo -e "${BOLD}Select scope:${RESET}"
    echo "  1) Global (~/.claude/) - Recommended for all sessions"
    echo "  2) Local (./.claude/)  - Current project only"
    read -rp "Enter choice [1/2] (default: 1): " choice
    case $choice in
      2) TARGET_MODE="local" ;;
      *) TARGET_MODE="global" ;;
    esac
  else
    TARGET_MODE="global"
  fi
fi

if [ "$TARGET_MODE" = "global" ]; then
  DEST_DIR="$HOME/.claude"
  SCOPE_LABEL="Global (~/.claude/)"
else
  DEST_DIR="$(pwd)/.claude"
  SCOPE_LABEL="Local Project (./.claude/)"
fi

if [ "$DO_UNINSTALL" = true ]; then
  if [ "$DEST_DIR" = "$SCRIPT_DIR/.claude" ]; then
    echo -e "\n${RED}✗ Cannot uninstall from the repository source folder itself.${RESET}\n"
    exit 1
  fi
  echo -e "\n${YELLOW}▶ Uninstalling PM Skill from: ${BOLD}${SCOPE_LABEL}${RESET}..."
  rm -rf "$DEST_DIR/skills/pm"
  for agent in analyst coder tester reviewer; do
    rm -f "$DEST_DIR/agents/$agent.md"
  done
  echo -e "${GREEN}✓ Uninstallation complete.${RESET}\n"
  exit 0
fi

echo -e "\n${BLUE}▶ Installing PM Skill to: ${BOLD}${SCOPE_LABEL}${RESET}...\n"

mkdir -p "$DEST_DIR/skills/pm"
mkdir -p "$DEST_DIR/agents"

# Locate source skill file (checks .claude/skills/pm or visible skills/pm)
SKILL_SRC=""
if [ -f "$SCRIPT_DIR/.claude/skills/pm/SKILL.md" ]; then
  SKILL_SRC="$SCRIPT_DIR/.claude/skills/pm/SKILL.md"
elif [ -f "$SCRIPT_DIR/skills/pm/SKILL.md" ]; then
  SKILL_SRC="$SCRIPT_DIR/skills/pm/SKILL.md"
fi

if [ -n "$SKILL_SRC" ]; then
  if [ "$SKILL_SRC" != "$DEST_DIR/skills/pm/SKILL.md" ]; then
    cp "$SKILL_SRC" "$DEST_DIR/skills/pm/SKILL.md"
  fi
  echo -e "  ${GREEN}✓${RESET} Installed PM skill -> $DEST_DIR/skills/pm/SKILL.md"
else
  echo -e "  ${RED}✗${RESET} Could not find SKILL.md in source directory."
  exit 1
fi

# Locate source agents folder (checks .claude/agents or visible agents/)
AGENTS_DIR=""
if [ -d "$SCRIPT_DIR/.claude/agents" ]; then
  AGENTS_DIR="$SCRIPT_DIR/.claude/agents"
elif [ -d "$SCRIPT_DIR/agents" ]; then
  AGENTS_DIR="$SCRIPT_DIR/agents"
fi

if [ -n "$AGENTS_DIR" ]; then
  for agent_file in "$AGENTS_DIR"/*.md; do
    [ -e "$agent_file" ] || continue
    base_name="$(basename "$agent_file")"
    dest_file="$DEST_DIR/agents/$base_name"
    if [ "$agent_file" != "$dest_file" ]; then
      cp "$agent_file" "$dest_file"
    fi
  done
  echo -e "  ${GREEN}✓${RESET} Installed subagents (analyst, coder, tester, reviewer) -> $DEST_DIR/agents/"
fi

echo -e "\n${GREEN}${BOLD}🎉 Installation Complete!${RESET}\n"
echo -e "${BOLD}How to use in Claude Code:${RESET}"
echo -e "  1. Start a session:       ${CYAN}claude${RESET}"
echo -e "  2. Call skill in chat:    ${CYAN}/pm${RESET}"
echo -e "  3. Or start with a task:  ${CYAN}/pm \"Build user authentication with JWT\"${RESET}"
echo ""
echo -e "Maintained by: ${BOLD}Shivp1413${RESET} (https://github.com/Shivp1413)"
