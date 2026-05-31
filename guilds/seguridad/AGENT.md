---
name: guild-seguridad
description: >
  Guild de seguridad tech-agnóstico. Estándar de AppSec aplicado transversalmente
  junto al dev agent y todos los guilds de stack. Cubre OWASP Top 10, auth, crypto,
  secretos, headers, CORS, logging de seguridad y supply chain.
  Trigger: cuando se escribe código que procesa input, maneja identidad, datos
  sensibles o se despliega una app a staging/prod.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar ejemplos al stack del proyecto
    - Coordinar severidades con el agente equipo/seguridad/appsec
---

# Guild de Seguridad

Un guild NO ejecuta tareas — valida que el trabajo del dev agent cumpla los estándares. Cada regla es binaria: cumple o no cumple.

Este guild se inyecta junto al dev agent en **todo** trabajo que toque input, identidad, datos sensibles, endpoints públicos o despliegues. Complementa `reglas/seguridad-web` subiendo el nivel a estándar AppSec.

## Marco de referencia

- OWASP Top 10 (2021 y sucesivos)
- OWASP ASVS — Application Security Verification Standard
- OWASP Proactive Controls
- CWE Top 25

## Clasificación de severidad

| Severidad | Definición | Acción |
|-----------|-----------|--------|
| **Crítica** | Permite takeover, exfiltración masiva o RCE | Bloquea merge. Fix antes de cualquier otra cosa. |
| **Alta** | Permite acceso no autorizado, escalamiento o bypass de auth | Bloquea merge. Se planifica fix con prioridad. |
| **Media** | Debilita postura (headers faltantes, logs sensibles, validación débil) | No bloquea pero debe tener ticket. |
| **Baja** | Best practice no crítica | Se registra como deuda. |

## Checklist OWASP Top 10 por PR

Antes de aprobar el PR, el dev agent o el agente AppSec debe confirmar:

### A01 — Broken Access Control
- [ ] Autorización validada en servidor, NUNCA solo en UI
- [ ] IDOR: no se confía en IDs del request para determinar ownership
- [ ] Endpoints admin protegidos por rol, no por obscurity
- [ ] JWT valida `aud`, `iss`, `exp` y firma

### A02 — Cryptographic Failures
- [ ] Contraseñas hasheadas con Argon2id / bcrypt (cost ≥ 12) — nunca MD5/SHA1
- [ ] TLS 1.2+ obligatorio; HSTS en headers
- [ ] Datos sensibles cifrados en reposo (PII, tokens, secretos de terceros)
- [ ] Sin claves criptográficas hardcodeadas — siempre en KMS/vault

### A03 — Injection
- [ ] SQL: queries parametrizadas o ORM; prohibido concatenar strings
- [ ] Prohibido `SELECT *` en código productivo (ver `guilds/sql-server-2022`)
- [ ] Sin SQL dinámico sin parámetros
- [ ] Comandos del SO: sin `exec`/`shell` con input del usuario
- [ ] LDAP/XPath/NoSQL: usar APIs parametrizadas

### A04 — Insecure Design
- [ ] Threat model hecho en features con `security-impact: alto` (auth, pagos, datos personales)
- [ ] Rate limiting en endpoints de auth y recursos costosos
- [ ] Validación de tipo, longitud y rango en todo input

### A05 — Security Misconfiguration
- [ ] Stack traces NO se exponen al cliente en PROD
- [ ] Swagger/OpenAPI deshabilitado en PROD (ver guild de stack backend)
- [ ] Headers de seguridad: `Content-Security-Policy`, `Strict-Transport-Security`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, `Permissions-Policy`
- [ ] CORS: whitelist explícita, nunca `*` en endpoints autenticados
- [ ] Cuentas default deshabilitadas

### A06 — Vulnerable and Outdated Components
- [ ] Dependencias sin CVE crítico (SCA en pipeline)
- [ ] Lock files (`package-lock.json`, `packages.lock.json`, etc.) versionados
- [ ] Supply chain: solo paquetes de registries confiables

### A07 — Identification and Authentication Failures
- [ ] MFA disponible para usuarios privilegiados
- [ ] Tokens con expiración razonable (access ≤ 15min, refresh con rotación)
- [ ] Tokens en headers `Authorization`, NUNCA en URL
- [ ] Logout invalida tokens del lado servidor cuando el modelo lo permite
- [ ] Contra brute force: lockout / backoff / captcha

