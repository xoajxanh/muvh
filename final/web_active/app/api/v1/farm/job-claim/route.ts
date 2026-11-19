import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - KHOA NHIEU CONG VIEC CUNG LUC
// Mo ta: Mot may co the chon nhieu viec roi chay tuan tu. De may khac khong
//        chay de len, khoa HET cac viec do ngay luc chon, chu khong doi toi
//        luot tung viec.
//        - Viec dang co nhip tim cua may KHAC   -> tu choi, bao ten may do
//        - Viec da DONE                          -> tu choi, khong cho nhan
//        - Con lai                               -> ghi deviceId + nhip tim
//        Khoa tu nha khi may tat qua 5 phut khong gui nhip tim.
//
// POST /api/v1/farm/job-claim
// Body: { jobCodes: string[], deviceId, deviceName, ts, sign }
// Ky: sign = MD5(jobCodes.join(",") + deviceId + ts + SALT)
// =========================================================================

const HET_HAN_MS = 5 * 60 * 1000;

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();

    const jobCodes: string[] = Array.isArray(body.jobCodes)
      ? body.jobCodes.map((x: any) => String(x || '').trim()).filter(Boolean)
      : [];
    const deviceId = String(body.deviceId || '').trim();
    const deviceName = String(body.deviceName || '').trim();
    const ts = body.ts;
    const sign = String(body.sign || '');

    if (jobCodes.length === 0) {
      return NextResponse.json({ ok: false, error: 'Thiếu jobCodes' }, { status: 400 });
    }
    if (!deviceId) {
      return NextResponse.json({ ok: false, error: 'Thiếu deviceId' }, { status: 400 });
    }

    const tsNum = Number(ts);
    if (!Number.isFinite(tsNum) || Math.abs(Math.floor(Date.now() / 1000) - tsNum) > MAX_TS_SKEW_SECONDS) {
      return NextResponse.json({ ok: false, error: 'Request hết hạn hoặc ts không hợp lệ' }, { status: 401 });
    }
    if (buildSign([jobCodes.join(','), deviceId], ts).toLowerCase() !== sign.toLowerCase()) {
      return NextResponse.json({ ok: false, error: 'Chữ ký không hợp lệ' }, { status: 401 });
    }

    const bayGio = new Date();
    const khoaDuoc: string[] = [];
    const tuChoi: { jobCode: string; lyDo: string; deviceName?: string }[] = [];

    for (const jobCode of jobCodes) {
      const job = await (prisma as any).farmAccountRange.findUnique({ where: { jobCode } });
      if (!job) {
        tuChoi.push({ jobCode, lyDo: 'Không tìm thấy công việc' });
        continue;
      }
      if (job.status === 'DONE') {
        tuChoi.push({ jobCode, lyDo: 'Công việc đã hoàn thành' });
        continue;
      }

      const conSong =
        !!job.deviceId &&
        !!job.lastHeartbeat &&
        bayGio.getTime() - new Date(job.lastHeartbeat).getTime() < HET_HAN_MS;

      if (conSong && job.deviceId !== deviceId) {
        tuChoi.push({
          jobCode,
          lyDo: 'Đang chạy ở máy khác',
          deviceName: job.deviceName || '',
        });
        continue;
      }

      await (prisma as any).farmAccountRange.update({
        where: { id: job.id },
        data: {
          deviceId,
          deviceName: deviceName || job.deviceName || '',
          lastHeartbeat: bayGio,
          status: job.status === 'NEW' ? 'RUNNING' : job.status,
        },
      });
      khoaDuoc.push(jobCode);
    }

    return NextResponse.json({
      ok: true,
      soKhoaDuoc: khoaDuoc.length,
      khoaDuoc,
      tuChoi,
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
