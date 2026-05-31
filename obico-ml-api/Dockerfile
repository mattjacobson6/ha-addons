# syntax=docker/dockerfile:1
# Builds Obico ml_api directly from the official release branch.

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:7.3.3
FROM ${BUILD_FROM}

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        python3 \
        python3-pip \
        python3-venv \
        libglib2.0-0 \
        libgl1 \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Clone Obico release branch and extract ml_api
RUN git clone --depth 1 --branch release \
        https://github.com/TheSpaghettiDetective/obico-server.git /tmp/obico-server \
    && cp -r /tmp/obico-server/ml_api /opt/ml_api \
    && rm -rf /tmp/obico-server

# Download model weights
RUN curl -o /opt/ml_api/model/model-weights.onnx -L \
        "$(cat /opt/ml_api/model/model-weights.onnx.url | tr -d '\r')"

# Install Python dependencies
# Remove pinned opencv from requirements and reinstall latest headless version
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && grep -iv "opencv" /opt/ml_api/requirements.txt > /tmp/requirements_no_cv.txt \
    && /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements_no_cv.txt \
    && /opt/venv/bin/pip install --no-cache-dir opencv-python-headless

# Copy addon run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /opt/ml_api

CMD ["/run.sh"]
