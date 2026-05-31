# 07 - Naming Conventions

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Convenciones de nombres para variables, funciones, archivos
- Como elegir nombres que revelan intencion
- Patrones comunes por tipo de elemento

---

## Principios Fundamentales

### 1. El nombre debe revelar intencion

El nombre de una variable, funcion o clase debe responder:
- **Que representa?**
- **Para que sirve?**
- **Como se usa?**

```typescript
// ❌ Malo - no revela nada
let d;

// ✅ Bueno - revela su proposito
let daysUntilExpiration;

// ❌ Malo - que es "x"?
function x(a, b) { ... }

// ✅ Bueno - describe la accion
function calculateDiscount(subtotal, taxRate) { ... }
```

### 2. Evitar nombres magicos

```typescript
// ❌ Malo - que significa 3600?
const timeout = 3600;

// ✅ Bueno - el numero tiene significado
const TIMEOUT_SECONDS = 3600;
// O mejor, semanticamente
const SESSION_DURATION_MS = 3600000;
```

### 3. Usar nombres Pronunciables

```typescript
// ❌ Malo
const dptmnt = 'Engineering';

// ✅ Bueno
const department = 'Engineering';
```

---

## Convenciones por Tipo

### Variables y Funciones

| Tipo | Convention | Ejemplo |
|------|------------|---------|
| Variables | camelCase | `userName`, `totalAmount` |
| Constantes | UPPER_SNAKE_CASE | `MAX_RETRIES`, `API_BASE_URL` |
| Funciones | camelCase, verbo + sustantivo | `getUserById`, `calculateTotal` |
| Booleanos | is/has/can/should + condition | `isActive`, `hasPermission` |

### Clases e Interfaces

| Tipo | Convention | Ejemplo |
|------|------------|---------|
| Clases | PascalCase, sustantivo | `UserService`, `PaymentProcessor` |
| Interfaces | PascalCase, I prefix (opcional) | `IUserService`, `UserRepository` |
| Enums | PascalCase | `OrderStatus`, `UserRole` |

### Archivos

| Tipo | Convention | Ejemplo |
|------|------------|---------|
| Componentes React | PascalCase | `UserProfile.tsx` |
| Servicios | kebab-case | `auth-service.ts` |
| Utilidades | kebab-case | `date-utils.ts` |
| Config | kebab-case | `eslint.config.js` |
| Tests | nombre.test.ts | `user.service.test.ts` |

---

## Patrones Comunes

### Funciones

```
verbo + objeto
├── getUser()
├── createOrder()
├── updateProfile()
├── deleteAccount()
├── calculateTotal()
├── fetchUsers()
└── validateEmail()
```

### Clases de Servicio

```
{Sustantivo}Service
├── AuthService
├── UserService
├── PaymentService
├── NotificationService
└── ReportService
```

### Clases de Repositorio

```
{Sustantivo}Repository
├── UserRepository
├── OrderRepository
└── ProductRepository
```

### Clases de Modelo

```
{Sustantivo} o {Sustantivo}Model
├── User
├── Order
├── ProductModel
└── UserProfile
```

---

## Nombres a Evitar

| Avoid | Reason |
|-------|--------|
| `data`, `info`, `temp` | Too generic |
| `obj`, `item`, `val` | No meaning |
| `a1`, `b2`, `x` | No context |
| single letters (except loop) | Unsearchable |
| Hungarian notation (strName) | Outdated |
| Abbreviations unclear | `usr` vs `user` |

---

## Ejemplo Completo

```typescript
// ❌ Antes - sin convenciones
function proc(d, s) {
  let x = d.map(i => i.t);
  if (s) return x[0];
  return x;
}

// ✅ Despues - con convenciones
function getFirstTag(tags: string[], includeInactive: boolean): string | null {
  const activeTags = tags.map(tag => tag.name);

  if (includeInactive) {
    return activeTags[0];
  }

  return activeTags[0] ?? null;
}
```

---

## Resumen

| Tipo | Convention |
|------|------------|
| Variables | camelCase |
| Constantes | UPPER_SNAKE_CASE |
| Funciones | get/create/update/delete + objeto |
| Clases | PascalCase, sustantivo |
| Archivos | kebab-case ( salvo componentes React) |
| Booleanos | is/has/can + condition |

---

## Siguiente Capitulo

Continuar con: [04-Git-Avanzado](./04-git-avanzado.md)

## Recursos

- `reglas/naming-conventions/AGENT.md` — referencia completa
