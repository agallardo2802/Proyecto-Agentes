# GGS - Installation Guide

## Requisitos previos

Antes de instalar los agentes, asegurate de tener estas herramientas disponibles en tu equipo:

| Herramienta | Requerido | Para qué se usa |
|-------------|-----------|-----------------|
| **Git** | Sí | Clonar este repositorio desde GitHub y mantenerlo actualizado. |
| **Node.js LTS** | Sí | Ejecutar herramientas de IA y clientes como Claude Code u OpenCode cuando dependan de npm. |
| **Python 3** | Recomendado | Ejecutar scripts auxiliares, automatizaciones y herramientas de análisis cuando el proyecto lo requiera. |
| **Node.js/npm** | Sí | Trabajar con stacks React/Next/Vite y ejecutar tooling frontend. |
| **Go** | Recomendado | Trabajar con proyectos o herramientas escritas en Go, y ejecutar tests Go cuando aplique. |
| **.NET SDK 8** | Recomendado | Trabajar con servicios .NET y ejecutar tests cuando aplique. |
| **Docker** | Recomendado | Ejecutar dependencias locales y entornos reproducibles. |
| **Windows Terminal** | Recomendado en Windows | Tener una terminal moderna con PowerShell, perfiles y mejor soporte de rutas/comandos. |
| **Ghostty** | Recomendado en Linux/macOS | Terminal moderna para equipos fuera de Windows cuando esté disponible por package manager. |
| **Visual Studio Code** | Recomendado | Editar agentes, documentación, scripts y archivos de configuración del equipo. |
| **Slack** | Recomendado | Comunicación operativa del equipo. |
| **OpenCode** | Sí | Cliente AI principal para usar los agentes GGS. |

### Windows — instalación sugerida

```powershell
winget install --id Git.Git -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Python.Python.3.12 -e
winget install --id GoLang.Go -e
winget install --id Microsoft.DotNet.SDK.8 -e
winget install --id Docker.DockerDesktop -e
winget install --id Microsoft.WindowsTerminal -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id SlackTechnologies.Slack -e
```

Después de instalar, cerrá y volvé a abrir la terminal para que se actualice el `PATH`.

### Verificación rápida

```bash
git --version
node --version
npm --version
python --version
go version
```

## Quick Install

### OpenCode (Windows)
```powershell
# Desde el clon del repo público
.\scripts\install.ps1 -DryRun
# Quitar -DryRun para aplicar cambios
```

El instalador Windows en modo OpenCode también deja listas las skills GGS para Claude Code, Codex y Antigravity en `~/.claude/skills/ggs`, `~/.codex/skills/ggs` y `~/.antigravity/skills/ggs`. Para omitir sólo Claude, usar `-NoInstallClaude`; para omitir todos los companion agents, usar `-NoInstallCompanionAgents`.

### OpenCode (Linux/macOS)
```bash
# Desde el clon del repo público
bash scripts/install.sh --dry-run
# Quitar --dry-run para aplicar cambios
```

En Linux/macOS el instalador valida dependencias y usa el paquete local o el repo público. React queda cubierto por Node.js/npm; no se instala React globalmente.

### Instalación desde GitHub público

Usar si querés revisar el instalador antes de ejecutarlo.

> ⚠️ **Elegí el instalador según tu sistema:** Windows usa PowerShell (`install.ps1`), Linux/macOS usa bash (`install.sh`).
> **No corras `install.sh` con `bash` en Windows**: ahí `bash` invoca WSL y, si no tenés una distro de Linux instalada, falla con `execvpe(/bin/bash) failed: No such file or directory`. En Windows usá siempre `install.ps1`.

**Windows (PowerShell):**
```powershell
git clone https://github.com/agallardo2802/Proyecto-Agentes $env:USERPROFILE\Proyecto-Agentes
cd $env:USERPROFILE\Proyecto-Agentes
.\scripts\install.ps1 -DryRun   # quitar -DryRun para aplicar
```

