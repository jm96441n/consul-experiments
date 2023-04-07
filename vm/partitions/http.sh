#!/bin/bash

set -e

echo "creating partition"
./consul partition create -name part-1

cleanup() {
    echo "shutting down upstreams"
}

trap 'trap " " SIGTERM; kill 0; wait; cleanup' SIGINT SIGTERM

cat <<EOF | ./consul config write -
Kind      = "proxy-defaults"
Name      = "global"
Config {
  protocol = "http"
}
EOF

echo "Writing gateway config entry"
cat <<EOF | ./consul config write -
kind = "api-gateway"
name = "api-gateway"
listeners = [
  {
    name = "listener-one"
    port     = 9999
    protocol = "http"
    hostname = "*.consul.example"
  }
]
EOF

echo "Writing http route config entry"
cat <<EOF | ./consul config write -
kind = "http-route"
name = "api-gateway-route"
rules = [
  {
    services = [
      {
        name = "service"
        partition = "part-1"
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
  partition = "part-1"
  id   = "service"
  port = 9002
}
EOF
./consul services register -partition part-1 /tmp/service.hcl

echo "Registering http service proxy"
cat <<EOF >/tmp/proxy.hcl
service {
  kind = "connect-proxy"
  name = "service"
  partition = "part-1"
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
./consul services register /tmp/proxy.hcl

cat <<EOF >/tmp/server1.html
HTTP/1.1 200 GET
Content-Type: text/html; charset=UTF-8

<!doctype html><html><body>server1</body></html>
EOF

echo "Running http service"
ncat -e "/bin/cat /tmp/server1.html" -k -l 9002 &
echo "Running http service sidecar proxy"
./consul connect envoy -sidecar-for service -admin-bind 127.0.0.1:9092 -- -l trace &
echo "Running api gateway"
./consul connect envoy -gateway api -register -service api-gateway -proxy-id api-gateway -- -l trace &

wait
