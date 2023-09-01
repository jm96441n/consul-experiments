#! /bin/bash

set -e

cleanup() {
    echo "shutting down"
    docker compose down
}

trap 'trap " " SIGTERM; cleanup' SIGINT SIGTERM

go install github.com/jm96441n/convoy-build@latest
#convoy-build

echo "Starting services"

docker compose up -d

sleep 5

consul config write -token="root" ./configs/proxy_defaults.hcl

consul config write -token="root" ./configs/jwt-provider.hcl
#consul config write -token="root" ./configs/jwt-provider-another.hcl

#consul config write -token="root" ./configs/jwt-intention.hcl
#consul config write -token="root" ./configs/jwt-stricter-intention.hcl
consul config write -token="root" ./configs/bender-gw-intention.hcl
consul config write -token="root" ./configs/zoidberg-gw-intention.hcl
consul config write -token="root" ./configs/nibbler-gw-intention.hcl

consul config write -token="root" ./configs/http-route.hcl

docker compose logs -f

wait
