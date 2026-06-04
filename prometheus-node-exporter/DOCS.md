# Prometheus Node Exporter — Documentation

## What is Node Exporter?

Node Exporter is Prometheus's official tool for collecting hardware and OS metrics from Unix-like systems. It exposes:

- CPU statistics (usage, context switches)
- Memory stats (free, used, cached)
- Disk I/O metrics (read/write operations)
- Network statistics (bytes/packets sent/received)
- System info (load average, uptime, processes)
- And 100+ other metrics

## Installation

1. Add repository to Home Assistant
2. Install Prometheus Node Exporter from the store
3. Start the add-on
4. Access metrics at `http://<HA-IP>:9100/metrics`

## Prometheus Configuration

Add to your `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'home_assistant'
    static_configs:
      - targets: ['<HA-IP>:9100']
    scrape_interval: 15s
```

Then restart Prometheus to begin collecting metrics.

## Grafana Dashboards

Popular pre-made dashboards for Node Exporter metrics:

- **Dashboard ID 1860**: "Node Exporter for Prometheus" (very comprehensive)
- **Dashboard ID 3662**: "Prometheus node Exporter Server Metrics for Grafana"
- **Dashboard ID 8919**: "Node Exporter Full"

Import these in Grafana: **Dashboards → Import** → Paste ID → Load

## Metrics Examples

### CPU Metrics
```
node_cpu_seconds_total{mode="user"}
node_cpu_seconds_total{mode="system"}
node_cpu_seconds_total{mode="idle"}
```

### Memory Metrics
```
node_memory_MemFree_bytes
node_memory_MemAvailable_bytes
node_memory_MemTotal_bytes
```

### Disk Metrics
```
node_disk_reads_completed_total
node_disk_writes_completed_total
node_filesystem_avail_bytes
```

### Network Metrics
```
node_network_receive_bytes_total
node_network_transmit_bytes_total
node_network_receive_packets_total
```

## Performance

Node Exporter is extremely lightweight:
- **Memory**: ~10-15MB
- **CPU**: Minimal (only on scrape requests)
- **Disk**: No persistent storage

Perfect for resource-constrained systems.

## Troubleshooting

| Symptom | Cause | Solution |
|---------|-------|----------|
| Metrics endpoint not responding | Add-on not running | Check add-on logs, restart |
| Prometheus can't scrape | Network connectivity | Verify IP/port, check firewall |
| Missing metrics | Collector disabled | Check Node Exporter logs |

## Advanced: Customizing Collectors

By default, Node Exporter enables most collectors. To disable specific collectors, you can modify startup options (future enhancement).

Common collectors:
- `cpu`, `meminfo`, `diskstats` - always enabled
- `systemd` - system service metrics
- `processes` - process-level metrics
- `netdev` - network interface metrics

## Support

Report issues at <https://github.com/mattjacobson6/ha-addons/issues>

For Node Exporter-specific issues, see <https://github.com/prometheus/node_exporter/issues>
