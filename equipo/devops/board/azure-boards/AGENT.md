---
name: board-azure-boards
description: >
  Agente Azure Boards. Hereda las reglas base de board/AGENT.md y agrega
  las convenciones específicas de Azure Boards para GGSoluciones.
  Trigger: cuando se crean, actualizan o gestionan work items en Azure Boards.
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

Este agente hereda todas las reglas de `equipo/devops/board/AGENT.md`. La política GGS de jerarquía, estimación y cierre aplica sin excepción.

## Jerarquía oficial GGS en Azure Boards

```
Epic
  └── Feature
        └── User Story
              ├── Task
              └── Bug
```

| Nivel | Azure Boards | Uso en GGS | Estimación |
|-------|--------------|-----------|------------|
| 1 | Epic | Objetivo de negocio grande | No |
| 2 | Feature | Agrupador funcional dentro de una Épica | No |
| 3 | User Story | Valor funcional con AC en Gherkin | No directa — suma Tasks |
| 4 | Task | Trabajo concreto de dev, análisis o diseño | Sí — Story Points |
| 4 | Bug | Defecto con pasos, severidad y evidencia | Sí — Story Points |

Reglas:
- Una User Story SIEMPRE cuelga de una Feature.
- Una Task SIEMPRE cuelga de una User Story.
- Un Bug debe vincularse a la User Story o Feature afectada.
- No se estiman Epics, Features ni User Stories directamente.
- Tasks y Bugs se estiman en Story Points con escala común del equipo.

## 5 Épicas Permanentes del tablero

Todo el trabajo del equipo cae dentro de una de estas 5 épicas permanentes. Antes de crear cualquier Feature o User Story, preguntarse: ¿a cuál épica pertenece? Evita que el tablero se llene de épicas sueltas.

| Épica | Contenido | Origen | Quién carga |
|-------|-----------|--------|-------------|
| 🔧 Mantenimiento | Features por sistema (ERP, Tecsur, Web, App Mobile, Reportes). Adentro van ajustes, fixes y deuda técnica de cada sistema. | Equipo técnico al detectar el problema | Devs / Jefatura |
| ⚙️ Tareas Operativas | Licencias, servidores, redes, backups, accesos — trabajo sin código. | Planificado o necesidad interna | Infra / Operaciones |
| 🌐 GLPI · Mesa de Ayuda | Solo lo que escala desde soporte N1 y requiere desarrollo o tiene impacto en producción. Cada ítem lleva el `GLPI#ID` de origen para trazabilidad. | Usuario externo vía GLPI · escalado desde soporte | Soporte N1 al escalar |
| 💡 Iniciativas a Validar | Ideas, pedidos sin AC definidos, investigaciones técnicas, PoCs. Antes de convertirse en Proyecto formal pasan por acá. | Cualquier miembro o área solicitante | Jefatura IT |
| 🚀 Proyectos | Cada proyecto es una Feature dentro de esta épica (Portal de Ventas, API Gateway, Sucursal Virtual 2.0, Aprovisionador, Portal Directorio). Tienen repo propio en Azure DevOps. | Planificación estratégica · priorización de Jefatura | Jefatura crea Features · equipo carga Tasks |

