# Manual de capacitación — Uso de IA para Administración y Finanzas

Audiencia: equipo de Administración, Contabilidad, Tesorería y responsables que revisan información financiera interna.

## Objetivo

Usar los agentes GGS como apoyo para ordenar información financiera, detectar desvíos y preparar borradores revisables, sin delegar decisiones contables, impositivas o de tesorería.

## Qué puede hacer la IA

| Necesidad | Skill recomendada | Ejemplo |
|---|---|---|
| Ver indicadores y desvíos | `finanzas-metricas` | “Armá KPIs de cobranzas vencidas por antigüedad.” |
| Revisar asientos o conciliaciones | `finanzas-contabilidad` | “Revisá este borrador de asiento y marcá si Debe/Haber no cierra.” |
| Proyectar caja | `finanzas-cashflow` | “Armá cashflow semanal con escenario base y estrés.” |
| Preparar reporte ejecutivo | `reportes-ggs` + skill financiera | “Generá un informe ejecutivo con KPIs y semáforos.” |

## Regla de oro

La IA ayuda a **analizar y preparar**. La persona responsable **valida y aprueba**.

## Qué perfil usar

| Perfil | Cuándo usarlo |
|---|---|
| `Enterprise Safe` | Opción recomendada para Administración/Finanzas cuando hay datos internos, clientes, saldos, bancos, RRHH o documentación sensible. Usa `google/gemini-3.5-flash` para análisis/contexto y `openai/gpt-5.5` para fases críticas. |
| `Full Codex` | Usar cuando además haya código, automatizaciones, integraciones, bugs complejos o validación técnica fuerte. |
| `Low Cost` | Usar sólo para ejemplos, capacitación, borradores o documentación sin datos sensibles. No usar con saldos, clientes, bancos, sueldos ni información confidencial. |

Regla práctica: si el archivo contiene datos reales de la empresa, empezá por `Enterprise Safe`. Si el trabajo termina tocando código o deploy, cambiá a `Full Codex`.

`Fallback models` puede aparecer en OpenCode como heredado. No lo uses como control de seguridad: para proteger datos o costos, elegí el perfil correcto antes de empezar.

## Cómo pedir bien

Usá esta estructura:

```text
Necesito [objetivo].
Fuente: [archivo/API/planilla/sistema].
Período: [desde/hasta].
Moneda: [ARS/USD/etc.].
Criterio: [caja/devengado/presupuesto/contable].
Salida: [tabla/resumen/reporte/asiento/cashflow].
Restricción: no inventes datos; marcá supuestos y faltantes.
```

## Ejemplos listos para copiar

### 1. Métricas de cobranzas

```text
Analizá las cobranzas del archivo adjunto.
Período: mayo 2026.
Moneda: ARS.
Quiero aging, total vencido, top 10 clientes por deuda vencida y riesgos P1/P2/P3.
No inventes fechas de vencimiento; si faltan, listalas aparte.
```

### 2. Balance y variaciones

```text
Revisá este balance de sumas y saldos.
Compará contra el mes anterior.
Marcá cuentas con variación mayor al 15%, saldos anómalos y movimientos que requieran soporte.
No propongas ajustes sin indicar cuenta, motivo y evidencia requerida.
```

### 3. Asiento contable

```text
Prepará un borrador de asiento para este comprobante.
Usá el plan de cuentas adjunto.
El asiento debe balancear Debe/Haber.
Si falta cuenta o soporte, marcá “requiere validación”.
```

### 4. Cashflow

```text
Armá cashflow semanal para las próximas 8 semanas.
Fuente: vencimientos de proveedores, cobranzas esperadas y saldo inicial informado.
Mostrá escenario base, conservador y estrés.
Marcá semanas con saldo negativo o bajo y acciones sugeridas.
```

## Qué no pedirle

- “Aprobá este asiento”.
- “Decidí qué impuesto corresponde”.
- “Inventá el saldo que falta”.
- “Ocultá diferencias de conciliación”.
- “Confirmá que el balance está perfecto” sin soporte.

## Checklist de revisión humana

- [ ] La fuente está identificada.
- [ ] El período y moneda están claros.
- [ ] Los totales cierran.
- [ ] Los asientos balancean.
- [ ] Los supuestos están escritos.
- [ ] Hay lista de datos faltantes.
- [ ] Las conclusiones son trazables.
- [ ] El responsable revisó antes de ejecutar o registrar.

## Flujo recomendado de trabajo

1. Preparar datos: exportar planilla, reporte o consulta.
2. Pedir análisis con período, moneda y objetivo.
3. Revisar supuestos y faltantes.
4. Pedir segunda pasada: “validá totales y marcá riesgos”.
5. Exportar reporte o borrador.
6. Aprobar internamente según circuito del área.

## Errores comunes

| Error | Riesgo | Cómo corregir |
|---|---|---|
| No indicar período | Mezcla datos de meses distintos | Agregar fecha desde/hasta |
| No indicar moneda | Totales incoherentes | Normalizar moneda o separar columnas |
| Pedir “decisión final” | Riesgo contable/impositivo | Pedir análisis y validación pendiente |
| Usar datos incompletos | Conclusiones falsas | Pedir lista de faltantes antes del análisis |
| Mezclar caja y devengado | Cashflow incorrecto | Aclarar criterio: caja o devengado |

## Cierre

Los agentes GGS para Administración deben producir evidencia, orden y alertas. Si una respuesta no muestra fuente, período, moneda y supuestos, no está lista para usarse.
