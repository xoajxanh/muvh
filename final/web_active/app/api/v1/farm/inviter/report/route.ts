import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { verifyFarmRequest, safeNum } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API BÁO CÁO ACC LV200 (NGƯỜI MỜI)
// Mô tả: Bot đạt Lv200 -> tạo mã nếu chưa có -> gửi mã, số người đã mời,
//        vàng/KC không khóa, thông tin nhân vật. Upsert theo (email, serverId).
//        Tự set COMPLETE khi MAX(gameInviteNum, confirmedCount) >= maxInvites.
// Ký: sign = MD5(email + serverId + roleId + inviteCode + gameInviteNum + ts + SALT)
// =========================================================================

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();

    const email = String(body.email || '').trim();
    const serverId = parseInt(String(body.serverId), 10);
    const roleId = String(body.roleId || '').trim();
    const inviteCode = String(body.inviteCode || '').trim();
    const gameInviteNum = parseInt(String(body.gameInviteNum ?? 0), 10) || 0;

    if (!email || !Number.isFinite(serverId)) {
      return NextResponse.json({ ok: false, error: 'Thiếu email hoặc serverId' }, { status: 400 });
    }

    const auth = await verifyFarmRequest(
      [email, serverId, roleId, inviteCode, gameInviteNum],
      body.ts, body.sign, body.createdBy
    );
    if (!auth.ok) {
      return NextResponse.json({ ok: false, error: auth.error }, { status: auth.status });
    }

    const now = new Date();
    const existing = await prisma.farmInviter.findUnique({
      where: { email_serverId: { email, serverId } },
    });

    const maxInvites = existing?.maxInvites ?? 5;

    // =========================================================================
    // [MOD FEATURE]: MOC CHUAN LA SO GAME BAO VE
    // Mô tả: gameInviteNum là TỔNG THẬT tại thời điểm acc Lv200 đăng nhập, nên
    //        nó đã bao gồm cả những lượt web cấp trước đó -> RESET confirmedCount
    //        về 0 để không đếm trùng. Từ giờ confirmedCount chỉ đếm phần PHÁT
    //        SINH SAU mốc này, và tổng đã dùng = gameInviteNum + confirmedCount.
    // =========================================================================
    const used = gameInviteNum;

    // Giữ nguyên DONE nếu đã có (bước nhận thưởng/mua đồ làm sau)
    let status = existing?.status === 'DONE' ? 'DONE' : (used >= maxInvites ? 'COMPLETE' : 'ACTIVE');

    const common = {
      password: String(body.password || ''),
      serverName: String(body.serverName || ''),
      roleId,
      roleName: String(body.roleName || ''),
      level: parseInt(String(body.level ?? 0), 10) || 0,
      inviteCode: inviteCode === '' ? null : inviteCode,
      gameInviteNum,
      confirmedCount: 0,   // reset: gameInviteNum đã gồm mọi lượt tính tới lúc này
      unboundGold: BigInt(Math.trunc(Number(body.unboundGold) || 0)),
      unboundDiamond: BigInt(Math.trunc(Number(body.unboundDiamond) || 0)),
      status,
      failCount: 0,
      lastError: null,
      lastSyncAt: now,
    };

    const row = await prisma.farmInviter.upsert({
      where: { email_serverId: { email, serverId } },
      update: common,
      create: {
        email,
        serverId,
        maxInvites: 5,
        createdById: auth.createdById,
        ...common,
      },
    });

    return NextResponse.json({
      ok: true,
      status: row.status,
      inviteCode: row.inviteCode || '',
      gameInviteNum: row.gameInviteNum,
      confirmedCount: row.confirmedCount,
      reservedCount: row.reservedCount,
      maxInvites: row.maxInvites,
      unboundGold: safeNum(row.unboundGold),
      unboundDiamond: safeNum(row.unboundDiamond),
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
