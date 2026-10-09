script = script or {}

local VERSION = '3.12.0'

local L = {
  title = 'VENOM X',
  subtitle = 'LA CANYONS',
  versionTag = 'v3.12.0',
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
  teleportHint = 'Teleport 11 m behind a real player, even while driving',
  cooldown = 'Teleport cooldown: %.1f s',
  pleaseWait = 'Please wait %d s',
  playerUnavailable = 'Player is no longer available',
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
  timeReset = 'RESET TO SERVER',
  presetSunrise = 'GOLDEN RISE 07:15',
  presetDay = 'DAY 12:00',
  presetSunset = 'GOLDEN SET 18:00',
  presetBlue = 'BLUE HOUR 18:40',
  presetNight = 'NIGHT 00:00',
  hudSettings = 'HUD SETTINGS',
  speedometer = 'Speedometer',
  rpmBar = 'RPM ring',
  opacity = 'HUD opacity',
  scale = 'HUD scale',
  resetPositions = 'Reset positions',
  hudNote = 'Drag the floating X or panel header. CTRL+SHIFT+X opens the menu.',
  nightMode = 'NIGHT MODE',
  resetDone = 'Reset to server time',
  spdOn = 'SPEEDOMETER ON',
  spdOff = 'SPEEDOMETER OFF',
  footer = 'VENOM X %s - CSP Online Script',
}

local C = {
  accent = rgbm(0.30, 0.78, 0.94, 1.00),
  accentSoft = rgbm(0.48, 0.85, 0.97, 0.72),
  accentFaint = rgbm(0.30, 0.78, 0.94, 0.19),
  text = rgbm(0.94, 0.96, 1.00, 1.00),
  dim = rgbm(0.56, 0.61, 0.71, 1.00),
  glass = rgbm(0.035, 0.045, 0.070, 0.90),
  glassDeep = rgbm(0.016, 0.024, 0.036, 0.94),
  card = rgbm(0.075, 0.095, 0.140, 0.50),
  cardSolid = rgbm(0.049, 0.067, 0.087, 0.77),
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
  { label = L.presetSunrise, sec = 7 * 3600 + 15 * 60 },
  { label = L.presetDay, sec = 12 * 3600 },
  { label = L.presetSunset, sec = 18 * 3600 },
  { label = L.presetBlue, sec = 18 * 3600 + 40 * 60 },
  { label = L.presetNight, sec = 0 },
}

local HUMAN_SESSION_IDS = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true }

