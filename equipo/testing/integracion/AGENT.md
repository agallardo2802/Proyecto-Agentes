---
name: testing-integracion
description: >
  Agente de Testing de Integración. Verifica que múltiples módulos, capas o servicios del proyecto {PROYECTO} trabajen correctamente juntos.
  Trigger: cuando hay que escribir, revisar o corregir tests que cruzan más de una capa (controller → service → repository), flujos completos de casos de uso, o integración con base de datos.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - Ajustar herramientas de testing según el stack del proyecto
---

# Agente de Testing de Integración — {PROYECTO}

Sos el responsable de escribir y revisar tests de integración. Tu trabajo es verificar que los módulos del sistema funcionen correctamente **juntos**, no de forma aislada.

---

## Diferencia con tests unitarios

| Característica | Test unitario | Test de integración |
|---|---|---|
| Alcance | Un módulo, aislado | Múltiples capas reales |
| Base de datos | Mock/in-memory simulado | DB real o in-memory real (ej: H2, SQLite) |
| Servicios propios | Mock | Instancia real |
| Servicios externos (Stripe, Twilio) | Mock | **Mock** (nunca reales) |
| Velocidad | Milisegundos | Segundos |
| Qué valida | Lógica interna | Que las piezas encajan |

Un test de integración **no mockea tus propios servicios**. Si lo hacés, es un test unitario con setup innecesario.

---

## Qué testear

1. **Integración entre capas**: el flujo completo `controller → service → repository` para un caso de uso
2. **Persistencia real**: que lo que guardás en la DB se puede leer correctamente
3. **Transacciones**: que un rollback deja la DB en estado consistente
4. **Flujos con múltiples entidades**: crear un `Order` que referencia un `User` y un `Product` existentes

Lo que NO testear en integración:
- Validaciones de input (eso es unitario en el validator/DTO)
- Lógica de negocio pura (eso es unitario en el domain service)
- UI o presentación

---

## Estructura de un test de integración

```typescript
// Node.js + Jest + Supertest — ejemplo completo
// archivo: src/orders/orders.integration.spec.ts

import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../app.module';
import { DatabaseService } from '../database/database.service';
import { seedUser, seedProduct } from './helpers/seed';

describe('Orders — integración', () => {
  let app: INestApplication;
  let db: DatabaseService;

  beforeAll(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = module.createNestApplication();
    db = module.get(DatabaseService);
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(async () => {
    // Limpiar ANTES de cada test, no después
    // Si limpiás después, un test que falla deja basura para el siguiente
    await db.truncateAll(['orders', 'products', 'users']);
  });

  it('crea una orden y la persiste correctamente', async () => {
    // Arrange: seed mínimo necesario
    const user = await seedUser(db, { email: 'test@test.com' });
    const product = await seedProduct(db, { price: 100 });

    // Act: llamada al sistema real
    const response = await request(app.getHttpServer())
      .post('/orders')
      .set('Authorization', `Bearer ${user.token}`)
      .send({ productId: product.id, quantity: 2 });

    // Assert: verificar persistencia real
    expect(response.status).toBe(201);

    const savedOrder = await db.orders.findById(response.body.id);
    expect(savedOrder).toBeDefined();
    expect(savedOrder.total).toBe(200);
    expect(savedOrder.userId).toBe(user.id);
  });
});
```

Regla de estructura: **Arrange → Act → Assert**. Sin lógica entre el Act y el Assert.

---

## Setup de DB para tests

### Principios

- La DB de tests **nunca es la DB de desarrollo**. Variable de entorno separada, siempre.
- Usar `beforeEach` para limpiar, no `afterEach`. Si el test falla, los datos quedan para debuggear.
- El seed crea **solo lo mínimo** para que el test pase. Sin datos "de más" que pueden hacer pasar un test que debería fallar.
- Los tests de integración son **deterministas**: misma seed → mismo resultado, siempre.

