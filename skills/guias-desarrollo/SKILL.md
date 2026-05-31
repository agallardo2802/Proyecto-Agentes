---
name: guias-desarrollo
description: >
  Crear guías técnicas de desarrollo para proyectos de GGSoluciones.
  Estructura obligatoria, formato Markdown, secciones requeridas y ejemplos.
  Usar cuando el usuario diga "guía", "documentar", "cómo usar", "setup", "onboarding".
---

# Guías de Desarrollo - Estándar GGSoluciones

Este skill define el formato y estructura para crear guías técnicas de desarrollo. Todas las guías deben seguir este padrão para que los desarrolladores encuentren información consistente.

## Cuándo usar este skill

- Usuario dice: "crear guía", "documentar cómo", "setup", "onboarding", "cómo usar"
- Necesitás documentar un proceso, configuración o uso de algo
- Crear documentación para nuevos desarrolladores

## Estructura obligatoria de una guía

```markdown
# Título de la Guía

## Objetivo
[Una oración: para qué sirve esta guía y qué problema resuelve]

## Prerequisites
- Requisitos previos necesarios para seguir la guía
- Siempre incluir versiones de herramientas

## Paso a paso

### 1. Primer paso
[Instrucciones claras y concretas]

### 2. Segundo paso
[Instrucciones...]
```

## Reglas de escritura

1. **Una guía = un objetivo**: No mezclar temas. Si es muy extensa, dividir en varias guías.
2. **Pasos numerados**: Siempre 1, 2, 3... sin saltos.
3. **Code blocks con lenguaje**: Usar ` ```bash`, ` ```typescript`, etc.
4. **Rutas absolutas cuando aplique**: usar una ruta de ejemplo genérica del proyecto, sin rutas reales del equipo.
5. **Evitar explicaciones largas**: Agregar notas al final si es necesario.

## Guía de setup / onboarding

Estructura para guiar a un nuevo desarrollador:

```markdown
# Guía de Setup - {Nombre del Proyecto}

## Objetivo
Configurar el entorno de desarrollo local para comenzar a trabajar en {Proyecto}.

## Requisitos previos

| Herramienta | Versión mínima | Notas |
|-------------|----------------|-------|
| .NET SDK | 8.0 | |
| Node.js | 20 LTS | |
| SQL Server | 2022 | Local o container |
| Git | 2.40+ | |

## Paso a paso

### 1. Clonar el repositorio
```bash
git clone https://github.com/agallardo2802/Proyecto-Agentes
cd {PROYECTO}
```

### 2. Configurar backend
```bash
cd backend
dotnet restore
```

**Nota**: Asegurate de tener SQL Server corriendo localmente.

### 3. Configurar frontend
```bash
cd frontend
npm install
```

### 4. Variables de entorno
Crear `.env` en `frontend/`:
```env
VITE_API_URL=http://localhost:5000
```

### 5. Ejecutar
```bash
# Backend
cd backend/src/{Proyecto}.Api
dotnet run

# Frontend (otra terminal)
cd frontend
npm run dev
```

### 6. Verificar
- Frontend: http://localhost:3000
- API: http://localhost:5000/swagger
- DB: connection string en appsettings.json

## Notas adicionales
- Credenciales de DEV: documentar usuarios de prueba sólo si el proyecto las define explícitamente y nunca publicar claves reales.
- Para más info, ver README.md del proyecto
```

## Guía de uso de una feature

```markdown
# Guía de Uso - {Nombre de la Feature}

## Objetivo
Explicar cómo usar {feature} desde la perspectiva del usuario.

## Dónde encontrarlo
- Ruta: `/ruta/a-la-feature`
- Rol requerido: {Rol}

## Cómo usar

### 1. Acceder
[Navegar a la ruta, hacer click en botón, etc.]

### 2. Completar datos
[Formulario, campos obligatorios, validaciones]

### 3. Ejecutar acción
[Boton de confirmar, acción a realizar]

### 4. Ver resultado
[Mensaje, redirección, actualización de datos]

## Casos de uso

### Caso A: Flujo normal
1. [Pasos...]
2. [Resultado esperado]

### Caso B: Con errores
1. [Pasos...]
2. [Error esperado y cómo resolver]
```

## Guía de API

```markdown
# API - {Nombre del módulo}

## Endpoints

### GET /api/{recurso}
Obtener lista de {recurso}.

**Auth**: Bearer token requerido

**Query params**:
| Param | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| page | int | No | Página (default: 1) |
| limit | int | No | Items por página (default: 20) |
| search | string | No | Búsqueda por nombre |

**Response 200**:
```json
{
  "data": [
    { "id": 1, "nombre": "Item 1" }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100
  }
}
```

### POST /api/{recurso}
Crear nuevo {recurso}.

**Body**:
```json
{
  "nombre": "Nuevo item",
  "descripcion": "Descripción"
}
```

**Response 201**:
```json
{
  "id": 2,
  "nombre": "Nuevo item",
  "createdAt": "2026-05-09T12:00:00Z"
}
```

## Códigos de error

| Código | Significado |
|--------|-------------|
| 400 | Validación fallida |
| 401 | No autenticado |
| 403 | No autorizado |
| 404 | No encontrado |
| 500 | Error interno |
```

## Guía de troubleshooting

```markdown
# Troubleshooting - {Problema común}

## Síntoma
[Descripción breve del problema]

## Causa probable
[Qué puede estar causando el problema]

## Solución

### Paso 1: Verificar
```bash
# Comando o paso de verificación
dotnet --version
```

### Paso 2: Corregir
[Pasos para solucionar]

### Paso 3: Verificar nuevamente
[Confirmar que funciona]

## Si no funciona
- Verificar logs en `{ruta de logs}`
- Contactar a {persona/canal}
```

## Checklist de calidad

- [ ] Título claro y descriptivo
- [ ] Objetivo en una oración
- [ ] Pasos numerados correctamente
- [ ] Code blocks con lenguaje apropiado
- [ ] Rutas absolutas cuando es relevante
- [ ] Screenshots si ayudan (referencia o descripción)
- [ ] Tablas para listas de parámetros/datos
- [ ] Errores documentados
- [ ] Ejemplos reales (no genéricos)
- [ ] Revisión ortográfica
