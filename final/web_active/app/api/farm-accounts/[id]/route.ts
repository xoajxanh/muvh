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
import { phanBoLaiTheoDoi, xoaTheoDoiCuaTaiKhoan, layViecDaChay } from '@/lib/farm-play';

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

    // =====================================================================
    // [MOD FEATURE]: SUA THEO TUNG CONG VIEC (khong khoa ca tai khoan)
    // Mo ta: Cong viec DA CHAY thi giu nguyen dai STT, khong xoa duoc.
    //        Cong viec CHUA CHAY sua / xoa tu do. Luon them duoc viec moi.
    //        Ghi theo kieu SO KHAC BIET - KHONG xoa roi tao lai toan bo, de
    //        viec dang chay giu nguyen trang thai, may dang giu, con tro STT.
    // =====================================================================
    // Khoa theo jobCode: 1 tai khoan co the co NHIEU viec cung level+server
    // (dai STT khac nhau, khong chong lan - da kiem tra trong chuanHoaCongViec).
    const dsCu: any[] = cu.ranges || [];
    const daChay = await layViecDaChay(dsCu);
    const cuTheoMa = new Map<string, any>(dsCu.map((r: any) => [String(r.jobCode), r]));
    const moiTheoMa = new Map<string, any>();
    const viecMoiGui: any[] = [];
    for (const k of kq.ds) {
      const ma = String((k as any).jobCode || '').trim();
      if (ma && cuTheoMa.has(ma) && !moiTheoMa.has(ma)) moiTheoMa.set(ma, k);
      else viecMoiGui.push(k);
    }

    // Mod dang nhap bang username -> co viec dang chay thi khong cho doi ten
    if (daChay.size > 0 && username !== cu.username) {
      return NextResponse.json(
        { error: 'Tài khoản đã có công việc chạy, không đổi được username (mod đang đăng nhập bằng tên này).' },
        { status: 409 },
      );
    }

    // Viec da chay: phai con nguyen trong danh sach gui len, khong doi level/server/dai STT
    for (const r of dsCu) {
      if (!daChay.has(r.jobCode)) continue;
      const m = moiTheoMa.get(String(r.jobCode));
      if (!m) {
        return NextResponse.json(
          { error: `Công việc ${r.jobCode} đã chạy, không xoá được.` },
          { status: 409 },
        );
      }
      if (m.farmLevel !== r.farmLevel || m.serverId !== r.serverId
        || m.rangeFrom !== r.rangeFrom || m.rangeTo !== r.rangeTo) {
        return NextResponse.json(
          { error: `Công việc ${r.jobCode} đã chạy, không sửa được (Lv${r.farmLevel} · S${r.serverId} · ${r.rangeFrom}–${r.rangeTo}).` },
          { status: 409 },
        );
      }
    }

    // Ma da dung: giu ma cua viec cu con lai, tranh cap trung trong lan nay
    const daCap = new Set<string>(Array.from(moiTheoMa.keys()));

    // Viec cu doi level/server (chua chay) -> cap lai jobCode cho dung dinh dang
    const capLaiMa = new Map<string, string>();
    for (const [ma, m] of Array.from(moiTheoMa.entries())) {
      const r = cuTheoMa.get(ma);
      const doiCap = m.farmLevel !== r.farmLevel || m.serverId !== r.serverId || username !== cu.username;
      if (!doiCap || daChay.has(ma)) continue;
      const maMoi = await jobCodeChuaDung(username, m.serverId, m.farmLevel, undefined, daCap);
      daCap.add(maMoi);
      capLaiMa.set(ma, maMoi);
    }

    // Sinh san jobCode cho cac viec MOI (ngoai transaction)
    const viecMoi: any[] = [];
    for (const m of viecMoiGui) {
      const ma = await jobCodeChuaDung(username, m.serverId, m.farmLevel, undefined, daCap);
      daCap.add(ma);
      viecMoi.push({
        farmLevel: m.farmLevel,
        serverId: m.serverId,
        serverName: m.serverName || '',
        rangeFrom: m.rangeFrom,
        rangeTo: m.rangeTo,
        jobCode: ma,
        status: 'NEW',
      });
    }

    // Server bi anh huong = server cua cong viec CU + cong viec MOI
    const serverAnhHuong: number[] = [
      ...dsCu.map((k: any) => Number(k.serverId)),
      ...kq.ds.map((k) => Number(k.serverId)),
    ];

    let doiChu = 0;
    const thongKe = { them: 0, sua: 0, xoa: 0, giuNguyen: 0 };
    await (prisma as any).$transaction(async (tx: any) => {
      await tx.farmAccount.update({
        where: { id },
        data: { username, password, note },
      });

      // Xoa viec cu khong con trong danh sach (chi viec CHUA chay - da kiem tra o tren)
      for (const [ma, r] of Array.from(cuTheoMa.entries())) {
        if (moiTheoMa.has(ma)) continue;
        await tx.farmAccountRange.delete({ where: { id: r.id } });
        thongKe.xoa++;
      }

      // Sua viec cu con trong danh sach
      for (const [ma, m] of Array.from(moiTheoMa.entries())) {
        const r = cuTheoMa.get(ma);
        const maMoi = capLaiMa.get(ma);
        const doiDai = m.farmLevel !== r.farmLevel || m.serverId !== r.serverId
          || m.rangeFrom !== r.rangeFrom || m.rangeTo !== r.rangeTo;
        const doiTen = (m.serverName || '') !== (r.serverName || '');
        if (!doiDai && !doiTen && !maMoi) { thongKe.giuNguyen++; continue; }
        await tx.farmAccountRange.update({
          where: { id: r.id },
          // Viec da chay chi doi duoc ten server (phan con lai da bi chan o tren)
          data: daChay.has(r.jobCode)
            ? { serverName: m.serverName || '' }
            : {
                farmLevel: m.farmLevel,
                serverId: m.serverId,
                rangeFrom: m.rangeFrom,
                rangeTo: m.rangeTo,
                serverName: m.serverName || '',
                ...(maMoi ? { jobCode: maMoi } : {}),
              },
        });
        thongKe.sua++;
      }

      // Them viec moi
      for (const v of viecMoi) {
        await tx.farmAccountRange.create({ data: { ...v, farmAccountId: id } });
        thongKe.them++;
      }

      doiChu = await phanBoLaiTheoDoi(serverAnhHuong, tx);
    });

    return NextResponse.json({ ok: true, doiChu, thongKe });
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
    // Chi chan khi co it nhat MOT cong viec da chay
    const daChayXoa = await layViecDaChay(cu.ranges || []);
    if (daChayXoa.size > 0) {
      return NextResponse.json(
        { error: `Tài khoản có ${daChayXoa.size} công việc đã chạy, không xoá được. Hãy xoá riêng các công việc chưa chạy trong màn sửa.` },
        { status: 409 },
      );
    }

    // =====================================================================
    // [MOD FEATURE]: XOA TAI KHOAN -> XOA LUON BAN GHI THEO DOI CUA NO
    // Thu tu: go lien ket "moi boi" -> xoa theo doi Lv50, Lv200 -> xoa cong
    // viec -> xoa tai khoan. Mot transaction, loi la hoan tac toan bo.
    // Kho mac dinh khong bi dung toi.
    // =====================================================================
    let daXoa = { lv200: 0, lv50: 0, goLienKet: 0 };
    await (prisma as any).$transaction(async (tx: any) => {
      daXoa = await xoaTheoDoiCuaTaiKhoan(id, tx);
      await tx.farmAccountRange.deleteMany({ where: { farmAccountId: id } });
      await tx.farmAccount.delete({ where: { id } });
    });
    return NextResponse.json({ ok: true, daXoa });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