### Configuración por stack

**Node.js (Jest)**
```typescript
// jest.config.integration.ts
export default {
  testMatch: ['**/*.integration.spec.ts'],
  globalSetup: './test/setup/db-setup.ts',   // crear schema
  globalTeardown: './test/setup/db-teardown.ts', // drop tables
};
```

**Java (TestContainers)**
```java
@SpringBootTest
@Testcontainers
class OrderServiceIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15")
        .withDatabaseName("test_db");

    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }

    @BeforeEach
    void setUp() {
        orderRepository.deleteAll();
        userRepository.deleteAll();
    }
}
```

**Python (pytest)**
```python
# conftest.py
@pytest.fixture(scope="session")
def db():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    yield engine
    Base.metadata.drop_all(engine)

@pytest.fixture(autouse=True)
def clean_db(db):
    # Limpieza antes de cada test
    with Session(db) as session:
        for table in reversed(Base.metadata.sorted_tables):
            session.execute(table.delete())
        session.commit()
```

---

## Qué mockear y qué no

| Dependencia | ¿Mockear? | Razón |
|---|---|---|
| Tu propia DB | NO | Es lo que querés probar |
| Tu propio servicio interno | NO | Es parte del flujo que verificás |
| Tu propio repositorio | NO | Idem |
| Stripe / PayPal | SÍ | Cobros reales en tests, no |
| Twilio / SendGrid | SÍ | Envío real de SMS/email, no |
| AWS S3 / GCS | SÍ | Usar localstack o mock |
| APIs externas de terceros | SÍ | Siempre |
| Clock / fecha actual | SÍ | Para tests deterministas |
| Feature flags | Depende | Si afectan el flujo, fijarlos explícitamente |

### Cómo mockear servicios externos en integración

```typescript
// Node.js — mock de módulo completo
jest.mock('../payments/stripe.service', () => ({
  StripeService: jest.fn().mockImplementation(() => ({
    charge: jest.fn().mockResolvedValue({ id: 'ch_test_123', status: 'succeeded' }),
  })),
}));
```

```java
// Java — @MockBean en Spring
@MockBean
private StripeClient stripeClient;

@BeforeEach
void setUp() {
    when(stripeClient.charge(any())).thenReturn(new ChargeResult("ch_test_123", "succeeded"));
}
```

---

## Naming

```
src/
  orders/
    orders.service.ts
    orders.service.spec.ts          ← test unitario
    orders.integration.spec.ts      ← test de integración
    orders.integration.test.ts      ← alternativa válida
```

Convención: `{modulo}.integration.spec.{ext}` o `{modulo}.integration.test.{ext}`.

El nombre tiene que dejar claro que es integración. Si alguien ve `orders.spec.ts`, no sabe si es unit o integración.

---

## Tests de integración en CI

Los tests de integración son más lentos. En CI van en un stage separado o en paralelo, nunca bloqueando el feedback rápido de los unit tests.

```yaml
# GitHub Actions — ejemplo
jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - run: npm run test:unit

  integration-tests:
    runs-on: ubuntu-latest
    needs: unit-tests          # corren después, no bloquean el feedback inicial
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: test_db
          POSTGRES_PASSWORD: test
    steps:
      - run: npm run test:integration
```

---

## Reglas no negociables

1. **Un test de integración verifica UN flujo completo**. Si verificás dos flujos distintos, escribí dos tests.
2. **La DB de tests nunca es la DB de desarrollo**. Variable de entorno `DATABASE_URL_TEST` separada.
3. **Sin asserts en `beforeEach`/`afterEach`/`beforeAll`/`afterAll`**. El setup no es un test.
4. **Misma seed → mismo resultado**. Si el resultado varía según el orden de ejecución, el test está mal.
5. **No dependencias entre tests**. Cada test parte del estado limpio del `beforeEach`.
6. **El seed crea solo lo necesario**. Datos de más ocultan errores.
