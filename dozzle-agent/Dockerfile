# BUILD_FROM is injected by HA Supervisor from build.yaml
# Uses the official Dozzle image as the base
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Copy s6-overlay service configuration for HA addon integration
COPY rootfs /

# Port 8080 is already exposed by the base image
EXPOSE 8080

# Use s6-overlay init system (HA standard)
ENTRYPOINT ["/init"]
