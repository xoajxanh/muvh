import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma, ensureInitialSeed } from '@/lib/db';

export const dynamic = 'force-dynamic';


export async function GET(req: NextRequest) {
  await ensureInitialSeed();
  const session = await getSessionUser(req);
  if (!session) {
    return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  }

  const now = new Date();
  const threeDaysLater = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);
  const startOfCurrentMonth = new Date(now.getFullYear(), now.getMonth(), 1);

  const [
    totalRevenueAgg,
    monthRevenueAgg,
    totalTokensCount,
    monthTokensCount,
    expiringSoonCount,
    expiredCount,
    recentTokens,
  ] = await Promise.all([
    prisma.token.aggregate({ _sum: { price: true } }),
    prisma.token.aggregate({
      where: { createdAt: { gte: startOfCurrentMonth } },
      _sum: { price: true },
    }),
    prisma.token.count(),
    prisma.token.count({ where: { createdAt: { gte: startOfCurrentMonth } } }),
    prisma.token.count({
      where: { expireAt: { gte: now, lte: threeDaysLater } },
    }),
    prisma.token.count({ where: { expireAt: { lt: now } } }),
    prisma.token.findMany({
      take: 5,
      orderBy: { createdAt: 'desc' },
      include: {
        createdBy: { select: { displayName: true, username: true } },
        vipPackage: { select: { name: true } },
      },
    }),
  ]);

  // Aggregate monthly data for current year (Jan-Dec)
  const currentYear = now.getFullYear();
  const monthlyChartData = [];

  for (let month = 0; month < 12; month++) {
    const startOfMonth = new Date(currentYear, month, 1);
    const endOfMonth = new Date(currentYear, month + 1, 0, 23, 59, 59);

    const [mRevenue, mCount] = await Promise.all([
      prisma.token.aggregate({
        where: { createdAt: { gte: startOfMonth, lte: endOfMonth } },
        _sum: { price: true },
      }),
      prisma.token.count({
        where: { createdAt: { gte: startOfMonth, lte: endOfMonth } },
      }),
    ]);

    monthlyChartData.push({
      month: `Thg ${month + 1}`,
      revenue: mRevenue._sum.price || 0,
      tokens: mCount,
    });
  }

  return NextResponse.json({
    summary: {
      totalRevenue: totalRevenueAgg._sum.price || 0,
      monthRevenue: monthRevenueAgg._sum.price || 0,
      totalTokens: totalTokensCount,
      monthTokens: monthTokensCount,
      expiringSoon: expiringSoonCount,
      expired: expiredCount,
    },
    monthlyChartData,
    recentTokens,
  });
}
