# 03 - OpenSpec

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Que es OpenSpec y para que sirve
- Como se integra con el workflow SDD de GGS
- Cuando usar OpenSpec vs guardar en memoria

---

## Que es OpenSpec

OpenSpec es un framework ligero de planificacion centrado en specs. Los specs viven en el repo junto al codigo, organizados por capacidad, y se crean a medida que se construye.

**En una oracion**: specs que persisten en el repo para que todos los agentes y desarrolladores tengan contexto alineado, sin importar cuando se unan o cuanto tiempo pase.

Sitio oficial: https://openspec.dev/

---

## Conceptos Clave

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

### Delta de Specs

Los cambios muestran COMO se modifican los requisitos. El diff de specs usa notacion diff (`-` quitado, `+` agregado) para que sea facil de revisar:

```
- El sistema DEBE expirar sesiones despues de 24hs
+ El sistema DEBE soportar periodos de expiracion configurables
```

---

## Comandos Basicos

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

---

## Integracion con Agentes GGS

En el workflow SDD de GGSoluciones:

```
1. sdd-init          → Bootea el contexto
2. sdd-propose       → Define alcance (similar a proposal.md)
3. sdd-spec          → Escribe requisitos en Gherkin (similar a spec.md)
4. sdd-design        → Diseno tecnico (similar a design.md)
5. sdd-tasks         → Descomposicion en tareas (similar a tasks.md)
6. sdd-apply         → Implementacion
7. sdd-verify        → Verificacion
8. sdd-archive       → Archivar
```

### Comparacion: OpenSpec vs SDD GGS

| Concepto OpenSpec | Equivalente GGS |
|------------------|---------------|
| `openspec new` | `sdd-propose` |
| `spec.md` | `sdd-spec` |
| `design.md` | `sdd-design` |
| `tasks.md` | `sdd-tasks` |
| `sdd-apply` | coding |
| Session-based | File-based |

**Diferencia clave**: **OpenSpec persiste en archivos versionables**. SDD GGS puede usar OpenSpec como backend de persistencia.

---

## Cuando Usar OpenSpec

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

---

## Ventajas sobre Otros Enfoques

| Problema | Sin OpenSpec | Con OpenSpec |
|----------|--------------|--------------|
| Nuevo dev que pregunta como funciona | "pregunale a fulano" | "leer openspec/specs/" |
| Agente sin contexto | "le falta contexto" | "leer la spec" |
| Review de cambio | "revisar todo el codigo" | "revisar proposal + design + spec delta" |
| Cambio de agentes | "pierdo todo el contexto" | specs viven en el repo |
| Onboarding nuevo | meses para entender | semanas |

---

## Modos de Persistencia

En el sistema GGS tenes tres modos:

| Modo | Cuando usarlo | Pros | Contras |
|------|--------------|------|---------|
| **engram** | Desarrollo solo | Rapido, sin archivos | No compartible |
| **openspec** | Equipo | Trail completo, git-friendly | Mas archivos |
| **hybrid** | Ambos | Compartible + recovery | Costo en tokens |
| **none** | Solo prueba | Ligero | Se pierde todo |

---

## Resumen

| Concepto | Punto clave |
|----------|-------------|
| OpenSpec | Specs que persisten en el repo |
| Change | Unidad de trabajo con proposal, design, tasks |
| Delta | Diff de specs versionable |
| Integracion | Se mapea a las fases SDD |
| Cuando usar | Cambios sustanciales, equipos, audit trail |

---

## Siguiente Capitulo

Continuar con: [04-Gherkin](./04-gherkin.md)

## Recursos

- Sitio: https://openspec.dev/
- GitHub: https://github.com/Fission-AI/OpenSpec/
- Discord: https://discord.gg/YctCnvvshC
