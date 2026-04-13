# Arquitectura de Agentes de IA

Un sistema open source de agentes especializados para equipos de desarrollo. En lugar de darle contexto a una IA cada vez que arrancás una tarea, tenés agentes pre-configurados con roles claros — PM, arquitecto, dev, tester, data engineer, BI — que ya saben cómo trabajar, qué estándares seguir y cuándo escalar.

Funciona en Claude Code, OpenCode y Gentle.ai. Compatible con cualquier proyecto, independiente del stack.

**¿Para qué sirve?**
- Estandarizar el código y los flujos de trabajo en todo el equipo
- Reducir el tiempo que se pierde explicándole contexto a la IA en cada sesión
- Bajar costos al usar el agente correcto para cada tarea
- Lograr equipos más consistentes y predecibles, sin importar quién ejecuta la tarea

---

## El Cuatro - Canal 4

Este repositorio incluye una configuración específica para **El Cuatro** con el stack definido en `Stack Tecnológico/Arquitectura Tecnológica 2026.html`.

| Componente | Skill/Guild | Propósito |
|-----------|------------|----------|
| **SDD específico** | `sdd-c4` | Workflow SDD + TDD para El Cuatro |
| **Dev especializado** | `dev-c4` | Dev senior que conoce el stack completo |
| **Guild .NET 8** | `guilds/backend-dotnet-8` | Patrones CQRS, MediatR |
| **Guild React** | `guilds/frontend-react-nextjs` | Patrones React + Next.js |
| **Guild Mobile** | `guilds/mobile-react-native` | Patrones React Native + Expo |
| **Guild RabbitMQ** | `guilds/messaging-rabbitmq` | Colas async |
| **Guild Observabilidad** | `guilds/observabilidad-grafana` | Grafana + Loki |
| **Regla YARP** | `reglas/yarp-gateway` | API Gateway |

### Cómo usar para El Cuatro

```
> sdd-c4
> necesito agregar autenticación JWT al portal
```

El skill `sdd-c4` automáticamente carga los guilds correctos según el tipo de cambio.

---

## Contribuir

Este proyecto es colaborativo. Si usás IA en tu equipo de desarrollo, tu experiencia tiene valor acá. Todo aporte es bienvenido: nuevos agentes, mejoras a los existentes, adaptaciones para otros stacks, o simplemente abrir un issue con lo que no funcionó.

La comunidad de desarrolladores que trabaja con IA está construyendo las mejores prácticas en tiempo real. Este repositorio es un intento de documentar eso y ponerlo a disposición de todos.

→ Leé [CONTRIBUTING.md](CONTRIBUTING.md) para ver cómo aportar.

---

## Árbol completo

```
Arquitectura de Agentes/
|
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
│   │   ├── dev/                → TDD, ramas por tarea, código limpio, SOLID
│   │   └── dev-c4/             → Dev especializado para El Cuatro (stack 2026)
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
│   └── datos/                  → Orquestador del área de Datos
│       ├── analista-datos/     → KPIs, métricas, traducción negocio → datos
│       ├── bi-reporting/       → Dashboards, Power BI, visualización
│       └── data-engineering/   → ETL, integración de datos, datasets
│
├── guilds/                     → Estándares por tecnología — se inyectan junto al dev agent
│   ├── backend-dotnet-8/       → .NET 8 LTS, CQRS, MediatR, Clean Arch
│   ├── backend-dotnet/         → Clean Arch, manejo de errores, logging, async en .NET
│   ├── frontend-react-nextjs/   → React 18, Next.js 14, TanStack Query, Tailwind
│   ├── frontend-angular/       → Lazy loading, Signals, OnPush, sin any
│   ├── mobile-react-native/     → React Native + Expo, shared library
│   ├── messaging-rabbitmq/    → RabbitMQ, async workers, retry, DLQ
│   ├── observabilidad-grafana/ → Grafana, Loki, Prometheus
│   ├── data-sqlserver/         → Normalización, índices, sin SELECT *, queries eficientes
│   ├── integraciones/          → Retry, circuit breaker, correlation ID, timeouts
│   ├── arquitectura/           → Validación transversal, ADR obligatorio, sin deuda silenciosa
│   └── datos/                  → Guilds de datos
│       ├── powerbi/            → Star schema, DAX estándar, performance de reportes
│       ├── modelado-datos/     → Naming conventions, 3NF, migrations versionadas
│       ├── kpis-negocio/       → Catálogo oficial de KPIs, proceso de alta, consistencia
│       └── data-governance/    → System of record, clasificación PII, linaje de datos
│
├── reglas/                     → Conocimiento técnico granular inyectable en cualquier agente
│   ├── yarp-gateway/         → YARP API Gateway, JWT, rate limiting
│   ├── naming-conventions/     → Variables, funciones, archivos, componentes
│   ├── code-review/            → Cómo dar y recibir feedback en reviews
│   ├── css-arquitectura/       → BEM, tokens, especificidad, sin !important
│   ├── debugging/              → Metodología para investigar bugs
│   ├── documentacion/          → Qué documentar y cómo (JSDoc, README, ADR)
│   ├── error-handling/         → Sin empty catch, logging, feedback al usuario
│   ├── git-avanzado/           → Rebase, cherry-pick, bisect, stash
│   ├��─ javascript-async/       → Promises, async/await, race conditions
│   ├── onboarding/             → Setup de entorno para nuevos integrantes
│   ├── performance-web/        → Renders innecesarios, bundle size, lazy loading
│   └── seguridad-web/          → XSS, CSRF, secretos, validación de input
│
├── config/                     → Configuración por proyecto (sin credenciales reales)
│   ├── base.config.md          → Defaults globales: herramientas, convenciones, variables de entorno
│   └── proyectos/
│       └── ejemplo.config.md   → Template para configurar un proyecto concreto
│
├── templates/                  → Plantillas para crear nuevos agentes
│   ├── nuevo-agente/           → Template base para un agente nuevo
│   ├── modificar-agente/       → Guía para actualizar un agente existente
│   └── base_reporte_corporativo/    → Template de reporte con estilo corporativo
│
├── GUIAS/
│   └── EQUIPO/
│       └── Guia-Equipo-El-Cuatro.md → Guía para el equipo de desarrollo
│
└── .atl/
    └── skill-registry.md       → Índice de todos los agentes disponibles
```

