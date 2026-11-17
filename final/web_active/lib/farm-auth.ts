import crypto from 'crypto';
import { prisma } from './db';

// =========================================================================
// [MOD FEATURE]: FARM KC - XÁC THỰC REQUEST TỪ BẢN MOD FARM
// Mô tả: Mọi request từ mod kèm ts (unix giây) + sign = MD5(<các tham số theo
//        thứ tự cố định> + ts + FARM_SECRET_SALT). Server kiểm tra sign và
//        |now - ts| <= 300s. createdBy = username web -> tra ra createdById.
// =========================================================================

export const FARM_SECRET_SALT =
  process.env.FARM_SECRET_SALT || 'MUVH_FARM_KC_SALT_2026_XOAI';

export const MAX_TS_SKEW_SECONDS = 300;

export function md5(text: string): string {
  return crypto.createHash('md5').update(text, 'utf8').digest('hex');
}

/** Tạo chữ ký: MD5(giá trị các tham số nối liền + ts + salt) */
export function buildSign(parts: (string | number | null | undefined)[], ts: string | number): string {
  const joined = parts.map((p) => (p === null || p === undefined ? '' : String(p))).join('');
  return md5(joined + String(ts) + FARM_SECRET_SALT);
}

export type FarmAuthResult =
  | { ok: true; createdById: string; username: string }
  | { ok: false; status: number; error: string };

/**
 * Kiểm tra ts + sign + createdBy.
 * @param signParts các tham số tham gia ký, ĐÚNG THỨ TỰ đã quy ước với mod.
 */
export async function verifyFarmRequest(
  signParts: (string | number | null | undefined)[],
  ts: string | number | null | undefined,
  sign: string | null | undefined,
  createdBy: string | null | undefined
): Promise<FarmAuthResult> {
  if (!ts || !sign) {
    return { ok: false, status: 400, error: 'Thiếu tham số ts hoặc sign' };
  }

  const tsNum = Number(ts);
  if (!Number.isFinite(tsNum)) {
    return { ok: false, status: 400, error: 'ts không hợp lệ' };
  }

  const nowSec = Math.floor(Date.now() / 1000);
  if (Math.abs(nowSec - tsNum) > MAX_TS_SKEW_SECONDS) {
    return { ok: false, status: 401, error: 'Request hết hạn (lệch giờ quá 300s)' };
  }

  const expected = buildSign(signParts, ts);
  if (expected.toLowerCase() !== String(sign).toLowerCase()) {
    return { ok: false, status: 401, error: 'Chữ ký không hợp lệ' };
  }

  if (!createdBy || String(createdBy).trim() === '') {
    return { ok: false, status: 400, error: 'Thiếu createdBy (username web)' };
  }

  const user = await prisma.user.findUnique({
    where: { username: String(createdBy).trim() },
    select: { id: true, username: true },
  });

  if (!user) {
    return { ok: false, status: 400, error: `Username web "${createdBy}" không tồn tại` };
  }

  return { ok: true, createdById: user.id, username: user.username };
}

/** BigInt không JSON.stringify được -> chuyển sang string/number an toàn */
export function safeNum(v: any): number {
  if (v === null || v === undefined) return 0;
  if (typeof v === 'bigint') return Number(v);
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
}
