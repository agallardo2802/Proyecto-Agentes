# 15 - Onboarding

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Como configurar el entorno de desarrollo
- Acceso a las herramientas del equipo
- Estructura del proyecto
- Primeros pasos como nuevo desarrollador

---

## Herramientas Requeridas

### Obligatorias

| Herramienta | Version | Para que |
|-------------|---------|----------|
| Git | 2.40+ | Control de versiones |
| Node.js | 20 LTS | Runtime |
| VS Code | Latest | Editor |
| Docker | Latest | Contenedores |

### Segun el Proyecto

| Herramienta | Proyecto |
|-------------|----------|
| .NET 8 SDK | Backend .NET |
| Python 3.11 | Scripts/Backend Python |
| SQL Server | Base de datos |
| Azure CLI | Cloud |

---

## Configuracion Inicial

### 1. Git

```bash
# Configurar identidad
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@ggsoluciones.com"

# Configurar editor
git config --global core.editor code

# Configurar default branch
git config --global init.defaultBranch master
```

### 2. SSH Keys

```bash
# Generar clave
ssh-keygen -t ed25519 -C "tu.email@ggsoluciones.com"

# Agregar al agente
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copiar clave publica
cat ~/.ssh/id_ed25519.pub
# Agregar en GitHub/GitLab/Azure DevOps
```

### 3. VS Code Extensions

```json
// extensions.json recomendado
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-vscode.vscode-typescript-next",
    "ms-azuretools.vscode-docker"
  ]
}
```

---

## Acceso a Herramientas

| Herramienta | Quien da acceso |
|-------------|-----------------|
| GitHub | Tech Lead |
| Azure DevOps | IT Ops |
| VPN | IT Ops |
| AWS/Azure | Cloud Admin |
| Slack/Teams | HR |

---

## Estructura del Proyecto

```
mi-proyecto/
├── src/                    # Codigo fuente
│   ├── features/           # Por feature
│   ├── shared/             # Codigo compartido
│   └── index.ts            # Entry point
├── tests/                  # Tests
├── docs/                   # Documentacion
├── scripts/                # Scripts de build/deploy
├── .env.example            # Variables de entorno ejemplo
├── docker-compose.yml      # Servicios locales
└── README.md               # Documentacion
```

---

## Primeros Pasos

### 1. Clonar el repo

```bash
git clone git@github.com:ggsoluciones/mi-proyecto.git
cd mi-proyecto
```

### 2. Instalar dependencias

```bash
npm install   # o dotnet restore, pip install, etc.
```

### 3. Configurar entorno

```bash
# Copiar template de variables
cp .env.example .env

# Editar con tus valores
code .env
```

### 4. Levantar servicios

```bash
docker-compose up -d   # o npm run dev
```

### 5. Verificar que funciona

```bash
# Verificar tests
npm test

# Verificar build
npm run build

# Verificar app en browser
open http://localhost:3000
```

---

## Conventions del Equipo

| Area | Convention |
|------|------------|
| Branching | feature/AB-{id}-descripcion |
| Commits | tipo(scope): descripcion |
| Naming | camelCase (JS), PascalCase (C#) |
| Testing | {nombre}.test.ts |

---

## Checklist de Onboarding

- [ ] Acceso a GitHub/GitLab/Azure
- [ ] Acceso al Board (Jira/Azure Boards)
- [ ] Acceso al Slack/Teams del equipo
- [ ] VPN configurada (si aplica)
- [ ] Clave SSH configurada
- [ ] IDE configurado
- [ ] Proyecto clonado y corriendo
- [ ] Primer task asignada

---

## Donde Pedir Ayuda

1. **Tech Lead** — Arquitectura, decisiones tecnicas
2. **PM** — Prioridades, alcance
3. **Documentacion** — README, docs/, wiki
4. **Slack/Teams** — Canales del equipo
5. **Compañero de equipo** — Pair programming

---

## Resumen

| Paso | Accion |
|------|--------|
| 1 | Instalar herramientas |
| 2 | Configurar Git y SSH |
| 3 | Obtener accesos |
| 4 | Clonar proyecto |
| 5 | Levantar entorno |
| 6 | Tomar primer task |

---

## Fin de la Guia

Felicitaciones por completar la Guia de Capacitacion GGS!

Ahora estas listo para:
- Trabajar con el sistema de agentes GGS
- Aplicar SDD y TDD en tus tareas
- Hacer code reviews efectivos
- Desplegar a produccion
- Contribuir al equipo

**Siguiente paso**: Tomar una tarea del board y comenzar a trabajar!

## Recursos

- `reglas/onboarding/AGENT.md` — guia completa
- `README.md` — documentacion del proyecto
- `CONTRIBUTING.md` — como contribuir
