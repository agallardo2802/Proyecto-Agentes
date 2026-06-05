#!/bin/bash
set -e

# Directorio donde vive este script (para resolver assets como el logo TUI).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

RED='\033[31m'
NC='\033[0m'
printf "${RED}Installing GGS Agents...${NC}\n"

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux*)     OS="linux";;
  Darwin*)    OS="macos";;
  MINGW*|MSYS*|CYGWIN*) OS="windows";;
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

DRY_RUN="${DRY_RUN:-0}"
SKIP_PREREQUISITES="${SKIP_PREREQUISITES:-0}"
AGENT="opencode"
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n)
      DRY_RUN="1"
      ;;
    --skip-prerequisites)
      SKIP_PREREQUISITES="1"
      ;;
    opencode|claude|codex|antigravity|cursor|windsurf)
      AGENT="$arg"
      ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: scripts/install.sh [--dry-run] [--skip-prerequisites] [opencode|claude|codex|antigravity|cursor|windsurf]"
      exit 1
      ;;
  esac
done
if [ -n "${GGS_OPENCODE_DEFAULT_MODEL:-}" ]; then
  DEFAULT_OPENCODE_MODEL="$GGS_OPENCODE_DEFAULT_MODEL"
  SDD_PROFILE_MODEL="$GGS_OPENCODE_DEFAULT_MODEL"
elif command -v codex >/dev/null 2>&1; then
  DEFAULT_OPENCODE_MODEL="openai/gpt-5.5"
  SDD_PROFILE_MODEL="openai/gpt-5.5"
else
  DEFAULT_OPENCODE_MODEL=""
  SDD_PROFILE_MODEL="openai/gpt-5.5"
fi

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

run_or_print() {
  if [ "$DRY_RUN" = "1" ]; then
    echo "DryRun: $*"
  else
    "$@"
  fi
}

install_package() {
  local name="$1"
  local apt_pkg="$2"
  local brew_pkg="$3"

  if [ "$OS" = "macos" ] && command_exists brew; then
    echo "Installing $name with Homebrew..."
    run_or_print brew install "$brew_pkg" || true
    return
  fi

  if [ "$OS" = "linux" ] && command_exists apt-get; then
    echo "Installing $name with apt..."
    run_or_print sudo apt-get update || true
    run_or_print sudo apt-get install -y "$apt_pkg" || true
    return
  fi

  echo "Package manager not available for $name. Install manually."
}

install_cask_or_snap() {
  local name="$1"
  local command_name="$2"
  local brew_cask="$3"
  local snap_pkg="$4"

  if command_exists "$command_name"; then
    echo "$name already installed"
    return
  fi

  if [ "$OS" = "macos" ] && command_exists brew; then
    echo "Installing $name with Homebrew cask..."
    run_or_print brew install --cask "$brew_cask" || true
    return
  fi

  if [ "$OS" = "linux" ] && command_exists snap; then
    echo "Installing $name with snap..."
    run_or_print sudo snap install "$snap_pkg" --classic || true
    return
  fi

  echo "$name not installed automatically. Install manually."
}

install_engram() {
  if command_exists engram; then
    echo "Engram already installed: $(engram version 2>/dev/null || engram --version 2>/dev/null || echo installed)"
    return
  fi

  echo "Engram not found. Installing/verifying Engram is required for GGS memory flow..."
  if [ "$DRY_RUN" = "1" ]; then
    echo "DryRun: would install Engram using official installer script"
    return
  fi

  if ! command_exists curl; then
    echo "curl is required to install Engram. Install curl and rerun."
    exit 1
  fi

  curl -fsSL https://raw.githubusercontent.com/Gentleman-Programming/engram/main/scripts/install.sh | sh
}

