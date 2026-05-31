# Capacitación - GGS Agentes

Esta guía es el punto de entrada para nuevos usuarios de la distribución privada de GGS Agentes.

## Recorrido recomendado

1. Leer `capacitacion/00-indice.md` para el mapa completo.
2. Instalar con `scripts/install.ps1 -DryRun` o `scripts/install.sh --dry-run` para validar sin cambios.
3. Usar uno de los tres agentes visibles de OpenCode:
   - `Orquestador`: flujo SDD completo.
   - `Planificador`: análisis, diseño y tablero; sin desarrollo.
   - `Revisor`: revisión adversarial.
4. Para control manual de fases, usar los skills SDD individuales (`sdd-init`, `sdd-explore`, `sdd-spec`, `sdd-design`, `sdd-tasks`, `sdd-apply`, `sdd-verify`, `sdd-archive`). No existe un agente visible separado de Skills.

## Materiales

- `capacitacion/01-fundamentos/` — SDD, TDD, OpenSpec y Gherkin.
- `capacitacion/02-desarrollo-estandares/` — TDD práctico, code review, naming y debugging.
- `capacitacion/03-despliegue/` — despliegue y CI/CD.
- `capacitacion/04-proyecto-real/` — tablero, PR workflow, seguridad y onboarding.

## Regla de cierre

No declarar SDD, PR o merge como completo hasta sincronizar el tablero con evidencia real: work items, PR, commits, build, deploy/verificación y estado final.
