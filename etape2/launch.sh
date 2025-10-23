#!/usr/bin/env bash
set -euo pipefail
export MSYS_NO_PATHCONV=1

ROOT="C:/Users/bourh/Docker-TP3/etape2"
NET_NAME="savage"
HTTP_NAME="HTTP"
PHP_NAME="SCRIPT"
DB_NAME="DATA"

# Supprimer containers et réseau existants
docker rm -f "$HTTP_NAME" "$PHP_NAME" "$DB_NAME" 2>/dev/null || true
docker network rm "$NET_NAME" 2>/dev/null || true

# Créer le réseau
docker network create "$NET_NAME"

# Lancer MariaDB
docker run -d \
  --name "$DB_NAME" \
  --network "$NET_NAME" \
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
  -v "$ROOT/src/create.sql:/docker-entrypoint-initdb.d/create.sql:ro" \
  mariadb:latest

# Construire l'image PHP avec mysqli
docker build -t php-mysqli "$ROOT/docker"

# Lancer PHP-FPM
docker run -d \
  --name "$PHP_NAME" \
  --network "$NET_NAME" \
  -v "$ROOT/src:/app" \
  php-mysqli

# Lancer NGINX
docker run -d \
  --name "$HTTP_NAME" \
  --network "$NET_NAME" \
  -p 8080:80 \
  -v "$ROOT/src:/app" \
  -v "$ROOT/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable-alpine

echo "✅ Étape 2 en route !"
echo "🌐 Ouvre ton browser : http://localhost:8080/test.php"