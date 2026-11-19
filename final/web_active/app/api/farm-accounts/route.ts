import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';
import {
  chuanHoaUsername,
  chuanHoaCongViec,
  kiemTraTrung,
  kiemTraChongLanNhieu,
  jobCodeChuaDung,
  buildOrderByFarmAccount,
} from '@/lib/farm-account';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API QUAN LY TAI KHOAN FARM_KC
// Mo ta: GET  = danh sach (phan trang, tim kiem, sap xep theo cot)
//        POST = them moi (check trung username + chong lan khoang STT)
//        Chi ADMIN moi duoc them; nguoi thuong chi xem phan minh tao.
// =========================================================================

export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });

  try {
    const { searchParams } = new URL(req.url);
    const page = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const pageSizeRaw = parseInt(searchParams.get('pageSize') || '20', 10) || 20;
    const pageSize = Math.min(100, Math.max(5, pageSizeRaw));
    const keyword = (searchParams.get('q') || '').trim();
    const status = (searchParams.get('status') || '').trim();
    const farmLevelRaw = (searchParams.get('farmLevel') || '').trim();
    const serverIdRaw = (searchParams.get('serverId') || '').trim();
    const sortBy = (searchParams.get('sortBy') || 'username').trim();
    const sortDir: 'asc' | 'desc' = searchParams.get('sortDir') === 'asc' ? 'asc' : 'desc';

    const where: any = {};
    if (session.role !== 'ADMIN') where.createdById = session.userId;
    if (status) where.status = status;
    // Loc theo level / server -> soi vao cac dong cong viec
    const locDong: any = {};
    const lv = parseInt(farmLevelRaw, 10);
    if (Number.isFinite(lv)) locDong.farmLevel = lv;
    const sv = parseInt(serverIdRaw, 10);
    if (serverIdRaw !== '' && Number.isFinite(sv)) locDong.serverId = sv;
    if (Object.keys(locDong).length > 0) where.ranges = { some: locDong };
    if (keyword) {
      where.OR = [
        { username: { contains: keyword } },
        { serverName: { contains: keyword } },
        { note: { contains: keyword } },
      ];
    }

    const [total, rows] = await Promise.all([
      (prisma as any).farmAccount.count({ where }),
      (prisma as any).farmAccount.findMany({
        where,
        orderBy: buildOrderByFarmAccount(sortBy, sortDir),
        skip: (page - 1) * pageSize,
        take: pageSize,
        include: {
          createdBy: { select: { username: true, displayName: true } },
          ranges: { orderBy: [{ farmLevel: 'asc' }, { serverId: 'asc' }, { rangeFrom: 'asc' }] },
        },
      }),
    ]);

    // Dem so acc game da gan cho tung tai khoan FARM_KC
    const ids = rows.map((r: any) => r.id);
    const demInviter = new Map<string, number>();
    const demInvitee = new Map<string, number>();
    if (ids.length) {
      const [gi, gv] = await Promise.all([
        prisma.farmInviter.groupBy({
          by: ['farmAccountId'] as any,
          where: { farmAccountId: { in: ids } } as any,
          _count: { _all: true },
        } as any),
        prisma.farmInvitee.groupBy({
          by: ['farmAccountId'] as any,
          where: { farmAccountId: { in: ids } } as any,
          _count: { _all: true },
        } as any),
      ]);
      (gi as any[]).forEach((g) => demInviter.set(g.farmAccountId, g._count._all));
      (gv as any[]).forEach((g) => demInvitee.set(g.farmAccountId, g._count._all));
    }

    const items = rows.map((r: any) => ({
      id: r.id,
      username: r.username,
      password: session.role === 'ADMIN' ? r.password : null,
      // Moi dong = level + server + khoang STT
      ranges: (r.ranges || []).map((k: any) => ({
        id: k.id,
        jobCode: k.jobCode,
        farmLevel: k.farmLevel,
        serverId: k.serverId,
        serverName: k.serverName,
        rangeFrom: k.rangeFrom,
        rangeTo: k.rangeTo,
        soAcc: Math.max(0, (k.rangeTo || 0) - (k.rangeFrom || 0) + 1),
        status: k.status,
        deviceId: k.deviceId,
        deviceName: k.deviceName,
        lastHeartbeat: k.lastHeartbeat,
        cursorStt: k.cursorStt,
      })),
      soAcc: (r.ranges || []).reduce(
        (t: number, k: any) => t + Math.max(0, (k.rangeTo || 0) - (k.rangeFrom || 0) + 1),
        0,
      ),
      daGan: (demInviter.get(r.id) || 0) + (demInvitee.get(r.id) || 0),
      note: r.note,
      status: r.status,
      lastSyncAt: r.lastSyncAt,
      createdBy: r.createdBy?.displayName || r.createdBy?.username || '',
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      // Chi ban ghi CHUA chay moi cho sua
      choPhepSua: r.status === 'NEW',
    }));

    return NextResponse.json({
      items,
      page,
      pageSize,
      total,
      totalPages: Math.max(1, Math.ceil(total / pageSize)),
      sortBy,
      sortDir,
      isAdmin: session.role === 'ADMIN',
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  if (session.role !== 'ADMIN') {
    return NextResponse.json({ error: 'Chỉ ADMIN được thêm tài khoản FARM_KC' }, { status: 403 });
  }

  try {
    const body = await req.json();
    const username = chuanHoaUsername(body.username);
    const password = String(body.password || '').trim();
    const note = String(body.note || '').trim() || null;

    if (!username) return NextResponse.json({ error: 'Chưa nhập username' }, { status: 400 });
    if (!password) return NextResponse.json({ error: 'Chưa nhập mật khẩu' }, { status: 400 });

    const kq = chuanHoaCongViec(body.ranges);
    if (!kq.ok) return NextResponse.json({ error: kq.loi }, { status: 400 });

    const trung = await kiemTraTrung(username);
    if (trung) {
      return NextResponse.json({ error: `Username "${username}" đã tồn tại` }, { status: 409 });
    }

    const chongLan = await kiemTraChongLanNhieu({ ds: kq.ds });
    if (chongLan) {
      return NextResponse.json(
        {
          error: `Lv${chongLan.farmLevel} · server ${chongLan.serverId}: khoảng STT bị chồng lấn với tài khoản "${chongLan.username}" (${chongLan.rangeFrom}–${chongLan.rangeTo})`,
        },
        { status: 409 },
      );
    }

    const row = await (prisma as any).farmAccount.create({
      data: {
        username,
        password,
        note,
        status: 'NEW',
        createdById: session.userId,
        ranges: { create: await Promise.all(
          kq.ds.map(async (k) => ({
            ...k,
            jobCode: await jobCodeChuaDung(username, k.serverId, k.farmLevel),
            status: 'NEW',
          })),
        ) },
      },
    });

    return NextResponse.json({ ok: true, id: row.id, username: row.username });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
