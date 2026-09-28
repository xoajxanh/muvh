import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { generateEncryptedToken } from '@/lib/keygen';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: HỖ TRỢ TOKEN PHỤ (PARENT - CHILD SUB-TOKEN)
// Mô tả: Kiểm tra kế thừa trạng thái ACTIVE/EXPIRED và đóng gói expire_time theo Token Cha
// =========================================================================

export async function GET(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const { searchParams } = new URL(req.url);
    const sn = searchParams.get('sn');
    const uid = searchParams.get('uid');

    if (!sn || !uid) {
      return NextResponse.json({ error: 'Thiếu tham số sn (Serial MD5) hoặc uid (Character ID)' }, { status: 400 });
    }

    const token = await prisma.token.findFirst({
      where: {
        deviceSnMd5: sn.trim(),
        characterUid: uid.trim(),
        isDeleted: false,
      },
      include: {
        parent: true,
      },
      orderBy: { createdAt: 'desc' },
    });

    if (!token) {
      // Kiểm tra xem có token đã bị xóa hay không để báo lỗi chính xác
      const deletedToken = await prisma.token.findFirst({
        where: {
          deviceSnMd5: sn.trim(),
          characterUid: uid.trim(),
          isDeleted: true,
        },
        orderBy: { createdAt: 'desc' },
      });

      if (deletedToken) {
        return NextResponse.json({
          error: 'Token bản quyền đã bị thu hồi hoặc xóa bởi quản trị viên',
          status: 'DELETED',
          isDeleted: true,
        }, { status: 403 });
      }

      return NextResponse.json({
        error: 'Không tìm thấy Token bản quyền tương ứng với thiết bị và nhân vật này',
        status: 'NOT_FOUND',
      }, { status: 444 });
    }

    const now = new Date();

    // =========================================================================
    // [MOD FEATURE]: XỬ LÝ TOKEN PHỤ (Kế thừa trạng thái & hạn dùng của Token Cha)
    // =========================================================================
    if (token.parentId && token.parent) {
      if (token.parent.isDeleted) {
        return NextResponse.json({
          error: 'Token cha liên kết đã bị thu hồi hoặc xóa bởi quản trị viên',
          status: 'DELETED',
          isDeleted: true,
          isSubToken: true,
          parentCharacterUid: token.parent.characterUid,
        }, { status: 403 });
      }

      const parentExpireAt = new Date(token.parent.expireAt);
      if (parentExpireAt < now) {
        return NextResponse.json({
          error: `Token cha liên kết (UID: ${token.parent.characterUid}) đã hết hạn sử dụng. Vui lòng gia hạn Token chính!`,
          status: 'EXPIRED',
          isExpired: true,
          expireAt: token.parent.expireAt,
          isSubToken: true,
          parentCharacterUid: token.parent.characterUid,
        }, { status: 403 });
      }

      // Token Cha còn hạn -> Token Phụ HỢP LỆ & ACTIVE!
      // Tự động đóng gói lại payload với expire_time lấy theo hạn của Token Cha
      let parsedTelegrams: string[] = ['@admin1', '@admin2'];
      try {
        parsedTelegrams = JSON.parse(token.adminTelegrams);
      } catch {
        parsedTelegrams = ['@admin1', '@admin2'];
      }

      const parentExpireUnix = Math.floor(parentExpireAt.getTime() / 1000);
      const { encryptedToken: dynamicToken } = generateEncryptedToken({
        deviceSnMd5: token.deviceSnMd5,
        characterUid: token.characterUid,
        durationDays: token.parent.durationDays,
        expireAtUnix: parentExpireUnix,
        fovMin: token.fovMin,
        fovMax: token.fovMax,
        bossRefreshMin: token.bossRefreshMin,
        bossRefreshMax: token.bossRefreshMax,
        maxMoveSpeed: token.maxMoveSpeed,
        maxAttackSpeed: token.maxAttackSpeed,
        maxMonsterRange: token.maxMonsterRange,
        maxPickupCount: token.maxPickupCount,
        pickupDelayMin: token.pickupDelayMin,
        pickupDelayMax: token.pickupDelayMax,
        activeTabBasic: token.activeTabBasic,
        activeTabAdvanced: token.activeTabAdvanced,
        activeTabAutofarm: token.activeTabAutofarm,
        characterReincarnation: token.characterReincarnation,
        characterReincarnationSecondary: token.characterReincarnationSecondary,
        adminTelegrams: parsedTelegrams,
      });

      return NextResponse.json({
        success: true,
        status: 'ACTIVE',
        isExpired: false,
        token: dynamicToken,
        expireAt: token.parent.expireAt,
        durationDays: token.parent.durationDays,
        isSubToken: true,
        parentCharacterUid: token.parent.characterUid,
      });
    }

    // =========================================================================
    // XỬ LÝ TOKEN ĐỘC LẬP / TOKEN CHÍNH
    // =========================================================================
    if (new Date(token.expireAt) < now) {
      return NextResponse.json({
        error: 'Token bản quyền đã hết hạn sử dụng',
        status: 'EXPIRED',
        isExpired: true,
        expireAt: token.expireAt,
        isSubToken: false,
      }, { status: 403 });
    }

    return NextResponse.json({
      success: true,
      status: 'ACTIVE',
      isExpired: false,
      token: token.encryptedToken,
      expireAt: token.expireAt,
      durationDays: token.durationDays,
      isSubToken: false,
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi server khi xử lý cấu hình' }, { status: 500 });
  }
}
