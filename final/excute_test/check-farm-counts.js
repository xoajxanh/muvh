// =========================================================================
// [MOD FEATURE]: FARM KC - DOI CHIEU SO LUONG DB VOI FILE DANG KY
// Mo ta: Dem lai 2 bang acc game, so voi email co trong cac file reg_success,
//        roi chi ra chinh xac ban ghi nao trong DB ma file KHONG co (du),
//        va email nao co trong file ma DB chua co (thieu).
//
// Cach dung:
//   node check-farm-counts.js
// =========================================================================
const fs = require('fs');
const path = require('path');

const THU_MUC_WEB = path.join(__dirname, '..', 'web_active');
function napPrisma() {
  try {
    return require('@prisma/client');
  } catch (e) {
    try {
      return require(path.join(THU_MUC_WEB, 'node_modules', '@prisma', 'client'));
    } catch (e2) {
      console.error('Khong nap duoc @prisma/client tai:', path.join(THU_MUC_WEB, 'node_modules', '@prisma', 'client'));
      process.exit(1);
    }
  }
}
const { PrismaClient } = napPrisma();
const prisma = new PrismaClient();

const MAU_DONG = /^(\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2})\s*\|\s*STT:\s*(\d+)\s*\|\s*Email:\s*(\S+)\s*\|\s*Pass:\s*(\S+)\s*\|\s*UID:\s*(\S*)\s*\|\s*IP:\s*(\S*)\s*$/;

function emailTrongFile(tienTo) {
  const em = new Map(); // email -> stt
  for (const f of fs.readdirSync(__dirname).filter((x) => x.startsWith(tienTo) && x.endsWith('.txt')).sort()) {
    const noiDung = fs.readFileSync(path.join(__dirname, f), 'utf8').replace(/^﻿/, '');
    for (const dong of noiDung.split(/\r?\n/)) {
      const m = MAU_DONG.exec(dong.trim());
      if (m) em.set(m[3].toLowerCase(), parseInt(m[2], 10));
    }
  }
  return em;
}

async function docHet(bang) {
  const ra = [];
  const TRANG = 2000;
  let bo = 0;
  for (;;) {
    const rows = await bang.findMany({
      select: { email: true, stt: true, importBatch: true },
      orderBy: { email: 'asc' },
      skip: bo,
      take: TRANG,
    });
    ra.push(...rows);
    if (rows.length < TRANG) break;
    bo += TRANG;
  }
  return ra;
}

async function soi(ten, tienTo, bang) {
  const tuFile = emailTrongFile(tienTo);
  const trongDb = await docHet(bang);

  console.log(`\n=== ${ten} ===`);
  console.log(`  File  : ${tuFile.size} email khac nhau`);
  console.log(`  DB    : ${trongDb.length} ban ghi`);

  const emailDb = new Set(trongDb.map((r) => String(r.email).toLowerCase()));
  const du = trongDb.filter((r) => !tuFile.has(String(r.email).toLowerCase()));
  const thieu = [...tuFile.keys()].filter((e) => !emailDb.has(e));

  console.log(`  Du (DB co, file khong co) : ${du.length}`);
  du.slice(0, 20).forEach((r) =>
    console.log(`      ${r.email}  | stt=${r.stt} | batch='${r.importBatch || ''}'`),
  );
  if (du.length > 20) console.log(`      ... con ${du.length - 20} dong nua`);

  console.log(`  Thieu (file co, DB khong) : ${thieu.length}`);
  thieu.slice(0, 20).forEach((e) => console.log(`      ${e}`));
  if (thieu.length > 20) console.log(`      ... con ${thieu.length - 20} dong nua`);

  // Bao nhieu ban ghi la do lan import vua roi tao ra
  const theoBatch = new Map();
  trongDb.forEach((r) => {
    const b = r.importBatch || '(khong co - ban ghi cu)';
    theoBatch.set(b, (theoBatch.get(b) || 0) + 1);
  });
  console.log('  Theo dot import:');
  [...theoBatch.entries()].forEach(([b, n]) => console.log(`      ${b}: ${n}`));

  // Kiem tra stt co dung voi file khong
  const lechStt = trongDb.filter((r) => {
    const s = tuFile.get(String(r.email).toLowerCase());
    return s !== undefined && s !== r.stt;
  });
  console.log(`  STT lech so voi file      : ${lechStt.length}`);
  lechStt.slice(0, 10).forEach((r) =>
    console.log(`      ${r.email}  DB stt=${r.stt} | file stt=${tuFile.get(String(r.email).toLowerCase())}`),
  );
}

async function main() {
  await soi('ACC LV200 (bang FarmInviter)', 'reg_success_vut_proxy', prisma.farmInviter);
  await soi('ACC LV50  (bang FarmInvitee)', 'reg_success_fang0_proxy', prisma.farmInvitee);
  console.log('\nXong.');
}

main()
  .catch((e) => {
    console.error('\nLOI:', e.message);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
