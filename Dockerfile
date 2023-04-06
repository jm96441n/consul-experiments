### CONFIGURATION ###
#
# These default values can be used by a Github Action to build images, if enabled.
#
#
### END CONFIGURATION ###

FROM ubuntu

ENV CONSUL_HTTP_ADDR=http://localhost:8500

RUN apt-get update && \
    apt-get install -y \
      bash \
      curl \
      jq && \
    rm -rf /var/lib/apt/lists/*

COPY ./envoy /bin/envoy
COPY ./consul /bin/consul

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
