import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - NHIP TIM + CON TRO CHAY CUA MOT CONG VIEC
// Mo ta: Mod goi dinh ky (vd moi 60s hoac sau moi acc) de:
//          - bao web la gia lap nay van dang giu cong viec
//          - ghi lai STT dang chay toi, de mo lai la chay tiep duoc
//          - bao da chay het khoang (status = DONE)
//
// POST /api/v1/farm/job-heartbeat
// Body: { jobCode, deviceId, deviceName, cursorStt, status, ts, sign }
// Ky: sign = MD5(jobCode + cursorStt + ts + SALT)
// =========================================================================

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();
    const jobCode = String(body.jobCode || '').trim();
    const deviceId = String(body.deviceId || '').trim();
    const deviceName = String(body.deviceName || '').trim();
    const cursorStt = parseInt(String(body.cursorStt ?? 0), 10) || 0;
    const trangThai = String(body.status || '').trim().toUpperCase();
    const ts = body.ts;
    const sign = String(body.sign || '');

    if (!jobCode) return NextResponse.json({ ok: false, error: 'Thiếu jobCode' }, { status: 400 });

    const tsNum = Number(ts);
    if (!Number.isFinite(tsNum) || Math.abs(Math.floor(Date.now() / 1000) - tsNum) > MAX_TS_SKEW_SECONDS) {
      return NextResponse.json({ ok: false, error: 'Request hết hạn hoặc ts không hợp lệ' }, { status: 401 });
    }
    if (buildSign([jobCode, cursorStt], ts).toLowerCase() !== sign.toLowerCase()) {
      return NextResponse.json({ ok: false, error: 'Chữ ký không hợp lệ' }, { status: 401 });
    }

    const job = await (prisma as any).farmAccountRange.findUnique({ where: { jobCode } });
    if (!job) {
      return NextResponse.json({ ok: false, error: 'Không tìm thấy công việc' }, { status: 404 });
    }

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
          error: `Công việc đang chạy ở máy khác${job.deviceName ? ` (${job.deviceName})` : ''}`,
        },
        { status: 409 },
      );
    }

    const data: any = { lastHeartbeat: bayGio };
    if (deviceId) data.deviceId = deviceId;
    if (deviceName) data.deviceName = deviceName;
    if (cursorStt > 0) data.cursorStt = cursorStt;
    if (['RUNNING', 'PAUSED', 'DONE'].includes(trangThai)) data.status = trangThai;

    await (prisma as any).farmAccountRange.update({ where: { id: job.id }, data });
    await (prisma as any).farmAccount.update({
      where: { id: job.farmAccountId },
      data: { lastSyncAt: bayGio },
    });

    return NextResponse.json({ ok: true });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
