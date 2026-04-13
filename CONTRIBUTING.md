# Contribuir a Arquitectura de Agentes de IA

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

## Para El Cuatro - Stack 2026

Este repositorio incluye configuración específica para **El Cuatro - Canal 4** con el stack definido en `Stack Tecnológico/Arquitectura Tecnológica 2026.html`:

| Componente | Archivo | Propósito |
|-----------|---------|----------|
| Skill SDD C4 | `equipo/sdd-c4/SKILL.md` | Workflow SDD + TDD específico |
| Dev C4 | `equipo/desarrollo/dev-c4/AGENT.md` | Dev especializado con stack |
| Guild .NET 8 | `guilds/backend-dotnet-8/AGENT.md` | Patrones CQRS, MediatR |
| Guild React | `guilds/frontend-react-nextjs/AGENT.md` | React + Next.js |
| Guild Mobile | `guilds/mobile-react-native/AGENT.md` | React Native + Expo |
| Guild RabbitMQ | `guilds/messaging-rabbitmq/AGENT.md` | Colas async |
| Guild Grafana | `guilds/observabilidad-grafana/AGENT.md` | Métricas y logs |
| Regla YARP | `reglas/yarp-gateway/AGENT.md` | API Gateway |

---

## Antes de empezar

1. Abrí un **issue** describiendo qué querés agregar o cambiar
2. Esperá feedback antes de escribir código — así evitamos trabajo duplicado
3. Forkea el repo y trabajá en una rama con nombre descriptivo:
   - `feat/guild-react-nextjs`
   - `improve/dev-c4`
   - `fix/testing-unitario`
   - `docs/guia-el-cuatro`

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
- Guía del equipo: [GUIAS/EQUIPO/Guia-Equipo-El-Cuatro.md](GUIAS%20EQUIPO/Guia-Equipo-El-Cuatro.md)
- Stack completo: `Stack Tecnológico/Arquitectura Tecnológica 2026.html`
- Índice de agentes: [.atl/skill-registry.md](.atl%2Fskill-registry.md)