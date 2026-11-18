import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';

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

    const [inviters, invitees] = await Promise.all([
      prisma.farmInviter.count({ where }),
      prisma.farmInvitee.count({ where }),
    ]);

    return NextResponse.json({ inviters, invitees });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
