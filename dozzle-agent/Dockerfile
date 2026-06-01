# BUILD_FROM is injected by HA Supervisor from build.yaml
# Uses the official Dozzle image as the base
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Tell Dozzle where to find the Docker socket
# HA mounts it at /var/run/docker.sock via docker_api: true
ENV DOCKER_HOST=unix:///var/run/docker.sock

# Port 8080 is already exposed by the base image
# The base image's entrypoint will handle startup
