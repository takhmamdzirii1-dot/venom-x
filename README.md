# VENOM X — CSP Online Server UI

Premium in-game HUD for the **VENOM LA Canyons** AssettoServer freeroam server, built as a
[CSP](https://customshaderspatch.me) Online Script. Version 2.

## What's new in V2

- **Custom glass HUD** — always-on quick menu (top-left, draggable, collapsible), expanded
  section panel (draggable, closeable), redesigned speedometer, custom auto-dismiss toast
  queue (top-center), all animated with a dark glass / blue-accent theme
- **Quick menu sections**: HOME / TELEPORT / PLAYERS / COLOR / TIME / HUD
- **Real car color picker** — swatches + RGB sliders applied through `shared/sim/chat`
  extras (`canChangeCarColor` / `changeCarColor`), synced to other players, with a
  reset-to-livery button and honest fallback to the built-in CSP picker if the module is
  unavailable
- **AI-proof player list** — filters on `sessionID` (human slots 0–5 only), AI flag,
  `TRAFFIC` name prefix, traffic model IDs; never lists AI traffic
- **Native teleports** — destination list prefers the server chat API
  (`teleportDestinations` + `teleportTo`), falls back to config points + physics
- **TIME section** — live server clock, local day/night presets (08:00 / 12:00 / 18:00 /
  22:00), ±12 h shift slider and reset, driven through the companion app below and
  **measured live** (the panel reports APPLIED / NO EFFECT / NO COMPANION — it never
  assumes success)
- **HUD settings** — speedometer + RPM bar toggles, opacity and scale sliders, position
  reset; everything persists per client via `ac.storage`
- **Emergency fallback** — if the custom HUD ever errors 3 times, a tabbed V1-style tool
  window appears in the CSP lightbulb menu so controls are never lost

## Companion app (local day/night)

CSP exposes `ac.setWeatherTimeOffset` only to app scripts (documented **offline-only**),
never to online scripts, so VENOM X ships a tiny silent companion:

```
VENOM_X_Client/
  manifest.ini           (LAZY = NONE — loads with AC, runs silently)
  VENOM_X_Client.lua     (applies time shifts from the online script via ac.connect shared struct)
```

### Install (each client, optional)

1. Download the repo (or `VENOM_X_Client.zip` if present)
2. Copy the `VENOM_X_Client` folder into `Assetto Corsa/content/lua/apps/`
3. Restart Assetto Corsa — the app appears in the CSP apps list with a status window

Without the companion the TIME section still shows the server clock and reports
`Companion: NOT INSTALLED` — everything else works. Because CSP documents the time API as
offline-only, the online script measures the real result after every shift and displays
the truth (APPLIED with measured seconds, or NO EFFECT).

## Server install

Already configured on the live server. Reference only:

- `cfg/csp_extra_options.ini` keeps its existing section header **`[SCRIPT_...]`** (do not
  rename it) with `SCRIPT = 'https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua'`,
  plus the mirrored `POINT_n` keys, `[TELEPORT_DESTINATIONS]` and `[CUSTOM_COLOR] ALLOW_EVERYWHERE = 1`
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
  definitions: online-script HUD, `ac.connect` shared structs, `shared/sim/chat`)
- Server: AssettoServer with CSP extras enabled

## Notes

- Online scripts run sandboxed (no file writes, no admin access); only the local player's
  own car (index 0) is ever modified
- Server time, weather and `/settime` are never touched — local time is client-visual only
  and reports its own measured effect
- If the GitHub account or default branch ever changes, update `SCRIPT` in `[SCRIPT_...]`
  accordingly
