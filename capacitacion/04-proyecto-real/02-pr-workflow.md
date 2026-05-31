# 13 - PR Workflow

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- El flujo de trabajo con Pull Requests
- Como crear un PR efectivo
- Como hacer y recibir code review
- Standards para merge

---

## Flujo de Trabajo

```
1. Trabajar en feature branch
2. Commit con mensaje convencional
3. Push y crear PR
4. Code review
5. Aplicar feedback
6. Approval + merge
7. Cerrar ticket
```

---

## Crear una Branch

```bash
# Actualizar master
git fetch
git checkout master
git pull origin master

# Crear branch desde el ticket
git checkout -b feature/AB-123-descripcion-corta
# O para bugs
git checkout -b bug/AB-456-fix-login
```

### Convenciones de Branch

| Tipo | Formato | Ejemplo |
|------|---------|---------|
| Feature | `feature/AB-{id}-descripcion` | `feature/AB-123-agregar-login` |
| Bug | `bug/AB-{id}-descripcion` | `bug/AB-456-fix-logout` |
| Hotfix | `hotfix/AB-{id}-descripcion` | `hotfix-789-urgente` |

---

## Commits

### Mensajes Convencionales

```
tipo(scope): descripcion corta

Cuerpo del mensaje (opcional)

Footer (opcional - issues relacionados)
```

### Tipos de Commit

| Tipo | Descripcion |
|------|-------------|
| feat | Nueva funcionalidad |
| fix | Bug fix |
| docs | Documentacion |
| style | Formato (sin cambio de logica) |
| refactor | Refactoring |
| test | Tests |
| chore | Mantenimiento |

### Ejemplos

```bash
git commit -m "feat(auth): agregar login con JWT"

git commit -m "fix(cart): corregir calculo de total con descuento
- El descuento no se aplicaba cuando era 0
- Agregar test para este caso
Closes AB-123"

git commit -m "docs(readme): actualizar guia de instalacion"
```

---

## Crear un Pull Request

### Titulo

```
[AB-123] Agregar autenticacion JWT al portal
```

### Descripcion Template

```markdown
## Resumen
Breve descripcion del cambio

## Cambios realizados
- Agregado JwtService
- Implementado middleware de auth
- Agregados tests unitarios

## Testing
- [ ] Tests unitarios pasando
- [ ] Tests de integracion pasando
- [ ] Verificado manualmente en local

## Screenshots (si aplica)
[Agregar screenshots aqui]

## Related Issues
AB-123

## Reviewers
@usuario1 @usuario2
```

---

## Code Review

### Tips para el Autor

1. **PR pequeno** — Mejor varios PRs pequenos que uno gigante
2. **Self-review** — Revisa tu propio PR antes de pedir review
3. **Descripcion clara** — Explica que hiciste y por que
4. **Responde rapido** — No dejar comentarios sin atender

### Tips para el Reviewer

1. **Critica constructiva** — Enfocarse en el codigo, no en la persona
2. **Ser especifico** — Decir exactamente que cambiar y donde
3. **Explicar el por que** — No solo "cambia esto", sino "esto porque..."
4. **Aprobar si es menor** — No bloquear por detalles menores

---

## Checklist Antes de Merge

Para el autor:
- [ ] Tests pasando en CI
- [ ] No hay conflictos con master
- [ ] Vinculado al ticket
- [ ] Descripcion completa

Para el reviewer:
- [ ] Code review hecho
- [ ] Tests revisados
- [ ] Seguridad revisada
- [ ] Aprobado

---

## Standards GGS

- **Todo PR vinculado a un ticket** — Usar AB# o PROJ-123
- **Al menos 1 approval** — No hacer self-merge
- **Branch protegida** — No hacer push directo a master
- **Status checks pasando** — CI en verde
- **Delete branch despues de merge** — Mantener limpio

---

## Resumen

| Paso | Accion |
|------|--------|
| Branch | Crear desde ticket |
| Commit | Mensaje convencional |
| PR | Descripcion completa |
| Review | Feedback construtivo |
| Merge | Solo con approval |

---

## Siguiente Capitulo

Continuar con: [03-Seguridad-Web](./03-seguridad-web.md)

## Recursos

- `equipo/devops/pr/` — guia de PRs
- `reglas/code-review/AGENT.md` — code review
