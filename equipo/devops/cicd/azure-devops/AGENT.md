---
name: cicd-azure-devops
description: >
  Agente Azure DevOps Pipelines. Hereda la estructura base de CI/CD de cicd/AGENT.md
  e implementa las etapas obligatorias en Azure DevOps Pipelines.
  Trigger: cuando se configura, depura o extiende un pipeline en Azure DevOps.
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

Este agente hereda todas las reglas de `equipo/devops/cicd/AGENT.md`. Las etapas obligatorias (lint → test → build → deploy-staging → smoke-test → deploy-prod) y los principios irrenunciables aplican sin excepción. Este archivo define cómo implementarlas en Azure DevOps Pipelines.

## Estructura de azure-pipelines.yml

El archivo vive en la raíz del repositorio. Un solo archivo puede tener múltiples stages.

```
raíz-del-repo/
  azure-pipelines.yml          # pipeline principal
  pipelines/
    templates/
      build-steps.yml          # steps reutilizables
      deploy-steps.yml         # steps de deploy parametrizados
```

Campos de alto nivel:

| Campo | Propósito |
|-------|-----------|
| `trigger` | Branches que disparan el pipeline automáticamente |
| `pr` | Branches que disparan el pipeline en un PR |
| `pool` | Tipo de agente (Microsoft-hosted o self-hosted) |
| `variables` | Variables a nivel pipeline o por stage |
| `stages` | Lista de stages. Cada stage tiene jobs, cada job tiene steps. |

## Pipeline YAML base completo

```yaml
trigger:
  branches:
    include:
      - main

pr:
  branches:
    include:
      - main

pool:
  vmImage: ubuntu-latest

variables:
  NODE_VERSION: '20'
  BUILD_ARTIFACT: 'dist-$(Build.SourceVersion)'

stages:
  - stage: CI
    displayName: Integración continua
    jobs:
      - job: Lint
        displayName: Lint
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: $(NODE_VERSION)
          - script: npm ci
            displayName: Instalar dependencias
          - script: npm run lint
            displayName: Ejecutar lint

      - job: Test
        displayName: Test
        dependsOn: Lint
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: $(NODE_VERSION)
          - script: npm ci && npm test -- --coverage
            displayName: Ejecutar tests
          - task: PublishTestResults@2
            inputs:
              testResultsFiles: '**/junit.xml'
          - task: PublishCodeCoverageResults@2
            inputs:
              codeCoverageTool: Cobertura
              summaryFileLocation: coverage/cobertura-coverage.xml

      - job: Build
        displayName: Build
        dependsOn: Test
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: $(NODE_VERSION)
          - script: npm ci && npm run build
            displayName: Compilar
          - task: PublishBuildArtifacts@1
            inputs:
              PathtoPublish: dist
              ArtifactName: $(BUILD_ARTIFACT)

  - stage: DeployStaging
    displayName: Deploy Staging
    dependsOn: CI
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: DeployToStaging
        displayName: Deploy a staging
        environment: staging
        strategy:
          runOnce:
            deploy:
              steps:
                - template: pipelines/templates/deploy-steps.yml
                  parameters:
                    environment: staging
                    artifactName: $(BUILD_ARTIFACT)

  - stage: DeployProd
    displayName: Deploy Producción
    dependsOn: DeployStaging
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: DeployToProd
        displayName: Deploy a producción
        environment: production         # este environment tiene approvals configurados
        strategy:
          runOnce:
            deploy:
              steps:
                - template: pipelines/templates/deploy-steps.yml
                  parameters:
                    environment: production
                    artifactName: $(BUILD_ARTIFACT)
```

## Variable groups vs Key Vault

### Variable groups (para variables no secretas o secretas internas)

Crear en **Pipelines → Library → Variable groups**.

```yaml
variables:
  - group: mi-proyecto-staging    # nombre del variable group
  - name: NODE_VERSION
    value: '20'
```

