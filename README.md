# VENOM X — AssettoServer online HUD (v3.14.0)

One auto-downloaded CSP online Lua script for VENOM LA Canyons:

`https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua`

### Functions
- Draggable glass UI and X launcher, Ctrl+Shift+X toggle.
- Teleport destination list and connected human player list; filters out Authentic AI and MNBA traffic.
- Player teleport places your own car approximately **11 m behind** the target's current look direction (at any driving speed). CSP `physics.setCarPosition()` is used, and a delayed read-back checks whether the car actually arrived before showing the success toast.
- Custom car colors, player/traffic filtering, independently draggable tachometer + speedometer.
- TIME presets: golden sunrise 07:15, daytime 12:00, golden sunset 18:00, blue hour 18:40, night 00:00. Fine tune +/-5 and +/-15 minutes.

### v3.14.0 — Compact CMRT-inspired telemetry and session cache priority fix

The previously tall circular tachometer was replaced by a small horizontal
CMRT-inspired layout drawn **entirely with VENOM X CSP vector primitives**:
oblong obsidian pill, large gear indicator on the left, RPM progression LEDs
along the top, readable KM/H and RPM values side by side, a right-side
percent ring, and a low-height fuel / remaining-laps strip. The percent ring
shows the car's **ERS/KERS charge** where `kersPresent` and `kersCharge`
exist; regular non-KERS cars use remaining fuel percent instead. Remaining
laps use `fuel/fuelPerLap` when available, or '--' if missing. No CMRT files,
fonts, or art are copied into VENOM X and players install nothing. All
existing HUD show/hide, draggable position, scale 80–130%, opacity and
speed smoothing features remain. Colors match the VENOM crimson theme.

**Actual cache regression fixed:** The pre-teleport snapshot was formerly
prioritized above `state.sessionOptions`. A second teleport could therefore
replace a pinned setup with already-reset switches. Now `sessionOptions`
takes priority until the user intentionally presses **SAVE CURRENT SETUP**;
subsequent jumps, including external Map/CM jumps, must use the saved state.
A bounded mismatch-check continues throughout the current gameplay
session rather than stopping after 4.5 seconds. This is still best-effort
and **cannot access wing/door animation internal Lua state** that a specific
car mod keeps separately from Extra A-J.

**TIME:** v3.13 original v2 Companion channel + native weather API fallback
remain unchanged. Historical v1 only read the server time; v2 used an
existing local Companion, and v3 stored bridge keys. If no client controller
is present in the online CSP Lua context, no server-only command can
force genuinely separate sky time for each player. Buttons continue to
work for personal clock selection but the physical sky is unverified.

Validation performed: archive Lua/manifest read, historical GitHub
source comparison, static regression checks. No actual CSP/Assetto
Corsa rendering or physical sky-time test was possible here.

### v3.13.0 — VENOM visual identity, legacy v2 time compatibility, in-session option memory

**Theme:** The entire panel, dock and speedometer now use a matched
obsidian-black / ivory-white / crimson-red design inspired by VENOM:
higher-contrast native DWrite labels, sharper branding, cleaner headings,
red navigation indicators and matching hover colors. No external fonts
or texture assets need to be installed.

**TIME:** Git history confirms that original v2.0 used a shared-memory
Companion with `ac.connect(..., ac.SharedNamespace.Shared)`, commands
`cmdOffset/cmdInstant/cmdSeq`, a heartbeat `beat` and acknowledgements.
The v3.x system later switched to `ac.store()` keys and a Pure bridge.
v3.13 restores the original v2 protocol as **automatic optional
backward compatibility**, using its exact field layout. The script uses
the channel only when a fresh heartbeat from the already-running
Companion is present and reports the command acknowledgement. If that
Companion is missing or CSP disallows both the bridge and native setter,
the personal slider remains a local clock preview: it cannot change the
actual sky. **No Pure requirement, no extra download and no shared
server clock adjustment.** Preset sunrise remains 07:15, sunset 18:00.

