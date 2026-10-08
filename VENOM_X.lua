script = script or {}

local VERSION = '2.0.0'

local L = {
  title = 'VENOM X',
  subtitle = 'LA CANYONS',
  versionTag = 'v2.0.0',
  ready = 'VENOM X READY - quick menu is in the top-left corner',
  emergencyMode = 'VENOM X: HUD error - fallback panel enabled from the lightbulb menu',
  tabHome = 'HOME',
  tabTeleport = 'TELEPORT',
  tabPlayers = 'PLAYERS',
  tabColor = 'COLOR',
  tabTime = 'TIME',
  tabHud = 'HUD',
  server = 'SERVER',
  connected = 'Connected: %d',
  timeNow = 'Server time: %s',
  speedNow = 'Your speed: %d km/h',
  returnToPits = 'Return to Pits',
  hideHud = 'Hide Speedometer',
  showHud = 'Show Speedometer',
  noDestinations = 'No teleport destinations configured',
  destinations = 'DESTINATIONS',
  destSourceChat = 'source: server chat API',
  destSourceConfig = 'source: server config',
  refresh = 'Refresh',
  kmh = 'KM/H',
  gear = 'GEAR %s',
  rpm = 'RPM',
  playersTitle = 'PLAYERS',
  connectedPlayers = 'Connected players: %d',
  teleportHint = 'Click a driver to teleport 10 m behind them',
  cooldown = 'Teleport cooldown: %.1f s',
  pleaseWait = 'Please wait %d s',
  playerUnavailable = 'Player is no longer available',
  stopCarFirst = 'Stop your car before teleporting',
  teleportedTo = 'Teleported to %s',
  teleportedToPlayer = 'Teleported behind %s',
  teleportFailed = 'Teleport failed',
  noPlayers = 'No other players connected',
  trafficHidden = 'AI traffic is never listed here.',
  carColor = 'CAR COLOR',
  currentColor = 'Current color',
  defaultColor = 'Default livery color',
  colorApply = 'Apply color',
  colorApplied = 'Color applied and synced',
  colorNotAllowed = 'Server does not allow color changes here',
  colorFail = 'Color change failed',
  colorNoModule = 'Color API unavailable in this session',
  colorPickerHint = 'Fallback: use the built-in CSP color changer in the CSP lightbulb menu. It is enabled server-side for your slot.',
  colorReset = 'Reset to livery',
  colorResetMsg = 'Color reset to livery',
  liveryNote = 'Textured liveries may not recolor.',
  red = 'RED',
  green = 'GREEN',
  blue = 'BLUE',
  lights = 'LIGHTS',
  headlightsOn = 'Headlights: ON',
  headlightsOff = 'Headlights: OFF',
  highBeamsOn = 'High Beams: ON',
  highBeamsOff = 'High Beams: OFF',
  serverTime = 'SERVER TIME',
  timeMorning = 'MORNING 08:00',
  timeNoon = 'NOON 12:00',
  timeEvening = 'EVENING 18:00',
  timeNight = 'NIGHT 22:00',
  timeShiftLabel = 'SHIFT HOURS',
  timeApply = 'Apply shift',
  timeReset = 'Reset to server time',
  timeNoCompanion = 'Local time: VENOM X Client app is not installed',
  timeInstall = 'Install info',
  timeInstallMsg = 'Install: copy the VENOM_X_Client folder into Assetto Corsa/content/lua/apps/ and restart the game. See the VENOM X repo README.',
  timeCompanionReady = 'Companion: READY',
  timeCompanionMissing = 'Companion: NOT INSTALLED',
  timeCompanionStale = 'Companion: NOT RUNNING',
  timeSent = 'Shift sent, measuring...',
  timeApplied = 'Measured shift: %+.0f s',
  timeNoEffect = 'CSP accepted the call but time did not change (documented offline-only)',
  timeUnverified = 'Sent - effect not measurable while server time advances',
  timeNoResponse = 'Companion did not answer',
  timeError = 'Companion error: %s',
  timeResetDone = 'Shift reset requested',
  timeNothingToReset = 'No local shift to reset',
  timeCspNote = 'Local day/night uses ac.setWeatherTimeOffset through the VENOM X Client app. CSP documents this API as offline-only, so online it may do nothing - the result above is measured live, not assumed.',
  hudSettings = 'HUD SETTINGS',
  speedometer = 'Speedometer',
  rpmBar = 'RPM bar',
  opacity = 'HUD opacity',
  scale = 'HUD scale',
  resetPositions = 'Reset menu positions',
  hudNote = 'Drag windows by their header. The quick menu can be collapsed with >.',
  unknownDriver = '(no name)',
  other = 'Other',
  footer = 'VENOM X %s - CSP Online Script',
}

local C = {
  accent = rgbm(0.36, 0.62, 1.00, 1.00),
  accentSoft = rgbm(0.36, 0.62, 1.00, 0.60),
  accentFaint = rgbm(0.36, 0.62, 1.00, 0.22),
  text = rgbm(0.93, 0.95, 0.99, 1.00),
  dim = rgbm(0.58, 0.63, 0.73, 1.00),
  glass = rgbm(0.045, 0.055, 0.085, 0.93),
  card = rgbm(0.07, 0.09, 0.13, 0.55),
  cardSolid = rgbm(0.05, 0.06, 0.09, 0.62),
  btn = rgbm(0.09, 0.11, 0.16, 0.88),
  btnHover = rgbm(0.14, 0.19, 0.30, 0.95),
  btnActive = rgbm(0.17, 0.27, 0.46, 0.98),
  btnFlat = rgbm(0.10, 0.13, 0.19, 0.90),
  bar = rgbm(1.00, 1.00, 1.00, 0.12),
  ok = rgbm(0.35, 0.90, 0.55, 1.00),
  warn = rgbm(1.00, 0.72, 0.30, 1.00),
  danger = rgbm(1.00, 0.38, 0.38, 1.00),
}

