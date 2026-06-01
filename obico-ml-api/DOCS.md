# Obico ML — Documentation

## What is Obico ML?

Obico ML is an AI-powered 3D printer failure detection system from
[The Spaghetti Detective](https://github.com/TheSpaghettiDetective). It analyzes
webcam feeds in real-time to detect:

- Print failures and spaghetti (tangled filament)
- Layer adhesion issues
- Nozzle clogs
- Other anomalies

This add-on runs the ML inference server that powers Obico's detection capabilities.

## Installation

1. **Add the repository** to Home Assistant:
   **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   Paste: `https://github.com/mattjacobson6/ha-addons`

2. **Install** the *Obico ML* add-on from the store.

3. **Configure** detection settings (see below).

4. **Start** the add-on. The ML API will be available on port **3333**.

## Configuration

### Detection Interval

The frequency (in seconds) at which the model analyzes webcam frames.
- Lower values = more frequent analysis (more CPU usage, faster detection)
- Higher values = less frequent analysis (lower CPU, potential detection lag)
- Default: **2 seconds**
- Range: 1–30 seconds

### Video Rotation Degree

Rotate the webcam feed before analysis. Useful if your camera is mounted at an angle.
- Options: **0°, 90°, 180°, 270°**
- Default: **0°**

### Log Level

Verbosity of the Obico ML service logs.
- Options: **debug**, **info** (default), **warning**, **error**
- Default: **info**

## API Endpoint

The ML API listens on:
```
http://<HA-IP>:3333
```

Use this endpoint with:
- [Obico Server](https://github.com/TheSpaghettiDetective/obico-server)
- Custom integrations
- Third-party monitoring tools

## Resource Requirements

Obico ML is **CPU and memory intensive** due to real-time ML inference:
- **CPU**: Uses 1-2 cores when analyzing frames
- **Memory**: ~500MB–1GB
- **Storage**: ~2GB (pre-downloaded ML models)

If your HA host has limited resources, increase the **Detection Interval**
to reduce load.

## Troubleshooting

| Symptom | Cause | Solution |
|---------|-------|----------|
| "Port 3333 not responding" | Add-on not running | Check logs and restart |
| High CPU usage | Detection interval too low | Increase Detection Interval in config |
| Out of memory errors | Insufficient host RAM | Free up memory or reduce detection frequency |
| Detection lag | Webcam feed not being analyzed | Lower Detection Interval or improve host performance |

## Architecture Support

- **amd64** (Intel/AMD 64-bit) ✅
- **aarch64** (ARM 64-bit, Raspberry Pi 4+) ✅

## Support

Open an issue at <https://github.com/mattjacobson6/ha-addons/issues>
