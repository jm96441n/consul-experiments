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

consul config write ./configs/jwt-provider.hcl
consul config write ./configs/jwt-provider-another.hcl

#consul config write ./configs/jwt-intention.hcl
consul config write ./configs/jwt-stricter-intention.hcl

docker compose logs -f

wait
