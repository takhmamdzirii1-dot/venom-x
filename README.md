# VENOM X — CSP Online Server UI

Premium in-game HUD for the **VENOM LA Canyons** AssettoServer freeroam server, built as a
[CSP](https://customshaderspatch.me) Online Script. Version 3.

## What's new in V3

- **Floating orb + expanding glass panel** — a small draggable orb snaps to either screen
  edge; a short click expands a 360×500 glass panel (never fullscreen) with animated
  open/close, draggable header, close button, and animated nav underline
- **Custom nav**: HOME / TP / PLAYERS / COLOR / TIME / HUD
- **Custom toasts** — top-center queue, slide + fade, OK/WARN accent bar, pulse on the orb
- **TIME section with a real local time mechanism** — the sky/lighting time-of-day can be
  shifted locally (client-side visual only) with a free-running clock display, a scrub
  slider, 7 presets (DAWN…MIDNIGHT), live offset readout and RESET TO SERVER
- **HSV color control** — full `ui.colorPicker` (hue bar) plus 12 named swatches, applied
  on release through `shared/sim/chat` (`canChangeCarColor` / `changeCarColor`), with
  reset-to-livery and honest fallbacks when the module or server permission is missing
- **Traffic-free player list** — filters on `sessionID` (human slots 0–5), AI flag,
  `TRAFFIC` name prefix and traffic model IDs; never lists AI traffic
- **Native teleports** — destination list prefers the server chat API
  (`teleportDestinations`), falls back to config `POINT_n` points; grouped, searchable;
  driver-to-driver teleport behind their car with cooldown and speed gate
- **Speedometer** — smoothed speed/RPM, gear, RPM bar with accent→warn→danger gradient,
  draggable, opacity/scale controls, all persisted per client via `ac.storage`
- **Emergency fallback** — if the HUD ever errors 3 times, a tabbed V1-style tool window
  appears in the CSP lightbulb menu so controls are never lost

## How local TIME works (and why it needs a helper)

Online scripts are sandboxed: CSP documents `ac.setWeatherTimeOffset` /
`setLightDirection` etc. as offline-only or app-only, so the online script cannot move
the sky itself. VENOM X therefore uses a **client-render bridge**:

```
VENOM X online script                Pure weather script (client side)
  ac.store('venomx.time.enabled')  ──►  reads the bridge every frame
  ac.store('venomx.time.offsetHours')
  ac.store('venomx.time.heartbeat')
                                       ac.getSkyFeatureDirection(feature, nil,
                                         sim.timestamp + offset) → sun/moon/light
                                         direction override inside Pure's pipeline
  ◄── ac.store('venomx.time.status')    restores Pure state when idle or stale
      ac.store('venomx.time.applied')
```

Only **your own screen** changes; the server, the sim state and other players are never
touched. Status is measured, not assumed: the TIME section displays the helper's actual
status (`offset-ready` / `offset-idle` / `offset-applied` / `hook-missing`) and offers
INSTALL when the helper is absent.

The helper drops into Pure's official test hook (`extension/weather/pure/test_ground/
test_ground.lua`, dofile'd by Pure's `weather.lua` — zero Pure file modifications) and is
adapted from the local **Gingys Time Controller** project
(`pure-helper/GingysTimeControllerPure.lua`), which proved this override mechanism.

### Install (each client, optional)

1. Download `VENOM_X_Client.zip` from the repo
2. Drag it into Content Manager's main window (CM extracts into the AC root folder),
   or manually place the file at
   `<Assetto Corsa>\extension\weather\pure\test_ground\test_ground.lua`
3. Restart Assetto Corsa — requires the **Pure** weather script (pureCtrl controller)

Without the helper, TIME still shows the server clock and every other feature works.

## Server install

Already configured on the live server. Reference only:

- `cfg/csp_extra_options.ini` keeps its existing section header **`[SCRIPT_...]`** (do not
  rename it) with `SCRIPT = 'https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua'`,
  plus the mirrored `POINT_n` keys, `[TELEPORT_DESTINATIONS]` and `[CUSTOM_COLOR] ALLOW_EVERYWHERE = 1`
- `REFRESH_PERIOD = 30` (ms) — V3 writes the time bridge every update tick
- `cfg/entry_list.ini`: human slots CAR_0–CAR_5 have `/ADAn` appended to `SKIN`;
  CAR_6+ (AI traffic) must never get `/ADAn`
- `cfg/extra_cfg.yml`: `NamePrefix: TRAFFIC` — used by the player filter

## Script URL

```
https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua
```

Public repo, unauthenticated direct access — every joining CSP client downloads it
automatically (served as `text/plain`).

## Requirements

- Custom Shaders Patch (CSP) on the client (built against the current CSP Lua SDK
  definitions: online-script HUD, `ac.storage`/`ac.store`, `shared/sim/chat`)
- Server: AssettoServer with CSP extras enabled
- TIME helper: Pure weather script (pureCtrl / Pure classic; not Pure LCS)

## Notes

- Online scripts run sandboxed (no file writes, no admin access); only the local player's
  own car (index 0) is ever modified
- Server time, weather and `/settime` are never touched — local time is client-visual only
  and reports its own measured status
- If the GitHub account or default branch ever changes, update `SCRIPT` in `[SCRIPT_...]`
  accordingly

## Status (2026-10-08)

- **DEPLOY-VERIFIED** — raw URL returns 200 `text/plain`, SHA256 matches the local file
- **RUNTIME-VERIFIED** — two local sessions plus one remote client (public IP) joined the
  live AssettoServer: the V3 script was fetched in every session with **zero Lua errors**
  in the CSP log; `ac.storage` persisted across restarts; `shared/sim/chat` init fired per
  session; the HSV color picker worked end-to-end (change → `car_colors.ini` persisted);
  the helper sits at Pure's guarded test hook and loaded under active Pure classic with
  no weather errors
- **PENDING** — teleport click outcome, player-list/HUD visuals, and the live TIME
  sun-shift effect (helper loads clean; the shift is only observable after an in-game
  TIME interaction)

## Status (2026-10-08, v3.1.0)

- **DEPLOY-VERIFIED** — v3.1.0 pushed, raw URL 200 `text/plain`, serves `VERSION = '3.1.0'`
- **RUNTIME-PARTIAL** — one real online session (session 4, /ADAn): script fetched,
  "Loading is finished", **zero Lua errors**; `shared/sim/chat` init fired; storage
  saved (orb position values changed = drag input received); helper present at the
  guarded Pure hook with no weather errors
- **NOT VISUALLY CONFIRMED** — orb/speedometer on screen, panel open/close, drag
  smoothness, teleport clicks, color re-test, player list, and all five TIME presets
  (Sunrise/Day/Sunset/Blue Hour/Night). Reason: the machine was in active use
  (Discord/Chrome foreground, live cursor) so no in-game clicks or screenshots of the
  game UI were possible without hijacking the session. Color/teleport/filter/bridge
  code paths are byte-identical to the v3.0.0 paths proven end-to-end on 2026-10-08.
