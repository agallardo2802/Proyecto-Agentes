---
name: web-skeleton
description: >
  Generar el esqueleto base de una nueva aplicación web para GGSoluciones.
  Incluye estructura de carpetas, configuración inicial, componentes base,
  estilos CSS tokens, y estructura de páginas para portales internos.
  Usar cuando el usuario diga "nueva web", "nuevo portal", "crear proyecto base".
---

# Web Skeleton - Esqueleto Base para Portales GGSoluciones

Este skill genera la estructura base para un nuevo portal/web interno de GGSoluciones, asegurando que todos los proyectos sigan el mismo formato, convenciones y estilos desde el día 1.

## Cuándo usar este skill

- Usuario dice: "nueva web", "nuevo portal", "crear proyecto", "empezar desde cero"
- Necesitás bootstrap de un portal con estructura lista para desarrollar
- Primer desarrollo de un nuevo sistema interno

## Stack por defecto

| Capa | Tecnología |
|------|------------|
| Backend | .NET 8 (Web API) |
| Frontend | React 18 + Vite |
| Estilos | Tailwind CSS + CSS Variables |
| API Gateway | YARP |
| Base de datos | SQL Server 2022 |
| Autenticación | JWT con refresh tokens |

## Estructura de carpetas obligatoria

```
{NOMBRE_PROYECTO}/
├── backend/
│   ├── src/
│   │   ├── {Nombre}.Api/           # API Gateway / Controllers
│   │   │   ├── Controllers/
│   │   │   ├── Middleware/
│   │   │   ├── Program.cs
│   │   │   └── appsettings.json
│   │   ├── {Nombre}.Application/   # Casos de uso, Commands, Queries
│   │   │   ├── Commands/
│   │   │   ├── Queries/
│   │   │   ├── DTOs/
│   │   │   └── Interfaces/
│   │   ├── {Nombre}.Domain/        # Entidades, Value Objects, Domain Services
│   │   │   ├── Entities/
│   │   │   ├── ValueObjects/
│   │   │   └── Enums/
│   │   └── {Nombre}.Infrastructure/# EF Core, Repositories, Servicios externos
│   │       ├── Data/
│   │       ├── Repositories/
│   │       └── Services/
│   ├── tests/
│   │   ├── {Nombre}.Api.Tests/
│   │   └── {Nombre}.Application.Tests/
│   ├── .editorconfig
│   └── README.md
│
├── frontend/
│   ├── src/
│   │   ├── components/              # Componentes reutilizables
│   │   │   ├── ui/                 # Componentes base (Button, Input, etc.)
│   │   │   └── shared/             # Componentes del dominio
│   │   ├── pages/                  # Páginas / Routers
│   │   ├── services/               # Llamadas API
│   │   ├── hooks/                  # Custom hooks
│   │   ├── store/                  # Estado (Zustand / Context)
│   │   ├── styles/                 # CSS, tokens, theme
│   │   ├── types/                  # TypeScript types
│   │   ├── utils/                  # Funciones helper
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── public/                     # Assets estáticos
│   ├── index.html
│   ├── package.json
│   ├── tailwind.config.js
│   ├── vite.config.ts
│   └── tsconfig.json
│
└── docs/
    ├── arquitectura.md             # Decisiones arquitectónicas (ADR)
    ├── api.md                      # Documentación de endpoints
    └── deploy.md                   # Guía de despliegue
```

## Componentes base obligatorios

El frontend DEBE incluir estos componentes desde el inicio:

### UI Kit (src/components/ui/)

| Componente | Descripción |
|------------|-------------|
| `Button` | Botón primario, secundario, outline, ghost. Variantes: primary, secondary, danger. Tamaños: sm, md, lg |
| `Input` | Input de texto con label, error, disabled. Soporte para type: text, password, email |
| `Select` | Dropdown con opciones, búsqueda, multi-select |
| `Table` | Tabla con headers, rows, pagination, sortable columns |
| `Modal` | Dialog modal con header, body, footer, close button |
| `Card` | Contenedor con padding, shadow, border radius |
| `Badge` | Indicador de estado: success, warning, error, info |
| `Spinner` | Loading indicator |
| `Toast` | Notificaciones temporales: success, error, warning, info |
| `Sidebar` | Navegación lateral con items, iconos, collapse |
| `Header` | Header con logo, user menu, notifications |
| `Pagination` | Controles de paginación |

### Tokens CSS obligatorios

