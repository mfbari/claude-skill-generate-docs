#!/bin/bash
# install.sh — Install the generate-docs skill into a skills directory.
#
# generate-docs is a portable Agent Skill: the self-contained `generate-docs/` folder
# (SKILL.md + references/ + assets/ + examples/) can be dropped into any agentic harness's
# skills directory. This script copies it into a Claude Code skills directory for you.
#
# Usage:
#   ./install.sh              # Install to current project  (.claude/skills/ in pwd)
#   ./install.sh --global     # Install for all projects    (~/.claude/skills/)
#   ./install.sh --help       # Show this help
#
# For other harnesses, just copy the `generate-docs/` folder into that tool's skills directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/generate-docs"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

show_help() {
    echo "generate-docs skill installer"
    echo ""
    echo "Usage:"
    echo "  ./install.sh              Install to current project (.claude/skills/ in pwd)"
    echo "  ./install.sh --global     Install for all projects   (~/.claude/skills/)"
    echo "  ./install.sh --help       Show this help"
    echo ""
    echo "For other harnesses, copy the generate-docs/ folder into that tool's skills directory."
    echo ""
    echo "After installing, in your agent:"
    echo "  /generate-docs            Default: 3 max retries"
    echo "  /generate-docs 5          Custom: 5 max retries"
}

if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    show_help
    exit 0
fi

if [[ "${1:-}" == "--global" ]]; then
    TARGET="$HOME/.claude/skills"
    SCOPE="globally"
else
    TARGET="$(pwd)/.claude/skills"
    SCOPE="to project"
fi

DEST="$TARGET/generate-docs"

echo -e "${CYAN}Installing the generate-docs skill ${SCOPE}: ${DEST}${NC}"
echo ""

mkdir -p "$TARGET"
rm -rf "$DEST"
cp -R "$SKILL_SRC" "$DEST"

echo -e "  ${GREEN}✓${NC} Skill     ${DIM}$DEST/SKILL.md${NC}"
echo -e "  ${GREEN}✓${NC} References ${DIM}$DEST/references/ (5 files)${NC}"
echo -e "  ${GREEN}✓${NC} Assets    ${DIM}$DEST/assets/ (2 templates)${NC}"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  📚 generate-docs skill installed successfully${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Usage in your agent:"
echo ""
echo -e "    ${YELLOW}/generate-docs${NC}        Generate docs (3 retries)"
echo -e "    ${YELLOW}/generate-docs 5${NC}      Generate docs (5 retries)"
echo ""
echo -e "  What it generates:"
echo ""
echo -e "    ${CYAN}docs/${NC}                 15 documentation files with Mermaid diagrams"
echo -e "    ${CYAN}CLAUDE.md${NC}             Updated with progressive disclosure references"
echo -e "    ${CYAN}AGENTS.md${NC}             Cross-tool context (Cursor, Copilot, etc.)"
echo ""
echo -e "  Suggested .gitignore addition:"
echo -e "    ${DIM}docs/_*.md${NC}"
echo ""
