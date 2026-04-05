---
name: guild-data-sqlserver
description: >
  Guild SQL Server. Valida que el trabajo del dev agent cumpla los estándares
  de modelado y queries en SQL Server: normalización, índices, queries,
  performance y seguridad.
  Trigger: cuando el agente de desarrollo trabaja con esta tecnología.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar versiones de frameworks según el proyecto
---

# Guild SQL Server

Un guild NO ejecuta tareas — valida que el trabajo del dev agent cumpla los estándares. Cada regla es binaria: cumple o no cumple.

## Cuándo inyectar este guild

Inyectar JUNTO al `equipo/desarrollo/dev/` cuando el stack incluye:
- SQL Server como base de datos principal
- Entity Framework Core o ADO.NET
- Queries directas en T-SQL

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El proyecto usa PostgreSQL o MySQL | No aplica — crear guild específico si es necesario |
| El trabajo es solo DAX / Power BI | `guilds/datos/powerbi` |
| El trabajo es modelado de datos / Data Warehouse | `guilds/datos/modelado-datos` |
| La tarea es solo ETL / pipeline | `equipo/datos/data-engineering/` |

## Dependencias

Este guild asume que el dev agent también tiene cargado:
- `reglas/seguridad-web` — para SQL injection prevention
- `reglas/error-handling` — para manejo de errores de DB

## Modelado

- Normalización mínima 3NF salvo justificación documentada.
- PKs siempre `INT IDENTITY` o `UNIQUEIDENTIFIER` (con justificación).
- FK con nombre explícito: `FK_{tabla}_{tablaReferenciada}`.
- Sin columnas nullable sin motivo — default values cuando corresponde.

## Índices

- Índice clustered en PK por defecto.
- Índices non-clustered en columnas de búsqueda frecuente y FK.
- Sin sobre-indexar: cada índice tiene un costo de escritura.
- Índices con nombre: `IX_{tabla}_{columnas}`.

## Queries

- Sin `SELECT *` en producción.
- JOINs explícitos (nunca `WHERE` con coma).
- Paginación con `OFFSET/FETCH` o `ROW_NUMBER()`.
- Sin cursores — reemplazar con set-based operations.
- CTEs para legibilidad en queries complejas.

## Performance

- `NOLOCK` solo cuando se entienden las consecuencias (dirty reads).
- Execution plan revisado para queries críticas.
- Sin funciones escalares en `WHERE` (no son SARGable).
- Estadísticas actualizadas.

## Seguridad

- Sin SQL dinámico sin `sp_executesql` con parámetros.
- Sin permisos directos en tablas — usar stored procedures o roles.
- Sin `sa` en aplicaciones.

## Checklist de validación

- [ ] Sin `SELECT *` en producción
- [ ] FKs con nombre explícito
- [ ] Índices en columnas de búsqueda y FK
- [ ] Sin cursores
- [ ] Paginación en queries de lista
- [ ] Sin SQL dinámico sin parámetros
- [ ] Sin permisos directos en tablas
- [ ] Execution plan revisado para queries críticas
