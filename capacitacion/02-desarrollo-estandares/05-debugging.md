# 09 - Debugging

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Metodologia para investigar bugs efectivamente
- Herramientas y tecnicas de debugging
- Como aislar el problema
- Como escribir un buen reporte de bug

---

## Metodologia de Debugging

### 1. Reproducir el bug

Antes de anything, asegurate de poder reproducir el problema:

- [ ] Entendi los pasos exactos?
- [ ] Puedo reproducirlo consistentemente?
- [ ] Conozco el estado del sistema?

```
Pasos para reproducir:
1. Ir a pagina X
2. Hacer click en boton Y
3. Verificar error en Z
```

### 2. Aislar el problema

Reducir el scope del problema:

- [ ] El bug esta en frontend, backend o ambos?
- [ ] Esta relacionado a un componente especifico?
- [ ] Sucede en un browser especifico?

### 3. Formar una hipotesis

Basado en la evidencia, proponer una causa probable:

```
Hipotesis: El error ocurre porque el token expiro y no se renovo
```

### 4. Testear la hipotesis

```
Verificar: Revisar si el token tiene fecha de expiracion
Confirmar: Probar con un token nuevo
```

### 5. Fix y verificar

- Aplicar la correccion
- Verificar que el bug ya no ocurre
- Verificar que no se broke nada mas

---

## Tecnicas de Debugging

### Logging

```typescript
// Agregar logs relevantes
console.log('[DEBUG] Request:', { url, method, body });

// Logs condicionales en desarrollo
if (process.env.NODE_ENV === 'development') {
  console.log('Response:', data);
}

// Usar logger estructurado
logger.info('Payment processed', { orderId, amount, status: 'success' });
```

### Breakpoints

```typescript
// Breakpoint en navegador
debugger;

// Breakpoint condicional
if (orderId === 'ORD-123') {
  debugger;
}
```

### Browser DevTools

| Solapa | Para que |
|--------|----------|
| Console | Ver errores y logs |
| Network | Ver requests/responses |
| Elements | Inspeccionar DOM |
| Sources | Debugger con breakpoints |
| Application | Ver storage, cookies |

---

## Errores Comunes y Como Investigarlos

### Error de Red

```
Pasos:
1. Ver Network tab
2. Identificar request que falla
3. Revisar status code
4. Revisar request/response
5. Revisar backend logs
```

### Error de JavaScript

```
Pasos:
1. Leer el stack trace
2. Identificar linea del error
3. Revisar el contexto (variables en ese momento)
4. Buscar en el codigo la causa raiz
```

### Error de Estado

```
Pasos:
1. Revisar Redux DevTools / React DevTools
2. Identificar estado que parece incorrecto
3. Buscar donde se modifica ese estado
4. Verificar la logica de actualizacion
```

---

## Checklist de Debugging

- [ ] Puedo reproducir el bug consistentemente?
- [ ] Conozco la version exacta donde aparecio?
- [ ] Revise los logs relevantes?
- [ ] El bug es consistente o intermitente?
- [ ] Tiene relacion con datos especificos?
- [ ] Puedo reproducir en otro ambiente?

---

## Como Escribir un Buen Reporte de Bug

### Template

```
## Titulo
[Breve descripcion del problema]

## Pasos para reproducir
1. Ir a pagina X
2. Hacer click en Y
3. Ver error Z

## Resultado esperado
[Que deberia pasar]

## Resultado actual
[Que pasa realmente]

## Evidencia
- Screenshot del error
- Console log relevante
- Request/Response si aplica

## Entorno
- Browser: Chrome 120
- OS: Windows 11
- Version del sistema: v2.3.1

## Notas adicionales
[Alguna otra informacion relevante]
```

---

## Resumen

| Paso | Accion |
|------|--------|
| 1. Reproducir | Poder recrear el bug consistentemente |
| 2. Aislar | Reducir el scope del problema |
| 3. Hipotesis | Proponer una causa probable |
| 4. Testear | Verificar la hipotesis |
| 5. Fix | Aplicar y verificar |

---

## Siguiente Capitulo

Continuar con: [10-Deploy-VM-Linux](../03-despliegue/01-deploy-vm-linux.md)

## Recursos

- `reglas/debugging/AGENT.md` — guia completa
- `reglas/error-handling/AGENT.md` — manejo de errores
