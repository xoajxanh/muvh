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

/** Trang thai coi nhu DA XONG cua tung loai acc */
export const XONG_LV200 = ['DONE', 'INVITED'];
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
