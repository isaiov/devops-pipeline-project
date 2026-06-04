#!/bin/bash
set -euo pipefail

IMAGE="${IMAGE_NAME:-ghcr.io/isaiov/devops-pipeline-project:latest}"
COMPOSE_FILE="docker-compose.prod.yml"

echo "==> Pulling latest image..."
docker pull "$IMAGE"

echo "==> Stopping old container..."
docker compose -f "$COMPOSE_FILE" down || true

echo "==> Starting new container..."
docker compose -f "$COMPOSE_FILE" up -d

echo "==> Waiting for health check..."
sleep 5

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:80/health)
if [ "$STATUS" != "200" ]; then
    echo "FAILED: health check returned $STATUS"
    docker compose -f "$COMPOSE_FILE" logs
    exit 1
fi

echo "==> Deploy complete. Site is live."

docker image prune -f
