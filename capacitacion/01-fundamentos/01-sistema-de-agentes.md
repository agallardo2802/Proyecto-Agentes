# 01 - Sistema de Agentes GGS

## Objetivos del Capitulo

Al finalizar este capitulo entenderas:
- Que es el sistema GGS y para que sirve
- Los tres modos disponibles y cuando usar cada uno
- Como los agentes se cargan automaticamente por contexto

---

## Que es GGS

GGS es un sistema de agentes especializados para equipos de desarrollo. En lugar de darle contexto a una IA cada vez que arrancas una tarea, tenes agentes pre-configurados con roles claros — PM, arquitecto, dev, tester, data engineer, BI — que ya saben como trabajar, que estandares seguir y cuando escalar.

**Para que sirve:**
- Estandarizar el codigo y los flujos de trabajo en todo el equipo
- Reducir el tiempo que se pierde explicandoles contexto a la IA en cada sesion
- Bajar costos al usar el agente correcto para cada tarea
- Lograr equipos mas consistentes y predecibles

---

## Los Tres Modos

Al trabajar con OpenCode tenes tres opciones en el dropdown:

| Modo | Nombre | Cuando usarlo |
|------|--------|---------------|
| **Arquitecto** | Automatic | Cuando necesitas el flujo completo. El agente maneja todo. |
| **Planificador** | Plan | Cuando solo quieres analisis y cargar el tablero. Otro desarrolla. |
| **Revisor** | Judgment | Cuando queres revision adversarial / "que lo juzgue". |

> **Nota**: Los skills SDD (`sdd-init`, `sdd-explore`, `sdd-spec`, etc.) se cargan automaticamente por contexto. No hay un "Skills mode" separado.

---

## Ejemplo de Uso

### Automatic (Orchestrator)

```
> Elegis "Arquitecto"
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

### Plan

```
> Elegis "Planificador"
> Necesito cargar al tablero la nueva feature de reportes

El agente:
1. Explora el contexto actual
2. Proponemos que es "reportes"
3. Escribe las specs
4. Disena la arquitectura
5. Crea las tareas
6. Carga Epica > Feature > Stories > Tasks en Azure Boards

> Listo, las tareas estan cargadas. Derivo a Automatic para implementar.
```

**Cuando**: Preparar trabajo para el equipo, cargar tablero, analisis previo sin desarrollar.

---

### Judgment

```
> Elegis "Revisor"
> Revisa estos cambios antes de mergear

El agente:
1. Lanza dos judges independientes
2. Revisa arquitectura, patrones, edge cases y riesgos
3. Consolida hallazgos
4. Pide/aplica fixes si corresponde
5. Re-juzga hasta PASS o escala con evidencia
```

**Cuando**: Antes de mergear, cuando queres revision adversarial.

---

## Inyeccion Automatica por Contexto

Los agentes y reglas se cargan automaticamente segun la tarea:

| Contexto | Agentes/Reglas inyectados |
|----------|---------------------------|
| Backend .NET | `guilds/backend-dotnet`, `reglas/yarp-gateway`, `guilds/seguridad` |
| Frontend React | `guilds/frontend-react-nextjs` |
| Tareas con AC | `equipo/desarrollo/dev-ggs`, `reglas/code-review` |
| Bugs | `equipo/desarrollo/dev-ggs`, `reglas/debugging` |
| PR review | `equipo/devops/pr/*`, `reglas/code-review` |
| Testing | `equipo/testing/*`, `reglas/error-handling` |
| Reportes | `equipo/datos/bi-reporting`, `reglas/diseno-reportes-ggs` |

---

## Principios del Sistema

Todos los agentes siguen estos principios:

1. **VALIDAR ANTES DE ACTUAR**: Nunca ejecutar directamente, siempre presentar opciones primero
2. **CONCEPTOS > CODIGO**: Explicar el porque, no solo el que
3. **MEJORA CONTINUA**: Cuestionar siempre si hay una mejor forma
4. **CLARIDAD OPERATIVA**: La ambiguedad es el enemigo

---

## Resumen

| Concepto | Punto clave |
|----------|-------------|
| GGS | Sistema de agentes pre-configurados por rol |
| Automatic | Flujo completo SDD, el agente hace todo |
| Plan | Solo analisis + cargar tablero |
| Judgment | Revision adversarial |
| Inyeccion automatica | Se cargan los agentes que aplican segun contexto |

---

## Siguiente Capitulo

Continuar con: [02-SDD-y-TDD](./02-sdd-tdd.md)
