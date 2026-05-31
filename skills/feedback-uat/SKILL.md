---
name: feedback-uat
description: "Trigger: feedback UAT, dejar feedback, prueba de usuario, comentarios de prueba, error de prueba, mejora, no entiendo el flujo."
license: Apache-2.0
metadata:
  author: GGSoluciones
  version: "1.1"
---

# Feedback UAT

## Activation Contract

Usá esta skill cuando un portal interno necesite capturar feedback formal de usuarios durante UAT, pilotos, pruebas operativas o validación de negocio.

## Outcome

El usuario puede dejar feedback desde cualquier vista principal del portal y el comentario queda guardado en base de datos con usuario, fecha, vista y contexto suficiente para que Comercial/Producto lo revise y lo convierta en backlog.

## Hard Rules

- Agregá un botón visible **“Dejar feedback”** en todas las vistas principales del portal.
- No guardes feedback en JSON, archivos locales, mocks, `localStorage` ni fixtures.
- Persistí siempre por API/BD usando el endpoint de feedback definido por el proyecto.
- Usá como estándar común de portales:
  - `POST /api/feedback`
- No crees endpoints por portal como primera opción. Sólo usalos si existe una razón de aislamiento real y documentada.
- `POST /api/sucursal-virtual/feedback` queda como alias compatible de SV360, no como contrato nuevo.
- Enviá siempre `portal` y `origen` para identificar claramente la aplicación; `appVersion` es complementario, no reemplazo del origen.
- Si vence el token o la API devuelve no autorizado, redirigí al login o iniciá el flujo de sesión expirada.
- Cuando haya comunicación operativa del feedback o resumen para seguimiento, usá el canal Slack **`#feedback-sites`**.
- Nunca muestres stacktrace, payload técnico, headers, tokens ni mensajes internos al usuario.
- No marques la tarea como validada sin probar persistencia real en BD o endpoint de revisión.

## UI Contract

El botón debe abrir un modal accesible con:

- `tipo`: `error`, `mejora`, `no entiendo el flujo`, `falta información`, `otro`.
- `prioridad`: `baja`, `media`, `alta`, `crítica`.
- checkbox: **“esto me impide continuar la prueba”**.
- `nombre de contacto`: obligatorio si no puede inferirse del usuario logueado; mostrarlo editable en maquetas/UAT.
- `comentario`: obligatorio.

El modal debe incluir:

- foco inicial y cierre por teclado;
- validación visible del comentario obligatorio;
- estado de envío/loading;
- botón enviar deshabilitado mientras se procesa;
- contraste correcto en light/dark mode;
- texto legible en hover, focus, disabled y error.


## Generic API Contract

Para nuevos portales, usá este contrato base:

```http
POST /api/feedback
Authorization: Bearer <token-del-portal>
Content-Type: application/json
```

Campos mínimos recomendados:

```json
{
  "portal": "nombre-corto-del-portal",
  "origen": "NombreHumanoDelPortal",
  "vista": "home",
  "tipo": "mejora",
  "severidad": "baja",
  "bloqueaPrueba": false,
  "comentario": "Texto ingresado por quien prueba",
  "usuarioEmail": "usuario@example.com",
  "usuarioNombre": "Nombre de contacto",
  "clienteDocumento": "opcional",
  "numeroAbonado": "opcional",
  "domicilio": "opcional",
  "url": "url actual",
  "userAgent": "navegador",
  "appVersion": "build o version"
}
```

Respuesta esperada de alta: `201` con `id`.

La API se encarga de persistir y de derivar la comunicación interna por API Comunicaciones. El frontend no debe llamar Slack ni webhooks directos.

## Payload Contract

Enviar junto con el comentario:

- usuario logueado;
- nombre de contacto de quien deja el feedback;
- email;
- fecha/hora;
- vista o sección actual;
- URL actual;
- navegador/user agent;
- identificador de cliente, abonado o contrato si aplica;
- domicilio o contexto activo si aplica;
- versión del portal si está disponible;
- `portal` y `origen` siempre; `appVersion` si está disponible;
- tipo, prioridad, bloqueo de prueba, nombre de contacto y comentario.

## User Messages

Usá estos mensajes visibles:

- Éxito: **“Feedback registrado. Gracias por ayudar a mejorar la prueba.”**
- Error: **“No pudimos registrar el feedback en este momento. Intentá nuevamente más tarde.”**

## Communication Contract

Cuando el flujo incluya avisos, resumen de hallazgos, reporte de UAT o coordinación posterior:

- usá Slack **`#feedback-sites`** como canal operativo;
- no publiques datos sensibles del usuario, cliente, contrato, domicilio ni tokens;
- podés incluir el nombre de contacto sólo si es necesario para seguimiento UAT y el canal es interno;
- compartí sólo resumen accionable: portal, vista, tipo, prioridad, bloqueo, nombre de contacto, fecha y link interno de revisión si existe;
- si la prioridad es `crítica` o bloquea la prueba, marcá el aviso como urgente sin exponer información privada.

## Manual Contract

Actualizá el manual del portal con una sección breve para usuarios:

- dónde aparece **“Dejar feedback”**;
- cuándo usarlo;
- qué significa prioridad y “me impide continuar la prueba”;
- qué información se adjunta automáticamente;
- por qué se solicita nombre de contacto para poder consultar dudas de la maqueta/UAT;
- cómo se comunica internamente el seguimiento por **`#feedback-sites`** cuando aplique;
- aclaración de que el feedback ayuda a convertir comentarios de UAT en backlog.

## Validation Checklist

Antes de aprobar:

1. Build OK.
2. Login real OK.
3. El botón aparece en todas las vistas principales.
4. El comentario obligatorio se valida.
5. El `POST /api/feedback` devuelve `201` o, si el portal tiene excepción documentada, el endpoint acordado devuelve `201`.
6. Un `GET`, vista de revisión, log o consulta controlada confirma que el feedback quedó guardado.
7. El feedback incluye usuario, nombre de contacto, fecha, vista, URL y contexto aplicable.
8. Token vencido vuelve al login sin error técnico.
9. No hay mocks, JSON ni archivos locales para persistencia.
10. Deploy publicado y verificado.

## Reference

Implementación base conocida:

- Repo: `ggsoluciones-sucursal-virtual-360`
- Frontend inicial: `43c15ff feat: add uat feedback capture`
- API Gateway/Postventa inicial: `fe4345d feat: persist sv360 feedback`
- Endpoint común vigente: `POST /api/feedback`
- Alias compatible SV360: `POST /api/sucursal-virtual/feedback`
- API Gateway genérico: `4d4505e feat: add generic feedback endpoint`
- SV360 migrado al endpoint común: `ca04935 feat: use generic feedback endpoint`
- Tabla: `postventa.SucursalVirtualFeedback`
- Comunicación interna: API Comunicaciones hacia Slack `#feedback-sites`

Tomá la referencia como contrato funcional, no como copia ciega: adaptá nombres, contexto, `portal` y `origen` al portal real. La persistencia y la comunicación deben quedar centralizadas detrás del API Gateway.
