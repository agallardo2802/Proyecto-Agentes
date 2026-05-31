# GGS - GGSoluciones

```text
██████████              ██████████
  ████████████████        ████████████████
 █████        █████      █████        █████
 ████                    ████
 ████                    ████
 ████       ████████     ████       ████████
 ████       ████████     ████       ████████
 ████         █████      ████         █████
  ████████████████        ████████████████
    ██████████              ██████████
   S  O  L  U  C  I  O  N  E  S
```

Un sistema open source de agentes especializados para equipos de desarrollo. En lugar de darle contexto a una IA cada vez que arrancás una tarea, tenés agentes pre-configurados con roles claros — PM, arquitecto, dev, tester, data engineer, BI — que ya saben cómo trabajar, qué estándares seguir y cuándo escalar.

Funciona en OpenCode, Claude Code, Codex, Antigravity y Gentle.ai. Compatible con cualquier proyecto, independiente del stack.

## Dirección Agentes v2

`ggs_agentes_base` evoluciona como **distribución pública GGS sobre Gentle AI/OpenCode**, no como fork del core.

- **Gentle AI/OpenCode** aporta el motor: SDD, subagentes, memoria, permisos, comandos y tooling.
- **GGS GGSoluciones** aporta la capa de empresa: skills, templates, estándares, branding, configuración e instalador.
- Los cambios externos se incorporan por curación: si son universales se adoptan en la base; si son específicos de GGSoluciones se adaptan como skill/template/config.

Ver propuesta: [`docs/architecture/agentes-v2-proposal.md`](docs/architecture/agentes-v2-proposal.md).

## Metodología de referencia

Los agentes de este repo **implementan** la metodología del área. La documentación transversal (metodología GGS, Azure Boards, glosario de campos, stack 2026) vive en el repo raíz del área:

- **Metodología GGS IT** → documentación de referencia adaptable a cada equipo.
- **Arquitectura Tecnológica 2026** → lineamientos de arquitectura adaptables al stack del proyecto.

Cuando cambia la metodología, se revisan los agentes de este repo para mantener consistencia.

**¿Para qué sirve?**
- Estandarizar el código y los flujos de trabajo en todo el equipo
- Reducir el tiempo que se pierde explicándole contexto a la IA en cada sesión
- Bajar costos al usar el agente correcto para cada tarea
- Lograr equipos más consistentes y predecibles, sin importar quién ejecuta la tarea

**¿Sos nuevo en el proyecto?** Empezá por la [Capacitación - GGS Agentes](CAPACITACION.md).

---

## ¿Por qué usar SDD, TDD y OpenSpec?

### SDD (Spec-Driven Development)

SDD es un flujo estructurado para desarrollo sustancial. En lugar de decir "escribí código", el agente:

| Beneficio | Descripción |
|-----------|-------------|
| **Menor scope** | Primero se explora, propone, diseña |
| **Specs como fuente de verdad** | Todo código se verifica contra specs |
| **No más rework** | Se Valida el diseño antes de implementar |
| **Trail auditable** | Cada decisión queda documentada |

```
Sin SDD: "escribí auth"          → 5 horas de trabajo + rework
Con SDD: explore → propose → spec → design → apply → 1 hora + correcto
```

**Cuándo usar SDD**: Features, refactors, bugs complejos.

---

### TDD (Test-Driven Development)

TDD asegura que cada línea de código tenga un test. El flujo RED-GREEN-REFACTOR:

| Fase | Qué hacés |
|------|-----------|
| **RED** | Escribís un test que falla |
| **GREEN** | Mínimo código para que pase |
| **REFACTOR** | Mejorás sin romper tests |

| Beneficio | Descripción |
|-----------|-------------|
| **Tests desde el día 1** | No hay código sin test |
| **Coverage garantizado** | Cada feature tiene tests |
| **Refactor seguro** | Si rompe, lo sabés inmediatamente |
| **Documentación viva** | Tests = documentación ejecutable |

```
Con TDD: implementás mirando el test fallar → pasarlo → refactor
Sin TDD: escribís código → después test → "me olvidé"
```

**Cuándo usar TDD**: Lógica de negocio, APIs, utilities.

---

### OpenSpec (Persistencia)

OpenSpec guarda todo el proceso en archivos. Elegí el modo según tu necesidad:

