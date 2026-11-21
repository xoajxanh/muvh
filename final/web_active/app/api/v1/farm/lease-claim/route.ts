import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';
import { BO_QUA_LV200, BO_QUA_LV50 } from '@/lib/farm-play';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - GIU (LEASE) MOT LO TAI KHOAN DE CHAY
// Mo ta: may bam BAT DAU voi so luong N -> server giu N acc cho may do trong
//        LEASE_PHUT phut. May khac khong nhan duoc nhung acc nay.
//        May crash/tat -> het han -> acc tu ve kho, khong ai phai go tay.
//
// Nguyen tu: dung MOT cau UPDATE ... OUTPUT voi (UPDLOCK, READPAST). Hai may
// bam cung luc KHONG the nhan trung, vi dong nao dang bi khoa thi bo qua.
//
// Hai nguon acc:
//   1. Dong FarmInviterPlay/FarmInviteePlay da co, chua xong, lease tu do
//   2. Acc trong kho CHUA tung chay tren server nay -> INSERT dong moi kem lease
//
// POST /api/v1/farm/lease-claim
// Body: { username, password, mode: "200"|"50", serverId, soLuong,
//         deviceId, deviceName, ts, sign }
// Ky: sign = MD5(username + serverId + soLuong + ts + SALT)
// =========================================================================

