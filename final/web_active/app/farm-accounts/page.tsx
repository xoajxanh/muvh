'use client';

import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import Navbar from '@/components/Navbar';
import {
  Users, RefreshCw, Search, Eye, EyeOff, ChevronLeft, ChevronRight,
  ArrowUp, ArrowDown, ChevronsUpDown, Plus, Pencil, Trash2, X,
  Crown, UserPlus, ListChecks, Wand2, AlertTriangle, CheckCircle2, Boxes, Server, Copy, Check, MonitorSmartphone, Lock,
} from 'lucide-react';

// =========================================================================
// [MOD FEATURE]: FARM KC - MAN HINH QUAN LY TAI KHOAN FARM_KC
// Mo ta: Bo cuc giong man ACC 200 / ACC 50 (co dinh 1 man hinh, chi cuon
//        danh sach, pagination dinh duoi).
//        MOI DONG CONG VIEC = level + server + khoang STT. Mot tai khoan co
//        nhieu dong nen cay duoc nhieu level tren nhieu server cung luc
//        (chay nhieu gia lap), vd:
//          longdt · Lv50  100-200   @ server 517
//          longdt · Lv50  1200-2000 @ server 515
//          longdt · Lv200 441-600   @ server 517
//        Hai dong chi dung do nhau khi CUNG level VA CUNG server.
// =========================================================================

const STATUS_STYLE: Record<string, string> = {
  NEW: 'bg-sky-500/15 text-sky-300 border-sky-500/30',
  RUNNING: 'bg-amber-500/15 text-amber-300 border-amber-500/30',
  PAUSED: 'bg-slate-500/15 text-slate-300 border-slate-500/30',
  DONE: 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30',
};

const STATUS_LABEL: Record<string, string> = {
  NEW: 'Chưa chạy — còn sửa được',
  RUNNING: 'Đang chạy',
  PAUSED: 'Tạm dừng',
  DONE: 'Đã xong',
};

const FILTER_OPTIONS = [
  { value: '', label: 'Tất cả' },
  { value: 'NEW', label: 'Chưa chạy' },
  { value: 'RUNNING', label: 'Đang chạy' },
  { value: 'PAUSED', label: 'Tạm dừng' },
  { value: 'DONE', label: 'Đã xong' },
];

let demKhoa = 0;
const dongMoi = (farmLevel = 50) => ({
  khoa: `d${++demKhoa}`,
  farmLevel,
  serverId: '' as any,
  serverName: '',
  rangeFrom: '',
  soLuong: '',
  rangeTo: '',
});

const MAU_FORM = () => ({
  id: '',
  username: '',
  password: '',
  note: '',
  dong: [dongMoi(50)] as any[],
});

