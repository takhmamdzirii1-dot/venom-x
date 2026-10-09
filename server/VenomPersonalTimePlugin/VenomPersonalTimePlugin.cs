using AssettoServer.Network.Tcp;
using AssettoServer.Server;
using AssettoServer.Server.Configuration;
using AssettoServer.Server.Weather;
using Microsoft.Extensions.Hosting;
using Serilog;

namespace VenomPersonalTimePlugin;

/// <summary>
/// Personal time via server-delivered CSP OnlineEvents; no client installation.
/// Never invokes WeatherManager.SetTime, even for administrators.
/// </summary>
public sealed class VenomPersonalTimePlugin : IHostedService
{
    private readonly VenomPersonalTimeConfiguration _config;
    private readonly VenomPersonalTimeService _time;
    private readonly WeatherManager _weatherManager;
    private readonly EntryCarManager _entryCarManager;
    private readonly ACServerConfiguration _server;
    private volatile bool _enabled;

    public VenomPersonalTimePlugin(
        VenomPersonalTimeConfiguration config,
        VenomPersonalTimeService time,
        WeatherManager weatherManager,
        EntryCarManager entryCarManager,
        CSPClientMessageTypeManager messages,
        ACServerConfiguration server)
    {
        _config = config;
        _time = time;
        _weatherManager = weatherManager;
        _entryCarManager = entryCarManager;
        _server = server;

        messages.RegisterOnlineEvent<VenomTimeEvent>(OnTimeEvent);
        _entryCarManager.ClientDisconnected += OnDisconnected;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        if (!_config.Enabled)
        {
            Log.Information("[VENOM TIME] Disabled in plugin configuration");
            return Task.CompletedTask;
        }
        if (!_server.Extra.EnableWeatherFx || !_server.Extra.EnableClientMessages)
        {
            Log.Error("[VENOM TIME] Requires EnableWeatherFx: true and EnableClientMessages: true");
            return Task.CompletedTask;
        }

        _enabled = true;
        Log.Information("[VENOM TIME] Started on AssettoServer 0.0.54 / per-client WeatherFX decorator");
        return Task.CompletedTask;
    }

    private void OnTimeEvent(ACTcpClient player, VenomTimeEvent command)
    {
        // Reply using the SAME OnlineEvent layout. AssettoServer 0.0.54 supports
        // client.SendPacket(OnlineEvent), as used by FastTravelPlugin.
        // ACK proves that this plugin processed the event and dispatched weather;
        // it does not prove that the player's WeatherFX rendered the new sky.
        if (!_enabled)
        {
            SendResponse(player, "err", "OFF");
            return;
        }
        if (!player.HasSentFirstUpdate)
        {
            SendResponse(player, "err", "SPAWN");
            return;
        }

        var replySeconds = "0";
        try
        {
            if (command.Mode == "sync")
            {
                _time.Clear(player.SessionId);
            }
            else if (command.Mode == "set" &&
                int.TryParse(command.Seconds, out var seconds) &&
                seconds >= 0 && seconds < 86400)
            {
                _time.Set(player.SessionId, seconds, _weatherManager.CurrentDateTime);
                replySeconds = seconds.ToString();
            }
            else
            {
                SendResponse(player, "err", "INPUT");
                return;
            }

            _weatherManager.SendWeather(player);
            Log.Information("[VENOM TIME] Received mode={Mode} requested={Seconds} session={Session} player={Player}; WeatherFX update dispatched",
                command.Mode, replySeconds, player.SessionId, player.Name);
            SendResponse(player, "ack", replySeconds);
        }
        catch (Exception ex)
        {
            Log.Error(ex, "[VENOM TIME] Could not dispatch weather for session {Session}", player.SessionId);
            SendResponse(player, "err", "WEATHER");
        }
    }

    private static void SendResponse(ACTcpClient player, string mode, string seconds)
    {
        try
        {
            player.SendPacket(new VenomTimeEvent
            {
                SessionId = 255, // CSP sender==nil indicates the server
                Mode = mode,
                Seconds = seconds
            });
        }
        catch (Exception ex)
        {
            Log.Warning(ex, "[VENOM TIME] Failed sending diagnostic ACK to client session {Session}", player.SessionId);
        }
    }

    private void OnDisconnected(ACTcpClient player, EventArgs _) => _time.Clear(player.SessionId);

    public Task StopAsync(CancellationToken cancellationToken)
    {
        _enabled = false;
        _entryCarManager.ClientDisconnected -= OnDisconnected;
        return Task.CompletedTask;
    }
}
