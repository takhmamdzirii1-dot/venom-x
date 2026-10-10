'use strict';
const fs = require('node:fs');
const assert = require('node:assert/strict');

const source = fs.readFileSync('VENOM_X.lua', 'utf8');
const mustInclude = [
  "local VERSION = '3.25.0'",
  "return ui.DWriteFont('Segoe UI'):weight(700)",
  "navHome = 'الرئيسية'",
  "navPlayers = 'اللاعبون'",
  "navTime = 'الوقت'",
  "navHud = 'الواجهة'",
  "hudSettings = 'إعدادات الواجهة'",
  "GHOST ON | تم تأكيد التفعيل",
  "GHOST OFF | تم تأكيد الإيقاف",
  "TIME | استلم السيرفر الطلب",
  "لا توجد نقطة آمنة",
  "خيارات السيارة | حفظ تلقائي نشط",
  "local function uiHint(message)",
  "ui.textWrapped(tostring(message))",
  "local function drawVenomOfficialLogo()",
  "ui.drawImage(VENOM_LOGO_URL",
  "ac.StructItem.key('VENOMX_Ghost_v1')",
  "ac.StructItem.key('VENOMX_SetTime')",
  "physics.disableCarCollisions"
];
for (const marker of mustInclude) {
  assert.ok(source.includes(marker), `Required UI/functionality marker missing: ${marker}`);
}
const lMatch = source.match(/local L = \{([\s\S]*?)\n\}/);
assert.ok(lMatch, 'Arabic copy table not found');
const l = lMatch[1];
const names = [...l.matchAll(/^\s*([a-zA-Z]\w*)\s*=/gm)].map(m=>m[1]);
const duplicates = names.filter((k,i)=>names.indexOf(k)!==i);
assert.deepEqual(duplicates, [], 'Duplicate localization keys');
assert.ok(l.includes("presetBlue = 'أزرق'"), 'Blue paint preset missing');
assert.ok(l.includes("presetBlueHour = 'مساء 18:40'"), 'Blue hour copy missing');
assert.ok(source.includes('{ label = L.presetBlueHour, sec = 18 * 3600 + 40 * 60 }'),
  'Time blue hour incorrectly mapped to paint label');
assert.ok(!source.includes('GHOST MODE   ON  /  DISABLE'),
  'Old unlocalized ghost toggle still present');
console.log('PASS: Arabic-first VENOM X copy/font, unique localization keys, unchanged TIME/GHOST protocol IDs');
