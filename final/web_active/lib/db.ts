import { PrismaClient } from '@prisma/client';
import { hashPassword } from './auth';

const globalForPrisma = global as unknown as { prisma: PrismaClient };

export const prisma =
  globalForPrisma.prisma ||
  new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['error', 'warn'] : ['error'],
  });

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;

let seedExecuted = false;

export async function ensureInitialSeed() {
  if (seedExecuted) return;
  seedExecuted = true;
  try {
    const userCount = await prisma.user.count();
    if (userCount === 0) {
      console.log('Seeding initial Super Admin user...');
      const adminPass = hashPassword('admin123');
      const salePass = hashPassword('sale123');

      const superAdmin = await prisma.user.create({
        data: {
          username: 'admin',
          passwordHash: adminPass,
          displayName: 'Super Admin',
          role: 'ADMIN',
        },
      });

      await prisma.user.create({
        data: {
          username: 'sale1',
          passwordHash: salePass,
          displayName: 'Nhân viên CSKH 1',
          role: 'SALE',
        },
      });

      console.log('Seeding default VIP packages...');
      const defaultPackages = [
        { name: 'Gói VIP 3 Ngày', durationDays: 3, price: 50000 },
        { name: 'Gói VIP 7 Ngày', durationDays: 7, price: 100000 },
        { name: 'Gói VIP 15 Ngày', durationDays: 15, price: 180000 },
        { name: 'Gói VIP 30 Ngày', durationDays: 30, price: 300000 },
        { name: 'Gói VIP 90 Ngày', durationDays: 90, price: 800000 },
      ];

      for (const pkg of defaultPackages) {
        await prisma.vipPackage.create({
          data: {
            name: pkg.name,
            durationDays: pkg.durationDays,
            fovMin: 20,
            fovMax: 90,
            bossRefreshMin: 1,
            bossRefreshMax: 60,
            maxMoveSpeed: 2.5,
            maxAttackSpeed: 2.5,
            maxMonsterRange: 50,
            maxPickupCount: 100,
            activeTabBasic: true,
            activeTabAdvanced: true,
            activeTabAutofarm: true,
            price: pkg.price,
          },
        });
      }
      console.log('Seeding default Telegram CSKH contacts...');
      await prisma.telegramContact.createMany({
        data: [
          { username: '@xoajxanh', name: 'Admin Xoài' },
          { username: '@legend92vn', name: 'Admin Legend' },
        ],
      });

      console.log('Database initial seed complete!');
    }
  } catch (err) {
    console.error('Error during initial seed:', err);
  }
}

