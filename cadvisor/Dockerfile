# BUILD_FROM is injected by HA Supervisor from build.yaml
# Uses Google's official cAdvisor image
ARG BUILD_FROM
FROM ${BUILD_FROM}

# The official cAdvisor image handles everything
# Port 8080 is already exposed
# Required volume mounts are handled by HA config

EXPOSE 8080

# The base image's entrypoint handles startup
