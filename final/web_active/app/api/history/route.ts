import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: API LỊCH SỬ ĐĂNG NHẬP THIẾT BỊ (ADMIN ONLY)
// Mô tả: Truy vấn danh sách thiết bị (distinct MD5) cùng thông tin nhân vật,
//        server, trạng thái và thời gian Last Login.
// =========================================================================

export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) {
    return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  }

  if (session.role !== 'ADMIN') {
    return NextResponse.json({ error: 'Chỉ Quản trị viên (Admin) mới có quyền xem Lịch sử đăng nhập!' }, { status: 403 });
  }

  const { searchParams } = new URL(req.url);
  const typeParam = searchParams.get('type') || searchParams.get('tab') || 'CUSTOMER';
  const targetType = typeParam.toUpperCase() === 'SVIP' ? 'SVIP' : 'CUSTOMER';
  const search = (searchParams.get('search') || '').trim();

  const page = Math.max(1, parseInt(searchParams.get('page') || '1', 10));
  const limit = Math.max(1, parseInt(searchParams.get('limit') || '20', 10));
  const skip = (page - 1) * limit;

  const whereClause: any = {
    type: targetType,
  };

  if (search !== '') {
    whereClause.OR = [
      { deviceSnMd5: { contains: search } },
      { characterName: { contains: search } },
      { characterUid: { contains: search } },
      { serverName: { contains: search } },
    ];
  }

  try {
    // 1. Nhóm theo deviceSnMd5 và lấy thời gian đăng nhập mới nhất
    const groupedDevices = await prisma.deviceLoginHistory.groupBy({
      by: ['deviceSnMd5'],
      where: whereClause,
      _max: { createdAt: true },
      _count: { id: true },
      orderBy: { _max: { createdAt: 'desc' } },
      skip,
      take: limit,
    });

    const totalDevicesCount = await prisma.deviceLoginHistory.groupBy({
      by: ['deviceSnMd5'],
      where: whereClause,
    });
    const total = totalDevicesCount.length;
    const totalPages = Math.ceil(total / limit) || 1;

    // 2. Lấy thông tin bản ghi đăng nhập cuối cùng cho từng thiết bị
    const devices = await Promise.all(
      groupedDevices.map(async (g) => {
        const latestRecord = await prisma.deviceLoginHistory.findFirst({
          where: {
            deviceSnMd5: g.deviceSnMd5,
            type: targetType,
          },
          orderBy: { createdAt: 'desc' },
        });

        // Tìm token tương ứng còn active trên máy này (nếu có)
        const token = await prisma.token.findFirst({
          where: {
            deviceSnMd5: g.deviceSnMd5,
            type: targetType,
            isDeleted: false,
          },
          select: {
            id: true,
            characterUid: true,
            customerName: true,
            expireAt: true,
            isTest: true,
          },
          orderBy: { createdAt: 'desc' },
        });

        return {
          deviceSnMd5: g.deviceSnMd5,
          totalLogins: g._count.id,
          lastLogin: g._max.createdAt,
          characterName: latestRecord?.characterName || 'Chưa xác định',
          characterUid: latestRecord?.characterUid || 'N/A',
          serverName: latestRecord?.serverName || 'Chưa xác định',
          lastStatus: latestRecord?.status || 'UNKNOWN',
          tokenInfo: token,
        };
      })
    );

    return NextResponse.json({
      devices,
      selectedType: targetType,
      pagination: {
        page,
        limit,
        total,
        totalPages,
      },
    });
  } catch (err: any) {
    console.error('[History API] Error fetching history:', err);
    return NextResponse.json({ error: err.message || 'Lỗi server khi tải lịch sử đăng nhập' }, { status: 500 });
  }
}
