// =========================================================================
// [MOD FEATURE]: FARM KC - XOA SACH BANG TAI KHOAN FARM_KC DE TAO LAI CHUAN
// Mo ta: Chi dung MOT LAN trong giai doan test. Script nay:
//          1. Go lien ket farmAccountId tren 2 bang theo doi (ve NULL)
//          2. DROP bang FarmAccountRange va FarmAccount
//        Sau do khoi dong lai web, ensureInitialSeed se tao lai 2 bang theo
//        dung cau truc moi (FarmAccount khong con farmLevel/rangeFrom/rangeTo).
//
// KHONG dung script nay khi da chay that - du lieu tai khoan FARM_KC se mat.
// Kho mac dinh (FarmInviter / FarmInvitee) KHONG bi dong toi.
//
// Cach dung:
//   node reset-farm-accounts.js --yes
// =========================================================================
const path = require('path');

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
      process.exit(1);
    }
  }
}
const { PrismaClient } = napPrisma();
const prisma = new PrismaClient();

const DONG_Y = process.argv.includes('--yes');

async function dem(bang) {
  try {
    const r = await prisma.$queryRawUnsafe(
      `SELECT COUNT(*) AS n FROM [dbo].[${bang}]`,
    );
    return Number(r?.[0]?.n ?? 0);
  } catch (e) {
    return null; // bang chua ton tai
  }
}

async function main() {
  const soTk = await dem('FarmAccount');
  const soKhoang = await dem('FarmAccountRange');

  console.log('Hien trang:');
  console.log('  FarmAccount      :', soTk === null ? 'chua co bang' : `${soTk} dong`);
  console.log('  FarmAccountRange :', soKhoang === null ? 'chua co bang' : `${soKhoang} dong`);

  if (!DONG_Y) {
    console.log('');
    console.log('Day la che do xem truoc. De xoa that, chay lai voi tham so --yes:');
    console.log('  node reset-farm-accounts.js --yes');
    return;
  }

  console.log('\nDang xoa...');

  // 1) Go lien ket tren 2 bang THEO DOI (kho mac dinh khong con cot nay)
  for (const bang of ['FarmInviterPlay', 'FarmInviteePlay']) {
    try {
      const n = await prisma.$executeRawUnsafe(
        `UPDATE [dbo].[${bang}] SET [farmAccountId] = NULL WHERE [farmAccountId] IS NOT NULL`,
      );
      console.log(`  ${bang}: go lien ket ${n} dong`);
    } catch (e) {
      console.log(`  ${bang}: bo qua (${e.message.split('\n')[0]})`);
    }
  }

  // 2) Xoa bang con truoc roi den bang cha
  for (const bang of ['FarmAccountRange', 'FarmAccount']) {
    try {
      await prisma.$executeRawUnsafe(
        `IF EXISTS (SELECT * FROM sys.tables WHERE name = '${bang}') DROP TABLE [dbo].[${bang}]`,
      );
      console.log(`  Da xoa bang ${bang}`);
    } catch (e) {
      console.log(`  ${bang}: loi - ${e.message.split('\n')[0]}`);
    }
  }

  console.log('\nXong. Gio khoi dong lai web (npm run dev hoac npm start),');
  console.log('he thong se tu tao lai 2 bang theo cau truc moi.');
}

main()
  .catch((e) => {
    console.error('\nLOI:', e.message);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
