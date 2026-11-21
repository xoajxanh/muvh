import { NextRequest, NextResponse } from 'next/server';
import { randomUUID } from 'crypto';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { verifyFarmRequest } from '@/lib/farm-auth';
import { timChuSoHuu, LOI_BO_QUA } from '@/lib/farm-play';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - API BAO LOI ACC (KHONG CHAY DUOC TREN SERVER)
// Mo ta: Mod gap loi khong vuot qua duoc (vd "Server hien tai da day...")
//        -> bao ve day roi tu chuyen sang acc ke tiep.
//        Ghi vao BANG THEO DOI (Play) dung server, KHO MAC DINH khong dung toi.
//        Acc Lv200 KHONG bi ghi de neu da co ma moi (ACTIVE/INVITED/DONE)
//        - tranh lam mat tien do that.
// Body : { email, password?, serverId, serverName?, farmLevel (50|200),
//          status (SERVER_FULL), errorMsg?, createdBy?, ts, sign }
// Ky   : sign = MD5(email + serverId + status + ts + SALT)
// =========================================================================

const GIU_NGUYEN_LV200 = ['ACTIVE', 'INVITED', 'DONE', 'COMPLETE'];
const GIU_NGUYEN_LV50 = ['SUCCESS', 'ALREADY_USED', 'RESERVED'];

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();

    const email = String(body.email || '').trim();
    const serverId = parseInt(String(body.serverId), 10);
    const farmLevel = parseInt(String(body.farmLevel), 10) === 200 ? 200 : 50;
    const status = String(body.status || '').trim().toUpperCase();
    const errorMsg = body.errorMsg ? String(body.errorMsg).slice(0, 900) : null;

    if (!email || !Number.isFinite(serverId)) {
      return NextResponse.json({ ok: false, error: 'Thiếu email hoặc serverId' }, { status: 400 });
    }
    if (!LOI_BO_QUA.includes(status)) {
      return NextResponse.json({ ok: false, error: `status không hợp lệ: ${status}` }, { status: 400 });
    }

    const auth = await verifyFarmRequest([email, serverId, status], body.ts, body.sign, body.createdBy);
    if (!auth.ok) {
      return NextResponse.json({ ok: false, error: auth.error }, { status: auth.status });
    }

    const chu = await timChuSoHuu(farmLevel, email, serverId);
    const bang: any = farmLevel === 200 ? (prisma as any).farmInviterPlay : (prisma as any).farmInviteePlay;
    const giuNguyen = farmLevel === 200 ? GIU_NGUYEN_LV200 : GIU_NGUYEN_LV50;
    const truongLoi = farmLevel === 200 ? 'lastError' : 'errorMsg';

    const cu = await bang.findUnique({ where: { email_serverId: { email, serverId } } });
    if (cu && giuNguyen.includes(cu.status)) {
      // Da co tien do that -> chi ghi chu loi, khong doi trang thai
      await bang.update({
        where: { id: cu.id },
        data: { [truongLoi]: `${status}: ${errorMsg || ''}`.slice(0, 900), updatedAt: new Date() },
      });
      return NextResponse.json({ ok: true, status: cu.status, giuNguyen: true });
    }

    if (cu) {
      await bang.update({
        where: { id: cu.id },
        data: {
          masterId: cu.masterId || chu.masterId,
          stt: cu.stt || chu.stt,
          farmAccountId: chu.farmAccountId || cu.farmAccountId || null,
          jobCode: chu.jobCode || cu.jobCode || null,
          serverName: String(body.serverName || cu.serverName || ''),
          status,
          [truongLoi]: errorMsg,
          ...(farmLevel === 200 ? { failCount: (cu.failCount || 0) + 1, lastSyncAt: new Date() } : {}),
          updatedAt: new Date(),
        },
      });
    } else {
      await bang.create({
        data: {
          id: randomUUID(),
          masterId: chu.masterId,
          stt: chu.stt,
          farmAccountId: chu.farmAccountId,
          jobCode: chu.jobCode,
          email,
          password: String(body.password || ''),
          serverId,
          serverName: String(body.serverName || ''),
          status,
          [truongLoi]: errorMsg,
          ...(farmLevel === 200 ? { failCount: 1, lastSyncAt: new Date() } : {}),
          createdById: auth.createdById,
        },
      });
    }

    return NextResponse.json({ ok: true, status });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
