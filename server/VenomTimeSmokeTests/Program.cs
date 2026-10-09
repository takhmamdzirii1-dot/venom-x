using VenomPersonalTimePlugin;

static void Check(string encoded, string expectedMode, string expectedSeconds)
{
    var ok = VenomPersonalTimePlugin.VenomPersonalTimePlugin.TryDecodeChatTime(
        "\t\t\t\t$CSP0:" + encoded, out var packet);

    if (!ok || packet.Mode != expectedMode || packet.Seconds != expectedSeconds)
        throw new Exception($"Decode FAILED: {encoded} -> ok={ok}, mode={packet.Mode}, seconds={packet.Seconds}");

    Console.WriteLine($"PASS: {expectedMode} {expectedSeconds}");
}

// Captured from the actual VENOM X 2026-10-09 AssettoServer log.
Check("YOpFD5uQc2V0ADA", "set", "0");            // NIGHT
Check("YOpFD5uQc3luYzA", "sync", "0");          // RESET TIME
Check("YOpFD5uQc2V0ADY3MjAw", "set", "67200");  // 18:40
Check("YOpFD5uQc2V0ADg2Mzk5", "set", "86399");  // 23:59:59
Check("YOpFD5uQc2V0ADE2OTYx", "set", "16961");  // slider

if (VenomPersonalTimePlugin.VenomPersonalTimePlugin.TryDecodeChatTime(
    "\t\t\t\t$CSP0:mDrRERH/", out _))
    throw new Exception("Unrelated packet must not be captured.");
Console.WriteLine("PASS: unrelated VENOM messages ignored");

if (VenomTimeEvent.PacketType != 0x909B0F45u)
    throw new Exception($"OnlineEvent type mismatch: 0x{VenomTimeEvent.PacketType:X8}, observed 0x909B0F45");
Console.WriteLine($"PASS: packet type hash 0x{VenomTimeEvent.PacketType:X8}");

Console.WriteLine("VENOM TIME CHAT BRIDGE SMOKE TESTS ALL PASS");
