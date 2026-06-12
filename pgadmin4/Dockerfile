ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install nginx for ingress support and additional tools
RUN apk add --no-cache \
        nginx \
        python3 \
        py3-pip \
        py3-requests \
        curl \
        ca-certificates

# Install pgAdmin4
RUN pip install --no-cache-dir pgadmin4

# Create pgadmin directories
RUN mkdir -p /var/lib/pgadmin && \
    mkdir -p /var/log/pgadmin && \
    chmod 755 /var/lib/pgadmin && \
    chmod 755 /var/log/pgadmin

# Copy rootfs
COPY rootfs /

# Make scripts executable
RUN chmod +x /etc/cont-init.d/* && \
    chmod +x /etc/services.d/nginx/* && \
    chmod +x /etc/services.d/pgadmin4/*

WORKDIR /

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION="PostgreSQL database management web interface"
ARG BUILD_NAME="pgAdmin4"
ARG BUILD_REF
ARG BUILD_VERSION
ARG BUILD_REPOSITORY="mattjacobson6/ha-addons"

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version="${BUILD_VERSION}" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.licenses="Apache 2.0" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${BUILD_REF}" \
    org.opencontainers.image.version="${BUILD_VERSION}"
