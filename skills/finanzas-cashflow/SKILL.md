---
name: finanzas-cashflow
description: >
  Trigger: cashflow, flujo de caja, caja, tesorería, forecast, proyección de caja,
  vencimientos, liquidez, cobranza esperada, pagos esperados, escenario financiero.
  Construir y revisar flujos de caja operativos con supuestos explícitos.
---

# Finanzas Cashflow

Usá esta skill cuando el equipo de Administración necesite proyectar caja, ordenar vencimientos, simular escenarios o explicar necesidades de liquidez.

## Reglas obligatorias

1. **Base de caja**: usar cobros y pagos esperados, no sólo facturación o gasto devengado.
2. **Supuestos visibles**: listar tasa de cobranza, fechas, moneda, vencimientos, pagos retenidos y saldos iniciales.
3. **Escenarios mínimos**: base, conservador y estrés si el usuario pide decisión de tesorería.
4. **Semáforo de liquidez**: marcar semanas/días con saldo bajo, negativo o concentración de pagos.
5. **No recomendar financiamiento definitivo**: proponer alternativas para evaluación del responsable financiero.
6. **Trazabilidad**: cada flujo relevante debe apuntar a factura, proveedor, cliente, nómina, impuesto, préstamo o input explícito.

## Estructura recomendada

| Período | Saldo inicial | Cobros esperados | Pagos esperados | Saldo final | Riesgo |
|---|---:|---:|---:|---:|---|

## Clasificación operativa

- Cobros operativos.
- Pagos operativos.
- Inversiones o compras extraordinarias.
- Financiamiento, préstamos o cuotas.
- Impuestos, cargas sociales y nómina.

## Validaciones

Antes de concluir, revisar:

- ¿El saldo inicial coincide con banco/caja?
- ¿Los vencimientos tienen fecha real?
- ¿Hay cobros vencidos incluidos como seguros?
- ¿Hay pagos críticos omitidos?
- ¿La moneda está normalizada?

## Salida esperada

- Resumen ejecutivo.
- Tabla semanal o diaria.
- Riesgos P1/P2/P3.
- Acciones sugeridas: cobrar, postergar, confirmar, conciliar o pedir aprobación.
