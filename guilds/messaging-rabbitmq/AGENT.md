---
name: messaging-rabbitmq
description: >
  Guild para implementación de colas asíncronas con RabbitMQ.
  Trigger: procesos asíncronos, workers, messaging.
license: MIT
metadata:
  author: aleja
  version: "1.0"
  stack: RabbitMQ 3.12+, .NET 8
  proyecto: El Cuatro
---

## Propósito

Todo proceso que no necesita respuesta inmediata va por RabbitMQ.
El objetivo es UI nunca espera por operaciones costosas.

##REGLA: Procesos que van a cola

| Proceso | Tipo | Por qué |
|---------|------|---------|
| Pagos | async | Puede tomar minutos |
| Aprovisionamiento | async | Puede fallar, reintentar |
| Notificaciones | async | No bloquea UI |
| Reportes | async | Costoso |
| Sync con ERP | async | Lento |

## Arquitectura

```
├── Producer (API) → Encola job → Retorna 202 Accepted
├── Queue (RabbitMQ) → Detiene mensajes
└── Consumer (Worker) → Procesa → Actualiza estado
```

## Productor (.NET)

```csharp
public interface IPublisher
{
    Task PublishAsync<T>(T message, CancellationToken ct = default);
}

// Encola, no procesa
public class CreatePaymentHandler : IRequestHandler<CreatePaymentCommand, Result>
{
    private readonly IPublisher _publisher;

    public async Task Handle(CreatePaymentCommand request, CancellationToken ct)
    {
        var job = new PaymentProcessingJob
        {
            PedidoId = request.PedidoId,
            Amount = request.Amount,
            CreatedAt = DateTime.UtcNow
        };

        await _publisher.PublishAsync(job, ct);
    }
}
```

## Consumidor (Worker)

```csharp
public class PaymentWorker : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            var message = await _consumer.ConsumeAsync<PaymentProcessingJob>(stoppingToken);

            try
            {
                await _paymentService.ProcessAsync(message);
                await _consumer.AckAsync(message);
            }
            catch (Exception ex)
            {
                await _consumer.NackAsync(message, requeue: true);
                _logger.LogError(ex, "Error procesando pago {PedidoId}", message.PedidoId);
            }
        }
    }
}
```

## Exchanges y Queues

| Exchange | Type | Queue | Routing Key |
|----------|------|-------|------------|
| payments | direct | payments.queue | payment.process |
| provisioning | direct | provisioning.queue | provisioning.create |
| notifications | fanout | notifications.queue | * |

## Retry Policy

- Retry automático: 3 intentos con exponential backoff
- Después de 3 fallos: → Dead Letter Queue

```csharp
await _channel.QueueDeclareAsync(
    queue: "payments.queue",
    durable: true,
    arguments: new Dictionary<string, object?>
    {
        ["x-dead-letter-exchange"] = "payments.dlx"
    });
```

## Errores a Evitar

1. **NUNCA procesar en el handler** → solo encolar
2. **NUNCA retornar 200** → retornar 202 Accepted
3. **NUNCA borrar job procesado** → marcar como completado
4. **NUNCA ignorar reintentos** → configurar DLQ

## Monitoring

- Queue depth alerts
- Processing time alerts
- Dead letter queue alerts

## Recursos

- [RabbitMQ .NET Client](https://www.rabbitmq.com/dotnet.html)
- [MassTransit](https://masstransit.io/) (optional abstraction)