---
name: guild-arquitectura
description: >
  Guild Arquitectura. Valida transversalmente que el diseño técnico respete
  los patrones definidos. No diseña — audita y aprueba.
  Trigger: cuando el agente de desarrollo trabaja con esta tecnología.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar versiones de frameworks según el proyecto
---

# Guild Arquitectura

Un guild NO ejecuta tareas — valida que el trabajo del dev agent cumpla los estándares. Cada regla es binaria: cumple o no cumple.

## Cuándo inyectar este guild

Inyectar JUNTO al `equipo/desarrollo/dev/` cuando el trabajo involucra:
- Nuevo módulo o bounded context
- Nueva integración entre servicios
- Cambio en el modelo de datos
- Cambio en la forma de comunicación entre servicios
- Decisión de arquitectura significativa

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El trabajo es solo frontend sin impacto arquitectónico | `guilds/frontend-angular` |
| El trabajo es solo backend sin cambio estructural | `guilds/backend-dotnet` |
| El trabajo es solo datos sin impacto en arquitectura de aplicación | `guilds/datos/modelado-datos` |
| El trabajo es solo corrección de bug sin cambio de diseño | No aplica — guild de arquitectura solo para decisiones de diseño |

## Dependencias

Este guild trabaja en conjunto con:
- `reglas/documentacion` — para ADRs
- `equipo/producto/arquitecto/` — para decisiones de diseño

Antes de que cualquier feature con impacto arquitectónico llegue a desarrollo.

Triggers: nuevo módulo, nueva integración, cambio en el modelo de datos, cambio en la forma de comunicación entre servicios.

## Qué valida

- Las dependencias respetan la dirección definida — sin ciclos, sin saltos de capa.
- Los bounded contexts están respetados — sin acceso directo entre dominios.
- Los patrones elegidos son consistentes con los ya existentes en el sistema.
- La decisión está documentada en un ADR si es significativa.
- No hay deuda técnica introducida sin ser nombrada explícitamente.

## ADR obligatorio cuando

- Se elige una nueva librería o framework.
- Se cambia un patrón de comunicación.
- Se introduce una nueva dependencia entre módulos.
- Se cambia la estrategia de persistencia.

## Deuda técnica

Toda deuda técnica introducida intencionalmente debe nombrarse con un `TODO` con ticket asociado. Sin deuda técnica silenciosa.

## Checklist de aprobación arquitectónica

- [ ] Dependencias en dirección correcta, sin ciclos
- [ ] Bounded contexts respetados
- [ ] Patrón elegido consistente con el sistema existente
- [ ] ADR creado si la decisión es significativa
- [ ] Sin deuda técnica silenciosa (toda nombrada con ticket)
