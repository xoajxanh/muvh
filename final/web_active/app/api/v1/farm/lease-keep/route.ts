import { NextRequest, NextResponse } from 'next/server';
import { prisma, ensureInitialSeed } from '@/lib/db';
import { buildSign, MAX_TS_SKEW_SECONDS } from '@/lib/farm-auth';

export const dynamic = 'force-dynamic';

// =========================================================================
// [MOD FEATURE]: FARM KC - GIA HAN / NHA KHOA CO HAN
// Mo ta: mod goi dinh ky (nhip tim 60s) de gia han CA LO dang giu, va goi
//        mot lan khi bam KET THUC de nha ngay, khong bat may khac cho 15 phut.
//        Chi dong vao dong ma CHINH MAY NAY dang giu -> khong the cuop cua
//        may khac, cung khong the nha nham lo cua nguoi ta.
//
// POST /api/v1/farm/lease-keep
// Body: { mode: "200"|"50", serverId, deviceId, nha?: true, ts, sign }
// Ky: sign = MD5(deviceId + serverId + ts + SALT)
// =========================================================================

const LEASE_PHUT = 15;

export async function POST(req: NextRequest) {
  try {
    await ensureInitialSeed();
    const body = await req.json();

    const mode = String(body.mode || '200').trim();
    const serverId = parseInt(String(body.serverId ?? 0), 10) || 0;
    const deviceId = String(body.deviceId || '').trim();
    const nha = body.nha === true;
    const ts = body.ts;
    const sign = String(body.sign || '');

    if (!deviceId) {
      return NextResponse.json({ ok: false, error: 'Thiếu deviceId' }, { status: 400 });
    }
    if (!serverId) {
      return NextResponse.json({ ok: false, error: 'Thiếu serverId' }, { status: 400 });
    }
    const tsNum = Number(ts);
    if (!Number.isFinite(tsNum) || Math.abs(Math.floor(Date.now() / 1000) - tsNum) > MAX_TS_SKEW_SECONDS) {
      return NextResponse.json({ ok: false, error: 'Request hết hạn hoặc ts không hợp lệ' }, { status: 401 });
    }
    if (buildSign([deviceId, serverId], ts).toLowerCase() !== sign.toLowerCase()) {
      return NextResponse.json({ ok: false, error: 'Chữ ký không hợp lệ' }, { status: 401 });
    }

    const laLv200 = mode !== '50';
    const theoDoi: any = laLv200 ? (prisma as any).farmInviterPlay : (prisma as any).farmInviteePlay;

    const ket = await theoDoi.updateMany({
      where: { serverId, leaseDeviceId: deviceId },
      data: nha
        ? { leaseDeviceId: null, leaseDeviceName: null, leaseUntil: null }
        : { leaseUntil: new Date(Date.now() + LEASE_PHUT * 60 * 1000) },
    });

    return NextResponse.json({
      ok: true,
      hanhDong: nha ? 'NHA' : 'GIA_HAN',
      soDong: ket.count || 0,
      leasePhut: nha ? 0 : LEASE_PHUT,
    });
  } catch (err: any) {
    return NextResponse.json({ ok: false, error: err.message || 'Lỗi máy chủ' }, { status: 500 });
  }
}
