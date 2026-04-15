# Skill: Estilo corporativo web y reportes — El Cuatro

## Objetivo
Este skill define cómo construir páginas web, dashboards HTML y reportes ejecutivos respetando la identidad visual corporativa de **El Cuatro**, usando los logos oficiales y manteniendo consistencia visual, jerarquía ejecutiva y legibilidad.

Se debe aplicar en:
- dashboards gerenciales
- reportes ejecutivos HTML
- presentaciones web internas
- micrositios o landing pages institucionales
- paneles comerciales, operativos o IT

No usar estilos genéricos si contradicen este estándar.

---

## Fuentes base analizadas
Tomar como referencia obligatoria los siguientes archivos y patrones ya usados:

- `Analisis_ERP_CRM_2026.html`
- `MCloude - Dashboard Gestión Integral.html`
- `MGPT - Metricas Comerciales.html`
- `Presentacion Directorio 19-03-26.html`
- Logo oficial `EL CUATRO POSITIVO` en PNG/JPG

---

## Identidad visual obligatoria

### 1. Logo
- Usar **siempre el logo oficial exacto** provisto por el usuario.
- No redibujar el logo.
- No vectorizar manualmente si no se pidió.
- No alterar colores, proporciones, contornos ni tipografía del logo.
- No aplicar sombras, biseles, glow, transparencias raras ni deformaciones.
- Mantener área de respiro visual alrededor del logo.
- Si el fondo es claro, usar la versión positiva del logo.
- Si el fondo es oscuro, solo usar una variante validada por el usuario.
- El logo debe renderizarse con `object-fit: contain`.

### 2. Paleta cromática
Usar esta base como estándar principal:

```css
:root {
  --bg: #f3f6fb;
  --panel: #ffffff;
  --panel-2: #f8fbff;
  --text: #1f2937;
  --muted: #667085;
  --line: #d9e2ec;

  --red: #e30613;
  --blue: #2d7ff9;
  --teal: #0ea5a4;
  --green: #16a34a;
  --orange: #d97706;
  --purple: #7c3aed;
  --gold: #b45309;

  --shadow: 0 10px 30px rgba(15, 23, 42, .08);
  --radius: 20px;
}
```

### 3. Uso funcional del color
- **Rojo corporativo (`--red`)**: títulos clave, acentos de marca, highlights ejecutivos, bordes de header, alertas críticas.
- **Azul (`--blue`)**: métricas informativas, navegación, badges analíticos, visualizaciones de soporte.
- **Teal (`--teal`)**: indicadores de procesos, integración, evolución, tecnología.
- **Verde (`--green`)**: cumplimiento, mejora, estado positivo.
- **Naranja (`--orange`)**: alertas, advertencias, foco, urgencia moderada.
- **Púrpura (`--purple`)**: capacidad, estrategia, categorías analíticas especiales.
- **Grises y fondos claros**: la base general del sistema visual.

### 4. Fondo de página
Usar fondo claro con profundidad suave. Patrón recomendado:

```css
body {
  margin: 0;
  background:
    radial-gradient(circle at top right, rgba(45,127,249,.07), transparent 28%),
    radial-gradient(circle at top left, rgba(227,6,19,.06), transparent 22%),
    var(--bg);
  color: var(--text);
  font-family: Inter, Segoe UI, Arial, sans-serif;
}
```

No usar fondos oscuros como base general salvo pedido explícito.

---

## Tipografía

### Fuente principal
Usar en este orden:
1. `Inter`
2. `Segoe UI`
3. `Arial`
4. `sans-serif`

### Reglas tipográficas
- Títulos principales: peso 800 o 900.
- Subtítulos y encabezados de sección: peso 700 u 800.
- Texto normal: 400 a 500.
- Labels KPI: uppercase, tracking amplio, tamaño chico.
- Evitar tipografías decorativas.
- Evitar exceso de cursivas.
- La lectura debe verse ejecutiva, limpia y moderna.

---

## Lenguaje visual esperado
El estilo corporativo observado responde a estos principios:

