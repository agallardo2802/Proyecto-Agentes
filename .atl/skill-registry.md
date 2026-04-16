# Skill Registry - GGS Agentes

**Version**: 3.0
**Updated**: 2026-04-15
**Author**: Alejandro Gallardo
**Stack**: Genérico (.NET, React, React Native, RabbitMQ, Grafana)

---

## Equipo (32 agentes)

| Agente | Trigger | Descripcion |
|--------|---------|------------|
| `equipo/desarrollo/dev` | Tareas con AC, bugs, refactor | Dev Senior con TDD |
| `equipo/desarrollo` | Desarrollo general | Equipo de desarrollo |
| `equipo/testing/unitario` | Testing unitario | QA Unitario |
| `equipo/testing/funcional` | Testing funcional, flujos E2E | QA Funcional |
| `equipo/testing/apis` | Testing de APIs | QA APIs |
| `equipo/testing/integracion` | Testing de integracion | QA Integracion |
| `equipo/testing/ui` | Testing UI | QA UI |
| `equipo/testing/ux` | Testing UX | UX Testing |
| `equipo/testing` | Testing general | Equipo de testing |
| `equipo/devops/cicd` | CI/CD | Pipeline CI/CD |
| `equipo/devops/cicd/github-actions` | GitHub Actions | GitHub Actions |
| `equipo/devops/cicd/azure-devops` | Azure DevOps | Azure Pipelines |
| `equipo/devops/pr` | Pull requests | PR Review |
| `equipo/devops/pr/github` | GitHub PRs | GitHub PRs |
| `equipo/devops/pr/bitbucket` | Bitbucket PRs | Bitbucket PRs |
| `equipo/devops/board` | Gestion de board | Project Board |
| `equipo/devops/board/jira` | Jira | Jira |
| `equipo/devops/board/azure-boards` | Azure Boards | Azure Boards |
| `equipo/devops` | DevOps general | Equipo DevOps |
| `equipo/datos` | Datos general | Equipo de datos |
| `equipo/datos/data-engineering` | Data Engineering | Data Engineering |
| `equipo/datos/bi-reporting` | BI Reporting | BI Reporting |
| `equipo/datos/analista-datos` | Analista de datos | AnalistaDatos |
| `equipo/producto/arquitecto` | Arquitectura de producto | Product Architect |
| `equipo/producto/analista` | Analisis de producto | Analista PM |
| `equipo/producto/pm` | Project Management | PM |
| `equipo/producto` | Producto general | Equipo producto |
| `equipo/diseno/ui` | Diseno UI | UI Design |
| `equipo/diseno/ux` | Diseno UX | UX Design |
| `equipo/diseno` | Diseno general | Equipo diseno |

---

## Reglas (12 reglas)

| Regla | Trigger | Descripcion |
|--------|---------|------------|
| `reglas/code-review` | PR review, feedback | Code review efectivo |
| `reglas/seguridad-web` | Validacion seguridad | Web security |
| `reglas/git-avanzado` | Workflow git | Git avanzado |
| `reglas/debugging` | Debugging | Debugging efectivo |
| `reglas/error-handling` | Manejo errores | Error handling |
| `reglas/documentacion` | Docs | Documentacion |
| `reglas/naming-conventions` | Nombres | Naming conventions |
| `reglas/onboarding` | Nuevo miembro | Onboarding |
| `reglas/css-arquitectura` | CSS | CSS Architecture |
| `reglas/javascript-async` | JS async | JavaScript async |
| `reglas/performance-web` | Performance | Web performance |
| `reglas/yarp-gateway` | API Gateway | Configuracion YARP |

---

## Guilds (18 guilds)

| Guild | Trigger | Descripcion |
|-------|---------|------------|
| `guilds/backend-dotnet-8` | .NET 8 proyectos | .NET 8 LTS, CQRS, MediatR |
| `guilds/backend-dotnet` | .NET projects | .NET general |
| `guilds/frontend-react-nextjs` | React/Next.js | React 18+, Next.js 14, Tailwind |
| `guilds/frontend-angular` | Angular projects | Angular |
| `guilds/mobile-react-native` | Apps移动 | React Native + Expo |
| `guilds/messaging-rabbitmq` | Colas asincronas | RabbitMQ, workers |
| `guilds/observabilidad-grafana` | Logging, metricas | Grafana, Loki, Prometheus |
| `guilds/arquitectura` | Arquitectura | Architecture patterns |
| `guilds/datos` | Datos | Guild de datos |
| `guilds/datos/modelado-datos` | Data modeling | Data modeling |
| `guilds/datos/data-governance` | Data governance | Data governance |
| `guilds/datos/powerbi` | Power BI | Power BI |
| `guilds/datos/kpis-negocio` | KPIs | Business KPIs |
| `guilds/data-sqlserver` | SQL Server | SQL Server |
| `guilds/integraciones` | Integraciones | Integrations |
| `guilds/AGENT.md` | Guilds general | Guilds overview |

---

## Skills SDD (9 fases)

| Skill | Trigger | Descripcion |
|-------|---------|------------|
| `sdd-ggs` | "sdd", "mi sdd", "sdd completo" | SDD completo con agentes GGS |
| `sdd-init` | `/sdd-init` | Initialize SDD |
| `sdd-explore` | `/sdd-explore` | Explore |
| `sdd-propose` | `/sdd-propose` | Propose |
| `sdd-spec` | `/sdd-spec` | Spec |
| `sdd-design` | `/sdd-design` | Design |
| `sdd-tasks` | `/sdd-tasks` | Tasks |
| `sdd-apply` | `/sdd-apply` | Apply |
| `sdd-verify` | `/sdd-verify` | Verify |
| `sdd-archive` | `/sdd-archive` | Archive |

---

## Stack Genérico

| Capa | Tecnologia | Guild asociado |
|------|-----------|--------------|
| Backend | .NET 8 | `guilds/backend-dotnet-8` |
| Frontend | React + Next.js | `guilds/frontend-react-nextjs` |
| Mobile | React Native | `guilds/mobile-react-native` |
| Mensajeria | RabbitMQ | `guilds/messaging-rabbitmq` |
| API Gateway | YARP | `reglas/yarp-gateway` |
| Observabilidad | Grafana + Loki | `guilds/observabilidad-grafana` |
| Datos | SQL Server | `guilds/data-sqlserver` |

---

## Inyeccion Automatica por Contexto

| Contexto | Reglas/Agentes inyectados |
|---------|--------------------------|
| Backend .NET 8 | `guilds/backend-dotnet-8` + `reglas/yarp-gateway` |
| Frontend React | `guilds/frontend-react-nextjs` |
| Mobile | `guilds/mobile-react-native` |
| Colas async | `guilds/messaging-rabbitmq` |
| Observabilidad | `guilds/observabilidad-grafana` |
| Tareas con AC | `equipo/desarrollo/dev` + `reglas/code-review` |
| Bugs | `equipo/desarrollo/dev` + `reglas/debugging` |
| PR review | `equipo/devops/pr/*` + `reglas/code-review` |
| Testing | `equipo/testing/*` + `reglas/error-handling` |
| Seguridad | `reglas/seguridad-web` |

---

## Metodologia

**SDD + TDD**

1. Analisis → Spec
2. Diseno → Design
3. implementacion → TDD (red → green → refactor)
4. PR Review obligatorio
5. Deploy

---

## Notas

- Todos los agentes tienen `{PROYECTO}` como placeholder
- Los agentes soportan adaptacion via la seccion `adapt:` en frontmatter
- **REGLA**: Ningun agente evoluciona sin PR aprobado por el equipo
- Stack configurable según las necesidades del proyecto