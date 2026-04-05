---
name: guild-kpis-negocio
description: >
  Guild que garantiza que los KPIs de negocio estén definidos oficialmente y sean consistentes en todo el sistema.
  Trigger: cuando el equipo de datos define, implementa o revisa indicadores de negocio en reportes, dashboards o modelos analíticos.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar herramientas según el stack de datos del proyecto
---

# Guild KPIs de Negocio

Garantiza que los indicadores estén definidos oficialmente y sean consistentes en todo el sistema. Un KPI sin catálogo es un KPI sin dueño — y eso genera discrepancias entre reportes.

## Cuándo inyectar este guild

Inyectar JUNTO a `equipo/datos/analista-datos/` o `equipo/datos/bi-reporting/` cuando el trabajo involucra:
- Definición de nuevos KPIs
- Revisión de KPIs existentes
- Construcción de reportes que muestren indicadores de negocio

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El trabajo es solo desarrollo de código backend | `guilds/backend-dotnet` |
| El trabajo es solo modelado de base de datos | `guilds/datos/modelado-datos` |
| El trabajo es calidad de datos o gobernanza | `guilds/datos/data-governance` |
| El trabajo es solo infraestructura de pipelines | `equipo/datos/data-engineering/` |

## Dependencias

Este guild requiere que el catálogo de KPIs esté sincronizado con:
- `equipo/datos/analista-datos/` — definición y aprobación
- `equipo/datos/bi-reporting/` — publicación en reportes
- `guilds/datos/data-governance` — para consistencia

---

## Catálogo de KPIs

- Todo KPI debe existir en el catálogo antes de aparecer en un reporte. Sin excepciones.
- El catálogo es la fuente de verdad. Si hay discrepancia entre el catálogo y un reporte, el catálogo gana.
- Un KPI no puede tener dos definiciones distintas en dos reportes diferentes. Si hay variantes legítimas (por mercado, por línea de negocio), son KPIs distintos con nombres distintos.

## Estructura de un KPI en el catálogo

Cada entrada del catálogo debe incluir todos los campos siguientes:

| Campo | Descripción |
|---|---|
| **Nombre oficial** | Nombre canónico, el que aparece en todos los reportes sin variación |
| **Definición de negocio** | Explicación en lenguaje del negocio, sin términos técnicos ni de base de datos |
| **Fórmula** | Expresión matemática o lógica exacta. Debe ser reproducible por cualquier analista |
| **Fuente de datos** | Tabla, campo y sistema origen. Si hay joins, documentarlos |
| **Granularidad** | Nivel mínimo de detalle: diario, por sucursal, por producto, por cliente |
| **Frecuencia de actualización** | Tiempo real, diaria, semanal, mensual |
| **Dueño** | Área o persona responsable de la definición del KPI |
| **Casos borde** | Cómo se tratan devoluciones, nulos, cancelaciones, períodos sin datos |
| **Fecha de vigencia** | Desde cuándo aplica esta definición (importante para históricos) |

## Proceso de alta de un KPI

El orden importa. No se implementa antes de validar la definición:

1. Analista de datos propone el KPI con la estructura del catálogo completa
2. Dueño del negocio aprueba la definición y los casos borde
3. Arquitectura de datos valida que la fuente existe y tiene la calidad necesaria
4. Se agrega al catálogo como fuente de verdad
5. Se implementa en el modelo de datos
6. Se publica en el reporte

## Reglas de consistencia

- Sin KPI calculado de formas distintas en distintos reportes. Si dos reportes muestran el mismo indicador con números distintos, hay un problema de gobernanza — no de implementación.
- Cuando hay discrepancia entre reportes, el catálogo determina cuál implementación es correcta.
- Los KPIs deprecados se marcan como deprecados en el catálogo con fecha de deprecación y motivo. No se eliminan — la trazabilidad histórica es parte del activo de datos.

---

## Checklist de validación

- [ ] KPI existe en el catálogo antes de implementar
- [ ] Definición aprobada por el dueño del negocio
- [ ] Fórmula documentada en el catálogo con reproducibilidad completa
- [ ] Fuente de datos validada por data engineering
- [ ] Casos borde documentados (devoluciones, nulos, cancelaciones)
- [ ] Sin dos reportes calculando el mismo KPI de forma distinta
