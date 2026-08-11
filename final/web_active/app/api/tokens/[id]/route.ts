import { NextRequest, NextResponse } from 'next/server';
import { getSessionUser } from '@/lib/auth';
import { prisma } from '@/lib/db';
import { generateEncryptedToken } from '@/lib/keygen';

export async function GET(req: NextRequest, { params }: { params: { id: string } }) {
  const session = await getSessionUser(req);
  if (!session) {
    return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  }

  const { id } = params;
  const token = await prisma.token.findUnique({
    where: { id },
    include: {
      vipPackage: true,
      createdBy: { select: { id: true, username: true, displayName: true, role: true } },
      notes: {
        include: {
          createdBy: { select: { id: true, username: true, displayName: true } },
        },
        orderBy: { createdAt: 'desc' },
      },
    },
  });

  if (!token) {
    return NextResponse.json({ error: 'Token không tồn tại' }, { status: 404 });
  }

  return NextResponse.json({ token });
}

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  const session = await getSessionUser(req);
  if (!session) {
    return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  }

  try {
    const { id } = params;
    const existingToken = await prisma.token.findUnique({ where: { id } });
    if (!existingToken) {
      return NextResponse.json({ error: 'Token không tồn tại' }, { status: 404 });
    }

    const body = await req.json();

    // Check if Admin is restoring a soft-deleted token
    if (body.action === 'RESTORE' && session.role === 'ADMIN') {
      const restoredToken = await prisma.token.update({
        where: { id },
        data: {
          isDeleted: false,
          deletedAt: null,
        },
      });

      await prisma.tokenNote.create({
        data: {
          tokenId: id,
          createdById: session.userId,
          action: 'RESTORE',
          detail: `Admin [${session.displayName}] đã khôi phục lại Token bị xóa logic.`,
        },
      });

      return NextResponse.json({ success: true, message: 'Đã khôi phục Token thành công', token: restoredToken });
    }

    const {
      deviceSnMd5,
      characterUid,
      customerName,
      isTest,
      packageId,
      durationDays,
      fovMin,
      fovMax,
      bossRefreshMin,
      bossRefreshMax,
      maxMoveSpeed,
      maxAttackSpeed,
      maxMonsterRange,
      maxPickupCount,
      pickupDelayMin,
      pickupDelayMax,
      activeTabBasic,
      activeTabAdvanced,
      activeTabAutofarm,
      characterReincarnation,
      adminTelegrams,
      price,
      isCustom,
      noteDetail,
    } = body;

    const newDuration = durationDays !== undefined ? Number(durationDays) : existingToken.durationDays;
    const now = new Date();
    const expireAt = new Date(now.getTime() + newDuration * 86400 * 1000);
    const expireAtUnix = Math.floor(expireAt.getTime() / 1000);

    let telegramsList: string[];
    if (adminTelegrams) {
      telegramsList = Array.isArray(adminTelegrams)
        ? adminTelegrams
        : typeof adminTelegrams === 'string'
        ? adminTelegrams.split(',').map((s) => s.trim()).filter((s) => s)
        : ['@admin1', '@admin2'];
    } else {
      try {
        telegramsList = JSON.parse(existingToken.adminTelegrams);
      } catch {
        telegramsList = ['@admin1', '@admin2'];
      }
    }

    const updatedParams = {
      deviceSnMd5: (deviceSnMd5 !== undefined ? deviceSnMd5 : existingToken.deviceSnMd5).trim(),
      characterUid: (characterUid !== undefined ? characterUid : existingToken.characterUid).trim(),
      durationDays: newDuration,
      expireAtUnix,
      fovMin: fovMin !== undefined ? Number(fovMin) : existingToken.fovMin,
      fovMax: fovMax !== undefined ? Number(fovMax) : existingToken.fovMax,
      bossRefreshMin: bossRefreshMin !== undefined ? Number(bossRefreshMin) : existingToken.bossRefreshMin,
      bossRefreshMax: bossRefreshMax !== undefined ? Number(bossRefreshMax) : existingToken.bossRefreshMax,
      maxMoveSpeed: maxMoveSpeed !== undefined ? Number(maxMoveSpeed) : existingToken.maxMoveSpeed,
      maxAttackSpeed: maxAttackSpeed !== undefined ? Number(maxAttackSpeed) : existingToken.maxAttackSpeed,
      maxMonsterRange: maxMonsterRange !== undefined ? Number(maxMonsterRange) : existingToken.maxMonsterRange,
      maxPickupCount: maxPickupCount !== undefined ? Number(maxPickupCount) : existingToken.maxPickupCount,
      pickupDelayMin: pickupDelayMin !== undefined ? Number(pickupDelayMin) : existingToken.pickupDelayMin,
      pickupDelayMax: pickupDelayMax !== undefined ? Number(pickupDelayMax) : existingToken.pickupDelayMax,
      activeTabBasic: activeTabBasic !== undefined ? Boolean(activeTabBasic) : existingToken.activeTabBasic,
      activeTabAdvanced: activeTabAdvanced !== undefined ? Boolean(activeTabAdvanced) : existingToken.activeTabAdvanced,
      activeTabAutofarm: activeTabAutofarm !== undefined ? Boolean(activeTabAutofarm) : existingToken.activeTabAutofarm,
      characterReincarnation: characterReincarnation !== undefined ? Number(characterReincarnation) : existingToken.characterReincarnation,
      adminTelegrams: telegramsList,
    };

    const { encryptedToken } = generateEncryptedToken(updatedParams);

    const updatedToken = await prisma.token.update({
      where: { id },
      data: {
        deviceSnMd5: updatedParams.deviceSnMd5,
        characterUid: updatedParams.characterUid,
        customerName: customerName !== undefined ? (customerName ? String(customerName).trim() : null) : existingToken.customerName,
        isTest: isTest !== undefined ? Boolean(isTest) : existingToken.isTest,
        packageId: packageId !== undefined ? packageId : existingToken.packageId,
        durationDays: updatedParams.durationDays,
        expireAt,
        fovMin: updatedParams.fovMin,
        fovMax: updatedParams.fovMax,
        bossRefreshMin: updatedParams.bossRefreshMin,
        bossRefreshMax: updatedParams.bossRefreshMax,
        maxMoveSpeed: updatedParams.maxMoveSpeed,
        maxAttackSpeed: updatedParams.maxAttackSpeed,
        maxMonsterRange: updatedParams.maxMonsterRange,
        maxPickupCount: updatedParams.maxPickupCount,
        pickupDelayMin: updatedParams.pickupDelayMin,
        pickupDelayMax: updatedParams.pickupDelayMax,
        activeTabBasic: updatedParams.activeTabBasic,
        activeTabAdvanced: updatedParams.activeTabAdvanced,
        activeTabAutofarm: updatedParams.activeTabAutofarm,
        characterReincarnation: updatedParams.characterReincarnation,
        adminTelegrams: JSON.stringify(telegramsList),
        price: price !== undefined ? Number(price) : existingToken.price,
        isCustom: isCustom !== undefined ? Boolean(isCustom) : existingToken.isCustom,
        encryptedToken,
      },
    });

    const auditDetail = noteDetail
      ? noteDetail.trim()
      : `Cập nhật cấu hình Token (MD5: ${updatedParams.deviceSnMd5}, UID: ${updatedParams.characterUid}, Hạn: ${updatedParams.durationDays} ngày).`;

    await prisma.tokenNote.create({
      data: {
        tokenId: id,
        createdById: session.userId,
        action: 'UPDATE',
        detail: auditDetail,
      },
    });

    return NextResponse.json({ success: true, token: updatedToken });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi khi cập nhật Token' }, { status: 500 });
  }
}

