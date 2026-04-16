---
name: observabilidad-grafana
description: >
  Guild para observabilidad con Grafana, Loki y Prometheus.
  Trigger: logging, métricas, alertas.
license: MIT
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  stack: Grafana, Loki, Prometheus
---

## Stack

| Tool | Propósito |
|------|----------|
| Grafana | Dashboards y alertas |
| Loki | Logs agregados |
| Prometheus | Métricas |

##REGLA: Logs Estructurados

```csharp
_logger.LogInformation("Pedido {PedidoId} creado por {UsuarioId}",
    request.PedidoId, currentUser.Id);
// NO: _logger.LogInformation($"Pedido {pedido.Id} creado");
```

## Métricas Obligatorias

- Request duration ( histogram )
- Error rate ( counter )
- Active connections ( gauge )
- Queue depth ( gauge )

## Dashboards

- API Gateway: requests, latency, errors
- Workers: jobs processed, failed, retry
- Database: connections, query time

## Alertas

| Alerta | Condición |
|-------|-----------|
| High Error Rate | errors > 5% en 5min |
| Slow Response | p95 > 2s |
| Queue Backup | depth > 1000 |
| Worker Down | no heartbeat 5min |

## Recursos

- [Grafana](https://grafana.com/)
- [Loki](https://grafana.com/oss/loki)
- [Serilog](https://serilog.net/)