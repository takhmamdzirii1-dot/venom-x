// Executes the actual VENOM X Lua car-options functions in a small Lua VM.
// Do not copy/paste their implementation into tests: extract it from VENOM_X.lua
// so regressions in the production source are caught automatically.
const fs = require('node:fs');
const {lua, lauxlib, lualib, to_luastring, to_jsstring} = require('fengari');
const source = fs.readFileSync('VENOM_X.lua', 'utf8');
const slice = (start, next) => {
  const from = source.indexOf(start);
  const to = source.indexOf(next, from + start.length);
  if (from === -1 || to === -1 || source.indexOf(start, from + 1) !== -1) {
    throw new Error('Cannot unambiguously extract source helper: ' + start);
  }
  return source.slice(from, to).trim();
};
const chunks = [
  slice('local function preserveFlag(v)', '\nlocal EXTRA_KEYS='),
  slice('local EXTRA_KEYS=', '\nlocal function snapshotCarOptions('),
  slice('local function encodeExtraSnapshot(snap)', '\nlocal function decodeExtraSnapshot('),
  slice('local function decodeExtraSnapshot(bits)', '\nlocal function persistExtraSnapshot('),
  slice('local function mergeLiveOptionSnapshot(old,live)', '\nlocal function optionSwitchDelta('),
  slice('local function optionSwitchDelta(old,live)', '\nbeginOptionsRestoration='),
  slice('beginOptionsRestoration=function(snapshot', '\nlocal function restoreCarOptions('),
  slice('local function restoreTeleportOptions()', '\n-- Track switches continuously')
];
const tests = `
assert(preserveFlag(true)==true,'ON not retained')
assert(preserveFlag(false)==false,'OFF not retained')
assert(preserveFlag(0)==false and preserveFlag(1)==true,'0/1 not normalized')
assert(preserveFlag(nil)==nil and preserveFlag('false')==nil,'invalid flag not ignored')
print('PASS: booleans ON/OFF and numeric 0/1')

local original={extra={true,false,true,false,true,false,true,false,true,false},
  headlights=false,highBeams=true,lowBeams=false,
  hazards=false,turnLeft=false,turnRight=false}
local encoded=encodeExtraSnapshot(original)
assert(#encoded==16,'16 states must be persisted')
local decoded=decodeExtraSnapshot(encoded)
for i=1,10 do
  assert(decoded.extra[i]==original.extra[i], 'EXTRA '..i..' lost on save/reload')
end
assert(decoded.headlights==false and decoded.highBeams==true and
  decoded.hazards==false and decoded.turnRight==false,'light or turn flag lost')
assert(decodeExtraSnapshot('invalid')==nil,'corrupt states should be discarded')
print('PASS: all 10 extras and lights survive cache roundtrip')

local old={extra={true,false,true,false,true,false,true,false,true,false},headlights=false}
local latest={extra={false,true},headlights=true}
mergeLiveOptionSnapshot(old,latest)
assert(old.extra[1]==false and old.extra[2]==true and
  old.extra[3]==true and old.headlights==true,
  'fresh OFF/ON preferences were not merged')
print('PASS: latest live driver changes override stale cache')

state={clock=10,sessionCarKey='car0',sessionOptions=old,sessionPinned=false}
car=function() return {id='car0'} end
stateVal=function(obj,key) return obj and obj[key] end
local saves=0
persistExtraSnapshot=function() saves=saves+1 end
snapshotCarOptions=function()
  return {extra={true,false,true,false,true,false,true,false,true,false},headlights=false}
end
local before={extra={false,false,true,false,true,false,true,false,true,false},headlights=false}
assert(beginOptionsRestoration(before,true)==true,'pre-teleport snapshot failed')
assert(state.sessionOptions.extra[1]==false and state.sessionOptions.extra[2]==false
  and state.sessionOptions.headlights==false,'stale pre-teleport cache used')
assert(state.optionsRestore.minHoldUntil==15 and state.optionsRestore.deadline==21)
assert(saves>=1,'TP snapshot not saved')
print('PASS: pre-teleport state captured, with five-second minimum hold')

local desired=state.sessionOptions
local reset={extra={false,false,false,false,false,false,false,false,false,false}}
assert(beginOptionsRestoration(reset,true))
assert(state.sessionOptions==desired and state.sessionOptions.extra[3]==true,
  'active guard learned a late car reset')
print('PASS: delayed reset cannot overwrite driver preferences')

state.clock=30
state.optionsRestore={snapshot=desired,started=30,minHoldUntil=35,
  deadline=41,nextAt=30,pass=0,cleanChecks=0,totalAttempts=0,denied=0,unavailable=0}
restoreCarOptions=function() return {readable=10,extraReadable=10,
  extraMissing=0,missing=0,attempted=0,denied=0,unavailable=0} end
for t=30,31,0.2 do state.clock=t restoreTeleportOptions() end
assert(state.optionsRestore~=nil,'guard stopped prematurely after clean checks')
state.clock=35.3
restoreTeleportOptions()
assert(state.optionsRestore==nil,'guard not released after safe minimum hold')
assert(state.sessionLearnAfter>35.3,'tracking resumed without cooldown')
print('PASS: guard survives early clean frames and releases after the reset window')
print('ALL VENOM CAR OPTIONS REGRESSIONS PASSED')
`;
const L = lauxlib.luaL_newstate();
lualib.luaL_openlibs(L);
let status = lauxlib.luaL_loadstring(L,to_luastring(chunks.join('\n\n')+'\n'+tests));
if (status !== lua.LUA_OK) throw new Error('Lua compile error: '+to_jsstring(lua.lua_tostring(L,-1)));
status = lua.lua_pcall(L,0,lua.LUA_MULTRET,0);
if (status !== lua.LUA_OK) throw new Error('Car options regression: '+to_jsstring(lua.lua_tostring(L,-1)));
console.log('Verified live Lua source helpers with Fengari.');
