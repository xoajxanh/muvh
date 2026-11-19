import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';
import {
  chuanHoaUsername,
  chuanHoaCongViec,
  kiemTraTrung,
  kiemTraChongLanNhieu,
  jobCodeChuaDung,
} from '@/lib/farm-account';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - SUA / XOA MOT TAI KHOAN FARM_KC
// Mo ta: CHI cho sua - xoa khi ban ghi CHUA chay (status = 'NEW'). Khi bot
//        da dong bo cong viec len he thong (status khac NEW) thi khoa lai.
// =========================================================================

async function layBanGhi(id: string) {
  return (prisma as any).farmAccount.findUnique({
    where: { id },
    include: { ranges: true },
  });
}

export async function PUT(req: NextRequest, ctx: { params: { id: string } }) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  if (session.role !== 'ADMIN') {
    return NextResponse.json({ error: 'Chỉ ADMIN được sửa tài khoản FARM_KC' }, { status: 403 });
  }

  try {
    const id = ctx.params.id;
    const cu = await layBanGhi(id);
    if (!cu) return NextResponse.json({ error: 'Không tìm thấy bản ghi' }, { status: 404 });
    if (cu.status !== 'NEW') {
      return NextResponse.json(
        { error: 'Tài khoản đã bắt đầu chạy, không sửa được nữa' },
        { status: 409 },
      );
    }

    const body = await req.json();
    const username = chuanHoaUsername(body.username ?? cu.username);
    const password = String(body.password ?? cu.password).trim();
    const note = body.note === undefined ? cu.note : String(body.note || '').trim() || null;

    if (!username) return NextResponse.json({ error: 'Chưa nhập username' }, { status: 400 });
    if (!password) return NextResponse.json({ error: 'Chưa nhập mật khẩu' }, { status: 400 });

    const kq = chuanHoaCongViec(body.ranges);
    if (!kq.ok) return NextResponse.json({ error: kq.loi }, { status: 400 });

    const trung = await kiemTraTrung(username, id);
    if (trung) return NextResponse.json({ error: `Username "${username}" đã tồn tại` }, { status: 409 });

    const chongLan = await kiemTraChongLanNhieu({ ds: kq.ds, boQuaId: id });
    if (chongLan) {
      return NextResponse.json(
        {
          error: `Lv${chongLan.farmLevel} · server ${chongLan.serverId}: khoảng STT bị chồng lấn với tài khoản "${chongLan.username}" (${chongLan.rangeFrom}–${chongLan.rangeTo})`,
        },
        { status: 409 },
      );
    }

    // Giu nguyen jobCode cu cho cong viec cung (level, server) de mod dang
    // chay khong bi mat ma; cong viec moi thi sinh ma moi.
    const maCu = new Map<string, string>();
    (cu.ranges || []).forEach((k: any) => maCu.set(`${k.farmLevel}|${k.serverId}`, k.jobCode));
    const dsGhi = await Promise.all(
      kq.ds.map(async (k) => ({
        ...k,
        jobCode:
          maCu.get(`${k.farmLevel}|${k.serverId}`) ||
          (await jobCodeChuaDung(username, k.serverId, k.farmLevel, id)),
        status: 'NEW',
      })),
    );

    // Ghi lai toan bo khoang: xoa cai cu roi tao lai theo danh sach moi
    await (prisma as any).$transaction([
      (prisma as any).farmAccountRange.deleteMany({ where: { farmAccountId: id } }),
      (prisma as any).farmAccount.update({
        where: { id },
        data: {
          username,
          password,
          note,
          ranges: { create: dsGhi },
        },
      }),
    ]);

    return NextResponse.json({ ok: true });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}

export async function DELETE(req: NextRequest, ctx: { params: { id: string } }) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  if (session.role !== 'ADMIN') {
    return NextResponse.json({ error: 'Chỉ ADMIN được xoá tài khoản FARM_KC' }, { status: 403 });
  }

  try {
    const id = ctx.params.id;
    const cu = await layBanGhi(id);
    if (!cu) return NextResponse.json({ error: 'Không tìm thấy bản ghi' }, { status: 404 });
    if (cu.status !== 'NEW') {
      return NextResponse.json(
        { error: 'Tài khoản đã bắt đầu chạy, không xoá được nữa' },
        { status: 409 },
      );
    }

    await (prisma as any).$transaction([
      (prisma as any).farmAccountRange.deleteMany({ where: { farmAccountId: id } }),
      (prisma as any).farmAccount.delete({ where: { id } }),
    ]);
    return NextResponse.json({ ok: true });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
