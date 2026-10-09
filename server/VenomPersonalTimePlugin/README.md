# VENOM Personal Time — AssettoServer 0.0.54.x / .NET 8

Server-side implementation for a genuine **per-player sky clock** with CSP WeatherFX.
Players do not install a client app. This is not the visual tint fallback.

The technique follows the publicly available idea from HardBrain PersonalTimePlugin
(AGPL-3.0, https://github.com/hidlbe/HardBrain-Free-Plugins), but deliberately uses
`IWeatherImplementation.SendWeather(..., client)` instead of calling
`ACTcpClient.SendPacketUdp()`, which is internal in AssettoServer 0.0.54.
Project is distributed under AGPL-3.0.

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
