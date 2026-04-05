# Arquitectura de Agentes de IA

Un sistema open source de agentes especializados para equipos de desarrollo. En lugar de darle contexto a una IA cada vez que arrancás una tarea, tenés agentes pre-configurados con roles claros — PM, arquitecto, dev, tester, data engineer, BI — que ya saben cómo trabajar, qué estándares seguir y cuándo escalar.

Funciona en Claude Code, OpenCode y Claude.ai. Compatible con cualquier proyecto, independiente del stack.

**¿Para qué sirve?**
- Estandarizar el código y los flujos de trabajo en todo el equipo
- Reducir el tiempo que se pierde explicándole contexto a la IA en cada sesión
- Bajar costos al usar el agente correcto para cada tarea
- Lograr equipos más consistentes y predecibles, sin importar quién ejecuta la tarea

---

## Contribuir

Este proyecto es colaborativo. Si usás IA en tu equipo de desarrollo, tu experiencia tiene valor acá. Todo aporte es bienvenido: nuevos agentes, mejoras a los existentes, adaptaciones para otros stacks, o simplemente abrir un issue con lo que no funcionó.

La comunidad de desarrolladores que trabaja con IA está construyendo las mejores prácticas en tiempo real. Este repositorio es un intento de documentar eso y ponerlo a disposición de todos.

---

## Árbol completo

```
Arquitectura de Agentes/
│
├── orchestrator/               → Punto de entrada único. Siempre se carga primero.
│
├── equipo/                     → Todos los agentes organizados por área
│   │
│   ├── producto/               → Orquestador del área de Producto
│   │   ├── pm/                 → Backlog, épicas, historias, bugs, prioridad
│   │   ├── analista/           → AC en Gherkin, casos de uso, reglas de negocio
│   │   └── arquitecto/         → Clean Arch, CQRS, ADR, C4, bounded contexts
│   │
│   ├── diseno/                 → Orquestador del área de Diseño
│   │   ├── ux/                 → Flujos de usuario, usabilidad, experiencia
│   │   └── ui/                 → Componentes, design system, consistencia visual
│   │
│   ├── desarrollo/             → Orquestador del área de Desarrollo
│   │   └── dev/                → TDD, ramas por tarea, código limpio, SOLID
│   │
│   ├── testing/                → Orquestador del área de Testing
│   │   ├── unitario/           → TDD, unit tests, lógica aislada
│   │   ├── integracion/        → Múltiples módulos o capas interactuando
│   │   ├── funcional/          → Smoke tests, flujos de negocio end-to-end
│   │   ├── apis/               → Contratos REST/GraphQL, status codes, payloads
│   │   ├── ux/                 → Usabilidad, fricción, experiencia del usuario
│   │   └── ui/                 → Consistencia visual, design system, deuda visual
│   │
│   └── devops/                 → Orquestador del área de DevOps
│       ├── pr/                 → Orquestador de Pull Requests (reglas base)
│       │   ├── github/         → PRs en GitHub (labels, branch protection, gh cli)
│       │   └── bitbucket/      → PRs en Bitbucket (smart commits, tasks, permisos)
│       ├── cicd/               → Orquestador de CI/CD (estructura base de pipeline)
│       │   ├── github-actions/ → Workflows YAML, secrets, environments, artefactos
│       │   └── azure-devops/   → Pipelines YAML, variable groups, approvals
│       └── board/              → Orquestador de tableros (jerarquía y reglas base)
│           ├── jira/           → Jira Cloud: JQL, smart commits, campos por tipo
│           └── azure-boards/   → Azure Boards: jerarquía, AB#, queries, capacity
│
├── reglas/                     → Conocimiento técnico granular inyectable en cualquier agente
│   ├── naming-conventions/     → Variables, funciones, archivos, componentes
│   ├── code-review/            → Cómo dar y recibir feedback en reviews
│   ├── css-arquitectura/       → BEM, tokens, especificidad, sin !important
│   ├── debugging/              → Metodología para investigar bugs
│   ├── documentacion/          → Qué documentar y cómo (JSDoc, README, ADR)
│   ├── error-handling/         → Sin empty catch, logging, feedback al usuario
│   ├── git-avanzado/           → Rebase, cherry-pick, bisect, stash
│   ├── javascript-async/       → Promises, async/await, race conditions
│   ├── onboarding/             → Setup de entorno para nuevos integrantes
│   ├── performance-web/        → Renders innecesarios, bundle size, lazy loading
│   └── seguridad-web/          → XSS, CSRF, secretos, validación de input
│
├── config/                     → Configuración por proyecto (sin credenciales reales)
│   ├── base.config.md          → Defaults globales: herramientas, convenciones, variables de entorno
│   └── proyectos/
│       └── ejemplo.config.md   → Template para configurar un proyecto concreto
│
└── templates/                  → Plantillas para crear nuevos agentes
    ├── nuevo-agente/           → Template base para un agente nuevo
    └── modificar-agente/       → Guía para actualizar un agente existente
```

