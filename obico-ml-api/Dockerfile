# syntax=docker/dockerfile:1
# Builds Obico ml_api directly from the official release branch.
# No pre-built third-party images pulled — source only.

ARG BUILD_FROM=ghcr.io/hassio-addons/base:16.3.2
FROM ${BUILD_FROM}

# Install system dependencies including OpenCV runtime libs
RUN apk add --no-cache \
    git python3 py3-pip py3-virtualenv \
    libffi curl \
    py3-opencv \
    libglib \
    && git clone --depth 1 --branch release \
        https://github.com/TheSpaghettiDetective/obico-server.git /tmp/obico-server \
    && cp -r /tmp/obico-server/ml_api /opt/ml_api \
    && rm -rf /tmp/obico-server

# Install Python dependencies, excluding opencv-python since we use the system package
RUN python3 -m venv /opt/venv --system-site-packages \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && grep -v "opencv" /opt/ml_api/requirements.txt > /tmp/requirements_no_cv.txt \
    && /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements_no_cv.txt

# Copy addon run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /opt/ml_api

CMD ["/run.sh"]
