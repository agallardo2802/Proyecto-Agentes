---
name: debugging
description: >
  Metodología de debugging sistemático para encontrar bugs de forma eficiente.
  Trigger: cuando hay un bug, un comportamiento inesperado, un error de red o un problema de estado.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — cuando hay un bug por resolver
- `equipo/testing/funcional/` — cuando se reporta un bug en testing

## Objetivo

Debuggear no es adivinar — es un proceso sistemático. Este agente define la metodología para encontrar bugs de forma eficiente.

## Proceso de debugging

```
1. REPRODUCIR — ¿podés reproducirlo consistentemente?
2. AISLAR — ¿en qué parte del código ocurre?
3. ENTENDER — ¿por qué ocurre? (no solo dónde)
4. FIXEAR — aplicar el fix mínimo necesario
5. VERIFICAR — ¿desapareció el bug? ¿no rompiste nada más?
6. TESTEAR — escribir el test que lo hubiera detectado
```

## Reglas

1. **Breakpoints > console.log** — usar DevTools; los logs se olvidan en el código
2. **Reproducir antes de fixear** — si no podés reproducirlo, no sabés si lo arreglaste
3. **Un cambio a la vez** — no cambiar 3 cosas y ver cuál funcionó
4. **Leer el error completo** — el stack trace dice exactamente dónde está el problema
5. **Buscar el último cambio** — `git log --oneline` + `git bisect` si es una regresión
6. **No asumir, verificar** — `console.log(typeof variable)` antes de asumir el tipo

## DevTools — tabs esenciales

| Tab | Para qué |
|-----|---------|
| **Console** | Errores JS, logs, ejecutar expresiones |
| **Sources** | Breakpoints, step through, watch variables |
| **Network** | Ver requests, status codes, payloads de APIs |
| **Elements** | Inspeccionar DOM, computed styles |
| **Application** | localStorage, sessionStorage, cookies |

## Comandos de debugging en consola

```js
// Ver el valor real de una variable en un momento específico
console.log(JSON.stringify(variable, null, 2));

// Medir performance
console.time('operacion');
// ... código ...
console.timeEnd('operacion');

// Stack trace en cualquier punto
console.trace('llegué hasta aquí');

// Debugger programático (equivale a un breakpoint)
debugger;
```
