# Docker Socket Proxy — Documentation

## How it works

The add-on runs [linuxserver/socket-proxy](https://github.com/linuxserver/docker-socket-proxy)
inside a Home Assistant container. That image uses HAProxy to intercept every Docker API
request and allow or deny it based on the path and HTTP method, controlled by environment
variables that map 1-to-1 to the options you set in the HA UI.

```
[Docker client]
      |  TCP :2375
[socket-proxy / HAProxy]  ←  allowlist enforced here
      |  Unix socket
[/var/run/docker.sock]
      |
[Docker daemon (host)]
```

## Installation

1. **Add the repository** to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   URL: `https://github.com/mattjacobson6/ha-addons`

2. **Install** the *Docker Socket Proxy* add-on from the store.

3. **Configure** endpoint access (see below) in the *Configuration* tab.

4. **Start** the add-on. If everything is working you will see a line like:
   ```
   [INFO] Docker Socket Proxy starting — enabled endpoints:
     + CONTAINERS
     + INFO
   ```

5. **Test** connectivity from another container or machine:
   ```bash
   docker -H tcp://<HA-IP>:2375 version
   ```

## Configuration reference

All options are boolean (`true` / `false`).

### Enabled by default

| Option | Docker API path(s) |
|--------|--------------------|
| `containers` | `/containers/*` |
| `info` | `/info` |
| `events` | `/events` |
| `ping` | `/_ping` |

### Disabled by default (enable only what you need)

| Option | Docker API path(s) | Risk |
|--------|--------------------|------|
| `images` | `/images/*` | Low |
| `networks` | `/networks/*` | Low |
| `volumes` | `/volumes/*` | Low |
| `services` | `/services` | Medium |
| `tasks` | `/tasks` | Low |
| `distribution` | `/distribution` | Low |
| `post` | All POST/DELETE methods | **High** — enables writes |
| `auth` | `/auth` | Medium |
| `build` | `/build` | Medium |
| `commit` | `/commit` | Medium |
| `configs` | `/configs` | Medium |
| `exec` | `/exec/*` | **High** — remote code execution |
| `grpc` | `/grpc` | Medium |
| `nodes` | `/nodes` | Medium (Swarm) |
| `plugins` | `/plugins` | Medium |
| `secrets` | `/secrets` | **High** — exposes sensitive data |
| `services` | `/services` | Medium (Swarm) |
| `session` | `/session` | **High** |
| `swarm` | `/swarm` | **High** (Swarm) |
| `system` | `/system` | Medium |

### The `post` option

HAProxy distinguishes HTTP methods separately from paths. Setting `post: true` enables
**POST, PUT, DELETE, and PATCH** requests across *all* allowed endpoints. Without it,
clients can only issue GET and HEAD (read-only). Enable `post` only when a consumer
explicitly requires write operations (e.g. Watchtower pulling and restarting containers).

## Port

The proxy listens on TCP port **2375** (configurable from the *Network* tab in the
add-on settings). There is no TLS on port 2375 — restrict access at the firewall or
use a reverse proxy with TLS termination if you need encryption in transit.

## Connecting clients

```bash
# Docker CLI
DOCKER_HOST=tcp://<HA-IP>:2375 docker ps

# Compose override
services:
  watchtower:
    environment:
      - DOCKER_HOST=tcp://<HA-IP>:2375
```

For Traefik, set:
```yaml
providers:
  docker:
    endpoint: "tcp://<HA-IP>:2375"
```

## Troubleshooting

| Symptom | Likely cause |
|---------|-------------|
| `[ERROR] /var/run/docker.sock not found` | `docker_api: true` missing from config.yaml or add-on not rebuilt after a config change |
| Client receives `403 Forbidden` | The requested endpoint is disabled in the add-on options |
| Client receives `connection refused` | Add-on not running, or port 2375 is blocked by firewall |
| Client receives `405 Method Not Allowed` | Write operation attempted but `post` is `false` |

## Architecture

This add-on only supports **amd64** at this time. ARM builds (`aarch64`, `armv7`) can be
added to `build.yaml` once tested — the upstream `lscr.io/linuxserver/socket-proxy` image
is multi-arch.
