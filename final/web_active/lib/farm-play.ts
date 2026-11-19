import { prisma } from './db';

// =========================================================================
// [MOD FEATURE]: FARM KC - TIEN ICH BANG THEO DOI (acc game x server x nguoi choi)
// Mo ta: FarmInviter / FarmInvitee la KHO MAC DINH, chi de doi chieu, KHONG
//        bao gio bi ghi tien do. Tien do nam o FarmInviterPlay / FarmInviteePlay.
//        Ham o day giup tim:
//          - dong goc trong kho (masterId, stt) theo email
//          - nguoi choi + cong viec (farmAccountId, jobCode) dang giu acc do
//            tren server do, dua vao dai STT cua cac cong viec da giao.
// =========================================================================

/**
 * Trang thai coi nhu DA XONG cua tung loai acc - acc KHONG thuoc danh sach nay
 * se duoc phat cho bot chay.
 *   Lv200: chi DONE (du 5 nguoi moi VA da mua goi 60 kim cuong). INVITED la du
 *          5 nguoi nhung CHUA mua kim cuong -> van phai chay full chu trinh.
 *   Lv50 : SUCCESS (nhap ma thanh cong) va ALREADY_USED (da nhap ma tu truoc)
 *          - ca hai deu da co ma gioi thieu roi. Moi trang thai khac chay lai.
 */
export const XONG_LV200 = ['DONE'];
export const XONG_LV50 = ['SUCCESS', 'ALREADY_USED'];

export type ChuSoHuu = {
  masterId: string | null;
  stt: number;
  farmAccountId: string | null;
  jobCode: string | null;
};

/**
 * Tim dong goc + nguoi choi cho mot acc game tren mot server.
 * farmLevel: 200 -> kho FarmInviter, 50 -> kho FarmInvitee.
 */
export async function timChuSoHuu(
  farmLevel: number,
  email: string,
  serverId: number,
): Promise<ChuSoHuu> {
  const kho: any = farmLevel === 200 ? (prisma as any).farmInviter : (prisma as any).farmInvitee;

  // Kho mac dinh: moi email chi mot dong (bat ke serverId cu cua no)
  const goc = await kho.findFirst({
    where: { email },
    orderBy: { stt: 'desc' },
    select: { id: true, stt: true },
  });

  const stt = Number(goc?.stt || 0);
  let farmAccountId: string | null = null;
  let jobCode: string | null = null;

  if (stt > 0) {
    const viec = await (prisma as any).farmAccountRange.findFirst({
      where: {
        farmLevel,
        serverId,
        rangeFrom: { lte: stt },
        rangeTo: { gte: stt },
      },
      select: { farmAccountId: true, jobCode: true },
    });
    if (viec) {
      farmAccountId = viec.farmAccountId;
      jobCode = viec.jobCode;
    }
  }

  return { masterId: goc?.id || null, stt, farmAccountId, jobCode };
}

