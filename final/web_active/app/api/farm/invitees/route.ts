import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API DANH SACH ACC LV50 CHO WEB
// Mô tả: Phân trang phía server. Non-ADMIN chỉ thấy dữ liệu của chính mình.
//        Kèm email của acc Lv200 đã mời (inviter).
// =========================================================================


// =========================================================================
// [MOD FEATURE]: FARM KC - SAP XEP THEO TUNG COT (tang / giam)
// =========================================================================
function buildOrderBy(sortBy: string, dir: 'asc' | 'desc'): any {
  switch (sortBy) {
    case 'stt': return [{ stt: dir }];
    case 'email': return [{ email: dir }];
    case 'password': return [{ password: dir }];
    case 'serverName': return [{ serverName: dir }, { serverId: dir }];
    case 'roleName': return [{ roleName: dir }];
    case 'level': return [{ level: dir }];
    case 'inviteCode': return [{ inviteCode: dir }];
    case 'inviterEmail': return [{ inviter: { email: dir } }, { updatedAt: 'desc' }];
    case 'errorMsg': return [{ errorMsg: dir }];
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

    // [MOD FEATURE]: loc theo tai khoan FARM_KC (nut "Xem cong viec")
    const farmUser = (searchParams.get('username') || '').trim();

    // [MOD FEATURE]: TIEN DO doc tu BANG THEO DOI (acc x server x nguoi choi).
    // Kho mac dinh FarmInviter / FarmInvitee chi dung o che do mode=kho.
    const theoDoi: any = (prisma as any).farmInviteePlay;

    // =====================================================================
    // [MOD FEATURE]: CHE DO "KHO MAC DINH" (mode=kho)
    // Mo ta: Xem danh sach acc goc trong kho - chi de doi chieu. Moi dong kem
    //        acc nay DANG CHOI tren nhung server nao, boi ai, trang thai gi.
    // =====================================================================
    if (searchParams.get('mode') === 'kho') {
      const kho: any = (prisma as any).farmInvitee;
      const whereKho: any = {};
      if (keyword) whereKho.email = { contains: keyword };
      const sttTu = parseInt(searchParams.get('sttFrom') || '', 10);
      const sttDen = parseInt(searchParams.get('sttTo') || '', 10);
      if (Number.isFinite(sttTu) || Number.isFinite(sttDen)) {
        whereKho.stt = {
          ...(Number.isFinite(sttTu) ? { gte: sttTu } : {}),
          ...(Number.isFinite(sttDen) ? { lte: sttDen } : {}),
        };
      }
      const chieu: 'asc' | 'desc' = sortDir;
      const orderKho = sortBy === 'email' ? [{ email: chieu }] : [{ stt: chieu }];

      const [totalKho, rowsKho] = await Promise.all([
        kho.count({ where: whereKho }),
        kho.findMany({
          where: whereKho,
          orderBy: orderKho,
          skip: (page - 1) * pageSize,
          take: pageSize,
          select: {
            id: true, stt: true, email: true, password: true, uid: true,
            regIp: true, regAt: true, importBatch: true, updatedAt: true,
            plays: {
              orderBy: { serverId: 'asc' },
              select: {
                serverId: true, serverName: true, status: true, roleName: true, level: true,
                farmAccount: { select: { username: true } },
              },
            },
          },
        }),
      ]);

      return NextResponse.json({
        mode: 'kho',
        items: (rowsKho as any[]).map((r) => ({
          id: r.id,
          stt: r.stt,
          email: r.email,
          password: showPassword ? r.password : null,
          uid: r.uid,
          regIp: r.regIp,
          regAt: r.regAt,
          importBatch: r.importBatch,
          soServer: (r.plays || []).length,
          dangChoi: (r.plays || []).map((p: any) => ({
            serverId: p.serverId,
            serverName: p.serverName,
            status: p.status,
            roleName: p.roleName,
            level: p.level,
            nguoiChoi: p.farmAccount?.username || '',
          })),
          updatedAt: r.updatedAt,
        })),
        page,
        pageSize,
        total: totalKho,
        totalPages: Math.max(1, Math.ceil(totalKho / pageSize)),
        sortBy,
        sortDir,
        isAdmin: session.role === 'ADMIN',
      });
    }

    const where: any = {};
    if (session.role !== 'ADMIN') where.createdById = session.userId;
    // =====================================================================
    // [MOD FEATURE]: LOC THEO TAI KHOAN FARM_KC = CA DAI STT DUOC GIAO
    // Mo ta: Truoc day chi loc theo farmAccountId -> chi thay acc DA PHAT cho
    //        bot (16 dong), trong khi dai duoc giao la 100 acc. Gio lay theo
    //        KHOANG STT cua cac cong viec Lv50 cua tai khoan do, cong them
    //        nhung acc da gan truc tiep vao tai khoan.
    // =====================================================================
    if (farmUser) {
      const tk = await (prisma as any).farmAccount.findUnique({
        where: { username: farmUser },
        select: { id: true, ranges: { where: { farmLevel: 50 }, select: { rangeFrom: true, rangeTo: true, serverId: true } } },
      });

      if (!tk) {
        // Khong co tai khoan nay -> khong tra ve dong nao
        where.id = '__khong_ton_tai__';
      } else {
        const dieuKien: any[] = [{ farmAccountId: tk.id }];
        for (const k of tk.ranges || []) {
          dieuKien.push({ serverId: k.serverId, stt: { gte: k.rangeFrom, lte: k.rangeTo } });
        }
        where.AND = [...(where.AND || []), { OR: dieuKien }];
      }
    }
    if (status) where.status = status;
    if (serverIdRaw) {
      const sid = parseInt(serverIdRaw, 10);
      if (Number.isFinite(sid)) where.serverId = sid;
    }
    if (keyword) {
      where.AND = [...(where.AND || []), { OR: [
        { email: { contains: keyword } },
        { roleName: { contains: keyword } },
        { inviteCode: { contains: keyword } },
      ] }];
    }

    const [total, rows] = await Promise.all([
      theoDoi.count({ where }),
      theoDoi.findMany({
        where,
        orderBy: buildOrderBy(sortBy, sortDir),
        skip: (page - 1) * pageSize,
        take: pageSize,
        include: {
          createdBy: { select: { username: true, displayName: true } },
          inviter: { select: { email: true, inviteCode: true } },
          farmAccount: { select: { username: true } },
        },
      }),
    ]);

    const items = (rows as any[]).map((r: any) => ({
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
      stt: (r as any).stt ?? 0,
      farmUsername: (r as any).farmAccount?.username || '',
      createdBy: r.createdBy?.displayName || r.createdBy?.username || '',
      updatedAt: r.updatedAt,
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
