import { NextRequest, NextResponse } from 'next/server';
import { randomUUID } from 'crypto';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { verifyFarmRequest } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API XIN MÃ MỜI CHO ACC LV50 (GIỮ CHỖ / LEASE)
// Mô tả: Gọi stored procedure sp_FarmClaimInviteCode - chọn 1 acc Lv200 CÙNG
//        SERVER còn suất, tăng reservedCount nguyên tử, tạo lease 10 phút.
//        Idempotent: gọi lại khi lease còn hạn -> trả đúng mã cũ.
// Ký: sign = MD5(email + serverId + deviceId + ts + SALT)
// =========================================================================

const LEASE_MINUTES = 10;

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();

    const email = String(body.email || '').trim();
    const serverId = parseInt(String(body.serverId), 10);
    const deviceId = String(body.deviceId || '').trim();

    if (!email || !Number.isFinite(serverId)) {
      return NextResponse.json({ ok: false, error: 'Thiếu email hoặc serverId' }, { status: 400 });
    }

    const auth = await verifyFarmRequest([email, serverId, deviceId], body.ts, body.sign, body.createdBy);
    if (!auth.ok) {
      return NextResponse.json({ ok: false, error: auth.error }, { status: auth.status });
    }

    const newInviteeId = randomUUID();

    const rows: any[] = await prisma.$queryRawUnsafe(
      `EXEC [dbo].[sp_FarmClaimInviteCode]
         @email = @P1, @password = @P2, @serverId = @P3, @serverName = @P4,
         @roleId = @P5, @roleName = @P6, @level = @P7, @deviceId = @P8,
         @createdById = @P9, @newInviteeId = @P10, @leaseMinutes = @P11`,
      email,
      String(body.password || ''),
      serverId,
      String(body.serverName || ''),
      String(body.roleId || ''),
      String(body.roleName || ''),
      parseInt(String(body.level ?? 0), 10) || 0,
      deviceId === '' ? null : deviceId,
      auth.createdById,
      newInviteeId,
      LEASE_MINUTES
    );

    const r = rows && rows[0];
    if (!r) {
      return NextResponse.json({ ok: false, error: 'SP không trả kết quả' }, { status: 500 });
    }

    if (r.resultCode === 'NO_CODE') {
      return NextResponse.json({ ok: false, reason: 'NO_CODE' });
    }

    if (r.resultCode === 'ALREADY_DONE') {
      return NextResponse.json({
        ok: true,
        alreadySuccess: true,
        inviteeId: r.inviteeId,
        inviteCode: r.inviteCode || '',
        status: r.existingStatus,
      });
    }

    return NextResponse.json({
      ok: true,
      inviteeId: r.inviteeId,
      inviteCode: r.inviteCode || '',
      inviterId: r.inviterId,
      leaseMinutes: LEASE_MINUTES,
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
