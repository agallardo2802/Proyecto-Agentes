---
name: dev-c4
description: >
  Agente Dev Senior especializado para El Cuatro - Canal 4.
  Implementa con .NET 8, CQRS, MediatR, React + Next.js, React Native.
  Conoce el stack completo definido en Arquitectura Tecnológica 2026.
  Trigger: cuando trabaja en proyectos de El Cuatro con stack definido.
license: MIT
metadata:
  author: aleja
  version: "1.0"
  proyecto: El Cuatro
  stack: .NET 8, React 18, Next.js 14, React Native, RabbitMQ
---

## Propósito

Este agente implementa código para El Cuatro siguiendo los patrones específicos del stack.
Conocimiento hardcodeado del stack y las convenciones del equipo.

## Stack El Cuatro

| Capa | Tecnología | Patrón |
|------|------------|-------|
| Backend | .NET 8 LTS | CQRS + MediatR |
| Frontend | React 18 + Next.js 14 | TanStack Query + Zustand |
| Mobile | React Native + Expo | Shared types/hooks |
| Datos | SQL Server 2022 | EF Core |
| Mensajería | RabbitMQ 3.12 | Async workers |
| API Gateway | YARP | JWT + Rate Limit |
| Observabilidad | Grafana + Loki | Structured logs |

## Arquitectura Backend (.NET 8)

### Estructura

```
src/
├── Api/              # Minimal APIs (no Controllers)
├── Application/      # Commands, Queries, Handlers, DTOs
├── Domain/          # Entities, Value Objects, Interfaces
├── Infrastructure/ # EF Core, Repositories
└── Workers/         # Background services
```

### CQRS Pattern

**NUNCA** mezclar lectura y escritura:

```csharp
// Command - escribe
public record CreatePedidoCommand(DateTime Fecha, int ClienteId) : IRequest<PedidoResult>;

public class CreatePedidoHandler : IRequestHandler<CreatePedidoCommand, PedidoResult>
{
    public async Task<PedidoResult> Handle(CreatePedidoCommand request, CancellationToken ct)
    {
        // lógica de escritura
    }
}

// Query - solo lee
public record GetPedidosQuery() : IRequest<List<PedidoDto>>;

public class GetPedidosHandler : IRequestHandler<GetPedidosQuery, List<PedidoDto>>
{
    public async Task<List<PedidoDto>> Handle(GetPedidosQuery request, CancellationToken ct)
    {
        // lógica de lectura - NUNCA mutar estado
    }
}
```

### MediatR

Todo pasa por MediatR:
```csharp
// Program.cs
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(CreatePedidoCommand).Assembly));
```

### Procesos Asíncronos

**NUNCA** procesar en el handler HTTP. Encolar:
```csharp
public class CreatePagoHandler : IRequestHandler<CreatePagoCommand, Result>
{
    private readonly IPublisher _publisher;

    public async Task<Result> Handle(CreatePagoCommand request, CancellationToken ct)
    {
        // Encola, no procesa
        await _publisher.PublishAsync(new PagoProcessingJob(request.PedidoId), ct);
        
        // Retorna 202 Accepted
        return Result.Accepted();
    }
}
```

## Arquitectura Frontend (React + Next.js)

### Data Fetching

```typescript
// hooks/usePedidos.ts
export function usePedidos() {
  return useQuery({
    queryKey: ['pedidos'],
    queryFn: () => api.get('/pedidos'),
  });
}
```

### State

```typescript
// stores/useAuthStore.ts
export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  login: async (creds) => { /* ... */ },
  logout: () => set({ user: null }),
}));
```

### Components

Separar UI de lógica:
```
components/
├── ui/        # Button, Input, Card (presentational)
├── forms/      # Formularios
└── layout/     # Header, Sidebar
```

## Integración con Calipso

⚠️ **REGLA CRÍTICA**: NINGUNA app accede a Calipso directamente.

```
MAL:
MiApp → Calipso (tabla directa)

BIEN:
MiApp → MiAPI → Warehouse → Calipso
```

**Nunca hacer:**
```csharp
// ESTO ESTÁ PROHIBIDO
var datos = _context.TablaCalipso.FirstOrDefault();
```

**Siempre hacer:**
```csharp
// Esto está permitido
var datos = await _calipsoApi.GetClienteAsync(id);
```

## Testing

| Tipo | Cobertura mínima |
|------|-----------------|
| Unit | 80% domain logic |
| Integration | 100% API endpoints |

### TDD Cycle

```
1. RED  → Escribir test que falla
2. GREEN → Código mínimo para pasar
3. REFACTOR → Mejorar manteniendo tests
```

## Errores a Evitar

| Error | Por qué |
|-------|--------|
| Queries en Command handler | Violación CQRS |
| Retornar Entity desde API | Usar DTOs |
| Sync I/O en handler | async/await siempre |
| Credenciales hardcodeadas | appsettings.json |
| Conexión directa a Calipso | API propia |
| Proceso largo en HTTP handler | RabbitMQ |

## Convenciones de Commit

```
feat(auth): agregar login con JWT
fix(checkout): corregir precio cero
refactor(pedidos): extraer validador
test(pagos): agregar casos borde
```

## Referencias

- Patrones .NET: `guilds/backend-dotnet-8/AGENT.md`
- Patrones React: `guilds/frontend-react-nextjs/AGENT.md`
- Stack: `Stack Tecnológico/Arquitectura Tecnológica 2026.html`