**Extras / wing / doors:** The desired Extra A-J, headlights, beams,
turn-signal and hazard flag values are now pinned as a **session-only
snapshot** on teleport and used by both internal teleports and external
map/Car Jump detectors. Restoration no longer stops after 4.5 seconds:
a rate-limited check every 2.5 seconds retries observable flag mismatches
throughout the game session. A long-lived CSP Car Jump event Disposable
is held so that garbage collection doesn't silently unsubscribe it.
The PLAYERS and CREW pages now have **SAVE CURRENT SETUP** controls:
use these after intentionally changing wings/doors/extras once the
cache is pinned, so it will preserve the new arrangement instead.
Switch values are not saved across leaving the game, respawning with
a different car model, or sessions.

**Important limitation:** A car mod can implement wing/door animation
using private Lua variables, geometry nodes or action-only button events.
These internal mod states are not recoverable from `car.extraA..extraJ`
flags alone. This is a best-effort generic preservation system, not a
guarantee for every car. No wholesale car reset, repair or state wipe is
added. Live in-game testing remains necessary.

### v3.12.0 — Horizontal frosted-glass quick dock and extra J preservation

- VENOM X logo (left click) shows/hides the QUICK DOCK, rather than opening the large menu; right click opens the full panel. The standalone MENU icon opens the complete panel, and Ctrl+Shift+X still works.
- Dock is OPEN on first entry in this version. A new local preference key replaces the old dock toggle so legacy hidden state does not unexpectedly hide the redesigned strip.
- Eight actions stay in ONE horizontal row: MAP, CREW, TIME, PAINT, LIGHT, HAZ, HUD and MENU, with adaptive tile widths.
- Real native CSP transparent tool window background, low-opacity idle style, high-contrast hover reveal, spring-like ease-out fade/slide entrance and exit, and persistent visibility.
- Expanded car-switch snapshots from Extra A-F to **Extra A-J**. Added a low-beam state fallback where CSP has no independent high-beams flag.
- Added guarded `ac.onCarJumped` event and a large-position-jump detector using the previous frame's car switch state to cover teleports made from **external Content Manager/map**, not just VENOM X buttons. Restoration still depends on online scripting API access and the specific car mod.
- Existing behind-player 11m, orientation matching, no-stop restriction, momentum clearing, status reporting and conditional recovery remain.

**Known TIME limitation:** Initial v3.6/v3.7 local sky logic relied on a client Pure/WeatherFX bridge; those revisions did not provide reliable standalone per-player sky time from the server script. Current CSP online Lua in the reported session does not expose `ac.setWeatherTimeOffset`, so this version preserves the user's private clock chooser and accurate requested time but cannot truthfully promise actual independent sunrise/night, regardless of preset values. The configured sunrise/sunset values are 07:15 and 18:00. No automatic shared server time changes are issued.

**QA:** GitHub source/static checks passed. An actual Assetto Corsa+CSP session is needed to verify UI render transparency, delayed car control restoration and any sky behavior. For missing extras, read the per-teleport diagnostic in PLAYERS/CREW.

### v3.11.2 — All teleport types use preservation

Friends, configured places, available server destinations and Pits now use
the same optional car switch and lighting preservation logic. State is
checked again over up to 4.5 seconds, with completion after repeated
clean checks from at least 2.4 seconds.

CSP may refuse some restoration APIs. The PLAYERS and CREW menus expose
the state after teleporting.

Individual sky time remains unavailable in an online script when the
client CSP does not expose the required API. The selected interface
clock does not imply the sun actually changed.

### v3.11.1 — Late car control reset restoration

Previous implementation tried restoring A-F, headlights, beams and hazards
after only 0.10 and 0.34 seconds, then destroyed the pendingTeleport
record around 0.7s. Car physics/scripts can reset options later, so
the restore logic ended too early. This update separates `optionsRestore`
from `pendingTeleport`, starts the snapshot before issuing a jump, and
conditionally retries control mismatches for up to 3.5 seconds. It finishes
early after multiple clean checks only after at least 1.4 seconds to
avoid overriding subsequent driver input indefinitely.

