---
name: skill-creator-ggs
description: "Trigger: crear skill, nueva skill, crear agente, nuevo agente GGS. Crear capacidades GGS sin duplicar Gentle AI."
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
---

# Skill Creator GGS

## Activation Contract

Usá esta skill cuando se pida crear o modificar una skill GGS, proponer un agente GGS o migrar un `AGENT.md` existente a skill, estándar, template o documentación.

## Hard Rules

- No crees un agente si una skill resuelve el caso.
- No copies capacidades core de Gentle AI/OpenCode; GGS agrega contexto de empresa.
- Una skill es contrato runtime para el LLM, no documentación humana extensa.
- Mantené `SKILL.md` compacto; mové ejemplos largos a `assets/` y detalle conceptual a `references/`.
- La descripción debe incluir triggers reales que el usuario diría.
- Todo agente nuevo debe justificar autonomía, permisos/modelo propio o rol de subagente.

## Decision Gates

| Necesidad | Crear |
|---|---|
| Patrón repetible de diseño, desarrollo o documentación | Skill |
| Rol autónomo que delega/revisa/ejecuta con criterio propio | Agent |
| Checklist o estándar transversal | Skill compacta + `standards/` |
| Ejemplos, HTML base, schemas o fixtures | `assets/` |
| Guía larga para humanos | `docs/` o `references/` |

## Execution Steps

1. Clasificá la necesidad: skill, agent, standard, template o docs.
2. Si es skill, creá `skills/{name}/SKILL.md` con frontmatter válido.
3. Si es agente, creá `agents/{name}/AGENT.md` solo con justificación explícita.
4. Registrá o regenerá `.atl/skill-registry.md` cuando aplique.
5. Indicá si la capacidad reemplaza un agente/regla anterior.

## Output Contract

Devolver archivos creados/modificados, decisión de clasificación y pasos de instalación/validación.