local NAV = {
  { key = 'HOME', label = L.tabHome },
  { key = 'TELEPORT', label = L.tabTeleport },
  { key = 'PLAYERS', label = L.tabPlayers },
  { key = 'COLOR', label = L.tabColor },
  { key = 'TIME', label = L.tabTime },
  { key = 'HUD', label = L.tabHud },
}

local MENU_W, MENU_H = 250, 300
local PANEL_W, PANEL_H = 440, 540
local HEADER_H = 40
local SWATCHES = {
  { name = 'White', c = rgbm(1.00, 1.00, 1.00, 1) },
  { name = 'Black', c = rgbm(0.03, 0.03, 0.03, 1) },
  { name = 'Red', c = rgbm(0.85, 0.08, 0.08, 1) },
  { name = 'Blue', c = rgbm(0.10, 0.30, 0.95, 1) },
  { name = 'Green', c = rgbm(0.08, 0.70, 0.25, 1) },
  { name = 'Yellow', c = rgbm(0.95, 0.85, 0.10, 1) },
  { name = 'Cyan', c = rgbm(0.10, 0.80, 0.85, 1) },
  { name = 'Orange', c = rgbm(0.95, 0.45, 0.08, 1) },
}
local HUMAN_SESSION_IDS = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true }

local state = {
  frames = 0,
  dt = 0.016,
  hudVisible = true,
  rpmBar = true,
  hudOp = 90,
  hudScale = 100,
  menuX = 24,
  menuY = 96,
  panelX = -1,
  panelY = 140,
  menuCollapsed = false,
  panelOpen = false,
  panelSection = 'HOME',
  lastSection = 'HOME',
  dragging = nil,
  dragMouse = nil,
  dragBase = nil,
  toasts = {},
  players = {},
  playersAt = -999,
  destList = {},
  destById = {},
  destSource = 'config',
  destAt = -999,
  chatEx = nil,
  chatState = 'UNTRIED',
  colorAllowed = nil,
  colorProbeAt = -999,
  colR = 80,
  colG = 80,
  colB = 80,
  shiftHours = 0,
  teleportCooldown = 0,
  smoothSpeed = 0,
  screen = nil,
  screenAt = -999,
  readyDone = false,
  readyFrames = 0,
  drawErrors = 0,
  emergency = false,
  time = {
    companion = 'UNKNOWN',
    status = 'NONE',
    lastCmd = 0,
    sentFrame = -999,
    t0 = 0,
    pending = 0,
    measured = 0,
    lastApplied = 0,
    err = '',
  },
}

local config = {}
local configDests = {}
local configById = {}
local stored = nil
local shared = nil

local SH_LAYOUT = {
  beat = ac.StructItem.int32(),
  cmdSeq = ac.StructItem.int32(),
  cmdOffset = ac.StructItem.float(),
  cmdInstant = ac.StructItem.int32(),
  ackSeq = ac.StructItem.int32(),
  ackResult = ac.StructItem.int32(),
  ackAt = ac.StructItem.int32(),
  ackErr = ac.StructItem.string(96),
}

local function car() return ac.getCar(0) end
local function sim() return ac.getSim() end

local function stateVal(o, k)
  if not o then return nil end
  local ok, v = pcall(function() return o[k] end)
  if not ok then return nil end
  if type(v) == 'function' then
    local ok2, r = pcall(v, o)
    if ok2 then return r end
    return nil
  end
  return v
end

