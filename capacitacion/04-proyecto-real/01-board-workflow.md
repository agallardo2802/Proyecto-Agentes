# 12 - Board Workflow

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- La jerarquia de trabajo en Azure Boards
- Como trabajar con epicas, features, user stories y tasks
- El workflow de un ticket desde que se crea hasta que se cierra

---

## Jerarquia de Trabajo

```
Epic (Epica)
    └── Feature (Caracteristica)
          └── User Story (Historia de Usuario)
                └── Task (Tarea)
                └── Bug (Defecto)
```

| Nivel | Se estima? | Tiene AC? | Ejemplo |
|-------|------------|-----------|---------|
| Epic | No | No | "Sistema de Cobros" |
| Feature | No | No | "Integracion con MercadoPago" |
| User Story | No | SI (Gherkin) | "Como usuario quiero pagar con tarjeta" |
| Task | SI (SP) | Opcional | "Crear endpoint /api/payment" |
| Bug | SI (SP) | No | "El boton de pagar no funciona" |

---

## Workflow de un Ticket

### Creacion

```
1. PM/Analista crea Epic/Feature/User Story
2. Asigna a sprint
3. Define AC en Gherkin
4. Dev crea Tasks con Story Points
```

### Desarrollo

```
1. Dev toma la tarea
2. Crea branch desde la User Story
3. Trabaja en la tarea
4. Commitea con mensaje vinculado (AB#123)
5. Abre PR vinculando al ticket
6. Pasa review
7. Mergea a master
```

### Cierre

```
1. QA verifica que funciona
2. Se hace deploy a prod
3. Analyst functional da sign-off
4. Se cierra la User Story
```

---

## Azure Boards - Comandos

### Work Items

```bash
# Crear work item
az boards work-item create --title "Fix login bug" --type Bug --project "MiProyecto"

# Listar work items
az boards work-item list --project "MiProyecto"

# Actualizar
az boards work-item update --id 123 --state "In Progress"
```

###Queries

```azure
# Mi trabajo actual
Assigned to @Me AND State <> Done

# Bugs criticos
Type = Bug AND Severity = Critical AND State <> Done

# User Stories del sprint
Area Path = "MiProyecto\Sprint 5" AND Work Item Type = "User Story"
```

---

## Policy GGS - Importante

- **User Stories sin AC = NO se trabaja** — deben tener criterios de aceptacion en Gherkin
- **Tasks sin Story Points = NO entran al sprint** — estimar en SP (1, 2, 3, 5, 8, 13)
- **PR sin linked ticket = NO se mergea** — siempre vincular a un AB#
- **User Story sin deploy + sign-off = NO se cierra** — requiere validation funcional

---

## Tipos de Work Items

| Tipo | Descripcion | Estimable? |
|------|-------------|------------|
| Epic | Gran capacidad que abarca varias features | No |
| Feature | Capacidad pequena que se entrega en un sprint | No |
| User Story | Requisito desde perspectiva del usuario | No (se cierran por hijos) |
| Task | Trabajo discrete para implementar una US | Si (Story Points) |
| Bug | Defecto encontrado | Si (Story Points) |

---

## Campos Importantes

### User Story

| Campo | Descripcion |
|-------|-------------|
| Title | Descripcion corta |
| Description | Detalle del requerimiento |
| Acceptance Criteria | Criterios en Gherkin |
| Assigned To | Quien la hace |
| Sprint | En que sprint esta |
| Story Points | Size (para Tasks/Bugs, no US) |
| Tags | Clasificacion |

### Bug

| Campo | Descripcion |
|-------|-------------|
| Title | Descripcion del problema |
| Steps to Reproduce | Como reproducirlo |
| Expected Behavior | Que deberia pasar |
| Actual Behavior | Que pasa realmente |
| Severity | Critica/Alta/Media/Baja |
| Priority | 1/2/3/4 |

---

## Resumen

| Concepto | Punto clave |
|----------|-------------|
| Jerarquia | Epic → Feature → US → Task/Bug |
| Estimacion | Solo Task y Bug tienen SP |
| AC | Solo User Stories tienen Gherkin |
| Workflow | Crear → Desarrollo → Cierre |
| Vinculacion | Todo PR vinculadas a AB# |

---

## Siguiente Capitulo

Continuar con: [13-PR-Workflow](./02-pr-workflow.md)

## Recursos

- `equipo/devops/board/azure-boards/AGENT.md` — guia completa
- `equipo/devops/board/jira/AGENT.md` — guia Jira
