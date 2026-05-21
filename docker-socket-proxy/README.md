# Docker Socket Proxy — Home Assistant Add-on

Wraps [linuxserver/socket-proxy](https://github.com/linuxserver/docker-socket-proxy) as a
trusted Home Assistant add-on. The proxy sits between the Docker daemon and any client that
needs Docker API access, enforcing a per-endpoint allowlist so you never expose more than
your tools actually need.

## Why?

Giving a container direct access to `/var/run/docker.sock` is equivalent to giving it root
on the host. The socket proxy lets you grant fine-grained read-only (or limited write)
access instead.

## Typical consumers

| Tool | Minimum endpoints required |
|------|---------------------------|
| Watchtower | `CONTAINERS`, `IMAGES`, `POST` |
| Portainer Agent | `CONTAINERS`, `EVENTS`, `INFO`, `NETWORKS`, `VOLUMES` |
| Traefik | `CONTAINERS`, `NETWORKS`, `EVENTS` |
| cAdvisor | `CONTAINERS`, `INFO`, `EVENTS` |

## Quick start

1. Add this repository to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. Install **Docker Socket Proxy** from the store.

3. Configure which API endpoints to expose in the add-on **Configuration** tab.

4. Start the add-on. Port **2375** is now available on the HA host.

5. Point your Docker client at `tcp://homeassistant.local:2375` (or the IP of your HA host).

## Security notes

- Keep `POST` disabled unless a consumer explicitly needs write access.
- `SECRETS`, `EXEC`, `SESSION`, and `SWARM` are particularly dangerous — leave them off
  unless you understand the implications.
- Restrict network access to port 2375 to trusted hosts only (firewall or VLAN).
- The add-on requires `docker_api: true`, which mounts the raw Docker socket
  (`/var/run/docker.sock`) inside the container.

## Support

Open an issue at <https://github.com/mattjacobson6/ha-addons/issues>.
