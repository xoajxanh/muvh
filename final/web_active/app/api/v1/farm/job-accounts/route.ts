import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API LAY DANH SACH ACC GAME CUA MOT CONG VIEC
// Mo ta: Mod goi sau khi da chon cong viec (jobCode). Web tra ve cac acc game
//        nam trong khoang STT cua cong viec do, BO QUA acc da lam xong.
//        Dong thoi KHOA cong viec vao gia lap dang goi (deviceId) va ghi nhip
//        tim - gia lap khac mo cung viec se bi bao dang chay o may khac.
//
// GET /api/v1/farm/job-accounts?jobCode=..&deviceId=..&deviceName=..
//     &take=50&afterStt=0&ts=..&sign=..
// Ky: sign = MD5(jobCode + ts + SALT)
// =========================================================================

export async function GET(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const { searchParams } = new URL(req.url);
    const jobCode = (searchParams.get('jobCode') || '').trim();
    const deviceId = (searchParams.get('deviceId') || '').trim();
    const deviceName = (searchParams.get('deviceName') || '').trim();
    const takeRaw = parseInt(searchParams.get('take') || '50', 10) || 50;
    const take = Math.min(200, Math.max(1, takeRaw));
    const afterStt = parseInt(searchParams.get('afterStt') || '0', 10) || 0;
    const chiemViec = searchParams.get('claim') !== '0';
    const ts = searchParams.get('ts');
    const sign = searchParams.get('sign');

    if (!jobCode) {
      return NextResponse.json({ ok: false, error: 'Thiếu jobCode' }, { status: 400 });
    }
    if (!ts || !sign) {
      return NextResponse.json({ ok: false, error: 'Thiếu tham số ts hoặc sign' }, { status: 400 });
    }
    const tsNum = Number(ts);
    if (!Number.isFinite(tsNum) || Math.abs(Math.floor(Date.now() / 1000) - tsNum) > MAX_TS_SKEW_SECONDS) {
      return NextResponse.json({ ok: false, error: 'Request hết hạn hoặc ts không hợp lệ' }, { status: 401 });
    }
    if (buildSign([jobCode], ts).toLowerCase() !== String(sign).toLowerCase()) {
      return NextResponse.json({ ok: false, error: 'Chữ ký không hợp lệ' }, { status: 401 });
    }

    const job = await (prisma as any).farmAccountRange.findUnique({
      where: { jobCode },
      include: { farmAccount: { select: { id: true, username: true, status: true } } },
    });
    if (!job) {
      return NextResponse.json({ ok: false, error: `Không tìm thấy công việc "${jobCode}"` }, { status: 404 });
    }

    // ---- Khoa cong viec vao mot gia lap ----
    const HET_HAN_MS = 5 * 60 * 1000;
    const bayGio = new Date();
    const conSong =
      !!job.deviceId &&
      !!job.lastHeartbeat &&
      bayGio.getTime() - new Date(job.lastHeartbeat).getTime() < HET_HAN_MS;

    if (conSong && deviceId && job.deviceId !== deviceId) {
      return NextResponse.json(
        {
          ok: false,
          daBiChiem: true,
          deviceName: job.deviceName || '',
          error: `Công việc này đang chạy ở máy khác${job.deviceName ? ` (${job.deviceName})` : ''}`,
        },
        { status: 409 },
      );
    }

    if (chiemViec && deviceId) {
      await (prisma as any).farmAccountRange.update({
        where: { id: job.id },
        data: {
          deviceId,
          deviceName: deviceName || job.deviceName || '',
          lastHeartbeat: bayGio,
          status: job.status === 'NEW' ? 'RUNNING' : job.status,
        },
      });
      if (job.farmAccount?.status === 'NEW') {
        await (prisma as any).farmAccount.update({
          where: { id: job.farmAccount.id },
          data: { status: 'RUNNING', lastSyncAt: bayGio },
        });
      }
    }

    // ---- Lay acc game trong khoang STT, bo qua acc da xong ----
    const laLv200 = job.farmLevel === 200;
    const bang: any = laLv200 ? prisma.farmInviter : prisma.farmInvitee;
    const trangThaiXong = laLv200 ? ['DONE', 'INVITED'] : ['SUCCESS', 'ALREADY_USED'];

    const where: any = {
      stt: { gte: Math.max(job.rangeFrom, afterStt + 1), lte: job.rangeTo },
      status: { notIn: trangThaiXong },
    };

    const [tongConLai, rows] = await Promise.all([
      bang.count({ where }),
      bang.findMany({
        where,
        orderBy: { stt: 'asc' },
        take,
        select: {
          id: true,
          stt: true,
          email: true,
          password: true,
          serverId: true,
          serverName: true,
          roleName: true,
          level: true,
          inviteCode: true,
          status: true,
        },
      }),
    ]);

    // Gan cong viec cho cac acc vua phat (de web biet acc nay thuoc block nao)
    if (chiemViec && rows.length > 0) {
      await bang.updateMany({
        where: { id: { in: rows.map((r: any) => r.id) }, farmAccountId: null },
        data: { farmAccountId: job.farmAccountId },
      });
    }

    return NextResponse.json({
      ok: true,
      jobCode: job.jobCode,
      username: job.farmAccount?.username || '',
      farmLevel: job.farmLevel,
      serverId: job.serverId,
      serverName: job.serverName,
      rangeFrom: job.rangeFrom,
      rangeTo: job.rangeTo,
      cursorStt: job.cursorStt,
      conLai: tongConLai,
      heetHang: rows.length === 0,
      accounts: rows.map((r: any) => ({
        stt: r.stt,
        email: r.email,
        password: r.password,
        serverId: job.serverId || r.serverId,
        serverName: job.serverName || r.serverName,
        roleName: r.roleName,
        level: r.level,
        inviteCode: r.inviteCode || '',
        status: r.status,
      })),
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
