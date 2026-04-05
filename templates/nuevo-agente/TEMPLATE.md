---
name: {nombre-en-kebab-case}
description: >
  {Una línea: qué hace este agente y para qué proyecto}.
  Trigger: {cuándo debe cargarse — ser específico, con ejemplos concretos de contexto}.
license: Apache-2.0
metadata:
  author: {Tu nombre}
  version: "1.0"
  type: base | guild | skill
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - {Qué placeholders adicionales hay que reemplazar}
    - {Qué secciones necesitan información específica del proyecto}
---

## Objetivo

{1-2 oraciones: qué problema resuelve este agente y por qué importa.
Ser directo. Evitar frases genéricas como "garantizar la calidad" sin especificar cómo.}

## Sub-agentes disponibles

{Si tiene sub-agentes, listarlos. Si no, indicar "Este agente no tiene sub-agentes. Opera de forma directa."}

| Sub-agente | Cuándo usarlo |
|------------|---------------|
| `{ruta/sub-agente}` | {contexto específico} |

## Árbol de decisión

```
{La pregunta de entrada más común que dispara este agente}
  → {condición A} → {acción o sub-agente}
  → {condición B} → {acción o sub-agente}

{Segunda pregunta de ramificación}
  → {Sí} → {qué hacer}
  → {No} → {qué hacer o escalar}
```

## Escalamiento

| Situación | Acción |
|-----------|--------|
| {Cuándo este agente no puede resolver} | Escalar a `{ruta/agente}` |
| {Cuándo falta información de prerequisito} | Volver a `{ruta/agente-upstream}` |

## Principios irrenunciables

{Lista de reglas. Cada regla:
- Empieza en negrita con el principio
- Es binaria: cumple o no cumple
- Incluye el "por qué" cuando no es obvio}

- **{Principio 1}**: {descripción y razón}
- **{Principio 2}**: {descripción y razón}

## {Sección de referencia — adaptar según el tipo de agente}

{Puede ser: formato de output, estructura de carpetas, comandos, tokens CSS, plantillas, etc.
Incluir ejemplos concretos. El ejemplo correcto/incorrecto es siempre más claro que solo la regla.}

```{lenguaje}
// ✅ Correcto
{ejemplo correcto con comentario explicativo}

// ❌ Incorrecto — {razón concreta por qué está mal}
{ejemplo incorrecto}
```

## Checklist pre-entrega

{Cada item debe poder responderse con Sí/No.
Se usa al cerrar un PR, al finalizar una tarea o al hacer handoff al siguiente agente.}

- [ ] {Item verificable 1 — específico, no genérico}
- [ ] {Item verificable 2}
- [ ] {Item verificable 3}

---
<!--
GUÍA DE COMPLETADO:

name:        kebab-case, singular, descriptivo (ej: "testing-unitario", "guild-frontend-angular")
             NUNCA usar "testing" solo si ya existe — el name debe ser único en todo el sistema
description: la primera línea resume qué hace; el Trigger define CUÁNDO se activa
type:        "base"  = agente de rol reutilizable (equipo/)
             "guild" = estándar de tecnología inyectable (guilds/)
             "skill" = conocimiento específico del proyecto (skills/)
adapt:       instrucciones para quien adapte este agente a un proyecto nuevo

SECCIONES OBLIGATORIAS en todo agente:
  - Objetivo               → qué problema resuelve
  - Sub-agentes            → a quién delega (o "opera directo")
  - Árbol de decisión      → cuándo hacer qué
  - Escalamiento           → cuándo ir a otro agente
  - Principios             → reglas no negociables
  - Checklist              → criterios de "terminado"

SECCIONES OPCIONALES según tipo:
  - Agente de rol    → Formato de output, Plantillas, Workflows
  - Guild            → Stack de validación, Checklist de código
  - Regla técnica    → Ejemplos correcto/incorrecto, Comandos

TAMAÑO IDEAL: 60-150 líneas. Si superás 150, considerá dividir en dos agentes.
INYECCIONES:  Documentar qué reglas o guilds se inyectan con este agente y cuándo.
-->

