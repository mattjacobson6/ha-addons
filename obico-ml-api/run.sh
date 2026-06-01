#!/usr/bin/env bash
set -e

CONFIG_FILE=/data/options.json

# Helper function to extract JSON values
get_json_value() {
    local key=$1
    local file=$2
    local default=${3:-}

    local value=$(grep -o "\"$key\":[^,}]*" "$file" | cut -d: -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [ -z "$value" ] || [ "$value" = "null" ]; then
        echo "$default"
    else
        echo "$value" | sed 's/^"//;s/"$//'
    fi
}

# Read configuration from /data/options.json
DETECTION_INTERVAL=$(get_json_value "detection_interval" "$CONFIG_FILE" "2")
VIDEO_ROTATION=$(get_json_value "video_rotation_degree" "$CONFIG_FILE" "0")
VERBOSITY=$(get_json_value "verbosity" "$CONFIG_FILE" "info")

# Set environment variables for the Obico ML API
export DETECTION_INTERVAL="$DETECTION_INTERVAL"
export VIDEO_ROTATION_DEGREE="$VIDEO_ROTATION"
export LOG_LEVEL="$VERBOSITY"

echo "[INFO] Obico ML API starting..."
echo "[INFO] Detection interval: ${DETECTION_INTERVAL}s"
echo "[INFO] Video rotation: ${VIDEO_ROTATION}°"
echo "[INFO] Log level: ${VERBOSITY}"

# Start the Obico ML API server using gunicorn
# The base image has the ML models and dependencies pre-installed
cd /app

exec gunicorn \
    --bind 0.0.0.0:3333 \
    --workers 1 \
    --access-logfile - \
    wsgi
