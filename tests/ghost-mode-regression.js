// Run the REAL VENOM X ghost-mode helpers in a Lua VM with simulated cars.
// Ensures OFF/ON is symmetrical, AI traffic is untouched and peer sync works.
const fs = require('node:fs');
const {lua, lauxlib, lualib, to_luastring, to_jsstring} = require('fengari');
const source=fs.readFileSync('VENOM_X.lua','utf8');
function extract(start,end) {
  const a=source.indexOf(start),b=source.indexOf(end,a+start.length);
  if(a<0||b<0||source.indexOf(start,a+1)>=0)throw Error('Ghost helper not found exactly once: '+start);
  return source.slice(a,b);
}
const helper=extract('local function ghostUsable()', 'local function refreshDestinations(force)');
const tests=`
state={
  clock=0,ghost={enabled=false,peers={},applied={},event=nil,checked=false,
   supported=false,nextSync=0,nextScan=0,lastStatus='OFF'}
}
HUMAN_SESSION_IDS={[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true}
stateVal=function(c,k) return c and c[k] end
isHumanCar=function(c,n,m,sid)
  return not c.isAIControlled and HUMAN_SESSION_IDS[sid] and
    not string.find(string.lower(m or ''),'traffic',1,true)
end
local myCar={index=0,sessionID=4,isConnected=true,isActive=true,id='player',driverName='ME'}
local alice={index=1,sessionID=1,isConnected=true,isActive=true,id='car',driverName='ALICE'}
local bob={index=2,sessionID=2,isConnected=true,isActive=true,id='car',driverName='BOB'}
local traffic={index=12,sessionID=12,isConnected=true,isActive=true,
  isAIControlled=true,id='traffic_van',driverName='TRAFFIC 1'}
local cars={myCar,alice,bob,traffic}
ac={
 getPatchVersionCode=function() return 4157 end,
 StructItem={key=function(v)return v end,boolean=function()return true end},
 iterateCars=function()
   local index=0
   return function()
     index=index+1
     if cars[index] then return index,cars[index] end
   end
 end,
}
local receiver=nil
local broadcasts={}
ac.OnlineEvent=function(_,callback)
  receiver=callback
  return function(msg) broadcasts[#broadcasts+1]=msg.enabled end
end
physics={}
local actions={}
physics.disableCarCollisions=function(index,disabled)
  actions[#actions+1]={index=index,disabled=disabled}
end
local saves=0
persist=function() saves=saves+1 end
toast=function() end
initGhostEvent()
assert(state.ghost.supported and receiver,'CSP ghost event did not initialize')
ghostUpdate()
assert(#actions==0,'ghost OFF must not change any colliders')
assert(broadcasts[1]==false,'initial ghost state not broadcast OFF')
print('PASS: init is OFF, sends sync but does not touch collisions')

assert(toggleGhostMode()==true)
assert(state.ghost.enabled and saves==1,'ghost ON not persisted')
assert(#actions==2,'must disable only two human remote vehicles')
assert(actions[1].index==1 and actions[1].disabled==true)
assert(actions[2].index==2 and actions[2].disabled==true)
assert(broadcasts[#broadcasts]==true)
print('PASS: ghost ON disables only remote humans and broadcasts state')

receiver(alice,{enabled=true})
assert(toggleGhostMode()==true)
assert(not state.ghost.enabled,'ghost OFF not saved')
assert(actions[#actions].index==2 and actions[#actions].disabled==false,
  'when own ghost turns OFF, a normal player must regain collisions')
assert(state.ghost.applied[1].disabled==true,
  'other opt-in ghost must stay collision-free after own toggle OFF')
print('PASS: ghost OFF restores normal collisions without disabling peer ghost')

receiver(alice,{enabled=false})
ghostUpdate()
state.clock=state.clock+1
ghostUpdate()
assert(state.ghost.applied[1].disabled==false,'peer ghost OFF must restore collision')
print('PASS: receiving peer OFF restores collision')

toggleGhostMode()
local charlie={index=3,sessionID=3,isConnected=true,isActive=true,
  id='car',driverName='CHARLIE'}
cars[#cars+1]=charlie
state.clock=state.clock+1
ghostUpdate()
assert(state.ghost.applied[3] and state.ghost.applied[3].disabled,
  'late joiner should get ghost collision settings on local client')
state.clock=state.clock+6
ghostUpdate()
assert(broadcasts[#broadcasts]==true,'heartbeat must advertise mode to late joiners')
print('PASS: late joiner receives local collision disable and heartbeat')

-- ON or OFF must never modify the human player's local car or AI traffic.
for _,action in ipairs(actions) do
  assert(action.index~=0 and action.index~=12,
    'ghost must never disable self or AI traffic')
end
print('PASS: local car and AI traffic untouched')

-- Remote clients with older CSP cannot claim working ghost protection.
local old=ac.getPatchVersionCode
ac.getPatchVersionCode=function() return 3400 end
assert(ghostUsable()==false,'old CSP should be marked unsupported')
ac.getPatchVersionCode=old
print('PASS: requires CSP with remote collision targeting')

print('ALL VENOM GHOST MODE REGRESSIONS PASSED')
`;
const L=lauxlib.luaL_newstate();
lualib.luaL_openlibs(L);
const code=helper+'\n'+tests;
let status=lauxlib.luaL_loadstring(L,to_luastring(code));
if(status!==lua.LUA_OK)throw Error('Ghost syntax: '+to_jsstring(lua.lua_tostring(L,-1)));
status=lua.lua_pcall(L,0,lua.LUA_MULTRET,0);
if(status!==lua.LUA_OK)throw Error('Ghost regression: '+to_jsstring(lua.lua_tostring(L,-1)));
console.log('Executed production ghost-mode code inside Fengari successfully.');