**Linux / macOS (bash):**
```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes /tmp/Proyecto-Agentes
bash /tmp/Proyecto-Agentes/scripts/install.sh --dry-run   # quitar --dry-run para aplicar
```

### Otros clientes (Claude Code, Codex, Antigravity)

Pasá el cliente como argumento. Por defecto el instalador usa `opencode`.

**Windows (PowerShell):**
```powershell
.\scripts\install.ps1 -Agent claude        # o: codex, antigravity, cursor, windsurf
```

**Linux / macOS (bash):**
```bash
bash scripts/install.sh claude             # o: codex, antigravity, cursor, windsurf
```

## Update existing installation

Desde el clon instalado:

```powershell
.\scripts\update.ps1
```

Validar sin aplicar cambios:

```powershell
.\scripts\update.ps1 -DryRun
```

Actualizar el repo y refrescar el registro de agentes en OpenCode:

```powershell
.\scripts\update.ps1 -ConfigureOpenCode
```

Actualizar también la CLI de Gentle AI en Windows:

```powershell
.\scripts\update.ps1 -UpdateGentleAI
```

Los scripts preservan configuración personal y crean backup de `~/.config/opencode/opencode.json` en `~/.config/opencode/backups/` antes de escribir. Reiniciá OpenCode o el cliente AI para cargar skills y agentes actualizados.

En Windows, el flujo OpenCode por defecto también actualiza/instala `~/.claude/skills/ggs`, `~/.codex/skills/ggs` y `~/.antigravity/skills/ggs` para que Claude Code, Codex y Antigravity puedan usar las mismas skills GGS después de reiniciar la app.

## Comandos de mantenimiento en OpenCode

Al registrar la capa GGS, el instalador agrega estos comandos a `opencode.json`:

```text
/ggs-status   # valida instalación/config sin aplicar cambios
/ggs-update   # actualiza Gentle AI + GGS y refresca OpenCode
```

Uso recomendado: corré `/ggs-status`. Primero valida sin aplicar cambios; si detecta actualizaciones o configuración incompleta, te pregunta si querés continuar. `/ggs-update` queda como atajo directo para mantenimiento avanzado. OpenCode carga configuración al iniciar: después de actualizar, reinicialo para tomar agentes, skills y comandos actualizados.

## Instalación desde clon local

Usá este camino sólo si querés revisar o modificar el repositorio antes de instalar. Después de clonar, ejecutá el instalador para que registre agentes, comandos, perfiles y companion skills.

### OpenCode
```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes /tmp/Proyecto-Agentes
bash /tmp/Proyecto-Agentes/scripts/install.sh opencode
```

### Claude Code
```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes /tmp/Proyecto-Agentes
bash /tmp/Proyecto-Agentes/scripts/install.sh claude
```

## Usage

Una vez instalado, elegí uno de los agentes GGS principales en OpenCode:

- `Orquestador` — flujo completo.
- `Planificador` — análisis, diseño y planificación.
- `Revisor` — revisión adversarial.

Para capacidades específicas, usá skills por contexto:

```
> necesito crear un login para el portal comercial
> armame un dashboard con métricas de ventas
> agregá feedback UAT para usuarios de prueba
> analizá este cashflow semanal y marcá riesgos P1/P2/P3
> revisá este asiento contable contra el plan de cuentas
> revisá este cambio con judgment
```

Skills financieras disponibles:

- `finanzas-metricas` — KPIs, cobranzas, pagos, aging, presupuesto vs real.
- `finanzas-contabilidad` — asientos, balances, conciliaciones y cierres para revisión humana.
- `finanzas-cashflow` — cashflow, vencimientos, escenarios y riesgos de liquidez.

Skill UAT disponible:

- `feedback-uat` — botón “Dejar feedback”, modal UAT con nombre de contacto, persistencia en BD, seguimiento por Slack `#feedback-sites` y validación de revisión.

