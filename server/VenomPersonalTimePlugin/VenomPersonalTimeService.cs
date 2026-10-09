using System.Collections.Concurrent;
using NodaTime;

namespace VenomPersonalTimePlugin;

/// <summary>Independent per-session time offsets; no global WeatherManager changes.</summary>
public sealed class VenomPersonalTimeService
{
    private readonly ConcurrentDictionary<byte, int> _offsets = new();

    public bool HasOverrides => !_offsets.IsEmpty;

    public void Set(byte sessionId, int requestedSeconds, ZonedDateTime serverTime)
    {
        requestedSeconds = Math.Clamp(requestedSeconds, 0, 86399);
        var nowSeconds = (int)(serverTime.TimeOfDay.TickOfDay / TimeSpan.TicksPerSecond);
        var offset = requestedSeconds - nowSeconds;
        // Use shortest equivalent offset to avoid date jumps; both wrap in 24h.
        if (offset > 43200) offset -= 86400;
        if (offset <= -43200) offset += 86400;
        _offsets[sessionId] = offset;
    }

    public void Clear(byte sessionId) => _offsets.TryRemove(sessionId, out _);

    public ZonedDateTime ForPlayer(byte sessionId, ZonedDateTime serverTime)
        => _offsets.TryGetValue(sessionId, out var offset)
            ? serverTime.PlusSeconds(offset)
            : serverTime;
}