export async function DELETE(req: NextRequest, { params }: { params: { id: string } }) {
  const session = await getSessionUser(req);
  if (!session) {
    return NextResponse.json({ error: 'Chưa đăng nhập' }, { status: 401 });
  }

  try {
    const { id } = params;
    const token = await prisma.token.findUnique({ where: { id } });
    if (!token) {
      return NextResponse.json({ error: 'Token không tồn tại' }, { status: 404 });
    }

    const { searchParams } = new URL(req.url);
    const isHardDelete = searchParams.get('hard') === 'true';

    // If SALE staff or soft-delete requested: Soft Delete (Xóa Logic)
    if (session.role === 'SALE' || (!isHardDelete && token.isDeleted === false)) {
      await prisma.token.update({
        where: { id },
        data: {
          isDeleted: true,
          deletedAt: new Date(),
        },
      });

      // Log Soft Delete in TokenNote
      await prisma.tokenNote.create({
        data: {
          tokenId: id,
          createdById: session.userId,
          action: 'SOFT_DELETE',
          detail: `Nhân viên [${session.displayName}] (${session.role}) đã thực hiện xóa logic (Soft Delete) Token này. Token đã bị hủy kích hoạt trên Client Mod.`,
        },
      });

      return NextResponse.json({
        success: true,
        isSoftDelete: true,
        message: 'Đã hủy kích hoạt và xóa logic Token. Nhật ký đã được lưu cho Admin kiểm tra.',
      });
    }

    // Only ADMIN can perform Hard Delete (Xóa Vĩnh Viễn khỏi DB)
    if (session.role !== 'ADMIN') {
      return NextResponse.json({ error: 'Chỉ Admin mới có quyền xóa vĩnh viễn Token khỏi cơ sở dữ liệu!' }, { status: 403 });
    }

    // Admin Hard Delete - Atomically delete dependent notes and token
    await prisma.$transaction([
      prisma.tokenNote.deleteMany({ where: { tokenId: id } }),
      prisma.token.delete({ where: { id } }),
    ]);

    return NextResponse.json({ success: true, isHardDelete: true, message: 'Admin đã xóa vĩnh viễn Token thành công' });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Lỗi khi xóa Token' }, { status: 500 });
  }
}
