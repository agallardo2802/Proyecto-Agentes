---
name: cicd-github-actions
description: >
  Agente GitHub Actions. Hereda la estructura base de CI/CD de cicd/AGENT.md
  e implementa las etapas obligatorias en GitHub Actions.
  Trigger: cuando se configura, depura o extiende un workflow de GitHub Actions.
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

Este agente hereda todas las reglas de `equipo/devops/cicd/AGENT.md`. Las etapas obligatorias (lint → test → build → deploy-staging → smoke-test → deploy-prod) y los principios irrenunciables aplican sin excepción. Este archivo define cómo implementarlas en GitHub Actions.

## Estructura de workflow YAML

```
.github/
  workflows/
    ci.yml          # lint + test + build (en cada PR y push)
    deploy.yml      # deploy-staging y deploy-prod (solo en main)
```

Campos obligatorios de todo workflow:

| Campo | Propósito |
|-------|-----------|
| `name` | Nombre legible. Aparece en la UI y en los status checks. |
| `on` | Triggers que disparan el workflow. |
| `jobs` | Uno o más jobs. Cada job corre en un runner separado. |
| `jobs.{id}.runs-on` | Tipo de runner. Usar `ubuntu-latest` por defecto. |

## Triggers recomendados

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:      # permite ejecución manual desde la UI
```

- `pull_request`: corre CI en cada PR. No deploya.
- `push` a `main`: corre CI y dispara el deploy.
- `workflow_dispatch`: útil para re-deploy manual o rollback sin tener que pushear código.

## Workflow base completo

```yaml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run lint

  test:
    name: Test
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm test -- --coverage
      - uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

  build:
    name: Build
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: dist-${{ github.sha }}
          path: dist/

  deploy-staging:
    name: Deploy Staging
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'   # solo en main, no en PRs
    environment: staging
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: dist-${{ github.sha }}
          path: dist/
      - name: Deploy a staging
        run: ./scripts/deploy.sh staging
        env:
          DEPLOY_TOKEN: ${{ secrets.STAGING_DEPLOY_TOKEN }}

  deploy-prod:
    name: Deploy Production
    runs-on: ubuntu-latest
    needs: deploy-staging
    if: github.ref == 'refs/heads/main'
    environment: production              # este environment tiene required reviewers
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: dist-${{ github.sha }}
          path: dist/
      - name: Deploy a producción
        run: ./scripts/deploy.sh production
        env:
          DEPLOY_TOKEN: ${{ secrets.PROD_DEPLOY_TOKEN }}
```

## Secrets

- Nunca hardcodear secrets en el YAML. Sin excepciones.
- Referenciar siempre como `${{ secrets.NOMBRE_DEL_SECRET }}`.
- Crear en **Settings → Secrets and variables → Actions**.
- Para secrets compartidos entre repos: usar **Organization secrets**.
- Para secrets de un ambiente específico: usar **Environment secrets** (más seguro, solo disponibles en ese environment).

```yaml
# Correcto
env:
  API_KEY: ${{ secrets.API_KEY }}

# Incorrecto — nunca esto
env:
  API_KEY: "sk-1234abcd"
```

## Caché de dependencias

Usar `actions/setup-node` con `cache: 'npm'` (o `'yarn'`, `'pnpm'`). Cachea automáticamente `node_modules`.

```yaml
# npm
- uses: actions/setup-node@v4
  with:
    node-version: 20
    cache: 'npm'

# pnpm
- uses: pnpm/action-setup@v3
  with:
    version: 9
- uses: actions/setup-node@v4
  with:
    node-version: 20
    cache: 'pnpm'

# caché manual para otros casos
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

## Artefactos

```yaml
# Publicar artefacto (en el job que genera el output)
- uses: actions/upload-artifact@v4
  with:
    name: dist-${{ github.sha }}   # nombre único por commit
    path: dist/
    retention-days: 7              # no acumular artefactos indefinidamente

# Consumir artefacto (en el job siguiente)
- uses: actions/download-artifact@v4
  with:
    name: dist-${{ github.sha }}
    path: dist/
```

Regla: nombrar artefactos con el SHA del commit (`${{ github.sha }}`). Trazabilidad completa de qué código generó qué artefacto.

## Environments: staging y production

Configurar en **Settings → Environments**.

| Environment | Required reviewers | Wait timer |
|-------------|-------------------|------------|
| `staging` | Ninguno | 0 min |
| `production` | 1 (tech lead o responsable del deploy) | Opcional |

El `environment: production` en el job bloquea la ejecución hasta que un reviewer apruebe desde la UI. Es la aprobación manual antes de desplegar a prod.

## Matrices de versión

Usá matrices cuando necesitás garantizar compatibilidad con múltiples versiones de Node, Python, etc.

```yaml
jobs:
  test:
    strategy:
      matrix:
        node-version: [18, 20, 22]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      - run: npm ci && npm test
```

Cuándo usar matrices: librerías y paquetes públicos que deben soportar múltiples versiones. En aplicaciones, usar la versión exacta del proyecto y punto.

## Reutilización con workflow_call y composite actions

### workflow_call — reutilizar un workflow completo

```yaml
# .github/workflows/ci-reusable.yml
on:
  workflow_call:
    inputs:
      node-version:
        required: true
        type: string
    secrets:
      DEPLOY_TOKEN:
        required: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ inputs.node-version }}
```

```yaml
# Llamarlo desde otro workflow
jobs:
  call-ci:
    uses: ./.github/workflows/ci-reusable.yml
    with:
      node-version: '20'
    secrets:
      DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
```

### Composite action — reutilizar steps

```yaml
# .github/actions/setup-project/action.yml
name: Setup project
description: Checkout + install + cache en un solo step
runs:
  using: composite
  steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: 20
        cache: 'npm'
    - run: npm ci
      shell: bash
```

```yaml
# Usar la composite action
steps:
  - uses: ./.github/actions/setup-project
  - run: npm run lint
```

## Patrones comunes

### Deploy condicional solo en main

```yaml
deploy-prod:
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
```

### Cancelar runs anteriores en el mismo PR

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

### Notificar en Slack si el deploy a prod falla

```yaml
- name: Notificar fallo en prod
  if: failure()
  run: |
    curl -X POST ${{ secrets.SLACK_WEBHOOK }} \
      -H 'Content-type: application/json' \
      --data '{"text":"Deploy a producción falló en ${{ github.sha }}"}'
```
