service {
    name     = "bender"
    id       = "bender"
    address  = "10.7.0.100"
    port     = 50051

    connect {
        sidecar_service {
            port = 20000

            check {
                name = "Connect Envoy Sidecar"
                tcp = "10.7.0.100:20000"
                interval ="10s"
            }
            proxy {
                destination_service_name = "bender"
                destination_service_id = "bender"
                local_service_address = "10.7.0.100"
                local_service_port = 50051
            }
        }
    }
}
