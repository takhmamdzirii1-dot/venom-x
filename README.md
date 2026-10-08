# VENOM X — CSP Online Server UI

Premium in-game UI for the **VENOM LA Canyons** AssettoServer freeroam server, built as a
[CSP](https://customshaderspatch.me) Online Script.

## Features

- **Speedometer HUD** — speed (KM/H), gear (R/N/1–9), RPM + RPM bar, auto-appears on join, toggleable, settings persist per client
- **Control panel** — opens from the CSP lightbulb menu (tool window, 6 tabs):
  - **HOME** — server info, connected count, server time, your speed, Return to Pits
  - **TELEPORT** — all 36 server teleport destinations, grouped (Main Ring / La Canada / Tujunga Rd / Angeles Forest HWY / Angeles Crest / Mountain Wilson), heading-aware
  - **PLAYERS** — live list of connected drivers with distance and car model; click to teleport your car 10 m behind them (speed check + 2.5 s cooldown + disconnect-safe)
  - **CAR** — current color swatch (read-only), built-in CSP color-changer guide, Headlights / High Beams toggles
  - **TIME** — live read-only server clock
  - **HUD** — speedometer / RPM bar toggles (persisted)

## Requirements

- Custom Shaders Patch (CSP) on the client (developed against CSP 0.3.0-preview62x Lua SDK)
- Server: AssettoServer with CSP extras enabled (`csp_extra_options.ini` containing a `[SCRIPT_VENOM_X]` section pointing at the raw Lua URL below)

## Install (server side)

Add to `cfg/csp_extra_options.ini` (keep your existing `[TELEPORT_DESTINATIONS]` and `[CUSTOM_COLOR]` sections):

```ini
[SCRIPT_VENOM_X]
SCRIPT=https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua
REQUIRED = 0
REFRESH_PERIOD = 0
DISPLAY_NAME = VENOM LA Canyons
DISPLAY_SUB = LA Canyons Freeroam

POINT_0 = Main Pits
POINT_0_GROUP = Main Ring
POINT_0_POS = -326.06, 161.18, -2926.84
POINT_0_HEADING = 0
; ... mirror every POINT_n / POINT_n_GROUP / POINT_n_POS / POINT_n_HEADING
; from [TELEPORT_DESTINATIONS] so the script can read them via ac.configValues()
```

And on the human player slots in `cfg/entry_list.ini`, append `/ADAn` to `SKIN` (allows the built-in CSP color changer + teleportation), e.g.:

```ini
SKIN=02_gt_silver_metallic/ADAn
```

## Script URL

```
https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua
```

Public repo, unauthenticated direct access — every joining CSP client downloads it automatically.

## Notes

- Online scripts run sandboxed (no file writes, no admin access); only the local player's own car (index 0) is ever modified
- Local time override is **not possible** from a CSP Online Script (`ac.setWeatherTimeOffset` is app-script/offline-only); server time is shown read-only
- Car paint cannot be set from Lua; the built-in CSP color picker is enabled server-side instead
- If the GitHub account or default branch ever changes, update `SCRIPT` in `[SCRIPT_VENOM_X]` accordingly
