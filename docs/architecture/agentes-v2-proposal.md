# Agentes v2 — Propuesta de distribución GGS sobre Gentle AI

## Decisión propuesta

Mantener `ggs_agentes_base` como **distribución pública GGS** sobre Gentle AI/OpenCode, no como fork del core.

Gentle AI aporta el motor: SDD, subagentes, comandos, memoria, permisos y herramientas. GGS aporta la capa de empresa: skills, templates, estándares, branding, configuración y pocos agentes propios.

## Problema

El repo actual mezcla cuatro conceptos bajo `AGENT.md`:

- trabajadores autónomos;
- estándares técnicos;
- guías de diseño/desarrollo;
- documentación y templates.

Eso genera costo de mantenimiento porque cada mejora de Gentle AI puede parecer algo que hay que sincronizar manualmente. La dirección deseada es curar e incorporar solo lo que agrega valor al contexto de GGSoluciones.

## Modelo objetivo

```text
Gentle AI / OpenCode
  └─ motor base: SDD, subagentes, tooling, memoria, permisos

ggs_agentes_base
  └─ distribución GGS: skills, templates, estándares, config, instalador
```

## Qué queda como agente

Mantener pocos agentes, solo cuando haya autonomía real, permisos/modelo propio o rol de delegación claro.

```text
agents/
  sdd-ggs-orchestrator/
  sdd-ggs-plan/
  sdd-ggs-judgment/
```

Opcionales futuros:

- `ggs-design-reviewer`, si se necesita revisión UX/UI autónoma.
- `ggs-architecture-reviewer`, si se necesita auditoría técnica autónoma.

## Qué pasa a skills

Las skills representan capacidades repetibles. Son el lugar principal para capturar la forma GGSoluciones de trabajar.

```text
skills/
  login-web/
  chatbot-web/
  menu-navigation/
  reportes-ggs/
  guias-desarrollo/
  manuales-tecnicos/
  web-skeleton/
  skill-creator-ggs/
  code-review-ggs/
  seguridad-web-ggs/
  testing-ggs/
  azure-boards-ggs/
```

Regla práctica:

| Si es... | Va en... |
|---|---|
| Rol autónomo con criterio, modelo o permisos propios | `agents/` |
| Patrón repetible de trabajo | `skills/` |
| Checklist o estándar inyectable | `skills/` o `standards/` referenciado |
| Explicación larga para humanos | `docs/` |
| Plantilla reutilizable | `templates/` |

## Estructura propuesta del repo

```text
ggs_agentes_base/
  README.md
  INSTALL.md
  CHANGELOG.md

  agents/
    sdd-ggs-orchestrator/
      AGENT.md
    sdd-ggs-plan/
      AGENT.md
    sdd-ggs-judgment/
      AGENT.md

  skills/
    login-web/
      SKILL.md
      assets/
      references/
    chatbot-web/
      SKILL.md
    menu-navigation/
      SKILL.md
    reportes-ggs/
      SKILL.md
    guias-desarrollo/
      SKILL.md
    manuales-tecnicos/
      SKILL.md
    web-skeleton/
      SKILL.md
    skill-creator-ggs/
      SKILL.md

  standards/
    arquitectura-2026.md
    seguridad-web.md
    naming.md
    testing.md
    azure-devops.md

  templates/
    login/
    chatbot/
    menu/
    reportes/
    manuales/
    proyectos/

  config/
    opencode/
      opencode.base.json
      agents.json
      permissions.json
    proyectos/
      plantilla.config.md

  scripts/
    install.ps1
    install.sh
    update.ps1
    validate.ps1
    review-gentle-updates.ps1

  docs/
    architecture/
      agentes-v2-proposal.md

  .atl/
    skill-registry.md
```

## Proceso de actualización

Los cambios de Gentle AI no se copian completos. Se revisan y se clasifican.

```text
1. Gentle AI/OpenCode publica cambios
2. GGS revisa el changelog o diff relevante
3. Se clasifica cada cambio:
   - core universal → actualizar dependencia/base
   - práctica útil para GGSoluciones → adaptar como skill GGS
   - reemplaza algo propio → simplificar o borrar lo propio
   - no aplica → ignorar
4. Se actualiza el repo ggs_agentes_base
5. Se corre validate.ps1
6. El equipo ejecuta update.ps1
```

## Scripts esperados

> Estado actualizado: la distribución v2 ya está publicada en `master`. Para rollout usar `v2.0.1-ggs-agents`, que incluye el fix del instalador para checkouts existentes de skills con cambios locales.

### `install.ps1`

Instala la distribución GGS por primera vez.