| Modo | Cuándo usarlo | Pros | Contras |
|-----|--------------|------|---------|
| **engram** | Desarrollo solo | Rápido, sin archivos | No compartible |
| **openspec** | Equipo | Trail completo, git-friendly | Más archivos |
| **hybrid** | Ambos | Compartible + recovery | Costo en tokens |
| **none** | Solo prueba | Ligero | Se pierde todo |

| Beneficio openspec | Descripción |
|-------------------|-------------|
| **Git-friendly** | Todo en `openspec/` → versionable |
| **Audit trail** | Cada cambio tiene specs, design, tasks |
| **Compartir** | Clonás y otro tiene el contexto |
| **Post-mortem** | Revisás qué se decidió y por qué |

```
openspec/
├── config.yaml
├── specs/
│   └── auth-spec.md
├── changes/
│   └── feature-login/
│       ├── proposal.md
│       ├── spec.md
│       ├── design.md
│       ├── tasks.md
│       └── archive.md
```

---

## 🚀 Instalación Rápida (recomendado)

### Instalación desde GitHub público

Esta distribución se instala desde el repositorio público `https://github.com/agallardo2802/Proyecto-Agentes`. Si estás desarrollando localmente, también podés definir `GGS_AGENTS_SOURCE_DIR` para instalar desde tu clon.

```powershell
# Windows PowerShell
irm https://raw.githubusercontent.com/agallardo2802/Proyecto-Agentes/main/scripts/install.ps1 | iex
```

```bash
# Linux / macOS
curl -fsSL https://raw.githubusercontent.com/agallardo2802/Proyecto-Agentes/main/scripts/install.sh | bash
```

Esto instala automáticamente:
- Git, Python, Node.js/npm para React, Go, .NET SDK, Docker
- Windows Terminal en Windows; Ghostty en Linux/macOS cuando el package manager lo soporte
- Visual Studio Code y Slack
- OpenCode (cliente AI)
- Gentle AI CLI cuando se usa `-UpdateGentleAI`
- Engram (memoria persistente)
- Agentes GGS completos

> Para usuarios finales, el camino recomendado es instalar desde GitHub. Si querés validar antes, cloná el repo y ejecutá el instalador con `-DryRun` o `--dry-run`.

### Solo herramientas (sin agentes)

```powershell
.\install.ps1 -OnlyPrerequisites
```

### Opciones avanzadas

| Parámetro | Descripción |
|-----------|-------------|
| `-SkipPrerequisites` | No instalar herramientas base |
| `-OnlyPrerequisites` | Solo herramientas, sin agentes |
| `-Agent opencode` | Agent objetivo (opencode, claude, codex, antigravity, cursor, windsurf) |
| `-DryRun` | Mostrar acciones sin clonar, actualizar ni escribir `opencode.json` |
| `-NoConfigureOpenCode` | Instalar/actualizar agentes sin tocar `~/.config/opencode/opencode.json` |
| `-NoInstallClaude` | Con `-Agent opencode`, omite instalar skills GGS en Claude Code |
| `-NoInstallCompanionAgents` | Con `-Agent opencode`, omite instalar skills companion en Claude/Codex/Antigravity |
| `-ConfigureOpenCodeOnly` | Solo refrescar el selector de agentes GGS en OpenCode |
| `-UpdateGentleAI` | Actualizar `gentle-ai` CLI usando el instalador oficial |

> React no se instala globalmente: queda cubierto por Node.js/npm para usar `npm create`, Vite, Next.js o el scaffold que corresponda por proyecto.

### Actualizar instalación existente

Desde el clon instalado:

```powershell
.\scripts\update.ps1
```

Para validar sin aplicar cambios:

```powershell
.\scripts\update.ps1 -DryRun
```

Si querés traer cambios y refrescar el selector de agentes de OpenCode en un solo paso:

```powershell
.\scripts\update.ps1 -ConfigureOpenCode
```

Para actualizar también la CLI de Gentle AI en Windows:

```powershell
.\scripts\update.ps1 -UpdateGentleAI
```

Antes de modificar `~/.config/opencode/opencode.json`, los scripts crean backup en `~/.config/opencode/backups/`. Después reiniciá OpenCode o el cliente AI: la configuración se carga al iniciar y no se hot-reloadea.

Al configurar OpenCode, el instalador también registra comandos de mantenimiento:

```text
/ggs-status   # valida instalación/config sin aplicar cambios
/ggs-update   # actualiza Gentle AI + GGS y refresca OpenCode
```

