# Guide de Uso - Equipo El Cuatro

> **Nota importante**: Este documento es el índice principal. Cada sección referencia los agentes específicos que contain la información detallada. Leé primero este documento completo, luego segí los enlaces para cada tarea.

---

## 1. Instalación - Herramientas del Desarrollador

### 1.1 Software Base Obligatorio

| Herramienta | Para qué sirve | Enlace |
|------------|--------------|-------|
| **Git** | Control de versiones | [Descargar](https://git-scm.com/) |
| **Docker Desktop** | Contenedores locales | [Descargar](https://www.docker.com/) |
| **VS Code** | Editor principal | [Descargar](https://code.visualstudio.com/) |

### 1.2 IA para Desarrollo (Elegir una)

| Opción | Notas | Setup |
|--------|-------|-------|
| **OpenCode** (recomendado) | Basado en Claude, integra con tus agentes | `[Guía de Instalación]` |
| **Gentle.ai** | Específico para SDD | `[Guía de Instalación]` |
| **Cursor** | Alternativa con IA | [Descargar](https://cursor.sh/) |

### 1.3 Runtime y SDKs

| Herramienta | install link | Notas |
|------------|--------------|-------|
| **.NET 8 SDK** | [Descargar](https://dotnet.microsoft.com/download) | Solo LTS |
| **Node.js 20 LTS** | [Descargar](https://nodejs.org/) | npm incluido |
| **Python 3.12** | [Descargar](https://www.python.org/) | Opcional |

### 1.4 Configuración de Seguridad

⚠️ **NUNCA usar credenciales productivas en local**

```
# Archivos que NUNCA deben subirse a git:
├── .env
├── appsettings.*.json (si tiene passwords)
├── *.pfx (certificados)
└── *.key (keys privadas)
```

**Reglas:**
- Usar siempre suffix `_test` o `_dev` para ambientes de desarrollo
- Keys de API pedirle a Alejandro o el líder técnico
- Nunca exponer datos de clientes en prompts

---

## 2. Conexión a la VM de Desarrollo

### 2.1 Servicios Disponibles en la VM

| Servicio | Host:Port | Propósito |
|----------|----------|----------|
| **SQL Server** | `10.x.x.x:1433` | Base de datos desarrollo |
| **Calipso WS** | `10.x.x.x:5000` | Web Services ERP |
| **RabbitMQ** | `10.x.x.x:5672` | Colas asíncronas |
| **API Gateway** | `10.x.x.x:8080` | YARP entrada APIs |
| **Grafana** | `10.x.x.x:3000` | Métricas y logs |

### 2.2 Configurar Connection Strings

En `appsettings.Development.json`:
```json
{
  "ConnectionStrings": {
    "Default": "Server=10.x.x.x,1433;Database=ElCuatro_Dev;User Id=dev_user;Password=PEDIR_A_LIDER;TrustServerCertificate=true"
  },
  "Calipso": {
    "BaseUrl": "http://10.x.x.x:5000"
  },
  "RabbitMQ": {
    "Host": "10.x.x.x"
  }
}
```

### 2.3 Credenciales

**Solicitar a Alejandro:**
- Usuario SQL dev
- Usuario RabbitMQ
- Keys de API de desarrollo

⚠️ **REGLA**: Nada de credenciales productivas. Si necesitás datos para prueba, pedirlos específicamente para el ambiente de test.

---

## 3. Flujo de Trabajo - SDD + TDD

### 3.1 Pasos del Desarrollo

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│ Análisis │ → │ Diseño  │ → │ TDD     │ → │  PR     │
└─────────┘    └─────────┘    └─────────┘    └─────────┘
      ↓            ↓            ↓            ↓
  Spec escrita  Design en ADR  Test pasa     Review
```

### 3.2 Cuándo Usar SDD (Spec-Driven Development)

Usa SDD para cualquier tarea que:
- ✅ Implica nuevo feature (no solo fix pequeño)
- ✅ Puede afectar a otros módulos
- ✅ Requiere integración con Calipso o servicios externos
- ✅ Necesita más de 1 día de trabajo

**No uses SDD para:**
- ❌ Fix pequeños de bugs aislados
- ❌ Cambios visuales menores en UI

### 3.3 Cómo Iniciar una Tarea

**Paso 1: Clonar repositorio**
```bash
git clone https://github.com/el-cuatro/mi-proyecto.git
cd mi-proyecto
```

**Paso 2: Crear rama**
```bash
git checkout -b feature/mi-nueva-feature
# o para fix:
git checkout -b fix/descripcion-corta
```

**Paso 3: Ejecutar con IA**
```
> quiero agregar autenticación JWT al sistema
> usar sdd-elcuatro para esta tarea
```

La IA va a:
- Generar la especificación
- Crear los tests primero (TDD)
- Implementar el código
- Darte instrucciones para PR

---

## 4. Agentes Disponibles - Cuándo Usar Cuál

### 4.1 Por Tarea

| Si necesitas... | Usar este agente |
|----------------|----------------|
| **Entender código existente** | `equipo/desarrollo/dev` + `guilds/*` |
| **Nueva feature completa** | `sdd-elcuatro` + `equipo/desarrollo/dev` |
| **Testing** | `equipo/testing/funcional` o `equipo/testing/unitario` |
| **Revisar código** | `reglas/code-review` (siempre) |
| **Debuguear error** | `reglas/debugging` + `equipo/desarrollo/dev` |
| **Seguridad** | `reglas/seguridad-web` |
| **Documentación** | `reglas/documentacion` |

### 4.2 Por Tecnología

| Stack | Agents a cargar |
|-------|----------------|
| Backend .NET 8 | `guilds/backend-dotnet-8` |
| Frontend React | `guilds/frontend-react-nextjs` |
| Mobile RN | `guilds/mobile-react-native` |
| Colas async | `guilds/messaging-rabbitmq` |
| Observabilidad | `guilds/observabilidad-grafana` |
| API Gateway | `reglas/yarp-gateway` |

---

## 5. Seguridad - Reglas No Negociables

### 5.1 Desarrollo

- 🔐 **NUNCA** credenciales en código fuente
- 🔐 **NUNCA** datos reales de clientes en pruebas
- 🔐 **SIEMPRE** separación DEV/PROD
- 🔐 **SIEMPRE** code review obligatorio

### 5.2 Con IA

- 🚫 **NUNCA** compartir passwords o api keys
- 🚫 **NUNCA** datos de clientes reales en prompts
- ✅ **SIEMPRE** revisar lo que la IA genera
- ✅ **SIEMPRE** tests pasan antes de commit

### 5.3 Respuesta a "¿Puedo usar datos de producción para probar?"

**NO, nunca.** Pedir datos de prueba sanitizados al líder técnico.

---

## 6. Cómo Subir un Pull Request

### 6.1 Pasos

**1. Asegurate de que los tests pasan:**
```bash
dotnet test          # Backend
# o
npm test           # Frontend
```

**2. Commitear cambios:**
```bash
git add .
git commit -m "feat: descripción corta de cambios"
```

**3. Push a tu rama:**
```bash
git push origin feature/mi-nueva-feature
```

**4. Crear PR en GitHub:**

Titulo del PR:
```
feat/fix: [descripción corta]
```

Cuerpo del PR:
```
## Descripción
[Qué hace este cambio]

## Tipo de cambio
- [ ] Feature
- [ ] Fix
- [ ] Refactor

## Testing
[Cómo probaste]

## Notas adicionales
[Cualquier cosa relevante]
```

### 6.2 Checklist Antes del PR

- [ ] Tests pasan localmente
- [ ] Code review hecho (auto o par)
- [ ] No hay credenciales expuestas
- [ ] Naming conventions respetadas
- [ ] Documentación actualizada (si aplica)

---

## 7. Dónde Buscar Información

| Qué necesitás | Dónde está |
|--------------|------------|
| Stack tecnológico completo | `Stack Tecnológico/Arquitectura Tecnológica 2026.html` |
| Patrones .NET 8 | `guilds/backend-dotnet-8/AGENT.md` |
| Patrones React | `guilds/frontend-react-nextjs/AGENT.md` |
| Reglas de código | `reglas/code-review/AGENT.md` |
| Reglas de seguridad | `reglas/seguridad-web/AGENT.md` |
| SDD completo | `equipo/sdd-ggsoluciones/SKILL.md` |
| Todos los agentes | `.atl/skill-registry.md` |

---

## 8. Help! Tengo Problemas

### 8.1 Errores Comunes

| Error | Solución |
|-------|----------|
| "No puedo conectar a SQL" | Verificar VPN conntected a la VM |
| "Docker no corre" | Docker Desktop arrancado? |
| "dotNet command not found" | Install .NET 8 SDK, no solo runtime |
| "No encuentro la config" | appsettings.Development.json |

### 8.2 Cómo Pedir Help

1. **Consultar este documento** (Ctrl+F)
2. **Revisar agentes relacionados** en skill-registry
3. **Preguntar en el canal #desarrollo**
4. **Escalar a Alejandro** si es sesuatu de arquitectura

---

## 9. Glosario

| Término | Significado |
|---------|-----------|
| **SDD** | Specification-Driven Development |
| **TDD** | Test-Driven Development |
| **CQRS** | Command Query Responsibility Segregation |
| **ADR** | Architectural Decision Record |
| **PR** | Pull Request |
| **DLQ** | Dead Letter Queue |
| **YARP** | Yet Another Reverse Proxy (API Gateway) |

---

## 10. Changelog

| Fecha | Cambio | Autor |
|-------|--------|-------|
| 2026-04-13 | Versión inicial | Alejandro |