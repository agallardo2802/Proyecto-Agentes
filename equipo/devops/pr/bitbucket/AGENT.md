---
name: pr-bitbucket
description: >
  Agente de Pull Requests en Bitbucket Cloud. Hereda las reglas base de pr/AGENT.md
  y agrega las convenciones específicas de la plataforma Bitbucket.
  Trigger: cuando se abre, revisa o mergea un PR en un repositorio alojado en Bitbucket Cloud.
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

Este agente hereda todas las reglas de `equipo/devops/pr/AGENT.md`. Las reglas de esa capa son obligatorias y no se repiten acá. Este archivo solo define lo específico de Bitbucket Cloud.

## Branch permissions recomendadas

Configurar en **Repository settings → Branch permissions**.

| Branch | Permiso | Valor |
|--------|---------|-------|
| `main` / `master` | Write access | Solo vía PR (nadie pushea directo) |
| `main` / `master` | Merge via | Pull request required |
| `main` / `master` | Minimum approvals | 1 (mínimo) |
| `main` / `master` | Reset approvals on change | ✅ ON |
| `develop` | Write access | Solo vía PR |
| `release/*` | Write access | Solo el release manager |

Para configurar restricciones de merge por directorio (equivalente a CODEOWNERS), usar **Default reviewers** por path (ver más abajo).

## Smart commits con Jira

Bitbucket procesa los mensajes de commit y PR automáticamente si el workspace está integrado con Jira.

### Sintaxis

```
{TICKET-ID} #{comando} {texto}
```

### Comandos disponibles

| Comando | Efecto en Jira |
|---------|---------------|
| `#comment {mensaje}` | Agrega comentario al ticket |
| `#time {tiempo} {mensaje}` | Registra tiempo trabajado |
| `#transition {estado}` | Mueve el ticket a ese estado |

### Ejemplos concretos

```bash
# Solo comentario
git commit -m "PROJ-123 #comment Implementada la validación del formulario"

# Tiempo + comentario
git commit -m "PROJ-456 #time 2h #comment Revisión de código y tests"

# Transición de estado
git commit -m "PROJ-789 #transition In Review Subiendo PR para revisión"

# Múltiples tickets en un commit
git commit -m "PROJ-123 PROJ-456 #comment Fix aplicado a ambos tickets"
```

Regla: el ID de ticket en el nombre de rama (ej: `feat/PROJ-123-login`) genera el link automáticamente en el PR. No es necesario repetirlo en cada commit, pero sí es útil para registrar tiempo o transiciones.

## Tasks en PR

Las Tasks son checklist de revisión internos del PR. No son comentarios: tienen estado abierto/resuelto y bloquean el merge si están configuradas como obligatorias.

### Cuándo crear Tasks

- Checklist de QA que el autor debe completar antes de solicitar review
- Puntos de revisión técnica acordados con el equipo
- Pendientes documentados para no olvidar antes del merge

### Cómo agregarlas

En la UI de Bitbucket: **PR → Add task** (desde cualquier comentario o desde el panel lateral).

```
☐ Tests unitarios agregados para el nuevo endpoint
☐ Variables de entorno documentadas en el README
☐ El PR referencia el ticket PROJ-123
☐ Probado en ambiente local con datos reales
```

Para hacer obligatorias las Tasks antes del merge: **Repository settings → Pull requests → Tasks must be complete before merge**.

## Diff comments: inline vs general

| Tipo | Cuándo usarlo |
|------|---------------|
| **Inline** | El comentario aplica a una línea o bloque específico del código. Siempre preferir este sobre el general para feedback técnico. |
| **General** | El comentario aplica al PR completo, no a una línea en particular. Ej: "El enfoque general no me convence por X motivo". |

Regla: el 90% de los comentarios de revisión deben ser inline. Un comentario general sin referencia a código concreto es vago y difícil de resolver.

## Merge strategies

Configurar la estrategia default en **Repository settings → Pull requests → Merge strategies**.

| Estrategia | Cuándo usarla | Historial resultante |
|-----------|---------------|---------------------|
| **Merge commit** | Feature branches largos con múltiples desarrolladores. Preserva la historia completa de la rama. | Muestra el merge como un commit explícito en main |
| **Squash** | Feature branches de un solo developer. Historial limpio en main. | Un único commit en main con todos los cambios |
| **Fast-forward** | Solo si la rama no divergió de main. Sin commits de merge. | Historia lineal, como si los commits fueran directos en main |

**Recomendación del equipo**: Squash como default. Un PR = un commit en main. Si necesitás ver el historial detallado, está en la rama antes del merge.

Cómo forzar squash para el proyecto:
**Repository settings → Pull requests → Default merge strategy → Squash**.

## Default reviewers por directorio

Equivalente a CODEOWNERS de GitHub. Configurar en **Repository settings → Default reviewers**.

Regla: cuando un PR modifica archivos en esa ruta, los reviewers asignados reciben notificación automática.

| Path | Reviewer asignado |
|------|------------------|
| `src/auth/**` | @backend-auth-lead |
| `src/payments/**` | @payments-team |
| `*.yml` / `*.yaml` | @devops-team |
| `src/ui/**` | @frontend-lead |

Bitbucket Cloud permite configurar esto por path con la interfaz de Default Reviewers. Aplica a todos los PRs del repositorio.
