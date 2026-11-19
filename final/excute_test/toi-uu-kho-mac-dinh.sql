/* =========================================================================
   FARM KC - TOI UU KHO MAC DINH: BO CAC COT TIEN DO THUA
   -------------------------------------------------------------------------
   Kho mac dinh chi giu thong tin dinh danh acc game:
       id, email, password, stt, uid, regIp, regAt, importBatch,
       createdById, createdAt, updatedAt
   Tien do choi da chuyen sang FarmInviterPlay / FarmInviteePlay, nen bo:
       FarmInviter : 19 cot      FarmInvitee : 14 cot
   Doi khoa duy nhat (email, serverId) thanh (email) - kho moi acc 1 dong.

   DIEU KIEN TRUOC KHI CHAY (script tu kiem tra, sai la dung lai):
     1. Da chay that chuyen-sang-bang-theo-doi.sql (@chayThat = 1)
        -> trong kho khong con dong nao serverId <> 0
     2. Trong moi bang kho khong co email trung
   CACH CHAY:
     - Lan dau @chayThat = 0 -> chay thu, cuoi script ROLLBACK.
     - Dung thi doi thanh 1, chay lai. Chay lai nhieu lan vo hai.
     - Chay xong: cap nhat code web ban moi + npx prisma generate + restart.
   ========================================================================= */
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @chayThat BIT = 0;   -- <<< DOI THANH 1 DE GHI THAT

/* -------------------------------------------------------------------------
   Danh sach cot se bo
   ------------------------------------------------------------------------- */
DECLARE @bo TABLE (bang SYSNAME, cot SYSNAME);
INSERT INTO @bo (bang, cot) VALUES
    (N'FarmInviter', N'serverId'),      (N'FarmInviter', N'serverName'),
    (N'FarmInviter', N'roleId'),        (N'FarmInviter', N'roleName'),
    (N'FarmInviter', N'level'),         (N'FarmInviter', N'inviteCode'),
    (N'FarmInviter', N'gameInviteNum'), (N'FarmInviter', N'confirmedCount'),
    (N'FarmInviter', N'reservedCount'), (N'FarmInviter', N'maxInvites'),
    (N'FarmInviter', N'unboundGold'),   (N'FarmInviter', N'unboundDiamond'),
    (N'FarmInviter', N'goldVoucher'),   (N'FarmInviter', N'packBought'),
    (N'FarmInviter', N'status'),        (N'FarmInviter', N'failCount'),
    (N'FarmInviter', N'lastError'),     (N'FarmInviter', N'lastSyncAt'),
    (N'FarmInviter', N'farmAccountId'),

    (N'FarmInvitee', N'serverId'),      (N'FarmInvitee', N'serverName'),
    (N'FarmInvitee', N'roleId'),        (N'FarmInvitee', N'roleName'),
    (N'FarmInvitee', N'level'),         (N'FarmInvitee', N'inviterId'),
    (N'FarmInvitee', N'inviteCode'),    (N'FarmInvitee', N'status'),
    (N'FarmInvitee', N'deviceId'),      (N'FarmInvitee', N'reservedAt'),
    (N'FarmInvitee', N'expireAt'),      (N'FarmInvitee', N'confirmedAt'),
    (N'FarmInvitee', N'errorMsg'),      (N'FarmInvitee', N'farmAccountId');

/* -------------------------------------------------------------------------
   KIEM TRA AN TOAN
   ------------------------------------------------------------------------- */
IF OBJECT_ID(N'[dbo].[FarmInviterPlay]') IS NULL OR OBJECT_ID(N'[dbo].[FarmInviteePlay]') IS NULL
BEGIN
    RAISERROR(N'DUNG: chua co bang theo doi FarmInviterPlay / FarmInviteePlay.', 16, 1);
    RETURN;
END;

DECLARE @sql NVARCHAR(MAX), @n INT;

