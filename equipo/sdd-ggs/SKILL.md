---
name: sdd-ggs
description: >
  Inicia el workflow SDD combinado con agentes personalizados GGS.
  Cuando dice "sdd", "mi sdd", "iniciar SDD", "sdd completo".
  Incluye: detección robusta de stack, strict TDD mode, skill registry, persistencia configurable.
license: MIT
metadata:
  author: Alejandro Gallardo
  version: "2.0"
---

## Propósito

Combinar el SDD de gentle-ai con tus agentes personalizados importados de Arquitectura de Agentes.
Este skill ejecuta el workflow completo de Spec-Driven Development mientras carga automáticamente
tus reglas, guilds y agentes según el contexto del proyecto.

Eres un SUB-AGENTE EJECUTOR, no el orchestrator. Hacés el trabajo vos mismo,
no lanzás sub-agentes, no llamés `delegate` ni `task`, y no devolvás ejecución
a menos que hits un blocker real que debe reportarse upstream.

## Cuándo Usar Este Skill

- Cuando necesitás un workflow estructurado para cambios importantes
- Cuando querés tener disponibles tus reglas y guilds durante el desarrollo
- Cuando decís: "sdd completo", "mi sdd", "iniciar SDD"
- Para cambios sustanciales: features, refactors, bugs complejos

## Modo de Persistencia

Este skill soporta múltiples modos de persistencia (igual que gentle-ai):

- **`engram`**: Rápido, sin archivos. Artefactos vivos en Engram. Ideal para desarrollo solo.
- **`openspec`**: Basado en archivos. Carpeta `openspec/` con trail completo. Compartible, git-friendly.
- **`hybrid`**: Ambos — archivos para compartir + Engram para recovery. Mayor costo en tokens.
- **`none`**: Solo retorna inline, sin persistencia.

El modo se resuelve en tiempo de inicialización (`/sdd-init`).

## Flujo Integrado

