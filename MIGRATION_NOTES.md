# Hawser Agent for Dockhand - Migration Notes

## Source Verification Summary

### Original Repository
- **Source:** https://github.com/Malith-Rukshan/addon-dockhand-hawser
- **Migrated to:** mattjacobson6/ha-addons (dockhand-hawser)
- **Migration Date:** 2026-06-12

## Source Verification Checklist ✅

### Base Images (build.yaml)
All base images are sourced from **official Home Assistant container registry**:
- ✅ **AMD64:** `ghcr.io/home-assistant/amd64-base:latest`
- ✅ **ARM64:** `ghcr.io/home-assistant/aarch64-base:latest`
- ✅ **ARMv7:** `ghcr.io/home-assistant/armv7-base:latest`

**Verification:** These are the official HA base images. No third-party or untrusted images.

### Hawser Binary Source (20-fetch-hawser.sh)
- ✅ **Source:** https://github.com/Finsys/hawser/releases/latest
- ✅ **Download URL:** `https://github.com/Finsys/hawser/releases/download/v{version}/hawser_{version}_linux_{arch}.tar.gz`
- ✅ **Checksum Verification:** SHA256 checksums downloaded and validated
- ✅ **Caching:** Downloaded versions cached in `/data/hawser/{version}/` with older versions pruned

**Verification:** Hawser binary is fetched from official Finsys GitHub releases with SHA256 verification.

### Dockhand Reference
- The addon acts as an agent that connects to Dockhand server (user-configured)
- No hardcoded Dockhand binaries included; only configuration handling
- Two modes supported:
  1. **Edge Mode:** WebSocket connection to user's Dockhand server
  2. **Standard Mode:** Docker API on port 2376 (user configures connection in Dockhand)

## Configuration Sources ✅

### cont-init.d Scripts (Initialization)
1. **10-validate.sh** - Validates required config based on mode
   - Edge mode: requires `dockhand_url` and `token`
   - Standard mode: optional TLS configuration
   - Generates agent UUID if missing
   - Creates stack directory if configured

2. **20-fetch-hawser.sh** - Downloads Hawser binary
   - Resolves latest version from GitHub API
   - Detects system architecture
   - Validates SHA256 checksums
   - Caches binary and prunes old versions

3. **30-render-ingress.sh** - Configures web UI port
   - Substitutes port number in index.html for Standard mode

### services.d Scripts (Running)
1. **hawser/run** - Main Hawser agent service
   - Sets environment variables from config
   - Handles both Edge and Standard modes
   - Manages TLS, token, socket, and stack directory settings

2. **hawser/finish** - Service shutdown handler
   - Logs exit code
   - Signals s6-overlay to halt if needed

3. **ingress/run** - Web UI server (darkhttpd)
   - Serves standard port information page
   - Port 8099 for ingress access

4. **ingress/finish** - Ingress shutdown handler
   - Graceful shutdown

## Configuration Options (config.yaml)

```yaml
Options:
  hawser_version: "0.2.44"      # Hawser binary version
  mode: edge|standard           # Connection mode
  agent_name: ""                # Optional custom agent name
  token: ""                      # Dockhand authentication (required for edge)
  dockhand_url: ""              # Dockhand server URL (required for edge)
  port: 2376                     # Docker API port (standard mode)
  bind_address: "0.0.0.0"       # Bind address (standard mode)
  tls_cert: ""                   # TLS certificate path (optional)
  tls_key: ""                    # TLS key path (optional)
  docker_socket: /var/run/docker.sock   # Docker socket path
  stacks_dir: /data/stacks       # Docker Compose stacks directory
  log_level: info                # Logging level
  skip_df_collection: false      # Disable disk usage collection
```

## Dockerfile Changes

**Original BUILD_REPOSITORY:** `Malith-Rukshan/addon-dockhand-hawser`  
**Updated BUILD_REPOSITORY:** `mattjacobson6/ha-addons`

This ensures Docker image labels correctly reference the new repository location.

## Dependabot Monitoring ✅

Added to `.github/dependabot.yml`:
- Monitors base image updates weekly (Mondays at 05:00 UTC)
- Auto-labels PRs with `dependencies` and `docker` tags
- Assigned to `mattjacobson6` for review

## Security Considerations

1. ✅ **Base Images:** Official HA images from trusted registry
2. ✅ **Binary Verification:** SHA256 checksums validated
3. ✅ **Docker API Access:** Controlled via configuration
4. ✅ **TLS Support:** Optional certificate-based security for Standard mode
5. ✅ **Agent ID:** Unique UUID generated per installation
6. ✅ **Token Storage:** Handled via HA's secure options storage

## Next Steps

1. Push changes to `mattjacobson6/ha-addons`
2. GitHub Actions will build and publish the addon
3. Dependabot will monitor base image updates weekly
4. The addon will appear in Home Assistant add-on store once published

## References

- Original: https://github.com/Malith-Rukshan/addon-dockhand-hawser
- Hawser Releases: https://github.com/Finsys/hawser/releases
- Dockhand: https://dockhand.pro
