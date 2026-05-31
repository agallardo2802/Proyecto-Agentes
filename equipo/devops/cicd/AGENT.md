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
| El rollback automático falló | Escalar a `equipo/desarrollo/dev-ggs` para diagnóstico manual |

## Etapas obligatorias de todo pipeline

```
1. lint              → análisis estático y formato de código
2. secrets-scan      → gitleaks / trufflehog — NO secretos en el repo
3. sast              → análisis de seguridad estático (SonarQube / CodeQL / Semgrep)
4. test              → unitarios + integración (cobertura ≥80%)
5. build             → compilación y empaquetado del artefacto
6. sca               → dependencias sin CVE crítico (OWASP Dep-Check / Snyk / dependabot)
7. container-scan    → si hay imagen Docker (Trivy / Grype)
8. deploy-staging    → despliegue automático a staging; SOLO desde `develop`
9. dast-baseline     → OWASP ZAP baseline contra staging
10. smoke-test       → verificación básica post-deploy en staging
11. deploy-prod      → SOLO desde `master` (merge develop→master); aprobación manual + approver de AppSec si tocó paths sensibles
12. release          → SOLO si deploy-prod + smoke-test de prod pasaron; versionado automático SemVer
```

El pipeline es secuencial. Si una etapa falla, las siguientes no se ejecutan.

## Mapa rama → ambiente (GitFlow GGS)

| Rama | Ambiente | Qué dispara |
|------|----------|-------------|
| Branch hija (`feat/`, `fix/`, …) | — (solo CI) | lint → secrets-scan → sast → test → build → sca; PR siempre apunta a `develop` |
| `develop` | **Staging** | etapas 1-10, incluyendo `deploy-staging` + `dast-baseline` + `smoke-test` |
| `master` | **Producción** | `deploy-prod` + `release` (etapas 11-12); solo recibe merge desde `develop` |

- **`deploy-staging` corre desde `develop`**, nunca desde una branch hija.
- **`deploy-prod` corre solo desde `master`**, y `master` solo se actualiza con un merge `develop → master` tras validar staging.
- Nunca se despliega a prod una branch hija ni se saltea staging.

## Release automático (etapa 12)

Todo deploy a prod exitoso cierra con un release versionado. La versión se calcula **automáticamente** leyendo los conventional commits desde el último tag — no se decide a mano.

### Cómo se calcula la versión (SemVer)

| Commit más relevante desde el último tag | Bump | Ejemplo |
|------------------------------------------|------|---------|
| `fix:` / `perf:` | patch | 1.4.2 → 1.4.**3** |
| `feat:` | minor | 1.4.2 → 1.**5**.0 |
| `feat!:`, `fix!:` o footer `BREAKING CHANGE:` | major | 1.4.2 → **2**.0.0 |
| Solo `docs:`/`chore:`/`test:`/`ci:` | sin release | (no se publica versión nueva) |

El bump lo determina el commit de mayor impacto en el rango. Primer release de un repo sin tags previos: `v0.1.0`.

### Pasos del release

```
deploy-prod OK + smoke-test prod verde
  │
  ├── 1. Calcular próxima versión vX.Y.Z desde los conventional commits
  ├── 2. Generar/actualizar CHANGELOG.md agrupado por tipo (Features, Fixes, Breaking)
  ├── 3. Crear y pushear git tag anotado vX.Y.Z (apuntando al commit desplegado)
  ├── 4. Publicar el Release en la plataforma del proyecto:
  │       • Azure DevOps → Release/Tag con notas (default GGS)
  │       • GitHub        → GitHub Release con notas
  └── 5. Vincular el Release y el tag al work item del tablero (AB#) y al deploy
```

### Reglas

- **El release nunca corre si `deploy-prod` o el smoke-test de prod fallaron.** No hay versión sin prod estable.
- **El tag apunta al commit exacto desplegado** — mantiene la trazabilidad del principio 4 (SHA), ahora también con versión legible.
- **Si no hay commits que ameriten release** (solo `chore`/`docs`), no se publica versión nueva — se registra el deploy pero sin tag.
- **El CHANGELOG y el tag se generan desde los commits, no a mano** — si un commit está mal tipado, el `Revisor` lo detecta antes del merge.
- **Herramienta sugerida por stack**: `semantic-release` (Node), `python-semantic-release` (Python), `GitVersion` o `dotnet` + `MinVer` (.NET). El sub-agente de plataforma elige según el stack del proyecto.

## Security gate — umbrales que bloquean

Un pipeline que llega a PROD con un hallazgo conocido crítico/alto es un incidente en potencia. Estas reglas no son negociables:

| Etapa | Bloquea si... |
|-------|---------------|
| `secrets-scan` | Cualquier secreto detectado (clave, token, password) |
| `sast` | ≥1 finding severidad **crítica** o **alta** sin waiver |
| `sca` | ≥1 dependencia con CVE **crítico** o **alto** sin waiver |
| `container-scan` | ≥1 CVE **crítico** en imagen base o en layers del proyecto |
| `dast-baseline` | ≥1 finding **alto** (ej: XSS, SQLi, auth bypass) |

**Waivers**: cuando un hallazgo no se puede fixear de inmediato, se documenta con:
- `AB#` del Bug/Task de seguimiento
- Owner (persona o agente)
- Justificación técnica
- Fecha de expiración (≤ 90 días)
- Firma: `equipo/seguridad/appsec` + `equipo/producto/arquitecto`

Sin waiver, el pipeline NO llega a `deploy-prod`.

## Coordinación con AppSec

El agente `equipo/seguridad/appsec` define los umbrales de severidad y aprueba waivers. El orquestador del CI/CD ejecuta; AppSec decide qué pasa y qué no.

## Principios irrenunciables

1. **Fail fast.** `lint` es la primera etapa. Si falla, el pipeline se detiene. No se llega a `build` con código roto.
2. **Sin secrets en código.** Variables de entorno o vault. Un secret hardcodeado en el repo es una vulnerabilidad, no un atajo.
3. **Caché de dependencias.** Reducir tiempos de ejecución cacheando `node_modules`, `.gradle`, `.pip` o lo que aplique al stack.
4. **Artefactos de build versionados con el SHA del commit.** Trazabilidad completa: saber exactamente qué código está en producción en todo momento.
5. **Rollback automático si smoke-test falla en prod.** El deploy a producción incluye un paso de verificación. Si falla, revierte sin intervención manual.
6. **Security gate no-bypass.** `secrets-scan`, `sast`, `sca`, `container-scan` y `dast-baseline` son obligatorios. No se desactivan "temporalmente" — si hace falta un waiver, se firma con `equipo/seguridad/appsec`.
7. **Todo deploy a prod exitoso cierra con release versionado.** Versión SemVer automática desde conventional commits, tag `vX.Y.Z` sobre el commit desplegado, CHANGELOG generado y Release publicado en la plataforma. Sin prod estable no hay release.
