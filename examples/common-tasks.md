# Ejemplo 1: Fix de bug simple

**Contexto**: El login no valida la contraseña correctamente.

---

**Paso 1: Investigar**
```
@reglas/debugging

El usuario reporta que puede hacer login con cualquier contraseña.
Buscá en el código de autenticación la función que valida credenciales.
```

**Paso 2: Test que reproduce**
```
@equipo/testing/unitario

Escribir un test que verifique que login falla con contraseña incorrecta.
El test debe pasar actuales (mostrando el bug) antes del fix.
```

**Paso 3: Fix**
```
@equipo/desarrollo/dev

Implementar el fix utilizando TDD:
1. El test ya está escrito (rojo)
2. Implementar la validación mínima para que pase (verde)
3. Refactorizar si es necesario (amarillo)
```

**Paso 4: PR**
```
@equipo/devops/pr/github

Crear PR vinculado al bug en el board.
Incluir:
- Descripción del problema
- Steps para reproducir
- Fix implementado
- Tests que pasan
```

---

## Ejemplo 2: Nueva feature

**Contexto**: Agregar sistema de logout con invalidación de sesión.

---

**Paso 1: Historia**
```
@equipo/producto/pm

Crear user story:
- Título: Logout con invalidación de sesión
- Como usuario logueado quiero cerrar sesión para que mi cuenta quede segura
- Criteria:
  - Al hacer click en logout, sesión queda invalidate
  - Token ya no es válido para llamadas API
  - Redirect a página de login
```

**Paso 2: Análisis**
```
@equipo/producto/analista

Dado un usuario logueado quando hace click en logout
Entonces la sesión debe ser invalidada
Y el token no debe ser aceptado en futuras requests
Y el usuario es redirigido a /login

Dado un usuario con token expired quando intenta hacer logout
Entonces recibe error 401
Y es redirigido a /login
```

**Paso 3: Diseño**
```
@equipo/producto/arquitecto

- Agregar endpoint POST /api/auth/logout
- Invalidar token en Redis (TTL = 0)
- Agregar header Authorization validation en middleware
- Flow: Client -> POST /logout -> Redis (invalidate) -> 200 OK
```

**Paso 4: Implementación**
```
@equipo/desarrollo/dev

TDD:
1. Test: logout invalida token
2. Implementar: endpoint + Redis invalidation
3. Test: token invalidado falla en requests
4. Implementar: middleware validation

Seguir: guilds/backend-dotnet, reglas/error-handling
```

**Paso 5: PR**
```
@equipo/devops/pr/github

AB#123: Agregar logout con invalidación de sesión
[ ] Tests unitarios pasan
[ ] Code review aprobado
[ ] Security review (si toca auth)
```

---

## Ejemplo 3: Code Review

**Contexto**: Revisar PR que agrega endpoints de pago.

---

**Paso 1: Revisión técnica**
```
@reglas/code-review

Revisar el PR:focus en:
- Naming de métodos y variables
- Manejo de errores
- Validaciones de input
-Logging de operaciones sensibles
```

**Paso 2: Revisión seguridad**
```
@reglas/seguridad-web

Revisar:
- Validación de input (no SQL injection)
- Uso de secretos en código
- CORS configurado
- Rate limiting
- Autenticación correcta
```

**Paso 3: Revisión performance**
```
@reglas/performance-web

Revisar:
- N+1 queries
- Carga innecesaria de datos
- Lazy loading apropiado
- Cache cuando corresponda
```

---

## Ejemplo 4: Onboarding dev nuevo

---

**Setup entorno**
```
@reglas/onboarding

1. Clonar repo: git clone https://github.com/org/proyecto.git
2. Instalar dependencias: dotnet restore / npm install
3. Configurar appsettings.json.local
4. Correr migrate: dotnet ef database update
5. Correr tests: dotnet test
```

**Workflow diario**
```
@reglas/git-avanzado

# Nueva rama para tarea
git checkout -b feature/PROJ-123-descripcion

# Hacer cambios y commit
git add .
git commit -m "feat(auth): agregar validacion de password"

# Subir cambios
git push -u origin feature/PROJ-123-descripcion

# Crear PR
gh pr create --title "feat(auth): agregar validacion" --body "..."
```

**Cómo contribuir**
```
@equipo/devops/pr/github

1. Fork del repo
2. Rama desde main
3. Changes con convencionales commits
4. PR con description completa
5. Code review approval
6. CI/CD verde
```