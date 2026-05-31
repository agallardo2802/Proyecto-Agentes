---
name: diseno-reportes-ggs
description: >
  Regla visual obligatoria para informes HTML, dashboards, reportes ejecutivos y visualizaciones de datos de GGSoluciones.
  Trigger: reporte HTML, dashboard, informe ejecutivo, métricas visuales, presentación, tablero o visualización de datos.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.1"
  type: base
---

# Diseño de reportes GGSoluciones

## Regla obligatoria

Todo informe HTML, dashboard, reporte ejecutivo o visualización de métricas para GGSoluciones DEBE usar como base visual canónica:

`{RUTA_REFERENCIA_VISUAL}`

No inventar estética. Antes de generar o modificar el HTML, leer esa plantilla y reutilizar su lenguaje visual.

## Logo obligatorio

Usar SIEMPRE el logo oficial claro en headers oscuros:

```html
<img src="{URL_LOGO_EMPRESA}"
     alt="GGSoluciones"
     class="hlogoimg"/>
```

No reemplazarlo por texto, emoji, placeholder ni wordmark improvisado, salvo que el usuario pida explícitamente una versión offline.

## Layout obligatorio para reportes

El reporte DEBE seguir esta estructura base:

1. Header oscuro `.header` con borde inferior rojo `--red`.
2. Marca `.hbrand` con logo oficial y bloque `.hcopy`.
3. Hero oscuro `.hero-band` con degradado `--dark -> #16213e -> #0f3460`.
4. Contenido en `.wrap`.
5. Secciones `.section` con encabezado `.sec-head`, número `.sec-num`, título `.sec-title` y subtítulo `.sec-sub`.
6. KPIs en cards blancas `.card.panel`.
7. Badges semánticos `.badge` usando `b-red`, `b-blue`, `b-green`, `b-orange`, `b-purple`, `b-sky`.
8. Tablas dentro de `.t-wrap` con estilos de la plantilla.
9. Callouts `.callout` cuando haga falta explicar hallazgos o riesgos.

## Tokens canónicos

Usar estos tokens como base. Se pueden extender, pero no cambiar sin justificar:

```css
:root{
  --dark:#1a1a2e;
  --bg:#f8f9fb;
  --panel:#ffffff;
  --panel2:#f8fbff;
  --text:#1f2937;
  --muted:#6b7280;
  --line:#e5e7eb;
  --red:#e30613;
  --red-soft:rgba(227,6,19,.10);
  --sky:#4bbfdf;
  --sky-soft:rgba(75,191,223,.12);
  --blue:#2d7ff9;
  --blue-soft:#eaf3ff;
  --green:#16a34a;
  --green-soft:rgba(22,163,74,.10);
  --orange:#d97706;
  --orange-soft:rgba(217,119,6,.12);
  --purple:#7c3aed;
  --purple-soft:rgba(124,58,237,.10);
  --shadow:0 4px 20px rgba(0,0,0,.07);
  --shadow-sm:0 4px 12px rgba(15,23,42,.06);
  --radius:16px;
  --radius-sm:14px;
}
```

## Tipografía obligatoria

Usar la misma carga tipográfica de la plantilla:

```html
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&family=Roboto+Condensed:wght@400;700;900&family=Roboto+Mono:wght@400;500&display=swap" rel="stylesheet"/>
```

- Texto: `Roboto`.
- Títulos, números fuertes y marca: `Roboto Condensed`.
- Código/IDs técnicos opcionales: `Roboto Mono`.

## Reglas de aceptación visual

- [ ] Header oscuro con línea roja inferior.
- [ ] Logo oficial `ggsoluciones-light-297x48.png` visible en header.
- [ ] Hero-band presente en reportes ejecutivos.
- [ ] Cards blancas, no dashboard dark genérico.
- [ ] KPIs visibles arriba del detalle.
- [ ] Fuente de datos y fecha de actualización visibles.
- [ ] Semáforos/badges consistentes: rojo crítico, naranja atención, verde OK, azul informativo.
- [ ] Tablas y drill-down no deben ser una sábana plana si existe jerarquía.
- [ ] Responsive mínimo 760px y 900px como la plantilla.

## Anti-patrones rechazados

- Dashboard dark genérico sin relación con la plantilla.
- Logo textual inventado `GGSOLUCIONES` si puede usarse el logo oficial.
- Colores hardcodeados fuera de tokens.
- Reportes de métricas sin fecha de actualización.
- Tablas gigantes sin agrupación/drill-down cuando hay jerarquía.

## Industry Reasoning — Tipos de producto GGSoluciones

> Adaptado de UI/UX Pro Max. Mapping de tipo de producto → diseño recomendado para portales internos y reportes de GGSoluciones.

### Categorías de producto GGSoluciones

| Category | Descripción | Patrón recomendado | Estilo recomendado |
|----------|-------------|-------------------|-------------------|
| **Portal comercial** | Venta, gestión de clientes, pipeline | Hero-centric + Tabular | Corporate minimal, cards claras |
| **Portal backoffice** | Administración, configuraciones, usuarios | Data-dense, sidebar nav | Professional, functional |
| **Dashboard operativo** | Métricas en tiempo real, estados | Executive dashboard | Data-dense, bien estructurado |
| **Reporte ejecutivo** | InformesHTML, presentaciones de métricas | Hero-band + KPI cards | Institucional con brand |
| **E-commerce interno** | Catálogo, gestión de productos | E-commerce grid | Clean, organized |
| **Sistema de turnos** | Agenda, disponibilidad, calendario | Calendar-centric, booking | Functional, clear |
| **Autogestión** | Portales de empleado, herramientas internas | Minimal, functional | Professional, light |
| **BI / Analytics** | Análisis de datos, visualizaciones | Chart-heavy, drill-down | Data-focused, accessible |

