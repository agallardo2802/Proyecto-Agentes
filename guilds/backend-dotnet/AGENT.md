---
name: guild-backend-dotnet
description: >
  Guild .NET / C#. Valida que el trabajo del dev agent cumpla los estándares
  de desarrollo backend con .NET: arquitectura, errores, logging, seguridad,
  performance y testing.
  Trigger: cuando el agente de desarrollo trabaja con esta tecnología.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar versiones de frameworks según el proyecto
---

# Guild Backend .NET / C#

Un guild NO ejecuta tareas — valida que el trabajo del dev agent cumpla los estándares. Cada regla es binaria: cumple o no cumple.

## Cuándo inyectar este guild

Inyectar JUNTO al `equipo/desarrollo/dev/` cuando el stack incluye:
- Proyectos .NET 6 / 7 / 8 / 9 con C#
- APIs Web con ASP.NET Core
- Proyectos con Entity Framework Core
- Aplicaciones con Serilog como logger

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El proyecto es Frontend Angular | `guilds/frontend-angular` |
| El trabajo es solo SQL / queries | `guilds/data-sqlserver` |
| El trabajo es integración con APIs externas | `guilds/integraciones` |
| La tarea es solo infraestructura / CI/CD | No requiere guild de stack |

## Dependencias

Este guild asume que el dev agent también tiene cargado:
- `reglas/error-handling` — para el manejo correcto de excepciones
- `reglas/seguridad-web` — para validación de input y secretos
- `reglas/naming-conventions` — para nombres consistentes en C#

## Estructura y capas

Clean Architecture obligatoria. Capas: API → Application → Domain → Infrastructure. Las dependencias apuntan hacia adentro. Sin lógica de negocio en controllers.

## Manejo de errores

- Sin excepciones genéricas (`catch Exception`). Excepciones de dominio tipadas.
- Middleware global de manejo de errores.
- ProblemDetails para respuestas de error (RFC 7807).
- Sin swallow de excepciones.

## Logging

- Serilog con structured logging.
- Sin string interpolation en logs — forma correcta: `Log.Information("User {UserId}", id)`, no `$"User {id}"`.
- Niveles correctos: `Debug` para desarrollo, `Information` para eventos de negocio, `Warning` para situaciones inesperadas pero manejadas, `Error` para fallos.

## Seguridad

- Sin secretos en código o appsettings commiteados.
- Validación de input con FluentValidation.
- Autenticación JWT con validación de claims.
- Sin SQL concatenado — siempre parámetros o EF Core.

## Performance

- Async/await en toda la cadena de I/O.
- Sin `.Result` o `.Wait()` — causa deadlock.
- Paginación obligatoria en endpoints de lista.
- Caché con `IMemoryCache` o `IDistributedCache` cuando aplica.

## Testing

- xUnit + Moq.
- Naming: `Metodo_Escenario_ResultadoEsperado`.
- Sin lógica en tests (no ifs, no loops).
- Cobertura mínima 80% en Application layer.

## Checklist de validación

- [ ] Sin lógica de negocio en controllers
- [ ] Excepciones tipadas, sin catch genérico
- [ ] Logs estructurados con niveles correctos
- [ ] Sin secretos en código
- [ ] Input validado con FluentValidation
- [ ] Todos los métodos I/O son async
- [ ] Sin `.Result` ni `.Wait()`
- [ ] Endpoints de lista tienen paginación
- [ ] Tests con naming correcto
- [ ] Cobertura ≥ 80% en Application layer
