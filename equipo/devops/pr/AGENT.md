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

## Política de ramas (GitFlow GGS) — target del PR

- **`master` = Producción, `develop` = Staging.**
- **Toda branch hija sale de `develop`** (`feature/`, `fix/`, etc.) y su PR apunta **SIEMPRE a `develop`**. NUNCA a `master`.
- **El único PR hacia `master` es `develop → master`**, y solo cuando develop está validado en staging (pipeline verde + smoke-test). Ese merge dispara `deploy-prod` + release.
- **Si el proyecto no tiene `develop`, crearla desde `master`** antes de abrir el primer PR y configurarla como branch por defecto del repo.

## Política GGS — PR y tablero

- **Sin commits directos a `master` ni a `develop`.** Todo cambio entra por Pull Request con al menos 1 reviewer aprobado. Sin excepciones de urgencia.
- Todo PR debe vincular al menos una Task o Bug de Azure Boards mediante `AB#`.
- Si no existe Task/Bug para el cambio, crearla antes de abrir el PR y vincular el `AB#` resultante.
- Si no se puede inferir en qué Feature/User Story debe colgar la Task/Bug, preguntar al usuario antes de crearla. No inventar parent.
- Un PR aprobado y mergeado habilita cerrar la Task correspondiente.
- Un PR de fix habilita cerrar el Bug solo después de validación.
- Un PR mergeado no cierra una User Story automáticamente: la User Story espera deploy + sign-off funcional del Analista Funcional.
- Si el PR toca varias Tasks/Bugs, explicitar cada `AB#` y por qué no se separó.
- PRs vinculados a ítems bajo la épica **GLPI · Mesa de Ayuda** llevan además `GLPI#{ID}` en la descripción para trazar el origen desde soporte N1.

## Protocolo obligatorio — PR/Merge ↔ Board

Cada vez que se abre, actualiza, completa o mergea un PR:

1. Buscar `AB#` en nombre de rama, commits, título y descripción del PR.
2. Si hay `AB#`, verificar que sea Task o Bug real y actualizarla con evidencia del PR:
   - link al PR;
   - branch;
   - resumen de cambios;
   - checks/build relevantes;
   - estado del PR: abierto, aprobado, mergeado o rechazado.
3. Si no hay `AB#`, buscar tarea relacionada por título/contexto del cambio.
4. Si existe una tarea relacionada, vincularla al PR y actualizarla.
5. Si no existe tarea relacionada, crear una Task o Bug con descripción HTML renderizable y vincularla al PR.
6. Si no se sabe bajo qué Feature/User Story crearla, preguntar al usuario y detener el flujo hasta tener parent claro.
7. Al mergear:
   - Task: cerrar (`Closed`) sólo con PR mergeado y evidencia de validación.
   - Bug: pasar a `Resolved` con PR mergeado; cerrar (`Closed`) sólo con validación de QA/usuario/Analista Funcional.
   - User Story: no cerrar por merge; requiere deploy + sign-off funcional.

## Sub-agentes disponibles

| Sub-agente | Cuándo usarlo |
|------------|---------------|
| `repo-privado/` | El proyecto usa el repositorio privado como plataforma de código |
| `github/` | El proyecto usa GitHub como plataforma de código |
| `bitbucket/` | El proyecto usa Bitbucket como plataforma de código |

## Árbol de decisión

