# Prometheus Node Exporter — Home Assistant Add-on

Lightweight hardware and OS metrics exporter for Prometheus. Exposes system metrics like CPU, memory, disk, and network usage.

## Features

✅ System metrics export (CPU, memory, disk, network)
✅ Host metrics collection
✅ Prometheus-compatible format
✅ Minimal resource overhead
✅ No configuration needed

## Quick Start

1. Add this repository to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. Install **Prometheus Node Exporter** from the store.

3. Click **Start**. Metrics will be available at `http://<HA-IP>:9100/metrics`.

## Prometheus Integration

Add to your Prometheus config:

```yaml
scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['<HA-IP>:9100']
```

## Metrics

Exposes ~100+ metrics including:

- **CPU**: Usage, context switches, interrupts
- **Memory**: Free, used, cached, buffers
- **Disk**: Read/write operations, I/O time
- **Network**: Bytes sent/received, packet counts
- **System**: Load average, uptime, processes

## Documentation

See [DOCS.md](DOCS.md) for detailed information.

## Support

Report issues at <https://github.com/mattjacobson6/ha-addons/issues>

## Credits

Built on [Prometheus Node Exporter](https://github.com/prometheus/node_exporter).
