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

## Política GGS — Azure Boards

```
Épica
  └── Feature
        └── User Story
              ├── Task
              └── Bug
```

Esta jerarquía es obligatoria para GGSoluciones. No se crean User Stories colgadas directo de una Épica: siempre pasan por una Feature.

| Tipo | Quién lo crea | ¿Se estima? | Cuándo se cierra |
|------|---------------|-------------|------------------|
| Épica | Jefatura IT | No | Cuando todas sus Features están cerradas |
| Feature | Jefatura IT / Analista Funcional | No | Cuando todas sus User Stories están cerradas |
| User Story | Analista Funcional / Jefatura IT | No directamente — suma de Tasks | Tras deploy + sign-off funcional del Analista Funcional |
| Task | Devs / Analista Funcional | Sí — en Story Points | Tras PR mergeado y aprobado |
| Bug | Cualquier miembro | Sí — en Story Points | Tras fix, PR mergeado y validado |

Regla central: **la estimación vive en Tasks y Bugs, no en User Stories, Features ni Épicas**. Una User Story puede mostrar esfuerzo total calculado, pero ese número surge de sumar las Tasks hijas.

## Regla transversal — PR/Merge actualiza tablero

- Todo PR o merge debe actualizar la Task/Bug relacionada con evidencia real.
- Si no existe Task/Bug, crearla antes de abrir o completar el PR.
- Si no se puede inferir el parent correcto para crearla, preguntar al usuario y no inventar jerarquía.
- El work item debe guardar link del PR, branch, commit/merge commit, resumen, checks y estado final.
- Cerrar Task sólo con PR mergeado y validado. Bug queda `Resolved` tras merge y pasa a `Closed` sólo con validación.
- No cerrar User Story por merge: requiere deploy + sign-off funcional.

## Regla transversal — SDD terminado actualiza tablero

- Todo SDD terminado debe reflejarse en el tablero con modelo GGS: Épica → Feature → User Story → Task/Bug.
- Registrar evidencia: change/spec/design/tasks, PRs, commits, build, deploy, verificación y archive.
- Crear o actualizar los work items necesarios para que el tablero represente el alcance real.
- Si no se puede inferir parent correcto, preguntar al usuario antes de crear o mover ítems.
- No declarar el SDD completo hasta que el tablero esté sincronizado o exista una decisión explícita del usuario.

## Contrato de claridad al crear work items

Cada work item debe poder entenderse sin una reunión oral. Si una persona del equipo abre el ticket y no puede responder **qué se quiere lograr, por qué importa, qué entra, qué no entra y cuándo se cierra**, el ticket no está listo.

| Tipo | Información mínima al crear |
|------|-----------------------------|
| Épica | Objetivo de negocio, problema, alcance macro, métricas de éxito, Features esperadas |
| Feature | Capacidad funcional, usuarios impactados, alcance incluido/excluido, User Stories esperadas |
| User Story | Actor, necesidad, beneficio, AC en Gherkin, Feature padre |
| Task | Trabajo concreto, parent User Story, Story Points, alcance, criterio de terminado |
| Bug | Pasos, resultado actual, resultado esperado, severidad, evidencia, vínculo funcional |

Regla: los campos deben escribirse para personas, no para el agente. Nada de títulos crípticos, siglas sin explicar o "ver con X". El tablero es documentación viva.

## Principios irrenunciables

1. **Todo trabajo tiene un ticket antes de arrancar.** Si no hay ticket, no hay rama, no hay código.
2. **Las historias tienen AC en formato Gherkin.** `Dado / Cuando / Entonces`. Mínimo 3 criterios antes de pasar a "En curso".
3. **Los bugs tienen estructura completa:** severidad, pasos para reproducir, comportamiento esperado vs. comportamiento actual. Sin estos datos, el bug no entra al sprint.
4. **El estado del ticket refleja la realidad.** Un ticket en "En progreso" sin actividad por más de 2 días tiene un problema. El estado se actualiza, no se ignora.
5. **Toda rama de código referencia el ID del work item.** Formato: `tipo/AB{ID}-descripcion`. Trazabilidad bidireccional entre código y gestión.
6. **No cerrar hacia arriba por ansiedad.** Una Task cerrada no cierra una User Story; una User Story cerrada no cierra una Feature; una Feature cerrada no cierra una Épica. Cada nivel se cierra solo cuando cumple su condición.

## Formato obligatorio de Task

La Task es la unidad atómica de ejecución. Si la Task está mal escrita, el PR nace mal. No se acepta una Task genérica tipo "hacer frontend" o "ajustar backend".

```markdown
Título: [Verbo en infinitivo + objeto concreto]

Parent: AB#{User Story}
Story Points: {1 | 2 | 3 | 5 | 8}
Tipo: {frontend | backend | api | db | test | devops | docs | análisis}
Área: {Backend | Frontend | Mobile | ERP | BI | Infra | otra}
Iteration: {Sprint / iteración}

Descripción:
  Trabajo concreto a realizar, explicado para que alguien del equipo pueda entenderlo sin contexto oral.

Alcance incluido:
  - {punto incluido}
  - {punto incluido}

Fuera de alcance:
  - {punto explícitamente excluido}

Criterio de terminado:
  - {resultado verificable de la Task}

PR esperado:
  Rama: {tipo}/AB{ID}-{descripcion-corta}
  PR: [AB#{ID}] {descripción breve}
```

### Definition of Ready de Task

- [ ] Tiene parent User Story vinculada.
- [ ] La User Story padre tiene AC en Gherkin.
- [ ] Tiene Story Points definidos.
- [ ] El alcance es atómico y no supera 8 SP.
- [ ] Tiene Area Path e Iteration Path.
- [ ] La descripción permite que un usuario del equipo entienda qué se hará y qué no se hará.

### Definition of Done de Task

- [ ] PR vinculado con `AB#`.
- [ ] Checks automáticos en verde.
- [ ] Review aprobado.
- [ ] PR mergeado.
- [ ] Ticket actualizado con evidencia o nota de validación cuando aplique.
