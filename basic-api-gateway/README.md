# Basic Api Gateway

**This project runs:**

* 1 consul server
* 1 service ([fortio](https://hub.docker.com/r/istio/fortio))
* 1 sidecar for the service
* 1 consul native api-gateway
* 1 http route configured to route from to the fortio service container and rewrites the path `/default` to `/fortio`.


## Tasks
### route
Prints http route config status
```sh
consul config read -kind http-route -name api-gateway-route
```

### gw
Prints api gateway config status
```sh
consul config read -kind api-gateway -name api-gateway
```
