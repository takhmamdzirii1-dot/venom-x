using AssettoServer.Network.Tcp;
using AssettoServer.Server;
using AssettoServer.Server.Weather;
using AssettoServer.Server.Weather.Implementation;
using NodaTime;

namespace VenomPersonalTimePlugin;

/// <summary>
/// Preserve the original WeatherFX sender but supply a per-client time.
/// On AssettoServer 0.0.54, ACTcpClient.SendPacketUdp is internal:
/// using IWeatherImplementation.SendWeather avoids private API calls.
/// </summary>
public sealed class VenomPersonalWeatherDecorator : IWeatherImplementation
{
    private readonly IWeatherImplementation _inner;
    private readonly VenomPersonalTimeService _personalTime;
    private readonly EntryCarManager _entryCarManager;

    public VenomPersonalWeatherDecorator(
        IWeatherImplementation inner,
        VenomPersonalTimeService personalTime,
        EntryCarManager entryCarManager)
    {
        _inner = inner;
        _personalTime = personalTime;
        _entryCarManager = entryCarManager;
    }

    public void SendWeather(WeatherData weather, ZonedDateTime serverTime, ACTcpClient? client = null)
    {
        if (client is not null)
        {
            _inner.SendWeather(weather, _personalTime.ForPlayer(client.SessionId, serverTime), client);
            return;
        }

        if (!_personalTime.HasOverrides)
        {
            _inner.SendWeather(weather, serverTime);
            return;
        }

        // Deliberately send only ONE packet per client, avoiding flicker from
        // a global broadcast that would overwrite a custom time.
        foreach (var entryCar in _entryCarManager.EntryCars)
        {
            if (entryCar.Client is not { HasSentFirstUpdate: true } player) continue;
            _inner.SendWeather(weather, _personalTime.ForPlayer(player.SessionId, serverTime), player);
        }
    }
}
