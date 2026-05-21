#!/bin/sh
set -e

# Increase file descriptor limit for HAProxy
ulimit -n 10000

CONFIG_FILE=/data/options.json
TEMPLATE_FILE=/usr/local/etc/haproxy/haproxy.cfg.template
OUTPUT_FILE=/tmp/haproxy.cfg

# Helper function to extract JSON values without jq (pure shell)
get_json_value() {
    local key=$1
    local file=$2
    local default=${3:-}

    # Use grep + sed to extract the value for a given key
    # Handles strings (with quotes), booleans, and numbers
    local value=$(grep -o "\"$key\":[^,}]*" "$file" | cut -d: -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [ -z "$value" ] || [ "$value" = "null" ]; then
        echo "$default"
    else
        # Remove quotes if present
        echo "$value" | sed 's/^"//;s/"$//'
    fi
}

# Read all options from /data/options.json
ALLOW_RESTARTS=$(get_json_value "ALLOW_RESTARTS" "$CONFIG_FILE" "false")
ALLOW_START=$(get_json_value "ALLOW_START" "$CONFIG_FILE" "false")
ALLOW_STOP=$(get_json_value "ALLOW_STOP" "$CONFIG_FILE" "false")
AUTH=$(get_json_value "AUTH" "$CONFIG_FILE" "false")
BUILD=$(get_json_value "BUILD" "$CONFIG_FILE" "false")
COMMIT=$(get_json_value "COMMIT" "$CONFIG_FILE" "false")
CONFIGS=$(get_json_value "CONFIGS" "$CONFIG_FILE" "false")
CONTAINERS=$(get_json_value "CONTAINERS" "$CONFIG_FILE" "true")
DISABLE_IPV6=$(get_json_value "DISABLE_IPV6" "$CONFIG_FILE" "false")
DISTRIBUTION=$(get_json_value "DISTRIBUTION" "$CONFIG_FILE" "false")
EVENTS=$(get_json_value "EVENTS" "$CONFIG_FILE" "true")
EXEC=$(get_json_value "EXEC" "$CONFIG_FILE" "false")
GRPC=$(get_json_value "GRPC" "$CONFIG_FILE" "false")
IMAGES=$(get_json_value "IMAGES" "$CONFIG_FILE" "false")
INFO=$(get_json_value "INFO" "$CONFIG_FILE" "true")
LOG_LEVEL=$(get_json_value "LOG_LEVEL" "$CONFIG_FILE" "info")
NETWORKS=$(get_json_value "NETWORKS" "$CONFIG_FILE" "false")
NODES=$(get_json_value "NODES" "$CONFIG_FILE" "false")
PING=$(get_json_value "PING" "$CONFIG_FILE" "true")
PLUGINS=$(get_json_value "PLUGINS" "$CONFIG_FILE" "false")
POST=$(get_json_value "POST" "$CONFIG_FILE" "false")
SECRETS=$(get_json_value "SECRETS" "$CONFIG_FILE" "false")
SERVICES=$(get_json_value "SERVICES" "$CONFIG_FILE" "false")
SESSION=$(get_json_value "SESSION" "$CONFIG_FILE" "false")
SOCKET_PATH=$(get_json_value "SOCKET_PATH" "$CONFIG_FILE" "/var/run/docker.sock")
SWARM=$(get_json_value "SWARM" "$CONFIG_FILE" "false")
SYSTEM=$(get_json_value "SYSTEM" "$CONFIG_FILE" "false")
TASKS=$(get_json_value "TASKS" "$CONFIG_FILE" "false")
VERSION=$(get_json_value "VERSION" "$CONFIG_FILE" "false")
VOLUMES=$(get_json_value "VOLUMES" "$CONFIG_FILE" "false")

# Normalize true/false strings to 1/0 for sed
normalize() {
    case "$1" in
        true) echo "true" ;;
        false) echo "false" ;;
        *) echo "$1" ;;
    esac
}

