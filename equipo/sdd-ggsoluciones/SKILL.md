---
name: sdd-ggsoluciones
description: >
  Inicia el workflow SDD de gentle-ai combinado con tus agentes personalizados de Arquitectura de Agentes.
  Cuando dice "sdd gg", "sdd-ggsoluciones", "mi sdd", "sdd con mis agentes", "iniciar SDD completo con mis agentes".
license: MIT
metadata:
  author: aleja
  version: "1.0"
---

## Objetivo

Combinar el SDD de gentle-ai (9 fases) con los agentes personalizados importados de Arquitectura de Agentes.

## Cuándo usar este skill

- Cuando necesitás un workflow estructurado para cambios importantes
- Cuando querés tener disponibles tus reglas y guilds durante el desarrollo
- Cuando decís: "sdd completo", "mi sdd", "iniciar SDD"

## Flujo Integrado

```
┌─────────────────────────────────────────────────────────────────┐
│            SDD GENTLE-AI + MIS AGENTES                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  /sdd-init                                                      │
│      ↓                                                          │
│  /skill-registry  ← Escanea mis agentes (equipo, reglas, guilds)│
│      ↓                                                          │
│  Elegís fase SDD ← Los agentes se activan según trigger         │
│                                                                 │
│  ┌─────────┬─────────┬─────────┬─────────┬─────────┐          │
│  │ EXPLORE │ PROPOSE│  SPEC   │ DESIGN  │  APPLY  │          │
│  └─────────┴─────────┴─────────┴─────────┴─────────┘          │
│       ↓         ↓        ↓        ↓        ↓                   │
│  Tus agentes se activan automáticamente:                      │
│                                                                 │
│  • Explore  → equipo/desarrollo/, guilds/*                     │
│  • Propose  → equipo/producto/, reglas/onboarding/             │
│  • Spec     → reglas/documentacion/, reglas/naming-conventions/│
│  • Design   → guilds/arquitectura/, reglas/css-arquitectura/    │
│  • Apply    → reglas/code-review/, reglas/error-handling/      │
│  • Verify   → equipo/testing/, reglas/seguridad-web/           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Fases SDD (gentle-ai)

| Fase | Skill | Trigger | Tus agentes que aplican |
|------|-------|---------|-------------------------|
| 1 | `sdd-init` | `/sdd-init` | Bootea todo |
| 2 | `sdd-explore` | `/sdd-explore` | `equipo/desarrollo/`, `guilds/*` |
| 3 | `sdd-propose` | `/sdd-propose` | `equipo/producto/` |
| 4 | `sdd-spec` | `/sdd-spec` | `reglas/documentacion/` |
| 5 | `sdd-design` | `/sdd-design` | `guilds/arquitectura/` |
| 6 | `sdd-tasks` | `/sdd-tasks` | Breakdown |
| 7 | `sdd-apply` | `/sdd-apply` | `reglas/code-review/` |
| 8 | `sdd-verify` | `/sdd-verify` | `equipo/testing/`, `reglas/seguridad-web/` |
| 9 | `sdd-archive` | `/sdd-archive` | Archiva y sincroniza |

## Agentes Disponibles (tus triggers)

### Equipo
- `equipo/desarrollo/dev` → Entender código, dominio
- `equipo/testing/funcional` → Testing funcional
- `equipo/testing/unitario` → Testing unitario
- `equipo/devops/cicd/` → CI/CD
- `equipo/devops/pr/` → Pull requests

### Reglas
- `reglas/code-review/` → Code review
- `reglas/seguridad-web/` → Validación de seguridad
- `reglas/git-avanzado/` → Workflow git
- `reglas/debugging/` → Debugging
- `reglas/error-handling/` → Manejo de errores

### Guilds (estándares por tecnología)
- `guilds/frontend-angular/` → Proyectos Angular
- `guilds/backend-dotnet/` → Proyectos .NET
- `guilds/datos/` → Componentes de datos

## Cómo usarlo

### Paso 1: Iniciar SDD completo
```
> /sdd-ggsoluciones
```
O simplemente:
```
> iniciar SDD completo con mis agentes
```

### Paso 2: El agente hace:
1. `/sdd-init` → Detecta stack y bootea Engram
2. `/skill-registry` → Escanea tus agentes importados
3. Lista las fases disponibles y tus agentes

### Paso 3: Working normally
```
> necesito agregar autenticación JWT
```
El agente:
- Detecta que es un cambio sustancial → propone usar SDD
- Activa `sdd-propose` para crear el proposal
- Durante `sdd-spec` y `sdd-design`, activa `guilds/arquitectura/`
- Durante `sdd-apply`, activa `reglas/code-review/`
- Durante `sdd-verify`, activa `equipo/testing/`

## Ejemplo de conversación

```
USER: necesito hacer un feature de login con JWT

AGENT: Esto parece un cambio sustancial. Querés que use SDD completo?

USER: sí

AGENT: *ejecuta /sdd-init + /skill-registry*
      
      SDD Listo + 52 agentes disponibles
      
      Phase: PROPOSE
      
      Agregando rules de:
      - equipo/producto/arquitecto
      - reglas/documentacion
      
      Creando proposal para "Login JWT"...
```

## Reglas

- **SDD se activa automáticamente** para cambios sustanciales (features, refactors, bugs complejos)
- **Tus agentes se activan** cuando el trigger coincide con lo que decís
- **Si no sabés qué fase**, simplemente decí qué necesitás y el agente guía
- **Podés saltar fases** si ya tenés la info (ej: si ya tenés specs, pasá a design)

## Referencias

- SDD spec: `skills/_shared/sdd-phase-common.md`
- Skill registry: `.atl/skill-registry.md`
- Tus agentes: `~/.claude/skills/equipo/`, `~/.claude/skills/reglas/`, `~/.claude/skills/guilds/`