install_uv() {
  # uv/uvx is required by markitdown-mcp (document/image -> markdown to save tokens).
  if command_exists uvx || command_exists uv; then
    echo "uv already installed: $(uv --version 2>/dev/null || echo installed)"
    return
  fi

  echo "uv not found. Installing (required for markitdown-mcp)..."
  if [ "$DRY_RUN" = "1" ]; then
    echo "DryRun: curl -LsSf https://astral.sh/uv/install.sh | sh"
    return
  fi

  if [ "$OS" = "macos" ] && command_exists brew; then
    brew install uv || true
    return
  fi

  if command_exists curl; then
    curl -LsSf https://astral.sh/uv/install.sh | sh || echo "Could not install uv. See https://docs.astral.sh/uv/"
  else
    echo "curl not available. Install uv manually: https://docs.astral.sh/uv/"
  fi
}

install_prerequisites() {
  if [ "$SKIP_PREREQUISITES" = "1" ]; then
    echo "Skipping prerequisites because SKIP_PREREQUISITES=1"
    return
  fi

  echo "Installing/verifying base tools..."

  command_exists git || install_package "Git" "git" "git"
  command_exists curl || install_package "curl" "curl" "curl"
  command_exists python3 || install_package "Python 3" "python3" "python"
  command_exists node || install_package "Node.js" "nodejs" "node"
  command_exists npm || install_package "npm" "npm" "node"
  command_exists go || install_package "Go" "golang-go" "go"
  command_exists dotnet || install_package ".NET SDK 8" "dotnet-sdk-8.0" "dotnet-sdk"
  command_exists docker || install_package "Docker" "docker.io" "docker"

  # React work is covered by Node.js/npm. React itself should not be installed globally.
  install_cask_or_snap "Visual Studio Code" "code" "visual-studio-code" "code"
  install_cask_or_snap "Slack" "slack" "slack" "slack"
  install_cask_or_snap "Ghostty" "ghostty" "ghostty" "ghostty"

  install_engram

  if ! command_exists opencode; then
    echo "OpenCode not found. Installing..."
    if [ "$DRY_RUN" = "1" ]; then
      echo "DryRun: npm install -g opencode-ai"
    else
      npm install -g opencode-ai || echo "Could not install OpenCode. Run: npm install -g opencode-ai"
    fi
  else
    echo "OpenCode already installed: $(opencode --version 2>/dev/null || echo ok)"
  fi

  install_uv
}

install_prerequisites

# Determine config directory based on agent

case "$AGENT" in
  opencode)
    CONFIG_DIR="$HOME/.config/opencode/skills"
    ;;
  claude)
    CONFIG_DIR="$HOME/.claude/skills/ggs"
    ;;
  codex)
    CONFIG_DIR="$HOME/.codex/skills/ggs"
    ;;
  antigravity)
    CONFIG_DIR="$HOME/.antigravity/skills/ggs"
    ;;
  cursor)
    CONFIG_DIR="$HOME/.cursor/skills/ggs"
    ;;
  windsurf)
    CONFIG_DIR="$HOME/.windsurf/skills/ggs"
    ;;
  *)
    echo "Unknown agent: $AGENT"
    echo "Supported: opencode, codex, claude, antigravity, cursor, windsurf"
    exit 1
    ;;
esac

echo "Installing for: $AGENT"
echo "Config directory: $CONFIG_DIR"

# Clone or update the repository
REPO_URL="${REPO_URL:-https://github.com/agallardo2802/Proyecto-Agentes}"
SKILLS_DIR="$CONFIG_DIR"
PARENT_DIR="$(dirname "$SKILLS_DIR")"
mkdir -p "$PARENT_DIR"

