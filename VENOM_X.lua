script = script or {}

local VERSION = '3.25.1'

local L = {
  -- English navigation/actions, Arabic contextual guidance and feedback.
  title = 'VENOM X',
  subtitle = 'LA CANYONS',
  versionTag = 'v3.25.1',
  ready = 'VENOM X جاهز | CTRL+SHIFT+X لفتح القائمة',
  emergencyMode = 'VENOM X: خطأ في الواجهة، تم تشغيل القائمة الاحتياطية',
  navHome = 'HOME',
  navTp = 'TELEPORT',
  navPlayers = 'PLAYERS',
  navColor = 'COLOR',
  navTime = 'TIME',
  navHud = 'HUD',
  online = 'ONLINE',
  playersChip = '%d PLAYERS',
  quickTeleport = 'TELEPORT',
  quickColor = 'COLOR',
  quickTime = 'TIME',
  quickPit = 'PITS',
  returnToPits = 'RETURN TO PITS',
  noDestinations = 'لا توجد مواقع انتقال متاحة',
  destSearch = '##vx_search',
  refresh = 'REFRESH',
  kmh = 'KM/H',
  gear = 'GEAR %s',
  rpmLabel = 'RPM %s',
  teleportHint = 'انتقل خلف لاعب حقيقي بمسافة آمنة (11 م)',
  cooldown = 'انتظر %.1f ثانية لإعادة الانتقال',
  pleaseWait = 'انتظر %d ثانية',
  playerUnavailable = 'اللاعب لم يعد متاحا',
  teleportedToPlayer = 'تم الانتقال إلى %s',
  teleportFailed = 'تعذر الانتقال',
  noPlayers = 'لا يوجد لاعبون آخرون متصلون',
  trafficHidden = 'سيارات الترافيك لا تظهر في قائمة اللاعبين',
  unknownDriver = '(unnamed)',
  other = 'Other',
  carColor = 'CAR COLOR',
  colorApply = 'APPLY',
  colorReset = 'ORIGINAL',
  colorUpdated = 'تم تغيير لون السيارة',
  colorResetMsg = 'تم استرجاع اللون الأصلي',
  colorNotAllowed = 'السيرفر لا يسمح بتغيير اللون هنا',
  colorFail = 'تعذر تغيير اللون',
  colorNoModule = 'خاصية الألوان غير متاحة الآن',
  liveryNote = 'بعض رسومات السيارة لا تدعم تغيير اللون',
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
  localTime = 'PERSONAL TIME',
  timeReset = 'SERVER TIME',
  presetSunrise = 'SUNRISE 07:15',
  presetDay = 'DAY 12:00',
  presetSunset = 'SUNSET 18:00',
  presetBlueHour = 'BLUE HOUR 18:40',
  presetNight = 'NIGHT 00:00',
  hudSettings = 'HUD SETTINGS',
  speedometer = 'Speedometer',
  rpmBar = 'RPM Ring',
  opacity = 'HUD Opacity',
  scale = 'HUD Scale',
  resetPositions = 'RESET POSITIONS',
  hudNote = 'اسحب زر X أو أعلى القائمة لتحريكها. CTRL+SHIFT+X لفتح القائمة.',
  nightMode = 'NIGHT MODE',
  resetDone = 'تمت العودة لوقت السيرفر',
  spdOn = 'تم تشغيل عداد السرعة',
  spdOff = 'تم إخفاء عداد السرعة',
  footer = 'VENOM X %s - CSP Online Script',
}

