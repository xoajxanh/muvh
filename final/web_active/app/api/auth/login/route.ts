import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { comparePassword, signJwtToken } from '@/lib/auth';

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();
    const { username, password } = body;

    if (!username || !password) {
      return NextResponse.json({ error: 'Tên đăng nhập và mật khẩu không được trống' }, { status: 400 });
    }

    const user = await prisma.user.findUnique({
      where: { username: username.trim() },
    });

    if (!user || !comparePassword(password, user.passwordHash)) {
      return NextResponse.json({ error: 'Tên đăng nhập hoặc mật khẩu không chính xác' }, { status: 401 });
    }

    const sessionPayload = {
      userId: user.id,
      username: user.username,
      displayName: user.displayName,
      role: user.role as 'ADMIN' | 'SALE',
    };

    const token = signJwtToken(sessionPayload);

    const response = NextResponse.json({
      success: true,
      user: sessionPayload,
      token,
    });

    // =========================================================================
    // [MOD FEATURE]: CHO PHEP DANG NHAP QUA HTTP TRONG MOI TRUONG TEST
    // Mô tả: Cờ secure chỉ bật khi chạy production VÀ biến USE_HTTPS = "true".
    //        Server test chạy HTTP thì đặt USE_HTTPS=false để trình duyệt chịu
    //        lưu cookie phiên.
    // CẢNH BÁO: khi secure = false, token JWT (chứa userId, role, hạn 7 ngày)
    //           đi qua mạng dưới dạng không mã hóa. CHỈ dùng trong mạng nội bộ.
    //           Khi chạy thật phải đặt USE_HTTPS=true và phục vụ qua HTTPS.
    // =========================================================================
    response.cookies.set('muvh_session', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production' && process.env.USE_HTTPS === 'true',
      sameSite: 'lax',
      path: '/',
      maxAge: 60 * 60 * 24 * 7, // 7 days
    });

    return response;
  } catch (err: any) {
    console.error('Login error:', err);
    return NextResponse.json({ error: err.message || 'Lỗi hệ thống khi đăng nhập' }, { status: 500 });
  }
}
