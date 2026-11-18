import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { safeNum } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API DANH SACH ACC LV200 CHO WEB
// Mô tả: Phân trang phía server. Non-ADMIN chỉ thấy dữ liệu do chính mình tạo
//        (theo createdById); ADMIN xem tất cả.
//        Mật khẩu acc game CHỈ trả về khi ADMIN yêu cầu (showPassword=1).
// =========================================================================


// =========================================================================
// [MOD FEATURE]: FARM KC - SAP XEP THEO TUNG COT (tang / giam)
// Mô tả: Chỉ cho sắp xếp theo các cột có trong danh sách trắng bên dưới.
//        Mặc định sắp xếp Email giảm dần.
// =========================================================================
function buildOrderBy(sortBy: string, dir: 'asc' | 'desc'): any {
  switch (sortBy) {
    case 'email': return [{ email: dir }];
    case 'password': return [{ password: dir }];
    case 'serverName': return [{ serverName: dir }, { serverId: dir }];
    case 'roleName': return [{ roleName: dir }];
    case 'level': return [{ level: dir }];
    case 'inviteCode': return [{ inviteCode: dir }];
    // usedCount = gameInviteNum + confirmedCount (khong sort truc tiep duoc)
    case 'usedCount': return [{ gameInviteNum: dir }, { confirmedCount: dir }];
    case 'unboundGold': return [{ unboundGold: dir }];
    case 'unboundDiamond': return [{ unboundDiamond: dir }];
    case 'goldVoucher': return [{ goldVoucher: dir }];
    case 'status': return [{ status: dir }];
    case 'time': return [{ updatedAt: dir }];
    case 'createdBy': return [{ createdBy: { username: dir } }];
    default: return [{ email: 'desc' }];
  }
}

export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) {
    return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  }

  try {
    const { searchParams } = new URL(req.url);
    const page = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const pageSizeRaw = parseInt(searchParams.get('pageSize') || '20', 10) || 20;
    const pageSize = Math.min(100, Math.max(5, pageSizeRaw));
    const keyword = (searchParams.get('q') || '').trim();
    const status = (searchParams.get('status') || '').trim();
    const serverIdRaw = (searchParams.get('serverId') || '').trim();
    // ADMIN luon nhan mat khau; web tu che bang dau sao, bam mat moi hien
    const showPassword = session.role === 'ADMIN';
    const sortBy = (searchParams.get('sortBy') || 'email').trim();
    const sortDir: 'asc' | 'desc' = searchParams.get('sortDir') === 'asc' ? 'asc' : 'desc';

    const where: any = {};
    if (session.role !== 'ADMIN') where.createdById = session.userId;
    if (status) where.status = status;
    if (serverIdRaw) {
      const sid = parseInt(serverIdRaw, 10);
      if (Number.isFinite(sid)) where.serverId = sid;
    }
    if (keyword) {
      where.OR = [
        { email: { contains: keyword } },
        { roleName: { contains: keyword } },
        { inviteCode: { contains: keyword } },
      ];
    }

    const [total, rows, agg] = await Promise.all([
      prisma.farmInviter.count({ where }),
      prisma.farmInviter.findMany({
        where,
        orderBy: buildOrderBy(sortBy, sortDir),
        skip: (page - 1) * pageSize,
        take: pageSize,
        include: { createdBy: { select: { username: true, displayName: true } } },
      }),
      // [MOD FEATURE]: TONG HOP TOAN BO (theo dung bo loc dang xem, khong chi trang hien tai)
      prisma.farmInviter.aggregate({
        where,
        _sum: {
          unboundGold: true,
          unboundDiamond: true,
          goldVoucher: true,
          gameInviteNum: true,
          confirmedCount: true,
          reservedCount: true,
        } as any,
      }),
    ]);

    const sum: any = (agg as any)?._sum || {};
    const totals = {
      unboundGold: safeNum(sum.unboundGold),
      unboundDiamond: safeNum(sum.unboundDiamond),
      goldVoucher: safeNum(sum.goldVoucher),
      usedCount: safeNum(sum.gameInviteNum) + safeNum(sum.confirmedCount),
      reservedCount: safeNum(sum.reservedCount),
    };

    const items = rows.map((r) => ({
      id: r.id,
      email: r.email,
      password: showPassword ? r.password : null,
      serverId: r.serverId,
      serverName: r.serverName,
      roleId: r.roleId,
      roleName: r.roleName,
      level: r.level,
      inviteCode: r.inviteCode,
      gameInviteNum: r.gameInviteNum,
      confirmedCount: r.confirmedCount,
      reservedCount: r.reservedCount,
      maxInvites: r.maxInvites,
      // Tổng đã dùng = mốc game báo lần cuối + phần web cấp thêm sau đó
      usedCount: r.gameInviteNum + r.confirmedCount,
      unboundGold: safeNum(r.unboundGold),
      unboundDiamond: safeNum(r.unboundDiamond),
      goldVoucher: safeNum(r.goldVoucher),
      status: r.status,
      failCount: r.failCount,
      lastError: r.lastError,
      lastSyncAt: r.lastSyncAt,
      createdBy: r.createdBy?.displayName || r.createdBy?.username || '',
      updatedAt: r.updatedAt,
    }));

    return NextResponse.json({
      items,
      page,
      pageSize,
      total,
      totalPages: Math.max(1, Math.ceil(total / pageSize)),
      totals,
      sortBy,
      sortDir,
      isAdmin: session.role === 'ADMIN',
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
