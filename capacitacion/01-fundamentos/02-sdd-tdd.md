# 02 - SDD y TDD

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Que es SDD y por que usarlo
- Que es TDD y como aplicarlo
- Como se combinan ambos en el workflow GGS

---

## SDD - Spec-Driven Development

SDD es un enfoque donde la especificacion precede a la implementacion. Antes de escribir codigo, se definen:
- **QUE** hace el sistema
- **COMO** se verifica que funciona
- **POR QUE** se tomaron ciertas decisiones

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

### Por que usar SDD

| Beneficio | Descripcion |
|-----------|-------------|
| **Menor scope** | Primero se explora, propone, diseña |
| **Specs como fuente de verdad** | Todo codigo se verifica contra specs |
| **No mas rework** | Se Valida el diseno antes de implementar |
| **Trail auditable** | Cada decision queda documentada |

```
Sin SDD: "escribi auth"          → 5 horas de trabajo + rework
Con SDD: explore → propose → spec → design → apply → 1 hora + correcto
```

---

## TDD - Test-Driven Development

TDD invierte el orden: primero el test, luego la implementacion.

### Ciclo rojo/verde/refactor

```
1. ROJO  → Escribir un test que falla (aun no existe la funcionalidad)
2. VERDE → Implementar lo minimo para que pase el test
3. REFACTOR → Limpiar codigo sin cambiar comportamiento
```

### Beneficios de TDD

- **Diseno emergent**: al escribir el test primero, pensas en la interfaz y en como se usa, no en como se implementa internamente
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

---

## SDD + TDD Combinados

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

**No se escribe codigo de produccion sin test primero.**

---

## Regla Transversal: VALIDAR ANTES DE ACTUAR

En todas las fases, el agente DEBE:
1. Presentar al menos 2 opciones con pros/contras
2. Explicar el porque de la recomendacion
3. Esperar confirmacion antes de ejecutar

### Regla Pedagogica

El porque siempre se explicita. No se saltea el contexto aunque el cambio sea rapido.

---

## Reglas de Calidad

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

---

## Resumen

| Concepto | Punto clave |
|----------|-------------|
| SDD | Primero la especificacion, luego el codigo |
| TDD | Primero el test, luego la implementacion |
| RED-GREEN-REFACTOR | Ciclo de TDD |
| Strict TDD | Obligatorio cuando hay test runner |
| VALIDAR ANTES DE ACTUAR | Siempre presentar opciones + esperar confirmacion |

---

## Siguiente Capitulo

Continuar con: [03-OpenSpec](./03-openspec.md)

## Recursos

- Ver `reglas/gherkin/AGENT.md` — referencia completa de Gherkin
- Ver `equipo/testing/unitario/AGENT.md` — patrones de tests unitarios
