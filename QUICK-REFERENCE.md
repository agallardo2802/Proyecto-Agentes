# GGS Quick Reference

**Una página con todo lo que necesitás día a día.**

---

##激活 agentes (en chat)

| Tarea | Comando |
|------|---------|
| SDD completo | `sdd` o `/sdd-init` |
| Solo exploración | `explorá el código de auth` |
| Solo análisis | `sdd plan` |
| Revisión adversarial | `judgment day` o `juzgar este PR` |

---

##Atajos por área

```
@equipo/producto/pm              → Crear épica/historia
@equipo/producto/analista        → Escribir AC en Gherkin
@equipo/producto/arquitecto      → Diseñar arquitectura
@equipo/desarrollo/dev           → Implementar con TDD
@equipo/testing/unitario         → tests unitarios
@equipo/devops/pr/github         → Revisar PR
@reglas/code-review              → Code review
@reglas/debugging               → Investigar bug
```

---

##Workflows pre-armados

###Nueva feature (completo)
```
1. @equipo/producto/pm → crear historia "module de pagos"
2. @equipo/producto/analista → escribir AC
3. @equipo/desarrollo/dev → implementar con TDD
4. @equipo/devops/pr/github → PR
```

###Fix bug
```
1. @reglas/debugging → investigar causa raíz
2. @equipo/testing/unitario → test que reproduce
3. @equipo/desarrollo/dev → fix mínimo
4. @equipo/devops/pr/github → PR vinculado al bug
```

###Code review rápido
```
1. @reglas/code-review
2. @reglas/seguridad-web
3. @reglas/performance-web
```

###Onboarding dev nuevo
```
1. @reglas/onboarding → setup entorno
2. @reglas/git-avanzado → comandos diario
3. @equipo/devops/pr → cómo contribuir
```

---

##Teclas útiles (TUI)

| Tecla | Acción |
|-----|--------|
| `↑↓` | Navegar |
| `Enter` | Seleccionar |
| `Espacio` | Toggle |
| `c` | Confirmar |
| `q` | Salir |
| `Esc` | Volver |

---

##Quick config

En `config/proyectos/{mi-proyecto}.config.md`:

```yaml
board: jira             # o azure-boards
vcs: github            # o bitbucket, azure-repos
cicd: github-actions  # o azure-devops
stack: dotnet-8
db: sql-server-2022
```

---

##Errores comunes

|Error|Solución|
|-----|--------|
|"No detecté stack"| Corré `/sdd-init`|
|"No sé qué agente"| Describí la tarea y el agent la detecta|
|"Tarea muy chica"| El agent la hace directo, no usa SDD|
|"Necesitás dar más contexto"| Pedile clarificación antes|

---

##Contactos

- equipo/desarrollo/dev → Implementación
- equipo/producto/arquitecto → Arquitectura  
- equipo/seguridad/appsec → Seguridad

**Más**: consultá `equipo/`, `guilds/`, `reglas/` para todos los agentes disponibles.