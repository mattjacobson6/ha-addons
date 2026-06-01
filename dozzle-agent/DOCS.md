# Dozzle Agent — Documentation

## What is Dozzle?

Dozzle is a lightweight Docker log viewer that allows you to monitor all your Docker containers' logs in real-time through a simple, elegant web interface. It's perfect for:

- **Debugging**: Quickly see what's happening in your containers
- **Monitoring**: Watch logs as they happen
- **Multi-container**: View logs from all your containers in one place

## Installation

1. **Add the repository** to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. **Install** the *Dozzle Agent* add-on from the store.

3. **Start** the add-on.

4. **Access** the web UI at `http://<HA-IP>:8080`

## Configuration

### Log Level

Controls the verbosity of Dozzle's own logs (not the Docker container logs).

- **debug**: Verbose logging
- **info**: Normal operation (default)
- **warn**: Only warnings and errors
- **error**: Only errors

## Accessing the Web UI

Once running, Dozzle is available at:

```
http://homeassistant.local:8080
```

Or using your HA host's IP:

```
http://192.168.x.x:8080
```

## Features

### View Logs

- **Real-time streaming**: See logs as they're written
- **Search**: Filter logs by keyword
- **Timestamps**: Every log entry shows when it occurred
- **Colors**: Easy-to-read syntax highlighting

### Container Selection

- **All containers**: View logs from all running and stopped containers
- **Filter**: Quickly find the container you're looking for
- **Stats**: See container status at a glance

## Security Notes

- The add-on requires `docker_api: true` to access the Docker socket
- Dozzle has read-only access — it only streams logs, doesn't modify containers
- Restrict access to port 8080 on your network if needed

## Troubleshooting

| Symptom | Cause | Solution |
|---------|-------|----------|
| "Cannot connect to port 8080" | Add-on not running | Check add-on logs and restart |
| No containers showing | Docker socket not mounted | Restart HA after addon starts |
| Logs not updating | Socket permission issue | Restart the add-on |

## Resource Usage

Dozzle is **extremely lightweight**:
- **Memory**: ~50–100MB
- **CPU**: Minimal (only when streaming)
- **Storage**: Minimal

Perfect for resource-constrained systems like Raspberry Pi.

## Support

Report issues at <https://github.com/mattjacobson6/ha-addons/issues>

For Dozzle-specific issues, see <https://github.com/amir20/dozzle/issues>
