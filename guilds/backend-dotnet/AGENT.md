---
name: guild-backend-dotnet
description: >
  Guild Backend .NET / C#. Valida que el trabajo del dev agent cumpla los estándares
  de arquitectura, errores, logging, seguridad, performance y testing.
  Aplica a cualquier versión de .NET Core soportada — hoy .NET 8 LTS.
  Trigger: cuando el agente de desarrollo trabaja con esta tecnología.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "2.0"
  type: guild
  stack: .NET 8 LTS, CQRS, MediatR, EF Core, SQL Server, RabbitMQ, YARP
  adapt:
    - Ajustar versión de .NET al LTS vigente del proyecto
---

# Guild Backend .NET / C#

Un guild NO ejecuta tareas — valida que el trabajo del dev agent cumpla los estándares. Cada regla es binaria: cumple o no cumple.

Este guild aplica a todo proyecto .NET Core del equipo. La versión evoluciona (8 → 9 → 10…) pero los patrones y convenciones se mantienen. Si el proyecto no usa la versión LTS vigente, escalar a arquitectura.

## Stack vigente

| Tecnología | Versión actual | Notas |
|------------|----------------|-------|
| .NET | 8 LTS | Versión soportada del equipo |
| C# | 12+ | nullable reference types siempre |
| SQL Server | 2022 | Ver `guilds/sql-server-2022` |
| RabbitMQ | 3.12+ | Colas asíncronas |
| MediatR | 12.x | Mediator pattern |
| EF Core | 8.x | ORM |
| YARP | 1.x | API Gateway — ver `reglas/yarp-gateway` |

## Patrones obligatorios

### 1. CQRS (Command Query Responsibility Segregation)

```
├── Commands (escriben) → Mutan estado → Retornan void o result
└── Queries (leen)      → Solo leen    → Retornan DTOs
```

Regla: NUNCA usar el mismo modelo para lectura y escritura.

### 2. MediatR Pattern

Todo request pasa por MediatR:

```csharp
public record CreatePedidoCommand(DateTime fecha, int clienteId) : IRequest<PedidoResult>;

public class CreatePedidoHandler : IRequestHandler<CreatePedidoCommand, PedidoResult>
{
    public async Task<PedidoResult> Handle(CreatePedidoCommand request, CancellationToken ct)
    {
        // lógica aquí
    }
}
```

### 3. Clean Architecture

```
├── src/
│   ├── Api/              # Controllers, minimal APIs
│   ├── Application/      # Commands, Queries, Handlers, DTOs
│   ├── Domain/           # Entities, Value Objects, Interfaces
│   ├── Infrastructure/   # EF Core, Repositories, External Services
│   └── Workers/          # Background services, RabbitMQ consumers
```

### 4. API Conventions

- Minimal APIs sobre controllers tradicionales.
- OpenAPI/Swagger siempre habilitado en entornos no productivos.
- JWT authentication obligatoria.
- Rate limiting por defecto.

## Estructura de proyecto

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

## Naming conventions

| Elemento | Convención | Ejemplo |
|----------|------------|---------|
| Entity | PascalCase singular | `Pedido` |
| Command | {Entity}{Action}Command | `CreatePedidoCommand` |
| Query | {Entity}{Action}Query | `GetPedidosQuery` |
| Handler | {Command/Query}Handler | `CreatePedidoHandler` |
| DTO | {Entity}{Response/Request}Dto | `PedidoDto` |
| Repository | I{Entity}Repository | `IPedidoRepository` |

## RabbitMQ Integration

Todo proceso largo pasa por cola. El handler solo encola, no procesa.

```csharp
public record ProcessPaymentCommand : IRequest
{
    public int PedidoId { get; init; }
}

public class ProcessPaymentHandler : IRequestHandler<ProcessPaymentCommand>
{
    private readonly IPublisher _publisher;

    public async Task Handle(ProcessPaymentCommand request, CancellationToken ct)
    {
        await _publisher.PublishAsync(new PaymentProcessingJob(request.PedidoId), ct);
    }
}
```

## Tests obligatorios

| Tipo | Cobertura mínima |
|------|------------------|
| Unit tests | 80% de la lógica de dominio |
| Integration | 100% de los endpoints de API |
| E2E | Flujos críticos de negocio |

## Errores comunes a evitar

1. NUNCA hacer queries en el handler de un Command → violación de CQRS.
2. NUNCA retornar entity desde la API → usar siempre DTOs.
3. NUNCA usar I/O sincrónico → async/await en todos lados.
4. NUNCA hardcodear connection strings → `appsettings.json` + override por entorno.
5. NUNCA dejar Swagger habilitado en PROD → deshabilitar por configuración.

## Registro de dependencias

```csharp
public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration config)
{
    services.AddDbContext<AppDbContext>(options =>
        options.UseSqlServer(config.GetConnectionString("Default")));

    services.AddScoped<IPedidoRepository, PedidoRepository>();
    services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(CreatePedidoCommand).Assembly));

    return services;
}
```

## Logging y observabilidad

Todo servicio registra con Serilog en formato estructurado, nunca strings interpolados.

```csharp
_log.LogInformation("Pedido {PedidoId} creado por usuario {UsuarioId}",
    request.PedidoId, currentUser.Id);
```

## Integración con ERP sistema externo crítico

**Regla crítica** (principio #13 de la Metodología IT): ninguna app accede directamente a la base de sistema externo crítico. Siempre vía API propia del equipo.

```
ERP sistema externo crítico → Warehouse API → Mi API → App
```

## Validación

- FluentValidation para commands y queries.
- DataAnnotations para DTOs simples.
- Validación en la capa Application, no en la API.

## Recursos

- [Minimal APIs](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis/)
- [MediatR](https://github.com/jbogard/MediatR)
- [EF Core](https://learn.microsoft.com/en-us/ef/core/)
- [YARP](https://microsoft.github.io/reverse-proxy/)
