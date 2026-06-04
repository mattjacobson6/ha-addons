# cAdvisor — Documentation

## What is cAdvisor?

cAdvisor (Container Advisor) is Google's container monitoring tool that analyzes container resource usage and performance. It collects metrics like:

- CPU usage and limits
- Memory usage and limits
- Disk I/O statistics
- Network statistics
- Network TCP/UDP connections

## Installation

1. Add repository to Home Assistant
2. Install cAdvisor from the store
3. Start the add-on
4. Access at `http://<HA-IP>:8080`

## Web Interface

The cAdvisor dashboard shows:

- **Container list** with current resource usage
- **Performance graphs** showing historical trends
- **Machine metrics** for the host system
- **Docker stats** with real-time data

## API Access

Query metrics programmatically:

```bash
curl http://<HA-IP>:8080/api/
```

## Performance Notes

cAdvisor is lightweight and has minimal overhead. However:

- Monitoring many containers increases CPU/memory usage
- Historical data is kept in memory (not persistent across restarts)
- For long-term metrics storage, use with Prometheus

## Permissions

The add-on requires:
- **Privileged mode**: Access to host kernel metrics
- **Docker API**: Mount to `/var/run/docker.sock`
- **Volume mounts**: System directories for performance analysis

These are enabled automatically via `privileged: true` and `docker_api: true` in the config.

## Prometheus Integration

cAdvisor can export metrics for Prometheus scraping:

```yaml
# In Prometheus config
scrape_configs:
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['<HA-IP>:8080']
    metrics_path: '/metrics'
```

## Troubleshooting

| Symptom | Cause | Solution |
|---------|-------|----------|
| "Port 8080 not responding" | Add-on not running | Check add-on logs and restart |
| No containers listed | Docker socket not accessible | Verify privileged mode is enabled |
| High CPU usage | Too many containers | Increase monitoring interval or filter containers |

## Support

Report issues at <https://github.com/mattjacobson6/ha-addons/issues>

For cAdvisor-specific issues, see <https://github.com/google/cadvisor/issues>
