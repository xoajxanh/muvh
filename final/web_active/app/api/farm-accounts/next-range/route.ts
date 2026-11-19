import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { FARM_LEVELS } from '@/lib/farm-account';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - GOI Y KHOANG STT TRONG TIEP THEO
// Mo ta: Voi mot (level cay, serverId), tra ve doan STT gan nhat chua ai
//        nhan de web dien san cho nguoi dung.
//        - daPhanBoToi : STT lon nhat da duoc giao tren server nay
//        - batDauTu    : daPhanBoToi + 1 (chua ai nhan thi la 1)
//        - tongAcc     : STT lon nhat co trong kho acc game (de biet tran)
//        - conLai      : so acc trong kho chua duoc giao
//        - cacKhoang   : cac khoang da giao, de hien cho nguoi dung nhin
// GET /api/farm-accounts/next-range?farmLevel=50&serverId=517
// =========================================================================

export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });

  try {
    const { searchParams } = new URL(req.url);
    const farmLevel = parseInt(searchParams.get('farmLevel') || '', 10);
    const serverId = parseInt(searchParams.get('serverId') || '0', 10) || 0;
    const boQuaId = (searchParams.get('id') || '').trim() || undefined;

    if (!FARM_LEVELS.includes(farmLevel)) {
      return NextResponse.json({ error: 'Level cày phải là 50 hoặc 200' }, { status: 400 });
    }

    // Moi dong cong viec co san level + server -> loc thang tren bang con
    const where: any = {
      farmLevel,
      serverId,
      ...(boQuaId ? { farmAccount: { NOT: { id: boQuaId } } } : {}),
    };

    const rows = await (prisma as any).farmAccountRange.findMany({
      where,
      orderBy: { rangeFrom: 'asc' },
      select: {
        rangeFrom: true,
        rangeTo: true,
        farmAccount: { select: { username: true } },
      },
    });
    const cacKhoang = rows.map((r: any) => ({
      username: r.farmAccount?.username || '',
      rangeFrom: r.rangeFrom,
      rangeTo: r.rangeTo,
    }));

    const daPhanBoToi = cacKhoang.reduce(
      (m: number, k: any) => Math.max(m, k.rangeTo || 0),
      0,
    );

    // =====================================================================
    // Kho acc that cua level nay.
    //   tongAcc = SO BAN GHI co that (khong phai STT lon nhat - acc Lv200 bat
    //             dau tu STT 441 nen max STT = 4000 nhung chi co 3.560 acc)
    //   sttMin / sttMax = bien cua dai STT dang co trong kho
    // =====================================================================
    const bang: any = farmLevel === 200 ? prisma.farmInviter : prisma.farmInvitee;
    // Chi tinh acc CO STT (> 0). Ban ghi stt = 0 la acc cu do bot tao truoc khi
    // co cot stt - khong thuoc kho chia theo khoang.
    const [aggKho, tongAcc, soChuaCoStt] = await Promise.all([
      bang.aggregate({ _min: { stt: true }, _max: { stt: true }, where: { stt: { gt: 0 } } } as any),
      bang.count({ where: { stt: { gt: 0 } } }),
      bang.count({ where: { stt: { lte: 0 } } }),
    ]);
    const sttMin = Number((aggKho as any)?._min?.stt || 0);
    const sttMax = Number((aggKho as any)?._max?.stt || 0);

    // Diem bat dau goi y: sau phan da giao, nhung khong duoi STT nho nhat
    const batDauTu = Math.max(daPhanBoToi + 1, sttMin || 1);

    // Con lai = SO ACC CO THAT tu diem bat dau tro di (STT khong lien tuc)
    const conLai = await bang.count({ where: { stt: { gte: batDauTu } } });

    // Khe trong nam GIUA cac khoang da giao (neu co) - uu tien lap day truoc
    const khoangTrong: { tu: number; den: number }[] = [];
    let moc = sttMin || 1;
    for (const k of [...cacKhoang].sort((a: any, b: any) => a.rangeFrom - b.rangeFrom)) {
      if (k.rangeFrom > moc) khoangTrong.push({ tu: moc, den: k.rangeFrom - 1 });
      moc = Math.max(moc, (k.rangeTo || 0) + 1);
    }

    return NextResponse.json({
      farmLevel,
      serverId,
      daPhanBoToi,
      batDauTu,
      tongAcc,
      soChuaCoStt,
      sttMin,
      sttMax,
      conLai,
      soKhoang: cacKhoang.length,
      khoangTrong: khoangTrong.slice(0, 5),
      cacKhoang: cacKhoang.slice(-5),
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
