if ac == nil or ac.store == nil or ac.load == nil then
  return
end

local sim = ac.getSim()

local KEY_ENABLED = 'venomx.time.enabled'
local KEY_OFFSET = 'venomx.time.offsetHours'
local KEY_BEAT = 'venomx.time.heartbeat'
local KEY_STATUS = 'venomx.time.status'
local KEY_APPLIED = 'venomx.time.applied'

local baseSunDirection = vec3(0, 1, 0)
local baseLightDirection = vec3(0, 1, 0)
local baseSunHeading = 0
local baseSunAngle = 0
local baseMoonDirection = vec3(0, 1, 0)
local baseMoonHeading = 0
local baseMoonAngle = 0
local getterDirection = vec3(0, 1, 0)
local getterHeading = 0
local getterAngle = 0
local overrideActive = false
local lastStatus = nil
local lastApplied = nil
local skyApiMissing = false
local suppressIntercept = false
local suppressGetterOffset = false

if __PURE__update_stellar_position == nil then
  ac.store(KEY_STATUS, 'hook-missing')
  ac.store(KEY_APPLIED, 'no')
  return
end

local originalUpdateStellarPosition = __PURE__update_stellar_position
local originalApplyWorld = __PURE__apply_world
local originalUpdateRender = __PURE__update_render
local originalAsyncUpdateWorld = __PURE__async_update_world
local originalAsyncUpdateRender = __PURE__async_update_render
local originalApplyExposure = __PURE__apply_Exposure
local originalApplyPP = __PURE__apply_PP
local originalUpdateTonemapping = __PURE__update_tonemapping
local originalSunHeadingGet = __PURE__sun_heading_get
local originalSunAngleGet = __PURE__sun_angle_get
local originalSunHeadingCorrectedGet = __PURE__sun_heading_get_corrected
local originalLightDirGet = __PURE__lightDir_get
local originalGetSunDirectionTo = ac.getSunDirectionTo
local originalGetMoonDirectionTo = ac.getMoonDirectionTo

local function clamp(value, minValue, maxValue)
  return math.max(minValue, math.min(maxValue, value))
end

local function readBool(value)
  if type(value) == 'boolean' then
    return value
  end
  if type(value) == 'number' then
    return value ~= 0
  end
  if type(value) == 'string' then
    local normalized = value:lower()
    return normalized == '1' or normalized == 'true' or normalized == 'yes' or normalized == 'on'
  end
  return false
end

local function normalize(direction)
  if direction == nil then
    return nil
  end
  local lengthSquared = direction.x * direction.x + direction.y * direction.y + direction.z * direction.z
  if lengthSquared < 1e-6 then
    return nil
  end
  local invLength = 1 / math.sqrt(lengthSquared)
  return vec3(direction.x * invLength, direction.y * invLength, direction.z * invLength)
end

local function dot(a, b)
  return a.x * b.x + a.y * b.y + a.z * b.z
end

local function cross(a, b)
  return vec3(
    a.y * b.z - a.z * b.y,
    a.z * b.x - a.x * b.z,
    a.x * b.y - a.y * b.x
  )
end

local function rotateAroundAxis(direction, axis, radians)
  local c = math.cos(radians)
  local s = math.sin(radians)
  local d = dot(axis, direction)
  return vec3(
    direction.x * c + (axis.y * direction.z - axis.z * direction.y) * s + axis.x * d * (1 - c),
    direction.y * c + (axis.z * direction.x - axis.x * direction.z) * s + axis.y * d * (1 - c),
    direction.z * c + (axis.x * direction.y - axis.y * direction.x) * s + axis.z * d * (1 - c)
  )
end

local function computeHeading(direction)
  local heading = math.deg(math.atan2(direction.z, direction.x))
  if heading < 0 then
    heading = heading + 360
  end
  return heading
end

local function computeElevation(direction)
  return math.deg(math.asin(clamp(direction.y, -1, 1)))
end

local function wrapTexOffset(value)
  if value > 1 or value < -1 then
    value = value - math.floor(value)
  end
  return value
end

