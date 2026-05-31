# syntax=docker/dockerfile:1
# Uses the official Obico ml_api base image which includes darknet, CUDA libs,
# and all compiled dependencies. Layers HA addon scaffolding on top.

ARG BUILD_FROM=thespaghettidetective/ml_api_base:1.4
FROM ${BUILD_FROM}

# Install HA addon scaffolding (s6-overlay + bashio)
ARG BUILD_ARCH=amd64
ARG BASHIO_VERSION="v0.16.2"
ARG S6_OVERLAY_VERSION="3.2.0.0"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        tzdata \
        xz-utils \
        wget \
    \
    && S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then S6_ARCH="x86_64"; fi \
    \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
        | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" \
        | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" \
        | tar -C / -Jxpf - \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz" \
        | tar -C / -Jxpf - \
    \
    && curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    \
    && apt-get purge -y --auto-remove xz-utils \
    && apt-get clean \
    && rm -rf /tmp/* /var/{cache,log}/* /var/lib/apt/lists/*

# Clone Obico ml_api from release branch
RUN git clone --depth 1 --branch release \
        https://github.com/TheSpaghettiDetective/obico-server.git /tmp/obico-server \
    && cp -r /tmp/obico-server/ml_api /app \
    && rm -rf /tmp/obico-server

WORKDIR /app

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Download model weights
RUN echo 'Downloading darknet model weights...' \
    && wget -O model/model-weights.darknet "$(cat model/model-weights.darknet.url | tr -d '\r')" \
    && echo 'Downloading ONNX model weights...' \
    && wget -O model/model-weights.onnx "$(cat model/model-weights.onnx.url | tr -d '\r')"

# Copy run script and set entrypoint
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 3333

ENTRYPOINT ["/init"]
CMD ["/run.sh"]
