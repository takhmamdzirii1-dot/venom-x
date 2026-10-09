using AssettoServer.Network.ClientMessages;

namespace VenomPersonalTimePlugin;

// Match the ac.OnlineEvent struct in VENOM_X.lua byte-for-byte.
[OnlineEvent(Key = "VENOMX_SetTime")]
public sealed class VenomTimeEvent : OnlineEvent<VenomTimeEvent>
{
    [OnlineEventField(Name = "mode", Size = 4)]
    public string Mode = "";

    [OnlineEventField(Name = "seconds", Size = 8)]
    public string Seconds = "";
}
