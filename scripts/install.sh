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
AGENT="${1:-opencode}"

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
ROOT_SKILL_DIR="$CONFIG_DIR/sdd-ggs"
mkdir -p "$ROOT_SKILL_DIR"
cp "$SKILLS_DIR/equipo/sdd-ggs/SKILL.md" "$ROOT_SKILL_DIR/SKILL.md"

# ============================================
# REGISTRAR AGENTES EN OPENCODE SELECTOR
# ============================================
if [ "$AGENT" = "opencode" ]; then
  echo ""
  echo "Registering GGS agents in OpenCode selector..."

  OPENCODE_CONFIG="$HOME/.config/opencode"
  OPENCODE_JSON="$OPENCODE_CONFIG/opencode.json"
  CUSTOM_AGENTS_DIR="$OPENCODE_CONFIG/agents/custom"

  # -------------------------------------------------------
  # LIMPIEZA: Borrar carpetas antiguas de agents/custom/
  # para evitar duplicados con prefijo "Custom/" en el dropdown
  # -------------------------------------------------------
  for agent_folder in "sdd-ggs" "Sdd-Ggs-Orchestrator" "Sdd-GGS-Orchestrator" "Sdd-GGS-Skills"; do
    if [ -d "$CUSTOM_AGENTS_DIR/$agent_folder" ]; then
      rm -rf "$CUSTOM_AGENTS_DIR/$agent_folder"
      echo "  - Removed old agents/custom/$agent_folder"
    fi
  done

  echo "  - Agent files live in skills/ggs/agents/ (no Custom/ duplicates)"
fi

echo ""
echo "GGS Agents installed successfully!"
echo ""
echo "To use:"
echo "  1. Open $AGENT (restart if already open)"
echo "  2. Select 'Sdd-GGS-Orchestrator' or 'Sdd-GGS-Skills' from the selector"
echo "  3. Or type: sdd"
echo ""
echo "For more info, see: $SKILLS_DIR/README.md"
