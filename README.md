# VENOM X — AssettoServer online HUD (v3.25.0)

One auto-downloaded CSP online Lua script for VENOM LA Canyons:

`https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/VENOM_X.lua`

### v3.25.0 — Arabic-first UX and typography consistency

- Arabic-first navigation, quick controls, time presets, ghost controls, player
  teleport, car colors, HUD settings and recovery notices. Protocol strings,
  car model IDs, Lua event keys and debug logs remain in their original form.
- Windows-native **Segoe UI Bold (weight 700)** remains the shared interface
  font, without bundling files or requiring any installation by players. The
  original official logo stays unchanged above the virtual mirror.
- Small-screen-safe labels, higher contrast for secondary text, wrapped hints,
  and shorter GHOST/TIME/recovery status descriptions. Full technical statuses
  remain available on hover for diagnostics; no success is claimed until the
  server acknowledgement arrives.
- Fixed a previously duplicated `presetBlue` localization key: blue car paint
  and the 18:40 blue-hour time preset now have separate labels.
- No change to personal TIME, GHOST network/physics, options persistence,
  teleport algorithms, logo placement, or server DLL in this UI-only release.
- CI parses the CSP Lua script and executes regression tests; **Arabic shaping
  and layout still need an in-game screenshot check on a real CSP client**.

### Functions
- Draggable glass UI and X launcher, Ctrl+Shift+X toggle.
- Teleport destination list and connected human player list; filters out Authentic AI and MNBA traffic.
- Player teleport places your own car approximately **11 m behind** the target's current look direction (at any driving speed). CSP `physics.setCarPosition()` is used, and a delayed read-back checks whether the car actually arrived before showing the success toast.
- Custom car colors, player/traffic filtering, independently draggable tachometer + speedometer.
- TIME presets: golden sunrise 07:15, daytime 12:00, golden sunset 18:00, blue hour 18:40, night 00:00. Fine tune +/-5 and +/-15 minutes.

### v3.24.0 — GHOST server relay hotfix (mandatory Plugin DLL update)

**Important:** v3.21.0 client-only ghost synchronization was insufficient for
AssettoServer 0.0.54: CSP Online Lua sends `$CSP0` chat-framed events, and
the server does not decode and forward that payload automatically as native
OnlineEvents. A client could display "GHOST ON" without the other driver
receiving the opt-in state.

**Fixed with a paired Lua + .NET server plugin update:**

- `VENOM_X.lua` sends its `VENOMX_Ghost_v1` boolean OnlineEvent as before,
  but now requires the **real server-generated ACK** (sender=nil on CSP).
  Without it, shows WAITING/NOT ACTIVE and asks to update the server DLL
  rather than falsely claiming that other players are collision-free.
- The existing `VenomPersonalTimePlugin.dll` now handles a validated ghost
  `$CSP0` packet AND the standard native-event path. It authenticates the
  player's session from their TCP connection, broadcasts a *native*
  OnlineEvent to connected clients, returns a server ACK to the requester,
  sends snapshots to late joiners and clears GHOST when a player leaves.
- TIME and GHOST emissions share the server's 1-second chat packet limit.
  Missing ghost ACKs trigger bounded automatic retries.
- GHOST disables only remote **human** car colliders (not local/AI indices).
  Both cars still use the same VENOM X script delivered automatically.
  Remote physics control requires CSP 0.2.8 or newer.
- **Players install nothing.** The server owner must install the newly built
  plugin DLL and restart AssettoServer; installing Lua only will not work.

Installation: download **VENOM-Personal-Time-net8** from
the successful workflow run at
https://github.com/takhmamdzirii1-dot/venom-x/actions/runs/37955197006,
extract and replace
`plugins/VenomPersonalTimePlugin/VenomPersonalTimePlugin.dll`,
retain the existing `EnablePlugins`, `EnableWeatherFx`,
`EnableClientMessages` configuration, and restart the server.
The server downloads the latest `VENOM_X.lua` from the existing URL.
The plugin name/folder and TIME settings have not changed.

Expected in startup logs:
`[VENOM GHOST] Relay enabled; ghost event=0x9BC418C2`
and when a user toggles ghost
`[VENOM GHOST] N -> True, sent to connected peers`.
VENOM UI should say `GHOST ON / SERVER CONFIRMED` after a real ACK.