-- 1. Tien do da duoc chuyen het chua (chi xet khi cot serverId con ton tai)
IF COL_LENGTH(N'dbo.FarmInviter', N'serverId') IS NOT NULL
BEGIN
    SET @sql = N'SELECT @n = COUNT(*) FROM [dbo].[FarmInviter] WHERE [serverId] <> 0';
    EXEC sp_executesql @sql, N'@n INT OUTPUT', @n = @n OUTPUT;
    IF @n > 0
    BEGIN
        RAISERROR(N'DUNG: kho Lv200 con %d dong mang tien do - chay chuyen-sang-bang-theo-doi.sql truoc.', 16, 1, @n);
        RETURN;
    END;
END;
IF COL_LENGTH(N'dbo.FarmInvitee', N'serverId') IS NOT NULL
BEGIN
    SET @sql = N'SELECT @n = COUNT(*) FROM [dbo].[FarmInvitee] WHERE [serverId] <> 0';
    EXEC sp_executesql @sql, N'@n INT OUTPUT', @n = @n OUTPUT;
    IF @n > 0
    BEGIN
        RAISERROR(N'DUNG: kho Lv50 con %d dong mang tien do - chay chuyen-sang-bang-theo-doi.sql truoc.', 16, 1, @n);
        RETURN;
    END;
END;

-- 2. Khong duoc trung email (sap tao khoa duy nhat tren email)
SELECT @n = COUNT(*) FROM (SELECT [email] FROM [dbo].[FarmInviter] GROUP BY [email] HAVING COUNT(*) > 1) x;
IF @n > 0 BEGIN RAISERROR(N'DUNG: kho Lv200 co %d email bi trung.', 16, 1, @n); RETURN; END;
SELECT @n = COUNT(*) FROM (SELECT [email] FROM [dbo].[FarmInvitee] GROUP BY [email] HAVING COUNT(*) > 1) x;
IF @n > 0 BEGIN RAISERROR(N'DUNG: kho Lv50 co %d email bi trung.', 16, 1, @n); RETURN; END;

PRINT N'=== Kiem tra an toan: DAT ===';

PRINT N'=== COT HIEN CO (truoc) ===';
SELECT t.name AS bang, COUNT(*) AS so_cot
FROM sys.columns c JOIN sys.tables t ON t.object_id = c.object_id
WHERE t.name IN (N'FarmInviter', N'FarmInvitee')
GROUP BY t.name;

BEGIN TRAN;

/* -------------------------------------------------------------------------
   BO TUNG COT: chi muc dung cot do -> rang buoc DEFAULT -> khoa ngoai -> cot
   ------------------------------------------------------------------------- */
DECLARE @bang SYSNAME, @cot SYSNAME, @ten SYSNAME, @daBo INT = 0;

DECLARE cotCur CURSOR LOCAL FAST_FORWARD FOR
    SELECT bang, cot FROM @bo
    WHERE COL_LENGTH(N'dbo.' + bang, cot) IS NOT NULL;
OPEN cotCur;
FETCH NEXT FROM cotCur INTO @bang, @cot;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- a) Chi muc co chua cot nay (tru khoa chinh)
    WHILE 1 = 1
    BEGIN
        SET @ten = NULL;
        SELECT TOP 1 @ten = i.name
        FROM sys.indexes i
        JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
        JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(N'dbo.' + @bang) AND c.name = @cot AND i.is_primary_key = 0;
        IF @ten IS NULL BREAK;
        SET @sql = N'DROP INDEX [' + @ten + N'] ON [dbo].[' + @bang + N']';
        EXEC sp_executesql @sql;
        PRINT N'  - bo chi muc ' + @ten;
    END;

    -- b) Rang buoc DEFAULT
    SET @ten = NULL;
    SELECT @ten = dc.name
    FROM sys.default_constraints dc
    JOIN sys.columns c ON c.object_id = dc.parent_object_id AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'dbo.' + @bang) AND c.name = @cot;
    IF @ten IS NOT NULL
    BEGIN
        SET @sql = N'ALTER TABLE [dbo].[' + @bang + N'] DROP CONSTRAINT [' + @ten + N']';
        EXEC sp_executesql @sql;
    END;

    -- c) Khoa ngoai (neu co)
    WHILE 1 = 1
    BEGIN
        SET @ten = NULL;
        SELECT TOP 1 @ten = fk.name
        FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
        JOIN sys.columns c ON c.object_id = fkc.parent_object_id AND c.column_id = fkc.parent_column_id
        WHERE fk.parent_object_id = OBJECT_ID(N'dbo.' + @bang) AND c.name = @cot;
        IF @ten IS NULL BREAK;
        SET @sql = N'ALTER TABLE [dbo].[' + @bang + N'] DROP CONSTRAINT [' + @ten + N']';
        EXEC sp_executesql @sql;
    END;

    -- d) Cot
    SET @sql = N'ALTER TABLE [dbo].[' + @bang + N'] DROP COLUMN [' + @cot + N']';
    EXEC sp_executesql @sql;
    SET @daBo = @daBo + 1;
    PRINT N'  - bo cot ' + @bang + N'.' + @cot;

    FETCH NEXT FROM cotCur INTO @bang, @cot;
