import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';

export const dynamic = 'force-dynamic';

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
    if (new Date(token.expireAt) < now) {
      return NextResponse.json({
        error: 'Token bản quyền đã hết hạn sử dụng',
        status: 'EXPIRED',
        isExpired: true,
        expireAt: token.expireAt,
      }, { status: 403 });
    }

    return NextResponse.json({
      success: true,
      status: 'ACTIVE',
      isExpired: false,
      token: token.encryptedToken,
      expireAt: token.expireAt,
      durationDays: token.durationDays,
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi server khi xử lý cấu hình' }, { status: 500 });
  }
}
