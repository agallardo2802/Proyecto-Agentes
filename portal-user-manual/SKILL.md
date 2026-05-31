---
name: portal-user-manual
description: >
  Crear, revisar o adaptar manuales de usuario, guías operativas, presentaciones o decks
  para portales internos de GGSoluciones. Usar cuando el usuario quiera documentar cómo usar
  un portal, sus módulos, pantallas, roles, flujos, botones, tablas, filtros, acciones,
  errores frecuentes y funciones disponibles para usuarios finales.
---

# Portal User Manual

Usá este skill cuando el usuario quiera crear o revisar un **manual de usuario de un portal interno** para que las personas sepan cómo usarlo y qué hace cada función.

## Diseño Visual - Template Estándar

**Archivo de referencia**: usar la guía HTML vigente del proyecto cuando exista. No asumir rutas locales absolutas.

Este es el diseño base para TODOS los portales y manuales internos de GGSoluciones.

### Logo (OBLIGATORIO)

```
{URL_LOGO_EMPRESA}
```

### Fuente (OBLIGATORIA)

```html
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;800&display=swap" rel="stylesheet"/>
```

**USAR SOLO ROBOTO** - No usar Roboto Condensed, Roboto Mono u otras fuentes.

### Colores CSS (OBLIGATORIOS)

```css
:root {
  /* Colores GGSoluciones */
  --red: #E30613;
  --red-light: #fef2f2;

  /* Colores complementarios */
  --blue: #4BBFDF;
  --blue-dark: #1a7a9a;
  --blue-light: #f0fbff;

  /* Fondos y superficies */
  --dark: #1a1a2e;
  --bg: #f8f9fb;
  --panel: #ffffff;

  /* Texto */
  --text: #1f2937;
  --muted: #6b7280;

  /* Bordes y sombras */
  --line: #e5e7eb;
  --shadow: 0 4px 20px rgba(0,0,0,.07);
  --radius: 16px;

  /* Estados */
  --green: #16a34a;
  --green-light: #f0fdf4;
  --orange: #d97706;
  --orange-light: #fffbeb;
}
```

### Estructura de la página

```
┌─────────────────────────────────────────────────────────┐
│ HEADER (sticky, fondo dark #1a1a2e, border-bottom red) │
│ [Logo] [Brand Title] [Botones de acción]               │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ HERO (gradiente dark, texto claro)                      │
│ [Badge] [H1] [Párrafo introductorio]                   │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ CONTENT                                                 │
│ .section (padding, border-bottom)                       │
│   .section-label (uppercase, red)                       │
│   .section-title (h2, bold)                             │
│   .section-sub (muted)                                  │
│   [grid-2 / grid-3 / grid-4]                            │
│   [cards / usecases / tips]                             │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│ FOOTER (dark, centrado)                                 │
└─────────────────────────────────────────────────────────┘
```

### Elementos de UI

| Elemento | Clase CSS | Descripción |
|----------|-----------|-------------|
| Cards | `.card` | Fondo white, border, radius 16px, shadow |
| Cards con borde colored | `.card.green`, `.card.red`, `.card.blue`, `.card.orange` | border-left 4px colored |
| Grid 2 columnas | `.grid-2` | display: grid; grid-template-columns: 1fr 1fr |
| Grid 3 columnas | `.grid-3` | display: grid; grid-template-columns: repeat(3, 1fr) |
| Use case | `.usecase` | Card con icono + body (título + descripción + tag) |
| Tips | `.tip-row` | Número + cuerpo con ejemplo |
| Semáforo | `.semaforo-grid` | 3 columnas: verde/amarillo/rojo |
| Callout | `.callout-final` | Gradient dark, icono + texto |
| Badges | `.pill` | Pills de estado |

### Responsive

```css
@media(max-width: 95%) {
  .grid-2, .grid-3, .grid-4, .semaforo-grid, .profile-grid { grid-template-columns: 1fr; }
}
```

---

## Referencia editorial obligatoria

Antes de estructurar el manual, leé:

- `references/intranet-ia-guide-page-skill.md`

