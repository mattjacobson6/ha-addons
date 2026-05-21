#!/usr/bin/env bash
set -e

CONFIG=/data/options.json

# Convert a JSON boolean option to the 1/0 format linuxserver expects
bool_opt() {
    local val
    val=$(jq -r ".$1" "$CONFIG")
    [[ "$val" == "true" ]] && echo 1 || echo 0
}

# Map HA addon options -> linuxserver socket-proxy environment variables
export CONTAINERS=$(bool_opt containers)
export INFO=$(bool_opt info)
export EVENTS=$(bool_opt events)
export PING=$(bool_opt ping)
export AUTH=$(bool_opt auth)
export BUILD=$(bool_opt build)
export COMMIT=$(bool_opt commit)
export CONFIGS=$(bool_opt configs)
export DISTRIBUTION=$(bool_opt distribution)
export EXEC=$(bool_opt exec)
export GRPC=$(bool_opt grpc)
export IMAGES=$(bool_opt images)
export NETWORKS=$(bool_opt networks)
export NODES=$(bool_opt nodes)
export PLUGINS=$(bool_opt plugins)
export POST=$(bool_opt post)
export SECRETS=$(bool_opt secrets)
export SERVICES=$(bool_opt services)
export SESSION=$(bool_opt session)
export SWARM=$(bool_opt swarm)
export SYSTEM=$(bool_opt system)
export TASKS=$(bool_opt tasks)
export VOLUMES=$(bool_opt volumes)

# Verify the Docker socket was mounted (requires docker_api: true in config.yaml)
if [ ! -S /var/run/docker.sock ]; then
    echo "[ERROR] /var/run/docker.sock not found."
    echo "[ERROR] Ensure 'docker_api: true' is set in config.yaml and the add-on is rebuilt."
    exit 1
fi

echo "[INFO] Docker Socket Proxy starting — enabled endpoints:"
[ "$CONTAINERS"  = "1" ] && echo "  + CONTAINERS"
[ "$INFO"        = "1" ] && echo "  + INFO"
[ "$EVENTS"      = "1" ] && echo "  + EVENTS"
[ "$PING"        = "1" ] && echo "  + PING"
[ "$AUTH"        = "1" ] && echo "  + AUTH"
[ "$BUILD"       = "1" ] && echo "  + BUILD"
[ "$COMMIT"      = "1" ] && echo "  + COMMIT"
[ "$CONFIGS"     = "1" ] && echo "  + CONFIGS"
[ "$DISTRIBUTION"= "1" ] && echo "  + DISTRIBUTION"
[ "$EXEC"        = "1" ] && echo "  + EXEC"
[ "$GRPC"        = "1" ] && echo "  + GRPC"
[ "$IMAGES"      = "1" ] && echo "  + IMAGES"
[ "$NETWORKS"    = "1" ] && echo "  + NETWORKS"
[ "$NODES"       = "1" ] && echo "  + NODES"
[ "$PLUGINS"     = "1" ] && echo "  + PLUGINS"
[ "$POST"        = "1" ] && echo "  + POST  (write operations enabled)"
[ "$SECRETS"     = "1" ] && echo "  + SECRETS"
[ "$SERVICES"    = "1" ] && echo "  + SERVICES"
[ "$SESSION"     = "1" ] && echo "  + SESSION"
[ "$SWARM"       = "1" ] && echo "  + SWARM"
[ "$SYSTEM"      = "1" ] && echo "  + SYSTEM"
[ "$TASKS"       = "1" ] && echo "  + TASKS"
[ "$VOLUMES"     = "1" ] && echo "  + VOLUMES"

# Hand off to linuxserver's s6-overlay init; environment is inherited
exec /init
