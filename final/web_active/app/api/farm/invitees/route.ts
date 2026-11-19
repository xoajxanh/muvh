import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { layDanhSachPhanBo, XONG_LV50 } from '@/lib/farm-play';

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

    const [totalGoc, rowsGoc] = await Promise.all([
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

    // =====================================================================
    // [MOD FEATURE]: XEM THEO TAI KHOAN FARM_KC = DU SO ACC DUOC PHAN BO
    // Mo ta: Bang theo doi chi co dong khi acc da chay. Xem theo tai khoan thi
    //        lay tu kho theo dai STT x server cua cac cong viec, acc chua chay
    //        hien thanh dong trang thai NEW - de thay dung 100/100 duoc giao.
    // =====================================================================
    let total = totalGoc;
    let rows: any[] = rowsGoc as any[];
    let soDuocGiao = 0;
    if (farmUser) {
      const sidLoc = serverIdRaw ? parseInt(serverIdRaw, 10) : NaN;
      const phanBo = await layDanhSachPhanBo({
        farmLevel: 50,
        farmUser,
        serverId: Number.isFinite(sidLoc) ? sidLoc : null,
        keyword,
        status,
        sortBy,
        sortDir,
        skip: (page - 1) * pageSize,
        take: pageSize,
      });
      total = phanBo.total;
      rows = phanBo.rows;
      soDuocGiao = phanBo.total;
    }

    // =====================================================================
    // [MOD FEATURE]: TONG HOP ACC 50 (da xong / chua xong / theo trang thai)
    // Mo ta: Tinh tren TOAN BO danh sach dang xem (khong chi trang hien tai),
    //        THEO DUNG bo loc: tai khoan, server, o tim kiem. Rieng chip trang
    //        thai thi bo qua de bang phan ra theo trang thai luon day du.
    //        Da xong = SUCCESS + ALREADY_USED (deu da co ma gioi thieu).
    //        Xem theo tai khoan: "Chua chay" = duoc giao - da co dong theo doi.
    // =====================================================================
    const whereTongHop: any = { ...where };
    delete whereTongHop.status;
    const nhomTrangThai: any[] = await theoDoi.groupBy({
      by: ['status'],
      where: whereTongHop,
      _count: { _all: true },
    });
    const theoTrangThai: Record<string, number> = {};
    let daChoi = 0;
    for (const g of nhomTrangThai) {
      const n = Number(g?._count?._all || 0);
      theoTrangThai[String(g.status)] = n;
      daChoi += n;
    }

    let tongTk = daChoi;
    let chuaChay = 0;
    if (farmUser) {
      const sidTk = serverIdRaw ? parseInt(serverIdRaw, 10) : NaN;
      // Dung cung bo loc voi danh sach (tai khoan + server + o tim kiem)
      tongTk = (await layDanhSachPhanBo({
        farmLevel: 50, farmUser,
        serverId: Number.isFinite(sidTk) ? sidTk : null,
        keyword, status: '', skip: 0, take: 0,
      })).total;
      chuaChay = Math.max(0, tongTk - daChoi);
    }
    const daXongTk = XONG_LV50.reduce((t, st) => t + (theoTrangThai[st] || 0), 0);
    const thongKe50 = {
      tong: tongTk,
      daXong: daXongTk,
      chuaXong: Math.max(0, tongTk - daXongTk),
      chuaChay,
      theoTrangThai,
    };

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
      // Acc da duoc giao nhung chua chay lan nao tren server nay
      chuaChay: !!r.chuaChay,
      createdBy: r.createdBy?.displayName || r.createdBy?.username || '',
      updatedAt: r.updatedAt,
    }));

    return NextResponse.json({
      items,
      page,
      pageSize,
      total,
      totalPages: Math.max(1, Math.ceil(total / pageSize)),
      soDuocGiao,
      thongKe50,
      sortBy,
      sortDir,
      isAdmin: session.role === 'ADMIN',
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
