# ZMK Config

## Hardware

### Sofle v1

- `NRF52840` bluetooth
- nice!view v2 OLED.

Current firmware info:

```
UF2 Bootloader 0.6.0 lib/nrfx (v2.0.0) lib/tinyusb (0.10.1-41-gdf0cda2d) lib/uf2 (remotes/origin/configupdate-9-gadbb8c7)
Model: nice!nano
Board-ID: nRF52840-nicenano
SoftDevice: S140 version 6.1.1
Date: Jun 19 2021
```

## Flashing

- Download `firmware.zip` from GitHub Actions
- Extract `firmware.zip`
- Flash one half at a time (flash the left half first and test it over USB):
    - Put the half into bootloader mode by double-clicking reset on the back
    - Plug in USB, a `NICENANO` volume should appear
    - Copy the matching file to the volume (`*left*.uf2` or `*right*.uf2`)
    - Wait for the volume to unmount automatically
- Power off both halves
- Power both halves back on to let them pair

If a half stops working, flash `*settings_reset*.uf2` first, then flash that half again.

## Local build

Build firmware with the same ZMK container used by GitHub Actions:

```sh
make
```

Generated UF2 files are written to `./build/artifacts`.
