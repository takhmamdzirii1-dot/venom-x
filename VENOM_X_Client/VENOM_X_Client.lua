script = script or {}

local LAY = {
  beat = ac.StructItem.int32(),
  cmdSeq = ac.StructItem.int32(),
  cmdOffset = ac.StructItem.float(),
  cmdInstant = ac.StructItem.int32(),
  ackSeq = ac.StructItem.int32(),
  ackResult = ac.StructItem.int32(),
  ackAt = ac.StructItem.int32(),
  ackErr = ac.StructItem.string(96),
}

local connOk, sh = pcall(ac.connect, LAY, true, ac.SharedNamespace.Shared)
local lastCmd = -1
local calls = 0
local lastResult = 'none'
local lastErr = ''

function script.update(dt)
  if not connOk or not sh then return end
  local s = ac.getSim()
  if s then sh.beat = s.frame end
  if sh.cmdSeq ~= lastCmd then
    lastCmd = sh.cmdSeq
    if sh.cmdSeq > 0 and sh.ackSeq ~= sh.cmdSeq then
      calls = calls + 1
      local ok, err = pcall(ac.setWeatherTimeOffset, sh.cmdOffset, sh.cmdInstant == 1)
      sh.ackSeq = sh.cmdSeq
      sh.ackResult = ok and 1 or 2
      sh.ackErr = ok and '' or string.sub(tostring(err), 1, 90)
      if s then sh.ackAt = s.frame end
      lastResult = ok and 'ok' or 'error'
      if not ok then lastErr = string.sub(tostring(err), 1, 80) end
    end
  end
end

function windowMain()
  ui.text('VENOM X Client')
  ui.text('Bridge: ' .. (connOk and 'connected' or 'failed'))
  ui.text('Calls: ' .. tostring(calls) .. '   Last: ' .. lastResult)
  if lastErr ~= '' then
    ui.textWrapped(lastErr)
  end
  ui.textDisabled('Uses ac.setWeatherTimeOffset')
end
