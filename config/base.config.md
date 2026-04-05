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
rama_principal: main
merge_strategy: squash
commit_format: conventional-commits
branch_naming: "{tipo}/{TICKET-XXX}-{descripcion-corta}"
cobertura_minima: 80
```

## Herramientas por defecto

```
board: jira
vcs: github
cicd: github-actions
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

- Este archivo define los defaults. Si un proyecto usa Bitbucket en lugar de GitHub, sobreescribí `vcs: bitbucket` en su config específica.
- Los placeholders `{...}` deben reemplazarse al adaptar a un proyecto concreto.
- Las credenciales y tokens van SIEMPRE en variables de entorno — nunca en este archivo.
