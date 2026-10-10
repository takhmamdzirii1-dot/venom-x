'use strict';
const fs = require('node:fs');
const assert = require('node:assert/strict');

const source = fs.readFileSync('VENOM_X.lua','utf8');
const mustInclude=[
  "local VERSION = '3.25.4'",
  "return ui.DWriteFont('Segoe UI'):weight(700)",
  "navHome = 'HOME'",
  "navTp = 'TELEPORT'",
  "navPlayers = 'PLAYERS'",
  "navColor = 'COLOR'",
  "navTime = 'TIME'",
  "navHud = 'HUD'",
  "hudSettings = 'HUD SETTINGS'",
  "GHOST ON | تم تأكيد التفعيل",
  "GHOST OFF | تم تأكيد الإيقاف",
  "TIME | استلم السيرفر الطلب",
  "لا توجد نقطة آمنة",
  "خيارات السيارة | حفظ تلقائي نشط",
  "local function actionButton(label, size, explanation)",
  "ui.setTooltip(explanation)",
  "ui.pushFont(ui.Font.Title)",
  "ui.textWrapped(tostring(message))",
  "local QUICK_ACTIONS = {",
  "label='MAP'",
  "label='CREW'",
  "label='GHOST'",
  "hint='ألغِ التصادم",
  "local function drawVenomOfficialLogo()",
  "ui.drawImage(VENOM_LOGO_URL",
  "ac.StructItem.key('VENOMX_Ghost_v1')",
  "ac.StructItem.key('VENOMX_SetTime')",
  "physics.disableCarCollisions",
  "vx_logo_fire = true",
  "stored.vx_logo_fire = state.logoFire",
  "local VENOM_FIRE_ANIM_URL",
  "assets/venom_flames_loop_v3.webp",
  "assets/venom_flames_rgba_v3.png",
  "local idx=math.floor(state.clock*10)%12",
  "ui.drawImage(FIRE_ANIM_PLAYER",
  "ui.drawImage(VENOM_FIRE_RGBA_URL",
  "state.logoFireStatus='ANIMATED WEBP'",
  "state.logoFireStatus='RGBA FALLBACK / LOADING WEBP'",
  "VENOM X FIRE:",
  "LOGO FIRE FX"
];
for (const marker of mustInclude) {
  assert.ok(source.includes(marker), `Required marker missing: ${marker}`);
}
const lMatch=source.match(/local L = \{([\s\S]*?)\n\}/);
assert.ok(lMatch,'UI strings table missing');
const l=lMatch[1];
const entries=[...l.matchAll(/^\s*([a-zA-Z]\w*)\s*=\s*'([^']*)'/gm)];
const names=entries.map(m=>m[1]);
assert.deepEqual(names.filter((k,i)=>names.indexOf(k)!==i),[],
  'Duplicate UI strings');
const values=Object.fromEntries(entries.map(m=>[m[1],m[2]]));
const menuKeys=['navHome','navTp','navPlayers','navColor','navTime','navHud',
  'hudSettings','colorApply','colorReset','presetSunrise','presetDay',
  'presetSunset','presetBlueHour','presetNight','resetPositions'];
for(const key of menuKeys) {
  assert.match(values[key], /^[A-Z0-9+\-/ :]+$/, `${key} must be in English`);
}
assert.equal(values.presetBlue,'BLUE');
assert.equal(values.presetBlueHour,'BLUE HOUR 18:40');
assert.ok(source.includes('{ label = L.presetBlueHour, sec = 18 * 3600 + 40 * 60 }'),
  'Blue-hour preset must not use blue paint label');
assert.ok(source.includes("local quickTimeLabels={'RISE 07:15'"),
  'Compact quick time labels missing');
assert.ok(source.includes("local ww=(w-68)/3"), 'Quick paint buttons are too narrow');
assert.ok(source.includes('local fontSize=18'), 'Larger toast font regression');
// Real RGBA + WebP assets must exist, and WebP must carry animation frames.
const png=fs.readFileSync('assets/venom_flames_rgba_v3.png');
const webp=fs.readFileSync('assets/venom_flames_loop_v3.webp');
assert.equal(png.subarray(1,4).toString('utf8'),'PNG');
assert.equal(png[25],6,'PNG must be true RGBA, not indexed palette');
assert.equal(webp.subarray(0,4).toString('utf8'),'RIFF');
assert.equal(webp.subarray(8,12).toString('utf8'),'WEBP');
assert.ok(webp.includes(Buffer.from('ANIM')),'WebP must be animated');
const fireStart=source.indexOf('local VENOM_FIRE_ANIM_URL');
const fireEnd=source.indexOf('function script.drawUI()',fireStart);
assert.ok(fireStart>0&&fireEnd>fireStart,'Fire renderer missing');
const fire=source.slice(fireStart,fireEnd);
assert.ok(!['ac.OnlineEvent','fetch(','physics.','drawLogoFire','drawLogoEmbers']
  .some(marker=>fire.includes(marker)),
  'Animated logo must not affect server or physics or restore old flame sticks');
assert.ok(fire.includes('local idx=math.floor(state.clock*10)%12'),'Fallback bounded');
assert.ok(fire.indexOf('ui.drawImage(VENOM_LOGO_URL')<
  fire.indexOf('drawLogoAnimation(width,height)'),
  'Flames must draw ON TOP, unlike invisible v2');
assert.ok(fire.includes('FIRE_ANIM_PLAYER:ready()'),'Animated WebP readiness check required');
assert.ok(!source.includes('ui.drawLine(bottom,center'),'Never restore old bars');
assert.ok(!source.includes("'الانتقال إلى موقع  >##vxhomeTP'"),
  'Arabic UI action labels should be English');
console.log('PASS: English menus, Arabic hover, WebP+RGBA fire client render, saved toggle, original protocols');
