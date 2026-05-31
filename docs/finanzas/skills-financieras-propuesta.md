# Propuesta de skills para Administración y Finanzas

Esta propuesta suma capacidades GGS para que el equipo de Administración use IA en análisis financiero, contabilidad operativa y tesorería sin perder trazabilidad ni control humano.

## Decisión

Crear **skills**, no agentes nuevos. El trabajo financiero necesita reglas de análisis, evidencia y formato; no requiere autonomía propia ni permisos especiales. El Orquestador/Planificador puede invocarlas cuando detecte contexto financiero.

## Skills propuestas

| Skill | Cuándo usarla | Resultado esperado |
|---|---|---|
| `finanzas-metricas` | métricas, cobranzas, pagos, rentabilidad, presupuesto vs real | KPIs, variaciones, semáforos, hallazgos P1/P2/P3 |
| `finanzas-contabilidad` | asientos, balance, mayor, conciliación, cierre mensual | borradores, controles, diferencias, pendientes de validación |
| `finanzas-cashflow` | caja, cashflow, tesorería, vencimientos, liquidez | flujo proyectado, escenarios, riesgos y acciones sugeridas |

## Guardrails comunes

- No inventar montos, cuentas ni saldos.
- Usar fuentes reales: ERP, BD, API, planilla, extracto o input explícito.
- Declarar período, moneda, fecha de corte y fuente.
- Separar devengado, facturación, cobranza y caja.
- Marcar incertidumbre y datos faltantes.
- No reemplazar aprobación de Administración, Contabilidad, Auditoría o asesor impositivo.

## Consejos de uso para Administración

### Buen prompt

```text
Analizá este cashflow semanal.
Fuente: archivo adjunto de vencimientos y cobranzas.
Moneda: ARS.
Período: junio 2026.
Necesito riesgos P1/P2/P3, semanas con saldo negativo y acciones sugeridas.
No inventes datos faltantes; marcá supuestos.
```

### Mal prompt

```text
Decime si estamos bien de caja.
```

Falta período, fuente, moneda, criterio de riesgo y objetivo.

## Checklist antes de confiar en una respuesta

- [ ] ¿Indica fuente y fecha de corte?
- [ ] ¿La moneda está clara?
- [ ] ¿Separa caja de devengado?
- [ ] ¿Marca supuestos?
- [ ] ¿Lista datos faltantes?
- [ ] ¿Los totales cierran?
- [ ] ¿Las acciones son revisables por una persona?

## Relación con normas contables

Para cashflow, la referencia conceptual general es que los flujos se clasifican como operación, inversión y financiación. Esta repo no fija norma contable legal; el uso local debe validarlo Administración/Contabilidad según criterio aplicable.

Referencias públicas consultadas:

- IFRS Foundation — IAS 7 Statement of Cash Flows: https://www.ifrs.org/issued-standards/list-of-standards/ias-7-statement-of-cash-flows.html/
- IFRS Foundation — IAS 1 Presentation of Financial Statements: https://www.ifrs.org/issued-standards/list-of-standards/ias-1-presentation-of-financial-statements/
