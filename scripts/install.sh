#!/bin/bash
set -e

# ============================================
# GGS Agents Installer v3.0
# Interactive TUI + Auto-Dependencies
# ============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GRAY='\033[0;90m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# ============================================
# UTILITY FUNCTIONS
# ============================================

print_banner() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗"
    echo -e "${CYAN}║       GGS Agents v3.0 - Install Wizard           ║"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${CYAN}▶ $1${NC}"
}

# ============================================
# DEPENDENCY DETECTION
# ============================================

detect_dependencies() {
    echo ""
    echo -e "${CYAN}🔍 Detecting dependencies...${NC}"
    
    DEPS=()
    
    # Git
    if command -v git &> /dev/null; then
        VERSION=$(git --version | grep -oP '\d+\.\d+' | head -1)
        echo -e "  ✅ git: v$VERSION"
        DEPS+=(git)
    else
        echo -e "  ❌ git: not found (required)"
    fi
    
    # Go
    if command -v go &> /dev/null; then
        VERSION=$(go version | grep -oP 'go\d+\.\d+' | head -1 | tr -d 'go')
        echo -e "  ✅ go: v$VERSION"
        DEPS+=(go)
    else
        echo -e "  ⚠️  go: not found (optional)"
    fi
    
    # Python
    if command -v python3 &> /dev/null; then
        VERSION=$(python3 --version | grep -oP '\d+\.\d+' | head -1)
        echo -e "  ✅ python: v$VERSION"
        DEPS+=(python)
    elif command -v python &> /dev/null; then
        VERSION=$(python --version | grep -oP '\d+\.\d+' | head -1)
        echo -e "  ✅ python: v$VERSION"
        DEPS+=(python)
    else
        echo -e "  ⚠️  python: not found (optional)"
    fi
    
    # Node.js
    if command -v node &> /dev/null; then
        VERSION=$(node --version | tr -d 'v')
        echo -e "  ✅ node: v$VERSION"
        DEPS+=(node)
    else
        echo -e "  ❌ node: not found (required)"
    fi
    
    # NPM
    if command -v npm &> /dev/null; then
        VERSION=$(npm --version)
        echo -e "  ✅ npm: v$VERSION"
        DEPS+=(npm)
    else
        echo -e "  ❌ npm: not found (required)"
    fi
    
    # OpenCode
    if command -v opencode &> /dev/null; then
        VERSION=$(opencode --version 2>/dev/null || echo "1.0")
        echo -e "  ✅ opencode: v$VERSION"
        DEPS+=(opencode)
    else
        echo -e "  ⚠️  opencode: not found (required - manual install)"
    fi
    
    # Engram
    if command -v engram &> /dev/null; then
        VERSION=$(engram --version 2>/dev/null || echo "1.0")
        echo -e "  ✅ engram: v$VERSION"
        DEPS+=(engram)
    else
        echo -e "  ⚠️  engram: not found (optional)"
    fi
}

install_missing_deps() {
    echo ""
    echo -e "${CYAN}📥 Missing dependencies${NC}"
    echo "Install with:"
    echo "  macOS: brew install git go node"
    echo "  Linux: apt-get install git golang nodejs npm"
    echo "  Manual: https://opencode.ai"
}

# ============================================
# AGENT SELECTION
# ============================================

select_agent() {
    echo ""
    echo -e "${CYAN}🤖 Select AI Agent:${NC}"
    echo "  1. opencode  (default - multi-model per phase)"
    echo "  2. claude    (Claude Code)"
    echo "  3. cursor    (Cursor IDE)"
    echo "  4. windsurf  (Windsurf)"
    echo "  5. all       (all agents)"
    echo ""
    read -p "Select [1-5]: " SELECTION
    
    case $SELECTION in
        1) AGENTS=("opencode") ;;
        2) AGENTS=("claude") ;;
        3) AGENTS=("cursor") ;;
        4) AGENTS=("windsurf") ;;
        5) AGENTS=("opencode" "claude" "cursor" "windsurf") ;;
        *) AGENTS=("opencode") ;;
    esac
}

# ============================================
# INSTALL LOGIC
# ============================================

