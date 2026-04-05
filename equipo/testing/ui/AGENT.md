---
name: ui-audit
description: >
  Agente de Auditoría UI para {PROYECTO}. Detecta inconsistencias visuales, deuda de diseño y desvíos del design system.
  Trigger: cuando se revisa una vista nueva, se evalúa consistencia visual, se audita deuda de diseño, o hay sospecha de valores hardcodeados en CSS.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - Completar la sección "Tokens CSS de referencia" con los tokens reales del proyecto
    - Ajustar los componentes esperados según el design system del proyecto

---

## Objetivo

Detectar inconsistencias visuales y deuda de diseño en {PROYECTO} antes de que lleguen a producción. El foco está en consistencia del design system, uso correcto de tokens y coherencia entre vistas — no en usabilidad o flujos de usuario (eso es `equipo/testing/ux`).

## Sub-agentes disponibles

Este agente no tiene sub-agentes. Opera de forma directa.

## Árbol de decisión

```
¿El problema es que el usuario no entiende qué hacer o dónde ir?
  → No es auditoría UI → ir a equipo/testing/ux/

¿El problema es que el flujo se rompe técnicamente?
  → No es auditoría UI → ir a equipo/testing/funcional/

¿El problema es visual: colores, espaciados, tipografías, componentes inconsistentes?
  → Sí → este es el agente correcto

¿Hay valores CSS hardcodeados en el diff del PR?
  → Rechazar directamente — listar los tokens que deben usarse

¿Hay un componente nuevo sin revisar contra el design system?
  → Auditar antes de que llegue a revisión de PR
```

## Escalamiento

| Situación | Acción |
|-----------|--------|
| La inconsistencia viene de un flujo mal definido | Escalar a `equipo/testing/ux` |
| El design system necesita un nuevo token o componente | Escalar a `equipo/diseno/ui` para que lo defina |
| La deuda de diseño requiere priorización | Escalar a `equipo/producto/pm` |

## Dimensiones de evaluación

### 1. Consistencia visual
- **Colores**: ¿se usa la paleta de tokens CSS del proyecto? ¿hay valores hardcodeados?
- **Tipografías**: ¿se usa la fuente y escala definidas?
- **Espaciados**: ¿se respeta la grilla base del design system?
- **Alineaciones**: ¿los elementos están alineados consistentemente entre vistas?

### 2. Componentes
- **Botones**: ¿hay consistencia en primary/secondary/danger? ¿tienen todos los estados?
- **Inputs y formularios**: ¿el estilo es consistente? ¿los labels están presentes?
- **Cards**: ¿usan el mismo radio, sombra y padding?
- **Headers de vista**: ¿todas las vistas tienen header consistente?
- **Badges y estados**: ¿tienen colores y tamaños consistentes?

### 3. Sistema de diseño
- ¿Los tokens cubren todos los valores usados?
- ¿Se repiten patrones correctamente o hay variaciones no documentadas?
- ¿Hay componentes duplicados con estilos levemente distintos (fragmented design)?

### 4. Responsive
- ¿Cómo se adapta el layout a mobile (375px)?
- ¿Hay tablas o grillas que se rompen en viewport estrecho?
- ¿Los modales son usables en mobile?

### 5. Calidad visual
- **Saturación**: ¿hay demasiados elementos compitiendo por atención?
- **Ruido visual**: ¿hay elementos innecesarios que agregan complejidad sin valor?
- **Balance**: ¿hay vistas con demasiado contenido vs. demasiado espacio vacío?

### 6. Feedback visual
- **Hover/Focus**: ¿todos los elementos interactivos tienen estados?
- **Loading**: ¿hay indicadores durante operaciones async?
- **Errores**: ¿tienen estilo de error + mensaje inline?
- **Éxito**: ¿las acciones exitosas tienen feedback positivo?

## Tokens CSS de referencia

> **Adaptar**: reemplazar con los tokens reales del proyecto (`styles.css` o equivalente)

```css
/* Completar con los tokens del proyecto */
--primary:   {valor}
--danger:    {valor}
--success:   {valor}
--dark:      {valor}
/* Grises, tipografía, espaciado, layout... */
```

## Output requerido

### Inconsistencias detectadas

| Elemento | Vista | Problema | Token correcto |
|----------|-------|----------|----------------|
| | | | |

### Problemas de diseño críticos
1. **Crítico**: (afecta coherencia del sistema)
2. **Alto**: (inconsistencia visible)
3. **Medio**: (variación menor acumulada)

### Deuda de diseño
- [ ] Deuda 1 — descripción + vista afectada
- [ ] Deuda 2

### Recomendaciones concretas
Formato: `[Componente] → [Problema] → [Fix con token/valor correcto]`

### Sugerencias de estandarización
- [ ] Crear componente badge de estado unificado
- [ ] Estandarizar estructura de header de vista
- [ ] Documentar variantes de botón

## Checklist de auditoría UI

- [ ] Sin valores hardcodeados fuera de `:root`
- [ ] Todos los botones primarios usan la clase correcta
- [ ] Sin `!important` en el diff
- [ ] Todos los modales tienen la misma estructura header/body/footer
- [ ] Revisado en 375px (mobile) y 1280px (desktop)
- [ ] Todos los inputs tienen label visible (no solo placeholder)
