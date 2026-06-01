# Dozzle Agent — Home Assistant Add-on

Lightweight Docker log viewer and aggregator. View all your Docker container logs in real-time with a clean, simple web interface.

## Features

✅ Real-time Docker log streaming
✅ Multi-architecture support (amd64, aarch64, armhf, armv7)
✅ Lightweight and fast
✅ Simple web UI
✅ Health checks enabled

## Quick Start

1. Add this repository to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. Install **Dozzle Agent** from the store.

3. Click **Start**. The web UI will be available at `http://<HA-IP>:8080`.

## Usage

Once running, access the Dozzle web interface at:
```
http://homeassistant.local:8080
```

Or use your HA host's IP address:
```
http://<HA-IP>:8080
```

## Configuration

- **Log Level**: Set verbosity (debug, info, warn, error) — default: info

## System Requirements

- **CPU**: Minimal (just streaming logs)
- **Memory**: 50–100MB
- **Storage**: Minimal
- **Docker socket access**: Yes (enabled via `docker_api: true`)

## Documentation

See [DOCS.md](DOCS.md) for full configuration and troubleshooting.

## Support

Report issues at <https://github.com/mattjacobson6/ha-addons/issues>

## Credits

Built on the official [Dozzle](https://github.com/amir20/dozzle) project by Amir Raminfar.
