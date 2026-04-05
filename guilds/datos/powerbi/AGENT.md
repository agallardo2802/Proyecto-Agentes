---
name: guild-powerbi
description: >
  Guild de estándares para desarrollo de reportes y dashboards en Power BI.
  Trigger: cuando el equipo de datos trabaja con Power BI, DAX, modelos tabulares o publicación en Power BI Service.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar herramientas según el stack de datos del proyecto
---

# Guild Power BI

Estándares para desarrollo de reportes y dashboards en Power BI. Estas reglas aplican a todo artefacto publicado o revisado por el equipo de datos.

## Cuándo inyectar este guild

Inyectar JUNTO a `equipo/datos/bi-reporting/` cuando el trabajo involucra:
- Desarrollo de reportes o dashboards en Power BI
- Medidas DAX
- Modelo tabular

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El trabajo es solo modelado SQL | `guilds/data-sqlserver` |
| El trabajo es solo arquitectura de datos | `guilds/datos/modelado-datos` |
| El trabajo es definición de KPIs | `guilds/datos/kpis-negocio` |
| El trabajo es código backend normal | No aplica |

## Dependencias

Este guild asume que el equipo también tiene:
- `guilds/datos/modelado-datos` — para star schema del modelo
- `guilds/datos/kpis-negocio` — para consistencia de métricas
- `reglas/naming-conventions` — para nombres de medidas

---

## Modelo de datos

- Star schema obligatorio: fact tables + dimension tables. Sin esquemas relacionales mezclados con el modelo tabular.
- Sin relaciones many-to-many directas — usar tabla puente explícita.
- Sin columnas calculadas en fact tables cuando el mismo resultado puede obtenerse como medida DAX.
- Nombres de tablas en singular y PascalCase: `FactVenta`, `DimCliente`, `DimFecha`.

## DAX

- Medidas en PascalCase con espacios: `[Ingresos Netos]`, `[Ticket Promedio]`.
- Sin lógica de negocio hardcodeada en DAX — usar tablas de parámetros para umbrales, tasas o categorías configurables.
- Variables obligatorias en medidas complejas para legibilidad:
  ```dax
  VAR _totalVentas = CALCULATE([Ventas Brutas], ALL(DimCliente))
  RETURN DIVIDE([Ventas Brutas], _totalVentas)
  ```
- Preferir `CALCULATE + FILTER` sobre columnas, no sobre medidas, cuando sea posible.
- Sin medidas implícitas — todas las agregaciones deben ser medidas explícitas definidas en el modelo.

## Performance

- Evitar columnas de alta cardinalidad en slicers (IDs, timestamps, texto libre).
- Modo de importación preferido sobre DirectQuery. Si se usa DirectQuery, documentar el motivo y medir el impacto.
- Deshabilitar Auto Date/Time cuando el modelo tiene tabla de fechas propia.
- Reducir el modelo antes de publicar: eliminar columnas innecesarias, verificar tipos de datos, comprimir con strings comunes.

## Diseño visual

- Paleta de colores del proyecto — no los defaults de Power BI.
- Sin más de 5-7 visuals por página. Si hay más información, agregar página adicional con foco claro.
- Título descriptivo en cada visual: el usuario tiene que entender qué mide sin leer el reporte entero.
- Tooltips configurados con contexto adicional donde el visual lo permita.
- Filtros de fecha siempre visibles en la página — no ocultos en el panel lateral.

## Publicación

- Workspace de desarrollo separado del de producción. Nunca publicar directo a prod desde Power BI Desktop.
- RLS (Row Level Security) configurado y testeado cuando el reporte expone datos sensibles o segmentados por usuario.
- Actualización programada documentada: frecuencia, ventana horaria, responsable de monitoreo.

---

## Checklist de validación

- [ ] Star schema implementado
- [ ] Sin relaciones many-to-many directas
- [ ] Medidas con nombre en PascalCase con espacios
- [ ] Sin medidas implícitas
- [ ] Variables usadas en DAX complejo
- [ ] Sin más de 7 visuals por página
- [ ] Paleta de colores del proyecto aplicada
- [ ] RLS configurado si hay datos sensibles
- [ ] Workspace dev separado de prod
