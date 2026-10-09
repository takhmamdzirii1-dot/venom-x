// Executes the real VENOM X TIME bridge against simulated CSP/AssettoServer.
// Verifies one-click presets, frozen payloads, server 1s throttle, slider
// coalescing, late ACKs and retry after rate-limit losses.
const fs=require('node:fs');
const {lua,lauxlib,lualib,to_luastring,to_jsstring}=require('fengari');
const source=fs.readFileSync('VENOM_X.lua','utf8');
function cut(a,b) {
  const i=source.indexOf(a),j=source.indexOf(b,i+a.length);
  if(i<0||j<=i||source.indexOf(a,i+1)>=0)throw Error('TIME block missing: '+a);
  return source.slice(i,j);
}
const chunk=cut('local function serverSec()', 'local function setPanelSize(idx)');
const prefix=cut('local function timeControlUpdate(dt)', '  tm.curOffset=anim(')+'end\n';
const checks=[
 'queueServerSky(true,preset.sec)',
 'queueServerSky(true,nv,true)',
 'queueServerSky(true,selected,true)',
 'queueServerSky(true,shownTimeSeconds()+minutes*60)',
 'local value=tostring(tm.serverSkyTargetSeconds or 0)'
];
for(const q of checks)if(!source.includes(q))throw Error('Missing one-click direct TIME UI control: '+q);
const tests=`
local simSeconds=40000
sim=function() return {timeTotalSeconds=simSeconds} end
wrapDay=function(n) return n%86400 end
wrapOffset=function(n)
 while n>43200 do n=n-86400 end
 while n<=-43200 do n=n+86400 end
 return n
end
fmtSec=function(n)return tostring(math.floor(n))end
local changes=0
persist=function() changes=changes+1 end
state={clock=10,time={
 want=0,curOffset=0,serverSkyEnabled=false,
 serverSkyPending=false,serverSkyLastAt=-999,
 serverSkyStatus='READY',serverSkyAwaiting=false,
 serverSkyExpectedSeconds=nil,serverSkyEvent=nil,
 serverSkyEventChecked=false,serverSkyTargetSeconds=nil,
 serverSkyTargetAt=0,serverSkyRetryCount=0,
 serverSkyPendingAt=0,serverSkyNextSendAt=0
}}
local sent={}
local ackHandler=nil
ac={StructItem={
 key=function(v)return v end,
 string=function(v)return v end
}}
ac.OnlineEvent=function(_,callback)
 ackHandler=callback
 return function(msg)
   sent[#sent+1]={mode=msg.mode,seconds=msg.seconds,time=state.clock}
   return true
 end
end
setTimePreset({sec=0},1)
simSeconds=60123  -- CSP clock jumps while queued
flushServerSky()
assert(#sent==1 and sent[1].seconds=='0',
  'first NIGHT click must send 0 despite CSP clock change')
assert(state.time.serverSkyTargetSeconds==0)
assert(state.time.serverSkyAwaiting and not state.time.serverSkyPending)
print('PASS: first click NIGHT 00:00 sends exact time with changing CSP clock')

ackHandler(nil,{mode='ack',seconds='0'})
assert(not state.time.serverSkyAwaiting and
  string.find(state.time.serverSkyStatus,'SERVER ACK',1,true))
print('PASS: server ACK corresponds to the first button press')

state.clock=10.1
simSeconds=0
setTimePreset({sec=43200},2)
flushServerSky()
assert(#sent==1,'AssettoServer rejects chat within one second')
state.clock=11.5
flushServerSky()
assert(#sent==2 and sent[2].seconds=='43200',
  'second preset should send one exact 12:00 packet automatically')
print('PASS: rapid button changes are queued, never lost to 1s CHAT throttle')

state.clock=11.6
queueServerSky(true,27000,true)
state.clock=11.7
queueServerSky(true,32500,true)
state.clock=12.4
flushServerSky()
assert(#sent==2,'slider must not send before 1.35s')
state.clock=12.9
flushServerSky()
assert(#sent==3 and sent[3].seconds=='32500',
  'slider must coalesce to the latest absolute target')
print('PASS: slider uses final setting, throttled and debounced')

-- When the server ignores a packet after a chat heartbeat, retry the
-- same absolute time without asking user to click again.
state.clock=15.1
setTimePreset({sec=67200},3)
flushServerSky()
assert(#sent==4 and sent[4].seconds=='67200')
state.clock=17.3
timeControlUpdate(0.016)
assert(#sent==5 and sent[5].seconds=='67200' and
  state.time.serverSkyRetryCount==1)
print('PASS: lost TIME packet retries by itself with SAME target time')

-- Another click before a late ACK: previous ACK must be ignored.
state.clock=18.7
setTimePreset({sec=26100},4)
flushServerSky()
assert(sent[#sent].seconds=='26100')
ackHandler(nil,{mode='ack',seconds='67200'})
assert(state.time.serverSkyAwaiting,
  'stale ACK should not clear current request')
ackHandler(nil,{mode='ack',seconds='26100'})
assert(not state.time.serverSkyAwaiting)
print('PASS: late ACK never overwrites newer preset')

-- No more than three retries; prove bounded behavior.
state.clock=21
setTimePreset({sec=50000},5)
flushServerSky()
local first=#sent
for i=1,3 do
 state.clock=state.clock+2.2
 timeControlUpdate(0.016)
end
assert(#sent==first+3)
state.clock=state.clock+2.2
timeControlUpdate(0.016)
assert(#sent==first+3 and
  state.time.serverSkyStatus=='NO SERVER ACK / CHECK PLUGIN DLL AND LOGS')
print('PASS: retries stop after 3 attempts with truthful error')

print('ALL VENOM ONE-CLICK TIME REGRESSIONS PASSED')
`;
const L=lauxlib.luaL_newstate();lualib.luaL_openlibs(L);
let status=lauxlib.luaL_loadstring(L,to_luastring(chunk+'\n'+prefix+'\n'+tests));
if(status!==lua.LUA_OK)throw Error('Lua parse: '+to_jsstring(lua.lua_tostring(L,-1)));
status=lua.lua_pcall(L,0,lua.LUA_MULTRET,0);
if(status!==lua.LUA_OK)throw Error('TIME behavior: '+to_jsstring(lua.lua_tostring(L,-1)));
console.log('Ran actual TIME bridge code with mocked CSP transport.');
