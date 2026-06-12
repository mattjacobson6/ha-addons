# Hawser Agent for Dockhand

Bridges Home Assistant's Docker to a Dockhand server. Manages containers, images, networks, volumes, and Compose stacks remotely via Dockhand's web dashboard.

## Features

- **Dual Mode Operation:**
  - **Edge Mode:** WebSocket-based connection to Dockhand server (recommended)
  - **Standard Mode:** Direct Docker API access via HTTP/HTTPS on port 2376

- **Docker Management:** Full control over containers, images, networks, volumes, and Compose stacks

- **Ingress UI:** Quick access status panel showing Hawser agent status and connection info

- **Security:**
  - Unique agent ID per installation (auto-generated UUID)
  - Optional TLS for Standard mode
  - Token-based authentication (Dockhand)
  - Docker socket access control

## Installation

1. Add this repository to Home Assistant:
   ```
   https://github.com/mattjacobson6/ha-addons
   ```

2. Install "Hawser Agent for Dockhand"

3. Configure based on your Dockhand setup (see below)

## Configuration

### Edge Mode (Recommended)

For WebSocket-based connection to your Dockhand server:

```yaml
mode: edge
dockhand_url: wss://your-dockhand-instance.com/api/hawser/connect
token: <agent-token-from-dockhand>
```

**Settings:**
- `hawser_version` - Hawser agent version (default: 0.2.44)
- `agent_name` - Custom agent name (optional, defaults to hostname)
- `docker_socket` - Path to Docker socket (default: /var/run/docker.sock)
- `stacks_dir` - Docker Compose stacks directory (default: /data/stacks)
- `log_level` - Logging level: debug|info|warn|error (default: info)
- `skip_df_collection` - Disable disk usage collection (default: false)

### Standard Mode

For direct Docker API access (HTTP/HTTPS):

```yaml
mode: standard
port: 2376
bind_address: 0.0.0.0
# Optional TLS
tls_cert: /ssl/certs/mycert.crt
tls_key: /ssl/certs/mykey.key
```

Then in Dockhand, add the host at: `http://<home-assistant-ip>:2376`

## Supported Architectures

- ✅ Intel/AMD (amd64)
- ✅ ARM 64-bit (aarch64)
- ✅ ARM 32-bit (armv7)

## Architecture

This addon uses:
- **Base Image:** Official Home Assistant Alpine base images (`ghcr.io/home-assistant/*-base:latest`)
- **Hawser Binary:** Downloaded from [Finsys/hawser](https://github.com/Finsys/hawser/releases) with SHA256 verification
- **Init System:** s6-overlay for service management
- **Web Server:** darkhttpd for ingress UI

## Security Notes

- SHA256 checksums are verified for Hawser binary downloads
- Unique agent ID is generated and persisted per installation
- TLS certificates are optional but recommended for Standard mode
- All configuration is stored in Home Assistant's secure options storage
- Token is only sent to your configured Dockhand instance

## Logs

Check the addon logs to verify:
- Hawser version resolution and download
- Connection status (Edge or Standard mode)
- Agent ID and name
- Any configuration errors

## Troubleshooting

### Hawser fails to start
- Check logs for configuration errors
- Verify Edge mode has both `dockhand_url` and `token` configured
- Verify Standard mode TLS config (cert and key must both be present or both absent)

### Binary download fails
- Check network connectivity
- Verify GitHub API is accessible
- Check available disk space in `/data/`

### Connection issues
- **Edge Mode:** Verify WebSocket URL and token are correct
- **Standard Mode:** Verify port 2376 is not blocked

## Links

- [Dockhand Dashboard](https://dockhand.pro)
- [Hawser Releases](https://github.com/Finsys/hawser/releases)
- [Repository](https://github.com/mattjacobson6/ha-addons)
