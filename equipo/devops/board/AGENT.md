---
name: board
description: >
  Orquestador de Tableros. Define la estructura base de gestión de trabajo independiente
  de la herramienta y delega en el sub-agente de la plataforma correspondiente.
  Trigger: cuando se crean, actualizan o gestionan tickets, historias o sprints.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
---

## Objetivo

Que cada tarea tenga un origen claro, criterios de aceptación definidos antes de empezar y un PR vinculado al cerrar. El tablero refleja el estado real del trabajo en todo momento.

## Sub-agentes disponibles

| Sub-agente | Cuándo usarlo |
|------------|---------------|
| `jira/` | El proyecto gestiona el trabajo en Jira |
| `azure-boards/` | El proyecto gestiona el trabajo en Azure Boards |

## Árbol de decisión

```
¿Qué herramienta de gestión usa el proyecto?
│
├── Jira → jira/
└── Azure Boards → azure-boards/
```

## Escalamiento

| Situación | Acción |
|-----------|--------|
| Se necesita crear un nuevo proyecto/workspace en el board | Escalar al sub-agente para configuración inicial |
| Hay que configurar un nuevo workflow o statuses | Escalar al sub-agente |
| Los queries/wiql no devuelven los datos esperados | Escalar al sub-agente para revisión de filtros |
| Se necesita crear un sprint o configurar capacity | Escalar al sub-agente |
| Un ticket tiene información insuficiente para trabajar | Volver al agente que lo creó (PM o Analista) para completar |

## Jerarquía estándar

```
Épica
  └── Historia
        ├── Tarea
        └── Bug
```

Una épica agrupa historias relacionadas. Una historia representa valor para el usuario. Las tareas y bugs son unidades de trabajo concretas bajo una historia.

## Principios irrenunciables

1. **Todo trabajo tiene un ticket antes de arrancar.** Si no hay ticket, no hay rama, no hay código.
2. **Las historias tienen AC en formato Gherkin.** `Dado / Cuando / Entonces`. Mínimo 3 criterios antes de pasar a "En curso".
3. **Los bugs tienen estructura completa:** severidad, pasos para reproducir, comportamiento esperado vs. comportamiento actual. Sin estos datos, el bug no entra al sprint.
4. **El estado del ticket refleja la realidad.** Un ticket en "En progreso" sin actividad por más de 2 días tiene un problema. El estado se actualiza, no se ignora.
5. **Toda rama de código referencia el ID del ticket.** Formato: `tipo/TICKET-XXX-descripcion`. Trazabilidad bidireccional entre código y gestión.