### Patrones de landing page (aplica a portales con homepage)

| Patrón | Cuándo usar | Estructura |
|--------|-------------|------------|
| **Hero-Centric** | Portales con fuerte identidad visual | Hero + Features + Social proof + CTA |
| **Feature-Rich Showcase** | SaaS interno con múltiples módulos | Header + Features grid + Detail sections |
| **Social Proof-Focused** | Portales de confianza (pagos, legales) | Testimonials + Trust badges + Stats |
| **Data-Dense Dashboard** | Backoffice y dashboards operativos | KPI cards + Tables + Quick actions |
| **Conversion-Optimized** | Portales con objetivo de acción (cotizar, comprar) | Hero + Benefits + CTA repetido |

### Estilos UI por contexto GGSoluciones

| Contexto | Estilo | Por qué |
|----------|--------|---------|
| Portal Comercial | Corporate minimal con cards claras | Profesional, confianza, accionable |
| Backoffice | Functional con sidebar fixa | Navegación clara, acceso rápido |
| Dashboard BI | Data-dense bien estructurado | Información primero, claridad de datos |
| Reporte HTML | Institucional con brand | Marca visible, profesional, exportable |
| Login corporativo | Clean con contraste oscuro | Institucional, seguro |
| Mobile-adapted | Responsive, touch-friendly | Accesible, usable en móvil |

### Anti-patterns por industria (GGSoluciones)

| Industria/Contexto | NO hacer | Por qué |
|-------------------|----------|---------|
| **Reportes ejecutivos** | Dashboard dark genérico | Brand lost, no institucional |
| **Portales comerciales** | Colores bright/neón, gradientes AI purple/pink | Pierde profesionalismo |
| **Login** | Emojis como iconos, login simple sin branding | No confianza, no institucional |
| **Dashboards operativos** | Animaciones decorativas, parallax | Distraen, no agrega valor |
| **BI/Analytics** | Charts sin tooltips, sin leyenda, sin labels | Data no legible |
| **Todos** | Placeholder como logo si existe el oficial | Brand inconsistency |
| **Todos** | Sin contraste en dark mode | Accesibilidad |

### Efectos y transiciones recomendados

| Efecto | Duración | Uso en GGSoluciones |
|--------|----------|------------------|
| **Hover de cards** | 150-200ms ease-out | Cards KPI, items de lista |
| **Transición de tabs** | 200-300ms ease | Tab switching, panel transitions |
| **Modals** | 250-300ms ease-out | Confirmaciones, detalles |
| **Toast notifications** | 150ms fade-in, auto-dismiss 3-5s | Feedback de acciones |
| **Skeleton shimmer** | 1.5s loop | Loading states >300ms |
| **Pressed state** | 80-120ms | Botones, elementos tappeables |

### Sistema de colores semántico (extensión de tokens)

| Token | Uso | Valor canónico |
|-------|-----|----------------|
| `--c-primary` | Acciones primarias, CTA principales | `#e30613` (rojo GGSoluciones) |
| `--c-secondary` | Acciones secundarias, navegación | `#2d7ff9` (azul) |
| `--c-success` | Estados OK, completion, positive | `#16a34a` (verde) |
| `--c-warning` | Atención, warning, pending | `#d97706` (naranja) |
| `--c-danger` | Errores, acciones destructivas | `#dc2626` (rojo intenso) |
| `--c-info` | Información, badges neutrales | `#4bbfdf` (sky) |
| `--c-surface-dark` | Fondos de portal dark | `#1a1a2e` |
| `--c-surface-light` | Fondos de vista, cards claras | `#ffffff` / `#f8f9fb` |
| `--c-text-primary` | Texto principal | `#1f2937` / `#f8f9fb` (dark) |
| `--c-text-muted` | Texto secundario, labels | `#6b7280` |

### Checklist de pre-entrega para reportes

- [ ] Header oscuro con línea inferior roja (`border-bottom: 2px solid var(--red)`)
- [ ] Logo oficial visible en header (`ggsoluciones-light-297x48.png`)
- [ ] Hero-band presente con gradiente institucional
- [ ] KPI cards en la parte superior (antes del detalle)
- [ ] Cards blancas, no dashboard dark genérico
- [ ] Tokens de color usados, no hex hardcodeados
- [ ] Fecha de actualización visible y fuente de datos
- [ ] Badges semánticos: rojo crítico, naranja atención, verde OK, azul informativo
- [ ] Tablas con grouping cuando hay jerarquía (no sábana plana)
- [ ] Charts con leyenda visible y tooltips
- [ ] Responsive verificado en 760px y 900px (como la plantilla)
- [ ] Tipografía: Roboto Condensed para títulos/números, Roboto para texto
- [ ] Contraste verificado: texto sobre fondos claros ≥4.5:1
- [ ] No emojis como iconos (usar SVG o caracteres de texto)