OpenCode no garantiza hot-reload ni ejecución automática segura de updates al abrir. Por eso el flujo soportado es: abrir OpenCode y correr `/ggs-status`. Ese comando valida en seco y, si detecta actualizaciones o configuración incompleta, le pide confirmación al usuario antes de ejecutar la actualización. `/ggs-update` queda como atajo directo para mantenimiento avanzado.

Cuando se ejecuta con el modo por defecto `-Agent opencode`, el instalador también deja listas las carpetas de Claude Code, Codex y Antigravity en `~/.claude/skills/ggs`, `~/.codex/skills/ggs` y `~/.antigravity/skills/ggs`. Si querés evitar sólo Claude, usá `-NoInstallClaude`; si querés evitar todos los companion agents, usá `-NoInstallCompanionAgents`.

---

## Instalación desde clon local (alternativa)

Usá este camino sólo si querés revisar o modificar el repositorio antes de instalar. Después de clonar, ejecutá el instalador para que registre agentes, comandos, perfiles y companion skills.

```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes /tmp/Proyecto-Agentes
bash /tmp/Proyecto-Agentes/scripts/install.sh opencode
```

---

## Uso

### Tres modos disponibles

Al instalar tenes tres opciones en el dropdown de OpenCode:

| Modo | Nombre | Cuando usarlo |
|------|--------|-------------|
| **Orquestador** | Orquestador | Cuando necesitás el flujo completo. El agente maneja todo. |
| **Planificador** | Planificador | Cuando sólo querés análisis y cargar el tablero. Otro desarrolla. |
| **Revisor** | Revisor | Cuando querés revisión adversarial / "que lo juzgue". |

> **Nota**: Los skills SDD (`sdd-init`, `sdd-explore`, `sdd-spec`, etc.) se cargan automáticamente por contexto. No hay un "Skills mode" separados — son skills individuales, no agentes.

---

#### Orquestador

Todo el flujo. El agente maneja todo de principio a fin.

```
> Elegi "Orquestador"
> Fix el bug de login que no valida la contrasena

El agente:
1. Explora el codigo de login
2. Propone soluciones
3. Escribe la spec
4. Disena la fix
5. Implementa
6. Verifica
7. Todo listo
```

**Cuando**: Una feature completa o fix rapido. El agente hace todo.

---

#### Planificador

Solo analisis y diseno. NO desarrolla. Carga el tablero.

```
> Elegi "Planificador"
> Necesito cargar al tablero la nueva feature de reportes

El agente:
1. Explora el contexto actual
2. Proponemos que es "reportes"
3. Escribe las specs
4. Disena la arquitectura
5. Crea las tareas
6. Carga Epica > Feature > Stories > Tasks en Azure Boards
7. Al terminar el SDD, vuelve a sincronizar el tablero con evidencia real de PR/build/deploy/verificación

> Listo, las tareas estan cargadas. Derivo a Automatic para implementar.
```

**Cuando**: Preparar trabajo para el equipo, cargar tablero, analisis previo sin desarrollar.

---

#### Revisor

Revision adversarial paralela. Dos jueces independientes revisan el mismo objetivo desde angulos distintos y consolidan hallazgos.

```
> Elegi "Revisor"
> Revisa estos cambios antes de mergear

El agente:
1. Lanza dos judges independientes
2. Revisa arquitectura, patrones, edge cases y riesgos
3. Consolida hallazgos
4. Pide/aplica fixes si corresponde
5. Re-juzga hasta PASS o escala con evidencia
```

**Cuando**: Antes de mergear, cuando queres revision adversarial o cuando queres que "lo juzgue".

---

### Ejemplo rapido

| Que necesitas? | Modo / Skill |
|---------------|---------------|
| Todo hecho, de punta a punta | **Automatic** |
| Analisis + cargar tablero | **Plan** |
| Solo explorar algo | `sdd-explore` (skill) |
| Solo escribir specs | `sdd-spec` (skill) |
| Solo verificar | `sdd-verify` (skill) |
| Revision adversarial antes de mergear | **Judgment** |

---

### Uso manual de skills

```
sdd-explore
sdd-spec
sdd-verify
login-web
reportes-ggs
feedback-uat
finanzas-metricas
finanzas-contabilidad
finanzas-cashflow
```

En Agentes v2, las capacidades específicas viven como skills. Los directorios `equipo/`, `guilds/` y `reglas/` quedan como legado temporal mientras se migra el contenido a skills compactas y estándares referenciados.

