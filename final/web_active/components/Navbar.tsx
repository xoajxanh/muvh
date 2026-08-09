'use client';

import React from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { User, LogOut, ShieldCheck, KeyRound } from 'lucide-react';
import { UserSession } from '@/lib/auth';

interface NavbarProps {
  user: UserSession | null;
}

export default function Navbar({ user }: NavbarProps) {
  const router = Router();

  const handleLogout = async () => {
    try {
      await fetch('/api/auth/logout', { method: 'POST' });
      router.push('/login');
      router.refresh();
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <header className="h-16 glass-panel border-b border-slate-800 px-6 flex items-center justify-between sticky top-0 z-40">
      <div className="flex items-center gap-3">
        <img src="/logo.png" alt="VUT MOD TEAMS" className="w-9 h-9 object-contain md:hidden drop-shadow" />
        <h2 className="font-semibold text-slate-200 text-sm md:text-base flex items-center gap-2">
          <span>Hệ Thống Quản Lý Bản Quyền Token</span>
          <span className="hidden lg:inline text-xs px-2 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/20 font-bold">VUT MOD TEAMS</span>
        </h2>
      </div>

      <div className="flex items-center gap-4">
        {user && (
          <div className="flex items-center gap-3">
            <span
              className={`px-2.5 py-1 rounded-full text-xs font-bold uppercase flex items-center gap-1 ${
                user.role === 'ADMIN'
                  ? 'bg-amber-500/10 text-amber-400 border border-amber-500/30'
                  : 'bg-cyan-500/10 text-cyan-400 border border-cyan-500/30'
              }`}
            >
              <ShieldCheck className="w-3.5 h-3.5" />
              {user.role === 'ADMIN' ? 'Super Admin' : 'Sale Staff'}
            </span>

            <div className="flex items-center gap-2 border-l border-slate-800 pl-4">
              <div className="w-8 h-8 rounded-full bg-slate-800 flex items-center justify-center text-cyan-400 font-bold text-sm border border-slate-700">
                {user.displayName.charAt(0).toUpperCase()}
              </div>
              <div className="hidden sm:block text-left">
                <div className="text-xs font-semibold text-slate-200">{user.displayName}</div>
                <div className="text-[10px] text-slate-400">@{user.username}</div>
              </div>
            </div>

            <Link
              href="/profile"
              className="p-2 rounded-lg bg-slate-800/60 hover:bg-slate-800 text-slate-400 hover:text-slate-200 transition"
              title="Đổi thông tin / Mật khẩu"
            >
              <KeyRound className="w-4 h-4" />
            </Link>

            <button
              onClick={handleLogout}
              className="p-2 rounded-lg bg-red-500/10 hover:bg-red-500/20 text-red-400 border border-red-500/20 transition flex items-center gap-1 text-xs font-medium"
              title="Đăng xuất"
            >
              <LogOut className="w-4 h-4" />
              <span className="hidden sm:inline">Thoát</span>
            </button>
          </div>
        )}
      </div>
    </header>
  );
}

function Router() {
  return useRouter();
}
