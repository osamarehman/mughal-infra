#!/bin/bash
set -e

# Update proxy
cd /opt/docker/proxy
cp -f /tmp/deploy/proxy/Caddyfile ./Caddyfile
cp -f /tmp/deploy/proxy/docker-compose.yml ./docker-compose.yml
docker compose up -d

# Update Homarr (preserving encryption key)
cd /opt/docker/homarr
cp -f /tmp/deploy/homarr/docker-compose.yml ./docker-compose.yml
if [ -f .env ]; then
    # Keep the existing encryption key
    docker compose up -d
else
    # Generate a new key if none exists
    ENCRYPTION_KEY=$(openssl rand -hex 32)
    echo "ENCRYPTION_KEY=$ENCRYPTION_KEY" > .env
    docker compose up -d
fi

# Update socket-proxy
cd /opt/docker/socket-proxy
cp -f /tmp/deploy/socket-proxy/docker-compose.yml ./docker-compose.yml
docker compose up -d

echo "Deployment completed successfully!"
