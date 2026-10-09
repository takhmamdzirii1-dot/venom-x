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
        if (!_enabled || !player.HasSentFirstUpdate) return;
        if (command.Mode == "sync")
        {
            _time.Clear(player.SessionId);
        }
        else if (command.Mode == "set" && int.TryParse(command.Seconds, out var seconds))
        {
            _time.Set(player.SessionId, seconds, _weatherManager.CurrentDateTime);
        }
        else return;

        _weatherManager.SendWeather(player); // dispatches through our decorator
        Log.Debug("[VENOM TIME] Personal update for session {Session}, mode {Mode}", player.SessionId, command.Mode);
    }

    private void OnDisconnected(ACTcpClient player, EventArgs _) => _time.Clear(player.SessionId);

    public Task StopAsync(CancellationToken cancellationToken)
    {
        _enabled = false;
        _entryCarManager.ClientDisconnected -= OnDisconnected;
        return Task.CompletedTask;
    }
}