sync_repo_to_dir() {
  local target_dir="$1"
  local parent_dir backup_root backup_dir ts
  parent_dir="$(dirname "$target_dir")"
  mkdir -p "$parent_dir"

  if [ -n "${GGS_AGENTS_SOURCE_DIR:-}" ] && [ -f "$GGS_AGENTS_SOURCE_DIR/scripts/install.sh" ]; then
    echo "Installing from local package into: $target_dir"
    if [ "$DRY_RUN" = "1" ]; then
      echo "DryRun: copy '$GGS_AGENTS_SOURCE_DIR' to '$target_dir'"
      return 0
    fi
    backup_root="$parent_dir/backups"
    mkdir -p "$backup_root"
    if [ -d "$target_dir" ]; then
      ts="$(date +%Y%m%d-%H%M%S)"
      backup_dir="$backup_root/$(basename "$target_dir").$ts.bak"
      mv "$target_dir" "$backup_dir"
      echo "  - Previous installation moved to backup: $backup_dir"
    fi
    mkdir -p "$target_dir"
    (cd "$GGS_AGENTS_SOURCE_DIR" && tar --exclude="./.git" --exclude="./.claude" --exclude="./node_modules" --exclude="./dist" --exclude="./backups" --exclude="./.next" -cf - .) | (cd "$target_dir" && tar -xf -)
    chmod -R u+w "$target_dir" 2>/dev/null || true
  elif [ -d "$target_dir/.git" ]; then
    echo "Updating existing installation: $target_dir"
    if [ "$DRY_RUN" = "1" ]; then
      echo "DryRun: fetch + pull de la rama por defecto del remoto en '$target_dir'"
    else
      # Detectar la rama por defecto del remoto (master) en vez de asumir main.
      # Sirve para clones viejos que quedaron apuntando a la rama renombrada.
      git -C "$target_dir" fetch origin --prune >/dev/null 2>&1 || true
      git -C "$target_dir" remote set-head origin -a >/dev/null 2>&1 || true
      def_branch="$(git -C "$target_dir" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
      [ -n "$def_branch" ] || def_branch="master"
      git -C "$target_dir" pull origin "$def_branch"
    fi
  elif [ ! -d "$target_dir" ]; then
    echo "Cloning repository into: $target_dir"
    if [ "$DRY_RUN" = "1" ]; then
      echo "DryRun: git clone '$REPO_URL' '$target_dir'"
    else
      git clone "$REPO_URL" "$target_dir"
    fi
  else
    echo "Target exists but is not a git clone: $target_dir"
    echo "Not removed automatically to protect local skills/config. Two options:"
    echo "  1) Install from a local clone (auto-backup + replace):"
    echo "       GGS_AGENTS_SOURCE_DIR=\"\$HOME/Proyecto-Agentes\" bash scripts/install.sh"
    echo "  2) Move/remove it manually and rerun:"
    echo "       mv \"$target_dir\" \"$target_dir.bak\""
    exit 1
  fi
}

sync_repo_to_dir "$SKILLS_DIR"

if [ "$AGENT" = "opencode" ]; then
  sync_repo_to_dir "$HOME/.claude/skills/ggs"
  sync_repo_to_dir "$HOME/.codex/skills/ggs"
  sync_repo_to_dir "$HOME/.antigravity/skills/ggs"
fi

