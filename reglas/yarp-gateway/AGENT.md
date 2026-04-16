---
name: yarp-gateway
description: >
  Reglas para API Gateway con YARP (Yet Another Reverse Proxy).
  Trigger: configuración de API Gateway.
license: MIT
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  stack: YARP 1.x, .NET 8
---

## Propósito

YARP es el punto único de entrada:
- Autenticación JWT
- Rate limiting
- Auditoría
- Routing a servicios

## Configuración

```csharp
// appsettings.json
{
  "ReverseProxy": {
    "Routes": {
      "portal": {
        "ClusterId": "portal-cluster",
        "Match": { "Path": "/portal/{**catch-all}" }
      },
      "api": {
        "ClusterId": "api-cluster", 
        "Match": { "Path": "/api/{**catch-all}" }
      }
    },
    "Clusters": {
      "api-cluster": {
        "Destinations": {
          "api1": { "Address": "http://api:8080" }
        }
      }
    }
  }
}
```

## REGLA: JWT Required

Todo request al API cluster requiere JWT válido.

```csharp
// Program.cs
app.UseAuthentication();
app.UseAuthorization();
```

## Rate Limiting

```csharp
services.AddRateLimiter(options =>
{
    options.GlobalLimiter = PartitionedRateLimiter.GetIpHttpLimiter(HttpContext);
    options.AddPolicy("api", context =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: context.User.Identity?.Name ?? context.Request.Headers.Host,
            factory: partition => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 100,
                Window = TimeSpan.FromMinutes(1),
                QueueProcessingOrder = QueueProcessingOrder.OldestFirst
            }));
});
```

## Auditoría

Todo request se loggea:
```csharp
app.Use(async (context, next) =>
{
    _logger.LogInformation("Request {Method} {Path} from {IP}",
        context.Request.Method, context.Request.Path, context.Connection.RemoteIpAddress);
    await next();
});
```

## Errores a Evitar

1. **NUNCA exponer servicios directamente** → siempre por YARP
2. **NUNCA deshabilitar auth** → siempre JWT
3. **NUNCA sin rate limiting** → DDoS risk

## Recursos

- [YARP](https://microsoft.github.io/reverse-proxy/)