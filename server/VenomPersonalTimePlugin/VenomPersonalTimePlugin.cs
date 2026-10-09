using System.Buffers.Binary;
using System.Collections.Concurrent;
using System.Linq;
using System.Text;
using AssettoServer.Commands;
using AssettoServer.Network.ClientMessages;
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
    private readonly ChatService _chatService;
    private readonly ACServerConfiguration _server;
    private volatile bool _enabled;
    private readonly ConcurrentDictionary<byte, bool> _ghostPlayers = new();

    public VenomPersonalTimePlugin(
        VenomPersonalTimeConfiguration config,
        VenomPersonalTimeService time,
        WeatherManager weatherManager,
        EntryCarManager entryCarManager,
        CSPClientMessageTypeManager messages,
        ChatService chatService,
        ACServerConfiguration server)
    {
        _config = config;
        _time = time;
        _weatherManager = weatherManager;
        _entryCarManager = entryCarManager;
        _chatService = chatService;
        _server = server;

        // CSP Online Lua in this 0.0.54 deployment transports OnlineEvent
        // as \t\t\t\t$CSP0:<base64> CHAT instead of Extended.ClientMessage.
        // ChatService exposes a cancellable event before broadcasting it.
        // Subscribe there as an additional transport, tightly scoped to
        // VENOMX_SetTime only. Keep the native event registration too.
        messages.RegisterOnlineEvent<VenomTimeEvent>(OnTimeEvent);
        messages.RegisterOnlineEvent<VenomGhostEvent>(OnGhostEvent);
        _chatService.MessageReceived += OnChatMessage;
        _entryCarManager.ClientConnected += OnClientConnected;
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
        Log.Information("[VENOM TIME] Started on AssettoServer 0.0.54 / per-client WeatherFX decorator, CSP0 chat bridge active. Event type=0x{PacketType:X8}",
            VenomTimeEvent.PacketType);
        Log.Information("[VENOM GHOST] Relay enabled; ghost event=0x{PacketType:X8}, CSP0 chat and native messages supported",
            VenomGhostEvent.PacketType);
        return Task.CompletedTask;
    }

    /// <summary>
    /// Decode CSP Online Lua's chat-encoded OnlineEvent transport. The
    /// 2026-10-09 server log contains:
    /// $CSP0:YOpFD5uQc2V0ADA -> uint16 60000, uint32 0x909B0F45,
    /// mode 'set', seconds '0'. The stock 0.0.54 chat handler does not
    /// automatically dispatch this packet to RegisterOnlineEvent.
    /// </summary>
    public static bool TryDecodeChatTime(string chat, out VenomTimeEvent message)
    {
        message = new VenomTimeEvent();
        var marker = chat.IndexOf("$CSP0:", StringComparison.Ordinal);
        if (marker < 0 || marker > 32 || !string.IsNullOrWhiteSpace(chat[..marker]))
            return false;

        var encoded = chat[(marker + 6)..].Trim();
        if (encoded.Length is < 12 or > 40) return false;
        try
        {
            var bytes = Convert.FromBase64String(encoded.PadRight((encoded.Length + 3) / 4 * 4, '='));
            if (bytes.Length is < 11 or > 18) return false;
            if (BinaryPrimitives.ReadUInt16LittleEndian(bytes.AsSpan(0, 2)) != 60000)
                return false;

            var packetId = BinaryPrimitives.ReadUInt32LittleEndian(bytes.AsSpan(2, 4));
            // Runtime hash is authoritative; the second value is the ID
            // verified from this server's captured VENOM_X.lua v3.20.1.
            if (packetId != VenomTimeEvent.PacketType && packetId != 0x909B0F45u)
                return false;

            var mode = Encoding.ASCII.GetString(bytes, 6, 4).TrimEnd('\0');
            var seconds = Encoding.ASCII.GetString(bytes, 10, bytes.Length - 10).TrimEnd('\0');
            if (mode is not ("set" or "sync")) return false;
            if (seconds.Length is < 1 or > 8 || !seconds.All(char.IsAsciiDigit))
                return false;

            message.Mode = mode;
            message.Seconds = seconds;
            return true;
        }
        catch (FormatException)
        {
            return false;
        }
    }

    // AssettoServer 0.0.54 CSP Online Lua sends $CSP0:<base64> as CHAT,
    // not as a registered extended message. Forward only validated opt-ins.
    // Do NOT broadcast raw encoded chat: CSP needs an actual OnlineEvent packet.
    public static bool TryDecodeChatGhost(string chat, out VenomGhostEvent message)
    {
        message = new VenomGhostEvent();
        var marker = chat.IndexOf("$CSP0:", StringComparison.Ordinal);
        if (marker < 0 || marker > 32 || !string.IsNullOrWhiteSpace(chat[..marker]))
            return false;
        var encoded = chat[(marker + 6)..].Trim();
        if (encoded.Length is < 8 or > 28) return false;
        try
        {
            var bytes = Convert.FromBase64String(encoded.PadRight((encoded.Length + 3) / 4 * 4, '='));
            if (bytes.Length != 7 || BinaryPrimitives.ReadUInt16LittleEndian(bytes.AsSpan(0, 2)) != 60000)
                return false;
            if (BinaryPrimitives.ReadUInt32LittleEndian(bytes.AsSpan(2, 4)) != VenomGhostEvent.PacketType)
                return false;
            if (bytes[6] > 1) return false;
            message.Enabled = bytes[6] == 1;
            return true;
        }
        catch (FormatException)
        {
            return false;
        }
    }

    private void OnChatMessage(ACTcpClient player, ChatEventArgs args)
    {
        if (TryDecodeChatTime(args.Message, out var command))
        {
            args.Cancel = true;
            Log.Information("[VENOM TIME] CSP0 CHAT BRIDGE decoded {Mode} {Seconds} from session {Session}",
                command.Mode, command.Seconds, player.SessionId);
            OnTimeEvent(player, command);
            return;
        }
        if (!TryDecodeChatGhost(args.Message, out var ghost)) return;
        args.Cancel = true;
        OnGhostEvent(player, ghost);
    }

    private void OnGhostEvent(ACTcpClient player, VenomGhostEvent command)
    {
        if (!_enabled || !player.HasSentFirstUpdate || player.EntryCar.AiControlled) return;

        // SessionId comes from the authenticated TCP connection, not the
        // Lua payload. A player may ONLY advertise their own GHOST mode.
        var session = player.SessionId;
        var old = _ghostPlayers.TryGetValue(session, out var previous) && previous;
        if (command.Enabled)
            _ghostPlayers[session] = true;
        else
            _ghostPlayers.TryRemove(session, out _);

        var response = new VenomGhostEvent { SessionId = 255, Enabled = command.Enabled };
        player.SendPacket(response); // real server ACK; never fake it locally

        foreach (var entry in _entryCarManager.EntryCars)
        {
            if (entry.Client is not { HasSentFirstUpdate: true } client || client == player)
                continue;
            client.SendPacket(new VenomGhostEvent
            {
                SessionId = session,
                Enabled = command.Enabled
            });
        }
        if (old != command.Enabled)
            Log.Information("[VENOM GHOST] {Session} -> {Enabled}, sent to connected peers",
                session, command.Enabled);
    }

    private void OnClientConnected(ACTcpClient player, EventArgs _)
        => player.FirstUpdateSent += OnFirstUpdateSent;

    private void OnFirstUpdateSent(ACTcpClient player, EventArgs _)
    {
        // Late joiners receive all active modes immediately (no 5s wait).
        foreach (var (session, enabled) in _ghostPlayers)
        {
            if (!enabled || session == player.SessionId) continue;
            player.SendPacket(new VenomGhostEvent { SessionId = session, Enabled = true });
        }
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

    private void OnDisconnected(ACTcpClient player, EventArgs _)
    {
        _time.Clear(player.SessionId);
        player.FirstUpdateSent -= OnFirstUpdateSent;
        if (!_ghostPlayers.TryRemove(player.SessionId, out _)) return;
        // Immediately release this player's ghost flag for remaining drivers.
        foreach (var entry in _entryCarManager.EntryCars)
        {
            if (entry.Client is not { HasSentFirstUpdate: true } client || client == player)
                continue;
            client.SendPacket(new VenomGhostEvent { SessionId = player.SessionId, Enabled = false });
        }
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        _enabled = false;
        _chatService.MessageReceived -= OnChatMessage;
        _entryCarManager.ClientConnected -= OnClientConnected;
        _entryCarManager.ClientDisconnected -= OnDisconnected;
        _ghostPlayers.Clear();
        return Task.CompletedTask;
    }
}