local function writeStatus(status, applied)
  if status ~= lastStatus then
    ac.store(KEY_STATUS, status)
    lastStatus = status
  end
  local appliedStr = applied and 'yes' or 'no'
  if appliedStr ~= lastApplied then
    ac.store(KEY_APPLIED, appliedStr)
    lastApplied = appliedStr
  end
end

local function bridgeLive()
  if not readBool(ac.load(KEY_ENABLED)) then
    return false
  end
  local beat = tonumber(ac.load(KEY_BEAT))
  if beat == nil then
    return false
  end
  local frame = 0
  if sim ~= nil and type(sim.frame) == 'number' then
    frame = sim.frame
  end
  return frame - beat <= 180
end

local function offsetHoursValue()
  return tonumber(ac.load(KEY_OFFSET)) or 0
end

local function bridgeOffsetting()
  if not bridgeLive() then
    return false
  end
  return math.abs(offsetHoursValue()) >= 0.001
end

local function computeOffsetDirection(sourceDirection, skyFeature)
  if sim == nil or skyApiMissing then
    return nil
  end
  if ac.getSkyFeatureDirection == nil or ac.SkyFeature == nil then
    skyApiMissing = true
    return nil
  end
  local hours = offsetHoursValue()
  local feature = skyFeature or ac.SkyFeature.Sun
  local baseTimestamp = (sim.timestamp or 0) - (tonumber(sim.timePhotoModeOffset) or 0)
  local targetTimestamp = baseTimestamp + hours * 3600
  local okServer, serverResult = pcall(ac.getSkyFeatureDirection, feature, nil, baseTimestamp)
  if not okServer then
    skyApiMissing = true
    return nil
  end
  local okTarget, targetResult = pcall(ac.getSkyFeatureDirection, feature, nil, targetTimestamp)
  if not okTarget then
    skyApiMissing = true
    return nil
  end
  local serverDirection = normalize(serverResult)
  local targetDirection = normalize(targetResult)
  if serverDirection == nil or targetDirection == nil then
    return nil
  end
  local direction = normalize(sourceDirection or serverDirection)
  if direction == nil then
    direction = vec3(serverDirection.x, serverDirection.y, serverDirection.z)
  end
  local axis = cross(serverDirection, targetDirection)
  local axisLength = math.sqrt(axis.x * axis.x + axis.y * axis.y + axis.z * axis.z)
  if axisLength > 1e-6 then
    axis = vec3(axis.x / axisLength, axis.y / axisLength, axis.z / axisLength)
    local angle = math.acos(clamp(dot(serverDirection, targetDirection), -1, 1))
    direction = rotateAroundAxis(direction, axis, angle)
  end
  return normalize(direction)
end

local function captureBaseState()
  if __PURE__sunDir ~= nil and __PURE__sunDir.set ~= nil then
    baseSunDirection:set(__PURE__sunDir)
  end
  local lightDir = originalLightDirGet ~= nil and originalLightDirGet() or nil
  if lightDir ~= nil and lightDir.set ~= nil then
    baseLightDirection:set(lightDir)
  else
    baseLightDirection:set(baseSunDirection)
  end
  baseSunHeading = originalSunHeadingGet ~= nil and originalSunHeadingGet() or computeHeading(baseSunDirection)
  baseSunAngle = originalSunAngleGet ~= nil and originalSunAngleGet() or computeElevation(baseSunDirection)
  if __PURE__moonDir ~= nil and __PURE__moonDir.set ~= nil then
    baseMoonDirection:set(__PURE__moonDir)
  end
  baseMoonHeading = __PURE__moon_heading_get ~= nil and __PURE__moon_heading_get() or computeHeading(baseMoonDirection)
  baseMoonAngle = __PURE__moon_angle_get ~= nil and __PURE__moon_angle_get() or computeElevation(baseMoonDirection)
end

local function refreshGetterOffset()
  local direction = computeOffsetDirection()
  if direction == nil then
    getterDirection:set(baseSunDirection)
    getterHeading = baseSunHeading
    getterAngle = baseSunAngle
    return false
  end
  getterDirection:set(direction)
  getterHeading = computeHeading(direction)
  getterAngle = computeElevation(direction)
  return true
end

