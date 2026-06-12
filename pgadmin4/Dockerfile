ARG BUILD_FROM

#Source: https://github.com/postgres/pgadmin4/blob/master/Dockerfile
########################################################################
#
# pgAdmin 4 - PostgreSQL Tools
#
# Copyright (C) 2013 - 2025, The pgAdmin Development Team
# This software is released under the PostgreSQL Licence
#
#########################################################################

# hadolint ignore=DL3029, DL3007
FROM --platform=$BUILDPLATFORM alpine:latest AS app-builder

# hadolint ignore=DL3018, DL3019
RUN --mount=type=cache,id=apk,sharing=locked,target=/var/cache/apk \
    apk add \
        autoconf \
        automake \
        bash \
        g++ \
        git \
        libc6-compat \
        libjpeg-turbo-dev \
        libpng-dev \
        libtool \
        make \
        nasm \
        nodejs \
        npm \
        yarn \
        zlib-dev

# Clone pgAdmin4 from GitHub
RUN \
    mkdir /tmp/pgadmin4-clone && \
    git clone --depth 1 https://github.com/pgadmin-org/pgadmin4.git /tmp/pgadmin4-clone

WORKDIR /pgadmin4

# Copy web source
RUN cp -r /tmp/pgadmin4-clone/web /pgadmin4/
# hadolint ignore=SC2046
RUN rm -rf /pgadmin4/web/*.log \
           /pgadmin4/web/config_*.py \
           /pgadmin4/web/node_modules \
           /pgadmin4/web/regression \
           $(find /pgadmin4/web -type d -name tests) \
           $(find /pgadmin4/web -type f -name .DS_Store)

WORKDIR /pgadmin4/web

# Build the JS vendor code in the app-builder, and then remove the vendor source.
# hadolint ignore=DL3016
RUN \
    --mount=type=cache,id=yarn,sharing=locked,target=/root/.yarn \
    export YARN_CACHE_FOLDER=/root/.yarn && \
    export CPPFLAGS="-DPNG_ARM_NEON_OPT=0" && \
    npm install -g corepack && \
    corepack enable && \
    yarn set version berry && \
    yarn set version 3 && \
    rm -f .yarnrc.yml && \
    yarn install > /dev/null 2>&1 && \
    yarn run bundle > /dev/null 2>&1 && \
    rm -rf node_modules \
           yarn.lock \
           package.json \
           .[!.]* \
           babel.cfg \
           webpack.* \
           jest.config.js \
           babel.* \
           ./pgadmin/static/js/generated/.cache

#########################################################################
# Next, create the base environment for Python
#########################################################################
# hadolint ignore=DL3007
FROM alpine:latest AS env-builder
ARG TARGETARCH
ARG TARGETVARIANT

# Clone pgAdmin4 to get requirements.txt
RUN apk add --no-cache git && \
    mkdir /tmp/pgadmin4-clone && \
    git clone --depth 1 https://github.com/pgadmin-org/pgadmin4.git /tmp/pgadmin4-clone

# hadolint ignore=DL3018, DL3019
RUN --mount=type=cache,id=apk-${TARGETARCH}-${TARGETVARIANT},sharing=locked,target=/var/cache/apk \
        apk add \
            make \
            python3 \
            py3-pip && \
        apk add --virtual build-deps \
            build-base \
            openssl-dev \
            libffi-dev \
            postgresql-dev \
            krb5-dev \
            rust \
            git \
            cargo \
            zlib-dev \
            libjpeg-turbo-dev \
            libpng-dev \
            python3-dev

RUN --mount=type=cache,id=pip-${TARGETARCH}-${TARGETVARIANT},sharing=locked,target=/root/.cache \
        python3 -m venv --system-site-packages --without-pip /venv && \
        /venv/bin/python3 -m pip install -r /tmp/pgadmin4-clone/requirements.txt && \
        apk del build-deps

#########################################################################
# Now, create a documentation build container for the Sphinx docs
#########################################################################

FROM env-builder AS docs-builder
ARG TARGETARCH
ARG TARGETVARIANT

# Install Sphinx
RUN --mount=type=cache,id=pip-${TARGETARCH}-${TARGETVARIANT},sharing=locked,target=/root/.cache \
        /venv/bin/python3 -m pip install sphinx && \
        /venv/bin/python3 -m pip install sphinxcontrib-youtube

WORKDIR /pgadmin4

# Copy the docs and web from cloned repo
RUN cp -r /tmp/pgadmin4-clone/docs /pgadmin4/ && \
    cp -r /tmp/pgadmin4-clone/web /pgadmin4/
RUN rm -rf /pgadmin4/docs/en_US/_build

# Build the docs
# hadolint ignore=DL3059
RUN LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 /venv/bin/sphinx-build /pgadmin4/docs/en_US /pgadmin4/docs/en_US/_build/html

# Cleanup unwanted files
RUN rm -rf /pgadmin4/docs/en_US/_build/html/.doctrees && \
    rm -rf /pgadmin4/docs/en_US/_build/html/_sources && \
    rm -rf /pgadmin4/docs/en_US/_build/html/_static/*.png

#########################################################################
# Create additional builders to get all of the PostgreSQL utilities
#########################################################################

FROM postgres:12-alpine AS pg12-builder
FROM postgres:13-alpine AS pg13-builder
FROM postgres:14-alpine AS pg14-builder
FROM postgres:15-alpine AS pg15-builder
FROM postgres:16-alpine AS pg16-builder
FROM postgres:17-alpine AS pg17-builder

# hadolint ignore=DL3007
FROM alpine:latest AS tool-builder

# Copy the PG binaries
COPY --from=pg12-builder /usr/local/bin/pg_dump /usr/local/pgsql/pgsql-12/
COPY --from=pg12-builder /usr/local/bin/pg_dumpall /usr/local/pgsql/pgsql-12/
COPY --from=pg12-builder /usr/local/bin/pg_restore /usr/local/pgsql/pgsql-12/
COPY --from=pg12-builder /usr/local/bin/psql /usr/local/pgsql/pgsql-12/

COPY --from=pg13-builder /usr/local/bin/pg_dump /usr/local/pgsql/pgsql-13/
COPY --from=pg13-builder /usr/local/bin/pg_dumpall /usr/local/pgsql/pgsql-13/
COPY --from=pg13-builder /usr/local/bin/pg_restore /usr/local/pgsql/pgsql-13/
COPY --from=pg13-builder /usr/local/bin/psql /usr/local/pgsql/pgsql-13/

COPY --from=pg14-builder /usr/local/bin/pg_dump /usr/local/pgsql/pgsql-14/
COPY --from=pg14-builder /usr/local/bin/pg_dumpall /usr/local/pgsql/pgsql-14/
COPY --from=pg14-builder /usr/local/bin/pg_restore /usr/local/pgsql/pgsql-14/
COPY --from=pg14-builder /usr/local/bin/psql /usr/local/pgsql/pgsql-14/

COPY --from=pg15-builder /usr/local/bin/pg_dump /usr/local/pgsql/pgsql-15/
COPY --from=pg15-builder /usr/local/bin/pg_dumpall /usr/local/pgsql/pgsql-15/
COPY --from=pg15-builder /usr/local/bin/pg_restore /usr/local/pgsql/pgsql-15/
COPY --from=pg15-builder /usr/local/bin/psql /usr/local/pgsql/pgsql-15/

COPY --from=pg16-builder /usr/local/bin/pg_dump /usr/local/pgsql/pgsql-16/
COPY --from=pg16-builder /usr/local/bin/pg_dumpall /usr/local/pgsql/pgsql-16/
COPY --from=pg16-builder /usr/local/bin/pg_restore /usr/local/pgsql/pgsql-16/
COPY --from=pg16-builder /usr/local/bin/psql /usr/local/pgsql/pgsql-16/

COPY --from=pg17-builder /usr/local/bin/pg_dump /usr/local/pgsql/pgsql-17/
COPY --from=pg17-builder /usr/local/bin/pg_dumpall /usr/local/pgsql/pgsql-17/
COPY --from=pg17-builder /usr/local/bin/pg_restore /usr/local/pgsql/pgsql-17/
COPY --from=pg17-builder /usr/local/bin/psql /usr/local/pgsql/pgsql-17/

#########################################################################
# Assemble everything into the final container.
#########################################################################
# hadolint ignore=DL3006
FROM ${BUILD_FROM} AS final
ARG TARGETARCH
ARG TARGETVARIANT

# Copy in the Python packages
COPY --from=env-builder /venv /venv

# Copy in the PostgreSQL tools
COPY --from=tool-builder /usr/local/pgsql /usr/local/

# Copy PostgreSQL libraries from pg17-builder
COPY --from=pg17-builder /usr/local/lib/ /usr/local/lib/
COPY --from=pg17-builder /usr/lib/libpq.so.5* /usr/lib/

# Create symlinks for libpq
RUN ls /usr/lib/libpq.so.* | head -1 | xargs -I {} ln -sf {} /usr/lib/libpq.so.5 && \
    ls /usr/lib/libpq.so.* | head -1 | xargs -I {} ln -sf {} /usr/lib/libpq.so || true

WORKDIR /pgadmin4
ENV PYTHONPATH=/pgadmin4

# Copy in the code and docs
COPY --from=app-builder /pgadmin4/web /pgadmin4
COPY --from=docs-builder /pgadmin4/docs/en_US/_build/html/ /pgadmin4/docs

# Dumb fix for a docker build: https://github.com/moby/moby/issues/37965
RUN true

# Get pgAdmin4 scripts and license from source
RUN apk add --no-cache git && \
    mkdir /tmp/pgadmin4-final && \
    git clone --depth 1 https://github.com/pgadmin-org/pgadmin4.git /tmp/pgadmin4-final && \
    cp /tmp/pgadmin4-final/pkg/docker/run_pgadmin.py /pgadmin4/ && \
    cp /tmp/pgadmin4-final/pkg/docker/gunicorn_config.py /pgadmin4/ && \
    cp /tmp/pgadmin4-final/LICENSE /pgadmin4/ && \
    cp /tmp/pgadmin4-final/DEPENDENCIES /pgadmin4/ && \
    rm -rf /tmp/pgadmin4-final && \
    apk del git

# Install runtime dependencies and configure everything in one RUN step
# hadolint ignore=DL3018, DL3019
RUN --mount=type=cache,id=final-apk-${TARGETARCH}-${TARGETVARIANT},sharing=locked,target=/var/cache/apk \
    apk add \
        apk-tools \
        python3 \
        py3-pip \
        postfix \
        krb5-libs \
        libjpeg-turbo \
        shadow \
        sudo \
        tzdata \
        libedit \
        libldap \
        libcap \
        nginx

RUN --mount=type=cache,id=pip-${TARGETARCH}-${TARGETVARIANT},sharing=locked,target=/root/.cache \
        /venv/bin/python3 -m pip install gunicorn==20.1.0

RUN     useradd -r -u 5050 -g root -s /sbin/nologin pgadmin && \
        mkdir -p /var/lib/pgadmin && \
        chown pgadmin:root /var/lib/pgadmin && \
        chmod g=u /var/lib/pgadmin && \
        touch /pgadmin4/config_distro.py && \
        chown pgadmin:root /pgadmin4/config_distro.py && \
        chmod g=u /pgadmin4/config_distro.py && \
        chmod g=u /etc/passwd && \
        setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/python3.12 && \
        echo "pgadmin ALL = NOPASSWD: /usr/sbin/postfix start" > /etc/sudoers.d/postfix && \
        echo "pgadminr ALL = NOPASSWD: /usr/sbin/postfix start" >> /etc/sudoers.d/postfix

# Precompile and optimize python code to save time and space on startup
RUN /venv/bin/python3 -O -m compileall -x node_modules /pgadmin4

# Make sure that S6 is not so hard on our service startup/shutdown
ENV \
    S6_SERVICES_GRACETIME=240000 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=120000 \
    PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION="False" \
    PGADMIN_CONFIG_WTF_CSRF_CHECK_DEFAULT="False" \
    PGADMIN_CONFIG_WTF_CSRF_ENABLED="False"

ARG CACHE_BUST

# Timestamp the build
RUN date +%Y%m%d%H%M%S > /build-timestamp

# Copy data
COPY rootfs /
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

# Labels
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
    org.opencontainers.image.version="${BUILD_VERSION}" \
    org.opencontainers.image.authors="mattjacobson6 (adapted from Expaso BV)" \
    org.opencontainers.image.vendor="mattjacobson6"
