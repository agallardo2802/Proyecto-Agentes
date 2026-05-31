---
name: propuesta-comercial-ggs
description: >
  Generar propuestas comerciales y de servicios profesionales en HTML con la
  identidad visual de GG Soluciones (hero, secciones numeradas, tabla de precios,
  cronograma, condiciones de pago). Usar cuando el usuario diga "propuesta",
  "cotización", "presupuesto", "propuesta de servicios", "propuesta comercial",
  "cotizar proyecto" o "armar propuesta para {cliente}".
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
---

# Propuesta Comercial GG Soluciones

Genera propuestas de servicios profesionales en HTML, listas para imprimir/PDF, con la identidad de GG Soluciones.

## Activation Contract

Usá esta skill cuando se pida armar una propuesta, cotización o presupuesto para un cliente. El output es un `.html` autocontenido que reutiliza `styles.css` del sitio GG Soluciones.

## Referencia visual canónica (OBLIGATORIA)

`assets/propuesta-ejemplo.html` — propuesta real de Actas Digitales. **Leerla antes de generar**: define el HTML, las clases CSS y el tono exactos. Copiá su estructura y reemplazá solo el contenido variable.

## Dependencias del proyecto web

- La propuesta vive junto a las páginas del sitio (`ggs_web/`) y enlaza `styles.css` (variables `--primary`, `--accent`, `--card`, `--border2`, `--muted`, `--text`).
- Reutiliza el `<header>`, `<footer>`, nav mobile, theme toggle y scripts del sitio — copialos del ejemplo tal cual.
- Logo: `logo.png`. WhatsApp: `https://wa.me/5493885120704`.

## Estructura obligatoria (en este orden)

1. **Hero** (`.doc-hero`): eyebrow "Propuesta de servicios profesionales", `<h1>` título, lead en cursiva.
2. **Acciones** (`.doc-actions`): botón "Descargar / Imprimir PDF" (`window.print()`) + "Coordinar reunión" (WhatsApp con mensaje prellenado).
3. **Meta** (`.doc-meta`): Destinatario, Atención, Oferente (con CUIT), Lugar y fecha, Validez.
4. **Objetivo** — qué se resuelve, en 1-2 párrafos.
5. **Situación actual y riesgos** — incluir un `.doc-callout` con el costo/impacto de NO hacerlo.
6. **Alcance del trabajo** — agrupado en `<h3>` + listas `.doc ul`.
7. **Arquitectura propuesta** (si aplica) — `.arch-grid` con `.arch-box`.
8. **Estimación económica** — `.price-table` con valor hora, etapas (horas + importe) y fila `.total`.
9. **Cronograma** — `.doc-table` por semanas.
10. **Entregables** — lista.
11. **Condiciones de pago** — `.payment-table` por cuotas contra entrega/validación.
12. **No incluido** — lista de exclusiones (servidores, licencias, soporte mensual, etc.).
13. **Etapa 2** (si aplica) — `.stage2-banner` con el próximo paso recomendado, a cotizar aparte.
14. **Resultado esperado** + cierre (`.doc-close`).

## Datos variables a pedir / confirmar

| Dato | Ejemplo |
|------|---------|
| Cliente / destinatario | "Registro Civil de la Provincia" |
| Persona de atención | "Octavio Rivas — Director" |
| Oferente + CUIT | "GG Soluciones — CUIT 20-34005631-1" |
| Lugar y fecha | "San Salvador de Jujuy, 31 de mayo de 2026" |
| Validez | "10 días hábiles" |
| Valor hora | "$40.000 ARS" |
| Etapas (horas + importe) | ver tabla de precios |
| Esquema de cuotas | 1 o 2 cuotas contra validación |

Si falta alguno, **preguntar antes de inventar** (especialmente montos, CUIT y fechas).

## Reglas

- **Ancho híbrido (obligatorio).** El documento ocupa todo el ancho (`.doc` y `.doc-hero .container` con `max-width: 100%`), pero el texto corrido se limita para que se lea sin fatiga:
  - **Ancho completo**: hero, tablas (`.price-table`, `.doc-table`, `.payment-table`) y diagrama de arquitectura (`.arch-grid`). Se leen mejor anchos.
  - **Ancho de lectura ~72ch**: párrafos (`.doc p`) y listas (`.doc ul`). Líneas más largas cansan la vista y bajan la comprensión (longitud óptima 50–75 caracteres).
  - NUNCA limitar el documento entero a un ancho fijo tipo `920px`.
- Tono profesional, claro y orientado a valor; nada de jerga técnica innecesaria hacia el cliente.
- Los importes se calculan: `horas × valor hora`. El total debe cuadrar con la suma de etapas y con las cuotas.
- Incluir siempre la nota fiscal: "Los valores no contemplan impuestos que pudieran corresponder...".
- `meta name="robots"` en `noindex, nofollow` (documento privado).
- Mantener bloque `@media print` para que el PDF salga bien.
- No prometer alcance fuera de lo listado; lo futuro va a "Etapa 2".

## Checklist de entrega

- [ ] Ancho híbrido: documento full-width, tablas/hero anchos, texto (`.doc p`/`.doc ul`) a ~72ch
- [ ] Hero con título y lead claros
- [ ] Tabla meta completa (destinatario, oferente+CUIT, fecha, validez)
- [ ] Secciones numeradas en orden
- [ ] Callout de riesgo/impacto en "Situación actual"
- [ ] Tabla de precios con total que cuadra
- [ ] Cronograma coherente con las etapas
- [ ] Condiciones de pago con cuotas que suman el total
- [ ] Nota fiscal incluida
- [ ] Header/footer/scripts del sitio presentes
- [ ] `@media print` y botón imprimir funcionando
- [ ] Modo claro/oscuro OK
