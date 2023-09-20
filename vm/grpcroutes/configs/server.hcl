node_name = "planetexpress"
datacenter = "dc1"
server = true

log_level = "INFO"

ui_config {
  enabled = true

}

addresses {
  http = "0.0.0.0"
  grpc = "0.0.0.0"
}

ports {
    http = 8500
    grpc = 8502
}

bind_addr = "0.0.0.0"
advertise_addr =" 10.7.0.2"

auto_reload_config = true