The actual outcome is now displayed as `CAR CONTROLS` on the PLAYERS tab
and `Car switches` in the CREW popup, including mismatch counts, denied
calls and unavailable APIs. CSP extra switch flags like HOLD_MODE or
STATIONARY_ONLY, custom car scripts, and online permissions may still block
full restoration; no claim of guaranteed extra persistence is made.

TIME result now explicitly reads `UNAVAILABLE IN ONLINE SCRIPT` if
`ac.setWeatherTimeOffset()` isn't available. Per-player clock presets
still change a local interface selection, **not the actual sun** in
this case. No global weather or server time changes are made.

### v3.11.0 — Native quick-action icon dock, no full menu required

The launcher X now has a premium dark-glass contextual quick dock with
eight hand-drawn vector icons and real clickable hitboxes:

- MAP opens a compact destination chooser with Return to Pits.
- CREW shows up to six real drivers and teleports behind a selected one.
- TIME exposes a personal clock slider and all five presets.
- PAINT provides 12 one-click car colors plus original livery.
- LIGHT toggles headlights; HAZ toggles hazards directly.
- HUD toggles the speedometer directly; MENU opens the full app.

The bar uses one row on desktops and two rows on narrow screens. It is
anchored to the draggable X, hides when the main menu is open, and can
be toggled with **right-click on X**. Its visibility persists locally.
All flyouts are native CSP tool windows with no extra installation.

The TIME slider now reads the requested target rather than a lagging
animation intermediate (avoids tug-of-war while dragging). Preset values
are unchanged: sunrise 07:15, midday 12:00, sunset 18:00, blue 18:40,
night 00:00. Critical limitation: CSP online Lua does not expose the
weather-time setter on all clients, and a clock preview cannot force
the actual personal sun position. When blocked, the quick TIME flyout
explicitly says **SKY LOCKED / CLOCK PREVIEW ONLY**.

Also checks for a false return from the teleport-to-position API.
Existing car switch preservation, steering alignment, 11 m positioning
and velocity reset are retained. In-game verification is still required
for visual quick-toolbar interaction and live physics.
### v3.10.4 — Keep controls and modifications after teleport

Before teleport, capture the local vehicle's **Extra A-F switch states**,
headlight state, high beams, turn signals and hazard lights. For up to two
short post-teleport checks (roughly 0.1s and 0.34s), only restore a state
**if the new state differs** and that CSP setter is available in this online
script. Do not toggle these controls unconditionally; many cars use extras
for custom modes, and one-shot controls might react to being set again.
Preservation is best effort since some scripts can independently change
these states or forbid write access from an online script.

**No reset/repair calls are issued** by the teleport command. Existing body,
tyre, suspension and engine damage should be left to the game and car
physics. Targeted *only damaged part* repair is not implemented; the
car-physics APIs and their permissions differ by vehicle/CSP build, and
blindly applying a global repair could erase unrelated damage or toggles.

All per-player TIME controls, HUD, color, genuine player filtering, and
11m-behind/heading checks remain unchanged. In-game verification is still
needed using a car with extras and hazards activated before teleport.
### v3.10.3 — Teleport while moving

Removed the local driver's 5 km/h speed gate. Teleport behind a genuine
human player now works from the menu regardless of the teleporter's
current speed, subject to normal CSP permission/position checks.
After moving, the script zeroes the car's previous velocity when that
physics API is available. This prevents carrying high-speed momentum
to the destination; car position and facing verification remain in place.
Real two-player runtime verification is still required.

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

For teleports, CSP must permit `physics.setCarPosition` in the script context, and the player does not need to stop before teleporting. A successful API call is not automatically treated as a successful teleport: the script verifies resulting position after about 0.7 seconds. Remote-player collision/road geometry or a server-side correction can still cause a teleport to fail.

### Validation
- GitHub source/static checks: passed in model-side inspection.
- **In-game test pending:** individual sun/moon movement, night lighting, and player-to-player teleport need to be tested with at least two genuine player sessions.
