import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';
import { BO_QUA_LV200, BO_QUA_LV50 } from '@/lib/farm-play';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - DANH SACH SERVER + SO ACC CON LAI THEO MODE
// Mo ta: thay cho luoi "cong viec" cu. Mod chi can chon Mode (200/50), roi
//        chon Server trong dropdown, roi nhap so luong muon chay.
//        API nay tra ve: moi server duoc giao cho tai khoan nay, kem
//          tong     : tong acc trong cac dai STT duoc giao
//          daXong   : da chay xong (hoac loi bo qua)
//          dangGiu  : MAY KHAC dang giu (lease chua het han)
//          conLai   : con co the nhan = tong - daXong - dangGiu
//        Nut "Tai lai" ben mod goi lai dung API nay.
//
// GET /api/v1/farm/pool?username=&password=&mode=200|50&deviceId=&ts=&sign=
// Ky: sign = MD5(username + password + ts + SALT)   (giong /jobs)
// =========================================================================

export async function GET(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const { searchParams } = new URL(req.url);
    const username = (searchParams.get('username') || '').trim().toLowerCase();
    const password = (searchParams.get('password') || '').trim();
    const deviceId = (searchParams.get('deviceId') || '').trim();
    const mode = (searchParams.get('mode') || '200').trim();
    const ts = searchParams.get('ts');
    const sign = searchParams.get('sign');

    if (!username || !password) {
      return NextResponse.json({ ok: false, error: 'Thiếu username hoặc password' }, { status: 400 });
    }
    if (!ts || !sign) {
      return NextResponse.json({ ok: false, error: 'Thiếu ts hoặc sign' }, { status: 400 });
    }
    const tsNum = Number(ts);
    if (!Number.isFinite(tsNum) || Math.abs(Math.floor(Date.now() / 1000) - tsNum) > MAX_TS_SKEW_SECONDS) {
      return NextResponse.json({ ok: false, error: 'Request hết hạn hoặc ts không hợp lệ' }, { status: 401 });
    }
    if (buildSign([username, password], ts).toLowerCase() !== String(sign).toLowerCase()) {
      return NextResponse.json({ ok: false, error: 'Chữ ký không hợp lệ' }, { status: 401 });
    }

    const laLv200 = mode !== '50';
    const farmLevel = laLv200 ? 200 : 50;

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

    // Gop cac dai STT theo server (mot server co the duoc giao nhieu dai)
    type DaiStt = { from: number; to: number };
    type ThongTinServer = { serverName: string; dai: DaiStt[] };
    const theoServer = new Map<number, ThongTinServer>();
    for (const k of acc.ranges || []) {
      if (k.farmLevel !== farmLevel) continue;
      const cu: ThongTinServer =
        theoServer.get(k.serverId) || { serverName: k.serverName || '', dai: [] };
      cu.dai.push({ from: k.rangeFrom, to: k.rangeTo });
      if (!cu.serverName && k.serverName) cu.serverName = k.serverName;
      theoServer.set(k.serverId, cu);
    }

    const kho: any = laLv200 ? (prisma as any).farmInviter : (prisma as any).farmInvitee;
    const theoDoi: any = laLv200 ? (prisma as any).farmInviterPlay : (prisma as any).farmInviteePlay;
    const trangThaiXong = laLv200 ? BO_QUA_LV200 : BO_QUA_LV50;
    const bayGio = new Date();

    const servers = await Promise.all(
      Array.from(theoServer.entries()).map(async ([serverId, info]) => {
        const locDai = { OR: info.dai.map((d: DaiStt) => ({ stt: { gte: d.from, lte: d.to } })) };

        const [tong, daXong, dangGiu] = await Promise.all([
          kho.count({ where: locDai }),
          theoDoi.count({
            where: { ...locDai, serverId, status: { in: trangThaiXong } },
          }),
          theoDoi.count({
            where: {
              ...locDai,
              serverId,
              status: { notIn: trangThaiXong },
              leaseUntil: { gt: bayGio },
              ...(deviceId ? { NOT: { leaseDeviceId: deviceId } } : {}),
            },
          }),
        ]);

        return {
          serverId,
          serverName: info.serverName || `Server ${serverId}`,
          tong,
          daXong,
          dangGiu,
          conLai: Math.max(0, tong - daXong - dangGiu),
          soDai: info.dai.length,
        };
      }),
    );

    servers.sort((a, b) => a.serverId - b.serverId);

    return NextResponse.json({
      ok: true,
      username: acc.username,
      mode: laLv200 ? '200' : '50',
      farmLevel,
      soServer: servers.length,
      servers,
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
