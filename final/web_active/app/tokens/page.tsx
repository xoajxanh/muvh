'use client';

import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import Navbar from '@/components/Navbar';
import Toast from '@/components/Toast';
import Link from 'next/link';
import {
  Key,
  PlusCircle,
  Search,
  Copy,
  Trash2,
  ExternalLink,
  CheckCircle2,
  AlertTriangle,
  Clock,
  RotateCcw,
  Ban,
} from 'lucide-react';

export default function TokensPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [tokens, setTokens] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [toast, setToast] = useState<{ message: string; type: 'success' | 'error' } | null>(null);

  useEffect(() => {
    fetch('/api/auth/me')
      .then((res) => {
        if (!res.ok) {
          router.push('/login');
          return null;
        }
        return res.json();
      })
      .then((resData) => {
        if (resData?.user) {
          setUser(resData.user);
          fetchTokens(search, statusFilter);
        }
      })
      .catch(() => router.push('/login'));
  }, [router]);

  const fetchTokens = async (searchQuery: string, status: string) => {
    setLoading(true);
    try {
      const url = `/api/tokens?search=${encodeURIComponent(searchQuery)}&status=${status}`;
      const res = await fetch(url);
      if (res.ok) {
        const json = await res.json();
        setTokens(json.tokens || []);
      }
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    fetchTokens(search, statusFilter);
  };

  const handleStatusChange = (newStatus: string) => {
    setStatusFilter(newStatus);
    fetchTokens(search, newStatus);
  };

  const handleCopyText = (text: string, label: string) => {
    navigator.clipboard.writeText(text);
    setToast({ message: `Đã copy ${label} vào Clipboard!`, type: 'success' });
  };

  const handleDeleteToken = async (id: string, sn: string, isHardDelete = false) => {
    const isSale = user.role === 'SALE';
    const confirmMsg = isSale
      ? `Bạn có chắc chắn muốn xóa Token của thiết bị [${sn}]?\n\nHành động này sẽ HỦY KÍCH HOẠT Token và ghi lại nhật ký cho Admin kiểm tra.`
      : isHardDelete
      ? `[CẢNH BÁO ADMIN] Bạn có chắc muốn XÓA VĨNH VIỄN Token của thiết bị [${sn}] khỏi cơ sở dữ liệu?`
      : `Bạn có chắc chắn muốn xóa (Soft Delete) Token của thiết bị [${sn}]?`;

    if (!confirm(confirmMsg)) return;

    try {
      const url = isHardDelete ? `/api/tokens/${id}?hard=true` : `/api/tokens/${id}`;
      const res = await fetch(url, { method: 'DELETE' });
      const json = await res.json();

      if (!res.ok) {
        setToast({ message: json.error || 'Lỗi khi xóa Token', type: 'error' });
        return;
      }

      setToast({ message: json.message || 'Xóa Token thành công!', type: 'success' });
      fetchTokens(search, statusFilter);
    } catch (e: any) {
      setToast({ message: e.message || 'Có lỗi xảy ra', type: 'error' });
    }
  };

  const handleRestoreToken = async (id: string, sn: string) => {
    if (!confirm(`[ADMIN] Bạn có chắc muốn KHÔI PHỤC lại Token của thiết bị [${sn}]?`)) return;

    try {
      const res = await fetch(`/api/tokens/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'RESTORE' }),
      });
      const json = await res.json();

      if (!res.ok) {
        setToast({ message: json.error || 'Lỗi khi khôi phục Token', type: 'error' });
        return;
      }

      setToast({ message: 'Đã khôi phục Token thành công!', type: 'success' });
      fetchTokens(search, statusFilter);
    } catch (e: any) {
      setToast({ message: e.message || 'Có lỗi xảy ra', type: 'error' });
    }
  };

  if (!user) {
    return (
      <div className="min-h-screen bg-[#0b0f19] flex items-center justify-center">
        <div className="w-8 h-8 border-4 border-cyan-500/20 border-t-cyan-500 rounded-full animate-spin"></div>
      </div>
    );
  }

  const now = new Date();
  const threeDaysLater = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);

  const getStatusBadge = (tok: any) => {
    if (tok.isDeleted) {
      return (
        <span className="px-2.5 py-1 rounded-full text-[10px] font-bold bg-rose-950/80 text-rose-300 border border-rose-500/40 flex items-center gap-1 w-max">
          <Ban className="w-3 h-3 text-rose-400" /> ĐÃ XÓA (SALE)
        </span>
      );
    }
    const exp = new Date(tok.expireAt);
    if (exp < now) {
      return (
        <span className="px-2.5 py-1 rounded-full text-[10px] font-bold bg-rose-500/10 text-rose-400 border border-rose-500/20 flex items-center gap-1 w-max">
          <Clock className="w-3 h-3" /> HẾT HẠN
        </span>
      );
    }
    if (exp <= threeDaysLater) {
      return (
        <span className="px-2.5 py-1 rounded-full text-[10px] font-bold bg-amber-500/10 text-amber-400 border border-amber-500/20 flex items-center gap-1 w-max animate-pulse">
          <AlertTriangle className="w-3 h-3" /> SẮP HẾT HẠN
        </span>
      );
    }
    return (
      <span className="px-2.5 py-1 rounded-full text-[10px] font-bold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 flex items-center gap-1 w-max">
        <CheckCircle2 className="w-3 h-3" /> HOẠT ĐỘNG
      </span>
    );
  };

  const filterOptions = [
    { label: 'TẤT CẢ', value: 'ALL' },
    { label: 'ĐANG HOẠT ĐỘNG', value: 'ACTIVE' },
    { label: 'SẮP HẾT HẠN (≤3D)', value: 'EXPIRING_SOON' },
    { label: 'ĐÃ HẾT HẠN', value: 'EXPIRED' },
    ...(user.role === 'ADMIN' ? [{ label: 'ĐÃ XÓA (BY SALE)', value: 'DELETED' }] : []),
  ];

  return (
    <div className="flex min-h-screen bg-[#0b0f19]">
      <Sidebar userRole={user.role} />

      <div className="flex-1 flex flex-col min-w-0">
        <Navbar user={user} />

        <main className="p-6 md:p-8 space-y-6 flex-1 overflow-y-auto">
          {toast && <Toast message={toast.message} type={toast.type} onClose={() => setToast(null)} />}

          {/* Top Bar */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <h1 className="text-2xl font-bold text-white flex items-center gap-2">
                Quản Lý Token Bản Quyền
                <Key className="w-5 h-5 text-cyan-400" />
              </h1>
              <p className="text-xs text-slate-400 mt-1">
                Danh sách toàn bộ token kích hoạt, kiểm tra trạng thái và lịch sử cập nhật
              </p>
            </div>

            <Link
              href="/tokens/create"
              className="px-5 py-2.5 gradient-button text-white text-sm font-semibold rounded-xl shadow-lg shadow-cyan-500/20 flex items-center gap-2 self-start sm:self-auto hover:scale-105 transition"
            >
              <PlusCircle className="w-4 h-4" />
              KÍCH HOẠT TOKEN MỚI
            </Link>
          </div>

          {/* Search & Filter Bar */}
          <div className="glass-card p-4 rounded-2xl flex flex-col md:flex-row gap-4 items-center justify-between">
            <form onSubmit={handleSearchSubmit} className="relative flex-1 w-full">
              <Search className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-500" />
              <input
                type="text"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                placeholder="Tìm theo Mã MD5, UID nhân vật hoặc Key..."
                className="w-full pl-10 pr-4 py-2.5 bg-slate-900/90 border border-slate-800 rounded-xl text-slate-100 placeholder-slate-500 focus:outline-none focus:border-cyan-500 text-xs transition"
              />
            </form>

            <div className="flex items-center gap-2 overflow-x-auto w-full md:w-auto">
              {filterOptions.map((filter) => (
                <button
                  key={filter.value}
                  onClick={() => handleStatusChange(filter.value)}
                  className={`px-3 py-2 rounded-xl text-[11px] font-semibold whitespace-nowrap transition ${
                    statusFilter === filter.value
                      ? 'bg-cyan-500/20 text-cyan-300 border border-cyan-500/40 shadow-sm'
                      : 'bg-slate-900/50 text-slate-400 hover:bg-slate-800'
                  }`}
                >
                  {filter.label}
                </button>
              ))}
            </div>
          </div>

          {/* Tokens Table */}
          <div className="glass-card p-6 rounded-2xl">
            {loading ? (
              <div className="py-12 text-center text-slate-400 text-xs flex items-center justify-center gap-2">
                <div className="w-5 h-5 border-2 border-cyan-500/20 border-t-cyan-500 rounded-full animate-spin"></div>
                Đang tải danh sách Token...
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs text-slate-300">
                  <thead className="bg-slate-900/80 uppercase text-slate-400 border-b border-slate-800 text-[11px]">
                    <tr>
                      <th className="py-3.5 px-4">Trạng Thái</th>
                      <th className="py-3.5 px-4">Mã Thiết Bị (MD5)</th>
                      <th className="py-3.5 px-4">UID Nhân Vật</th>
                      <th className="py-3.5 px-4">Gói VIP / Loại</th>
                      <th className="py-3.5 px-4">Hạn Sử Dụng</th>
                      <th className="py-3.5 px-4">Giá Tiền</th>
                      <th className="py-3.5 px-4">Người Tạo</th>
                      <th className="py-3.5 px-4 text-right">Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-800/60">
                    {tokens.map((tok) => {
                      const apiUrl = `${window.location.origin}/api/v1/config?sn=${tok.deviceSnMd5}&uid=${tok.characterUid}`;
                      return (
                        <tr
                          key={tok.id}
                          onClick={() => router.push(`/tokens/${tok.id}`)}
                          className="hover:bg-slate-800/50 cursor-pointer transition"
                        >
                          <td className="py-3.5 px-4">{getStatusBadge(tok)}</td>
                          <td className="py-3.5 px-4 font-mono font-bold text-cyan-300">
                            {tok.deviceSnMd5}
                          </td>
                          <td className="py-3.5 px-4 font-mono text-slate-200 font-medium">
                            {tok.characterUid}
                          </td>
                          <td className="py-3.5 px-4">
                            <span className="px-2.5 py-1 rounded bg-indigo-500/10 text-indigo-300 border border-indigo-500/20 font-semibold text-xs">
                              {tok.vipPackage?.name || (tok.isCustom ? 'Custom Config' : 'Mặc Định')}
                            </span>
                          </td>
                          <td className="py-3.5 px-4 font-medium text-slate-200">
                            {new Date(tok.expireAt).toLocaleDateString('vi-VN')} ({tok.durationDays}d)
                          </td>
                          <td className="py-3.5 px-4 font-semibold text-emerald-400">
                            {tok.price.toLocaleString('vi-VN')} đ
                          </td>
                          <td className="py-3.5 px-4 text-slate-400">{tok.createdBy?.displayName}</td>
                          <td className="py-3.5 px-4 text-right" onClick={(e) => e.stopPropagation()}>
                            <div className="inline-flex items-center justify-end gap-1.5">
                              <button
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleCopyText(tok.encryptedToken, 'Token mã hóa');
                                }}
                                className="h-8 w-8 inline-flex items-center justify-center bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-lg border border-slate-700/60 transition"
                                title="Copy Token mã hóa"
                              >
                                <Copy className="w-3.5 h-3.5" />
                              </button>

                              <button
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleCopyText(apiUrl, 'API URL');
                                }}
                                className="h-8 w-8 inline-flex items-center justify-center bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-lg border border-slate-700/60 transition"
                                title="Copy Endpoint API cho Mod"
                              >
                                <ExternalLink className="w-3.5 h-3.5" />
                              </button>

                              <Link
                                href={`/tokens/${tok.id}`}
                                onClick={(e) => e.stopPropagation()}
                                className="h-8 px-3 inline-flex items-center justify-center bg-cyan-600/20 hover:bg-cyan-600/30 text-cyan-300 border border-cyan-500/30 rounded-lg font-semibold text-[11px] transition"
                              >
                                Chi tiết ({tok._count?.notes || 0})
                              </Link>

                              {/* Restore Button for Admin when Token is Soft-Deleted */}
                              {user.role === 'ADMIN' && tok.isDeleted && (
                                <button
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    handleRestoreToken(tok.id, tok.deviceSnMd5);
                                  }}
                                  className="h-8 px-2.5 inline-flex items-center justify-center bg-emerald-600/20 hover:bg-emerald-600/30 text-emerald-400 border border-emerald-500/30 rounded-lg font-semibold text-[11px] transition"
                                  title="Khôi phục Token"
                                >
                                  <RotateCcw className="w-3.5 h-3.5 mr-1" /> Khôi phục
                                </button>
                              )}

                              {/* Delete Button (Soft Delete for Sale / Hard Delete or Soft Delete for Admin) */}
                              <button
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handleDeleteToken(tok.id, tok.deviceSnMd5, user.role === 'ADMIN' && tok.isDeleted);
                                }}
                                className="h-8 w-8 inline-flex items-center justify-center bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border border-rose-500/20 rounded-lg transition"
                                title={
                                  user.role === 'ADMIN' && tok.isDeleted
                                    ? 'Xóa vĩnh viễn khỏi Database'
                                    : 'Xóa Token (Hủy kích hoạt)'
                                }
                              >
                                <Trash2 className="w-3.5 h-3.5" />
                              </button>
                            </div>
                          </td>
                        </tr>
                      );
                    })}

                    {tokens.length === 0 && (
                      <tr>
                        <td colSpan={8} className="py-10 text-center text-slate-500 italic">
                          Không tìm thấy token nào phù hợp
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </main>
      </div>
    </div>
  );
}
