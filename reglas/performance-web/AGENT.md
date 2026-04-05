---
name: performance-web
description: >
  Buenas prácticas de performance web para el desarrollo diario.
  Trigger: cuando se implementan búsquedas, se cargan listas grandes o se detecta lag.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — siempre
- `equipo/diseno/ui/` — cuando se diseñan componentes con alto potencial de render
- `equipo/testing/funcional/` — cuando se miden tiempos de carga
- `guilds/frontend-angular/` — siempre (para change detection, lazy loading)

## Objetivo

El performance no se optimiza al final — se construye desde el principio con buenos hábitos.

## Reglas

1. **Debounce en búsquedas** — 300ms mínimo; nunca hacer fetch por cada keystroke
2. **No modificar el DOM en loops** — calcular primero, actualizar una vez
3. **Lazy initialization** — no inicializar datos que no se van a usar enseguida
4. **Cachear datos estáticos** — catálogos, listas de opciones que no cambian
5. **Paginación en listas grandes** — nunca renderizar más de 100 items a la vez
6. **Medir antes de optimizar** — DevTools Performance tab; no optimizar a ciegas

## Debounce — el más importante

```js
// ❌ Fetch por cada keystroke — 1 request por letra
inputBusqueda.addEventListener('input', (e) => {
  buscarClientes(e.target.value); // dispara 10 requests al escribir "juan perez"
});

// ✅ Debounce — 1 request después de 300ms sin escribir
function debounce(fn, delay = 300) {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}

const buscarDebounced = debounce(buscarClientes, 300);
inputBusqueda.addEventListener('input', (e) => buscarDebounced(e.target.value));
```

## Caché de datos estáticos

```js
// ❌ Fetch en cada renderizado
async function renderizarFormulario() {
  const provincias = await api.getProvincias(); // mismo resultado siempre
  // ...
}

// ✅ Cachear al inicio, reusar siempre
let _provinciasCache = null;

async function getProvincias() {
  if (!_provinciasCache) {
    _provinciasCache = await api.getProvincias();
  }
  return _provinciasCache;
}
```

## Checklist de performance

- [ ] Búsquedas en tiempo real tienen debounce de 300ms mínimo
- [ ] Sin modificaciones al DOM dentro de loops
- [ ] Datos estáticos cacheados, no fetched en cada render
- [ ] Listas grandes tienen paginación o virtualización
