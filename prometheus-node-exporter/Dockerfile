# BUILD_FROM is injected by HA Supervisor from build.yaml
# Uses Prometheus's official Node Exporter image
ARG BUILD_FROM
FROM ${BUILD_FROM}

# The official Node Exporter image handles everything
# Port 9100 is already exposed
# Required volume mounts are handled by HA config

EXPOSE 9100

# The base image's entrypoint handles startup
