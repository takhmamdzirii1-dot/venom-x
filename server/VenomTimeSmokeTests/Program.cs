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


static string EncodeGhost(bool enabled)
{
    var bytes = new byte[7];
    System.Buffers.Binary.BinaryPrimitives.WriteUInt16LittleEndian(bytes.AsSpan(0,2), 60000);
    System.Buffers.Binary.BinaryPrimitives.WriteUInt32LittleEndian(bytes.AsSpan(2,4), VenomGhostEvent.PacketType);
    bytes[6] = enabled ? (byte)1 : (byte)0;
    return Convert.ToBase64String(bytes).TrimEnd('=');
}

foreach (var enabled in new[] { false, true })
{
    var packet = "\t\t\t\t$CSP0:" + EncodeGhost(enabled);
    if (!VenomPersonalTimePlugin.VenomPersonalTimePlugin.TryDecodeChatGhost(packet, out var decoded)
        || decoded.Enabled != enabled)
        throw new Exception($"GHOST CSP0 decode failed for enabled={enabled}");
    if (VenomPersonalTimePlugin.VenomPersonalTimePlugin.TryDecodeChatTime(packet, out _))
        throw new Exception("GHOST event was incorrectly treated as a TIME event");
}
// Actual 2026-10-10 CSP client GHOST event captures:
if (!VenomPersonalTimePlugin.VenomPersonalTimePlugin.TryDecodeChatGhost(
    "\t\t\t\t$CSP0:YOrCGMSb", out var compactOff) || compactOff.Enabled)
    throw new Exception("Compact real-world 6-byte OFF packet must decode as false");
if (!VenomPersonalTimePlugin.VenomPersonalTimePlugin.TryDecodeChatGhost(
    "\t\t\t\t$CSP0:YOrCGMSbAQ", out var actualOn) || !actualOn.Enabled)
    throw new Exception("Real-world 7-byte ON packet must decode as true");
Console.WriteLine("PASS: real captured compact OFF / expanded ON packets");

if (VenomPersonalTimePlugin.VenomPersonalTimePlugin.TryDecodeChatGhost(
    "\t\t\t\t$CSP0:" + "YOpFD5uQc2V0ADA", out _))
    throw new Exception("TIME packet should never decode as GHOST.");
Console.WriteLine($"PASS: server ghost ON/OFF CSP0 packet type 0x{VenomGhostEvent.PacketType:X8}");

Console.WriteLine("VENOM TIME & GHOST CHAT BRIDGE SMOKE TESTS ALL PASS");
