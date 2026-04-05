---
name: board-jira
description: >
  Agente Jira Cloud. Hereda las reglas base de board/AGENT.md y agrega
  las convenciones específicas de la plataforma Jira.
  Trigger: cuando se crean, actualizan o gestionan tickets en Jira Cloud.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - Configurar la URL base en config/proyectos/{proyecto}.config.md
---

## Herencia

Este agente hereda todas las reglas de `equipo/devops/board/AGENT.md`. Los principios irrenunciables (ticket antes de código, AC en Gherkin, bugs con estructura completa) aplican sin excepción. Este archivo define cómo implementarlos en Jira Cloud.

## Jerarquía en Jira

```
Epic
  └── Story
        ├── Task
        └── Bug
              └── Sub-task
```

- **Epic**: objetivo de negocio de mediano plazo. No tiene Story Points, tiene una fecha estimada.
- **Story**: unidad de valor para el usuario. Tiene AC, Story Points y Sprint asignado.
- **Task**: trabajo técnico sin valor directo para el usuario (ej: configurar CI, migrar base de datos). Tiene descripción y estimación.
- **Bug**: defecto en producción o QA. Tiene severidad, pasos, ambiente.
- **Sub-task**: división de una Story o Task cuando el trabajo requiere paralelismo entre personas.

## Campos obligatorios por tipo

| Campo | Story | Bug | Task |
|-------|-------|-----|------|
| Summary | ✅ | ✅ | ✅ |
| Descripción | ✅ | ✅ | ✅ |
| Epic Link | ✅ | ✅ | ✅ |
| Criterios de aceptación (AC) | ✅ (Gherkin) | — | — |
| Story Points | ✅ | — | ✅ |
| Sprint | ✅ | ✅ (si es del sprint actual) | ✅ |
| Severidad | — | ✅ | — |
| Pasos para reproducir | — | ✅ | — |
| Comportamiento esperado | — | ✅ | — |
| Comportamiento actual | — | ✅ | — |
| Ambiente donde ocurre | — | ✅ | — |
| Estimación (horas) | — | — | ✅ |

### Severidad de bugs

| Nivel | Descripción | SLA de atención |
|-------|-------------|----------------|
| `Critical` | Sistema caído o pérdida de datos | Mismo día |
| `High` | Feature principal bloqueada, sin workaround | 24 horas |
| `Medium` | Feature degradada, hay workaround | Próximo sprint |
| `Low` | Cosmético o edge case raro | Backlog |

## Workflow recomendado

```
To Do → In Progress → In Review → Done
```

| Estado | Quién lo mueve | Condición |
|--------|---------------|-----------|
| To Do | PO / SM al planificar el sprint | El ticket tiene AC y estimación |
| In Progress | Developer al arrancar | Hay rama creada con el ID del ticket |
| In Review | Developer al abrir el PR | El PR está abierto y los checks pasan |
| Done | Developer / QA al mergear | PR mergeado y ticket verificado |

Regla: el Developer mueve el ticket. El PM no mueve tickets de desarrollo. Si un ticket lleva más de 2 días en el mismo estado sin actividad, hay un problema que resolver, no un estado que ignorar.

## Naming conventions de Jira

| Elemento | Formato | Ejemplo |
|----------|---------|---------|
| Epic Name | Sustantivo descriptivo corto | `Módulo de pagos`, `Autenticación SSO` |
| Story Summary | `Como {rol} quiero {acción} para {beneficio}` | `Como usuario quiero resetear mi contraseña para recuperar el acceso` |
| Bug Summary | `[{Severidad}] {Descripción del problema en presente}` | `[High] El botón de pago no responde en iOS Safari` |
| Task Summary | Verbo infinitivo + objeto | `Configurar pipeline de CI en GitHub Actions` |
| Sprint Name | `Sprint {numero} — {fecha-inicio}` | `Sprint 24 — 2026-04-07` |

## Smart commits desde Git

```bash
# Comentario en el ticket
git commit -m "PROJ-123 #comment Implementado el endpoint POST /auth/login"

# Transición de estado
git commit -m "PROJ-456 #transition In Review PR abierto para revisión"

# Registro de tiempo
git commit -m "PROJ-789 #time 3h #comment Tests unitarios y de integración"
```

Prerequisito: el workspace de Jira debe estar conectado al repositorio (Bitbucket nativo, o vía integración GitHub/GitLab en Jira settings).

## Labels vs Components vs Fix Version

| Campo | Propósito | Ejemplo |
|-------|-----------|---------|
| **Labels** | Tags libres para filtrar o agrupar de forma ad hoc. No hay taxonomía fija. | `performance`, `security`, `tech-debt` |
| **Components** | Áreas del sistema. Taxonomía definida por el proyecto. Asignar responsable. | `Backend`, `Frontend`, `Infraestructura`, `Auth` |
| **Fix Version** | Release en el que se incluirá el ticket. Vincula el ticket al roadmap. | `v1.2.0`, `v2.0.0-beta` |

Regla: Components siempre. Labels cuando el Component no alcanza para categorizar. Fix Version en todo ticket que va a un release planificado.

## Epics

- El Epic Link en Stories y Bugs es obligatorio (campo de la tabla de arriba).
- El Epic Name debe ser descriptivo en sí mismo. "Mejoras" no es un Epic Name; "Módulo de pagos con Stripe" sí lo es.
- Una Epic no pasa a Done hasta que todas sus Stories estén Done.

## JQL de referencia rápida

```jql
-- Tickets del sprint activo
project = {PROYECTO} AND sprint in openSprints()

-- Mis tickets en progreso
project = {PROYECTO} AND assignee = currentUser() AND status = "In Progress"

-- Bugs críticos o high abiertos
project = {PROYECTO} AND issuetype = Bug AND priority in (Critical, High) AND status != Done

-- Historias sin criterios de aceptación (campo customizado)
project = {PROYECTO} AND issuetype = Story AND "Acceptance Criteria" is EMPTY

-- Historias sin story points en el sprint activo
project = {PROYECTO} AND issuetype = Story AND sprint in openSprints() AND "Story Points" is EMPTY

-- Todo lo que va en el próximo release
project = {PROYECTO} AND fixVersion = "v1.2.0" ORDER BY priority DESC

-- Tickets sin Epic asignado
project = {PROYECTO} AND "Epic Link" is EMPTY AND issuetype in (Story, Bug, Task)

-- Tickets sin actividad en los últimos 3 días (posible bloqueo)
project = {PROYECTO} AND updated < -3d AND status = "In Progress"
```
