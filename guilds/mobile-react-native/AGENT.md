---
name: mobile-react-native
description: >
  Guild para proyectos Mobile con React Native y Expo.
  Comparte lógica con el frontend web.
  Trigger: apps móviles iOS/Android.
license: MIT
metadata:
  author: aleja
  version: "1.0"
  stack: React Native 0.74+, Expo SDK 50+, TypeScript 5+
  proyecto: El Cuatro
---

## Stack Definido

| Tecnología | Versión |
|------------|--------|
| React Native | 0.74.x |
| Expo | SDK 50 |
| TypeScript | 5.x |
| Zustand | 4.x |
| TanStack Query | 5.x |

## REGLA: shared Library

Types y hooks se comparten entre web y mobile:

```
packages/shared/
├── types/    # PedidoDto, User - IGUALES
├── hooks/    # usePedidos - IGUALES
└── utils/    # formateo
```

## Estructura

```
mobile/
├── src/
│   ├── app/           # Expo Router
│   ├── components/    # Shared con web
│   ├── hooks/        # Shared
│   ├── stores/      # Zustand (shared)
│   └── types/       # Shared types
└── app.json
```

## Data Fetching

TanStack Query - mismo hook que web:
```typescript
export function usePedidos() {
  return useQuery({
    queryKey: ['pedidos'],
    queryFn: () => api.get('/pedidos'),
  });
}
```

## State

Zustand - mismo store que web:
```typescript
export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  login: async (creds) => { /* ... */ },
  logout: () => set({ user: null }),
}));
```

## Errores a Evitar

1. **NUNCA duplicar tipos** → shared package
2. **NUNCA duplicar hooks** → shared
3. **NUNCA hardcodar URLs** → env
4. **NUNCA guardar token en AsyncStorage** → encrypted storage

## Build

```bash
# Dev
expo start

# iOS
expo run:ios

# Android
expo run:android
```

## Recursos

- [Expo](https://expo.dev/)
- [React Navigation](https://reactnavigation.org/)