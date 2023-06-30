
service {
    name     = "zoidberg"
    id       = "zoidberg"
    address  = "10.6.0.200"
    port     = 8080

    connect {
        sidecar_service {
            port = 20000

            check {
                name = "Connect Envoy Sidecar"
                tcp = "10.6.0.200:20000"
                interval ="10s"
            }
            proxy {
                destination_service_name = "zoidberg"
                destination_service_id = "zoidberg"
                local_service_address = "10.6.0.200"
                local_service_port = 8080
            }
        }
    }
}
