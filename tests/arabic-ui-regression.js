'use strict';
const fs = require('node:fs');
const assert = require('node:assert/strict');

const source = fs.readFileSync('VENOM_X.lua','utf8');
const mustInclude=[
  "local VERSION = '3.25.3'",
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
  "if state.logoFire then",
  "VENOM_FIRE_ATLAS_URL",
  "assets/venom_flames_atlas_v2.png",
  "local idx=math.floor(state.clock*10)%12",
  "ui.drawImage(VENOM_FIRE_ATLAS_URL",
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
// Sprite Atlas is client-only: no network event or procedural loops per frame.
const fireStart=source.indexOf('local VENOM_FIRE_ATLAS_URL');
const fireEnd=source.indexOf('function script.drawUI()',fireStart);
assert.ok(fireStart>0 && fireEnd>fireStart,'Atlas renderer missing');
const fire=source.slice(fireStart,fireEnd);
assert.ok(!/ac\.OnlineEvent|fetch\(|physics\.|drawLogoFire|drawLogoEmbers/.test(fire),
  'Animated logo must not interact with physics, online events or old line-based fire');
assert.ok(fire.includes('math.floor(state.clock*10)%12'),'Frame selection must remain bounded');
assert.ok(fire.includes('column/4+ux') && fire.includes('row/3+uy'),
  'Atlas UV cropping must match 4×3 frames');
assert.ok(fire.indexOf('ui.drawImage(VENOM_FIRE_ATLAS_URL')<
  fire.indexOf('ui.drawImage(VENOM_LOGO_URL'),
  'Animation must be drawn behind original logo');
assert.ok(!source.includes('ui.drawLine(bottom,center'),
  'Old vertical flame sticks must be completely removed');
assert.ok(!source.includes("'الانتقال إلى موقع  >##vxhomeTP'"),
  'Arabic UI action labels should be English');
console.log('PASS: English menus, Arabic hover, sprite atlas fire client render, saved toggle, original protocols');