END;
CLOSE cotCur;
DEALLOCATE cotCur;

PRINT CONCAT(N'=== Da bo ', @daBo, N' cot ===');

/* -------------------------------------------------------------------------
   CHI MUC MOI CHO KHO: khoa duy nhat theo email + tim theo STT
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'FarmInviter_email_key' AND object_id = OBJECT_ID(N'dbo.FarmInviter'))
    CREATE UNIQUE INDEX [FarmInviter_email_key] ON [dbo].[FarmInviter]([email]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'FarmInviter_stt_idx' AND object_id = OBJECT_ID(N'dbo.FarmInviter'))
    CREATE INDEX [FarmInviter_stt_idx] ON [dbo].[FarmInviter]([stt]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'FarmInviter_createdById_idx' AND object_id = OBJECT_ID(N'dbo.FarmInviter'))
    CREATE INDEX [FarmInviter_createdById_idx] ON [dbo].[FarmInviter]([createdById]);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'FarmInvitee_email_key' AND object_id = OBJECT_ID(N'dbo.FarmInvitee'))
    CREATE UNIQUE INDEX [FarmInvitee_email_key] ON [dbo].[FarmInvitee]([email]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'FarmInvitee_stt_idx' AND object_id = OBJECT_ID(N'dbo.FarmInvitee'))
    CREATE INDEX [FarmInvitee_stt_idx] ON [dbo].[FarmInvitee]([stt]);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'FarmInvitee_createdById_idx' AND object_id = OBJECT_ID(N'dbo.FarmInvitee'))
    CREATE INDEX [FarmInvitee_createdById_idx] ON [dbo].[FarmInvitee]([createdById]);

/* -------------------------------------------------------------------------
   KET QUA
   ------------------------------------------------------------------------- */
PRINT N'=== COT CON LAI (sau) ===';
SELECT t.name AS bang, c.column_id AS thu_tu, c.name AS cot, ty.name AS kieu
FROM sys.columns c
JOIN sys.tables t ON t.object_id = c.object_id
JOIN sys.types ty ON ty.user_type_id = c.user_type_id
WHERE t.name IN (N'FarmInviter', N'FarmInvitee')
ORDER BY t.name, c.column_id;

PRINT N'=== CHI MUC CON LAI ===';
SELECT t.name AS bang, i.name AS chi_muc, i.is_unique AS duy_nhat
FROM sys.indexes i JOIN sys.tables t ON t.object_id = i.object_id
WHERE t.name IN (N'FarmInviter', N'FarmInvitee') AND i.name IS NOT NULL
ORDER BY t.name, i.name;

SELECT N'FarmInviter' AS bang, COUNT(*) AS so_dong FROM [dbo].[FarmInviter]
UNION ALL
SELECT N'FarmInvitee', COUNT(*) FROM [dbo].[FarmInvitee];

IF @chayThat = 1
BEGIN
    COMMIT;
    PRINT N'>>> DA GHI THAT. Gio cap nhat code web + npx prisma generate + restart.';
END
ELSE
BEGIN
    ROLLBACK;
    PRINT N'>>> CHAY THU - DA ROLLBACK, DATABASE KHONG DOI. Doi @chayThat = 1 de ghi that.';
END;