```
┌─────────────────────────────────────────────────────────────────┐
│            SDD GENTLE-AI + MIS AGENTES v2.0                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  /sdd-init                                                      │
│      ↓                                                          │
│  Detección de Stack + Testing Capabilities                      │
│      ↓                                                          │
│  Strict TDD Mode Resolution                                     │
│      ↓                                                          │
│  Skill Registry (tus agentes)                                  │
│      ↓                                                          │
│  Elegís fase SDD ← Los agentes se activan según trigger            │
│                                                                 │
│  ┌─────────┬─────────┬─────────┬─────────┬─────────┐          │
│  │ EXPLORE │ PROPOSE│  SPEC   │ DESIGN  │  APPLY  │          │
│  └─────────┴─────────┴─────────┴─────────┴─────────┘          │
│       ↓         ↓        ↓        ↓        ↓                   │
│  Tus agentes se activan automáticamente:                      │
│                                                                 │
│  • Explore  → equipo/desarrollo/, guilds/*                     │
│  • Propose  → equipo/producto/, reglas/onboarding/            │
│  • Spec     → reglas/documentacion/, reglas/naming-conventions/│
│  • Design   → guilds/arquitectura/, reglas/css-arquitectura/     │
│  • Apply    → reglas/code-review/, reglas/error-handling/         │
│  • Verify   → equipo/testing/, reglas/seguridad-web/          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Pasos de Ejecución (igual que gentle-ai)

### Step 1: Detect Project Context

Leé el proyecto para entender:
- Tech stack (package.json, go.mod, pyproject.toml, etc.)
- Convenciones existentes (linters, test frameworks, CI)
- Patrones de arquitectura en uso

### Step 2: Detect Testing Capabilities

Escaneá el proyecto para toda la infraestructura de testing:

```
Detect testing capabilities:
├── Test Runner
│   ├── package.json → devDependencies: vitest, jest, mocha, ava
│   ├── package.json → scripts.test (what command it runs)
│   ├── pyproject.toml / pytest.ini / setup.cfg → pytest
│   ├── go.mod → go test (built-in)
│   ├── Cargo.toml → cargo test (built-in)
│   └── Result: {framework name, command} or NOT FOUND
│
├── Test Layers
│   ├── Unit: test runner exists → AVAILABLE
│   ├── Integration:
│   │   ├── JS/TS: @testing-library/* in dependencies
│   │   ├── Python: pytest + httpx/requests-mock/factory-boy
│   │   ├── Go: net/http/httptest (built-in)
│   │   ├── .NET: xUnit/NUnit + WebApplicationFactory
│   │   └── Result: AVAILABLE or NOT INSTALLED
│   ├── E2E:
│   │   ├── playwright, cypress, selenium in dependencies
│   │   ├── Python: playwright, selenium
│   │   ├── Go: chromedp
│   │   └── Result: AVAILABLE or NOT INSTALLED
│   └── Each layer → record tool name
│
├── Coverage Tool
│   ├── JS/TS: vitest --coverage, jest --coverage, c8, istanbul/nyc
│   ├── Python: coverage.py, pytest-cov
│   ├── Go: go test -cover (built-in)
│   ├── .NET: coverlet
│   └── Result: {command} or NOT AVAILABLE
│
└── Quality Tools
    ├── Linter: eslint, pylint, ruff, golangci-lint, clippy
    ├── Type checker: tsc --noEmit, mypy, pyright, go vet
    ├── Formatter: prettier, black, gofmt, rustfmt
    └── Each: {command} or NOT AVAILABLE
```

### Step 3: Resolve STRICT TDD MODE

Determiná si Strict TDD Mode debe activarse. La resolución sigue una cadena de prioridad:

```
1. Leé del system prompt / agent config (máxima prioridad):
   ├── Buscar "strict-tdd-mode" marker en el archivo de system prompt
   │   (ej: CLAUDE.md, GEMINI.md, .cursorrules, etc.)
   ├── Si dice "enabled" → strict_tdd: true
   ├── Si dice "disabled" → strict_tdd: false
   └── Esta es la preferencia del usuario en la gentle-ai TUI
│
2. Si no hay marker, revisar config de openspec:
   ├── Leer openspec/config.yaml → strict_tdd field
   └── Si existe → usar ese valor
│
3. Si no se encuentra nada Y se detectó test runner en Step 2:
   ├── Default: strict_tdd: true (activar si el proyecto PUEDE hacer TDD)
   └── Esto asegura TDD activo incluso sin setup de TUI
│
4. Si no se detectó test runner:
   ├── strict_tdd: false (no se puede activar sin test runner)
   └── Incluir NOTA en summary: "Strict TDD Mode unavailable — no test runner detected"
```

**NO le preguntes al usuario interactivamente.** La preferencia se resuelve de config existente.

### Step 4: Initialize Persistence Backend

Si el modo es `openspec`, crear la estructura:

```
openspec/
├── config.yaml              ← Project-specific SDD config
├── specs/                   ← Source of truth (empty initially)
└── changes/                 ← Active changes
    └── archive/             ← Completed changes
```

### Step 5: Generate Config (openspec mode)

Basado en lo detectado, crear el config:

```yaml
# openspec/config.yaml
schema: spec-driven

context: |
  Tech stack: {detected stack}
  Architecture: {detected patterns}
  Testing: {detected test framework}
  Style: {detected linting/formatting}

strict_tdd: {true/false}

rules:
  proposal:
    - Include rollback plan for risky changes
    - Identify affected modules/packages
  specs:
    - Use Given/When/Then format for scenarios
    - Use RFC 2119 keywords (MUST, SHALL, SHOULD, MAY)
  design:
    - Include sequence diagrams for complex flows
    - Document architecture decisions with rationale
  tasks:
    - Group tasks by phase (infrastructure, implementation, testing)
    - Use hierarchical numbering (1.1, 1.2, etc.)
    - Keep tasks small enough to complete in one session
  apply:
    - Follow existing code patterns and conventions
    - Load relevant coding skills for the project stack
  verify:
    - Run tests if test infrastructure exists
    - Compare implementation against every spec scenario
  archive:
    - Warn before merging destructive deltas (large removals)
```

### Step 6: Persist Testing Capabilities

**Este paso es OBLIGATORIO — no lo omitas.**

Persistir las capacidades de testing detectadas como observación separada en Engram
(o sección en config.yaml para openspec). Este cache previene re-detección.

Si el modo es `engram` o `hybrid`:
```
mem_save(
  title: "sdd/{project-name}/testing-capabilities",
  topic_key: "sdd/{project-name}/testing-capabilities",
  type: "config",
  project: "{project-name}",
  content: "{testing capabilities markdown — see format below}"
)
```

**Testing Capabilities format**:

```markdown
## Testing Capabilities

**Strict TDD Mode**: {enabled/disabled}
**Detected**: {date}

### Test Runner
- Command: `{command}`
- Framework: {name}

### Test Layers
| Layer | Available | Tool |
|-------|-----------|------|
| Unit | ✅ / ❌ | {tool or —} |
| Integration | ✅ / ❌ | {tool or —} |
| E2E | ✅ / ❌ | {tool or —} |

### Coverage
- Available: ✅ / ❌
- Command: `{command or —}`

### Quality Tools
| Tool | Available | Command |
|------|-----------|---------|
| Linter | ✅ / ❌ | {command or —} |
| Type checker | ✅ / ❌ | {command or —} |
| Formatter | ✅ / ❌ | {command or —} |
```

### Step 7: Build Skill Registry (tus agentes)

Igual que el skill `skill-registry`:

1. **Escanear user skills**: glob `*/SKILL.md` en todos los directorios de skills conocidos.
   **Usuario-level**: `~/.claude/skills/`, `~/.config/opencode/skills/`, `~/.gemini/skills/`, `~/.cursor/skills/`, `~/.copilot/skills/`. **Proyecto-level**: `.claude/skills/`, `.gemini/skills/`, `.agent/skills/`, `skills/`. Skip `sdd-*`, `_shared`, `skill-registry`. Deduplicar por nombre (proyecto-level gana). Leer frontmatter triggers.

2. **Escanear project conventions**: revisar `agents.md`, `AGENTS.md`, `CLAUDE.md` (proyecto-level), `.cursorrules`, `GEMINI.md`, `copilot-instructions.md` en la raíz del proyecto.

3. **SIEMPRE escribir `.atl/skill-registry.md`** en la raíz del proyecto (crear `.atl/` si no existe).

4. **SI Engram está disponible, TAMBIEN guardar**: `mem_save(title: "skill-registry", topic_key: "skill-registry", type: "config", project: "{project}", content: "{registry markdown}")`

### Step 8: Persist Project Context

**Este paso es OBLIGATORIO — no lo omitas.**

Si el modo es `engram`:
```
mem_save(
  title: "sdd-init/{project-name}",
  topic_key: "sdd-init/{project-name}",
  type: "architecture",
  project: "{project-name}",
  content: "{your detected project context from Steps 1-7}"
)
```

Si el modo es `openspec` o `hybrid`: el config ya fue escrito en Step 5.

Si el modo es `hybrid`: también llamar `mem_save` como arriba (escribir a AMBOS backends).

### Step 9: Return Summary

Retornar un summary estructurado adaptado al modo resuelto:

#### Modo engram

```
## SDD Initialized (v2.0 - gg-soluciones)

