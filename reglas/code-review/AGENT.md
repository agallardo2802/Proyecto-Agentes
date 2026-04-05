---
name: code-review
description: >
  Reglas para dar y recibir code reviews de forma constructiva y efectiva.
  Trigger: cuando se revisa un PR, se da feedback o se reciben comentarios de revisión.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/devops/pr/github/` — siempre
- `equipo/devops/pr/bitbucket/` — siempre
- `equipo/desarrollo/dev/` — cuando se abre o revisa un PR

## Objetivo

El code review es la herramienta más poderosa del equipo para mantener calidad y compartir conocimiento. No es para demostrar quién sabe más — es para que el código sea mejor.

## Reglas para el REVISOR

1. **Revisar el código, no a la persona** — nunca "vos hiciste mal esto", siempre "este enfoque tiene un problema porque..."
2. **Formato de comentarios**:
   - `[obligatorio]` — debe corregirse antes de mergear
   - `[sugerencia]` — mejora recomendada, el autor decide
   - `[pregunta]` — duda genuina, no crítica
3. **Explicar el POR QUÉ** — nunca "cambiá esto" sin explicación técnica
4. **Máximo 20 comentarios por PR** — si hay más problemas, rechazarlo y pedir refactor antes
5. **Aprobar si pasa el estándar** — no bloquear por preferencias personales de estilo
6. **Reconocer lo bueno** — si algo está bien hecho, decirlo

## Reglas para el AUTOR

1. **Self-review antes de pedir revisión** — revisar tu propio diff primero
2. **PR pequeños** — máximo 400 líneas de cambio; si es más grande, dividir
3. **Contexto en la descripción** — el revisor no tiene tu contexto mental
4. **Responder todos los comentarios** — nunca silencio; al menos "aplicado" o "discutido en daily"
5. **No tomar los comentarios personalmente** — el código no es tu identidad

## Checklist del revisor

- [ ] ¿El código hace lo que dice el ticket?
- [ ] ¿Los tests cubren los casos nuevos?
- [ ] ¿Hay lógica de negocio sin tests?
- [ ] ¿Hay secrets o credenciales en el código?
- [ ] ¿Hay empty catch que silencian errores?
- [ ] ¿Los nombres son claros y consistentes con el proyecto?
- [ ] ¿Hay console.log de debug olvidados?

## Ejemplo de comentario correcto

```
[obligatorio] línea 47 — este fetch no tiene try/catch.
Si la API falla, la UI quedará congelada sin feedback al usuario.
Ver agente error-handling, regla 1.

[sugerencia] línea 83 — podrías usar Promise.all aquí para ejecutar
ambos fetches en paralelo y reducir el tiempo de carga a la mitad.
```
