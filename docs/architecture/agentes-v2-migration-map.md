# Agentes v2 — Mapa inicial de migración

## Objetivo

Clasificar el contenido actual para migrar de una flota grande de `AGENT.md` a una distribución GGS basada en Gentle AI/OpenCode + skills.

## Clasificación

| Ubicación actual | Clasificación v2 | Acción |
|---|---|---|
| `agents/Arquitecto` | Agent | Mantener como coordinador GGS mínimo |
| `agents/Planificador` | Agent | Mantener como modo de planificación |
| `agents/Revisor` | Agent | Mantener como revisión adversarial |
| `skills/login-web` | Skill | Mantener y compactar después |
| `skills/reportes-ggs` | Skill | Mantener y mover ejemplos largos a `assets/`/`references/` después |
| `skills/guias-desarrollo` | Skill | Mantener |
| `skills/manuales-tecnicos` | Skill | Mantener |
| `skills/web-skeleton` | Skill | Mantener |
| `equipo/diseno/*` | Skill o standard | Migrar criterios UX/UI a skills específicas |
| `equipo/testing/*` | Skill o standard | Consolidar como `testing-ggs` + referencias |
| `equipo/devops/*` | Skill | Consolidar por herramienta: Azure Boards, PR, CI/CD |
| `guilds/*` | Skill + standard | Convertir reglas compactas por stack |
| `reglas/*` | Skill + standard | Convertir checklists runtime; mover explicación larga a `standards/` |
| `templates/*` | Template | Mantener como assets reutilizables |
| `config/*` | Config | Mantener como configuración GGS por proyecto |

## Primera tanda

1. Crear skills de diseño faltantes: `chatbot-web`, `menu-navigation`, `skill-creator-ggs`. ✅
2. Crear `standards/` como destino de reglas largas. ✅
3. Agregar scripts v2 de actualización y revisión de novedades. ✅
4. Actualizar README con el nuevo modelo: Gentle AI como base, GGS como distribución pública. ✅
5. Ajustar instaladores para registrar solo agentes GGS reales y preservar configuración existente. ✅
6. Reemplazar el registry generado con rutas absolutas por un registry portable relativo al repo. ✅
7. Publicar Agentes GGS v2 desde la rama histórica `agentes_v2` hacia `master` vía PR #10. ✅
8. Validar instalación/update con backups y rollback seguro. ✅
9. Publicar tag de rollout `v2.0.1-ggs-agents` con fix de instalador. ✅

## Estado de rollout

| Elemento | Estado |
|---|---|
| Branch vigente | `master` |
| PR vigente | PR #10 mergeado |
| Commit base v2 | `eb0c834` |
| Commit recomendado | `b03377d` |
| Tag recomendado | `v2.0.1-ggs-agents` |
| Comando principal | `/ggs-status` |
| Comando avanzado | `/ggs-update` |
| Auto-update silencioso | No habilitado por seguridad |
| Config OpenCode | Se modifica con backup previo y preservando configuración existente |

## Pendiente

- Compactar skills existentes con frontmatter de una línea.
- Migrar `reglas/` y `guilds/` por tandas.
- Decidir si `equipo/` queda como legado temporal o se archiva cuando termine la migración.
- Revisar scripts legacy antes de incorporarlos a la validación automática de PowerShell 5.1.
- Cerrar manualmente PRs obsoletos si una migración previa dejó ramas intermedias abiertas.
