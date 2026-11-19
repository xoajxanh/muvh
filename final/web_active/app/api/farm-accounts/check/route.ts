import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { ensureInitialSeed } from '@/lib/db';
import {
  chuanHoaUsername,
  kiemTraTrung,
  goiYUsername,
  kiemTraChongLan,
  FARM_LEVELS,
} from '@/lib/farm-account';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - CHECK TRUNG USERNAME + GOI Y USERNAME MOI
// Mo ta: Web goi khi nguoi dung roi chuot khoi o username (blur).
//        Tra ve { trung: true/false, goiY: "..." } de hien ngay duoi o nhap.
//        Tien the kiem tra luon khoang STT co chong lan khong (neu gui kem).
// GET /api/farm-accounts/check?username=abc&id=<id-khi-sua>
//     &farmLevel=50&serverId=0&rangeFrom=1&rangeTo=500
// =========================================================================

export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });

  try {
    const { searchParams } = new URL(req.url);
    const raw = searchParams.get('username') || '';
    const username = chuanHoaUsername(raw);
    const boQuaId = (searchParams.get('id') || '').trim() || undefined;

    const kq: any = { username, hopLe: !!username };

    if (!username) {
      kq.loi = 'Username chỉ nhận chữ thường, số và . _ -';
    } else {
      const trung = await kiemTraTrung(username, boQuaId);
      kq.trung = !!trung;
      if (trung) kq.goiY = await goiYUsername(username);
    }

    // Kiem tra chong lan khoang STT neu client gui du tham so
    const farmLevel = parseInt(searchParams.get('farmLevel') || '', 10);
    const serverId = parseInt(searchParams.get('serverId') || '0', 10) || 0;
    const rangeFrom = parseInt(searchParams.get('rangeFrom') || '', 10);
    const rangeTo = parseInt(searchParams.get('rangeTo') || '', 10);

    if (
      FARM_LEVELS.includes(farmLevel) &&
      Number.isFinite(rangeFrom) &&
      Number.isFinite(rangeTo) &&
      rangeFrom >= 1 &&
      rangeTo >= rangeFrom
    ) {
      const chongLan = await kiemTraChongLan({ farmLevel, serverId, rangeFrom, rangeTo, boQuaId });
      kq.chongLan = chongLan
        ? {
            username: chongLan.username,
            farmLevel: chongLan.farmLevel,
            rangeFrom: chongLan.rangeFrom,
            rangeTo: chongLan.rangeTo,
          }
        : null;
    }

    return NextResponse.json(kq);
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