CI built the .NET 8 plugin against AssettoServer v0.0.54 and passed
CSP0 ON/OFF decoding, TIME transport and the real Lua regression suite.
**Two-player in-game collision behavior still requires a live test.**

### v3.23.0 — One-click real TIME with exact presets and automatic retry

The former TIME UI derived an offset from CSP's `timeTotalSeconds`, then
used a later copy of the same mutable clock to reconstruct an absolute
timestamp. If the WeatherFX plugin changed that clock between those
operations, the first button press could select an incorrect hour.

AssettoServer v0.0.54.26 also hard-drops chat packets received less than
1,000 ms after the last one. The VENOMX_SetTime request uses CSP's
chat-encoded `$CSP0` transport; another TIME slider change or CSP event
could block the command without generating a plugin ACK.

**Fixed in v3.23.0 Lua only:**
- Presets pass their exact absolute day-seconds directly; the target does
  not depend on the mutable current WeatherFX time.
- Both TIME sliders and +/-15/+/-5 minute controls use exact target seconds.
- The TIME readout follows the selected clock forward from the click.
- Rapid changes are coalesced, with a 340ms slider debounce and at least
  1.35s spacing between chat-transmitted time requests.
- If no server ACK arrives after 2.1s, retry automatically with the exact
  same requested time, up to 3 bounded retries; a genuinely failed action
  still shows a clear error instead of silently requiring a second click.
- The selected absolute target is persisted across Lua reloads. Old stored
  relative-offset entries are migrated when loaded.
- The .NET time plugin DLL, collision modes, teleport protection and
  vehicle option-saving code remain unchanged.

Automated GitHub Actions run the actual Lua time bridge in Fengari with
simulated CSP clocks and dropped/late messages. Tests passed for one-click
midnight, 12:00 after a prior custom time, final slider value, 1-second
rate-limiting, automatic retries and stale ACK suppression.

The code passes automated tests; in-game first-click behavior must still
be verified with a real client and AssettoServer.

### v3.22.0 — Smart teleport protection + Unstuck recovery

- A successful VENOM teleport to a map destination, another player or
  the pits starts a **temporary local-car collision shield**.
  External CSP/map teleports are detected by jump callbacks or unusual
  position changes and get the same shield when supported.
- While the shield is active, calls
  `physics.disableCarCollisions(0, true)` for this client and restores
  `false` automatically. Minimum grace period: 3s; if any connected
  car (players or AI) is within 12 metres, delays release, with a hard
  14s deadline to avoid permanent no-collision mode.
  This temporary shield does not alter the manual GHOST opt-in or remote
  player collision state.
- The new **UNSTUCK / RECOVER** action is available from HOME, the
  TELEPORT page and the MAP quick menu. It returns the player's own
  car to the last locally observed upright, low-speed (<=45 km/h),
  non-crowded checkpoint after repeated stable samples. Captures pause
  for 11s after teleport, avoid inverted cars and stop points close
  to traffic. This is a heuristic checkpoint, NOT a guarantee that the
  location is legal track/drivable pavement.
- If a valid checkpoint is missing, the first click asks for confirmation
  and the second click within 4s returns to configured pits instead.
  If the player is moving over 30 km/h, recovering likewise requires
  a second confirmation. Recovery has a 12s cooldown and preserves
  the existing Extra A-J auto-restore.
- If CSP does not expose the local collision API, the shield reports
  UNAVAILABLE instead of pretending to protect the user. An observed
  teleport can also fail in the game despite an accepted command:
  actual in-game validation is still required. Never attempt to disable
  collisions permanently or infer road surfaces from position alone.
- Lua syntax tests and the existing car-options and Ghost tests all
  passed; production Lua shield/recovery helpers are executed in a
  separate regression suite covering min/max duration, nearby traffic,
  checkpoint sampling, cooldown and confirmation.

### v3.21.0 — Opt-in GHOST MODE: player-vs-player collisions

- New `GHOST` instant toggle in the quick dock and a clearly labelled
  on/off button on the HOME page. OFF by default; user preference persists.
- Uses CSP `physics.disableCarCollisions(remoteHuman.index, disabled)`
  **only for connected real remote players**, never index 0 (own car)
  or AI traffic. Local car still has physical traffic, environment and walls.
- In v3.24.0, the `VENOMX_Ghost_v1` event is relayed by the updated
  server-side VENOM plugin, rather than assuming client-only rebroadcast.
  On each client, a human remote collider is disabled whenever either
  the local player OR the remote driver has ghost enabled.
