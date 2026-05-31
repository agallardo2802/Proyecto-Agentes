# 06 - Code Review

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Como dar feedback efectivo en code review
- Como recibir feedback de forma constructiva
- Los aspectos clave a revisar
- El proceso de review en el equipo GGS

---

## Por que Importa el Code Review

El code review es la ultima linea de defensa antes de que el codigo entre al sistema. No es solo encontrar bugs, sino:

- **Compartir conocimiento** entre el equipo
- **Estandarizar** patrones y convenciones
- **Detectar** problemas antes de que lleguen a produccion
- **Mejorar** la calidad del codigo colectivamente

---

## Como Dar Feedback Efectivo

### Principios

1. **Critica el codigo, no la persona**
   - ❌ "Este codigo esta mal"
   - ✅ "Este pattern podria simplificarse con..."

2. **Sugiere, no ordene**
   - ❌ "Cambia esto as"
   - ✅ "Que te parece usar X aqui? Yo lo haria asi..."

3. **Explica el "por que"**
   - ❌ "No uses var"
   - ✅ "Usar const es mejor aqui porque evita reasignaciones accidentales"

4. **Sé especifico**
   - ❌ "Esto no esta bien"
   - ✅ "Linea 23: el null check falta en el caso de arrays vacios"

### Tips de redaccion

| Tipo de comentario | Ejemplo |
|--------------------|--------|
| **Sugerencia** | "Podriamos usar map() aqui en lugar de forEach" |
| **Pregunta** | "Por que elegiste este approach en lugar de X?" |
| **Requiere cambio** | "Este secret esta hardcodeado — debe venir de env" |
| **Aprendizaje** | "Interesante pattern, no lo conocia. De donde lo sacaste?" |

---

## Como Recibir Feedback

1. **Escuchar sin defensividad** — No justificar, solo entender
2. **Agradecer** — El reviewer esta aportando tiempo
3. **Aclarar** — Si no entendes, preguntar
4. **Aplicar** — Si tiene sentido, hacer el cambio
5. **Discutir** — Si no estas de acuerdo, explicar tu razonamiento

> Recorda: el objetivo es mejorar el codigo, no demostrar que estas en lo correcto.

---

## Que Revisar

### Funcionalidad

- [ ] El codigo hace lo que dicen los AC?
- [ ] Edge cases considerados?
- [ ] Error handling apropiados?

### Legibilidad

- [ ] Nombres claros?
- [ ] Funciones pequenas y enfocadas?
- [ ] Complejidad ciclomatica aceptable?

### Estandares

- [ ] Naming conventions respetadas?
- [ ] Estructura de archivos consistente?
- [ ] Tests incluidos?

### Seguridad

- [ ] Secrets en variables de entorno?
- [ ] Input validado?
- [ ] Sin XSS, SQL injection?

### Performance

- [ ] Sin N+1 queries?
- [ ] Lazy loading donde corresponde?
- [ ] Caching apropiado?

---

## Proceso de Review en GGS

### Flujo

```
1. Developer crea branch y trabaja
2. Commit con mensaje convencional
3. Abre PR vinculando al ticket (AB#123)
4. Code review por otro miembro
5. Feedback aplicado o discutido
6. Approval + merge a master
```

### Requirements para Merge

- [ ] Al menos 1 approval
- [ ] Todos los tests pasando
- [ ] Sin conflicts con master
- [ ] Vinculado a ticket

---

## Template de Review Comment

```markdown
## Resumen
[Comentario general — opcional]

##Cambios requeridos
- **Linea 45**: El array puede ser null, agregar guard clause
- **Linea 78**: Este secret debe estar en .env, no hardcoded

## Sugerencias (opcional)
- **Linea 12**: Podria usar optional chaining (?.) aqui
- **Linea 90**: Considerar extraer a constante

## Preguntas
- **Linea 34**: Por que elegiste este approach en lugar de usar el helper?
```

---

## Resumen

| Aspecto | Punto clave |
|---------|-------------|
| Feedback | Critica el codigo, no la persona |
| Tono | Sugiere, no ordenes |
| Especificidad | Se preciso en lo que decis |
| Recepcion | Escuchar sin defensividad |
| Que revisar | Funcionalidad, legibilidad, estandares, seguridad |

---

## Siguiente Capitulo

Continuar con: [07-Naming-Conventions](./03-naming-conventions.md)

## Recursos

- `reglas/code-review/AGENT.md` — guia completa
- `reglas/seguridad-web/AGENT.md` — seguridad