Esa referencia define tono interno, claridad, estructura didáctica, seguridad, navegación y checklist visual. No limita el manual a IA: se usa como estándar editorial y UX para contenido interno GGSoluciones.

---

## Objetivo del manual

El manual debe permitir que un usuario final entienda:

- para qué sirve el portal;
- qué roles existen y qué ve cada uno;
- cómo ingresar y navegar;
- qué hace cada módulo/pantalla;
- cómo usar botones, filtros, tablas, formularios y acciones;
- qué mensajes o errores puede ver y qué hacer;
- qué datos no debe cargar o compartir;
- a quién pedir ayuda.

## Objetivo del manual

El manual debe permitir que un usuario final entienda:

- para qué sirve el portal;
- qué roles existen y qué ve cada uno;
- cómo ingresar y navegar;
- qué hace cada módulo/pantalla;
- cómo usar botones, filtros, tablas, formularios y acciones;
- qué mensajes o errores puede ver y qué hacer;
- qué datos no debe cargar o compartir;
- a quién pedir ayuda.

## Reglas

1. **Manual accionable, no decorativo**: explicar pasos concretos con resultado esperado.
2. **Una función = una explicación**: objetivo, pasos, campos/botones y errores comunes.
3. **Role-aware**: separar instrucciones por rol cuando el portal cambie navegación o permisos.
4. **Evidencia real**: no inventar pantallas; validar contra archivos, HTML servido, screenshots o descripción confirmada.
5. **Lenguaje de usuario**: evitar nombres internos técnicos salvo que sean visibles para el usuario.
6. **Capturas si aplican**: pedir o usar screenshots cuando la explicación visual mejore el manual.
7. **Formato reusable**: dejar estructura fácil de versionar como Markdown, HTML o PPTX según pida el usuario.

## Estructura recomendada

1. Portada: nombre del portal, versión/fecha y audiencia.
2. Introducción: para qué sirve y qué problemas resuelve.
3. Acceso: login, recuperación/ayuda, roles disponibles.
4. Navegación general: menú, header, búsqueda, cambio de tema si existe.
5. Módulos del portal: una sección por módulo.
6. Funciones por pantalla: botones, filtros, tablas, formularios, exportaciones, estados.
7. Flujos frecuentes: paso a paso de tareas reales.
8. Errores comunes: mensaje visible, causa probable, qué hacer.
9. Buenas prácticas: datos, seguridad, validación y soporte.
10. Glosario breve si hay términos propios del negocio.

## Flujo obligatorio

1. Identificar portal, audiencia, roles y formato esperado del manual.
2. Verificar evidencia disponible: repo, screenshots, HTML servido, rutas o descripción funcional.
3. Leer `references/intranet-ia-guide-page-skill.md` para tono y estructura.
4. Armar índice del manual antes de escribir contenido largo.
5. Redactar por módulos y funciones, con pasos claros.
6. Validar que no falten funciones visibles ni roles principales.
7. Si el output es `.pptx`, usar la skill/herramienta de Presentations.

## Checklist de diseño visual

- [ ] Logo GGSoluciones presente: `{URL_LOGO_EMPRESA}`
- [ ] Fuente Roboto cargada desde Google Fonts
- [ ] Colores CSS usando los tokens definidos (--red: #E30613, --blue: #4BBFDF, etc.)
- [ ] Header con fondo dark, logo y border-bottom red
- [ ] Hero con gradiente y estructura correcta
- [ ] Sections con section-label (uppercase, red) + section-title + section-sub
- [ ] Cards con border-radius 16px y shadow
- [ ] Grids responsive (colapsan a 1 columna en móvil)
- [ ] Footer dark centrado

## Checklist de contenido

- [ ] El manual explica todas las funciones visibles del portal.
- [ ] Está separado por módulo/pantalla y por rol cuando aplica.
- [ ] Cada acción importante tiene pasos y resultado esperado.
- [ ] Tablas, filtros, botones y formularios están explicados.
- [ ] Errores frecuentes tienen explicación no técnica.
- [ ] No hay datos sensibles ni supuestos sin marcar.
- [ ] El tono es claro para usuarios no técnicos.
- [ ] El formato final sirve para compartir con usuarios.