local function applyOffsetState(direction)
  if direction == nil then
    return false
  end
  local heading = computeHeading(direction)
  local elevation = computeElevation(direction)
  local lightDir = originalLightDirGet ~= nil and originalLightDirGet() or nil

  if __PURE__sunDir ~= nil and __PURE__sunDir.set ~= nil then
    __PURE__sunDir:set(direction)
  end
  if SunDir ~= nil and SunDir.set ~= nil then
    SunDir:set(direction)
  end
  if lightDir ~= nil and lightDir.set ~= nil then
    lightDir:set(direction)
  end
  if __PURE__sun_heading_set ~= nil then
    __PURE__sun_heading_set(heading)
  end
  if __PURE__sun_angle_set ~= nil then
    __PURE__sun_angle_set(elevation)
  end
  if __PURE__lightDir_set ~= nil then
    __PURE__lightDir_set(direction)
  end
  if ac.setLightDirection ~= nil then
    pcall(function()
      ac.setLightDirection(direction)
    end)
  end
  if ac.setCustomSunDirection ~= nil then
    pcall(function()
      ac.setCustomSunDirection(direction)
    end)
  end
  if ac.setSunAngle ~= nil then
    pcall(function()
      ac.setSunAngle(elevation)
    end)
  end
  if __PURE__STATE ~= nil and __PURE__STATE.setValue ~= nil then
    local stateHeading = correct_angle ~= nil and correct_angle(heading + 90) or (heading + 90)
    __PURE__STATE:setValue('stellar.sun.heading', stateHeading)
    __PURE__STATE:setValue('stellar.sun.angle', elevation)
  end
  return true
end

local function applyMoonOffsetState(direction)
  if direction == nil then
    return false
  end
  local heading = computeHeading(direction)
  local elevation = computeElevation(direction)

  if __PURE__moonDir ~= nil and __PURE__moonDir.set ~= nil then
    __PURE__moonDir:set(direction)
  end
  if MoonDir ~= nil and MoonDir.set ~= nil then
    MoonDir:set(direction)
  end
  if __PURE__moon_heading_set ~= nil then
    __PURE__moon_heading_set(heading)
  end
  if __PURE__moon_angle_set ~= nil then
    __PURE__moon_angle_set(elevation)
  end
  if ac.setCustomMoonDirection ~= nil then
    pcall(function()
      ac.setCustomMoonDirection(direction)
    end)
  end
  if __PURE__STATE ~= nil and __PURE__STATE.setValue ~= nil then
    local stateHeading = correct_angle ~= nil and correct_angle(heading + 90) or (heading + 90)
    __PURE__STATE:setValue('stellar.moon.heading', stateHeading)
    __PURE__STATE:setValue('stellar.moon.angle', elevation)
  end
  return true
end

local function restoreBaseState()
  local lightDir = originalLightDirGet ~= nil and originalLightDirGet() or nil

  if __PURE__sunDir ~= nil and __PURE__sunDir.set ~= nil then
    __PURE__sunDir:set(baseSunDirection)
  end
  if SunDir ~= nil and SunDir.set ~= nil then
    SunDir:set(baseSunDirection)
  end
  if lightDir ~= nil and lightDir.set ~= nil then
    lightDir:set(baseLightDirection)
  end
  if __PURE__sun_heading_set ~= nil then
    __PURE__sun_heading_set(baseSunHeading)
  end
  if __PURE__sun_angle_set ~= nil then
    __PURE__sun_angle_set(baseSunAngle)
  end
  if __PURE__lightDir_set ~= nil then
    __PURE__lightDir_set(baseLightDirection)
  end
  if ac.setLightDirection ~= nil then
    pcall(function()
      ac.setLightDirection(baseLightDirection)
    end)
  end
  if __PURE__STATE ~= nil and __PURE__STATE.setValue ~= nil then
    local stateHeading = correct_angle ~= nil and correct_angle(baseSunHeading + 90) or (baseSunHeading + 90)
    __PURE__STATE:setValue('stellar.sun.heading', stateHeading)
    __PURE__STATE:setValue('stellar.sun.angle', baseSunAngle)
  end
  if ac.setCustomSunDirection ~= nil then
    pcall(function()
      ac.setCustomSunDirection(baseSunDirection)
    end)
  end
  if ac.setSunAngle ~= nil then
    pcall(function()
      ac.setSunAngle(baseSunAngle)
    end)
  end
  if __PURE__moonDir ~= nil and __PURE__moonDir.set ~= nil then
    __PURE__moonDir:set(baseMoonDirection)
  end
  if MoonDir ~= nil and MoonDir.set ~= nil then
    MoonDir:set(baseMoonDirection)
  end
  if __PURE__moon_heading_set ~= nil then
    __PURE__moon_heading_set(baseMoonHeading)
  end
  if __PURE__moon_angle_set ~= nil then
    __PURE__moon_angle_set(baseMoonAngle)
  end
  if __PURE__STATE ~= nil and __PURE__STATE.setValue ~= nil then
    local moonStateHeading = correct_angle ~= nil and correct_angle(baseMoonHeading + 90) or (baseMoonHeading + 90)
    __PURE__STATE:setValue('stellar.moon.heading', moonStateHeading)
    __PURE__STATE:setValue('stellar.moon.angle', baseMoonAngle)
  end
  if ac.setCustomMoonDirection ~= nil then
    pcall(function()
      ac.setCustomMoonDirection(baseMoonDirection)
    end)
  end
