---
name: ejemplo.config
description: >
  Config de ejemplo para un proyecto. Copiar este archivo, renombrarlo a
  {nombre-proyecto}.config.md y completar los valores.
type: config
proyecto: ejemplo
---

## Proyecto

```
nombre: Mi Proyecto
repo: owner/nombre-repo
stack: React + Node.js + PostgreSQL
```

## Board

```
herramienta: jira
url_base: https://mi-org.atlassian.net
project_key: PROJ
sprint_naming: "Sprint {numero} — {YYYY-MM-DD}"
```

## VCS

```
herramienta: github
repo: owner/nombre-repo
rama_principal: main
rama_develop: develop
```

## CI/CD

```
herramienta: github-actions
deploy_staging: push a develop
deploy_prod: push a main (con aprobación manual)
```

## Ambientes

```
local:    http://localhost:3000
staging:  https://staging.mi-proyecto.com
prod:     https://mi-proyecto.com
```

## Fuentes de verdad

| Qué buscar | Dónde está |
|-----------|-----------|
| Tokens CSS | `src/styles/tokens.css` |
| Estructura principal | `src/App.tsx` |
| Lógica de negocio | `src/services/` |
| Variables de entorno | `.env.example` |

## Herramientas y credenciales

> Ver `config/base.config.md` para las variables de entorno requeridas.
> No escribir valores reales aquí — solo referencias a las variables.

| Recurso | Variable de entorno |
|---------|---------------------|
| Jira | `JIRA_BASE_URL`, `JIRA_API_TOKEN` |
| GitHub | `GITHUB_TOKEN` |
