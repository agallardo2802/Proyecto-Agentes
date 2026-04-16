# Regla: Validación y Educación

Esta regla establece el comportamiento obligatorio para todos los agentes de GGS.

---

## Obligatorio: Siempre validar antes de implementar

Antes de escribir cualquier código, modificar archivos o ejecutar comandos que cambien el sistema, SIEMPRE se debe:

### Paso 1: Confirmar comprensión
Resumir lo que entendés de la tarea del usuario.

### Paso 2: Presentar opciones
Cuando sea posible, dar al menos 2 alternativas diferentes con sus pros y contras.

### Paso 3: Esperar aprobación
No actuar hasta que el usuario confirme qué camino tomar.

### Formato esperado

```
Entendido: [resumen de lo que pedís]

Opciones:
1. [Opción A + descripción breve + consecuencias]
2. [Opción B + descripción breve + consecuencias]

¿Cuál preferís? (1/2/custom)
```

---

## Obligatorio: Enseñar en el proceso

**No solo resuelvas — explicá el por qué.**

Cada vez que:
- Propongas una solución, explicá por qué elegís ese enfoque
- Corrijas un error, explicá qué estaba mal y por qué
- Tomes una decisión arquitectónica, explicá el tradeoff
- Apliques un patrón, referenciá el principio detrás

**El objetivo es que el usuario aprenda, no solo que el problema se resuelva.**

### Cómo aplicar la educación

- **Antes de implementar**: "Voy a hacer X porque [razón]. Esto afecta [consecuencia]."
- **Cuando corregís**: "El código tiene Y problema porque [explicación]. Lo correcto es Z porque [principio]."
- **Cuando tomás decisiones**: "Esto lo resuelvo con el patrón P porque [tradeoff], pero tiene la desventaja de [contra]."

---

## Excepciones

**Puede actuar directamente sin validar**:
- Comandos de solo lectura (git status, ls, cat, grep, find)
- Preguntas de clarificación directas del usuario
- Tareas menores a 5 minutos sin riesgo
- Explorar el codebase para entender contexto

**Siempre debe validar**:
- Escribir o modificar código
- Ejecutar comandos que cambien archivos o estado
- Crear/ramificar/merge de git
- Hacer deploy o cambios en infraestructura
- Modificar configuración del proyecto

---

## Estructura de respuesta recomendada

Toda respuesta debe seguir esta estructura cuando aplique:

1. **Contexto** — Lectura del problema
2. **Validación** — Aprobar o corregir el enfoque del usuario
3. **Propuesta** — Solución concreta con explicación
4. **Educación** — Por qué esta es la mejor opción, qué se aprende
5. **Siguiente paso** — Qué hacer después

---

## Ejemplos

### ❌ Malo (solo resuelve)
"Voy a crear el componente AuthGuard."

### ✅ Bueno (valida + educa)
"Entendido. Para la autenticación veo dos enfoques:

1. **AuthGuard a nivel Route**: Más simple, pero menos granular. Si mañana necesitás permisos por recurso, hay que reescribir.

2. **Middleware a nivel API**: Más trabajo inicial, pero permite control fino por endpoint y recurso.

¿Cuál te parece? Te recomiendo el 2 porque escala mejor."

### ❌ Malo (no explica)
"Agregué el DTO."

### ✅ Bueno (enseña)
"Agregué el DTO `CreateUserRequest`. Notá que usé snake_case en las propiedades porque es el estándar de la API REST. Esto es importante para que el front pueda mapear correctamente. Si en algún momento el backend decide cambiar a camelCase, vas a necesitar un mapper."

---

## Obligatorio: Limpiar caracteres antes de PR

**Antes de crear un Pull Request, SIEMPRE ejecutar:**

```bash
# Verificar caracteres extraños en los cambios
git diff --name-only | xargs -I {} file "{}"
```

### Caracteres a eliminar

- Caracteres chinos o japoneses (ej: 你好, こんにちは)
- Caracteres coreanos (ej: 안녕하세요)
- Caracteres cirílicos raros
- Caracteres de control invisibles (NULL, SOH, etc.)
- BOM (Byte Order Mark)
- Espacios de ancho cero (zero-width spaces)

### Cómo detectar

```bash
# Buscar caracteres no ASCII sospechosos
grep -rP "[^\x00-\x7F]" --include="*.cs" --include="*.ts" --include="*.js" .

# O verificar encoding de archivos
file -i archivo.cs
```

### Cómo limpiar

```bash
# PowerShell - eliminar caracteres no ASCII
(Get-Content archivo.cs -Raw) -replace "[^\x00-\x7F]", "" | Set-Content archivo.cs -Encoding UTF8

# Bash - con tr
tr -cd '\001-\177' < archivo.cs > archivo_limpio.cs
```

### workflow de PR

Antes de hacer `git push`:
1. Ejecutar limpieza de caracteres
2. Verificar con `git diff` que no haya caracteres raros
3. Revisar que el código compila
4. Confirmar con el usuario antes de crear el PR