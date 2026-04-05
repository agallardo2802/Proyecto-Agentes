---
name: board-azure-boards
description: >
  Agente Azure Boards. Hereda las reglas base de board/AGENT.md y agrega
  las convenciones específicas de Azure Boards.
  Trigger: cuando se crean, actualizan o gestionan work items en Azure Boards.
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

Este agente hereda todas las reglas de `equipo/devops/board/AGENT.md`. Los principios irrenunciables (ticket antes de código, AC en Gherkin, bugs con estructura completa) aplican sin excepción. Este archivo define cómo implementarlos en Azure Boards.

## Jerarquía Azure vs Jira

Azure Boards tiene un nivel extra entre Epic y User Story: el **Feature**. Esto cambia cómo se planifica el trabajo.

| Nivel | Azure Boards | Jira | Notas |
|-------|-------------|------|-------|
| 1 | Epic | Epic | Objetivo estratégico. Sin Story Points. |
| 2 | Feature | — (no existe) | Funcionalidad de producto. Agrupa User Stories. |
| 3 | User Story (PBI) | Story | Unidad de valor para el usuario. Tiene AC y Story Points. |
| 3 | Bug | Bug | Defecto. Mismo nivel que User Story en el backlog. |
| 4 | Task | Task / Sub-task | Unidad de trabajo técnico. Estimación en horas. |

Implicaciones prácticas:
- En Jira pondrías Epics grandes. En Azure, esos Epics se dividen en Features primero.
- Un Epic puede tener múltiples Features. Una Feature puede tener múltiples User Stories.
- Los sprints se planifican a nivel User Story, no Feature ni Epic.

## Estados por tipo de work item

### User Story (Product Backlog Item)

```
New → Active → Resolved → Closed
```

| Estado | Significado |
|--------|-------------|
| New | Creada, en backlog, no asignada a sprint |
| Active | En el sprint actual, en progreso |
| Resolved | Implementada y en review / QA |
| Closed | Verificada y mergeada |

### Bug

```
New → Active → Resolved → Verified → Closed
```

| Estado | Significado |
|--------|-------------|
| New | Reportado, pendiente de triage |
| Active | Asignado y en corrección |
| Resolved | Fix implementado, pendiente verificación |
| Verified | QA confirmó que el fix funciona |
| Closed | Mergeado y en producción |

Nota: Azure Boards usa el estado `Verified` para bugs, que no existe en User Stories. No saltear este estado: es la confirmación explícita de QA.

## Campos obligatorios por tipo

| Campo | User Story | Bug | Task |
|-------|-----------|-----|------|
| Title | ✅ | ✅ | ✅ |
| Description | ✅ | ✅ | ✅ |
| Feature (parent) | ✅ | ✅ | ✅ |
| Area Path | ✅ | ✅ | ✅ |
| Iteration Path (Sprint) | ✅ | ✅ | ✅ |
| Acceptance Criteria | ✅ (Gherkin) | — | — |
| Story Points | ✅ | — | — |
| Priority | ✅ | ✅ | ✅ |
| Severity | — | ✅ | — |
| Repro Steps | — | ✅ | — |
| System Info (ambiente) | — | ✅ | — |
| Original Estimate (horas) | — | — | ✅ |

## Area paths e Iteration paths

### Area paths

Representan la estructura del equipo o del sistema. Configurar en **Project settings → Project configuration → Areas**.

```
{PROYECTO}
  ├── Backend
  │     ├── Auth
  │     └── Payments
  ├── Frontend
  └── Infraestructura
```

Regla: cada work item tiene un Area Path. No dejar en la raíz del proyecto. El Area Path define quién es responsable del área.

### Iteration paths (Sprints)

Configurar en **Project settings → Project configuration → Iterations**.

Naming convention: `{PROYECTO}\Sprint {numero} — {fecha-inicio}`

Ejemplo: `MiProyecto\Sprint 24 — 2026-04-07`

- Crear los sprints del trimestre completo al inicio del trimestre.
- La duración estándar es 2 semanas.
- No renombrar sprints pasados.

## AB# notation

Linkea un work item de Azure Boards con commits y PRs desde cualquier repositorio conectado (GitHub o Azure Repos).

### Desde un commit

```bash
git commit -m "feat: implementar login con OAuth AB#1234"
git commit -m "fix: corregir timeout en auth service AB#1234 AB#1235"
```

### Desde un PR (en la descripción o título)

```
Closes AB#1234
Fixes AB#1234
```

### Resultado

- El work item aparece en el PR con el link de trazabilidad.
- El PR aparece en el work item en la tab "Development".
- Si se usa `Closes` o `Fixes`, el work item pasa a estado `Resolved` automáticamente al mergear.

### Requisito previo

El repositorio debe estar conectado al proyecto de Azure Boards en **Project settings → GitHub connections** (para repos de GitHub) o automático para Azure Repos.

## Queries útiles

Equivalente a JQL de Jira. Guardar en **Boards → Queries → My Queries** o **Shared Queries**.

```
-- Mis items activos en el sprint actual
[System.TeamProject] = @project
AND [System.AssignedTo] = @me
AND [System.State] = Active
AND [System.IterationPath] = @currentIteration

-- Bugs activos sin asignar
[System.TeamProject] = @project
AND [System.WorkItemType] = Bug
AND [System.State] IN (New, Active)
AND [System.AssignedTo] = ''

-- User Stories sin AC en el sprint actual
[System.TeamProject] = @project
AND [System.WorkItemType] = User Story
AND [System.IterationPath] = @currentIteration
AND [Microsoft.VSTS.Common.AcceptanceCriteria] = ''

-- Todo el sprint actual por estado
[System.TeamProject] = @project
AND [System.IterationPath] = @currentIteration
AND [System.WorkItemType] IN (User Story, Bug, Task)
ORDER BY [System.State] ASC

-- Items bloqueados (con tag "blocked")
[System.TeamProject] = @project
AND [System.Tags] CONTAINS 'blocked'
AND [System.State] NOT IN (Closed, Resolved)
```

## Capacity planning por sprint

En **Boards → Sprints → Capacity**, configurar:
- Horas por día por persona
- Días libres del sprint (feriados, vacaciones)

Regla: completar la capacidad antes de planificar el sprint. Si la suma de estimaciones de Tasks supera la capacidad del equipo, sacar items del sprint antes de arrancar, no durante.

Flujo:
1. PO y SM estiman las User Stories en Story Points en el backlog.
2. Al planificar el sprint, el equipo descompone Stories en Tasks con estimación en horas.
3. La suma de horas de Tasks no debe superar el capacity disponible.
4. Si supera: negociar scope con el PO antes de confirmar el sprint, no después.
