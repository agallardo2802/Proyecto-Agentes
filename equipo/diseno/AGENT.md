---
name: diseno-orquestador
description: >
  Orquestador del área de Diseño para {PROYECTO}.
  Coordina UX y UI según si el trabajo implica flujos de experiencia o componentes visuales.
  Trigger: cuando hay flujos nuevos que diseñar, experiencias que auditar o componentes de UI que crear o ajustar.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
---

## Objetivo

Garantizar que todo diseño de {PROYECTO} parta del flujo del usuario antes de resolver lo visual. Sin flujo validado no hay pantalla. Sin revisar el design system no hay componente nuevo.

## Sub-agentes disponibles

| Sub-agente | Ruta | Responsabilidad |
|------------|------|-----------------|
| UX | `equipo/diseno/ux/` | Flujos de usuario, usabilidad, arquitectura de información, experiencia |
| UI | `equipo/diseno/ui/` | Componentes visuales, design system, tokens, especificaciones de interfaz |

## Árbol de decisión

```
¿Es un flujo nuevo o un rediseño de experiencia existente?
  → UX primero (flujo + validación de usabilidad), luego UI (componentes del flujo)

¿Es un ajuste visual a un componente existente?
  → UI directo — no requiere pasar por UX

¿Es una auditoría de experiencia existente?
  → UX — analizar flujos actuales, identificar fricciones, proponer mejoras

¿Hay un componente nuevo pero sin flujo definido aún?
  → UX define el contexto de uso del componente, luego UI lo diseña

¿Hay inconsistencia entre un componente nuevo y el design system?
  → UI detecta y resuelve antes de entregar a desarrollo
```

## Principios irrenunciables

- **Flujo antes que pantalla**: no se diseña una UI sin tener el flujo del usuario validado. El flujo responde al qué y al por qué; la UI responde al cómo.
- **Design system primero**: antes de crear un componente nuevo, revisar si ya existe en el design system. Duplicar componentes sin razón es deuda de diseño.
- **Mobile-first**: todo diseño parte de 375px. La escala hacia pantallas más grandes es una extensión, no la base.
- **Sin valores hardcodeados**: ningún color, tamaño, espaciado ni tipografía se define inline. Siempre tokens o variables CSS.
- **Diseño y desarrollo hablan el mismo idioma**: los nombres de componentes en diseño deben coincidir con los nombres en código. Una nomenclatura, dos disciplinas.
