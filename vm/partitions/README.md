# Basic Api Gateway

**This project runs:**

* 1 consul server
* 1 consul agent in partition "ap1"
* 1 service ([fortio](https://hub.docker.com/r/istio/fortio)) in default partition
* 1 sidecar for the service in the default partition
* 1 service ([fortio](https://hub.docker.com/r/istio/fortio)) in partition "ap1"
* 1 sidecar for the service in partition "ap1"
* 1 consul native api-gateway


## Tasks
### start
Runs the `start.sh` file
```sh
./start.sh
```


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
