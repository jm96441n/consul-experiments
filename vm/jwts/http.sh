#!/bin/bash

set -e

cleanup() {
    docker stop service || true
    echo "shutting down upstreams"
}

trap 'trap " " SIGTERM; kill 0; wait; cleanup' SIGINT SIGTERM

cat <<EOF | consul config write -
Kind      = "proxy-defaults"
Name      = "global"
Config {
  protocol = "http"
}
EOF

echo "Writing gateway config entry"
cat <<EOF | consul config write -
kind = "api-gateway"
name = "api-gateway"
listeners = [
  {
    name = "listener-one"
    port     = 9999
    protocol = "http"
  }
]
EOF

echo "Writing http route config entry"
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
        name = "service"
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

echo "Registering http service"
cat <<EOF >/tmp/service.hcl
service {
  name = "service"
  id   = "service"
  port = 9002
}
EOF
consul services register /tmp/service.hcl

echo "Registering http service proxy"
cat <<EOF >/tmp/proxy.hcl
service {
  kind = "connect-proxy"
  name = "service"
  id   = "service"
  port = 9001

  proxy = {
    destination_service_name  = "service"
    destination_service_id    = "service"
    local_service_address     = "127.0.0.1"
    local_service_port        = 9002
  }
}
EOF
consul services register /tmp/proxy.hcl

docker run -d --rm --name service -p 9002:8080 docker.mirror.hashicorp.services/fortio/fortio server -redirect-port -disabled -echo-server-default-params status=200
echo "Running http service sidecar proxy"
consul connect envoy -sidecar-for service -admin-bind 127.0.0.1:9092 -- -l trace &
echo "Running api gateway"
consul connect envoy -gateway api -register -service api-gateway -proxy-id api-gateway -- -l trace &

wait