-- VENOM signature: obsidian body, ivory eyes, crimson accent.
-- Native DirectWrite text for consistently sharp fonts without local assets.
local C = {
  accent = rgbm(0.94, 0.17, 0.25, 1.00),
  accentSoft = rgbm(1.00, 0.59, 0.63, 1.00),
  accentFaint = rgbm(0.92, 0.23, 0.29, 0.27),
  text = rgbm(0.98, 0.97, 0.97, 1.00),
  dim = rgbm(0.84, 0.84, 0.88, 1.00),
  glass = rgbm(0.026, 0.027, 0.034, 0.89),
  glassDeep = rgbm(0.015, 0.016, 0.022, 0.96),
  card = rgbm(0.091, 0.082, 0.098, 0.63),
  cardSolid = rgbm(0.064, 0.056, 0.074, 0.83),
  btn = rgbm(0.091, 0.080, 0.101, 0.95),
  btnHover = rgbm(0.175, 0.105, 0.132, 0.99),
  btnActive = rgbm(0.35, 0.105, 0.150, 0.98),
  btnFlat = rgbm(0.091, 0.088, 0.110, 0.96),
  bar = rgbm(1.00, 1.00, 1.00, 0.15),
  ok = rgbm(0.52, 0.94, 0.67, 1.00),
  warn = rgbm(1.00, 0.76, 0.43, 1.00),
  danger = rgbm(1.00, 0.36, 0.39, 1.00),
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
  { label = L.presetBlueHour, sec = 18 * 3600 + 40 * 60 },
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
  sessionOptions = nil,
  sessionCarKey = nil,
  sessionPinned = false,
  sessionRetryAt = -999,
  sessionLearnAfter = 0,
  sessionLastChange = 0,
  lastAutoExtraCount = 0,
  lastControlsCacheAt = -999,
  snapshotReloadChecked = false,
  lastControls = nil,
  lastControlsAt = -1,
  lastCarPos = nil,
  lastCarSampleAt = nil,
  registeredJumpHook = false,
  carJumpSubscription = nil,
  -- Per-player ghost collisions: only disable OTHER human car colliders.
  ghost = {
    enabled=false, peers={}, applied={}, event=nil, checked=false,
    supported=false, nextSync=0, nextScan=0, lastStatus='OFF',
    confirmed=false,waiting=false,queued=false,sendAt=-999,retries=0
  },
  -- CSP0 OnlineEvents use CHAT transport. Throttle TIME and GHOST together.
  cspChatNextAt=0,
  -- Temporary collision protection is separate from the persistent ghost mode.
  tpShield = {active=false,untilAt=0,minUntil=0,status='READY',
    nextCheck=0,started=0},
  recovery = {spot=nil,carKey=nil,stable=0,nextAt=0,
    captureAfter=5,lastCaptureAt=-999,cooldownUntil=0,
    confirmUntil=0,status='SEARCHING FOR SAFE STOP'},
  time = {
    want=0,curOffset=0,mode='SERVER',nativeRejected=false,
    nativeAttempted=false,nativeApplied=false,nativeResult='NOT CALLED',
    nativeCalls=0,lastNativeAt=-999,lastNativeOffset=math.huge,
    lastControl='NONE',lastSunHeight=nil,lastMoonHeight=nil,
    skyProbeAt=-999,skyProbeError=nil,
    legacyShared=nil,legacyConnected=false,legacyReady=false,
    legacySeq=nil,legacyPendingAt=-999,legacyLastTarget=0,
    legacyAck='NOT CONNECTED',legacyProbeAt=-999,
    serverSkyEnabled=false,serverSkyPending=false,
    serverSkyLastAt=-999,serverSkyStatus='NOT REQUESTED',
    serverSkyEvent=nil,serverSkyEventChecked=false,
    serverSkyAwaiting=false,serverSkyExpectedSeconds=nil,
    serverSkyAckAt=-999,
    serverSkyTargetSeconds=nil,serverSkyTargetAt=0,
    serverSkyPendingAt=0,serverSkyNextSendAt=0,
    serverSkyRetryCount=0,
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

-- Presentation-only localization: keep protocol values and diagnostics intact.
-- Short strings are deliberate: HUD and quick popups remain legible at 318 px.
local function ghostLabel()
  local g=state.ghost
  if not g.supported then return 'GHOST | غير متاح على نسخة CSP الحالية' end
  if g.confirmed then
    return g.enabled and 'GHOST ON | تم تأكيد التفعيل' or
      'GHOST OFF | تم تأكيد الإيقاف'
  end
  if g.waiting or g.queued then return 'GHOST | ننتظر تأكيد السيرفر' end
  if g.retries>3 then return 'GHOST | لم يصل تأكيد السيرفر' end
  return g.enabled and 'GHOST ON | لم يتم التأكيد بعد' or 'GHOST OFF | غير مفعل'
end

local function timeLabel()
  local tm=state.time
  local status=tostring(tm.serverSkyStatus or '')
  if status:find('SERVER ACK',1,true) and not status:find('NO SERVER ACK',1,true) then
    return 'TIME | استلم السيرفر الطلب - تحقق من السماء'
  end
  if tm.serverSkyAwaiting or tm.serverSkyPending or status:find('RETRYING',1,true) then
    return 'TIME | في انتظار رد السيرفر'
  end
  if status:find('NO SERVER ACK',1,true) then return 'TIME | تأخر رد السيرفر' end
  if status:find('SERVER ERROR',1,true) or status:find('FAILED',1,true) then
    return 'TIME | حدث خطأ في الطلب'
  end
  if status:find('EVENT READY',1,true) then return 'TIME | جاهز للاستخدام' end
  if not tm.serverSkyEnabled then return 'TIME | وقت السيرفر' end
  return 'TIME | تحقق من حالة WeatherFX'
end

local function optionsLabel()
  local raw=tostring(state.optionsStatus or '')
  if raw:find('MISMATCH',1,true) or raw:find('REJECTED',1,true) then
    return 'خيارات السيارة | يوجد اختلاف يحتاج مراجعة'
  end
  if raw:find('RESTOR',1,true) or raw:find('RECOVER',1,true) then
    return 'خيارات السيارة | جار استعادة الإعدادات'
  end
  if raw:find('VERIFIED',1,true) then return 'خيارات السيارة | تم التحقق من الإعدادات' end
  if raw:find('TRACK',1,true) or raw:find('KEEPING',1,true) then
    return 'خيارات السيارة | حفظ تلقائي نشط'
  end
  if raw=='NOT TESTED' then return 'خيارات السيارة | جار التحقق' end
  return 'خيارات السيارة | '..raw
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
      vx_ghost = false,
      vx_visual_offset = 0,
      vx_server_sky = false,
      vx_server_target = -1,
      vx_extra_car = '',
      vx_extra_bits = '',
      vx_extra_frame = -1,
      vx_extra_epoch = 0,
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
    if type(res.vx_ghost) == 'boolean' then state.ghost.enabled=res.vx_ghost end
    if type(res.vx_server_sky) == 'boolean' then
      state.time.serverSkyEnabled=res.vx_server_sky
      state.time.serverSkyPending=res.vx_server_sky
    end
    if type(res.vx_server_target)=='number' and
        res.vx_server_target>=0 and res.vx_server_target<86400 then
      state.time.serverSkyTargetSeconds=math.floor(res.vx_server_target)
      state.time.serverSkyTargetAt=state.clock
    end
    if type(res.vx_visual_offset) == 'number' and math.abs(res.vx_visual_offset)<=43200 then
      state.time.want=res.vx_visual_offset
      state.time.curOffset=res.vx_visual_offset
    end
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
  stored.vx_ghost = state.ghost.enabled
  -- Backwards-compatible storage key: holds the REAL SKY time offset.
  -- Old vx_visual_on/vx_visual_power settings are intentionally ignored.
  stored.vx_visual_offset = state.time.want
  stored.vx_server_sky = state.time.serverSkyEnabled
  stored.vx_server_target = state.time.serverSkyTargetSeconds or -1
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
local startTeleportShield
local tryRecoverCar

local function teleportSelf(pos, dir, message)
  -- Snapshot the live extras BEFORE physics.setCarPosition resets a modded car.
  if beginOptionsRestoration then beginOptionsRestoration(nil, true) end
  local ok, result = pcall(physics.setCarPosition, 0, pos, dir)
  if ok and result ~= false then
    if startTeleportShield then startTeleportShield() end
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
    if beginOptionsRestoration then beginOptionsRestoration(nil, true) end
    local ok, res = pcall(function() return state.chatEx.teleportTo(d.id) end)
    if ok and res then
      if startTeleportShield then startTeleportShield() end
      toast(string.format(L.teleportedToPlayer, d.name))
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
    return teleportConfigDest(d)
  end
  toast(L.noDestinations, 'warn')
  return false
end

-- Snapshot ONLY client-visible control states before repositioning.
-- Some modded cars use extras A-F as latching modes or one-shot actions:
-- never fire setters unconditionally, only restore a proven mismatch shortly
-- after teleport. Unsupported CSP online APIs are safely ignored.
local function preserveFlag(v)
  -- Lua "condition and value or nil" drops a valid false flag.
  -- Both ON and OFF are essential to faithfully restore modded car options.
  if type(v)=='boolean' then return v end
  -- Some CSP car-state bindings expose switches as the numeric 0/1.
  if type(v)=='number' and (v==0 or v==1) then return v==1 end
  return nil
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
-- HOT-RELOAD CACHE: CSP periodically reloads this server script. Keep
-- the current driving-session switches in CSP typed storage for reloads only.
-- A new session has a lower sim.frame, or expires the 75s freshness window.
local function encodeExtraSnapshot(snap)
  if not snap then return '' end
  local function bit(x) return x==true and '1' or x==false and '0' or '-' end
  local bits={}
  for i=1,#EXTRA_KEYS do bits[#bits+1]=bit(snap.extra[i]) end
  for _,key in ipairs({'headlights','highBeams','lowBeams',
     'hazards','turnLeft','turnRight'}) do bits[#bits+1]=bit(snap[key]) end
  return table.concat(bits)
end

local function decodeExtraSnapshot(bits)
  if type(bits)~='string' or #bits~=16 or bits:find('[^01%-]') then
    return nil
  end
  local function get(i)
    local x=bits:sub(i,i)
    if x=='1' then return true end
    if x=='0' then return false end
    return nil
  end
  local result={extra={}}
  for i=1,#EXTRA_KEYS do result.extra[i]=get(i) end
  for i,key in ipairs({'headlights','highBeams','lowBeams',
      'hazards','turnLeft','turnRight'}) do result[key]=get(10+i) end
  return result
end

local function persistExtraSnapshot()
  if not stored or not state.sessionOptions or not state.sessionCarKey then return end
  local sf=stateVal(sim(),'frame')
  local ok,now=pcall(os.time)
  if type(sf)~='number' or not ok or type(now)~='number' then return end
  stored.vx_extra_car=state.sessionCarKey
  stored.vx_extra_bits=encodeExtraSnapshot(state.sessionOptions)
  stored.vx_extra_frame=math.floor(sf)
  stored.vx_extra_epoch=math.floor(now)
  state.lastControlsCacheAt=state.clock
end

local function recoverExtraSnapshot(model)
  if state.snapshotReloadChecked then return nil end
  state.snapshotReloadChecked=true
  if not stored or stored.vx_extra_car~=model then return nil end
  local sf=stateVal(sim(),'frame')
  local ok,now=pcall(os.time)
  if type(sf)~='number' or not ok or type(now)~='number' then return nil end
  local prevFrame,prevEpoch=tonumber(stored.vx_extra_frame),
    tonumber(stored.vx_extra_epoch)
  if not prevFrame or not prevEpoch or sf<prevFrame
      or now<prevEpoch or now-prevEpoch>75 then return nil end
  return decodeExtraSnapshot(stored.vx_extra_bits)
end

local function optionsReadout()
  local snap=state.sessionOptions
  if not snap then return 'AUTO CACHE: INITIALIZING' end
  local readable,enabled=0,0
  for i=1,#EXTRA_KEYS do
    if type(snap.extra[i])=='boolean' then
      readable=readable+1
      if snap.extra[i] then enabled=enabled+1 end
    end
  end
  if readable==0 then return 'AUTO CACHE: EXTRA FLAGS NOT READABLE' end
  return string.format('AUTO CACHE: %d/10 FLAGS READ / %d ON',
    readable,enabled)
end

local function mergeLiveOptionSnapshot(old,live)
  if not old then return live end
  for i=1,#EXTRA_KEYS do
    if type(live.extra[i])=='boolean' then
      old.extra[i]=live.extra[i]
    end
  end
  for _,key in ipairs({'headlights','highBeams','lowBeams',
      'hazards','turnLeft','turnRight'}) do
    if type(live[key])=='boolean' then old[key]=live[key] end
  end
  return old
end

local function optionSwitchDelta(old,live)
  local off,on=0,0
  if not old then return off,on end
  local function compare(a,b)
    if a==true and b==false then off=off+1
    elseif a==false and b==true then on=on+1 end
  end
  for i=1,#EXTRA_KEYS do compare(old.extra[i],live.extra[i]) end
  compare(old.headlights,live.headlights)
  compare(old.highBeams,live.highBeams)
  compare(old.hazards,live.hazards)
  return off,on
end

beginOptionsRestoration=function(snapshot, beforeTeleport)
  local own=car()
  if not own then return false end
  local carKey=tostring(stateVal(own,'id') or 'UNKNOWN')
  if state.sessionCarKey~=carKey then
    state.sessionOptions=nil
    state.sessionPinned=false
    state.sessionCarKey=carKey
  end
  local active=state.optionsRestore
  -- A menu teleport runs BEFORE the car moves, so its fresh snapshot is
  -- authoritative. This picks up driver changes made immediately before TP.
  -- A jump callback runs AFTER the reset, so NEVER learn reset values there.
  local desired=state.sessionOptions or snapshot or snapshotCarOptions(own)
  if beforeTeleport and not active then
    desired=mergeLiveOptionSnapshot(desired,snapshot or snapshotCarOptions(own))
  end
  state.sessionOptions=desired
  state.sessionPinned=true
  persistExtraSnapshot()
  -- Prevent a delayed physics/car-script reset from becoming the new state.
  -- Learning resumes when restoration finishes (rather than after 11s).
  state.sessionLearnAfter=state.clock+10.0
  state.optionsRestore={
    snapshot=desired,
    started=state.clock,
    -- Do not stop at the first 2-second run of clean frames: mod cars may
    -- reset their extras several seconds AFTER the physical teleport.
    minHoldUntil=state.clock+5.0,
    deadline=state.clock+11.0,
    cleanChecks=0,
    nextAt=state.clock+0.16,pass=0,clean=0,totalAttempts=0,
    denied=0,unavailable=0
  }
  state.optionsStatus='TP / CAR OPTIONS PROTECTED'
  return true
end

local function restoreCarOptions(snapshot)
  local result={missing=0,attempted=0,denied=0,unavailable=0,
    readable=0,extraReadable=0,extraMissing=0,extraApplied=0}
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
      result.extraReadable=result.extraReadable+1
      if wanted~=current then
        result.missing=result.missing+1
        result.extraMissing=result.extraMissing+1
        if type(ac.setExtraSwitch)=='function' then
          local ok,ret=pcall(ac.setExtraSwitch,i-1,wanted)
          if ok and ret~=false then
            result.attempted=result.attempted+1
            result.extraApplied=result.extraApplied+1
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
  task.nextAt=state.clock+(task.pass<9 and .15 or .40)
  task.totalAttempts=task.totalAttempts+stats.attempted
  task.denied=task.denied+stats.denied
  task.unavailable=task.unavailable+stats.unavailable
  if stats.extraReadable==0 then
    state.optionsStatus='CAR JUMP: WAITING FOR EXTRA READBACK'
    task.cleanChecks=0
  elseif stats.extraMissing>0 then
    state.optionsStatus=string.format('EXTRA MISMATCH %d / NO API %d / REJECTED %d',
      stats.extraMissing,task.unavailable,task.denied)
    task.cleanChecks=0
  elseif stats.missing>0 then
    state.optionsStatus=string.format('LIGHT MISMATCH %d',stats.missing)
    task.cleanChecks=0
  else
    task.cleanChecks=(task.cleanChecks or 0)+1
    state.optionsStatus=string.format('EXTRAS VERIFIED: %d/10',stats.extraReadable)
  end
  local stable=stats.extraReadable>0 and task.cleanChecks>=3 and
    state.clock>=task.minHoldUntil
  if stable or state.clock>=task.deadline then
    if not stable then
      state.optionsStatus=string.format(
        'RESTORE NOT VERIFIED / EXTRA %d / API %d / REJECTED %d',
        stats.extraMissing,task.unavailable,task.denied)
      pcall(ac.log,'VENOM X '..state.optionsStatus)
    end
    state.optionsRestore=nil
    state.sessionLearnAfter=state.clock+0.30
    persistExtraSnapshot()
  end
end

-- Track switches continuously to preserve them when a CM/map teleport
-- happens OUTSIDE the VENOM X menu. No vehicle physics reset is called here.
local function monitorExternalTeleports()
  local me=car()
  if not me or not me.position then return end
  local pos=me.position
  local now=state.clock
  local key=tostring(stateVal(me,'id') or 'UNKNOWN')

  if state.sessionCarKey~=key or not state.sessionOptions then
    state.sessionCarKey=key
    local previous=recoverExtraSnapshot(key)
    state.sessionOptions=previous or snapshotCarOptions(me)
    state.lastControls=state.sessionOptions
    state.lastControlsAt=now
    state.sessionPinned=true
    state.sessionLearnAfter=now+.6
    state.optionsRestore=nil
    state.optionsStatus=previous and 'RELOADED / AUTO CACHE RECOVERED'
      or 'AUTO TRACKING CAR OPTIONS'
    if previous then beginOptionsRestoration(previous)
    else persistExtraSnapshot() end
  end

  local previous=state.lastCarPos
  if previous and state.lastCarSampleAt and not state.optionsRestore then
    local elapsed=now-state.lastCarSampleAt
    local dx,dz=pos.x-previous.x,pos.z-previous.z
    -- Detect Content Manager or third-party map jumps too.
    if elapsed>0 and elapsed<.25 and dx*dx+dz*dz>900 then
      beginOptionsRestoration(state.sessionOptions)
      if startTeleportShield then startTeleportShield() end
      state.optionsStatus='EXTERNAL MAP JUMP / AUTO RESTORE'
    end
  end
  state.lastCarPos={x=pos.x,y=pos.y,z=pos.z}
  state.lastCarSampleAt=now

  -- Learn each intentional switch/light change as it happens, without any
  -- SAVE button. Avoid capturing jump-induced resets as desired values.
  if state.optionsRestore or now<state.sessionLearnAfter
      or now-state.lastControlsAt<.08 then return end
  state.lastControlsAt=now
  local sample=snapshotCarOptions(me)
  local off,on=optionSwitchDelta(state.sessionOptions,sample)
  if off>=2 and on==0 then
    -- Multiple options switching off together is a common car reset.
    -- Single deliberate toggle-offs remain allowed.
    beginOptionsRestoration(state.sessionOptions)
    state.optionsStatus='CAR OPTIONS RESET / AUTO RESTORE'
    return
  end
  if off>0 or on>0 then state.sessionLastChange=now end
  state.sessionOptions=mergeLiveOptionSnapshot(state.sessionOptions,sample)
  state.lastControls=state.sessionOptions
  if off>0 or on>0 or now-state.lastControlsCacheAt>18 then
    persistExtraSnapshot()
  end
  if state.optionsStatus=='NOT TESTED' then
    state.optionsStatus='AUTO TRACKING CAR OPTIONS'
  end
end

local function registerCarJumpProtection()
  if state.registeredJumpHook then return end
  state.registeredJumpHook=true
  if type(ac.onCarJumped)~='function' then return end
  local ok,err=pcall(function()
    -- Preserve Disposable: if it is GC'd, CSP might unsubscribe this callback.
    state.carJumpSubscription=ac.onCarJumped(0,function()
      if startTeleportShield and state.clock>2 then
        -- Captures Content Manager/map teleports as well as VENOM.
        startTeleportShield()
      end
      if state.optionsRestore then
        -- A delayed jump inside our guard needs extra time for mod scripts to
        -- finish their resets. Keep the original desired switches intact.
        local task=state.optionsRestore
        task.minHoldUntil=math.min(task.started+13.0,
          math.max(task.minHoldUntil,state.clock+3.0))
        task.deadline=math.min(task.started+17.0,
          math.max(task.deadline,state.clock+6.0))
        task.cleanChecks=0
        task.nextAt=state.clock+0.16
        state.optionsStatus='CAR JUMP / KEEPING OPTIONS'
      elseif state.sessionOptions or state.lastControls then
        beginOptionsRestoration(state.sessionOptions or state.lastControls)
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
    toast('الانتقال | تعذر تحديد اتجاه اللاعب','warn')
    return
  end
  local length=math.sqrt(x*x+z*z)
  if length<0.01 then
    toast('الانتقال | اتجاه اللاعب غير صالح','warn')
    return
  end
  x,z=x/length,z/length
  -- CSP setCarPosition expects the *opposite* of ac.getCar().look.
  -- Position stays behind the target (-look * 11m), but orientation must
  -- use -look so that our resulting car.look matches the other driver's.
  -- See CSP Online-stuff/old-teleport/teleport-to-car.lua by Sahneisttoll.
  local destination=vec3(target.position.x-x*11,target.position.y+0.2,target.position.z-z*11)
  -- Shared preservation before any car jump: player, destination or pits.
  beginOptionsRestoration(originalOptions, true)
  local ok,answer=pcall(physics.setCarPosition,0,destination,vec3(-x,0,-z))
  if not ok or answer==false then
    state.optionsRestore=nil
    state.optionsStatus='TELEPORT REJECTED'
    toast(L.teleportFailed,'warn')
    pcall(ac.log,'VENOM X teleport rejected: '..tostring(answer))
    return
  end
  if startTeleportShield then startTeleportShield() end
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
    toast('الانتقال | لم يتم تأكيد الموقع','warn') return
  end
  local dx=pos.x-pending.dest.x
  local dz=pos.z-pending.dest.z
  if dx*dx+dz*dz>=64 or math.abs(pos.y-pending.dest.y)>=9 then
    toast('الانتقال | لم يتغير الموقع','warn')
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
        toast('تم الانتقال لكن اتجاه السيارة غير صحيح','warn')
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

-- GHOST MODE: a peer-to-peer CSP OnlineEvent shares each driver's own
-- opt-in mode, including drivers who join later. Never alter AI colliders.
-- physics.disableCarCollisions(index, value) requires CSP with remote-car
-- support (introduced in CSP 0.2.8). Both clients must run the online script.
local function ghostUsable()
  if type(physics)~='table' or
    type(physics.disableCarCollisions)~='function' or
    type(ac.OnlineEvent)~='function' or ac.StructItem==nil then
    return false
  end
  -- CSP 0.2.8 (build 3424) introduced collision toggles for REMOTE cars.
  if type(ac.getPatchVersionCode)=='function' then
    local ok,version=pcall(ac.getPatchVersionCode)
    if not ok or type(version)~='number' or version<3424 then return false end
  end
  return true
end

local function initGhostEvent()
  local g=state.ghost
  if g.checked then return end
  g.checked=true
  g.supported=ghostUsable()
  if not g.supported then
    -- Never advertise a persisted ghost setting as active on older CSP.
    g.enabled=false
    g.lastStatus='GHOST UNAVAILABLE / CSP 0.2.8+ REQUIRED'
    persist()
    return
  end
  local ok,evt=pcall(function()
    return ac.OnlineEvent({
      ac.StructItem.key('VENOMX_Ghost_v1'),
      enabled=ac.StructItem.boolean()
    },function(sender,message)
      if not message then return end
      if sender==nil then
        -- A server-generated event confirms reception; log for live diagnosis.
        pcall(ac.log,'VENOM X GHOST server event ACK received, enabled='..
          tostring(message.enabled)..', wanted='..tostring(g.enabled))
        if message.enabled==g.enabled then
          g.confirmed=true
          g.waiting=false
          g.queued=false
          g.retries=0
          g.lastStatus=g.enabled and
            'GHOST ON / SERVER CONFIRMED' or 'GHOST OFF / SERVER CONFIRMED'
        end
        return
      end
      if sender.index==0 then return end
      local sid=stateVal(sender,'sessionID')
      if type(sid)~='number' or not HUMAN_SESSION_IDS[sid] or
         not isHumanCar(sender,
           stateVal(sender,'driverName'),stateVal(sender,'id'),sid) then
        return
      end
      -- Only accept this driver speaking for their OWN session.
      g.peers[sid]={enabled=message.enabled==true,lastAt=state.clock}
      g.nextScan=0
    end)
  end)
  if ok and evt then
    g.event=evt
    g.lastStatus=g.enabled and 'GHOST ON / SERVER NOT CONFIRMED' or
      'GHOST OFF / SERVER NOT CONFIRMED'
    -- On Lua hot reload, send even an OFF state so a previous ON on the
    -- still-connected server session cannot linger.
    g.queued=true
  else
    g.supported=false
    g.enabled=false
    g.lastStatus='GHOST EVENT ERROR'
    persist()
    pcall(ac.log,'VENOM X ghost event init: '..tostring(evt))
  end
end

local function ghostDisableAt(index,disabled)
  local ok,ret=pcall(physics.disableCarCollisions,index,disabled)
  if not ok or ret==false then
    state.ghost.lastStatus='GHOST PHYSICS API REJECTED'
    return false
  end
  return true
end

local function scanGhostCollisions()
  local g=state.ghost
  if not g.supported then return end
  local seen={}
  -- A client's own car keeps normal traffic/world physics. Setting
  -- remote human colliders is sufficient for the player-pair interaction.
  for _,c in ac.iterateCars() do
    if c.index~=0 and c.isConnected and c.isActive then
      local sid=stateVal(c,'sessionID')
      if isHumanCar(c,stateVal(c,'driverName'),stateVal(c,'id'),sid) then
        seen[c.index]=true
        local peer=g.peers[sid]
        local peerGhost=peer and peer.enabled and
          state.clock-peer.lastAt<16 or false
        local disable=g.enabled or peerGhost
        local prev=g.applied[c.index]
        if not prev or prev.session~=sid or prev.disabled~=disable then
          -- Avoid enabling an untouched collider: only restore ones
          -- previously disabled by VENOM X.
          if disable or (prev and prev.disabled) then
            if ghostDisableAt(c.index,disable) then
              g.applied[c.index]={session=sid,disabled=disable}
            end
          else
            g.applied[c.index]={session=sid,disabled=false}
          end
        end
      end
    end
  end
  for idx,prev in pairs(g.applied) do
    if not seen[idx] then
      -- Disconnected cars can be recycled with a different session ID.
      -- Forget their previous state rather than affecting a new occupant.
      g.applied[idx]=nil
    end
  end
end

local function sendGhostState()
  local g=state.ghost
  if not g.event then return false end
  if state.clock<(state.cspChatNextAt or 0) then
    g.queued=true
    return false
  end
  local ok,ret=pcall(g.event,{enabled=g.enabled})
  if ok and ret~=false then
    g.sendAt=state.clock
    g.waiting=true
    g.queued=false
    if g.retries==0 then
      pcall(ac.log,'VENOM X GHOST client event sent, wanted='..
        tostring(g.enabled)..'; awaiting server reply')
    end
    -- Stock v0.0.54 discards chat messages sent less than 1s apart.
    state.cspChatNextAt=state.clock+1.35
    if state.time then
      state.time.serverSkyNextSendAt=math.max(
        state.time.serverSkyNextSendAt or 0,state.cspChatNextAt)
    end
    return true
  end
  g.queued=true
  g.lastStatus='GHOST SEND FAILED / CHECK CSP'
  pcall(ac.log,'VENOM X ghost network send: '..tostring(ret))
  return false
end

local function setGhostEnabled(enabled)
  local g=state.ghost
  initGhostEvent()
  if not g.supported or not g.event then
    toast(g.lastStatus,'warn')
    return false
  end
  g.enabled=enabled==true
  persist()
  g.confirmed=false
  g.waiting=false
  g.queued=true
  g.retries=0
  g.lastStatus='GHOST REQUESTED / WAITING FOR SERVER ACK'
  -- Local collider change alone is insufficient for peer-to-peer ghost.
  scanGhostCollisions()
  sendGhostState()
  g.nextSync=state.clock+6
  toast(g.enabled and 'GHOST ON | ننتظر تأكيد السيرفر' or
    'GHOST OFF | ننتظر تأكيد السيرفر')
  return true
end

local function toggleGhostMode()
  return setGhostEnabled(not state.ghost.enabled)
end

local function ghostUpdate()
  local g=state.ghost
  initGhostEvent()
  if not g.supported then return end
  if state.clock>=g.nextScan then
    g.nextScan=state.clock+0.75
    scanGhostCollisions()
  end
  if g.waiting and state.clock-g.sendAt>2.2 then
    g.waiting=false
    g.retries=g.retries+1
    if g.retries<=3 then
      g.queued=true
      g.lastStatus='GHOST RETRY '..g.retries..' / SERVER ACK PENDING'
    else
      g.confirmed=false
      g.lastStatus='GHOST ACK TIMEOUT / CHECK CSP CLIENT LOG'
    end
  end
  if g.queued and g.retries<=3 and not g.waiting then
    sendGhostState()
  end
  if state.clock>=g.nextSync then
    -- Once confirmed, keep active modes fresh for late joiners; the server
    -- also sends cached ghost states as soon as a new driver finishes loading.
    g.nextSync=state.clock+(g.enabled and 8 or 25)
    if g.confirmed or (not g.waiting and g.retries>3) then
      g.retries=0
      g.queued=true
    end
  end
end

-- SMART TP SHIELD: temporarily turn off collisions for OUR own car only.
-- This protects against both human and AI overlap after placement; world
-- geometry is still managed by the game's track physics.
-- Do not modify the peer ghost network state, which has its own lifecycle.
local function carDistanceSquared(a,b)
  if not a or not b then return math.huge end
  local dx=(tonumber(a.x) or 0)-(tonumber(b.x) or 0)
  local dy=(tonumber(a.y) or 0)-(tonumber(b.y) or 0)
  local dz=(tonumber(a.z) or 0)-(tonumber(b.z) or 0)
  return dx*dx+dy*dy+dz*dz
end

local function nearbyCars(radius)
  local me=car()
  if not me or not me.position or type(ac.iterateCars)~='function' then
    return true -- fail safe: do not call an area clear without evidence
  end
  for _,other in ac.iterateCars() do
    if other.index~=0 and other.isConnected and other.isActive and
       other.position and carDistanceSquared(me.position,other.position)<radius*radius then
      return true
    end
  end
  return false
end

local function stopTeleportShield()
  local shield=state.tpShield
  if not shield.active then return end
  shield.active=false
  -- Only restore local index 0 that this feature specifically disabled.
  -- Existing GHOST player colliders (remote indices) are untouched.
  local ok,ret=pcall(physics.disableCarCollisions,0,false)
  shield.status=(ok and ret~=false) and 'NORMAL COLLISIONS RESTORED' or
    'COULD NOT RESTORE COLLISIONS'
  if not ok or ret==false then
    pcall(ac.log,'VENOM X TP shield release rejected: '..tostring(ret))
  end
end

startTeleportShield=function()
  local shield=state.tpShield
  local recovery=state.recovery
  -- Protect the last known road position from being replaced by a transient
  -- spawn point, physics reset, or airborn car after a teleport.
  recovery.captureAfter=state.clock+11
  recovery.stable=0
  if type(physics)~='table' or
     type(physics.disableCarCollisions)~='function' then
    shield.status='TP SHIELD UNAVAILABLE / CSP PHYSICS API'
    return false
  end
  local ok,ret=pcall(physics.disableCarCollisions,0,true)
  if not ok or ret==false then
    shield.status='TP SHIELD REJECTED BY CSP'
    return false
  end
  shield.active=true
  shield.started=state.clock
  shield.minUntil=state.clock+3
  shield.untilAt=state.clock+14
  shield.nextCheck=state.clock+0.4
  shield.status='TP SHIELD ACTIVE'
  return true
end

local function updateTeleportShield()
  local shield=state.tpShield
  if not shield.active or state.clock<shield.nextCheck then return end
  shield.nextCheck=state.clock+0.3
  -- Minimum 3-second grace period. Keep protection while another car is
  -- within 12m, but cap at 14 seconds so collision bypass cannot persist.
  if state.clock>=shield.minUntil and
     (not nearbyCars(12) or state.clock>=shield.untilAt) then
    if state.clock>=shield.untilAt and nearbyCars(12) then
      toast('حماية الانتقال انتهت | انتبه للسيارات القريبة','warn')
    end
    stopTeleportShield()
  end
end

-- UNSTUCK / RECOVERY: remember recent reliably stopped and upright positions.
-- No fabricated "road-safe" coordinates, no auto-teleport into random lanes,
-- no repeated risky moves while the car is being driven fast.
local function sampleRecoverySpot()
  local recovery=state.recovery
  if state.clock<recovery.nextAt then return end
  recovery.nextAt=state.clock+1
  local me=car()
  if not me or not me.position then return end
  local key=tostring(stateVal(me,'id') or 'UNKNOWN')
  if recovery.carKey~=key then
    recovery.carKey=key
    recovery.spot=nil
    recovery.stable=0
    recovery.captureAfter=state.clock+3
  end
  if state.clock<recovery.captureAfter or state.tpShield.active or
     state.optionsRestore or nearbyCars(9) then
    recovery.stable=0
    return
  end
  local speed=tonumber(stateVal(me,'speedKmh'))
  local p=me.position
  local heading=me.look
  local x=heading and tonumber(heading.x)
  local z=heading and tonumber(heading.z)
  local up=me.up and tonumber(me.up.y)
  local wheels=tonumber(stateVal(me,'wheelsOnGround'))
  -- Regular road driving under 45 km/h is a better emergency checkpoint
  -- than saving only stopped cars (which can be stuck in place).
  if not speed or speed>45 or not x or not z or x*x+z*z<0.5 or
     not tonumber(p.x) or not tonumber(p.y) or not tonumber(p.z) or
     (up and up<0.8) or (wheels and wheels<2) then
    recovery.stable=0
    return
  end
  recovery.stable=recovery.stable+1
  if recovery.stable<3 then return end
  local length=math.sqrt(x*x+z*z)
  recovery.spot={
    x=p.x,y=p.y,z=p.z,
    dirX=-x/length,dirZ=-z/length,
    carKey=key,at=state.clock
  }
  recovery.lastCaptureAt=state.clock
  recovery.status='RECOVERY CHECKPOINT SAVED'
end

tryRecoverCar=function()
  local recovery=state.recovery
  local me=car()
  if not me or not me.position then
    toast('الاسترجاع غير متاح الآن','warn') return false
  end
  if state.clock<recovery.cooldownUntil then
    toast('الاسترجاع | انتظر قليلا','warn') return false
  end
  if state.pendingTeleport then
    toast('انتظر حتى يكتمل الانتقال السابق','warn') return false
  end
  local key=tostring(stateVal(me,'id') or 'UNKNOWN')
  local spot=recovery.spot
  local hasSpot=spot and spot.carKey==key and
     state.clock-spot.at<1200
  local speed=tonumber(stateVal(me,'speedKmh')) or 0
  if not hasSpot or speed>30 then
    if state.clock>=recovery.confirmUntil then
      recovery.confirmUntil=state.clock+4
      toast(hasSpot and 'استرجاع أثناء القيادة؟ اضغط مجددا للتأكيد' or
        'لا توجد نقطة آمنة | اضغط مجددا للعودة للحظيرة','warn')
      return false
    end
  end
  recovery.confirmUntil=0
  recovery.cooldownUntil=state.clock+12
  recovery.status='RECOVERY REQUESTED'
  if not hasSpot then
    -- Deliberate fallback; the second press confirms the pits destination.
    local ok=returnToPits()
    if not ok then
      recovery.status='RECOVERY FAILED / NO PITS DESTINATION'
      recovery.cooldownUntil=state.clock
    end
    return ok
  end
  -- Move exactly to a previously observed upright stationary position.
  -- Orientation is inverted to match physics.setCarPosition.
  local ok=teleportSelf(vec3(spot.x,spot.y+0.18,spot.z),
    vec3(spot.dirX,0,spot.dirZ),'RECOVERED TO LAST CHECKPOINT')
  if not ok then
    recovery.status='RECOVERY FAILED'
    recovery.cooldownUntil=state.clock
    return false
  end
  if type(physics.setCarVelocity)=='function' then
    pcall(physics.setCarVelocity,0,vec3(0,0,0))
  end
  if type(physics.awakeCar)=='function' then
    pcall(physics.awakeCar,0)
  end
  recovery.status=state.tpShield.active and
    'RECOVERED / TP SHIELD ACTIVE' or 'RECOVERED / SHIELD UNAVAILABLE'
  return true
end

local function recoveryStatusLine()
  local r=state.recovery
  local shield=state.tpShield
  if shield.active then
    return string.format('حماية الانتقال تعمل | %.0f ثانية',
      math.max(0,shield.untilAt-state.clock))
  end
  if r.spot and state.clock-r.spot.at<1200 then
    return 'الاسترجاع جاهز | آخر نقطة آمنة محفوظة'
  end
  return 'لا توجد نقطة آمنة | الرجوع للحظيرة بعد التأكيد'
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

-- Personal real sky bridge for AssettoServer 0.0.54 (server-side plugin).
-- Must match VenomTimeEvent.cs in VenomPersonalTimePlugin exactly.
-- The server plugin sends normal WeatherFX updates with a timestamp for
-- only this player. No client installation or global server time commands.
local function openServerSkyEvent()
  local tm=state.time
  if tm.serverSkyEventChecked then return end
  tm.serverSkyEventChecked=true
  if type(ac.OnlineEvent)~='function' or not ac.StructItem then
    tm.serverSkyStatus='CSP ONLINE EVENT API UNAVAILABLE'
    return
  end
  local ok,evt=pcall(function()
    return ac.OnlineEvent({
      ac.StructItem.key('VENOMX_SetTime'),
      mode=ac.StructItem.string(4),
      seconds=ac.StructItem.string(8),
    },function(sender,data)
      -- AssettoServer replies with sender=nil and the same event layout.
      -- The local send result is NOT a real server acknowledgement.
      if sender~=nil or not data then return end
      local kind=tostring(data.mode or '')
      if kind~='ack' and kind~='err' then return end
      if not tm.serverSkyAwaiting then return end
      local details=tostring(data.seconds or '')
      if kind=='ack' and details~=tostring(tm.serverSkyExpectedSeconds) then
        -- Ignore late responses from older slider positions.
        return
      end
      tm.serverSkyAwaiting=false
      tm.serverSkyAckAt=state.clock
      tm.serverSkyStatus=kind=='ack'
        and ('SERVER ACK '..(details=='0' and '00:00 OR SYNC' or
          fmtSec(tonumber(details) or 0))..' / CHECK SUN')
        or ('SERVER ERROR: '..details)
    end)
  end)
  if ok and evt then
    tm.serverSkyEvent=evt
    tm.serverSkyStatus='EVENT READY / SERVER PLUGIN REQUIRED'
  else
    tm.serverSkyStatus='EVENT INIT FAILED: '..tostring(evt):sub(1,65)
  end
end

-- CSP's timeTotalSeconds can itself become PERSONAL after a WeatherFX update.
-- Never recalculate a pressed preset from that mutable clock on a later frame.
-- Store absolute target seconds at the instant the player chooses a time.
local function shownTimeSeconds()
  local tm=state.time
  if tm.serverSkyEnabled and type(tm.serverSkyTargetSeconds)=='number' then
    return wrapDay(tm.serverSkyTargetSeconds+
      math.max(0,state.clock-tm.serverSkyTargetAt))
  end
  return wrapDay(serverSec())
end

local function queueServerSky(enabled,exactSeconds,debounced)
  local tm=state.time
  if enabled then
    -- A frozen absolute value prevents the time-shift/second-click bug.
    local exact=tonumber(exactSeconds) or shownTimeSeconds()
    tm.serverSkyTargetSeconds=math.floor(wrapDay(exact))
    tm.serverSkyTargetAt=state.clock
    -- Compatibility for the legacy v2 channel (not used in real-sky sending).
    tm.want=wrapOffset(tm.serverSkyTargetSeconds-serverSec())
  else
    tm.serverSkyTargetSeconds=nil
    tm.serverSkyTargetAt=state.clock
    tm.want=0
  end
  tm.curOffset=tm.want
  tm.serverSkyEnabled=enabled
  tm.serverSkyPending=true
  tm.serverSkyAwaiting=false
  tm.serverSkyRetryCount=0
  -- Slider changes coalesce; preset/reset clicks schedule immediately.
  tm.serverSkyPendingAt=state.clock+(debounced and .34 or 0)
  tm.serverSkyStatus='TIME CHANGE QUEUED'
  persist()
end

local function flushServerSky()
  local tm=state.time
  if not tm.serverSkyPending or state.clock<tm.serverSkyPendingAt or
    state.clock<tm.serverSkyNextSendAt or
    state.clock<(state.cspChatNextAt or 0) then return end
  openServerSkyEvent()
  if not tm.serverSkyEvent then return end
  local action=tm.serverSkyEnabled and 'set' or 'sync'
  if action=='set' and tm.serverSkyTargetSeconds==nil then
    -- Migration fallback for v3.22.0 saved preferences (once only).
    tm.serverSkyTargetSeconds=math.floor(wrapDay(serverSec()+tm.want))
    tm.serverSkyTargetAt=state.clock
    persist()
  end
  local value=tostring(tm.serverSkyTargetSeconds or 0)
  local ok,err=pcall(tm.serverSkyEvent,{
    mode=action,seconds=action=='set' and value or '0'
  })
  if ok then
    tm.serverSkyLastAt=state.clock
    -- Stock AssettoServer v0.0.54 discards CHAT events sent <1000ms apart.
    -- Add margin for other CSP chat messages, not only consecutive TIME.
    tm.serverSkyNextSendAt=state.clock+1.35
    state.cspChatNextAt=tm.serverSkyNextSendAt
    tm.serverSkyPending=false
    tm.serverSkyAwaiting=true
    tm.serverSkyExpectedSeconds=action=='set' and value or '0'
    tm.serverSkyStatus=action=='set'
      and ('AWAITING SERVER ACK '..fmtSec(tonumber(value) or 0))
      or 'AWAITING SERVER SYNC ACK'
  else
    tm.serverSkyStatus='SEND FAILED: '..tostring(err):sub(1,60)
    pcall(ac.log,'VENOM X server sky event: '..tostring(err))
  end
end

-- Gold-hour presets intentionally use deterministic in-game clock values.
-- Sampling a dynamic sky feature timestamp from this CSP online sandbox did
-- not produce reliable per-client sun positions. Keep the path that previously
-- worked, and provide fine adjustment around the local weather conditions.
local function setTimePreset(preset, index)
  queueServerSky(true,preset.sec)
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

-- A single subdued wrapping style avoids clipping long diagnostic lines.
local function uiHint(message)
  ui.pushStyleColor(ui.StyleColor.Text, C.dim)
  ui.textWrapped(tostring(message))
  ui.popStyleColor()
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
  sectionLabel('LA CANYONS  /  متصل')
  local p = ui.getCursor()
  local w = PANEL_W - 37
  ui.drawRectFilled(p, vec2(p.x + w, p.y + 91), C.cardSolid, 13)
  ui.drawRect(p, vec2(p.x + w, p.y + 91), C.accentFaint, 13, ui.CornerFlags.All, 1)
  ui.dwriteDrawText('FREEROAM', 22, vec2(p.x + 15,p.y + 10), C.text)
  ui.dwriteDrawText('تجول / قيادة / تواصل', 13, vec2(p.x + 15,p.y + 41),C.dim)
  ui.drawCircleFilled(vec2(p.x + 19,p.y + 76),4,C.ok)
  ui.dwriteDrawText(tostring(#state.players + 1)..' لاعبون متصلون',13,
    vec2(p.x + 30,p.y + 68),C.accentSoft)
  ui.dummy(vec2(0,106))
  sectionLabel('التحكم السريع')
  ui.dummy(vec2(0,7))
  if ui.button('الانتقال إلى موقع  >##vxhomeTP', vec2(0,40)) then setSection('TELEPORT') end
  if ui.button('الانتقال إلى لاعب  >##vxhomePL', vec2(0,40)) then setSection('PLAYERS') end
  if ui.button('لون السيارة وتخصيصها  >##vxhomeCL', vec2(0,40)) then setSection('COLOR') end
  if ui.button('الوقت والسماء  >##vxhomeTM', vec2(0,40)) then setSection('TIME') end
  ui.separator()
  sectionLabel('GHOST MODE / للاعبين فقط')
  local ghost=state.ghost
  if ui.button((ghost.enabled and 'GHOST ON / إيقاف' or
      'GHOST OFF / تشغيل')..'##vxhomeGHOST',vec2(0,38)) then
    toggleGhostMode()
  end
  uiHint(ghostLabel())
  uiHint(ghost.confirmed and
    'خاص باللاعبين فقط - السيرفر أكد الطلب' or
    'لن نعتبر الوضع مؤكدا حتى يصل رد السيرفر')
  if ui.itemHovered() then ui.setTooltip(tostring(ghost.lastStatus)) end
  ui.separator()
  sectionLabel('الاسترجاع / حماية الانتقال')
  uiHint(recoveryStatusLine())
  if ui.button('استرجاع السيارة / آخر نقطة آمنة##vxhomeRecover',vec2(0,33)) then
    tryRecoverCar()
  end
  uiHint('آخر نقطة آمنة محفوظة. اضغط مرتين للتأكيد عند الحاجة.')
  ui.separator()
  local me = car()
  if me then
    local bw = math.max(80,(PANEL_W-52)/2)
    if ui.button(me.headlightsActive and 'الأنوار: تعمل##vxhl' or 'الأنوار: مطفأة##vxhl',vec2(bw,30)) then toggleHeadlights() end
    ui.sameLine()
    if ui.button(me.highBeams and 'الضوء العالي: يعمل##vxhb' or 'الضوء العالي: مطفأ##vxhb',vec2(bw,30)) then toggleHighBeams() end
  end
  if ui.button('العودة إلى الحظيرة##vxhomePit',vec2(0,30)) then returnToPits() end
end

local function drawTeleport()
  sectionLabel(state.destSource == 'chat' and 'مواقع السيرفر' or 'المواقع المتاحة')
  local changed, entered
  state.search, changed, entered = ui.inputText(L.destSearch, state.search)
  if ui.itemHovered() then ui.setTooltip('ابحث باسم الموقع أو المجموعة') end
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
  ui.separator()
  uiHint(recoveryStatusLine())
  if ui.button('استرجاع السيارة##vxTpRecover',vec2(0,28)) then
    tryRecoverCar()
  end
end

local function drawPlayers()
  refreshPlayers(false)
  ui.textColored(string.format('%d لاعبون متصلون', #state.players), C.accentSoft)
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
        if ui.button('انتقال##pl' .. pl.index, vec2(0, 24)) then
          teleportToPlayer(pl)
        end
      end
    end)
    ui.endChild()
    ui.popStyleVar()
    if not okp then error(errp, 0) end
  end
  uiHint(L.trafficHidden)
  uiHint(optionsLabel())
  if ui.itemHovered() then ui.setTooltip(tostring(state.optionsStatus)) end
  ui.textColored(optionsReadout(),C.accentSoft)
  uiHint('يتم حفظ الخيارات أثناء القيادة واستعادتها بعد الانتقال.')
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
  ui.dwriteDrawText(hasCustom and 'اللون الحالي' or 'اللون الأصلي', 13, vec2(p.x + 44, p.y + 2), C.dim)
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
  sectionLabel('الوقت الخاص / لكل لاعب')
  ui.textColored(timeLabel(),C.accentSoft)
  if ui.itemHovered() then ui.setTooltip(tostring(tm.serverSkyStatus)) end
  uiHint('تغيير السماء يتطلب WeatherFX. تأكيد السيرفر لا يعني تحقق التأثير بصريا.')
  ui.dummy(vec2(0,5))
  local p=ui.getCursor()
  ui.drawRectFilled(p,vec2(p.x+PANEL_W-35,p.y+80),C.cardSolid,12)
  ui.drawRect(p,vec2(p.x+PANEL_W-35,p.y+80),C.accentFaint,12,ui.CornerFlags.All,1)
  ui.dwriteDrawText(fmtSec(shownTimeSeconds()),34,
    vec2(p.x+16,p.y+7),C.text)
  ui.dwriteDrawText('الوقت الذي اخترته',13,vec2(p.x+16,p.y+56),C.accentSoft)
  ui.dummy(vec2(0,90))

  -- Controls must never disappear just because online CSP blocks global
  -- weather APIs. This is independent personal UI state for each player.
  sectionLabel('اختر وقتك')
  local tv=shownTimeSeconds()
  local nv=ui.slider('##vx_personal_time',tv,0,86399,'',1)
  if math.abs(nv-tv)>0.5 then
    queueServerSky(true,nv,true)
    tm.lastControl='SLIDER'
  end
  ui.dummy(vec2(0,5))
  local bw=math.max(95,(PANEL_W-56)/2)
  for i,preset in ipairs(TIME_PRESETS) do
    if (i-1)%2==1 then ui.sameLine() end
    if ui.button(preset.label..'##vx_solar_'..i,vec2(bw,32)) then
      setTimePreset(preset,i)
      tm.lastControl=preset.label
      toast('TIME | تم اختيار '..preset.label)
    end
  end
  if ui.button('العودة لوقت السيرفر##vx_time_reset',vec2(0,30)) then
    queueServerSky(false)
    tm.lastControl='RESET'
    toast('TIME | تمت العودة لوقت السيرفر')
  end

  sectionLabel('ضبط الوقت بدقة')
  local fineW=math.max(56,(PANEL_W-57)/4)
  for i,minutes in ipairs({-15,-5,5,15}) do
    if i>1 then ui.sameLine() end
    local label=string.format('%+d min',minutes)
    if ui.button(label..'##vx_fine_'..i,vec2(fineW,29)) then
      queueServerSky(true,shownTimeSeconds()+minutes*60)
      tm.lastControl=label
    end
  end

  ui.separator()
  uiHint('وقت السيرفر: '..fmtSec(wrapDay(serverSec())))
  uiHint('آخر اختيار: '..tostring(tm.lastControl))
  if tm.serverSkyEnabled then
    ui.textColored('TIME | ننتظر تحديث السماء من السيرفر',C.accentSoft)
  elseif tm.mode=='LEGACY COMPANION' then
    ui.textColored('V2 COMPANION: '..tostring(tm.legacyAck),C.accentSoft)
    uiHint('تحقق من مظهر الشمس والسماء داخل اللعبة.')
  elseif tm.mode=='CSP NATIVE' and tm.nativeApplied then
    ui.textColored('TIME | تم إرسال الأمر، تأثير السماء غير مؤكد',C.accentSoft)
  else
    ui.textColored('TIME | لا يمكن التحقق من السماء الآن',C.warn)
    uiHint('V2: '..tostring(tm.legacyAck):sub(1,70))
    uiHint('CSP: '..tostring(tm.nativeResult):sub(1,70))
  end
  -- Sun and moon are read-only here. Never fabricate fake night exposure.
  if tm.lastSunHeight~=nil then
    ui.textDisabled(string.format('ارتفاع الشمس الفعلي: %.3f',tm.lastSunHeight))
  end
  if tm.lastMoonHeight~=nil then
    ui.textDisabled(string.format('ارتفاع القمر الفعلي: %.3f',tm.lastMoonHeight))
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
  sectionLabel('حجم القائمة')
  local szW = (PANEL_W - 40) / 3
  local szNames = { 'S', 'M', 'L' }
  for i = 0, 2 do
    if i > 0 then ui.sameLine() end
    local lbl = (state.panelSize == i) and ('[' .. szNames[i + 1] .. ']') or (' ' .. szNames[i + 1] .. ' ')
    if ui.button(lbl, vec2(szW, 28)) then setPanelSize(i) end
  end
  ui.separator()
  uiHint(L.hudNote)
  ui.separator()
  sectionLabel('التشخيص')
  local spdErr = state.spdErrors or 0
  ui.textDisabled('عداد السرعة: ' .. (spdErr == 0 and 'يعمل' or ('خطأ ×' .. tostring(spdErr))))
  if state.spdErrorMsg then ui.textWrapped('آخر خطأ: ' .. tostring(state.spdErrorMsg):sub(1, 180)) end
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
    if hovered then ui.setTooltip('ضغطة: الاختصارات / زر يمين: القائمة الكاملة') end
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
    local titleSize = ui.measureDWriteText('X', 30, -1)
    ui.dwriteDrawText('X', 30, vec2((ORB_SIZE - titleSize.x) * .5, 0), C.text)
    -- Two tiny red slashes reference the Venom emblem, without an image.
    ui.drawLine(vec2(11,12),vec2(17,19),C.accent,1.6)
    ui.drawLine(vec2(45,12),vec2(39,19),C.accent,1.6)
    local capSize = ui.measureDWriteText('VENOM', 10, -1)
    ui.dwriteDrawText('VENOM', 10, vec2((ORB_SIZE - capSize.x) * .5, 37), C.dim)
  end, true, true)
end

-- VENOM X QUICK DOCK: compact interactive native CSP tool windows.
-- No external icons, fonts, installed plugins or fake input overlays.
local QUICK_ACTIONS = {
  { key='DEST', label='مواقع', hint='الانتقال إلى موقع' },
  { key='FRIEND', label='لاعبون', hint='الانتقال خلف لاعب حقيقي' },
  { key='TIME', label='الوقت', hint='اختر الوقت الخاص بك' },
  { key='PAINT', label='اللون', hint='تغيير لون السيارة' },
  { key='LIGHT', label='الأنوار', hint='تشغيل أو إطفاء الأنوار' },
  { key='HAZARD', label='التحذير', hint='إشارات الخطر' },
  { key='HUD', label='العداد', hint='إظهار أو إخفاء عداد السرعة' },
  { key='GHOST', label='GHOST', hint='وضع الشبح - للاعبين فقط' },
  { key='MENU', label='القائمة', hint='فتح قائمة VENOM X الكاملة' },
}

local function toggleHazards()
  local c=car()
  if not c or not ac.TurningLights or type(ac.setTurningLights)~='function' then
    toast('التحذير غير متاح','warn')
    return
  end
  local mode=c.hazardLights and ac.TurningLights.None or ac.TurningLights.Hazards
  if mode==nil then toast('التحذير غير متاح','warn') return end
  local ok,result=pcall(ac.setTurningLights,mode)
  if not ok or result==false then toast('تعذر تبديل إشارات التحذير','warn') end
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
  elseif kind=='GHOST' then
    ui.drawCircle(v(cx,cy-1),9,paint,24,1.6)
    ui.drawCircleFilled(v(cx-4,cy-2),1.5,paint,12)
    ui.drawCircleFilled(v(cx+4,cy-2),1.5,paint,12)
    ui.drawLine(v(cx-8,cy+9),v(cx-4,cy+6),paint,1.4)
    ui.drawLine(v(cx-4,cy+6),v(cx,cy+9),paint,1.4)
    ui.drawLine(v(cx,cy+9),v(cx+4,cy+6),paint,1.4)
    ui.drawLine(v(cx+4,cy+6),v(cx+8,cy+9),paint,1.4)
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
  -- VENOM vertical quick rail: icon + readable label, always one column.
  local gap,pad,headerH,footerH=4,9,30,9
  local width=clamp(math.floor(scr.x*.12),126,152)
  local maxHeight=math.max(210,scr.y-90)
  local tileH=clamp(
    math.floor((maxHeight-headerH-footerH-pad*2-(count-1)*gap)/count),
    22,44)
  local h=headerH+footerH+pad*2+tileH*count+gap*(count-1)
  local x=state.orbX+ORB_SIZE+12
  if x+width>scr.x-8 then x=state.orbX-width-12 end
  x=clamp(x,8,math.max(8,scr.x-width-8))
  local y=clamp(
    state.orbY+ORB_SIZE*.5-h*.5,43,math.max(43,scr.y-h-8))
  return x,y,width,h,count,width-pad*2,tileH,gap,pad,headerH
end

local function performQuickAction(key)
  if key=='MENU' then openPanel(nil) return end
  if key=='LIGHT' then toggleHeadlights() return end
  if key=='HAZARD' then toggleHazards() return end
  if key=='GHOST' then toggleGhostMode() return end
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
  local x,y,w,h,count,tileW,tileH,gap,pad,headerH=quickDockGeometry()
  local mouse=ui.mousePos()
  local proximity=mouse and inRect(
    {x=x-36,y=y-30,w=w+72,h=h+60},mouse)
  local hovering=state.quickMode~=nil or proximity
  state.dockHover=anim(state.dockHover,hovering and 1 or 0,10,state.dt)
  local reveal=clamp(state.dockHover,0,1)
  local eased=easeOutCubic(progress)
  local visibility=(.24+.76*reveal)*eased
  -- Rail rises gently as it opens; the launcher X stays fixed.
  y=y+(1-eased)*-16
  state.quickDockBounds={
    x=x,y=y,w=w,h=h,tileH=tileH,gap=gap,headerH=headerH,pad=pad
  }
  withWindow('vx_quick_dock',vec2(x,y),vec2(w,h),function()
    ui.drawRectFilled(vec2(0,0),vec2(w,h),
      col(C.glassDeep,visibility*(.23+.62*reveal)),14)
    ui.drawRect(vec2(1,1),vec2(w-1,h-1),
      col(C.accent,visibility*(.20+.25*reveal)),
      14,ui.CornerFlags.All,1)
    ui.drawRectFilled(vec2(14,0),vec2(w-14,2),
      col(C.accent,visibility),1)
    ui.dwriteDrawText('VENOM / سريع',12,vec2(pad+5,11),
      col(C.text,visibility*(.65+.35*reveal)))
    ui.drawLine(vec2(pad,headerH),vec2(w-pad,headerH),
      col(C.accent,visibility*.26),1)
    local vehicle=car()
    for i,item in ipairs(QUICK_ACTIONS) do
      local xx=pad
      local yy=headerH+pad+(i-1)*(tileH+gap)
      ui.setCursor(vec2(xx,yy))
      local click=false
      local hovered=false
      if progress>.88 then
        click=ui.invisibleButton('##vxq_'..item.key,vec2(tileW,tileH))
        hovered=ui.itemHovered()
      else
        ui.dummy(vec2(tileW,tileH))
      end
      local selected=state.quickMode==item.key
      local active=selected or
        (item.key=='HUD' and state.hudVisible) or
        (item.key=='LIGHT' and vehicle and vehicle.headlightsActive) or
        (item.key=='HAZARD' and vehicle and vehicle.hazardLights) or
        (item.key=='GHOST' and state.ghost.enabled)
      local actionColor=item.key=='HAZARD' and C.warn or C.accent
      local bg=active and C.btnActive or hovered and C.btnHover or C.btnFlat
      ui.drawRectFilled(vec2(xx,yy),vec2(xx+tileW,yy+tileH),
        col(bg,visibility*(active and .88 or hovered and .77 or .35)),9)
      ui.drawRect(vec2(xx,yy),vec2(xx+tileW,yy+tileH),
        col(actionColor,visibility*(active and .70 or hovered and .43 or .13)),
        9,ui.CornerFlags.All,1)
      if active then
        ui.drawRectFilled(vec2(xx+1,yy+7),
          vec2(xx+3,yy+tileH-7),col(actionColor,visibility),1)
      end
      local centerY=yy+tileH*.5
      local iconPaint=(selected or hovered) and C.accentSoft or C.text
      quickGlyph(item.key,xx+23,centerY,col(iconPaint,visibility))
      ui.dwriteDrawText(item.label,13,
        vec2(xx+45,centerY-8),
        col((active or hovered) and C.text or C.dim,visibility))
      if tileW>115 then
        ui.dwriteDrawText(string.format('%02d',i),9,
          vec2(xx+tileW-21,centerY-7),
          col(C.dim,visibility*.43))
      end
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
  local w=math.min(302,math.max(220,scr.x-16))
  local h=mode=='TIME' and 418 or mode=='PAINT' and 220 or 270
  h=math.min(h,math.max(160,scr.y-78))
  -- Open flyouts beside the vertical rail, aligned to the selected icon.
  local chosenRow=1
  for i,item in ipairs(QUICK_ACTIONS) do
    if item.key==mode then
      chosenRow=i
      break
    end
  end
  local x=b.x+b.w+11
  if x+w>scr.x-8 then x=b.x-w-11 end
  x=clamp(x,8,math.max(8,scr.x-w-8))
  local rowY=b.y+b.headerH+b.pad+(chosenRow-1)*(b.tileH+b.gap)
  local y=clamp(rowY-12,43,math.max(43,scr.y-h-8))
  withWindow('vx_quick_details',vec2(x,y),vec2(w,h),function()
    ui.drawRectFilled(vec2(0,0),vec2(w,h),C.glassDeep,15)
    ui.drawRect(vec2(1,1),vec2(w-1,h-1),col(C.accent,.32),15,ui.CornerFlags.All,1)
    ui.drawRectFilled(vec2(13,0),vec2(73,2),C.accent,1)
    local heads={DEST='المواقع السريعة',FRIEND='الانتقال إلى صديق',
      TIME='الوقت الخاص',PAINT='لون السيارة'}
    ui.dwriteDrawText(heads[mode] or 'التحكم السريع',15,vec2(15,14),C.text)
    ui.dwriteDrawText('VENOM X  /  تحكم سريع',12,vec2(15,34),C.dim)
    ui.setCursor(vec2(w-37,12))
    if ui.button('X##vxqclose',vec2(25,24)) then state.quickMode=nil end
    ui.drawLine(vec2(13,54),vec2(w-13,54),C.accentFaint,1)
    ui.setCursor(vec2(13,63))
    local opened=ui.beginChild('vx_quick_body',vec2(w-26,h-76),false,ui.WindowFlags.None)
    if opened then
      if mode=='DEST' then
        if #state.destList==0 then
          ui.textDisabled('لا توجد مواقع انتقال في السيرفر')
        else
          for i,d in ipairs(state.destList) do
            if i>16 then break end
            if ui.button(d.name..'##vxqd_'..i,vec2(w-50,31)) then
              teleportDest(d)
              state.quickMode=nil
            end
            if ui.itemHovered() then ui.setTooltip(d.group or 'موقع') end
          end
        end
        ui.separator()
        if ui.button('العودة للحظيرة##vxqpit',vec2(w-50,30)) then
          returnToPits()
          state.quickMode=nil
        end
        ui.separator()
        uiHint(recoveryStatusLine())
        if ui.button('استرجاع السيارة##vxqRecover',vec2(w-50,30)) then
          if tryRecoverCar() then state.quickMode=nil end
        end
      elseif mode=='FRIEND' then
        refreshPlayers(false)
        if #state.players==0 then ui.textDisabled('لا يوجد لاعبون آخرون متصلون') end
        for i,p in ipairs(state.players) do
          if i>6 then break end
          local name=#p.name>22 and p.name:sub(1,21)..'...' or p.name
          if ui.button(name..'  /  TP##vxqfriend_'..i,vec2(w-50,34)) then
            teleportToPlayer(p)
            state.quickMode=nil
          end
          ui.textDisabled(string.format('   %d م',math.floor(p.dist+.5)))
        end
        ui.textDisabled('الترافيك غير مدرج. الانتقال خلف اللاعب باتجاهه.')
        ui.textDisabled(optionsLabel())
        ui.textColored(optionsReadout(),C.accentSoft)
      elseif mode=='TIME' then
        local tm=state.time
        local now=shownTimeSeconds()
        ui.textColored(fmtSec(now),C.accentSoft)
        ui.textColored(timeLabel(),C.accentSoft)
        local selected=ui.slider('##vxq_clock',now,0,86399,'',1)
        if math.abs(selected-now)>.5 then
          queueServerSky(true,selected,true)
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
        if ui.button('وقت السيرفر##vxqreset',vec2(w-50,28)) then
          queueServerSky(false)
          tm.lastControl='RESET'
        end
        if tm.serverSkyEnabled then
          ui.textColored('TIME | جار تحديث السماء من السيرفر',C.accentSoft)
          ui.textDisabled('تحتاج إضافة VENOM Personal Time بالسيرفر')
        elseif tm.mode=='LEGACY COMPANION' then
          ui.textColored('TIME | قناة التوقيت القديمة v2',C.accentSoft)
          ui.textDisabled(tostring(tm.legacyAck))
        elseif tm.mode=='CSP NATIVE' then
          ui.textDisabled('CSP | تغيير السماء غير مؤكد بصريا')
        else
          ui.textColored('TIME | السماء لم تتغير بعد',C.warn)
          uiHint('V2: '..tostring(tm.legacyAck):sub(1,54))
          uiHint('CSP: '..tostring(tm.nativeResult):sub(1,54))
        end
        if tm.lastSunHeight~=nil then
          ui.textDisabled(string.format('ارتفاع الشمس: %.3f',tm.lastSunHeight))
        end
        ui.textDisabled('تأكيد السيرفر لا يثبت تغير السماء. تحقق بعينك.')
      elseif mode=='PAINT' then
        local ww=(w-68)/4
        for i,preset in ipairs(PRESETS) do
          if (i-1)%4~=0 then ui.sameLine() end
          local click=ui.button(preset.label..'##vxqp_'..i,vec2(ww,30))
          if click then applyColor(preset) end
          if ui.itemHovered() then ui.setTooltip(preset.label..' - تطبيق اللون') end
        end
        if ui.button('استرجاع اللون الأصلي##vxqoriginal',vec2(w-50,30)) then applyColor(nil) end
        ui.textDisabled('تغيير اللون يعتمد على صلاحيات السيرفر.')
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
    ui.dwriteDrawText('VENOM', 21, vec2(18, 10), C.text)
    ui.dwriteDrawText('X', 21, vec2(105, 10), C.accent)
    ui.dwriteDrawText('التحكم  /  LA CANYONS', 13, vec2(18, 39), C.dim)
    ui.drawRectFilled(vec2(18,59),vec2(73,61),C.accent,1)

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
    ui.dwriteDrawText('VENOM X   ' .. VERSION, 12, vec2(15, footY + 3), C.dim)
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

local function toastSafeTop(scr)
  -- Reserve real space below the virtual mirror as well as the logo.
  -- Previous clamp to scr.y-156 incorrectly pushed the first toast back up.
  local logoW=clamp(scr.x*.16,155,252)
  local logoBottom=2+logoW*(665/2048)
  if scr.y<320 then return math.max(logoBottom+18,scr.y-52) end
  return math.max(242,math.floor(scr.y*.31),logoBottom+26)
end

local function drawToasts()
  if #state.toasts == 0 then return end
  local scr = getScreenSize()
  pushGlass()
  local okc = pcall(function()
    local yStart=toastSafeTop(scr)
    ui.beginTransparentWindow('vx_toasts', vec2(0, 0), vec2(scr.x, scr.y), true, false)
    local visible=math.max(1,math.floor((scr.y-yStart-8)/48))
    local first=math.max(1,#state.toasts-visible+1)
    for i=first,#state.toasts do
      local t=state.toasts[i]
      local aIn = clamp(t.t / 0.16, 0, 1)
      local aOut = clamp((t.dur - t.t) / 0.3, 0, 1)
      local a = easeOutCubic(aIn) * aOut
      if a > 0.02 then
        local tsz = ui.measureDWriteText(t.text, 15, -1)
        local w = math.max(240, tsz.x + 44)
        local h = 40
        local slide = (1 - easeOutCubic(aIn)) * -18
        local x = (scr.x - w) * 0.5
        local y = yStart + (i - first) * (h + 8) + slide
        ui.drawRectFilled(vec2(x, y), vec2(x + w, y + h), rgbm(0.045, 0.055, 0.090, 0.95 * a), 10)
        ui.drawRect(vec2(x, y), vec2(x + w, y + h), rgbm(C.accent.r, C.accent.g, C.accent.b, 0.35 * a), 10, ui.CornerFlags.All, 1)
        local barC = t.kind == 'warn' and C.warn or C.ok
        ui.drawRectFilled(vec2(x + 1, y + 8), vec2(x + 5, y + h - 8), rgbm(barC.r, barC.g, barC.b, a), 2)
        ui.dwriteDrawText(t.text, 15, vec2(x + 18, y + (h - 19) * 0.5), rgbm(1, 1, 1, a))
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
  -- Source CMRT gearbox uses 435x100 for its KERS capsule. Display at
  -- 70% by default, matching the compact ~305px screenshot reference.
  local k = .70 * clamp(state.hudScale or 100, 80, 130) / 100
  local w, h = math.floor(435*k), math.floor(135*k)
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
-- Independent compact CMRT-style telemetry, redrawn from scratch with
-- native CSP vector primitives. No imported font/image or third-party code.
-- Geometry: long thin pill, gear ring, RPM shift dots, speed, KERS/fuel
-- circular percentage, and a slim fuel/estimated-laps footer.
-- Pixel-faithful CMRT gearbox layout, rebuilt with VENOM crimson colors.
-- Matching original 435x100 KERS variant proportions, 14 RPM LEDs, the
-- large 50px endcaps, two 46px dial outlines and floating fuel capsule.
-- Recreated entirely with native CSP vector calls; no local files required.
local function drawSpeedometer()
  if not state.hudVisible then return end
  local c=car()
  if not c then return end
  local speed=math.max(0,tonumber(stateVal(c,'speedKmh')) or 0)
  local rpm=math.max(0,tonumber(stateVal(c,'rpm')) or 0)
  local gear=gearString(tonumber(stateVal(c,'gear')) or 0)
  local limiter=tonumber(stateVal(c,'rpmLimiter')) or 8000
  if limiter<100 then limiter=8000 end

  local x,y,w,h,k=speedoRect()
  x,y=handleSpeedoDrag(x,y,w,h)
  if state.spdX<0 then state.spdX,state.spdY=x,y end

  local opacity=clamp(state.hudOp or 90,40,100)/100
  state.smoothSpeed=anim(state.smoothSpeed,speed,12,state.dt)
  state.smoothRpm=anim(state.smoothRpm,rpm,14,state.dt)

  local ratio=clamp(state.smoothRpm/limiter,0,1)
  local fuel=tonumber(stateVal(c,'fuel'))
  local maxFuel=tonumber(stateVal(c,'maxFuel'))
  local fuelPerLap=tonumber(stateVal(c,'fuelPerLap'))
  local battery=tonumber(stateVal(c,'kersCharge'))
  local hasBattery=stateVal(c,'kersPresent')==true
  local pct=nil
  if hasBattery and battery and battery>=0 then
    pct=clamp(battery<=1 and battery*100 or battery,0,100)
  elseif fuel and maxFuel and maxFuel>0 then
    pct=clamp(fuel/maxFuel*100,0,100)
  end

  withWindow('vx_speedo',vec2(x,y),vec2(w,h),function()
    local function v(px,py) return vec2(px*k,py*k) end
    local function color(base,moreAlpha)
      return col(base,opacity*(moreAlpha or 1))
    end
    local function textAt(value,px,py,size,paint)
      ui.dwriteDrawText(tostring(value),size*k,v(px,py),color(paint))
    end
    local function centered(value,cx,cy,size,paint)
      local valueString=tostring(value)
      local ts=ui.measureDWriteText(valueString,size*k,-1)
      ui.dwriteDrawText(valueString,size*k,
        v(cx,cy)-vec2(ts.x*.5,ts.y*.5),color(paint))
    end
    local function ring(cx,cy,r,width,a,b,paint,fade)
      ui.pathClear()
      ui.pathArcTo(v(cx,cy),r*k,a,b,64)
      ui.pathStroke(color(paint,fade),false,width*k)
    end

    -- Identical silhouette principle to original GEARBOX_ERS capsule:
    -- 435x100 body starting y=20, tangent round ends radius 50.
    -- Deep transparent obsidian replaces CMRT's untinted asset.
    ui.drawRectFilled(v(0,20),v(435,120),
      rgbm(.015,.015,.021,opacity*.91),50*k)
    ui.drawRect(v(1,21),v(434,119),
      rgbm(.69,.68,.73,opacity*.17),49*k,ui.CornerFlags.All,1.25*k)
    ui.drawRectFilled(v(43,30),v(392,112),
      rgbm(.023,.021,.028,opacity*.56),38*k)
    -- Soft internal highlight on the upper contour: CMRT texture feel.
    ui.drawLine(v(54,23),v(380,23),
      rgbm(.65,.64,.67,opacity*.075),1*k)

    -- LEFT GEAR: CMRT circle centered 50/70, ~46px radius and 6px rim.
    local gcx,gcy=50,70
    ui.drawCircleFilled(v(gcx,gcy),45*k,
      rgbm(.021,.020,.027,opacity*.91),64)
    ring(gcx,gcy,42,6,.10,.10+math.pi*1.94,C.dim,.29)
    ring(gcx,gcy,42,6,.11,.11+math.pi*1.94*ratio,
      ratio>.96 and C.warn or C.accent,.98)
    ui.drawCircle(v(gcx,gcy),36*k,color(C.dim,.16),58,1.4*k)
    centered(gear,gcx,gcy-1,46,C.text)

    -- EXACT CMRT dot quantity and 14px spacing, not the prior 19 LEDs.
    for i=0,13 do
      local active=state.rpmBar and ratio*14>=i+1
      local hue=ratio>.95 and C.warn or C.accent
      ui.drawCircleFilled(v(126+i*14,39),4.35*k,
        color(active and hue or C.dim,active and .99 or .21),17)
    end

    -- SPEED + RPM occupy the same columns as the screenshot.
    textAt('KMH',110,53,14,C.dim)
    textAt(tostring(math.floor(state.smoothSpeed+.5)),
      110,69,25,C.text)
    textAt('RPM',200,53,14,C.dim)
    textAt(tostring(math.floor(state.smoothRpm+.5)),
      200,69,25,C.text)

    -- RIGHT BATTERY/FUEL RING: same footprint as original CMRT
    -- ~100px end-cap. Percent text only, no second label inside.
    local rcx,rcy=385,70
    ui.drawCircleFilled(v(rcx,rcy),47*k,
      rgbm(.016,.016,.022,opacity*.97),64)
    ring(rcx,rcy,42,6,-math.pi*.97,math.pi*.97,C.dim,.26)
    if pct and pct>.05 then
      ring(rcx,rcy,42,6,
        -math.pi*.97,-math.pi*.97+math.pi*1.94*(pct/100),
        pct<12 and C.warn or C.accent,1)
    end
    ui.drawCircle(v(rcx,rcy),35*k,color(C.dim,.13),60,1*k)
    centered(pct and tostring(math.floor(pct+.5)) or '--',
      rcx,rcy,23,C.text)

    -- Original fuel capsule overlaps bottom edge, centered horizontally.
    ui.drawRectFilled(v(85,106),v(319,126),
      rgbm(.016,.016,.022,opacity*.92),10*k)
    ui.drawRect(v(85,106),v(319,126),
      color(C.dim,.35),10*k,ui.CornerFlags.All,2*k)
    local fuelLow=fuel and maxFuel and maxFuel>0
      and (fuel/maxFuel)<.10
    ui.drawCircleFilled(v(97,116),4.1*k,
      color(fuelLow and C.accent or C.dim,.82),18)
    local fuelValue=fuel and string.format('%.1fL',fuel) or '--'
    local laps=(fuel and fuelPerLap and fuelPerLap>.01)
      and string.format('%.1f',fuel/fuelPerLap) or '--'
    textAt('FUEL',109,109,13,C.dim)
    textAt(fuelValue,155,109,14,C.text)
    textAt('EST.LAP',219,109,13,C.dim)
    textAt(laps,286,109,13,C.text)
  end,true,false,true)
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

-- Restored compatibility with the ORIGINAL v2.0 local time protocol.
-- It only uses a running existing VENOM client Companion (no Pure or
-- weather plugin installation prompted by this server script).
-- Layout MUST match the 2026-10-08 v2.0 GitHub revision byte for byte.
local LEGACY_TIME_FIELDS={
  'beat','cmdSeq','cmdOffset','cmdInstant',
  'ackSeq','ackResult','ackAt','ackErr'
}

local function openLegacyTimeCompanion()
  local tm=state.time
  if tm.legacyConnected then return end
  tm.legacyConnected=true
  if type(ac.connect)~='function' or
      not ac.StructItem or not ac.SharedNamespace then
    tm.legacyAck='LEGACY SHARED API NOT AVAILABLE'
    return
  end
  local ok,shared=pcall(function()
    local layout={
      beat=ac.StructItem.int32(),
      cmdSeq=ac.StructItem.int32(),
      cmdOffset=ac.StructItem.float(),
      cmdInstant=ac.StructItem.int32(),
      ackSeq=ac.StructItem.int32(),
      ackResult=ac.StructItem.int32(),
      ackAt=ac.StructItem.int32(),
      ackErr=ac.StructItem.string(96),
    }
    return ac.connect(layout,true,ac.SharedNamespace.Shared)
  end)
  if ok and shared then
    tm.legacyShared=shared
    tm.legacyAck='WAITING FOR ORIGINAL v2 COMPANION'
  else
    tm.legacyAck='LEGACY CONNECT NOT AVAILABLE'
  end
end

local function updateLegacyTimeCompanion()
  local tm=state.time
  if not tm.legacyConnected then openLegacyTimeCompanion() end
  local shared=tm.legacyShared
  tm.legacyReady=false
  if not shared then return end
  local s=sim()
  if not s then return end
  local ready,frame=pcall(function()
    return tonumber(s.frame) or -1
  end)
  if not ready then return end
  local okBeat,beat=pcall(function() return tonumber(shared.beat) or -1 end)
  if not okBeat or beat<=0 or frame<beat or frame-beat>=180 then
    tm.legacyAck='ORIGINAL COMPANION NOT RUNNING'
    return
  end
  tm.legacyReady=true

  if tm.legacySeq~=nil then
    local okAck,ackSeq,ackResult,ackErr=pcall(function()
      return tonumber(shared.ackSeq),tonumber(shared.ackResult),
        tostring(shared.ackErr or '')
    end)
    if okAck and ackSeq==tm.legacySeq then
      if ackResult==2 then
        tm.legacyAck='COMPANION ERROR: '..tostring(ackErr):sub(1,55)
      else
        tm.legacyAck='COMPANION ACK / CHECK SKY'
      end
      tm.legacySeq=nil
    elseif state.clock-tm.legacyPendingAt>3.5 then
      tm.legacyAck='COMPANION DID NOT ACK'
      tm.legacySeq=nil
    end
  end
  if tm.legacySeq~=nil then return end
  if math.abs(wrapOffset(tm.want-tm.legacyLastTarget))<1 then return end
  local okWrite,seq=pcall(function()
    local n=(tonumber(shared.cmdSeq) or 0)+1
    shared.cmdOffset=wrapOffset(tm.want)
    shared.cmdInstant=1
    shared.cmdSeq=n
    return n
  end)
  if okWrite then
    tm.legacySeq=seq
    tm.legacyPendingAt=state.clock
    tm.legacyLastTarget=tm.want
    tm.legacyAck='SENT VIA ORIGINAL v2 COMPANION'
  else
    tm.legacyAck='COMPANION WRITE REJECTED'
  end
end

local function timeControlUpdate(dt)
  local tm=state.time
  if tm.serverSkyAwaiting and state.clock-tm.serverSkyLastAt>2.1 then
    tm.serverSkyAwaiting=false
    if tm.serverSkyRetryCount<3 then
      -- The server might have discarded CSP's chat packet during the 1s
      -- rate-limit window. Retry THIS EXACT absolute time, no extra click.
      tm.serverSkyRetryCount=tm.serverSkyRetryCount+1
      tm.serverSkyPending=true
      tm.serverSkyPendingAt=state.clock
      tm.serverSkyStatus='RETRYING SERVER TIME '..tm.serverSkyRetryCount
    else
      tm.serverSkyStatus='NO SERVER ACK / CHECK PLUGIN DLL AND LOGS'
    end
  end
  flushServerSky()
  tm.curOffset=anim(tm.curOffset,tm.want,2.8,dt)
  if math.abs(tm.want-tm.curOffset)<1 then tm.curOffset=tm.want end
  -- First try the original v2.0 local companion channel. Pure is NOT required.
  if not tm.serverSkyEnabled then updateLegacyTimeCompanion() end
  tm.mode=tm.serverSkyEnabled and 'SERVER PERSONAL' or
    tm.legacyReady and 'LEGACY COMPANION' or
    (type(ac.setWeatherTimeOffset)=='function' and
      not tm.nativeRejected and 'CSP NATIVE' or 'SERVER')
  if tm.mode=='LEGACY COMPANION' then
    tm.nativeResult='LEGACY: '..tostring(tm.legacyAck)
  elseif tm.mode~='CSP NATIVE' and not tm.nativeRejected then
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
  ghostUpdate()
  monitorExternalTeleports()
  restoreTeleportOptions()
  updateTeleportShield()
  sampleRecoverySpot()
  verifyPlayerTeleport()
  if (state.panelOpen and state.section == 'PLAYERS') or state.quickMode=='FRIEND' then
    refreshPlayers(false)
  end
end

-- Always-on official VENOM banner, centered against the full UI viewport.
-- Place optimized image at assets/venom_logo.webp in this GitHub repository.
-- Loaded over HTTPS and cached by CSP; no per-frame downloads or client mods.
local VENOM_LOGO_URL =
  'https://raw.githubusercontent.com/takhmamdzirii1-dot/venom-x/main/assets/venom_logo.webp'

local BRAND_FONT=nil
do
  local ok,ff=pcall(function()
    if type(ui.DWriteFont)~='function' then return nil end
    return ui.DWriteFont('Segoe UI'):weight(700)
  end)
  if ok then BRAND_FONT=ff end
end
local function withBrandFont(draw)
  local pushed=false
  if BRAND_FONT and type(ui.pushFont)=='function' then
    pushed=pcall(ui.pushFont,BRAND_FONT)
  end
  local ok,err=pcall(draw)
  if pushed then pcall(ui.popFont) end
  if not ok then error(err) end
end

local function drawVenomOfficialLogo()
  local screen=getScreenSize()
  if not screen or type(ui.drawImage)~='function' then return end
  -- Compact, independent of the main menu, quick dock, and movable tachometer.
  -- Anchor to the upper edge of the screen, ABOVE the typical virtual mirror.
  local width=clamp(screen.x*.16,155,252)
  local height=width*(665/2048)
  local left=math.floor((screen.x-width)*.5)
  local top=2
  ui.beginTransparentWindow('vx_official_logo',
    vec2(left,top),vec2(width,height+1),true,false)
  ui.drawImage(VENOM_LOGO_URL,vec2(0,0),
    vec2(width,height),rgbm(1,1,1,.97))
  ui.endTransparentWindow()
end

function script.drawUI()
  local logoOk,logoErr=pcall(drawVenomOfficialLogo)
  if not logoOk and not state.logoErrorReported then
    state.logoErrorReported=true
    pcall(ac.log,'VENOM X official logo: '..tostring(logoErr))
  end
  if not state.readyDone then
    state.readyFrames = state.readyFrames + 1
    if state.readyFrames >= 90 then
      state.readyDone = true
      toast(L.ready)
    end
  end
  local launchOk, launchErr = pcall(function() withBrandFont(drawVenomLauncher) end)
  if launchOk then
    state.launcherErrors = 0
  else
    state.launcherErrors = (state.launcherErrors or 0) + 1
    if state.launcherErrors == 1 then pcall(ac.log, 'VENOM X launcher: ' .. tostring(launchErr)) end
  end
  local quickOk, quickErr=pcall(function()
    withBrandFont(drawQuickDock)
    withBrandFont(drawQuickPopup)
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
  if pcall(function() withBrandFont(drawToasts) end) then
    state.toastErrors = 0
  else
    state.toastErrors = (state.toastErrors or 0) + 1
  end
  local ok, panelErr = pcall(function() withBrandFont(drawVenomPanelSafe) end)
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