- A state heartbeat every 5 seconds synchronizes late joiners; the remote
  state expires after 16 seconds if the peer stops advertising.
- Requires CSP 0.2.8 (build 3424) or newer for remote-car collision API,
  an updated server-side VENOM Personal Time + Ghost DLL (v3.24.0), and
  server-delivered VENOM X Lua. Players still need no client-side installation.
- Does not promise an authoritative server-side no-collision system for
  older CSP clients or clients without the online script. Verify with
  two online drivers that they can pass through without collision; the
  automated checks only simulate physics calls and peer events.

CI verifies real Lua syntax, preservation of TIME/teleports/extra options,
and executes the ghost-mode Lua functions to test on/off, peer states,
late joins, AI exclusion and minimum CSP version.

### v3.20.3 — Automatic car options persistence during teleport

- Fixes a Lua truthiness bug that silently discarded every readable `false`
  switch value. Now captures and restores both `true` and `false`
  for Extras A–J, headlights, beams, hazard lights and indicators.
- Supports CSP switch properties returning numeric 0/1.
- VENOM player teleport, map/destination teleport, chat-API teleport and
  return to pits take a **fresh live snapshot before moving**. New changes
  immediately before pressing TP take priority over stale cached settings.
- Does not learn temporary reset values while a restore is already in progress.
- Keeps automatic switch restoration active for at least five seconds after
  moving, up to eleven seconds for mismatch recovery; a subsequent car-jump
  callback extends the guard within a bounded deadline.
- Preserves previously implemented external/map jump monitoring and 10-switch
  diagnostic feedback; does not change the separately working server personal
  TIME plugin or VENOM branding/other tools.

Automated CI runs a Lua interpreter against the **actual source helpers** and
passed tests for false/true preservation, 16-state cache roundtrips,
last-minute driver changes, late-reset protection, and bounded stable release.
This cannot prove a car mod accepts `ac.setExtraSwitch` online: validate in
game using a modded car and inspect `CAR CONTROLS` diagnostics on any mismatch.

### v3.20.2 — Remove legacy visual sky filters

After confirmed in-game physical sky changes using the server plugin,
VENOM X removes the obsolete local VISUAL SKY screen tint and CSP color
correction effects entirely, including UI controls in the TIME main panel
and quick popup, per-frame color grading and full-screen overlay.
Stored visual filter settings are ignored. The historical
`vx_visual_offset` storage key is retained for **real-sky time offset**
backwards compatibility; it is not a filter.

Real personal day/night, TIME presets, sliders, fine tuning, sync/reset,
server ACK diagnostics, teleport, automatic car option recovery, speedometer
and official center logo remain unchanged. No new server plugin or
`extra_cfg.yml` changes are required for this Lua-only upgrade.

### 2026-10-09 hotfix — CSP0 CHAT transport for AssettoServer 0.0.54.26

**Confirmed from actual user log:** after the DLL loaded and logged
`[VENOM TIME] Started`, online TIME requests were received as
`CHAT: ... $CSP0:YOpFD5uQc2V0ADA`, NOT as native
`CSPMessageTypeTcp.ClientMessage`. Stock AssettoServer 0.0.54
does not decode that chat-encoded payload into server-side OnlineEvents,
so `RegisterOnlineEvent` handlers were never called. Older DLLs therefore
cannot control the physical sky, even though they loaded successfully.

The fixed server-only plugin now listens to the built-in cancellable
`ChatService.MessageReceived` event, recognizes **only** the matching
`VENOMX_SetTime` encoded command (protocol opcode `60000`, Lua packet ID
`0x909B0F45`), parses its four-character mode and up to eight seconds
digits, cancels public forwarding, then uses the existing personal WeatherFX
sender. The original direct OnlineEvent transport also remains supported.
No new client files or Lua installation are required.

.NET 8 GitHub Actions smoke tests **passed** on captured commands for
`set 0`, `sync 0`, `set 67200`, `set 86399`, `set 16961`; unrelated
packet rejection and the generated OnlineEvent packet hash also passed.
Download the **latest successful build with the chat bridge**, replace the
old server DLL, restart server and reconnect players. Verify both
`[VENOM TIME] CSP0 CHAT BRIDGE decoded` and
`[VENOM TIME] Received mode=set` in the server log and
`SERVER ACK` inside VENOM TIME.

