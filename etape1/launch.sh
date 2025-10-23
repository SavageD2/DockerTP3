set -euo pipefail
export MSYS_NO_PATHCONV=1

ROOT="C:/Users/bourh/Docker-TP3/etape1"
NET_NAME="savage"
HTTP_NAME="HTTP"
PHP_NAME="SCRIPT"

docker rm -f "$HTTP_NAME" "$PHP_NAME" 2>/dev/null || true
docker network rm "$NET_NAME" 2>/dev/null || true

docker network create "$NET_NAME"

docker run -d \
  --name "$PHP_NAME" \
  --network "$NET_NAME" \
  -v "$ROOT/src:/app" \
  php:8.2-fpm-alpine

docker run -d \
  --name "$HTTP_NAME" \
  --network "$NET_NAME" \
  -p 8080:80 \
  -v "$ROOT/src:/app" \
  -v "$ROOT/config/default.conf:/etc/nginx/conf.d/default.conf:ro" \
  nginx:stable-alpine

echo "✅ Containers mis en route avec succès !!!"
echo "��� Ouvre ton browser et go sur : http://localhost:8080"