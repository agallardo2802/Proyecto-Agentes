# 11 - CI/CD Pipeline

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Que es CI/CD y por que es importante
- Estructura basica de un pipeline
- Las etapas de un pipeline tipico
- Como configurar deployment automatico

---

## Que es CI/CD

### CI - Continuous Integration

Integrar cambios de codigo frecuentemente al repositorio principal, verificando automaticamente que el codigo compila y pasa los tests.

```
Desarrollador → Commit → Build → Test → Reporte
```

### CD - Continuous Delivery/Deployment

Automatizar el release del software, permitiendo deployments rapidos y confiables.

```
Test → Staging → Produccion
```

---

## Pipeline Tipico

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  Build   │ → │  Test    │ → │  Stage   │ → │  Prod    │ → │  Monitor │
│          │   │          │   │          │   │          │   │          │
│ compile  │   │ unit     │   │ deploy   │   │ deploy   │   │ health   │
│ bundle   │   │ e2e      │   │ smoke    │   │ rollback │   │ alerts   │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
```

---

## Etapas del Pipeline

### 1. Checkout

```yaml
# Obtener el codigo
- uses: actions/checkout@v4
```

### 2. Setup

```yaml
# Instalar dependencias
- uses: actions/setup-node@v4
  with:
    node-version: '20'
```

### 3. Build

```yaml
# Compilar y crear bundle
- run: npm ci
- run: npm run build
```

### 4. Test

```yaml
# Tests unitarios
- run: npm test

# Coverage
- run: npm run test:coverage

# Tests de integracion
- run: npm run test:e2e
```

### 5. Security Scan

```yaml
# Secret scanning
- uses: trufflesecurity/trufflehog@main

# SAST
- uses: github/codeql-action/analyze@v2

# SCA (dependencies)
- uses: snyk/actions/node@master
```

### 6. Deploy

```yaml
# Deploy a staging
- run: ./deploy.sh staging

# Deploy a prod (solo si es master)
- if: github.ref == 'refs/heads/master'
  run: ./deploy.sh prod
```

---

## GitHub Actions - Estructura

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [master, develop]
  pull_request:
    branches: [master]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm test
      - run: npm run lint

  deploy:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/master'
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh production
```

---

## Azure DevOps - Estructura

```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
      - master

stages:
  - stage: Build
    jobs:
      - job: BuildAndTest
        pool:
          vmImage: ubuntu-latest
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: '20'
          - script: npm ci
          - script: npm test
          - script: npm run build

  - stage: Deploy_Staging
    dependsOn: Build
    jobs:
      - deployment: DeployStaging
        environment: 'staging'
        strategy:
          runOnce:
            deploy:
              steps:
                - script: ./deploy.sh staging

  - stage: Deploy_Prod
    dependsOn: Deploy_Staging
    condition: succeeded()
    jobs:
      - deployment: DeployProd
        environment: 'production'
        strategy:
          runOnce:
            deploy:
              steps:
                - script: ./deploy.sh prod
```

---

## Environments

### GitHub Actions

```yaml
environments:
  staging:
    url: https://staging.ggsoluciones.com
    reviewers:
      - team-backend

  production:
    url: https://ggsoluciones.com
    reviewers:
      - team-backend
      - team-lead
    required_reviewers: 1
```

### Azure DevOps

```yaml
environments:
  - name: staging
    resource type: URL
  - name: production
    resource type: URL
    approvals:
      - approver: team-lead
```

---

## Secrets y Variables

### GitHub Actions

```yaml
steps:
  - run: npm run deploy
    env:
      API_KEY: ${{ secrets.API_KEY }}
      DB_HOST: ${{ vars.DB_HOST }}
```

### Azure DevOps

```yaml
variables:
  - group: production-secrets

steps:
  - script: npm run deploy
    env:
      DB_PASSWORD: $(DB_PASSWORD)
```

---

## Resumen

| Concepto | Descripcion |
|----------|-------------|
| CI | Integrar cambios frecuentemente + tests automaticos |
| CD | Automatizar release a staging/prod |
| Pipeline | Secuencia de etapas automatizadas |
| Stages | Build → Test → Deploy |
| Environments | Staging, Production |
| Secrets | Credenciales fuera del codigo |

---

## Siguiente Capitulo

Continuar con: [12-Board-Workflow](../04-proyecto-real/01-board-workflow.md)

## Recursos

- `equipo/devops/cicd/github-actions/` — guia GitHub Actions
- `equipo/devops/cicd/azure-devops/` — guia Azure DevOps
