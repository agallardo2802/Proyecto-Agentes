---
name: deploy-linux-vm
description: >
  Guia de deployment a VM Linux via linea de comando para el equipo GGSoluciones.
  Trigger: cuando se necesita desplegar a un servidor Linux, ya sea via SSH, scripts, o CI/CD.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: base
---

# Deploy en VM Linux — Guia para el Equipo GGSoluciones

## Pre-requisitos

```bash
# Verificar conexion SSH
ssh -v usuario@servidor.example.com

# Verificar que rsync esta disponible (para transferencias eficientes)
rsync --version

# Verificar que tienes las claves SSH configuradas
ls ~/.ssh/id_rsa.pub
```

## Conexion SSH

```bash
# Conexion basica
ssh usuario@servidor.example.com

# Conexion con clave especifica
ssh -i ~/.ssh/mi-clave-deploy usuario@servidor.example.com

# Conexion con puerto personalizado
ssh -p 2222 usuario@servidor.example.com
```

### Configuracion SSH (recomendado)

Crear `~/.ssh/config`:

```ssh-config
Host vm-prod
    HostName servidor.ggsoluciones.com
    User deploy
    Port 22
    IdentityFile ~/.ssh/mi-clave-deploy
    ForwardAgent yes

Host vm-staging
    HostName staging.ggsoluciones.com
    User deploy
    Port 22
    IdentityFile ~/.ssh/mi-clave-deploy
```

Uso: `ssh vm-prod`

## Transferencia de archivos

### rsync (recomendado — solo transfiere cambios)

```bash
# Sincronizar carpeta local a remoto
rsync -avz --delete ./dist/ deploy@servidor.ggsoluciones.com:/var/www/app/

# Excluir archivos
rsync -avz --exclude='node_modules' --exclude='.env' ./ deploy@servidor.ggsoluciones.com:/var/www/app/

# Modo seco (ver que se copiaria sin hacerlo)
rsync -avzn ./dist/ deploy@servidor.ggsoluciones.com:/var/www/app/
```

### scp (simple pero menos eficiente)

```bash
# Copiar archivo
scp archivo.zip deploy@servidor.ggsoluciones.com:/tmp/

# Copiar carpeta completa
scp -r ./build/* deploy@servidor.ggsoluciones.com:/var/www/app/
```

## Workflow basico de deploy

### Paso a paso manual

```bash
# 1. Conectar por SSH
ssh deploy@servidor.ggsoluciones.com

# 2. Ir al directorio de la aplicacion
cd /var/www/mi-app

# 3. Bajar el servicio (si es systemd)
sudo systemctl stop mi-app

# 4. Respaldar version actual
cp -r ./current ./backup-$(date +%Y%m%d-%H%M%S)

# 5. Actualizar archivos (desde tu maquina, en otra terminal)
rsync -avz --exclude='.env' ./dist/ deploy@servidor.ggsoluciones.com:/var/www/mi-app/

# 6. Reiniciar servicio
sudo systemctl start mi-app

# 7. Verificar que esta corriendo
sudo systemctl status mi-app

# 8. Revisar logs
journalctl -u mi-app -f
```

### Script de deploy completo

Crear `deploy.sh` (NO commitear a git con secrets):

```bash
#!/bin/bash
# deploy.sh — usar solo localmente, nunca commitear

set -e

ENV=$1              # prod | staging
APP_DIR="/var/www/mi-app"
BACKUP_DIR="/var/www/backups"

if [ "$ENV" != "prod" ] && [ "$ENV" != "staging" ]; then
  echo "Uso: ./deploy.sh prod|staging"
  exit 1
fi

echo "==> Haciendo backup..."
BACKUP_NAME="backup-$(date +%Y%m%d-%H%M%S)"
ssh deploy@servidor.ggsoluciones.com "cp -r $APP_DIR $BACKUP_DIR/$BACKUP_NAME"

echo "==> Deteniendo servicio..."
ssh deploy@servidor.ggsoluciones.com "sudo systemctl stop mi-app"

echo "==> Sincronizando archivos..."
rsync -avz --exclude='node_modules' --exclude='.env' --exclude='.git' \
  ./dist/ \
  deploy@servidor.ggsoluciones.com:$APP_DIR/

echo "==> Reiniciando servicio..."
ssh deploy@servidor.ggsoluciones.com "sudo systemctl start mi-app"

echo "==> Verificando..."
sleep 3
ssh deploy@servidor.ggsoluciones.com "sudo systemctl status mi-app --no-pager"

echo "==> Deploy a $ENV completado!"
```

