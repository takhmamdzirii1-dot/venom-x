# VENOM Personal Time — AssettoServer 0.0.54.x / .NET 8

Server-side implementation for a genuine **per-player sky clock** with CSP WeatherFX.
Players do not install a client app. This is not the visual tint fallback.

The technique follows the publicly available idea from HardBrain PersonalTimePlugin
(AGPL-3.0, https://github.com/hidlbe/HardBrain-Free-Plugins), but deliberately uses
`IWeatherImplementation.SendWeather(..., client)` instead of calling
`ACTcpClient.SendPacketUdp()`, which is internal in AssettoServer 0.0.54.
Project is distributed under AGPL-3.0.

## v3.24.0: Shared server DLL now relays GHOST (required for working online collisions)

For AssettoServer 0.0.54.x, VENOM X's GHOST OnlineEvent
(`VENOMX_Ghost_v1`, one Boolean named `enabled`) is transmitted as a CSP
`$CSP0` chat packet. The older server DLL intercepted TIME only, and
peer-side ghost flags were not reliably distributed.

The updated server DLL:
1. Registers `VenomGhostEvent` with the native CSP message manager and
   recognizes the exact 7-byte ghost CSP0 chat packet (0x9BC418C2).
2. Uses the actual TCP session ID to relay only the sender's own flag,
   with proper native CSP `OnlineEvent` packets to all other drivers.
3. Sends a native event back with SessionId=255 as the **real server ACK**
   used by VENOM X v3.24.0; it also supports snapshots for late joiners
   and immediate cleanup on disconnect.
4. Shares the existing `VenomPersonalTimePlugin` folder/config. No new
   `EnablePlugins` entry and no user-side downloads are needed.

**Replace the server-side DLL** with the new `VENOM-Personal-Time-net8`
GitHub Actions artifact at
https://github.com/takhmamdzirii1-dot/venom-x/actions/runs/37955197006,
then restart AssettoServer and reconnect with at least two human players.
Only the owner installs the DLL. Leave TIME configuration untouched.
Server startup must log `[VENOM GHOST] Relay enabled`; VENOM X home panel
must show `GHOST ON / SERVER CONFIRMED` for a successful request.

The .NET smoke tests passed for true/false chat decoding, normal TIME
handling and event type hashing; client-side Lua regressions also pass.
Actual real-world player-to-player physics remains to be validated live.

## Status

Source is compiled successfully in GitHub Actions against the upstream
AssettoServer `v0.0.54` sources using .NET 8. **Live server validation on
0.0.54.26 is still required.** The user's exact
`0.0.54.26` binary may have additional downstream differences.

## Installation (after CI succeeds)

1. Back up the entire server config and plugin folder.
2. Download `VENOM-Personal-Time-net8` artifact from GitHub Actions.
3. Put its `VenomPersonalTimePlugin` folder inside the AssettoServer `plugins/` folder.
4. In `cfg/extra_cfg.yml`, keep existing settings and add:

```yaml
EnableClientMessages: true
EnableWeatherFx: true
EnablePlugins:
  - VenomPersonalTimePlugin
```

Do **not** replace your other `EnablePlugins` entries; append only the new one.
If your server config already declares either scalar option, edit its existing value,
do not duplicate YAML keys. Plugin configuration (separate YAML doc):

```yaml
---
!VenomPersonalTimeConfiguration
Enabled: true
```

5. Restart AssettoServer and ask players to reconnect.
6. VENOM X `v3.20.0` now sends matching `ac.OnlineEvent` packets
   automatically when TIME sliders/presets change.
   The key is `VENOMX_SetTime` with fields `mode: string(4)` and
   `seconds: string(8)`. `set` is personal time, `sync` restores server time.

## CSP0 chat transport fix for AssettoServer 0.0.54.26

In the user's captured log, CSP v3.20.1 sent:
```
$CSP0:YOpFD5uQc2V0ADA
```
This is an OnlineEvent framed in a **chat packet**, with opcode 60000,
packet type `0x909B0F45`, `mode=set`, `seconds=0`.
Stock AssettoServer 0.0.54 handles such packets as CHAT but does not
forward them to `CSPClientMessageTypeManager.RegisterOnlineEvent`.

The corrected plugin attaches to the cancellable ChatService.MessageReceived,
validates the exact event key and packet framing, decodes TIME commands,
sets `Cancel=true` to prevent ordinary chat forwarding and uses its
existing per-player WeatherFX override. Both the native event path and
the chat transport path are supported.

**Validation:** GitHub Actions builds the DLL against AssettoServer
`v0.0.54` and runs a native .NET 8 smoke test which verifies the
actual log's `set`/`sync` Base64 packets, ignores unrelated packets,
and confirms the generated OnlineEvent type is `0x909B0F45`.
These automated checks passed. Gameplay validation still pending.

Expected after replacing the old DLL:
```
[VENOM TIME] Started ... CSP0 chat bridge active
[VENOM TIME] CSP0 CHAT BRIDGE decoded set 0 ...
[VENOM TIME] Received mode=set requested=0 ... WeatherFX update dispatched
```

## Live diagnostic (v3.20.1)

The updated DLL returns an `ack` OnlineEvent from the **server** using the
`VENOMX_SetTime` event layout after it calls `WeatherManager.SendWeather(player)`.
VENOM X v3.20.1 expects that ACK and reports an error if it does not arrive
within 4 seconds. The outgoing reply uses `SessionId = 255` (server sender)
and the same `mode: string(4)` / `seconds: string(8)` layout.

Expected server logs:

```
[VENOM TIME] Started on AssettoServer 0.0.54 / per-client WeatherFX decorator
[VENOM TIME] Received mode=set requested=0 session=... player=...; WeatherFX update dispatched
```

Interpretation:
- No startup log: the plugin service was not started.
- Startup log but no `Received mode=set`: old VENOM_X.lua, mismatched OnlineEvent ID,
  or packets are not reaching this plugin. Try enabling `DebugClientMessages: true`
  temporarily in extra_cfg.yml and inspect unknown CSP Lua messages.
- `Received` log but `NO SERVER ACK`: server-to-client response may not be delivered.
- `SERVER ACK` with unchanged actual sky: the event and backend executed; inspect
  WeatherFX controller/Pure and the physical sun-height diagnostic. ACK alone does
  not prove the sky rendered.

## Behavior

- Handles player and admin identically. **Never** changes global server time.
- Tracks requested time as an offset, so the personal clock continues moving.
- Automatically resends personal time on ordinary WeatherFX updates.
- Clears each user's override on disconnect.
- Does not modify the existing teleport, paint, Extra Switch, or speedometer code.
- Needs CSP WeatherFX and a client version supporting it.
