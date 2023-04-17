node_name = "consul-server1"
datacenter = "dc1"
server = true

log_level = "INFO"

peering { enabled = true }

ui_config = {
  enabled = true

}

data_dir = "~/consul/data"

addresses = {
  http = "0.0.0.0"
  grpc = "0.0.0.0"
}

bind_addr = "0.0.0.0"
advertise_addr = "10.6.0.2"

ports = {
  http = 8500
  grpc = 8502
  dns = 8600
  serf_lan = 8301
}


auto_reload_config = true
