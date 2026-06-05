#!/bin/bash
# ==============================================================================
# GGS DOCTOR - Diagnostico de instalacion (Linux/macOS)
# ==============================================================================
# Verifica el estado de la instalacion GGS/OpenCode y reporta que falta.
# Uso: bash scripts/doctor.sh
# ==============================================================================

ISSUES=0
GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; CYAN='\033[36m'; GRAY='\033[90m'; NC='\033[0m'
ok()   { printf "  ${GREEN}[OK]${NC}   %s\n" "$1"; }
warn() { printf "  ${YELLOW}[WARN]${NC} %s\n" "$1"; ISSUES=$((ISSUES+1)); }
fail() { printf "  ${RED}[FAIL]${NC} %s\n" "$1"; ISSUES=$((ISSUES+1)); }

echo ""
printf "${CYAN}=== GGS DOCTOR ===${NC}\n\n"

# 1. Herramientas
printf "${CYAN}Herramientas:${NC}\n"
for t in git node opencode uv engram; do
  if command -v "$t" >/dev/null 2>&1; then
    v="$($t --version 2>/dev/null | head -n1)"
    ok "$t -> $v"
  else
    case "$t" in
      uv)     warn "uv no encontrado (markitdown-mcp no funcionara)";;
      engram) warn "engram no encontrado (memoria persistente deshabilitada)";;
      *)      fail "$t no encontrado";;
    esac
  fi
done

# 2. OpenCode config
echo ""
printf "${CYAN}OpenCode:${NC}\n"
OC_DIR="$HOME/.config/opencode"
OC_JSON="$OC_DIR/opencode.json"
if [ -f "$OC_JSON" ]; then
  if command -v python3 >/dev/null 2>&1 && python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$OC_JSON" 2>/dev/null; then
    ok "opencode.json es JSON valido"
    for a in Arquitecto Planificador Revisor; do
      if python3 -c "import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if sys.argv[2] in d.get('agent',{}) else 1)" "$OC_JSON" "$a" 2>/dev/null; then
        ok "Agente '$a' registrado"
      else
        fail "Agente '$a' NO registrado"
      fi
    done
    for m in engram markitdown; do
      if python3 -c "import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if sys.argv[2] in d.get('mcp',{}) else 1)" "$OC_JSON" "$m" 2>/dev/null; then
        ok "MCP '$m' configurado"
      else
        warn "MCP '$m' no configurado"
      fi
    done
  else
    fail "opencode.json NO es JSON valido: $OC_JSON"
  fi
else
  fail "No existe opencode.json. Corre install.sh"
fi

# 3. Skills GGS
if [ -f "$OC_DIR/skills/agents/Arquitecto/AGENT.md" ]; then
  ok "Skills GGS instalados"
else
  fail "Skills GGS no encontrados en $OC_DIR/skills"
fi

# 4. Logo TUI
echo ""
printf "${CYAN}Logo TUI:${NC}\n"
[ -f "$OC_DIR/tui-plugins/gentle-logo.tsx" ] && ok "Plugin de logo presente" || warn "Plugin de logo no encontrado"
if [ -f "$OC_DIR/tui.json" ]; then
  grep -q "gentle-logo" "$OC_DIR/tui.json" && ok "Logo registrado en tui.json" || warn "Logo NO registrado en tui.json"
else
  warn "tui.json no existe"
fi

# Resumen
echo ""
if [ "$ISSUES" -eq 0 ]; then
  printf "${GREEN}Todo OK. Instalacion GGS saludable.${NC}\n"
else
  printf "${YELLOW}%s punto(s) requieren atencion. Revisa los [WARN]/[FAIL].${NC}\n" "$ISSUES"
  printf "${GRAY}Tip: corre  bash scripts/install.sh  para reparar.${NC}\n"
fi
echo ""
