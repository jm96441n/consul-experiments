node_name = "agent-partition"
datacenter = "dc1"
partition = "part-1"
server = false

data_dir = "~/consul/data"
log_level = "INFO"
retry_join = ["bender"]


addresses = {
  grpc = "0.0.0.0"
  http = "0.0.0.0"
}


bind_addr = "0.0.0.0"
advertise_addr = "192.168.50.131"

ports = {
  grpc = 9502
  serf_lan = 9301
  http = 9500
  dns = 9600
}

auto_reload_config = true
