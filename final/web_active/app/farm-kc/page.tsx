'use client';

import React, { useEffect, useState, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import Navbar from '@/components/Navbar';
import { Gift, RefreshCw, Search, Eye, EyeOff, ChevronLeft, ChevronRight, Crown, UserPlus, ArrowUp, ArrowDown, ChevronsUpDown, Coins, Gem, Ticket, Users, CheckCircle2, CircleDashed, Target, UserCog, X, Server } from 'lucide-react';

// =========================================================================
// [MOD FEATURE]: FARM KC - TRANG MA MOI RONG VANG (GOP 2 BANG VAO 1 MENU)
// Mô tả: Một trang duy nhất, chuyển nhanh giữa ACC 200 (người mời) và
//        ACC 50 (người được mời) bằng nút gạt. Phân trang phía server.
//        Mật khẩu acc game ẩn mặc định, chỉ ADMIN bấm mới xem.
// =========================================================================

type Tab = 'inviters' | 'invitees';

const STATUS_STYLE: Record<string, string> = {
  // --- ACC 200 (người mời) ---
  NEW: 'bg-slate-500/15 text-slate-300 border-slate-500/40',
  ACTIVE: 'bg-sky-500/15 text-sky-300 border-sky-500/30',
  INVITED: 'bg-amber-500/15 text-amber-300 border-amber-500/40',
  DONE: 'bg-emerald-500/15 text-emerald-300 border-emerald-500/40',
  COMPLETE: 'bg-amber-500/15 text-amber-300 border-amber-500/40',
  ERROR: 'bg-rose-500/15 text-rose-300 border-rose-500/30',
  SUCCESS: 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30',
  RESERVED: 'bg-amber-500/15 text-amber-300 border-amber-500/30',
  FAILED: 'bg-rose-500/15 text-rose-300 border-rose-500/30',
  EXPIRED: 'bg-slate-500/15 text-slate-300 border-slate-500/30',
  ALREADY_USED: 'bg-violet-500/15 text-violet-300 border-violet-500/30',
  // [MOD FEATURE]: NO_CODE = luc xin khong con ma -> to mau canh bao rieng
  NO_CODE: 'bg-orange-500/20 text-orange-300 border-orange-500/50',
};

const STATUS_LABEL: Record<string, string> = {
  // --- ACC 200: nghĩa + điều kiện + việc cần làm ---
  NEW: 'BƯỚC KHỞI TẠO — chưa có mã mời\n• Điều kiện: chưa tạo được mã\n• Việc cần làm: bot đăng nhập, đạt Lv200 rồi tạo mã',
  ACTIVE: 'ĐANG GOM NGƯỜI MỜI\n• Điều kiện: đã có mã, số người mời < 5\n• Việc cần làm: chờ acc Lv50 nhập mã',
  INVITED: 'ĐỦ 5 NGƯỜI — CHƯA mua kim cương\n• Điều kiện: đủ 5 người mời, chưa mua gói nào\n• Việc cần làm: nhận thưởng mốc rồi mua gói 60 kim cương',
  DONE: 'HOÀN THIỆN TOÀN BỘ CHU TRÌNH\n• Điều kiện: đủ 5 người mời VÀ đã mua ≥ 1 gói kim cương\n• Không còn việc gì — bot sẽ bỏ qua acc này',
  COMPLETE: 'TRẠNG THÁI CŨ — tương đương INVITED\n• Tự chuyển sang INVITED hoặc DONE khi web khởi động lại',
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
    { value: 'NEW', label: 'Chưa có mã' },
    { value: 'ACTIVE', label: 'Đang gom người' },
    { value: 'INVITED', label: 'Đủ 5, chưa mua' },
    { value: 'DONE', label: 'Hoàn thiện' },
    { value: 'ERROR', label: 'Lỗi' },
  ],
  invitees: [
    { value: '', label: 'Tất cả' },
    { value: 'NEW', label: 'Chưa chạy' },
    { value: 'SUCCESS', label: 'Thành công' },
    { value: 'RESERVED', label: 'Giữ chỗ' },
    { value: 'FAILED', label: 'Thất bại' },
    { value: 'ALREADY_USED', label: 'Đã nhập trước' },
    { value: 'NO_CODE', label: 'Hết mã' },
    { value: 'EXPIRED', label: 'Hết hạn' },
  ],
};

