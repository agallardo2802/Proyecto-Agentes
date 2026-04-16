#!/bin/bash
set -e

echo "Installing GGS Agents..."

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux*)     OS="linux";;
  Darwin*)    OS="macos";;
  *)          echo "Unsupported OS: $OS"; exit 1;;
esac

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)     ARCH="amd64";;
  arm64)      ARCH="arm64";;
  aarch64)    ARCH="arm64";;
  *)          echo "Unsupported architecture: $ARCH"; exit 1;;
esac

echo "Detected: $OS-$ARCH"

# Determine config directory based on agent
AGENT="${1:-opencode}"  # Default to opencode, can be claude, cursor, etc.

case "$AGENT" in
  opencode)
    CONFIG_DIR="$HOME/.config/opencode/skills"
    ;;
  claude)
    CONFIG_DIR="$HOME/.claude/skills"
    ;;
  cursor)
    CONFIG_DIR="$HOME/.cursor/skills"
    ;;
  windsurf)
    CONFIG_DIR="$HOME/.windsurf/skills"
    ;;
  *)
    echo "Unknown agent: $AGENT"
    echo "Supported: opencode, claude, cursor, windsurf"
    exit 1
    ;;
esac

echo "Installing for: $AGENT"
echo "Config directory: $CONFIG_DIR"

# Create skills directory
mkdir -p "$CONFIG_DIR"

# Clone or update the repository
REPO_URL="${REPO_URL:-https://github.com/agallardo2802/Proyecto-Agentes.git}"
SKILLS_DIR="$CONFIG_DIR/ggs"

if [ -d "$SKILLS_DIR" ]; then
  echo "Updating existing installation..."
  cd "$SKILLS_DIR"
  git pull origin main
else
  echo "Cloning repository..."
  git clone "$REPO_URL" "$SKILLS_DIR"
fi

# Copiar skill SDD a la raíz de skills para que esté disponible en autocomplete
ROOT_SKILL_DIR="$CONFIG_DIR/Sdd-GGS"
mkdir -p "$ROOT_SKILL_DIR"
cp "$SKILLS_DIR/equipo/sdd-ggs/SKILL.md" "$ROOT_SKILL_DIR/SKILL.md"

echo ""
echo "✅ GGS Agents installed successfully!"
echo ""
echo "To use:"
echo "  1. Open $AGENT"
echo "  2. Type: sdd"
echo "  3. Or use: @equipo/desarrollo/dev"
echo ""
echo "For more info, see: $SKILLS_DIR/README.md"