node_name = "client-ap1"
datacenter = "dc1"
server = false
partition = "ap1"

log_level = "INFO"

data_dir = "~/consul/data"
retry_join = ["10.6.0.2"]

ui_config = {
  enabled = true

}

ports = {
  grpc = 8502
  serf_lan = 8301
  http = 8500
  dns = 8600
}

bind_addr = "0.0.0.0"
advertise_addr = "10.6.0.11"

auto_reload_config = true
