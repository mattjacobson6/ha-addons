# pgAdmin4 for Home Assistant

A PostgreSQL database management and administration web interface for Home Assistant.

## Features

- **Web UI:** Manage PostgreSQL databases, users, tables, and queries through a web interface
- **Ingress Support:** Access pgAdmin4 directly from Home Assistant sidebar
- **SSL/TLS:** Optional HTTPS support with custom certificates
- **PostgreSQL Tools:** Includes pg_dump, pg_restore, and psql utilities for PostgreSQL 12-17
- **Multi-Architecture:** Supports amd64, aarch64, armv7, and i386

## Installation

1. Add this repository to Home Assistant:
   ```
   https://github.com/mattjacobson6/ha-addons
   ```

2. Install "pgAdmin4" from the add-ons store

3. Configure the options as needed (see Configuration section)

4. Start the addon

## Configuration

### Basic Options

- **SSL:** Enable HTTPS support (recommended for security)
- **SSL Certificate File:** Path to fullchain certificate (relative to /ssl)
- **SSL Private Key File:** Path to private key (relative to /ssl)

### Advanced Options

- **System Packages:** Additional Alpine Linux packages to install at startup
- **Initialization Commands:** Custom shell commands to run during startup
- **Leave Front Door Open:** Disable password authentication (testing only)

## Usage

### Accessing pgAdmin4

1. Click the pgAdmin4 addon from the Home Assistant sidebar (Ingress)
2. Or navigate to `http://[HA_IP]:80` (if Ingress not available)

### Connecting to Databases

1. In pgAdmin4, go to "Servers" and add a new server
2. Configure connection:
   - **Host:** Database server IP or hostname
   - **Port:** 5432 (PostgreSQL default)
   - **Username:** Database user
   - **Password:** Database password
3. Click "Save"

## Supported PostgreSQL Versions

The addon includes client tools for PostgreSQL:
- 12, 13, 14, 15, 16, 17

## Image Sources

- **Base Image:** `ghcr.io/hassio-addons/base:*` (Official Home Assistant base images)
- **pgAdmin4:** Installed via Python package manager (official package)
- **PostgreSQL Tools:** Official `postgres:*-alpine` Docker images

All image sources are official and trusted.

## Security Notes

- **SSL:** Use the built-in SSL support for encrypted connections
- **Password:** Always set a strong password in pgAdmin4 settings
- **Access Control:** Restrict network access using Home Assistant's firewall
- **Front Door:** Leave "Front Door" disabled in production

## Troubleshooting

### Connection Refused

Check that:
1. The PostgreSQL server is running and accessible
2. The hostname/IP is correct
3. The port is correct (usually 5432)
4. Firewall rules allow connection

### SSL Certificate Errors

1. Ensure certificate and key files exist in `/ssl`
2. Verify file paths are correct (relative to /ssl)
3. Restart the addon after updating files

## Links

- [pgAdmin4 Official](https://www.pgadmin.org/)
- [pgAdmin4 Documentation](https://www.pgadmin.org/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Repository](https://github.com/mattjacobson6/ha-addons)
