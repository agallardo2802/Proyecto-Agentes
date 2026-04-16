# Contribuir a GGS - Agentes de IA

Gracias por querer aportar. Este proyecto crece con la experiencia de quienes usan IA en equipos reales — tu perspectiva tiene valor acá.

---

## ¿Qué podés aportar?

- **Nuevo agente** — un rol que falta en el sistema (ej: seguridad, mobile, ML)
- **Mejora a un agente existente** — árbol de decisión más completo, mejores principios, escalamiento más preciso
- **Nuevo guild** — estándares para un stack que no está cubierto (ej: React, Python, Java)
- **Nueva regla** — conocimiento técnico granular inyectable (ej: accesibilidad, i18n)
- **Adaptación de stack** — config para tu tecnología en `config/proyectos/`
- **Documentación** — ejemplos de uso, casos reales, guías
- **Skill SDD** — workflow completo para un equipo o contexto específico

---

## Getting Started

Para adaptar este proyecto a tu equipo:

1. Configurá tu stack en `config/proyectos/tu-proyecto.config.md`
2. Seleccioná los guilds que correspondan a tu tecnología
3. Personalizá las reglas según tus estándares
4. Leé los agentes en `equipo/` para entender el flujo

---

## Antes de empezar

1. Abrí un **issue** describiendo qué querés agregar o cambiar
2. Esperá feedback antes de escribir código — así evitamos trabajo duplicado
3. Forkea el repo y trabajá en una rama con nombre descriptivo:
   - `feat/guild-react-nextjs`
   - `improve/dev-agent`
   - `fix/testing-unitario`
   - `docs/new-guide`

---

## Estructura de un agente

Todo agente nuevo debe seguir esta estructura en su `AGENT.md`:

```markdown
---
name: nombre-del-agente
description: Una línea que explica qué hace
---

## Objetivo
Qué resuelve este agente y cuándo se usa.

## Sub-agentes disponibles
Lista de sub-agentes o "Este agente no tiene sub-agentes."

## Árbol de decisión
Flujo de preguntas Sí/No que guía al agente en cada situación.

## Escalamiento
Tabla con situaciones y a quién escalar.

## Responsabilidades
Lista de lo que hace.

## Principios irrenunciables
Lo que NUNCA debe hacer este agente.

## Checklist de entrega
Criterios verificables antes de considerar una tarea terminada.
```

Usá los templates en `templates/nuevo-agente/` y `templates/modificar-agente/` como punto de partida.

---

## Estructura de un skill SDD

Skills van en `equipo/` o en la raíz de skills del proyecto:

```markdown
---
name: sdd-nombre
description: Descripción del workflow
---

## Propósito
Qué hace este skill y cuándo se usa.

## Proceso
Pasos del workflow (Análisis, Diseño, Implementación, etc.)

## Agentes Automáticos
Qué agentes carga automáticamente según el contexto.

## Referencias
 Links a los archivosrelatedos.
```

---

## Proceso de PR

1. Abrí el PR hacia `main` con una descripción clara de qué cambia y por qué
2. Referenciá el issue relacionado (`Closes #123`)
3. Un mantenedor va a revisar y puede pedir ajustes
4. Una vez aprobado, se mergea

---

## Convenciones de commit

```
feat: agregar nuevo guild React Native
fix: corregir tree de decisión en dev-c4
docs: actualizar guía del equipo
refactor: extraer lógica común a regla compartida
chore: actualizar dependencias
```

---

## Preguntas

Abrí un issue con el tag `question` o `discussion`. Todo feedback es bienvenido.

---

## Recursos

- README principal: [README.md](README.md)
- Guía del equipo: [equipo/](equipo/)
- Índice de agentes: [.atl/skill-registry.md](.atl%2Fskill-registry.md)