// =========================================================================
// [MOD FEATURE]: FARM KC - DANH SACH PHAN BO CUA MOT TAI KHOAN FARM_KC
// Mo ta: Khi xem theo mot tai khoan (vd datnd), phai thay DU so acc duoc giao
//        (dai STT x server), ke ca acc CHUA CHAY lan nao. Nen danh sach lay tu
//        KHO MAC DINH theo dai STT, roi ghep voi dong theo doi o DUNG server
//        cua cong viec. Acc chua chay -> dong "ao" trang thai NEW.
//        Phan trang chinh xac: moi cong viec la mot doan lien tiep, ghep noi
//        cac doan theo thu tu (server, STT).
// =========================================================================
export async function layDanhSachPhanBo(p: {
  farmLevel: number;
  farmUser: string;
  serverId?: number | null;
  keyword?: string;
  status?: string;
  sortBy?: string;
  sortDir?: 'asc' | 'desc';
  skip: number;
  take: number;
}): Promise<{ total: number; rows: any[]; soCongViec: number }> {
  const laLv200 = p.farmLevel === 200;
  const kho: any = laLv200 ? (prisma as any).farmInviter : (prisma as any).farmInvitee;

  const tk = await (prisma as any).farmAccount.findUnique({
    where: { username: p.farmUser },
    select: {
      username: true,
      ranges: {
        where: {
          farmLevel: p.farmLevel,
          ...(p.serverId !== null && p.serverId !== undefined ? { serverId: p.serverId } : {}),
        },
        orderBy: [{ serverId: 'asc' }, { rangeFrom: 'asc' }],
        select: { serverId: true, serverName: true, rangeFrom: true, rangeTo: true, jobCode: true },
      },
    },
  });
  if (!tk || (tk.ranges || []).length === 0) return { total: 0, rows: [], soCongViec: 0 };

  const tang = (p.sortDir || 'asc') === 'asc';
  const theoEmail = p.sortBy === 'email';
  const doan = tang ? tk.ranges : [...tk.ranges].reverse();

  // Dieu kien cho moi doan (cong viec)
  const whereCua = (r: any) => {
    const w: any = { stt: { gte: r.rangeFrom, lte: r.rangeTo } };
    if (p.keyword) w.email = { contains: p.keyword };
    if (p.status === 'NEW') {
      // Chua chay = chua co dong theo doi nao o server nay, hoac dang NEW
      w.plays = { none: { serverId: r.serverId, status: { not: 'NEW' } } };
    } else if (p.status) {
      w.plays = { some: { serverId: r.serverId, status: p.status } };
    }
    return w;
  };

  const demTung = await Promise.all(doan.map((r: any) => kho.count({ where: whereCua(r) })));
  const total = demTung.reduce((a: number, b: number) => a + b, 0);

  // Cat dung trang tren chuoi cac doan noi tiep nhau
  const rows: any[] = [];
  let boQua = p.skip;
  let canLay = p.take;
  for (let i = 0; i < doan.length && canLay > 0; i++) {
    const r = doan[i];
    const n = demTung[i];
    if (boQua >= n) { boQua -= n; continue; }

    const ds = await kho.findMany({
      where: whereCua(r),
      orderBy: theoEmail ? [{ email: tang ? 'asc' : 'desc' }] : [{ stt: tang ? 'asc' : 'desc' }],
      skip: boQua,
      take: canLay,
      select: {
        id: true, stt: true, email: true, password: true,
        plays: {
          where: { serverId: r.serverId },
          take: 1,
          include: {
            createdBy: { select: { username: true, displayName: true } },
            farmAccount: { select: { username: true } },
            ...(laLv200 ? {} : { inviter: { select: { email: true, inviteCode: true } } }),
          },
        },
      },
    });

    for (const m of ds as any[]) {
      const tienDo = (m.plays || [])[0];
      if (tienDo) {
        rows.push({ ...tienDo, stt: tienDo.stt || m.stt });
      } else {
        // Dong "ao": acc da duoc giao nhung chua chay lan nao tren server nay
        rows.push({
          id: `kho:${m.id}:${r.serverId}`,
          email: m.email,
          password: m.password,
          stt: m.stt,
          serverId: r.serverId,
          serverName: r.serverName,
          roleId: '', roleName: '', level: 0, inviteCode: null,
          gameInviteNum: 0, confirmedCount: 0, reservedCount: 0, maxInvites: 5,
          unboundGold: 0, unboundDiamond: 0, goldVoucher: 0, packBought: 0,
          status: 'NEW', failCount: 0, lastError: null, lastSyncAt: null,
          deviceId: null, reservedAt: null, expireAt: null, confirmedAt: null, errorMsg: null,
          inviter: null,
          jobCode: r.jobCode,
          farmAccount: { username: tk.username },
          createdBy: null,
          updatedAt: null,
          chuaChay: true,
        });
      }
    }

    canLay -= ds.length;
    boQua = 0;
  }

  return { total, rows, soCongViec: doan.length };
}

// =========================================================================
// [MOD FEATURE]: FARM KC - PHAN BO LAI BANG THEO DOI SAU KHI SUA CONG VIEC
// Mo ta: Chu so huu (farmAccountId, jobCode) cua moi dong theo doi duoc tinh
//        lai theo dai STT x server cua cac cong viec HIEN TAI:
//          - dong ra khoi dai cua tai khoan -> sang tai khoan dang giu dai do,
//            hoac thanh vo chu neu chua ai giu
//          - dong moi lot vao dai -> gan cho tai khoan giu dai
//        KHONG xoa dong nao: tien do trong game (ma moi cua acc Lv200 ma cac
//        acc Lv50 cung server dang dung) phai duoc giu nguyen.
//        Tra ve so dong da doi chu.
// =========================================================================
export async function phanBoLaiTheoDoi(serverIds: number[], db: any = prisma): Promise<number> {
  const ds = Array.from(new Set((serverIds || []).map((x) => Number(x)).filter((x) => Number.isFinite(x))));
  if (ds.length === 0) return 0;

  const cho = ds.map((_, i) => `@P${i + 1}`).join(', ');
  let tong = 0;

  for (const [bang, level] of [['FarmInviterPlay', 200], ['FarmInviteePlay', 50]] as const) {
    const sql = `
      UPDATE p
         SET p.[farmAccountId] = v.[farmAccountId],
             p.[jobCode]       = v.[jobCode],
             p.[updatedAt]     = GETDATE()
      FROM [dbo].[${bang}] p
      OUTER APPLY (
          SELECT TOP 1 r.[farmAccountId], r.[jobCode]
          FROM [dbo].[FarmAccountRange] r
          WHERE r.[farmLevel] = ${level}
            AND r.[serverId] = p.[serverId]
            AND p.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
      ) v
      WHERE p.[serverId] IN (${cho})
        AND (   ISNULL(p.[farmAccountId], N'') <> ISNULL(v.[farmAccountId], N'')
             OR ISNULL(p.[jobCode], N'')       <> ISNULL(v.[jobCode], N''))`;
    tong += Number(await db.$executeRawUnsafe(sql, ...ds)) || 0;
  }
  return tong;
}

