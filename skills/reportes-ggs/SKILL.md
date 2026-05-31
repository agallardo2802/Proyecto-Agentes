---
name: reportes-ggs
description: >
  Crear reportes HTML, dashboards, informes ejecutivos y métricas visuales para portales
  internos de GGSoluciones. Define estructura, estilos, componentes y estándares visuales.
  Usar cuando el usuario diga "reporte", "dashboard", "informe", "métricas", "exportar".
---

# Reportes GGSoluciones - Estándar para Informes y Dashboards

Este skill establece el estándar visual y funcional para todos los reportes, dashboards e informes en portales internos de GGSoluciones.

## Cuándo usar este skill

- Usuario dice: "crear reporte", "dashboard", "informe", "métricas", "exportar a PDF/Excel"
- Necesitás mostrar datos tabulares con gráficos o métricas visuales
- Crear informe ejecutivo o presentación de datos

## Reglas transversales obligatorias

**ANTES de crear cualquier reporte, LEER:**
- `reglas/diseno-reportes-ggs` — Estilo visual canónico
- `equipo/datos/bi-reporting` — Agente de BI
- `equipo/diseno/ui` — Agente de UI

**INYECTAR SIEMPRE:**
- `equipo/datos/bi-reporting`
- `equipo/diseno/ui`
- `reglas/css-arquitectura`
- `reglas/diseno-reportes-ggs`

## Logo obligatorio

```
{URL_LOGO_EMPRESA}
```

**Usar siempre**: En headers, footers, y cualquier elemento visual que represente la marca.

## Base visual canónica

```
{RUTA_REFERENCIA_VISUAL}
```

**Referencia obligatoria**: Ese archivo define el estilo canónico de reportes GGSoluciones.

## Estructura de un reporte

```html
<!-- Header del reporte -->
<header class="report-header">
  <div class="report-title">
    <img src="LOGO_GGS" alt="GGSoluciones" class="report-logo" />
    <h1>Nombre del Reporte</h1>
    <span class="report-subtitle">Período: Mayo 2026</span>
  </div>
  <div class="report-meta">
    <span class="report-date">Generado: 09/05/2026</span>
    <span class="report-user">Usuario: Alejandro Gallardo</span>
  </div>
</header>

<!-- KPIs / Métricas principales -->
<section class="report-kpis">
  <div class="kpi-card">
    <span class="kpi-label">Ventas Totales</span>
    <span class="kpi-value">$12.5M</span>
    <span class="kpi-delta positive">+15% vs mes anterior</span>
  </div>
  <!-- más KPIs... -->
</section>

<!-- Tabla de datos -->
<section class="report-table">
  <table>
    <thead>
      <tr>
        <th>Columna 1</th>
        <th>Columna 2</th>
        <th class="text-right">Monto</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Dato 1</td>
        <td>Dato 2</td>
        <td class="text-right">$1,000</td>
      </tr>
    </tbody>
    <tfoot>
      <tr>
        <td colspan="2">Total</td>
        <td class="text-right">$10,000</td>
      </tr>
    </tfoot>
  </table>
</section>

<!-- Gráfico (si aplica) -->
<section class="report-chart">
  <!-- Chart.js, ApexCharts, etc. -->
</section>

<!-- Footer -->
<footer class="report-footer">
  <span>Reporte generado automáticamente</span>
  <span>GGSoluciones - Todos los derechos reservados</span>
</footer>
```

## Componentes de reporte

### KPI Card

```html
<div class="kpi-card">
  <span class="kpi-label">Label descriptiva</span>
  <span class="kpi-value">$12,500,000</span>
  <span class="kpi-delta positive">+15%</span>
  <span class="kpi-period">vs abril 2026</span>
</div>
```

```css
.kpi-card {
  background: var(--ec-surface);
  border: 1px solid var(--ec-border);
  border-radius: var(--ec-radius-lg);
  padding: var(--ec-space-5);
  display: flex;
  flex-direction: column;
  gap: var(--ec-space-2);
}

.kpi-label {
  font-size: 13px;
  font-weight: 600;
  color: var(--ec-text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.kpi-value {
  font-size: 32px;
  font-weight: 800;
  color: var(--ec-text-primary);
}

.kpi-delta {
  font-size: 14px;
  font-weight: 700;
}

.kpi-delta.positive { color: var(--ec-success); }
.kpi-delta.negative { color: var(--ec-error); }
```

