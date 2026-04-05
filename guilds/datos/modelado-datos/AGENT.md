---
name: guild-modelado-datos
description: >
  Guild de estándares para diseño de esquemas de datos relacionales y dimensionales.
  Trigger: cuando el equipo de datos diseña o revisa modelos de base de datos, migraciones de esquema o estructuras de Data Warehouse.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar herramientas según el stack de datos del proyecto
---

# Guild Modelado de Datos

Estándares para diseño de esquemas de datos relacionales y dimensionales. Aplica a todo modelo nuevo, migración o refactor de esquema revisado por el equipo.

## Cuándo inyectar este guild

Inyectar JUNTO a `equipo/datos/data-engineering/` cuando el trabajo involucra:
- Diseño de nuevas tablas o entidades
- Migraciones de esquema
- Definición de Data Warehouse o modelo analítico

## Cuándo NO inyectar este guild

| Situación | Guild correcto |
|-----------|---------------|
| El trabajo es solo queries de lectura | `guilds/data-sqlserver` |
| El trabajo es solo dashboards | `guilds/datos/powerbi` |
| El trabajo es solo definición de KPIs | `guilds/datos/kpis-negocio` |
| El trabajo es desarrollo de código normal | No aplica — guild de datos |

## Dependencias

Este guild asume que también puede inyectarse con:
- `guilds/data-sqlserver` — para modelado relacional
- `guilds/datos/powerbi` — para el modelo tabular
- `guilds/datos/data-governance` — para políticas de calidad

---

## Normalización

- 3NF como mínimo en tablas OLTP. La desnormalización en OLTP requiere justificación documentada.
- Desnormalización aceptada en OLAP/Data Warehouse — pero debe documentarse el motivo (performance de lectura, simplificación de consultas analíticas).
- Sin redundancia de datos sin motivo explícito.
- Atributos atómicos: un campo = un dato. Sin `nombre_apellido` concatenados, sin listas en una columna, sin JSON embebido en VARCHAR salvo justificación de diseño.

## Naming conventions

| Elemento | Convención | Ejemplo |
|---|---|---|
| Tablas | PascalCase, singular | `Cliente`, `Pedido`, `LineaPedido` |
| Columnas | snake_case | `fecha_creacion`, `id_cliente` |
| PK | `id_{tabla}` o `{tabla}_id` | `id_cliente`, `cliente_id` |
| FK | `id_{tablaReferenciada}` | `id_cliente`, `id_pedido` |
| Índices | `IX_{tabla}_{columnas}` | `IX_Pedido_fecha_creacion` |
| Unique constraints | `UQ_{tabla}_{columnas}` | `UQ_Cliente_email` |
| Check constraints | `CK_{tabla}_{regla}` | `CK_Pedido_estado` |

## Tipos de datos

- Usar el tipo más específico y pequeño que cubra el dominio del dato.
- `NVARCHAR` solo cuando hay Unicode real confirmado. Para texto en español estándar, `VARCHAR`.
- `DATETIME2` en lugar de `DATETIME` para mayor precisión y rango.
- `DECIMAL(p, s)` con precisión explícita para valores monetarios — nunca `FLOAT` ni `REAL` para dinero.
- Sin `VARCHAR(MAX)` ni `NVARCHAR(MAX)` sin justificación documentada. El tamaño máximo debe estar fundamentado.

## Integridad

- FK explícita para toda relación entre tablas — sin relaciones implícitas por convención de nombre.
- `NOT NULL` por defecto. `NULL` solo cuando el dato puede genuinamente no existir en el dominio del negocio.
- `CHECK` constraints para columnas con dominio pequeño y conocido (estados, tipos, categorías fijas).
- Columnas de auditoría obligatorias en todas las tablas de negocio:
  - `fecha_creacion` — timestamp de inserción
  - `fecha_modificacion` — timestamp de última actualización
  - `creado_por` — usuario o proceso que generó el registro

## Versionado de esquema

- Todo cambio de esquema debe tener un script de migración versionado. Sin `ALTER TABLE` manual en producción.
- Retrocompatibilidad en migraciones: agregar columnas nullable antes de convertirlas a NOT NULL. El proceso es: agregar nullable → poblar valores → agregar constraint NOT NULL.
- Scripts de rollback documentados para cambios destructivos.

---

## Checklist de validación

- [ ] 3NF en tablas OLTP (o desnormalización documentada)
- [ ] Naming conventions respetadas: tablas PascalCase singular, columnas snake_case
- [ ] PKs y FKs con naming estándar
- [ ] Sin FLOAT para dinero (usar DECIMAL con precisión explícita)
- [ ] Sin VARCHAR(MAX) sin justificación documentada
- [ ] NOT NULL por defecto en columnas de negocio
- [ ] Columnas de auditoría presentes (fecha_creacion, fecha_modificacion, creado_por)
- [ ] Migrations versionadas para todo cambio de esquema
