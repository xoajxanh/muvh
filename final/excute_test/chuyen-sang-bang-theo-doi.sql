/* =========================================================================
   FARM KC - CHUYEN TIEN DO SANG BANG THEO DOI + TRA KHO MAC DINH VE SACH
   -------------------------------------------------------------------------
   Truoc day mod ghi thang tien do (server, nhan vat, ma moi, vang...) vao kho
   mac dinh FarmInviter / FarmInvitee. Script nay:
     1. Sao cac dong co serverId <> 0 sang FarmInviterPlay / FarmInviteePlay,
        gan nguoi choi + jobCode theo dai STT cua cong viec da giao.
     2. Noi lai quan he "Lv50 duoc moi boi Lv200" sang dong theo doi (cung server).
     3. Dua cac dong goc ve trang thai mac dinh: serverId = 0, NEW, xoa nhan vat,
        ma moi, vang, KC, kim phieu... Chi giu email / mat khau / STT / UID.

   CACH CHAY:
     - Lan dau de @chayThat = 0  -> chay thu, cuoi script ROLLBACK, khong doi gi.
       Doc ket qua dem truoc/sau, thay dung thi doi thanh 1 va chay lai.
     - YEU CAU: web da khoi dong it nhat 1 lan voi ban moi (de tao 2 bang Play).
     - Chay lai nhieu lan vo hai: dong da sao roi thi bo qua.
   ========================================================================= */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @chayThat BIT = 0;   -- <<< DOI THANH 1 DE GHI THAT

IF OBJECT_ID(N'[dbo].[FarmInviterPlay]') IS NULL OR OBJECT_ID(N'[dbo].[FarmInviteePlay]') IS NULL
BEGIN
    RAISERROR(N'Chua co bang FarmInviterPlay / FarmInviteePlay - hay khoi dong web ban moi truoc.', 16, 1);
    RETURN;
END;

PRINT N'=== TRUOC KHI CHUYEN ===';
SELECT N'Kho Lv200 (FarmInviter)' AS bang,
       COUNT(*) AS tong,
       SUM(CASE WHEN [serverId] <> 0 THEN 1 ELSE 0 END) AS dang_lan_tien_do,
       SUM(CASE WHEN [farmAccountId] IS NOT NULL THEN 1 ELSE 0 END) AS co_gan_tai_khoan
FROM [dbo].[FarmInviter]
UNION ALL
SELECT N'Kho Lv50 (FarmInvitee)', COUNT(*),
       SUM(CASE WHEN [serverId] <> 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN [farmAccountId] IS NOT NULL THEN 1 ELSE 0 END)
FROM [dbo].[FarmInvitee]
UNION ALL
SELECT N'Theo doi Lv200 (FarmInviterPlay)', COUNT(*), NULL, NULL FROM [dbo].[FarmInviterPlay]
UNION ALL
SELECT N'Theo doi Lv50 (FarmInviteePlay)', COUNT(*), NULL, NULL FROM [dbo].[FarmInviteePlay];

BEGIN TRAN;

/* -------------------------------------------------------------------------
   BUOC 1 - Lv200: sao tien do sang FarmInviterPlay
   ------------------------------------------------------------------------- */
INSERT INTO [dbo].[FarmInviterPlay] (
    [id], [masterId], [stt], [email], [password], [serverId], [serverName],
    [roleId], [roleName], [level], [inviteCode], [gameInviteNum], [confirmedCount],
    [reservedCount], [maxInvites], [unboundGold], [unboundDiamond], [goldVoucher],
    [packBought], [status], [failCount], [lastError], [lastSyncAt],
    [farmAccountId], [jobCode], [createdById], [createdAt], [updatedAt]
)
SELECT
    LOWER(CONVERT(NVARCHAR(100), NEWID())), m.[id], m.[stt], m.[email], m.[password],
    m.[serverId], m.[serverName], m.[roleId], m.[roleName], m.[level], m.[inviteCode],
    m.[gameInviteNum], m.[confirmedCount], m.[reservedCount], m.[maxInvites],
    m.[unboundGold], m.[unboundDiamond], m.[goldVoucher], m.[packBought], m.[status],
    m.[failCount], m.[lastError], m.[lastSyncAt],
    v.[farmAccountId], v.[jobCode], m.[createdById], m.[createdAt], m.[updatedAt]
