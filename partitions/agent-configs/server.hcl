node_name = "bender"
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
advertise_addr = "192.168.50.131"

ports = {
  http = 7500
  grpc = 7502
  dns = 7600
}

auto_reload_config = true