end

local function applyFinalOffset()
  if not bridgeLive() then
    if overrideActive then
      restoreBaseState()
      overrideActive = false
    end
    writeStatus('offset-idle', false)
    return false
  end
  if math.abs(offsetHoursValue()) < 0.001 then
    if overrideActive then
      restoreBaseState()
      overrideActive = false
    end
    writeStatus('offset-idle', true)
    return true
  end
  local direction = computeOffsetDirection()
  if direction == nil then
    writeStatus('offset-error', false)
    return false
  end
  local ok = pcall(function()
    applyOffsetState(direction)
    if ac.SkyFeature ~= nil then
      applyMoonOffsetState(computeOffsetDirection(nil, ac.SkyFeature.Moon))
    end
  end)
  if not ok then
    writeStatus('offset-error', false)
    return false
  end
  overrideActive = true
  writeStatus('offset-applied', true)
  return true
end

local function installSunDirectionIntercept()
  if originalGetSunDirectionTo == nil then
    return
  end
  ac.getSunDirectionTo = function(out)
    originalGetSunDirectionTo(out)
    if suppressIntercept or not bridgeOffsetting() or out == nil then
      return
    end
    local direction = computeOffsetDirection(out)
    if direction == nil then
      return
    end
    if out.set ~= nil then
      out:set(direction)
    else
      out.x = direction.x
      out.y = direction.y
      out.z = direction.z
    end
    getterDirection:set(direction)
    getterHeading = computeHeading(direction)
    getterAngle = computeElevation(direction)
  end
end

local function installMoonDirectionIntercept()
  if originalGetMoonDirectionTo == nil then
    return
  end
  ac.getMoonDirectionTo = function(out)
    originalGetMoonDirectionTo(out)
    if suppressIntercept or not bridgeOffsetting() or out == nil then
      return
    end
    local direction = computeOffsetDirection(out, ac.SkyFeature ~= nil and ac.SkyFeature.Moon or nil)
    if direction == nil then
      return
    end
    if out.set ~= nil then
      out:set(direction)
    else
      out.x = direction.x
      out.y = direction.y
      out.z = direction.z
    end
  end
end

