---
name: pr
description: >
  Orquestador de Pull Requests. Define las reglas base de PR independientes de la plataforma
  y delega en el sub-agente de la plataforma correspondiente.
  Trigger: cuando se va a abrir un PR, preparar cambios para revisión o crear una rama nueva.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto

---

## Objetivo

Garantizar que cada Pull Request sea legible, trazable y revisable en minutos. Estas reglas son la base que toda plataforma hereda. Cada sub-agente de plataforma las aplica y agrega las convenciones específicas de su interfaz.

## Sub-agentes disponibles

| Sub-agente | Cuándo usarlo |
|------------|---------------|
| `github/` | El proyecto usa GitHub como plataforma de código |
| `bitbucket/` | El proyecto usa Bitbucket como plataforma de código |

## Árbol de decisión

```
¿El PR va a un repositorio de GitHub?
  → github/

¿El PR va a un repositorio de Bitbucket?
  → bitbucket/
```

## Escalamiento

| Situación | Acción |
|-----------|--------|
| Se necesita configurar branch protection por primera vez | Escalar a `equipo/devops/pr/{plataforma}` para que genere la configuración específica |
| El pipeline de CI/CD no está configurado | Escalar a `equipo/devops/cicd/` |
| Hay conflictos de merge que no se resuelven | Escalar a `equipo/desarrollo/dev` para que resuelva los conflictos |
| El PR requiere aprobar un feature flag o configuración | Escalar a `equipo/producto/pm` |

## Principios irrenunciables

1. **Nombre de rama obligatorio**: `{tipo}/{TICKET-XXX}-{descripcion-corta}`. Tipos válidos: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`.
2. **Título del PR**: `[TICKET-XXX] Descripción breve (máx 70 caracteres)`. Sin ticket, no hay PR.
3. **Un PR = una historia o tarea.** Nunca mezclar features no relacionadas en el mismo PR.
4. **Self-review obligatorio** antes de pedir revisión. El autor revisa su propio diff primero.
5. **Checks automáticos en verde** (lint + tests) antes de solicitar revisión humana. No se pide review sobre código roto.
6. **Squash and merge** para mantener el historial de `main` limpio y legible.
7. **Sin PR sin descripción completa.** El template es obligatorio; un PR sin descripción no se aprueba.

## Template de PR

```markdown
## ¿Qué hace este PR?
<!-- Una oración clara -->

## Ticket
<!-- TICKET-XXX -->

## Cambios principales
-
-

## Cómo probar
1.
2.

## Checklist
- [ ] Los tests pasan localmente
- [ ] No hay console.log de debug
- [ ] El código sigue las convenciones del proyecto
- [ ] El ticket está actualizado
```

## Checklist pre-apertura

- [ ] Rama creada desde `main`/`master` actualizado
- [ ] Nombre de rama sigue el formato `tipo/TICKET-descripcion`
- [ ] Commits con formato Conventional Commits
- [ ] Template de descripción completo
- [ ] Ticket vinculado y en estado "En curso"
- [ ] Tests pasando localmente
- [ ] Sin archivos de debug o `.env` incluidos

## Cómo dar feedback en review

- **Bloqueante**: el PR no puede mergearse sin resolver esto. Indicar qué está mal y por qué.
- **Sugerencia**: mejora que no bloquea. Prefijá con `nit:` o `sugerencia:`.
- **Pregunta**: si no entendés algo, preguntá antes de asumir que está mal.
- Siempre explicá el porqué técnico del comentario, no solo qué cambiar.
- Apuntá al código, no a la persona.
