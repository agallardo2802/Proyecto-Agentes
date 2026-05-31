# 10 - Deploy VM Linux

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Conectarse a una VM Linux por SSH
- Transferir archivos con rsync
- Configurar servicios con systemd
- Configurar Nginx como reverse proxy

---

## Pre-requisitos

```bash
# Verificar conexion SSH
ssh -v usuario@servidor.example.com

# Verificar que rsync esta disponible
rsync --version

# Verificar que tienes las claves SSH configuradas
ls ~/.ssh/id_rsa.pub
```

---

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

---

## Transferencia de Archivos

### rsync (recomendado - solo transfiere cambios)

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

---

## Workflow de Deploy

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

---

## Servicios con systemd

### Crear servicio

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

---

## Nginx como Reverse Proxy

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

---

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

---

## Checklist de Pre-deploy

- [ ] Tests en verde en CI
- [ ] Feature branch mergeada a master
- [ ] .env verificado en produccion (NO en el repo)
- [ ] Backup realizado
- [ ] Health check definido y accesible
- [ ] Rollback plan documentado

---

## Rollback Rapido

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

---

## Siguiente Capitulo

Continuar con: [11-CI-CD-Pipeline](./02-cicd-pipeline.md)

## Recursos

- `reglas/deploy-linux-vm/AGENT.md` — guia completa
- `equipo/devops/cicd/` — pipelines del equipo