### A08 — Software and Data Integrity Failures
- [ ] CI/CD firma artefactos o genera SHA trazables
- [ ] Webhooks validan firma (HMAC o similar)
- [ ] Actualizaciones de config vienen de fuente verificada

### A09 — Security Logging and Monitoring Failures
- [ ] Eventos de seguridad logueados: login ok/fail, cambio de permisos, acceso a datos sensibles
- [ ] Logs NO contienen secretos, tokens, ni PII en claro
- [ ] Correlation ID en todos los logs de request (ver `guilds/integraciones`)
- [ ] Alertas configuradas para picos anómalos

### A10 — Server-Side Request Forgery (SSRF)
- [ ] URLs de terceros validadas contra allowlist
- [ ] Metadatos de cloud (169.254.169.254) bloqueados salvo excepción documentada

## Manejo de secretos

Reglas duras:
- Secretos NUNCA en código, `appsettings.json`, `.env` committeado, ni en logs.
- Secrets scan (gitleaks/trufflehog) obligatorio en pipeline y pre-commit hook.
- Si un secreto se filtró: **rotar inmediatamente**, no solo borrar el commit.
- Rotación periódica documentada (≤ 90 días para claves de servicio).
- Uso de Key Vault / Secret Manager según plataforma del proyecto.

## Identidad y sesión

- JWT: validar `iss`, `aud`, `exp`, firma. Nunca `alg: none`.
- Refresh tokens rotativos y revocables.
- Cookies de sesión: `HttpOnly`, `Secure`, `SameSite=Lax` o `Strict`.
- No generar IDs de sesión predecibles; usar CSPRNG.

## Datos personales (PII)

- Clasificar datos al crear tablas (ver `guilds/datos/data-governance`).
- Minimizar: no guardar lo que no se usa.
- Enmascarar en logs (`email: a***@dominio.com`).
- Considerar retención y borrado según marco legal aplicable.

## Integración con ERP sistema externo crítico

El **principio #13** (solo API propia, nunca acceso directo a la base) también es una regla de seguridad: evita exponer credenciales del ERP, controla rate, loguea accesos y permite auditoría. El guild de seguridad **rechaza** cualquier código que viole este principio.

## Cuándo escalar al agente AppSec

Se invoca `equipo/seguridad/appsec` (ver su AGENT.md) cuando:

- La Task toca auth, crypto o identidad
- Se maneja PII, datos financieros o de salud
- Hay integración nueva con sistema externo expuesto a internet
- Se implementan endpoints públicos (sin auth)
- Se cambia política de CORS, CSP o headers
- Hay sospecha o incidente de seguridad en curso
- El PR apunta a `master` con cambios en paths sensibles (ver `equipo/devops/pr`)

## Herramientas recomendadas por capa

| Capa | Herramienta | Stage |
|------|-------------|-------|
| SAST | SonarQube / CodeQL / Semgrep | pipeline post-lint |
| SCA | OWASP Dependency-Check / dependabot / Snyk | pipeline post-build |
| Secrets scan | gitleaks / trufflehog | pre-commit + pipeline |
| DAST | OWASP ZAP baseline | staging post-deploy |
| Container scan | Trivy | pipeline post-build |

El detalle de integración vive en `equipo/devops/cicd/AGENT.md`.

## Errores comunes a evitar

1. Validar solo en el cliente → siempre duplicar en servidor.
2. Confiar en el `Origin` del request para autorización → se puede spoofear.
3. Usar `Math.random()` para tokens → usar CSPRNG.
4. Guardar password con hash rápido (SHA-256, MD5) → Argon2id / bcrypt.
5. Devolver stack trace al cliente en error → loguear interno, mensaje genérico afuera.
6. `try/catch` que traga la excepción → viola el principio #4.
7. Copiar y pegar política CORS de Stack Overflow → whitelist explícita siempre.
8. Dejar endpoints de debug o `/actuator` expuestos en PROD.

## Output esperado cuando el guild participa

1. Checklist OWASP marcado con severidades.
2. Hallazgos con CWE/OWASP refs.
3. Fix concreto o ticket con severidad.
4. Recomendación: aprobar, pedir cambios o escalar a `equipo/seguridad/appsec`.

## Recursos

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
