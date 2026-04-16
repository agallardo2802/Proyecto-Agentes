# GGS - Installation Guide

## Quick Install

### OpenCode (Windows)
```powershell
irm https://raw.githubusercontent.com/agallardo2802/Proyecto-Agentes/main/scripts/install.ps1 | iex
```

### OpenCode (Linux/macOS)
```bash
curl -fsSL https://raw.githubusercontent.com/agallardo2802/Proyecto-Agentes/main/scripts/install.sh | bash
```

### Claude Code
```bash
curl -fsSL https://raw.githubusercontent.com/agallardo2802/Proyecto-Agentes/main/scripts/install.sh | bash -s claude
```

## Manual Installation

### OpenCode
```bash
# Clone el repositorio
git clone https://github.com/agallardo2802/Proyecto-Agentes.git ~/.config/opencode/skills/ggs
```

### Claude Code
```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes.git ~/.claude/skills/ggs
```

## Usage

Una vez instalado, simplemente escribí:

```
> sdd
> necesito agregar autenticación JWT
```

O usá un agente específico:

```
@equipo/desarrollo/dev
@equipo/producto/pm
@guilds/backend-dotnet
```

## Estructura de archivos

El sistema se instala en:
- OpenCode: `~/.config/opencode/skills/ggs/`
- Claude: `~/.claude/skills/ggs/`
- Cursor: `~/.cursor/skills/ggs/`

Dentro encontrás:
- `orchestrator/AGENT.md` — punto de entrada
- `equipo/` — todos los agentes
- `guilds/` — estándares por tecnología
- `reglas/` — reglas técnicas
- `equipo/sdd-ggs/SKILL.md` — skill SDD