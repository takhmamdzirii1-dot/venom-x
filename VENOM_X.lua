script = script or {}

local VENOM_X_VERSION = '1.0.0'

local L = {
  title = 'VENOM X',
  subtitle = 'LA CANYONS',
  versionTag = 'v1.0.0',
  ready = 'VENOM X READY - open it from the CSP lightbulb menu',
  tabHome = 'HOME',
  tabTeleport = 'TELEPORT',
  tabPlayers = 'PLAYERS',
  tabCar = 'CAR',
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
  destinations = 'TELEPORT DESTINATIONS',
  kmh = 'KM/H',
  gear = 'GEAR %s',
  rpm = 'RPM',
  playersTitle = 'PLAYERS',
  connectedPlayers = 'Connected players: %d',
  teleportHint = 'Click a driver to teleport 10 m behind them (your own car only)',
  cooldown = 'Teleport cooldown: %.1f s',
  pleaseWait = 'Please wait %d s',
  playerUnavailable = 'Player is no longer available',
  stopCarFirst = 'Stop your car before teleporting',
  teleportedTo = 'Teleported to %s',
  teleportedToPlayer = 'Teleported behind %s',
  teleportFailed = 'Teleport failed',
  noPlayers = 'No other players connected',
  trafficHidden = 'AI traffic is not shown here.',
  carColor = 'CAR COLOR',
  currentColor = 'Current color',
  defaultColor = 'Default livery color',
  colorHowTo = 'Change Color',
  colorHowToMsg = 'Use the built-in CSP color changer in the CSP lightbulb menu. It is enabled server-side for your slot. Works on cars with regular skins - textured liveries may not recolor.',
  liveryNote = 'Some liveries cannot be recolored. The built-in CSP picker handles that automatically.',
  lights = 'LIGHTS',
  headlightsOn = 'Headlights: ON',
  headlightsOff = 'Headlights: OFF',
  highBeamsOn = 'High Beams: ON',
  highBeamsOff = 'High Beams: OFF',
  serverTime = 'SERVER TIME',
  timeOverrideUnavailable = 'Local time override unavailable',
  timeOverrideReason = 'CSP Online Scripts cannot change the time of day: ac.setWeatherTimeOffset is an app-script / offline-only API and is not exposed to online scripts. Server time is synced by AssettoServer and shared by every player, so VENOM X shows it read-only instead of faking a local override.',
  hudSettings = 'HUD SETTINGS',
  speedometer = 'Speedometer',
  rpmBar = 'RPM bar',
  hudNote = 'The speedometer appears automatically in the lower-right corner when you join.',
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
  card = rgbm(0.07, 0.09, 0.13, 0.55),
  cardSolid = rgbm(0.05, 0.06, 0.09, 0.62),
  bar = rgbm(1.00, 1.00, 1.00, 0.12),
  ok = rgbm(0.35, 0.90, 0.55, 1.00),
  warn = rgbm(1.00, 0.72, 0.30, 1.00),
  danger = rgbm(1.00, 0.38, 0.38, 1.00),
}

local state = {
  frames = 0,
  hudVisible = true,
  rpmBar = true,
  teleportCooldown = 0,
  players = {},
  playersAt = -999,
  screen = nil,
  screenAt = -999,
  readyDone = false,
  readyFrames = 0,
  smoothSpeed = 0,
}

local config = {}
local destinations = {}
local destById = {}
local stored = nil

local function car() return ac.getCar(0) end
local function sim() return ac.getSim() end

local function toast(message, icon)
  pcall(function() ui.toast(icon or ui.Icons.Bulb, tostring(message)) end)
end

local function trim(s)
  return (tostring(s):gsub('^%s*(.-)%s*$', '%1'))
end

local function fmtClock(h, m, s)
  return string.format('%02d:%02d:%02d', h, m, s)
end