Reglas:
- No se crean épicas sueltas por fuera de estas 5. Si algo no encaja → se discute antes de crear una épica nueva.
- Mantenimiento y Proyectos agrupan por sistema/proyecto a nivel Feature — así la deuda técnica vive junto al sistema que la generó.
- Ítems bajo **GLPI · Mesa de Ayuda** DEBEN tener el `GLPI#ID` en el título o descripción (ver sección AB# / GLPI# notation).

## Creación y cierre por tipo

| Tipo | Quién lo crea | Cuándo se cierra |
|------|---------------|------------------|
| Epic | Jefatura IT | Cuando todas sus Features están cerradas |
| Feature | Jefatura IT / Analista Funcional | Cuando todas sus User Stories están cerradas |
| User Story | Analista Funcional / Jefatura IT | Tras deploy + sign-off funcional del Analista Funcional |
| Task | Devs / Analista Funcional | Tras PR mergeado y aprobado |
| Bug | Cualquier miembro | Tras fix, PR mergeado y validado |

## Regla transversal — sincronización PR/Merge

Cada PR o merge debe dejar Azure Boards actualizado:

- Si hay `AB#`, validar que exista y sea Task/Bug; luego agregar evidencia del PR/merge.
- Si no hay `AB#`, buscar una Task/Bug relacionada por rama, commits, título, descripción y contexto del cambio.
- Si no existe Task/Bug relacionada, crearla.
- Si no se sabe bajo qué Feature/User Story crearla, preguntar al usuario y detener el flujo hasta tener parent claro.
- Guardar en el work item: URL del PR, branch, commit o merge commit, resumen, validaciones, deploy si aplica y estado final.
- Usar HTML renderizable en `System.Description` y `System.History` cuando se escriba por API.

## Regla transversal — SDD terminado actualiza Azure Boards

Al terminar un SDD:

- Validar que exista representación GGS: Epic → Feature → User Story → Task/Bug.
- Actualizar o crear work items faltantes con descripción HTML renderizable.
- Vincular evidencia del SDD: proposal/spec/design/tasks/archive, PRs, commits, build, deploy y verificación.
- Actualizar estados según política: Task/Bug con evidencia; User Story sólo con deploy + sign-off funcional.
- Si falta parent o no se puede inferir la ubicación correcta, preguntar al usuario antes de escribir cambios.

## Estados por tipo

### Epic y Feature

```
New → Active → Resolved → Closed
```

| Estado | Condición |
|--------|-----------|
| New | Creada, priorizada o pendiente de descomposición |
| Active | Tiene hijos en progreso o planificados |
| Resolved | Todos los hijos están cerrados, pendiente revisión de Jefatura IT / Analista Funcional |
| Closed | Cierre confirmado por la condición del nivel |

### User Story

```
New → Active → Resolved → Closed
```

| Estado | Condición |
|--------|-----------|
| New | Tiene Feature padre y AC en Gherkin pendientes o listos para sprint |
| Active | Al menos una Task hija está en progreso |
| Resolved | Todas las Tasks/Bugs hijas están resueltas y el cambio está listo para deploy/sign-off |
| Closed | Deploy exitoso + sign-off funcional del Analista Funcional |

Importante: **mergear PRs no cierra una User Story**. El merge solo habilita pasar a `Resolved` si todas las Tasks/Bugs hijas terminaron. El cierre real requiere deploy y sign-off.

### Task

```
New → Active → (Paused) → Resolved → Closed
```

| Estado | Condición |
|--------|-----------|
| New | Creada, vinculada a User Story y estimada en Story Points |
| Active | Alguien la está trabajando y tiene rama/PR asociado |
| Paused | Bloqueada externamente (espera definición, acceso, decisión o urgencia que interrumpió). **Requiere comentario obligatorio** con motivo, fecha y quién desbloquea. No es para "lo dejo para después" — eso va en New. |
| Resolved | PR aprobado, checks verdes y listo para merge |
| Closed | PR mergeado |

### Bug

```
New → Active → (Paused) → Resolved → Closed
```

| Estado | Condición |
|--------|-----------|
| New | Reportado con severidad, pasos y evidencia |
| Active | Asignado y en corrección |
| Paused | Bloqueado externamente (espera AC del Analista Funcional, acceso, decisión). **Requiere comentario obligatorio** con motivo, fecha y quién desbloquea. |
| Resolved | Fix implementado y PR mergeado |
| Closed | Fix validado por quien reportó, QA o Analista Funcional según impacto |

## Estado Paused · regla transversal

`Paused` aplica a Task, Bug y User Story cuando hay bloqueo externo real. No es "pausa personal" ni "lo retomo después" — para eso está `New`.

Reglas:
- **Comentario obligatorio al mover a Paused** con: motivo concreto, fecha de inicio del bloqueo, quién destraba.
- Si el bloqueo se resuelve → volver a `Active`.
- Si el bloqueo se mantiene >1 sprint → escalar a Jefatura IT / Analista Funcional.
- Items en Paused se revisan en la daily: si nadie destraba, el ítem no debe quedar oculto.

## Campos obligatorios por tipo

| Campo | Epic | Feature | User Story | Task | Bug |
|-------|------|---------|------------|------|-----|
| Title | ✅ | ✅ | ✅ | ✅ | ✅ |
| Description | ✅ | ✅ | ✅ | ✅ | ✅ |
| Parent | — | Epic | Feature | User Story | User Story / Feature |
| Area Path | ✅ | ✅ | ✅ | ✅ | ✅ |
| Iteration Path | — | — | ✅ | ✅ | ✅ |
| Acceptance Criteria | — | — | ✅ Gherkin | — | — |
| Story Points | — | — | — | ✅ | ✅ |
| Priority | ✅ | ✅ | ✅ | ✅ | ✅ |
| Severity | — | — | — | — | ✅ |
| Repro Steps | — | — | — | — | ✅ |
| System Info / Ambiente | — | — | — | — | ✅ |
| Evidencia | — | — | Opcional | Opcional | ✅ |

## Plantillas de creación claras

Estas plantillas definen qué información debe cargarse al crear cada work item. El objetivo no es llenar campos por llenar: es que cualquier integrante pueda leer el item y entender el trabajo sin pedir contexto por chat.

## Regla de renderizado para Azure Boards

Azure Boards **NO es un README**. Si el work item se crea o actualiza por API, `System.Description` y `Microsoft.VSTS.Common.AcceptanceCriteria` se deben persistir en **HTML renderizable**, no en Markdown crudo.

Reglas:
- Usar HTML simple y estable: `<h2>`, `<p>`, `<ul>`, `<li>`, `<strong>`, `<br/>`.
- Usar Markdown solo como guía humana dentro de este documento, **no** como formato final al escribir en Azure Boards.
- Antes de dar por creado un item, releerlo y verificar que no se vea con `##`, listas crudas o texto plano mal renderizado.
- Si el canal de escritura no garantiza render de Markdown, convertir SIEMPRE la plantilla a HTML antes de persistir.

### Epic

```markdown
## Problema de negocio
{Qué problema se quiere resolver y por qué importa}

## Objetivo
{Resultado de negocio esperado}

## Alcance macro
- {frente incluido}
- {frente incluido}

## Fuera de alcance
- {límite explícito}

## Métricas de éxito
- {métrica observable}

## Features esperadas
- {Feature candidata}
```

### Feature

```markdown
## Capacidad funcional
{Qué capacidad habilita esta Feature}

## Usuarios impactados
- {rol / área}

## Alcance incluido
- {funcionalidad incluida}

## Fuera de alcance
- {funcionalidad excluida}

## User Stories esperadas
- {historia candidata}

## Dependencias
- {dependencia funcional, técnica o de datos}
```

### User Story

```markdown
## Historia
Como {rol},
quiero {acción},
para {beneficio}.

## Contexto
{Por que hace falta esta historia}

## Criterios de aceptacion
Ver `reglas/gherkin/AGENT.md` para formato estándar.

## Fuera de alcance
- {lo que no entra en esta User Story}

## Feature padre
AB#{ID}
```

## Plantilla de Task en Azure Boards

Usar esta estructura en la descripción de cada Task. La Task debe poder leerse sin reunión previa; si alguien necesita preguntar "¿qué hay que hacer?", la Task está incompleta.

```markdown
## Objetivo
{Resultado concreto que esta Task debe lograr}

## Contexto
{Por qué existe esta Task y a qué User Story aporta}

## Alcance incluido
- {Cambio incluido}
- {Cambio incluido}

## Fuera de alcance
- {Cambio que NO entra en esta Task}

## Criterio de terminado
- {Condición verificable}
- {Condición verificable}

## Datos de ejecución
- Parent: AB#{User Story}
- Story Points: {1 | 2 | 3 | 5 | 8}
- Tipo: {frontend | backend | api | db | test | devops | docs | análisis}
- Rama esperada: {tipo}/AB{ID}-{descripcion-corta}
- PR esperado: [AB#{ID}] {descripción breve}
```

### Reglas de calidad para Tasks

- No crear Tasks con verbos vagos: "revisar", "ver", "mejorar" sin resultado verificable.
- No mezclar capas si eso impide estimar: separar frontend, backend, db o test cuando corresponda.
- No meter más de 8 SP en una Task. Si supera 8 SP, se parte antes de entrar al sprint.
- No crear una Task sin parent User Story salvo tareas técnicas excepcionales aprobadas por Jefatura IT.

## Plantilla de Bug en Azure Boards

```markdown
## Resumen
{Descripción breve del comportamiento incorrecto}

## Severidad
{Critical | High | Medium | Low}

## Entorno
{producción | staging | local} — versión/build: {x.y.z}

## Pasos para reproducir
1. {paso concreto}
2. {paso concreto}
3. {paso concreto}

## Resultado actual
{Qué ocurre hoy}

## Resultado esperado
{Qué debería ocurrir}

## Impacto
{A quién afecta, qué flujo bloquea, si hay workaround}

## Evidencia
{screenshot, log, traza, video o link}

## Vínculo funcional
User Story / Feature afectada: AB#{ID}

## Story Points
{1 | 2 | 3 | 5 | 8}
```

Regla: un Bug sin pasos, impacto y evidencia no entra al sprint. Puede registrarse como borrador, pero no se trabaja hasta completar esos datos.

## Snippets HTML de referencia

Usar estos snippets como base al persistir por API:

### Heading + párrafo

```html
<h2>Contexto</h2>
<p>{explicación breve}</p>
```

### Lista

```html
<h2>Alcance incluido</h2>
<ul>
  <li>{punto incluido}</li>
  <li>{punto incluido}</li>
</ul>
```

### Historia

```html
<h2>Historia</h2>
<p><strong>Como</strong> {rol},<br/><strong>quiero</strong> {acción},<br/><strong>para</strong> {beneficio}.</p>
```

### Criterios de aceptación

```html
<h2>Criterios de aceptación</h2>
<ul>
  <li><strong>Dado</strong> {contexto}, <strong>cuando</strong> {evento}, <strong>entonces</strong> {resultado}.</li>
</ul>
```

## Area paths e Iteration paths

### Area paths

Representan la estructura del equipo o del sistema. Configurar en **Project settings → Project configuration → Areas**.

```
{PROYECTO}
  ├── Backend
  ├── Frontend
  ├── Mobile
  ├── ERP
  ├── Diseño
  └── Infraestructura
```

Regla: cada work item tiene un Area Path. No dejar en la raíz del proyecto.

### Iteration paths

Configurar en **Project settings → Project configuration → Iterations**.

Naming convention: `{PROYECTO}\Sprint {numero} — {fecha-inicio}`

- Crear los sprints del trimestre completo al inicio del trimestre.
- No renombrar sprints pasados.
- Las User Stories, Tasks y Bugs del sprint deben tener Iteration Path.

## AB# / GLPI# notation

Todo commit y PR referencia el work item con `AB#`. Los ítems bajo la épica **GLPI · Mesa de Ayuda** llevan además `GLPI#ID` para trazar el origen desde soporte N1.

```bash
git commit -m "feat: implementar alta de cliente AB#142"
git commit -m "fix: validar CUIT inválido AB#151"
git commit -m "fix: corrige export de reporte AB#210 GLPI#3488"
```

En PR:

```text
Closes AB#142
Fixes AB#151
Origen: GLPI#3488
```

Reglas:
- Todo commit y PR → obligatorio `AB#{ID}`.
- Todo ítem bajo la épica GLPI · Mesa de Ayuda → obligatorio `GLPI#{ID}` en título/descripción del work item y en el PR.
- El `GLPI#` NO reemplaza al `AB#`: ambos conviven cuando aplican.

Regla GGS: si Azure mueve automáticamente un work item a `Resolved`, verificar que no cierre una User Story sin deploy + sign-off funcional del Analista Funcional. La automatización ayuda, pero no reemplaza la validación funcional.

## Queries útiles

```wiql
-- Mis Tasks y Bugs activos en el sprint actual
[System.TeamProject] = @project
AND [System.AssignedTo] = @me
AND [System.WorkItemType] IN ('Task', 'Bug')
AND [System.State] = 'Active'
AND [System.IterationPath] = @currentIteration

-- User Stories sin AC
[System.TeamProject] = @project
AND [System.WorkItemType] = 'User Story'
AND [Microsoft.VSTS.Common.AcceptanceCriteria] = ''

-- Tasks o Bugs sin Story Points
[System.TeamProject] = @project
AND [System.WorkItemType] IN ('Task', 'Bug')
AND [Microsoft.VSTS.Scheduling.StoryPoints] = ''

-- User Stories listas para sign-off
[System.TeamProject] = @project
AND [System.WorkItemType] = 'User Story'
AND [System.State] = 'Resolved'

-- Items bloqueados
[System.TeamProject] = @project
AND [System.Tags] CONTAINS 'blocked'
AND [System.State] NOT IN ('Closed')
```

## Sprint planning por Story Points

El equipo planifica por esfuerzo relativo, no por horas.

Flujo:
1. Jefatura IT y Analista Funcional seleccionan User Stories candidatas para el sprint.
2. El Analista Funcional valida AC en Gherkin.
3. Devs y Analista Funcional descomponen cada User Story en Tasks.
4. Tasks y Bugs se estiman en Story Points.
5. Si una Task supera 8 SP, se parte.
6. La capacidad del sprint se controla sumando SP de Tasks/Bugs, no estimando User Stories directamente.

Regla: si la suma de Tasks/Bugs supera la capacidad del equipo, se negocia scope antes de confirmar el sprint.
