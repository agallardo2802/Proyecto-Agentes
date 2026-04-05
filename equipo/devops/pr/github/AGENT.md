---
name: pr-github
description: >
  Agente de Pull Requests en GitHub. Hereda las reglas base de pr/AGENT.md
  y agrega las convenciones específicas de la plataforma GitHub.
  Trigger: cuando se abre, revisa o mergea un PR en un repositorio alojado en GitHub.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - Configurar la URL base en config/proyectos/{proyecto}.config.md
---

## Herencia

Este agente hereda todas las reglas de `equipo/devops/pr/AGENT.md`. Las reglas de esa capa son obligatorias y no se repiten acá. Este archivo solo define lo específico de GitHub.

## Configuración recomendada del repo

Branch protection en `main`/`master`. Configurar en **Settings → Branches → Branch protection rules**.

| Regla | Valor recomendado | Motivo |
|-------|-------------------|--------|
| Require a pull request before merging | ✅ ON | Nadie pushea directo a main |
| Required approvals | Mínimo 1 | Al menos un par revisa |
| Dismiss stale pull request approvals | ✅ ON | Nuevo commit invalida aprobaciones previas |
| Require status checks to pass | ✅ ON | GitHub Actions en verde antes de merge |
| Require branches to be up to date | ✅ ON | Sin fast-forward sobre código viejo |
| Restrict who can push to matching branches | Equipo definido | Evita pushes accidentales |
| Include administrators | ✅ ON | Las reglas aplican a todos, sin excepción |

## Labels

Crear estos labels en **Settings → Labels**. Son obligatorios para poder filtrar y reportar.

| Label | Color | Cuándo aplicarlo |
|-------|-------|-----------------|
| `feat` | `#0075ca` | PR que agrega nueva funcionalidad |
| `fix` | `#e4e669` | PR que corrige un bug |
| `chore` | `#cfd3d7` | Infraestructura, deps, configuración, sin cambio funcional |
| `breaking-change` | `#b60205` | El PR rompe compatibilidad hacia atrás |
| `needs-review` | `#fbca04` | PR listo para revisión humana |
| `wip` | `#f9d0c4` | Trabajo en progreso, no está listo para merge |

Regla: todo PR tiene exactamente un label de tipo (`feat`, `fix`, `chore`) y puede tener labels adicionales de estado.

## Draft PR

Usá Draft PR para trabajo en progreso. Nunca pongas `wip` en el título ni bloqueés reviews con comentarios informales.

```bash
# Crear PR directamente como draft
gh pr create --draft --title "[TICKET-123] Descripción" --body "$(cat .github/PULL_REQUEST_TEMPLATE.md)"
```

Un Draft PR:
- No puede mergearse accidentalmente
- Sí puede recibir comentarios tempranos
- Se convierte a "Ready for review" cuando el autor lo marca listo

**Cuándo usar Draft**: desde el primer commit si el trabajo va a durar más de un día o si querés feedback temprano sobre el enfoque.

## Linkear PR a Issue

Incluir en la descripción del PR para cerrar el issue automáticamente al mergear:

```
Closes #123
Fixes #456
Resolves #789
```

- `Closes` y `Fixes` son equivalentes. Usá el que te resulte más natural.
- Solo funciona en PRs mergeados a la rama default del repo.
- Si el issue está en otro repo: `Closes owner/repo#123`.

## GitHub Actions — check obligatorio antes de merge

El status check requerido debe ser el nombre exacto del job en el workflow YAML.

```yaml
# En el workflow de CI
jobs:
  ci:
    name: CI  # <-- este nombre exacto va en branch protection
```

En **Settings → Branches → Required status checks**, agregar: `CI` (o el nombre exacto del job). Si el check no aparece en la lista, ejecutar el workflow al menos una vez desde esa rama primero.

## Flujo de revisión en GitHub

### Cuándo usar cada tipo de review

| Acción | Cuándo | Efecto |
|--------|--------|--------|
| **Comment** | Tenés una pregunta o duda. No bloqueás el merge. | Sin estado, solo comentario |
| **Request changes** | Encontraste algo que DEBE resolverse antes del merge. | Bloquea el merge hasta que el autor responda |
| **Approve** | El PR está listo. Podés tener nits pendientes, no bloqueantes. | Suma al conteo de aprobaciones requeridas |

Regla: nunca uses "Approve" si hay algo que genuinamente te preocupa. Usá "Request changes" y explicá el porqué técnico.

### Responder a Request changes

El autor responde cada comentario con:
- `Done` si lo implementó
- `Agreed, but in a follow-up ticket #XXX` si es deuda técnica legítima
- `Disagree: [razón técnica]` si no está de acuerdo — esto abre una conversación, no se ignora

Una vez respondidos todos los comentarios, el autor re-solicita review con el botón **Re-request review**.

## Reviewers

- Asignar al menos 1 reviewer del área del código modificado (ejemplo: si tocás `src/auth/`, asignar a alguien del equipo de auth).
- Usar CODEOWNERS para asignación automática:

```
# .github/CODEOWNERS
src/auth/       @equipo/backend-auth
src/payments/   @equipo/backend-payments
src/ui/         @equipo/frontend
*.yml           @equipo/devops
```

- No asignar más de 2 reviewers por PR. Más revisores no garantizan mejor revisión; diluyen la responsabilidad.

## Milestones

Agrupar PRs por release usando Milestones en **Issues → Milestones**.

Naming convention: `v{semver}` — ejemplos: `v1.2.0`, `v2.0.0-beta`.

```bash
# Asignar milestone desde CLI
gh pr edit 123 --milestone "v1.2.0"
```

- Crear el milestone antes de empezar el sprint o ciclo de release.
- Todos los PRs de un release van al mismo milestone.
- Al mergear el último PR del milestone, crear el tag de release correspondiente.

## Comandos útiles (gh cli)

```bash
# Crear PR con template
gh pr create --title "[TICKET-123] Descripción" --body-file .github/PULL_REQUEST_TEMPLATE.md

# Crear PR como draft
gh pr create --draft --title "[TICKET-123] WIP: Descripción"

# Listar PRs pendientes de mi review
gh pr list --search "review-requested:@me"

# Ver estado de checks de un PR
gh pr checks 123

# Mergear con squash (método por defecto del equipo)
gh pr merge 123 --squash --delete-branch

# Asignar reviewers
gh pr edit 123 --add-reviewer usuario1,usuario2

# Agregar label
gh pr edit 123 --add-label "feat,needs-review"

# Convertir draft a ready
gh pr ready 123

# Ver PR en el browser
gh pr view 123 --web
```