- apariencia ejecutiva
- paneles limpios y claros
- alto contraste en métricas
- lectura rápida para dirección
- consistencia modular
- acentos de marca claros, no invasivos
- sensación de orden, control y profesionalización

No usar:
- glassmorphism exagerado
- neon
- skeuomorphism
- sombras pesadas
- layouts recargados
- animaciones innecesarias

---

## Estructura obligatoria para dashboards y reportes

### 1. Header de marca
Debe incluir:
- logo oficial a la izquierda o junto al título
- nombre del reporte
- opcional: subtítulo con contexto, corte o gerencia
- borde inferior rojo corporativo o equivalente de marca

Patrón recomendado:

```css
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 34px;
  background: #fff;
  border-bottom: 4px solid var(--red);
  margin-bottom: 24px;
  border-radius: var(--radius);
  box-shadow: var(--shadow);
}

.header img {
  height: 64px;
  object-fit: contain;
}
```

### 2. Hero o bloque inicial
Cuando el reporte sea ejecutivo o para directorio, usar una apertura fuerte:
- título claro
- bajada explicativa breve
- badges o pills de contexto
- 2 a 4 métricas destacadas

El hero puede usar rojo corporativo en fondos destacados, pero con buena legibilidad.

### 3. Grid de KPIs
- Usar grillas de 3, 4, 5 o 6 columnas según ancho.
- Cada KPI debe vivir dentro de una card clara.
- Número grande, label breve, explicación corta.
- El color de acento debe responder a la naturaleza del indicador.

### 4. Secciones temáticas
Separar por bloques:
- negocio
- comercial
- operaciones
- IT
- proyectos
- capacidad
- riesgos
- definiciones

Cada sección debe tener:
- título claro
- subtítulo o aclaración de lectura
- cards o paneles consistentes

### 5. Tablas
Las tablas deben verse ejecutivas, no técnicas. Reglas:
- cabecera uppercase
- líneas divisorias suaves
- padding generoso
- colores neutros
- badges para estados

### 6. Foot o cierre
Debe incluir:
- nombre del reporte
- marca El Cuatro
- gerencia o área
- autor si corresponde
- fecha o período

---

## Componentes permitidos y recomendados

### Cards
```css
.card {
  background: var(--panel);
  border: 1px solid var(--line);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
}
```

### KPI card
- label pequeña
- valor dominante
- subtexto explicativo
- opcional tooltip o badge comparativo

### Badges
Usar badges redondeados para:
- período
- estado
- tendencia
- live / corte / snapshot

### Status pills
Usar variantes suaves:
- verde claro con texto verde
- azul claro con texto azul
- naranja claro con texto naranja
- rojo claro con texto rojo
- púrpura claro con texto púrpura

### Callouts
Permitir bloques destacados con degradado suave o fondo tonal para:
- recomendación
- definición clave
- advertencia de gestión
- foco ejecutivo

### Hito list / checklist
Usar listas con iconografía liviana y muy clara.
Ideal para:
- hitos logrados
- riesgos
- próximos pasos
- criterios de decisión

---

## Estándar de espaciado y proporciones
- `max-width`: 1440px para dashboards
- `padding` exterior: 28px aprox.
- separación entre bloques: 16px a 28px
- radios: 14px a 20px
- altura de logo header: 44px a 64px
- evitar densidad excesiva

La UI debe respirar.

---

## Reglas de responsive

### Desktop
- priorizar lectura horizontal en KPI grid
- mantener header con buen balance

### Tablet
- pasar grids complejas a 2 columnas

### Mobile
- una columna
- header compacto
- hero apilado
- cards con padding reducido pero legible

Siempre validar que:
- no se corte texto
- no se rompan imágenes
- no se superpongan badges
- no se deforme el logo
- no aparezcan scrolls horizontales innecesarios

---

## Gráficos y visualización de datos

### Principios
- los gráficos acompañan la lectura, no la reemplazan
- deben ser claros para dirección
- priorizar barras, líneas y doughnuts simples
- evitar visualizaciones extravagantes

