---
name: git-avanzado
description: >
  Manejo avanzado de Git para el trabajo diario del equipo.
  Trigger: cuando hay conflictos, se necesita deshacer cambios, o reescribir historia.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

## Inyección automática

Esta regla se carga automáticamente con:
- `equipo/desarrollo/dev/` — siempre (para flujo de ramas y commits)
- `equipo/devops/pr/` — siempre (para conflictos y resolución)
- `reglas/onboarding/` — se complementa con esta para flujo de trabajo

## Objetivo

Cubrir los comandos que resuelven el 90% de los problemas reales: conflictos, deshacer errores, mantener ramas limpias y entender qué pasó.

## Reglas

1. **Nunca trabajar directo en `main`/`master`** — siempre crear rama
2. **Commits atómicos** — un commit = un cambio lógico
3. **Antes de pushear** — `git pull --rebase origin main` para actualizar sin merge commits
4. **Rebase interactivo para limpiar** — `git rebase -i HEAD~N` antes del PR
5. **`git stash` para cambiar de contexto** — `git stash` guarda el trabajo; `git stash pop` lo restaura
6. **Resolver conflictos con calma** — leer ambas versiones; nunca aceptar sin leer
7. **`git bisect` para bugs regresivos** — encuentra el commit culpable en minutos
8. **`git reflog` para recuperar trabajo perdido** — si hiciste `reset --hard` por error
9. **Nunca `--force-push` en ramas compartidas** — solo en tu rama personal

## Comandos de rescate frecuentes

```bash
# Deshacer el último commit sin perder cambios
git reset --soft HEAD~1

# Ver qué cambió en un commit específico
git show abc1234

# Buscar en qué commit se introdujo un texto
git log -S "textoABuscar" --oneline

# Recuperar rama o commit "perdido"
git reflog
git checkout -b rama-recuperada HEAD@{2}

# Limpiar ramas locales ya mergeadas
git branch --merged main | grep -v main | xargs git branch -d
```

## Flujo diario correcto

```bash
git checkout main && git pull
git checkout -b feat/TICKET-XXX-descripcion
# ... trabajo ...
git add -p                           # agregar cambios selectivamente
git commit -m "feat(scope): descripcion"
git pull --rebase origin main        # actualizar antes de pushear
git push origin feat/TICKET-XXX-descripcion
```
