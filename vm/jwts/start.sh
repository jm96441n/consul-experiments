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

docker compose logs -f

wait
