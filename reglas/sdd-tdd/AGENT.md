---
name: sdd-tdd
description: >
  Guia practica de SDD (Spec-Driven Development) y TDD (Test-Driven Development) para el equipo GGSoluciones.
  Trigger: cuando se quiere entender o implementar SDD con TDD en el workflow del equipo.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

# SDD y TDD — Guia para el Equipo GGSoluciones

## SDD — Spec-Driven Development

SDD es un enfoque donde la especificacion precede a la implementacion. Antes de escribir codigo, se definen:
- **Que** hace el sistema
- **Como** se verifica que funciona
- **Por que** se tomaron ciertas decisiones

### Flujo SDD completo

```
propose  →  spec  →  design  →  tasks  →  apply  →  verify  →  archive
```

| Fase | Objetivo | Output |
|------|----------|--------|
| **propose** | Definir alcance e intent | proposal.md |
| **spec** | Requisitos y escenarios | spec.md (Gherkin) |
| **design** | Arquitectura y decisiones | design.md, ADR |
| **tasks** | Descomposicion en tareas | tasks.md |
| **apply** | Implementacion | Codigo |
| **verify** | Validacion contra spec | Test results |
| **archive** | Sincronizar specs finales | Delta specs |

### Regla transversal: VALIDAR ANTES DE ACTUAR

En todas las fases, el agente DEBE:
1. Presentar al menos 2 opciones con pros/contras
2. Explicar el porque de la recomendacion
3. Esperar confirmacion antes de ejecutar

### Regla pedagogica

El porque siempre se explicita. No se saltea el contexto aunque el cambio sea rapido.

## TDD — Test-Driven Development

TDD invierte el orden: primero el test, luego la implementacion.

### Ciclo rojo/verde/refactor

```
1. ROJO  → Escribir un test que falla (aun no existe la funcionalidad)
2. VERDE → Implementar lo minimo para que pase el test
3. REFACTOR → Limpiar codigo sin cambiar comportamiento
```

### Beneficios

- **Diseño emergent**: al escribir el test primero, pensas en la interfaz y en como se usa, no en como se implementa internamente
- **Regresion inmediata**: cualquier cambio que rompa algo se detecta al toque
- **Documentacion ejecutable**: los tests muestran como se usa el codigo
- **Confianza para refactor**: si los tests pasan, el cambio esta bien

### Estructura de un buen test

```typescript
// naming: subject_WHEN_condition_THEN_expectation
describe('AuthService', () => {
  describe('login', () => {
    it('WHEN valid credentials THEN return user token', async () => {
      // given
      const credentials = { email: 'test@example.com', password: 'pass123' };
      // when
      const result = await authService.login(credentials);
      // then
      expect(result.token).toBeDefined();
      expect(result.expiresAt).toBeAfter(Date.now());
    });
  });
});
```

## SDD + TDD combinados

SDD define el QUE, TDD implementa el COMO verificado.

```
SDD spec (Gherkin)          →  genera  →  TDD tests
     ↓
SDD design                  →  guia    →  TDD implementation
     ↓
SDD apply + TDD rojo/verde →  codigo  →  SDD verify
```

### Strict TDD Mode

Cuando hay test runner disponible, TDD es obligatorio:
1. **Primero**: test que reproduce el bug o valida el requisito
2. **Segundo**: implementacion minima que hace pasar el test
3. **Tercero**: refactor si corresponde

No se escribe codigo de produccion sin test primero.

## Gherkin — lenguaje de specs

Gherkin es el lenguaje de especificacion por comportamiento (BDD).

### Estructura

```gherkin
Funcionalidad: Titulo de la funcionalidad

  Antecedentes:  # Optional — preconditions compartidas
    Dado que el usuario esta autenticado
    Y existe un producto en el carrito

  Escenario: Un escenario descriptivo
    Dado que el usuario tiene items en el carrito
    Cuando hace clic en "Finalizar compra"
    Entonces se muestra el resumen del pedido
    Y se habilita el boton de pago
```

### Keywords

| ES | EN | Uso |
|----|----|-----|
| Dado/a/os/as | Given | Contexto inicial |
| Cuando | When | Accion del usuario o evento |
| Entonces | Then | Resultado esperado |
| Y | And | Continua el paso anterior |
| Pero | But | Negacion del resultado |

### Ejemplo real

```gherkin
Funcionalidad: Login de usuarios

  Escenario: Login exitoso
    Dado un usuario registrado con email "test@ggsoluciones.com"
    Cuando ingreso mis credenciales validas
    Entonces el sistema me redirecciona al dashboard
    Y muestra mi nombre en la barra superior

  Escenario: Login con contrasena incorrecta
    Dado un usuario registrado con email "test@ggsoluciones.com"
    Cuando ingreso una contrasena incorrecta
    Entonces el sistema muestra mensaje de error
    Y permanece en la pagina de login
```

## Reglas de calidad

### NUNCA

- `// TODO` o `// FIXME` en produccion — usar tickets
- Codigo sin test en features nuevas
- Empty catch que silencian errores
- Secretos hardcodeados — siempre variables de entorno
- Deploy manual — CI/CD siempre

### SIEMPRE

- Test que fallan primero (TDD)
- Specs en Gherkin antes de codear (SDD)
- Code review antes de merge
- PR vinculado a ticket
- Mensajes de commit convencionales

## Recursos

- Ver `reglas/gherkin/AGENT.md` — referencia completa de Gherkin
- Ver `reglas/openspec/AGENT.md` — como OpenSpec se integra con SDD
- Ver `equipo/testing/unitario/AGENT.md` — patrones de tests unitarios
