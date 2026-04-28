---
name: frontend-react-nextjs
description: >
  Guild para proyectos Frontend con React, TypeScript, Next.js y Tailwind CSS.
  Trigger: cuando se trabaja en interfaces web, portales o backoffice.
license: MIT
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  stack: React 18+, TypeScript 5+, Next.js 14+, Tailwind CSS 3+
---

## Propósito

Este guild define los estándares, patrones y convenciones para desarrollo frontend con React y Next.js.
Todo proyecto nuevo en frontend sigue estos patrones.

## Stack Definido

| Tecnología | Versión | Notas |
|------------|--------|-------|
| React | 18.x | Solo esta versión |
| TypeScript | 5.x | strict mode siempre |
| Next.js | 14.x | App Router |
| Tailwind CSS | 3.x | Estilos |
| Vite | 5.x | Solo para apps no Next.js |
| TanStack Query | 5.x | Data fetching |
| Zustand | 4.x | State management |

## Patrones Obligatorios

### 1. Componentes Presentacionales

Separate UI de logica:
```
components/
├── ui/           # Buttons, Inputs, Cards (sin lógica de negocio)
├── forms/        # Formularios genéricos
└── layout/       # Header, Sidebar, Layout
```

### 2. App Router (Next.js 14+)

```
app/
├── (auth)/login/page.tsx
├── (portal)/
│   ├── page.tsx          # Dashboard
│   └── layout.tsx        # Portal layout con sidebar
├── api/                  # Route handlers
└── layout.tsx           # Root layout
```

### 3. Data Fetching con TanStack Query

```typescript
// hooks/usePedidos.ts
export function usePedidos() {
  return useQuery({
    queryKey: ['pedidos'],
    queryFn: () => api.get('/pedidos'),
  });
}
```

### 4. State con Zustand

```typescript
// stores/useAuthStore.ts
interface AuthState {
  user: User | null;
  login: (credentials: Credentials) => Promise<void>;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  login: async (credentials) => { /* ... */ },
  logout: () => set({ user: null }),
}));
```

## Estructura de Proyecto

```
mi-proyecto/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (auth)/
│   │   ├── (portal)/
│   │   └── api/
│   ├── components/
│   │   ├── ui/                # Shadcn/ui components
│   │   ├── forms/
│   │   └── layout/
│   ├── hooks/                  # Custom hooks
│   ├── lib/                   # Utils, API client
│   ├── stores/                # Zustand stores
│   ├── types/                 # TypeScript types
│   └── styles/
│       └── globals.css
├── public/
├── .env.local
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```

## Naming Conventions

| Elemento | Convention | Ejemplo |
|----------|-----------|--------|
| Component | PascalCase | `PedidoCard.tsx` |
| Hook | camelCase con use | `usePedidos.ts` |
| Store | camelCase con use | `useAuthStore.ts` |
| Utility | camelCase | `formatFecha.ts` |
| Type | PascalCase | `PedidoDto.ts` |
| Test | SameName.test.tsx | `PedidoCard.test.tsx` |

## Tailwind CSS

Usar siempre design tokens del proyecto:
```tsx
// BIEN
<Button className="bg-primary-500 text-white">

// MAL
<Button className="bg-blue-500">
```

## Manejo de Errores

```typescript
try {
  await mutationAsync(params);
} onError: (error) => {
  toast.error(error.message);
}
```

## Autenticación JWT

Token en cookie httpOnly, NO en localStorage.

## Types Obligatorios

```typescript
// response types
interface ApiResponse<T> {
  data: T;
  success: boolean;
  message?: string;
}

// paginated
interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  pageSize: number;
}
```

## SSR vs CSR

| Página | Tipo | Cuándo |
|--------|------|--------|
| Dashboard | SSR | Datos personalizables |
| Login | SSR | SEO no importa, velocidad sí |
| Lists | CSR | React Query maneja cache |
| Forms | CSR | Interactividad primero |

## Tests

| Tipo | Herramienta | Cobertura |
|------|-------------|----------|
| Unit | Vitest + Testing Library | 80% |
| Component | Vitest | 100% componentes |
| E2E | Playwright | критически важные flujos |

## Errores Comunes a Evitar

1. **NUNCA hardcodar URLs** → usar `NEXT_PUBLIC_API_URL`
2. **NUNCA guardar token en localStorage** → cookies only
3. **NUNCA hacer fetch directo en componente** → usar hooks
4. **NUNCA usar any** → TypeScript strict
5. **NUNCA mixear estilos inline con Tailwind** → solo Tailwind

## Integración con APIs

El frontend consume APIs propias, NO Calipso directo:
```
Frontend → API Gateway (.NET) → Warehouse → ERP
```

## UI Components (Shadcn/ui)

Usar siempre Shadcn/ui como base:
- Button, Input, Card, Dialog, etc.
- Customizables vía Tailwind

## deployment

```bash
# Dev
npm run dev

# Prod
npm run build
npm start
```

## Recursos

- [Next.js 14 App Router](https://nextjs.org/docs/app)
- [TanStack Query](https://tanstack.com/query/latest)
- [Tailwind CSS](https://tailwindcss.com/)
- [Shadcn/ui](https://ui.shadcn.com/)