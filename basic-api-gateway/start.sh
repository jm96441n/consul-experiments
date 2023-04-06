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
kind = "http-route"
name = "api-gateway-route"
rules = [
  {
    filters {
        URLRewrite {
            path = "/fortio"
        }
    }

    services = [
      {
        name = "bender"
      }
    ]
    matches = [
        {
            path {
                value = "/default"
                match = "prefix"
            }
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
