#!/usr/bin/env bash
set -euo pipefail
docker compose up -d --build
echo "Étape 3 lancée → http://localhost:8080"