También podés pedir fases SDD específicas:

```
sdd-explore
sdd-spec
sdd-verify
```

## Estructura de archivos

El sistema se instala en:
- OpenCode: `~/.config/opencode/skills/`
- Claude: `~/.claude/skills/ggs/`
- Codex: `~/.codex/skills/ggs/`
- Antigravity: `~/.antigravity/skills/ggs/`
- Cursor: `~/.cursor/skills/ggs/`
- Windsurf: `~/.windsurf/skills/ggs/`

OpenCode queda además con MCP local/remoto para `engram`, `context7`, `azure-devops` y `playwright`.

- `engram` queda activo por defecto porque es parte del flujo de memoria.
- `context7`, `azure-devops` y `playwright` quedan registrados pero deshabilitados por defecto desde el release `1.0.21`, para evitar errores de arranque si faltan red, npm/npx, secretos o permisos.
- Azure DevOps usa la organización que configures para tu equipo y dominios acotados (`core`, `work`, `work-items`, `repositories`, `wiki`, `pipelines`) cuando se habilita.

Para habilitar MCPs opcionales durante la instalación:

```bash
GGS_ENABLE_OPTIONAL_MCPS=1 bash scripts/install.sh
```

Modelo por defecto en OpenCode:
- Si Codex está instalado, nuevas instalaciones usan el perfil SDD de Codex (`openai/gpt-5.5`) y crean `Codex-Ale.json`.
- También se crea `Codex-Ale SDD Profile.json` para que el perfil aparezca como opción personalizable.
- Si Codex no está instalado, o si existe un modelo propio ya configurado, OpenCode conserva su modelo existente o su default.
- Los agentes visibles (`Orquestador`, `Planificador`, `Revisor`) no fuerzan modelo propio; usan el modelo/perfil activo de OpenCode para evitar mostrar dos modelos distintos.
- Para forzar otro modelo: definí `GGS_OPENCODE_DEFAULT_MODEL` antes de instalar.

Perfiles SDD estándar:

| Perfil | Cuándo usarlo | Modelos principales |
|---|---|---|
| `Full Codex` | Desarrollo real, bugs complejos, deploy, PR y revisión fuerte | `openai/gpt-5.5`, `openai/gpt-5.3-codex`, `openai/gpt-5.4-mini` |
| `Enterprise Safe` | Datos sensibles, finanzas, clientes, RRHH o contexto interno con key enterprise | `google/gemini-3.5-flash` para contexto/análisis y `openai/gpt-5.5` para fases críticas |
| `Low Cost` | Borradores, documentación, resúmenes y tareas no sensibles | `ggsoluciones-ai/minimax-m2.7` |

Reglas:
- Si hay datos sensibles, no usar `Low Cost`.
- Si hay código crítico, deploy o bug complejo, usar `Full Codex`.
- `Fallback models` puede aparecer como heredado por OpenCode/Gentle. No se usa como control de seguridad/costo; cambiá de perfil explícitamente.

Dentro encontrás:
- `agents/Arquitecto/AGENT.md` — punto de entrada
- `agents/Planificador/AGENT.md` — modo planificación
- `agents/Revisor/AGENT.md` — revisión adversarial
- `skills/` — capacidades GGS activables por contexto
- `templates/` — plantillas reutilizables
- `standards/` — estándares largos referenciados por skills
- `equipo/`, `guilds/`, `reglas/` — legado temporal durante la migración Agentes v2

## Rollback de configuración OpenCode

Si una actualización deja mal la configuración global, restaurá el backup más reciente:

```powershell
$cfg = "$env:USERPROFILE\.config\opencode"
$last = Get-ChildItem "$cfg\backups\opencode.json.*.bak" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Copy-Item $last.FullName "$cfg\opencode.json" -Force
```

Luego reiniciá OpenCode.