local function installSkydomeDiskHook()
  if PURE_CLASS_2dClouds_section == nil or PURE_CLASS_2dClouds_section.updateCover == nil then
    return
  end
  if ac.TextureState == nil then
    return
  end
  local originalUpdateCover = PURE_CLASS_2dClouds_section.updateCover
  PURE_CLASS_2dClouds_section.updateCover = function(self, dt, set, cover)
    originalUpdateCover(self, dt, set, cover)

    if not bridgeOffsetting() or cover == nil or cover.getTextureState == nil then
      return
    end
    if cover:getTextureState() == ac.TextureState.Empty then
      return
    end

    local sunPos = self.sun_position or (self.texture ~= nil and self.texture.sun_position or nil)
    if sunPos == nil then
      return
    end

    local useMoon = self.sunangle ~= nil and self.sunangle <= -5 and self.sunangle >= -90
    local feature = useMoon and ac.SkyFeature.Moon or ac.SkyFeature.Sun
    local targetDirection = computeOffsetDirection(nil, feature)
    if targetDirection == nil then
      return
    end

    local targetHeading = computeHeading(targetDirection)
    local rotation = 0
    if set ~= nil and set.allowRotationOscillation and self.sunangle ~= nil and (self.sunangle < 900 or self.sunangle > 7) and PURE_CLASS_2dClouds_set__getOsciWindShift ~= nil then
      rotation = 0.05 * math.sin(PURE_CLASS_2dClouds_set__getOsciWindShift())
    end

    cover.texOffsetX = wrapTexOffset(-0.25 - 0.00277778 * (targetHeading - sunPos * 360) + rotation)
  end
end

installSunDirectionIntercept()
installMoonDirectionIntercept()
installSkydomeDiskHook()

if originalSunHeadingGet ~= nil then
  __PURE__sun_heading_get = function()
    if not suppressGetterOffset and bridgeOffsetting() then
      return getterHeading
    end
    return originalSunHeadingGet()
  end
end

if originalSunAngleGet ~= nil then
  __PURE__sun_angle_get = function()
    if not suppressGetterOffset and bridgeOffsetting() then
      return getterAngle
    end
    return originalSunAngleGet()
  end
end

if originalSunHeadingCorrectedGet ~= nil then
  __PURE__sun_heading_get_corrected = function(x)
    if not suppressGetterOffset and bridgeOffsetting() then
      local heading = getterHeading - (__PURE__track_heading_angle or 0) + (x or 0)
      if correct_angle ~= nil then
        return correct_angle(heading)
      end
      return heading
    end
    return originalSunHeadingCorrectedGet(x)
  end
end

if originalLightDirGet ~= nil then
  __PURE__lightDir_get = function()
    if not suppressGetterOffset and bridgeOffsetting() then
      return getterDirection
    end
    return originalLightDirGet()
  end
end

__PURE__update_stellar_position = function(...)
  if overrideActive then
    restoreBaseState()
    overrideActive = false
  end
  suppressIntercept = true
  suppressGetterOffset = true
  local results = {pcall(originalUpdateStellarPosition, ...)}
  suppressGetterOffset = false
  suppressIntercept = false
  if not results[1] then
    error(results[2], 0)
  end
  captureBaseState()
  if bridgeOffsetting() then
    refreshGetterOffset()
  else
    getterDirection:set(baseSunDirection)
    getterHeading = baseSunHeading
    getterAngle = baseSunAngle
  end
  return table.unpack(results, 2)
end

if originalApplyWorld ~= nil then
  __PURE__apply_world = function(...)
    local result = originalApplyWorld(...)
    pcall(applyFinalOffset)
    return result
  end
end

if originalUpdateRender ~= nil then
  __PURE__update_render = function(...)
    local result = originalUpdateRender(...)
    pcall(applyFinalOffset)
    return result
  end
end

if originalAsyncUpdateWorld ~= nil then
  __PURE__async_update_world = function(...)
    local result = originalAsyncUpdateWorld(...)
    pcall(applyFinalOffset)
    return result
  end
end

if originalAsyncUpdateRender ~= nil then
  __PURE__async_update_render = function(...)
    local result = originalAsyncUpdateRender(...)
    pcall(applyFinalOffset)
    return result
  end
end

if originalApplyExposure ~= nil then
  __PURE__apply_Exposure = function(...)
    local result = originalApplyExposure(...)
    pcall(applyFinalOffset)
    return result
  end
end

if originalApplyPP ~= nil then
  __PURE__apply_PP = function(...)
    local result = originalApplyPP(...)
    pcall(applyFinalOffset)
    return result
  end
end

if originalUpdateTonemapping ~= nil then
  __PURE__update_tonemapping = function(...)
    local result = originalUpdateTonemapping(...)
    pcall(applyFinalOffset)
    return result
  end
end

__PURE__update__test_ground = function()
  pcall(applyFinalOffset)
end

writeStatus('offset-ready', false)
