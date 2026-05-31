# 14 - Seguridad Web

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Los principales vectores de ataque web
- Como prevenir XSS, CSRF, inyeccion
- Manejo seguro de secretos
- Headers de seguridad

---

## OWASP Top 10

Los riesgos de seguridad mas criticos en aplicaciones web:

1. **A01: Broken Access Control** — Acceso no autorizado
2. **A02: Cryptographic Failures** — Fallas de criptografia
3. **A03: Injection** — Inyeccion (SQL, NoSQL, Command)
4. **A04: Insecure Design** — Diseno inseguro
5. **A05: Security Misconfiguration** — Configuracion incorrecta
6. **A06: Vulnerable Components** — Componentes vulnerables
7. **A07: Auth Failures** — Fallos de autenticacion
8. **A08: Data Integrity Failures** — Integridad de datos
9. **A09: Logging Failures** — Fallos de logging
10. **A10: SSRF** — Server-Side Request Forgery

---

## Inyeccion (Injection)

### SQL Injection

```typescript
// ❌ Malo - vulnerable
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ Bueno - parametizado
const query = 'SELECT * FROM users WHERE email = ?';
db.execute(query, [email]);

// ✅ Mejor - usar ORM
const user = await User.findOne({ where: { email } });
```

### Command Injection

```typescript
// ❌ Malo - ejecutar comando del usuario
exec(`ping ${host}`);

// ✅ Bueno - sanitizar o no usar
execFile('ping', [host]);
```

### Prevention

- Usar queries parametrizadas
- Validar y sanitizar input
- Principio de minimo privilegio
- Escapar output

---

## XSS - Cross-Site Scripting

### Tipos

1. **Reflected** — Parametro en la URL
2. **Stored** — Guardado en la DB
3. **DOM** — Manipulacion del DOM

### Ejemplo

```typescript
// ❌ Malo - renderiza HTML sin sanitizar
<div>{userInput}</div>

// ✅ Bueno - sanitize
import DOMPurify from 'dompurify';
<div>{DOMPurify.sanitize(userInput)}</div>

// ✅ React automatico (por defecto)
// Pero evitar dangerouslySetInnerHTML
```

### Prevention

- Sanitizar todo input del usuario
- Usar frameworks que automaticen escape
- Content Security Policy (CSP)
- HTTPOnly cookies

---

## CSRF - Cross-Site Request Forgery

### Como funciona

```
1. Usuario logueado en bank.com
2. Visita malicious.com (en otra tab)
3. malicious.com ejecuta POST a bank.com/transfer?to=hacker&amount=10000
4. El navegador'envia las cookies de bank.com automaticamente
5. Transferencia exitosa
```

### Prevention

```typescript
// ✅ Usar tokens CSRF
app.use(csrf());

// ✅ Verificar SameSite cookie
res.cookie('session', token, {
  sameSite: 'strict',
  httpOnly: true,
  secure: true
});
```

---

## Secretos en Codigo

### ❌ NUNCA hacer esto

```typescript
// Malo - hardcoded secrets
const API_KEY = '<NON_REAL_API_KEY_EXAMPLE>';
const DB_PASSWORD = '<NON_REAL_PASSWORD_EXAMPLE>';
```

### ✅ SIEMPRE hacer esto

```typescript
// Leer de variables de entorno
const API_KEY = process.env.API_KEY;
const DB_PASSWORD = process.env.DB_PASSWORD;

// .env (NO commitear)
API_KEY=<set-in-local-env-only>
DB_PASSWORD=<set-in-local-env-only>
```

### GitIgnore

```
# .gitignore
.env
.env.local
*.pem
*.key
credentials.json
```

### Secret Scanning

```yaml
# GitHub Actions
- name: TruffleHog
  uses: trufflesecurity/trufflehog@main
```

---

## Headers de Seguridad

### Nginx

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header Content-Security-Policy "default-src 'self'" always;
```

### Express.js

```typescript
import helmet from 'helmet';
app.use(helmet());
```

---

## Validacion de Input

```typescript
import Joi from 'joi';

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(8).required(),
  age: Joi.number().integer().min(18).max(120)
});

const { error, value } = userSchema.validate(input);
if (error) {
  throw new ValidationError(error.message);
}
```

---

## Resumen

| Vulnerabilidad | Prevencion |
|----------------|------------|
| SQL Injection | Queries parametizadas |
| XSS | Sanitizar + escaping |
| CSRF | Tokens + SameSite cookies |
| Secrets | Variables de entorno |
| Headers | helmet/CSP |

---

## Siguiente Capitulo

Continuar con: [04-Onboarding](./04-onboarding.md)

## Recursos

- `reglas/seguridad-web/AGENT.md` — guia completa
- `guilds/seguridad/AGENT.md` — estandares
- OWASP Top 10: https://owasp.org/www-project-top-ten/
