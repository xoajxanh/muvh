import { prisma } from './db';

// =========================================================================
// [MOD FEATURE]: FARM KC - TIEN ICH CHO TAI KHOAN FARM_KC
// Mo ta: Chuan hoa username, kiem tra trung, goi y username moi, kiem tra
//        chong lan khoang STT.
//        MOI DONG CONG VIEC = level + server + khoang STT. Mot tai khoan co
//        nhieu dong nen cay duoc nhieu level tren nhieu server cung luc
//        (vd: Lv50 100-200 @ server 517 va Lv50 1200-2000 @ server 515).
//        Hai dong chi dung do nhau khi CUNG level VA CUNG server.
// =========================================================================

export const FARM_LEVELS = [50, 200];

export type CongViec = {
  farmLevel: number;
  serverId: number;
  serverName: string;
  rangeFrom: number;
  rangeTo: number;
  /** Co = cong viec da luu (dung de doi chieu khi sua); khong co = viec moi */
  jobCode?: string;
};

/** Username chi gom chu thuong, so, dau cham/gach duoi/gach ngang */
export function chuanHoaUsername(v: any): string {
  return String(v || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9._-]/g, '');
}

/** Co ban ghi nao dang dung username nay khong (bo qua chinh minh khi sua) */
export async function kiemTraTrung(username: string, boQuaId?: string) {
  const u = chuanHoaUsername(username);
  if (!u) return null;
  return (prisma as any).farmAccount.findFirst({
    where: boQuaId ? { username: u, NOT: { id: boQuaId } } : { username: u },
    select: { id: true, username: true },
  });
}

const CHU_SO = 'abcdefghijklmnopqrstuvwxyz0123456789';

function duoiNgauNhien(doDai = 4): string {
  let s = '';
  for (let i = 0; i < doDai; i++) s += CHU_SO[Math.floor(Math.random() * CHU_SO.length)];
  return s;
}

/** Goi y mot username chua ai dung, dua tren username nguoi dung vua go */
export async function goiYUsername(gocRaw: string): Promise<string> {
  const goc = chuanHoaUsername(gocRaw) || 'farmkc';
  for (let i = 0; i < 30; i++) {
    const doDai = i < 10 ? 3 : i < 20 ? 4 : 5;
    const thu = `${goc}${duoiNgauNhien(doDai)}`.slice(0, 100);
    if (!(await kiemTraTrung(thu))) return thu;
  }
  return `${goc}${Date.now().toString(36)}`.slice(0, 100);
}

// =========================================================================
// [MOD FEATURE]: FARM KC - MA DINH DANH CONG VIEC (jobCode)
// Mo ta: Dang <USERNAME>-S<server>-L<level>-<so thu tu>, vd LONGDT-S517-L50-01.
//        Mod gui kem ma nay trong moi request de web biet dang lam block nao,
//        va de khoa mot cong viec vao dung mot gia lap.
// =========================================================================
export function taoJobCode(username: string, serverId: number, farmLevel: number, thuTu = 1) {
  const u = chuanHoaUsername(username).toUpperCase().replace(/[^A-Z0-9]/g, '') || 'FARMKC';
  const sv = Number(serverId) || 0;
  const stt = String(thuTu).padStart(2, '0');
  return `${u}-S${sv}-L${farmLevel}-${stt}`;
}

/** Sinh jobCode chua ai dung (phong khi doi username lam trung ma cu) */
export async function jobCodeChuaDung(
  username: string,
  serverId: number,
  farmLevel: number,
  boQuaId?: string,
  /** Ma da cap trong CUNG lan luu (chua ghi DB) - tranh 2 viec moi trung ma */
  daCapTrongLanNay?: Set<string>,
): Promise<string> {
  // Mot tai khoan co the co NHIEU viec cung server + level (khac dai STT)
  // -> ma tang dan: LONGDT-S517-L50-01, -02, -03 ...
  for (let i = 1; i <= 99; i++) {
    const ma = taoJobCode(username, serverId, farmLevel, i);
    if (daCapTrongLanNay && daCapTrongLanNay.has(ma)) continue;
    const co = await (prisma as any).farmAccountRange.findFirst({
      where: boQuaId ? { jobCode: ma, NOT: { farmAccountId: boQuaId } } : { jobCode: ma },
      select: { id: true },
    });
    if (!co) {
      if (daCapTrongLanNay) daCapTrongLanNay.add(ma);
      return ma;
    }
  }
  return `${taoJobCode(username, serverId, farmLevel, 99)}-${Date.now().toString(36).toUpperCase()}`;
}

