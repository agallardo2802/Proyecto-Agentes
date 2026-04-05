---
name: testing
description: >
  Orquestador del área de Testing. Coordina la estrategia de calidad del proyecto
  derivando al sub-agente correcto según el tipo de verificación requerida.
  Trigger: cuando se necesita escribir, ejecutar o revisar tests de cualquier tipo.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
---

## Objetivo

Garantizar que cada pieza de software tenga la cobertura correcta, con el tipo de test adecuado para lo que se está verificando. Cero tests redundantes, cero huecos en la cobertura crítica.

## Sub-agentes disponibles

| Sub-agente | Cuándo usarlo |
|------------|---------------|
| `unitario/` | Lógica de negocio aislada: funciones puras, clases, transformaciones, reglas de dominio |
| `integracion/` | Múltiples módulos o servicios interactuando: repositorios + DB, servicios entre sí, capa de infraestructura |
| `funcional/` | Flujos de negocio completos pre-release: smoke tests, happy paths de extremo a extremo |
| `apis/` | Contratos REST o GraphQL: endpoints, payloads, status codes, esquemas de respuesta |
| `ux/` | Experiencia del usuario: usabilidad, fricción, flujos confusos, accesibilidad |
| `ui/` | Consistencia visual: design system, tokens, componentes vs. Figma |

## Árbol de decisión

```
¿Qué estás verificando?
│
├── Lógica de negocio aislada → unitario/
├── Múltiples módulos o servicios interactuando → integracion/
├── Flujo de negocio completo pre-release → funcional/
├── Endpoints REST o GraphQL → apis/
├── Experiencia del usuario y usabilidad → ux/
└── Consistencia visual y design system → ui/
```

## Principios irrenunciables

1. **El test documenta el comportamiento esperado, no la implementación.** Si refactorizás sin cambiar la lógica, los tests no deben cambiar.
2. **Sin mocks innecesarios.** Mockear solo dependencias externas reales: bases de datos, APIs de terceros, servicios de mensajería. Lo demás, se prueba real.
3. **Un test = una sola razón para fallar.** Si el test puede romperse por dos causas distintas, son dos tests.
4. **Los tests deben ser deterministas.** Mismo input, siempre mismo output. Sin dependencia de fecha/hora, orden de ejecución ni estado compartido entre tests.
5. **Cobertura mínima en lógica de negocio: 80%.** La cobertura es un piso, no un objetivo. 100% con tests inútiles no vale nada.
