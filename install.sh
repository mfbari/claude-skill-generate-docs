#!/bin/bash
# install.sh — Install generate-docs into your project or globally
#
# Usage:
#   ./install.sh              # Install to current project (.claude/ in pwd)
#   ./install.sh --global     # Install to ~/.claude/ (available everywhere)
#   ./install.sh --help       # Show this help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

show_help() {
    echo "generate-docs installer"
    echo ""
    echo "Usage:"
    echo "  ./install.sh              Install to current project (.claude/ in pwd)"
    echo "  ./install.sh --global     Install to ~/.claude/ (available everywhere)"
    echo "  ./install.sh --help       Show this help"
    echo ""
    echo "After installing, run in Claude Code:"
    echo "  /generate-docs            Default: 3 max retries"
    echo "  /generate-docs 5          Custom: 5 max retries"
}

if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    show_help
    exit 0
fi

if [[ "${1:-}" == "--global" ]]; then
    TARGET="$HOME/.claude"
    SCOPE="globally"
else
    TARGET="$(pwd)/.claude"
    SCOPE="to project"
fi

echo -e "${CYAN}Installing generate-docs ${SCOPE}: ${TARGET}${NC}"
echo ""

mkdir -p "$TARGET/commands" "$TARGET/agents"

# Copy command
cp "$SCRIPT_DIR/.claude/commands/generate-docs.md" "$TARGET/commands/generate-docs.md"
echo -e "  ${GREEN}✓${NC} Command   ${DIM}$TARGET/commands/generate-docs.md${NC}"

# Copy agents
for agent in doc-explorer doc-generator doc-verifier; do
    cp "$SCRIPT_DIR/.claude/agents/${agent}.md" "$TARGET/agents/${agent}.md"
    echo -e "  ${GREEN}✓${NC} Agent     ${DIM}$TARGET/agents/${agent}.md${NC}"
done

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  📚 generate-docs installed successfully${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Usage in Claude Code:"
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