# ============================================
# REGISTRAR AGENTES EN OPENCODE SELECTOR
# ============================================
if [ "$AGENT" = "opencode" ]; then
  echo ""
  echo "Registering GGS agents in OpenCode selector..."

  if [ "$DRY_RUN" = "1" ]; then
    echo "DryRun: no opencode.json will be created or modified"
    echo "DryRun: agents that would be registered: Arquitecto, Planificador, Revisor"
    echo "DryRun: companion skills would remain available for Claude Code, Codex and Antigravity"
    echo ""
    echo "GGS Agents dry-run completed successfully!"
    exit 0
  fi

  OPENCODE_CONFIG="$HOME/.config/opencode"
  OPENCODE_JSON="$OPENCODE_CONFIG/opencode.json"
  AGENTS_DIR="$OPENCODE_CONFIG/agents"
  CUSTOM_AGENTS_DIR="$OPENCODE_CONFIG/agents/custom"
  BACKUP_DIR="$OPENCODE_CONFIG/backups"

  mkdir -p "$OPENCODE_CONFIG"

  PYTHON_BIN=""
  if command -v python3 >/dev/null 2>&1 && python3 --version >/dev/null 2>&1; then
    PYTHON_BIN="python3"
  elif command -v python >/dev/null 2>&1 && python --version >/dev/null 2>&1; then
    PYTHON_BIN="python"
  else
    echo "  - python3/python not found; cannot update opencode.json automatically"
    echo "  - Install Python 3 and rerun this script"
    exit 1
  fi

  if [ ! -f "$OPENCODE_JSON" ]; then
    printf '%s\n' '{"$schema":"https://opencode.ai/config.json","agent":{}}' > "$OPENCODE_JSON"
  fi

  mkdir -p "$BACKUP_DIR"
  if [ -f "$OPENCODE_JSON" ]; then
    TS="$(date +%Y%m%d-%H%M%S)"
    cp "$OPENCODE_JSON" "$BACKUP_DIR/opencode.json.$TS.bak"
    echo "  - Backup created: $BACKUP_DIR/opencode.json.$TS.bak"
  fi

  # -------------------------------------------------------
  # LIMPIEZA SEGURA: mover carpetas antiguas de agents/ y agents/custom/
  # a backup para evitar duplicados en el dropdown
  # sin borrar contenido local del usuario.
  # -------------------------------------------------------
  legacy_brand="C""4"
  legacy_sdd="sdd-c""4"
  legacy_orchestrator="Sdd-${legacy_brand}-Orchestrator"
  legacy_plan="Sdd-${legacy_brand}-Plan"
  legacy_judgment="Sdd-${legacy_brand}-Judgment"
  legacy_skills="Sdd-${legacy_brand}-Skills"
  for agent_folder in "sdd-ggs" "$legacy_sdd" "Sdd-GGS-Orchestrator" "Sdd-GGS-Plan" "Sdd-GGS-Judgment" "Sdd-GGS-Skills" "$legacy_orchestrator" "$legacy_plan" "$legacy_judgment" "$legacy_skills" "Orquestador" "Planificador" "Revisor"; do
    if [ -d "$AGENTS_DIR/$agent_folder" ]; then
      TS="$(date +%Y%m%d-%H%M%S)"
      mv "$AGENTS_DIR/$agent_folder" "$BACKUP_DIR/$agent_folder.$TS.bak"
      echo "  - Moved old agents/$agent_folder to backup"
    fi
    if [ -d "$CUSTOM_AGENTS_DIR/$agent_folder" ]; then
      TS="$(date +%Y%m%d-%H%M%S)"
      mv "$CUSTOM_AGENTS_DIR/$agent_folder" "$BACKUP_DIR/$agent_folder.$TS.bak"
      echo "  - Moved old agents/custom/$agent_folder to backup"
    fi
  done

  "$PYTHON_BIN" - "$OPENCODE_JSON" "$DEFAULT_OPENCODE_MODEL" "$SDD_PROFILE_MODEL" <<'PY'
import json
import os
import sys
from pathlib import Path

path = Path(sys.argv[1])
default_model = sys.argv[2]
profile_model = sys.argv[3] if len(sys.argv) > 3 and sys.argv[3] else "openai/gpt-5.5"
data = json.loads(path.read_text(encoding="utf-8"))
data["$schema"] = "https://opencode.ai/config.json"
agents = data.setdefault("agent", {})
mcps = data.setdefault("mcp", {})
commands = data.setdefault("command", {})
optional_mcp_enabled = os.environ.get("GGS_ENABLE_OPTIONAL_MCPS") == "1"
legacy_models = {"opencode/minimax-m2.5-free", "ggsoluciones-ai/minimax-m2.7", "minimax-coding-plan/MiniMax-M2.7", "minimax-coding-plan/MiniMax-M2.7-highspeed", "google/gemini-3.5-flash"}
model = data.get("model")
if not model or model in legacy_models:
    model = default_model or None
