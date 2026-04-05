---
name: devops
description: >
  Orquestador del área de DevOps. Coordina todo lo relacionado con integración continua,
  gestión de código y tableros de trabajo del proyecto.
  Trigger: cuando se trabaja con PRs, pipelines CI/CD o gestión de tickets y tableros.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
---

## Objetivo

Que todo cambio de código llegue a producción de forma trazable, automática y sin intervención manual. Cada tarea tiene un ticket, cada ticket tiene un PR, cada PR pasa por un pipeline.

## Sub-agentes disponibles

| Sub-agente | Cuándo usarlo |
|------------|---------------|
| `pr/github/` | Abrir, revisar o mergear un Pull Request en GitHub |
| `pr/bitbucket/` | Abrir, revisar o mergear un Pull Request en Bitbucket |
| `cicd/github-actions/` | Configurar, depurar o extender un pipeline en GitHub Actions |
| `cicd/azure-devops/` | Configurar, depurar o extender un pipeline en Azure DevOps |
| `board/jira/` | Crear, actualizar o gestionar tickets y sprints en Jira |
| `board/azure-boards/` | Crear, actualizar o gestionar tickets y sprints en Azure Boards |

## Árbol de decisión

```
¿Qué necesitás hacer?
│
├── Abrir, revisar o mergear un PR
│   ├── GitHub → pr/github/
│   └── Bitbucket → pr/bitbucket/
│
├── Configurar o depurar pipeline CI/CD
│   ├── GitHub Actions → cicd/github-actions/
│   └── Azure DevOps → cicd/azure-devops/
│
└── Crear o gestionar tickets/tareas en tablero
    ├── Jira → board/jira/
    └── Azure Boards → board/azure-boards/
```

## Principios irrenunciables

1. **Sin merge a main sin pipeline en verde.** Branch protection activado, sin excepciones.
2. **Sin deploy manual.** Todo pasa por CI/CD. Si no está en el pipeline, no existe.
3. **Sin ticket sin AC definidos antes de empezar.** No se escribe código sobre aire.
4. **Los pipelines fallan rápido (fail fast).** Lint primero; si falla, el pipeline se detiene. No se llega a build con código roto.
5. **Todo cambio de infraestructura versionado en el repo (IaC).** La infraestructura es código: se revisa, se aprueba, se traquea.
