---
name: login-web
description: >
  Crear pantalla de login para portales internos de GGSoluciones.
  Estándar visual y funcional con modo claro/oscuro, diseño institucional + operativo,
  errores controlados y usuarios de prueba.
  Usar cuando el usuario diga "login", "pantalla de acceso", "autenticación", "ingreso".
---

# Login Web - Estándar GGSoluciones

Este skill define el estándar visual y funcional para pantallas de login en portales internos de GGSoluciones. Todos los portales deben seguir este formato para mantener consistencia.

## Cuándo usar este skill

- Usuario dice: "login", "pantalla de acceso", "crear autenticación"
- Necesitás una pantalla de login para un portal interno
- El portal es nuevo o no tiene login estandarizado

## Principios obligatorios

### 1. Contraste primero
- Ningún texto puede quedar gris claro sobre fondo blanco ni negro sobre azul oscuro
- Validar títulos, labels, placeholders, botones, badges y mensajes de error en ambos modos

### 2. Login de dos zonas
- **Zona institucional / hero**: Logo, nombre del portal, descripción
- **Zona operativa / formulario**: Campos, usuarios de prueba, botón
- **Desktop**: Layout en dos columnas
- **Mobile**: Apilar hero arriba y formulario abajo

### 3. Identidad GGSoluciones visible
- Logo arriba o dentro del hero
- Texto del portal debajo: `PORTAL COMERCIAL`, `INTRANET`, `PORTAL BENEFICIOS`, etc.
- Usar rojo GGSoluciones (`#d30027`) como color primario de acción

### 4. Formulario simple
- Campo clave/contraseña claro
- Botón principal visible y ancho completo
- Usuarios/perfiles de prueba como cards seleccionables si aplica
- Mostrar clave DEV solo si es ambiente DEV

### 5. Errores controlados
**NO mostrar**: stack traces, `Failed to fetch`, tokens, headers, errores técnicos

**SÍ mostrar**:
- "No se pudo iniciar sesión. Verificá la clave e intentá nuevamente."
- "La sesión venció. Volvé a ingresar."
- "El servicio no está disponible. Avisá a soporte."

## Layout base (HTML)

```html
<section class="login-page" data-theme="dark">
  <div class="login-shell">
    <aside class="login-hero">
      <img class="login-logo" src="/assets/logo-ggsoluciones.svg" alt="GGSoluciones" />
      <span class="login-kicker">PORTAL COMERCIAL</span>
      <h1>Gestión de ventas y clientes en un solo lugar</h1>
      <p>Acceso interno conectado al API Gateway y base DEV.</p>

      <div class="login-status-pills">
        <span>API Gateway</span>
        <span>BD DEV</span>
        <span>Roles</span>
      </div>
    </aside>

    <main class="login-card">
      <h2>Ingresá al sistema</h2>
      <p class="login-help">Seleccioná tu perfil e ingresá la clave asignada.</p>

      <label for="login-password">Clave</label>
      <input id="login-password" type="password" placeholder="Clave de usuario" autocomplete="current-password" />

      <div class="login-users">
        <button class="login-user-card selected" type="button">
          <span class="avatar">AG</span>
          <span>
            <strong>Alejandro Gallardo</strong>
            <small>Vendedor · TV Music</small>
          </span>
        </button>
      </div>

      <p class="login-dev-note">🔐 DEV · Usar credenciales de prueba definidas por el proyecto.</p>

      <button class="login-submit" type="button">Ingresar</button>
    </main>
  </div>
</section>
```

## CSS con modo claro y oscuro

