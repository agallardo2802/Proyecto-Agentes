---
name: guild-data-governance
description: >
  Guild que garantiza calidad de datos, trazabilidad y fuente única de verdad en todo el ecosistema de datos.
  Trigger: cuando el equipo de datos trabaja con integración de sistemas, calidad de datos, clasificación de sensibilidad o políticas de acceso y retención.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar herramientas según el stack de datos del proyecto
---

# Guild Data Governance

Garantiza calidad de datos, trazabilidad y fuente única de verdad en todo el ecosistema. Sin governance, los datos son ruido — no activos.

## Cuándo inyectar este guild

Inyectar JUNTO a `equipo/datos/data-engineering/` o `equipo/datos/analista-datos/` cuando el trabajo involucra:
- Clasificación de sensibilidad de datos
- Definición de políticas de acceso o retención
- Auditoría de calidad de datos
- Lineage/linaje de datos críticos

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El trabajo es solo construcción de dashboards | `guilds/datos/powerbi` |
| El trabajo es solo modelado de esquema | `guilds/datos/modelado-datos` |
| El trabajo es solo definición de KPIs | `guilds/datos/kpis-negocio` |
| El trabajo es desarrollo de código normal | No aplica — guild de datos |

## Dependencias

Este guild trabaja en conjunto con:
- `guilds/datos/kpis-negocio` — para consistencia de KPIs
- `guilds/datos/modelado-datos` — para esquema y naming
- `guilds/datos/powerbi` — para publicación segura

---

## Fuente única de verdad

- Cada dato crítico tiene un sistema de origen (system of record) definido y documentado.
- Si el dato existe en múltiples sistemas, hay un proceso de maestro definido que determina qué sistema es autoritativo y cómo se sincronizan los demás.
- Sin datos críticos duplicados en múltiples sistemas sin sincronización documentada y monitorizada.

## Calidad de datos

Las siguientes dimensiones deben monitorearse activamente — no de forma reactiva:

| Dimensión | Qué mide |
|---|---|
| **Completitud** | % de campos requeridos sin nulos en el período analizado |
| **Exactitud** | El dato refleja la realidad del negocio — validado contra fuente autoritativa |
| **Consistencia** | Mismo dato = mismo valor en distintos sistemas o capas del pipeline |
| **Oportunidad** | El dato está disponible cuando el proceso que lo consume lo necesita |
| **Unicidad** | Sin duplicados no intencionales — registros únicos identificables por su PK |

Cada dimensión debe tener una métrica medible y un umbral de alerta definido por el equipo.

## Clasificación de datos

Toda columna o dataset debe tener una clasificación de sensibilidad asignada. Sin clasificación, el dato no puede publicarse ni compartirse:

| Nivel | Descripción |
|---|---|
| **Público** | Sin restricciones de acceso |
| **Interno** | Solo empleados de la organización |
| **Confidencial** | Acceso restringido por rol o área de negocio |
| **Sensible / PII** | Datos personales o sensibles que requieren cumplimiento legal (GDPR, LGPD, etc.) |

## Linaje de datos

- Documentar origen → transformaciones → destino para todos los datos críticos del negocio.
- Cuando un reporte muestra un número, debe poder trazarse hasta la fuente sin ambigüedad.
- El linaje es parte del catálogo de datos — no documentación separada.

## Retención y ciclo de vida

- Política de retención definida por tipo de dato y clasificación de sensibilidad.
- Datos PII con fecha de expiración explícita. Pasada esa fecha, el proceso de eliminación o anonimización debe ejecutarse.
- Archivado antes de eliminación: los datos no se eliminan directamente de producción sin pasar por una etapa de archivo.

## Acceso

- Principio de mínimo privilegio: cada rol accede solo a los datos que necesita para su función.
- Acceso a datos sensibles o confidenciales con aprobación documentada y auditable.
- Sin acceso directo a bases de producción para desarrollo o testing. Los entornos de desarrollo usan datos anonimizados o sintéticos.

---

## Checklist de validación

- [ ] System of record definido para datos críticos
- [ ] Métricas de calidad monitoreadas (completitud, unicidad, consistencia)
- [ ] Toda columna con clasificación de sensibilidad asignada
- [ ] Linaje documentado para datos críticos
- [ ] Política de retención definida por tipo de dato
- [ ] Acceso por principio de mínimo privilegio
- [ ] Sin acceso directo a prod para desarrollo o testing