Compilation and payload decoding are verified in CI. Real in-game sky
movement has **not** been confirmed yet.

### v3.20.1 — End-to-end personal TIME acknowledgements

- The client no longer treats a successful Lua `pcall` as proof the server accepted a time setting.
- The updated .NET 8 VENOM time plugin sends back an OnlineEvent ACK only after it
  handles the client's command and dispatches a WeatherFX update; unexpected commands
  or dispatch exceptions trigger a server error response instead.
- TIME displays `AWAITING SERVER ACK`, `SERVER ACK`, `SERVER ERROR`, or
  `NO SERVER ACK / CHECK PLUGIN DLL AND LOGS` after 4 seconds.
- A server ACK confirms receiving/dispatching the packet, **not** visible physical
  sun or moon movement. If sky still does not change after an ACK, verify the
  WeatherFX controller (Pure PP is a post-processing filter, not proof of
  the selected weather controller), client CSP and server logs.
- Reinstall the *new* `VENOM-Personal-Time-net8` DLL from a successful
  GitHub Actions artifact built after v3.20.0, then restart server and reconnect.
  Do not keep the initial v3.20.0 DLL for this diagnostic test.

### v3.20.0 — Real per-player TIME for AssettoServer 0.0.54.x

VENOM X now sends `ac.OnlineEvent` commands (`VENOMX_SetTime`) to a compatible
server-side **VenomPersonalTimePlugin**. The server plugin changes the
WeatherFX time on outgoing weather updates **for that player only**.
Other players and admins retain their own time; **no global time changes**.

- Net8 plugin source: `server/VenomPersonalTimePlugin/`
- .NET 8 build CI: `.github/workflows/build-venom-personal-time-net8.yml`
- Successful compilation against AssettoServer `v0.0.54` in GitHub Actions;
  in-game validation on the user's exact `0.0.54.26` remains pending.
- Build artifact: `VENOM-Personal-Time-net8` from GitHub Actions.
- Install on **server only**, once. No manual client apps, companion, or Pure hook.
- Server configuration requirements: `EnableWeatherFx: true`,
  `EnableClientMessages: true`, and add `VenomPersonalTimePlugin` to
  existing `EnablePlugins` list. Do not overwrite other plugins.
- NIGHT/DAY/Rise/Set/Blue Hour in VENOM X now send server sky requests.
  Press RESET TIME to send `sync` and return to server clock.
- Native screen color correction is now only an optional VISUAL SKY fallback
  toggle; it is not turned on automatically when selecting a real sky time.
- `SENT ... / CHECK SKY` in the UI means an event send succeeded, not that
  the server accepted it. Full verification requires server logs and actual
  sun/sky movement after the DLL is installed.

**Important:** Never copy a .NET 9 HardBrain binary to the .NET 8 server.
Use the custom .NET 8 plugin or upgrade the entire AssettoServer stack.
This implementation avoids direct `ACTcpClient.SendPacketUdp` calls, which
are internal in `v0.0.54`, by wrapping the supported
`IWeatherImplementation.SendWeather` interface.

### v3.19.1 — Native personal visual time and mirror-safe notifications

- The v3.19.0 toast positioning accidentally capped the first notification to `screenHeight - 156`, pushing it back toward the logo on some resolutions. The first VENOM notification now reserves a larger zone below the central logo and typical Virtual Mirror position. Small screens prioritize the newest notification. The mirror itself is user-configurable, so its exact coordinates cannot be read by the CSP Online Lua script.
- Personal visual time now first uses the **CSP Online Lua color-correction API** (`ac.ColorCorrectionModulationRgb` + `ac.addColorCorrection`) to alter the locally rendered scene. NIGHT darkens and cools the scene; GOLDEN RISE, GOLDEN SET and BLUE HOUR apply their own tone. DAY returns the scene toward neutral. The intensity slider and time choice are saved. Native color correction needs client CSP/postprocessing support. If unavailable or rejected, a HUD tint fallback is retained.
- The TIME panels show a `SCENE FILTER` diagnostic indicating API registration or an error. **Registered does not mean visually verified**. These are local color grades, not real astronomical sun/moon movement, scene relighting, or weather changes. Other players' clocks, colors and weather are unaffected by a player's choice.
- Test: Disconnect, rejoin, select TIME → NIGHT 00:00 and compare with DAY 12:00, then send a screenshot that includes `SCENE FILTER`. The previous version's in-game failure prompted this change; no successful live CSP validation has been claimed.

