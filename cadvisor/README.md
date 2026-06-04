# cAdvisor — Home Assistant Add-on

Google's Container Advisor for analyzing container resource usage and performance characteristics. Collects, aggregates, and exports container metrics.

## Features

✅ Real-time container metrics collection
✅ Resource usage analysis (CPU, memory, disk, network)
✅ Web UI dashboard on port 8080
✅ REST API for metrics queries
✅ Historical data tracking

## Quick Start

1. Add this repository to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. Install **cAdvisor** from the store.

3. Click **Start**. The web UI will be available at `http://<HA-IP>:8080`.

## Access

- **Web UI**: `http://<HA-IP>:8080/`
- **Metrics API**: `http://<HA-IP>:8080/api/`

## Documentation

See [DOCS.md](DOCS.md) for detailed information.

## Support

Report issues at <https://github.com/mattjacobson6/ha-addons/issues>

## Credits

Built on [Google's cAdvisor](https://github.com/google/cadvisor).
