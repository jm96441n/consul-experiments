
service {
    name     = "nibbler"
    id       = "nibbler"
    address  = "10.6.0.250"
    port     = 8082

    connect {
        sidecar_service {
            port = 20000

            check {
                name = "Connect Envoy Sidecar"
                tcp = "10.6.0.200:20000"
                interval ="10s"
            }
            proxy {
                upstreams = [
                    {
                        destination_name = "bender"
                        local_bind_port = 5000
                    }
                ]
            }
        }
    }
}
