'use client';

import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import Navbar from '@/components/Navbar';
import { Gift, RefreshCw, Search, Eye, EyeOff, ChevronLeft, ChevronRight, Crown, UserPlus } from 'lucide-react';

// =========================================================================
// [MOD FEATURE]: FARM KC - TRANG MA MOI RONG VANG (GOP 2 BANG VAO 1 MENU)
// Mô tả: Một trang duy nhất, chuyển nhanh giữa ACC 200 (người mời) và
//        ACC 50 (người được mời) bằng nút gạt. Phân trang phía server.
//        Mật khẩu acc game ẩn mặc định, chỉ ADMIN bấm mới xem.
// =========================================================================

type Tab = 'inviters' | 'invitees';

const STATUS_STYLE: Record<string, string> = {
  ACTIVE: 'bg-sky-500/15 text-sky-300 border-sky-500/30',
  COMPLETE: 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30',
  DONE: 'bg-violet-500/15 text-violet-300 border-violet-500/30',
  ERROR: 'bg-rose-500/15 text-rose-300 border-rose-500/30',
  SUCCESS: 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30',
  RESERVED: 'bg-amber-500/15 text-amber-300 border-amber-500/30',
  FAILED: 'bg-rose-500/15 text-rose-300 border-rose-500/30',
  EXPIRED: 'bg-slate-500/15 text-slate-300 border-slate-500/30',
  ALREADY_USED: 'bg-violet-500/15 text-violet-300 border-violet-500/30',
  NO_CODE: 'bg-sky-500/15 text-sky-300 border-sky-500/30',
};

const STATUS_LABEL: Record<string, string> = {
  ACTIVE: 'Còn suất mời',
  COMPLETE: 'Đã đủ 5 người mời',
  DONE: 'Đã nhận thưởng xong',
  ERROR: 'Lỗi, cần xem lại',
  SUCCESS: 'Nhập mã thành công',
  RESERVED: 'Đang giữ chỗ',
  FAILED: 'Nhập mã thất bại',
  EXPIRED: 'Hết hạn giữ chỗ',
  ALREADY_USED: 'Đã nhập mã từ trước',
  NO_CODE: 'Lúc xin không còn mã',
};

const FILTER_OPTIONS: Record<Tab, { value: string; label: string }[]> = {
  inviters: [
    { value: '', label: 'Tất cả' },
    { value: 'ACTIVE', label: 'Còn suất' },
    { value: 'COMPLETE', label: 'Đủ 5 người' },
    { value: 'DONE', label: 'Đã xong' },
    { value: 'ERROR', label: 'Lỗi' },
  ],
  invitees: [
    { value: '', label: 'Tất cả' },
    { value: 'SUCCESS', label: 'Thành công' },
    { value: 'RESERVED', label: 'Giữ chỗ' },
    { value: 'FAILED', label: 'Thất bại' },
    { value: 'ALREADY_USED', label: 'Đã nhập trước' },
    { value: 'NO_CODE', label: 'Hết mã' },
    { value: 'EXPIRED', label: 'Hết hạn' },
  ],
};

