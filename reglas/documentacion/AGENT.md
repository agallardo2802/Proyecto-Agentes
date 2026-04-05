---
name: documentacion
description: >
  Cuándo y cómo documentar código: JSDoc, README y comentarios útiles.
  Trigger: cuando se escribe código nuevo, se agrega una función compleja o se actualiza el README.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — siempre (para JSDoc, README, ADRs)
- `equipo/producto/arquitecto/` — siempre (para ADRs)
- `equipo/testing/unitario/` — cuando se escribe tests que documentan comportamiento
- `reglas/onboarding/` — se complementa con esta regla para documentación de proyecto

## Objetivo

La documentación no es burocracia — es empatía con el próximo developer (que probablemente sos vos en 6 meses).

## Reglas

1. **Documentar el "por qué", no el "qué"** — el código ya dice qué hace; el comentario agrega el por qué
2. **Comentario = deuda si describe código obvio** — `// suma 1 al contador` es ruido
3. **JSDoc para funciones públicas y utilidades** — cualquier función usada en más de un archivo
4. **README siempre actualizado** — si cambiás cómo se levanta el proyecto, actualizá en el mismo PR
5. **TODO con ticket** — `// TODO: PI-42 - mover lógica a servicio`; sin ticket se pierde para siempre
6. **Sin código comentado** — para eso existe git; borrarlo
7. **Documentar decisiones de arquitectura** — si elegiste librería X sobre Y, dejá una nota

## Cuándo escribir JSDoc

```js
// ✅ Función compleja — documentar
/**
 * Calcula el precio final con descuento por cantidad y política vigente.
 *
 * @param {number} precioBase - Precio unitario sin descuentos
 * @param {number} cantidad - Cantidad de unidades
 * @returns {number} Precio final con descuentos aplicados
 *
 * @example
 * calcularPrecioFinal(1000, 5) // → 4500
 */
function calcularPrecioFinal(precioBase, cantidad) { ... }

// ❌ Función simple — NO documentar
function formatearFecha(fecha) {
  return fecha.toLocaleDateString('es-AR');
}
```

## Comentarios útiles vs. ruido

```js
// ❌ Ruido
// Incrementa el contador
ventasCount++;

// ✅ Útil — explica una decisión no obvia
// setTimeout(0) fuerza que el DOM se actualice antes de leer
// el alto del elemento. Ver issue #87.
setTimeout(() => calcularAlto(), 0);

// ✅ Útil — advierte un gotcha
// ATENCIÓN: la API devuelve precios en centavos, no en pesos.
const precio = apiResponse.monto * 0.01;
```

## Checklist de documentación en cada PR

- [ ] Funciones nuevas complejas tienen JSDoc
- [ ] Sin código comentado
- [ ] Sin TODOs sin ticket
- [ ] README actualizado si cambia el setup o los scripts