local function loadStored()
  local ok, res = pcall(function()
    return ac.storage({ venomx_hud = true, venomx_rpm = true })
  end)
  if ok and type(res) == 'table' then
    stored = res
    if res.venomx_hud ~= nil then state.hudVisible = res.venomx_hud end
    if res.venomx_rpm ~= nil then state.rpmBar = res.venomx_rpm end
  end
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

local function buildDestinations()
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
        destinations[#destinations + 1] = d
        destById[i] = d
      end
    end
  end
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

local function teleportToDestination(d)
  if not d or not d.pos then return end
  local rad = math.rad(d.heading)
  local dir = vec3(math.sin(rad), 0, -math.cos(rad))
  teleportSelf(d.pos, dir, string.format(L.teleportedTo, d.name))
end

local function returnToPits()
  local d = destById[0] or destinations[1]
  if d then
    teleportToDestination(d)
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
  if not target or not target.isActive or not target.isConnected or target.isAIControlled then
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

local function refreshPlayers(force)
  if not force and (state.frames - state.playersAt) < 24 then return end
  state.playersAt = state.frames
  local myPos = car().position
  local list = {}
  for _, c in ac.iterateCars() do
    if c.index ~= 0 and c.isConnected and c.isActive and not c.isAIControlled then
      local nm = c.driverName
      if nm == nil or nm == '' then nm = L.unknownDriver end
      list[#list + 1] = {
        index = c.index,
        name = nm,
        model = c.id,
        dist = math.distance(c.position, myPos),
      }
    end
  end
  table.sort(list, function(a, b) return a.dist < b.dist end)
  state.players = list
end

local function toggleHeadlights()
  local c = car()
  pcall(function() ac.setHeadlights(not c.headlightsActive) end)
end

local function toggleHighBeams()
  local c = car()
  pcall(function() ac.setHighBeams(not c.highBeams) end)
end

local function toggleHud()
  state.hudVisible = not state.hudVisible
  if stored then stored.venomx_hud = state.hudVisible end
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

local function drawSpeedometer()
  if not state.hudVisible then return end
  local size = getScreenSize()
  local w, h = 216, 138
  local x0 = size.x - w - 26
  local y0 = size.y - h - 96
  local c = car()

  ui.drawRectFilled(vec2(x0, y0), vec2(x0 + w, y0 + h), C.cardSolid, 14)
  ui.drawRect(vec2(x0, y0), vec2(x0 + w, y0 + h), C.accentFaint, 14, ui.CornerFlags.All, 1.5)

  state.smoothSpeed = state.smoothSpeed + (math.max(0, c.speedKmh) - state.smoothSpeed) * 0.25
  local speedStr = tostring(math.floor(state.smoothSpeed + 0.5))
  local sz = ui.measureDWriteText(speedStr, 44, -1)
  ui.dwriteDrawText(speedStr, 44, vec2(x0 + (w - sz.x) * 0.5, y0 + 8), C.text)

  local ks = ui.measureText(L.kmh, -1)
  ui.drawText(L.kmh, vec2(x0 + (w - ks.x) * 0.5, y0 + 60), C.accentSoft)

  ui.drawText(string.format(L.gear, gearString(c.gear)), vec2(x0 + 14, y0 + 82), C.text)

  local rp = ui.measureText(L.rpm, -1)
  ui.drawText(L.rpm, vec2(x0 + w - 14 - rp.x, y0 + 82), C.dim)

  if state.rpmBar then
    local maxRpm = c.rpmLimiter
    if not maxRpm or maxRpm <= 0 then maxRpm = 8000 end
    local frac = math.max(0, math.min(1, c.rpm / maxRpm))
    local bx0, by0 = x0 + 14, y0 + 100
    local bx1, by1 = x0 + w - 14, y0 + 108
    ui.drawRectFilled(vec2(bx0, by0), vec2(bx1, by1), C.bar, 4)
    if frac > 0.005 then
      ui.drawRectFilled(vec2(bx0, by0), vec2(bx0 + (bx1 - bx0) * frac, by1), C.accent, 4)
    end
  end

  ui.drawText(L.title, vec2(x0 + 14, y0 + 118), rgbm(0.42, 0.52, 0.72, 0.55))
end

local function card(id, height, contentFn)
  ui.pushStyleVar(ui.StyleVar.ChildRounding, 10)
  ui.pushStyleColor(ui.StyleColor.ChildBg, C.card)
  if ui.beginChild(id, vec2(0, height), false, ui.WindowFlags.None) then
    contentFn()
  end
  ui.endChild()
  ui.popStyleColor()
  ui.popStyleVar()
end

local function drawHomeTab(me, simulation)
  ui.textColored(config.DISPLAY_NAME or 'VENOM LA Canyons', C.text)
  ui.textColored(config.DISPLAY_SUB or 'LA Canyons Freeroam', C.dim)
  ui.separator()
  card('VENOM_X_HOME_STATS', 118, function()
    ui.textColored(L.server, C.accentSoft)
    ui.text(string.format(L.connected, simulation.connectedCars))
    ui.text(string.format(L.timeNow, fmtClock(simulation.timeHours, simulation.timeMinutes, simulation.timeSeconds)))
    ui.text(string.format(L.speedNow, math.floor(math.max(0, me.speedKmh) + 0.5)))
  end)
  ui.separator()
  if ui.button(L.returnToPits, vec2(0, 28)) then
    returnToPits()
  end
  ui.button(state.hudVisible and L.hideHud or L.showHud, vec2(0, 28))
end

local function drawTeleportTab()
  ui.textColored(L.destinations, C.accentSoft)
  if #destinations == 0 then
    ui.textDisabled(L.noDestinations)
    return
  end
  card('VENOM_X_DEST_LIST', 330, function()
    local lastGroup = nil
    for _, d in ipairs(destinations) do
      if d.group ~= lastGroup then
        lastGroup = d.group
        ui.textColored(d.group, C.accent)
      end
      if ui.button(d.name, vec2(0, 21)) then
        teleportToDestination(d)
      end
      ui.setTooltip(string.format('%s\n%.1f, %.1f, %.1f', d.name, d.pos.x, d.pos.y, d.pos.z))
    end
  end)
  ui.separator()
  if ui.button(L.returnToPits, vec2(0, 28)) then
    returnToPits()
  end
end

local function drawPlayersTab()
  refreshPlayers(false)
  ui.textColored(string.format(L.connectedPlayers, #state.players), C.accentSoft)
  ui.textDisabled(L.teleportHint)
  ui.separator()
  card('VENOM_X_PLAYER_LIST', 330, function()
    if #state.players == 0 then
      ui.textDisabled(L.noPlayers)
    else
      for _, p in ipairs(state.players) do
        if ui.button(string.format('%s   %d m', p.name, math.floor(p.dist + 0.5)), vec2(0, 23)) then
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

local function drawCarTab(me)
  ui.textColored(L.carColor, C.accentSoft)
  card('VENOM_X_COLOR', 96, function()
    local cc = me.customCarColor
    local p = ui.cursorScreenPos()
    if cc and cc.r == cc.r then
      ui.drawRectFilled(p, vec2(p.x + 26, p.y + 26), rgbm(cc.r, cc.g, cc.b, 1), 6)
      ui.drawRect(p, vec2(p.x + 26, p.y + 26), rgbm(1, 1, 1, 0.35), 6, ui.CornerFlags.All, 1)
      ui.setCursorScreenPos(vec2(p.x + 34, p.y))
      ui.textColored(L.currentColor, C.text)
    else
      ui.setCursorScreenPos(vec2(p.x + 34, p.y))
      ui.textColored(L.defaultColor, C.dim)
    end
    ui.setCursorScreenPos(vec2(p.x, p.y + 34))
    if ui.button(L.colorHowTo, vec2(0, 24)) then
      toast(L.colorHowToMsg)
    end
  end)
  ui.textDisabled(L.liveryNote)
  ui.separator()
  ui.textColored(L.lights, C.accentSoft)
  if ui.button(me.headlightsActive and L.headlightsOn or L.headlightsOff, vec2(0, 28)) then
    toggleHeadlights()
  end
  if ui.button(me.highBeams and L.highBeamsOn or L.highBeamsOff, vec2(0, 28)) then
    toggleHighBeams()
  end
end

local function drawTimeTab(simulation)
  ui.textColored(L.serverTime, C.accentSoft)
  local p = ui.cursorScreenPos()
  local tstr = fmtClock(simulation.timeHours, simulation.timeMinutes, simulation.timeSeconds)
  local tsz = ui.measureDWriteText(tstr, 38, -1)
  ui.dwriteDrawText(tstr, 38, p, C.text)
  ui.setCursorScreenPos(vec2(p.x, p.y + tsz.y + 8))
  ui.textDisabled(string.format(L.timeNow, tstr))
  ui.separator()
  card('VENOM_X_TIME_INFO', 150, function()
    ui.textColored(L.timeOverrideUnavailable, C.warn)
    ui.textWrapped(L.timeOverrideReason)
  end)
end

local function drawHudTab()
  ui.textColored(L.hudSettings, C.accentSoft)
  if ui.checkbox(L.speedometer, state.hudVisible) then
    toggleHud()
  end
  if ui.checkbox(L.rpmBar, state.rpmBar) then
    state.rpmBar = not state.rpmBar
    if stored then stored.venomx_rpm = state.rpmBar end
  end
  ui.separator()
  ui.textDisabled(L.hudNote)
end

local function drawPanel()
  local me = car()
  local simulation = sim()

  ui.pushStyleVar(ui.StyleVar.WindowPadding, vec2(12, 10))

  ui.pushFont(ui.Font.Title)
  ui.textColored(L.title, C.accent)
  ui.popFont()
  ui.sameLine()
  ui.textColored(L.versionTag, C.dim)
  ui.textColored(L.subtitle, C.dim)
  ui.separator()

  if ui.beginTabBar('VENOM_X_TABS', ui.TabBarFlags.None) then
    if ui.beginTabItem(L.tabHome, ui.TabItemFlags.None) then drawHomeTab(me, simulation); ui.endTabItem() end
    if ui.beginTabItem(L.tabTeleport, ui.TabItemFlags.None) then drawTeleportTab(); ui.endTabItem() end
    if ui.beginTabItem(L.tabPlayers, ui.TabItemFlags.None) then drawPlayersTab(); ui.endTabItem() end
    if ui.beginTabItem(L.tabCar, ui.TabItemFlags.None) then drawCarTab(me); ui.endTabItem() end
    if ui.beginTabItem(L.tabTime, ui.TabItemFlags.None) then drawTimeTab(simulation); ui.endTabItem() end
    if ui.beginTabItem(L.tabHud, ui.TabItemFlags.None) then drawHudTab(); ui.endTabItem() end
    ui.endTabBar()
  end

  ui.separator()
  ui.textDisabled(string.format(L.footer, VENOM_X_VERSION))

  ui.popStyleVar()
end

function script.update(dt)
  state.frames = state.frames + 1
  if state.teleportCooldown > 0 then
    state.teleportCooldown = math.max(0, state.teleportCooldown - dt)
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
  local ok = pcall(drawSpeedometer)
  if not ok and state.frames % 240 == 0 then
    state.hudVisible = false
  end
end

loadStored()
loadConfig()
buildDestinations()

ui.registerOnlineExtra(ui.Icons.Bulb, L.title,
  function() return true end,
  function() drawPanel(); return false end,
  function(ok) end,
  ui.OnlineExtraFlags.Tool,
  bit.bor(ui.WindowFlags.NoCollapse, ui.WindowFlags.NoFocusOnAppearing),
  vec2(400, 580)
)