### v3.18.0 — Extra state survives script hot reload; physical sky limitation

**Why the extra cache was lost:** The server can specify a positive
`REFRESH_PERIOD` for its GitHub-delivered online script. CSP may
replace the script's Lua state mid-game, wiping ordinary Lua tables.
VENOM X now automatically records the latest Extra A-J and light flags
to CSP typed storage and recovers them only when the *same car model*
is present, the simulation frame has not reset and the record is fresh
(under 75 seconds). Changes are written automatically when controls
change, and periodically while playing. No SAVE button is required.

Car-jump reset can also temporarily make `car.extraA`…`extraJ`
unreadable. v3.18 retries restoration for up to 10 seconds, with
additional time for transient post-jump readback. The PLAYERS/CREW
status is explicit when flags cannot be read or an attempted switch
restoration is denied. A CSP call returning without error never
proves a mod's animated wing/door stayed in place.

**The preferred CSP-native fix for persistent car extras:**
CSP **0.3.0-preview123 or newer** supports `KEEP_ON_RESET` for
each switch defined in the *car's own* CSP extension config, e.g.:

```ini
[EXTRA_SWITCHES]
SWITCH_A_FLAGS = KEEP_ON_RESET
SWITCH_B_FLAGS = KEEP_ON_RESET
SWITCH_C_FLAGS = KEEP_ON_RESET
SWITCH_D_FLAGS = KEEP_ON_RESET
SWITCH_E_FLAGS = KEEP_ON_RESET
SWITCH_F_FLAGS = KEEP_ON_RESET
```

Add only flags that match switches present for a particular car; if a
car already has other `SWITCH_X_FLAGS`, combine flags per that car's
existing config rather than overwriting them. Car mods can define their
own animation and control restrictions. CSP server online Lua does not
have demonstrated permission to edit an arbitrary installed car's
extension configuration. Therefore VENOM X cannot silently apply these
flags to every third-party car with a server-only file.

**TIME:** v2's shared-memory time controls required a separate local
Companion process/app with a live heartbeat, and v3's experiment used a
local weather bridge. On the reported client screenshot both were
missing, and the server-loaded online script also lacked
`ac.setWeatherTimeOffset`. The old TIME UI can select a personal clock
preset but cannot force real sky changes with this permission set.
For guaranteed real day/night from server only, use a **server-admin
time control that changes everyone** (not applied automatically here).
For **different skies per player**, a functioning client weather
controller is needed; this can't be recreated merely by changing the
GitHub-delivered online script. No global server time command is
executed by VENOM X.

### v3.17.0 — Automatic extra/light tracking, no Save button

The previous “SAVE CURRENT SETUP” control has been removed completely
from PLAYERS and quick CREW, because players should not have to manually
save every changed door/wing option. VENOM X now:

1. Reads the current car's supported Extra A-J, headlights, beams, hazard
   and signal flags while driving and automatically learns changes
   approximately every 80 ms.
2. On an internal teleport, Content Manager/third-party map position jump
   or CSP car-jump callback, freezes the last observed state before reset
   and attempts to restore different switch/light flags.
3. Keeps a live session memory for subsequent teleports; resumes learning
   the driver's changes after a short reset-protection window, rather
   than locking previous switches ON until leaving the game.
4. If at least two active car controls drop together, treats that as a
   possible car reset and attempts restoration rather than learning the
   simultaneous OFF states.
5. Displays *how many* Extra A-J switches are actually readable:
   `AUTO CACHE: n/10 EXTRAS READ / n ENABLED`. Inability to read them
   now says `EXTRA FLAGS NOT READABLE`, instead of falsely reporting
   “UNCHANGED” based on the lighting fields only. Restoration failures
   distinguish unavailable APIs, denied calls and option mismatches.

**Limitations:** No generic online-script method can always restore
internal door/spoiler animation variables that a particular car mod
resets on car-jump; some switches are hold-mode, stationary-only or
require neutral/brake. The restore logic only handles public CSP flags.
Real-game verification is required and a no-read-access diagnostic
cannot be corrected simply by additional retries.

