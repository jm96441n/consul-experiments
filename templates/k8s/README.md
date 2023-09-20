# JWTs

**This project runs:**

* 1 kind cluster
* 1 consul server
* 3 services (bender, zoidberg, and nibbler) ([http-echo](https://hub.docker.com/r/hashicorp/http-echo/))
* 1 sidecar per service
* 1 APIGateway

Tasks can be run either using make or [xc](https://github.com/joerdav/xc)

Make sure you have set the `CONSUL_K8S_CHARTS_LOCATION` to the filepath on your system of the helm charts in consul-k8s

## Tasks
### start
Run the `start` file
```sh
./start
```
This starts the `kind` setup which runs kind, consul, and the three services. It then configures a jwt provider based
on the tokens in the [token section](#Tokens) below, and a service
intention to only allow requests from zoidberg to bender if a valid JWT is present.

### reload
Run the `reload` file
```sh
./reload
```
This restarts your consul configuration within your `kind` cluster. It deletes all added resources (services and consul)
and then loads your local consul and consul-k8s images and reinstalls consul and services.

### exec-zoidberg
Execs you into the zoidberg container and drops you into a shell
```
kubectl exec -i -t $(kubectl get pods --selector=app=zoidberg -o jsonpath='{.items[*].metadata.name}') -c zoidberg -- /bin/sh
```

### exec-nibbler
Execs you into the nibbler container and drops you into a shell
```
kubectl exec -i -t $(kubectl get pods --selector=app=nibbler -o jsonpath='{.items[*].metadata.name}') -c nibble -- /bin/sh
```
