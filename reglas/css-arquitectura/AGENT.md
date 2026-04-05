---
name: css-arquitectura
description: >
  Arquitectura de CSS: BEM, especificidad, responsive y variables.
  Trigger: cuando se escribe CSS nuevo, se crean componentes o se modifica el sistema de estilos.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Actualizar la sección "Variables CSS" con los tokens reales del proyecto
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — cuando se trabaja con CSS/estilos
- `equipo/diseno/ui/` — siempre
- `equipo/testing/ui/` — para auditoría visual
- `guilds/frontend-angular/` — siempre

## Objetivo

CSS sin arquitectura se convierte en un archivo de 3.000 líneas que nadie quiere tocar. Este agente define cómo organizar, nombrar y escribir estilos para que escalen sin romperse.

## Reglas

1. **BEM para componentes**: `bloque__elemento--modificador`; máximo 2 niveles de anidado
2. **Cero `!important`**: si lo necesitás, el problema es de especificidad
3. **Variables CSS para todo**: colores, tamaños, sombras, radios van en `--variables`
4. **Mobile-first**: estilos base para mobile, `@media (min-width: Xpx)` para desktop
5. **Especificidad baja y plana**: preferir clases únicas antes que selectores encadenados
6. **Sin estilos inline en HTML**: todo estilo va en CSS
7. **Orden de propiedades**: layout → box model → tipografía → visual → animación

## BEM en práctica

```css
/* ✅ BEM correcto */
.producto-card { }
.producto-card__titulo { }
.producto-card__titulo--destacado { }
.producto-card--agotado { }

/* ❌ Selectores anidados — frágil y difícil de sobrescribir */
.sidebar nav ul li a { }

/* ❌ !important — señal de problema de especificidad */
.btn-primario { color: white !important; }
```

## Responsive mobile-first

```css
/* ✅ Mobile-first */
.grid-productos {
  display: grid;
  grid-template-columns: 1fr;          /* mobile */
}

@media (min-width: 768px) {
  .grid-productos {
    grid-template-columns: repeat(2, 1fr); /* tablet */
  }
}

@media (min-width: 1024px) {
  .grid-productos {
    grid-template-columns: repeat(3, 1fr); /* desktop */
  }
}
```

## Orden de propiedades

```css
.componente {
  /* 1. Layout */
  display: flex;
  position: relative;
  align-items: center;

  /* 2. Box model */
  width: 100%;
  padding: 16px;
  margin: 0 auto;

  /* 3. Tipografía */
  font-size: 14px;
  font-weight: 500;
  color: var(--gray-700);

  /* 4. Visual */
  background: white;
  border: 1px solid var(--border);
  border-radius: 8px;

  /* 5. Animación */
  transition: box-shadow 0.2s ease;
}
```

## Checklist de CSS en cada PR

- [ ] Sin `!important` en el diff
- [ ] Sin valores hardcodeados — usar variables CSS del proyecto
- [ ] Revisado en 375px (mobile) y 1280px (desktop)
- [ ] Selectores BEM — máximo 2 niveles
- [ ] Sin estilos inline en HTML