export default function FarmAccountsPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [items, setItems] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [total, setTotal] = useState(0);
  const [totalPages, setTotalPages] = useState(1);
  const [isAdmin, setIsAdmin] = useState(false);
  const [keyword, setKeyword] = useState('');
  const [status, setStatus] = useState('');
  const [farmLevel, setFarmLevel] = useState('');
  const [serverLoc, setServerLoc] = useState('');
  const [dsServer, setDsServer] = useState<any[]>([]);
  const [sortBy, setSortBy] = useState('username');
  const [sortDir, setSortDir] = useState<'asc' | 'desc'>('desc');
  const [showAllPassword, setShowAllPassword] = useState(false);
  const [hienMatKhauDong, setHienMatKhauDong] = useState<Record<string, boolean>>({});
  // [MOD FEATURE]: bao da copy jobCode
  const [daCopy, setDaCopy] = useState('');

  const copyMa = async (ma: string) => {
    try { await navigator.clipboard.writeText(ma); } catch (e) { console.error(e); }
    setDaCopy(ma);
    setTimeout(() => setDaCopy((c) => (c === ma ? '' : c)), 1500);
  };

  const [moForm, setMoForm] = useState(false);
  const [form, setForm] = useState<any>(MAU_FORM());
  const [dangLuu, setDangLuu] = useState(false);
  const [loiForm, setLoiForm] = useState('');
  const [ktUsername, setKtUsername] = useState<any>(null);
  // Chong lan + goi y kho trong, theo KHOA cua tung dong
  const [chongLan, setChongLan] = useState<Record<string, any>>({});
  const [khoTrong, setKhoTrong] = useState<Record<string, any>>({});

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

  const loadServers = async () => {
    try {
      const res = await fetch('/api/farm-accounts/options');
      if (res.ok) setDsServer((await res.json()).server || []);
    } catch (e) { console.error(e); }
  };

  const load = async (
    p = 1,
    st: string = status,
    lv: string = farmLevel,
    sv: string = serverLoc,
    sb: string = sortBy,
    sd: 'asc' | 'desc' = sortDir,
  ) => {
    setLoading(true);
    try {
      const q = new URLSearchParams({
        page: String(p), pageSize: String(pageSize), sortBy: sb, sortDir: sd,
      });
      if (keyword.trim()) q.set('q', keyword.trim());
      if (st) q.set('status', st);
      if (lv) q.set('farmLevel', lv);
      if (sv !== '') q.set('serverId', sv);

      const res = await fetch(`/api/farm-accounts?${q}`);
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
    if (user) { load(1, status, farmLevel, serverLoc, sortBy, sortDir); loadServers(); }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user, status, farmLevel, serverLoc, sortBy, sortDir]);

  const doiSort = (key: string) => {
    if (sortBy === key) setSortDir((d) => (d === 'desc' ? 'asc' : 'desc'));
    else { setSortBy(key); setSortDir('desc'); }
  };

  const fmtTime = (v: any) => {
    if (!v) return '-';
    try { return new Date(v).toLocaleString('vi-VN'); } catch { return '-'; }
  };
  const fmtNum = (v: any) => (typeof v === 'number' ? v.toLocaleString('vi-VN') : String(v ?? '0'));
  const tenServer = (sid: any, ten?: string) =>
    Number(sid) === 0 ? 'mặc định' : (ten || `Server ${sid}`);

  /** Danh sách dòng hợp lệ, dạng gửi lên API */
  const dsCongViec = (f: any = form) =>
    (f.dong || [])
      .map((d: any) => ({
        farmLevel: Number(d.farmLevel),
        serverId: Number(d.serverId) || 0,
        serverName: d.serverName || '',
        rangeFrom: Number(d.rangeFrom),
        rangeTo: Number(d.rangeTo),
        // Viec da luu gui kem jobCode de API sua dung viec (khong xoa roi tao lai)
        ...(d.jobCode ? { jobCode: d.jobCode } : {}),
      }))
      .filter(
        (k: any) =>
          Number.isFinite(k.rangeFrom) && Number.isFinite(k.rangeTo) &&
          k.rangeFrom >= 1 && k.rangeTo >= k.rangeFrom,
      );

  // =========================================================================
  // [MOD FEATURE]: CHECK TRUNG USERNAME
  // =========================================================================
  const kiemTraUsername = async (ten?: string) => {
    const u = (ten ?? form.username ?? '').trim();
    if (!u) return;
    const q = new URLSearchParams({ username: u });
    if (form.id) q.set('id', form.id);
    try {
      const res = await fetch(`/api/farm-accounts/check?${q}`);
      if (res.ok) setKtUsername(await res.json());
    } catch (e) { console.error(e); }
  };

  const dungGoiY = () => {
    if (!ktUsername?.goiY) return;
    setForm((f: any) => ({ ...f, username: ktUsername.goiY }));
    setKtUsername({ username: ktUsername.goiY, trung: false, hopLe: true });
  };

  // =========================================================================
  // [MOD FEATURE]: CHONG LAN VOI CHINH CAC DONG KHAC CUA TAI KHOAN NAY
  // Mo ta: Tinh ca dong da luu lan dong moi chua luu tren form. Chi cung
  //        level + cung server moi tinh la dung nhau.
  // =========================================================================
  const chongLanNoiBo = (d: any, ds: any[] = form.dong || []) => {
    const tu = Number(d.rangeFrom), den = Number(d.rangeTo);
    if (!Number.isFinite(tu) || !Number.isFinite(den) || tu < 1 || den < tu) return null;
    for (let i = 0; i < ds.length; i++) {
      const x = ds[i];
      if (x.khoa === d.khoa) continue;
      if (Number(x.farmLevel) !== Number(d.farmLevel)) continue;
      if ((Number(x.serverId) || 0) !== (Number(d.serverId) || 0)) continue;
      const a = Number(x.rangeFrom), b = Number(x.rangeTo);
      if (!Number.isFinite(a) || !Number.isFinite(b) || a < 1 || b < a) continue;
      if (tu <= b && a <= den) return { stt: i + 1, rangeFrom: a, rangeTo: b, daChay: !!x.daChay };
    }
    return null;
  };

  /** STT cuoi cung da giao cho cac dong KHAC cua chinh form (cung level+server) */
  const toiDaNoiBo = (d: any, ds: any[], lv: any, sv: any) =>
    ds.reduce((m: number, x: any) => {
      if (x.khoa === d.khoa) return m;
      if (Number(x.farmLevel) !== Number(lv) || (Number(x.serverId) || 0) !== (Number(sv) || 0)) return m;
      const b = Number(x.rangeTo);
      return Number.isFinite(b) && b > m ? b : m;
    }, 0);

  /** Dong chong lan tu web la cua chinh tai khoan dang sua -> bo qua (form da tu kiem) */
  const laCuaMinh = (cl: any) =>
    !!cl && !!form.id &&
    String(cl.username || '').toLowerCase() === String(form.usernameGoc || form.username || '').toLowerCase();

  // =========================================================================
  // [MOD FEATURE]: KIEM TRA CHONG LAN CHO MOT DONG
  // =========================================================================
  const kiemTraDong = async (
    khoa: string,
    f: any = form,
    ghiDe?: { farmLevel?: any; serverId?: any },
  ) => {
    const d = (f.dong || []).find((x: any) => x.khoa === khoa);
    if (!d || !d.rangeFrom || !d.rangeTo) {
      setChongLan((c) => ({ ...c, [khoa]: undefined }));
      return;
    }
    const q = new URLSearchParams({
      farmLevel: String(ghiDe?.farmLevel ?? d.farmLevel),
      serverId: String(Number(ghiDe?.serverId ?? d.serverId) || 0),
      rangeFrom: String(d.rangeFrom),
      rangeTo: String(d.rangeTo),
    });
    // Chi bo qua DUNG dong nay (viec da luu); cac viec khac cua minh van tinh
    if (d.jobCode) q.set('job', d.jobCode);
    try {
      const res = await fetch(`/api/farm-accounts/check?${q}`);
      if (!res.ok) return;
      const j = await res.json();
      setChongLan((c) => ({ ...c, [khoa]: j.chongLan ?? null }));
    } catch (e) { console.error(e); }
  };

  // =========================================================================
  // [MOD FEATURE]: GOI Y KHOANG STT CON TRONG CHO MOT DONG
  // =========================================================================
  const layKhoTrong = async (
    khoa: string,
    f: any = form,
    ghiDe?: { farmLevel?: any; serverId?: any },
  ) => {
    const d = (f.dong || []).find((x: any) => x.khoa === khoa);
    if (!d) return;
    // Bam doi level/server xong thi state chua kip cap nhat -> uu tien gia tri
    // vua bam, neu khong se hoi web bang level cu (hien sai thong tin).
    const lv = ghiDe?.farmLevel ?? d.farmLevel;
    const sv = ghiDe?.serverId ?? d.serverId;
    try {
      const q = new URLSearchParams({
        farmLevel: String(lv),
        serverId: String(Number(sv) || 0),
      });
      if (d.jobCode) q.set('job', d.jobCode);
      const res = await fetch(`/api/farm-accounts/next-range?${q}`);
      if (!res.ok) return;
      const j = await res.json();
      setKhoTrong((k) => ({ ...k, [khoa]: j }));
      setForm((cu: any) => ({
        ...cu,
        dong: cu.dong.map((x: any) => {
          if (x.khoa !== khoa || String(x.rangeFrom || '').trim() !== '') return x;
          // Tinh ca cac dong chua luu cua chinh form (cung level+server)
          const tu = Math.max(j.batDauTu || 1, toiDaNoiBo(x, cu.dong, lv, sv) + 1);
          const sl = Number(x.soLuong) || 0;
          return { ...x, rangeFrom: String(tu), rangeTo: sl > 0 ? String(tu + sl - 1) : x.rangeTo };
        }),
      }));
    } catch (e) { console.error(e); }
  };

  const tenServerTuDong = (sid: any) => {
    const n = parseInt(String(sid), 10);
    return Number.isFinite(n) && n > 0 ? `VĨNH HẰNG ${n}` : '';
  };

  /** Sửa một ô của một dòng; tự tính các ô liên quan */
  const doiO = (khoa: string, ten: string, giaTri: any) => {
    setForm((f: any) => ({
      ...f,
      dong: f.dong.map((d: any) => {
        if (d.khoa !== khoa) return d;
        const o = { ...d, [ten]: giaTri };

        // Doi level -> kho acc khac han, bo dai cu de goi y dien lai
        if (ten === 'farmLevel') {
          o.rangeFrom = '';
          o.rangeTo = '';
        }

        if (ten === 'serverId') {
          const tuDongCu = tenServerTuDong(d.serverId);
          const giuTenNguoiDung = d.serverName && d.serverName !== tuDongCu;
          if (!giuTenNguoiDung) o.serverName = tenServerTuDong(giaTri);
        }

        const tu = parseInt(String(o.rangeFrom), 10);
        const sl = parseInt(String(o.soLuong), 10);
        const den = parseInt(String(o.rangeTo), 10);
        if ((ten === 'soLuong' || ten === 'rangeFrom') && Number.isFinite(tu) && Number.isFinite(sl) && sl >= 1) {
          o.rangeTo = String(tu + sl - 1);
        } else if (ten === 'rangeTo' && Number.isFinite(tu) && Number.isFinite(den) && den >= tu) {
          o.soLuong = String(den - tu + 1);
        }
        return o;
      }),
    }));
    setChongLan((c) => ({ ...c, [khoa]: undefined }));
    if (ten === 'serverId' || ten === 'farmLevel') setKhoTrong((k) => ({ ...k, [khoa]: undefined }));
  };

  const datKhoang = (khoa: string, tu: number, den: number) => {
    setForm((f: any) => ({
      ...f,
      dong: f.dong.map((d: any) =>
        d.khoa === khoa
          ? { ...d, rangeFrom: String(tu), soLuong: String(den - tu + 1), rangeTo: String(den) }
          : d,
      ),
    }));
    setChongLan((c) => ({ ...c, [khoa]: undefined }));
  };

  const themDong = () => {
    const d = dongMoi(50);
    setForm((f: any) => ({ ...f, dong: [...f.dong, d] }));
    setTimeout(() => setForm((f: any) => { layKhoTrong(d.khoa, f); return f; }), 0);
  };

  const xoaDong = (khoa: string) => {
    setForm((f: any) => ({ ...f, dong: f.dong.filter((d: any) => d.khoa !== khoa) }));
    setChongLan((c) => ({ ...c, [khoa]: undefined }));
    setKhoTrong((k) => ({ ...k, [khoa]: undefined }));
  };

  const moThem = () => {
    const f = MAU_FORM();
    setForm(f);
    setKtUsername(null);
    setChongLan({});
    setKhoTrong({});
    setLoiForm('');
    setMoForm(true);
    f.dong.forEach((d: any) => layKhoTrong(d.khoa, f));
  };

  const moSua = (r: any) => {
    const f = MAU_FORM();
    f.id = r.id;
    f.username = r.username;
    (f as any).usernameGoc = r.username;
    f.password = r.password || '';
    f.note = r.note || '';
    f.dong = (r.ranges || []).map((k: any) => ({
      khoa: `d${++demKhoa}`,
      farmLevel: k.farmLevel,
      serverId: k.serverId,
      serverName: k.serverName || '',
      rangeFrom: String(k.rangeFrom),
      soLuong: String(Math.max(0, k.rangeTo - k.rangeFrom + 1)),
      rangeTo: String(k.rangeTo),
      // Viec da chay -> khoa level / server / dai STT, khong xoa dong duoc
      daChay: !!k.daChay,
      jobCode: k.jobCode || '',
    }));
    if (f.dong.length === 0) f.dong = [dongMoi(50)];
    setForm(f);
    setKtUsername(null);
    setChongLan({});
    setKhoTrong({});
    setLoiForm('');
    setMoForm(true);
    f.dong.filter((d: any) => !d.daChay).forEach((d: any) => layKhoTrong(d.khoa, f));
  };

  const luu = async () => {
    const ranges = dsCongViec();
    if (ranges.length === 0) {
      setLoiForm('Phải thêm ít nhất một dòng công việc có khoảng STT hợp lệ');
      return;
    }
    setDangLuu(true);
    setLoiForm('');
    try {
      const res = await fetch(
        form.id ? `/api/farm-accounts/${form.id}` : '/api/farm-accounts',
        {
          method: form.id ? 'PUT' : 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            username: form.username,
            password: form.password,
            note: form.note,
            ranges,
          }),
        },
      );
      const j = await res.json();
      if (!res.ok) { setLoiForm(j.error || 'Lưu không thành công'); return; }
      setMoForm(false);
      load(page);
      loadServers();
    } catch (e: any) {
      setLoiForm(e.message || 'Lỗi mạng');
    } finally {
      setDangLuu(false);
    }
  };

  const xoa = async (r: any) => {
    if (!confirm(
      `Xoá tài khoản FARM KC "${r.username}"?\n\n` +
      `Sẽ xoá luôn các công việc và TOÀN BỘ bản ghi theo dõi (acc đã chạy trên các server) của tài khoản này.\n` +
      `Kho mặc định không bị ảnh hưởng. Không hoàn tác được.`,
    )) return;
    try {
      const res = await fetch(`/api/farm-accounts/${r.id}`, { method: 'DELETE' });
      const j = await res.json();
      if (!res.ok) { alert(j.error || 'Xoá không thành công'); return; }
      const x = j.daXoa || {};
      if ((x.lv200 || 0) + (x.lv50 || 0) > 0) {
        alert(`Đã xoá "${r.username}" cùng ${x.lv200 || 0} bản ghi Lv200 và ${x.lv50 || 0} bản ghi Lv50.`);
      }
      load(page);
    } catch (e: any) { alert(e.message || 'Lỗi mạng'); }
  };

  /** Nhảy sang màn Farm KC, lọc đúng công việc của tài khoản này */
  const xemCongViec = (r: any, k?: any) => {
    const level = k?.farmLevel ?? (r.ranges?.[0]?.farmLevel || 50);
    const sv = k?.serverId;
    const tab = level === 200 ? 'inviters' : 'invitees';
    const q = new URLSearchParams({ username: r.username, tab });
    if (sv !== undefined && sv !== null) q.set('serverId', String(sv));
    router.push(`/farm-kc?${q}`);
  };

  const Th = ({
    k, children, align = 'left', extra,
  }: { k?: string; children: React.ReactNode; align?: 'left' | 'center' | 'right'; extra?: React.ReactNode }) => {
    const dangSort = !!k && sortBy === k;
    const canh = align === 'right' ? 'justify-end' : align === 'center' ? 'justify-center' : 'justify-start';
    const canhText = align === 'right' ? 'text-right' : align === 'center' ? 'text-center' : 'text-left';
    return (
      <th className={`px-4 py-2.5 font-semibold ${canhText} select-none`}>
        <span className={`inline-flex items-center gap-1 ${canh} w-full`}>
          {k ? (
            <button
              onClick={() => doiSort(k)}
              className={`inline-flex items-center gap-1 transition ${dangSort ? 'text-sky-300' : 'text-slate-400 hover:text-slate-200'}`}
              title="Bấm để sắp xếp"
            >
              {children}
              {dangSort
                ? (sortDir === 'desc' ? <ArrowDown className="w-3 h-3" /> : <ArrowUp className="w-3 h-3" />)
                : <ChevronsUpDown className="w-3 h-3 opacity-40" />}
            </button>
          ) : <span>{children}</span>}
          {extra}
        </span>
      </th>
    );
  };

  const OMatKhau = ({ r }: { r: any }) => {
    const hien = showAllPassword || !!hienMatKhauDong[r.id];
    if (!r.password) return <span className="text-slate-600 text-xs">-</span>;
    return (
      <button
        onClick={() => setHienMatKhauDong((m) => ({ ...m, [r.id]: !m[r.id] }))}
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

  const TheLevel = ({ lv }: { lv: number }) => (
    <span className={`px-1.5 py-0.5 rounded-md text-[10px] font-bold border shrink-0 ${
      lv === 200
        ? 'bg-amber-500/15 text-amber-300 border-amber-500/30'
        : 'bg-sky-500/15 text-sky-300 border-sky-500/30'
    }`}>
      Lv{lv}
    </span>
  );

  if (!user) return null;

  return (
    <div className="flex h-screen overflow-hidden bg-slate-950">
      <Sidebar userRole={user.role} />
      <div className="flex-1 flex flex-col min-w-0 h-screen overflow-hidden">
        <Navbar user={user} />

        <main className="flex-1 min-h-0 flex flex-col gap-3 p-4 overflow-hidden">
          <div className="flex items-center justify-between flex-wrap gap-3 shrink-0">
            <div className="flex items-center gap-3 min-w-0">
              <div className="w-9 h-9 rounded-lg bg-violet-500/10 border border-violet-500/30 flex items-center justify-center shrink-0">
                <Users className="w-5 h-5 text-violet-400" />
              </div>
              <div className="min-w-0">
                <h1 className="text-base font-bold text-white leading-tight truncate">Tài khoản FARM KC</h1>
                <p className="text-xs text-slate-400 truncate">
                  Mỗi tài khoản cày được nhiều level trên nhiều server cùng lúc · {fmtNum(total)} dòng
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2 shrink-0">
              <button
                onClick={() => router.push('/farm-kc')}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-900 border border-slate-800 text-slate-300 hover:text-white text-xs font-medium transition"
              >
                <ListChecks className="w-3.5 h-3.5" />
                Về màn Farm KC
              </button>
              {isAdmin && (
                <button
                  onClick={moThem}
                  className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-gradient-to-r from-violet-600 to-fuchsia-600 text-white text-xs font-semibold shadow shadow-violet-500/20 hover:opacity-90 transition"
                >
                  <Plus className="w-3.5 h-3.5" />
                  Thêm tài khoản
                </button>
              )}
            </div>
          </div>

          <div className="flex items-center flex-wrap gap-2 shrink-0">
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
                placeholder="Tìm username / ghi chú rồi Enter..."
                className="w-full pl-8 pr-6 py-1.5 rounded-lg bg-slate-900 border border-slate-800 text-xs text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-violet-600"
              />
              <span className="pointer-events-none absolute right-[3px] top-1/2 -translate-y-1/2 text-slate-600 group-hover:text-slate-400 text-[10px] leading-none select-none">⋮⋮</span>
            </div>

            <div className="w-px h-5 bg-slate-800 shrink-0" />

            <div className="inline-flex p-0.5 rounded-lg bg-slate-900 border border-slate-800 shrink-0">
              {[
                { v: '', l: 'Cả hai', icon: null },
                { v: '200', l: 'Có cày 200', icon: <Crown className="w-3.5 h-3.5" /> },
                { v: '50', l: 'Có cày 50', icon: <UserPlus className="w-3.5 h-3.5" /> },
              ].map((o) => (
                <button
                  key={o.v}
                  onClick={() => setFarmLevel(o.v)}
                  className={`flex items-center gap-1.5 px-3 py-1 rounded-md text-xs font-semibold transition ${
                    farmLevel === o.v ? 'bg-slate-700 text-white' : 'text-slate-400 hover:text-slate-200'
                  }`}
                >
                  {o.icon}
                  {o.l}
                </button>
              ))}
            </div>

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

            {FILTER_OPTIONS.map((o) => (
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
          </div>

          <div className="flex-1 min-h-0 flex flex-col rounded-2xl border border-slate-800 bg-slate-900/40 overflow-hidden">
            <div className="flex-1 min-h-0 overflow-auto">
              <table className="w-full text-sm">
                <thead className="sticky top-0 z-10">
                  <tr className="bg-slate-900 text-slate-400 text-xs uppercase tracking-wide">
                    <Th k="username">Username</Th>
                    {isAdmin && (
                      <Th
                        extra={
                          <button
                            onClick={() => setShowAllPassword((v) => !v)}
                            title={showAllPassword ? 'Ẩn toàn bộ mật khẩu' : 'Hiện toàn bộ mật khẩu'}
                            className={`ml-1 p-0.5 rounded transition ${showAllPassword ? 'text-rose-300' : 'text-slate-500 hover:text-slate-200'}`}
                          >
                            {showAllPassword ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                          </button>
                        }
                      >
                        Mật khẩu
                      </Th>
                    )}
                    <Th>Công việc được giao</Th>
                    <Th align="right">Tổng acc</Th>
                    <Th align="right">Đã gán</Th>
                    <Th k="status" align="center">Trạng thái</Th>
                    <Th k="lastSyncAt">Đồng bộ cuối</Th>
                    <Th k="createdBy">Người tạo</Th>
                    <Th align="center">Thao tác</Th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800/60">
                  {loading ? (
                    <tr><td colSpan={9} className="px-4 py-10 text-center text-slate-500">Đang tải...</td></tr>
                  ) : items.length === 0 ? (
                    <tr><td colSpan={9} className="px-4 py-10 text-center text-slate-500">Chưa có tài khoản nào</td></tr>
                  ) : (
                    items.map((r) => (
                      <tr key={r.id} className="transition hover:bg-slate-800/30 align-top">
                        <td className="px-4 py-2.5 text-slate-200 font-medium whitespace-nowrap">{r.username}</td>
                        {isAdmin && <td className="px-4 py-2.5"><OMatKhau r={r} /></td>}
                        <td className="px-4 py-2.5">
                          {(r.ranges || []).length === 0 ? (
                            <span className="text-slate-600 text-xs">chưa giao</span>
                          ) : (
                            <div className="flex flex-col gap-0.5">
                              {r.ranges.map((k: any) => {
                                const dangChay =
                                  k.lastHeartbeat &&
                                  Date.now() - new Date(k.lastHeartbeat).getTime() < 5 * 60 * 1000;
                                return (
                                  <div key={k.id} className="flex items-center gap-2 text-xs">
                                    <button
                                      onClick={() => xemCongViec(r, k)}
                                      className="flex items-center gap-2 hover:opacity-80 transition"
                                      title="Xem công việc của dòng này"
                                    >
                                      <TheLevel lv={k.farmLevel} />
                                      {k.daChay && (
                                        <span title="Đã chạy - khoá dải STT">
                                          <Lock className="w-3 h-3 text-slate-500" />
                                        </span>
                                      )}
                                      <span className="text-slate-400 min-w-[110px] text-left">
                                        {tenServer(k.serverId, k.serverName)}
                                      </span>
                                      <span className="font-mono text-slate-300">
                                        {fmtNum(k.rangeFrom)} – {fmtNum(k.rangeTo)}
                                      </span>
                                      <span className="text-[10px] text-slate-600">({fmtNum(k.soAcc)} acc)</span>
                                    </button>

                                    {/* Ma dinh danh cong viec - mod dung ma nay */}
                                    <button
                                      onClick={() => copyMa(k.jobCode)}
                                      title="Bấm để copy mã công việc"
                                      className="inline-flex items-center gap-1 px-1.5 py-0.5 rounded-md bg-slate-800/80 border border-slate-700 font-mono text-[10px] text-violet-300 hover:border-violet-500/50 transition"
                                    >
                                      {daCopy === k.jobCode
                                        ? <Check className="w-3 h-3 text-emerald-400" />
                                        : <Copy className="w-3 h-3 opacity-60" />}
                                      {k.jobCode}
                                    </button>

                                    {dangChay && (
                                      <span
                                        title={`Đang chạy ở ${k.deviceName || 'một giả lập'} · STT ${fmtNum(k.cursorStt)}`}
                                        className="inline-flex items-center gap-1 px-1.5 py-0.5 rounded-md bg-emerald-500/10 border border-emerald-500/30 text-[10px] text-emerald-300"
                                      >
                                        <MonitorSmartphone className="w-3 h-3" />
                                        {k.deviceName || 'đang chạy'}
                                        {k.cursorStt > 0 && <span className="font-mono">#{fmtNum(k.cursorStt)}</span>}
                                      </span>
                                    )}
                                  </div>
                                );
                              })}
                            </div>
                          )}
                        </td>
                        <td className="px-4 py-2.5 text-right font-mono text-xs text-slate-300">{fmtNum(r.soAcc)}</td>
                        <td className="px-4 py-2.5 text-right font-mono text-xs">
                          <span className={r.daGan > 0 ? 'text-emerald-300 font-semibold' : 'text-slate-600'}>
                            {fmtNum(r.daGan)}
                          </span>
                        </td>
                        <td className="px-4 py-2.5 text-center"><Badge st={r.status} /></td>
                        <td className="px-4 py-2.5 text-slate-500 text-xs whitespace-nowrap">{fmtTime(r.lastSyncAt)}</td>
                        <td className="px-4 py-2.5 text-slate-500 text-xs whitespace-nowrap">{r.createdBy || '-'}</td>
                        <td className="px-4 py-2.5">
                          <div className="flex items-center justify-center gap-1">
                            <button
                              onClick={() => xemCongViec(r)}
                              title="Xem chi tiết công việc"
                              className="p-1.5 rounded-lg bg-slate-800 text-sky-300 hover:bg-slate-700 transition"
                            >
                              <ListChecks className="w-3.5 h-3.5" />
                            </button>
                            {isAdmin && (
                              <>
                                <button
                                  onClick={() => moSua(r)}
                                  title="Sửa / thêm công việc (việc đã chạy sẽ được giữ nguyên)"
                                  className="p-1.5 rounded-lg bg-slate-800 text-slate-300 hover:bg-slate-700 disabled:opacity-25 disabled:cursor-not-allowed transition"
                                >
                                  <Pencil className="w-3.5 h-3.5" />
                                </button>
                                <button
                                  onClick={() => xoa(r)}
                                  disabled={!r.choPhepXoa}
                                  title={r.choPhepXoa ? 'Xoá' : 'Có công việc đã chạy, không xoá được tài khoản'}
                                  className="p-1.5 rounded-lg bg-slate-800 text-rose-300 hover:bg-rose-900/40 disabled:opacity-25 disabled:cursor-not-allowed transition"
                                >
                                  <Trash2 className="w-3.5 h-3.5" />
                                </button>
                              </>
                            )}
                          </div>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>

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

      {/* =====================================================================
          [MOD FEATURE]: FORM THEM / SUA - DANH SACH DONG CONG VIEC
         ===================================================================== */}
      {moForm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
          <div className="absolute inset-0 bg-black/70 backdrop-blur-sm" onClick={() => setMoForm(false)} />
          <div className="relative w-full max-w-5xl max-h-[90vh] flex flex-col rounded-2xl border border-slate-800 bg-slate-900 shadow-2xl overflow-hidden">
            <div className="shrink-0 flex items-center justify-between px-5 py-3 border-b border-slate-800 bg-slate-900/80">
              <h2 className="text-sm font-bold text-white">
                {form.id ? 'Sửa tài khoản FARM KC' : 'Thêm tài khoản FARM KC'}
              </h2>
              <button onClick={() => setMoForm(false)} className="p-1 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition">
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="flex-1 min-h-0 flex flex-col gap-3 p-5 overflow-hidden">
              {/* Thong tin tai khoan */}
              <div className="shrink-0 grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-medium text-slate-400 mb-1">Username</label>
                  <input
                    value={form.username}
                    onChange={(e) => { setForm({ ...form, username: e.target.value }); setKtUsername(null); }}
                    disabled={form.dong.some((d: any) => d.daChay)}
                    title={form.dong.some((d: any) => d.daChay) ? 'Có công việc đã chạy - mod đang đăng nhập bằng tên này, không đổi được' : ''}
                    onBlur={() => kiemTraUsername()}
                    placeholder="vd: longdt"
                    className="w-full px-3 py-2 rounded-lg bg-slate-950 border border-slate-800 text-sm text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-violet-600 disabled:opacity-60 disabled:cursor-not-allowed"
                  />
                  {ktUsername && (
                    <div className="mt-1.5 text-xs">
                      {ktUsername.loi ? (
                        <span className="text-rose-400">{ktUsername.loi}</span>
                      ) : ktUsername.trung ? (
                        <span className="flex items-center flex-wrap gap-2 text-rose-400">
                          <AlertTriangle className="w-3.5 h-3.5 shrink-0" />
                          Đã tồn tại.
                          {ktUsername.goiY && (
                            <button
                              onClick={dungGoiY}
                              className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-violet-500/15 border border-violet-500/40 text-violet-300 font-semibold hover:bg-violet-500/25 transition"
                            >
                              <Wand2 className="w-3 h-3" />
                              Dùng “{ktUsername.goiY}”
                            </button>
                          )}
                        </span>
                      ) : (
                        <span className="flex items-center gap-1.5 text-emerald-400">
                          <CheckCircle2 className="w-3.5 h-3.5" />
                          Dùng được
                        </span>
                      )}
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-xs font-medium text-slate-400 mb-1">Mật khẩu</label>
                  <input
                    value={form.password}
                    onChange={(e) => setForm({ ...form, password: e.target.value })}
                    placeholder="Mật khẩu tài khoản"
                    className="w-full px-3 py-2 rounded-lg bg-slate-950 border border-slate-800 text-sm text-slate-200 font-mono placeholder:text-slate-600 placeholder:font-sans focus:outline-none focus:border-violet-600"
                  />
                </div>
              </div>

              {/* Ghi chu: textarea cho nhap dai */}
              <div className="shrink-0">
                <label className="block text-xs font-medium text-slate-400 mb-1">Ghi chú</label>
                <textarea
                  value={form.note}
                  onChange={(e) => setForm({ ...form, note: e.target.value })}
                  rows={2}
                  placeholder="Số điện thoại, máy chạy, lưu ý khi cày... (xuống dòng thoải mái)"
                  className="w-full px-3 py-2 rounded-lg bg-slate-950 border border-slate-800 text-sm text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-violet-600 resize-y min-h-[52px] max-h-[160px]"
                />
              </div>

              {/* =============================================================
                  Danh sach dong cong viec - chi cuon RIENG trong khoi nay
                 ============================================================= */}
              <div className="flex-1 min-h-0 flex flex-col">
                <div className="shrink-0 flex items-center justify-between mb-1.5">
                  <label className="text-xs font-medium text-slate-400">
                    Công việc được giao — mỗi dòng là một giả lập: level + server + khoảng STT
                  </label>
                  <button
                    onClick={themDong}
                    className="flex items-center gap-1 px-2 py-1 rounded-lg bg-violet-500/15 border border-violet-500/40 text-violet-300 text-[11px] font-semibold hover:bg-violet-500/25 transition"
                  >
                    <Plus className="w-3 h-3" />
                    Thêm dòng
                  </button>
                </div>

                <div className="flex-1 min-h-0 flex flex-col rounded-xl border border-slate-800 bg-slate-950/40 overflow-hidden">
                  {/* Tieu de cot */}
                  <div className="shrink-0 grid grid-cols-[26px_128px_96px_minmax(140px,1fr)_96px_16px_96px_16px_96px_32px] gap-2 items-center px-3 py-1.5 bg-slate-900/70 border-b border-slate-800 text-[10px] font-semibold uppercase tracking-wide text-slate-500">
                    <span />
                    <span>Level cày</span>
                    <span>Server ID</span>
                    <span>Tên server</span>
                    <span className="text-center">Từ</span>
                    <span />
                    <span className="text-center text-violet-400/80">Số acc</span>
                    <span />
                    <span className="text-center">Đến</span>
                    <span />
                  </div>

                  <div className="flex-1 min-h-0 overflow-auto p-2 space-y-2">
                    {form.dong.map((d: any, idx: number) => {
                      const kho = khoTrong[d.khoa];
                      const clWeb = chongLan[d.khoa];
                      const clMinh = chongLanNoiBo(d);
                      // Chong lan voi tai khoan KHAC lay tu web; voi chinh minh lay tu form
                      const cl = laCuaMinh(clWeb) ? null : clWeb;
                      const batDauGoiY = kho
                        ? Math.max(kho.batDauTu || 1, toiDaNoiBo(d, form.dong, d.farmLevel, d.serverId) + 1)
                        : 1;
                      return (
                        <div
                          key={d.khoa}
                          className={`rounded-lg border px-3 py-2 ${
                            d.farmLevel === 200
                              ? 'border-amber-500/30 bg-amber-500/[0.04]'
                              : 'border-sky-500/30 bg-sky-500/[0.04]'
                          }`}
                        >
                          <div className="grid grid-cols-[26px_128px_96px_minmax(140px,1fr)_96px_16px_96px_16px_96px_32px] gap-2 items-center">
                            <span className="text-[10px] font-bold text-slate-600 flex items-center gap-0.5" title={d.daChay ? `${d.jobCode} đã chạy - khoá` : ''}>
                              {d.daChay ? <Lock className="w-3 h-3 text-amber-400" /> : <>#{idx + 1}</>}
                            </span>

                            <div className="inline-flex p-0.5 rounded-lg bg-slate-950 border border-slate-800">
                              {[50, 200].map((lv) => (
                                <button
                                  key={lv}
                                  disabled={d.daChay}
                                  onClick={() => {
                                    doiO(d.khoa, 'farmLevel', lv);
                                    layKhoTrong(d.khoa, form, { farmLevel: lv });
                                  }}
                                  className={`flex items-center justify-center gap-1 flex-1 px-1.5 py-1 rounded-md text-[11px] font-semibold transition ${
                                    Number(d.farmLevel) === lv
                                      ? lv === 200
                                        ? 'bg-gradient-to-r from-amber-600 to-orange-600 text-white'
                                        : 'bg-gradient-to-r from-sky-600 to-indigo-600 text-white'
                                      : 'text-slate-400 hover:text-slate-200'
                                  }`}
                                >
                                  {lv === 200 ? <Crown className="w-3 h-3" /> : <UserPlus className="w-3 h-3" />}
                                  Lv{lv}
                                </button>
                              ))}
                            </div>

                            <input
                              type="number"
                              value={d.serverId}
                              onChange={(e) => doiO(d.khoa, 'serverId', e.target.value)}
                              disabled={d.daChay}
                              onBlur={(e) => {
                                const sv = e.target.value;
                                layKhoTrong(d.khoa, form, { serverId: sv });
                                kiemTraDong(d.khoa, form, { serverId: sv });
                              }}
                              placeholder="0"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-slate-800 text-xs text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />
                            <input
                              value={d.serverName}
                              onChange={(e) => doiO(d.khoa, 'serverName', e.target.value)}
                              placeholder="Tự điền theo Server ID"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-slate-800 text-xs text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />

                            <input
                              type="number"
                              value={d.rangeFrom}
                              onChange={(e) => doiO(d.khoa, 'rangeFrom', e.target.value)}
                              disabled={d.daChay}
                              onBlur={() => kiemTraDong(d.khoa)}
                              placeholder="1"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-slate-800 text-xs text-slate-200 text-center placeholder:text-slate-600 focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />
                            <span className="text-slate-600 text-xs text-center">+</span>
                            <input
                              type="number"
                              value={d.soLuong}
                              onChange={(e) => doiO(d.khoa, 'soLuong', e.target.value)}
                              disabled={d.daChay}
                              onBlur={() => kiemTraDong(d.khoa)}
                              placeholder="60"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-violet-800/60 text-xs text-violet-200 font-semibold text-center placeholder:text-slate-600 placeholder:font-normal focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />
                            <span className="text-slate-600 text-xs text-center">=</span>
                            <input
                              type="number"
                              value={d.rangeTo}
                              onChange={(e) => doiO(d.khoa, 'rangeTo', e.target.value)}
                              disabled={d.daChay}
                              onBlur={() => kiemTraDong(d.khoa)}
                              placeholder="60"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-slate-800 text-xs text-slate-200 text-center placeholder:text-slate-600 focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />

                            <button
                              onClick={() => xoaDong(d.khoa)}
                              disabled={form.dong.length <= 1 || d.daChay}
                              title={d.daChay ? 'Công việc đã chạy, không xoá được' : 'Xoá dòng này'}
                              className="p-1.5 rounded-lg bg-slate-800 text-rose-300 hover:bg-rose-900/40 disabled:opacity-25 disabled:cursor-not-allowed transition"
                            >
                              <Trash2 className="w-3.5 h-3.5" />
                            </button>
                          </div>

                          {(kho || cl !== undefined || clMinh) && (
                            <div className="mt-1.5 pl-[34px] space-y-1">
                              {kho && (
                                <div className="flex items-start gap-1.5 text-[11px] text-slate-500">
                                  <Boxes className="w-3.5 h-3.5 text-violet-400 shrink-0 mt-px" />
                                  <span className="flex items-center flex-wrap gap-x-1.5 gap-y-0.5">
                                    <span>
                                      Lv{kho.farmLevel} · server <b className="text-slate-300">{kho.serverId === 0 ? 'mặc định' : kho.serverId}</b> ·
                                      {' '}kho <b className="text-slate-300">{fmtNum(kho.tongAcc)}</b> acc
                                      {kho.sttMax > 0 && (
                                        <> (STT <b className="text-slate-300">{fmtNum(kho.sttMin)}–{fmtNum(kho.sttMax)}</b>)</>
                                      )}
                                      {' '}· đã giao tới <b className="text-slate-300">{fmtNum(kho.daPhanBoToi)}</b>
                                      {' '}· còn <b className={kho.conLai > 0 ? 'text-emerald-300' : 'text-rose-300'}>{fmtNum(kho.conLai)}</b> acc
                                      {kho.soChuaCoStt > 0 && (
                                        <span className="text-amber-400/80">
                                          {' '}· {fmtNum(kho.soChuaCoStt)} acc chưa có STT (không chia được)
                                        </span>
                                      )}
                                    </span>
                                    <button
                                      onClick={() => doiO(d.khoa, 'rangeFrom', String(batDauGoiY))}
                                      className="px-1.5 py-0.5 rounded-md bg-violet-500/15 border border-violet-500/40 text-violet-300 font-bold hover:bg-violet-500/25 transition"
                                    >
                                      bắt đầu từ {fmtNum(batDauGoiY)}
                                    </button>
                                    {(kho.khoangTrong || []).map((k: any, i: number) => (
                                      <button
                                        key={i}
                                        onClick={() => datKhoang(d.khoa, k.tu, k.den)}
                                        className="px-1.5 py-0.5 rounded-md bg-slate-800 border border-slate-700 text-slate-300 font-mono hover:border-violet-500/50 transition"
                                      >
                                        {fmtNum(k.tu)}–{fmtNum(k.den)}
                                      </button>
                                    ))}
                                  </span>
                                </div>
                              )}

                              {clMinh && (
                                <div className="text-[11px]">
                                  <span className="flex items-center gap-1.5 text-rose-400">
                                    <AlertTriangle className="w-3.5 h-3.5 shrink-0" />
                                    Chồng lấn với dòng #{clMinh.stt}{clMinh.daChay ? ' (đã chạy)' : ''} của chính tài khoản này — Lv{d.farmLevel} · server {Number(d.serverId) || 0} · {clMinh.rangeFrom}–{clMinh.rangeTo}
                                  </span>
                                </div>
                              )}
                              {!clMinh && cl !== undefined && (
                                <div className="text-[11px]">
                                  {cl ? (
                                    <span className="flex items-center gap-1.5 text-rose-400">
                                      <AlertTriangle className="w-3.5 h-3.5 shrink-0" />
                                      Chồng lấn với “{cl.username}” — Lv{cl.farmLevel} · server {cl.serverId} · {cl.rangeFrom}–{cl.rangeTo}
                                    </span>
                                  ) : (
                                    <span className="flex items-center gap-1.5 text-emerald-400">
                                      <CheckCircle2 className="w-3.5 h-3.5" />
                                      Khoảng này chưa ai nhận
                                    </span>
                                  )}
                                </div>
                              )}
                            </div>
                          )}
                        </div>
                      );
                    })}
                  </div>
                </div>

                <p className="shrink-0 mt-1.5 text-[11px] text-slate-600">
                  Dòng có <Lock className="inline w-3 h-3 text-amber-400 -mt-0.5" /> là công việc đã chạy: giữ nguyên dải STT, không xoá được (vẫn đổi được tên server). Việc chưa chạy sửa/xoá tự do, luôn thêm được việc mới.{' '}
                  Hai dòng chỉ đụng nhau khi <b className="text-slate-500">cùng level và cùng server</b>. Cùng khoảng STT nhưng khác server thì hợp lệ — đó là chạy nhiều giả lập song song.
                </p>
              </div>

              {loiForm && (
                <div className="shrink-0 flex items-start gap-2 px-3 py-2 rounded-lg bg-rose-500/10 border border-rose-500/30 text-xs text-rose-300">
                  <AlertTriangle className="w-3.5 h-3.5 shrink-0 mt-0.5" />
                  {loiForm}
                </div>
              )}
            </div>

            <div className="shrink-0 flex items-center justify-between gap-2 px-5 py-3 border-t border-slate-800 bg-slate-900/80">
              <p className="text-[11px] text-slate-500">
                {dsCongViec().length === 0
                  ? 'Chưa có dòng nào hợp lệ'
                  : `${dsCongViec().length} dòng · tổng ${fmtNum(
                      dsCongViec().reduce((t: number, k: any) => t + (k.rangeTo - k.rangeFrom + 1), 0),
                    )} acc`}
              </p>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => setMoForm(false)}
                  className="px-4 py-2 rounded-lg bg-slate-800 text-slate-300 text-xs font-medium hover:bg-slate-700 transition"
                >
                  Huỷ
                </button>
                <button
                  onClick={luu}
                  disabled={
                    dangLuu ||
                    ktUsername?.trung ||
                    dsCongViec().length === 0 ||
                    form.dong.some((d: any) => (!!chongLan[d.khoa] && !laCuaMinh(chongLan[d.khoa])) || !!chongLanNoiBo(d))
                  }
                  className="px-4 py-2 rounded-lg bg-gradient-to-r from-violet-600 to-fuchsia-600 text-white text-xs font-semibold disabled:opacity-40 disabled:cursor-not-allowed hover:opacity-90 transition"
                >
                  {dangLuu ? 'Đang lưu...' : form.id ? 'Lưu thay đổi' : 'Thêm tài khoản'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