if model:
    data["model"] = model
else:
    data.pop("model", None)

legacy_brand = "C" + "4"
legacy_sdd = "sdd-" + legacy_brand.lower()
legacy_agent_names = (
    "Orquestador",
    "Sdd-GGS-Orchestrator",
    "Sdd-GGS-Plan",
    "Sdd-GGS-Judgment",
    "Sdd-GGS-Skills",
    "sdd-ggs",
    legacy_sdd,
    f"Sdd-{legacy_brand}-Orchestrator",
    f"Sdd-{legacy_brand}-Plan",
    f"Sdd-{legacy_brand}-Judgment",
    f"Sdd-{legacy_brand}-Skills",
)
for old_name in legacy_agent_names:
    agents.pop(old_name, None)

def agent_config(description, prompt):
    cfg = {"description": description, "mode": "primary", "prompt": prompt}
    return cfg

agents["Arquitecto"] = agent_config(
    "Arquitecto - flujo completo SDD-GGS; orquesta todo el proceso",
    "{file:./skills/agents/Arquitecto/AGENT.md}",
)
agents["Planificador"] = agent_config(
    "Planificador - solo análisis y carga de tablero; otro desarrolla",
    "{file:./skills/agents/Planificador/AGENT.md}",
)
agents["Revisor"] = agent_config(
    "Revisor - revisión adversarial paralela con dos jueces independientes",
    "{file:./skills/agents/Revisor/AGENT.md}",
)

profiles_dir = Path.home() / ".config" / "opencode" / "profiles"
profiles_dir.mkdir(parents=True, exist_ok=True)
def make_profile(models, efforts):
    return {
        "models": models,
        "fallback": {},
        "configs": {phase: {"reasoningEffort": effort} for phase, effort in efforts.items()},
    }

