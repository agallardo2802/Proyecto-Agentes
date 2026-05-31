---
name: base.config
description: >
  Configuración global del sistema de agentes. Valores por defecto que aplican
  a todos los proyectos. Los proyectos individuales pueden sobreescribir estos valores.
type: config
---

## Autor

```
nombre: {Tu nombre}
email: {tu@email.com}
timezone: America/Argentina/Buenos_Aires
idioma: es-AR
```

## Convenciones globales

```
rama_produccion: master       ← Producción. Solo recibe merges desde develop.
rama_integracion: develop     ← Staging. Origen y destino de todas las branches hijas.
merge_strategy: squash
commit_format: conventional-commits
branch_naming: "{tipo}/AB{ID}-{descripcion-corta}"
cobertura_minima: 80
```

## Política de ramas (GitFlow GGS)

```
master  ──────────●───────────────────●──────────►  (Producción)
                  ▲                    ▲
                  │ merge release       │ merge release
                  │ (solo desde develop)│
develop ●───●────●────●───●────●───────●──────────►  (Staging)
         ▲       ▲         ▲
         │       │         │  feature/fix branches salen de develop
     feat/AB123 fix/AB456 feat/AB789  y vuelven a develop vía PR
```

Reglas no negociables:

- **`master` = Producción.** Solo recibe merges **desde `develop`**, nunca desde una branch hija.
- **`develop` = Staging.** Es el origen Y el destino de toda branch hija (feature, fix, etc.).
- **Toda branch hija sale de `develop`** y se mergea de vuelta a `develop` vía PR. NUNCA apunta a `master`.
- **`master` se actualiza solo cuando develop está validado en staging** (pipeline verde + smoke-test) — el merge develop→master dispara el release a prod.
- **Si un proyecto no tiene `develop`, el agente la crea** desde `master` antes de empezar a trabajar, y configura `develop` como branch por defecto del repo.
- **Carril de hotfix de emergencia (única excepción).** Cuando hay un incidente crítico en producción y no se puede esperar el ciclo por `develop`:
  - La branch `hotfix/AB{ID}-{desc}` sale de **`master`** (estado exacto de prod), no de `develop`.
  - Se arregla, se valida (tests + smoke) y su PR apunta a **`master`** con aprobación obligatoria (+ AppSec si toca paths sensibles).
  - El merge a `master` dispara `deploy-prod` + release (bump **patch**).
  - **Back-merge obligatorio `master → develop`** inmediatamente después, para que el fix no se pierda en la próxima release.
  - Es el ÚNICO caso donde un branch toca `master` directo, y solo se justifica por emergencia real de prod. Todo lo demás pasa por `develop`.

## Herramientas por defecto

```
board: azure-boards
vcs: repo-privado
cicd: azure-devops
```

## Credenciales

> Las credenciales NUNCA van en este archivo. Usá variables de entorno o un gestor de secretos.

| Variable de entorno | Para qué |
|---------------------|----------|
| `JIRA_BASE_URL` | URL base de Jira (ej: https://tu-org.atlassian.net) |
| `JIRA_API_TOKEN` | Token de API de Jira |
| `GITHUB_TOKEN` | Personal access token de GitHub |
| `AZURE_DEVOPS_ORG` | Organización de Azure DevOps |
| `AZURE_DEVOPS_TOKEN` | PAT de Azure DevOps |

## Memory (Engram)

```
memoria_persistente: true
proyecto_engram: {PROYECTO}       ← reemplazar al adaptar
```

Variables de entorno requeridas para Engram:

| Variable | Para qué |
|----------|---------|
| `ENGRAM_PROJECT` | Nombre del proyecto en el sistema de memoria |
| `ENGRAM_SCOPE` | Scope por defecto: `project` |

Reglas de uso:
- Toda decisión arquitectónica → `mem_save` con `type: decision`
- Todo bug resuelto → `mem_save` con `type: bugfix` (incluir causa raíz)
- Al iniciar sesión → `mem_context` para recuperar contexto previo
- Al cerrar sesión → `mem_session_summary` es obligatorio

## Notas

- Este archivo define los defaults para GGSoluciones. Si un proyecto usa GitHub o Bitbucket en lugar de el repositorio privado, sobreescribí `vcs` en su config específica.
- Los placeholders `{...}` deben reemplazarse al adaptar a un proyecto concreto.
- Las credenciales y tokens van SIEMPRE en variables de entorno — nunca en este archivo.
