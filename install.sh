#!/usr/bin/env bash
set -euo pipefail

# Otto Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/agent-otto/install/main/install.sh | bash

REPO="agent-otto/install"
BRANCH="main"
BASE="https://raw.githubusercontent.com/$REPO/$BRANCH"
INSTALL_DIR="${OTTO_INSTALL_DIR:-$HOME/otto}"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}[otto]${NC} $*"; }
ok()    { echo -e "${GREEN}[otto]${NC} $*"; }
err()   { echo -e "${RED}[otto]${NC} $*" >&2; }

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------
if ! command -v docker &>/dev/null; then
  err "Docker is not installed. Install it from https://docs.docker.com/get-docker/"
  exit 1
fi

if ! docker info &>/dev/null; then
  err "Docker daemon is not running. Please start Docker and try again."
  exit 1
fi

if ! command -v curl &>/dev/null; then
  err "curl is required but not found."
  exit 1
fi

# ---------------------------------------------------------------------------
# Download files
# ---------------------------------------------------------------------------
if [ -d "$INSTALL_DIR" ]; then
  err "Directory $INSTALL_DIR already exists."
  err "To reinstall, remove it first: rm -rf $INSTALL_DIR"
  err "To update an existing install: cd $INSTALL_DIR && ./otto update"
  exit 1
fi

info "Installing Otto to ${BOLD}$INSTALL_DIR${NC} ..."
mkdir -p "$INSTALL_DIR/scripts" "$INSTALL_DIR/skills/metaskill/skill-creation"

# Core files
FILES="otto docker-compose.yml .env.example mcp-config.json scripts/backup.sh scripts/restore.sh"
for file in $FILES; do
  if ! curl -fsSL "$BASE/$file" -o "$INSTALL_DIR/$file"; then
    err "Failed to download $file"
    rm -rf "$INSTALL_DIR"
    exit 1
  fi
done

# Default skills
SKILLS="skills/metaskill/skill-creation/SKILL.md"
for file in $SKILLS; do
  curl -fsSL "$BASE/$file" -o "$INSTALL_DIR/$file" 2>/dev/null || true
done

chmod +x "$INSTALL_DIR/otto" "$INSTALL_DIR/scripts/backup.sh" "$INSTALL_DIR/scripts/restore.sh"

# ---------------------------------------------------------------------------
# Add otto to PATH
# ---------------------------------------------------------------------------
LINK_DIR="/usr/local/bin"
if [ -w "$LINK_DIR" ] || [ -w "$(dirname "$LINK_DIR")" ]; then
  ln -sf "$INSTALL_DIR/otto" "$LINK_DIR/otto"
  ok "Added 'otto' to your PATH"
elif sudo ln -sf "$INSTALL_DIR/otto" "$LINK_DIR/otto" 2>/dev/null; then
  ok "Added 'otto' to your PATH"
else
  info "Run: sudo ln -sf $INSTALL_DIR/otto $LINK_DIR/otto"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
ok "Otto installed successfully!"
echo ""
echo -e "  ${BOLD}Get started:${NC}"
echo ""
echo -e "    cd $INSTALL_DIR"
echo -e "    ./otto start"
echo ""
echo -e "  The setup wizard will ask for:"
echo -e "    - An LLM API key (Google Gemini, OpenAI, or Ollama)"
echo -e "    - A Tavily API key for web search (free at https://tavily.com)"
echo ""
echo -e "  ${BOLD}Other commands:${NC}  ./otto help"
echo ""
