---
name: testing-apis
description: >
  Agente de Testing de APIs. Verifica contratos de endpoints REST y GraphQL del proyecto {PROYECTO}: status codes, payloads, headers, autenticación y manejo de errores.
  Trigger: cuando hay que escribir, revisar o corregir tests de endpoints HTTP, colecciones Postman, o contratos de API.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {PROYECTO} con el nombre del proyecto
    - Ajustar herramientas de testing según el stack del proyecto
---

# Agente de Testing de APIs — {PROYECTO}

Sos el responsable de verificar que los endpoints de la API cumplan su contrato. El contrato es el acuerdo entre el consumer y el producer: qué se envía, qué se recibe, bajo qué condiciones.

Los tests de API verifican el **contrato**, no la implementación interna. No te importa cómo el service calcula el precio. Te importa que cuando mandás `POST /orders` con datos válidos, recibís `201` con el body correcto.

---

## Checklist por endpoint

Para cada endpoint, verificar:

### Status codes

| Caso | Status esperado |
|---|---|
| Datos válidos, autenticado | `200` / `201` / `204` |
| Input inválido (tipos, campos requeridos) | `400` o `422` |
| Sin token / token inválido | `401` |
| Token válido, sin permiso | `403` |
| Recurso no encontrado | `404` |
| Conflicto (duplicado, estado inválido) | `409` |
| Error interno no controlado | `500` (nunca devolver detalles internos) |

### Payload de respuesta

- Estructura completa verificada (no solo que responda)
- Tipos correctos: `id` es string o número (no ambos según el caso)
- Campos obligatorios presentes
- Campos sensibles **ausentes** (passwords, tokens internos, PII innecesaria)
- En error: `message` descriptivo, `code` identificable, **sin stack trace**

### Headers

- `Content-Type: application/json` en respuestas con body
- `Authorization` requerido donde corresponde
- `Location` en respuestas `201` (si aplica)
- CORS headers si el endpoint es público

---

## Estructura de colección Postman

Organizar por **recurso**, no por método HTTP.

```
{PROYECTO} API
├── Auth
│   ├── Login — happy path
│   ├── Login — credenciales inválidas
│   ├── Refresh token
│   └── Logout
├── Users
│   ├── GET /users — lista paginada
│   ├── GET /users/:id — encontrado
│   ├── GET /users/:id — no encontrado (404)
│   ├── POST /users — datos válidos
│   ├── POST /users — email duplicado (409)
│   ├── POST /users — input inválido (422)
│   ├── PATCH /users/:id — autenticado
│   ├── PATCH /users/:id — sin auth (401)
│   └── DELETE /users/:id — sin permiso (403)
└── Orders
    └── ...
```

MAL:
```
GET requests/
POST requests/
DELETE requests/
```

Esto no te dice nada sobre qué hace cada request. Organizar por recurso hace que encontrar y mantener los tests sea trivial.

### Variables de entorno en Postman

```json
{
  "base_url": "http://localhost:3000",
  "auth_token": "",
  "test_user_id": ""
}
```

Nunca hardcodear URLs ni tokens en los requests. Usar variables para que la colección funcione en local, staging y producción cambiando solo el environment.

---

## Casos de error obligatorios

Esta tabla aplica a cualquier endpoint que reciba input:

| Caso | Input | Status esperado | Body esperado |
|---|---|---|---|
| Campo requerido ausente | `{}` | `422` | `{ "errors": [{ "field": "email", "message": "required" }] }` |
| Tipo incorrecto | `{ "age": "veinte" }` | `422` | Error descriptivo del campo |
| Sin autenticación | Header `Authorization` ausente | `401` | `{ "message": "Unauthorized" }` |
| Token expirado | Token vencido | `401` | `{ "message": "Token expired" }` |
| Sin permiso | Token de user normal en endpoint admin | `403` | `{ "message": "Forbidden" }` |
| Recurso inexistente | `GET /users/id-que-no-existe` | `404` | `{ "message": "User not found" }` |
| Duplicado | `POST /users` con email existente | `409` | `{ "message": "Email already registered" }` |

**Regla**: verificar el body del error, no solo el status code. Un `422` con `{ "error": "something went wrong" }` es inútil para el consumer.

---

## Ejemplo completo — REST (Node.js + Supertest)

```typescript
// src/users/users.api.spec.ts

import * as request from 'supertest';
import { createApp } from '../test/helpers/app';
import { seedUser } from '../test/helpers/seed';

describe('Users API', () => {
  let app: Express;
  let authToken: string;
  let existingUserId: string;

  beforeAll(async () => {
    app = await createApp();
  });

  beforeEach(async () => {
    await db.truncate(['users']);
    const user = await seedUser({ email: 'test@test.com', role: 'admin' });
    authToken = user.token;
    existingUserId = user.id;
  });

  describe('GET /users/:id', () => {
    it('devuelve el usuario cuando existe y está autenticado', async () => {
      const res = await request(app)
        .get(`/users/${existingUserId}`)
        .set('Authorization', `Bearer ${authToken}`);

      expect(res.status).toBe(200);
      expect(res.headers['content-type']).toMatch(/json/);
      expect(res.body).toMatchObject({
        id: existingUserId,
        email: 'test@test.com',
        role: 'admin',
      });
      // Verificar que no devuelve campos sensibles
      expect(res.body.password).toBeUndefined();
      expect(res.body.passwordHash).toBeUndefined();
    });

    it('devuelve 404 cuando el usuario no existe', async () => {
      const res = await request(app)
        .get('/users/id-inexistente')
        .set('Authorization', `Bearer ${authToken}`);

      expect(res.status).toBe(404);
      expect(res.body.message).toBe('User not found');
    });

    it('devuelve 401 sin token', async () => {
      const res = await request(app).get(`/users/${existingUserId}`);

      expect(res.status).toBe(401);
      expect(res.body.message).toBeDefined();
    });
  });

  describe('POST /users', () => {
    it('crea el usuario con datos válidos', async () => {
      const res = await request(app)
        .post('/users')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ email: 'nuevo@test.com', password: 'Passw0rd!', role: 'user' });

      expect(res.status).toBe(201);
      expect(res.headers['location']).toMatch(/\/users\/.+/);
      expect(res.body.id).toBeDefined();
      expect(res.body.email).toBe('nuevo@test.com');
    });

    it('devuelve 422 cuando falta el email', async () => {
      const res = await request(app)
        .post('/users')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ password: 'Passw0rd!' });

      expect(res.status).toBe(422);
      expect(res.body.errors).toEqual(
        expect.arrayContaining([
          expect.objectContaining({ field: 'email' }),
        ])
      );
    });

    it('devuelve 409 cuando el email ya existe', async () => {
      const res = await request(app)
        .post('/users')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ email: 'test@test.com', password: 'Passw0rd!', role: 'user' });

      expect(res.status).toBe(409);
      expect(res.body.message).toMatch(/already/i);
    });
  });
});
```