---

## Getting Started

Este es un proyecto base configurable para cualquier equipo. Clone el repositorio y personalice según su stack.

---

## Contribuir

Este proyecto es colaborativo. Si usás IA en tu equipo de desarrollo, tu experiencia tiene valor acá. Todo aporte es bienvenido: nuevos agentes, mejoras a los existentes, adaptaciones para otros stacks, o simplemente abrir un issue con lo que no funcionó.

La comunidad de desarrolladores que trabaja con IA está construyendo las mejores prácticas en tiempo real. Este repositorio es un intento de documentar eso y ponerlo a disposición de todos.

→ Leé [CONTRIBUTING.md](CONTRIBUTING.md) para ver cómo aportar.

---

## Árbol completo

```
GGS Agentes/
|
├── agents/Arquitecto/ → Punto de entrada único. Siempre se carga primero.
│
├── equipo/                     → Todos los agentes organizados por área
│   │
│   ├── producto/               → Orquestador del área de Producto
│   │   ├── pm/                 → Backlog, épicas, historias, bugs, prioridad
│   │   ├── analista/           → AC en Gherkin, casos de uso, reglas de negocio
│   │   └── arquitecto/         → Clean Arch, CQRS, ADR, GGS, bounded contexts
│   │
│   ├── diseno/                 → Orquestador del área de Diseño
│   │   ├── ux/                 → Flujos de usuario, usabilidad, experiencia
│   │   └── ui/                 → Componentes, design system, consistencia visual
│   │
│   ├── desarrollo/             → Orquestador del área de Desarrollo
│   │   └── dev-ggs/             → TDD, ramas por tarea, código limpio, SOLID
│   │
│   ├── testing/                → Orquestador del área de Testing
│   │   ├── unitario/           → TDD, unit tests, lógica aislada
│   │   ├── integracion/        → Múltiples módulos o capas interactuando
│   │   ├── funcional/          → Smoke tests, flujos de negocio end-to-end
│   │   ├── apis/               → Contratos REST/GraphQL, status codes, payloads
│   │   ├── ux/                 → Usabilidad, fricción, experiencia del usuario
│   │   └── ui/                 → Consistencia visual, design system, deuda visual
│   │
│   ├── devops/                 → Orquestador del área de DevOps
│   │   ├── pr/                 → Orquestador de Pull Requests (reglas base)
│   │   │   ├── github/         → PRs en GitHub (labels, branch protection, gh cli)
│   │   │   └── bitbucket/      → PRs en Bitbucket (smart commits, tasks, permisos)
│   │   ├── cicd/               → Orquestador de CI/CD (estructura base de pipeline)
│   │   │   ├── github-actions/ → Workflows YAML, secrets, environments, artefactos
│   │   │   └── azure-devops/   → Pipelines YAML, variable groups, approvals
│   │   └── board/              → Orquestador de tableros (jerarquía y reglas base)
│   │       ├── jira/           → Jira Cloud: JQL, smart commits, campos por tipo
│   │       └── azure-boards/   → Azure Boards: jerarquía, AB#, queries, capacity
│   │
│   ├── datos/                  → Orquestador del área de Datos
│   │   ├── analista-datos/     → KPIs, métricas, traducción negocio → datos
│   │   ├── bi-reporting/       → Dashboards, Power BI, visualización
│   │   ├── data-engineering/   → ETL, integración de datos, datasets
│   │   └── dba/                → Especialista DB (SQL Server 2022): índices, naming, performance
│   │
│   └── seguridad/              → Orquestador del área de Seguridad / AppSec
│       └── appsec/             → Threat model, OWASP, PR sensible, incident response
│
├── guilds/                     → Estándares por tecnología — se inyectan junto al dev agent
│   ├── backend-dotnet/         → .NET Core LTS (hoy 8), CQRS, MediatR, Clean Arch, RabbitMQ, YARP
│   ├── frontend-react-nextjs/   → React 18, Next.js 14, TanStack Query, Tailwind
│   ├── frontend-angular/       → Lazy loading, Signals, OnPush, sin any
│   ├── mobile-react-native/     → React Native + Expo, shared library
│   ├── messaging-rabbitmq/      → RabbitMQ, async workers, retry, DLQ
│   ├── observabilidad-grafana/ → Grafana, Loki, Prometheus
│   ├── sql-server-2022/        → Normalización, índices, sin SELECT *, queries eficientes
│   ├── integraciones/          → Retry, circuit breaker, correlation ID, timeouts
│   ├── arquitectura/           → Validación transversal, ADR obligatorio, sin deuda silenciosa
│   ├── seguridad/              → OWASP Top 10, auth, crypto, secretos, headers — transversal
│   └── datos/                  → Guilds de datos
│       ├── powerbi/            → Star schema, DAX estándar, performance de reportes
│       ├── modelado-datos/     → Naming conventions, 3NF, migrations versionadas
│       ├── kpis-negocio/       → Catálogo oficial de KPIs, proceso de alta, consistencia
│       └── data-governance/    → System of record, clasificación PII, linaje de datos
│
├── reglas/                     → Conocimiento técnico granular inyectable en cualquier agente
│   ├── yarp-gateway/           → YARP API Gateway, JWT, rate limiting
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
│   ├── seguridad-web/          → XSS, CSRF, secretos, validación de input
│   ├── gherkin/                → Gherkin en español (Dado/Cuando/Entonces)
│   ├── validacion-y-educacion/ → Validar + educar en el proceso
│   ├── openspec/               → OpenSpec, specs en repo, cambios
│   ├── sdd-tdd/                → Guía de SDD y TDD para el equipo
│   ├── deploy-linux-vm/        → Deploy en VM Linux via SSH, rsync, nginx, docker
│   └── diseno-reportes-ggs/ → Estándar visual de reportes GGSoluciones
│
├── config/                     → Configuración por proyecto (sin credenciales reales)
│   ├── base.config.md          → Defaults globales: herramientas, convenciones, variables de entorno
│   └── proyectos/
│       └── ejemplo.config.md   → Template para configurar un proyecto concreto
│
├── templates/                  → Plantillas para crear nuevos agentes
│   ├── nuevo-agente/           → Template base para un agente nuevo
│   └── modificar-agente/        → Guía para actualizar un agente existente
│
└── .atl/
    └── skill-registry.md       → Índice de todos los agentes disponibles
```