ALLOW_RESTARTS=$(normalize "$ALLOW_RESTARTS")
ALLOW_START=$(normalize "$ALLOW_START")
ALLOW_STOP=$(normalize "$ALLOW_STOP")
AUTH=$(normalize "$AUTH")
BUILD=$(normalize "$BUILD")
COMMIT=$(normalize "$COMMIT")
CONFIGS=$(normalize "$CONFIGS")
CONTAINERS=$(normalize "$CONTAINERS")
DISABLE_IPV6=$(normalize "$DISABLE_IPV6")
DISTRIBUTION=$(normalize "$DISTRIBUTION")
EVENTS=$(normalize "$EVENTS")
EXEC=$(normalize "$EXEC")
GRPC=$(normalize "$GRPC")
IMAGES=$(normalize "$IMAGES")
INFO=$(normalize "$INFO")
NETWORKS=$(normalize "$NETWORKS")
NODES=$(normalize "$NODES")
PING=$(normalize "$PING")
PLUGINS=$(normalize "$PLUGINS")
POST=$(normalize "$POST")
SECRETS=$(normalize "$SECRETS")
SERVICES=$(normalize "$SERVICES")
SESSION=$(normalize "$SESSION")
SWARM=$(normalize "$SWARM")
SYSTEM=$(normalize "$SYSTEM")
TASKS=$(normalize "$TASKS")
VERSION=$(normalize "$VERSION")
VOLUMES=$(normalize "$VOLUMES")

# Generate HAProxy config from template by replacing placeholders
sed \
  -e "s|%%ALLOW_RESTARTS%%|$ALLOW_RESTARTS|g" \
  -e "s|%%ALLOW_START%%|$ALLOW_START|g" \
  -e "s|%%ALLOW_STOP%%|$ALLOW_STOP|g" \
  -e "s|%%AUTH%%|$AUTH|g" \
  -e "s|%%BUILD%%|$BUILD|g" \
  -e "s|%%COMMIT%%|$COMMIT|g" \
  -e "s|%%CONFIGS%%|$CONFIGS|g" \
  -e "s|%%CONTAINERS%%|$CONTAINERS|g" \
  -e "s|%%DISABLE_IPV6%%|$DISABLE_IPV6|g" \
  -e "s|%%DISTRIBUTION%%|$DISTRIBUTION|g" \
  -e "s|%%EVENTS%%|$EVENTS|g" \
  -e "s|%%EXEC%%|$EXEC|g" \
  -e "s|%%GRPC%%|$GRPC|g" \
  -e "s|%%IMAGES%%|$IMAGES|g" \
  -e "s|%%INFO%%|$INFO|g" \
  -e "s|%%LOG_LEVEL%%|$LOG_LEVEL|g" \
  -e "s|%%NETWORKS%%|$NETWORKS|g" \
  -e "s|%%NODES%%|$NODES|g" \
  -e "s|%%PING%%|$PING|g" \
  -e "s|%%PLUGINS%%|$PLUGINS|g" \
  -e "s|%%POST%%|$POST|g" \
  -e "s|%%SECRETS%%|$SECRETS|g" \
  -e "s|%%SERVICES%%|$SERVICES|g" \
  -e "s|%%SESSION%%|$SESSION|g" \
  -e "s|%%SOCKET_PATH%%|$SOCKET_PATH|g" \
  -e "s|%%SWARM%%|$SWARM|g" \
  -e "s|%%SYSTEM%%|$SYSTEM|g" \
  -e "s|%%TASKS%%|$TASKS|g" \
  -e "s|%%VERSION%%|$VERSION|g" \
  -e "s|%%VOLUMES%%|$VOLUMES|g" \
  "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "[INFO] Docker Socket Proxy starting..."
echo "[INFO] HAProxy config generated at $OUTPUT_FILE"
echo "[INFO] Enabled endpoints:"
[ "$CONTAINERS" = "true" ] && echo "  + CONTAINERS"
[ "$INFO" = "true" ] && echo "  + INFO"
[ "$EVENTS" = "true" ] && echo "  + EVENTS"
[ "$PING" = "true" ] && echo "  + PING"
[ "$IMAGES" = "true" ] && echo "  + IMAGES"
[ "$NETWORKS" = "true" ] && echo "  + NETWORKS"
[ "$VOLUMES" = "true" ] && echo "  + VOLUMES"
[ "$SERVICES" = "true" ] && echo "  + SERVICES"
[ "$VERSION" = "true" ] && echo "  + VERSION"
[ "$POST" = "true" ] && echo "  + POST (write operations enabled)"

# Launch HAProxy with the generated config
exec "$@"
