---
name: finanzas-metricas
description: >
  Trigger: finanzas, administración, métricas financieras, KPI financiero, tablero financiero,
  rentabilidad, cobranzas, pagos, aging, presupuesto vs real, variaciones.
  Crear análisis y reportes financieros internos con datos verificables.
---

# Finanzas Métricas

Usá esta skill cuando el equipo de Administración necesite analizar indicadores financieros, desvíos, cobranzas, pagos, rentabilidad o tableros ejecutivos.

## Reglas obligatorias

1. **No inventar números**: todo monto debe venir de archivo, API, BD, ERP, planilla o input explícito del usuario.
2. **Declarar corte y fuente**: indicar período, moneda, fecha de corte, fuente y filtros usados.
3. **Separar devengado y caja**: no mezclar ventas/facturación con cobros ni gastos con pagos.
4. **Mostrar variaciones útiles**: comparar contra presupuesto, período anterior o meta cuando exista.
5. **Explicar calidad de datos**: marcar datos incompletos, duplicados, sin conciliación o fuera de período.
6. **No dar asesoramiento contable/impositivo definitivo**: entregar análisis operativo para revisión del responsable.

## Métricas recomendadas

| Bloque | Indicadores |
|---|---|
| Resultado | ingresos, costos, margen bruto, EBITDA operativo si está definido por Administración |
| Cobranzas | vencido, por vencer, aging, cobranza real vs esperada |
| Pagos | compromisos, vencimientos, pagos realizados, concentración por proveedor |
| Presupuesto | real vs presupuesto, desvío absoluto, desvío porcentual, causa probable |
| Rentabilidad | margen por unidad, producto, canal, cliente o proyecto cuando exista dato trazable |

## Salida esperada

- Resumen ejecutivo de 3 a 5 bullets.
- Tabla de KPIs con monto, variación y semáforo.
- Hallazgos priorizados: P1 riesgo financiero, P2 desvío relevante, P3 mejora o seguimiento.
- Preguntas abiertas cuando falte dato para concluir.

## Evidencia mínima

Antes de cerrar, reportá:

- fuente usada;
- período;
- moneda;
- última fecha de actualización;
- supuestos aplicados.
