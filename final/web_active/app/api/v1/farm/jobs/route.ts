import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API LAY CONG VIEC CUA MOT TAI KHOAN FARM_KC
// Mo ta: Mod goi ngay sau khi nguoi dung bam KIEM TRA DANG NHAP.
//        Web tra ve danh sach cong viec (block) duoc giao cho tai khoan do,
//        kem tien do, de mod tu dien Dai Acc STT va to sang server.
//        - Mot viec  -> mod tu chon luon
//        - Nhieu viec -> mod hien danh sach cho nguoi dung bam chon
//
// GET /api/v1/farm/jobs?username=longdt&password=...&deviceId=...&ts=..&sign=..
// Ky: sign = MD5(username + password + ts + SALT)
// =========================================================================

export async function GET(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const { searchParams } = new URL(req.url);
    const username = (searchParams.get('username') || '').trim().toLowerCase();
    const password = (searchParams.get('password') || '').trim();
    const deviceId = (searchParams.get('deviceId') || '').trim();
    const ts = searchParams.get('ts');
    const sign = searchParams.get('sign');

    if (!username || !password) {
      return NextResponse.json({ ok: false, error: 'Thiếu username hoặc password' }, { status: 400 });
    }
    if (!ts || !sign) {
      return NextResponse.json({ ok: false, error: 'Thiếu tham số ts hoặc sign' }, { status: 400 });
    }

    const tsNum = Number(ts);
    if (!Number.isFinite(tsNum)) {
      return NextResponse.json({ ok: false, error: 'ts không hợp lệ' }, { status: 400 });
    }
    const nowSec = Math.floor(Date.now() / 1000);
    if (Math.abs(nowSec - tsNum) > MAX_TS_SKEW_SECONDS) {
      return NextResponse.json({ ok: false, error: 'Request hết hạn (lệch giờ quá 300s)' }, { status: 401 });
    }
    if (buildSign([username, password], ts).toLowerCase() !== String(sign).toLowerCase()) {
      return NextResponse.json({ ok: false, error: 'Chữ ký không hợp lệ' }, { status: 401 });
    }

    const acc = await (prisma as any).farmAccount.findUnique({
      where: { username },
      include: {
        ranges: { orderBy: [{ farmLevel: 'asc' }, { serverId: 'asc' }] },
      },
    });

    if (!acc) {
      return NextResponse.json({ ok: false, error: 'Tài khoản không tồn tại' }, { status: 404 });
    }
    if (acc.password !== password) {
      return NextResponse.json({ ok: false, error: 'Sai mật khẩu' }, { status: 401 });
    }

    const HET_HAN_MS = 5 * 60 * 1000; // qua 5 phut khong co nhip tim coi nhu may kia da tat
    const bayGio = Date.now();

    const jobs = await Promise.all(
      (acc.ranges || []).map(async (k: any) => {
        const bang: any = k.farmLevel === 200 ? prisma.farmInviter : prisma.farmInvitee;
        const loc = { stt: { gte: k.rangeFrom, lte: k.rangeTo } };

        const [tong, daXong] = await Promise.all([
          bang.count({ where: loc }),
          bang.count({
            where: {
              ...loc,
              status: k.farmLevel === 200 ? { in: ['DONE', 'INVITED'] } : { in: ['SUCCESS', 'ALREADY_USED'] },
            },
          }),
        ]);

        const conSong =
          !!k.deviceId &&
          !!k.lastHeartbeat &&
          bayGio - new Date(k.lastHeartbeat).getTime() < HET_HAN_MS;

        return {
          jobCode: k.jobCode,
          farmLevel: k.farmLevel,
          serverId: k.serverId,
          serverName: k.serverName,
          rangeFrom: k.rangeFrom,
          rangeTo: k.rangeTo,
          cursorStt: k.cursorStt,
          status: k.status,
          tongAcc: tong,
          daXong,
          // May khac dang giu viec nay -> mod canh bao thay vi chay de len
          dangChayOMayKhac: conSong && !!deviceId && k.deviceId !== deviceId,
          deviceName: conSong ? k.deviceName || '' : '',
        };
      }),
    );

    return NextResponse.json({
      ok: true,
      username: acc.username,
      status: acc.status,
      note: acc.note || '',
      soViec: jobs.length,
      jobs,
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