### Colores para gráficos
Usar la paleta corporativa.
Orden sugerido:
1. rojo corporativo
2. azul
3. teal
4. verde
5. naranja
6. púrpura

### Reglas
- títulos claros
- leyendas simples
- ejes discretos
- gridlines suaves
- no saturar con demasiadas series
- siempre privilegiar comprensión ejecutiva

---

## Microcopy y tono de contenidos visuales
El diseño debe ir acompañado de textos:
- claros
- ejecutivos
- orientados a gestión
- con lenguaje simple pero profesional
- explicando qué significa cada número

Preferir:
- “qué mide”
- “contra qué compara”
- “qué lectura habilita”
- “por qué importa”

Evitar:
- texto de relleno
- frases marketineras vacías
- tecnicismo sin contexto

---

## Qué debe hacer el agente al construir una web o reporte

### Obligatorio
1. Cargar el logo oficial provisto por el usuario.
2. Respetar la paleta corporativa observada.
3. Mantener fondo claro con acentos rojo/azul.
4. Usar Inter o fallback equivalente.
5. Construir layout modular con cards, KPIs, secciones y tablas limpias.
6. Priorizar legibilidad ejecutiva.
7. Explicar indicadores importantes con microcopy breve.
8. Mantener consistencia entre header, hero, cards y footer.
9. Usar responsive real.
10. Validar que el resultado se vea institucional y no genérico.

### Prohibido
1. Cambiar el logo.
2. Inventar colores fuera de sistema sin justificación.
3. Usar otra identidad visual que compita con la marca.
4. Sobrecargar la interfaz.
5. Usar bordes agresivos o sombras pesadas.
6. Mezclar estilos incompatibles.
7. Crear dashboards oscuros salvo pedido explícito.
8. Hacer hero banners estridentes o publicitarios.
9. Usar componentes visuales que rompan la estética corporativa.
10. Entregar algo “lindo” pero poco ejecutivo.

---

## Plantilla base recomendada

```html
<body>
  <div class="wrap">
    <header class="header">
      <img src="LOGO_OFICIAL" alt="El Cuatro">
      <div class="htitle">Título del reporte</div>
    </header>

    <section class="hero card">
      <div>
        <h1>Título ejecutivo</h1>
        <p>Resumen breve de lectura gerencial.</p>
      </div>
    </section>

    <section class="grid-kpis">
      <div class="card kpi">...</div>
      <div class="card kpi">...</div>
      <div class="card kpi">...</div>
      <div class="card kpi">...</div>
    </section>

    <section class="section">
      <div class="section-head">
        <div>
          <h2>Sección</h2>
          <p>Subtítulo</p>
        </div>
      </div>
      <div class="two-col">
        <div class="card panel">...</div>
        <div class="card panel">...</div>
      </div>
    </section>

    <footer class="foot">
      Reporte corporativo · El Cuatro · Gerencia / Área · Período
    </footer>
  </div>
</body>
```

---

## Criterios de validación final
Antes de dar por terminado un diseño, verificar:

- ¿el logo es exactamente el oficial?
- ¿la paleta se siente El Cuatro?
- ¿el header refleja identidad corporativa?
- ¿el diseño se parece a los dashboards ya aprobados?
- ¿los KPIs se leen rápido?
- ¿hay jerarquía clara?
- ¿el resultado sirve para dirección o gerencia?
- ¿el responsive mantiene integridad visual?
- ¿el conjunto se ve profesional, ordenado y corporativo?

Si alguna respuesta es no, revisar antes de entregar.

---

## Instrucción operativa para futuros agentes
Cuando el usuario pida una web, dashboard, tablero, informe HTML o reporte ejecutivo para El Cuatro:

- aplicar este skill por defecto
- usar el logo oficial exacto provisto
- tomar como referencia estética directa los HTML aprobados existentes
- mantener consistencia con Canal 4 / El Cuatro
- priorizar claridad ejecutiva, modularidad y lectura institucional

Este skill tiene prioridad sobre estilos genéricos del agente.

