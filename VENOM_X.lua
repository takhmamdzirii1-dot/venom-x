script = script or {}

local VERSION = '3.7.0'

local L = {
  title = 'VENOM X',
  subtitle = 'LA CANYONS',
  versionTag = 'v3.7.0',
  ready = 'VENOM X READY | CTRL+SHIFT+X for menu',
  emergencyMode = 'VENOM X: HUD error - fallback panel enabled from the lightbulb menu',
  navHome = 'HOME',
  navTp = 'TP',
  navPlayers = 'PLAYERS',
  navColor = 'COLOR',
  navTime = 'TIME',
  navHud = 'HUD',
  online = 'ONLINE',
  playersChip = '%d PLAYERS',
  quickTeleport = 'TELEPORT',
  quickColor = 'COLOR',
  quickTime = 'TIME',
  quickPit = 'PIT',
  returnToPits = 'Return to Pits',
  noDestinations = 'No teleport destinations configured',
  destSearch = '##vx_search',
  refresh = 'Refresh',
  kmh = 'KM/H',
  gear = 'GEAR %s',
  rpmLabel = 'RPM %s',
  teleportHint = 'Tap a driver to teleport 10 m behind them',
  cooldown = 'Teleport cooldown: %.1f s',
  pleaseWait = 'Please wait %d s',
  playerUnavailable = 'Player is no longer available',
  stopCarFirst = 'STOP VEHICLE FIRST',
  teleportedToPlayer = 'TELEPORTED TO %s',
  teleportFailed = 'Teleport failed',
  noPlayers = 'No other players connected',
  trafficHidden = 'AI traffic is never listed here',
  unknownDriver = '(no name)',
  other = 'Other',
  carColor = 'CAR COLOR',
  colorApply = 'APPLY',
  colorReset = 'RESET',
  colorUpdated = 'COLOR UPDATED',
  colorResetMsg = 'Color reset to livery',
  colorNotAllowed = 'Server does not allow color changes here',
  colorFail = 'Color change failed',
  colorNoModule = 'Color API unavailable in this session',
  liveryNote = 'Textured liveries may not recolor',
  presetWhite = 'WHITE',
  presetBlack = 'BLACK',
  presetGraphite = 'GRAPHITE',
  presetSilver = 'SILVER',
  presetRed = 'RED',
  presetOrange = 'ORANGE',
  presetYellow = 'YELLOW',
  presetGreen = 'GREEN',
  presetCyan = 'CYAN',
  presetBlue = 'BLUE',
  presetPurple = 'PURPLE',
  presetPink = 'PINK',
  localTime = 'LOCAL TIME',
  controllerPure = 'PURE',
  controllerWfx = 'WEATHER FX',
  timeReady = 'READY',
  timeNoModule = 'TIME MODULE NOT INSTALLED',
  timeInstall = 'INSTALL',
  timeInstallMsg = 'Copy VENOM_X_Client.zip into the Assetto Corsa root folder (drag it into Content Manager) and restart the game. Requires the Pure weather script.',
  timeUnavailable = 'Local time unavailable with current weather controller.',
  timeActive = 'SHIFT %+.1f h',
  timeReset = 'RESET TO SERVER',
  timeWaiting = 'WAITING FOR WEATHER SCRIPT',
  presetSunrise = 'SUNRISE 06:30',
  presetDay = 'DAY 12:00',
  presetSunset = 'SUNSET 19:00',
  presetBlue = 'BLUE HOUR 20:00',
  presetNight = 'NIGHT 00:00',
  hudSettings = 'HUD SETTINGS',
  speedometer = 'Speedometer',
  rpmBar = 'RPM bar',
  opacity = 'HUD opacity',
  scale = 'HUD scale',
  resetPositions = 'Reset positions',
  hudNote = 'Drag the X or panel header with your mouse. CTRL+SHIFT+X toggles the menu.',
  nightMode = 'NIGHT MODE',
  resetDone = 'Reset to server time',
  spdOn = 'SPEEDOMETER ON',
  spdOff = 'SPEEDOMETER OFF',
  footer = 'VENOM X %s - CSP Online Script',
}

local C = {
  accent = rgbm(0.42, 0.70, 1.00, 1.00),
  accentSoft = rgbm(0.42, 0.70, 1.00, 0.62),
  accentFaint = rgbm(0.42, 0.70, 1.00, 0.20),
  text = rgbm(0.94, 0.96, 1.00, 1.00),
  dim = rgbm(0.56, 0.61, 0.71, 1.00),
  glass = rgbm(0.035, 0.045, 0.070, 0.90),
  glassDeep = rgbm(0.025, 0.032, 0.052, 0.94),
  card = rgbm(0.075, 0.095, 0.140, 0.50),
  cardSolid = rgbm(0.055, 0.070, 0.105, 0.66),
  btn = rgbm(0.085, 0.105, 0.155, 0.90),
  btnHover = rgbm(0.130, 0.180, 0.290, 0.96),
  btnActive = rgbm(0.160, 0.260, 0.450, 0.98),
  btnFlat = rgbm(0.095, 0.120, 0.175, 0.90),
  bar = rgbm(1.00, 1.00, 1.00, 0.11),
  ok = rgbm(0.36, 0.88, 0.55, 1.00),
  warn = rgbm(1.00, 0.72, 0.30, 1.00),
  danger = rgbm(1.00, 0.42, 0.42, 1.00),
}

local NAV = {
  { key = 'HOME', label = L.navHome },
  { key = 'TELEPORT', label = L.navTp },
  { key = 'PLAYERS', label = L.navPlayers },
  { key = 'COLOR', label = L.navColor },
  { key = 'TIME', label = L.navTime },
  { key = 'HUD', label = L.navHud },
}

local PRESETS = {
  { label = L.presetWhite, r = 1.00, g = 1.00, b = 1.00 },
  { label = L.presetBlack, r = 0.03, g = 0.03, b = 0.03 },
  { label = L.presetGraphite, r = 0.22, g = 0.23, b = 0.25 },
  { label = L.presetSilver, r = 0.72, g = 0.74, b = 0.78 },
  { label = L.presetRed, r = 0.82, g = 0.07, b = 0.07 },
  { label = L.presetOrange, r = 0.95, g = 0.45, b = 0.08 },
  { label = L.presetYellow, r = 0.95, g = 0.85, b = 0.10 },
  { label = L.presetGreen, r = 0.08, g = 0.68, b = 0.26 },
  { label = L.presetCyan, r = 0.10, g = 0.78, b = 0.84 },
  { label = L.presetBlue, r = 0.10, g = 0.32, b = 0.95 },
  { label = L.presetPurple, r = 0.52, g = 0.22, b = 0.90 },
  { label = L.presetPink, r = 0.95, g = 0.40, b = 0.68 },
}

local TIME_PRESETS = {
  { label = L.presetSunrise, sec = 6 * 3600 + 1800 },
  { label = L.presetDay, sec = 12 * 3600 },
  { label = L.presetSunset, sec = 19 * 3600 },
  { label = L.presetBlue, sec = 20 * 3600 },
  { label = L.presetNight, sec = 0 },
}

local HUMAN_SESSION_IDS = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true }

