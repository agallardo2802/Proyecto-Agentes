---
name: naming-conventions
description: >
  Convenciones de nombres para variables, funciones, archivos y clases CSS.
  Trigger: cuando se nombran variables, funciones, archivos, componentes o clases.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — siempre
- `equipo/diseno/ui/` — siempre (para CSS)
- `guilds/backend-dotnet/` — siempre
- `guilds/frontend-angular/` — siempre
- `equipo/datos/bi-reporting/` — para medidas DAX

## Objetivo

Los nombres son la primera forma de documentación. Un buen nombre elimina la necesidad de un comentario.

## Reglas de naming por tipo

| Tipo | Convención | Ejemplo |
|------|-----------|---------|
| Variables y funciones (JS) | `camelCase` | `ventaActual`, `calcularTotal()` |
| Constantes globales | `UPPER_SNAKE_CASE` | `MAX_REINTENTOS`, `API_BASE_URL` |
| Clases y componentes | `PascalCase` | `VentaCard`, `useVentas` |
| Archivos JS/TS | `kebab-case` | `venta-service.js`, `use-ventas.ts` |
| Clases CSS | `kebab-case` + BEM | `venta-card`, `venta-card__titulo` |
| Booleanos | prefijo `is`/`has`/`can`/`should` | `isLoading`, `hasError`, `canEdit` |
| Event handlers | prefijo `on` o `handle` | `onClick`, `handleSubmit` |
| Custom hooks React | prefijo `use` | `useVentas`, `useConfirmacion` |

## Reglas de calidad

1. **Nombres que explican la intención**: `calcularPrecioConDescuento()` > `calc()`
2. **Sin abreviaciones crípticas**: `usuario` > `usr`, `cantidad` > `qty`
3. **Consistencia con el dominio del negocio**: usar los términos del negocio (venta, cliente, factura)
4. **Sin números en nombres**: `datos2` > `datosActualizados`
5. **Verbos para funciones**: `obtenerVentas()`, `guardarCliente()`, `validarFormulario()`
6. **Sustantivos para variables**: `ventaActual`, `listaClientes`

## Ejemplos

```js
// ❌ Nombres crípticos
const d = new Date();
const fn = (x) => x * 1.21;
let arr2 = [];
function proc(data) { }

// ✅ Nombres con intención
const fechaActual = new Date();
const calcularPrecioConIVA = (precioBase) => precioBase * 1.21;
let ventasFiltradas = [];
function procesarPagoConTarjeta(datosTarjeta) { }
```

```css
/* ❌ Clase sin significado */
.div1 { }
.rojo-grande { }

/* ✅ BEM descriptivo */
.venta-card { }
.venta-card--urgente { }
.venta-card__monto { }
```
