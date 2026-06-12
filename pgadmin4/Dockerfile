ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install build dependencies and runtime dependencies
RUN apk add --no-cache \
        nginx \
        ca-certificates \
        curl \
        git \
        python3 \
        py3-pip \
        postgresql-client \
        openssl && \
    apk add --virtual build-deps \
        python3-dev \
        build-base \
        postgresql-dev \
        libffi-dev \
        openssl-dev

# Create pgAdmin4 virtual environment and install
RUN python3 -m venv /opt/pgadmin4 && \
    /opt/pgadmin4/bin/pip install --upgrade pip setuptools wheel && \
    /opt/pgadmin4/bin/pip install --no-cache-dir pgadmin4 gunicorn

# Clean up build dependencies
RUN apk del build-deps && \
    rm -rf /var/cache/apk/*

# Create necessary directories
RUN mkdir -p /var/lib/pgadmin && \
    mkdir -p /var/log/pgadmin && \
    mkdir -p /pgadmin4 && \
    chmod 755 /var/lib/pgadmin && \
    chmod 755 /var/log/pgadmin

# Create a wrapper script to run pgAdmin4
RUN cat > /usr/local/bin/run-pgadmin.sh << 'EOF'
#!/bin/bash
set -e

export PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=false
export PGADMIN_CONFIG_PROXY_X_FOR_COUNT=1
export PGADMIN_CONFIG_PROXY_X_PROTO_COUNT=1
export PGADMIN_CONFIG_PROXY_X_HOST_COUNT=1
export PGADMIN_CONFIG_PROXY_X_PORT_COUNT=1
export PGADMIN_CONFIG_CONSOLE_LOG_LEVEL=10
export PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=False
export PGADMIN_CONFIG_WTF_CSRF_CHECK_DEFAULT=False

cd /var/lib/pgadmin
exec /opt/pgadmin4/bin/python3 -m pgadmin4
EOF
chmod +x /usr/local/bin/run-pgadmin.sh

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