```css
:root {
  /* Colores GGSoluciones */
  --ec-red: #d30027;
  --ec-red-dark: #a8001f;
  --ec-red-light: #fde8ea;

  /* Fondos modo claro */
  --ec-bg-primary: #f8fafc;
  --ec-bg-secondary: #ffffff;
  --ec-bg-tertiary: #f1f5f9;

  /* Fondos modo oscuro */
  --ec-dark-bg-primary: #0f172a;
  --ec-dark-bg-secondary: #111827;
  --ec-dark-bg-tertiary: #1e293b;

  /* Texto */
  --ec-text-primary: #0f172a;
  --ec-text-secondary: #64748b;
  --ec-text-muted: #94a3b8;
  --ec-dark-text-primary: #f8fafc;
  --ec-dark-text-secondary: #a8b3c7;

  /* Borders */
  --ec-border: #dbe3ef;
  --ec-dark-border: #2f3b52;

  /* Estados */
  --ec-success: #10b981;
  --ec-warning: #f59e0b;
  --ec-error: #ef4444;
  --ec-info: #3b82f6;

  /* Espaciado */
  --ec-space-1: 4px;
  --ec-space-2: 8px;
  --ec-space-3: 12px;
  --ec-space-4: 16px;
  --ec-space-5: 20px;
  --ec-space-6: 24px;
  --ec-space-8: 32px;
  --ec-space-10: 40px;
  --ec-space-12: 48px;

  /* Border radius */
  --ec-radius-sm: 6px;
  --ec-radius-md: 10px;
  --ec-radius-lg: 16px;
  --ec-radius-xl: 24px;
  --ec-radius-full: 9999px;

  /* Sombras */
  --ec-shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --ec-shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --ec-shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  --ec-shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);

  /* Transiciones */
  --ec-transition-fast: 150ms ease;
  --ec-transition-normal: 250ms ease;
  --ec-transition-slow: 350ms ease;
}
```

## Páginas base obligatorias

Todo portal debe incluir estas páginas desde el inicio:

| Página | Ruta | Descripción |
|--------|------|-------------|
| Login | `/login` | Pantalla de autenticación (usar skill login-web) |
| Dashboard | `/dashboard` | Página principal después del login |
| 404 | `/404` | Página no encontrada |
| 500 | `/500` | Error interno del servidor |

## Configuración inicial requerida

### backend/{Nombre}.Api/appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database={Nombre}Db;Trusted_Connection=true;TrustServerCertificate=true"
  },
  "Auth": {
    "Jwt": {
      "Key": "${JWT_SECRET}",
      "Issuer": "{Nombre} API",
      "Audience": "{Nombre} Frontend",
      "ExpiryMinutes": 60,
      "RefreshTokenExpiryDays": 7
    }
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

### frontend/vite.config.ts

```ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true,
      },
    },
  },
});
```

### frontend/tailwind.config.js

```js
/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        ec: {
          red: '#d30027',
          'red-dark': '#a8001f',
          'red-light': '#fde8ea',
        },
      },
    },
  },
  plugins: [],
};
```

## Git hooks obligatorios

Incluir en el proyecto:

```bash
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'
      - name: Restore
        run: dotnet restore backend/{Nombre}.Api/{Nombre}.Api.csproj
      - name: Build
        run: dotnet build backend/{Nombre}.Api/{Nombre}.Api.csproj --no-restore
      - name: Test
        run: dotnet test backend/tests --no-build --verbosity quiet

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      - name: Install
        run: npm ci
      - name: Lint
        run: npm run lint
      - name: Build Front
        run: npm run build
```

## Convenciones de nomenclatura

| Tipo | Convención | Ejemplo |
|------|------------|---------|
| Proyectos .NET | PascalCase | `PortalComercial.Api` |
| Clases | PascalCase | `UsuarioService` |
| Métodos | PascalCase | `GetByIdAsync` |
| Variables | camelCase | `usuarioActual` |
| Constantes | UPPER_SNAKE_CASE | `MAX_REINTENTOS` |
| Archivos CSS | kebab-case | `button-styles.css` |
| Componentes React | PascalCase | `UserCard.tsx` |
| Rutas API | kebab-case | `/api/usuarios` |

## Checklist de entrega

- [ ] Estructura de carpetas según spec
- [ ] UI Kit completo (todos los componentes base)
- [ ] Tokens CSS con modo claro/oscuro
- [ ] Login (usar template existente)
- [ ] Dashboard básico
- [ ] Rutas 404 y 500
- [ ] Configuración JWT funcionando
- [ ] Conexión a DB configurada
- [ ] GitHub Actions CI configurado
- [ ] README con guía de setup
- [ ] ADR de arquitectura inicial
