'use client';

import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import Navbar from '@/components/Navbar';
import {
  DollarSign,
  Key,
  AlertTriangle,
  TrendingUp,
  PlusCircle,
  Clock,
  ChevronRight,
  Sparkles,
} from 'lucide-react';
import Link from 'next/link';

export default function DashboardPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<any>(null);

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
          loadDashboardData();
        }
      })
      .catch(() => router.push('/login'));
  }, [router]);

  const loadDashboardData = async () => {
    try {
      const res = await fetch('/api/dashboard');
      if (res.ok) {
        const json = await res.json();
        setData(json);
      }
    } catch (e) {
      console.error('Failed to load dashboard data:', e);
    } finally {
      setLoading(false);
    }
  };

  if (loading || !user) {
    return (
      <div className="min-h-screen bg-[#0b0f19] flex items-center justify-center">
        <div className="flex flex-col items-center gap-3">
          <div className="w-10 h-10 border-4 border-cyan-500/20 border-t-cyan-500 rounded-full animate-spin"></div>
          <span className="text-sm font-medium text-slate-400">Đang tải Dashboard...</span>
        </div>
      </div>
    );
  }

  const summary = data?.summary || {
    totalRevenue: 0,
    monthRevenue: 0,
    totalTokens: 0,
    monthTokens: 0,
    expiringSoon: 0,
    expired: 0,
  };

  const monthlyChartData = data?.monthlyChartData || [];
  const maxRevenue = Math.max(...monthlyChartData.map((d: any) => d.revenue), 1000000);
  const maxTokens = Math.max(...monthlyChartData.map((d: any) => d.tokens), 5);

  // Calculate SVG Line Path & Points for Tokens count
  const chartWidth = 1200;
  const chartHeight = 200;
  const points = monthlyChartData.map((item: any, i: number) => {
    const x = (i + 0.5) * (chartWidth / 12);
    const y = 175 - (item.tokens / maxTokens) * 135;
    return { x, y, tokens: item.tokens, month: item.month };
  });

  const linePathD = points.reduce((acc: string, pt: any, idx: number) => {
    return idx === 0 ? `M ${pt.x} ${pt.y}` : `${acc} L ${pt.x} ${pt.y}`;
  }, '');

  const areaPathD = points.length > 0
    ? `${linePathD} L ${points[points.length - 1].x} 190 L ${points[0].x} 190 Z`
    : '';

  return (
    <div className="flex min-h-screen bg-[#0b0f19]">
      <Sidebar userRole={user.role} />

      <div className="flex-1 flex flex-col min-w-0">
        <Navbar user={user} />

        <main className="p-6 md:p-8 space-y-8 flex-1 overflow-y-auto">
          {/* Header Action Bar */}
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <h1 className="text-2xl font-bold text-white flex items-center gap-2">
                Tổng Quan Quản Trị
                <Sparkles className="w-5 h-5 text-cyan-400" />
              </h1>
              <p className="text-xs text-slate-400 mt-1">
                Theo dõi doanh thu, số lượng token kích hoạt và cảnh báo hết hạn
              </p>
            </div>

            <Link
              href="/tokens/create"
              className="px-5 py-2.5 gradient-button text-white text-sm font-semibold rounded-xl shadow-lg shadow-cyan-500/20 flex items-center gap-2 self-start sm:self-auto hover:scale-105 transition"
            >
              <PlusCircle className="w-4 h-4" />
              TẠO TOKEN MỚI
            </Link>
          </div>

          {/* KPI Summary Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            {/* Card 1: Tổng Doanh Thu */}
            <div className="glass-card p-6 rounded-2xl relative overflow-hidden group">
              <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition">
                <DollarSign className="w-16 h-16 text-cyan-400" />
              </div>
              <div className="flex items-center gap-3 text-cyan-400 text-xs font-semibold uppercase tracking-wider mb-2">
                <DollarSign className="w-4 h-4" />
                Tổng Doanh Thu
              </div>
              <div className="text-2xl font-black text-white">
                {summary.totalRevenue.toLocaleString('vi-VN')} <span className="text-xs font-medium text-slate-400">VNĐ</span>
              </div>
              <div className="text-xs text-slate-400 mt-2 flex items-center gap-1">
                <TrendingUp className="w-3.5 h-3.5 text-emerald-400" />
                Tháng này: <span className="text-slate-200 font-semibold">{summary.monthRevenue.toLocaleString('vi-VN')} VNĐ</span>
              </div>
            </div>

            {/* Card 2: Tổng Token Đã Tạo */}
            <div className="glass-card p-6 rounded-2xl relative overflow-hidden group">
              <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition">
                <Key className="w-16 h-16 text-indigo-400" />
              </div>
              <div className="flex items-center gap-3 text-indigo-400 text-xs font-semibold uppercase tracking-wider mb-2">
                <Key className="w-4 h-4" />
                Tổng Token Đã Tạo
              </div>
              <div className="text-2xl font-black text-white">
                {summary.totalTokens} <span className="text-xs font-medium text-slate-400">Tokens</span>
              </div>
              <div className="text-xs text-slate-400 mt-2">
                Tháng này: <span className="text-slate-200 font-semibold">{summary.monthTokens} tokens</span> mới
              </div>
            </div>

            {/* Card 3: Cảnh Báo Sắp Hết Hạn (< 3 Ngày) */}
            <div className="glass-card p-6 rounded-2xl relative overflow-hidden border-amber-500/30 bg-gradient-to-br from-slate-900/90 to-amber-950/20 group">
              <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition">
                <AlertTriangle className="w-16 h-16 text-amber-400" />
              </div>
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-2 text-amber-400 text-xs font-semibold uppercase tracking-wider">
                  <AlertTriangle className="w-4 h-4" />
                  Sắp Hết Hạn (≤ 3 Ngày)
                </div>
                <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-amber-500/20 text-amber-300 border border-amber-500/30 animate-pulse">
                  CẢNH BÁO
                </span>
              </div>
              <div className="text-2xl font-black text-amber-300">
                {summary.expiringSoon} <span className="text-xs font-medium text-amber-400/70">Tokens</span>
              </div>
              <div className="text-xs text-slate-400 mt-2">
                Cần chăm sóc & gia hạn ngay cho khách
              </div>
            </div>

            {/* Card 4: Token Đã Hết Hạn */}
            <div className="glass-card p-6 rounded-2xl relative overflow-hidden group">
              <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition">
                <Clock className="w-16 h-16 text-rose-400" />
              </div>
              <div className="flex items-center gap-3 text-rose-400 text-xs font-semibold uppercase tracking-wider mb-2">
                <Clock className="w-4 h-4" />
                Token Đã Hết Hạn
              </div>
              <div className="text-2xl font-black text-white">
                {summary.expired} <span className="text-xs font-medium text-slate-400">Tokens</span>
              </div>
              <div className="text-xs text-slate-400 mt-2">
                Đã bị hệ thống tạm dừng active remote
              </div>
            </div>
          </div>

          {/* Monthly Revenue & Tokens Chart (Bar + Line Overlay) */}
          <div className="glass-card p-6 rounded-2xl space-y-4">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <div>
                <h3 className="font-bold text-slate-100 text-base">
                  Thống Kê Doanh Thu & Số Lượng Token Theo Tháng ({new Date().getFullYear()})
                </h3>
                <p className="text-xs text-slate-400">
                  Cột thể hiện Doanh thu (VNĐ) | Đường Line thể hiện Số lượng Token phát hành
                </p>
              </div>

              {/* Chart Legend */}
              <div className="flex items-center gap-4 text-xs font-semibold">
                <div className="flex items-center gap-2">
                  <span className="w-3 h-3 rounded-sm bg-gradient-to-t from-indigo-500 to-cyan-400"></span>
                  <span className="text-cyan-300">Doanh Thu (Cột)</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="w-3.5 h-1 bg-emerald-400 rounded-full"></span>
                  <span className="text-emerald-400">Số Token (Line)</span>
                </div>
              </div>
            </div>

            {/* Combined Chart Area */}
            <div className="relative h-72 pt-8 pb-4 border-b border-slate-800">
              {/* SVG Overlay Line Chart */}
              <svg
                viewBox={`0 0 ${chartWidth} ${chartHeight}`}
                className="absolute inset-x-0 bottom-8 w-full h-[200px] pointer-events-none z-10"
                preserveAspectRatio="none"
              >
                <defs>
                  <linearGradient id="lineGrad" x1="0" y1="0" x2="1" y2="0">
                    <stop offset="0%" stopColor="#10b981" />
                    <stop offset="50%" stopColor="#34d399" />
                    <stop offset="100%" stopColor="#6ee7b7" />
                  </linearGradient>
                  <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="#10b981" stopOpacity="0.25" />
                    <stop offset="100%" stopColor="#10b981" stopOpacity="0" />
                  </linearGradient>
                </defs>

                {/* Shaded Area under Line */}
                {areaPathD && <path d={areaPathD} fill="url(#areaGrad)" />}

                {/* Glowing Line */}
                {linePathD && (
                  <path
                    d={linePathD}
                    fill="none"
                    stroke="url(#lineGrad)"
                    strokeWidth="3.5"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    className="drop-shadow-[0_0_8px_rgba(16,185,129,0.5)]"
                  />
                )}

                {/* Data Point Circles */}
                {points.map((pt: any, i: number) => (
                  <g key={i}>
                    <circle
                      cx={pt.x}
                      cy={pt.y}
                      r="5"
                      fill="#10b981"
                      stroke="#0b0f19"
                      strokeWidth="2"
                      className="drop-shadow-[0_0_6px_rgba(16,185,129,0.8)]"
                    />
                  </g>
                ))}
              </svg>

              {/* Column Bars & Hover Tooltips */}
              <div className="h-full flex items-end justify-between gap-2 px-2 relative z-0">
                {monthlyChartData.map((item: any, idx: number) => {
                  const heightPct = Math.max(8, Math.round((item.revenue / maxRevenue) * 100));
                  return (
                    <div key={idx} className="flex-1 flex flex-col items-center gap-2 group h-full justify-end relative">
                      {/* Hover Tooltip Popup */}
                      <div className="absolute -top-12 z-30 opacity-0 group-hover:opacity-100 transition-all duration-200 pointer-events-none bg-slate-900 border border-slate-700 px-3 py-1.5 rounded-xl shadow-xl text-[11px] whitespace-nowrap flex flex-col items-center gap-0.5">
                        <span className="font-bold text-cyan-400">
                          {item.revenue > 0 ? `${item.revenue.toLocaleString('vi-VN')} đ` : '0 đ'}
                        </span>
                        <span className="text-emerald-400 font-semibold">
                          {item.tokens} Tokens
                        </span>
                      </div>

                      {/* Bar Column */}
                      <div
                        style={{ height: `${heightPct}%` }}
                        className="w-full max-w-[34px] bg-gradient-to-t from-indigo-700/80 via-sky-500/80 to-cyan-400/90 rounded-t-lg group-hover:brightness-125 transition-all shadow-md shadow-cyan-500/10"
                      ></div>

                      {/* Month Label */}
                      <span className="text-[11px] font-medium text-slate-400 mt-2">{item.month}</span>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>

          {/* Recently Created Tokens */}
          <div className="glass-card p-6 rounded-2xl space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="font-bold text-slate-100 text-base">Token Mới Kích Hoạt Gần Đây</h3>
                <p className="text-xs text-slate-400">Danh sách 5 token vừa tạo gần nhất</p>
              </div>
              <Link
                href="/tokens"
                className="text-xs text-cyan-400 hover:text-cyan-300 font-semibold flex items-center gap-1"
              >
                Xem tất cả <ChevronRight className="w-4 h-4" />
              </Link>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-xs text-slate-300">
                <thead className="bg-slate-900/60 uppercase text-slate-400 border-b border-slate-800 text-[11px]">
                  <tr>
                    <th className="py-3 px-4">Thiết Bị MD5</th>
                    <th className="py-3 px-4">UID Nhân Vật</th>
                    <th className="py-3 px-4">Gói VIP</th>
                    <th className="py-3 px-4">Hạn Sử Dụng</th>
                    <th className="py-3 px-4">Giá Tiền</th>
                    <th className="py-3 px-4">Người Tạo</th>
                    <th className="py-3 px-4 text-right">Thao Tác</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60">
                  {data?.recentTokens?.map((tok: any) => (
                    <tr key={tok.id} className="hover:bg-slate-800/30 transition">
                      <td className="py-3.5 px-4 font-mono font-semibold text-cyan-300">
                        {tok.deviceSnMd5.substring(0, 10)}...
                      </td>
                      <td className="py-3.5 px-4 font-mono text-slate-200">{tok.characterUid}</td>
                      <td className="py-3.5 px-4">
                        <span className="px-2 py-0.5 rounded bg-indigo-500/10 text-indigo-300 border border-indigo-500/20 font-medium">
                          {tok.vipPackage?.name || (tok.isCustom ? 'Custom Config' : 'Mặc Định')}
                        </span>
                      </td>
                      <td className="py-3.5 px-4 font-medium text-slate-300">
                        {new Date(tok.expireAt).toLocaleDateString('vi-VN')}
                      </td>
                      <td className="py-3.5 px-4 font-semibold text-emerald-400">
                        {tok.price.toLocaleString('vi-VN')} đ
                      </td>
                      <td className="py-3.5 px-4 text-slate-400">{tok.createdBy?.displayName}</td>
                      <td className="py-3.5 px-4 text-right">
                        <Link
                          href={`/tokens/${tok.id}`}
                          className="px-2.5 py-1 bg-slate-800 hover:bg-slate-700 text-slate-200 rounded-lg font-medium text-[11px] transition"
                        >
                          Chi tiết
                        </Link>
                      </td>
                    </tr>
                  ))}
                  {(!data?.recentTokens || data.recentTokens.length === 0) && (
                    <tr>
                      <td colSpan={7} className="py-8 text-center text-slate-500 italic">
                        Chưa có token nào được tạo
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
