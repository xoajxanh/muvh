// =========================================================================
// [MOD FEATURE]: FARM KC - IMPORT FILE DANG KY ACC VAO DATABASE
// Mo ta: Doc cac file reg_success_*.txt roi tao ban ghi trong 2 bang:
//          reg_success_fang0_proxy*.txt -> FarmInvitee (acc Lv50 di nhap ma)
//          reg_success_vut_proxy*.txt   -> FarmInviter (acc Lv200 tao ma)
//        Kho chi giu email / mat khau / STT / UID / IP / thoi diem dang ky.
//        Tien do choi tren tung server nam o FarmInviterPlay / FarmInviteePlay.
//        Trung email thi BO QUA (khong ghi de ban ghi da co).
//
// Cach dung (dat ngay trong thu muc excute_test, chay tu bat ky dau):
//   node import-farm-reg.js [duong-dan-thu-muc-chua-file] [--dry]
// Mac dinh doc file ngay trong thu muc chua script nay.
//   --dry  : chi doc file va bao cao, khong ghi vao DB
// =========================================================================
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// Prisma Client nam trong node_modules cua web_active -> tim theo duong dan
// tuyet doi, de script chay duoc du dat ngoai thu muc do.
const THU_MUC_WEB = path.join(__dirname, '..', 'web_active');
function napPrisma() {
  try {
    return require('@prisma/client');
  } catch (e) {
    try {
      return require(path.join(THU_MUC_WEB, 'node_modules', '@prisma', 'client'));
    } catch (e2) {
      console.error('Khong nap duoc @prisma/client.');
      console.error('Kiem tra lai thu muc:', path.join(THU_MUC_WEB, 'node_modules', '@prisma', 'client'));
      console.error('Neu chua cai, chay: cd ' + THU_MUC_WEB + ' && npm install && npx prisma generate');
      process.exit(1);
    }
  }
}
const { PrismaClient } = napPrisma();

const prisma = new PrismaClient();

const THU_MUC = process.argv[2] && !process.argv[2].startsWith('--')
  ? process.argv[2]
  : __dirname;
const CHAY_THU = process.argv.includes('--dry');

// Mau mot dong:
// 2026-10-01 19:56:11 | STT: 0001 | Email: a@gmail.com | Pass: 12345ZXC | UID: 1790... | IP: 183.80.170.28
const MAU_DONG = /^(\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2})\s*\|\s*STT:\s*(\d+)\s*\|\s*Email:\s*(\S+)\s*\|\s*Pass:\s*(\S+)\s*\|\s*UID:\s*(\S*)\s*\|\s*IP:\s*(\S*)\s*$/;

function docFile(duongDan) {
  // Bo BOM dau file neu co
  const noiDung = fs.readFileSync(duongDan, 'utf8').replace(/^﻿/, '');
  const ketQua = [];
  const dongLoi = [];

  noiDung.split(/\r?\n/).forEach((dong, i) => {
    const d = dong.trim();
    if (!d) return;
    const m = MAU_DONG.exec(d);
    if (!m) {
      dongLoi.push({ dong: i + 1, noiDung: d.slice(0, 120) });
      return;
    }
    ketQua.push({
      regAt: new Date(m[1].replace(' ', 'T')),
      stt: parseInt(m[2], 10) || 0,
      email: m[3].trim().toLowerCase(),
      password: m[4].trim(),
      uid: (m[5] || '').trim(),
      regIp: (m[6] || '').trim(),
    });
  });

  return { ketQua, dongLoi };
}

function timFile(tienTo) {
  if (!fs.existsSync(THU_MUC)) return [];
  return fs
    .readdirSync(THU_MUC)
    .filter((f) => f.startsWith(tienTo) && f.toLowerCase().endsWith('.txt'))
    .sort()
    .map((f) => path.join(THU_MUC, f));
}

async function layAdminId() {
  const admin = await prisma.user.findFirst({
    where: { role: 'ADMIN' },
    orderBy: { createdAt: 'asc' },
    select: { id: true, username: true },
  });
  if (!admin) throw new Error('Khong tim thay tai khoan ADMIN nao trong bang User');
  return admin;
}