const LEASE_PHUT = 15;

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();

    const username = String(body.username || '').trim().toLowerCase();
    const password = String(body.password || '').trim();
    const mode = String(body.mode || '200').trim();
    const serverId = parseInt(String(body.serverId ?? 0), 10) || 0;
    const soLuong = Math.max(1, Math.min(500, parseInt(String(body.soLuong ?? 0), 10) || 0));
    const deviceId = String(body.deviceId || '').trim();
    const deviceName = String(body.deviceName || '').trim();
    const ts = body.ts;
    const sign = String(body.sign || '');

    if (!username || !password) {
      return NextResponse.json({ ok: false, error: 'Thiếu username hoặc password' }, { status: 400 });
    }
    if (!serverId) {
      return NextResponse.json({ ok: false, error: 'Thiếu serverId' }, { status: 400 });
    }
    if (!deviceId) {
      return NextResponse.json({ ok: false, error: 'Thiếu deviceId' }, { status: 400 });
    }
    const tsNum = Number(ts);
    if (!Number.isFinite(tsNum) || Math.abs(Math.floor(Date.now() / 1000) - tsNum) > MAX_TS_SKEW_SECONDS) {
      return NextResponse.json({ ok: false, error: 'Request hết hạn hoặc ts không hợp lệ' }, { status: 401 });
    }
    if (buildSign([username, serverId, soLuong], ts).toLowerCase() !== sign.toLowerCase()) {
      return NextResponse.json({ ok: false, error: 'Chữ ký không hợp lệ' }, { status: 401 });
    }

    const acc = await (prisma as any).farmAccount.findUnique({
      where: { username },
      include: { ranges: true },
    });
    if (!acc) {
      return NextResponse.json({ ok: false, error: 'Tài khoản không tồn tại' }, { status: 404 });
    }
    if (acc.password !== password) {
      return NextResponse.json({ ok: false, error: 'Sai mật khẩu' }, { status: 401 });
    }

    const laLv200 = mode !== '50';
    const farmLevel = laLv200 ? 200 : 50;
    const bangPlay = laLv200 ? 'FarmInviterPlay' : 'FarmInviteePlay';
    const bangKho = laLv200 ? 'FarmInviter' : 'FarmInvitee';
    const trangThaiXong = laLv200 ? BO_QUA_LV200 : BO_QUA_LV50;

    // Cac dai STT duoc giao cho tai khoan nay tren server nay
    const dai = (acc.ranges || [])
      .filter((k: any) => k.farmLevel === farmLevel && k.serverId === serverId)
      .map((k: any) => ({ from: k.rangeFrom, to: k.rangeTo }));

    if (dai.length === 0) {
      return NextResponse.json(
        { ok: false, error: `Tài khoản chưa được giao dải nào ở server ${serverId} (Lv${farmLevel})` },
        { status: 400 },
      );
    }

    const serverName =
      (acc.ranges || []).find((k: any) => k.serverId === serverId && k.serverName)?.serverName || '';

    const dkDai = dai.map((d: any) => `([stt] >= ${d.from} AND [stt] <= ${d.to})`).join(' OR ');
    const dsXong = trangThaiXong.map((x) => `'${x}'`).join(',');
    const devEsc = deviceId.replace(/'/g, "''");
    const devNameEsc = deviceName.replace(/'/g, "''");
    const svNameEsc = String(serverName).replace(/'/g, "''");
    const creatorEsc = String(acc.createdById).replace(/'/g, "''");

    const nhan: { stt: number; email: string; password: string; status: string }[] = [];

    // ---------------------------------------------------------------------
    // 1) Nhan lai cac dong da co: chua xong VA lease tu do (hoac cua chinh may nay)
    // ---------------------------------------------------------------------
    const sqlUpdate = `
      UPDATE TOP (${soLuong}) p
      SET p.[leaseDeviceId] = N'${devEsc}',
          p.[leaseDeviceName] = N'${devNameEsc}',
          p.[leaseUntil] = DATEADD(minute, ${LEASE_PHUT}, SYSUTCDATETIME()),
          p.[updatedAt] = SYSUTCDATETIME()
      OUTPUT inserted.[stt], inserted.[email], inserted.[password], inserted.[status]
      FROM [dbo].[${bangPlay}] AS p WITH (UPDLOCK, READPAST)
      WHERE p.[serverId] = ${serverId}
        AND p.[status] NOT IN (${dsXong})
        AND (${dkDai})
        AND (p.[leaseUntil] IS NULL
             OR p.[leaseUntil] < SYSUTCDATETIME()
             OR p.[leaseDeviceId] = N'${devEsc}')
    `;
    const daCo: any[] = await prisma.$queryRawUnsafe(sqlUpdate);
    for (const r of daCo || []) {
      nhan.push({ stt: r.stt, email: r.email, password: r.password || '', status: r.status });
    }

    // ---------------------------------------------------------------------
    // 2) Con thieu -> lay acc trong kho CHUA tung chay tren server nay
    // ---------------------------------------------------------------------
    const conThieu = soLuong - nhan.length;
    if (conThieu > 0) {
      const sqlInsert = `
        INSERT INTO [dbo].[${bangPlay}]
            ([id], [masterId], [stt], [email], [password], [serverId], [serverName],
             [status], [leaseDeviceId], [leaseDeviceName], [leaseUntil],
             [createdById], [createdAt], [updatedAt])
        OUTPUT inserted.[stt], inserted.[email], inserted.[password], inserted.[status]
        SELECT TOP (${conThieu})
            CONVERT(NVARCHAR(100), NEWID()), k.[id], k.[stt], k.[email], k.[password],
            ${serverId}, N'${svNameEsc}', 'NEW',
            N'${devEsc}', N'${devNameEsc}',
            DATEADD(minute, ${LEASE_PHUT}, SYSUTCDATETIME()),
            N'${creatorEsc}', SYSUTCDATETIME(), SYSUTCDATETIME()
        FROM [dbo].[${bangKho}] AS k WITH (UPDLOCK, READPAST)
        WHERE (${dkDai})
          AND NOT EXISTS (
                SELECT 1 FROM [dbo].[${bangPlay}] AS p
                WHERE p.[email] = k.[email] AND p.[serverId] = ${serverId}
              )
        ORDER BY k.[stt]
      `;
      try {
        const moi: any[] = await prisma.$queryRawUnsafe(sqlInsert);
        for (const r of moi || []) {
          nhan.push({ stt: r.stt, email: r.email, password: r.password || '', status: r.status });
        }
      } catch (e: any) {
        // Hai may chen cung luc -> dung unique (email, serverId). Bo qua, lan sau nhan tiep.
        if (!String(e?.message || '').match(/duplicate|unique/i)) throw e;
      }
    }

    nhan.sort((a, b) => a.stt - b.stt);

    return NextResponse.json({
      ok: true,
      mode: laLv200 ? '200' : '50',
      serverId,
      serverName,
      leasePhut: LEASE_PHUT,
      soXin: soLuong,
      soNhan: nhan.length,
      accounts: nhan,
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
