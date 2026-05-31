---
name: chatbot-web
description: "Trigger: chatbot, chat, asistente, conversación, mensajes. Crear interfaces conversacionales para portales internos de GGSoluciones."
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
---

# Chatbot Web - Estándar GGSoluciones

## Activation Contract

Usá esta skill cuando el usuario pida un chatbot, asistente conversacional, panel de mensajes, soporte interno o experiencia de chat embebida en un portal.

No la uses para formularios tradicionales, tickets o reportes si no hay interacción conversacional.

## Hard Rules

- Diseñá el chat como herramienta operativa, no como demo visual.
- Mostrá estados claros: vacío, escribiendo, respuesta parcial, error, reconexión y sin permisos.
- Nunca muestres tokens, prompts internos, stack traces ni nombres técnicos de servicios.
- Separá mensajes de usuario, asistente y sistema con jerarquía visual consistente.
- Todo mensaje automático debe explicar qué pasó y qué puede hacer el usuario.
- Si hay streaming, permití cancelar o reintentar sin duplicar mensajes.
- Incluí accesibilidad: foco visible, `aria-live` para respuestas y navegación por teclado.

## Decision Gates

| Caso | Decisión |
|---|---|
| Chat simple de soporte | Layout de una columna con historial y composer fijo |
| Chat dentro de portal operativo | Panel lateral o drawer, sin bloquear la tarea principal |
| Respuestas con datos sensibles | Mostrar fuente, fecha y alcance del dato |
| Error del modelo/API | Mensaje humano + acción de reintento, nunca error técnico crudo |

## Execution Steps

1. Definí el objetivo del asistente y qué NO puede hacer.
2. Diseñá historial, composer, acciones rápidas y estados vacíos.
3. Agregá indicadores de carga/streaming y manejo de errores.
4. Validá contraste claro/oscuro con tokens GGSoluciones.
5. Documentá permisos, límites y datos usados por el asistente.

## Output Contract

Entregar estructura UI, estados requeridos, copy de errores, criterios de accesibilidad y notas de integración.
