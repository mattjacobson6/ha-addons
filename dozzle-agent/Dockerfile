# BUILD_FROM is injected by HA Supervisor from build.yaml
# Uses the official Dozzle image as the base
ARG BUILD_FROM
FROM ${BUILD_FROM}

# The official Dozzle image already has everything configured
# Port 8080 is exposed by default
# Just ensure the container can access the Docker socket (enabled via docker_api: true in config.yaml)

EXPOSE 8080

# Use the official Dozzle image's default entrypoint
# (no need to override - the base image handles it)