local function toast(message)
  if state.emergency then
    pcall(function() ui.toast(ui.Icons.Bulb, tostring(message)) end)
    return
  end
  local t = { text = tostring(message), t = 0, dur = 4.5 }
  local list = state.toasts
  if #list >= 4 then table.remove(list, 1) end
  list[#list + 1] = t
end

local function trim(s)
  return (tostring(s):gsub('^%s*(.-)%s*$', '%1'))
end

local function fmtClock(h, m, s)
  return string.format('%02d:%02d:%02d', h, m, s)
end

local function col(c, k)
  return rgbm(c.r, c.g, c.b, c.mult * k)
end

local function inRect(r, p)
  return p.x >= r.x and p.y >= r.y and p.x <= r.x + r.w and p.y <= r.y + r.h
end

local function clampPos(x, y, sw, sh)
  local nx = math.max(8, math.min(sw - 60, x))
  local ny = math.max(56, math.min(sh - 40, y))
  return nx, ny
end

local function handleDrag(key, hr, x, y, sw, sh)
  if state.dragging and state.dragging ~= key then return x, y end
  local mp = ui.mousePos()
  if state.dragging == key then
    if ui.mouseDown(0) then
      local nx = state.dragBase.x + (mp.x - state.dragMouse.x)
      local ny = state.dragBase.y + (mp.y - state.dragMouse.y)
      nx, ny = clampPos(nx, ny, sw, sh)
      return nx, ny
    end
    state.dragging = nil
  elseif ui.mouseClicked(0) and inRect(hr, mp) then
    state.dragging = key
    state.dragMouse = mp
    state.dragBase = vec2(x, y)
  end
  return x, y
end

local function loadStored()
  local ok, res = pcall(function()
    return ac.storage({
      vx_hud = true,
      vx_rpm = true,
      vx_op = 90,
      vx_sc = 100,
      vx_mx = 24,
      vx_my = 96,
      vx_px = -1,
      vx_py = 140,
    })
  end)
  if ok and type(res) == 'table' then
    stored = res
    if res.vx_hud ~= nil then state.hudVisible = res.vx_hud end
    if res.vx_rpm ~= nil then state.rpmBar = res.vx_rpm end
    if type(res.vx_op) == 'number' then state.hudOp = res.vx_op end
    if type(res.vx_sc) == 'number' then state.hudScale = res.vx_sc end
    if type(res.vx_mx) == 'number' then state.menuX = res.vx_mx end
    if type(res.vx_my) == 'number' then state.menuY = res.vx_my end
    if type(res.vx_px) == 'number' then state.panelX = res.vx_px end
    if type(res.vx_py) == 'number' then state.panelY = res.vx_py end
  end
end

local function persist()
  if not stored then return end
  stored.vx_hud = state.hudVisible
  stored.vx_rpm = state.rpmBar
  stored.vx_op = state.hudOp
  stored.vx_sc = state.hudScale
  stored.vx_mx = state.menuX
  stored.vx_my = state.menuY
  stored.vx_px = state.panelX
  stored.vx_py = state.panelY
end

local function loadConfig()
  local layout = { DISPLAY_NAME = 'VENOM LA Canyons', DISPLAY_SUB = 'LA Canyons Freeroam' }
  for i = 0, 63 do
    layout['POINT_' .. i] = ''
    layout['POINT_' .. i .. '_GROUP'] = ''
    layout['POINT_' .. i .. '_POS'] = ''
    layout['POINT_' .. i .. '_HEADING'] = '0'
  end
  local ok, res = pcall(function() return ac.configValues(layout) end)
  if ok and type(res) == 'table' then config = res end
end

local function buildConfigDests()
  for i = 0, 63 do
    local name = config['POINT_' .. i]
    if name and name ~= '' then
      local posStr = config['POINT_' .. i .. '_POS'] or ''
      local x, y, z = posStr:match('([%-%d%.]+)%s*,%s*([%-%d%.]+)%s*,%s*([%-%d%.]+)')
      if x then
        local group = trim(config['POINT_' .. i .. '_GROUP'] or '')
        if group == '' then group = L.other end
        local d = {
          id = i,
          name = trim(name),
          group = group,
          pos = vec3(tonumber(x), tonumber(y), tonumber(z)),
          heading = tonumber(config['POINT_' .. i .. '_HEADING']) or 0,
        }
        configDests[#configDests + 1] = d
        configById[i] = d
      end
    end
  end
  state.destList = configDests
  state.destById = configById
  state.destSource = 'config'
end

local function loadChat()
  local ok, mod = pcall(require, 'shared/sim/chat')
  if ok and type(mod) == 'table' and type(mod.extras) == 'table' then
    state.chatEx = mod.extras
    state.chatState = 'OK'
  else
    state.chatEx = nil
    state.chatState = ok and 'NO_EXTRAS' or 'NO_REQUIRE'
  end
end

local function connectBridge()
  local ok, s = pcall(ac.connect, SH_LAYOUT, true, ac.SharedNamespace.Shared)
  if ok and s then shared = s end
end

local function teleportSelf(pos, dir, message)
  local ok = pcall(function()
    physics.setCarPosition(0, pos, dir)
  end)
  if ok then
    if message then toast(message) end
    return true
  end
  toast(L.teleportFailed)
  return false
end

local function headingDir(heading)
  local rad = math.rad(heading)
  return vec3(math.sin(rad), 0, -math.cos(rad))
end

local function teleportConfigDest(d)
  if not d or not d.pos then return false end
  return teleportSelf(d.pos, headingDir(d.heading), string.format(L.teleportedTo, d.name))
end

local function teleportDest(d)
  if not d then return end
  if state.destSource == 'chat' and state.chatEx then
    local ok, res = pcall(function() return state.chatEx.teleportTo(d.id) end)
    if ok and res then
      toast(string.format(L.teleportedTo, d.name))
      return
    end
  end
  if d.pos then
    teleportConfigDest(d)
  else
    toast(L.teleportFailed)
  end
end

local function returnToPits()
  local d = configById[0] or configDests[1]
  if d then
    teleportConfigDest(d)
  else
    toast(L.noDestinations)
  end
end

local function teleportToPlayer(p)
  if state.teleportCooldown > 0.05 then
    toast(string.format(L.pleaseWait, math.ceil(state.teleportCooldown)))
    return
  end
  if not p then return end
  local target = ac.getCar(p.index)
  if not target or not target.isActive or not target.isConnected then
    toast(L.playerUnavailable)
    return
  end
  if stateVal(target, 'isAIControlled') then
    toast(L.playerUnavailable)
    return
  end
  local me = car()
  if me.speedKmh > 5 then
    toast(L.stopCarFirst)
    return
  end
  local lx, lz = target.look.x, target.look.z
  local len = math.sqrt(lx * lx + lz * lz)
  if len < 0.001 then
    lx, lz, len = 0, -1, 1
  end
  lx, lz = lx / len, lz / len
  local behind = vec3(target.position.x - lx * 10, target.position.y, target.position.z - lz * 10)
  local ok = pcall(function()
    physics.setCarPosition(0, behind, vec3(lx, 0, lz))
    physics.setCarVelocity(0, vec3(0, 0, 0))
    physics.awakeCar(0)
  end)
  if ok then
    state.teleportCooldown = 2.5
    toast(string.format(L.teleportedToPlayer, p.name))
  else
    toast(L.teleportFailed)
  end
end

local function isHumanCar(c, nm, mid, sid)
  if stateVal(c, 'isAIControlled') then return false end
  if type(sid) == 'number' and not HUMAN_SESSION_IDS[sid] then return false end
  if type(nm) == 'string' and nm:find('TRAFFIC', 1, true) then return false end
  if type(mid) == 'string' then
    if mid:find('traffic', 1, true) or mid:find('authentic_ai', 1, true) then return false end
  end
  return true
end

local function refreshPlayers(force)
  if not force and (state.frames - state.playersAt) < 24 then return end
  state.playersAt = state.frames
  local myPos = car().position
  local list = {}
  for _, c in ac.iterateCars() do
    if c.index ~= 0 and c.isConnected and c.isActive then
      local nm = stateVal(c, 'driverName')
      if type(nm) ~= 'string' or nm == '' then nm = L.unknownDriver end
      local mid = stateVal(c, 'id')
      if type(mid) ~= 'string' then mid = '' end
      local sid = stateVal(c, 'sessionID')
      if isHumanCar(c, nm, mid, sid) then
        list[#list + 1] = {
          index = c.index,
          name = nm,
          model = mid,
          dist = math.distance(c.position, myPos),
        }
      end
    end
  end
  table.sort(list, function(a, b) return a.dist < b.dist end)
  state.players = list
end

local function refreshDestinations(force)
  if not force and (state.frames - state.destAt) < 150 then return end
  state.destAt = state.frames
  if state.chatEx then
    local ok, res = pcall(function() return state.chatEx.teleportDestinations() end)
    if ok and type(res) == 'table' and #res > 0 then
      local list, byId = {}, {}
      for _, d in ipairs(res) do
        local group = d.group
        if type(group) ~= 'string' or group == '' then group = L.other end
        local nd = {
          id = d.ID,
          name = tostring(d.name or ''),
          group = group,
          pos = d.position,
          heading = d.heading or 0,
        }
        if nd.name ~= '' then
          list[#list + 1] = nd
          byId[nd.id] = nd
        end
      end
      if #list > 0 then
        state.destList = list
        state.destById = byId
        state.destSource = 'chat'
        return
      end
    end
  end
  state.destList = configDests
  state.destById = configById
  state.destSource = 'config'
end

local function probeColor(force)
  if not state.chatEx then
    state.colorAllowed = false
    return
  end
  if not force and (state.frames - state.colorProbeAt) < 90 then return end
  state.colorProbeAt = state.frames
  local ok, res = pcall(function() return state.chatEx.canChangeCarColor() end)
  if ok and type(res) == 'boolean' then
    state.colorAllowed = res
  end
end

local function applyColor(c)
  if not state.chatEx then
    toast(L.colorNoModule)
    return
  end
  local arg = nil
  if c then arg = rgb(c.r, c.g, c.b) end
  local ok, res = pcall(function() return state.chatEx.changeCarColor(arg) end)
  if not ok then
    toast(L.colorFail)
    return
  end
  if res then
    toast(c and L.colorApplied or L.colorResetMsg)
  else
    toast(L.colorNotAllowed)
  end
end

local function toggleHeadlights()
  local c = car()
  pcall(function() ac.setHeadlights(not c.headlightsActive) end)
end

local function toggleHighBeams()
  local c = car()
  pcall(function() ac.setHighBeams(not c.highBeams) end)
end

local function getScreenSize()
  if state.screen == nil or (state.frames - state.screenAt) > 90 then
    local ok, size = pcall(function() return render.getRenderTargetSize() end)
    if ok and size and size.x and size.x > 0 then
      state.screen = size
      state.screenAt = state.frames
    elseif state.screen == nil then
      state.screen = vec2(1920, 1080)
    end
  end
  return state.screen
end

local function gearString(g)
  if g == -1 then return 'R' end
  if g == 0 then return 'N' end
  return tostring(g)
end

local function pushGlass()
  ui.pushStyleVar(ui.StyleVar.WindowRounding, 12)
  ui.pushStyleVar(ui.StyleVar.WindowPadding, vec2(12, 10))
  ui.pushStyleVar(ui.StyleVar.ItemSpacing, vec2(6, 6))
  ui.pushStyleVar(ui.StyleVar.FrameRounding, 7)
  ui.pushStyleVar(ui.StyleVar.FramePadding, vec2(9, 5))
  ui.pushStyleColor(ui.StyleColor.WindowBg, C.glass)
  ui.pushStyleColor(ui.StyleColor.Border, C.accentFaint)
  ui.pushStyleColor(ui.StyleColor.ChildBg, C.cardSolid)
  ui.pushStyleColor(ui.StyleColor.Button, C.btnFlat)
  ui.pushStyleColor(ui.StyleColor.ButtonHovered, C.btnHover)
  ui.pushStyleColor(ui.StyleColor.ButtonActive, C.btnActive)
  ui.pushStyleColor(ui.StyleColor.FrameBg, C.btn)
  ui.pushStyleColor(ui.StyleColor.FrameBgHovered, C.btnHover)
  ui.pushStyleColor(ui.StyleColor.FrameBgActive, C.btnActive)
  ui.pushStyleColor(ui.StyleColor.SliderGrab, C.accent)
  ui.pushStyleColor(ui.StyleColor.SliderGrabActive, C.accent)
  ui.pushStyleColor(ui.StyleColor.Text, C.text)
  ui.pushStyleColor(ui.StyleColor.CheckMark, C.accent)
  ui.pushStyleColor(ui.StyleColor.Separator, C.accentFaint)
end

local function popGlass()
  ui.popStyleColor(14)
  ui.popStyleVar(5)
end

local function withWindow(id, pos, size, content)
  pushGlass()
  local okc = pcall(function()
    ui.beginTransparentWindow(id, pos, size, false, true)
    content()
    ui.endTransparentWindow()
  end)
  if not okc then
    pcall(ui.endTransparentWindow)
  end
  popGlass()
end

local function card(id, height, contentFn)
  ui.pushStyleVar(ui.StyleVar.ChildRounding, 10)
  if ui.beginChild(id, vec2(0, height), false, ui.WindowFlags.None) then
    contentFn()
  end
  ui.endChild()
  ui.popStyleVar()
end

local function sectionTitle(text)
  ui.textColored(text, C.accentSoft)
end

local function drawHome()
  local me = car()
  local s = sim()
  ui.textColored(config.DISPLAY_NAME or L.title, C.text)
  ui.textColored(config.DISPLAY_SUB or L.subtitle, C.dim)
  ui.separator()
  card('vx_home_stats', 132, function()
    sectionTitle(L.server)
    ui.text(string.format(L.connected, s.connectedCars))
    ui.text(string.format(L.timeNow, fmtClock(s.timeHours, s.timeMinutes, s.timeSeconds)))
    ui.text(string.format(L.speedNow, math.floor(math.max(0, me.speedKmh) + 0.5)))
  end)
  ui.separator()
  sectionTitle(L.lights)
  if ui.button(me.headlightsActive and L.headlightsOn or L.headlightsOff, vec2(0, 28)) then
    toggleHeadlights()
  end
  if ui.button(me.highBeams and L.highBeamsOn or L.highBeamsOff, vec2(0, 28)) then
    toggleHighBeams()
  end
  ui.separator()
  if ui.button(L.returnToPits, vec2(0, 30)) then
    returnToPits()
  end
end

local function drawTeleport()
  refreshDestinations(false)
  ui.textColored(L.destinations, C.accentSoft)
  ui.textDisabled(state.destSource == 'chat' and L.destSourceChat or L.destSourceConfig)
  if #state.destList == 0 then
    ui.textDisabled(L.noDestinations)
    return
  end
  card('vx_dest_list', 330, function()
    local lastGroup = nil
    for _, d in ipairs(state.destList) do
      if d.group ~= lastGroup then
        lastGroup = d.group
        ui.textColored(d.group, C.accent)
      end
      if ui.button(d.name, vec2(0, 23)) then
        teleportDest(d)
      end
      ui.setTooltip(string.format('%s\n%s', d.name, d.group))
    end
  end)
  if ui.button(L.refresh, vec2(0, 26)) then
    refreshDestinations(true)
  end
  ui.sameLine()
  if ui.button(L.returnToPits, vec2(0, 26)) then
    returnToPits()
  end
end

local function drawPlayers()
  refreshPlayers(false)
  ui.textColored(string.format(L.connectedPlayers, #state.players), C.accentSoft)
  ui.textDisabled(L.teleportHint)
  ui.separator()
  card('vx_player_list', 340, function()
    if #state.players == 0 then
      ui.textDisabled(L.noPlayers)
    else
      for _, p in ipairs(state.players) do
        if ui.button(string.format('%s   %d m', p.name, math.floor(p.dist + 0.5)), vec2(0, 24)) then
          teleportToPlayer(p)
        end
        ui.setTooltip(string.format('%s\n%s - %d m', p.name, p.model or '', math.floor(p.dist + 0.5)))
      end
    end
  end)
  ui.textDisabled(L.trafficHidden)
  if state.teleportCooldown > 0.05 then
    ui.textColored(string.format(L.cooldown, state.teleportCooldown), C.warn)
  end
end

local function drawColor()
  probeColor(false)
  local me = car()
  ui.textColored(L.carColor, C.accentSoft)
  card('vx_color_head', 112, function()
    local cc = me.customCarColor
    local p = ui.cursorScreenPos()
    if cc and cc.r == cc.r then
      ui.drawRectFilled(p, vec2(p.x + 30, p.y + 30), rgbm(cc.r, cc.g, cc.b, 1), 7)
      ui.drawRect(p, vec2(p.x + 30, p.y + 30), rgbm(1, 1, 1, 0.40), 7, ui.CornerFlags.All, 1)
      ui.setCursorScreenPos(vec2(p.x + 38, p.y + 2))
      ui.textColored(L.currentColor, C.text)
      ui.setCursorScreenPos(vec2(p.x + 38, p.y + 16))
      ui.textColored(string.format('%d, %d, %d', math.floor(cc.r * 255 + 0.5), math.floor(cc.g * 255 + 0.5), math.floor(cc.b * 255 + 0.5)), C.dim)
    else
      ui.setCursorScreenPos(vec2(p.x + 38, p.y + 8))
      ui.textColored(L.defaultColor, C.dim)
    end
    ui.setCursorScreenPos(vec2(p.x, p.y + 42))
    if ui.button(L.colorReset, vec2(0, 26)) then
      applyColor(nil)
    end
  end)
  if not state.chatEx then
    card('vx_color_fallback', 92, function()
      sectionTitle(L.colorNoModule)
      ui.textWrapped(L.colorPickerHint)
    end)
    return
  end
  if state.colorAllowed == false then
    ui.textColored(L.colorNotAllowed, C.warn)
  end
  local p = ui.cursorScreenPos()
  for i, sw in ipairs(SWATCHES) do
    ui.pushStyleColor(ui.StyleColor.Button, sw.c)
    ui.pushStyleColor(ui.StyleColor.ButtonHovered, sw.c)
    ui.pushStyleColor(ui.StyleColor.ButtonActive, sw.c)
    if i > 1 and (i - 1) % 4 ~= 0 then ui.sameLine() end
    if ui.button('##sw' .. i, vec2(42, 34)) then
      applyColor(sw.c)
    end
    ui.setTooltip(sw.name)
    ui.popStyleColor(3)
  end
  ui.sameLine()
  ui.textDisabled(L.liveryNote)
  ui.separator()
  local v
  v = ui.slider(L.red, state.colR, 0, 100, '%d', true)
  state.colR = v
  v = ui.slider(L.green, state.colG, 0, 100, '%d', true)
  state.colG = v
  v = ui.slider(L.blue, state.colB, 0, 100, '%d', true)
  state.colB = v
  local pv = rgbm(state.colR / 100, state.colG / 100, state.colB / 100, 1)
  local pp = ui.cursorScreenPos()
  ui.drawRectFilled(pp, vec2(pp.x + 44, pp.y + 28), pv, 6)
  ui.drawRect(pp, vec2(pp.x + 44, pp.y + 28), rgbm(1, 1, 1, 0.35), 6, ui.CornerFlags.All, 1)
  ui.setCursorScreenPos(vec2(pp.x + 52, pp.y + 4))
  ui.textColored(L.currentColor, C.dim)
  if ui.button(L.colorApply, vec2(0, 30)) then
    applyColor(pv)
  end
end

local function wrapOffset(o)
  local h = 43200
  while o > h do o = o - 86400 end
  while o <= -h do o = o + 86400 end
  return o
end

local function timeCmd(offset)
  if not shared then
    state.time.status = 'NOT_INSTALLED'
    toast(L.timeNoCompanion)
    return
  end
  local s = sim()
  if not s then return end
  offset = wrapOffset(offset)
  state.time.pending = offset
  state.time.t0 = s.timestamp
  state.time.sentFrame = state.frames
  state.time.lastCmd = shared.cmdSeq + 1
  shared.cmdOffset = offset
  shared.cmdInstant = 1
  shared.cmdSeq = state.time.lastCmd
  state.time.status = 'SENT'
end

local function timePreset(targetSec)
  local s = sim()
  if not s then return end
  timeCmd(targetSec - s.timeTotalSeconds)
end

local function companionStatus()
  if not shared then
    state.time.companion = 'NOT_INSTALLED'
    return
  end
  local s = sim()
  local b = shared.beat
  if not s then
    state.time.companion = 'UNKNOWN'
    return
  end
  if b > 0 and (s.frame - b) < 180 then
    state.time.companion = 'READY'
  elseif b > 0 then
    state.time.companion = 'STALE'
  else
    state.time.companion = 'NOT_INSTALLED'
  end
end

local function companionColor()
  local c = state.time.companion
  if c == 'READY' then return C.ok end
  if c == 'STALE' then return C.warn end
  return C.danger
end

local function statusColor()
  local st = state.time.status
  if st == 'APPLIED' then return C.ok end
  if st == 'SENT' then return C.warn end
  if st == 'NO_EFFECT' or st == 'ERROR' or st == 'NO_RESPONSE' or st == 'NOT_INSTALLED' then return C.danger end
  return C.dim
end

local function statusText()
  local tm = state.time
  local st = tm.status
  if st == 'SENT' then return L.timeSent end
  if st == 'APPLIED' then return string.format(L.timeApplied, tm.measured) end
  if st == 'NO_EFFECT' then return L.timeNoEffect end
  if st == 'UNVERIFIED' then return L.timeUnverified end
  if st == 'NO_RESPONSE' then return L.timeNoResponse end
  if st == 'ERROR' then return string.format(L.timeError, tm.err) end
  if st == 'NOT_INSTALLED' then return L.timeNoCompanion end
  return ''
end

local function drawTime()
  local s = sim()
  companionStatus()
  ui.textColored(L.serverTime, C.accentSoft)
  local p = ui.cursorScreenPos()
  local tstr = fmtClock(s.timeHours, s.timeMinutes, s.timeSeconds)
  local tsz = ui.measureDWriteText(tstr, 40, -1)
  ui.dwriteDrawText(tstr, 40, p, C.text)
  ui.setCursorScreenPos(vec2(p.x, p.y + tsz.y + 6))
  ui.textColored(string.format(L.timeNow, tstr), C.dim)
  ui.separator()
  local comp = state.time.companion
  local compText = L.timeCompanionMissing
  if comp == 'READY' then compText = L.timeCompanionReady
  elseif comp == 'STALE' then compText = L.timeCompanionStale end
  ui.textColored(compText, companionColor())
  if comp ~= 'READY' then
    if ui.button(L.timeInstall, vec2(0, 26)) then
      toast(L.timeInstallMsg)
    end
    ui.separator()
  end
  local bw = 200
  if ui.button(L.timeMorning, vec2(bw, 30)) then timePreset(8 * 3600) end
  ui.sameLine()
  if ui.button(L.timeNoon, vec2(bw, 30)) then timePreset(12 * 3600) end
  if ui.button(L.timeEvening, vec2(bw, 30)) then timePreset(18 * 3600) end
  ui.sameLine()
  if ui.button(L.timeNight, vec2(bw, 30)) then timePreset(22 * 3600) end
  ui.separator()
  local v = ui.slider(L.timeShiftLabel, state.shiftHours, -12, 12, '%+d h', true)
  state.shiftHours = v
  if ui.button(L.timeApply, vec2(0, 28)) then
    timeCmd(state.shiftHours * 3600)
  end
  ui.sameLine()
  if ui.button(L.timeReset, vec2(0, 28)) then
    if state.time.lastApplied ~= 0 then
      timeCmd(-state.time.lastApplied)
      state.time.lastApplied = 0
      toast(L.timeResetDone)
    else
      toast(L.timeNothingToReset)
    end
  end
  local st = statusText()
  if st ~= '' then
    ui.textColored(st, statusColor())
  end
  ui.textWrapped(L.timeCspNote)
end

local function drawHud()
  ui.textColored(L.hudSettings, C.accentSoft)
  if ui.checkbox(L.speedometer, state.hudVisible) then
    state.hudVisible = not state.hudVisible
    persist()
  end
  if ui.checkbox(L.rpmBar, state.rpmBar) then
    state.rpmBar = not state.rpmBar
    persist()
  end
  local v1, m1 = ui.slider(L.opacity, state.hudOp, 40, 100, '%d%%', true)
  state.hudOp = v1
  local v2, m2 = ui.slider(L.scale, state.hudScale, 80, 130, '%d%%', true)
  state.hudScale = v2
  if m1 or m2 then persist() end
  if ui.button(L.resetPositions, vec2(0, 28)) then
    state.menuX, state.menuY = 24, 96
    state.panelX, state.panelY = -1, 140
    persist()
    toast(L.resetPositions)
  end
  ui.separator()
  ui.textDisabled(L.hudNote)
end

local function drawSection(key)
  if key == 'HOME' then drawHome()
  elseif key == 'TELEPORT' then drawTeleport()
  elseif key == 'PLAYERS' then drawPlayers()
  elseif key == 'COLOR' then drawColor()
  elseif key == 'TIME' then drawTime()
  elseif key == 'HUD' then drawHud() end
end

local function checkSectionEnter()
  if state.panelSection ~= state.lastSection then
    state.lastSection = state.panelSection
    if state.panelSection == 'TELEPORT' then
      refreshDestinations(true)
    elseif state.panelSection == 'COLOR' then
      probeColor(true)
    end
  end
end

local function openSection(key)
  state.panelSection = key
  state.panelOpen = true
  checkSectionEnter()
end

local function drawQuickMenu()
  local scr = getScreenSize()
  local x, y = state.menuX, state.menuY
  x, y = clampPos(x, y, scr.x, scr.y)
  if state.menuCollapsed then
    withWindow('vx_pill', vec2(x, y), vec2(150, 44), function()
      if ui.button('VENOM X   >', vec2(138, 32)) then
        state.menuCollapsed = false
      end
    end)
    return
  end
  local hr = { x = x, y = y, w = MENU_W, h = 36 }
  local mp = ui.mousePos()
  local cbr = { x = hr.x + MENU_W - 36, y = hr.y + 6, w = 28, h = 24 }
  local collapseClick = ui.mouseClicked(0) and inRect(cbr, mp)
  if not collapseClick then
    local ox, oy = state.menuX, state.menuY
    x, y = handleDrag('menu', hr, x, y, scr.x, scr.y)
    state.menuX, state.menuY = x, y
    if x ~= ox or y ~= oy then persist() end
  end
  withWindow('vx_menu', vec2(x, y), vec2(MENU_W, MENU_H), function()
    ui.dwriteDrawText(L.title, 17, vec2(x + 12, y + 7), C.accent)
    local tw = ui.measureDWriteText(L.title, 17, -1)
    ui.dwriteDrawText(L.versionTag, 11, vec2(x + 12 + tw.x + 8, y + 13), C.dim)
    ui.drawText('>', vec2(x + MENU_W - 27, y + 8), inRect(cbr, mp) and C.accent or C.dim)
    if collapseClick then state.menuCollapsed = true end
    ui.drawRectFilled(vec2(x + 10, y + 35), vec2(x + MENU_W - 10, y + 36), C.accentFaint, 0)
    ui.setCursorScreenPos(vec2(x + 12, y + 44))
    for _, item in ipairs(NAV) do
      local active = state.panelOpen and state.panelSection == item.key
      ui.pushStyleColor(ui.StyleColor.Button, active and C.btnActive or C.btnFlat)
      if ui.button(item.label, vec2(MENU_W - 24, 30)) then
        openSection(item.key)
      end
      ui.popStyleColor()
    end
    local s = sim()
    ui.setCursorScreenPos(vec2(x + 12, y + MENU_H - 32))
    ui.textColored(string.format('%s   %s', fmtClock(s.timeHours, s.timeMinutes, s.timeSeconds), string.format(L.connected, s.connectedCars)), C.dim)
  end)
end

local function drawPanel()
  local scr = getScreenSize()
  if state.panelX < 0 then
    state.panelX = scr.x - PANEL_W - 24
    persist()
  end
  local x, y = state.panelX, state.panelY
  x, y = clampPos(x, y, scr.x, scr.y)
  local hr = { x = x, y = y, w = PANEL_W, h = HEADER_H }
  local mp = ui.mousePos()
  local xbr = { x = hr.x + PANEL_W - 36, y = hr.y + 6, w = 28, h = 26 }
  local closeClick = ui.mouseClicked(0) and inRect(xbr, mp)
  if not closeClick then
    local ox, oy = state.panelX, state.panelY
    x, y = handleDrag('panel', hr, x, y, scr.x, scr.y)
    state.panelX, state.panelY = x, y
    if x ~= ox or y ~= oy then persist() end
  end
  withWindow('vx_panel', vec2(x, y), vec2(PANEL_W, PANEL_H), function()
    if closeClick then state.panelOpen = false end
    ui.dwriteDrawText(L.title, 16, vec2(x + 14, y + 8), C.accent)
    local tw = ui.measureDWriteText(L.title, 16, -1)
    ui.dwriteDrawText(state.panelSection, 14, vec2(x + 14 + tw.x + 10, y + 11), C.text)
    ui.drawText('X', vec2(x + PANEL_W - 27, y + 8), inRect(xbr, mp) and C.danger or C.dim)
    ui.drawRectFilled(vec2(x + 10, y + 38), vec2(x + PANEL_W - 10, y + 39), C.accentFaint, 0)
    ui.setCursorScreenPos(vec2(x + 12, y + HEADER_H + 6))
    if ui.beginChild('vx_section', vec2(PANEL_W - 24, PANEL_H - HEADER_H - 18), false, ui.WindowFlags.None) then
      drawSection(state.panelSection)
    end
    ui.endChild()
  end)
end

local function drawToasts()
  local scr = getScreenSize()
  for i, t in ipairs(state.toasts) do
    local aIn = math.min(1, t.t / 0.18)
    local aOut = math.min(1, (t.dur - t.t) / 0.25)
    local a = math.max(0, math.min(aIn, aOut))
    local tsz = ui.measureText(t.text, -1)
    local w = math.max(260, tsz.x + 36)
    local h = 36
    local x = (scr.x - w) * 0.5
    local y = 26 + (i - 1) * (h + 8)
    ui.drawRectFilled(vec2(x, y), vec2(x + w, y + h), rgbm(0.05, 0.06, 0.10, 0.94 * a), 9)
    ui.drawRect(vec2(x, y), vec2(x + w, y + h), col(C.accentFaint, a), 9, ui.CornerFlags.All, 1)
    ui.drawRectFilled(vec2(x + 1, y + 7), vec2(x + 4, y + h - 7), col(C.accent, a), 2)
    ui.drawText(t.text, vec2(x + 16, y + (h - tsz.y) * 0.5), col(C.text, a))
  end
end

local function drawSpeedometer()
  if not state.hudVisible then return end
  local scr = getScreenSize()
  local k = state.hudScale / 100
  local op = state.hudOp / 100
  local w = math.floor(216 * k)
  local h = math.floor(138 * k)
  local x0 = scr.x - w - 26
  local y0 = scr.y - h - 96
  local c = car()

  ui.drawRectFilled(vec2(x0, y0), vec2(x0 + w, y0 + h), col(C.cardSolid, op), 14)
  ui.drawRect(vec2(x0, y0), vec2(x0 + w, y0 + h), col(C.accentFaint, op), 14, ui.CornerFlags.All, 1.5)

  state.smoothSpeed = state.smoothSpeed + (math.max(0, c.speedKmh) - state.smoothSpeed) * 0.25
  local speedStr = tostring(math.floor(state.smoothSpeed + 0.5))
  local fs = math.floor(44 * k)
  local sz = ui.measureDWriteText(speedStr, fs, -1)
  ui.dwriteDrawText(speedStr, fs, vec2(x0 + (w - sz.x) * 0.5, y0 + 8 * k), col(C.text, op))

  local ks = ui.measureText(L.kmh, -1)
  ui.drawText(L.kmh, vec2(x0 + (w - ks.x) * 0.5, y0 + 62 * k), col(C.accentSoft, op))

  ui.drawText(string.format(L.gear, gearString(c.gear)), vec2(x0 + 14, y0 + 84 * k), col(C.text, op))

  local rp = ui.measureText(L.rpm, -1)
  ui.drawText(L.rpm, vec2(x0 + w - 14 - rp.x, y0 + 84 * k), col(C.dim, op))

  if state.rpmBar then
    local maxRpm = c.rpmLimiter
    if not maxRpm or maxRpm <= 0 then maxRpm = 8000 end
    local frac = math.max(0, math.min(1, c.rpm / maxRpm))
    local bx0, by0 = x0 + 14, y0 + 102 * k
    local bx1, by1 = x0 + w - 14, y0 + 110 * k
    ui.drawRectFilled(vec2(bx0, by0), vec2(bx1, by1), col(C.bar, op), 4)
    if frac > 0.005 then
      local band = C.accent
      if frac > 0.95 then band = C.danger
      elseif frac > 0.85 then band = C.warn end
      ui.drawRectFilled(vec2(bx0, by0), vec2(bx0 + (bx1 - bx0) * frac, by1), col(band, op), 4)
    end
  end

  ui.drawText(L.title, vec2(x0 + 14, y0 + 120 * k), col(C.accentSoft, op * 0.55))
end

local function drawAll()
  drawToasts()
  drawSpeedometer()
  drawQuickMenu()
  if state.panelOpen then
    drawPanel()
  end
end

local function drawEmergency()
  ui.pushStyleVar(ui.StyleVar.WindowPadding, vec2(12, 10))
  ui.pushFont(ui.Font.Title)
  ui.textColored(L.title, C.accent)
  ui.popFont()
  ui.sameLine()
  ui.textColored(L.versionTag, C.dim)
  ui.textColored(config.DISPLAY_NAME or L.subtitle, C.dim)
  ui.separator()
  if ui.beginTabBar('vx_emerg_tabs', ui.TabBarFlags.None) then
    for _, item in ipairs(NAV) do
      if ui.beginTabItem(item.label, ui.TabItemFlags.None) then
        drawSection(item.key)
        ui.endTabItem()
      end
    end
    ui.endTabBar()
  end
  ui.separator()
  ui.textDisabled(string.format(L.footer, VERSION))
  ui.popStyleVar()
end

function script.update(dt)
  state.frames = state.frames + 1
  state.dt = math.min(dt or 0.016, 0.1)
  if state.teleportCooldown > 0 then
    state.teleportCooldown = math.max(0, state.teleportCooldown - state.dt)
  end
  local alive = {}
  for _, t in ipairs(state.toasts) do
    t.t = t.t + state.dt
    if t.t < t.dur then alive[#alive + 1] = t end
  end
  state.toasts = alive
  local tm = state.time
  if tm.status == 'SENT' and shared and state.frames - tm.sentFrame >= 45 then
    if shared.ackSeq == tm.lastCmd then
      local s = sim()
      if not s or s.timestamp == 0 then
        tm.status = 'UNVERIFIED'
      else
        local D = s.timestamp - tm.t0
        tm.measured = D
        if shared.ackResult == 2 then
          tm.status = 'ERROR'
          tm.err = tostring(shared.ackErr)
        else
          local m = s.timeMultiplier
          if m and (m > 0.001 or m < -0.001) then
            tm.status = 'UNVERIFIED'
          else
            local tol = math.max(90, math.abs(tm.pending) * 0.2)
            if math.abs(D - tm.pending) <= tol then
              tm.status = 'APPLIED'
              tm.lastApplied = tm.pending
            elseif math.abs(D) <= tol then
              tm.status = 'NO_EFFECT'
            else
              tm.status = 'UNVERIFIED'
            end
          end
        end
      end
    elseif state.frames - tm.sentFrame >= 300 then
      tm.status = 'NO_RESPONSE'
    end
  end
end

function script.drawUI()
  if not state.readyDone then
    state.readyFrames = state.readyFrames + 1
    if state.readyFrames >= 90 then
      state.readyDone = true
      toast(L.ready)
    end
  end
  if state.emergency then return end
  local ok = pcall(drawAll)
  if ok then
    state.drawErrors = 0
  else
    state.drawErrors = state.drawErrors + 1
    if state.drawErrors >= 3 then
      state.emergency = true
      pcall(function() ui.toast(ui.Icons.Bulb, L.emergencyMode) end)
    end
  end
end

loadStored()
loadConfig()
buildConfigDests()
loadChat()
connectBridge()
refreshDestinations(true)

ui.registerOnlineExtra(ui.Icons.Bulb, L.title,
  function() return state.emergency end,
  function() drawEmergency(); return false end,
  function(ok) end,
  ui.OnlineExtraFlags.Tool,
  bit.bor(ui.WindowFlags.NoCollapse, ui.WindowFlags.NoFocusOnAppearing),
  vec2(430, 600)
)
