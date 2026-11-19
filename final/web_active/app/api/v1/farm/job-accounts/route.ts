import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';
import { XONG_LV200, XONG_LV50 } from '@/lib/farm-play';

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
      include: { farmAccount: { select: { id: true, username: true, status: true, createdById: true } } },
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

    // =====================================================================
    // [MOD FEATURE]: LAY ACC TU KHO MAC DINH, TIEN DO TU BANG THEO DOI
    // Mo ta: Danh sach acc lay tu kho (FarmInviter / FarmInvitee) theo dai STT
    //        - kho CHI DOC, khong ghi gi vao do.
    //        Acc "da xong" xet tren BANG THEO DOI dung server cua cong viec:
    //        longdt@S517 xong roi khong lam acc do bien mat khoi datnd@S518.
    // =====================================================================
    const laLv200 = job.farmLevel === 200;
    const kho: any = laLv200 ? (prisma as any).farmInviter : (prisma as any).farmInvitee;
    const theoDoi: any = laLv200 ? (prisma as any).farmInviterPlay : (prisma as any).farmInviteePlay;
    const trangThaiXong = laLv200 ? XONG_LV200 : XONG_LV50;

    const trongDai = { stt: { gte: job.rangeFrom, lte: job.rangeTo } };

    // Acc trong dai, CHUA xong tren server nay (tinh qua quan he plays)
    const where: any = {
      stt: { gte: Math.max(job.rangeFrom, afterStt + 1), lte: job.rangeTo },
      plays: { none: { serverId: job.serverId, status: { in: trangThaiXong } } },
    };

    const [tongTrongDai, daXong, tongConLai, rows] = await Promise.all([
      kho.count({ where: trongDai }),
      theoDoi.count({
        where: { serverId: job.serverId, ...trongDai, status: { in: trangThaiXong } },
      }),
      kho.count({ where }),
      kho.findMany({
        where,
        orderBy: { stt: 'asc' },
        take,
        select: {
          stt: true,
          email: true,
          password: true,
          // Tien do (neu da tung choi) cua acc nay tren DUNG server cong viec
          plays: {
            where: { serverId: job.serverId },
            select: { status: true, inviteCode: true, roleName: true, level: true },
            take: 1,
          },
        },
      }),
    ]);

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
      tongTrongDai,
      daXong,
      conLai: tongConLai,
      heetHang: rows.length === 0,
      accounts: rows.map((r: any) => {
        const tienDo = (r.plays || [])[0] || null;
        return {
          stt: r.stt,
          email: r.email,
          password: r.password,
          serverId: job.serverId,
          serverName: job.serverName,
          roleName: tienDo?.roleName || '',
          level: tienDo?.level || 0,
          inviteCode: tienDo?.inviteCode || '',
          // Chua tung choi tren server nay -> NEW
          status: tienDo?.status || 'NEW',
        };
      }),
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