// =========================================================================
// [MOD FEATURE]: TACH NOI DUNG RA KHOI DEFAULT EXPORT
// Mo ta: useSearchParams() bat buoc phai nam trong <Suspense> thi `next build`
//        moi prerender duoc trang nay (loi missing-suspense-with-csr-bailout).
// =========================================================================
function FarmKcNoiDung() {
  const router = useRouter();
  const searchParams = useSearchParams();
  // [MOD FEATURE]: loc cong viec cua mot tai khoan FARM_KC (?username=...)
  const [farmUser, setFarmUser] = useState('');
  // [MOD FEATURE]: 2 o loc - tai khoan FARM_KC va server
  const [dsTaiKhoan, setDsTaiKhoan] = useState<any[]>([]);
  const [dsServer, setDsServer] = useState<any[]>([]);
  const [serverLoc, setServerLoc] = useState('');
  const [daChonMacDinh, setDaChonMacDinh] = useState(false);
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
  // Hien mat khau: toan bo (bam con mat o header cot) hoac tung dong (bam vao o)
  const [showAllPassword, setShowAllPassword] = useState(false);
  const [hienMatKhauDong, setHienMatKhauDong] = useState<Record<string, boolean>>({});
  // Sap xep theo cot - mac dinh Email giam dan
  const [sortBy, setSortBy] = useState('email');
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('desc');
  const [totals, setTotals] = useState<any>(null);
  const [chiTieu, setChiTieu] = useState<any>(null);
  // Số lượng của CẢ HAI bảng, hiện ngay trên nút gạt
  const [counts, setCounts] = useState<{ inviters: number; invitees: number }>({ inviters: 0, invitees: 0 });
  const pageSize = 20;

  useEffect(() => {
    const u = searchParams.get('username') || '';
    const t = searchParams.get('tab');
    const sv = searchParams.get('serverId');
    if (u) setFarmUser(u);
    if (sv !== null && sv !== '') setServerLoc(sv);
    loadOptions(u, sv);
    if (t === 'inviters' || t === 'invitees') {
      setTab(t);
      setSortBy(t === 'invitees' ? 'inviterEmail' : 'email');
      setSortDir(t === 'invitees' ? 'asc' : 'desc');
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    fetch('/api/auth/me')
      .then((res) => (res.ok ? res.json() : null))
      .then((d) => {
        if (d?.user) setUser(d.user);
        else router.push('/login');
      })
      .catch(() => router.push('/login'));
  }, [router]);

  // =========================================================================
  // [MOD FEATURE]: NAP DANH SACH TAI KHOAN FARM_KC + SERVER CHO O LOC
  // Mo ta: Neu URL khong chi dinh ?username= thi mac dinh chon tai khoan dau
  //        tien trong danh sach, va lay luon server cua tai khoan do.
  // =========================================================================
  const loadOptions = async (uTuUrl: string, svTuUrl?: string | null) => {
    try {
      const res = await fetch('/api/farm-accounts/options');
      if (!res.ok) { setDaChonMacDinh(true); return; }
      const j = await res.json();
      const ds = j.taiKhoan || [];
      setDsTaiKhoan(ds);
      setDsServer(j.server || []);

      if (uTuUrl) {
        // URL da chi dinh server thi giu nguyen, khong tu doi
        if (svTuUrl === null || svTuUrl === undefined || svTuUrl === '') {
          const tk = ds.find((t: any) => t.username === uTuUrl);
          const sv = tk?.ranges?.[0]?.serverId;
          if (sv) setServerLoc(String(sv));
        }
      } else if (ds.length > 0) {
        // Mac dinh: tai khoan dau tien + dong cong viec dau tien cua no
        const dong0 = ds[0].ranges?.[0];
        setFarmUser(ds[0].username);
        if (dong0?.serverId) setServerLoc(String(dong0.serverId));
        const lv = dong0?.farmLevel;
        if (lv === 200 || lv === 50) {
          const t: Tab = lv === 200 ? 'inviters' : 'invitees';
          setTab(t);
          setSortBy(t === 'invitees' ? 'inviterEmail' : 'email');
          setSortDir(t === 'invitees' ? 'asc' : 'desc');
        }
      }
    } catch (e) {
      console.error(e);
    } finally {
      setDaChonMacDinh(true);
    }
  };

  /** Doi tai khoan loc -> keo theo server va tab cua tai khoan do */
  const doiTaiKhoanLoc = (u: string) => {
    setFarmUser(u);
    const tk = dsTaiKhoan.find((t: any) => t.username === u);
    if (tk) {
      const ds = tk.ranges || [];
      // Chi tu chon server khi tai khoan chay tren DUNG MOT server
      const cacSv = Array.from(new Set(ds.map((k: any) => k.serverId)));
      setServerLoc(cacSv.length === 1 && cacSv[0] ? String(cacSv[0]) : '');
      // Chi tu doi tab khi tai khoan chi cay MOT level
      const cacLv = Array.from(new Set(ds.map((k: any) => k.farmLevel)));
      if (cacLv.length === 1) {
        const t: Tab = cacLv[0] === 200 ? 'inviters' : 'invitees';
        if (t !== tab) {
          setTab(t);
          setStatus('');
          setSortBy(t === 'invitees' ? 'inviterEmail' : 'email');
          setSortDir(t === 'invitees' ? 'asc' : 'desc');
        }
      }
    }
  };

  const loadCounts = async () => {
    try {
      const res = await fetch('/api/farm/counts');
      if (res.ok) setCounts(await res.json());
    } catch (e) {
      console.error(e);
    }
  };

  const load = async (
    p = 1,
    t: Tab = tab,
    st: string = status,
    sb: string = sortBy,
    sd: 'asc' | 'desc' = sortDir,
  ) => {
    setLoading(true);
    try {
      const q = new URLSearchParams({
        page: String(p),
        pageSize: String(pageSize),
        sortBy: sb,
        sortDir: sd,
      });
      if (keyword.trim()) q.set('q', keyword.trim());
      if (st) q.set('status', st);
      if (farmUser) q.set('username', farmUser);
      if (serverLoc) q.set('serverId', serverLoc);

      const res = await fetch(`/api/farm/${t}?${q}`);
      loadCounts();
      if (res.ok) {
        const j = await res.json();
        setItems(j.items || []);
        setTotal(j.total || 0);
        setTotalPages(j.totalPages || 1);
        setIsAdmin(!!j.isAdmin);
        setTotals(j.totals || null);
        setChiTieu(j.chiTieu || null);
        setPage(j.page || p);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    // Cho chon xong gia tri mac dinh roi moi goi API, tranh goi 2 lan
    if (user && daChonMacDinh) load(1, tab, status, sortBy, sortDir);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user, daChonMacDinh, tab, status, sortBy, sortDir, farmUser, serverLoc]);

  // =========================================================================
  // [MOD FEATURE]: SAP XEP THEO COT
  // Mô tả: Bấm lần đầu vào tiêu đề cột -> giảm dần, bấm lại -> tăng dần.
  // =========================================================================
  const doiSort = (key: string) => {
    if (sortBy === key) {
      setSortDir((d) => (d === 'desc' ? 'asc' : 'desc'));
    } else {
      setSortBy(key);
      setSortDir('desc');
    }
  };

  const doiTab = (t: Tab) => {
    if (t === tab) return;
    setTab(t);
    setStatus('');
    setKeyword('');
    setItems([]);
    setTotals(null);
    setChiTieu(null);
    setHienMatKhauDong({});
    // ACC 50 mac dinh gom nhom theo nguoi moi; ACC 200 mac dinh Email giam dan
    setSortBy(t === 'invitees' ? 'inviterEmail' : 'email');
    setSortDir(t === 'invitees' ? 'asc' : 'desc');
  };

  const laAcc200 = tab === 'inviters';

  const fmtTime = (v: any) => {
    if (!v) return '-';
    try { return new Date(v).toLocaleString('vi-VN'); } catch { return '-'; }
  };
  const fmtNum = (v: any) => (typeof v === 'number' ? v.toLocaleString('vi-VN') : '0');

  // =========================================================================
  // [MOD FEATURE]: GOM NHOM THEO NGUOI MOI (bang ACC 50)
  // Mô tả: Khi đang sắp xếp theo cột "Người mời", các acc cùng một người mời
  //        nằm liền nhau. Dòng đầu mỗi nhóm được kẻ vạch ngăn + in đậm email
  //        kèm số acc của nhóm, các dòng sau làm mờ đi cho dễ nhìn ra khối.
  // =========================================================================
  const gomNhom = !laAcc200 && sortBy === 'inviterEmail';

  const thongTinNhom = React.useMemo(() => {
    const kq = new Map<string, { dauNhom: boolean; soDong: number }>();
    const dem = new Map<string, number>();
    for (const r of items) {
      const k = r.inviterEmail || '(khong ro)';
      dem.set(k, (dem.get(k) || 0) + 1);
    }
    let truoc: string | null = null;
    for (const r of items) {
      const k = r.inviterEmail || '(khong ro)';
      kq.set(r.id, { dauNhom: k !== truoc, soDong: dem.get(k) || 1 });
      truoc = k;
    }
    return kq;
  }, [items]);

  // =========================================================================
  // [MOD FEATURE]: MAU DONG - CHI TO RIENG BAN GHI NO_CODE
  // Mô tả: Bỏ cách tô xen kẽ theo người mời (gây rối mắt). Giờ các dòng dùng
  //        nền chung, chỉ dòng NO_CODE (lúc xin không còn mã) được tô cảnh báo.
  // =========================================================================
  const layMauDong = (r: any) => {
    if (r.status === 'NO_CODE') {
      return 'bg-orange-950/60 hover:bg-orange-900/50 border-l-2 border-l-orange-500';
    }
    return 'hover:bg-slate-800/30';
  };

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

  // =========================================================================
  // [MOD FEATURE]: TIEU DE COT BAM DE SAP XEP
  // =========================================================================
  const Th = ({
    k,
    children,
    align = 'left',
    extra,
  }: {
    k?: string;
    children: React.ReactNode;
    align?: 'left' | 'center' | 'right';
    extra?: React.ReactNode;
  }) => {
    const dangSort = !!k && sortBy === k;
    const canh = align === 'right' ? 'justify-end' : align === 'center' ? 'justify-center' : 'justify-start';
    const canhText = align === 'right' ? 'text-right' : align === 'center' ? 'text-center' : 'text-left';
    return (
      <th className={`px-4 py-2.5 font-semibold ${canhText} select-none`}>
        <span className={`inline-flex items-center gap-1 ${canh} w-full`}>
          {k ? (
            <button
              onClick={() => doiSort(k)}
              className={`inline-flex items-center gap-1 transition ${
                dangSort ? 'text-sky-300' : 'text-slate-400 hover:text-slate-200'
              }`}
              title="Bấm để sắp xếp"
            >
              {children}
              {dangSort ? (
                sortDir === 'desc' ? <ArrowDown className="w-3 h-3" /> : <ArrowUp className="w-3 h-3" />
              ) : (
                <ChevronsUpDown className="w-3 h-3 opacity-40" />
              )}
            </button>
          ) : (
            <span>{children}</span>
          )}
          {extra}
        </span>
      </th>
    );
  };

  // =========================================================================
  // [MOD FEATURE]: O MAT KHAU - MAC DINH CHE, BAM VAO DE HIEN RIENG TUNG DONG
  // =========================================================================
  const OMatKhau = ({ r }: { r: any }) => {
    const hien = showAllPassword || !!hienMatKhauDong[r.id];
    if (!r.password) return <span className="text-slate-600 text-xs">-</span>;
    return (
      <button
        onClick={() =>
          setHienMatKhauDong((m) => ({ ...m, [r.id]: !m[r.id] }))
        }
        className={`font-mono text-xs px-2 py-0.5 rounded-md border transition ${
          hien
            ? 'text-rose-300 border-rose-500/30 bg-rose-500/10'
            : 'text-slate-500 border-slate-700/60 bg-slate-800/40 hover:text-slate-300 tracking-[0.15em]'
        }`}
        title={hien ? 'Bấm để ẩn' : 'Bấm để hiện mật khẩu'}
      >
        {hien ? r.password : '••••••••'}
      </button>
    );
  };

  const O = ({
    icon,
    nhan,
    gt,
    mau,
  }: { icon: React.ReactNode; nhan: string; gt: any; mau: string }) => (
    <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-slate-900/70 border border-slate-800">
      <span className={mau}>{icon}</span>
      <span className="text-[11px] text-slate-500">{nhan}</span>
      <span className={`text-xs font-bold font-mono ${mau}`}>
        {typeof gt === 'string' ? gt : fmtNum(gt)}
      </span>
    </div>
  );

  if (!user) return null;

  return (
    <div className="flex h-screen overflow-hidden bg-slate-950">
      <Sidebar userRole={user.role} />
      <div className="flex-1 flex flex-col min-w-0 h-screen overflow-hidden">
        <Navbar user={user} />

        <main className="flex-1 min-h-0 flex flex-col gap-3 p-4 overflow-hidden">
          {/* HANG 1: tieu de + nut gat ACC 200 / ACC 50 (gon trong 1 dong) */}
          <div className="flex items-center justify-between flex-wrap gap-3 shrink-0">
            <div className="flex items-center gap-3 min-w-0">
              <div className="w-9 h-9 rounded-lg bg-amber-500/10 border border-amber-500/30 flex items-center justify-center shrink-0">
                <Gift className="w-5 h-5 text-amber-400" />
              </div>
              <div className="min-w-0">
                <h1 className="text-base font-bold text-white leading-tight truncate">
                  Farm KC — Mã mời Rồng Vàng
                </h1>
                <p className="text-xs text-slate-400 truncate">
                  {laAcc200 ? 'Tài khoản Lv200 tạo mã mời' : 'Tài khoản Lv50 nhập mã mời'} · {fmtNum(total)} dòng
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2 shrink-0">
            <button
              onClick={() => router.push('/farm-accounts')}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-900 border border-slate-800 text-slate-300 hover:text-white text-xs font-medium transition"
              title="Quản lý tài khoản chạy bot FARM KC"
            >
              <UserCog className="w-3.5 h-3.5" />
              Tài khoản Farm KC
            </button>

            <div className="inline-flex p-0.5 rounded-lg bg-slate-900 border border-slate-800 shrink-0">
              <button
                onClick={() => doiTab('inviters')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-semibold transition ${
                  laAcc200
                    ? 'bg-gradient-to-r from-amber-600 to-orange-600 text-white shadow shadow-amber-500/20'
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                <Crown className="w-3.5 h-3.5" />
                ACC 200
                <span className={`font-bold ${laAcc200 ? 'text-white/80' : 'text-slate-500'}`}>
                  ({fmtNum(counts.inviters)})
                </span>
              </button>
              <button
                onClick={() => doiTab('invitees')}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-md text-xs font-semibold transition ${
                  !laAcc200
                    ? 'bg-gradient-to-r from-sky-600 to-indigo-600 text-white shadow shadow-sky-500/20'
                    : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                <UserPlus className="w-3.5 h-3.5" />
                ACC 50
                <span className={`font-bold ${!laAcc200 ? 'text-white/80' : 'text-slate-500'}`}>
                  ({fmtNum(counts.invitees)})
                </span>
              </button>
            </div>
            </div>
          </div>

          {/* [MOD FEATURE]: dang xem cong viec cua mot tai khoan FARM_KC */}
          {farmUser && (
            <div className="shrink-0 flex items-center gap-2 px-3 py-1.5 rounded-lg bg-violet-500/10 border border-violet-500/30 text-xs text-violet-200 w-fit">
              <UserCog className="w-3.5 h-3.5" />
              Đang xem công việc của tài khoản
              <span className="font-bold text-white">{farmUser}</span>
              <button
                onClick={() => { setFarmUser(''); setServerLoc(''); router.replace('/farm-kc'); }}
                className="ml-1 p-0.5 rounded hover:bg-violet-500/20 transition"
                title="Bỏ lọc"
              >
                <X className="w-3.5 h-3.5" />
              </button>
            </div>
          )}

          {/* HANG 2: o tim kiem nho + quick filter + hien mat khau tren cung 1 dong */}
          <div className="flex items-center flex-wrap gap-2 shrink-0">
            {/* =====================================================================
                [MOD FEATURE]: O TIM KIEM CO GIAN DUOC
                Mô tả: Mặc định nhỏ 240px; tự nới rộng khi đang gõ (focus), và
                       kéo được mép phải để tự chỉnh bề rộng theo ý.
               ===================================================================== */}
            <div
              className="group relative shrink-0 resize-x overflow-hidden rounded-lg
                         w-[240px] min-w-[180px] max-w-[720px]
                         transition-[width] duration-200 focus-within:w-[420px]"
              title="Đang gõ sẽ tự rộng ra · kéo mép phải để tự chỉnh bề rộng"
            >
              <Search className="w-3.5 h-3.5 text-slate-500 absolute left-2.5 top-1/2 -translate-y-1/2 pointer-events-none" />
              <input
                value={keyword}
                onChange={(e) => setKeyword(e.target.value)}
                onKeyDown={(e) => { if (e.key === 'Enter') load(1); }}
                placeholder="Tìm email / nhân vật / mã rồi Enter..."
                className="w-full pl-8 pr-6 py-1.5 rounded-lg bg-slate-900 border border-slate-800 text-xs text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-sky-600"
              />
              {/* Gach bao hieu keo duoc o goc phai */}
              <span className="pointer-events-none absolute right-[3px] top-1/2 -translate-y-1/2 text-slate-600 group-hover:text-slate-400 text-[10px] leading-none select-none">
                ⋮⋮
              </span>
            </div>

            <div className="w-px h-5 bg-slate-800 shrink-0" />

            {/* [MOD FEATURE]: LOC THEO TAI KHOAN FARM_KC */}
            <div className="relative shrink-0">
              <UserCog className="w-3.5 h-3.5 text-violet-400 absolute left-2.5 top-1/2 -translate-y-1/2 pointer-events-none" />
              <select
                value={farmUser}
                onChange={(e) => doiTaiKhoanLoc(e.target.value)}
                title="Lọc theo tài khoản FARM KC"
                className="appearance-none pl-8 pr-7 py-1.5 rounded-lg bg-slate-900 border border-slate-800 text-xs text-slate-200 focus:outline-none focus:border-violet-600 cursor-pointer max-w-[220px]"
              >
                <option value="">Tất cả tài khoản</option>
                {dsTaiKhoan.map((t: any) => (
                  <option key={t.id} value={t.username}>
                    {t.username}
                    {(t.ranges || []).length > 0
                      ? ' · ' + t.ranges
                          .map((k: any) => `Lv${k.farmLevel} ${k.rangeFrom}–${k.rangeTo}@${k.serverId || 'mđ'}`)
                          .join(' | ')
                      : ' · chưa giao'}
                  </option>
                ))}
              </select>
              <ChevronsUpDown className="w-3 h-3 text-slate-500 absolute right-2.5 top-1/2 -translate-y-1/2 pointer-events-none" />
            </div>

            {/* [MOD FEATURE]: LOC THEO SERVER */}
            <div className="relative shrink-0">
              <Server className="w-3.5 h-3.5 text-sky-400 absolute left-2.5 top-1/2 -translate-y-1/2 pointer-events-none" />
              <select
                value={serverLoc}
                onChange={(e) => setServerLoc(e.target.value)}
                title="Lọc theo server"
                className="appearance-none pl-8 pr-7 py-1.5 rounded-lg bg-slate-900 border border-slate-800 text-xs text-slate-200 focus:outline-none focus:border-sky-600 cursor-pointer max-w-[200px]"
              >
                <option value="">Tất cả server</option>
                {dsServer.map((sv: any) => (
                  <option key={sv.serverId} value={String(sv.serverId)}>
                    {sv.serverId === 0 ? 'Mặc định (chưa gán)' : sv.serverName || `Server ${sv.serverId}`}
                  </option>
                ))}
              </select>
              <ChevronsUpDown className="w-3 h-3 text-slate-500 absolute right-2.5 top-1/2 -translate-y-1/2 pointer-events-none" />
            </div>

            <div className="w-px h-5 bg-slate-800 shrink-0" />

            {FILTER_OPTIONS[tab].map((o) => (
              <button
                key={o.value}
                onClick={() => setStatus(o.value)}
                className={`px-3 py-1.5 rounded-lg text-xs font-semibold border transition ${
                  status === o.value
                    ? 'bg-slate-700 border-slate-600 text-white'
                    : 'bg-slate-900 border-slate-800 text-slate-400 hover:text-slate-200 hover:border-slate-700'
                }`}
              >
                {o.label}
              </button>
            ))}

            {gomNhom && (
              <span className="ml-auto flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-sky-500/10 border border-sky-500/25 text-[11px] text-sky-300">
                <Users className="w-3.5 h-3.5" />
                Đang gom nhóm theo người mời
              </span>
            )}

            {/* [MOD FEATURE]: TONG HOP TOAN BO (theo bo loc hien tai, khong chi trang dang xem) */}
            {laAcc200 && totals && (
              <div className="ml-auto flex items-center gap-2 flex-wrap">
                <O icon={<Users className="w-3.5 h-3.5" />} nhan="Đã mời" gt={totals.usedCount} mau="text-emerald-300" />
                <O icon={<Coins className="w-3.5 h-3.5" />} nhan="Vàng" gt={totals.unboundGold} mau="text-slate-300" />
                <O icon={<Gem className="w-3.5 h-3.5" />} nhan="KC" gt={totals.unboundDiamond} mau="text-cyan-300" />
                <O icon={<Ticket className="w-3.5 h-3.5" />} nhan="Kim Phiếu" gt={totals.goldVoucher} mau="text-amber-300" />
              </div>
            )}
          </div>

          {/* =====================================================================
              [MOD FEATURE]: THANH THONG KE CHI TIEU (chi bang ACC 200)
              Mô tả: Tính trên TOÀN BỘ dữ liệu theo bộ lọc đang xem, không phải
                     chỉ trang hiện tại.
             ===================================================================== */}
          {laAcc200 && chiTieu && (
            <div className="shrink-0 flex items-center flex-wrap gap-2">
              <O
                icon={<CheckCircle2 className="w-3.5 h-3.5" />}
                nhan="Nick đã mời đủ"
                gt={`${fmtNum(chiTieu.soDu)}/${fmtNum(chiTieu.soNick)}`}
                mau="text-emerald-300"
              />
              <O
                icon={<CircleDashed className="w-3.5 h-3.5" />}
                nhan="Nick chưa đủ"
                gt={fmtNum(chiTieu.soChuaDu)}
                mau="text-amber-300"
              />
              <O
                icon={<Target className="w-3.5 h-3.5" />}
                nhan="Còn cần mời"
                gt={`${fmtNum(chiTieu.conThieu)} lượt`}
                mau="text-sky-300"
              />

              {/* Thanh tien do tong the */}
              <div className="flex items-center gap-2 min-w-[180px] flex-1 max-w-[320px]">
                <div className="h-1.5 flex-1 rounded-full bg-slate-800 overflow-hidden">
                  <div
                    className="h-full rounded-full bg-gradient-to-r from-emerald-500 to-emerald-400 transition-all"
                    style={{
                      width: `${chiTieu.soNick > 0 ? Math.round((chiTieu.soDu / chiTieu.soNick) * 100) : 0}%`,
                    }}
                  />
                </div>
                <span className="text-[11px] font-bold text-emerald-300 font-mono shrink-0">
                  {chiTieu.soNick > 0 ? Math.round((chiTieu.soDu / chiTieu.soNick) * 100) : 0}%
                </span>
              </div>
            </div>
          )}

          {/* BANG: chi cuon ben trong, header dinh tren, pagination dinh duoi */}
          <div className="flex-1 min-h-0 flex flex-col rounded-2xl border border-slate-800 bg-slate-900/40 overflow-hidden">
            <div className="flex-1 min-h-0 overflow-auto">
              <table className="w-full text-sm">
                <thead className="sticky top-0 z-10">
                  <tr className="bg-slate-900 text-slate-400 text-xs uppercase tracking-wide">
                    <Th k="email">Email</Th>
                    {isAdmin && (
                      <Th
                        k="password"
                        extra={
                          <button
                            onClick={() => setShowAllPassword((v) => !v)}
                            title={showAllPassword ? 'Ẩn toàn bộ mật khẩu' : 'Hiện toàn bộ mật khẩu'}
                            className={`ml-1 p-0.5 rounded transition ${
                              showAllPassword ? 'text-rose-300' : 'text-slate-500 hover:text-slate-200'
                            }`}
                          >
                            {showAllPassword ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                          </button>
                        }
                      >
                        Mật khẩu
                      </Th>
                    )}
                    <Th k="serverName">Server</Th>
                    <Th k="roleName">Nhân vật</Th>
                    <Th k="level" align="center">Lv</Th>
                    <Th k="inviteCode">{laAcc200 ? 'Mã mời' : 'Mã đã nhập'}</Th>
                    {laAcc200 ? (
                      <>
                        <Th k="usedCount" align="center">Đã mời</Th>
                        <Th k="unboundGold" align="right">Vàng</Th>
                        <Th k="unboundDiamond" align="right">KC</Th>
                        <Th k="goldVoucher" align="right">Kim Phiếu</Th>
                      </>
                    ) : (
                      <>
                        <Th k="inviterEmail">Người mời</Th>
                        <Th k="errorMsg">Lỗi</Th>
                      </>
                    )}
                    <Th k="status" align="center">Trạng thái</Th>
                    <Th k="time">Thời điểm</Th>
                    <Th k="createdBy">Người tạo</Th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60">
                  {loading ? (
                    <tr><td colSpan={15} className="px-4 py-10 text-center text-slate-500">Đang tải...</td></tr>
                  ) : items.length === 0 ? (
                    <tr><td colSpan={15} className="px-4 py-10 text-center text-slate-500">Chưa có dữ liệu</td></tr>
                  ) : (
                    items.map((r) => (
                      <tr
                        key={r.id}
                        className={`transition ${layMauDong(r)} ${
                          gomNhom && thongTinNhom.get(r.id)?.dauNhom
                            ? 'border-t-2 border-t-slate-600/80'
                            : ''
                        }`}
                      >
                        <td className="px-4 py-2.5 text-slate-200 whitespace-nowrap">{r.email}</td>
                        {isAdmin && <td className="px-4 py-2.5"><OMatKhau r={r} /></td>}
                        <td className="px-4 py-2.5 text-slate-400 whitespace-nowrap">{r.serverName || r.serverId}</td>
                        <td className="px-4 py-2.5 text-slate-300 whitespace-nowrap">{r.roleName || '-'}</td>
                        <td className="px-4 py-2.5 text-center text-slate-400">{r.level || '-'}</td>
                        <td className="px-4 py-2.5">
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
                            <td className="px-4 py-2.5 text-center whitespace-nowrap">
                              <div>
                                <span className={`font-semibold ${r.usedCount >= r.maxInvites ? 'text-emerald-400' : 'text-slate-200'}`}>
                                  {r.usedCount}/{r.maxInvites}
                                </span>
                                {r.reservedCount > 0 && (
                                  <span className="ml-1 text-[11px] text-amber-400">(+{r.reservedCount})</span>
                                )}
                              </div>
                              {/* Da nhan = so game da xac nhan · Cho nhan = web da cap, game chua xac nhan */}
                              <div
                                className="text-[10px] mt-0.5"
                                title="Đã nhận = game đã xác nhận · Chờ nhận = web đã cấp, chờ acc Lv200 đăng nhập lại để chốt"
                              >
                                <span className="text-slate-500">Đã nhận {r.gameInviteNum}</span>
                                <span className="text-slate-600"> · </span>
                                <span className={r.confirmedCount > 0 ? 'text-amber-400' : 'text-slate-500'}>
                                  Chờ nhận {r.confirmedCount}
                                </span>
                              </div>
                            </td>
                            <td className="px-4 py-2.5 text-right text-slate-300 font-mono text-xs">{fmtNum(r.unboundGold)}</td>
                            <td className="px-4 py-2.5 text-right text-cyan-300 font-mono text-xs">{fmtNum(r.unboundDiamond)}</td>
                            <td className="px-4 py-2.5 text-right font-mono text-xs">
                              <span className={r.goldVoucher > 0 ? 'text-amber-300 font-semibold' : 'text-slate-600'}>
                                {fmtNum(r.goldVoucher)}
                              </span>
                            </td>
                          </>
                        ) : (
                          <>
                            <td
                              className={`px-4 py-2.5 text-xs whitespace-nowrap ${
                                gomNhom ? 'border-l-2 border-l-slate-700/70' : ''
                              }`}
                            >
                              {!r.inviterEmail ? (
                                <span className="text-slate-500">-</span>
                              ) : gomNhom && thongTinNhom.get(r.id)?.dauNhom ? (
                                <span className="flex items-center gap-2">
                                  <span className="text-slate-100 font-semibold">{r.inviterEmail}</span>
                                  <span
                                    className="px-1.5 py-0.5 rounded-md bg-sky-500/15 border border-sky-500/30 text-[10px] font-bold text-sky-300"
                                    title="Số acc Lv50 của người mời này trong trang hiện tại"
                                  >
                                    {thongTinNhom.get(r.id)?.soDong}
                                  </span>
                                </span>
                              ) : gomNhom ? (
                                <span className="flex items-center gap-1.5 text-slate-600">
                                  <span className="text-slate-700">↳</span>
                                  {r.inviterEmail}
                                </span>
                              ) : (
                                <span className="text-slate-400">{r.inviterEmail}</span>
                              )}
                            </td>
                            <td className="px-4 py-2.5 text-rose-400 text-xs max-w-[200px] truncate" title={r.errorMsg || ''}>
                              {r.errorMsg || '-'}
                            </td>
                          </>
                        )}

                        <td className="px-4 py-2.5 text-center">
                          <Badge st={r.status} />
                          {laAcc200 && r.failCount > 0 && (
                            <div className="text-[11px] text-rose-400 mt-1">lỗi x{r.failCount}</div>
                          )}
                        </td>
                        <td className="px-4 py-2.5 text-slate-500 text-xs whitespace-nowrap">
                          {fmtTime(laAcc200 ? (r.lastSyncAt || r.updatedAt) : (r.confirmedAt || r.updatedAt))}
                        </td>
                        <td className="px-4 py-2.5 text-slate-500 text-xs whitespace-nowrap">{r.createdBy || '-'}</td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>

            {/* Thanh pagination co dinh duoi cung, co luon nut Tai lai */}
            <div className="shrink-0 flex items-center justify-between gap-3 px-4 py-2 border-t border-slate-800 bg-slate-900/80">
              <p className="text-xs text-slate-500">Trang {page}/{totalPages} · {fmtNum(total)} dòng</p>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => load(page)}
                  className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-medium transition"
                >
                  <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
                  Tải lại
                </button>
                <button
                  disabled={page <= 1 || loading}
                  onClick={() => load(page - 1)}
                  className="p-1.5 rounded-lg bg-slate-800 text-slate-300 disabled:opacity-30 disabled:cursor-not-allowed hover:bg-slate-700 transition"
                >
                  <ChevronLeft className="w-4 h-4" />
                </button>
                <button
                  disabled={page >= totalPages || loading}
                  onClick={() => load(page + 1)}
                  className="p-1.5 rounded-lg bg-slate-800 text-slate-300 disabled:opacity-30 disabled:cursor-not-allowed hover:bg-slate-700 transition"
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

export default function FarmKcPage() {
  return (
    <Suspense
      fallback={<div className="min-h-screen bg-slate-950" />}
    >
      <FarmKcNoiDung />
    </Suspense>
  );
}
