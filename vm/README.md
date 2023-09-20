# JWTS

**This project runs:**

* 1 consul server
* 3 services (bender, zoidberg, and nibbler) ([http-echo](https://hub.docker.com/r/hashicorp/http-echo/))
* 1 sidecar per service
* 1 APIGateway

Tasks can be run either using make or [xc](https://github.com/joerdav/xc)

## Tasks
### start
Run the `start.sh` file (ctrl-c in this window with the logs will trigger a shutdown of
`docker compose`)
```sh
./start.sh
```
This starts the `docker-compose` setup which runs consul and the three services. It then configures a jwt provider based
on the tokens in the [token section](#Tokens) below, and a service
intention to only allow requests from zoidberg to bender if a valid JWT is present.

### convoy-build
installs the `convoy-build` command
```
go install github.com/jm96441n/convoy-build
```
This rebuilds the convoy image, which includes local consul and envoy into it

### exec-zoidberg
Execs you into the zoidberg container and drops you into a shell
```
docker compose exec service-zoidberg-default /bin/sh
```

### exec-nibbler
Execs you into the nibbler container and drops you into a shell
```
docker compose exec service-nibbler-default /bin/sh
```


