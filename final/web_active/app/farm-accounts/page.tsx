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
  // [MOD FEATURE]: MUC TIEU SAN LUONG - nhap so KC + server -> tu chia acc
  targetKc: '' as any,
  mtServer: '' as any,
  // [MOD FEATURE]: AN CHIA - % khach nhan, phan con lai ve acc game nhan cua minh
  tyLeKhach: '100' as any,
  tkNhan: '',
  mkNhan: '',
  dong: [] as any[],
});

// =========================================================================
// [MOD FEATURE]: CONG THUC SAN LUONG (khop voi lib/farm-account.ts)
//   1 acc Lv200 = 60 KC, can 5 acc Lv50 nhap ma moi du dieu kien.
//   Lv200 = lam tron LEN (muc tieu / 60) · Lv50 = Lv200 x 5
// =========================================================================
const KC_MOI_LV200 = 60;
const LV50_MOI_LV200 = 5;
const tinhCanCap = (targetKc: any) => {
  const t = Math.max(0, Math.floor(Number(targetKc) || 0));
  const lv200 = Math.ceil(t / KC_MOI_LV200);
  return { targetKc: t, lv200, lv50: lv200 * LV50_MOI_LV200, kc: lv200 * KC_MOI_LV200 };
};
/** Chia KC theo ti le: khach lam tron xuong, phan le ve minh (khop server) */
const chiaKc = (kc: number, tyLeKhach: any) => {
  const tong = Math.max(0, Math.floor(kc || 0));
  const t = Math.max(0, Math.min(100, Number(tyLeKhach)));
  const tl = Number.isFinite(t) ? t : 100;
  const khach = Math.floor((tong * tl) / 100);
  return { khach, minh: tong - khach, tyLe: tl };
};
const tyLeHopLe = (v: any) => {
  if (String(v ?? '').trim() === '') return 100;
  const n = Number(v);
  return Number.isFinite(n) && n >= 0 && n <= 100 && Math.floor(n) === n ? n : NaN;
};
const tinhSanLuong = (so200: number, so50: number) => {
  const ghep = Math.min(Math.max(0, so200), Math.floor(Math.max(0, so50) / LV50_MOI_LV200));
  return { ghep, kc: ghep * KC_MOI_LV200 };
};

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
  const [hienMkNhan, setHienMkNhan] = useState(false);
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
      // Dong da co so acc ma chua co dai -> cap luon theo so luong
      setForm((cu: any) => {
        const x = cu.dong.find((y: any) => y.khoa === khoa);
        if (x && String(x.rangeFrom || '').trim() === '' && (parseInt(String(x.soLuong), 10) || 0) > 0) {
          const xMoi = { ...x, farmLevel: lv, serverId: sv };
          const tu = Math.max(j.batDauTu || 1, toiDaNoiBo(xMoi, cu.dong, lv, sv) + 1);
          setTimeout(() => capTheoSoLuong(khoa, { ...cu, dong: cu.dong.map((y: any) => (y.khoa === khoa ? xMoi : y)) }, tu), 0);
        }
        return cu;
      });
    } catch (e) { console.error(e); }
  };

  // =========================================================================
  // [MOD FEATURE]: CAP THEO SO LUONG ACC
  // Nhap "so acc" -> hoi web STT cua acc thu N trong kho (STT khong lien tuc)
  // -> dien Tu/Den. Kho khong du -> cap toi da, ghi so thieu de canh bao.
  // =========================================================================
  const capTheoSoLuong = async (khoa: string, f: any = form, tuMuon?: number) => {
    const d = (f.dong || []).find((x: any) => x.khoa === khoa);
    if (!d) return;
    const sl = parseInt(String(d.soLuong), 10);
    if (!Number.isFinite(sl) || sl < 1) return;
    const tu = tuMuon ?? (parseInt(String(d.rangeFrom), 10) ||
      (toiDaNoiBo(d, f.dong, d.farmLevel, d.serverId) + 1));
    try {
      const q = new URLSearchParams({
        farmLevel: String(d.farmLevel),
        serverId: String(Number(d.serverId) || 0),
        tu: String(tu),
        soLuong: String(sl),
      });
      if (d.jobCode) q.set('job', d.jobCode);
      const res = await fetch(`/api/farm-accounts/next-range?${q}`);
      if (!res.ok) return;
      const j = await res.json();
      setKhoTrong((k) => ({ ...k, [khoa]: j }));
      const c = j.capPhat;
      if (!c) return;
      setForm((cu: any) => ({
        ...cu,
        dong: cu.dong.map((x: any) =>
          x.khoa === khoa
            ? { ...x, rangeFrom: String(c.tu), rangeTo: c.soLuong > 0 ? String(c.den) : '', soLuong: String(c.soLuong || ''), thieu: c.thieu || 0 }
            : x,
        ),
      }));
      setTimeout(() => setForm((cu: any) => { kiemTraDong(khoa, cu); return cu; }), 0);
    } catch (e) { console.error(e); }
  };

  /** Sua tay Tu/Den -> dem lai so acc THAT trong dai */
  const demTheoDai = async (khoa: string, f: any = form) => {
    const d = (f.dong || []).find((x: any) => x.khoa === khoa);
    if (!d) return;
    const tu = parseInt(String(d.rangeFrom), 10);
    const den = parseInt(String(d.rangeTo), 10);
    if (!Number.isFinite(tu) || !Number.isFinite(den) || den < tu) return;
    try {
      const q = new URLSearchParams({
        farmLevel: String(d.farmLevel),
        serverId: String(Number(d.serverId) || 0),
        tu: String(tu),
        den: String(den),
      });
      if (d.jobCode) q.set('job', d.jobCode);
      const res = await fetch(`/api/farm-accounts/next-range?${q}`);
      if (!res.ok) return;
      const j = await res.json();
      setKhoTrong((k) => ({ ...k, [khoa]: j }));
      if (j.capPhat) {
        setForm((cu: any) => ({
          ...cu,
          dong: cu.dong.map((x: any) =>
            x.khoa === khoa ? { ...x, soLuong: String(j.capPhat.soLuong), thieu: 0 } : x,
          ),
        }));
      }
      kiemTraDong(khoa, f);
    } catch (e) { console.error(e); }
  };

  // =========================================================================
  // [MOD FEATURE]: TU PHAN BO THEO MUC TIEU KC
  // Muc tieu -> so Lv200 / Lv50 can co. Tru phan da co o cac dong DA CHAY
  // (khoa, giu nguyen), phan con lai cap thanh 2 dong moi tren server muc
  // tieu tu acc TRONG trong kho. Cac dong chua chay cu bi thay the (giu lai
  // jobCode neu cung level + server de ma cong viec khong doi).
  // =========================================================================
  const [dangPhanBo, setDangPhanBo] = useState(false);
  const tuPhanBo = async (f: any = form) => {
    const can = tinhCanCap(f.targetKc);
    const sv = parseInt(String(f.mtServer), 10);
    if (can.targetKc <= 0) { setLoiForm('Nhập mục tiêu kim cương trước'); return; }
    if (!Number.isFinite(sv) || sv < 0) { setLoiForm('Nhập Server ID để phân bổ'); return; }
    setLoiForm('');
    setDangPhanBo(true);
    try {
      const khoaCung = (f.dong || []).filter((d: any) => d.daChay);
      const thayThe = (f.dong || []).filter((d: any) => !d.daChay);
      const dsBoQua = thayThe.map((d: any) => d.jobCode).filter(Boolean);
      const daCo = (lv: number) => khoaCung
        .filter((d: any) => Number(d.farmLevel) === lv)
        .reduce((t: number, d: any) => t + (parseInt(String(d.soLuong), 10) || 0), 0);

      const dongMoiDs: any[] = [];
      const ketQuaKho: Record<string, any> = {};
      for (const lv of [200, 50]) {
        const con = (lv === 200 ? can.lv200 : can.lv50) - daCo(lv);
        if (con <= 0) continue;
        // diem bat dau: sau cac dong DA CHAY cung level + server (neu co)
        const tu = khoaCung
          .filter((d: any) => Number(d.farmLevel) === lv && (Number(d.serverId) || 0) === sv)
          .reduce((m: number, d: any) => Math.max(m, parseInt(String(d.rangeTo), 10) || 0), 0) + 1;
        const q = new URLSearchParams({
          farmLevel: String(lv), serverId: String(sv), tu: String(tu), soLuong: String(con),
        });
        if (dsBoQua.length) q.set('job', dsBoQua.join(','));
        const res = await fetch(`/api/farm-accounts/next-range?${q}`);
        if (!res.ok) continue;
        const j = await res.json();
        const c = j.capPhat || { tu, den: tu - 1, soLuong: 0, thieu: con };
        const giuMa = thayThe.find((d: any) =>
          Number(d.farmLevel) === lv && (Number(d.serverId) || 0) === sv && d.jobCode);
        const d = {
          ...dongMoi(lv),
          serverId: String(sv),
          serverName: tenServerTuDong(sv),
          rangeFrom: String(c.tu),
          rangeTo: c.soLuong > 0 ? String(c.den) : '',
          soLuong: String(c.soLuong || 0),
          thieu: c.thieu || 0,
          tuDong: true,
          jobCode: giuMa?.jobCode || '',
        };
        ketQuaKho[d.khoa] = j;
        dongMoiDs.push(d);
      }
      setKhoTrong((k) => ({ ...k, ...ketQuaKho }));
      setChongLan({});
      setForm((cu: any) => ({
        ...cu,
        dong: [...(cu.dong || []).filter((d: any) => d.daChay), ...dongMoiDs],
        daPhanBoCho: `${can.targetKc}|${sv}`,
      }));
    } catch (e: any) {
      setLoiForm(e.message || 'Lỗi phân bổ');
    } finally {
      setDangPhanBo(false);
    }
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

        // So acc / dai STT: STT trong kho khong lien tuc -> KHONG tinh tay o
        // day, roi o thi hoi web (capTheoSoLuong / demTheoDai).
        if (ten === 'soLuong' || ten === 'rangeFrom' || ten === 'rangeTo') o.thieu = 0;
        return o;
      }),
    }));
    setChongLan((c) => ({ ...c, [khoa]: undefined }));
    if (ten === 'serverId' || ten === 'farmLevel') setKhoTrong((k) => ({ ...k, [khoa]: undefined }));
  };

  const datKhoang = (khoa: string, tu: number, den: number) => {
    let fMoi: any = null;
    setForm((f: any) => {
      fMoi = {
        ...f,
        dong: f.dong.map((d: any) =>
          d.khoa === khoa ? { ...d, rangeFrom: String(tu), rangeTo: String(den), thieu: 0 } : d,
        ),
      };
      return fMoi;
    });
    setChongLan((c) => ({ ...c, [khoa]: undefined }));
    setTimeout(() => { if (fMoi) demTheoDai(khoa, fMoi); }, 0);
  };

  const themDong = () => {
    const d: any = dongMoi(50);
    // Mac dinh lay server cua muc tieu cho nhanh, van sua duoc
    const sv = parseInt(String(form.mtServer), 10);
    if (Number.isFinite(sv) && sv >= 0) { d.serverId = String(sv); d.serverName = tenServerTuDong(sv); }
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
    f.targetKc = r.targetKc ? String(r.targetKc) : '';
    f.tyLeKhach = String(r.tyLeKhach ?? 100);
    f.tkNhan = r.tkNhan || '';
    f.mkNhan = r.mkNhan || '';
    f.mtServer = (r.ranges || []).length ? String(r.ranges[0].serverId) : '';
    (f as any).daPhanBoCho = `${r.targetKc || 0}|${f.mtServer}`;
    f.dong = (r.ranges || []).map((k: any) => ({
      khoa: `d${++demKhoa}`,
      farmLevel: k.farmLevel,
      serverId: k.serverId,
      serverName: k.serverName || '',
      rangeFrom: String(k.rangeFrom),
      // so acc THAT trong dai (web dem san)
      soLuong: String(k.soAcc ?? Math.max(0, k.rangeTo - k.rangeFrom + 1)),
      rangeTo: String(k.rangeTo),
      // Viec da chay -> khoa level / server / dai STT, khong xoa dong duoc
      daChay: !!k.daChay,
      jobCode: k.jobCode || '',
    }));
    setForm(f);
    setHienMkNhan(false);
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
      setLoiForm('Chưa có dòng cấp tài khoản nào hợp lệ — nhập mục tiêu KC + server rồi bấm “Tự phân bổ”, hoặc thêm dòng');
      return;
    }
    // [MOD FEATURE]: an chia - khach < 100% thi phai co acc game nhan
    const tl = tyLeHopLe(form.tyLeKhach);
    if (!Number.isFinite(tl)) { setLoiForm('Tỉ lệ khách nhận phải là số nguyên 0–100 (%)'); return; }
    if (tl < 100 && (!String(form.tkNhan).trim() || !String(form.mkNhan).trim())) {
      setLoiForm(`Khách nhận ${tl}% → mình nhận ${100 - tl}%: nhập tài khoản game nhận và mật khẩu`);
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
            targetKc: parseInt(String(form.targetKc), 10) || 0,
            tyLeKhach: tl,
            tkNhan: String(form.tkNhan || '').trim(),
            mkNhan: String(form.mkNhan || '').trim(),
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
                    <Th>Tài khoản được cấp</Th>
                    <Th align="right">Mục tiêu KC</Th>
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
                    <tr><td colSpan={10} className="px-4 py-10 text-center text-slate-500">Đang tải...</td></tr>
                  ) : items.length === 0 ? (
                    <tr><td colSpan={10} className="px-4 py-10 text-center text-slate-500">Chưa có tài khoản nào</td></tr>
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
                        {/* [MOD FEATURE]: muc tieu KC + san luong du kien tu so acc da cap */}
                        <td className="px-4 py-2.5 text-right text-xs whitespace-nowrap">
                          {r.targetKc > 0 ? (
                            <div className="flex flex-col items-end gap-0.5">
                              <span className="font-mono font-semibold text-violet-200">{fmtNum(r.targetKc)}</span>
                              <span
                                className={`font-mono text-[10px] ${r.kcDuKien >= r.targetKc ? 'text-emerald-400' : 'text-rose-400'}`}
                                title={`Dự kiến từ ${fmtNum(r.soAcc200)} Lv200 + ${fmtNum(r.soAcc50)} Lv50 đã cấp`}
                              >
                                dự kiến {fmtNum(r.kcDuKien)}
                              </span>
                              {/* [MOD FEATURE]: an chia voi khach */}
                              {(r.tyLeKhach ?? 100) < 100 && (
                                <span
                                  className="text-[10px] text-emerald-300/90"
                                  title={`Khách ${r.tyLeKhach}% · mình ${100 - r.tyLeKhach}% → nhận vào ${r.tkNhan || '(chưa có acc nhận)'}`}
                                >
                                  khách {r.tyLeKhach}% · mình {fmtNum(r.chiaMucTieu?.minh || 0)}
                                </span>
                              )}
                            </div>
                          ) : (
                            <span className="text-slate-600">—</span>
                          )}
                        </td>
                        <td className="px-4 py-2.5 text-right font-mono text-xs text-slate-300">
                          <div className="flex flex-col items-end gap-0.5">
                            <span>{fmtNum(r.soAcc)}</span>
                            <span className="text-[10px] text-slate-500">
                              <span className="text-amber-300/80">{fmtNum(r.soAcc200 || 0)}</span> / <span className="text-sky-300/80">{fmtNum(r.soAcc50 || 0)}</span>
                            </span>
                          </div>
                        </td>
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
                  [MOD FEATURE]: MUC TIEU SAN LUONG -> TU PHAN BO
                  Nhap so KC muon cay + server -> tinh so acc Lv200 / Lv50
                  (1 Lv200 = 60 KC, can 5 Lv50) roi cap tu acc trong trong kho.
                 ============================================================= */}
              {(() => {
                const can = tinhCanCap(form.targetKc);
                const doiMucTieu = form.daPhanBoCho !== `${can.targetKc}|${parseInt(String(form.mtServer), 10)}`;
                const chayKhiRoi = () => {
                  const sv = parseInt(String(form.mtServer), 10);
                  if (can.targetKc > 0 && Number.isFinite(sv) && sv >= 0 && doiMucTieu && !dangPhanBo) tuPhanBo();
                };
                return (
                  <div className="shrink-0 rounded-xl border border-violet-500/30 bg-violet-500/[0.04] p-3">
                    <div className="flex items-end gap-3 flex-wrap">
                      <div>
                        <label className="block text-[11px] font-medium text-slate-400 mb-1">Mục tiêu kim cương (KC)</label>
                        <input
                          type="number"
                          min={0}
                          value={form.targetKc}
                          onChange={(e) => setForm({ ...form, targetKc: e.target.value })}
                          onBlur={chayKhiRoi}
                          onKeyDown={(e) => { if (e.key === 'Enter') chayKhiRoi(); }}
                          placeholder="vd: 5000"
                          className="w-40 px-3 py-2 rounded-lg bg-slate-950 border border-violet-700/60 text-sm text-violet-100 font-semibold placeholder:text-slate-600 placeholder:font-normal focus:outline-none focus:border-violet-500"
                        />
                      </div>
                      <div>
                        <label className="block text-[11px] font-medium text-slate-400 mb-1">Server ID</label>
                        <input
                          type="number"
                          min={0}
                          value={form.mtServer}
                          onChange={(e) => setForm({ ...form, mtServer: e.target.value })}
                          onBlur={chayKhiRoi}
                          onKeyDown={(e) => { if (e.key === 'Enter') chayKhiRoi(); }}
                          placeholder="vd: 517"
                          className="w-28 px-3 py-2 rounded-lg bg-slate-950 border border-slate-800 text-sm text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-violet-600"
                        />
                      </div>
                      <div className="text-xs text-slate-500 pb-2 min-w-[120px]">
                        {tenServerTuDong(form.mtServer) || '—'}
                      </div>
                      <button
                        onClick={() => tuPhanBo()}
                        disabled={dangPhanBo || can.targetKc <= 0 || String(form.mtServer).trim() === ''}
                        className="ml-auto flex items-center gap-1.5 px-3 py-2 rounded-lg bg-gradient-to-r from-violet-600 to-fuchsia-600 text-white text-xs font-semibold disabled:opacity-40 disabled:cursor-not-allowed hover:opacity-90 transition"
                        title="Tính lại và cấp acc trống trong kho (giữ nguyên các dòng đã chạy)"
                      >
                        <Wand2 className="w-3.5 h-3.5" />
                        {dangPhanBo ? 'Đang phân bổ...' : form.dong.some((d: any) => !d.daChay) ? 'Phân bổ lại' : 'Tự phân bổ'}
                      </button>
                    </div>

                    {can.targetKc > 0 && (
                      <div className="mt-2 flex items-center flex-wrap gap-x-3 gap-y-1 text-xs text-slate-400">
                        <span>Cần</span>
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-amber-500/10 border border-amber-500/30 text-amber-200">
                          <Crown className="w-3 h-3" /> <b>{fmtNum(can.lv200)}</b> acc Lv200
                        </span>
                        <span>+</span>
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-sky-500/10 border border-sky-500/30 text-sky-200">
                          <UserPlus className="w-3 h-3" /> <b>{fmtNum(can.lv50)}</b> acc Lv50
                        </span>
                        <span className="text-slate-500">
                          → {fmtNum(can.lv200)} × {KC_MOI_LV200} KC = <b className="text-violet-200">{fmtNum(can.kc)} KC</b>
                          {' '}· mỗi Lv200 cần {LV50_MOI_LV200} Lv50 · làm tròn lên
                        </span>
                        {doiMucTieu && form.dong.some((d: any) => !d.daChay) && (
                          <span className="text-amber-400">· mục tiêu đã đổi — bấm “Phân bổ lại”</span>
                        )}
                      </div>
                    )}
                  </div>
                );
              })()}

              {/* =============================================================
                  [MOD FEATURE]: AN CHIA VOI KHACH
                  100% = khach nhan het. Duoi 100% thi phan con lai cua minh
                  se duoc che do GOM KIM CUONG chuyen vao acc game nhan.
                 ============================================================= */}
              {(() => {
                const tl = tyLeHopLe(form.tyLeKhach);
                const hopLe = Number.isFinite(tl);
                const coChia = hopLe && tl < 100;
                const can = tinhCanCap(form.targetKc);
                const chiaMT = chiaKc(can.targetKc, tl);
                return (
                  <div className={`shrink-0 rounded-xl border p-3 ${coChia ? 'border-emerald-500/30 bg-emerald-500/[0.04]' : 'border-slate-800 bg-slate-950/30'}`}>
                    <div className="flex items-end gap-3 flex-wrap">
                      <div>
                        <label className="block text-[11px] font-medium text-slate-400 mb-1">Tỉ lệ khách nhận (%)</label>
                        <div className="flex items-center gap-1.5">
                          <input
                            type="number"
                            min={0}
                            max={100}
                            value={form.tyLeKhach}
                            onChange={(e) => setForm({ ...form, tyLeKhach: e.target.value })}
                            placeholder="100"
                            className={`w-24 px-3 py-2 rounded-lg bg-slate-950 border text-sm font-semibold text-center focus:outline-none ${hopLe ? 'border-slate-700 text-slate-100 focus:border-emerald-600' : 'border-rose-600 text-rose-300'}`}
                          />
                          {[100, 70, 60, 50].map((v) => (
                            <button
                              key={v}
                              onClick={() => setForm({ ...form, tyLeKhach: String(v) })}
                              className={`px-2 py-1 rounded-md text-[11px] font-semibold border transition ${
                                String(tl) === String(v)
                                  ? 'bg-emerald-500/20 border-emerald-500/50 text-emerald-200'
                                  : 'bg-slate-900 border-slate-800 text-slate-400 hover:text-slate-200'
                              }`}
                            >
                              {v}%
                            </button>
                          ))}
                        </div>
                      </div>
                      <div className="pb-2 text-xs text-slate-400">
                        {!hopLe ? (
                          <span className="text-rose-400">Nhập số nguyên 0–100</span>
                        ) : coChia ? (
                          <>
                            Khách <b className="text-slate-200">{tl}%</b> · mình <b className="text-emerald-300">{100 - tl}%</b>
                            {can.targetKc > 0 && (
                              <span className="text-slate-500">
                                {' '}— mục tiêu {fmtNum(can.targetKc)} KC: khách {fmtNum(chiaMT.khach)} · mình <b className="text-emerald-300">{fmtNum(chiaMT.minh)}</b>
                              </span>
                            )}
                          </>
                        ) : (
                          <span className="text-slate-500">Khách nhận toàn bộ — không cần tài khoản nhận</span>
                        )}
                      </div>
                    </div>

                    {coChia && (
                      <div className="mt-2.5 grid grid-cols-2 gap-3">
                        <div>
                          <label className="block text-[11px] font-medium text-slate-400 mb-1">
                            Tài khoản game nhận phần của mình ({100 - tl}%)
                          </label>
                          <input
                            value={form.tkNhan}
                            onChange={(e) => setForm({ ...form, tkNhan: e.target.value })}
                            placeholder="email / tài khoản đăng nhập game"
                            className={`w-full px-3 py-2 rounded-lg bg-slate-950 border text-sm text-slate-200 placeholder:text-slate-600 focus:outline-none focus:border-emerald-600 ${String(form.tkNhan).trim() ? 'border-slate-800' : 'border-rose-700/70'}`}
                          />
                        </div>
                        <div>
                          <label className="block text-[11px] font-medium text-slate-400 mb-1">Mật khẩu tài khoản nhận</label>
                          <div className="relative">
                            <input
                              type={hienMkNhan ? 'text' : 'password'}
                              value={form.mkNhan}
                              onChange={(e) => setForm({ ...form, mkNhan: e.target.value })}
                              placeholder="mật khẩu đăng nhập game"
                              autoComplete="new-password"
                              className={`w-full pl-3 pr-9 py-2 rounded-lg bg-slate-950 border text-sm text-slate-200 font-mono placeholder:text-slate-600 placeholder:font-sans focus:outline-none focus:border-emerald-600 ${String(form.mkNhan).trim() ? 'border-slate-800' : 'border-rose-700/70'}`}
                            />
                            <button
                              type="button"
                              onClick={() => setHienMkNhan((v) => !v)}
                              title={hienMkNhan ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
                              className="absolute right-2 top-1/2 -translate-y-1/2 p-1 text-slate-500 hover:text-slate-200"
                            >
                              {hienMkNhan ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                            </button>
                          </div>
                        </div>
                        <p className="col-span-2 text-[11px] text-slate-600">
                          Cày xong, chế độ gom kim cương sẽ đăng nhập tài khoản này để chuyển phần {100 - tl}% vào.
                        </p>
                      </div>
                    )}
                  </div>
                );
              })()}

              {/* =============================================================
                  Danh sach dong cong viec - chi cuon RIENG trong khoi nay
                 ============================================================= */}
              <div className="flex-1 min-h-0 flex flex-col">
                <div className="shrink-0 flex items-center justify-between mb-1.5">
                  <label className="text-xs font-medium text-slate-400">
                    Tài khoản được cấp — tự phân bổ theo mục tiêu, sửa được số acc / dải STT, thêm dòng để cấp thêm
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
                  <div className="shrink-0 grid grid-cols-[26px_120px_88px_minmax(120px,1fr)_100px_96px_16px_96px_32px] gap-2 items-center px-3 py-1.5 bg-slate-900/70 border-b border-slate-800 text-[10px] font-semibold uppercase tracking-wide text-slate-500">
                    <span />
                    <span>Level cày</span>
                    <span>Server ID</span>
                    <span>Tên server</span>
                    <span className="text-center text-violet-400/80">Số acc</span>
                    <span className="text-center">Từ STT</span>
                    <span />
                    <span className="text-center">Đến STT</span>
                    <span />
                  </div>

                  <div className="flex-1 min-h-0 overflow-auto p-2 space-y-2">
                    {form.dong.length === 0 && (
                      <div className="px-3 py-6 text-center text-xs text-slate-500">
                        Chưa cấp tài khoản nào. Nhập <b className="text-violet-300">mục tiêu KC</b> + <b className="text-slate-300">Server ID</b> ở trên để tự phân bổ, hoặc bấm “Thêm dòng”.
                      </div>
                    )}
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
                          <div className="grid grid-cols-[26px_120px_88px_minmax(120px,1fr)_100px_96px_16px_96px_32px] gap-2 items-center">
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

                            {/* So acc: nhap so luong -> web cap dai STT co DUNG so acc that */}
                            <input
                              type="number"
                              min={0}
                              value={d.soLuong}
                              onChange={(e) => doiO(d.khoa, 'soLuong', e.target.value)}
                              disabled={d.daChay}
                              onBlur={() => capTheoSoLuong(d.khoa)}
                              onKeyDown={(e) => { if (e.key === 'Enter') capTheoSoLuong(d.khoa); }}
                              placeholder="số acc"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-violet-800/60 text-xs text-violet-200 font-semibold text-center placeholder:text-slate-600 placeholder:font-normal focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />
                            <input
                              type="number"
                              value={d.rangeFrom}
                              onChange={(e) => doiO(d.khoa, 'rangeFrom', e.target.value)}
                              disabled={d.daChay}
                              onBlur={() => {
                                const tu = parseInt(String(d.rangeFrom), 10);
                                if ((parseInt(String(d.soLuong), 10) || 0) > 0 && Number.isFinite(tu)) capTheoSoLuong(d.khoa, form, tu);
                                else demTheoDai(d.khoa);
                              }}
                              placeholder="tự cấp"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-slate-800 text-xs text-slate-200 text-center placeholder:text-slate-600 focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />
                            <span className="text-slate-600 text-xs text-center">→</span>
                            <input
                              type="number"
                              value={d.rangeTo}
                              onChange={(e) => doiO(d.khoa, 'rangeTo', e.target.value)}
                              disabled={d.daChay}
                              onBlur={() => demTheoDai(d.khoa)}
                              placeholder="tự cấp"
                              className="w-full px-2.5 py-1.5 rounded-lg bg-slate-950 border border-slate-800 text-xs text-slate-200 text-center placeholder:text-slate-600 focus:outline-none focus:border-violet-600 disabled:opacity-50 disabled:cursor-not-allowed"
                            />

                            <button
                              onClick={() => xoaDong(d.khoa)}
                              disabled={d.daChay}
                              title={d.daChay ? 'Công việc đã chạy, không xoá được' : 'Xoá dòng này'}
                              className="p-1.5 rounded-lg bg-slate-800 text-rose-300 hover:bg-rose-900/40 disabled:opacity-25 disabled:cursor-not-allowed transition"
                            >
                              <Trash2 className="w-3.5 h-3.5" />
                            </button>
                          </div>

                          {(kho || cl !== undefined || clMinh || d.thieu > 0) && (
                            <div className="mt-1.5 pl-[34px] space-y-1">
                              {d.thieu > 0 && (
                                <div className="flex items-center gap-1.5 text-[11px] text-rose-400">
                                  <AlertTriangle className="w-3.5 h-3.5 shrink-0" />
                                  Kho Lv{d.farmLevel} @ server {Number(d.serverId) || 0} chỉ còn đủ cấp {fmtNum(Number(d.soLuong) || 0)} acc — thiếu <b>{fmtNum(d.thieu)}</b> acc
                                </div>
                              )}
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
                                      onClick={() => {
                                        doiO(d.khoa, 'rangeFrom', String(batDauGoiY));
                                        if ((parseInt(String(d.soLuong), 10) || 0) > 0) capTheoSoLuong(d.khoa, form, batDauGoiY);
                                      }}
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
                  Nhập <b className="text-slate-500">số acc</b> là web tự cấp dải STT trống có đúng số acc thật trong kho; sửa tay Từ/Đến thì web đếm lại số acc.{' '}
                  Dòng có <Lock className="inline w-3 h-3 text-amber-400 -mt-0.5" /> đã chạy: giữ nguyên, được tính vào mục tiêu khi phân bổ lại.{' '}
                  Hai dòng chỉ đụng nhau khi <b className="text-slate-500">cùng level và cùng server</b>.
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
              {(() => {
                // [MOD FEATURE]: TONG KET SAN LUONG tu so acc da cap
                const dsHopLe = dsCongViec();
                const tongTheoLv = (lv: number) => (form.dong || [])
                  .filter((d: any) => Number(d.farmLevel) === lv)
                  .reduce((t: number, d: any) => {
                    const tu = parseInt(String(d.rangeFrom), 10), den = parseInt(String(d.rangeTo), 10);
                    return Number.isFinite(tu) && Number.isFinite(den) && den >= tu ? t + (parseInt(String(d.soLuong), 10) || 0) : t;
                  }, 0);
                const so200 = tongTheoLv(200), so50 = tongTheoLv(50);
                const sl = tinhSanLuong(so200, so50);
                const can = tinhCanCap(form.targetKc);
                const lech50 = so50 - so200 * LV50_MOI_LV200;
                if (dsHopLe.length === 0) return <p className="text-[11px] text-slate-500">Chưa có dòng nào hợp lệ</p>;
                return (
                  <div className="flex items-center flex-wrap gap-x-3 gap-y-1 text-[11px] text-slate-400">
                    <span className="inline-flex items-center gap-1 text-amber-200"><Crown className="w-3 h-3" /> {fmtNum(so200)} Lv200</span>
                    <span className="inline-flex items-center gap-1 text-sky-200"><UserPlus className="w-3 h-3" /> {fmtNum(so50)} Lv50</span>
                    <span>→ dự kiến <b className="text-violet-200">{fmtNum(sl.kc)} KC</b></span>
                    {(() => {
                      const tl = tyLeHopLe(form.tyLeKhach);
                      if (!Number.isFinite(tl) || tl >= 100 || sl.kc <= 0) return null;
                      const c = chiaKc(sl.kc, tl);
                      return (
                        <span className="text-slate-500">
                          (khách {fmtNum(c.khach)} · mình <b className="text-emerald-300">{fmtNum(c.minh)}</b>)
                        </span>
                      );
                    })()}
                    {can.targetKc > 0 && (
                      sl.kc >= can.targetKc
                        ? <span className="inline-flex items-center gap-1 text-emerald-400"><CheckCircle2 className="w-3 h-3" /> đủ mục tiêu {fmtNum(can.targetKc)}</span>
                        : <span className="inline-flex items-center gap-1 text-rose-400"><AlertTriangle className="w-3 h-3" /> thiếu {fmtNum(can.targetKc - sl.kc)} KC so với mục tiêu {fmtNum(can.targetKc)}</span>
                    )}
                    {so200 > 0 && lech50 !== 0 && (
                      <span className="text-amber-400">
                        · {lech50 > 0 ? `dư ${fmtNum(lech50)}` : `thiếu ${fmtNum(-lech50)}`} Lv50 so với {fmtNum(so200)} Lv200
                      </span>
                    )}
                  </div>
                );
              })()}
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
