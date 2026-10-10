'use strict';
const fs = require('node:fs');
const assert = require('node:assert/strict');

const source = fs.readFileSync('VENOM_X.lua','utf8');
const mustInclude=[
  "local VERSION = '3.25.1'",
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
  "physics.disableCarCollisions"
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
assert.ok(!source.includes("'الانتقال إلى موقع  >##vxhomeTP'"),
  'Arabic UI action labels should be English');
console.log('PASS: English controls, Arabic hover/help and feedback, large fonts, UI fit, protocol IDs');
