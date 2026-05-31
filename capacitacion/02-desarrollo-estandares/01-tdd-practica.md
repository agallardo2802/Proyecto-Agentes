# 05 - TDD en Practica

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Como aplicar TDD en tu dia a dia
- La estructura de un test efectivo
- El patron AAA (Arrange-Act-Assert)
- Common patterns en tests

---

## El Ciclo TDD

```
RED    → Escribir un test que falla
GREEN  → Implementar lo minimo para que pase
REFACTOR → Limpiar sin cambiar comportamiento
```

### Paso 1: RED - Escribir test que falla

Antes de escribir cualquier codigo de produccion, escribis un test que describe lo que queres lograr.

```typescript
// test/auth.service.test.ts
describe('AuthService', () => {
  describe('login', () => {
    it('WHEN invalid credentials THEN throw AuthError', async () => {
      // El test falla porque AuthService no existe aun
    });
  });
});
```

### Paso 2: GREEN - Implementar lo minimo

Escribir solo lo necesario para que el test pase.

```typescript
// auth.service.ts
class AuthService {
  async login(credentials: Credentials): Promise<Token> {
    // Implementacion minima solo para pasar el test
    if (!credentials.email || !credentials.password) {
      throw new AuthError('Invalid credentials');
    }
    return { token: 'fake-token' };
  }
}
```

### Paso 3: REFACTOR - Limpiar

Mejorar el codigo sin cambiar el comportamiento.

```typescript
// Refactor: extraer validacion, mejorar nombres, etc.
class AuthService {
  async login(credentials: Credentials): Promise<Token> {
    this.validateCredentials(credentials);
    return this.createToken(credentials.email);
  }

  private validateCredentials(credentials: Credentials): void {
    if (!credentials.email || !credentials.password) {
      throw new AuthError('Invalid credentials');
    }
  }
}
```

---

## Estructura de un Test

### Patron AAA: Arrange - Act - Assert

```typescript
it('WHEN valid credentials THEN return user token', async () => {
  // ARRANGE: preparar el contexto
  const credentials = { email: 'test@example.com', password: 'pass123' };

  // ACT: ejecutar la accion
  const result = await authService.login(credentials);

  // ASSERT: verificar el resultado
  expect(result.token).toBeDefined();
  expect(result.expiresAt).toBeAfter(Date.now());
});
```

### Naming: subject_WHEN_condition_THEN_expectation

```
subject          → Que se prueba (Login, AuthService, calculateTotal)
WHEN condition   → Cuando pasa algo especifico
THEN expectation → Entonces se espera un resultado
```

| Ejemplo | Descripcion |
|---------|-------------|
| `it('WHEN valid credentials THEN return token')` | Login exitoso |
| `it('WHEN invalid password THEN throw error')` | Login fallido |
| `it('WHEN cart empty THEN disable checkout')` | Carrito vacio |

---

## Tipos de Tests

### Tests Unitarios

Prueban una unidad de codigo de forma aislada (funcion, metodo, clase).

```typescript
// Unit test - aislado, sin dependencias reales
describe('calculateTotal', () => {
  it('WHEN items have tax THEN include tax in total', () => {
    const items = [{ price: 100 }, { price: 200 }];
    const total = calculateTotal(items, { taxRate: 0.21 });
    expect(total).toBe(363); // (100+200) * 1.21
  });
});
```

### Tests de Integracion

Prueban como multiples unidades trabajan juntas.

```typescript
// Integration test - con dependencias reales
describe('AuthController', () => {
  it('WHEN valid login THEN return 200 with token', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({ email: 'test@example.com', password: 'pass123' });

    expect(response.status).toBe(200);
    expect(response.body.token).toBeDefined();
  });
});
```

### Tests de Mocking

Aislar la unidad bajo test reemplazando dependencias.

```typescript
// Con mocks
describe('UserService', () => {
  it('WHEN user exists THEN return user data', async () => {
    // Mock del repositorio
    const mockRepo = jest.fn().mockResolvedValue({ id: 1, name: 'Test' });
    const service = new UserService(mockRepo);

    const user = await service.getUser(1);

    expect(user.name).toBe('Test');
  });
});
```

---

## Common Patterns

### Testing Excepciones

```typescript
it('WHEN divide by zero THEN throw error', () => {
  expect(() => calculator.divide(10, 0)).toThrow('Cannot divide by zero');
});
```

### Testing Async

```typescript
it('WHEN API responds THEN return data', async () => {
  const data = await fetchUser(1);
  expect(data.name).toBe('John');
});
```

### Testing Eventos

```typescript
it('WHEN button clicked THEN emit event', () => {
  const handler = jest.fn();
  button.on('click', handler);
  button.click();
  expect(handler).toHaveBeenCalled();
});
```

---

## Checklist de un Buen Test

- [ ] Nombre claro que describe el comportamiento
- [ ] Testea un solo comportamiento
- [ ] Arrange-Act-Assert visible
- [ ] Sin duplicacion con otros tests
- [ ] Fallido temporalmente (RED) antes de la implementacion
- [ ] Legible por cualquier persona del equipo

---

## Resumen

| Concepto | Punto clave |
|----------|-------------|
| RED-GREEN-REFACTOR | Ciclo de TDD |
| AAA | Arrange-Act-Assert |
| Naming | subject_WHEN_condition_THEN_expectation |
| Test unitario | Aislado, sin dependencias |
| Test integracion | Multiples unidades juntas |
| Mock | Reemplazar dependencias |

---

## Siguiente Capitulo

Continuar con: [06-Code-Review](./02-code-review.md)

## Recursos

- `equipo/testing/unitario/AGENT.md` — patrones completos
- `reglas/sdd-tdd/AGENT.md` — TDD teorico
