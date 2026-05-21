# Docker Socket Proxy — Documentation

## How it works

The add-on runs the official [HAProxy](https://www.haproxy.org/) image with a custom
configuration that intercepts every Docker API request and allows or denies it based on
the path and HTTP method. The options you set in the Home Assistant UI are converted into
a HAProxy configuration file via a startup script.

```
[Docker client]
      |  TCP :2375
[HAProxy]  ←  strict ACL rules enforced here
      |  Unix socket
[/var/run/docker.sock]
      |
[Docker daemon (host)]
```

### Startup flow

1. The add-on container starts and runs `docker-entrypoint.sh`
2. The script reads your options from `/data/options.json`
3. It uses `sed` to generate a complete HAProxy config from a template
4. HAProxy starts with the generated config
5. All Docker API requests are filtered through ACL rules

## Installation

1. **Add the repository** to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. **Install** the *Docker Socket Proxy* add-on from the store.

3. **Turn off Protection mode** in the add-on's **Info** tab — this is required for the add-on
   to access the Docker socket.

4. **Configure** endpoint access in the **Configuration** tab.

5. **Start** the add-on. You should see output like:
   ```
   [INFO] Docker Socket Proxy starting...
   [INFO] HAProxy config generated at /tmp/haproxy.cfg
   [INFO] Enabled endpoints:
     + CONTAINERS
     + INFO
     + EVENTS
     + PING
   ```

6. **Test** connectivity:
   ```bash
   docker -H tcp://<HA-IP>:2375 version
   ```
   You should see Docker version info (confirming the /version endpoint works if enabled).

## Configuration reference

### Enabled by default

| Option | Docker API path(s) |
|--------|-------------------|
| `CONTAINERS` | `/containers/*` |
| `INFO` | `/info` |
| `EVENTS` | `/events` |
| `PING` | `/_ping` |

### Disabled by default

| Option | Docker API path(s) | Risk level |
|--------|-------------------|-----------|
| `VERSION` | `/version` | Low |
| `IMAGES` | `/images/*` | Low |
| `NETWORKS` | `/networks/*` | Low |
| `VOLUMES` | `/volumes/*` | Low |
| `TASKS` | `/tasks` | Low |
| `DISTRIBUTION` | `/distribution` | Low |
| `NODES` | `/nodes` | Medium |
| `SERVICES` | `/services` | Medium |
| `AUTH` | `/auth` | Medium |
| `BUILD` | `/build` | Medium |
| `COMMIT` | `/commit` | Medium |
| `CONFIGS` | `/configs` | Medium |
| `GRPC` | `/grpc` | Medium |
| `SYSTEM` | `/system` | Medium |
| `POST` | All POST/PUT/DELETE/PATCH | **HIGH** — enables write ops |
| `EXEC` | `/exec/*` | **HIGH** — remote code execution |
| `SECRETS` | `/secrets` | **HIGH** — sensitive data |
| `SESSION` | `/session` | **HIGH** — interactive access |
| `SWARM` | `/swarm` | **HIGH** — cluster control |
| `ALLOW_START` | `/containers/.*/start` | **HIGH** — start containers |
| `ALLOW_STOP` | `/containers/.*/stop` | **HIGH** — stop containers |
| `ALLOW_RESTARTS` | `/containers/.*/restart` `/services/.*/update` | **HIGH** — restart services |

### Key options explained

#### POST (Write operations)

HAProxy distinguishes HTTP methods separately from paths. Enabling `POST` allows POST, PUT,
DELETE, and PATCH requests across *all* allowed endpoints. For example:
- With `CONTAINERS=true` and `POST=false`: clients can only inspect containers and get logs (read-only)
- With `CONTAINERS=true` and `POST=true`: clients can also create, update, and delete containers

Enable `POST` only when a consumer explicitly requires write operations.

#### ALLOW_START / ALLOW_STOP / ALLOW_RESTARTS

These are fine-grained controls for specific container operations:
- `ALLOW_START`: Allow starting stopped containers (`POST /containers/:id/start`)
- `ALLOW_STOP`: Allow stopping running containers (`POST /containers/:id/stop`)
- `ALLOW_RESTARTS`: Allow restarting containers and updating services

These require `CONTAINERS` and/or `SERVICES` to be enabled, and they also require `POST=true`.

#### LOG_LEVEL

HAProxy logging verbosity. Useful values:
- `debug`: Very verbose, includes all requests
- `info`: Normal operation
- `notice`: Important events only
- `warning`: Warnings and errors only

## Port and networking

The proxy listens on TCP port **2375** (configurable in the add-on's **Network** settings).
There is **no TLS** on port 2375 — restrict access at the network level or use a reverse
proxy with TLS termination if needed.

## Connecting clients

### Docker CLI

```bash
DOCKER_HOST=tcp://<HA-IP>:2375 docker ps
```

### Docker Compose

```yaml
services:
  watchtower:
    image: containrrr/watchtower
    environment:
      - DOCKER_HOST=tcp://<HA-IP>:2375
```

### Traefik

```yaml
providers:
  docker:
    endpoint: "tcp://<HA-IP>:2375"
```

## Troubleshooting

| Symptom | Likely cause | Solution |
|---------|-------------|----------|
| "Add-on failed to start" or "Permission denied" | Protection mode is ON | Turn off **Protection mode** in the add-on's **Info** tab and restart |
| Client receives `403 Forbidden` | Endpoint disabled in options | Enable the required endpoint in **Configuration** and restart |
| Client receives `connection refused` | Add-on not running or port blocked | Check add-on is running; verify firewall allows port 2375 |
| Client receives `405 Method Not Allowed` | Write operation attempted but `POST=false` | Enable `POST` in **Configuration** if write access is needed |
| HAProxy won't start | Malformed options.json | Delete the add-on config and reinstall, or check for special characters in `SOCKET_PATH` |

## Architecture

This add-on currently supports **amd64** architecture. The official HAProxy image also supports
`aarch64` (ARM64) and `armv7` (32-bit ARM) — these can be added to `build.yaml` if tested on
those platforms.

## Advanced: Custom socket path

The `SOCKET_PATH` option controls where HAProxy looks for the Docker socket. The default is
`/var/run/docker.sock`, which is correct for standard Docker and Home Assistant OS. Change
this only if you run Docker on a non-standard path.
