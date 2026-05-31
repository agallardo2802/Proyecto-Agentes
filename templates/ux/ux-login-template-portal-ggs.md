# Template UX Login — Portales GGSoluciones

Este template define el estándar visual y funcional para pantallas de login en portales internos de GGSoluciones. Usalo como regla base del agente UX/UI para que todos los portales mantengan consistencia, legibilidad y soporte de modo claro/oscuro.

## Objetivo

Diseñar un login corporativo claro, moderno y operativo, evitando pantallas genéricas, bajo contraste o formularios confusos. El login debe comunicar:

- Producto o portal al que se ingresa.
- Contexto interno de GGSoluciones.
- Estado de conexión a API Gateway / BD DEV si aplica.
- Acceso por usuario/clave local o perfil de prueba.
- Soporte visual completo para modo claro y modo oscuro.

## Principios obligatorios

1. **Contraste primero**
   - Ningún texto puede quedar gris claro sobre fondo blanco ni negro sobre azul oscuro.
   - Validar títulos, labels, placeholders, botones, badges y mensajes de error en ambos modos.

2. **Login de dos zonas**
   - Zona institucional / hero.
   - Zona operativa / formulario.
   - En desktop usar layout en dos columnas.
   - En mobile apilar el hero arriba y el formulario abajo.

3. **Identidad GGSoluciones visible**
   - Logo arriba o dentro del hero.
   - Texto del portal debajo: `PORTAL COMERCIAL`, `INTRANET`, `PORTAL BENEFICIOS`, etc.
   - Usar rojo GGSoluciones como color primario de acción.

4. **Formulario simple**
   - Campo clave/contraseña claro.
   - Botón principal visible y ancho completo.
   - Usuarios/perfiles de prueba como cards seleccionables si aplica.
   - Mostrar clave DEV sólo si es ambiente DEV.

5. **Errores controlados**
   - No mostrar stack traces, `Failed to fetch`, tokens, headers ni errores técnicos.
   - Mensajes permitidos:
     - `No se pudo iniciar sesión. Verificá la clave e intentá nuevamente.`
     - `La sesión venció. Volvé a ingresar.`
     - `El servicio no está disponible. Avisá a soporte.`

## Layout base

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

## CSS base con modo claro y oscuro

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

.login-hero {
  min-width: 0;
}

.login-logo {
  width: 220px;
  max-width: 100%;
  display: block;
  margin-bottom: 20px;
}

.login-kicker {
  display: block;
  margin-bottom: 16px;
  color: var(--ec-muted);
  font-size: 12px;
  font-weight: 800;
  letter-spacing: .28em;
}

.login-hero h1 {
  margin: 0;
  font-size: clamp(38px, 5vw, 64px);
  line-height: .95;
  letter-spacing: -.04em;
  color: var(--ec-text);
}

.login-hero p {
  max-width: 520px;
  margin: 20px 0 0;
  color: var(--ec-muted);
  font-size: 17px;
  line-height: 1.55;
}

.login-status-pills {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 28px;
}

.login-status-pills span {
  padding: 8px 14px;
  border: 1px solid var(--ec-border);
  border-radius: 999px;
  color: var(--ec-text);
  background: rgba(255, 255, 255, .08);
  font-size: 12px;
  font-weight: 700;
}

.login-card {
  background: var(--ec-surface);
  border: 1px solid var(--ec-border);
  border-radius: 28px;
  padding: 32px;
  box-shadow: var(--ec-shadow);
}

.login-card h2 {
  margin: 0;
  color: var(--ec-text);
  font-size: 26px;
  line-height: 1.15;
}

.login-help {
  margin: 8px 0 24px;
  color: var(--ec-muted);
  line-height: 1.45;
}

.login-card label {
  display: block;
  margin-bottom: 8px;
  color: var(--ec-text);
  font-size: 13px;
  font-weight: 800;
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

.login-card input::placeholder {
  color: var(--ec-muted);
}

.login-card input:focus {
  border-color: var(--ec-red);
  box-shadow: 0 0 0 4px rgba(211, 0, 39, .14);
}

.login-users {
  display: grid;
  gap: 10px;
  margin-top: 18px;
}

.login-user-card {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px;
  border: 1px solid var(--ec-border);
  border-radius: 16px;
  background: color-mix(in srgb, var(--ec-surface) 90%, var(--ec-bg));
  color: var(--ec-text);
  text-align: left;
  cursor: pointer;
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

.login-user-card strong {
  display: block;
  color: var(--ec-text);
}

.login-user-card small {
  display: block;
  margin-top: 3px;
  color: var(--ec-muted);
}

.login-dev-note {
  margin: 18px 0;
  color: var(--ec-muted);
  text-align: center;
  font-size: 13px;
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
  .login-page {
    padding: 20px;
    align-items: start;
  }

  .login-shell {
    grid-template-columns: 1fr;
    gap: 24px;
  }

  .login-hero h1 {
    font-size: 38px;
  }

  .login-card {
    padding: 24px;
    border-radius: 22px;
  }
}
```

## Regla obligatoria para portales con sidebar

Si el portal reutiliza el shell de Portal Comercial con sidebar fija, el login NO debe renderizar el sidebar ni reservar su columna. El layout debe ser de una sola columna hasta que la sesión esté iniciada.

En `/Portal_Comercial/css/styles.css`, usar este patrón:

```css
/* Login: sin sidebar por defecto */
.sidebar {
  display: none;
}

body {
  display: block;
}

/* App autenticada: recién ahí aparece el shell con sidebar */
body.logged-in {
  display: grid;
  grid-template-columns: 260px 1fr;
}

body.logged-in .sidebar {
  display: flex;
}
```

En `app.js`, cuando el login sea exitoso:

```js
document.body.classList.add('logged-in');
```

Y al cerrar sesión o volver al login:

```js
document.body.classList.remove('logged-in');
```

Validación visual obligatoria: en pantalla de login no puede quedar una columna vacía a la izquierda ni un borde/espacio reservado para el sidebar.

## Reglas para el agente UX/UI

Pegá estas reglas en el agente:

```md
Cuando diseñes un login para portales GGSoluciones:

1. Usá siempre un layout institucional + formulario operativo.
2. Implementá modo claro y oscuro desde el inicio, no como parche posterior.
3. Validá contraste en títulos, labels, placeholders, botones, cards y mensajes.
4. Usá rojo GGSoluciones como acción primaria y fondos neutros oscuros/claros.
5. No muestres errores técnicos al usuario final.
6. Si hay usuarios de prueba, mostrarlos como cards seleccionables con rol y unidad.
7. Si es ambiente DEV, mostrar una nota chica con la clave general; nunca en PROD.
8. El botón principal debe ser ancho completo, visible y con texto de acción concreto.
9. En desktop, usar dos columnas; en mobile, una sola columna responsive.
10. Si el portal tiene sidebar, ocultarla por defecto y mostrarla sólo con `body.logged-in`.
11. Antes de entregar, revisar visualmente modo claro y oscuro.
```

## Checklist de validación

- [ ] El login se ve correcto en desktop.
- [ ] El login se ve correcto en mobile.
- [ ] Modo claro legible.
- [ ] Modo oscuro legible.
- [ ] Logo visible y proporcionado.
- [ ] Botón principal claro.
- [ ] Errores funcionales, no técnicos.
- [ ] Campos con foco visible.
- [ ] Cards seleccionables accesibles.
- [ ] Sin textos quemados de otro portal.
- [ ] Si el portal tiene sidebar, no aparece ni reserva espacio en el login.
- [ ] Después de login exitoso, `document.body.classList.add('logged-in')` activa el shell con sidebar.
