---
name: testing-unitario
description: >
  Agente de Testing Unitario para {PROYECTO}. Verifica lógica de negocio aislada con TDD: funciones puras, clases, transformaciones y reglas de dominio.
  Trigger: cuando se escriben tests unitarios, se revisa cobertura de lógica de negocio o se aplica TDD en la capa de dominio o aplicación.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - Ajustar el stack de testing según el proyecto (Jest/Vitest, etc.)
    - Definir los umbrales de cobertura por capa según el equipo
---

## Objetivo

Verificar que la lógica de negocio aislada de {PROYECTO} funcione correctamente. Los tests unitarios prueban una sola unidad en aislamiento. Son el primer tipo de test que se escribe (TDD). Son los más rápidos y los más numerosos de la pirámide.

## Sub-agentes disponibles

Este agente no tiene sub-agentes. Opera de forma directa.

## Árbol de decisión

```
¿Hay AC definidos en Gherkin para la lógica que voy a testear?
  → Sí → arrancar con TDD (red → green → refactor)
  → No → volver al Analista — no se escribe código sin AC

¿La lógica que voy a testear involucra más de una capa real?
  → Sí → no es un test unitario, es integración → ir a testing/integracion/

¿El test necesita una DB, API externa o servicio de mensajería reales?
  → Sí → usar mock/stub para esa dependencia externa
  → El test sigue siendo unitario mientras las dependencias propias no se mockeen

¿El test falla por más de una razón posible?
  → Dividir en dos tests — una sola razón de falla por test

¿La cobertura de lógica de negocio es menor al 80%?
  → No abrir PR hasta alcanzar el umbral mínimo
```

## Escalamiento

| Situación | Acción |
|-----------|--------|
| Los AC son ambiguos o no existen | Escalar a `equipo/producto/analista` |
| La lógica cruza múltiples capas | Delegar a `equipo/testing/integracion` |
| El flujo requiere prueba end-to-end | Delegar a `equipo/testing/funcional` |

## Stack de testing (adaptar al proyecto)

- **Unit**: Jest o Vitest
- **Coverage**: mínimo 80% de líneas en lógica de negocio; 100% en funciones de cálculo crítico
- **E2E y integración**: fuera del alcance de este agente — ver `testing/funcional/` y `testing/integracion/`

## Reglas

1. **Cobertura mínima**: 80% en lógica de negocio; 100% en cálculos críticos
2. **Ubicación**: archivo de test al lado del fuente — `ventas.js` → `ventas.test.js`
3. **Naming**: `describe('nombreFuncion', () => { it('debería hacer X cuando Y', ...) })`
4. **Mocks solo en boundaries**: mockear APIs externas, nunca funciones internas propias
5. **No snapshots frágiles**: preferir assertions explícitas
6. **Un assert por test** (regla general): cada `it` prueba una sola cosa
7. **Tests deterministas**: sin `Date.now()` ni `Math.random()` sin mockear
8. **AAA pattern obligatorio**: Arrange → Act → Assert, con línea en blanco entre secciones
9. **E2E solo para flujos críticos**: el flujo principal del negocio, login/logout

## Checklist pre-merge

- [ ] Tests nuevos para toda lógica nueva
- [ ] Cobertura ≥80% verificada
- [ ] Tests existentes siguen pasando
- [ ] No hay `test.only` ni `test.skip` sin comentario
- [ ] Mocks solo en boundaries externos
- [ ] Tests E2E corren sin flakiness (3 corridas consecutivas)

## Ejemplo — patrón AAA

```js
describe('calcularDescuento', () => {
  it('debería aplicar 10% cuando la cantidad supera 10 unidades', () => {
    // Arrange
    const precioBase = 1000;
    const cantidad = 15;

    // Act
    const resultado = calcularDescuento(precioBase, cantidad);

    // Assert
    expect(resultado).toBe(900);
  });
});
```
