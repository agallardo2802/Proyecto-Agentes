---
name: error-handling
description: >
  Manejo de errores correcto: sin empty catch, mensajes útiles y logging con contexto.
  Trigger: cuando se implementa manejo de excepciones, se muestran errores al usuario o se loguean fallos.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — siempre
- `equipo/testing/unitario/` — cuando se testean casos de error
- `guilds/backend-dotnet/` — siempre
- `guilds/integraciones/` — siempre

## Objetivo

Los errores silenciados son peores que los errores que crashean. Un empty catch es la mentira más cara del código.

## Reglas

1. **NUNCA empty catch** — siempre loguear y mostrar feedback al usuario
2. **Mensajes amigables al usuario** — nunca mostrar stack traces ni "undefined is not a function"
3. **Loguear con contexto** — `console.error('[nombreFuncion]', error)` — siempre identificar el origen
4. **NUNCA `alert()` para errores** — usar toasts, mensajes inline o estados de error en la UI
5. **Distinguir errores recuperables de fatales** — un 404 no es lo mismo que un 500
6. **Limpiar estado en finally** — botones, spinners y loaders siempre en `finally`

## Patrones

```js
// ❌ El peor código del mundo — error silenciado
try {
  await procesarPago(datos);
} catch (e) {}

// ❌ Casi igual de malo — log sin contexto ni UX
try {
  await procesarPago(datos);
} catch (e) {
  console.log(e);
}

// ✅ Correcto
async function procesarPago(datos) {
  try {
    const resultado = await api.pago(datos);
    mostrarExito('Pago procesado correctamente');
    return resultado;
  } catch (error) {
    console.error('[procesarPago]', error);

    // Mensaje según tipo de error
    if (error.status === 400) {
      mostrarError('Los datos del pago son inválidos. Verificá e intentá de nuevo.');
    } else if (error.status === 503) {
      mostrarError('El servicio de pagos no está disponible. Intentá en unos minutos.');
    } else {
      mostrarError('Ocurrió un error inesperado. Contactá a soporte si persiste.');
    }
  } finally {
    setBtnPagarDisabled(false);
    setLoadingPago(false);
  }
}
```

## Checklist de manejo de errores

- [ ] Sin empty catch en todo el diff
- [ ] Todo catch loguea con `console.error('[nombreFuncion]', error)`
- [ ] El usuario recibe un mensaje comprensible (no el error técnico)
- [ ] Sin `alert()` para mostrar errores — usar componente de toast/mensaje
- [ ] Estado de loading limpiado en `finally`
