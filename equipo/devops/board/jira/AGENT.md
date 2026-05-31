---
name: board-jira
description: >
  Agente Jira Cloud. Hereda las reglas base de board/AGENT.md y adapta
  la política GGS cuando un proyecto use Jira en lugar de Azure Boards.
  Trigger: cuando se crean, actualizan o gestionan tickets en Jira Cloud.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "2.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - Configurar la URL base en config/proyectos/{proyecto}.config.md
---

## Herencia

Este agente hereda todas las reglas de `equipo/devops/board/AGENT.md`. Para GGSoluciones la herramienta oficial es Azure Boards; Jira queda como adaptación si un proyecto externo lo requiere. Aun así, la política GGS de estimación y cierre no cambia.

## Jerarquía GGS en Jira

Jira no trae `Feature` de la misma forma que Azure Boards. Si se usa Jira, modelar Feature como issue type propio o como nivel intermedio equivalente.

```
Epic
  └── Feature
        └── Story
              ├── Task
              └── Bug
```

| Tipo | Uso | Estimación |
|------|-----|------------|
| Epic | Objetivo de negocio grande | No |
| Feature | Agrupador funcional | No |
| Story | Valor funcional con AC en Gherkin | No directa — suma Tasks |
| Task | Trabajo concreto | Sí — Story Points |
| Bug | Defecto validable | Sí — Story Points |

## Creación y cierre

| Tipo | Quién lo crea | Cuándo se cierra |
|------|---------------|------------------|
| Epic | Jefatura IT | Cuando todas sus Features están cerradas |
| Feature | Jefatura IT / Analista Funcional | Cuando todas sus Stories están cerradas |
| Story | Analista Funcional / Jefatura IT | Tras deploy + sign-off funcional del Analista Funcional |
| Task | Devs / Analista Funcional | Tras PR mergeado y aprobado |
| Bug | Cualquier miembro | Tras fix, PR mergeado y validado |

## Campos obligatorios por tipo

| Campo | Feature | Story | Bug | Task |
|-------|---------|-------|-----|------|
| Summary | ✅ | ✅ | ✅ | ✅ |
| Description | ✅ | ✅ | ✅ | ✅ |
| Parent / Epic Link | ✅ | ✅ Feature | ✅ Story/Feature | ✅ Story |
| Acceptance Criteria | — | ✅ Gherkin | — | — |
| Story Points | — | — | ✅ | ✅ |
| Sprint | — | ✅ | ✅ | ✅ |
| Priority | ✅ | ✅ | ✅ | ✅ |
| Severity | — | — | ✅ | — |
| Repro Steps | — | — | ✅ | — |
| Ambiente | — | — | ✅ | — |

## Workflow recomendado

```
To Do → In Progress → In Review → Resolved → Done
```

| Estado | Condición |
|--------|-----------|
| To Do | Ítem creado y con parent correcto |
| In Progress | Hay responsable y rama vinculada |
| In Review | PR abierto o validación en curso |
| Resolved | Trabajo implementado; pendiente deploy/sign-off si es Story |
| Done | Cumple la condición de cierre del tipo |

Regla: el merge de un PR puede cerrar una Task, pero no una Story. La Story espera deploy + sign-off funcional del Analista Funcional.

## Severidad de bugs

| Nivel | Descripción | SLA de atención |
|-------|-------------|----------------|
| Critical | Sistema caído o pérdida de datos | Mismo día |
| High | Feature principal bloqueada, sin workaround | 24 horas |
| Medium | Feature degradada, hay workaround | Próximo sprint |
| Low | Cosmético o edge case raro | Backlog |

## Naming conventions

| Elemento | Formato | Ejemplo |
|----------|---------|---------|
| Epic Name | Sustantivo descriptivo corto | `Portal de ventas MVP` |
| Feature Summary | Sustantivo funcional | `Gestión de clientes` |
| Story Summary | `Como {rol} quiero {acción} para {beneficio}` | `Como vendedor quiero registrar clientes para generar contratos` |
| Bug Summary | `[{Severidad}] {Descripción en presente}` | `[High] CUIT inválido se acepta en alta de cliente` |
| Task Summary | Verbo infinitivo + objeto | `Implementar endpoint POST /clientes` |

## JQL de referencia rápida

```jql
-- Tickets del sprint activo
project = {PROYECTO} AND sprint in openSprints()

-- Tasks y Bugs sin Story Points
project = {PROYECTO} AND issuetype in (Task, Bug) AND "Story Points" is EMPTY

-- Stories sin criterios de aceptación
project = {PROYECTO} AND issuetype = Story AND "Acceptance Criteria" is EMPTY

-- Stories listas para sign-off
project = {PROYECTO} AND issuetype = Story AND status = Resolved

-- Bugs críticos o high abiertos
project = {PROYECTO} AND issuetype = Bug AND priority in (Critical, High) AND status != Done

-- Tickets sin parent
project = {PROYECTO} AND parent is EMPTY AND issuetype in (Story, Bug, Task)
```