/** Doc + lam sach danh sach cong viec gui len tu web */
export function chuanHoaCongViec(
  raw: any,
): { ok: true; ds: CongViec[] } | { ok: false; loi: string } {
  const vao = Array.isArray(raw) ? raw : [];
  const ds: CongViec[] = [];

  for (const k of vao) {
    const farmLevel = parseInt(String(k?.farmLevel), 10);
    const serverId = parseInt(String(k?.serverId ?? 0), 10) || 0;
    const serverName = String(k?.serverName || '').trim();
    const rangeFrom = parseInt(String(k?.rangeFrom), 10);
    const rangeTo = parseInt(String(k?.rangeTo), 10);

    if (!FARM_LEVELS.includes(farmLevel)) {
      return { ok: false, loi: 'Level cày phải là 50 hoặc 200' };
    }
    if (!Number.isFinite(rangeFrom) || !Number.isFinite(rangeTo)) {
      return { ok: false, loi: `Dòng Lv${farmLevel} (server ${serverId}) chưa nhập đủ khoảng STT` };
    }
    if (rangeFrom < 1 || rangeTo < rangeFrom) {
      return {
        ok: false,
        loi: `Khoảng STT của dòng Lv${farmLevel} (server ${serverId}) không hợp lệ (từ ≤ đến, bắt đầu từ 1)`,
      };
    }

    const jobCode = String(k?.jobCode || '').trim() || undefined;
    const moi: CongViec = { farmLevel, serverId, serverName, rangeFrom, rangeTo, jobCode };

    // =================================================================
    // [MOD FEATURE]: CHONG TRUNG VOI CHINH CAC DONG CUA TAI KHOAN NAY
    // Mot tai khoan duoc co NHIEU viec cung server + level, nhung cac dai
    // STT khong duoc dam nhau (vd 1-100 va 1-20 cung @517 Lv50 la sai).
    // =================================================================
    const dung = ds.find(
      (x) => x.farmLevel === farmLevel && x.serverId === serverId &&
        x.rangeFrom <= rangeTo && rangeFrom <= x.rangeTo,
    );
    if (dung) {
      return {
        ok: false,
        loi: `Lv${farmLevel} · server ${serverId}: dải ${rangeFrom}–${rangeTo} chồng lên dải ${dung.rangeFrom}–${dung.rangeTo} của chính tài khoản này.`,
      };
    }

    ds.push(moi);
  }

  if (ds.length === 0) {
    return { ok: false, loi: 'Phải thêm ít nhất một dòng công việc' };
  }
  return { ok: true, ds };
}

/**
 * Kiem tra mot khoang co chong lan tai khoan KHAC khong.
 * Chi xet CUNG farmLevel va CUNG serverId - khac server thi trung khoang
 * van hop le (chay nhieu gia lap tren nhieu server).
 */
export async function kiemTraChongLan(p: {
  farmLevel: number;
  serverId: number;
  rangeFrom: number;
  rangeTo: number;
  /** Bo qua CA tai khoan (dung khi luu - phan tu doi chieu chinh no da lam rieng) */
  boQuaId?: string;
  /** Bo qua DUNG MOT viec (dong dang sua) - van tinh cac viec khac cua chinh tai khoan */
  boQuaJob?: string;
}) {
  const row = await (prisma as any).farmAccountRange.findFirst({
    where: {
      farmLevel: p.farmLevel,
      serverId: p.serverId,
      rangeFrom: { lte: p.rangeTo },
      rangeTo: { gte: p.rangeFrom },
      ...(p.boQuaId ? { farmAccount: { NOT: { id: p.boQuaId } } } : {}),
      ...(p.boQuaJob ? { NOT: { jobCode: p.boQuaJob } } : {}),
    },
    select: {
      rangeFrom: true,
      rangeTo: true,
      farmLevel: true,
      serverId: true,
      serverName: true,
      farmAccount: { select: { username: true } },
    },
  });

  if (!row) return null;
  return {
    username: row.farmAccount?.username || '(không rõ)',
    farmLevel: row.farmLevel,
    serverId: row.serverId,
    serverName: row.serverName,
    rangeFrom: row.rangeFrom,
    rangeTo: row.rangeTo,
  };
}

/** Kiem tra ca danh sach cong viec cua mot tai khoan */
export async function kiemTraChongLanNhieu(p: { ds: CongViec[]; boQuaId?: string }) {
  for (const k of p.ds) {
    const v = await kiemTraChongLan({ ...k, boQuaId: p.boQuaId });
    if (v) return v;
  }
  return null;
}

/** Sap xep theo cot cho danh sach tai khoan FARM_KC */
export function buildOrderByFarmAccount(sortBy: string, dir: 'asc' | 'desc'): any {
  switch (sortBy) {
    case 'username': return [{ username: dir }];
    case 'status': return [{ status: dir }];
    case 'lastSyncAt': return [{ lastSyncAt: dir }];
    case 'createdAt': return [{ createdAt: dir }];
    case 'createdBy': return [{ createdBy: { username: dir } }];
    default: return [{ username: 'desc' }];
  }
}
