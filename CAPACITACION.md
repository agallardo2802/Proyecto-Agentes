# Capacitación - GGS Agentes

## Objetivo
Entender qué problema resuelve GGS Agentes, cómo instalarlo y cómo usarlo correctamente en un equipo de desarrollo.

## Requisitos previos

| Herramienta | Versión mínima | Notas |
|-------------|----------------|-------|
| Git | 2.40+ | Necesario para clonar o versionar cambios |
| PowerShell | 5.1+ | Requerido en Windows para el instalador |
| Bash | 4+ | Requerido en Linux/macOS para el instalador |
| OpenCode, Claude Code, Cursor o Windsurf | Última estable | Elegí la plataforma donde vas a usar los agentes |
| Go | 1.22+ | Opcional, solo si querés compilar la TUI |

## Paso a paso

### 1. Entender qué es GGS Agentes

GGS Agentes es un sistema de agentes especializados para trabajar con IA en proyectos de software sin repetir contexto en cada tarea.

En vez de pedirle todo a un único asistente genérico, usás roles concretos:

- `orchestrator/` coordina el trabajo.
- `equipo/` contiene agentes por área: producto, diseño, desarrollo, testing, datos y DevOps.
- `guilds/` contiene estándares técnicos por stack.
- `reglas/` contiene reglas transversales reutilizables.
- `agents/` contiene accesos directos para plataformas como OpenCode.

### 2. Entender el flujo de trabajo

El flujo recomendado es SDD: Spec-Driven Development.

```text
explore -> propose -> spec -> design -> tasks -> apply -> verify -> archive
```

La idea es simple: primero se entiende el problema, después se diseña, y recién al final se implementa. Esto evita el clásico error de pedir código antes de tener claro el alcance.

### 3. Instalar con el instalador automático

En Windows:

```powershell
irm https://raw.githubusercontent.com/agallardo2802/Proyecto-Agentes/main/scripts/install.ps1 | iex
```

En Linux/macOS:

```bash
curl -fsSL https://raw.githubusercontent.com/agallardo2802/Proyecto-Agentes/main/scripts/install.sh | bash
```

El instalador detecta herramientas disponibles, permite elegir la plataforma objetivo e intenta registrar los agentes necesarios. En OpenCode, el registro automático requiere que exista `~/.config/opencode/opencode.json`; si no existe, primero inicializá OpenCode y después ejecutá nuevamente el instalador.

### 4. Instalar manualmente si hace falta

Para OpenCode:

```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes.git ~/.config/opencode/skills/ggs
```

Para Claude Code:

```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes.git ~/.claude/skills/ggs
```

### 5. Verificar la instalación

Después de instalar:

1. Abrí la plataforma elegida.
2. Confirmá que aparezcan los agentes `Sdd-GGS-*`.
3. Si usás OpenCode y no aparecen, verificá que exista `~/.config/opencode/opencode.json` y reejecutá el instalador.
4. Probá una primera tarea de solo análisis antes de pedir implementación.

### 6. Elegir el modo correcto

Después de instalar, elegí el agente según el tipo de trabajo:

| Modo | Cuándo usarlo |
|------|---------------|
| `Sdd-GGS-Orchestrator` | Cuando querés el flujo completo guiado |
| `Sdd-GGS-Plan` | Cuando solo querés análisis, specs o diseño |
| `Sdd-GGS-Skills` | Cuando querés controlar manualmente cada fase |
| `Sdd-GGS-Judgment` | Cuando necesitás revisión adversarial |

### 7. Hacer la primera prueba

Usá una tarea chica y concreta:

```text
Necesito revisar cómo está armado el login y proponer mejoras sin tocar código.
```

Si querés implementar, pedí el flujo completo:

```text
Usá SDD para agregar validación de contraseña en login.
```

### 8. Leer la estructura antes de modificar

Antes de crear o cambiar agentes, revisá:

- `README.md` para entender el proyecto completo.
- `INSTALL.md` para instalación rápida.
- `CONTRIBUTING.md` para reglas de contribución.
- `templates/` para crear o modificar agentes con estructura consistente.
- `.atl/skill-registry.md` para ver el índice de skills y reglas disponibles.

### 9. Contribuir correctamente

Para contribuir:

1. Abrí un issue explicando qué querés cambiar.
2. Creá una rama descriptiva.
3. Usá commits convencionales.
4. Actualizá documentación si cambia el uso, instalación o flujo.
5. Abrí un PR contra `main`.

## Errores frecuentes

| Problema | Cómo resolverlo |
|----------|-----------------|
| No aparecen los agentes en el dropdown | Reejecutá el instalador y verificá la plataforma seleccionada |
| Hay agentes duplicados | Usá el instalador automático; limpia duplicados de instalaciones anteriores |
| No sabés qué modo usar | Empezá con `Sdd-GGS-Orchestrator` |
| El agente implementa demasiado pronto | Pedí explícitamente `solo analizar` o usá `Sdd-GGS-Plan` |
| El equipo no entiende el repo | Seguí esta capacitación antes de contribuir |

## Checklist de capacitación

- [ ] Entendí qué problema resuelve GGS Agentes.
- [ ] Sé diferenciar agentes, guilds y reglas.
- [ ] Sé instalarlo en mi plataforma.
- [ ] Sé elegir entre Orchestrator, Plan, Skills y Judgment.
- [ ] Sé ejecutar una primera tarea de prueba.
- [ ] Sé dónde mirar antes de contribuir.
- [ ] Leí las reglas de contribución.

## Notas adicionales

No saltees la etapa de entendimiento. Estos agentes no reemplazan el criterio técnico: lo ordenan. Si el equipo no entiende el flujo, la IA va a acelerar el desorden. Primero fundamentos, después automatización.
