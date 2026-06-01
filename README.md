# Home Assistant Add-ons

A collection of Home Assistant add-ons for Docker management and 3D printer monitoring.

## Add-ons Included

### 🐳 [Docker Socket Proxy](docker-socket-proxy/)

Secure proxy for Docker daemon access. Grants fine-grained API permissions to containers without exposing the raw socket.

- **Features:** Per-endpoint access control, default-deny security posture, healthchecks, multi-arch
- **Port:** 2375 (TCP)
- **Architectures:** amd64

### 🤖 [Obico ML](obico-ml-api/)

AI-powered 3D printer failure detection using real-time webcam analysis.

- **Features:** Real-time failure detection, CPU/GPU support, pre-trained models, healthchecks
- **Port:** 3333 (REST API)
- **Architectures:** amd64, aarch64

## Installation

1. Add this repository to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. Install the desired add-on from the store

3. Configure and start

## Repository Info

- **Maintainer:** [mattjacobson6](https://github.com/mattjacobson6)
- **License:** MIT
- **Issues:** [GitHub Issues](https://github.com/mattjacobson6/ha-addons/issues)

## Automatic Updates

This repository uses **Dependabot** to automatically monitor base images and dependencies for security updates. Pull requests are created automatically when updates are available.

## License

All add-ons in this repository are licensed under the MIT License. See [LICENSE](LICENSE) for details.
