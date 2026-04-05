---
name: onboarding
description: >
  Setup del entorno local para nuevos integrantes del equipo.
  Trigger: cuando un developer nuevo se une o hay que configurar el entorno desde cero.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
  adapt:
    - Reemplazar {REPO} con la URL real del repositorio
    - Completar variables de entorno con las del proyecto
    - Ajustar el comando de dev server según el stack
---

## Inyección automática

Esta regla se carga automáticamente con:
- **Solo se carga bajo demanda** — no es automática en ningún agente
- Se carga cuando: nuevo developer se incorpora o se configura entorno desde cero

## Objetivo

Reducir el tiempo de ramping de un developer nuevo a menos de un día.

## Reglas

1. **Leer el README antes de preguntar** — si algo falta, actualizarlo
2. **Nunca commitear `.env`** — copiar desde `.env.example`, el real va en `.gitignore`
3. **Versión de Node fija** — usar `.nvmrc` o `package.json#engines`
4. **Instalar dependencias antes de correr** — `npm install` primero
5. **Primer PR = cambio trivial** — validar que el pipeline funciona
6. **Preguntar antes de instalar librerías nuevas** — no agregar dependencias sin aprobación

## Checklist de setup inicial

- [ ] Clonar el repositorio con SSH
- [ ] Instalar la versión correcta de Node (`nvm use`)
- [ ] Copiar `.env.example` → `.env` y completar variables
- [ ] Ejecutar `npm install`
- [ ] Ejecutar `npm run dev` — verificar que levanta sin errores
- [ ] Ejecutar `npm test` — todos los tests en verde
- [ ] Leer la carpeta de gobernanza completa
- [ ] Revisar los agentes de `pr`, `git-avanzado` y `code-review`
- [ ] Hacer el primer commit trivial y abrir un PR de prueba

## Primeros pasos

```bash
git clone git@github.com:{REPO}.git
cd {nombre-repo}
nvm use
cp .env.example .env
# → completar .env con valores del equipo
npm install
npm run dev
npm test
```

## Variables de entorno — estructura mínima esperada

```bash
# .env.example — commitear esto, no el .env real
NODE_ENV=development
API_BASE_URL=http://localhost:3000
# → agregar las variables reales del proyecto
```