export default function FarmKcPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [tab, setTab] = useState<Tab>('inviters');
  const [items, setItems] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [total, setTotal] = useState(0);
  const [totalPages, setTotalPages] = useState(1);
  const [isAdmin, setIsAdmin] = useState(false);
  const [keyword, setKeyword] = useState('');
  const [status, setStatus] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const pageSize = 20;

  useEffect(() => {
    fetch('/api/auth/me')
      .then((res) => (res.ok ? res.json() : null))
      .then((d) => {
        if (d?.user) setUser(d.user);
        else router.push('/login');
      })
      .catch(() => router.push('/login'));
  }, [router]);

  const load = async (p = 1, t: Tab = tab, st: string = status) => {
    setLoading(true);
    try {
      const q = new URLSearchParams({ page: String(p), pageSize: String(pageSize) });
      if (keyword.trim()) q.set('q', keyword.trim());
      if (st) q.set('status', st);
      if (showPassword) q.set('showPassword', '1');

      const res = await fetch(`/api/farm/${t}?${q}`);
      if (res.ok) {
        const j = await res.json();
        setItems(j.items || []);
        setTotal(j.total || 0);
        setTotalPages(j.totalPages || 1);
        setIsAdmin(!!j.isAdmin);
        setPage(j.page || p);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user) load(1, tab, status);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user, tab, status, showPassword]);

  const doiTab = (t: Tab) => {
    if (t === tab) return;
    setTab(t);
    setStatus('');
    setKeyword('');
    setItems([]);
  };

  const fmtTime = (v: any) => {
    if (!v) return '-';
    try { return new Date(v).toLocaleString('vi-VN'); } catch { return '-'; }
  };
  const fmtNum = (v: any) => (typeof v === 'number' ? v.toLocaleString('vi-VN') : '0');

  const Badge = ({ st }: { st: string }) => (
    <span
      title={STATUS_LABEL[st] || ''}
      className={`px-2.5 py-1 rounded-lg text-[11px] font-semibold border ${
        STATUS_STYLE[st] || 'bg-slate-700/30 text-slate-300 border-slate-600/40'
      }`}
    >
      {st}
    </span>
  );

  if (!user) return null;

  const laAcc200 = tab === 'inviters';

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar userRole={user.role} />
      <div className="flex-1 flex flex-col min-w-0">
        <Navbar user={user} />

        <main className="flex-1 p-6 space-y-5 overflow-x-hidden">
          <div className="flex items-center justify-between flex-wrap gap-3">
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 rounded-xl bg-amber-500/10 border border-amber-500/30 flex items-center justify-center">
                <Gift className="w-6 h-6 text-amber-400" />
              </div>
              <div>
                <h1 className="text-xl font-bold text-white">Farm KC — Mã mời Rồng Vàng</h1>
                <p className="text-sm text-slate-400">
                  {laAcc200 ? 'Tài khoản Lv200 tạo mã mời' : 'Tài khoản Lv50 nhập mã mời'} · {fmtNum(total)} dòng
                </p>
              </div>
            </div>

            <button
              onClick={() => load(page)}
              className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-sm font-medium transition"
            >
              <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
              Tải lại
            </button>
          </div>

          <div className="inline-flex p-1 rounded-xl bg-slate-900 border border-slate-800">
            <button
              onClick={() => doiTab('inviters')}
              className={`flex items-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold transition ${
                laAcc200
                  ? 'bg-gradient-to-r from-amber-600 to-orange-600 text-white shadow-lg shadow-amber-500/20'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              <Crown className="w-4 h-4" />
              ACC 200 · Người mời
            </button>
            <button
              onClick={() => doiTab('invitees')}
              className={`flex items-center gap-2 px-5 py-2.5 rounded-lg text-sm font-semibold transition ${
                !laAcc200
                  ? 'bg-gradient-to-r from-sky-600 to-indigo-600 text-white shadow-lg shadow-sky-500/20'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              <UserPlus className="w-4 h-4" />
              ACC 50 · Được mời
            </button>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <div className="relative flex-1 min-w-[220px]">
              <Search className="w-4 h-4 text-slate-500 absolute left-3 top-1/2 -translate-y-1/2" />
              <input
                value={keyword}
                onChange={(e) => setKeyword(e.target.value)}
                onKeyDown={(e) => { if (e.key === 'Enter') load(1); }}
                placeholder="Tìm email / tên nhân vật / mã mời rồi Enter..."
                className="w-full pl-10 pr-4 py-2.5 rounded-xl bg-slate-900 border border-slate-800 text-sm text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-sky-600"
              />
            </div>

            {isAdmin && (
              <button
                onClick={() => setShowPassword((v) => !v)}
                className={`flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm font-medium transition border ${
                  showPassword
                    ? 'bg-rose-500/10 border-rose-500/30 text-rose-300'
                    : 'bg-slate-900 border-slate-800 text-slate-400 hover:text-slate-200'
                }`}
              >
                {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                {showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
              </button>
            )}
          </div>

          <div className="flex flex-wrap items-center gap-2">
            {FILTER_OPTIONS[tab].map((o) => (
              <button
                key={o.value}
                onClick={() => setStatus(o.value)}
                className={`px-3.5 py-1.5 rounded-lg text-xs font-semibold border transition ${
                  status === o.value
                    ? 'bg-slate-700 border-slate-600 text-white'
                    : 'bg-slate-900 border-slate-800 text-slate-400 hover:text-slate-200 hover:border-slate-700'
                }`}
              >
                {o.label}
              </button>
            ))}
          </div>

          <div className="rounded-2xl border border-slate-800 bg-slate-900/40 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-slate-900/80 text-slate-400 text-xs uppercase tracking-wide">
                    <th className="px-4 py-3 text-left font-semibold">Email</th>
                    {showPassword && <th className="px-4 py-3 text-left font-semibold">Mật khẩu</th>}
                    <th className="px-4 py-3 text-left font-semibold">Server</th>
                    <th className="px-4 py-3 text-left font-semibold">Nhân vật</th>
                    <th className="px-4 py-3 text-center font-semibold">Lv</th>
                    <th className="px-4 py-3 text-left font-semibold">{laAcc200 ? 'Mã mời' : 'Mã đã nhập'}</th>
                    {laAcc200 ? (
                      <>
                        <th className="px-4 py-3 text-center font-semibold">Đã mời</th>
                        <th className="px-4 py-3 text-right font-semibold">Vàng</th>
                        <th className="px-4 py-3 text-right font-semibold">KC</th>
                      </>
                    ) : (
                      <>
                        <th className="px-4 py-3 text-left font-semibold">Người mời</th>
                        <th className="px-4 py-3 text-left font-semibold">Lỗi</th>
                      </>
                    )}
                    <th className="px-4 py-3 text-center font-semibold">Trạng thái</th>
                    <th className="px-4 py-3 text-left font-semibold">Thời điểm</th>
                    <th className="px-4 py-3 text-left font-semibold">Người tạo</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60">
                  {loading ? (
                    <tr><td colSpan={13} className="px-4 py-10 text-center text-slate-500">Đang tải...</td></tr>
                  ) : items.length === 0 ? (
                    <tr><td colSpan={13} className="px-4 py-10 text-center text-slate-500">Chưa có dữ liệu</td></tr>
                  ) : (
                    items.map((r) => (
                      <tr key={r.id} className="hover:bg-slate-800/30 transition">
                        <td className="px-4 py-3 text-slate-200 whitespace-nowrap">{r.email}</td>
                        {showPassword && <td className="px-4 py-3 text-rose-300 font-mono text-xs">{r.password || '-'}</td>}
                        <td className="px-4 py-3 text-slate-400 whitespace-nowrap">{r.serverName || r.serverId}</td>
                        <td className="px-4 py-3 text-slate-300 whitespace-nowrap">{r.roleName || '-'}</td>
                        <td className="px-4 py-3 text-center text-slate-400">{r.level || '-'}</td>
                        <td className="px-4 py-3">
                          {r.inviteCode ? (
                            <span className="font-mono text-xs text-amber-300 bg-amber-500/10 px-2 py-1 rounded-lg border border-amber-500/20">
                              {r.inviteCode}
                            </span>
                          ) : (
                            <span className="text-slate-600 text-xs">{laAcc200 ? 'chưa tạo' : '-'}</span>
                          )}
                        </td>

                        {laAcc200 ? (
                          <>
                            <td className="px-4 py-3 text-center whitespace-nowrap">
                              <div>
                                <span className={`font-semibold ${r.usedCount >= r.maxInvites ? 'text-emerald-400' : 'text-slate-200'}`}>
                                  {r.usedCount}/{r.maxInvites}
                                </span>
                                {r.reservedCount > 0 && (
                                  <span className="ml-1 text-[11px] text-amber-400">(+{r.reservedCount})</span>
                                )}
                              </div>
                              {/* Tổng = mốc game báo lần đăng nhập cuối + phần web cấp thêm sau đó.
                                  Còn số "web" > 0 nghĩa là acc Lv200 chưa đăng nhập lại để chốt sổ. */}
                              <div
                                className="text-[10px] mt-0.5"
                                title="game = số acc Lv200 báo về lần đăng nhập cuối · web = số lượt web cấp thêm sau đó (chưa được game xác nhận)"
                              >
                                <span className="text-slate-500">game {r.gameInviteNum}</span>
                                <span className="text-slate-600"> + </span>
                                <span className={r.confirmedCount > 0 ? 'text-amber-400' : 'text-slate-500'}>
                                  web {r.confirmedCount}
                                </span>
                              </div>
                            </td>
                            <td className="px-4 py-3 text-right text-slate-300 font-mono text-xs">{fmtNum(r.unboundGold)}</td>
                            <td className="px-4 py-3 text-right text-cyan-300 font-mono text-xs">{fmtNum(r.unboundDiamond)}</td>
                          </>
                        ) : (
                          <>
                            <td className="px-4 py-3 text-slate-400 text-xs whitespace-nowrap">{r.inviterEmail || '-'}</td>
                            <td className="px-4 py-3 text-rose-400 text-xs max-w-[200px] truncate" title={r.errorMsg || ''}>
                              {r.errorMsg || '-'}
                            </td>
                          </>
                        )}

                        <td className="px-4 py-3 text-center">
                          <Badge st={r.status} />
                          {laAcc200 && r.failCount > 0 && (
                            <div className="text-[11px] text-rose-400 mt-1">lỗi x{r.failCount}</div>
                          )}
                        </td>
                        <td className="px-4 py-3 text-slate-500 text-xs whitespace-nowrap">
                          {fmtTime(laAcc200 ? (r.lastSyncAt || r.updatedAt) : (r.confirmedAt || r.updatedAt))}
                        </td>
                        <td className="px-4 py-3 text-slate-500 text-xs whitespace-nowrap">{r.createdBy || '-'}</td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>

            <div className="flex items-center justify-between px-4 py-3 border-t border-slate-800 bg-slate-900/60">
              <p className="text-xs text-slate-500">Trang {page}/{totalPages} · {fmtNum(total)} dòng</p>
              <div className="flex items-center gap-2">
                <button
                  disabled={page <= 1 || loading}
                  onClick={() => load(page - 1)}
                  className="p-2 rounded-lg bg-slate-800 text-slate-300 disabled:opacity-30 disabled:cursor-not-allowed hover:bg-slate-700 transition"
                >
                  <ChevronLeft className="w-4 h-4" />
                </button>
                <button
                  disabled={page >= totalPages || loading}
                  onClick={() => load(page + 1)}
                  className="p-2 rounded-lg bg-slate-800 text-slate-300 disabled:opacity-30 disabled:cursor-not-allowed hover:bg-slate-700 transition"
                >
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