**Project**: {project name}
**Stack**: {detected stack}
**Persistence**: engram
**Strict TDD Mode**: {enabled ✅ / disabled ❌ / unavailable}

### Tus Agentes Detectados
- Equipo: {lista}
- Reglas: {lista}
- Guilds: {lista}

### Testing Capabilities
| Capability | Status |
|------------|--------|
| Test Runner | {tool} ✅ / ❌ Not found |
| Unit Tests | ✅ / ❌ |
| Integration Tests | {tool} ✅ / ❌ Not installed |
| E2E Tests | {tool} ✅ / ❌ Not installed |
| Coverage | ✅ / ❌ |
| Linter | {tool} ✅ / ❌ |
| Type Checker | {tool} ✅ / ❌ |

### Context Saved
- **Engram ID**: #{observation-id}
- **Topic key**: sdd-init/{project-name}
- **Capabilities ID**: #{capabilities-observation-id}
- **Capabilities key**: sdd/{project-name}/testing-capabilities

No project files created.

### ⚠️ Engram Mode Limitations
- **No iteration history**: re-running a phase overwrites previous version
- **Not shareable**: Engram es base de datos local
- **Partial audit trail**: archive phase saves summary, not full folder

### Next Steps
Ready for /sdd-explore <topic> or /sdd-new <change-name>.
```

#### Modo openspec

```
## SDD Initialized (v2.0)

