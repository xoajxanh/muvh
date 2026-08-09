import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'MUVH Admin - Quản Lý Bản Quyền Token Remote',
  description: 'Hệ thống quản lý active token từ xa cho MUVH Android Mod',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="vi" className="dark">
      <body className={inter.className}>
        <div className="min-h-screen bg-[#0b0f19] text-slate-100 flex flex-col antialiased">
          {children}
        </div>
      </body>
    </html>
  );
}
