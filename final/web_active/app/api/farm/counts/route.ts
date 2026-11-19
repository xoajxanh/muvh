import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { demPhanBo } from '@/lib/farm-play';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - DEM SO LUONG 2 BANG (hien tren tab)
// Mô tả: Trả về số dòng của cả 2 bảng cùng lúc, có áp bộ lọc theo người tạo
//        giống 2 API danh sách.
// =========================================================================

export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) {
    return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  }

  try {
    const where: any = {};
    if (session.role !== 'ADMIN') where.createdById = session.userId;

    // =====================================================================
    // [MOD FEATURE]: SO TREN TAB PHAI KHOP VOI DANH SACH DANG XEM
    //   - Dang xem theo tai khoan Farm KC -> dem PHAN BO (dai STT x server),
    //     ke ca acc chua chay - dung y nhu danh sach.
    //   - Khong chon tai khoan -> dem dong THEO DOI (acc da chay), co loc server.
    //   - Kho mac dinh -> tong so acc trong kho.
    // =====================================================================
    const { searchParams } = new URL(req.url);
    const farmUser = (searchParams.get('username') || '').trim();
    const sidRaw = (searchParams.get('serverId') || '').trim();
    const sid = sidRaw === '' ? NaN : parseInt(sidRaw, 10);
    const coServer = Number.isFinite(sid);

    const whereTheoDoi: any = { ...where };
    if (coServer) whereTheoDoi.serverId = sid;

    const [inviters, invitees, khoInviters, khoInvitees] = await Promise.all([
      farmUser
        ? demPhanBo(200, farmUser, coServer ? sid : null)
        : (prisma as any).farmInviterPlay.count({ where: whereTheoDoi }),
      farmUser
        ? demPhanBo(50, farmUser, coServer ? sid : null)
        : (prisma as any).farmInviteePlay.count({ where: whereTheoDoi }),
      prisma.farmInviter.count(),
      prisma.farmInvitee.count(),
    ]);

    return NextResponse.json({ inviters, invitees, khoInviters, khoInvitees });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