- verifica herramientas base;
- instala o valida OpenCode/Gentle/Engram;
- soporta `-DryRun` para validar sin escribir configuración;
- soporta `-UpdateGentleAI` para actualizar explícitamente Gentle AI con el instalador oficial;
- registra los tres agentes visibles en OpenCode: `Orquestador`, `Planificador`, `Revisor`;
- registra comandos operativos `/ggs-status` y `/ggs-update`;
- con `-Agent opencode`, también instala/actualiza skills GGS para Claude Code en `~/.claude/skills/ggs` salvo que se use `-NoInstallClaude`;
- crea backup antes de modificar `~/.config/opencode/opencode.json`;
- preserva proveedor, modelo, MCPs y preferencias existentes;
- si el checkout local de skills existe pero no puede actualizarse por cambios locales, lo conserva y continúa con advertencia para no pisar trabajo del usuario.

### `update.ps1`

Actualiza una instalación existente del equipo.

- trae la última versión de `ggs_agentes_base` cuando se ejecuta desde un clon git;
- valida que la estructura local siga completa;
- preserva configuración local;
- soporta `-DryRun` para validar sin aplicar cambios;
- soporta `-ConfigureOpenCode` para refrescar `~/.config/opencode/opencode.json` sin pedir un segundo comando manual;
- soporta `-UpdateGentleAI` para ejecutar explícitamente el instalador oficial de Gentle AI en Windows;
- crea backup antes de modificar configuración global de OpenCode;
- informa que OpenCode debe reiniciarse para cargar cambios;
- nunca debe borrar carpetas legacy de agentes sin moverlas antes a backup o pedir intervención manual.

### Comandos OpenCode

La entrada recomendada para el equipo es `/ggs-status`.

- `/ggs-status`: valida el entorno en seco y, si detecta faltantes o updates, pide confirmación antes de actualizar.
- `/ggs-update`: atajo avanzado para actualizar GGS/Gentle AI de forma explícita.

No hay auto-update silencioso al abrir OpenCode. La actualización automática se descartó porque puede tocar configuración global, ralentizar startup o generar side effects sin consentimiento.

### Validación de rollout

| Área | Estado |
|---|---|
| PR principal | PR #10 mergeado a `master` en `eb0c834` |
| Fix posterior | `b03377d fix(installer): tolerate protected existing skills checkout` |
| Tags | `v2.0-ggs-agents` en `eb0c834`; `v2.0.1-ggs-agents` en `b03377d` |
| Gentle AI | Validado en `gentle-ai 1.30.6` |
| Python | Validado en `Python 3.12.3` |
| OpenCode config | `opencode.json` validado como JSON correcto después del update |
| Backup | Validado en `~/.config/opencode/backups/` |
| Rollback | Validado en copia temporal, sin restaurar sobre config activa |

### `review-gentle-updates.ps1`

Asiste la curación de novedades de Gentle AI.

- muestra versión instalada y versión disponible;
- lista cambios candidatos;
- separa core, skills, agentes y config;
- no aplica cambios automáticamente sin decisión.

## Criterio de adopción

| Cambio detectado | Acción |
|---|---|
| Mejora del core SDD, memoria, permisos o subagentes | Adoptar actualizando Gentle/OpenCode |
| Nueva práctica reusable para portales internos | Adaptar como skill GGS |
| Agente genérico que duplica uno GGS | Preferir el genérico si cubre el caso, reducir GGS |
| Regla específica de otra empresa/contexto | Ignorar |
| Template útil pero no GGS | Adaptar branding, copy y estructura antes de incorporar |

## Migración sugerida

1. Congelar creación de nuevos `AGENT.md` salvo agentes principales.
2. Clasificar todos los `AGENT.md` actuales como `agent`, `skill`, `standard`, `docs` o `template`.
3. Convertir primero `reglas/` y `guilds/` a skills compactas o standards referenciados.
4. Mantener `skills/` de diseño como primera tanda: login, chatbot, menú, reportes, guías y manuales.
5. Actualizar instaladores para instalar la distribución GGS, no una copia del core.
6. Regenerar `.atl/skill-registry.md`.
7. Actualizar README con el nuevo modelo mental: Gentle AI como base, GGS como distribución pública.

## Riesgos

- Convertir todo a skills sin criterio puede crear una lista inmanejable.
- Mantener demasiados agentes vuelve a duplicar Gentle AI.
- Copiar novedades de Gentle sin curación vuelve al problema de fork.
- Skills demasiado largas pierden utilidad en runtime; el detalle debe ir a `references/` o `templates/`.

## Resultado esperado

El equipo instala una forma GGS de usar Gentle AI:

- misma base para todos;
- estándares internos consistentes;
- menos mantenimiento;
- evolución controlada;
- capacidad de incorporar mejoras externas sin perder identidad de empresa.