FROM [dbo].[FarmInviter] m
OUTER APPLY (
    SELECT TOP 1 r.[farmAccountId], r.[jobCode]
    FROM [dbo].[FarmAccountRange] r
    WHERE r.[farmLevel] = 200 AND r.[serverId] = m.[serverId]
      AND m.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
) v
WHERE m.[serverId] <> 0
  AND NOT EXISTS (
      SELECT 1 FROM [dbo].[FarmInviterPlay] p
      WHERE p.[email] = m.[email] AND p.[serverId] = m.[serverId]
  );
PRINT CONCAT(N'  Buoc 1 - sao Lv200: ', @@ROWCOUNT, N' dong');

/* -------------------------------------------------------------------------
   BUOC 2 - Lv50: sao tien do sang FarmInviteePlay
   inviterId cu tro vao dong KHO Lv200 -> doi sang dong THEO DOI Lv200 cung server
   ------------------------------------------------------------------------- */
INSERT INTO [dbo].[FarmInviteePlay] (
    [id], [masterId], [stt], [email], [password], [serverId], [serverName],
    [roleId], [roleName], [level], [inviterId], [inviteCode], [status], [deviceId],
    [reservedAt], [expireAt], [confirmedAt], [errorMsg],
    [farmAccountId], [jobCode], [createdById], [createdAt], [updatedAt]
)
SELECT
    LOWER(CONVERT(NVARCHAR(100), NEWID())), m.[id], m.[stt], m.[email], m.[password],
    m.[serverId], m.[serverName], m.[roleId], m.[roleName], m.[level],
    ip.[id], m.[inviteCode], m.[status], m.[deviceId],
    m.[reservedAt], m.[expireAt], m.[confirmedAt], m.[errorMsg],
    v.[farmAccountId], v.[jobCode], m.[createdById], m.[createdAt], m.[updatedAt]
FROM [dbo].[FarmInvitee] m
OUTER APPLY (
    SELECT TOP 1 r.[farmAccountId], r.[jobCode]
    FROM [dbo].[FarmAccountRange] r
    WHERE r.[farmLevel] = 50 AND r.[serverId] = m.[serverId]
      AND m.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
) v
OUTER APPLY (
    SELECT TOP 1 p.[id]
    FROM [dbo].[FarmInviterPlay] p
    WHERE p.[masterId] = m.[inviterId] AND p.[serverId] = m.[serverId]
) ip
WHERE m.[serverId] <> 0
  AND NOT EXISTS (
      SELECT 1 FROM [dbo].[FarmInviteePlay] p
      WHERE p.[email] = m.[email] AND p.[serverId] = m.[serverId]
  );
PRINT CONCAT(N'  Buoc 2 - sao Lv50: ', @@ROWCOUNT, N' dong');

/* -------------------------------------------------------------------------
   BUOC 3 - Tra kho mac dinh ve sach
   Dong nao trong kho DA CO ban serverId = 0 cung email (hiem) thi xoa ban
   mang server, con lai dua ve serverId = 0 + xoa sach tien do.
   ------------------------------------------------------------------------- */
-- 3a. Lv50 truoc (no tro toi kho Lv200 qua inviterId)
UPDATE [dbo].[FarmInvitee]
SET [inviterId] = NULL, [farmAccountId] = NULL
WHERE [inviterId] IS NOT NULL OR [farmAccountId] IS NOT NULL;
PRINT CONCAT(N'  Buoc 3a - go lien ket kho Lv50: ', @@ROWCOUNT, N' dong');

DELETE m FROM [dbo].[FarmInvitee] m
WHERE m.[serverId] <> 0
  AND EXISTS (SELECT 1 FROM [dbo].[FarmInvitee] k WHERE k.[email] = m.[email] AND k.[serverId] = 0);
PRINT CONCAT(N'  Buoc 3b - xoa ban trung trong kho Lv50: ', @@ROWCOUNT, N' dong');

UPDATE [dbo].[FarmInvitee]
SET [serverId] = 0, [serverName] = N'', [roleId] = N'', [roleName] = N'', [level] = 0,
    [inviteCode] = NULL, [status] = N'NEW', [deviceId] = NULL, [reservedAt] = NULL,
    [expireAt] = NULL, [confirmedAt] = NULL, [errorMsg] = NULL, [updatedAt] = GETDATE()
