// =========================================================================
// [MOD FEATURE]: FARM KC - CLI GOI THU TUNG API (tu tinh sign MD5)
// Cach dung:
//   node scripts/farm-call.js get-inviter   <email> <serverId> [user]
//   node scripts/farm-call.js report        <email> <serverId> <inviteCode> [num] [user]
//   node scripts/farm-call.js claim         <email> <serverId> [deviceId] [user]
//   node scripts/farm-call.js result        <email> <serverId> <STATUS> [errMsg] [user]
// Bien moi truong: BASE_URL (mac dinh http://localhost:3000), FARM_SECRET_SALT
// =========================================================================
const crypto = require('crypto');

const BASE = process.env.BASE_URL || 'http://localhost:3000';
const SALT = process.env.FARM_SECRET_SALT || 'MUVH_FARM_KC_SALT_2026_XOAI';
const md5 = (s) => crypto.createHash('md5').update(s, 'utf8').digest('hex');
const mkSign = (parts, ts) => md5(parts.map((p) => (p == null ? '' : String(p))).join('') + ts + SALT);

const [, , cmd, email, serverIdRaw, a4, a5, a6] = process.argv;
const serverId = parseInt(serverIdRaw, 10);
const ts = Math.floor(Date.now() / 1000);

function show(label, parts, url, body) {
  console.log('--- ' + label + ' ---');
  console.log('chuoi ky  :', parts.map((p) => (p == null ? '' : String(p))).join('') + ts + '<SALT>');
  console.log('url       :', url);
  if (body) console.log('body      :', JSON.stringify(body));
}

async function send(url, body) {
  const res = body
    ? await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) })
    : await fetch(url);
  const text = await res.text();
  console.log('HTTP      :', res.status);
  try { console.log('ket qua   :', JSON.stringify(JSON.parse(text), null, 2)); }
  catch { console.log('ket qua   :', text); }
}

(async () => {
  if (!cmd || !email || !Number.isFinite(serverId)) {
    console.log('Thieu tham so. Xem huong dan o dau file.');
    process.exit(1);
  }

  if (cmd === 'get-inviter') {
    const user = a4 || 'admin';
    const parts = [email, serverId];
    const q = new URLSearchParams({
      email, serverId: String(serverId), createdBy: user,
      ts: String(ts), sign: mkSign(parts, ts),
    });
    const url = `${BASE}/api/v1/farm/inviter?${q}`;
    show('GET /api/v1/farm/inviter', parts, url);
    return send(url);
  }

  if (cmd === 'report') {
    const inviteCode = a4 || '';
    const num = parseInt(a5 || '0', 10) || 0;
    const user = a6 || 'admin';
    const roleId = '1001';
    const parts = [email, serverId, roleId, inviteCode, num];
    const body = {
      email, password: 'test123', serverId, serverName: 'VINH HANG ' + serverId,
      roleId, roleName: 'ManualInviter', level: 200,
      inviteCode, gameInviteNum: num, unboundGold: 123456, unboundDiamond: 7890,
      createdBy: user, ts, sign: mkSign(parts, ts),
    };
    const url = `${BASE}/api/v1/farm/inviter/report`;
    show('POST /api/v1/farm/inviter/report', parts, url, body);
    return send(url, body);
  }

  if (cmd === 'claim') {
    const deviceId = a4 || 'DEV_MANUAL';
    const user = a5 || 'admin';
    const parts = [email, serverId, deviceId];
    const body = {
      email, password: 'test123', serverId, serverName: 'VINH HANG ' + serverId,
      roleId: '2001', roleName: 'ManualInvitee', level: 50, deviceId,
      createdBy: user, ts, sign: mkSign(parts, ts),
    };
    const url = `${BASE}/api/v1/farm/invite/claim`;
    show('POST /api/v1/farm/invite/claim', parts, url, body);
    return send(url, body);
  }

  if (cmd === 'result') {
    const status = (a4 || 'SUCCESS').toUpperCase();
    const errorMsg = a5 || null;
    const user = a6 || 'admin';
    const parts = [email, serverId, status];
    const body = { email, serverId, status, errorMsg, createdBy: user, ts, sign: mkSign(parts, ts) };
    const url = `${BASE}/api/v1/farm/invite/result`;
    show('POST /api/v1/farm/invite/result', parts, url, body);
    return send(url, body);
  }

  console.log('Lenh khong hop le:', cmd);
})().catch((e) => { console.error('LOI:', e.message); process.exit(1); });