local ORB_SIZE = 56
local PANEL_W = 370
local PANEL_H = 515
local PANEL_SIZES = { { 318, 440 }, { 370, 515 }, { 438, 590 } }
local OPEN_DUR = 0.24
local DRAG_THRESHOLD = 6
local STORE_ENABLED = 'venomx.time.enabled'
local STORE_OFFSET = 'venomx.time.offsetHours'
local STORE_BEAT = 'venomx.time.heartbeat'
local STORE_STATUS = 'venomx.time.status'
local STORE_APPLIED = 'venomx.time.applied'

local state = {
  frames = 0,
  dt = 0.016,
  clock = 0,
  hudVisible = true,
  rpmBar = true,
  hudOp = 90,
  hudScale = 100,
  orbX = 16,
  orbY = -1,
  spdX = -1,
  spdY = -1,
  panelSize = 1,
  panelW = 370,
  panelH = 515,
  section = 'HOME',
  sectT = 1,
  navX = -1,
  openT = 0,
  panelOpen = false,
  panelTX = 0,
  panelTY = 0,
  panelDrag = false,
  panelDragMouse = nil,
  panelDragBase = nil,
  orbPress = nil,
  spdPress = nil,
  orbHover = 0,
  dragging = nil,
  toasts = {},
  players = {},
  playersAt = -999,
  destList = {},
  destById = {},
  configList = {},
  configById = {},
  destSource = 'config',
  destAt = -999,
  groupOpen = {},
  search = '',
  chatEx = nil,
  chatState = 'UNTRIED',
  colorAllowed = nil,
  colorProbeAt = -999,
  picker = rgbm(0.80, 0.80, 0.80, 1),
  pickerDirty = false,
  pickerInit = false,
  teleportCooldown = 0,
  smoothSpeed = 0,
  smoothRpm = 0,
  screen = nil,
  screenAt = -999,
  readyDone = false,
  readyFrames = 0,
  drawErrors = 0,
  emergency = false,
  time = {
    helper = nil,
    helperSeen = false,
    applied = 'no',
    want = 0,
    curOffset = 0,
    probeAt = -999,
  },
}

local config = {}
local stored = nil

-- Lua lexical scoping: drawHud() is defined before speedoRect().
-- Forward-declare the local variable or the HUD tab calls a NIL GLOBAL.
local speedoRect

local function car() return ac.getCar(0) end
local function sim() return ac.getSim() end

local function clamp(v, a, b)
  if v < a then return a end
  if v > b then return b end
  return v
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

local function easeOutCubic(t)
  local inv = 1 - t
  return 1 - inv * inv * inv
end

local function anim(cur, target, speed, dt)
  return cur + (target - cur) * (1 - math.exp(-speed * dt))
end

local function wrapDay(sec)
  sec = sec % 86400
  if sec < 0 then sec = sec + 86400 end
  return sec
end

local function wrapOffset(sec)
  while sec > 43200 do sec = sec - 86400 end
  while sec <= -43200 do sec = sec + 86400 end
  return sec
end

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

local function trim(s)
  return (tostring(s):gsub('^%s*(.-)%s*$', '%1'))
end

local function fmtClock(h, m)
  return string.format('%02d:%02d', h, m)
end

local function fmtSec(sec)
  sec = wrapDay(sec)
  local h = math.floor(sec / 3600)
  local m = math.floor((sec - h * 3600) / 60)
  return fmtClock(h, m)
end

local function col(c, k)
  return rgbm(c.r, c.g, c.b, c.mult * k)
end

local function mixCol(a, b, t)
  return rgbm(lerp(a.r, b.r, t), lerp(a.g, b.g, t), lerp(a.b, b.b, t), lerp(a.mult, b.mult, t))
end

local function inRect(r, p)
  return p.x >= r.x and p.y >= r.y and p.x <= r.x + r.w and p.y <= r.y + r.h
end

