# Obico ML — Home Assistant Add-on

AI-powered 3D printer failure detection powered by
[The Spaghetti Detective](https://github.com/TheSpaghettiDetective).

Detects print failures, tangles, and other anomalies in real-time by analyzing your printer's webcam feed.

## Quick Start

1. Add this repository to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. Install **Obico ML** from the store.

3. Wait for the build to complete (ML models are downloaded during build — 5–10 minutes).

4. Configure detection settings in the **Configuration** tab (optional).

5. Click **Start**. The ML API will be available at `http://<HA-IP>:3333`.

## Configuration

- **Detection Interval**: How often to analyze webcam frames (1–30 seconds, default 2s)
- **Video Rotation**: Rotate camera feed before analysis (0°, 90°, 180°, 270°)
- **Log Level**: Service verbosity (debug, info, warning, error)

## Features

✅ Real-time failure detection
✅ Multi-architecture support (amd64, aarch64)
✅ Pre-trained ML models included
✅ Configurable detection frequency
✅ Health checks enabled
✅ CPU and GPU support

## System Requirements

- **CPU**: 1–2 cores for inference (or GPU if available)
- **Memory**: 500MB–1GB
- **Storage**: ~2GB (models included)
- **Host**: HA OS, Supervised, or Container install

## Documentation

See [DOCS.md](DOCS.md) for complete configuration and troubleshooting.

## Support

Report issues at <https://github.com/mattjacobson6/ha-addons/issues>