**Project**: {project name}
**Stack**: {detected stack}
**Persistence**: openspec
**Strict TDD Mode**: {enabled ✅ / disabled ❌ / unavailable}

### Tus Agentes Detectados
{list}

### Testing Capabilities
{same table as above}

### Structure Created
- openspec/config.yaml ← Project config with detected context + testing capabilities
- openspec/specs/      ← Ready for specifications
- openspec/changes/    ← Ready for change proposals

### Next Steps
Ready for /sdd-explore <topic> or /sdd-new <change-name>.
```

## Tus Agentes Disponibles (para todas las fases)

### Equipo
- `equipo/desarrollo/dev` → Entender código, dominio
- `equipo/testing/funcional` → Testing funcional
- `equipo/testing/unitario` → Testing unitario
- `equipo/devops/cicd/` → CI/CD
- `equipo/devops/pr/` → Pull requests
- `equipo/producto/arquitecto` → Arquitectura de producto

### Reglas
- `reglas/code-review/` → Code review
- `reglas/seguridad-web/` → Validación de seguridad
- `reglas/git-avanzado/` → Workflow git
- `reglas/debugging/` → Debugging
- `reglas/error-handling/` → Manejo de errores
- `reglas/documentacion/` → Documentación
- `reglas/naming-conventions/` → Convenciones de nombres

### Guilds (estándares por tecnología)
- `guilds/frontend-angular/` → Proyectos Angular
- `guilds/backend-dotnet/` → Proyectos .NET
- `guilds/datos/` → Componentes de datos
- `guilds/arquitectura/` → Patrones de arquitectura

## Cómo Usarlo

### Inicialización (necesaria una vez por proyecto)
```
> /sdd-init
> sdd
> mi sdd
> iniciar SDD completo
```

### Desarrollo completo con TDD
```
> /sdd-apply [tarea]
```
Esto activa:
- `equipo/desarrollo/dev` ← implementación con TDD
- `guilds/backend-dotnet` ← estándares .NET
- `reglas/code-review` ← review
- `reglas/error-handling` ← manejo de errores

### Flujo completo
```
1. /sdd-init           → Bootea el proyecto + detecta stack
2. /sdd-propose        → Crear propuesta
3. /sdd-spec           → Especificar requisitos
4. /sdd-design         → Diseño técnico
5. /sdd-tasks          → Descomponer en tareas
6. /sdd-apply          → Implementar con TDD
7. /sdd-verify         → Verificar
8. /sdd-archive        → Archivar
```

## Reglas

- **SDD se activa automáticamente** para cambios sustanciales
- **Tus agentes se activan** cuando el trigger coincide con lo que decís
- **Si no sabés qué fase**, simplemente decí qué necesitás y el agente guía
- **Podés saltar fases** si ya tenés la info (ej: si ya tenés specs, pasá a design)
- **NUNCA crees placeholder specs** - specs se crean vía sdd-spec durante un cambio
- **SIEMPRE detectá el tech stack real**, no guesses
- **NUNCA te comportes como el orchestrator** - ejecutá directamente y retorná resultados
- **NUNCA omitas la detección de testing capabilities** - fases downstream dependen de esto
- **Retorná structured envelope**: `status`, `executive_summary`, `detailed_report` (optional), `artifacts`, `next_recommended`, `risks`

## Referencias

- SDD spec: `skills/_shared/sdd-phase-common.md`
- Skill registry: `.atl/skill-registry.md`
- Tus agentes: `equipo/`, `reglas/`, `guilds/`
- Convenciones: `skills/_shared/engram-convention.md`, `skills/_shared/openspec-convention.md`