# Docker Socket Proxy — Home Assistant Add-on

A secure Docker socket proxy for Home Assistant, based on the official [HAProxy](https://www.haproxy.org/)
image. The proxy sits between the Docker daemon and any client that needs Docker API access,
enforcing a per-endpoint allowlist so you never expose more than your tools actually need.

## Why?

Giving a container direct access to `/var/run/docker.sock` is equivalent to giving it root
on the host. The socket proxy lets you grant fine-grained read-only (or limited write)
access instead. This add-on uses HAProxy to enforce strict ACLs on every Docker API request.

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

3. **IMPORTANT:** Go to the add-on **Info** tab and turn off **Protection mode**.

4. Configure which API endpoints to expose in the **Configuration** tab.

5. Click **Start**. Port **2375** is now available on the HA host.

6. Point your Docker client at `tcp://homeassistant.local:2375` (or the IP of your HA host).

## Security notes

- **Protection mode must be OFF** for the add-on to access the Docker socket.
- Keep `POST` disabled unless a consumer explicitly needs write operations.
- `EXEC`, `SECRETS`, `SESSION`, and `SWARM` are particularly dangerous — leave them off
  unless you fully understand the risks.
- Restrict network access to port 2375 to trusted hosts only (firewall or VLAN).
- The add-on uses the official HAProxy Docker image with a strict default-deny policy.

## Support

Open an issue at <https://github.com/mattjacobson6/ha-addons/issues>.