---

## Skills SDD Disponibles

| Skill | Trigger | Propósito |
|-------|---------|----------|
| `sdd-ggs` | "sdd", "mi sdd", "sdd completo" | SDD completo con agentes GGS |
| `sdd-init` | `/sdd-init` | Inicializar contexto SDD |

### Fases SDD individuales (cargadas por contexto)

| Skill | Trigger | Propósito |
|-------|---------|----------|
| `sdd-explore` | `/sdd-explore` | Explorar código y contexto |
| `sdd-propose` | `/sdd-propose` | Crear propuesta de cambio |
| `sdd-spec` | `/sdd-spec` | Escribir specs y requisitos |
| `sdd-design` | `/sdd-design` | Diseño técnico y arquitectura |
| `sdd-tasks` | `/sdd-tasks` | Descomponer en tareas |
| `sdd-apply` | `/sdd-apply` | Implementar código |
| `sdd-verify` | `/sdd-verify` | Verificar con tests |
| `sdd-archive` | `/sdd-archive` | Archivar y documentar |

### Skills especializados (GGSoluciones)

| Skill | Trigger | Propósito |
|-------|---------|----------|
| `login-web` | "login", "pantalla de acceso", "autenticación" | Pantalla de login institucional |
| `reportes-ggs` | "reporte", "dashboard", "informe", "métricas" | Estándar de reportes y dashboards |
| `feedback-uat` | "feedback UAT", "dejar feedback", "prueba de usuario" | Captura formal de feedback UAT con persistencia en BD y seguimiento por `#feedback-sites` |
| `finanzas-metricas` | "métricas financieras", "cobranzas", "pagos", "presupuesto vs real" | KPIs financieros con fuente, período, moneda y variaciones |
| `finanzas-contabilidad` | "balance", "asiento contable", "conciliación", "cierre mensual" | Borradores y controles contables trazables para revisión humana |
| `finanzas-cashflow` | "cashflow", "flujo de caja", "tesorería", "vencimientos" | Proyección de caja, escenarios y riesgos de liquidez |
| `web-skeleton` | "nueva web", "nuevo portal", "crear proyecto" | Esqueleto base para nuevos proyectos |
| `guias-desarrollo` | "guía", "setup", "onboarding", "cómo usar" | Guías técnicas paso a paso |
| `manuales-tecnicos` | "manual técnico", "arquitectura", "diseño del sistema" | Documentación técnica profunda |
| `portal-user-manual` | "manual de usuario", "documentar portal" | Manuales para portales internos |

