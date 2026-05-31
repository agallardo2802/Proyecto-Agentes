---
name: guild-sql-server-2022
description: >
  Guild especialista SQL Server 2022. Define y valida estándares GGS para modelado,
  naming, GUIDs, índices, constraints, migrations, seguridad, performance y operación
  en bases de datos SQL Server 2022.
  Trigger: cuando el agente dev o DBA trabaja con SQL Server 2022, T-SQL, EF Core,
  ADO.NET, migrations, índices, stored procedures, views o queries críticas.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: guild
  adapt:
    - Ajustar excepciones por proyecto solo con ADR o decisión documentada
---

# Guild SQL Server 2022

Un guild NO ejecuta tareas: valida que el trabajo cumpla el estándar. Si una regla no se cumple, el PR no está listo. Punto. La base de datos es parte del producto, no un detalle de infraestructura.

## Cuándo inyectar este guild

Inyectar JUNTO a `equipo/desarrollo/dev-ggs/` o `equipo/datos/dba/` cuando la Task/Bug toque:

- SQL Server 2022.
- Entity Framework Core sobre SQL Server.
- ADO.NET o Dapper.
- T-SQL, stored procedures, views, functions o triggers.
- Migrations o scripts de schema/data.
- Índices, constraints, FKs, PKs o performance de queries.

## Estándar GGS obligatorio

| Categoría | Regla |
|-----------|-------|
| Versión objetivo | SQL Server 2022 |
| Naming | PascalCase para tablas/columnas de dominio |
| PK | `Id UNIQUEIDENTIFIER NOT NULL` |
| FK | `{Entidad}Id UNIQUEIDENTIFIER NOT NULL/NULL según regla` |
| Índices | `IX_{Tabla}_{Columnas}` con tabla/columnas en PascalCase |
| Índices únicos | `UX_{Tabla}_{Columnas}` |
| Constraints | Siempre nombradas explícitamente |
| Migrations | Versionadas, revisables y con rollback/estrategia |
| Seguridad | Sin SQL dinámico concatenado, sin `sa`, sin secretos |
| Performance | Sin `SELECT *`, revisar SARGability, planes e índices |

## Naming detallado

| Objeto | Patrón | Ejemplo válido | Ejemplo inválido |
|--------|--------|----------------|------------------|
| Tabla | PascalCase | `Cliente` | `clientes`, `tbl_cliente` |
| Columna | PascalCase | `FechaCreacion` | `fecha_creacion` |
| PK columna | `Id` | `Id` | `ClienteId` como PK local |
| FK columna | `{Entidad}Id` | `ClienteId` | `id_cliente` |
| PK constraint | `PK_{Tabla}` | `PK_Cliente` | `PK_clientes` |
| FK constraint | `FK_{Tabla}_{Referencia}` | `FK_OrdenPago_Cliente` | `fk_orden_cliente` |
| Índice | `IX_{Tabla}_{Columnas}` | `IX_Cliente_Nombre` | `ix_cliente_nombre` |
| Índice único | `UX_{Tabla}_{Columnas}` | `UX_Cliente_Cuit` | `UQ_cuit` |
| Default | `DF_{Tabla}_{Columna}` | `DF_Cliente_Activo` | default autogenerado |
| Check | `CK_{Tabla}_{Regla}` | `CK_Cliente_CuitFormato` | check autogenerado |

## GUIDs como identificadores

Reglas:

- Toda tabla de dominio nueva usa `Id UNIQUEIDENTIFIER NOT NULL`.
- La PK se llama `PK_{Tabla}`.
- Las FKs son `UNIQUEIDENTIFIER` y se nombran `{Entidad}Id`.
- Preferir GUID secuencial cuando el volumen de escritura sea relevante.
- Si el GUID lo genera SQL Server, evaluar `NEWSEQUENTIALID()` para reducir fragmentación.
- Si el GUID lo genera aplicación, documentar estrategia y consistencia con el ORM.
- No usar GUID como clustered key en tablas de alta escritura sin revisar fragmentación, fill factor y patrón de inserción.

Ejemplo base:

```sql
CREATE TABLE Cliente (
    Id UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Cliente_Id DEFAULT NEWSEQUENTIALID(),
    Nombre NVARCHAR(200) NOT NULL,
    Cuit NVARCHAR(20) NOT NULL,
    Activo BIT NOT NULL CONSTRAINT DF_Cliente_Activo DEFAULT (1),
    FechaCreacion DATETIME2(3) NOT NULL CONSTRAINT DF_Cliente_FechaCreacion DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_Cliente PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT UX_Cliente_Cuit UNIQUE (Cuit)
);

CREATE INDEX IX_Cliente_Nombre ON Cliente (Nombre);
```

## Índices y performance

- Toda FK usada en joins debe tener índice nonclustered.
- Todo índice debe responder a una consulta real o caso de uso documentado.
- No crear índices por intuición: validar filtros, joins, ordenamientos y cardinalidad.
- Evitar funciones sobre columnas en `WHERE`: rompen SARGability.
- Evitar `LIKE '%texto'` en búsquedas críticas sin estrategia específica.
- Usar includes solo cuando reduzcan lookups medibles.
- Revisar execution plan en queries críticas.
- Medir impacto de escritura antes de agregar múltiples índices.

## Tipos de datos

- Texto: `NVARCHAR(n)` con tamaño definido; evitar `NVARCHAR(MAX)` salvo necesidad real.
- Fechas: `DATETIME2(3)` para precisión consistente; guardar UTC cuando aplique.
- Dinero: `DECIMAL(18,2)` o precisión definida por negocio; no `FLOAT`.
- Booleanos: `BIT NOT NULL` con default cuando corresponda.
- Estados: preferir catálogo/tabla o constraint clara; no strings libres sin control.

## Seguridad

- Prohibido concatenar SQL con input externo.
- SQL dinámico solo con `sp_executesql` y parámetros.
- Aplicaciones no usan `sa` ni usuarios dueños de schema.
- Permisos mínimos necesarios.
- Datos sensibles documentados y protegidos según clasificación.
- No guardar secretos en tablas sin estrategia de cifrado/gestión de secretos.

## Migrations

Toda migration debe responder:

- Qué cambia.
- Por qué cambia.
- Qué datos existentes afecta.
- Si bloquea escrituras/lecturas.
- Cómo se revierte o cuál es la estrategia de recuperación.
- Cómo se valida después de aplicar.

No se aprueba:

- Cambio destructivo sin plan.
- Script sin transacción cuando corresponde.
- Constraint autogenerada sin nombre.
- Índice sin justificación.
- Cambio de tipo de columna sin análisis de datos existentes.

## Checklist de validación del guild

- [ ] SQL Server 2022 es la versión objetivo.
- [ ] Tablas/columnas usan PascalCase.
- [ ] Nuevas tablas de dominio usan `Id UNIQUEIDENTIFIER`.
- [ ] FKs usan `{Entidad}Id UNIQUEIDENTIFIER`.
- [ ] PK/FK/DF/CK/IX/UX tienen nombres explícitos.
- [ ] Índices usan primera letra en mayúscula en tabla/columnas: `IX_Cliente_Nombre`.
- [ ] Toda FK de join frecuente tiene índice.
- [ ] No hay `SELECT *` productivo.
- [ ] No hay SQL dinámico concatenado.
- [ ] Queries críticas son SARGable.
- [ ] Migration versionada con rollback/estrategia.
- [ ] GGS-TRACE presente si el cambio fue hecho por agente.