```css
:root {
  --ec-red: #d30027;
  --ec-red-dark: #a8001f;
  --ec-bg: #f8fafc;
  --ec-surface: #ffffff;
  --ec-text: #0f172a;
  --ec-muted: #64748b;
  --ec-border: #dbe3ef;
  --ec-shadow: 0 24px 70px rgba(15, 23, 42, .18);
}

[data-theme="dark"] {
  --ec-bg: #0f172a;
  --ec-surface: #111827;
  --ec-text: #f8fafc;
  --ec-muted: #a8b3c7;
  --ec-border: #2f3b52;
  --ec-shadow: 0 24px 70px rgba(0, 0, 0, .45);
}

.login-page {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 32px;
  background:
    radial-gradient(circle at 20% 20%, rgba(211, 0, 39, .18), transparent 28%),
    linear-gradient(135deg, var(--ec-bg), #1f1f1f);
  color: var(--ec-text);
}

.login-shell {
  width: min(980px, 100%);
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(360px, 420px);
  gap: clamp(28px, 5vw, 72px);
  align-items: center;
}

.login-hero h1 {
  margin: 0;
  font-size: clamp(38px, 5vw, 64px);
  line-height: .95;
  letter-spacing: -.04em;
  color: var(--ec-text);
}

.login-card {
  background: var(--ec-surface);
  border: 1px solid var(--ec-border);
  border-radius: 28px;
  padding: 32px;
  box-shadow: var(--ec-shadow);
}

.login-card input {
  width: 100%;
  min-height: 46px;
  padding: 0 14px;
  border: 1px solid var(--ec-border);
  border-radius: 14px;
  background: color-mix(in srgb, var(--ec-surface) 88%, var(--ec-bg));
  color: var(--ec-text);
  outline: none;
}

.login-card input:focus {
  border-color: var(--ec-red);
  box-shadow: 0 0 0 4px rgba(211, 0, 39, .14);
}

.login-submit {
  width: 100%;
  min-height: 48px;
  border: 0;
  border-radius: 14px;
  background: var(--ec-red);
  color: white;
  font-weight: 900;
  cursor: pointer;
  box-shadow: 0 16px 30px rgba(211, 0, 39, .24);
}

.login-submit:hover {
  background: var(--ec-red-dark);
}

@media (max-width: 860px) {
  .login-shell {
    grid-template-columns: 1fr;
    gap: 24px;
  }
}
```

## Regla para portales con sidebar

Si el portal reutiliza un shell con sidebar fija (como Portal Comercial), el login NO debe renderizar el sidebar ni reservar su columna.

**CSS:**
```css
/* Login: sin sidebar por defecto */
.sidebar { display: none; }
body { display: block; }

/* App autenticada: recién ahí aparece el shell con sidebar */
body.logged-in {
  display: grid;
  grid-template-columns: 260px 1fr;
}

body.logged-in .sidebar { display: flex; }
```

**JavaScript (al login exitoso):**
```js
document.body.classList.add('logged-in');
```

**JavaScript (al cerrar sesión):**
```js
document.body.classList.remove('logged-in');
```

⚠️ **Validación**: En pantalla de login no puede quedar una columna vacía a la izquierda ni un borde/espacio reservado para el sidebar.

## Usuarios de prueba (cards seleccionables)

```html
<div class="login-users">
  <button class="login-user-card selected" type="button">
    <span class="avatar">AG</span>
    <span>
      <strong>Alejandro Gallardo</strong>
      <small>Vendedor · TV Music</small>
    </span>
  </button>
  <button class="login-user-card" type="button">
    <span class="avatar">PM</span>
    <span>
      <strong>Pedro Martínez</strong>
      <small>Gerente · Ventas</small>
    </span>
  </button>
</div>
```

```css
.login-user-card {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px;
  border: 1px solid var(--ec-border);
  border-radius: 16px;
  background: color-mix(in srgb, var(--ec-surface) 90%, var(--ec-bg));
  cursor: pointer;
  text-align: left;
}

.login-user-card:hover,
.login-user-card.selected {
  border-color: var(--ec-red);
  box-shadow: 0 10px 24px rgba(211, 0, 39, .12);
}

.avatar {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  border-radius: 999px;
  background: var(--ec-red);
  color: white;
  font-weight: 900;
}
```

## Notas de ambiente DEV

Solo mostrar en ambientes DEV, nunca en PROD:

```html
<p class="login-dev-note">🔐 DEV · Usar credenciales de prueba definidas por el proyecto.</p>
```

```css
.login-dev-note {
  margin: 18px 0;
  color: var(--ec-muted);
  text-align: center;
  font-size: 13px;
}
```

## Flujo de autenticación (recomendado)

1. Usuario ingresa clave
2. Click en "Ingresar" o Enter
3. Loading en botón
4. POST a `/api/auth/login`
5. Si éxito: guardar token, redirigir a dashboard, agregar `body.logged-in`
6. Si error: mostrar mensaje controlado, no técnica

## Checklist de entrega

- [ ] Login se ve correcto en desktop
- [ ] Login se ve correcto en mobile
- [ ] Modo claro legible
- [ ] Modo oscuro legible
- [ ] Logo visible y proporcionado
- [ ] Botón principal claro (rojo GGSoluciones)
- [ ] Errores funcionales, no técnicos
- [ ] Campos con foco visible (border rojo)
- [ ] Cards de usuarios de prueba accesibles
- [ ] Sin textos quemados de otro portal
- [ ] Si el portal tiene sidebar, no aparece ni reserva espacio en el login
- [ ] Después de login exitoso, `document.body.classList.add('logged-in')` activa el shell con sidebar
- [ ] En ambiente DEV, mostrar clave general