### Perfiles SDD estándar

| Perfil | Uso recomendado |
|---|---|
| `Full Codex` | Desarrollo real, bugs complejos, deploy, PR y revisión fuerte |
| `Enterprise Safe` | Datos sensibles o internos: finanzas, clientes, RRHH, documentación corporativa |
| `Low Cost` | Borradores, resúmenes, documentación no sensible y tareas de bajo riesgo |

Los agentes visibles (`Orquestador`, `Planificador`, `Revisor`) heredan el modelo del perfil activo. Para controlar costo y seguridad, cambiá de perfil explícitamente; no dependas de fallback automático.

---

## Plugins y Extensiones

### Community Plugins (v4.5)

| Plugin | Descripción |
|--------|-------------|
| `sub-agent-statusline` | Muestra actividad de sub-agents en TUI |
| `sdd-engram-plugin` | Gestiona perfiles SDD y navega memorias Engram desde OpenCode |

### MCP Servers (v4.5)

> Integración con herramientas externas via Model Context Protocol.
> Desde el release público `1.0.21`, sólo `engram` queda activo por defecto. Los MCP opcionales se registran pero quedan deshabilitados para no romper el arranque de OpenCode si faltan credenciales, red o paquetes npm.

```yaml
# OpenCode queda configurado por el instalador con estos MCP servers:
mcp:
  context7:
    enabled: false
    type: remote
    url: https://mcp.context7.com/mcp
  engram:
    type: local
    command: [engram, mcp, --tools=agent]
  azure-devops:
    enabled: false
    type: local
    command: [npx, -y, "@azure-devops/mcp", "<azure-devops-org>", -d, core, work, work-items, repositories, wiki, pipelines]
  playwright:
    enabled: false
    type: local
    command: [npx, -y, "@playwright/mcp@latest"]
```

Para habilitar MCPs opcionales durante la instalación:

```bash
GGS_ENABLE_OPTIONAL_MCPS=1 bash scripts/install.sh
```

### Backup & Rollback (v4.5)

```bash
gentle-ai backups list              # Ver backups
gentle-ai backups restore <id>     # Restaurar
gentle-ai backups create           # Backup manual
gentle-ai backups pin <id>         # Proteger del prune
```

---

## Flujo SDLC end-to-end

```
equipo/producto/pm
  └── equipo/producto/analista
        └── equipo/producto/arquitecto
              └── equipo/diseno
                    └── equipo/desarrollo/dev-ggs
                          └── equipo/testing
                                └── equipo/devops/pr
                                      └── merge → master
                                            └── equipo/devops/cicd (deploy)
```

---

## Cómo usar este sistema

### Para proyectos específicos - Uso recomendado

**1. Usar el skill SDD:**
```
> sdd-init
> necesito agregar sistema de cobros
```

**2. O desarrollo directo:**
```
> usar dev para esta tarea
```

Carga el agente dev con los guilds del stack.

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

## Uso en OpenCode / Gentle.ai

## Uso en Claude (claude.ai)

Claude.ai tiene la funcionalidad de **Proyectos** que permite mantener archivos de instrucciones persistentes. Es la forma más directa de usar este sistema.

### Paso a paso

**1. Crear un Proyecto en Claude.ai**

