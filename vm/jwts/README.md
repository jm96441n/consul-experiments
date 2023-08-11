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


## Test the Basic JWT Setup
This is just to run through enforcing that a valid JWT exists at all on the request.

First in one terminal window run the `start` command via either `make start` or `xc start`.

Once the `start` command finishes (you can tell by seeing logs for the running containers in the window),
in a separate terminal window run the `exec-zoidberg` command to exec into the zoidberg container.

Then run the following to see a denied request from a missing JWT (you should see `JWT is missing` in the response):
```
curl localhost:5000
```

Next we'll make a request using the JWT we stored in the env to see it succeed (you'll see `hello world` get returned):
```
curl -H "Authorization: Bearer $SIMPLE_TOKEN" localhost:5000
```

Exit the exec'd container and you can shutdown the scaffold by `ctrl-c` in the window with logs.

## Testing Stricter JWT Intentions
This setup is to run through enforcing that a JWT with specific claims exists on the request.
First up, we need to modify the `start.sh` file by commenting out line 22 and uncommenting line 23 so that we write the
stricter service intention.

First we'll do our usual and run the `start` command in one terminal window.

Once that completes let's open another terminal window and exec into the zoidberg container with the `exec-zoidberg`
command. In that container let's run the following to see our simple token no longer work because it's missing the
claims:
```
curl -H "Authorization: Bearer $SIMPLE_TOKEN" localhost:5000
```

Now let's use our `DOCTOR_TOKEN` which contains the correct claim, so in the same zoidberg container lets run the
following which should succeed:
```
curl -H "Authorization: Bearer $DOCTOR_TOKEN" localhost:5000
```

Finally let's exit that container and exec into the nibbler container with the `exec-nibbler` command and make the same
request but this time using the `PET_TOKEN` which has the right claim key but a wrong value.
```
curl -H "Authorization: Bearer $PET_TOKEN" localhost:5000
```

## Tokens

The JWK is generated using: [mkjwk](https://mkjwk.org/) using a key size of 2048, key use is `Signature`, algo is `PS256`, and Key
ID is `SHA-256`

JWTs are generated using: [jwt tool](https://www.scottbrady91.com/tools/jwt)

### SIMPLE_TOKEN
The `SIMPLE_TOKEN` env variable for the `zoidberg` service in the docker-compose file is an example JWT token that is signed by the generated JWK
in the `my-key.jwk` file (and is base64 encoded in the `jwk-intention.hcl` file).

The following was used in the JWT:

JWT HEADER:
```
{
    "typ": "JWT",
    "alg": "PS256",
    "kid": "C-E1nCjwgBC-PuGM2O467FRDhKx8AkVctISAbo3riew"
}
```

JWT Payload
```
{
    "iss": "local"
}
```

### DOCTOR_TOKEN
This key `DOCTOR_TOKEN` in the `zoidberg` service has the additional claim of `role: doctor` and is signed by the same JWK.

The following was used in the JWT:

JWT HEADER:
```
{
    "typ": "JWT",
    "alg": "PS256",
    "kid": "C-E1nCjwgBC-PuGM2O467FRDhKx8AkVctISAbo3riew"
}
```

JWT Payload
```
{
    "iss": "local",
    "role": "doctor"
}
```

### PET_TOKEN
This key `PET_TOKEN` in the `nibbler` service has the additional claim of `role: pet` and is signed by the same JWK.

The following was used in the JWT:

JWT HEADER:
```
{
    "typ": "JWT",
    "alg": "PS256",
    "kid": "C-E1nCjwgBC-PuGM2O467FRDhKx8AkVctISAbo3riew"
}
```

JWT Payload
```
{
    "iss": "local",
    "role": "pet"
}
```
