---
name: javascript-async
description: >
  Patrones de JavaScript asincrónico para el trabajo diario.
  Trigger: cuando se trabaja con fetch, Promises, async/await o timing.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — siempre
- `equipo/testing/unitario/` — cuando se testean funciones async
- `equipo/testing/apis/` — siempre
- `guilds/frontend-angular/` — siempre (para manejo de observables/subscriptions)
- `guilds/integraciones/` — siempre (para manejo de requests)

## Objetivo

El código async mal escrito es la fuente número uno de bugs silenciosos. Este agente cubre los patrones correctos y las trampas más comunes.

## Reglas

1. **Siempre async/await sobre `.then()`** — más legible, más fácil de debuggear
2. **Todo await dentro de try/catch** — nunca dejar un await sin manejo de error
3. **finally para limpiar estado** — deshabilitar botones, ocultar spinners siempre en `finally`
4. **Promise.all para operaciones independientes** — no hacer await uno por uno si pueden ir en paralelo
5. **NO usar await dentro de forEach** — usar `for...of` o `Promise.all(array.map(...))`
6. **Indicar loading antes del await** — el usuario necesita feedback inmediato

## Patrones correctos

```js
// ✅ Patrón completo con loading + error + finally
async function cargarDatos() {
  setBtnDisabled(true);
  setLoading(true);
  try {
    const datos = await api.getDatos();
    renderDatos(datos);
  } catch (error) {
    console.error('[cargarDatos]', error);
    mostrarError('No se pudieron cargar los datos. Intentá de nuevo.');
  } finally {
    setBtnDisabled(false);
    setLoading(false);
  }
}

// ✅ Operaciones independientes en paralelo
const [usuario, permisos] = await Promise.all([
  api.getUsuario(id),
  api.getPermisos(id)
]);

// ❌ Trampa: await en forEach (no espera, no maneja errores)
items.forEach(async (item) => {
  await procesarItem(item); // Este await es ignorado
});

// ✅ Correcto: for...of
for (const item of items) {
  await procesarItem(item);
}
```

## Checklist de código async

- [ ] Todo await dentro de try/catch
- [ ] Estado de loading mostrado antes del await
- [ ] Estado de loading limpiado en finally
- [ ] Sin await dentro de forEach — usar for...of o Promise.all
- [ ] Operaciones independientes ejecutadas en paralelo con Promise.all
