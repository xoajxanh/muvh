import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API DANH SACH ACC LV50 CHO WEB
// Mô tả: Phân trang phía server. Non-ADMIN chỉ thấy dữ liệu của chính mình.
//        Kèm email của acc Lv200 đã mời (inviter).
// =========================================================================

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
    const showPassword = searchParams.get('showPassword') === '1' && session.role === 'ADMIN';

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

    const [total, rows] = await Promise.all([
      prisma.farmInvitee.count({ where }),
      prisma.farmInvitee.findMany({
        where,
        // Nhóm các acc cùng một người mời nằm cạnh nhau để tô màu xen kẽ dễ nhìn
        orderBy: [{ inviterId: 'asc' }, { updatedAt: 'desc' }],
        skip: (page - 1) * pageSize,
        take: pageSize,
        include: {
          createdBy: { select: { username: true, displayName: true } },
          inviter: { select: { email: true, inviteCode: true } },
        },
      }),
    ]);

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
      inviterEmail: r.inviter?.email || '',
      status: r.status,
      deviceId: r.deviceId,
      reservedAt: r.reservedAt,
      expireAt: r.expireAt,
      confirmedAt: r.confirmedAt,
      errorMsg: r.errorMsg,
      createdBy: r.createdBy?.displayName || r.createdBy?.username || '',
      updatedAt: r.updatedAt,
    }));

    return NextResponse.json({
      items,
      page,
      pageSize,
      total,
      totalPages: Math.max(1, Math.ceil(total / pageSize)),
      isAdmin: session.role === 'ADMIN',
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