---

## Flujo SDLC end-to-end

```
equipo/producto/pm
  └── equipo/producto/analista
        └── equipo/producto/arquitecto
              └── equipo/diseno
                    └── equipo/desarrollo/dev
                          └── equipo/testing
                                └── equipo/devops/pr
                                      └── merge → main
                                            └── equipo/devops/cicd (deploy)
```

---

## Cómo usar este sistema

### Paso 1 — Configurar el proyecto

Copiar `config/proyectos/ejemplo.config.md` → `config/proyectos/{mi-proyecto}.config.md` y completar:
- Nombre del repo
- Herramienta de board (Jira / Azure Boards)
- Herramienta de VCS (GitHub / Bitbucket)
- Herramienta de CI/CD (GitHub Actions / Azure DevOps)
- Ambientes (local, staging, prod)

Las credenciales van en variables de entorno — **nunca en este archivo**.

### Paso 2 — Adaptar los agentes

Cada `AGENT.md` tiene una sección `adapt:` en el frontmatter que indica qué placeholders reemplazar. Antes de usar cualquier agente en un proyecto real, reemplazar `{PROYECTO}`, `{REPO}`, etc. con los valores reales.

---

## Uso en Claude (claude.ai)

Claude.ai tiene la funcionalidad de **Proyectos** que permite mantener archivos de instrucciones persistentes. Es la forma más directa de usar este sistema.

### Paso a paso

**1. Crear un Proyecto en Claude.ai**

