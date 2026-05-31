---
name: openspec
description: >
  Guia practica de OpenSpec para el equipo de GGSoluciones.
  Trigger: cuando se quiere entender OpenSpec, crear cambios, o trabajar con specs persistidas en el repo.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

# OpenSpec — Guia para el Equipo GGSoluciones

## Que es OpenSpec

OpenSpec es un framework ligero de planificacion centrado en specs. Los specs viven en el repo junto al codigo, organizados por capacidad, y se crean a medida que se construye.

Sitio oficial: https://openspec.dev/

**En una oracion**: specs que persisten en el repo para que todos los agentes y desarrolladores tengan contexto alineado, sin importar cuando se unan o cuanto tiempo pase.

## Conceptos clave

### Spec

Una spec describe QUE hace una parte del sistema (no COMO esta implementado). Cada spec tiene:

```
openspec/specs/{capability}/spec.md
```

Contenido:
- **Purpose**: para que existe esta capacidad
- **Requirements**: lo que el sistema DEBE hacer (keyword DEBE/SHALL)
- **Scenarios**: ejemplos concretos en Gherkin Dado/Cuando/Entonces

### Change (cambio)

Un cambio es una unidad de trabajo planificada. Se genera cuando describis un cambio y OpenSpec produce:

```
openspec/changes/{change-id}/
├── proposal.md   ← descripcion del cambio
├── design.md     ← decisiones tecnicas
├── tasks.md      ← tareas de implementacion
└── specs/        ← deltas de specs afectadas
```

### Delta de specs

Los cambios muestran COMO se modifican los requisitos. El diff de specs usa notacion diff (`-` quitado, `+` agregado) para que sea facil de revisar:

```
- El sistema DEBE expirar sesiones despues de 24hs
+ El sistema DEBE soportar periodos de expiracion configurables
```

## Instalacion

```bash
npm install -g @fission-ai/openspec@latest
```

## Comandos basicos

```bash
# Ver todos los comandos disponibles
openspec --help

# Crear un cambio (proposal + design + tasks)
openspec new "mi nuevo feature"

# Ver el estado de los cambios
openspec status

# Ver una spec existente
openspec specs auth-session
```

## Integracion con agentes GGS

En el workflow SDD de GGSoluciones:

```
1. sdd-init          → Bootea el contexto
2. sdd-propose       → Define alcance (similar a proposal.md)
3. sdd-spec          → Escribe requisitos en Gherkin (similar a spec.md)
4. sdd-design        → Diseño tecnico (similar a design.md)
5. sdd-tasks         → Descomposicion en tareas (similar a tasks.md)
6. sdd-apply         → Implementacion
7. sdd-verify        → Verificacion
8. sdd-archive       → Archivar
```

**OpenSpec vs SDD GGS:**

| Concepto OpenSpec | Equivalente GGS |
|------------------|-----------------|
| `openspec new` | `sdd-propose` |
| `spec.md` | `sdd-spec` |
| `design.md` | `sdd-design` |
| `tasks.md` | `sdd-tasks` |
| `sdd-apply` | coding |
| Session-based | File-based |

La diferencia clave: **OpenSpec persiste en archivos versionables**. SDD GGS puede usar OpenSpec como backend de persistencia.

## Cuándo usar OpenSpec

**Usar OpenSpec cuando:**
- El equipo necesita visibilidad sobre QUE esta cambiando y POR QUE
- Varios agentes o desarrolladores trabajan en el mismo cambio
- Se quiere un audit trail de decisiones de diseno
- El cambio es sustancial (feature, refactor, bug complejo)
- Se necesita compartir el plan sin compartir una sesion de chat

**No usar OpenSpec cuando:**
- El cambio es trivial (< 30 min, sin riesgo)
- Solo vos trabajas en ello y no necesitás compartir contexto
- Estas en modo exploracion rapida

## Ventajas sobre otros enfoques

| Problema | Sin OpenSpec | Con OpenSpec |
|----------|--------------|--------------|
| Nuevo dev que pregunta como funciona | "pregunale a fulano" | "leer openspec/specs/" |
| Agente sin contexto | "le falta contexto" | "leer la spec" |
| Review de cambio | "revisar todo el codigo" | "revisar proposal + design + spec delta" |
| Cambio de agentes | "pierdo todo el contexto" | specs viven en el repo |
|Onboarding nuevo | meses para entender | semanas |

## Siguiente paso

Ver `reglas/sdd-tdd/AGENT.md` para entender como SDD y TDD se integran con OpenSpec.

## Recursos

- Sitio: https://openspec.dev/
- GitHub: https://github.com/Fission-AI/OpenSpec/
- Discord: https://discord.gg/YctCnvvshC