async function nap({ ten, tienTo, bang, createdById, batch }) {
  const files = timFile(tienTo);
  console.log(`\n=== ${ten} (${tienTo}*) ===`);
  if (files.length === 0) {
    console.log('  Khong tim thay file nao trong', THU_MUC);
    return;
  }

  // Gom tat ca dong, bo trung email ngay trong file
  const theoEmail = new Map();
  let tongDong = 0;
  let tongLoi = 0;

  for (const f of files) {
    const { ketQua, dongLoi } = docFile(f);
    tongDong += ketQua.length;
    tongLoi += dongLoi.length;
    console.log(`  ${path.basename(f)}: ${ketQua.length} dong hop le${dongLoi.length ? `, ${dongLoi.length} dong khong doc duoc` : ''}`);
    for (const r of ketQua) {
      if (!theoEmail.has(r.email)) theoEmail.set(r.email, r);
    }
  }

  const dsMoi = [...theoEmail.values()];
  console.log(`  -> ${tongDong} dong, ${dsMoi.length} email khac nhau${tongLoi ? `, ${tongLoi} dong loi` : ''}`);

  // Email da co trong DB (bat ke serverId nao) thi bo qua - bang mac dinh
  // chi giu MOT ban ghi cho moi tai khoan game.
  process.stdout.write('  Dang doc email da co trong DB...');
  const daCo = new Set();
  const TRANG = 5000;
  let bo = 0;
  for (;;) {
    const rows = await bang.findMany({
      select: { email: true },
      orderBy: { email: 'asc' },
      skip: bo,
      take: TRANG,
    });
    rows.forEach((r) => daCo.add(String(r.email).toLowerCase()));
    if (rows.length < TRANG) break;
    bo += TRANG;
    process.stdout.write(`\r  Dang doc email da co trong DB... ${daCo.size}`);
  }
  process.stdout.write(`\r  Email da co trong DB: ${daCo.size}            \n`);

  const canThem = dsMoi.filter((r) => !daCo.has(r.email));
  console.log(`  Trung, bo qua: ${dsMoi.length - canThem.length} · Se them moi: ${canThem.length}`);

  if (CHAY_THU) {
    console.log('  (--dry) Khong ghi vao DB.');
    if (canThem[0]) console.log('  Vi du ban ghi dau:', JSON.stringify(canThem[0]));
    return;
  }
  if (canThem.length === 0) return;

  const bayGio = new Date();
  let daGhi = 0;
  // Moi ban ghi ~18 cot, SQL Server toi da 2100 tham so/truy van -> lo 100 dong
  const LO = 100;
  for (let i = 0; i < canThem.length; i += LO) {
    const lo = canThem.slice(i, i + LO).map((r) => ({
      id: crypto.randomUUID(),
      email: r.email,
      password: r.password,
      // Kho mac dinh chi giu thong tin dinh danh - tien do nam o bang *Play
      stt: r.stt,
      uid: r.uid,
      regIp: r.regIp,
      regAt: r.regAt,
      importBatch: batch,
      createdById,
      createdAt: bayGio,
      updatedAt: bayGio,
    }));
    const kq = await bang.createMany({ data: lo });
    daGhi += kq.count ?? lo.length;
    process.stdout.write(`\r  Dang ghi... ${daGhi}/${canThem.length}`);
  }
  console.log(`\r  Da them ${daGhi} ban ghi moi.              `);
}

async function main() {
  console.log('Thu muc file:', THU_MUC);
  if (CHAY_THU) console.log('CHE DO CHAY THU - khong ghi vao DB');

  const admin = await layAdminId();
  console.log('Nguoi tao gan cho ban ghi:', admin.username);

  const batch = `import-${new Date().toISOString().slice(0, 19).replace(/[:T]/g, '')}`;

  // Acc Lv200: nguoi MOI -> bang FarmInviter, trang thai NEW (chua co ma moi)
  await nap({
    ten: 'ACC LV200 (nguoi moi)',
    tienTo: 'reg_success_vut_proxy',
    bang: prisma.farmInviter,
    createdById: admin.id,
    batch,
  });

  // Acc Lv50: nguoi DUOC MOI -> bang FarmInvitee, trang thai NEW (chua nhap ma)
  await nap({
    ten: 'ACC LV50 (duoc moi)',
    tienTo: 'reg_success_fang0_proxy',
    bang: prisma.farmInvitee,
    createdById: admin.id,
    batch,
  });

  console.log('\nXong.');
}

main()
  .catch((e) => {
    console.error('\nLOI:', e.message);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
