# Consul Experiments

Repo to hold some experiments with consul/useful consul setups for local testing.

## Repo Layout

At the root of this repo:
* `Dockerfile` used to build the `consul-envoy` image used for the gateways and sidecars.
* `convoy-build` this is used to build the docker image for `consul-envoy`, this assumes you have an installation of
  consul at `$HOME/go/bin/consul` and an installation of envoy at `/usr/local/bin/envoy` that will be copied into the
  container at build time (this allows you to use recently built versions of consul for testing).
* `entrypoint.sh` used as the entrypoint for the `consul-envoy` container

Each directory contains:
* `docker-compose` file that handles starting the consul containers/services, this assumes you've:
     * built the `consul-envoy` image by running the `convoy-build` script.
     * have a local consul image named `consul-dev:latest`, which you can get from running `make docker-dev` in the consul repo.
     * a `CONSUL_LICENSE` env variable with a valid consul license in it (if you're not running enterprise consul you can just remove those lines)
* `start.sh` bash script to run that handles running docker compose and writing the relevant config entries to consul
* A `configs` directory with the relevant consul configs for the consul servers/agents/clients/gateways/sidecars.
* `README.md` that briefly describes the setup.

## Status of Projects

| Directory         | Status      |
|-------------------|-------------|
| `basic`             | In Progress |
| `basic-api-gateway` | Working     |
| `partitions`        | In Progress |
