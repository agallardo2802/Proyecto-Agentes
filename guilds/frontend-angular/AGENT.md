---
name: guild-frontend-angular
description: >
  Guild Angular. Valida que el trabajo del dev agent cumpla los estándares
  de desarrollo frontend con Angular: arquitectura, estado, componentes,
  performance, seguridad y testing.
  Trigger: cuando el agente de desarrollo trabaja con esta tecnología.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar versiones de frameworks según el proyecto
---

# Guild Frontend Angular

Un guild NO ejecuta tareas — valida que el trabajo del dev agent cumpla los estándares. Cada regla es binaria: cumple o no cumple.

## Cuándo inyectar este guild

Inyectar JUNTO al `equipo/desarrollo/dev/` cuando el stack incluye:
- Proyectos Angular 16+ (Standalone o módulos)
- Componentes, servicios, guards o interceptors Angular
- Estado con NgRx o Signals
- Tests con Jest + Angular Testing Library

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El proyecto es React / Vue / Svelte | No aplica — crear guild específico |
| El trabajo es solo backend .NET | `guilds/backend-dotnet` |
| El trabajo es solo CSS/tokens sin lógica Angular | `reglas/css-arquitectura` |
| La tarea es solo CI/CD o infraestructura | No requiere guild de stack |

## Dependencias

Este guild asume que el dev agent también tiene cargado:
- `reglas/css-arquitectura` — para tokens, especificidad y sin !important
- `reglas/seguridad-web` — para sanitización en templates y XSS
- `reglas/performance-web` — para renders innecesarios y bundle size
- `reglas/naming-conventions` — para nombres de componentes, servicios y archivos

## Arquitectura

- Feature modules o Standalone components (Angular 17+).
- Lazy loading obligatorio para rutas.
- Sin lógica de negocio en componentes — va en services.
- Separación container/presentational: smart components (con lógica) vs dumb components (solo inputs/outputs).

## Estado

- NgRx para estado global complejo.
- Signals para estado local reactivo (Angular 17+).
- Sin múltiples fuentes de verdad para el mismo dato.
- Sin estado en componentes si es compartido.

## Componentes

- Naming: `{feature}-{nombre}.component.ts`.
- Sin `any` en TypeScript.
- Inputs con tipos explícitos. Outputs con EventEmitter tipado.
- OnPush change detection en componentes presentacionales.
- Sin lógica en templates — moverla al componente o a un pipe.

## Performance

- `trackBy` en todos los `*ngFor`.
- Pipes puros para transformaciones.
- Lazy loading de imágenes.
- Sin subscriptions sin unsubscribe — usar async pipe o `takeUntilDestroyed`.

## Seguridad

- Sin `innerHTML` sin sanitización.
- Sin datos del usuario interpolados directamente en templates.
- HttpClient interceptors para autenticación.

## Testing

- Jest + Testing Library.
- Sin acceder al DOM por clase CSS — usar roles o text content.
- Sin probar implementación interna.

## Checklist de validación

- [ ] Lazy loading en todas las rutas
- [ ] Sin lógica de negocio en componentes
- [ ] Estado global en NgRx/Signals, no en componentes
- [ ] Sin `any` en TypeScript
- [ ] OnPush en componentes presentacionales
- [ ] `trackBy` en todos los `*ngFor`
- [ ] Sin subscriptions sin cleanup
- [ ] Sin `innerHTML` sin sanitización
- [ ] Tests con Testing Library, sin selectores CSS
