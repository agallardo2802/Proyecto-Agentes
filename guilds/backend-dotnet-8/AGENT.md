---
name: backend-dotnet-8
description: >
  Guild para proyectos Backend con .NET 8, CQRS, MediatR y patrones de Clean Architecture.
  Trigger: cuando se trabaja en APIs .NET 8, servicios backend, o integración con bases de datos.
license: MIT
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  stack: .NET 8, CQRS, MediatR, SQL Server, RabbitMQ
---

## Propósito

Este guild define los estándares, patrones y convenciones para desarrollo backend con .NET 8.
Todo proyecto nuevo en .NET 8 sigue estos patrones. No es negociable.

## Stack Definido

| Tecnología | Versión | Notas |
|------------|--------|-------|
| .NET | 8.x LTS | Solo esta versión |
| C# | 12+ | nullable reference types siempre |
| SQL Server | 2022 | Base de datos principal |
| RabbitMQ | 3.12+ | Colas asíncronas |
| MediatR | 12.x | Mediator pattern |
| EF Core | 8.x | ORM |
| YARP | 1.x | API Gateway |

## Patrones Obligatorios

### 1. CQRS (Command Query Responsibility Segregation)

```
├── Commands (escriben) → Mutan estado → Retornan void o result
└── Queries (leen)     → Solo leen   → Retornan DTOs
```

**Regla**: NUNCA usar el mismo modelo para lectura y escritura.

### 2. MediatR Pattern

Todo request pasa por MediatR:
```csharp
// Command
public record CreatePedidoCommand(DateTime fecha, int clienteId) : IRequest<PedidoResult>;

// Handler
public class CreatePedidoHandler : IRequestHandler<CreatePedidoCommand, PedidoResult>
{
    public async Task<PedidoResult> Handle(CreatePedidoCommand request, CancellationToken ct)
    {
        // lógica aquí
    }
}
```

### 3. Clean Architecture Layers

```
├── src/
│   ├── Api/              # Controllers, minimal APIs
│   ├── Application/      # Commands, Queries, Handlers, DTOs
│   ├── Domain/           # Entities, Value Objects, Interfaces
│   ├── Infrastructure/   # EF Core, Repositories, External Services
│   └── Workers/         # Background services, RabbitMQ consumers
```

### 4. API Conventions

- Minimal APIs (.NET 7+) sobre controllers tradicionales
- OpenAPI/Swagger siempre habilitado
- JWT authentication obligatoria
- Rate limiting por defecto

## Estructura de Proyecto

```
MiProyecto/
├── src/
│   ├── MiProyecto.Api/
│   │   ├── Program.cs
│   │   ├── appsettings.json
│   │   └── Properties/launchSettings.json
│   ├── MiProyecto.Application/
│   │   ├── Commands/
│   │   ├── Queries/
│   │   ├── DTOs/
│   │   └── Interfaces/
│   ├── MiProyecto.Domain/
│   │   ├── Entities/
│   │   ├── ValueObjects/
│   │   └── Enums/
│   ├── MiProyecto.Infrastructure/
│   │   ├── Data/
│   │   ├── Repositories/
│   │   └── Services/
│   └── MiProyecto.Workers/
│       └── Consumers/
├── tests/
│   └── MiProyecto.Tests/
├── docker-compose.yml
└── README.md
```

## Naming Conventions

| Elemento | Convention | Ejemplo |
|----------|-----------|--------|
| Entity | PascalCase singular | `Pedido` |
| Command | {Entity}{Action}Command | `CreatePedidoCommand` |
| Query | {Entity}{Action}Query | `GetPedidosQuery` |
| Handler | {Command/Query}Handler | `CreatePedidoHandler` |
| DTO | {Entity}{Response/Request}Dto | `PedidoDto` |
| Repository | I{Entity}Repository | `IPedidoRepository` |

## RabbitMQ Integration

Todo proceso largo pasa por cola:

```csharp
public record ProcessPaymentCommand : IRequest
{
    public int PedidoId { get; init; }
}

// El handler solo encola, no procesa
public class ProcessPaymentHandler : IRequestHandler<ProcessPaymentCommand>
{
    private readonly IPublisher _publisher;

    public async Task Handle(ProcessPaymentCommand request, CancellationToken ct)
    {
        // Encola el trabajo, no lo ejecuta
        await _publisher.PublishAsync(new PaymentProcessingJob(request.PedidoId), ct);
    }
}
```

## Tests Obligatorios

| Tipo | Coverage mínimo |
|------|----------------|
| Unit tests | 80% domain logic |
| Integration | 100% API endpoints |
| E2E | критически важные flujos |

## Errores Comunes a Evitar

1. **NUNCA hacer queries en el handler de un Command** → CQRS violation
2. **NUNCA retornar entity desde API** → Usar siempre DTOs
3. **NUNCA usar synchronous I/O** → async/await everywhere
4. **NUNCA hardcodar connection strings** → appsettings.json + override por environment
5. **NUNCA dejar Swagger enabled en PROD** → Deshabilitar con `#if !DEBUG`

## Registro de Dependencias

Usar extension methods:

```csharp
// Infrastructure/DependencyInjection.cs
public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration config)
{
    services.AddDbContext<AppDbContext>(options =>
        options.UseSqlServer(config.GetConnectionString("Default")));

    services.AddScoped<IPedidoRepository, PedidoRepository>();
    services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(CreatePedidoCommand).Assembly));

    return services;
}
```

## Logging y Observabilidad

Todo servicio registra con Serilog:

```csharp
_log.LogInformation("Pedido {PedidoId} creado por usuario {UsuarioId}",
    request.PedidoId, currentUser.Id);
```

Formatos estructurados, NO strings interpolados.

## Integración con ERP

⚠️ **REGLA CRÍTICA**: NINGUNA app accede directamente al Calipso.
Siempre a través de APIs propias en la capa de aplicación.

```
ERP Calipso → Warehouse API → Mi API → App
```

## Validación

- FluentValidation para commands y queries
- DataAnnotations para DTOs
- Validación en APPLICATION layer, no en API

## Resources

- [Minimal APIs .NET 8](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis/)
- [MediatR](https://github.com/jbogard/MediatR)
- [EF Core](https://learn.microsoft.com/en-us/ef/core/)
- [YARP](https://microsoft.github.io/reverse-proxy/)