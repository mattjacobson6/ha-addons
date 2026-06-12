#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::log.info "Initializing pgAdmin4..."

# Ensure persistent data directory exists
mkdir -p /data/pgadmin4
mkdir -p /data/pgadmin4/sessions
mkdir -p /data/pgadmin4/storage
mkdir -p /var/log/pgadmin

# Write config_distro.py (always regenerated so config changes take effect)
cat << EOF > /pgadmin4/config_distro.py
CA_FILE = '/etc/ssl/certs/ca-certificates.crt'
LOG_FILE = '/dev/null'
HELP_PATH = '../../docs'
DEFAULT_BINARY_PATHS = {'pg': '/usr/local/pgsql-17'}
SQLITE_PATH = '/data/pgadmin4/pgadmin4.db'
SESSION_DB_PATH = '/data/pgadmin4/sessions'
STORAGE_DIR = '/data/pgadmin4/storage'
EOF

# Append any PGADMIN_CONFIG_* env vars to config_distro.py
for var in $(env | grep PGADMIN_CONFIG_ | cut -d "=" -f 1); do
    echo "${var#PGADMIN_CONFIG_} = $(eval "echo \$$var")" >> /pgadmin4/config_distro.py
done

# Set up SSL configuration if enabled
if bashio::config.true 'ssl'; then
    bashio::log.info "SSL is enabled"
fi

# Install any additional system packages if specified
if bashio::config.has_value 'system_packages'; then
    for pkg in $(bashio::config 'system_packages'); do
        bashio::log.info "Installing system package: ${pkg}"
        apk add --no-cache "${pkg}"
    done
fi

# Run any initialization commands if specified
if bashio::config.has_value 'init_commands'; then
    bashio::log.info "Running initialization commands..."
    while IFS= read -r cmd; do
        if [ -n "$cmd" ]; then
            bashio::log.info "Running: $cmd"
            eval "$cmd"
        fi
    done <<< "$(bashio::config 'init_commands')"
fi

# Initialize the database on first launch
if [ ! -f /data/pgadmin4/pgadmin4.db ]; then
    bashio::log.info "First launch — initializing pgAdmin4 database..."

    export PGADMIN_DEFAULT_EMAIL
    export PGADMIN_DEFAULT_PASSWORD
    PGADMIN_DEFAULT_EMAIL=$(bashio::config 'pgadmin_default_email')
    PGADMIN_DEFAULT_PASSWORD=$(bashio::config 'pgadmin_default_password')

    cd /pgadmin4 || exit 1
    /venv/bin/python3 run_pgadmin.py || bashio::exit.nok "Failed to initialize pgAdmin4 database"

    bashio::log.info "Database initialized successfully"
fi

bashio::log.info "pgAdmin4 initialization complete"
