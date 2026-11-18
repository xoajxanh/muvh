import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { verifyFarmRequest, safeNum } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API KIỂM TRA ACC LV200 TRƯỚC KHI ĐĂNG NHẬP
// Mô tả: Bot hỏi trước khi login 1 acc Lv200. Nếu đã COMPLETE/DONE thì bỏ qua
//        acc đó, khỏi tốn thời gian đăng nhập.
// Ký: sign = MD5(email + serverId + ts + SALT)
// =========================================================================

export async function GET(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const { searchParams } = new URL(req.url);
    const email = (searchParams.get('email') || '').trim();
    const serverIdRaw = searchParams.get('serverId');
    const ts = searchParams.get('ts');
    const sign = searchParams.get('sign');
    const createdBy = searchParams.get('createdBy');

    if (!email || !serverIdRaw) {
      return NextResponse.json({ ok: false, error: 'Thiếu email hoặc serverId' }, { status: 400 });
    }
    const serverId = parseInt(serverIdRaw, 10);
    if (!Number.isFinite(serverId)) {
      return NextResponse.json({ ok: false, error: 'serverId không hợp lệ' }, { status: 400 });
    }

    const auth = await verifyFarmRequest([email, serverId], ts, sign, createdBy);
    if (!auth.ok) {
      return NextResponse.json({ ok: false, error: auth.error }, { status: auth.status });
    }

    const row = await prisma.farmInviter.findUnique({
      where: { email_serverId: { email, serverId } },
    });

    if (!row) {
      return NextResponse.json({ ok: true, exists: false });
    }

    return NextResponse.json({
      ok: true,
      exists: true,
      status: row.status,
      inviteCode: row.inviteCode || '',
      gameInviteNum: row.gameInviteNum,
      confirmedCount: row.confirmedCount,
      reservedCount: row.reservedCount,
      maxInvites: row.maxInvites,
      unboundGold: safeNum(row.unboundGold),
      unboundDiamond: safeNum(row.unboundDiamond),
      goldVoucher: safeNum(row.goldVoucher),
      packBought: row.packBought,
      failCount: row.failCount,
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