full_codex_models = {
    "gentle-orchestrator": "openai/gpt-5.5",
    "sdd-apply": "openai/gpt-5.5",
    "sdd-archive": "openai/gpt-5.4-mini",
    "sdd-design": "openai/gpt-5.5",
    "sdd-explore": "openai/gpt-5.3-codex",
    "sdd-init": "openai/gpt-5.3-codex",
    "sdd-judgment": "openai/gpt-5.5",
    "sdd-onboard": "openai/gpt-5.3-codex",
    "sdd-plan": "openai/gpt-5.5",
    "sdd-propose": "openai/gpt-5.5",
    "sdd-spec": "openai/gpt-5.3-codex",
    "sdd-tasks": "openai/gpt-5.3-codex",
    "sdd-verify": "openai/gpt-5.5",
}
enterprise_safe_models = {
    "gentle-orchestrator": "google/gemini-3.5-flash",
    "sdd-apply": "openai/gpt-5.5",
    "sdd-archive": "google/gemini-3.5-flash",
    "sdd-design": "openai/gpt-5.5",
    "sdd-explore": "google/gemini-3.5-flash",
    "sdd-init": "google/gemini-3.5-flash",
    "sdd-judgment": "openai/gpt-5.5",
    "sdd-onboard": "google/gemini-3.5-flash",
    "sdd-plan": "google/gemini-3.5-flash",
    "sdd-propose": "google/gemini-3.5-flash",
    "sdd-spec": "google/gemini-3.5-flash",
    "sdd-tasks": "openai/gpt-5.5",
    "sdd-verify": "openai/gpt-5.5",
}
low_cost_models = {
    "gentle-orchestrator": "ggsoluciones-ai/minimax-m2.7",
    "sdd-apply": "ggsoluciones-ai/minimax-m2.7",
    "sdd-archive": "ggsoluciones-ai/minimax-m2.7",
    "sdd-design": "ggsoluciones-ai/minimax-m2.7",
    "sdd-explore": "ggsoluciones-ai/minimax-m2.7",
    "sdd-init": "ggsoluciones-ai/minimax-m2.7",
    "sdd-judgment": "ggsoluciones-ai/minimax-m2.7",
    "sdd-onboard": "ggsoluciones-ai/minimax-m2.7",
    "sdd-plan": "ggsoluciones-ai/minimax-m2.7",
    "sdd-propose": "ggsoluciones-ai/minimax-m2.7",
    "sdd-spec": "ggsoluciones-ai/minimax-m2.7",
    "sdd-tasks": "ggsoluciones-ai/minimax-m2.7",
    "sdd-verify": "ggsoluciones-ai/minimax-m2.7",
}
standard_efforts = {
    "gentle-orchestrator": "medium",
    "sdd-apply": "high",
    "sdd-archive": "low",
    "sdd-design": "high",
    "sdd-explore": "medium",
    "sdd-init": "low",
    "sdd-judgment": "high",
    "sdd-onboard": "low",
    "sdd-plan": "medium",
    "sdd-propose": "medium",
    "sdd-spec": "medium",
    "sdd-tasks": "medium",
    "sdd-verify": "high",
}
low_cost_efforts = {
    "gentle-orchestrator": "medium",
    "sdd-apply": "medium",
    "sdd-archive": "low",
    "sdd-design": "medium",
    "sdd-explore": "medium",
    "sdd-init": "low",
    "sdd-judgment": "medium",
    "sdd-onboard": "low",
    "sdd-plan": "medium",
    "sdd-propose": "medium",
    "sdd-spec": "medium",
    "sdd-tasks": "medium",
    "sdd-verify": "medium",
}
profile_definitions = {
    "Codex-Ale.json": make_profile(full_codex_models, standard_efforts),
    "Codex-Ale SDD Profile.json": make_profile(full_codex_models, standard_efforts),
    "Full Codex.json": make_profile(full_codex_models, standard_efforts),
    "Enterprise Safe.json": make_profile(enterprise_safe_models, standard_efforts),
    "Low Cost.json": make_profile(low_cost_models, low_cost_efforts),
}
for profile_name, profile_content in profile_definitions.items():
    (profiles_dir / profile_name).write_text(json.dumps(profile_content, indent=2), encoding="utf-8")
if not default_model:
    print("  - Codex not found: keeping OpenCode default/existing model")
for name in list(agents):
    if name.endswith("-fallback") or name in {"sdd-plan", "sdd-judgment", "Sdd-GGS-Skills", legacy_sdd, f"Sdd-{legacy_brand}-Skills"}:
        del agents[name]
