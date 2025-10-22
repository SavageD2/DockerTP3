#!/usr/bin/env bash
set -euo pipefail

STEP_NET="webnet2"
HTTP_NAME="HTTP"
PHP_NAME="SCRIPT"
DB_NAME="DATA"

docker rm -f "$HTTP_NAME" "$PHP_NAME" "$DB_NAME" 2>/dev/null || true
docker network create "$STEP_NET" 2>/dev/null || true

# build image PHP avec mysqli/pdo_mysql
docker build -t php-mysqli:8.2-fpm-alpine ./php

# MariaDB (init .sql joué si volume neuf)
docker volume create etape2_mariadb_data >/dev/null
docker run -d --name "$DB_NAME" --network "$STEP_NET" \
  -e MARIADB_RANDOM_ROOT_PASSWORD=1 \
  -e MARIADB_DATABASE=tpdb \
  -e MARIADB_USER=tpuser \
  -e MARIADB_PASSWORD=tpsecret \
  -v etape2_mariadb_data:/var/lib/mysql \
  -v "$(pwd)/db/init:/docker-entrypoint-initdb.d:ro" \
  mariadb:11

# PHP-FPM custom (rw)
docker run -d --name "$PHP_NAME" --network "$STEP_NET" \
  -v "$(pwd)/web:/app:rw" \
  php-mysqli:8.2-fpm-alpine

# Nginx (ro + conf)
docker run -d --name "$HTTP_NAME" --network "$STEP_NET" -p 8081:80 \
  -v "$(pwd)/web:/app:ro" \
  -v "$(pwd)/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable-alpine

echo "Étape 2 lancée → http://localhost:8081 (test.php)"