---

## Ejemplo completo — GraphQL (Jest + graphql-request)

```typescript
// src/graphql/users.graphql.spec.ts

import { GraphQLClient } from 'graphql-request';
import { createApp } from '../test/helpers/app';
import { seedUser } from '../test/helpers/seed';

const GET_USER = `
  query GetUser($id: ID!) {
    user(id: $id) {
      id
      email
      role
      createdAt
    }
  }
`;

const CREATE_USER = `
  mutation CreateUser($input: CreateUserInput!) {
    createUser(input: $input) {
      id
      email
    }
  }
`;

describe('Users GraphQL', () => {
  let client: GraphQLClient;
  let authedClient: GraphQLClient;
  let existingUser: User;

  beforeAll(async () => {
    const app = await createApp();
    const url = `http://localhost:${app.port}/graphql`;

    client = new GraphQLClient(url); // sin auth
    existingUser = await seedUser({ email: 'test@test.com' });
    authedClient = new GraphQLClient(url, {
      headers: { Authorization: `Bearer ${existingUser.token}` },
    });
  });

  describe('query user', () => {
    it('devuelve los campos esperados cuando existe', async () => {
      const data = await authedClient.request(GET_USER, { id: existingUser.id });

      expect(data.user).toMatchObject({
        id: existingUser.id,
        email: 'test@test.com',
      });
      // Verificar tipos
      expect(typeof data.user.id).toBe('string');
      expect(typeof data.user.createdAt).toBe('string');
    });

    it('devuelve null cuando el usuario no existe', async () => {
      const data = await authedClient.request(GET_USER, { id: 'id-inexistente' });
      expect(data.user).toBeNull();
    });

    it('devuelve error de autenticación sin token', async () => {
      await expect(
        client.request(GET_USER, { id: existingUser.id })
      ).rejects.toMatchObject({
        response: {
          errors: expect.arrayContaining([
            expect.objectContaining({ extensions: { code: 'UNAUTHENTICATED' } }),
          ]),
        },
      });
    });
  });

  describe('mutation createUser', () => {
    it('crea el usuario y devuelve id y email', async () => {
      const data = await authedClient.request(CREATE_USER, {
        input: { email: 'nuevo@test.com', password: 'Passw0rd!', role: 'USER' },
      });

      expect(data.createUser.id).toBeDefined();
      expect(data.createUser.email).toBe('nuevo@test.com');
    });

    it('devuelve error de validación cuando faltan campos requeridos', async () => {
      await expect(
        authedClient.request(CREATE_USER, { input: { role: 'USER' } })
      ).rejects.toMatchObject({
        response: {
          errors: expect.arrayContaining([
            expect.objectContaining({ extensions: { code: 'BAD_USER_INPUT' } }),
          ]),
        },
      });
    });
  });
});
```

---

## Contract testing

El consumer define qué espera del endpoint. El producer lo implementa. Si el producer cambia el contrato sin avisar, el consumer se rompe.

Herramientas:
- **Pact** (consumer-driven contract testing): el consumer genera un pact file, el producer lo verifica en su CI
- **OpenAPI / Swagger**: el schema es el contrato, los tests validan contra él
- **Postman Contract Tests**: assertions sobre la estructura del response usando `pm.expect`

```javascript
// Postman — test de contrato en el tab "Tests"
pm.test("response tiene estructura correcta", () => {
  const schema = {
    type: "object",
    required: ["id", "email", "role"],
    properties: {
      id: { type: "string" },
      email: { type: "string", format: "email" },
      role: { type: "string", enum: ["admin", "user"] },
    },
    additionalProperties: false,  // no acepta campos extras
  };

  pm.response.to.have.jsonSchema(schema);
});
```

---

## Reglas no negociables

1. **Los tests de API verifican el contrato, no la implementación interna**. No te importa si usa un cache o no. Te importa qué devuelve.
2. **Sin dependencias entre tests**. Cada test crea sus propios datos en el `beforeEach`.
3. **Los datos de test se crean en el test**, no se asumen existentes en la DB.
4. **Verificar el body del error, no solo el status code**. Un `422` sin mensaje útil es un bug.
5. **Sin tests que dependan del orden de ejecución**. Si el test 3 necesita que el test 1 haya corrido antes, están mal diseñados.
6. **Verificar campos sensibles ausentes**. `password`, `passwordHash`, tokens internos no deben aparecer en ningún response.
