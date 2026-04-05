---
name: seguridad-web
description: >
  Prácticas de seguridad web básicas para el desarrollo diario.
  Trigger: cuando se procesa input del usuario, se manejan tokens/secretos, o se configuran APIs.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — siempre
- `equipo/diseno/ui/` — siempre (para innerHTML y sanitización)
- `guilds/backend-dotnet/` — siempre
- `guilds/frontend-angular/` — siempre
- `guilds/integraciones/` — siempre
- `guilds/data-sqlserver/` — siempre (SQL injection)

## Objetivo

La seguridad no es opcional ni para "después". Estas reglas previenen el 80% de los vectores de ataque más comunes.

## Reglas

1. **NUNCA `innerHTML` con datos del usuario** — usar `textContent` o sanitizar; XSS en 3 caracteres
2. **NUNCA secretos en el código** — API keys, tokens, contraseñas van en variables de entorno; nunca en git
3. **Validar en el servidor, no solo en el cliente** — el frontend se puede bypassear
4. **HTTPS siempre** — nunca HTTP en producción
5. **Sanitizar input antes de procesar** — trim, escape, validar tipo y longitud
6. **No exponer stack traces al usuario** — loguear internamente, mostrar mensaje genérico
7. **Tokens en headers, no en URLs** — los URLs aparecen en logs y browser history

## XSS — el más común

```js
// ❌ XSS — si el dato viene del usuario, este código ejecuta scripts arbitrarios
div.innerHTML = usuarioInput;
div.innerHTML = `<span>${nombre}</span>`;

// ✅ Seguro — textContent escapa automáticamente
div.textContent = usuarioInput;

// ✅ Si necesitás HTML dinámico — sanitizar primero
import DOMPurify from 'dompurify';
div.innerHTML = DOMPurify.sanitize(usuarioInput);
```

## Secretos — el error más costoso

```js
// ❌ NUNCA — commitear una API key es como publicarla
const API_KEY = 'sk-abc123xyz';
const DB_URL = 'postgresql://user:password@host/db';

// ✅ Variables de entorno — nunca tocan el código
const API_KEY = process.env.API_KEY;
const DB_URL = process.env.DATABASE_URL;
```

## Checklist de seguridad en cada PR

- [ ] Sin secrets ni credenciales en el código
- [ ] Sin `innerHTML` con datos no sanitizados
- [ ] Input del usuario validado antes de procesar
- [ ] Errores internos no expuestos al usuario final
- [ ] `.env` en `.gitignore`
