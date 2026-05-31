# GGS Quick Reference

**Una página con todo lo que necesitás día a día.**

---

## Activos agentes (en chat)

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
@equipo/desarrollo/dev-ggs           → Implementar con TDD
@equipo/testing/unitario         → tests unitarios
@equipo/devops/pr/github         → Revisar PR
@reglas/code-review              → Code review
@reglas/debugging               → Investigar bug
```

---

##Workflows pre-armados

###Administración y finanzas
```
Métricas financieras  → finanzas-metricas
Asientos/balances     → finanzas-contabilidad
Cashflow/tesorería    → finanzas-cashflow
Reporte ejecutivo     → reportes-ggs + skill financiera
```

Prompts útiles:

```
Analizá este cashflow semanal. Moneda ARS. Marcá riesgos P1/P2/P3 y no inventes datos faltantes.
Revisá este asiento contra el plan de cuentas. Debe balancear Debe/Haber y quedar pendiente de validación.
Armá KPIs de cobranzas vencidas por aging, fuente y fecha de corte.
```

###UAT y feedback de usuarios
```
Feedback formal      → feedback-uat
Manual de uso        → portal-user-manual
Canal operativo      → Slack #feedback-sites
```

Prompt útil:

```
Agregá feedback UAT al portal: botón "Dejar feedback" en vistas principales, modal formal con nombre de contacto, endpoint de feedback del proyecto y documentación en el manual.
```

###Nueva feature (completo)
```
1. @equipo/producto/pm → crear historia "module de pagos"
2. @equipo/producto/analista → escribir AC
3. @equipo/desarrollo/dev-ggs → implementar con TDD
4. @equipo/devops/pr/github → PR
```

###Fix bug
```
1. @reglas/debugging → investigar causa raíz
2. @equipo/testing/unitario → test que reproduce
3. @equipo/desarrollo/dev-ggs → fix mínimo
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

##Quick config

En `config/proyectos/{mi-proyecto}.config.md`:

```yaml
board: jira             # o azure-boards
vcs: github            # o bitbucket, repo-privado
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

- equipo/desarrollo/dev-ggs → Implementación
- equipo/producto/arquitecto → Arquitectura
- equipo/seguridad/appsec → Seguridad

**Más**: consultá `equipo/`, `guilds/`, `reglas/` para todos los agentes disponibles.
