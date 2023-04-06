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

cat <<EOF | consul config write -
Kind      = "proxy-defaults"
Name      = "global"
Config {
  protocol = "http"
}
EOF

cat <<EOF | consul config write -
kind = "api-gateway"
name = "api-gateway"
listeners = [
  {
    name = "listener-one"
    port     = 9001
    protocol = "http"
  }
]
EOF

cat <<EOF | consul config write -
kind = "http-route"
name = "api-gateway-route"
rules = [
  {
    services = [
      {
        name = "bender"
      }
    ]
  }
]

parents = [
  {
    sectionName = "listener-one"
    name = "api-gateway"
    kind = "api-gateway"
  }
]
EOF

docker compose logs -f

wait