Uso:
```bash
chmod +x deploy.sh
./deploy.sh staging   # Probar primero en staging
./deploy.sh prod
```

## Servicios con systemd

### Crear servicio (como root)

```bash
sudo nano /etc/systemd/system/mi-app.service
```

```ini
[Unit]
Description=Mi App GGSoluciones
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/var/www/mi-app
ExecStart=/usr/bin/node /var/www/mi-app/server.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable mi-app
sudo systemctl start mi-app
```

### Comandos utiles

```bash
sudo systemctl status mi-app         # Ver estado
sudo systemctl restart mi-app       # Reiniciar
sudo systemctl stop mi-app          # Detener
sudo journalctl -u mi-app -f        # Ver logs en vivo
sudo journalctl -u mi-app --since "1 hour ago"  # Logs ultima hora
```

## Nginx como reverse proxy

```bash
sudo nano /etc/nginx/sites-available/mi-app
```

```nginx
server {
    listen 80;
    server_name mi-app.ggsoluciones.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/mi-app /etc/nginx/sites-enabled/
sudo nginx -t           # Validar configuracion
sudo systemctl reload nginx
```

## Docker (si aplica)

```bash
# Build y push
docker build -t mi-app:latest .
docker tag mi-app:latest registry.ggsoluciones.com/mi-app:latest
docker push registry.ggsoluciones.com/mi-app:latest

# Deploy en VM
ssh deploy@servidor.ggsoluciones.com << 'EOF'
  docker pull registry.ggsoluciones.com/mi-app:latest
  docker stop mi-app || true
  docker rm mi-app || true
  docker run -d \
    --name mi-app \
    --restart unless-stopped \
    -p 127.0.0.1:3000:3000 \
    --env-file /var/www/mi-app/.env \
    registry.ggsoluciones.com/mi-app:latest
EOF
```

## CI/CD con GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build
        run: npm ci && npm run build

      - name: Deploy to VM
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.VM_HOST }}
          username: ${{ secrets.VM_USER }}
          key: ${{ secrets.VM_SSH_KEY }}
          script: |
            cd /var/www/mi-app
            sudo systemctl stop mi-app
            rsync -avz --exclude='.env' ./dist/ .
            sudo systemctl start mi-app
```

Agregar secrets en GitHub: `VM_HOST`, `VM_USER`, `VM_SSH_KEY`.

## Checklist de pre-deploy

- [ ] Tests en verde en CI
- [ ] Feature branch mergeada a master
- [ ] .env verificado en produccion (NO en el repo)
- [ ] Backup realizado
- [ ] Health check definido y accesible
- [ ] Rollback plandocumentado

## Rollback rapido

```bash
# Encontrar ultimo backup
ssh deploy@servidor.ggsoluciones.com "ls -t /var/www/backups/ | head -1"

# Restaurar
ssh deploy@servidor.ggsoluciones.com << 'EOF'
  sudo systemctl stop mi-app
  rm -rf /var/www/mi-app
  cp -r /var/www/backups/backup-20240511-143022 /var/www/mi-app
  sudo systemctl start mi-app
EOF
```

## Recursos

- Ver `reglas/git-avanzado/AGENT.md` — gestion de branches y commits
- Ver `equipo/devops/cicd/` — pipeline CI/CD del equipo
