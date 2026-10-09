using AssettoServer.Network.ClientMessages;

namespace VenomPersonalTimePlugin;

/// <summary>VENOM X per-player collision opt-in, relayed by AssettoServer.
/// On-wire layout must exactly match ac.OnlineEvent({key,enabled=boolean()}).</summary>
[OnlineEvent(Key = "VENOMX_Ghost_v1")]
public sealed class VenomGhostEvent : OnlineEvent<VenomGhostEvent>
{
    [OnlineEventField(Name = "enabled")]
    public bool Enabled;
}
