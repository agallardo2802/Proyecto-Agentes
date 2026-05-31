# 08 - Git Avanzado

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Comandos avanzados para el dia a dia
- Como manejar branches efectivamente
- Cuando usar rebase vs merge
- Como usar bisect para debuggear

---

## Workflow Basico

```
1. git fetch
2. git checkout -b feature/ticket-123
3. work + commit
4. git push -u origin feature/ticket-123
5. crear PR
6. review + merge
```

---

## Comandos Esenciales

### Rebase - Mantener historial limpio

```bash
# Rebase de tu branch sobre master
git fetch
git rebase origin/master

# Si hay conflictos, resolver y luego
git rebase --continue

# Abortar si algo sale mal
git rebase --abort
```

**Cuando usar**: Para mantener un historial lineal y limpio.

### Cherry-pick - Traer commits especificos

```bash
# Traer un commit especifico a tu branch
git cherry-pick abc1234

# Traer varios commits
git cherry-pick abc1234 def5678
```

**Cuando usar**: Para aplicar un fix especifico sin hacer merge completo.

### Stash - Guardar cambios temporales

```bash
# Guardar cambios sin commit
git stash

# Guardar con mensaje
git stash save "WIP: working on auth fix"

# Ver stashes disponibles
git stash list

# Recuperar el ultimo stash
git stash pop

# Recuperar un stash especifico
git stash apply stash@{2}
```

---

## Rebase Interactivo

```bash
# Editar ultimos 3 commits
git rebase -i HEAD~3
```

Opciones disponibles:
- `pick` — usar el commit tal cual
- `reword` — cambiar el mensaje
- `edit` — modificar el commit
- `squash` — combinar con el anterior
- `drop` — eliminar el commit

---

## Buscar Que Commit Rompio Algo

### Bisect - Busqueda binaria

```bash
# Iniciar bisect
git bisect start

# Marcar donde esta el bug (HEAD)
git bisect bad

# Marcar donde trabajaba bien
git bisect good v1.0.0

# Git checkout un commit en el medio
# Testea manualmente
# Marcar como good o bad
git bisect good  # o git bisect bad

# Continuar hasta encontrar el commit
# Git muestra: "commit abc123 is the first bad commit"

# Terminar
git bisect reset
```

---

## Comandos de Emergencia

### Deshacer el ultimo commit (sin perder cambios)

```bash
git reset --soft HEAD~1
```

### Deshacer cambios en archivo especifico

```bash
git checkout -- archivo.txt
```

### Ver que commiteaste hace 5 commits

```bash
git reset --hard HEAD~5
```

### Recuperar un branch borrado

```bash
git reflog
# buscar el commit donde estaba el branch
git checkout -b nombre-branch hash-encontrado
```

---

## Tags - Versionado

```bash
# Crear tag
git tag v1.0.0

# Push tag
git push origin v1.0.0

# Push todos los tags
git push --tags

# Ver tags
git tag -l
```

---

## Comandos Utiles del Dia a Dia

```bash
# Ver branches locales y remotos
git branch -a

# Ver ultimo commit de cada branch
git branch -v

# Ver cambios staged y unstaged
git status

# Ver diff staged
git diff --staged

# Ver diff con otro branch
git diff master..mi-branch

# Ver log bonito
git log --oneline --graph --decorate

# Ver quien wrote que linea
git blame archivo.txt
```

---

## Resumen

| Comando | Uso |
|---------|-----|
| `git rebase` | Mantener historial lineal |
| `git cherry-pick` | Traer commits especificos |
| `git stash` | Guardar cambios temporales |
| `git bisect` | Encontrar que rompio algo |
| `git reflog` | Recuperar cualquier cosa |

---

## Siguiente Capitulo

Continuar con: [05-Debugging](./05-debugging.md)

## Recursos

- `reglas/git-avanzado/AGENT.md` — referencia completa
- Pro tip: crear aliases en ~/.gitconfig