// =========================================================================
// [MOD FEATURE]: FARM KC - XOA BAN GHI THEO DOI CUA MOT TAI KHOAN
// Mo ta: Dung khi XOA tai khoan Farm KC. Xoa het dong theo doi thuoc tai khoan
//        do. Acc Lv50 nao dang "moi boi" mot acc Lv200 bi xoa thi go lien ket
//        truoc (inviterId = NULL) de khong con tro vao dong khong ton tai.
//        Kho mac dinh KHONG bi dung toi.
// =========================================================================
export async function xoaTheoDoiCuaTaiKhoan(
  farmAccountId: string,
  db: any = prisma,
): Promise<{ lv200: number; lv50: number; goLienKet: number }> {
  const goLienKet = Number(await db.$executeRawUnsafe(
    `UPDATE v SET v.[inviterId] = NULL, v.[updatedAt] = GETDATE()
       FROM [dbo].[FarmInviteePlay] v
       JOIN [dbo].[FarmInviterPlay] i ON i.[id] = v.[inviterId]
      WHERE i.[farmAccountId] = @P1`,
    farmAccountId,
  )) || 0;

  const lv50 = Number(await db.$executeRawUnsafe(
    `DELETE FROM [dbo].[FarmInviteePlay] WHERE [farmAccountId] = @P1`,
    farmAccountId,
  )) || 0;

  const lv200 = Number(await db.$executeRawUnsafe(
    `DELETE FROM [dbo].[FarmInviterPlay] WHERE [farmAccountId] = @P1`,
    farmAccountId,
  )) || 0;

  return { lv200, lv50, goLienKet };
}

// =========================================================================
// [MOD FEATURE]: FARM KC - DEM SO ACC DUOC PHAN BO CHO MOT TAI KHOAN
// Mo ta: Cung cach tinh voi layDanhSachPhanBo (tong dai STT x server cua cac
//        cong viec), de so tren tab ACC 200 / ACC 50 khop voi danh sach.
// =========================================================================
export async function demPhanBo(
  farmLevel: number,
  farmUser: string,
  serverId?: number | null,
): Promise<number> {
  const kho: any = farmLevel === 200 ? (prisma as any).farmInviter : (prisma as any).farmInvitee;
  const tk = await (prisma as any).farmAccount.findUnique({
    where: { username: farmUser },
    select: {
      ranges: {
        where: {
          farmLevel,
          ...(serverId !== null && serverId !== undefined ? { serverId } : {}),
        },
        select: { rangeFrom: true, rangeTo: true },
      },
    },
  });
  if (!tk) return 0;
  const dem = await Promise.all(
    (tk.ranges || []).map((r: any) => kho.count({ where: { stt: { gte: r.rangeFrom, lte: r.rangeTo } } })),
  );
  return dem.reduce((a: number, b: number) => a + b, 0);
}

// =========================================================================
// [MOD FEATURE]: FARM KC - CONG VIEC NAO DA CHAY (KHOA KHONG CHO SUA/XOA)
// Mo ta: Khoa theo TUNG CONG VIEC chu khong khoa ca tai khoan. Mot cong viec
//        coi la DA CHAY khi co bat ky dau vet nao:
//          - trang thai cong viec khac NEW, hoac
//          - da co may nhan viec (nhip tim / con tro STT), hoac
//          - da co dong theo doi mang jobCode nay.
//        Viec chua chay van sua / xoa tu do, va luon them duoc viec moi.
//        Tra ve tap jobCode da chay.
// =========================================================================
export async function layViecDaChay(ranges: any[]): Promise<Set<string>> {
  const daChay = new Set<string>();
  const ma: string[] = [];
  for (const r of ranges || []) {
    if (!r?.jobCode) continue;
    if ((r.status && r.status !== 'NEW') || r.lastHeartbeat || Number(r.cursorStt || 0) > 0) {
      daChay.add(r.jobCode);
    } else {
      ma.push(r.jobCode);
    }
  }
  if (ma.length > 0) {
    const [g200, g50] = await Promise.all([
      (prisma as any).farmInviterPlay.groupBy({
        by: ['jobCode'], where: { jobCode: { in: ma } }, _count: { _all: true },
      }),
      (prisma as any).farmInviteePlay.groupBy({
        by: ['jobCode'], where: { jobCode: { in: ma } }, _count: { _all: true },
      }),
    ]);
    for (const g of (g200 as any[]).concat(g50 as any[])) {
      if (g?.jobCode && Number(g?._count?._all || 0) > 0) daChay.add(g.jobCode);
    }
  }
  return daChay;
}
