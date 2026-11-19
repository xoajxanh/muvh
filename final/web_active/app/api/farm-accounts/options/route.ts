import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - DANH SACH TAI KHOAN + SERVER CHO O LOC
// Mo ta: Tra ve danh sach gon nhe (khong phan trang) de man Farm KC do vao
//        2 o chon: Tai khoan FARM_KC va Server.
//        Danh sach server gom server cua cac tai khoan FARM_KC + server that
//        da thay trong du lieu acc game.
// =========================================================================

export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });

  try {
    const where: any = {};
    if (session.role !== 'ADMIN') where.createdById = session.userId;

    const taiKhoan = await (prisma as any).farmAccount.findMany({
      where,
      orderBy: [{ username: 'asc' }],
      select: {
        id: true,
        username: true,
        status: true,
        ranges: {
          orderBy: [{ farmLevel: 'asc' }, { serverId: 'asc' }, { rangeFrom: 'asc' }],
          select: { jobCode: true, farmLevel: true, serverId: true, serverName: true, rangeFrom: true, rangeTo: true },
        },
      },
    });

    // Gom server: tu cac dong cong viec + tu du lieu acc game that
    const mapServer = new Map<number, string>();
    taiKhoan.forEach((t: any) => {
      (t.ranges || []).forEach((k: any) => {
        if (!mapServer.get(k.serverId)) mapServer.set(k.serverId, k.serverName || '');
      });
    });

    const whereGame: any = {};
    if (session.role !== 'ADMIN') whereGame.createdById = session.userId;

    const [svInviter, svInvitee] = await Promise.all([
      (prisma as any).farmInviterPlay.groupBy({
        by: ['serverId', 'serverName'] as any,
        where: whereGame,
        _count: { _all: true },
      } as any),
      (prisma as any).farmInviteePlay.groupBy({
        by: ['serverId', 'serverName'] as any,
        where: whereGame,
        _count: { _all: true },
      } as any),
    ]);

    [...(svInviter as any[]), ...(svInvitee as any[])].forEach((g) => {
      const ten = mapServer.get(g.serverId);
      if (!ten) mapServer.set(g.serverId, g.serverName || '');
    });

    const server: { serverId: number; serverName: string }[] = [];
    mapServer.forEach((serverName, serverId) => server.push({ serverId, serverName }));
    server.sort((a, b) => a.serverId - b.serverId);

    return NextResponse.json({ taiKhoan, server });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
