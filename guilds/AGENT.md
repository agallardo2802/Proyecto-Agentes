---
name: guilds-orchestrator
description: >
  Orquestador de Guilds. Los guilds son estándares transversales por tecnología
  que se inyectan en el contexto del dev agent según el stack que esté usando.
  Trigger: cuando el agente de desarrollo trabaja con cualquier tecnología del stack.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar versiones de frameworks según el proyecto
---

# Guilds Orchestrator

Un guild NO ejecuta tareas — valida que el trabajo del agente de desarrollo cumpla los estándares de la tecnología. Se inyecta junto al dev agent cuando se trabaja con esa tecnología.

## Tabla de inyección

| Stack / tecnología | Guild a inyectar |
|---|---|
| Backend .NET / C# | `guilds/backend-dotnet` |
| Frontend Angular | `guilds/frontend-angular` |
| Base de datos SQL Server | `guilds/data-sqlserver` |
| APIs externas / integraciones | `guilds/integraciones` |
| Decisiones arquitectónicas | `guilds/arquitectura` |
| Power BI / DAX | `guilds/datos/powerbi` |
| Modelado de datos | `guilds/datos/modelado-datos` |
| KPIs y métricas | `guilds/datos/kpis-negocio` |
| Calidad y gobierno de datos | `guilds/datos/data-governance` |

## Regla de inyección

Los guilds se cargan JUNTO al dev agent, no antes ni después. Son el "sombrero" de estándares que lleva puesto el dev mientras codea.

Ningún código llega a PR sin pasar por el checklist del guild correspondiente.

## Precondiciones antes de inyectar un guild

Antes de cargar cualquier guild, verificar:

```
¿El agente de desarrollo ya tiene los AC definidos?
  → No → volver a equipo/producto/analista (el guild no puede operar sin AC)

¿Se conoce el stack tecnológico de la tarea?
  → No → preguntar antes de inyectar el guild equivocado

¿La tarea toca más de un stack (ej: frontend + backend)?
  → Inyectar ambos guilds simultáneamente
  → Aplicar ambos checklists antes del PR
```

## Conflictos entre guilds

Algunos guilds no deben coexistir porque cubren stacks mutuamente excluyentes:

| Guild A | Guild B | Conflicto |
|---------|---------|-----------|
| `guilds/frontend-angular` | `guilds/backend-dotnet` | Solo si la tarea es fullstack — en ese caso inyectar ambos |
| `guilds/data-sqlserver` | `guilds/datos/modelado-datos` | No son conflicto — pueden coexistir en tareas de datos |

## Flujo de validación post-implementación

```
Dev agent termina el código
  └── Cargar checklist del guild correspondiente
        └── ¿Todos los items en verde?
              → Sí → habilitar la apertura del PR
              → No → resolver los items pendientes antes de abrir el PR
```
