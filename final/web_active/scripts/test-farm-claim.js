// =========================================================================
// [MOD FEATURE]: FARM KC - SCRIPT TEST CLAIM DONG THOI (P1)
// Chay: node scripts/test-farm-claim.js [baseUrl] [serverId] [webUsername]
// Tieu chi dat: khong acc Lv200 nao vuot maxInvites (used + reserved <= 5)
// =========================================================================
const crypto = require('crypto');

const BASE = process.argv[2] || 'http://localhost:3000';
const SERVER_ID = parseInt(process.argv[3] || '517', 10);
const WEB_USER = process.argv[4] || 'admin';
const SALT = process.env.FARM_SECRET_SALT || 'MUVH_FARM_KC_SALT_2026_XOAI';

const md5 = (s) => crypto.createHash('md5').update(s, 'utf8').digest('hex');
const sign = (parts, ts) => md5(parts.map((p) => (p == null ? '' : String(p))).join('') + ts + SALT);
const nowTs = () => Math.floor(Date.now() / 1000);

async function post(path, body) {
  const r = await fetch(BASE + path, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  return { httpStatus: r.status, data: await r.json().catch(() => ({})) };
}

async function reportInviter(email, code) {
  const ts = nowTs();
  return post('/api/v1/farm/inviter/report', {
    email, password: 'test123', serverId: SERVER_ID, serverName: 'VINH HANG ' + SERVER_ID,
    roleId: '1001', roleName: 'TestInviter', level: 200,
    inviteCode: code, gameInviteNum: 0, unboundGold: 123456, unboundDiamond: 7890,
    createdBy: WEB_USER, ts, sign: sign([email, SERVER_ID, '1001', code, 0], ts),
  });
}

async function claim(email, i) {
  const ts = nowTs();
  const deviceId = 'DEV' + i;
  return post('/api/v1/farm/invite/claim', {
    email, password: 'test123', serverId: SERVER_ID, serverName: 'VINH HANG ' + SERVER_ID,
    roleId: '2' + i, roleName: 'TestInvitee' + i, level: 50, deviceId,
    createdBy: WEB_USER, ts, sign: sign([email, SERVER_ID, deviceId], ts),
  });
}

async function result(email, status) {
  const ts = nowTs();
  return post('/api/v1/farm/invite/result', {
    email, serverId: SERVER_ID, status, errorMsg: null,
    createdBy: WEB_USER, ts, sign: sign([email, SERVER_ID, status], ts),
  });
}

(async () => {
  const stamp = Date.now();
  const inviterEmail = `t_inviter_${stamp}@test.local`;
  console.log('=== 1. Tao 1 acc Lv200 voi ma moi (max 5 luot) ===');
  console.log(JSON.stringify((await reportInviter(inviterEmail, 'TESTCODE' + stamp + SERVER_ID)).data));

  console.log('\n=== 2. Ban 12 request claim DONG THOI (chi duoc toi da 5 OK) ===');
  const emails = Array.from({ length: 12 }, (_, i) => `t_invitee_${stamp}_${i}@test.local`);
  const res = await Promise.all(emails.map((e, i) => claim(e, i)));
  let okCount = 0, noCode = 0;
  res.forEach((r, i) => {
    if (r.data.ok && r.data.inviteCode) okCount++;
    else if (r.data.reason === 'NO_CODE') noCode++;
    else console.log('  [bat thuong]', i, r.httpStatus, JSON.stringify(r.data));
  });
  console.log(`  OK (nhan duoc ma): ${okCount}  |  NO_CODE: ${noCode}  |  tong: ${res.length}`);
  console.log(okCount === 5 ? '  => DAT: dung 5 suat' : `  => SAI: ky vong 5, thuc te ${okCount}`);

  console.log('\n=== 3. Bao SUCCESS cho 5 acc da nhan ma ===');
  const winners = emails.filter((e, i) => res[i].data.ok && res[i].data.inviteCode);
  for (const e of winners) {
    const r = await result(e, 'SUCCESS');
    console.log('  ', e, JSON.stringify(r.data));
  }

  console.log('\n=== 4. Goi lai result cho 1 acc (kiem tra idempotent, khong cong 2 lan) ===');
  console.log('  ', JSON.stringify((await result(winners[0], 'SUCCESS')).data));

  console.log('\n=== 5. Claim them 1 acc nua -> phai NO_CODE ===');
  const extra = `t_invitee_${stamp}_extra@test.local`;
  const r5 = await claim(extra, 99);
  console.log('  ', JSON.stringify(r5.data));
  console.log(r5.data.reason === 'NO_CODE' ? '  => DAT' : '  => SAI: van cap duoc ma');

  console.log('\n=== 6. Trang thai cuoi cua acc Lv200 (phai COMPLETE, confirmed=5, reserved=0) ===');
  const ts = nowTs();
  const q = new URLSearchParams({
    email: inviterEmail, serverId: String(SERVER_ID), createdBy: WEB_USER,
    ts: String(ts), sign: sign([inviterEmail, SERVER_ID], ts),
  });
  const g = await fetch(`${BASE}/api/v1/farm/inviter?${q}`);
  console.log('  ', JSON.stringify(await g.json()));
})().catch((e) => { console.error('LOI TEST:', e); process.exit(1); });
