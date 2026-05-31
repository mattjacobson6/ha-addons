# Obico ML API

Runs the Obico ML failure detection API server as a Home Assistant addon.
Built directly from the official [Obico server](https://github.com/TheSpaghettiDetective/obico-server) release branch — no third-party pre-built images.

Used as the AI backend for [BamBuddy](https://github.com/maziggy/bambuddy)'s built-in failure detection feature.

## How it works

While a print is running, BamBuddy periodically sends camera snapshots to this addon at port 3333. The Obico YOLO model analyses each frame and returns a failure confidence score. BamBuddy smooths scores over time and triggers your configured action (notify / pause / cut power) when a threshold is crossed.

## Configuration

| Option | Description |
|---|---|
| `ml_api_token` | Authentication token. Set the same value in BamBuddy → Settings → Failure Detection. Default: `obico_api_secret` — change to something unique. |

## BamBuddy setup

In BamBuddy → Settings → Failure Detection:
- **ML API URL**: `http://192.168.0.2:3333`
- **ML API Token**: whatever you set above

## Updating

To update to a newer Obico release: rebuild the addon image from the HA addon store. The Dockerfile always pulls from the `release` branch tip.

## Notes

- amd64 only (x86 HA installs). The Obico ML model requires a capable CPU — not suitable for Raspberry Pi.
- The addon exposes port 3333 on the HA host. It is LAN-only; do not expose this port externally.
- No data leaves your network. All inference is local.
