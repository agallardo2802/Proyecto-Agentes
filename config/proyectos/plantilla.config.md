# Template: config/proyectos/{MI-PROYECTO}.config.md

> Copiar este archivo y personalizar según tu proyecto.
> Este archivo le dice a los agentes qué herramientas usary cómo trabajar.

## Proyecto

```yaml
nombre: MI-PROYECTO
repo: https://github.com/mi-org/mi-proyecto.git
stack: dotnet-8  # dotnet-8, nodejs, python, go, etc.
```

## Herramientas

```yaml
board:
  herramienta: jira  # jira, azure-boards
  proyecto_key: PROJ
  url: https://miempresa.atlassian.net

vcs:
  herramienta: github  # github, bitbucket, azure-repos
  url: https://github.com/mi-org/mi-proyecto
  default_branch: main

cicd:
  herramienta: github-actions  # github-actions, azure-devops
  ambientes:
    - nombre: dev
      url: https://dev.miproyecto.com
    - nombre: staging  
      url: https://staging.miproyecto.com
    - nombre: prod
      url: https://miproyecto.com
```

## Database

```yaml
db:
  tipo: sql-server-2022  # sql-server-2022, postgresql, mysql
  server: db.miempresa.com
  nombre: MiProyectoDb
```

## APIs Externas

```yaml
apis_externas:
  - nombre: Stripe
    url: https://api.stripe.com
    secret_env: STRIPE_SECRET_KEY
  - nombre: SendGrid
    url: https://api.sendgrid.com
    secret_env: SENDGRID_API_KEY
```

## Convenciones del equipo

```yaml
convenciones:
  ramas:
    main: main
    feature: feature/{ticket}-{descripcion-corta}
    bugfix: fix/{ticket}-{descripcion-corta}
  commits:
    formato: "{tipo}({area}): {descripcion}"
    tipos:
      - feat
      - fix
      - docs
      - refactor
      - test
      - chore
  nomenclatura:
    clases: PascalCase
    metodos: PascalCase
    variables: camelCase
    constantes: UPPER_SNAKE_CASE
    archivos: kebab-case.js
```

## Personas del equipo

```yaml
equipo:
  - nombre: Juan Perez
    slack: "@juan"
    rol: Tech Lead
  - nombre: Maria Gomez
    slack: "@maria"
    rol: Product Owner
```

## Guilds activos (según stack)

```yaml
guilds:
  - guilds/backend-dotnet      # Solo si es .NET
  - guilds/frontend-react-nextjs  # Solo si es React
  - guilds/data-sqlserver     # Solo si es SQL Server
```

---

## Cómo usar

1. **Copiar**: `cp config/proyectos/ejemplo.config.md config/proyectos/mi-proyecto.config.md`
2. **Editar**: Reemplazar los valores con los de tu proyecto
3. **使用时**: Los agentes lo cargan automáticamente desde `/sdd-init`

```bash
> /sdd-init
> necesito agregar autenticación JWT
```

---

## Ejemplo completo

```yaml
nombre: PortalClientes
repo: https://github.com/miempresa/portal-clientes.git
stack: dotnet-8

board:
  herramienta: jira
  proyecto_key: PORTAL
  url: https://miempresa.atlassian.net

vcs:
  herramienta: github
  url: https://github.com/miempresa/portal-clientes
  default_branch: main

cicd:
  herramienta: github-actions
  ambientes:
    - nombre: dev
      url: https://dev.portal.miempresa.com
    - nombre: staging
      url: https://staging.portal.miempresa.com
    - nombre: prod
      url: https://portal.miempresa.com

db:
  tipo: sql-server-2022
  server: db.miempresa.com
  nombre: PortalDb

apis_externas:
  - nombre: Stripe
    url: https://api.stripe.com
    secret_env: STRIPE_SECRET_KEY

convenciones:
  ramas:
    main: main
    feature: feature/{AB}-{descripcion}
    bugfix: fix/{AB}-{descripcion}
  commits:
    formato: "{tipo}({area}): {descripcion}"
  nomenclatura:
    clases: PascalCase
    metodos: PascalCase
    variables: camelCase

guilds:
  - guilds/backend-dotnet
  - guilds/data-sqlserver
```