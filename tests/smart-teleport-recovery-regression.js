// Execute production smart teleport shield + recovery Lua code with fake cars.
const fs=require('node:fs');
const {lua,lauxlib,lualib,to_luastring,to_jsstring}=require('fengari');
const source=fs.readFileSync('VENOM_X.lua','utf8');
const start='-- SMART TP SHIELD: temporarily turn off collisions';
const end='local function refreshDestinations(force)';
const a=source.indexOf(start),b=source.indexOf(end,a+start.length);
if(a<0||b<a||source.indexOf(start,a+1)!==-1)throw Error('Cannot find smart TP helpers');
const body=source.slice(a,b);
const tests=`
state={
 clock=0,pendingTeleport=nil,optionsRestore=nil,ghost={enabled=true},
 tpShield={active=false,untilAt=0,minUntil=0,status='READY',nextCheck=0,started=0},
 recovery={spot=nil,carKey=nil,stable=0,nextAt=0,captureAfter=5,
   lastCaptureAt=-999,cooldownUntil=0,confirmUntil=0,status='SEARCHING'}
}
local own={index=0,id='CAR',position={x=10,y=2,z=10},
  look={x=1,z=0},up={y=1},speedKmh=20,isActive=true,isConnected=true,
  wheelsOnGround=4}
local traffic={index=12,id='traffic',position={x=90,y=2,z=90},
  isConnected=true,isActive=true}
local remote={index=1,id='OTHER',position={x=90,y=2,z=90},
  isConnected=true,isActive=true}
local vehicles={own,traffic,remote}
car=function() return own end
stateVal=function(obj,key)return obj and obj[key] end
vec3=function(x,y,z)return {x=x,y=y,z=z} end
local calls={}
physics={
 disableCarCollisions=function(index,value)
   calls[#calls+1]={index=index,on=value} return true
 end,
 setCarVelocity=function() return true end,
 awakeCar=function()return true end
}
ac={iterateCars=function()
 local i=0
 return function() i=i+1 if vehicles[i] then return i,vehicles[i] end end
end}
local messages={}
toast=function(msg)messages[#messages+1]=msg end
local movements=0
teleportSelf=function(pos,dir,msg)
 movements=movements+1
 assert(pos and dir and dir.z and msg)
 startTeleportShield()
 return true
end
local pits=0
returnToPits=function() pits=pits+1 return true end
assert(startTeleportShield())
assert(state.tpShield.active and state.tpShield.minUntil==3)
assert(#calls==1 and calls[1].index==0 and calls[1].on==true)
assert(state.ghost.enabled==true,'temporary shield must preserve manual ghost')
state.clock=2.9
updateTeleportShield()
assert(state.tpShield.active,'released before grace period')
state.clock=4
updateTeleportShield()
assert(not state.tpShield.active and calls[#calls].index==0 and
  calls[#calls].on==false,'local physics should be restored')
print('PASS: teleport shield ON for minimum 3s and restores normal physics')

state.clock=20
traffic.position.x=11;traffic.position.z=11
startTeleportShield()
state.clock=26
updateTeleportShield()
assert(state.tpShield.active,'shield ended in overlapping traffic before limit')
state.clock=34.4
updateTeleportShield()
assert(not state.tpShield.active,'shield failed to end at bounded max')
assert(calls[#calls].index==0 and calls[#calls].on==false)
print('PASS: nearby traffic delays protection release, max 14s')

traffic.position.x=90;traffic.position.z=90
state.clock=40
state.recovery.carKey=nil
state.recovery.spot=nil
state.recovery.captureAfter=40
state.recovery.nextAt=40
for _,t in ipairs({40,41.1,42.2}) do
 state.clock=t
 sampleRecoverySpot()
end
assert(state.recovery.spot and state.recovery.spot.x==10,
  'stable checkpoint never captured')
assert(state.recovery.spot.dirX==-1,'car heading must be inverted for teleport')
print('PASS: stable, upright 20km/h car saves last good checkpoint')

local saved=state.recovery.spot
own.speedKmh=80
state.clock=44
sampleRecoverySpot()
assert(state.recovery.spot==saved,'speeding should not overwrite checkpoint')
own.speedKmh=0
own.up.y=0
state.clock=45
sampleRecoverySpot()
assert(state.recovery.spot==saved,'flipped car should not overwrite checkpoint')
own.up.y=1
traffic.position.x=10
traffic.position.z=10
state.clock=46
sampleRecoverySpot()
assert(state.recovery.spot==saved,'crowded car must not overwrite checkpoint')
print('PASS: unsafe, inverted or fast positions cannot poison recovery cache')

traffic.position.x=90;traffic.position.z=90
own.position={x=55,y=8,z=55}
state.clock=60
assert(tryRecoverCar())
assert(movements==1 and state.tpShield.active)
assert(state.recovery.cooldownUntil==72)
assert(not tryRecoverCar(),'cooldown needs to prevent repeated recovery')
assert(state.recovery.spot==saved)
print('PASS: UNSTUCK returns to saved checkpoint, enables shield and cooldown')

state.clock=90
state.recovery.spot=nil
state.recovery.cooldownUntil=0
assert(not tryRecoverCar(),'first no-checkpoint click must only ask for confirmation')
assert(pits==0,'unconfirmed return to pits must never happen')
state.clock=91
assert(tryRecoverCar())
assert(pits==1,'second click must initiate pit fallback')
print('PASS: missing checkpoint asks for confirmation before pits fallback')

state.clock=120
state.recovery.spot=saved
state.recovery.cooldownUntil=0
own.speedKmh=80
assert(not tryRecoverCar(),'unsafe high-speed recovery must request confirmation')
assert(movements==1)
state.clock=121
assert(tryRecoverCar())
assert(movements==2,'confirmed high-speed recovery failed')
print('PASS: fast driving requires deliberate two-click recovery')

assert(state.ghost.enabled and
  not (function()
    for _,a in ipairs(calls) do if a.index~=0 then return true end end
    return false
  end)(),'temporary shield must never toggle ghost peer indices')
print('PASS: manual ghost mode and player peer collision toggles unaffected')
print('ALL VENOM SMART TP/RECOVERY REGRESSIONS PASSED')
`;
const L=lauxlib.luaL_newstate();lualib.luaL_openlibs(L);
let status=lauxlib.luaL_loadstring(L,to_luastring(body+'\n'+tests));
if(status!==lua.LUA_OK)throw Error('Lua parse: '+to_jsstring(lua.lua_tostring(L,-1)));
status=lua.lua_pcall(L,0,lua.LUA_MULTRET,0);
if(status!==lua.LUA_OK)throw Error('Behavior: '+to_jsstring(lua.lua_tostring(L,-1)));
console.log('Production source smart teleport/recovery helpers executed.');
