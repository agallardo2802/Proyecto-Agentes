---
name: finanzas-contabilidad
description: >
  Trigger: balance, estado contable, asiento contable, libro diario, mayor, plan de cuentas,
  conciliación, cierre mensual, imputación, devengamiento.
  Preparar borradores y controles contables para revisión del área.
---

# Finanzas Contabilidad

Usá esta skill cuando el equipo de Administración necesite revisar balances, asientos, conciliaciones, cierres mensuales o imputaciones contables.

## Límites

- La IA **no aprueba** asientos ni balances.
- La IA prepara borradores, controles, conciliaciones y alertas para revisión humana.
- No reemplaza criterio del contador, auditor, asesor impositivo ni normativa local aplicable.

## Reglas obligatorias

1. **Debe = Haber**: todo asiento propuesto debe balancear.
2. **Trazabilidad**: cada línea debe referenciar comprobante, lote, cuenta, fecha o fuente.
3. **Plan de cuentas real**: no crear cuentas nuevas salvo que el usuario lo pida y quede marcado como propuesta.
4. **Corte contable**: validar período, fecha de registración y fecha del comprobante.
5. **Conciliación primero**: bancos, proveedores, clientes e intercompany deben marcar diferencias antes de proponer ajustes.
6. **No ocultar incertidumbre**: si falta soporte, marcar “requiere validación”.

## Casos de uso

| Caso | Qué hacer |
|---|---|
| Asiento contable | Proponer líneas, cuenta, debe, haber, descripción y soporte |
| Balance de sumas y saldos | Detectar saldos anómalos, cuentas sin movimiento y variaciones relevantes |
| Conciliación bancaria | Comparar extracto vs mayor, listar diferencias y posibles matches |
| Cierre mensual | Checklist de pendientes, provisiones, devengamientos y reclasificaciones |
| Auditoría interna | Armar muestra, evidencia y hallazgos accionables |

## Formato de asiento sugerido

| Fecha | Cuenta | Descripción | Debe | Haber | Soporte | Estado |
|---|---|---:|---:|---:|---|---|

## Cierre de respuesta

Siempre terminar con:

- “Pendiente de validación por Administración/Contabilidad”.
- Lista de datos faltantes.
- Riesgos si se registra sin validar.
