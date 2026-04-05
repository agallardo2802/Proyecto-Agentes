# Cómo modificar un agente existente

Seguí este proceso cada vez que necesités actualizar un agente para que los cambios queden bien documentados y el equipo esté alineado.

---

## Cuándo modificar vs. crear nuevo

| Situación | Acción |
|-----------|--------|
| Una regla existente cambió | **Modificar** el agente existente |
| Se agrega una regla al área ya cubierta | **Modificar** el agente existente |
| El agente cubre un área completamente nueva | **Crear** agente nuevo |
| El agente creció demasiado (>150 líneas) | **Dividir** en dos agentes |
| Una regla quedó desactualizada | **Eliminar** la regla + bumping version |

---

## Proceso de modificación

### 1. Identificar el agente correcto

```
¿El cambio aplica a ONE área específica?
  → Sí → modificar ese agente
  → No → podría necesitar modificar varios o crear un orchestrator update
```

### 2. Aplicar el cambio mínimo

- Cambiar solo lo que cambió — no aprovechar para "mejorar" otras partes
- Si encontrás algo roto mientras modificás: **fix en commit separado**

### 3. Bumping de versión

| Tipo de cambio | Version bump |
|---------------|-------------|
| Nueva regla o sección | Minor: `1.0` → `1.1` |
| Corrección de error | Patch: `1.0` → `1.0.1` |
| Reescritura significativa | Major: `1.0` → `2.0` |

```yaml
# Actualizar en el frontmatter
metadata:
  version: "1.1"   # ← bumpeado
```

### 4. Documentar el cambio

Agregar al final del archivo una sección de changelog (solo para major/minor):

```markdown
## Changelog

### v1.1
- Agregada regla 8: {descripción breve}
- Actualizado checklist: {qué cambió}

### v1.0
- Versión inicial
```

### 5. Checklist antes de commitear

- [ ] Solo se modificó lo necesario
- [ ] Version bumpeado si aplica
- [ ] Ejemplos actualizados si las reglas cambiaron
- [ ] Checklist actualizado
- [ ] Si es un agente de proyecto: verificar que sigue alineado con el código real
- [ ] Anunciar el cambio al equipo (Slack, daily, etc.)

---

## Adaptar un agente BASE a un proyecto nuevo

Cuando copiás un agente de `Agentes base/` a `gobernanza/skills/` de un proyecto:

```bash
# 1. Copiar el agente
cp "Agentes base/fundamentos/error-handling/AGENT.md" \
   "mi-proyecto/gobernanza/skills/error-handling/SKILL.md"

# 2. Renombrar AGENT.md → SKILL.md (convención del proyecto)
# 3. Buscar y reemplazar todos los placeholders
```

### Placeholders estándar a reemplazar

| Placeholder | Reemplazar por |
|-------------|---------------|
| `{PROYECTO}` | Nombre del proyecto (ej: "Portal Ventas El Cuatro") |
| `{REPO}` | owner/repo (ej: "agallardo2802/portal-ventas-elcuatro") |
| `{STACK}` | Stack tecnológico (ej: "Vanilla JS / HTML / CSS") |
| `{valor}` | Valor real del token o configuración |
| `type: base` | `type: proyecto` |
| `author: {Tu nombre}` | `author: Alejandro Gallardo` |

### Qué adaptar según el tipo

**Standards (ui, css-arquitectura, typography):**
- Completar todos los tokens CSS con los valores reales de `styles.css`
- Ajustar escala tipográfica si es diferente

**Auditoría (ux-research, ui-audit, qa-funcional):**
- Reemplazar flujos genéricos por los flujos reales del negocio
- Agregar los casos de prueba específicos del proyecto

**Proceso (pr, testing, cicd):**
- Ajustar el nombre de la rama principal (main vs master)
- Actualizar los comandos de npm/yarn/pnpm
- Agregar variables de entorno reales en onboarding

**Equipo (board-tasks):**
- Ajustar los estados del tablero si son distintos
- Reemplazar Jira por Linear u otra herramienta si aplica
