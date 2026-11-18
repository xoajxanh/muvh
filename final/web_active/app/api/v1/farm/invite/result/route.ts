import { NextRequest, NextResponse } from 'next/server';
import { randomUUID } from 'crypto';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { verifyFarmRequest } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API BÁO KẾT QUẢ NHẬP MÃ CỦA ACC LV50
// Mô tả: SUCCESS  -> reservedCount - 1, confirmedCount + 1 (cập nhật COMPLETE)
//        FAILED   -> reservedCount - 1 (trả suất)
//        ALREADY_USED / NO_CODE -> chỉ ghi nhận trạng thái acc Lv50
//        Idempotent: gọi lại khi đã chốt kết quả -> không cộng/trừ suất lần 2.
// Ký: sign = MD5(email + serverId + status + ts + SALT)
// =========================================================================

const FINAL_STATUSES = ['SUCCESS', 'FAILED', 'ALREADY_USED', 'NO_CODE'];

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();

    const email = String(body.email || '').trim();
    const serverId = parseInt(String(body.serverId), 10);
    const status = String(body.status || '').trim().toUpperCase();
    const errorMsg = body.errorMsg ? String(body.errorMsg).slice(0, 900) : null;

    if (!email || !Number.isFinite(serverId)) {
      return NextResponse.json({ ok: false, error: 'Thiếu email hoặc serverId' }, { status: 400 });
    }
    if (!FINAL_STATUSES.includes(status)) {
      return NextResponse.json({ ok: false, error: `status không hợp lệ: ${status}` }, { status: 400 });
    }

    const auth = await verifyFarmRequest([email, serverId, status], body.ts, body.sign, body.createdBy);
    if (!auth.ok) {
      return NextResponse.json({ ok: false, error: auth.error }, { status: auth.status });
    }

    const now = new Date();

    const result = await prisma.$transaction(async (tx) => {
      const existing = await tx.farmInvitee.findUnique({
        where: { email_serverId: { email, serverId } },
      });

      // Chỉ nhả/cộng suất khi dòng đang ở trạng thái RESERVED (chống gọi lại 2 lần)
      const shouldAdjustInviter = !!(existing && existing.status === 'RESERVED' && existing.inviterId);

      if (existing) {
        await tx.farmInvitee.update({
          where: { id: existing.id },
          data: {
            status,
            errorMsg,
            confirmedAt: status === 'SUCCESS' ? now : existing.confirmedAt,
            level: parseInt(String(body.level ?? existing.level), 10) || existing.level,
            roleId: String(body.roleId || existing.roleId),
            roleName: String(body.roleName || existing.roleName),
            serverName: String(body.serverName || existing.serverName),
            updatedAt: now,
          },
        });
      } else {
        await tx.farmInvitee.create({
          data: {
            id: randomUUID(),
            email,
            password: String(body.password || ''),
            serverId,
            serverName: String(body.serverName || ''),
            roleId: String(body.roleId || ''),
            roleName: String(body.roleName || ''),
            level: parseInt(String(body.level ?? 0), 10) || 0,
            inviteCode: body.inviteCode ? String(body.inviteCode) : null,
            status,
            errorMsg,
            confirmedAt: status === 'SUCCESS' ? now : null,
            createdById: auth.createdById,
          },
        });
      }

      if (!shouldAdjustInviter) {
        return { adjusted: false, inviterStatus: null as string | null };
      }

      const inviter = await tx.farmInviter.findUnique({ where: { id: existing!.inviterId! } });
      if (!inviter) return { adjusted: false, inviterStatus: null as string | null };

      const newReserved = Math.max(0, inviter.reservedCount - 1);
      const newConfirmed = status === 'SUCCESS' ? inviter.confirmedCount + 1 : inviter.confirmedCount;
      // Tổng đã dùng = mốc game báo + phần web cấp thêm sau mốc đó (KHÔNG dùng MAX)
      const used = inviter.gameInviteNum + newConfirmed;
      const newStatus =
        inviter.status === 'DONE' ? 'DONE' : (used >= inviter.maxInvites ? 'COMPLETE' : inviter.status);

      await tx.farmInviter.update({
        where: { id: inviter.id },
        data: {
          reservedCount: newReserved,
          confirmedCount: newConfirmed,
          status: newStatus,
          updatedAt: now,
        },
      });

      return { adjusted: true, inviterStatus: newStatus };
    });

    return NextResponse.json({ ok: true, status, ...result });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