### Tabla de reporte

```css
.report-table table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.report-table th {
  background: var(--ec-bg-tertiary);
  padding: var(--ec-space-3) var(--ec-space-4);
  text-align: left;
  font-weight: 700;
  color: var(--ec-text-secondary);
  text-transform: uppercase;
  font-size: 12px;
  letter-spacing: 0.05em;
  border-bottom: 2px solid var(--ec-border);
}

.report-table td {
  padding: var(--ec-space-3) var(--ec-space-4);
  border-bottom: 1px solid var(--ec-border);
  color: var(--ec-text-primary);
}

.report-table tr:hover {
  background: var(--ec-bg-tertiary);
}

.report-table .text-right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.report-table tfoot td {
  font-weight: 700;
  background: var(--ec-bg-tertiary);
  border-top: 2px solid var(--ec-border);
}
```

## Tipos de reportes

### 1. Reporte tabular simple

- Tabla con datos
- Posibles filtros (fecha, categoría)
- Paginación si hay muchos registros
- Exportar a Excel

### 2. Dashboard ejecutivo

- KPI cards en grid (2-4 columnas)
- Gráficos principales (línea, barra, donut)
- Tabla resumen con links a detalle
- Período seleccionable

### 3. Informe ejecutivo (PDF)

- Portada con logo y título
- Resumen ejecutivo (textos y KPIs)
- Gráficos con análisis
- Detalle en tablas
- Footer con fecha y usuario

### 4. Reporte comparativo

- Múltiples columnas (períodos)
- Columnas con variación %
- Gráfico comparativo
- Highlight de cambios significativos

## Colores para gráficos

Usar esta paleta para gráficos (evitar colores default):

```css
:root {
  --chart-1: #d30027;  /* Rojo GGSoluciones */
  --chart-2: #3b82f6;  /* Azul */
  --chart-3: #10b981;  /* Verde */
  --chart-4: #f59e0b;  /* Amarillo */
  --chart-5: #8b5cf6; /* Violeta */
  --chart-6: #06b6d4; /* Cyan */
  --chart-7: #eggs899; /* Rosa */
  --chart-8: #6366f1; /* Indigo */
}
```

## Funcionalidades obligatorias

| Función | Descripción |
|---------|-------------|
| Filtros | Por fecha, categoría, status. Aplicar y reset |
| Export | PDF y Excel mínimo |
| Ordenar | Click en headers de tabla |
| Paginación | Si > 20 registros |
| Responsivo | Ver en móvil |
| Loading state | Mientras cargan datos |
| Error state | Si falla la consulta |

## Errores permitidos vs NO permitidos

**PERMITIDO**:
- "No se encontraron datos para el período seleccionado"
- "Error al cargar el reporte. Intenta nuevamente."

**NO PERMITIDO**:
- Stack traces
- Errores de base de datos
- Nombres de tablas/campos internos
- Tokens o credentials

## Export a PDF

Recomendación: usar librería de servidor o cliente:

- **Servidor**: Puppeteer, Playwright, or WeasyPrint
- **Cliente**: html2pdf.js, jspdf

El PDF debe mantener el estilo visual (colores, tipografía, logo).

## Export a Excel

Usar librería como:
- **Backend**: ClosedXML (C#), xlsx (Node)
- **Frontend**: SheetJS, ExcelJS

Incluir:
- Headers con formato
- Totales en footer
- Nombre de hoja descriptivo

## Checklist de entrega

- [ ] Logo GGSoluciones visible en header
- [ ] Título del reporte claro
- [ ] Período indicado
- [ ] KPIs con variación (cuando aplica)
- [ ] Tabla con headers claros
- [ ] Totales calculados correctamente
- [ ] Gráficos (si aplica) con colores de la paleta
- [ ] Filtros funcionales
- [ ] Export PDF funciona
- [ ] Export Excel funciona
- [ ] Modo claro y oscuro OK
- [ ] Responsive en móvil
- [ ] Errores controlados (no técnicos)
- [ ] Footer con fecha y usuario
