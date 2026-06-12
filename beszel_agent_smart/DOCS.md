# Beszel Agent (S.M.A.R.T.) for Home Assistant

Monitor your Home Assistant system with Beszel, including **S.M.A.R.T. disk health monitoring**. This add-on runs the Beszel agent with smartmontools and reports stats to your Beszel Hub.

## What it monitors:

- CPU, memory, disk, and network usage
- Home Assistant Add-ons (via Docker API)
- S.M.A.R.T. disk health data
- Historical data with trends

Lightweight design with built-in smartmontools support.

## S.M.A.R.T. Monitoring

This variant includes `smartmontools` for disk health monitoring. The add-on uses `full_access` mode to provide necessary permissions for accessing disk S.M.A.R.T. data. All disk devices are automatically detected and monitored:
- SATA/SAS drives (`/dev/sd*`)
- NVMe drives (`/dev/nvme*`)

No manual configuration required. You need to **disable the Protection mode** to allow the add-on to access disk devices for S.M.A.R.T. data. The add-on automatically provides access to all disk devices and Beszel Agent monitors all drives with S.M.A.R.T. capabilities.

## Watchdog and Healthcheck

This add-on uses two internal ports:

- `45876/tcp` for the Beszel agent
- `45877/tcp` for a lightweight HTTP watchdog endpoint

## Installation and Setup

Add `https://github.com/mattjacobson6/ha-addons` as a custom repository in Home Assistant, then install this add-on from the store.

For Beszel setup, see the [upstream installation guide](https://github.com/vineetchoudhary/home-assistant-beszel-agent/blob/main/docs/INSTALLATION.md).

## Need Help?

- [Report issues on GitHub](https://github.com/mattjacobson6/ha-addons/issues)
- [Check out Beszel docs](https://github.com/henrygd/beszel)
- [Upstream addon source](https://github.com/vineetchoudhary/home-assistant-beszel-agent)

## License

MIT - see [LICENSE](https://github.com/mattjacobson6/ha-addons/blob/main/LICENSE)
