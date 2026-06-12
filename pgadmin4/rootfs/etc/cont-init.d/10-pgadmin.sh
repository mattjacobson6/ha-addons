#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::log.info "Initializing pgAdmin4..."

# Set up pgAdmin configuration directory
mkdir -p /var/lib/pgadmin
mkdir -p /var/log/pgadmin

# Install any additional system packages if specified
if bashio::config.has_value 'system_packages'; then
    packages=$(bashio::config 'system_packages')
    if [ -n "$packages" ]; then
        bashio::log.info "Installing additional system packages..."
        apk add --no-cache $(echo "$packages" | tr -d '[]"' | sed 's/,/ /g')
    fi
fi

# Run any initialization commands if specified
if bashio::config.has_value 'init_commands'; then
    commands=$(bashio::config 'init_commands')
    if [ -n "$commands" ]; then
        bashio::log.info "Running initialization commands..."
        echo "$commands" | while read -r cmd; do
            if [ -n "$cmd" ]; then
                bashio::log.info "Running: $cmd"
                eval "$cmd"
            fi
        done
    fi
fi

bashio::log.info "pgAdmin4 initialization complete"