local ORB_SIZE = 56
local PANEL_W = 370
local PANEL_H = 515
local PANEL_SIZES = { { 318, 440 }, { 370, 515 }, { 438, 590 } }
local OPEN_DUR = 0.24
local DRAG_THRESHOLD = 6
-- Standalone time control. No Pure bridge, shared time keys or client files.

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
  quickDockVisible = true,
  dockProgress = 0,
  dockHover = 0,
  quickMode = nil,
  quickErrors = 0,
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
  pendingTeleport = nil,
  optionsRestore = nil,
  optionsStatus = 'NOT TESTED',
  lastControls = nil,
  lastCarPos = nil,
  lastCarSampleAt = nil,
  registeredJumpHook = false,
  time = {
    want=0,curOffset=0,mode='SERVER',nativeRejected=false,
    nativeAttempted=false,nativeApplied=false,nativeResult='NOT CALLED',
    nativeCalls=0,lastNativeAt=-999,lastNativeOffset=math.huge,
    lastControl='NONE',lastSunHeight=nil,lastMoonHeight=nil,
    skyProbeAt=-999,skyProbeError=nil,
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
      vx_dock_v2 = true,
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
    if type(res.vx_dock_v2) == 'boolean' then state.quickDockVisible = res.vx_dock_v2 end
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
  stored.vx_dock_v2 = state.quickDockVisible
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

local beginOptionsRestoration

local function teleportSelf(pos, dir, message)
  if beginOptionsRestoration then beginOptionsRestoration() end
  local ok, result = pcall(physics.setCarPosition, 0, pos, dir)
  if ok and result ~= false then
    if message then toast(message) end
    return true
  end
  state.optionsRestore=nil
  state.optionsStatus='TELEPORT REJECTED'
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
    if beginOptionsRestoration then beginOptionsRestoration() end
    local ok, res = pcall(function() return state.chatEx.teleportTo(d.id) end)
    if ok and res then
      toast(string.format('TELEPORTED TO %s', d.name))
      return
    end
    state.optionsRestore=nil
    state.optionsStatus='SERVER TELEPORT REJECTED'
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

-- Snapshot ONLY client-visible control states before repositioning.
-- Some modded cars use extras A-F as latching modes or one-shot actions:
-- never fire setters unconditionally, only restore a proven mismatch shortly
-- after teleport. Unsupported CSP online APIs are safely ignored.
local function preserveFlag(v)
  return type(v)=='boolean' and v or nil
end

local EXTRA_KEYS={'extraA','extraB','extraC','extraD','extraE','extraF','extraG','extraH','extraI','extraJ'}

local function snapshotCarOptions(me)
  local snapshot={extra={}}
  for i,key in ipairs(EXTRA_KEYS) do
    snapshot.extra[i]=preserveFlag(stateVal(me,key))
  end
  snapshot.headlights=preserveFlag(stateVal(me,'headlightsActive'))
  snapshot.highBeams=preserveFlag(stateVal(me,'highBeams'))
  snapshot.lowBeams=preserveFlag(stateVal(me,'lowBeams'))
  snapshot.hazards=preserveFlag(stateVal(me,'hazardLights'))
  snapshot.turnLeft=preserveFlag(stateVal(me,'turningLeftOnly'))
  snapshot.turnRight=preserveFlag(stateVal(me,'turningRightOnly'))
  return snapshot
end

-- Preserve switch state without spamming controls if they never changed.
-- Return actual observable mismatches; online CSP might forbid setters.
beginOptionsRestoration=function(snapshot)
  local own=car()
  if not own then return false end
  state.optionsRestore={
    snapshot=snapshot or snapshotCarOptions(own),
    started=state.clock,deadline=state.clock+4.5,
    nextAt=state.clock+0.16,pass=0,clean=0,totalAttempts=0,
    denied=0,unavailable=0
  }
  state.optionsStatus='TP / WATCHING VEHICLE CONTROLS'
  return true
end

local function restoreCarOptions(snapshot)
  local result={missing=0,attempted=0,denied=0,unavailable=0,readable=0}
  if not snapshot then return result end
  local me=car()
  if not me then return result end

  local function restoreBool(field,was,setter)
    local current=preserveFlag(stateVal(me,field))
    if current==nil or was==nil then return end
    result.readable=result.readable+1
    if current==was then return end
    result.missing=result.missing+1
    if type(setter)~='function' then
      result.unavailable=result.unavailable+1
      return
    end
    local ok,ret=pcall(setter,was)
    if ok and ret~=false then
      result.attempted=result.attempted+1
    else
      result.denied=result.denied+1
    end
  end

  for i,key in ipairs(EXTRA_KEYS) do
    local wanted=snapshot.extra[i]
    local current=preserveFlag(stateVal(me,key))
    if wanted~=nil and current~=nil then
      result.readable=result.readable+1
      if wanted~=current then
        result.missing=result.missing+1
        if type(ac.setExtraSwitch)=='function' then
          local ok,ret=pcall(ac.setExtraSwitch,i-1,wanted)
          if ok and ret~=false then
            result.attempted=result.attempted+1
          else
            result.denied=result.denied+1
          end
        else
          result.unavailable=result.unavailable+1
        end
      end
    end
  end
  restoreBool('headlightsActive',snapshot.headlights,ac.setHeadlights)
  -- CSP commonly exposes car.lowBeams rather than car.highBeams.
  if snapshot.highBeams~=nil then
    restoreBool('highBeams',snapshot.highBeams,ac.setHighBeams)
  elseif snapshot.lowBeams~=nil then
    local nowLow=preserveFlag(stateVal(me,'lowBeams'))
    if nowLow~=nil then
      result.readable=result.readable+1
      if nowLow~=snapshot.lowBeams then
        result.missing=result.missing+1
        if type(ac.setHighBeams)=='function' then
          local ok,ret=pcall(ac.setHighBeams,not snapshot.lowBeams)
          if ok and ret~=false then
            result.attempted=result.attempted+1
          else
            result.denied=result.denied+1
          end
        else
          result.unavailable=result.unavailable+1
        end
      end
    end
  end

  local h=preserveFlag(stateVal(me,'hazardLights'))
  local l=preserveFlag(stateVal(me,'turningLeftOnly'))
  local r=preserveFlag(stateVal(me,'turningRightOnly'))
  local wantedHazards=snapshot.hazards
  local wantedLeft=snapshot.turnLeft
  local wantedRight=snapshot.turnRight
  local mismatch=false
  if wantedHazards~=nil and h~=nil then
    result.readable=result.readable+1
    mismatch=mismatch or (h~=wantedHazards)
  end
  if wantedLeft~=nil and l~=nil then
    result.readable=result.readable+1
    mismatch=mismatch or (l~=wantedLeft)
  end
  if wantedRight~=nil and r~=nil then
    result.readable=result.readable+1
    mismatch=mismatch or (r~=wantedRight)
  end
  if mismatch then
    result.missing=result.missing+1
    local turns=ac.TurningLights
    local desired=turns and (wantedHazards and turns.Hazards
       or wantedLeft and turns.Left
       or wantedRight and turns.Right
       or turns.None)
    if desired==nil or type(ac.setTurningLights)~='function' then
      result.unavailable=result.unavailable+1
    else
      local ok,ret=pcall(ac.setTurningLights,desired)
      if ok and ret~=false then
        result.attempted=result.attempted+1
      else
        result.denied=result.denied+1
      end
    end
  end
  return result
end

-- Physics.setCarPosition can trigger a *later* car jump/reset in physics
-- scripts. Keep preservation independent from pendingTeleport (which ends
-- after 0.7s), and check up to 3.5s with bounded retry intervals.
local function restoreTeleportOptions()
  local task=state.optionsRestore
  if not task or state.clock<task.nextAt then return end
  local stats=restoreCarOptions(task.snapshot)
  task.pass=task.pass+1
  task.nextAt=state.clock+(task.pass<5 and 0.17 or 0.38)
  task.last=stats
  task.totalAttempts=task.totalAttempts+stats.attempted
  task.denied=task.denied+stats.denied
  task.unavailable=task.unavailable+stats.unavailable
  if stats.missing==0 then
    task.clean=task.clean+1
  else
    task.clean=0
  end
  -- Hold on long enough for delayed post-jump resets but avoid fighting
  -- intentional new driver input indefinitely.
  if (state.clock-task.started)>=2.4 and task.clean>=3 then
    state.optionsStatus=task.totalAttempts>0 and 'RESTORED / VERIFIED'
       or stats.readable>0 and 'UNCHANGED' or 'NO READ ACCESS'
    state.optionsRestore=nil
  elseif state.clock>=task.deadline then
    if stats.missing>0 then
      state.optionsStatus=string.format('PARTIAL: %d MISMATCH / %d DENIED / %d NO API',
        stats.missing,task.denied,task.unavailable)
      pcall(ac.log,'VENOM X TP options: '..state.optionsStatus)
    else
      state.optionsStatus=stats.readable>0 and 'VERIFIED AFTER TP'
        or 'NO READ ACCESS'
    end
    state.optionsRestore=nil
  else
    state.optionsStatus=string.format('CHECKING %d / MISSING %d',task.pass,stats.missing)
  end
end

-- Track switches continuously to preserve them when a CM/map teleport
-- happens OUTSIDE the VENOM X menu. No vehicle physics reset is called here.
local function monitorExternalTeleports()
  local me=car()
  if not me or not me.position then return end
  local pos=me.position
  if type(pos.x)~='number' or type(pos.z)~='number' then return end
  local previous=state.lastCarPos
  local now=state.clock
  if previous and state.lastCarSampleAt and not state.optionsRestore then
    local elapsed=now-state.lastCarSampleAt
    local dx,dz=pos.x-previous.x,pos.z-previous.z
    -- 70 metres in under .25s is a teleport, not normal driving.
    if elapsed>0 and elapsed<0.25 and dx*dx+dz*dz>4900
       and state.lastControls then
      beginOptionsRestoration(state.lastControls)
      state.optionsStatus='EXTERNAL MAP TP / RESTORING'
    end
  end
  state.lastCarPos={x=pos.x,y=pos.y,z=pos.z}
  state.lastCarSampleAt=now
  if not state.optionsRestore then
    state.lastControls=snapshotCarOptions(me)
  end
end

local function registerCarJumpProtection()
  if state.registeredJumpHook then return end
  state.registeredJumpHook=true
  if type(ac.onCarJumped)~='function' then return end
  local ok,err=pcall(function()
    ac.onCarJumped(0,function()
      if not state.optionsRestore and state.lastControls then
        beginOptionsRestoration(state.lastControls)
        state.optionsStatus='CAR JUMP / RESTORING OPTIONS'
      end
    end)
  end)
  if not ok then
    pcall(ac.log,'VENOM X car jump hook unavailable: '..tostring(err))
  end
end

local function teleportToPlayer(p)
  if state.teleportCooldown>0.05 or state.pendingTeleport then
    toast(string.format(L.pleaseWait,math.ceil(math.max(state.teleportCooldown,1))),'warn')
    return
  end
  if not p then return end
  local target=ac.getCar(p.index)
  if not target or not target.isActive or not target.isConnected
      or not target.position then
    toast(L.playerUnavailable,'warn') return
  end
  local sid=stateVal(target,'sessionID')
  local model=tostring(stateVal(target,'id') or ''):lower()
  if type(sid)~='number' or not HUMAN_SESSION_IDS[sid]
      or stateVal(target,'isAIControlled')
      or model:find('traffic',1,true) or model:find('authentic_ai',1,true) then
    toast(L.playerUnavailable,'warn') return
  end
  local me=car()
  if not me or not me.position then toast(L.teleportFailed,'warn') return end
  local originalOptions=snapshotCarOptions(me)
  local look=target.look
  local x=look and tonumber(look.x)
  local z=look and tonumber(look.z)
  if not x or not z then
    toast('TELEPORT: TARGET HEADING UNAVAILABLE','warn')
    return
  end
  local length=math.sqrt(x*x+z*z)
  if length<0.01 then
    toast('TELEPORT: INVALID TARGET HEADING','warn')
    return
  end
  x,z=x/length,z/length
  -- CSP setCarPosition expects the *opposite* of ac.getCar().look.
  -- Position stays behind the target (-look * 11m), but orientation must
  -- use -look so that our resulting car.look matches the other driver's.
  -- See CSP Online-stuff/old-teleport/teleport-to-car.lua by Sahneisttoll.
  local destination=vec3(target.position.x-x*11,target.position.y+0.2,target.position.z-z*11)
  -- Shared preservation before any car jump: player, destination or pits.
  beginOptionsRestoration(originalOptions)
  local ok,answer=pcall(physics.setCarPosition,0,destination,vec3(-x,0,-z))
  if not ok or answer==false then
    state.optionsRestore=nil
    state.optionsStatus='TELEPORT REJECTED'
    toast(L.teleportFailed,'warn')
    pcall(ac.log,'VENOM X teleport rejected: '..tostring(answer))
    return
  end
  -- A moving player can teleport directly. Clear momentum after placement
  -- to avoid being thrown forward at the original driving speed. If this
  -- optional CSP helper is restricted, position verification still runs.
  if type(physics.setCarVelocity)=='function' then
    pcall(physics.setCarVelocity,0,vec3(0,0,0))
  end
  if type(physics.awakeCar)=='function' then pcall(physics.awakeCar,0) end
  state.pendingTeleport={
    dest=destination,name=p.name,at=state.clock+0.7,
    lookX=x,lookZ=z
  }
  state.teleportCooldown=2.5
end

local function verifyPlayerTeleport()
  local pending=state.pendingTeleport
  if not pending or state.clock<pending.at then return end
  state.pendingTeleport=nil
  local me=car()
  local pos=me and me.position
  if not pos then
    toast('TELEPORT: POSITION NOT VERIFIED','warn') return
  end
  local dx=pos.x-pending.dest.x
  local dz=pos.z-pending.dest.z
  if dx*dx+dz*dz>=64 or math.abs(pos.y-pending.dest.y)>=9 then
    toast('TELEPORT BLOCKED OR NOT UPDATED','warn')
    return
  end
  -- Confirm our physical car orientation matches the target's heading.
  local lk=me.look
  local mx=lk and tonumber(lk.x)
  local mz=lk and tonumber(lk.z)
  if mx and mz then
    local norm=math.sqrt(mx*mx+mz*mz)
    if norm>0.01 then
      local facingDot=(mx*pending.lookX+mz*pending.lookZ)/norm
      if facingDot<0.7 then
        toast('TELEPORTED, BUT CAR FACING WRONG WAY','warn')
        pcall(ac.log,string.format('VENOM X teleport heading mismatch: dot=%.3f',facingDot))
        return
      end
    end
  end
  toast(string.format(L.teleportedToPlayer,pending.name))
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

-- Gold-hour presets intentionally use deterministic in-game clock values.
-- Sampling a dynamic sky feature timestamp from this CSP online sandbox did
-- not produce reliable per-client sun positions. Keep the path that previously
-- worked, and provide fine adjustment around the local weather conditions.
local function setTimePreset(preset, index)
  state.time.want = wrapOffset(preset.sec - serverSec())
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
    -- Personal clock is always available; no bridge discovery/probe needed.
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
  state.quickMode = nil
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

local function withWindow(id, pos, size, content, noPad, interactiveTool, clearBackground)
  pushGlass()
  if clearBackground then
    ui.pushStyleColor(ui.StyleColor.WindowBg,rgbm(0,0,0,0))
  end
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
  if clearBackground then ui.popStyleColor() end
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
  sectionLabel('LA CANYONS  /  ONLINE')
  local p = ui.getCursor()
  local w = PANEL_W - 37
  ui.drawRectFilled(p, vec2(p.x + w, p.y + 91), C.cardSolid, 13)
  ui.drawRect(p, vec2(p.x + w, p.y + 91), C.accentFaint, 13, ui.CornerFlags.All, 1)
  ui.dwriteDrawText('FREEROAM', 22, vec2(p.x + 15,p.y + 10), C.text)
  ui.dwriteDrawText('Explore / Drive / Connect', 12, vec2(p.x + 15,p.y + 41),C.dim)
  ui.drawCircleFilled(vec2(p.x + 19,p.y + 76),4,C.ok)
  ui.dwriteDrawText(tostring(#state.players + 1)..' HUMAN DRIVERS',12,
    vec2(p.x + 30,p.y + 68),C.accentSoft)
  ui.dummy(vec2(0,106))
  sectionLabel('QUICK CONTROL')
  ui.dummy(vec2(0,7))
  if ui.button('TELEPORT   /   DESTINATIONS   >##vxhomeTP', vec2(0,40)) then setSection('TELEPORT') end
  if ui.button('PLAYERS   /   GO TO FRIEND   >##vxhomePL', vec2(0,40)) then setSection('PLAYERS') end
  if ui.button('CAR COLOR   /   CUSTOM PAINT   >##vxhomeCL', vec2(0,40)) then setSection('COLOR') end
  if ui.button('TIME & SKY   /   ENVIRONMENT   >##vxhomeTM', vec2(0,40)) then setSection('TIME') end
  ui.separator()
  local me = car()
  if me then
    local bw = math.max(80,(PANEL_W-52)/2)
    if ui.button(me.headlightsActive and 'LIGHTS ON##vxhl' or 'LIGHTS OFF##vxhl',vec2(bw,30)) then toggleHeadlights() end
    ui.sameLine()
    if ui.button(me.highBeams and 'BEAMS ON##vxhb' or 'BEAMS OFF##vxhb',vec2(bw,30)) then toggleHighBeams() end
  end
  if ui.button('RETURN TO PITS##vxhomePit',vec2(0,30)) then returnToPits() end
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
  ui.textDisabled('CAR CONTROLS: '..tostring(state.optionsStatus))
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
  local tm=state.time
  sectionLabel('PERSONAL TIME / EACH PLAYER')
  ui.dummy(vec2(0,5))
  local p=ui.getCursor()
  ui.drawRectFilled(p,vec2(p.x+PANEL_W-35,p.y+80),C.cardSolid,12)
  ui.drawRect(p,vec2(p.x+PANEL_W-35,p.y+80),C.accentFaint,12,ui.CornerFlags.All,1)
  ui.dwriteDrawText(fmtSec(wrapDay(serverSec()+tm.curOffset)),34,
    vec2(p.x+16,p.y+7),C.text)
  ui.dwriteDrawText('YOUR SELECTED TIME',11,vec2(p.x+16,p.y+56),C.accentSoft)
  ui.dummy(vec2(0,90))

  -- Controls must never disappear just because online CSP blocks global
  -- weather APIs. This is independent personal UI state for each player.
  sectionLabel('CHOOSE YOUR TIME')
  local tv=wrapDay(serverSec()+tm.want)
  local nv=ui.slider('##vx_personal_time',tv,0,86399,'',1)
  if math.abs(nv-tv)>0.5 then
    tm.want=wrapOffset(nv-serverSec())
    tm.lastControl='SLIDER'
  end
  ui.dummy(vec2(0,5))
  local bw=math.max(95,(PANEL_W-56)/2)
  for i,preset in ipairs(TIME_PRESETS) do
    if (i-1)%2==1 then ui.sameLine() end
    if ui.button(preset.label..'##vx_solar_'..i,vec2(bw,32)) then
      setTimePreset(preset,i)
      tm.lastControl=preset.label
      toast('TIME: '..preset.label)
    end
  end
  if ui.button('RESET TO SERVER TIME##vx_time_reset',vec2(0,30)) then
    tm.want=0
    tm.lastControl='RESET'
    toast('TIME: SERVER CLOCK')
  end

  sectionLabel('FINE TUNE / GOLDEN HOUR')
  local fineW=math.max(56,(PANEL_W-57)/4)
  for i,minutes in ipairs({-15,-5,5,15}) do
    if i>1 then ui.sameLine() end
    local label=string.format('%+d min',minutes)
    if ui.button(label..'##vx_fine_'..i,vec2(fineW,29)) then
      tm.want=wrapOffset(tm.want+minutes*60)
      tm.lastControl=label
    end
  end

  ui.separator()
  ui.textDisabled('Server: '..fmtSec(wrapDay(serverSec())))
  ui.textDisabled('Last selection: '..tostring(tm.lastControl))
  if tm.mode=='CSP NATIVE' and tm.nativeApplied then
    ui.textColored('CSP time API called; sky effect not verified.',C.accentSoft)
  else
    ui.textDisabled('Personal time selected. Sky remains server-controlled.')
  end
  -- Sun and moon are read-only here. Never fabricate fake night exposure.
  if tm.lastSunHeight~=nil then
    ui.textDisabled(string.format('Real sun height: %.3f',tm.lastSunHeight))
  end
  if tm.lastMoonHeight~=nil then
    ui.textDisabled(string.format('Real moon height: %.3f',tm.lastMoonHeight))
  end
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

local function toggleQuickDockFromLogo()
  if state.panelOpen then
    closePanel()
    state.quickDockVisible=true
  else
    state.quickDockVisible=not state.quickDockVisible
  end
  if not state.quickDockVisible then state.quickMode=nil end
  persist()
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

    if hovered and ui.mouseClicked(1) then openPanel(nil) end
    if hovered then ui.setTooltip('Click: show/hide shortcuts  /  Right click: full menu') end
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
          toggleQuickDockFromLogo()
        end
        state.orbPress = nil
      end
    elseif clicked and not state.dragging then
      toggleQuickDockFromLogo()
    end

    state.orbHover = anim(state.orbHover, hovered and 1 or 0, 12, state.dt)
    local glow = (0.33 + state.orbHover * 0.30 + (active and 0.12 or 0))
    ui.drawRectFilled(vec2(0, 0), vec2(ORB_SIZE, ORB_SIZE), C.glassDeep, 15)
    ui.drawRect(vec2(1, 1), vec2(ORB_SIZE - 1, ORB_SIZE - 1), col(C.accent, glow), 14, ui.CornerFlags.All, 1.7)
    if state.quickDockVisible then
      ui.drawRectFilled(vec2(8, ORB_SIZE - 5), vec2(ORB_SIZE - 8, ORB_SIZE - 3), C.accent, 1)
    end
    local titleSize = ui.measureDWriteText('X', 28, -1)
    ui.dwriteDrawText('X', 28, vec2((ORB_SIZE - titleSize.x) * .5, 2), C.accent)
    local capSize = ui.measureDWriteText('VENOM', 9, -1)
    ui.dwriteDrawText('VENOM', 9, vec2((ORB_SIZE - capSize.x) * .5, 37), C.dim)
  end, true, true)
end

-- VENOM X QUICK DOCK: compact interactive native CSP tool windows.
-- No external icons, fonts, installed plugins or fake input overlays.
local QUICK_ACTIONS = {
  { key='DEST', label='MAP', hint='Teleport to a location' },
  { key='FRIEND', label='CREW', hint='Teleport behind a real player' },
  { key='TIME', label='TIME', hint='Select a personal clock preset' },
  { key='PAINT', label='PAINT', hint='Apply a color in one click' },
  { key='LIGHT', label='LIGHT', hint='Toggle vehicle headlights' },
  { key='HAZARD', label='HAZ', hint='Toggle vehicle hazard lights' },
  { key='HUD', label='HUD', hint='Toggle speedometer display' },
  { key='MENU', label='MENU', hint='Open complete VENOM X menu' },
}

local function toggleHazards()
  local c=car()
  if not c or not ac.TurningLights or type(ac.setTurningLights)~='function' then
    toast('HAZARD CONTROL UNAVAILABLE','warn')
    return
  end
  local mode=c.hazardLights and ac.TurningLights.None or ac.TurningLights.Hazards
  if mode==nil then toast('HAZARD CONTROL UNAVAILABLE','warn') return end
  local ok,result=pcall(ac.setTurningLights,mode)
  if not ok or result==false then toast('HAZARD CONTROL REJECTED','warn') end
end

local function quickGlyph(kind,cx,cy,paint)
  local v=function(x,y) return vec2(x,y) end
  if kind=='DEST' then
    ui.drawCircle(v(cx,cy-3),7,paint,24,1.6)
    ui.drawCircleFilled(v(cx,cy-3),2.5,paint,12)
    ui.drawLine(v(cx-5,cy+2),v(cx,cy+11),paint,1.7)
    ui.drawLine(v(cx+5,cy+2),v(cx,cy+11),paint,1.7)
  elseif kind=='FRIEND' then
    ui.drawCircle(v(cx-4,cy-4),4,paint,18,1.5)
    ui.drawCircle(v(cx+6,cy-3),3,paint,16,1.4)
    ui.drawLine(v(cx-12,cy+9),v(cx-9,cy+4),paint,1.5)
    ui.drawLine(v(cx-9,cy+4),v(cx+2,cy+4),paint,1.5)
    ui.drawLine(v(cx+2,cy+4),v(cx+5,cy+9),paint,1.5)
    ui.drawLine(v(cx+6,cy+4),v(cx+11,cy+5),paint,1.3)
  elseif kind=='TIME' then
    ui.drawCircle(v(cx,cy),9,paint,30,1.6)
    ui.drawLine(v(cx,cy),v(cx,cy-6),paint,1.8)
    ui.drawLine(v(cx,cy),v(cx+5,cy+2),paint,1.8)
  elseif kind=='PAINT' then
    ui.drawCircle(v(cx,cy),9,paint,28,1.5)
    ui.drawCircleFilled(v(cx-4,cy-3),2,rgbm(1,.42,.42,1),12)
    ui.drawCircleFilled(v(cx+3,cy-5),2,rgbm(.45,.8,1,1),12)
    ui.drawCircleFilled(v(cx+4,cy+3),2,rgbm(.46,1,.7,1),12)
  elseif kind=='LIGHT' then
    ui.drawCircle(v(cx-3,cy),6,paint,22,1.7)
    for i=-1,1 do ui.drawLine(v(cx+5,cy+i*6),v(cx+12,cy+i*6),paint,1.6) end
  elseif kind=='HAZARD' then
    ui.drawLine(v(cx,cy-10),v(cx-10,cy+8),paint,1.8)
    ui.drawLine(v(cx-10,cy+8),v(cx+10,cy+8),paint,1.8)
    ui.drawLine(v(cx+10,cy+8),v(cx,cy-10),paint,1.8)
    ui.drawLine(v(cx,cy-4),v(cx,cy+3),paint,1.9)
    ui.drawCircleFilled(v(cx,cy+6),1,paint,8)
  elseif kind=='HUD' then
    ui.drawCircle(v(cx,cy),10,paint,32,1.7)
    ui.drawLine(v(cx,cy),v(cx+6,cy-7),paint,1.9)
    ui.drawCircleFilled(v(cx,cy),2,paint,12)
  else
    for i=-1,1 do ui.drawLine(v(cx-10,cy+i*6),v(cx+10,cy+i*6),paint,1.8) end
  end
end

local function quickDockGeometry()
  local scr=getScreenSize()
  local count=#QUICK_ACTIONS
  local gap,pad=5,9
  -- All eight quick actions remain HORIZONTAL; compact tile size
  -- instead of stacking them into a vertical/two-row menu.
  local available=math.max(240,scr.x-ORB_SIZE-44)
  local tileW=clamp(math.floor((available-pad*2-(count-1)*gap)/count),28,48)
  local tileH=55
  local w=count*tileW+(count-1)*gap+pad*2
  local h=tileH+pad*2
  local x=state.orbX+ORB_SIZE+10
  if x+w>scr.x-8 then x=state.orbX-w-10 end
  x=clamp(x,8,math.max(8,scr.x-w-8))
  local y=clamp(state.orbY+math.floor((ORB_SIZE-h)*.5),45,math.max(45,scr.y-h-8))
  return x,y,w,h,count,tileW,tileH,gap,pad
end

local function performQuickAction(key)
  if key=='MENU' then openPanel(nil) return end
  if key=='LIGHT' then toggleHeadlights() return end
  if key=='HAZARD' then toggleHazards() return end
  if key=='HUD' then
    state.hudVisible=not state.hudVisible
    persist()
    toast(state.hudVisible and L.spdOn or L.spdOff)
    return
  end
  if state.quickMode==key then
    state.quickMode=nil
  else
    state.quickMode=key
    if key=='FRIEND' then refreshPlayers(true) end
    if key=='DEST' then refreshDestinations(true) end
  end
end

local function drawQuickDock()
  if state.panelOpen or state.openT>0.1 then return end
  local progress=clamp(state.dockProgress or 0,0,1)
  if progress<0.02 then return end
  local x,y,w,h,columns,tileW,tileH,gap,pad=quickDockGeometry()
  local mouse=ui.mousePos()
  local near=mouse and inRect({x=x-65,y=y-55,w=w+130,h=h+110},mouse)
  local hovering=state.quickMode~=nil or near
  state.dockHover=anim(state.dockHover,hovering and 1 or 0,10,state.dt)
  local reveal=clamp(state.dockHover,0,1)
  local visibility=(.23+.77*reveal)*easeOutCubic(progress)
  local dx=(1-easeOutCubic(progress))*18
  x=x+dx
  state.quickDockBounds={x=x,y=y,w=w,h=h}
  withWindow('vx_quick_dock',vec2(x,y),vec2(w,h),function()
    ui.drawRectFilled(vec2(0,0),vec2(w,h),
      col(C.glassDeep,visibility*(.20+.55*reveal)),15)
    ui.drawRect(vec2(1,1),vec2(w-1,h-1),
      col(C.accent,visibility*(.13+.26*reveal)),15,ui.CornerFlags.All,1)
    ui.drawRectFilled(vec2(13,0),vec2(69,2),col(C.accent,visibility),1)
    local vehicle=car()
    for i,item in ipairs(QUICK_ACTIONS) do
      local xx=pad+(i-1)*(tileW+gap)
      local yy=pad
      ui.setCursor(vec2(xx,yy))
      local click=false
      local hovered=false
      if progress>.88 then
        click=ui.invisibleButton('##vxq_'..item.key,vec2(tileW,tileH))
        hovered=ui.itemHovered()
      else
        ui.dummy(vec2(tileW,tileH))
      end
      local active=state.quickMode==item.key or
        (item.key=='HUD' and state.hudVisible) or
        (item.key=='LIGHT' and vehicle and vehicle.headlightsActive) or
        (item.key=='HAZARD' and vehicle and vehicle.hazardLights)
      local color=item.key=='HAZARD' and C.warn or C.accent
      local bg=active and C.btnActive or hovered and C.btnHover or C.btnFlat
      ui.drawRectFilled(vec2(xx,yy),vec2(xx+tileW,yy+tileH),
        col(bg,visibility*(.26+.49*reveal)),11)
      ui.drawRect(vec2(xx,yy),vec2(xx+tileW,yy+tileH),
        col(color,visibility*(active and .64 or hovered and .46 or .16)),
        11,ui.CornerFlags.All,1)
      if active then
        ui.drawRectFilled(vec2(xx+9,yy+tileH-3),
          vec2(xx+tileW-9,yy+tileH-1),col(color,visibility),1)
      end
      local ink=(active or hovered) and color or C.dim
      quickGlyph(item.key,xx+tileW*.5,yy+18,col(ink,visibility))
      local ts=ui.measureDWriteText(item.label,9,-1)
      ui.dwriteDrawText(item.label,9,vec2(xx+(tileW-ts.x)*.5,yy+38),
        col((active or hovered) and C.text or C.dim,visibility))
      if hovered then ui.setTooltip(item.hint) end
      if click then performQuickAction(item.key) end
    end
  end,true,true,true)
end

local function drawQuickPopup()
  local mode=state.quickMode
  if not mode or state.panelOpen or not state.quickDockVisible or state.openT>0.1 then return end
  local b=state.quickDockBounds
  if not b then return end
  local scr=getScreenSize()
  local w=302
  local h=mode=='TIME' and 316 or mode=='PAINT' and 220 or 270
  local x=clamp(b.x,8,math.max(8,scr.x-w-8))
  local y=b.y+b.h+9
  if y+h>scr.y-8 then y=b.y-h-9 end
  y=clamp(y,43,math.max(43,scr.y-h-8))
  withWindow('vx_quick_details',vec2(x,y),vec2(w,h),function()
    ui.drawRectFilled(vec2(0,0),vec2(w,h),C.glassDeep,15)
    ui.drawRect(vec2(1,1),vec2(w-1,h-1),col(C.accent,.32),15,ui.CornerFlags.All,1)
    ui.drawRectFilled(vec2(13,0),vec2(73,2),C.accent,1)
    local heads={DEST='QUICK DESTINATIONS',FRIEND='TELEPORT TO CREW',
      TIME='PERSONAL TIME',PAINT='QUICK CAR PAINT'}
    ui.dwriteDrawText(heads[mode] or 'QUICK ACCESS',15,vec2(15,14),C.text)
    ui.dwriteDrawText('VENOM X  /  INSTANT CONTROL',9,vec2(15,34),C.dim)
    ui.setCursor(vec2(w-37,12))
    if ui.button('X##vxqclose',vec2(25,24)) then state.quickMode=nil end
    ui.drawLine(vec2(13,54),vec2(w-13,54),C.accentFaint,1)
    ui.setCursor(vec2(13,63))
    local opened=ui.beginChild('vx_quick_body',vec2(w-26,h-76),false,ui.WindowFlags.None)
    if opened then
      if mode=='DEST' then
        if #state.destList==0 then
          ui.textDisabled('No destinations configured on server.')
        else
          for i,d in ipairs(state.destList) do
            if i>16 then break end
            if ui.button(d.name..'##vxqd_'..i,vec2(w-50,31)) then
              teleportDest(d)
              state.quickMode=nil
            end
            if ui.itemHovered() then ui.setTooltip(d.group or 'Destination') end
          end
        end
        ui.separator()
        if ui.button('RETURN TO PITS##vxqpit',vec2(w-50,30)) then
          returnToPits()
          state.quickMode=nil
        end
      elseif mode=='FRIEND' then
        refreshPlayers(false)
        if #state.players==0 then ui.textDisabled('No other human drivers online.') end
        for i,p in ipairs(state.players) do
          if i>6 then break end
          local name=#p.name>22 and p.name:sub(1,21)..'...' or p.name
          if ui.button(name..'  /  TP##vxqfriend_'..i,vec2(w-50,34)) then
            teleportToPlayer(p)
            state.quickMode=nil
          end
          ui.textDisabled(string.format('   %d m away',math.floor(p.dist+.5)))
        end
        ui.textDisabled('AI traffic excluded. Behind driver / same heading.')
        ui.textDisabled('Car switches: '..tostring(state.optionsStatus))
      elseif mode=='TIME' then
        local tm=state.time
        ui.textColored(fmtSec(wrapDay(serverSec()+tm.want)),C.accentSoft)
        local now=wrapDay(serverSec()+tm.want)
        local selected=ui.slider('##vxq_clock',now,0,86399,'',1)
        if math.abs(selected-now)>.5 then
          tm.want=wrapOffset(selected-serverSec())
          tm.lastControl='QUICK SLIDER'
        end
        local bw=(w-55)/2
        for i,preset in ipairs(TIME_PRESETS) do
          if i%2==0 then ui.sameLine() end
          if ui.button(preset.label..'##vxqt_'..i,vec2(bw,31)) then
            setTimePreset(preset,i)
            tm.lastControl=preset.label
          end
        end
        if ui.button('RESET TIME##vxqreset',vec2(w-50,28)) then
          tm.want=0
          tm.lastControl='RESET'
        end
        if tm.mode=='CSP NATIVE' then
          ui.textDisabled('CSP local sky API detected (visual not confirmed).')
        else
          ui.textColored('SKY LOCKED / CLOCK PREVIEW ONLY',C.warn)
        end
      elseif mode=='PAINT' then
        local ww=(w-68)/4
        for i,preset in ipairs(PRESETS) do
          if (i-1)%4~=0 then ui.sameLine() end
          local click=ui.button(preset.label..'##vxqp_'..i,vec2(ww,30))
          if click then applyColor(preset) end
          if ui.itemHovered() then ui.setTooltip(preset.label..' - apply car color') end
        end
        if ui.button('ORIGINAL LIVERY##vxqoriginal',vec2(w-50,30)) then applyColor(nil) end
        ui.textDisabled('Color sync depends on server permissions.')
      end
    end
    ui.endChild()
  end,true,true)
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
    ui.drawRectFilled(vec2(0, 0), vec2(pw, ph), C.glassDeep, 15)
    ui.drawRect(vec2(0, 0), vec2(pw, ph), col(C.accent, .19), 15, ui.CornerFlags.All, 1)
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
    ui.dwriteDrawText('STUDIO CONTROL   /   LA CANYONS', 11, vec2(18, 38), C.dim)

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
  local w, h = math.floor(332*k), math.floor(174*k)
  local x, y = state.spdX, state.spdY
  if type(x) ~= 'number' or x < 0 then x,y = scr.x-w-26,scr.y-h-70 end
  if type(y) ~= 'number' or y < 0 then y = scr.y-h-70 end
  if x > scr.x-40 or y > scr.y-40 or x+w < 40 or y+h < 40 then
    x,y = scr.x-w-26,scr.y-h-70
    state.spdX,state.spdY = -1,-1
    persist()
  end
  x = clamp(x,8,math.max(8,scr.x-w-8))
  y = clamp(y,40,math.max(40,scr.y-h-8))
  return x,y,w,h,k
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

-- Original CMRT-inspired circular tachometer: pure CSP vector drawing,
-- no fonts, textures or CMRT modules must be installed by players.
local function drawSpeedometer()
  if not state.hudVisible then return end
  local c = car()
  if not c then return end
  local speed = math.max(0, tonumber(c.speedKmh) or 0)
  local rpm = math.max(0, tonumber(c.rpm) or 0)
  local gear = gearString(tonumber(c.gear) or 0)
  local limiter = tonumber(c.rpmLimiter) or 8000
  if limiter < 100 then limiter = 8000 end
  local x,y,w,h,k = speedoRect()
  x,y = handleSpeedoDrag(x,y,w,h)
  if state.spdX < 0 then state.spdX,state.spdY = x,y end
  local opacity = clamp(state.hudOp or 90,40,100)/100
  withWindow('vx_speedo',vec2(x,y),vec2(w,h),function()
    local function v(a,b) return vec2(a*k,b*k) end
    ui.drawRectFilled(v(0,0),vec2(w,h),col(C.glassDeep,opacity),15)
    ui.drawRect(v(1,1),v(331,173),col(C.accentFaint,opacity),15,ui.CornerFlags.All,1.2)
    ui.drawRectFilled(v(16,14),v(53,16),col(C.accent,opacity),1)
    state.smoothSpeed=anim(state.smoothSpeed,speed,10,state.dt)
    state.smoothRpm=anim(state.smoothRpm,rpm,12,state.dt)
    local f=clamp(state.smoothRpm/limiter,0,1)
    local center=v(84,85)
    local radius=59*k
    local from=math.pi*.75
    local sweep=math.pi*1.5
    if state.rpmBar then
      ui.pathClear()
      ui.pathArcTo(center,radius,from,from+sweep,55)
      ui.pathStroke(col(C.bar,opacity),false,9*k)
      if f > .001 then
        local tint=f>.96 and C.danger or (f>.85 and C.warn or C.accent)
        ui.pathClear()
        ui.pathArcTo(center,radius,from,from+sweep*f,55)
        ui.pathStroke(col(tint,opacity),false,9*k)
      end
    end
    ui.drawCircleFilled(center,43*k,col(C.cardSolid,opacity),48)
    ui.drawCircle(center,43*k,col(C.accentFaint,opacity),48,1*k)
    local gearSize=41*k
    local gs=ui.measureDWriteText(gear,gearSize,-1)
    ui.dwriteDrawText(gear,gearSize,vec2(center.x-gs.x*.5,center.y-gs.y*.63),col(C.text,opacity))
    local lbl=ui.measureDWriteText('GEAR',11*k,-1)
    ui.dwriteDrawText('GEAR',11*k,vec2(center.x-lbl.x*.5,center.y+25*k),col(C.accentSoft,opacity))
    ui.drawLine(v(160,19),v(160,147),col(C.accentFaint,opacity),1*k)
    local speedText=tostring(math.floor(state.smoothSpeed+.5))
    local st=ui.measureDWriteText(speedText,52*k,-1)
    ui.dwriteDrawText(speedText,52*k,v(237,36)-vec2(st.x*.5,0),col(C.text,opacity))
    local unit=ui.measureDWriteText('KM/H',13*k,-1)
    ui.dwriteDrawText('KM/H',13*k,v(237,100)-vec2(unit.x*.5,0),col(C.accentSoft,opacity))
    local rpmText=string.format('%d RPM',math.floor(state.smoothRpm/10)*10)
    local rp=ui.measureDWriteText(rpmText,14*k,-1)
    ui.dwriteDrawText(rpmText,14*k,v(237,122)-vec2(rp.x*.5,0),col(C.dim,opacity))
    ui.drawLine(v(14,153),v(316,153),col(C.accentFaint,opacity),1*k)
    ui.dwriteDrawText('VENOM X',10*k,v(17,158),col(C.accentSoft,opacity))
    ui.dwriteDrawText('LIVE TELEMETRY',10*k,v(217,158),col(C.dim,opacity))
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

local function timeControlUpdate(dt)
  local tm=state.time
  tm.curOffset=anim(tm.curOffset,tm.want,2.8,dt)
  if math.abs(tm.want-tm.curOffset)<1 then tm.curOffset=tm.want end
  tm.mode=type(ac.setWeatherTimeOffset)=='function' and
    not tm.nativeRejected and 'CSP NATIVE' or 'SERVER'
  if tm.mode~='CSP NATIVE' and not tm.nativeRejected then
    tm.nativeResult='UNAVAILABLE IN ONLINE SCRIPT'
  end
  if state.clock-tm.skyProbeAt>1 then
    tm.skyProbeAt=state.clock
    local skyFn=type(ac.getSkyFeatureDirection)=='function' and ac.getSkyFeatureDirection
    local sunType=ac.SkyFeature and ac.SkyFeature.Sun
    local moonType=ac.SkyFeature and ac.SkyFeature.Moon
    local okSun,sun=pcall(function()
      if not skyFn or sunType==nil then return nil end
      local v=skyFn(sunType)
      return v and tonumber(v.y) or nil
    end)
    local okMoon,moon=pcall(function()
      if not skyFn or moonType==nil then return nil end
      local v=skyFn(moonType)
      return v and tonumber(v.y) or nil
    end)
    tm.lastSunHeight=okSun and sun or nil
    tm.lastMoonHeight=okMoon and moon or nil
    tm.skyProbeError=tm.lastSunHeight==nil and
      (okSun and 'NOT AVAILABLE' or 'RESTRICTED') or nil
  end
  if tm.mode=='CSP NATIVE' and state.clock-tm.lastNativeAt>0.20 and
      (math.abs(tm.curOffset-tm.lastNativeOffset)>1 or not tm.nativeAttempted) then
    tm.lastNativeAt=state.clock
    tm.nativeAttempted=true
    tm.nativeCalls=tm.nativeCalls+1
    local ok,result=pcall(ac.setWeatherTimeOffset,tm.curOffset,true)
    if ok and result~=false then
      tm.nativeApplied=true
      tm.nativeResult=result==nil and 'CALLED (NOT CONFIRMED)'
        or 'CALLED ('..tostring(result)..')'
      tm.lastNativeOffset=tm.curOffset
    else
      tm.nativeRejected=true
      tm.nativeApplied=false
      tm.nativeResult=ok and 'REJECTED' or ('ERROR: '..tostring(result):sub(1,95))
      tm.mode='SERVER'
      pcall(ac.log,'VENOM X local time rejected: '..tostring(result))
    end
  end
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
  -- Persist only the target state, animate expansion independently.
  state.dockProgress=anim(state.dockProgress,
    state.quickDockVisible and 1 or 0,11,state.dt)
  if math.abs(state.dockProgress-(state.quickDockVisible and 1 or 0))<.006 then
    state.dockProgress=state.quickDockVisible and 1 or 0
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
  timeControlUpdate(state.dt)
  monitorExternalTeleports()
  restoreTeleportOptions()
  verifyPlayerTeleport()
  if (state.panelOpen and state.section == 'PLAYERS') or state.quickMode=='FRIEND' then
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
  local quickOk, quickErr=pcall(function()
    drawQuickDock()
    drawQuickPopup()
  end)
  if not quickOk then
    state.quickErrors=(state.quickErrors or 0)+1
    if state.quickErrors==1 then
      pcall(ac.log,'VENOM X quick dock: '..tostring(quickErr))
    end
  else
    state.quickErrors=0
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
registerCarJumpProtection()
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
