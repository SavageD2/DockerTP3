#!/usr/bin/env bash
set -euo pipefail
export MSYS_NO_PATHCONV=1

ROOT="C:/Users/bourh/Docker-TP3/etape1"
STEP_NET="webnet"
HTTP_NAME="HTTP"
PHP_NAME="SCRIPT"

docker rm -f "$HTTP_NAME" "$PHP_NAME" 2>/dev/null || true
docker network create "$STEP_NET" 2>/dev/null || true

docker run -d --name "$PHP_NAME" --network "$STEP_NET" \
  -v "$ROOT/web:/app:rw" \
  php:8.2-fpm-alpine

docker run -d --name "$HTTP_NAME" --network "$STEP_NET" -p 8080:80 \
  -v "$ROOT/web:/app:ro" \
  -v "$ROOT/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable-alpine

echo "Étape 1 lancée → http://localhost:8080"
