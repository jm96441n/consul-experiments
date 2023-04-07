#! /bin/bash

set -e

cleanup() {
    echo "shutting down"
    docker compose down
}

trap 'trap " " SIGTERM; cleanup' SIGINT SIGTERM

echo "Starting services"

docker compose up -d

sleep 5

consul config write ./configs/proxy_defaults.hcl

consul config write ./configs/http_route_api_gateway.hcl

docker compose logs -f

wait