```
¿El PR va a un repositorio de el repositorio privado?
  → repo-privado/

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
| Hay conflictos de merge que no se resuelven | Escalar a `equipo/desarrollo/dev-ggs` para que resuelva los conflictos |
| El PR requiere aprobar un feature flag o configuración | Escalar a `equipo/producto/pm` |
| El PR toca paths sensibles de seguridad | Agregar a `equipo/seguridad/appsec` como reviewer obligatorio (ver sección "Approver obligatorio de AppSec") |

## Approver obligatorio de AppSec

Un PR hacia `master`/`master` que toque alguno de estos paths requiere aprobación explícita de `equipo/seguridad/appsec` además del reviewer de código estándar:

- `**/auth/**`, `**/authentication/**`, `**/authorization/**`
- `**/identity/**`, `**/login/**`, `**/session/**`
- `**/security/**`, `**/crypto/**`
- `**/payments/**`, `**/billing/**`
- `**/webhooks/**` (entrantes)
- `**/*cors*`, `**/*csp*`, `Program.cs`, `Startup.cs`
- Migrations que agreguen/modifiquen columnas con PII o datos sensibles
- Cambios en `equipo/devops/cicd/` que afecten al security gate

Reglas duras:

- Sin aprobación de AppSec, el PR **NO** se mergea a `master`, aunque el pipeline esté en verde.
- Findings críticos/altos del guild `guilds/seguridad` bloquean merge.
- Si AppSec pide cambios, se ajusta; si justifica un waiver, se documenta con `AB#`, owner y fecha de expiración.
- La lista de paths sensibles por defecto es la anterior; cada proyecto puede ampliarla en su `config/proyectos/{proyecto}.config.md` pero NUNCA reducirla sin firma de AppSec + Arquitecto.

## Principios irrenunciables

1. **Nombre de rama obligatorio**: `{tipo}/AB#{ID}-{descripcion-corta}`. Tipos válidos: `feature`, `fix`, `chore`, `docs`, `refactor`, `test`, `release`. Ejemplos: `feature/AB#142-crear-cliente-endpoint`, `fix/AB#151-validacion-cuit-formato-invalido`.
2. **Formato de commit**: `tipo(scope): descripción AB#{ID}`. Ejemplos: `feat(clientes): agregar endpoint POST /api/clientes AB#142`, `fix(clientes): corregir validación de CUIT AB#151`. Excepciones sin `AB#`: `chore` de mantenimiento técnico puro (ej. `chore: actualizar NuGet MediatR 12.x`).
3. **Título del PR**: `[AB#{ID}] Descripción breve (máx 70 caracteres)`. Sin Task/Bug de Azure Boards, no hay PR.
4. **Un PR = una Task o Bug.** Nunca abrir PR contra una User Story genérica ni mezclar features no relacionadas.
5. **Self-review obligatorio** antes de pedir revisión. El autor revisa su propio diff primero.
6. **Checks automáticos en verde** (lint + tests) antes de solicitar revisión humana. No se pide review sobre código roto.
7. **Squash and merge** para mantener el historial de `develop` limpio y legible. El merge `develop → master` conserva el historial validado.
8. **Sin PR sin descripción completa.** El template es obligatorio; un PR sin descripción no se aprueba.
9. **Security gate + AppSec approver.** Si el PR toca paths sensibles, aprobación de `equipo/seguridad/appsec` obligatoria. El pipeline (`equipo/devops/cicd`) debe pasar `secrets-scan`, `sast`, `sca` sin findings críticos/altos sin waiver firmado.

## Template de PR

```markdown
## ¿Qué hace este PR?
<!-- Una oración clara -->

## Ticket
<!-- AB#{ID} de Task o Bug. Ej: AB#142 -->

## Cambios principales
-
-

## Autoría / trazabilidad
<!-- Indicar si hubo cambios de agente y qué agente participó -->
- Actor principal: {person:{rol/equipo} | agent:{ruta-del-agente}}
- Work item: AB#{ID}
- Marcas GGS-TRACE agregadas: {sí/no/no aplica}

## Cómo probar
1.
2.

## Impacto de seguridad
<!-- Completar siempre. Si aplica alguno, AppSec debe aprobar. -->
- Toca auth / identidad / sesión: {sí/no}
- Maneja PII / datos sensibles: {sí/no}
- Cambia política CORS / CSP / headers: {sí/no}
- Expone endpoint público nuevo: {sí/no}
- Integra sistema externo nuevo: {sí/no}
- Threat model actualizado: {sí/no/no aplica}

## Checklist
- [ ] Los tests pasan localmente
- [ ] No hay console.log de debug
- [ ] El código sigue las convenciones del proyecto
- [ ] La Task/Bug de Azure Boards está actualizada
- [ ] Si hubo cambios de agente, existe marca `GGS-TRACE` en archivos/bloques modificados
- [ ] Pipeline verde: `secrets-scan`, `sast`, `sca`, `container-scan` (si aplica)
- [ ] Checklist OWASP de `guilds/seguridad` revisado si el PR tiene impacto de seguridad
- [ ] AppSec aprobó si tocó paths sensibles
```

## Checklist pre-apertura

- [ ] Rama creada desde `develop` actualizado (branch hija). PR apunta a `develop`, nunca a `master`
- [ ] Nombre de rama sigue el formato `{tipo}/AB#{ID}-descripcion`
- [ ] Commits con formato `tipo(scope): descripción AB#{ID}`
- [ ] Template de descripción completo
- [ ] Task/Bug vinculada con `AB#` y en estado activo
- [ ] Si no existía Task/Bug, fue creada y vinculada; si faltaba parent, se preguntó al usuario
- [ ] Tests pasando localmente
- [ ] Sin archivos de debug o `.env` incluidos
- [ ] Trazabilidad `GGS-TRACE` revisada si el cambio fue hecho por un agente

## Cómo dar feedback en review

- **Bloqueante**: el PR no puede mergearse sin resolver esto. Indicar qué está mal y por qué.
- **Sugerencia**: mejora que no bloquea. Prefijá con `nit:` o `sugerencia:`.
- **Pregunta**: si no entendés algo, preguntá antes de asumir que está mal.
- Siempre explicá el porqué técnico del comentario, no solo qué cambiar.
- Apuntá al código, no a la persona.
