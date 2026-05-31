---
name: menu-navigation
description: "Trigger: menú, sidebar, navegación, topbar, breadcrumbs, layout. Crear navegación para portales internos de GGSoluciones."
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
---

# Menu Navigation - Estándar GGSoluciones

## Activation Contract

Usá esta skill cuando el usuario pida menú, sidebar, topbar, navegación, breadcrumbs, shell de portal o estructura de módulos.

No la uses para una pantalla aislada que no comparte navegación con el resto del portal.

## Hard Rules

- La navegación debe reflejar tareas del usuario, no carpetas técnicas.
- El ítem activo debe ser inequívoco en desktop y mobile.
- Los permisos deben ocultar o deshabilitar opciones de forma consistente.
- Login, error público y recuperación de sesión no deben renderizar sidebar del portal.
- Mobile debe tener navegación colapsada, foco controlado y cierre explícito.
- Breadcrumbs se usan cuando hay jerarquía real, no para repetir el título.
- No inventes nombres de módulos: usá lenguaje del negocio.

## Decision Gates

| Necesidad | Patrón |
|---|---|
| Portal operativo con muchos módulos | Sidebar persistente + topbar contextual |
| Portal simple de 3 a 5 secciones | Topbar con menú responsive |
| Módulos con jerarquía profunda | Sidebar + breadcrumbs |
| Acciones frecuentes | Topbar contextual, no menú lateral saturado |

## Execution Steps

1. Listá módulos, roles y acciones principales.
2. Definí patrón de navegación según volumen y jerarquía.
3. Diseñá estados: activo, hover, disabled, collapsed, mobile y loading.
4. Separá navegación global, navegación contextual y acciones de página.
5. Validá permisos, responsive, accesibilidad y contraste.

## Output Contract

Entregar mapa de navegación, estructura de componentes, reglas de permisos, comportamiento responsive y criterios de aceptación.