Ir a [claude.ai](https://claude.ai) → **Projects** → **New project**.
Nombrar el proyecto igual que el repositorio al que aplica.

**2. Agregar el orchestrator como instrucción del proyecto**

En el panel del proyecto → **Project instructions** → pegar el contenido completo de `orchestrator/AGENT.md`.

Este texto actúa como el contexto base de todas las conversaciones del proyecto. Claude siempre lo tendrá presente.

**3. Agregar archivos de agentes al conocimiento del proyecto**

En **Project knowledge** → **Add content** → subir los archivos `AGENT.md` que corresponden al proyecto. Como mínimo:

```
orchestrator/AGENT.md          ← siempre
equipo/producto/pm/AGENT.md
equipo/producto/analista/AGENT.md
equipo/desarrollo/dev/AGENT.md
equipo/testing/unitario/AGENT.md
equipo/devops/pr/github/AGENT.md    ← o bitbucket según el proyecto
equipo/devops/cicd/github-actions/AGENT.md  ← o azure-devops
equipo/devops/board/jira/AGENT.md   ← o azure-boards
guilds/{stack}/AGENT.md             ← el guild del stack del proyecto
config/proyectos/{mi-proyecto}.config.md
```

No es necesario subir todos. Subir solo los agentes que el proyecto realmente usa.

**4. Iniciar una conversación**

Abrir una nueva conversación dentro del proyecto. El orchestrator ya está activo. Describir la tarea y Claude identificará qué agente aplica:

```
Quiero crear una historia de usuario para el módulo de pagos.
```

Claude responderá desde el rol del agente `equipo/producto/pm` automáticamente.

**5. Activar un agente específico cuando sea necesario**

Si querés invocar un agente concreto de forma explícita:

```
Actúa como el agente equipo/desarrollo/dev y el guild guilds/backend-dotnet.
Tengo el ticket PROJ-42 con los siguientes AC: [...]
```

**6. Inyectar reglas adicionales en la conversación**

Las reglas no están en el conocimiento del proyecto por defecto — se inyectan en el momento que son relevantes. Simplemente pegá el contenido del archivo en el chat:

```
[contenido de reglas/error-handling/AGENT.md]

Con estas reglas en mente, revisá el siguiente código: [...]
```

---

## Uso en Claude Code (terminal)

[Claude Code](https://claude.ai/code) es el cliente de consola oficial de Anthropic. Se ejecuta en la terminal dentro del directorio del proyecto y lee instrucciones desde archivos `CLAUDE.md` automáticamente.

### Cómo funciona la carga de instrucciones

Claude Code tiene tres niveles de instrucciones que se cargan en este orden:

| Nivel | Archivo | Cuándo aplica |
|-------|---------|---------------|
| Global | `~/.claude/CLAUDE.md` | Siempre, en cualquier proyecto |
| Proyecto | `./CLAUDE.md` (raíz del repo) | Al abrir ese directorio |
| Subdirectorio | `./src/CLAUDE.md` (opcional) | Al trabajar en esa carpeta |

### Paso a paso

**1. Instalar Claude Code**

```bash
npm install -g @anthropic-ai/claude-code
```

O descargar desde [claude.ai/code](https://claude.ai/code).

**2. Crear el `CLAUDE.md` del proyecto**

En la raíz del repositorio, crear `CLAUDE.md` con las instrucciones del orchestrator y la config del proyecto. Este archivo se carga automáticamente en cada sesión:

```markdown
# Agentes del proyecto

@{ruta-absoluta-a-este-repo}/orchestrator/AGENT.md
@{ruta-absoluta-a-este-repo}/config/proyectos/{mi-proyecto}.config.md
```

Claude Code soporta la directiva `@ruta` para importar el contenido de otros archivos en el `CLAUDE.md`. Usarla para mantener el archivo liviano en lugar de copiar el contenido.

Si el repositorio de agentes está en la misma máquina que el proyecto, las rutas absolutas funcionan directamente. Si preferís copiar el contenido, pegarlo directamente en el `CLAUDE.md`.

**3. Abrir Claude Code en el proyecto**

```bash
cd /ruta/al/proyecto
claude
```

Claude Code carga el `CLAUDE.md` automáticamente. El orchestrator queda activo desde el primer mensaje.

**4. Incluir agentes adicionales en la sesión con `@`**

Dentro de la conversación de Claude Code, usar `@` para incluir el contenido de cualquier archivo en el contexto actual:

```
@/ruta/a/agentes/equipo/desarrollo/dev/AGENT.md
@/ruta/a/agentes/guilds/backend-dotnet/AGENT.md
@src/auth/auth.service.ts

Implementar autenticación JWT según el ticket PROJ-42 con los siguientes AC: [...]
```

Claude Code lee los archivos referenciados y los incorpora al contexto de la conversación.

**5. Cargar reglas en el momento que son relevantes**

Las reglas se inyectan durante la conversación cuando la tarea las requiere:

```
@/ruta/a/agentes/reglas/error-handling/AGENT.md
@/ruta/a/agentes/reglas/seguridad-web/AGENT.md

Revisá este middleware de autenticación: @src/auth/auth.middleware.ts
```

**6. Estructura recomendada del `CLAUDE.md` del proyecto**

```markdown
# {NOMBRE-DEL-PROYECTO}

## Sistema de agentes
@{ruta}/orchestrator/AGENT.md

## Config del proyecto
@{ruta}/config/proyectos/{mi-proyecto}.config.md

## Stack del proyecto
- Backend: .NET 8 / C#
- Frontend: Angular 17
- DB: SQL Server
- Board: Jira
- VCS: GitHub
- CI/CD: GitHub Actions

## Guilds activos
Los siguientes guilds aplican a este proyecto. Cargarlos junto al dev agent:
- `@{ruta}/guilds/backend-dotnet/AGENT.md`
- `@{ruta}/guilds/frontend-angular/AGENT.md`
- `@{ruta}/guilds/data-sqlserver/AGENT.md`
```

---

## Uso en OpenCode (terminal)

[OpenCode](https://opencode.ai) es el cliente de consola de IA para desarrollo creado por SST. Se ejecuta como TUI (terminal UI) dentro del proyecto y carga instrucciones desde un archivo de configuración y desde el directorio `.opencode/`.

### Cómo funciona la carga de instrucciones

OpenCode carga instrucciones en este orden al iniciar:

| Nivel | Archivo | Cuándo aplica |
|-------|---------|---------------|
| Config global | `~/.config/opencode/config.json` | Siempre |
| Config proyecto | `./opencode.json` (raíz del repo) | Al abrir ese directorio |
| Instrucciones | `./.opencode/` (directorio) | Archivos `.md` dentro de esa carpeta |

### Paso a paso

**1. Instalar OpenCode**

```bash
# Con npm
npm install -g opencode-ai

# Con brew (macOS)
brew install sst/tap/opencode
```

Ver documentación actualizada en [opencode.ai/docs](https://opencode.ai/docs).

**2. Inicializar en el repositorio**

```bash
cd /ruta/al/proyecto
opencode
```

Al primer arranque, OpenCode crea `.opencode/` en la raíz del repo.

**3. Crear la instrucción principal del sistema de agentes**

Crear `.opencode/agents.md` con el contenido del orchestrator y la config del proyecto:

```markdown
# Sistema de agentes — {PROYECTO}

Sos un sistema de agentes de software factory. Antes de responder cualquier
tarea, identificá qué agente aplica según el contexto.

---

[pegar contenido de orchestrator/AGENT.md]

---

[pegar contenido de config/proyectos/{mi-proyecto}.config.md]
```

OpenCode carga todos los archivos `.md` del directorio `.opencode/` al iniciar la sesión.

**4. Crear un archivo de instrucciones por área**

Mantener los agentes separados por área facilita el mantenimiento. Actualizar cada archivo cuando cambie el AGENT.md fuente:

```
.opencode/
  agents.md       ← orchestrator + config del proyecto
  producto.md     ← equipo/producto/pm + analista + arquitecto
  desarrollo.md   ← equipo/desarrollo/dev + guild del stack + reglas clave
  testing.md      ← equipo/testing/* concatenados
  devops.md       ← pr + cicd + board de la plataforma del proyecto
  datos.md        ← equipo/datos/* + guilds de datos (si aplica)
```

Ejemplo de `.opencode/desarrollo.md`:

```markdown
[pegar contenido de equipo/desarrollo/dev/AGENT.md]

---

[pegar contenido de guilds/backend-dotnet/AGENT.md]

---

[pegar contenido de reglas/naming-conventions/AGENT.md]

---

[pegar contenido de reglas/error-handling/AGENT.md]
```

**5. Referenciar archivos del proyecto con `@`**

Dentro de la sesión de OpenCode, usar `@` para incluir archivos del repo en el contexto:

```
@src/auth/auth.service.ts @src/auth/auth.controller.ts
Revisá estos archivos con el guild de backend .NET y las reglas de error-handling.
```

**6. Mantener los archivos `.opencode/` sincronizados**

Los archivos en `.opencode/` son copias del contenido de los AGENT.md. Cuando actualices un agente en este repositorio, actualizar el archivo correspondiente en `.opencode/` del proyecto.

Recomendación: agregar `.opencode/` al `.gitignore` si los agentes son sensibles, o commitearlo si el equipo completo debe tener las mismas instrucciones.

```bash
# Commitear las instrucciones del equipo
git add .opencode/
git commit -m "chore: actualizar instrucciones de agentes en opencode"
```

---

## Referencia rápida — qué cargar para cada tarea

| Tarea | Agentes a activar | Reglas a inyectar |
|-------|-------------------|-------------------|
| Crear épica o historia | `equipo/producto/pm` | — |
| Escribir AC | `equipo/producto/analista` | — |
| Diseñar arquitectura | `equipo/producto/arquitecto` | `reglas/documentacion` |
| Diseñar flujo de usuario | `equipo/diseno/ux` | — |
| Diseñar componente UI | `equipo/diseno/ui` | `reglas/css-arquitectura` |
| Implementar feature | `equipo/desarrollo/dev` + guild del stack | `reglas/naming-conventions`, `reglas/error-handling` |
| Escribir tests unitarios | `equipo/testing/unitario` | — |
| Revisar un PR | `reglas/code-review` + `reglas/seguridad-web` | `reglas/performance-web` |
| Configurar pipeline | `equipo/devops/cicd/{herramienta}` | — |
| Gestionar tickets | `equipo/devops/board/{herramienta}` | — |
| Definir KPI | `equipo/datos/analista-datos` + `guilds/datos/kpis-negocio` | — |
| Construir dashboard | `equipo/datos/bi-reporting` + `guilds/datos/powerbi` | — |
| Investigar un bug | `reglas/debugging` | `reglas/error-handling` |

---

## Navegar por área

| Quiero... | Ir a... |
|-----------|---------|
| Crear épicas, historias o bugs | `equipo/producto/` |
| Diseñar una pantalla o flujo | `equipo/diseno/` |
| Implementar una feature | `equipo/desarrollo/` |
| Escribir o revisar tests | `equipo/testing/` |
| Hacer un PR, deploy o gestionar tickets | `equipo/devops/` |
| Trabajar con datos, KPIs o dashboards | `equipo/datos/` |
| Consultar una regla técnica | `reglas/` |

---

## Dos capas de conocimiento

| Capa | Dónde | Para qué |
|------|-------|----------|
| **Agentes de rol** | `equipo/` | Saben QUÉ hacer y CUÁNDO. Orquestan el trabajo. |
| **Reglas técnicas** | `reglas/` | Saben CÓMO hacer algo específico. Se inyectan en los agentes de rol. |

---

## Estado del sistema

| Área | Agentes | Estado |
|------|---------|--------|
| orchestrator | 1 | ✅ Completo |
| equipo/producto | 4 (1 orq + 3 hoja) | ✅ Completo |
| equipo/diseno | 3 (1 orq + 2 hoja) | ✅ Completo |
| equipo/desarrollo | 2 (1 orq + 1 hoja) | ✅ Completo |
| equipo/testing | 7 (1 orq + 6 hoja) | ✅ Completo |
| equipo/devops | 7 (3 orq + 4 hoja) | ✅ Completo |
| equipo/datos | 4 (1 orq + 3 hoja) | ✅ Completo |
| guilds | 10 (1 orq + 9 guild) | ✅ Completo |
| reglas | 11 | ✅ Completo |

---

## Principios irrenunciables del sistema

Transversales a todos los agentes:

1. Sin `!important` en CSS
2. Sin valores hardcodeados — siempre variables/tokens
3. Sin secretos en código — siempre variables de entorno
4. Sin empty catch — siempre loguear y mostrar feedback
5. Sin código comentado — para eso existe git
6. Sin commits directos a main — todo pasa por PR
7. Todo PR vinculado a un ticket
8. Toda decisión arquitectónica tiene su ADR
9. Sin código sin test (TDD)
10. Mobile-first: diseñar para 375px, escalar hacia arriba
11. Sin deploy manual: todo pasa por CI/CD
12. Sin feature sin AC definidos
