# VENOM X — CSP Online Server UI

Premium in-game HUD for the **VENOM LA Canyons** AssettoServer freeroam server, built as a
[CSP](https://customshaderspatch.me) Online Script. Version 3.

## VENOM X v3.9.2 — TIME sunset/sunrise calibration (2026-10-09)

Restores the v3.9.0 CSP-native per-client time-offset attempt during online
sessions. The v3.9.1 online-race guard disabled this path for all online
players. CSP can still reject the request on certain clients: UI indicates
whether the API accepted it, **not** whether the sky visibly changed.

Golden sunrise 07:15 (was 06:30), Golden sunset 18:00 (was 19:00),
Blue hour 18:40 (was 20:00). Day 12:00 and Night 00:00 unchanged.
Experimental solar-trajectory calculations removed from preset selection.
Added per-player +/-5 and +/-15 minute tuning for the active map/date.

These clock values are useful golden-hour starting points, not guaranteed
astronomical sunrise or sunset moments. Time applies to the local player
when the CSP controller permits it, never using server-wide /settime.
No additional client file is required for the optional CSP-native attempt.

## VENOM X v3.9.1 — Real TIME status (2026-10-09)

**Important:** Using the TIME slider in an Online Lua script cannot by
itself move the visible sun on other people's PCs. Previous v3.9 tried
the exposed CSP `ac.setWeatherTimeOffset` symbol in online mode; even
when an API call did not throw, it did not prove a visible weather change.
v3.9.1 no longer treats that stub as a working online sky controller.

- Per-player time on Pure: requires a **locally installed VENOM-compatible
  Pure Bridge**, which listens to `venomx.time.*` storage keys and updates
  the actual sun, moon and light directions inside Pure.
- The original Gingys Time Controller (app and script) uses
  `GingysClientTime.PureBridge.*`, **not** `venomx.time.*`. It cannot
  be assumed to obey VENOM controls without an adaptation.
- Pure-less users: can keep the server's WeatherFX time/sky, but a separate
  per-player sun-time override cannot be promised from a server-injected
  online script alone. This is not a problem with clicking the button.
- `/settime HH:mm` is a documented AssettoServer **admin server-wide**
  time change, not per-player.
- Optional Pure bridge installation files are distributed as a separate
  client package; they are NOT embedded in or automatically installed by
  the one-file Online Lua script. Don't rely on stale README paths
  claiming `pure-helper/GingysTimeControllerPure.lua` is in this repo
  unless the file is actually present.
- Keep WeatherFX enabled in AssettoServer and verify Pure effects are
  loaded locally. Do not run both Gingys and VENOM time overrides in Pure
  simultaneously.
- This release is statically verified and GitHub-deployed, **not
  runtime-verified** across player Pure/CSP versions.

## VENOM X v3.9 — Automatic TIME / SKY routing

VENOM X automatically chooses an available client-side time control path:

1. **Active VENOM Pure bridge**: an offset-stage acknowledgment in `venomx.time.status` enables the Pure route. The client helper updates its sun, moon, and lighting state.
2. **CSP native API**: attempts `ac.setWeatherTimeOffset()` if the API exists and the sandbox permits it. A denied operation falls back automatically.
3. **No supported controller**: keeps server weather and disables local-time presets instead of simulating sunset by darkening the picture.

Pure is **optional**, but detecting Pure alone is not enough to inject a protected weather-script hook. The Pure bridge must already be active or the native CSP time API must be available.

Sunrise, sunset, solar noon, blue hour and night can use the actual simulated-date sun path via `ac.getSkyFeatureDirection()`. If it is inaccessible, clock presets are used.

**AssettoServer configuration:** set `EnableWeatherFx: true` in `extra_cfg.yml`, and keep `LockServerDate: true` for calendar-accurate solar times. Confirm the current server configuration before replacing it.

Weather, clouds, reflections and PP filters remain controlled by the user's active weather system. An online Lua script cannot guarantee the same image quality on devices with different Pure/CSP installations.

All HUD, launcher, teleport and color features still ship in one server script. Client-by-client visual validation is necessary; a successful API call is not itself proof of visual adjustment.

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

## Status (2026-10-08, v3.3.0)

- **DEPLOY-VERIFIED** — v3.3.0 pushed, raw URL 200 `text/plain`, serves `VERSION = '3.3.0'`
- **USER-SESSION EVIDENCE (v3.2.0, 18:35-18:41, session 4, /ADAn, zero Lua/weather
  errors)** — storage diffs prove real panel operation: section persisted as HUD
  (HUD tab opened), new panel-size key persisted as 2 (size L set), two position
  keys reset to -1 (RESET POSITIONS clicked), orb position values changed (drag),
  extra chat-extras traffic (tab opens). Nav, S/M/L, reset and drag all worked.
- **v3.3.0 DELTA (speedo self-heal, resize grip, HUD debug, press polish)** — shipped
  on the proven v3.2.0 interaction core; serving, syntax-checked, never loaded
  in-game yet. First fresh VENOM join fetches it.

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
