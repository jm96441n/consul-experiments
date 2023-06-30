# JWTS

**This project runs:**

* 1 consul server
* 2 service ([http-echo](https://hub.docker.com/r/hashicorp/http-echo/))
* 1 sidecar per service


## Tasks
### start
Run the `start.sh` file from one terminal window (ctrl-c in this window with the logs will trigger a shutdown of
`docker compose`)
```sh
./start.sh
```
This starts the `docker-compose` setup which runs consul and the two services. It then configures a jwt provider based
on the tokens in the [token section](#Tokens) below, and a service
intention to only allow requests from zoidberg to bender if a valid JWT is present.


To test out the token intention in action, open a new terminal window and exec into the zoidberg container with:
```
docker compose exec service-zoidberg-default /bin/sh
```

Then run the following to see a denied request from a missing JWT (you should see `JWT is missing` in the response):
```
curl localhost:5000
```

Next we'll make a request using the JWT we stored in the env to see it succeed (you'll see `hello world` get returned):
```
curl -H "Authorization: Bearer $TOKEN" localhost:5000
```


## Tokens

The `TOKEN` env variable for the `zoidberg` service in the docker-compose file is an example JWT token that is signed by the generated JWK
in the `my-key.jwk` file (and is base64 encoded in the `jwk-intention.hcl` file.

The JWK is generated from: [mkjwk](https://mkjwk.org/) using a key size of 2048, key use is `Signature`, algo is `PS256`, and Key
ID is `SHA-256`

JWT is generated from [jwt tool](https://www.scottbrady91.com/tools/jwt)
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
