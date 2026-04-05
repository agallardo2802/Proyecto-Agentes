# Instalación — Sistema de Agentes

Guía de instalación para usar estos agentes en tu entorno local.

---

## Requisitos

Elegí la plataforma que vas a usar:

| Plataforma | Para qué sirve |
|-----------|----------------|
| **Claude Code** | Cliente de terminal oficial de Anthropic |
| **OpenCode** | Cliente de terminal open source (multi-modelo) |
| **Claude.ai** | Interfaz web — no requiere instalación |

---

## Claude Code (terminal oficial de Anthropic)

### Windows

```powershell
# 1. Instalar Node.js (si no lo tenés)
winget install OpenJS.NodeJS.LTS

# 2. Instalar Claude Code
npm install -g @anthropic-ai/claude-code

# 3. Verificar instalación
claude --version
```

### macOS

```bash
# 1. Instalar Node.js (si no lo tenés)
brew install node

# 2. Instalar Claude Code
npm install -g @anthropic-ai/claude-code

# 3. Verificar instalación
claude --version
```

### Linux

```bash
# 1. Instalar Node.js (si no lo tenés)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# 2. Instalar Claude Code
npm install -g @anthropic-ai/claude-code

# 3. Verificar instalación
claude --version
```

### Configurar cuenta

```bash
claude login
```

Requiere cuenta en [claude.ai](https://claude.ai) con plan Pro o Team.

Documentación oficial: https://claude.ai/code

---

## OpenCode (terminal open source)

### Windows

```powershell
# Opción A — con npm
npm install -g opencode-ai

# Opción B — con Scoop
scoop install opencode

# Verificar instalación
opencode --version
```

### macOS

```bash
# Opción A — con npm
npm install -g opencode-ai

# Opción B — con Homebrew
brew install sst/tap/opencode

# Verificar instalación
opencode --version
```

### Linux

```bash
# Con npm
npm install -g opencode-ai

# Verificar instalación
opencode --version
```

### Configurar modelo

OpenCode soporta múltiples proveedores. Al primer arranque te pide configurar el modelo:

```bash
opencode
```

Recomendado: Claude (Anthropic) o GPT-4o (OpenAI). Necesitás una API key del proveedor que elijas.

Documentación oficial: https://opencode.ai/docs

---

## Claude.ai (web — sin instalación)

1. Ir a [claude.ai](https://claude.ai)
2. Crear cuenta (plan Free disponible, Pro recomendado)
3. Ir a **Projects** → **New project**
4. Seguir el paso a paso en el [README](README.md)

---

## Clonar este repositorio

Una vez que tenés la plataforma instalada, cloná el repositorio:

```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes.git
cd Proyecto-Agentes
```

---

## Primeros pasos después de instalar

### Claude Code

```bash
# Entrar al directorio del proyecto donde vas a trabajar
cd /ruta/a/tu/proyecto

# Crear el CLAUDE.md apuntando al repositorio de agentes
# (ver README.md sección "Uso en Claude Code")
echo "# Agentes\n@/ruta/a/Proyecto-Agentes/orchestrator/AGENT.md" > CLAUDE.md

# Abrir Claude Code
claude
```

### OpenCode

```bash
# Entrar al directorio del proyecto donde vas a trabajar
cd /ruta/a/tu/proyecto

# Inicializar OpenCode (crea .opencode/ automáticamente)
opencode

# Luego crear .opencode/agents.md con el contenido del orchestrator
# (ver README.md sección "Uso en OpenCode")
```

### Claude.ai

Ver el paso a paso completo en la sección **Uso en Claude (claude.ai)** del [README](README.md).

---

## Problemas comunes

| Problema | Solución |
|----------|----------|
| `claude: command not found` | Cerrar y reabrir la terminal después de instalar |
| `npm: permission denied` (Linux/Mac) | Usar `sudo npm install -g` o configurar npm prefix |
| `claude login` no abre el browser | Copiar la URL manualmente desde la terminal |
| OpenCode no encuentra el modelo | Verificar que la API key esté configurada correctamente |
