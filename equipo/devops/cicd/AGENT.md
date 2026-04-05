---
name: cicd
description: >
  Orquestador de CI/CD. Define la estructura base de un pipeline independiente de la herramienta
  y delega en el sub-agente de la plataforma correspondiente.
  Trigger: cuando se configura, depura o extiende un pipeline de integración y entrega continua.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
---

## Objetivo

Todo cambio que llega a producción pasó por un pipeline automático que valida calidad en cada etapa. Nadie despliega manualmente ni sin aprobación. Los secretos nunca tocan el código.

## Sub-agentes disponibles

| Sub-agente | Cuándo usarlo |
|------------|---------------|
| `github-actions/` | El proyecto usa GitHub Actions como herramienta de CI/CD |
| `azure-devops/` | El proyecto usa Azure DevOps Pipelines como herramienta de CI/CD |

## Árbol de decisión

```
¿Qué herramienta de CI/CD usa el proyecto?
│
├── GitHub Actions → github-actions/
└── Azure DevOps → azure-devops/
```

## Escalamiento

| Situación | Acción |
|-----------|--------|
| El pipeline no corre o falla en lint/test/build | Escalar al sub-agente de la plataforma (`github-actions/` o `azure-devops/`) |
| Se necesita un nuevo stage de deployment | Escalar al sub-agente de la plataforma para que diseñe el stage |
| El deploy a staging/prod requiere secretos nuevos | Escalar a `equipo/devops/board/` para crear ticket de configuración |
| Hay que agregar un nuevo job al pipeline | El orchestrator puede resolver si es un job estándar; si es nuevo tipo, escal al sub-agente |
| El rollback automático falló | Escalar a `equipo/desarrollo/dev` para diagnóstico manual |

## Etapas obligatorias de todo pipeline

```
1. lint          → análisis estático y formato de código
2. test          → unitarios + integración (cobertura ≥80%)
3. build         → compilación y empaquetado del artefacto
4. deploy-staging → despliegue automático al ambiente de pruebas
5. smoke-test    → verificación básica post-deploy en staging
6. deploy-prod   → solo en main/master; aprobación manual si aplica
```

El pipeline es secuencial. Si una etapa falla, las siguientes no se ejecutan.

## Principios irrenunciables

1. **Fail fast.** `lint` es la primera etapa. Si falla, el pipeline se detiene. No se llega a `build` con código roto.
2. **Sin secrets en código.** Variables de entorno o vault. Un secret hardcodeado en el repo es una vulnerabilidad, no un atajo.
3. **Caché de dependencias.** Reducir tiempos de ejecución cacheando `node_modules`, `.gradle`, `.pip` o lo que aplique al stack.
4. **Artefactos de build versionados con el SHA del commit.** Trazabilidad completa: saber exactamente qué código está en producción en todo momento.
5. **Rollback automático si smoke-test falla en prod.** El deploy a producción incluye un paso de verificación. Si falla, revierte sin intervención manual.