local function toast(message, kind)
  if state.emergency then
    pcall(function() ui.toast(ui.Icons.Bulb, tostring(message)) end)
    return
  end
  local t = { text = tostring(message), t = 0, dur = 2.7, kind = kind or 'ok' }
  local list = state.toasts
  if #list >= 3 then table.remove(list, 1) end
  list[#list + 1] = t
end

local function getScreenSize()
  -- Transparent CSP UI windows use UI coordinates, not the off-screen render target.
  -- A 1920x1080 guessed fallback on a smaller display hid the speedometer.
  if state.screen == nil or (state.frames - state.screenAt) > 30 then
    local ok, size = pcall(function() return ac.getUI().windowSize end)
    if not ok or not size or size.x < 200 or size.y < 200 then
      ok, size = pcall(function() return render.getRenderTargetSize() end)
    end
    if ok and size and size.x >= 200 and size.y >= 200 then
      state.screen = vec2(size.x, size.y)
      state.screenAt = state.frames
    elseif state.screen == nil then
      state.screen = vec2(1280, 720)
      state.screenAt = state.frames
    end
  end
  return state.screen
end

local function applyPanelSize()
  PANEL_W = clamp(math.floor(state.panelW or 370), 300, 560)
  PANEL_H = clamp(math.floor(state.panelH or 515), 380, 680)
end

local function panelTargetPos()
  local scr = getScreenSize()
  local px = state.orbX + ORB_SIZE + 12
  if px + PANEL_W > scr.x - 12 then
    px = state.orbX - PANEL_W - 12
  end
  if px < 8 then px = 8 end
  local py = clamp(state.orbY - 20, 48, math.max(48, scr.y - PANEL_H - 12))
  return px, py
end

local function panelRect()
  return { x = state.panelTX, y = state.panelTY, w = PANEL_W, h = PANEL_H }
end

local function panelBlocks()
  return state.panelOpen and state.openT >= 0.9 and inRect(panelRect(), ui.mousePos())
end

local function loadStored()
  local ok, res = pcall(function()
    return ac.storage({
      vx_hud = true,
      vx_rpm = true,
      vx_op = 90,
      vx_sc = 100,
      vx_ox = 16,
      vx_oy = -1,
      vx_sx = -1,
      vx_sy = -1,
      vx_psz = 1,
      vx_pw = 370,
      vx_ph = 515,
      vx_sec = 'HOME',
    })
  end)
  if ok and type(res) == 'table' then
    stored = res
    if res.vx_hud ~= nil then state.hudVisible = res.vx_hud end
    if res.vx_rpm ~= nil then state.rpmBar = res.vx_rpm end
    if type(res.vx_op) == 'number' then state.hudOp = clamp(res.vx_op, 40, 100) end
    if type(res.vx_sc) == 'number' then state.hudScale = clamp(res.vx_sc, 80, 130) end
    if type(res.vx_ox) == 'number' and res.vx_ox >= -100 and res.vx_ox <= 4000 then state.orbX = res.vx_ox end
    if type(res.vx_oy) == 'number' and res.vx_oy >= -100 and res.vx_oy <= 4000 then state.orbY = res.vx_oy end
    if type(res.vx_sx) == 'number' and (res.vx_sx == -1 or (res.vx_sx >= -50 and res.vx_sx <= 4000)) then state.spdX = res.vx_sx end
    if type(res.vx_sy) == 'number' and (res.vx_sy == -1 or (res.vx_sy >= -50 and res.vx_sy <= 4000)) then state.spdY = res.vx_sy end
    if type(res.vx_psz) == 'number' then state.panelSize = clamp(math.floor(res.vx_psz + 0.5), -1, 2) end
    if type(res.vx_pw) == 'number' then state.panelW = clamp(res.vx_pw, 300, 560) end
    if type(res.vx_ph) == 'number' then state.panelH = clamp(res.vx_ph, 380, 680) end
    if type(res.vx_sec) == 'string' then state.section = res.vx_sec end
  end
end

local function persist()
  if not stored then return end
  stored.vx_hud = state.hudVisible
  stored.vx_rpm = state.rpmBar
  stored.vx_op = state.hudOp
  stored.vx_sc = state.hudScale
  stored.vx_ox = state.orbX
  stored.vx_oy = state.orbY
  stored.vx_sx = state.spdX
  stored.vx_sy = state.spdY
  stored.vx_psz = state.panelSize
  stored.vx_pw = state.panelW
  stored.vx_ph = state.panelH
  stored.vx_sec = state.section
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
  local list, byId = {}, {}
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
        list[#list + 1] = d
        byId[i] = d
      end
    end
  end
  state.configList = list
  state.configById = byId
  state.destList = list
  state.destById = byId
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

local function headingDir(heading)
  local rad = math.rad(heading)
  return vec3(math.sin(rad), 0, -math.cos(rad))
end

local function teleportSelf(pos, dir, message)
  local ok = pcall(function()
    physics.setCarPosition(0, pos, dir)
  end)
  if ok then
    if message then toast(message) end
    return true
  end
  toast(L.teleportFailed, 'warn')
  return false
end

local function teleportConfigDest(d)
  if not d or not d.pos then return false end
  return teleportSelf(d.pos, headingDir(d.heading), string.format('TELEPORTED TO %s', d.name))
end

local function teleportDest(d)
  if not d then return end
  if state.destSource == 'chat' and state.chatEx then
    local ok, res = pcall(function() return state.chatEx.teleportTo(d.id) end)
    if ok and res then
      toast(string.format('TELEPORTED TO %s', d.name))
      return
    end
  end
  if d.pos then
    teleportConfigDest(d)
  else
    toast(L.teleportFailed, 'warn')
  end
end

local function returnToPits()
  local d = state.configById[0] or state.configList[1]
  if d then
    teleportConfigDest(d)
  else
    toast(L.noDestinations, 'warn')
  end
end

local function teleportToPlayer(p)
  if state.teleportCooldown > 0.05 then
    toast(string.format(L.pleaseWait, math.ceil(state.teleportCooldown)), 'warn')
    return
  end
  if not p then return end
  local target = ac.getCar(p.index)
  if not target or not target.isActive or not target.isConnected then
    toast(L.playerUnavailable, 'warn')
    return
  end
  if stateVal(target, 'isAIControlled') then
    toast(L.playerUnavailable, 'warn')
    return
  end
  local me = car()
  if not me then
    toast(L.teleportFailed, 'warn')
    return
  end
  if me.speedKmh > 5 then
    toast(L.stopCarFirst, 'warn')
    return
  end
  local lk = target.look
  local lx, lz
  if lk and type(lk.x) == 'number' and type(lk.z) == 'number' then
    lx, lz = lk.x, lk.z
  else
    lx, lz = 0, -1
  end
  local len = math.sqrt(lx * lx + lz * lz)
  if len < 0.001 then
    lx, lz, len = 0, -1, 1
  end
  lx, lz = lx / len, lz / len
  local behind = vec3(target.position.x - lx * 11, target.position.y, target.position.z - lz * 11)
  local ok = pcall(function()
    physics.setCarPosition(0, behind, vec3(lx, 0, lz))
    physics.setCarVelocity(0, vec3(0, 0, 0))
    physics.awakeCar(0)
  end)
  if ok then
    state.teleportCooldown = 2.5
    toast(string.format(L.teleportedToPlayer, p.name))
  else
    toast(L.teleportFailed, 'warn')
  end
end

local function isHumanCar(c, nm, mid, sid)
  if stateVal(c, 'isAIControlled') then return false end
  if type(sid) ~= 'number' or not HUMAN_SESSION_IDS[sid] then return false end
  if type(nm) == 'string' then
    if nm:find('TRAFFIC', 1, true) then return false end
    if nm:lower():find('traffic', 1, true) then return false end
  end
  if type(mid) == 'string' then
    local ml = mid:lower()
    if ml:find('traffic', 1, true) or ml:find('authentic_ai', 1, true) then return false end
  end
  return true
end

local function refreshPlayers(force)
  if not force and (state.frames - state.playersAt) < 30 then return end
  state.playersAt = state.frames
  local me = car()
  if not me or not me.position then return end
  local myPos = me.position
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
  state.destList = state.configList
  state.destById = state.configById
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
    toast(L.colorNoModule, 'warn')
    return
  end
  local arg = nil
  if c then arg = rgb(c.r, c.g, c.b) end
  local ok, res = pcall(function() return state.chatEx.changeCarColor(arg) end)
  if not ok then
    toast(L.colorFail, 'warn')
    return
  end
  if res then
    toast(c and L.colorUpdated or L.colorResetMsg)
  else
    toast(L.colorNotAllowed, 'warn')
  end
end

local function initPicker()
  if state.pickerInit then return end
  local ownCar = car()
  local cc = ownCar and ownCar.customCarColor or nil
  if cc and cc.r == cc.r then
    state.picker.r = cc.r
    state.picker.g = cc.g
    state.picker.b = cc.b
  end
  state.pickerInit = true
end

local function toggleHeadlights()
  local c = car()
  pcall(function() ac.setHeadlights(not c.headlightsActive) end)
end

local function toggleHighBeams()
  local c = car()
  pcall(function() ac.setHighBeams(not c.highBeams) end)
end

local function gearString(g)
  if g == -1 then return 'R' end
  if g == 0 then return 'N' end
  return tostring(g)
end

local function prettyModel(id)
  if type(id) ~= 'string' or id == '' then return '' end
  local s = id:gsub('[%_%-]+', ' ')
  if #s > 26 then s = s:sub(1, 26) end
  return s
end

local function serverSec()
  local s = sim()
  if not s then return 0 end
  return s.timeTotalSeconds or 0
end

local function setPanelSize(idx)
  idx = clamp(idx, 0, 2)
  state.panelSize = idx
  state.panelW = PANEL_SIZES[idx + 1][1]
  state.panelH = PANEL_SIZES[idx + 1][2]
  applyPanelSize()
  persist()
end

local function setSection(key)
  if state.section ~= key then
    state.section = key
    state.sectT = 0
  end
  if key == 'TELEPORT' then
    refreshDestinations(true)
  elseif key == 'COLOR' then
    probeColor(true)
    state.pickerInit = false
    initPicker()
  elseif key == 'TIME' then
    state.time.probeAt = -999
  elseif key == 'PLAYERS' then
    refreshPlayers(true)
  end
  persist()
end

local function openPanel(key)
  if not state.panelOpen then
    state.panelTX, state.panelTY = panelTargetPos()
    state.navX = -1
  end
  if key then setSection(key) end
  state.panelOpen = true
end

local function closePanel()
  state.panelOpen = false
end

local function pushGlass()
  ui.pushStyleVar(ui.StyleVar.WindowRounding, 12)
  ui.pushStyleVar(ui.StyleVar.WindowPadding, vec2(10, 8))
  ui.pushStyleVar(ui.StyleVar.ItemSpacing, vec2(6, 6))
  ui.pushStyleVar(ui.StyleVar.FrameRounding, 7)
  ui.pushStyleVar(ui.StyleVar.FramePadding, vec2(9, 5))
  ui.pushStyleColor(ui.StyleColor.WindowBg, C.glassDeep)
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

local function withWindow(id, pos, size, content, noPad, interactiveTool)
  pushGlass()
  local begun = false
  local ok, err = pcall(function()
    if interactiveTool then
      ui.beginToolWindow(id, pos, size, noPad == true, true)
    else
      -- Keep the working HUD/speedometer rendering pipeline intact.
      ui.beginTransparentWindow(id, pos, size, noPad == true, true)
    end
    begun = true
    content()
  end)
  if begun then
    local endOK, endErr = pcall(function()
      if interactiveTool then ui.endToolWindow() else ui.endTransparentWindow() end
    end)
    if not endOK and ok then ok, err = false, endErr end
  end
  popGlass()
  if not ok then error('VENOM X [' .. tostring(id) .. '] ' .. tostring(err), 0) end
end

local function withAlpha(a, fn)
  ui.pushStyleVarAlpha(a)
  local ok, err = pcall(fn)
  ui.popStyleVar()
  if not ok then error(err, 0) end
end

local function sectionLabel(text)
  ui.textColored(text, C.accentSoft)
end

local function drawChip(p, text, color, minWidth)
  local tsz = ui.measureDWriteText(text, 12, -1)
  local w = math.max(minWidth or 0, tsz.x + 22)
  ui.drawRectFilled(p, vec2(p.x + w, p.y + 22), C.card, 11)
  ui.drawRect(p, vec2(p.x + w, p.y + 22), col(color, 0.5), 11, ui.CornerFlags.All, 1)
  ui.dwriteDrawText(text, 12, vec2(p.x + (w - tsz.x) * 0.5, p.y + 4), color)
  return w
end

local function drawHome()
  refreshPlayers(false)
  local realHumans = #state.players + 1
  ui.textColored('LA CANYONS  /  FREEROAM', C.accentSoft)
  ui.separator()
  ui.textColored('WELCOME TO VENOM X', C.text)
  ui.textDisabled('Connected drivers: ' .. tostring(realHumans))
  ui.textDisabled('Quick access to your favorite features.')
  ui.dummy(vec2(0, 8))

  if ui.button('TELEPORT LOCATIONS   >##vxhomeTP', vec2(0, 39)) then setSection('TELEPORT') end
  if ui.button('ONLINE PLAYERS   >##vxhomePL', vec2(0, 39)) then setSection('PLAYERS') end
  if ui.button('CUSTOM CAR COLOR   >##vxhomeCL', vec2(0, 39)) then setSection('COLOR') end
  if ui.button('TIME & SKY   >##vxhomeTM', vec2(0, 39)) then setSection('TIME') end
  ui.separator()
  local me = car()
  if me then
    local halfW = math.max(90,(PANEL_W - 43) * 0.5)
    if ui.button(me.headlightsActive and 'LIGHTS ON##vxlts' or 'LIGHTS OFF##vxlts', vec2(halfW, 31)) then toggleHeadlights() end
    ui.sameLine()
    if ui.button(me.highBeams and 'BEAMS ON##vxhb' or 'BEAMS OFF##vxhb', vec2(halfW, 31)) then toggleHighBeams() end
  end
  if ui.button('RETURN TO PITS##vxpit', vec2(0, 34)) then returnToPits() end
end

local function drawTeleport()
  sectionLabel(state.destSource == 'chat' and 'SERVER DESTINATIONS' or 'CONFIG DESTINATIONS')
  local changed, entered
  state.search, changed, entered = ui.inputText(L.destSearch, state.search)
  if ui.itemHovered() then ui.setTooltip('Filter destinations by name or group') end
  if #state.destList == 0 then
    ui.textDisabled(L.noDestinations)
    return
  end
  local q = state.search:lower()
  local groups, order = {}, {}
  for _, d in ipairs(state.destList) do
    local okMatch = q == '' or d.name:lower():find(q, 1, true) ~= nil or d.group:lower():find(q, 1, true) ~= nil
    if okMatch then
      if not groups[d.group] then
        groups[d.group] = {}
        order[#order + 1] = d.group
      end
      local g = groups[d.group]
      g[#g + 1] = d
    end
  end
  if #order == 0 then
    ui.textDisabled(L.noDestinations)
    return
  end
  for _, gname in ipairs(order) do
    local g = groups[gname]
    local open = state.groupOpen[gname]
    if open == nil then open = false end
    local label = (open and '-  ' or '+  ') .. gname .. '  (' .. #g .. ')'
    ui.pushStyleColor(ui.StyleColor.Button, open and C.btnActive or C.btnFlat)
    ui.pushStyleColor(ui.StyleColor.Text, C.accent)
    local clicked = ui.button(label, vec2(0, 26))
    ui.popStyleColor(2)
    if clicked then
      state.groupOpen[gname] = not open
      open = not open
    end
    if open then
      for _, d in ipairs(g) do
        if ui.button(d.name, vec2(0, 23)) then
          teleportDest(d)
        end
        if ui.itemHovered() then ui.setTooltip(string.format('%s\n%s', d.name, d.group)) end
      end
    end
  end
  ui.separator()
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
  ui.textColored(string.format('%d CONNECTED', #state.players), C.accentSoft)
  ui.textDisabled(L.teleportHint)
  if #state.players == 0 then
    ui.textDisabled(L.noPlayers)
  end
  for _, pl in ipairs(state.players) do
    ui.pushStyleVar(ui.StyleVar.ChildRounding, 10)
    local opened = ui.beginChild('vx_pl' .. pl.index, vec2(0, 72), false, ui.WindowFlags.None)
    local okp, errp = pcall(function()
      if opened then
        local title = pl.name
        if #title > 24 then title = title:sub(1, 24) end
        ui.dwriteDrawText(title, 14, ui.cursorScreenPos(), C.text)
        ui.dummy(vec2(0, 18))
        ui.textDisabled(string.format('%s - %d m', prettyModel(pl.model), math.floor(pl.dist + 0.5)))
        if ui.button('TELEPORT##pl' .. pl.index, vec2(0, 24)) then
          teleportToPlayer(pl)
        end
      end
    end)
    ui.endChild()
    ui.popStyleVar()
    if not okp then error(errp, 0) end
  end
  ui.textDisabled(L.trafficHidden)
  if state.teleportCooldown > 0.05 then
    ui.textColored(string.format(L.cooldown, state.teleportCooldown), C.warn)
  end
end

local function drawColor()
  probeColor(false)
  initPicker()
  sectionLabel(L.carColor)
  local me = car()
  if not me then
    ui.textColored(L.colorNoModule, C.warn)
    return
  end
  local cc = me.customCarColor
  local p = ui.cursorScreenPos()
  local hasCustom = cc and cc.r == cc.r
  local prev = hasCustom and cc or state.picker
  ui.drawRectFilled(p, vec2(p.x + 34, p.y + 34), rgbm(prev.r, prev.g, prev.b, 1), 8)
  ui.drawRect(p, vec2(p.x + 34, p.y + 34), rgbm(1, 1, 1, 0.4), 8, ui.CornerFlags.All, 1)
  ui.dwriteDrawText(hasCustom and 'CURRENT' or 'LIVERY', 12, vec2(p.x + 44, p.y + 2), C.dim)
  ui.dwriteDrawText(string.format('%d %d %d', math.floor(prev.r * 255 + 0.5), math.floor(prev.g * 255 + 0.5), math.floor(prev.b * 255 + 0.5)), 12, vec2(p.x + 44, p.y + 18), C.text)
  ui.dummy(vec2(0, 40))
  if not state.chatEx then
    ui.textColored(L.colorNoModule, C.warn)
    return
  end
  if state.colorAllowed == false then
    ui.textColored(L.colorNotAllowed, C.warn)
  end
  local swW = math.floor((PANEL_W - 40 - 30) / 6)
  if swW < 24 then swW = 24 end
  for i, pr in ipairs(PRESETS) do
    if i > 1 and (i - 1) % 6 ~= 0 then ui.sameLine() end
    local c = rgbm(pr.r, pr.g, pr.b, 1)
    if ui.colorButton('##pw' .. i, c, bit.bor(ui.ColorPickerFlags.NoAlpha, ui.ColorPickerFlags.NoTooltip), vec2(swW, 28)) then
      state.picker.r = pr.r
      state.picker.g = pr.g
      state.picker.b = pr.b
      applyColor(c)
    end
    if ui.itemHovered() then ui.setTooltip(pr.label) end
  end
  ui.dummy(vec2(0, 8))
  if ui.button(L.colorApply, vec2((PANEL_W - 44) / 2, 30)) then
    applyColor(state.picker)
  end
  ui.sameLine()
  if ui.button(L.colorReset, vec2((PANEL_W - 44) / 2, 30)) then
    applyColor(nil)
  end
  local pickerFlags = bit.bor(ui.ColorPickerFlags.NoAlpha, ui.ColorPickerFlags.PickerHueBar, ui.ColorPickerFlags.NoSidePreview)
  local changed = ui.colorPicker('##vx_picker', state.picker, pickerFlags)
  if changed then
    state.pickerDirty = true
  end
  if state.pickerDirty and not ui.mouseDown(0) then
    state.pickerDirty = false
    applyColor(state.picker)
  end
  ui.textDisabled(L.liveryNote)
end

local function drawTime()
  local tm = state.time
  if tm.probeAt < 0 or (state.frames - tm.probeAt) > 60 then
    tm.probeAt = state.frames
    local ok, st = pcall(ac.load, STORE_STATUS)
    if ok then
      tm.helper = st
      if st ~= nil then tm.helperSeen = true end
    end
    local ok2, ap = pcall(ac.load, STORE_APPLIED)
    if ok2 and ap ~= nil then tm.applied = ap end
  end
  local installed = tm.helperSeen
  local hookMissing = type(tm.helper) == 'string' and tm.helper:find('hook-missing', 1, true) ~= nil
  local visualSec = wrapDay(serverSec() + tm.curOffset)
  local p = ui.cursorScreenPos()
  ui.dwriteDrawText(fmtSec(visualSec), 38, p, C.text)
  local tsz = ui.measureDWriteText(fmtSec(visualSec), 38, -1)
  ui.dummy(vec2(0, tsz.y + 2))
  local chipY = ui.cursorScreenPos().y
  local cx = p.x
  cx = cx + drawChip(vec2(cx, chipY), L.localTime, C.accent, 96) + 6
  local ctrl = hookMissing and L.controllerWfx or L.controllerPure
  cx = cx + drawChip(vec2(cx, chipY), ctrl, hookMissing and C.danger or C.ok, 84) + 6
  if installed and not hookMissing then
    drawChip(vec2(cx, chipY), tm.applied == 'yes' and L.timeReady or L.timeWaiting, tm.applied == 'yes' and C.ok or C.warn, 110)
  end
  ui.dummy(vec2(0, 30))
  ui.separator()
  if hookMissing then
    ui.textColored(L.timeUnavailable, C.warn)
    return
  end
  if not installed then
    sectionLabel('SERVER TIME')
    ui.textWrapped('Core VENOM X features work from the server script alone. Local sky-time override needs client-side weather access and is not available with a single CSP online script. The server clock remains available above.')
    return
  end
  local tv = wrapDay(serverSec() + tm.curOffset)
  local nv = ui.slider('##vx_tl', tv, 0, 86399, '', 1)
  if math.abs(nv - tv) > 0.5 then
    tm.want = wrapOffset(nv - serverSec())
  end
  local bw = (PANEL_W - 40) / 2
  for i, pr in ipairs(TIME_PRESETS) do
    if (i - 1) % 2 > 0 then ui.sameLine() end
    if ui.button(pr.label, vec2(bw, 28)) then
      tm.want = wrapOffset(pr.sec - serverSec())
      if pr.sec >= 21 * 3600 or pr.sec < 3600 then
        toast(L.nightMode)
      end
    end
  end
  if ui.button(L.timeReset, vec2(0, 30)) then
    tm.want = 0
    toast(L.resetDone)
  end
  ui.textColored(string.format(L.timeActive, tm.curOffset / 3600), C.dim)
end

local function drawHud()
  sectionLabel(L.hudSettings)
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
    state.hudVisible = true
    state.hudOp = 90
    state.hudScale = 100
    state.orbX, state.orbY = 16, -1
    state.spdX, state.spdY = -1, -1
    setPanelSize(1)
    persist()
    toast(L.resetPositions)
  end
  ui.separator()
  sectionLabel('PANEL SIZE')
  local szW = (PANEL_W - 40) / 3
  local szNames = { 'S', 'M', 'L' }
  for i = 0, 2 do
    if i > 0 then ui.sameLine() end
    local lbl = (state.panelSize == i) and ('[' .. szNames[i + 1] .. ']') or (' ' .. szNames[i + 1] .. ' ')
    if ui.button(lbl, vec2(szW, 28)) then setPanelSize(i) end
  end
  ui.separator()
  ui.textDisabled(L.hudNote)
  ui.separator()
  sectionLabel('DEBUG')
  local spdErr = state.spdErrors or 0
  ui.textDisabled('Speedometer renderer: ' .. (spdErr == 0 and 'ACTIVE' or ('ERROR x' .. tostring(spdErr))))
  if state.spdErrorMsg then ui.textWrapped('Last error: ' .. tostring(state.spdErrorMsg):sub(1, 180)) end
  local dx0, dy0 = speedoRect()
  ui.textDisabled(string.format('X: %d  Y: %d', math.floor(dx0 + 0.5), math.floor(dy0 + 0.5)))
  ui.textDisabled(string.format('Scale: %d%%  Opacity: %d%%', clamp(state.hudScale or 100, 80, 130), clamp(state.hudOp or 90, 40, 100)))
end

local function drawSection(key)
  if key == 'HOME' then drawHome()
  elseif key == 'TELEPORT' then drawTeleport()
  elseif key == 'PLAYERS' then drawPlayers()
  elseif key == 'COLOR' then drawColor()
  elseif key == 'TIME' then drawTime()
  elseif key == 'HUD' then drawHud() end
end

local function clampPos(x, y, sw, sh)
  x = clamp(x, 8, sw - ORB_SIZE - 8)
  y = clamp(y, 56, sh - ORB_SIZE - 8)
  return x, y
end

local function drawVenomLauncher()
  local scr = getScreenSize()
  if state.orbY < 0 or state.orbX < 0 or state.orbY > scr.y - ORB_SIZE or state.orbX > scr.x - ORB_SIZE then
    state.orbX = 16
    state.orbY = math.floor(scr.y * 0.5 - ORB_SIZE * 0.5)
    persist()
  end

  -- CSP tool windows are explicitly interactive, unlike ordinary HUD overlays.
  withWindow('vx_floating_launch', vec2(state.orbX, state.orbY), vec2(ORB_SIZE, ORB_SIZE), function()
    ui.setCursor(vec2(0, 0))
    local clicked = ui.invisibleButton('##vxlauncher_btn', vec2(ORB_SIZE, ORB_SIZE))
    local hovered, active = ui.itemHovered(), ui.itemActive()
    local mouse = ui.mousePos()

    if not state.orbPress and hovered and ui.mouseClicked(0) then
      state.orbPress = { mx = mouse.x, my = mouse.y, x = state.orbX, y = state.orbY, moved = false }
    end
    local press = state.orbPress
    if press then
      if ui.mouseDown(0) then
        local dx, dy = mouse.x - press.mx, mouse.y - press.my
        if (dx * dx + dy * dy) > DRAG_THRESHOLD * DRAG_THRESHOLD then press.moved = true end
        if press.moved then
          state.orbX, state.orbY = clampPos(press.x + dx, press.y + dy, scr.x, scr.y)
        end
      else
        if press.moved then
          persist()
        elseif clicked or hovered then
          if state.panelOpen then closePanel() else openPanel(nil) end
        end
        state.orbPress = nil
      end
    elseif clicked and not state.dragging then
      if state.panelOpen then closePanel() else openPanel(nil) end
    end

    state.orbHover = anim(state.orbHover, hovered and 1 or 0, 12, state.dt)
    local glow = (0.33 + state.orbHover * 0.30 + (active and 0.12 or 0))
    ui.drawRectFilled(vec2(0, 0), vec2(ORB_SIZE, ORB_SIZE), C.glassDeep, 15)
    ui.drawRect(vec2(1, 1), vec2(ORB_SIZE - 1, ORB_SIZE - 1), col(C.accent, glow), 14, ui.CornerFlags.All, 1.7)
    if state.panelOpen then
      ui.drawRectFilled(vec2(8, ORB_SIZE - 5), vec2(ORB_SIZE - 8, ORB_SIZE - 3), C.accent, 1)
    end
    local titleSize = ui.measureDWriteText('X', 28, -1)
    ui.dwriteDrawText('X', 28, vec2((ORB_SIZE - titleSize.x) * .5, 2), C.accent)
    local capSize = ui.measureDWriteText('VENOM', 9, -1)
    ui.dwriteDrawText('VENOM', 9, vec2((ORB_SIZE - capSize.x) * .5, 37), C.dim)
  end, true, true)
end

local function drawVenomPanel()
  if state.openT < .015 then return end
  local progress = easeOutCubic(clamp(state.openT, 0, 1))
  local px, py, pw, ph
  if state.openT >= .97 then
    px, py, pw, ph = state.panelTX, state.panelTY, PANEL_W, PANEL_H
  else
    px = lerp(state.orbX, state.panelTX, progress)
    py = lerp(state.orbY, state.panelTY, progress)
    pw = lerp(ORB_SIZE, PANEL_W, progress)
    ph = lerp(ORB_SIZE, PANEL_H, progress)
  end

  withWindow('vx_main_overlay', vec2(px, py), vec2(pw, ph), function()
    -- A tiny expanding preview stays non-interactive during the morph animation.
    ui.drawRectFilled(vec2(0, 0), vec2(pw, ph), C.glassDeep, 12)
    ui.drawRect(vec2(0, 0), vec2(pw, ph), col(C.accent, .23), 12, ui.CornerFlags.All, 1)
    ui.drawRectFilled(vec2(12, 0), vec2(math.max(12, pw - 12), 2), C.accent, 1)

    if state.openT < .90 then
      ui.dwriteDrawText('X', 22, vec2(14, 12), C.accent)
      return
    end

    -- Two-layer header: single native drag hitbox plus a real close button.
    ui.drawRectFilled(vec2(1, 2), vec2(pw - 1, 67), C.cardSolid, 11)
    ui.setCursor(vec2(12, 10))
    ui.invisibleButton('##vxhead_drag', vec2(math.max(90, PANEL_W - 76), 51))
    local hovered = ui.itemHovered()
    local mouse = ui.mousePos()
    if not state.panelDrag and hovered and ui.mouseClicked(0) then
      state.panelDrag = {
        x = state.panelTX, y = state.panelTY,
        mx = mouse.x, my = mouse.y, moved = false
      }
    end
    local dp = state.panelDrag
    if dp then
      if ui.mouseDown(0) then
        local dx, dy = mouse.x - dp.mx, mouse.y - dp.my
        if dx * dx + dy * dy > 9 then dp.moved = true end
        if dp.moved then
          local scr = getScreenSize()
          state.panelTX = clamp(dp.x + dx, 8, math.max(8, scr.x - PANEL_W - 8))
          state.panelTY = clamp(dp.y + dy, 48, math.max(48, scr.y - PANEL_H - 8))
        end
      else
        if dp.moved then persist() end
        state.panelDrag = false
      end
    end
    ui.dwriteDrawText('VENOM', 18, vec2(18, 12), C.text)
    ui.dwriteDrawText('X', 18, vec2(93, 12), C.accent)
    ui.dwriteDrawText('LA CANYONS   /   ONLINE', 11, vec2(18, 38), C.dim)

    ui.setCursor(vec2(PANEL_W - 46, 17))
    if ui.button('X##vx_panel_close', vec2(30, 28)) then closePanel() end

    -- Compact segmented navigation with meaningful hover/active styling.
    local navW = math.floor((PANEL_W - 36) / 3)
    for i, item in ipairs(NAV) do
      local row = math.floor((i - 1) / 3)
      local column = (i - 1) % 3
      local xx = 12 + column * (navW + 6)
      local yy = 76 + row * 36
      local selected = state.section == item.key
      ui.setCursor(vec2(xx, yy))
      if selected then
        ui.pushStyleColor(ui.StyleColor.Button, C.btnActive)
        ui.pushStyleColor(ui.StyleColor.Text, C.text)
      end
      local click = ui.button(item.label .. '##vxnav_' .. i, vec2(navW, 30))
      if selected then
        ui.popStyleColor(2)
        ui.drawRectFilled(vec2(xx + 16, yy + 29),
          vec2(xx + navW - 16, yy + 31), col(C.accent, clamp(state.sectT * 2, .3, 1)), 1)
      end
      if click then setSection(item.key) end
    end

    ui.drawLine(vec2(13, 153), vec2(PANEL_W - 13, 153), C.accentFaint, 1)
    ui.setCursor(vec2(12, 160))
    local contentH = math.max(100, PANEL_H - 218)
    local opened = ui.beginChild('vx_feature_content', vec2(PANEL_W - 24, contentH), false, ui.WindowFlags.None)
    local ok, err = pcall(function()
      if opened then
        -- Native alpha is applied only to content, not the button hitboxes around it.
        local fade = clamp((state.openT - .90) / .10, 0.05, 1)
        withAlpha(fade * clamp(state.sectT * 2, .1, 1), function()
          drawSection(state.section)
        end)
      end
    end)
    ui.endChild()
    if not ok then
      state.panelErrorMsg = tostring(err)
      if state.reportedSectionError ~= tostring(err) then
        pcall(ac.log, 'VENOM X section ' .. state.section .. ': ' .. tostring(err))
        state.reportedSectionError = tostring(err)
      end
    else
      state.reportedSectionError = nil
      state.panelErrorMsg = nil
    end

    local footY = PANEL_H - 45
    ui.drawLine(vec2(13, footY - 5), vec2(PANEL_W - 13, footY - 5), C.accentFaint, 1)
    ui.dwriteDrawText('VENOM X   ' .. VERSION, 11, vec2(15, footY + 3), C.dim)
    ui.dwriteDrawText('CTRL+SHIFT+X', 10, vec2(15, footY + 20), C.accentSoft)

    -- Bottom right drag handle, size changes in real time. No full-screen input.
    ui.setCursor(vec2(PANEL_W - 39, PANEL_H - 39))
    ui.invisibleButton('##vxresize', vec2(28, 29))
    if ui.itemActive() and ui.mouseDown(0) then
      local delta = ui.mouseDelta()
      local scr = getScreenSize()
      if delta and (delta.x ~= 0 or delta.y ~= 0) then
        state.panelW = clamp(PANEL_W + delta.x, 300, math.min(560, scr.x - 18))
        state.panelH = clamp(PANEL_H + delta.y, 380, math.min(680, scr.y - 50))
        state.panelSize = -1
        applyPanelSize()
      end
    elseif state.panelSize == -1 and ui.itemHovered() and ui.mouseReleased(0) then
      persist()
    end
    ui.drawLine(vec2(PANEL_W - 11, PANEL_H - 31), vec2(PANEL_W - 27, PANEL_H - 15), C.accentSoft, 2)
    ui.drawLine(vec2(PANEL_W - 11, PANEL_H - 23), vec2(PANEL_W - 19, PANEL_H - 15), C.dim, 2)
  end, true, true)
end

local function drawToasts()
  if #state.toasts == 0 then return end
  local scr = getScreenSize()
  pushGlass()
  local okc = pcall(function()
    ui.beginTransparentWindow('vx_toasts', vec2(0, 0), vec2(scr.x, 176), true, false)
    for i, t in ipairs(state.toasts) do
      local aIn = clamp(t.t / 0.16, 0, 1)
      local aOut = clamp((t.dur - t.t) / 0.3, 0, 1)
      local a = easeOutCubic(aIn) * aOut
      if a > 0.02 then
        local tsz = ui.measureDWriteText(t.text, 14, -1)
        local w = math.max(240, tsz.x + 44)
        local h = 40
        local slide = (1 - easeOutCubic(aIn)) * -18
        local x = (scr.x - w) * 0.5
        local y = 24 + (i - 1) * (h + 8) + slide
        ui.drawRectFilled(vec2(x, y), vec2(x + w, y + h), rgbm(0.045, 0.055, 0.090, 0.95 * a), 10)
        ui.drawRect(vec2(x, y), vec2(x + w, y + h), rgbm(C.accent.r, C.accent.g, C.accent.b, 0.35 * a), 10, ui.CornerFlags.All, 1)
        local barC = t.kind == 'warn' and C.warn or C.ok
        ui.drawRectFilled(vec2(x + 1, y + 8), vec2(x + 5, y + h - 8), rgbm(barC.r, barC.g, barC.b, a), 2)
        ui.dwriteDrawText(t.text, 14, vec2(x + 18, y + (h - 18) * 0.5), rgbm(1, 1, 1, a))
      end
    end
    ui.endTransparentWindow()
  end)
  if not okc then
    pcall(ui.endTransparentWindow)
  end
  popGlass()
end

speedoRect = function()
  local scr = getScreenSize()
  local k = clamp(state.hudScale or 100, 80, 130) / 100
  local w = math.floor(220 * k)
  local h = math.floor(150 * k)
  local x0, y0 = state.spdX, state.spdY
  if type(x0) ~= 'number' or x0 < 0 then
    x0 = scr.x - w - 26
    y0 = scr.y - h - 90
  end
  if type(y0) ~= 'number' or y0 < 0 then
    y0 = scr.y - h - 90
  end
  if x0 > scr.x - 40 or y0 > scr.y - 40 or x0 + w < 40 or y0 + h < 40 then
    x0 = scr.x - w - 26
    y0 = scr.y - h - 90
    state.spdX, state.spdY = -1, -1
    persist()
  end
  x0 = clamp(x0, 8, math.max(8, scr.x - w - 8))
  y0 = clamp(y0, 48, math.max(48, scr.y - h - 8))
  return x0, y0, w, h, k
end

local function handleSpeedoDrag(x0, y0, w, h)
  local mp = ui.mousePos()
  local r = { x = x0, y = y0, w = w, h = h }
  local press = state.spdPress
  if not press and not state.dragging and not panelBlocks() and ui.mouseClicked(0) and inRect(r, mp) then
    press = { ox = x0, oy = y0, mx = mp.x, my = mp.y, moved = false }
    state.spdPress = press
  end
  if press then
    if ui.mouseDown(0) then
      if not press.moved then
        local dx = mp.x - press.mx
        local dy = mp.y - press.my
        if dx * dx + dy * dy > DRAG_THRESHOLD * DRAG_THRESHOLD then
          press.moved = true
          state.dragging = 'spd'
        end
      end
      if press.moved then
        local scr = getScreenSize()
        state.spdX = clamp(press.ox + (mp.x - press.mx), 8, scr.x - w - 8)
        state.spdY = clamp(press.oy + (mp.y - press.my), 48, scr.y - h - 8)
        return state.spdX, state.spdY
      end
      return x0, y0
    end
    if press.moved then
      persist()
    end
    state.spdPress = nil
    state.dragging = nil
  end
  return x0, y0
end

local function drawSpeedometer()
  if not state.hudVisible then return end
  local c = car()
  if not c then return end
  local speed = math.max(0, tonumber(c.speedKmh) or 0)
  local rpm = math.max(0, tonumber(c.rpm) or 0)
  local gearNum = tonumber(c.gear) or 0
  local x0, y0, w, h, k = speedoRect()
  x0, y0 = handleSpeedoDrag(x0, y0, w, h)
  if state.spdX < 0 then
    state.spdX, state.spdY = x0, y0
  end
  local opacity = clamp(state.hudOp or 90, 40, 100) / 100

  -- CSP's transparent window drawing space starts at (0,0) relative to its
  -- own position. NEVER add window screen offsets a second time: that caused
  -- the speedometer to be fully clipped even while its renderer said ACTIVE.
  withWindow('vx_speedo', vec2(x0, y0), vec2(w, h), function()
    ui.drawRectFilled(vec2(0, 0), vec2(w, h), col(C.cardSolid, opacity), 14)
    ui.drawRect(vec2(0, 0), vec2(w, h), col(C.accentFaint, opacity), 14, ui.CornerFlags.All, 1.5)

    state.smoothSpeed = anim(state.smoothSpeed, speed, 9, state.dt)
    local speedStr = tostring(math.floor(state.smoothSpeed + 0.5))
    local fs = math.floor(46 * k)
    local speedTextSize = ui.measureDWriteText(speedStr, fs, -1)
    ui.dwriteDrawText(speedStr, fs,
      vec2((w - speedTextSize.x) * 0.5, 8 * k), col(C.text, opacity))

    local kmTextSize = ui.measureDWriteText(L.kmh, 13, -1)
    ui.dwriteDrawText(L.kmh, 13,
      vec2((w - kmTextSize.x) * 0.5, 64 * k), col(C.accentSoft, opacity))

    ui.dwriteDrawText(string.format(L.gear, gearString(gearNum)), 15,
      vec2(14 * k, 88 * k), col(C.text, opacity))

    state.smoothRpm = anim(state.smoothRpm, rpm, 12, state.dt)
    local rpmStr = tostring(math.floor(state.smoothRpm / 10) * 10)
    local rpmLabel = string.format(L.rpmLabel, rpmStr)
    local rpmTextSize = ui.measureDWriteText(rpmLabel, 15, -1)
    ui.dwriteDrawText(rpmLabel, 15,
      vec2(w - 14 * k - rpmTextSize.x, 88 * k), col(C.dim, opacity))

    if state.rpmBar then
      local maxRpm = tonumber(c.rpmLimiter) or 8000
      if maxRpm <= 0 then maxRpm = 8000 end
      local frac = clamp(state.smoothRpm / maxRpm, 0, 1)
      local x1, y1, x2, y2 = 14 * k, 112 * k, w - 14 * k, 122 * k
      ui.drawRectFilled(vec2(x1, y1), vec2(x2, y2), col(C.bar, opacity), 5)
      if frac > 0.005 then
        local band = C.accent
        if frac > 0.85 and frac < 0.95 then
          band = mixCol(C.accent, C.warn, (frac - 0.85) / 0.10)
        elseif frac >= 0.95 and frac < 0.98 then
          band = mixCol(C.warn, C.danger, (frac - 0.95) / 0.03)
        elseif frac >= 0.98 then
          band = C.danger
        end
        ui.drawRectFilled(vec2(x1, y1), vec2(x1 + (x2 - x1) * frac, y2),
          col(band, opacity), 5)
      end
    end
    ui.dwriteDrawText(L.title, 11, vec2(14 * k, 132 * k),
      col(C.accentSoft, opacity * 0.6))
  end)
end

local function drawVenomPanelSafe()
  if state.openT > 0.01 then
    drawVenomPanel()
  end
end

local function drawEmergency()
  ui.pushStyleVar(ui.StyleVar.WindowPadding, vec2(12, 10))
  local okd, errd = pcall(function()
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
          local oke, erro = pcall(drawSection, item.key)
          ui.endTabItem()
          if not oke then errd = erro end
        end
      end
      ui.endTabBar()
    end
    ui.separator()
    ui.textDisabled(string.format(L.footer, VERSION))
  end)
  ui.popStyleVar()
  if not okd then
    pcall(function() ui.toast(ui.Icons.Warning, tostring(errd)) end)
  end
end

-- CSP native configurable hotkey, available with server-delivered online scripts.
-- If unavailable on a client, lightbulb remains a backup action.
do
  local ok, key = pcall(function()
    return ac.ControlButton('venomx/Toggle VENOM X Menu',
      { keyboard = { key = ui.KeyIndex.X, ctrl = true, shift = true } })
  end)
  if ok then state.menuShortcut = key end
end

local function timeBridgeUpdate(dt)
  local tm = state.time
  tm.curOffset = anim(tm.curOffset, tm.want, 2.2, dt)
  if math.abs(tm.want - tm.curOffset) < 2 then
    tm.curOffset = tm.want
  end
  pcall(function()
    ac.store(STORE_ENABLED, true)
    ac.store(STORE_OFFSET, tm.curOffset / 3600)
    local s = sim()
    ac.store(STORE_BEAT, s and s.frame or state.frames)
  end)
end

function script.update(dt)
  state.frames = state.frames + 1
  state.dt = math.min(dt or 0.016, 0.1)
  state.clock = state.clock + state.dt
  if state.teleportCooldown > 0 then
    state.teleportCooldown = math.max(0, state.teleportCooldown - state.dt)
  end
  local alive = {}
  for _, t in ipairs(state.toasts) do
    t.t = t.t + state.dt
    if t.t < t.dur then alive[#alive + 1] = t end
  end
  state.toasts = alive
  if state.menuShortcut and state.menuShortcut:pressed() then
    if state.panelOpen then closePanel() else openPanel(nil) end
  end
  local speed = (1 / OPEN_DUR)
  if state.panelOpen then
    state.openT = math.min(1, state.openT + state.dt * speed)
  else
    state.openT = math.max(0, state.openT - state.dt * speed * 1.15)
  end
  if state.sectT < 1 then
    state.sectT = math.min(1, state.sectT + state.dt * 7)
  end
  timeBridgeUpdate(state.dt)
  if state.panelOpen and state.section == 'PLAYERS' then
    refreshPlayers(false)
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
  local launchOk, launchErr = pcall(drawVenomLauncher)
  if launchOk then
    state.launcherErrors = 0
  else
    state.launcherErrors = (state.launcherErrors or 0) + 1
    if state.launcherErrors == 1 then pcall(ac.log, 'VENOM X launcher: ' .. tostring(launchErr)) end
  end
  local speedOk, speedErr = pcall(drawSpeedometer)
  if speedOk then
    state.spdErrors, state.spdErrorMsg = 0, nil
  else
    state.spdErrors = (state.spdErrors or 0) + 1
    state.spdErrorMsg = tostring(speedErr)
    if state.spdErrors == 1 then pcall(ac.log, 'VENOM X speedometer: ' .. state.spdErrorMsg) end
    -- Graceful fallback without dependencies if the styled CSP window fails.
    if state.hudVisible then
      local scr = getScreenSize()
      local began = false
      pcall(function()
        ui.beginTransparentWindow('vx_speed_recovery', vec2(math.max(8, scr.x - 220), math.max(48, scr.y - 170)), vec2(205, 110), true, false)
        began = true
        ui.text('VENOM X')
        local cc = car()
        ui.text(string.format('%d KM/H', math.floor(tonumber(cc and cc.speedKmh) or 0)))
        ui.endTransparentWindow()
        began = false
      end)
      if began then pcall(ui.endTransparentWindow) end
    end
  end
  if pcall(drawToasts) then
    state.toastErrors = 0
  else
    state.toastErrors = (state.toastErrors or 0) + 1
  end
  local ok, panelErr = pcall(drawVenomPanelSafe)
  if ok then
    state.drawErrors = 0
  else
    state.drawErrors = state.drawErrors + 1
    if state.drawErrors == 1 then pcall(ac.log, 'VENOM X panel: ' .. tostring(panelErr)) end
    if state.drawErrors == 3 then
      state.panelErrorMsg = tostring(panelErr)
      pcall(function() ui.toast(ui.Icons.Warning, 'VENOM X panel: ' .. tostring(panelErr):sub(1, 160)) end)
      -- Keep the X visible so the user can close it and access the lightbulb tool.
      closePanel()
    end
  end
end

loadStored()
applyPanelSize()
loadConfig()
buildConfigDests()
loadChat()
refreshDestinations(true)
setSection(state.section)

-- Lightbulb fallback is a one-click toggle, never an extra floating panel.
ui.registerOnlineExtra(ui.Icons.Bulb, L.title,
  function() return true end,
  nil,
  function(clicked)
    if clicked == false then return end
    if state.panelOpen then closePanel() else openPanel(nil) end
  end,
  ui.OnlineExtraFlags.None
)
