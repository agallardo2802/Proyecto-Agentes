---
name: pr-repo-privado
description: >
  Agente de Pull Requests en el repositorio privado. Hereda las reglas base de pr/AGENT.md
  y agrega las convenciones específicas de Azure DevOps Repos para GGSoluciones.
  Trigger: cuando se abre, revisa, completa o mergea un PR en un repositorio alojado en el repositorio privado.
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

Este agente hereda todas las reglas de `equipo/devops/pr/AGENT.md`. La regla central no cambia: **un PR se vincula a una Task o Bug con `AB#`, nunca a una User Story genérica**.

## Política GGS — el repositorio privado + Azure Boards

- Todo PR debe incluir al menos un `AB#` de Task o Bug.
- Si el PR no trae `AB#`, buscar tarea relacionada; si no existe, crearla antes de continuar.
- Si no se puede inferir el parent correcto para la nueva Task/Bug, preguntar al usuario y no inventar Feature/User Story.
- La rama debe seguir el formato `{tipo}/AB{ID}-{descripcion-corta}`.
- El título del PR debe seguir el formato `[AB#{ID}] {descripción breve}`.
- El PR aprobado con checks verdes deja la Task en `Resolved`.
- El PR mergeado deja la Task en `Closed`.
- Para Bugs, el merge deja el Bug en `Resolved`; el cierre `Closed` requiere validación de quien reportó, QA o Analista Funcional según impacto.
- Ningún PR cierra una User Story. La User Story cierra solo con deploy + sign-off funcional del Analista Funcional.

## Sincronización obligatoria con Azure Boards

Al abrir, actualizar, completar o mergear un PR en el repositorio privado:

1. Leer work items vinculados del PR y buscar `AB#` en branch, commits, título y descripción.
2. Si no hay vínculo, resolver o crear Task/Bug antes de pedir review.
3. Actualizar el work item con:
   - URL del PR;
   - branch origen/destino;
   - commit o squash commit;
   - evidencia de build/checks;
   - resultado del merge si aplica.
4. Si se crea work item nuevo, debe quedar bajo parent correcto. Si el parent no es evidente, preguntar al usuario.
5. No completar el PR si no quedó una Task/Bug real vinculada y actualizada.

## Branch policies recomendadas

Configurar en **Project Settings → Repositories → {repo} → Policies**.

| Política | Valor recomendado | Motivo |
|----------|-------------------|--------|
| Require a minimum number of reviewers | 1 mínimo | Todo cambio pasa por revisión humana |
| Reset code reviewer votes when there are new changes | ON | Nuevos commits invalidan aprobaciones viejas |
| Check for linked work items | Required | Sin `AB#`, no hay trazabilidad |
| Check for comment resolution | Required | No se mergea con conversaciones abiertas |
| Limit merge types | Squash merge | Historial limpio en `master`/`master` |
| Build validation | Required | CI verde antes de merge |
| Automatically included reviewers | Por path/equipo | CODEOWNERS equivalente en el repositorio privado |

## Flujo de PR

```text
Task/Bug Active
  → rama creada tipo/AB{ID}-descripcion
  → commits con AB#{ID}
  → PR abierto en el repositorio privado
  → reviewers + build validation
  → comentarios resueltos
  → aprobación + checks verdes
  → Task Resolved
  → squash merge
  → Task Closed
```

Para Bug:

```text
Bug Active
  → PR con fix
  → aprobación + checks verdes
  → merge
  → Bug Resolved
  → validación funcional/QA
  → Bug Closed
```

## Template de PR para el repositorio privado

```markdown
## ¿Qué hace este PR?
{Una oración clara y concreta}

## Work item
AB#{ID de Task o Bug}

## Tipo
{feat | fix | chore | docs | refactor | test}

## Cambios principales
- {cambio 1}
- {cambio 2}

## Autoría / trazabilidad
- Actor principal: {person:{rol/equipo} | agent:{ruta-del-agente}}
- Work item: AB#{ID}
- Marcas GGS-TRACE agregadas: {sí/no/no aplica}

## Cómo probar
1. {paso verificable}
2. {paso verificable}

## Impacto
- Área afectada: {Backend | Frontend | Mobile | DB | Infra | BI | otra}
- Riesgo: {bajo | medio | alto}
- Feature/User Story padre: AB#{ID si aplica}

## Checklist
- [ ] PR vinculado a Task/Bug con AB#
- [ ] La rama sigue `tipo/AB{ID}-descripcion`
- [ ] Los commits referencian AB#
- [ ] Checks automáticos en verde
- [ ] Self-review realizado
- [ ] No hay secretos, `.env` ni archivos de debug
- [ ] La Task/Bug fue actualizada con evidencia o nota de prueba si aplica
- [ ] Si hubo cambios de agente, existe marca `GGS-TRACE` en archivos/bloques modificados
```

## Completion options

Al completar el PR:

- Usar **Squash commit** como estrategia por defecto.
- Activar **Delete source branch** salvo ramas compartidas justificadas.
- Usar **Complete associated work items after merging** solo para Tasks. Para Bugs, usarlo con cuidado: si falta validación, dejar el Bug en `Resolved`, no `Closed`.
- No activar cierre automático de User Stories desde PR.

## Comentarios de review

| Tipo | Cuándo usarlo |
|------|---------------|
| Bloqueante | Rompe funcionalidad, seguridad, arquitectura, tests o contrato |
| Sugerencia | Mejora no obligatoria |
| Pregunta | Falta contexto o hay ambigüedad |

Regla: todo comentario técnico debe explicar el **porqué**, no solo pedir un cambio. Un comentario sin fundamento técnico es ruido.

## Escalamiento

| Situación | Acción |
|-----------|--------|
| Falta work item vinculado | Bloquear PR hasta agregar `AB#` de Task/Bug |
| El PR apunta a User Story | Devolver: crear/vincular Task o Bug |
| El PR declara cambios de agente sin `GGS-TRACE` | Bloquear hasta agregar marca en archivo/bloque o justificar `no aplica` |
| Falla build validation | Volver a `equipo/desarrollo/dev-ggs` o guild correspondiente |
| Hay cambio de arquitectura | Inyectar `equipo/producto/arquitecto` antes de aprobar |
| Hay cambio funcional no cubierto por AC | Volver a `equipo/producto/analista` |
| El PR mezcla varias Tasks/Bugs | Exigir justificación o separar PRs |
