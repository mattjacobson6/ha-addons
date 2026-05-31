#!/usr/bin/with-contenv bashio

# Read token from addon options
ML_API_TOKEN=$(bashio::config 'ml_api_token')
export ML_API_TOKEN

bashio::log.info "Starting Obico ML API on port 3333..."
bashio::log.info "ML_API_TOKEN is set"

cd /opt/ml_api

exec /opt/venv/bin/gunicorn \
    --bind 0.0.0.0:3333 \
    --workers 1 \
    --access-logfile - \
    wsgi