WHERE [serverId] <> 0;
PRINT CONCAT(N'  Buoc 3c - tra kho Lv50 ve mac dinh: ', @@ROWCOUNT, N' dong');

-- 3d. Lv200
UPDATE [dbo].[FarmInviter] SET [farmAccountId] = NULL WHERE [farmAccountId] IS NOT NULL;
PRINT CONCAT(N'  Buoc 3d - go lien ket kho Lv200: ', @@ROWCOUNT, N' dong');

DELETE m FROM [dbo].[FarmInviter] m
WHERE m.[serverId] <> 0
  AND EXISTS (SELECT 1 FROM [dbo].[FarmInviter] k WHERE k.[email] = m.[email] AND k.[serverId] = 0);
PRINT CONCAT(N'  Buoc 3e - xoa ban trung trong kho Lv200: ', @@ROWCOUNT, N' dong');

UPDATE [dbo].[FarmInviter]
SET [serverId] = 0, [serverName] = N'', [roleId] = N'', [roleName] = N'', [level] = 0,
    [inviteCode] = NULL, [gameInviteNum] = 0, [confirmedCount] = 0, [reservedCount] = 0,
    [maxInvites] = 5, [unboundGold] = 0, [unboundDiamond] = 0, [goldVoucher] = 0,
    [packBought] = 0, [status] = N'NEW', [failCount] = 0, [lastError] = NULL,
    [lastSyncAt] = NULL, [updatedAt] = GETDATE()
WHERE [serverId] <> 0;
PRINT CONCAT(N'  Buoc 3f - tra kho Lv200 ve mac dinh: ', @@ROWCOUNT, N' dong');

/* -------------------------------------------------------------------------
   KIEM TRA SAU KHI CHUYEN
   ------------------------------------------------------------------------- */
PRINT N'=== SAU KHI CHUYEN ===';
SELECT N'Kho Lv200 (FarmInviter)' AS bang,
       COUNT(*) AS tong,
       SUM(CASE WHEN [serverId] <> 0 THEN 1 ELSE 0 END) AS con_lan_tien_do,
       SUM(CASE WHEN [status] <> N'NEW' THEN 1 ELSE 0 END) AS khac_NEW
FROM [dbo].[FarmInviter]
UNION ALL
SELECT N'Kho Lv50 (FarmInvitee)', COUNT(*),
       SUM(CASE WHEN [serverId] <> 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN [status] <> N'NEW' THEN 1 ELSE 0 END)
FROM [dbo].[FarmInvitee];

SELECT N'Theo doi Lv200' AS bang, p.[serverId], a.[username] AS nguoi_choi,
       COUNT(*) AS so_dong,
       SUM(CASE WHEN p.[masterId] IS NULL THEN 1 ELSE 0 END) AS khong_tim_thay_goc
FROM [dbo].[FarmInviterPlay] p
LEFT JOIN [dbo].[FarmAccount] a ON a.[id] = p.[farmAccountId]
GROUP BY p.[serverId], a.[username]
UNION ALL
SELECT N'Theo doi Lv50', p.[serverId], a.[username], COUNT(*),
       SUM(CASE WHEN p.[masterId] IS NULL THEN 1 ELSE 0 END)
FROM [dbo].[FarmInviteePlay] p
LEFT JOIN [dbo].[FarmAccount] a ON a.[id] = p.[farmAccountId]
GROUP BY p.[serverId], a.[username]
ORDER BY 1, 2, 3;

-- Lv50 dang RESERVED/SUCCESS ma mat lien ket toi nguoi moi Lv200
SELECT N'Lv50 co ma nhung khong noi duoc toi Lv200' AS canh_bao, COUNT(*) AS so_dong
FROM [dbo].[FarmInviteePlay]
WHERE [inviteCode] IS NOT NULL AND [inviterId] IS NULL;

IF @chayThat = 1
BEGIN
    COMMIT;
    PRINT N'>>> DA GHI THAT VAO DATABASE.';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT N'>>> CHAY THU - DA ROLLBACK, DATABASE KHONG DOI. Doi @chayThat = 1 de ghi that.';
END;