### Azure Key Vault (para secrets de producción)

Vincular un Key Vault a un variable group en Library. Azure DevOps importa los secrets como variables.

```yaml
variables:
  - group: mi-proyecto-keyvault   # variable group vinculado al Key Vault
```

| Criterio | Variable group | Key Vault |
|----------|---------------|-----------|
| Secrets de baja criticidad (staging) | ✅ | — |
| Secrets de producción | — | ✅ |
| Auditoría y rotación automática | — | ✅ |
| Sin costo adicional de configuración | ✅ | — |

Regla: toda variable que se use en el stage de producción va a Key Vault. No hay excepciones.

Referenciar variables en steps:

```yaml
- script: echo "Deployando con token..."
  env:
    DEPLOY_TOKEN: $(DEPLOY_TOKEN)   # viene del Key Vault via variable group
```

## Approvals en environments

Configurar en **Pipelines → Environments → {environment} → Approvals and checks**.

| Environment | Check | Configuración |
|-------------|-------|---------------|
| `staging` | Ninguno | Deploy automático |
| `production` | Manual approval | 1 aprobador (tech lead) |
| `production` | Business hours | Solo en horario laboral (opcional) |

El stage con `environment: production` se detiene hasta que el aprobador confirme en la UI o vía notificación de correo. Si no aprueba en el tiempo configurado, el pipeline expira.

## Service connections

Configurar en **Project settings → Service connections** para conectar Azure DevOps con recursos externos.

| Tipo | Cuándo usarlo |
|------|---------------|
| Azure Resource Manager | Deploy a App Service, AKS, Azure Functions |
| Docker Registry | Push de imágenes a ACR o Docker Hub |
| GitHub | Acceso a repos de GitHub desde pipelines |
| Generic | APIs externas con token |

Referencia en YAML:

```yaml
- task: AzureWebApp@1
  inputs:
    azureSubscription: 'mi-service-connection'   # nombre exacto de la service connection
    appName: 'mi-app-staging'
    package: $(Pipeline.Workspace)/$(BUILD_ARTIFACT)
```

## Templates: reutilización con parámetros

```yaml
# pipelines/templates/deploy-steps.yml
parameters:
  - name: environment
    type: string
  - name: artifactName
    type: string

steps:
  - task: DownloadBuildArtifacts@1
    inputs:
      artifactName: ${{ parameters.artifactName }}
  - script: ./scripts/deploy.sh ${{ parameters.environment }}
    displayName: Deploy a ${{ parameters.environment }}
    env:
      DEPLOY_TOKEN: $(DEPLOY_TOKEN)
```

```yaml
# Uso en el pipeline principal
- template: pipelines/templates/deploy-steps.yml
  parameters:
    environment: staging
    artifactName: $(BUILD_ARTIFACT)
```

## Artifacts: publicar y consumir entre stages

```yaml
# Publicar en CI stage
- task: PublishBuildArtifacts@1
  inputs:
    PathtoPublish: dist
    ArtifactName: dist-$(Build.SourceVersion)

# Consumir en Deploy stage
- task: DownloadBuildArtifacts@1
  inputs:
    artifactName: dist-$(Build.SourceVersion)
    downloadPath: $(Pipeline.Workspace)
```

Regla: nombrar artefactos con el `Build.SourceVersion` (SHA del commit). Equivalente al principio de trazabilidad del cicd base.

## Branch policies

Equivalente a branch protection de GitHub. Configurar en **Project settings → Repositories → Policies** (branch level).

| Policy | Valor recomendado |
|--------|------------------|
| Require a minimum number of reviewers | 1 |
| Reset all approval votes when new changes are pushed | ✅ ON |
| Require linked work items | ✅ ON — todo PR tiene un ticket |
| Require comment resolution | ✅ ON — todos los comments resueltos antes de merge |
| Build validation | Pipeline de CI debe pasar |
| Limit merge types | Solo Squash merge |