Ir a [claude.ai](https://claude.ai) → **Projects** → **New project**.
Nombrar el proyecto igual que el repositorio al que aplica.

**2. Agregar el orchestrator como instrucción del proyecto**

En el panel del proyecto → **Project instructions** → pegar el contenido completo de `agents/Arquitecto/AGENT.md`.

Este texto actúa como el contexto base de todas las conversaciones del proyecto. Claude siempre lo tendrá presente.

**3. Agregar archivos de agentes al conocimiento del proyecto**

En **Project knowledge** → **Add content** → subir los archivos `AGENT.md` que corresponden al proyecto. Como mínimo:

```
agents/Arquitecto/AGENT.md          ← siempre
equipo/producto/pm/AGENT.md
equipo/producto/analista/AGENT.md
equipo/desarrollo/dev-ggs/AGENT.md
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
Actúa como el agente equipo/desarrollo/dev-ggs y el guild guilds/backend-dotnet.
Tengo el ticket PROJ-42 con los siguientes AC: [...]
```

**6. Inyectar reglas adicionales en la conversación**

Las reglas no están en el conocimiento del proyecto por defecto — se injectan en el momento que son relevantes. Simplemente pegá el contenido del archivo en el chat:

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

@<path-to-ggs-agents>/agents/Arquitecto/AGENT.md
@<path-to-ggs-agents>/config/proyectos/<project-name>.config.md
```

Claude Code soporta la directiva `@ruta` para importar el contenido de otros archivos en el `CLAUDE.md`. Usarla para mantener el archivo liviano en lugar de copiar el contenido.

Si el repositorio de agentes está en la misma máquina que el proyecto, las rutas absolutas funcionan directamente. Si preferís copiar el contenido, pegarlo directamente en el `CLAUDE.md`.

**3. Abrir Claude Code en el proyecto**

```bash
cd my-project
claude
```

Claude Code carga el `CLAUDE.md` automáticamente. El orchestrator queda activo desde el primer mensaje.

**4. Incluir agentes adicionales en la sesión con `@`**

Dentro de la conversación de Claude Code, usar `@` para incluir el contenido de cualquier archivo en el contexto actual:

```
@<path-to-ggs-agents>/equipo/desarrollo/dev-ggs/AGENT.md
@<path-to-ggs-agents>/guilds/backend-dotnet/AGENT.md
@src/auth/auth.service.ts

Implementar autenticación JWT según el ticket PROJ-42 con los siguientes AC: [...]
```

Claude Code lee los archivos referenciados y los incorpora al contexto de la conversación.

**5. Cargar reglas en el momento que son relevantes**

Las reglas se injectan durante la conversación cuando la tarea las requiere:

```
@<path-to-ggs-agents>/reglas/error-handling/AGENT.md
@<path-to-ggs-agents>/reglas/seguridad-web/AGENT.md

Revisá este middleware de autenticación: @src/auth/auth.middleware.ts
```

**6. Estructura recomendada del `CLAUDE.md` del proyecto**

```markdown
# {NOMBRE-DEL-PROYECTO}

## Sistema de agentes
@{ruta}/agents/Arquitecto/AGENT.md

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
- `@{ruta}/guilds/sql-server-2022/AGENT.md`
- `@{ruta}/guilds/seguridad/AGENT.md`      ← siempre, transversal
```

---

## Uso en OpenCode (terminal)

[OpenCode](https://opencode.ai) es el cliente de consola de IA para desarrollo creado por SST. Se ejecuta como TUI (terminal UI) dentro del proyecto y carga instrucciones desde un archivo de configuración y desde el directorio `.opencode/`.

### Cómo funciona la carga de instrucciones

OpenCode carga instrucciones en este orden al iniciar:

| Nivel | Archivo | Cuándo aplica |
|-------|---------|---------------|
| Config global | `~/.config/opencode/opencode.json` | Siempre |
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
cd my-project
opencode
```

Al primer arranque, OpenCode crea `.opencode/` en la raíz del repo.

**3. Crear la instrucción principal del sistema de agentes**

Crear `.opencode/agents.md` con el contenido del orchestrator y la config del proyecto:

```markdown
# Sistema de agentes — <project-name>

Sos un sistema de Arquitectura de Agentes de IA. Antes de responder cualquier
tarea, identificá qué agente aplica según el contexto.

---

[pegar contenido de agents/Arquitecto/AGENT.md]

### Skills SDD

Los skills SDD de Gentle AI/OpenCode están disponibles para controlar fases específicas cuando no querés usar el orquestador completo:

```
# Ejemplo de uso
> Quiero agregar autenticación JWT al portal
> sdd-explore auth
> sdd-spec auth
> sdd-verify auth
```

### Carga legacy durante migración

Estos nombres siguen documentados solo para instalaciones que todavía usan `equipo/`, `guilds/` y `reglas/`. En Agentes v2, el destino es reemplazarlos por skills compactas.

```
@guilds/backend-dotnet
@equipo/desarrollo/dev-ggs
@reglas/code-review

Implementar autenticación JWT según el ticket...
```

---

## Referencia rápida legacy — qué cargar para cada tarea

| Tarea | Agentes a activar | Reglas a inyectar |
|-------|-------------------|-------------------|
| SDD completo | **Orquestador** | — |
| Solo análisis/cargar tablero | **Planificador** | — |
| Revision adversarial | **Revisor** | — |
| Crear épica o historia | `equipo/producto/pm` | — |
| Escribir AC | `equipo/producto/analista` | `reglas/gherkin` |
| Diseñar arquitectura | `equipo/producto/arquitecto` | `reglas/documentacion` |
| Diseño flujo de usuario | `equipo/diseno/ux` | — |
| Diseño componente UI | `equipo/diseno/ui` | `reglas/css-arquitectura` |
| Implementar feature | `equipo/desarrollo/dev-ggs` + guild del stack | `reglas/naming-conventions`, `reglas/error-handling` |
| Escribir tests unitarios | `equipo/testing/unitario` | `reglas/sdd-tdd` |
| Revisar un PR | `reglas/code-review` + `reglas/seguridad-web` | `reglas/performance-web` |
| Configurar pipeline | `equipo/devops/cicd/{herramienta}` | — |
| Gestionar tickets | `equipo/devops/board/{herramienta}` | — |
| Definir KPI | `equipo/datos/analista-datos` + `guilds/datos/kpis-negocio` | — |
| Construir dashboard | `equipo/datos/bi-reporting` + `guilds/datos/powerbi` | `reglas/diseno-reportes-ggs` |
| Investigar un bug | `reglas/debugging` | `reglas/error-handling` |

---

## Estado del sistema

| Área | Agentes | Estado |
|------|---------|--------|
| orchestrator | 1 | ✅ Completo |
| equipo/producto | 4 (1 orq + 3 hoja) | ✅ Completo |
| equipo/diseno | 3 (1 orq + 2 hoja) | ✅ Completo |
| equipo/desarrollo | 2 (1 orq + 1 hoja) | ✅ Completo |
| equipo/testing | 7 (1 orq + 6 hoja) | ✅ Completo |
| equipo/devops | 10 (4 orq + 6 hoja) | ✅ Completo |
| equipo/datos | 4 (1 orq + 3 hoja) | ✅ Completo |
| guilds | 18 | ✅ Completo |
| reglas | 18 | ✅ Actualizado |

---

## Principios irrenunciables del sistema

Transversales a todos los agentes:

### Canónicos (metodología GGS IT)

1. Sin `!important` en CSS
2. Sin valores hardcodeados — siempre variables/tokens
3. Sin secretos en código — siempre variables de entorno
4. Sin empty catch — siempre loguear y mostrar feedback
5. Sin código comentado — para eso existe git
6. Sin commits directos a master — todo pasa por PR
7. Todo PR vinculado a una Task/Bug real; si no existe se crea y si no se sabe dónde colgarla se pregunta
8. Toda decisión arquitectónica tiene su ADR
9. Sin código sin test (TDD)
10. Mobile-first: diseñar para 375px, escalar hacia arriba
11. Sin deploy manual: todo pasa por CI/CD
12. Todo PR o merge actualiza la tarea relacionada con evidencia de PR/build/merge
13. Todo SDD terminado actualiza el tablero con modelo GGS, evidencia y estado real
14. Sin User Story sin AC definidos en Gherkin
15. **sistema externo crítico solo por API propia** — NUNCA acceso directo a la base

### Extensiones GGSoluciones

16. Sin KPI sin definición oficial en el catálogo
17. Sin datos críticos sin system of record definido
18. Todo código pasa por el checklist del guild de su stack antes del PR
19. Sin User Story cerrada sin deploy + sign-off funcional
20. Sin Task/Bug sin Story Points antes de entrar al sprint
21. Sin PR contra User Story genérica: todo PR apunta a una Task o Bug
22. Todo cambio de código hecho por agente deja marca `GGS-TRACE` en archivo modificado
23. Todo README de proyecto incluye `Mapa aplicativo` y relaciones con APIs/eventos/sistemas
24. Sin cambio de BD SQL Server sin DBA + `guilds/sql-server-2022`
25. Sin TO-BE sin AS-IS verificado: inventario aplicativo obligatorio antes de rediseño
26. Carpetas nuevas siempre sin espacios; usar kebab-case o minúsculas
27. Sin PROD con vulnerabilidad crítica/alta sin waiver firmado por AppSec + Arquitecto + PM
28. Todo PR a paths sensibles (auth, crypto, PII, payments) requiere aprobación de AppSec
29. Todo pipeline pasa `secrets-scan`, `sast`, `sca` y `container-scan` antes de deploy-prod
30. Feature con `security-impact: alto` requiere threat model STRIDE antes del ADR

---

## Guía para el equipo

Consultar los agentes en `equipo/` para más detalles.
