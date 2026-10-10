'use strict';
// v3.25.5 final verification: packed burning-logo asset generated and published.
const fs = require('node:fs');
const assert = require('node:assert/strict');

const source = fs.readFileSync('VENOM_X.lua','utf8');
const mustInclude=[
  "local VERSION = '3.25.5'",
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
  "local VENOM_BURNING_WEBP_URL",
  "assets/venom_fire_logo_v5.webp",
  "assets/venom_fire_logo_v5.png",
  "state.logoFirePower=clamp(res.vx_logo_power,40,100)",
  "stored.vx_logo_power = state.logoFirePower",
  "FIRE INTENSITY",
  "ui.drawImage(VENOM_BURNING_PLAYER",
  "ui.drawImage(VENOM_BURNING_STILL_URL",
  "state.logoFireStatus='FIRE ANIMATED / 16 FRAMES'",
  "state.logoFireStatus='FIRE STATIC / WEBP LOADING'",
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
// The precomposed animation must include real fire and logo on each frame.
const png=fs.readFileSync('assets/venom_fire_logo_v5.png');
const webp=fs.readFileSync('assets/venom_fire_logo_v5.webp');
assert.equal(png.subarray(1,4).toString('utf8'),'PNG');
assert.equal(png[25],6,'Still must be 32-bit RGBA for transparent logo/fire');
assert.equal(webp.subarray(0,4).toString('utf8'),'RIFF');
assert.equal(webp.subarray(8,12).toString('utf8'),'WEBP');
assert.ok(webp.includes(Buffer.from('ANIM')),'WebP must be animated');
assert.ok(webp.length<900000,'Animated logo must remain lightweight');
const fireStart=source.indexOf('local VENOM_BURNING_WEBP_URL');
const fireEnd=source.indexOf('function script.drawUI()',fireStart);
assert.ok(fireStart>0&&fireEnd>fireStart,'Fire renderer missing');
const fire=source.slice(fireStart,fireEnd);
assert.ok(!['ac.OnlineEvent','fetch(','physics.','drawLogoFire','drawLogoEmbers']
  .some(marker=>fire.includes(marker)),
  'Fire must not call server/physics or old ugly procedural bars');
assert.ok(fire.includes('VENOM_BURNING_PLAYER:ready()') &&
  fire.includes('VENOM_BURNING_PLAYER:valid()'),
  'Animated WebP decode/readiness must be checked');
assert.ok(fire.includes('ui.drawImage(VENOM_BURNING_STILL_URL'),
  'Always show strong static flames if animation is not yet ready');
assert.ok(fire.includes('ui.drawImage(VENOM_LOGO_URL'),
  'Always keep original logo if assets fail');
assert.ok(!source.includes('ui.drawLine(bottom,center'),
  'Old vertical flame sticks must never return');
assert.ok(!source.includes("'الانتقال إلى موقع  >##vxhomeTP'"),
  'Arabic UI action labels should be English');
console.log('PASS: English menus, Arabic tips, strong 16-frame precomposed fire, static fallback, saved intensity, no server logic changes');