---

## Skills SDD Disponibles

| Skill | Trigger | Propósito |
|-------|---------|----------|
| `sdd-c4` | "sdd c4", "sdd el cuatro" | SDD completo para El Cuatro |
| `sdd-elcuatro` | "sdd elcuatro", "mi sdd" | SDD genérico con mis agentes |
| `sdd-init` | `/sdd-init` | Inicializar contexto SDD |

---

## Flujo SDLC end-to-end

```
equipo/producto/pm
  └── equipo/producto/analista
        └── equipo/producto/arquitecto
              └── equipo/diseno
                    └── equipo/desarrollo/dev (o dev-c4 para C4)
                          └── equipo/testing
                                └── equipo/devops/pr
                                      └── merge → main
                                            └── equipo/devops/cicd (deploy)
```

---

## Cómo usar este sistema

### Para El Cuatro - Uso recomendado

**1. Usar el skill `sdd-c4`:**
```
> sdd-c4
> necesito agregar sistema de cobros con Mercado Pago
```

El skill automáticamente:
- Detecta el tipo de cambio → elige los guilds adecuados
- Genera spec con Given/When/Then
- Crea tests primero (TDD)
- Usa CQRS con MediatR para backend
- Configura RabbitMQ para procesos async

**2. O usar desarrollo directo:**
```
> usar dev-c4 para esta tarea
```

Carga el agente especializado con el stack de El Cuatro.

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

### Para El Cuatro - skill sdd-c4

```
# Activation
sdd-c4

# Ejemplo de uso
> Quiero agregar autenticación JWT al portal de ventas
> Usar el cuatro para este desarrollo
```

El skill `sdd-c4` está disponible en:
- `~/.config/opencode/skills/equipo/sdd-c4/`

### Cargar agentes manualmente

```
@guilds/backend-dotnet-8
@equipo/desarrollo/dev-c4
@reglas/code-review

Implementar autenticación JWT según el ticket...
```

---

## Referencia rápida — qué cargar para cada tarea

| Tarea | Agentes a activar | Reglas a inyectar |
|-------|-------------------|-------------------|
| Crear épica o historia | `equipo/producto/pm` | — |
| Escribir AC | `equipo/producto/analista` | — |
| Diseñar arquitectura | `equipo/producto/arquitecto` | `reglas/documentacion` |
| Diseño flujo de usuario | `equipo/diseno/ux` | — |
| Diseño componente UI | `equipo/diseno/ui` | `reglas/css-arquitectura` |
| Implementar (El Cuatro) | `dev-c4` + `guilds/backend-dotnet-8` | `reglas/naming-conventions` |
| Implementar feature | `equipo/desarrollo/dev` + guild del stack | `reglas/naming-conventions`, `reglas/error-handling` |
| Escribir tests unitarios | `equipo/testing/unitario` | — |
| Revisar un PR | `reglas/code-review` + `reglas/seguridad-web` | `reglas/performance-web` |
| Configurar pipeline | `equipo/devops/cicd/{herramienta}` | — |
| Gestionar tickets | `equipo/devops/board/{herramienta}` | — |
| Definir KPI | `equipo/datos/analista-datos` + `guilds/datos/kpis-negocio` | — |
| Construir dashboard | `equipo/datos/bi-reporting` + `guilds/datos/powerbi` | — |
| Investigar un bug | `reglas/debugging` | `reglas/error-handling` |

---

## Estado del sistema

| Área | Agentes | Estado |
|------|---------|--------|
| orchestrator | 1 | ✅ Completo |
| equipo/producto | 4 (1 orq + 3 hoja) | ✅ Completo |
| equipo/diseno | 3 (1 orq + 2 hoja) | ✅ Completo |
| equipo/desarrollo | 2 (1 orq + 1 hoja) | ✅ Completo |
| equipo/desarrollo (C4) | 1 | ✅ Nuevo: dev-c4 |
| equipo/testing | 7 (1 orq + 6 hoja) | ✅ Completo |
| equipo/devops | 10 (4 orq + 6 hoja) | ✅ Completo |
| equipo/datos | 4 (1 orq + 3 hoja) | ✅ Completo |
| guilds | 18 | ✅ Actualizado con stack C4 |
| reglas | 12 | ✅ Actualizado |

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
13. **Para El Cuatro**: NUNCA acceso directo a Calipso — siempre por API propia

---

## Guía para el equipo

Consultar `GUIAS/EQUIPO/Guia-Equipo-El-Cuatro.md` para:
- Instalación de herramientas
- Conexión a VM de desarrollo
- Flujo SDD + TDD
- Agentes por tarea
- Seguridad
- Cómo subir PR

---

## Stack El Cuatro (2026)

Definido en `Stack Tecnológico/Arquitectura Tecnológica 2026.html`

| Capa | Tecnología |
|------|-----------|
| Backend | .NET 8 LTS |
| Frontend | React 18 + Next.js 14 |
| Mobile | React Native + Expo |
| Datos | SQL Server 2022 |
| Mensajería | RabbitMQ |
| API Gateway | YARP |
| Observabilidad | Grafana + Loki |