# BUILD_FROM is injected by HA Supervisor from build.yaml
# Uses the official Dozzle image as the base
ARG BUILD_FROM
FROM ${BUILD_FROM}

# The official Dozzle image handles everything
# Port 8080 is already exposed
# Docker socket is mounted via docker_api: true in config.yaml
# Let the base image's entrypoint handle startup
