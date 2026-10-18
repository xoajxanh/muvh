import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: API XÁC THỰC BẢN QUYỀN ONLINE CHO BẢN CLIENT (SVIP)
// Mô tả: Kiểm tra token active theo Device SN MD5 và Character UID (hỗ trợ UID = "ALL").
//        Ghi nhận lịch sử đăng nhập DeviceLoginHistory khi isLogin = 1.
// =========================================================================

export async function GET(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const { searchParams } = new URL(req.url);
    const sn = searchParams.get('sn');
    const uid = searchParams.get('uid');
    const roleName = searchParams.get('name') || searchParams.get('roleName') || '';
    const serverName = searchParams.get('server') || searchParams.get('serverName') || '';
    const isLogin = searchParams.get('isLogin') === '1';

    if (!sn) {
      return NextResponse.json({ error: 'Thiếu tham số sn (Mã thiết bị MD5)' }, { status: 400 });
    }

    const cleanSn = sn.trim();
    const cleanUid = (uid || '').trim();

    const recordLoginHistory = async (status: 'SUCCESS' | 'FAILED') => {
      if (!isLogin) return;
      try {
        await prisma.deviceLoginHistory.create({
          data: {
            deviceSnMd5: cleanSn,
            characterUid: cleanUid || 'ALL',
            characterName: roleName.trim() || null,
            serverName: serverName.trim() || null,
            status,
            type: 'SVIP',
          },
        });
      } catch (err) {
        console.error('[History] Failed to record SVIP login history:', err);
      }
    };

    // Tìm tất cả token SVIP còn hiệu lực của máy này (khớp UID hoặc ALL)
    const matchingTokens = await prisma.token.findMany({
      where: {
        deviceSnMd5: cleanSn,
        type: 'SVIP',
        isDeleted: false,
        characterUid: cleanUid !== '' ? { in: [cleanUid, 'ALL', 'all'] } : { in: ['ALL', 'all'] },
      },
      orderBy: { createdAt: 'desc' },
    });

    let token = null;
    if (matchingTokens.length > 0) {
      // Ưu tiên token gán đích danh UID nhân vật, nếu không có mới lấy token ALL
      token = matchingTokens.find((t) => t.characterUid.toUpperCase() === cleanUid.toUpperCase()) ||
              matchingTokens.find((t) => t.characterUid.toUpperCase() === 'ALL') ||
              matchingTokens[0];
    }

    if (!token) {
      // Kiểm tra xem có token SVIP nào bị xóa không
      const deletedToken = await prisma.token.findFirst({
        where: {
          deviceSnMd5: cleanSn,
          type: 'SVIP',
          isDeleted: true,
        },
        orderBy: { createdAt: 'desc' },
      });

      await recordLoginHistory('FAILED');

      if (deletedToken) {
        return NextResponse.json({
          error: 'Token SVIP bản quyền đã bị thu hồi hoặc xóa bởi quản trị viên',
          status: 'DELETED',
          isDeleted: true,
        }, { status: 403 });
      }

      return NextResponse.json({
        error: 'Chưa có bản quyền SVIP cho thiết bị này hoặc UID không hợp lệ!',
        status: 'NOT_FOUND',
      }, { status: 444 });
    }

    const now = new Date();
    if (new Date(token.expireAt) < now) {
      await recordLoginHistory('FAILED');
      return NextResponse.json({
        error: 'Token SVIP đã hết hạn sử dụng. Vui lòng gia hạn để tiếp tục!',
        status: 'EXPIRED',
        isExpired: true,
        expireAt: token.expireAt,
      }, { status: 403 });
    }

    // Xác thực thành công!
    await recordLoginHistory('SUCCESS');

    return NextResponse.json({
      success: true,
      status: 'ACTIVE',
      isExpired: false,
      token: token.encryptedToken,
      expireAt: token.expireAt,
      durationDays: token.durationDays,
      characterUid: token.characterUid,
      mainTier: token.characterReincarnation,
      subTier: token.characterReincarnationSecondary,
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ khi xác thực SVIP' }, { status: 500 });
  }
}
