service {
    name     = "zoidberg"
    id       = "zoidberg"
    address  = "10.6.0.101"
    port     = 8080
    partition = "ap1"

    connect {
        sidecar_service {
            port = 20000

            check {
                name = "Connect Envoy Sidecar"
                tcp = "10.6.0.101:20000"
                interval ="10s"
            }
            proxy {
                destination_service_name = "zoidberg"
                destination_service_id = "zoidberg"
                local_service_address = "10.6.0.101"
                local_service_port = 8080
            }
        }
    }
}
