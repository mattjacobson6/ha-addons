#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::log.info "Initializing pgAdmin4..."

# Set up pgAdmin configuration directories
mkdir -p /var/lib/pgadmin
mkdir -p /var/log/pgadmin
mkdir -p /pgadmin4/config_local.py

# Set up SSL configuration if enabled
if bashio::config.true 'ssl'; then
    bashio::log.info "SSL is enabled"
    certfile=$(bashio::config 'certfile')
    keyfile=$(bashio::config 'keyfile')

    # Validate that both cert and key are provided
    if [ -z "$certfile" ] || [ -z "$keyfile" ]; then
        bashio::log.warning "SSL enabled but certificate or key not specified"
    fi
fi

# Install any additional system packages if specified
if bashio::config.has_value 'system_packages'; then
    packages=$(bashio::config 'system_packages')
    if [ -n "$packages" ]; then
        bashio::log.info "Installing additional system packages..."
        # Convert array format to space-separated string
        pkg_list=$(echo "$packages" | tr -d '[]"' | sed 's/,/ /g' | sed 's/"//g')
        apk add --no-cache $pkg_list
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
