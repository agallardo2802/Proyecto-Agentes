# Skill: Intranet IA Guide Page

Usá este skill cuando el usuario quiera crear, revisar o transformar una página HTML de la intranet con el estilo de la **Guía de uso de IA**.

---

## Metadata sugerida para `SKILL.md`

```yaml
---
name: intranet-ia-guide-page
description: >
  Crear o adaptar páginas HTML de la intranet GGSoluciones con el formato editorial,
  visual y didáctico de la Guía de uso de IA. Usar cuando se pidan páginas de
  capacitación, guías internas, buenas prácticas, ejemplos por área, prompts,
  procedimientos o contenidos explicativos para usuarios internos.
---
```

---

## Objetivo

Crear páginas internas que sean:

- claras para usuarios no técnicos;
- visualmente consistentes con la intranet;
- útiles para capacitación y adopción;
- accionables, no sólo informativas;
- navegables desde y hacia el home de intranet.

La página tiene que explicar **qué es**, **para qué sirve**, **cómo se usa**, **qué ejemplos concretos aplicar** y **qué cuidados tener**.

---

## Principios UX

1. **Primero claridad, después estética**
   - Si el usuario no entiende qué hacer, la página falla.

2. **Una sección = una idea**
   - No mezclar definición, procedimiento, ejemplo y advertencia en el mismo bloque.

3. **Ejemplos concretos**
   - Evitar textos genéricos. Mostrar casos reales por área o herramienta.

4. **Lenguaje interno simple**
   - Usar tono profesional, cercano y directo.
   - Evitar tecnicismos salvo que sean necesarios.

5. **IA como apoyo, no reemplazo**
   - Mantener el criterio: la IA potencia el trabajo, no reemplaza responsabilidad humana.

6. **Seguridad visible**
   - Toda guía debe incluir buenas prácticas de privacidad, datos sensibles y validación humana.

---

## Estructura recomendada de página

### 1. Header común

Debe incluir:

- logo de GGSoluciones;
- link al home `/intranet/`;
- título de la página;
- footer exacto al final.

Footer obligatorio:

```txt
Intranet GGSoluciones · Jefatura de Operaciones IT & Desarrollo · sistemasit@ggsoluciones.com
```

---

### 2. Hero inicial

Debe responder rápido:

- qué es la página;
- para quién es;
- qué va a poder hacer el usuario después de leerla.

Ejemplo:

```html
<section class="hero">
  <p class="eyebrow">Guía interna</p>
  <h1>Uso práctico de IA en el trabajo diario</h1>
  <p>Ejemplos concretos, buenas prácticas y prompts para usar IA con criterio, seguridad y foco en productividad.</p>
</section>
```

---

### 3. Bloque de orientación rápida

Usar tarjetas cortas:

- Qué podés hacer.
- Cuándo usarlo.
- Cuándo no usarlo.
- Qué validar antes de publicar/enviar.

---

### 4. Secciones por caso de uso

Cada caso debe tener:

```md
## Caso de uso

Qué problema resuelve.

### Prompt sugerido
[Prompt concreto]

### Cómo revisar la respuesta
- Validar datos.
- Corregir tono.
- Confirmar que no haya información sensible.
```

Ejemplos deseables:

- Gmail: responder un correo difícil.
- Google Docs: mejorar redacción.
- Sheets: ordenar datos o generar fórmulas.
- Atención al cliente: responder reclamos.
- IT: documentar incidentes.
- Comercial: preparar propuesta o resumen.

---

### 5. Prompts por área

Cada prompt debe ser específico, copiable y adaptable.

Formato:

```html
<div class="prompt-card">
  <h3>Atención al cliente · Reclamo por demora</h3>
  <pre>Actuá como asistente de atención al cliente...</pre>
  <p><strong>Usalo para:</strong> responder con empatía, explicar próximos pasos y evitar promesas falsas.</p>
</div>
```

Reglas del prompt:

- incluir rol;
- incluir contexto;
- pedir tono;
- pedir formato de salida;
- pedir que no invente datos;
- pedir revisión humana final.

---

### 6. Buenas prácticas de seguridad

Siempre incluir una sección clara:

- No pegar contraseñas.
- No subir datos personales innecesarios.
- No compartir información de clientes sin autorización.
- Revisar antes de enviar o publicar.
- No tomar decisiones críticas sólo con IA.

---

### 7. Checklist final

Toda página de guía debe cerrar con checklist:

```md
Antes de usar la respuesta de IA:
- ¿Verifiqué que los datos sean correctos?
- ¿El tono es adecuado para GGSoluciones?
- ¿No hay información sensible?
- ¿La respuesta es clara para el destinatario?
- ¿Hace falta aprobación de otra área?
```

---

## Reglas visuales

La página debe:

- usar `public/assets/intranet-common.css`;
- mantener layout ancho y responsive;
- tener cards limpias;
- usar rojo sólo para acción o énfasis importante;
- evitar bloques gigantes de texto;
- usar tablas sólo si ayudan a comparar;
- permitir copiar prompts fácilmente si se agrega JS;
- tener logo clickeable al home;
- no usar `localhost`;
- no usar assets locales rotos;
- agregar `rel="noopener noreferrer"` en links externos con `target="_blank"`.

---

## Checklist de validación del agente

Antes de entregar una página nueva, validar:

```md
- [ ] Logo vuelve a `/intranet/`.
- [ ] Footer exacto presente.
- [ ] Usa `intranet-common.css`.
- [ ] No hay `localhost`.
- [ ] No hay links rotos obvios.
- [ ] Links externos `_blank` tienen `rel="noopener noreferrer"`.
- [ ] El contenido tiene ejemplos concretos.
- [ ] Hay sección de seguridad.
- [ ] Hay prompts copiables o claramente delimitados.
- [ ] La página se entiende sin explicación adicional.
- [ ] Se verificó en 1080p y pantalla ancha.
```

---

## Prompt operativo para usar el skill

```md
Usá el skill `intranet-ia-guide-page`.

Necesito crear una página HTML para la intranet con el estilo de la Guía de uso de IA.

Tema: [tema]
Audiencia: [usuarios/área]
Objetivo: [qué tiene que poder hacer la persona]
Casos de uso: [lista]
Restricciones: mantener formato intranet, footer exacto, logo al home, sin localhost.

Primero analizá si el contenido sirve para tomar acción.
Después creá el HTML en `public/[ruta]`.
Finalmente validá estructura, links, footer y consistencia visual.
```

---

## Criterio de aceptación

Una página creada con este skill se considera correcta si:

- parece parte de la misma intranet;
- se entiende en menos de 30 segundos;
- tiene ejemplos aplicables;
- deja claro qué hacer y qué no hacer;
- no expone datos sensibles;
- vuelve al home desde el logo;
- puede mantenerse como HTML estático versionado.
