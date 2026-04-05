---
name: guild-integraciones
description: >
  Guild Integraciones. Valida que el trabajo del dev agent cumpla los estándares
  para integración con APIs externas y sistemas de terceros: contratos,
  resiliencia, manejo de errores, seguridad y logging.
  Trigger: cuando el agente de desarrollo trabaja con esta tecnología.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar versiones de frameworks según el proyecto
---

# Guild Integraciones

Un guild NO ejecuta tareas — valida que el trabajo del dev agent cumpla los estándares. Cada regla es binaria: cumple o no cumple.

## Cuándo inyectar este guild

Inyectar JUNTO al `equipo/desarrollo/dev/` cuando el trabajo involucra:
- Consumo de APIs de terceros (Stripe, Twilio, SendGrid, etc.)
- webhooks o callbacks de sistemas externos
- Integración con servicios de mensajería o notificación

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El trabajo es solo frontend | `guilds/frontend-angular` |
| El trabajo es solo backend sin integraciones externas | `guilds/backend-dotnet` |
| La integración es con base de datos | `guilds/data-sqlserver` |
| La integración es con Power BI | `guilds/datos/powerbi` |

## Dependencias

Este guild asume que el dev agent también tiene cargado:
- `reglas/seguridad-web` — para manejo de secrets y tokens
- `reglas/error-handling` — para manejo de errores y logging de integraciones (correlación de requests incluida)

## Contratos

- Versionar APIs consumidas (`/v1/`, `/v2/`).
- Documentar contrato esperado: qué campos, tipos, valores posibles.
- Validar response antes de procesar — no asumir estructura.

## Resiliencia

- Retry con backoff exponencial para errores transitorios (429, 503, timeout).
- Circuit breaker para servicios inestables (Polly en .NET).
- Timeout explícito en toda llamada externa — sin espera infinita.
- Fallback definido: qué pasa si el servicio falla.

## Manejo de errores

- Distinguir errores de negocio (400, 422) de errores de infraestructura (500, timeout).
- No propagar excepciones del tercero directamente — traducir a excepciones de dominio.
- Loguear request y response en errores (sin datos sensibles).

## Seguridad

- Secrets de terceros en variables de entorno o vault.
- Sin API keys en logs.
- Headers de autenticación no logueados.
- Validar certificados SSL en producción.

## Logging

- Loguear: servicio llamado, endpoint, duración, status code, retry attempt.
- Correlation ID para trazar llamadas entre servicios.
- Sin loguear PII o datos de tarjeta.

## Checklist de validación

- [ ] Retry con backoff exponencial implementado
- [ ] Timeout explícito en toda llamada externa
- [ ] Fallback definido para fallo del servicio
- [ ] Response validado antes de procesar
- [ ] Errores de terceros traducidos a dominio propio
- [ ] Sin secrets en código o logs
- [ ] Correlation ID en todas las llamadas
- [ ] Sin PII en logs
