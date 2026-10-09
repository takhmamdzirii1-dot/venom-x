# VENOM X — AssettoServer online HUD (v3.10.2)

One auto-downloaded CSP online Lua script for VENOM LA Canyons:

`https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua`

### Functions
- Draggable glass UI and X launcher, Ctrl+Shift+X toggle.
- Teleport destination list and connected human player list; filters out Authentic AI and MNBA traffic.
- Player teleport places your own car approximately **11 m behind** the target's current look direction (when stopped). CSP `physics.setCarPosition()` is used, and a delayed read-back checks whether the car actually arrived before showing the success toast.
- Custom car colors, player/traffic filtering, independently draggable tachometer + speedometer.
- TIME presets: golden sunrise 07:15, daytime 12:00, golden sunset 18:00, blue hour 18:40, night 00:00. Fine tune +/-5 and +/-15 minutes.

### v3.10.2 — Fix teleport facing the wrong way

After teleporting ~11m behind another genuine player's car, use the
**negative of the target's normalized `car.look`** as the facing argument
for `physics.setCarPosition`. This is the convention used by an existing
CSP online teleport-to-car script. Passing `car.look` directly rotates
your car 180 degrees relative to the target. The readback now checks both
distance from the destination and whether the player's final look vector
matches the other car's original heading (`dot >= 0.7`). No success
message is shown when verification fails. Requires a two-player in-game
test to establish success in the current AssettoServer environment.

### v3.10.1 — Restore personal TIME menu controls

TIME slider, Sunrise/Day/Sunset/Blue Hour/Night presets, minute calibration
and Reset to Server are always interactive for **each player independently**.
Selecting a time updates the player's local VENOM X clock display even when
the CSP online Lua API cannot change the visible weather sky. The server clock
is never changed. This is UI selection, **not proof of individual astronomical
sunlight control**, which still depends on runtime CSP permissions.

Presets: sunrise 07:15; midday 12:00; sunset 18:00; blue hour 18:40;
night 00:00. Fine-tune by -15/-5/+5/+15 minutes.
### TIME — no Pure bridge or extra files

This version removes all `venomx.time.*` shared-state hooks, Pure bridge detection, and local helper dependencies. TIME attempts CSP's own `ac.setWeatherTimeOffset()` only, scoped to the local player's weather view. The server clock is **never** modified.

**Important technical limitation:** CSP online-script sandbox and active client weather controller may reject or ignore a per-client time offset. Merely exposing the API function (or returning without error) does **not** prove that the rendered sky, sunlight or moon changed. The UI reports the request result and, if available, live sun/moon elevations from `ac.getSkyFeatureDirection()`. It never adds an artificial brightness/night overlay.

Moon availability depends on CSP/weather controller, track coordinates, simulation date, and lunar position. Moon above horizon is not necessarily visible; no moon texture is faked. Sunlight and reflections are derived from the active weather controller, not directly overridden by this script.

If the CSP client denies the online API, individual real sun changes cannot be guaranteed by this one server-only file. No client ZIP or Pure installation is provided/required.

### Server config

Keep the original `[SCRIPT_...]` section in `cfg/csp_extra_options.ini`; do not rename it. Set `SCRIPT` to the raw URL above; the client downloads the current version upon join.

Set `EnableWeatherFx: true` in AssettoServer `extra_cfg.yml` to enable WeatherFX. Keep six human slots `CAR_0` through `CAR_5` with `AI=none`; place AI traffic cars after those slots with `AI=fixed`. The UI lists only human slots. WeatherFX does not automatically grant a per-client online-script sky override.

For teleports, CSP must permit `physics.setCarPosition` in the script context, and the player must be stopped (<=5 km/h). A successful API call is not automatically treated as a successful teleport: the script verifies resulting position after about 0.7 seconds. Remote-player collision/road geometry or a server-side correction can still cause a teleport to fail.

### Validation
- GitHub source/static checks: passed in model-side inspection.
- **In-game test pending:** individual sun/moon movement, night lighting, and player-to-player teleport need to be tested with at least two genuine player sessions.