agents["plan"] = {"hidden": True}
agents["build"] = {"hidden": True}
mcps.setdefault("context7", {"enabled": optional_mcp_enabled, "type": "remote", "url": "https://mcp.context7.com/mcp"})
mcps.setdefault("engram", {"type": "local", "command": ["engram", "mcp", "--tools=agent"]})
mcps["azure-devops"] = {
    "enabled": optional_mcp_enabled,
    "type": "local",
    "command": [
        "npx",
        "-y",
        "@azure-devops/mcp",
        "ggsoluciones",
        "-d",
        "core",
        "work",
        "work-items",
        "repositories",
        "wiki",
        "pipelines",
    ],
}
mcps["playwright"] = {"enabled": optional_mcp_enabled, "type": "local", "command": ["npx", "-y", "@playwright/mcp@latest"]}
# Markitdown: convierte PDF/Word/Excel/PPT/imagenes a Markdown para ahorrar tokens.
# Sin credenciales -> habilitado por defecto (requiere uv/uvx, instalado por el script).
mcps["markitdown"] = {"enabled": True, "type": "local", "command": ["uvx", "markitdown-mcp"]}
# Notion (oficial): requiere NOTION_TOKEN en el entorno -> opcional.
mcps["notion"] = {
    "enabled": optional_mcp_enabled,
    "type": "local",
    "command": ["npx", "-y", "@notionhq/notion-mcp-server"],
    "environment": {"NOTION_TOKEN": "{env:NOTION_TOKEN}"},
}
# NotebookLM: requiere login de browser (auth persistente) -> opcional.
mcps["notebooklm"] = {"enabled": optional_mcp_enabled, "type": "local", "command": ["npx", "-y", "notebooklm-mcp@latest"]}
skills_root = Path.home() / ".config" / "opencode" / "skills"
commands["ggs-doctor"] = {
    "description": "Diagnosticar la instalacion GGS/OpenCode (agentes, MCPs, logo, herramientas)",
    "prompt": f"Ejecuta: bash '{skills_root}/scripts/doctor.sh'. Reporta el estado de herramientas, opencode.json, agentes, MCPs, skills y logo TUI. Resume los [WARN]/[FAIL] y sugiere como repararlos.",
}
commands["ggs-update"] = {
    "description": "Actualizar agentes GGS y refrescar OpenCode",
    "prompt": f"Ejecuta desde el clon instalado: GGS_AGENTS_SOURCE_DIR='{skills_root}' bash '{skills_root}/scripts/install.sh' --dry-run. Si el usuario confirma, repetir sin --dry-run. Luego resume cambios y recorda reiniciar OpenCode.",
}
commands["ggs-status"] = {
    "description": "Validar instalacion GGS/OpenCode y ofrecer actualizacion segura",
    "prompt": f"Ejecuta: test -d '{skills_root}' && find '{skills_root}/agents' -maxdepth 2 -type f -name AGENT.md 2>/dev/null. Reporta estado de agentes GGS y OpenCode. Si falta algo, pregunta si quiere reinstalar. Si confirma, ejecuta desde el clon instalado: GGS_AGENTS_SOURCE_DIR='{skills_root}' bash '{skills_root}/scripts/install.sh'. Al finalizar, resume cambios y recorda reiniciar OpenCode.",
}
path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
PY
  echo "  - Registered Arquitecto in opencode.json"
  echo "  - Registered Planificador in opencode.json"
  echo "  - Registered Revisor in opencode.json"

  PLUGIN_DIR="$OPENCODE_CONFIG/tui-plugins"
  PLUGIN_PATH="$PLUGIN_DIR/gentle-logo.tsx"
  mkdir -p "$PLUGIN_DIR"
  if [ -f "$PLUGIN_PATH" ]; then
    TS="$(date +%Y%m%d-%H%M%S)"
    cp "$PLUGIN_PATH" "$BACKUP_DIR/gentle-logo.tsx.$TS.bak"
  fi
  # El contenido del logo (con bloques Unicode) vive en un archivo aparte para
  # evitar problemas de codificacion. Se copia tal cual desde el repo/clon.
  LOGO_ASSET="$SCRIPT_DIR/assets/gentle-logo.tsx"
  if [ -f "$LOGO_ASSET" ]; then
    cp "$LOGO_ASSET" "$PLUGIN_PATH"
    echo "  - Installed GGSoluciones logo plugin: $PLUGIN_PATH"
  else
    echo "  - Logo asset not found at $LOGO_ASSET; skipping TUI logo"
  fi
  echo "  - Agent files live in skills/agents/ (no Custom/ duplicates)"
fi

echo ""
echo "GGS Agents installed successfully!"
echo ""
echo "To use:"
echo "  1. Open $AGENT (restart if already open)"
if [ "$AGENT" = "opencode" ]; then
  echo "  2. Select 'Arquitecto', 'Planificador' or 'Revisor' from the selector"
  echo "  3. Or type: sdd"
  echo "  4. Restart Claude Code, Codex and Antigravity if they were already open"
else
  echo "  2. Verify it loads GGS skills from: $SKILLS_DIR"
  echo "  3. Invoke the SDD-GGS skill/agent with: sdd"
fi
echo ""
echo "For more info, see: $SKILLS_DIR/README.md"