install_ggs_agents() {
    REPO_URL="${REPO_URL:-https://github.com/agallardo2802/Proyecto-Agentes.git}"
    
    for AGENT in "${AGENTS[@]}"; do
        echo ""
        echo -e "${CYAN}📦 Installing for: $AGENT${NC}"
        
        # Config directory
        case $AGENT in
            opencode)  CONFIG_DIR="$HOME/.config/opencode/skills" ;;
            claude)   CONFIG_DIR="$HOME/.claude/skills" ;;
            cursor)  CONFIG_DIR="$HOME/.cursor/skills" ;;
            windsurf) CONFIG_DIR="$HOME/.windsurf/skills" ;;
            *)      CONFIG_DIR="$HOME/.config/opencode/skills" ;;
        esac
        
        echo -e "  📂 $CONFIG_DIR"
        
        # Create directory
        mkdir -p "$CONFIG_DIR"
        
        SKILLS_DIR="$CONFIG_DIR/ggs"
        
        # Clone or update
        if [ -d "$SKILLS_DIR" ]; then
            echo -e "  📥 Updating..."
            cd "$SKILLS_DIR"
            git pull origin main 2>/dev/null || true
        else
            echo -e "  📥 Cloning..."
            git clone "$REPO_URL" "$SKILLS_DIR"
        fi
        
        # Copy skill to root
        ROOT_SKILL_DIR="$CONFIG_DIR/sdd-ggs"
        mkdir -p "$ROOT_SKILL_DIR"
        cp "$SKILLS_DIR/equipo/sdd-ggs/SKILL.md" "$ROOT_SKILL_DIR/SKILL.md" 2>/dev/null || true
        
        # Register in OpenCode
        if [ "$AGENT" = "opencode" ]; then
            echo -e "  📝 Registering in OpenCode..."
            
            OPENCODE_CONFIG="$HOME/.config/opencode"
            OPENCODE_JSON="$OPENCODE_CONFIG/opencode.json"
            CUSTOM_AGENTS_DIR="$OPENCODE_CONFIG/agents/custom"
            
            # Clean old agents
            for folder in sdd-ggs Sdd-GGS-Orchestrator Sdd-GGS-Skills Sdd-GGS-Plan Sdd-GGS-Judgment; do
                rm -rf "$CUSTOM_AGENTS_DIR/$folder" 2>/dev/null || true
            done
            
            # Register new agents
            if [ -f "$OPENCODE_JSON" ]; then
                python3 - "$OPENCODE_JSON" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = json.loads(path.read_text(encoding="utf-8"))
agents = data.setdefault("agent", {})
common_tools = {"read": True, "edit": True, "write": True, "bash": True, "glob": True, "grep": True}
model = "opencode/minimax-m2.5-free"

agents["Sdd-GGS-Orchestrator"] = {
    "name": "Sdd-GGS-Orchestrator",
    "description": "SDD automático - flujo completo",
    "mode": "primary",
    "model": model,
    "prompt": "{file:./skills/ggs/agents/Sdd-GGS-Orchestrator/agent.md}",
    "tools": common_tools,
}
agents["Sdd-GGS-Plan"] = {
    "name": "Sdd-GGS-Plan",
    "description": "Plan - solo análisis",
    "mode": "primary",
    "model": model,
    "prompt": "{file:./skills/ggs/agents/Sdd-GGS-Plan/agent.md}",
    "tools": common_tools,
}
agents["Sdd-GGS-Skills"] = {
    "name": "Sdd-GGS-Skills",
    "description": "Skills - control manual",
    "mode": "primary",
    "model": model,
    "prompt": "{file:./skills/ggs/agents/Sdd-GGS-Skills/agent.md}",
    "tools": common_tools,
}
agents["Sdd-GGS-Judgment"] = {
    "name": "Sdd-GGS-Judgment",
    "description": "Judgment Day - revisión adversarial",
    "mode": "primary",
    "model": model,
    "prompt": "{file:./skills/ggs/agents/Sdd-GGS-Judgment/agent.md}",
    "tools": common_tools,
}

path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
PY
                echo -e "  ✅ Registered 4 agents"
            fi
        fi
        
        echo -e "  ✅ $AGENT ready!"
    done
}

# ============================================
# MAIN
# ============================================

main() {
    print_banner
    
    # Detect deps
    detect_dependencies
    
    # Check required
    if ! command -v git &> /dev/null || ! command -v node &> /dev/null; then
        install_missing_deps
    fi
    
    # Select agent
    select_agent
    
    # Confirm
    echo ""
    echo -e "${CYAN}📋 Summary:${NC}"
    echo "  Agents: ${AGENTS[*]}"
    echo "  Repo: https://github.com/agallardo2802/Proyecto-Agentes.git"
    echo ""
    read -p "Proceed? [Y/n]: " CONFIRM
    
    if [ "$CONFIRM" = "n" ] || [ "$CONFIRM" = "N" ]; then
        echo "Cancelled."
        exit 0
    fi
    
    # Install
    install_ggs_agents
    
    # Done
    echo ""
    print_banner
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Open your AI agent"
    echo "  2. Select 'Sdd-GGS-Orchestrator'"
    echo "  3. Run: /sdd-init"
    echo ""
}

main "$@"