**TIME truthfulness:** Historical VENOM X v2 used a local Companion
protocol; v1 did not implement an independent sky override. When neither
a responding legacy Companion nor the native weather-time API is
available in the online CSP script sandbox, selecting a clock preset
cannot move the real sun. The TIME popup now shows the precise v2 and
native API state plus actual sun Y so diagnosis is explicit. No Pure
installation and no server-wide `/settime` has been added.

### v3.16.0 — 1:1 CMRT gearbox proportions, recolored VENOM crimson

The reference is the user's own CMRT Complete HUD archive and gearbox
screenshot. Unlike v3.14's merely "CMRT-inspired" design, v3.16 uses
the source gearbox's characteristic **435 × 100 KERS capsule silhouette**,
original 50-unit radius ends, 14 dots separated by 14 units, left gear
center (50,70), right resource dial center (385,70), text columns
(KMH x=110 / RPM x=200), and bottom overlapping FUEL / EST.LAP pill.
The on-screen reference is roughly 305px wide, so the display defaults to
70% of these original logical proportions at 100% HUD Scale; HUD settings
retain their independent 80–130% scaling, opacity, show/hide and drag.

The former blue/teal rings are now **VENOM crimson**, with dark-gray
inactive RPM dots, white gear/numeric text and smoky black capsule.
Battery-equipped cars show battery percent; regular cars fall back to
remaining fuel percent. The entire visual is hand-rendered in CSP Lua,
without external CMRT textures, logo imagery or font installation.
The version does not modify TIME, telemetry collection, quick rail,
player teleport, car option cache or server weather.

As with all previous versions, an actual CSP game render is needed for
final pixel-level calibration. The server-delivered script may hot-refresh,
but a reconnect is recommended if the overlay appears partially initialized.

### v3.15.0 — Animated vertical quick-action rail

The eight-action horizontal strip is now a **single vertical column** with
hand-drawn vector icons and clear labels (MAP, CREW, TIME, PAINT, LIGHT,
HAZ, HUD, MENU), an obsidian translucent panel, a fine crimson top
accent, a small active-state indicator, low idle opacity, and animated
fade/slide entrance and hover emphasis.

- Left-click VENOM X's **X** logo to expand/collapse the rail.
- Right-click X or click **MENU** to access the large controls panel.
- Quick time, teleport and color flyouts appear beside their selected
  vertical action and flip to the other side near a screen edge.
- Responsive rail width/row height adapts to the client's resolution.
  The original native HUD, personalized TIME selector, A-J car cache,
  saved light/hazard states and 11m-behind-player teleport are unchanged.
- The rail remains open by default for new users; an existing local
  hide/show preference remains respected.

**Live server script refresh:** With CSP server-delivered Lua pointing at
the repository raw URL and periodic script refresh enabled, UI changes
may appear while a driver remains connected. Visual changes need no
game restart after the new version is visible, but a disconnect/rejoin
is recommended after logic changes (TIME hooks, Car Jump callbacks,
per-session state) to avoid mixing initialized state from different
script revisions. Users need not restart Assetto Corsa as a first step.

**Validation:** GitHub source/README synchronization and static Lua
structure checks were performed. In-game hover, layout and refresh
behavior require a live CSP client test.

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

### v3.18.1 — Official server emblem above Virtual Mirror

The original VENOM OFFICIAL SERVER graphic has been optimized into a
transparent 720×234 WebP (approximately 39.7 KB).

The server-delivered UI script now draws a persistent, top-center logo
layer independently of the quick rail, menus and speedometer. The image
is requested as a cached texture over HTTPS, not downloaded every frame.
The width adapts to the player's UI viewport (155–252 units) with the
original aspect ratio and a top margin of 2 units.

**Deployed asset:** `assets/venom_logo.webp` is committed to
the repository's `main` branch (39,700 bytes), matching the optimized
logo's Git blob hash exactly. The script fetches the public raw image URL:

`https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/assets/venom_logo.webp`

No manual client files or server-file copies are necessary.

The UI logo is anchored at the top center, not attached to Virtual
Mirror's position or state. If a player's Virtual Mirror occupies the
same topmost pixels, they may overlap and the mirror must be lowered
using their own mirror positioning controls. Rendering of remote WebP
depends on the player's CSP version; in-game verification is required.

### Validation
- GitHub source/static checks: passed in model-side inspection.
- **In-game test pending:** individual sun/moon movement, night lighting, and player-to-player teleport need to be tested with at least two genuine player sessions.
