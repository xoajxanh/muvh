import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';
import { BO_QUA_LV200, BO_QUA_LV50 } from '@/lib/farm-play';

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
        // Tong = so acc trong kho mac dinh thuoc dai; da xong = tren BANG THEO DOI
        // dung server cua cong viec nay (doc lap voi cac server khac).
        const laLv200 = k.farmLevel === 200;
        const kho: any = laLv200 ? (prisma as any).farmInviter : (prisma as any).farmInvitee;
        const theoDoi: any = laLv200 ? (prisma as any).farmInviterPlay : (prisma as any).farmInviteePlay;
        const loc = { stt: { gte: k.rangeFrom, lte: k.rangeTo } };

        const [tong, daXong] = await Promise.all([
          kho.count({ where: loc }),
          theoDoi.count({
            where: {
              ...loc,
              serverId: k.serverId,
              // xong hoac loi bo qua (SERVER_FULL) deu tinh la da xu ly
              status: { in: laLv200 ? BO_QUA_LV200 : BO_QUA_LV50 },
            },
          }),
        ]);

        const conSong =
          !!k.deviceId &&
          !!k.lastHeartbeat &&
          bayGio - new Date(k.lastHeartbeat).getTime() < HET_HAN_MS;

        // =================================================================
        // [MOD FEATURE]: FARM KC - CO HOAN THANH
        // Da chay het so acc trong dai -> viec coi nhu xong. Mod se to xam
        // nut nay va khong cho bam. Tien the chot luon status = DONE de
        // lan sau khong phai tinh lai.
        // =================================================================
        const hoanThanh = tong > 0 && daXong >= tong;
        if (hoanThanh && k.status !== 'DONE') {
          await (prisma as any).farmAccountRange
            .update({ where: { id: k.id }, data: { status: 'DONE' } })
            .catch(() => {});
        }

        return {
          hoanThanh,
          jobCode: k.jobCode,
          farmLevel: k.farmLevel,
          serverId: k.serverId,
          serverName: k.serverName,
          rangeFrom: k.rangeFrom,
          rangeTo: k.rangeTo,
          cursorStt: k.cursorStt,
          status: hoanThanh ? 'DONE' : k.status,
          tongAcc: tong,
          daXong,
          // May khac dang giu viec nay -> mod canh bao thay vi chay de len
          dangChayOMayKhac: !hoanThanh && conSong && !!deviceId && k.deviceId !== deviceId,
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
