script = script or {}

local VERSION = '3.4.0'

local L = {
  title = 'VENOM X',
  subtitle = 'LA CANYONS',
  versionTag = 'v3.4.0',
  ready = 'VENOM X READY - tap the VENOM X launcher',
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
  hudNote = 'Drag the orb or the speedometer. Short click on the orb opens the panel.',
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
local PANEL_W = 340
local PANEL_H = 430
local PANEL_SIZES = { { 300, 380 }, { 340, 430 }, { 390, 500 } }
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
  panelW = 340,
  panelH = 430,
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
  PANEL_W = clamp(math.floor(state.panelW or 340), 260, 560)
  PANEL_H = clamp(math.floor(state.panelH or 430), 330, 640)
end

local function panelTargetPos()
  local scr = getScreenSize()
  local px = state.orbX + ORB_SIZE + 12
  if px + PANEL_W > scr.x - 12 then
    px = state.orbX - PANEL_W - 12
  end
  if px < 8 then px = 8 end
  local py = clamp(state.orbY - 20, 56, scr.y - PANEL_H - 12)
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
      vx_pw = 340,
      vx_ph = 430,
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
    if type(res.vx_pw) == 'number' then state.panelW = clamp(res.vx_pw, 260, 560) end
    if type(res.vx_ph) == 'number' then state.panelH = clamp(res.vx_ph, 330, 640) end
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

local function withWindow(id, pos, size, content, noPad)
  pushGlass()
  local begun = false
  local ok, err = pcall(function()
    ui.beginTransparentWindow(id, pos, size, noPad or false, true)
    begun = true
    content()
  end)
  if begun then
    local ended, endErr = pcall(ui.endTransparentWindow)
    if not ended and ok then ok, err = false, endErr end
  end
  popGlass()
  -- Errors must reach the protected renderer; otherwise a broken HUD reports ACTIVE.
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
  local s = sim()
  local cc = (s and type(s.connectedCars) == 'number') and s.connectedCars or 0
  local p = ui.cursorScreenPos()
  local w1 = drawChip(p, L.online, C.ok, 86)
  drawChip(vec2(p.x + w1 + 8, p.y), string.format(L.playersChip, cc), C.accent, 100)
  ui.dummy(vec2(0, 30))
  ui.dwriteDrawText(config.DISPLAY_NAME or L.title, 20, ui.cursorScreenPos(), C.text)
  ui.dummy(vec2(0, 28))
  ui.dwriteDrawText(config.DISPLAY_SUB or L.subtitle, 13, ui.cursorScreenPos(), C.dim)
  ui.dummy(vec2(0, 22))
  ui.separator()
  local bw = (PANEL_W - 34) / 2
  if ui.button(L.quickTeleport, vec2(bw, 34)) then openPanel('TELEPORT') end
  ui.sameLine()
  if ui.button(L.quickColor, vec2(bw, 34)) then openPanel('COLOR') end
  if ui.button(L.quickTime, vec2(bw, 34)) then openPanel('TIME') end
  ui.sameLine()
  if ui.button(L.quickPit, vec2(bw, 34)) then returnToPits() end
  ui.separator()
  if ui.button(L.returnToPits, vec2(0, 30)) then returnToPits() end
  local me = car()
  if me then
    local lb = (PANEL_W - 34) / 2
    if ui.button(me.headlightsActive and 'LIGHTS ON' or 'LIGHTS OFF', vec2(lb, 30)) then toggleHeadlights() end
    ui.sameLine()
    if ui.button(me.highBeams and 'BEAMS ON' or 'BEAMS OFF', vec2(lb, 30)) then toggleHighBeams() end
  end
  ui.separator()
  local tm = state.time
  ui.textDisabled('TIME: ' .. (tm.helper == nil and 'NO HELPER' or tostring(tm.helper)) .. ' / ' .. tostring(tm.applied))
  ui.textDisabled(string.format(L.footer, VERSION))
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
    if ui.colorButton('##pw' .. i, c, ui.ColorPickerFlags.NoAlpha, vec2(swW, 28)) then
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
  if state.orbY < 0 or state.orbX < -ORB_SIZE or state.orbY < -ORB_SIZE or state.orbX > scr.x or state.orbY > scr.y then
    state.orbX = 16
    state.orbY = math.floor(scr.y * 0.5 - ORB_SIZE / 2)
    persist()
  end
  local mp = ui.mousePos()
  withWindow('vx_launcher', vec2(state.orbX - 2, state.orbY - 2), vec2(ORB_SIZE + 4, ORB_SIZE + 4), function()
    ui.invisibleButton('##vxlaunch', vec2(ORB_SIZE, ORB_SIZE))
    local mn = ui.itemRectMin()
    local mx = ui.itemRectMax()
    local bx, by = mn.x, mn.y
    local bw, bh = mx.x - mn.x, mx.y - mn.y
    ui.drawRectFilled(vec2(bx, by), vec2(bx + bw, by + bh), C.glassDeep, 16)
    ui.drawRect(vec2(bx, by), vec2(bx + bw, by + bh), col(C.accent, 0.5 + state.orbHover * 0.3 + (state.orbPress and 0.2 or 0)), 16, ui.CornerFlags.All, 2)
    local cx = bx + bw * 0.5
    local xt = ui.measureDWriteText('X', 30, -1)
    ui.dwriteDrawText('X', 30, vec2(cx - xt.x * 0.5, by + 1), col(C.accent, 0.9))
    local cap = ui.measureDWriteText('VENOM X', 9, -1)
    ui.dwriteDrawText('VENOM X', 9, vec2(cx - cap.x * 0.5, by + bh - 13), C.dim)
    local r = { x = bx, y = by, w = bw, h = bh }
    local over = inRect(r, mp) and not state.dragging and not panelBlocks()
    state.orbHover = anim(state.orbHover, over and 1 or 0, 12, state.dt)
    local press = state.orbPress
    if not press and not state.dragging and not panelBlocks() and ui.mouseClicked(0) and inRect(r, mp) then
      press = { ox = state.orbX, oy = state.orbY, mx = mp.x, my = mp.y, moved = false }
      state.orbPress = press
    end
    if press then
      if ui.mouseDown(0) then
        if not press.moved then
          local dx = mp.x - press.mx
          local dy = mp.y - press.my
          if dx * dx + dy * dy > DRAG_THRESHOLD * DRAG_THRESHOLD then
            press.moved = true
            state.dragging = 'orb'
          end
        end
        if press.moved then
          state.orbX, state.orbY = clampPos(press.ox + (mp.x - press.mx), press.oy + (mp.y - press.my), scr.x, scr.y)
        end
      else
        if press.moved then
          state.orbX, state.orbY = clampPos(state.orbX, state.orbY, scr.x, scr.y)
          persist()
        elseif inRect(r, mp) then
          if state.panelOpen then closePanel() else openPanel(nil) end
        end
        state.orbPress = nil
        state.dragging = nil
      end
    end
  end, true)
end

local function drawVenomPanel()
  local t = easeOutCubic(clamp(state.openT, 0, 1))
  if t <= 0.01 then return end
  local px, py, pw, ph
  if state.openT >= 0.9 then
    px, py, pw, ph = state.panelTX, state.panelTY, PANEL_W, PANEL_H
  else
    px = lerp(state.orbX, state.panelTX, t)
    py = lerp(state.orbY, state.panelTY, t)
    pw = lerp(64, PANEL_W, t)
    ph = lerp(64, PANEL_H, t)
  end
  withWindow('vx_panel', vec2(px, py), vec2(pw, ph), function()
    if state.openT < 0.9 then
      local cx0 = px + pw * 0.5
      local cy0 = py + ph * 0.5
      local lc = col(C.accent, 0.4 + t * 0.6)
      ui.drawLine(vec2(cx0 - 9, cy0 - 9), vec2(cx0 + 9, cy0 + 9), lc, 3)
      ui.drawLine(vec2(cx0 + 9, cy0 - 9), vec2(cx0 - 9, cy0 + 9), lc, 3)
      return
    end
    local alpha = clamp((state.openT - 0.9) / 0.1, 0, 1)
    withAlpha(alpha, function()
      local headW = PANEL_W - 28
      ui.invisibleButton('##vxhead', vec2(headW - 32, 28))
      local hmn = ui.itemRectMin()
      local hmx = ui.itemRectMax()
      local mp = ui.mousePos()
      local hr = { x = hmn.x, y = hmn.y, w = hmx.x - hmn.x, h = hmx.y - hmn.y }
      if not state.panelDrag and not state.dragging and not state.orbPress and ui.mouseClicked(0) and inRect(hr, mp) then
        state.panelDrag = true
        state.dragging = 'panel'
        state.panelDragMouse = mp
        state.panelDragBase = vec2(state.panelTX, state.panelTY)
      end
      if state.panelDrag then
        if ui.mouseDown(0) then
          local scr = getScreenSize()
          state.panelTX = clamp(state.panelDragBase.x + (mp.x - state.panelDragMouse.x), 8, scr.x - PANEL_W - 8)
          state.panelTY = clamp(state.panelDragBase.y + (mp.y - state.panelDragMouse.y), 48, scr.y - 80)
        else
          state.panelDrag = false
          state.dragging = nil
        end
      end
      ui.dwriteDrawText(L.title, 15, vec2(hmn.x + 6, hmn.y + 4), C.accent)
      local tw = ui.measureDWriteText(L.title, 15, -1)
      ui.dwriteDrawText(state.section, 12, vec2(hmn.x + 6 + tw.x + 8, hmn.y + 6), C.text)
      ui.sameLine()
      if ui.button('X', vec2(26, 26)) then closePanel() end
      ui.separator()
      local twoRow = PANEL_W < 320
      local perRow = twoRow and 3 or 6
      local itemW = (PANEL_W - 28 - (perRow - 1) * 6) / perRow
      local navTargetX, navTargetY = nil, nil
      for i, item in ipairs(NAV) do
        if i > 1 and ((i - 1) % perRow ~= 0) then ui.sameLine() end
        local active = state.section == item.key
        if active then
          ui.pushStyleColor(ui.StyleColor.Button, C.btnActive)
          ui.pushStyleColor(ui.StyleColor.Text, C.text)
        else
          ui.pushStyleColor(ui.StyleColor.Button, C.btnFlat)
          ui.pushStyleColor(ui.StyleColor.Text, C.dim)
        end
        local navHit = ui.button(item.label, vec2(itemW, 26))
        ui.popStyleColor(2)
        if navHit and state.openT >= 0.999 and not state.dragging then
          setSection(item.key)
        end
        if active then
          local amn = ui.itemRectMin()
          local amx = ui.itemRectMax()
          navTargetX = (amn.x + amx.x) * 0.5
          navTargetY = amx.y + 1
        end
      end
      if navTargetX then
        if state.navX < 0 then state.navX = navTargetX end
        state.navX = anim(state.navX, navTargetX, 14, state.dt)
        ui.drawRectFilled(vec2(state.navX - 14, navTargetY), vec2(state.navX + 14, navTargetY + 2), C.accent, 1)
      end
      local cy = ui.cursorScreenPos()
      local childH = (py + PANEL_H - 8) - cy.y - 30
      if childH < 60 then childH = 60 end
      withAlpha(alpha * clamp(state.sectT * 1.4, 0, 1), function()
        local opened = ui.beginChild('vx_section', vec2(PANEL_W - 24, childH), false, ui.WindowFlags.None)
        local okd, errd = pcall(function()
          if opened then drawSection(state.section) end
        end)
        ui.endChild()
        if not okd then error(errd, 0) end
      end)
      ui.textDisabled(string.format('v%s', VERSION))
      ui.sameLine()
      local ax = ui.availableSpaceX()
      ui.dummy(vec2(ax - 30, 4))
      ui.sameLine()
      ui.invisibleButton('##vxgrip', vec2(28, 20))
      local gmn = ui.itemRectMin()
      local gmx = ui.itemRectMax()
      ui.drawLine(vec2(gmx.x - 5, gmx.y - 15), vec2(gmx.x - 15, gmx.y - 5), C.dim, 2)
      ui.drawLine(vec2(gmx.x - 5, gmx.y - 10), vec2(gmx.x - 10, gmx.y - 5), C.dim, 2)
      local gr = { x = gmn.x, y = gmn.y, w = gmx.x - gmn.x, h = gmx.y - gmn.y }
      if not state.sizeDrag and not state.dragging and not state.orbPress and ui.mouseClicked(0) and inRect(gr, mp) then
        state.sizeDrag = { w = PANEL_W, h = PANEL_H, mx = mp.x, my = mp.y }
        state.dragging = 'size'
      end
      if state.sizeDrag then
        if ui.mouseDown(0) then
          local scr2 = getScreenSize()
          state.panelW = clamp(state.sizeDrag.w + (mp.x - state.sizeDrag.mx), 260, math.min(560, scr2.x - 16))
          state.panelH = clamp(state.sizeDrag.h + (mp.y - state.sizeDrag.my), 330, math.min(640, scr2.y - 16))
          state.panelSize = -1
          applyPanelSize()
          state.panelTX = math.min(state.panelTX, scr2.x - PANEL_W - 8)
          state.panelTY = math.min(state.panelTY, scr2.y - 80)
        else
          state.sizeDrag = nil
          state.dragging = nil
          persist()
        end
      end
    end)
  end)
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

local function speedoRect()
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
  local spd = tonumber(c.speedKmh) or 0
  if spd < 0 then spd = 0 end
  local rpm = tonumber(c.rpm) or 0
  if rpm < 0 then rpm = 0 end
  local gearNum = tonumber(c.gear) or 0
  local x0, y0, w, h, k = speedoRect()
  x0, y0 = handleSpeedoDrag(x0, y0, w, h)
  if state.spdX < 0 then
    state.spdX = x0
    state.spdY = y0
  end
  local op = clamp(state.hudOp or 90, 40, 100) / 100
  withWindow('vx_speedo', vec2(x0, y0), vec2(w, h), function()
    ui.drawRectFilled(vec2(x0, y0), vec2(x0 + w, y0 + h), col(C.cardSolid, op), 14)
    ui.drawRect(vec2(x0, y0), vec2(x0 + w, y0 + h), col(C.accentFaint, op), 14, ui.CornerFlags.All, 1.5)
    local targetSpeed = math.max(0, spd)
    state.smoothSpeed = anim(state.smoothSpeed, targetSpeed, 9, state.dt)
    local speedStr = tostring(math.floor(state.smoothSpeed + 0.5))
    local fs = math.floor(46 * k)
    local sz = ui.measureDWriteText(speedStr, fs, -1)
    ui.dwriteDrawText(speedStr, fs, vec2(x0 + (w - sz.x) * 0.5, y0 + 8 * k), col(C.text, op))
    local ks = ui.measureDWriteText(L.kmh, 13, -1)
    ui.dwriteDrawText(L.kmh, 13, vec2(x0 + (w - ks.x) * 0.5, y0 + 64 * k), col(C.accentSoft, op))
    ui.dwriteDrawText(string.format(L.gear, gearString(gearNum)), 15, vec2(x0 + 14, y0 + 88 * k), col(C.text, op))
    state.smoothRpm = anim(state.smoothRpm, rpm, 12, state.dt)
    local rpmStr = tostring(math.floor(state.smoothRpm / 10) * 10)
    local rs = ui.measureDWriteText(rpmStr, 15, -1)
    ui.dwriteDrawText(string.format(L.rpmLabel, rpmStr), 15, vec2(x0 + w - 14 - rs.x - 38, y0 + 88 * k), col(C.dim, op))
    if state.rpmBar then
      local maxRpm = tonumber(c.rpmLimiter) or 8000
      if maxRpm <= 0 then maxRpm = 8000 end
      local frac = clamp(state.smoothRpm / maxRpm, 0, 1)
      local bx0, by0 = x0 + 14, y0 + 112 * k
      local bx1, by1 = x0 + w - 14, y0 + 122 * k
      ui.drawRectFilled(vec2(bx0, by0), vec2(bx1, by1), col(C.bar, op), 5)
      if frac > 0.005 then
        local band
        if frac <= 0.85 then
          band = C.accent
        elseif frac < 0.95 then
          band = mixCol(C.accent, C.warn, (frac - 0.85) / 0.10)
        elseif frac < 0.98 then
          band = mixCol(C.warn, C.danger, (frac - 0.95) / 0.03)
        else
          band = C.danger
        end
        ui.drawRectFilled(vec2(bx0, by0), vec2(bx0 + (bx1 - bx0) * frac, by1), col(band, op), 5)
      end
    end
    ui.dwriteDrawText(L.title, 11, vec2(x0 + 14, y0 + 132 * k), col(C.accentSoft, op * 0.5))
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
  if state.emergency then return end
  local ok, panelErr = pcall(drawVenomPanelSafe)
  if ok then
    state.drawErrors = 0
  else
    state.drawErrors = state.drawErrors + 1
    if state.drawErrors == 1 then pcall(ac.log, 'VENOM X panel: ' .. tostring(panelErr)) end
    if state.drawErrors >= 3 then
      state.emergency = true
      pcall(function() ui.toast(ui.Icons.Bulb, L.emergencyMode) end)
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

-- The native lightbulb entry is a click action, never a second 430x600 tool window.
-- Matches CSP's documented registerOnlineExtra(icon, title, enabled, nil, action, flags).
ui.registerOnlineExtra(ui.Icons.Bulb, L.title,
  function() return true end,
  nil,
  function(clicked)
    if clicked == false then return end
    if state.emergency then
      state.emergency = false
      state.drawErrors = 0
    end
    if state.panelOpen then closePanel() else openPanel(nil) end
  end,
  ui.OnlineExtraFlags.None
)
