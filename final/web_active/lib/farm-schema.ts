// =========================================================================
// [MOD FEATURE]: FARM KC - MIGRATE BANG & STORED PROCEDURE
// Mô tả: Tạo bảng FarmInviter / FarmInvitee và stored procedure
//        sp_FarmClaimInviteCode (giữ chỗ lease chống vượt 5 lượt mời).
//        Idempotent - chạy lại nhiều lần không mất dữ liệu.
// =========================================================================

export const FARM_KC_TABLES_SQL = `
-- =====================================================================
-- [MOD FEATURE]: FARM KC - KHO MAC DINH (CHI DE DOI CHIEU)
-- Mo ta: Moi acc game mot dong, chi giu thong tin dinh danh lay tu file
--        dang ky (email / mat khau / STT / UID / IP / thoi diem dang ky).
--        TIEN DO CHOI tren tung server nam o FarmInviterPlay / FarmInviteePlay.
--        Da bo 19 cot tien do o FarmInviter va 14 cot o FarmInvitee.
-- =====================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmInviter')
BEGIN
    CREATE TABLE [dbo].[FarmInviter] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
        [email] NVARCHAR(255) NOT NULL,
        [password] NVARCHAR(255) NOT NULL DEFAULT '',
        [stt] INT NOT NULL DEFAULT 0,
        [uid] NVARCHAR(50) NOT NULL DEFAULT '',
        [regIp] NVARCHAR(50) NOT NULL DEFAULT '',
        [regAt] DATETIME2 NULL,
        [importBatch] NVARCHAR(100) NOT NULL DEFAULT '',
        [createdById] NVARCHAR(100) NOT NULL,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmInviter_email_key] ON [dbo].[FarmInviter]([email]);
    CREATE INDEX [FarmInviter_stt_idx] ON [dbo].[FarmInviter]([stt]);
    CREATE INDEX [FarmInviter_createdById_idx] ON [dbo].[FarmInviter]([createdById]);
END;

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmInvitee')
BEGIN
    CREATE TABLE [dbo].[FarmInvitee] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
        [email] NVARCHAR(255) NOT NULL,
        [password] NVARCHAR(255) NOT NULL DEFAULT '',
        [stt] INT NOT NULL DEFAULT 0,
        [uid] NVARCHAR(50) NOT NULL DEFAULT '',
        [regIp] NVARCHAR(50) NOT NULL DEFAULT '',
        [regAt] DATETIME2 NULL,
        [importBatch] NVARCHAR(100) NOT NULL DEFAULT '',
        [createdById] NVARCHAR(100) NOT NULL,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmInvitee_email_key] ON [dbo].[FarmInvitee]([email]);
    CREATE INDEX [FarmInvitee_stt_idx] ON [dbo].[FarmInvitee]([stt]);
    CREATE INDEX [FarmInvitee_createdById_idx] ON [dbo].[FarmInvitee]([createdById]);
END;

-- =====================================================================
-- [MOD FEATURE]: FARM KC - TAI KHOAN CHAY BOT
-- Mo ta: FarmAccount chi giu thong tin tai khoan (username / mat khau).
--        MOI DONG CONG VIEC nam o bang FarmAccountRange: level + server +
--        khoang STT. Mot tai khoan co the co nhieu dong -> cay nhieu level
--        tren nhieu server cung luc (chay nhieu gia lap).
-- =====================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmAccount')
BEGIN
    CREATE TABLE [dbo].[FarmAccount] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
        [username] NVARCHAR(100) NOT NULL,
        [password] NVARCHAR(255) NOT NULL DEFAULT '',
        [note] NVARCHAR(1000) NULL,
        [status] NVARCHAR(20) NOT NULL DEFAULT 'NEW',
        [lastSyncAt] DATETIME2 NULL,
        [createdById] NVARCHAR(100) NOT NULL,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmAccount_username_key] ON [dbo].[FarmAccount]([username]);
    CREATE INDEX [FarmAccount_createdById_idx] ON [dbo].[FarmAccount]([createdById]);
END;

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmAccountRange')
BEGIN
    CREATE TABLE [dbo].[FarmAccountRange] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
        [farmAccountId] NVARCHAR(100) NOT NULL,
        [jobCode] NVARCHAR(60) NOT NULL,
        [farmLevel] INT NOT NULL,
        [serverId] INT NOT NULL DEFAULT 0,
        [serverName] NVARCHAR(255) NOT NULL DEFAULT '',
        [rangeFrom] INT NOT NULL DEFAULT 0,
        [rangeTo] INT NOT NULL DEFAULT 0,
        [status] NVARCHAR(20) NOT NULL DEFAULT 'NEW',
        -- Khoa thiet bi: gia lap nao dang giu viec nay
        [deviceId] NVARCHAR(255) NULL,
        [deviceName] NVARCHAR(255) NULL,
        [lastHeartbeat] DATETIME2 NULL,
        [cursorStt] INT NOT NULL DEFAULT 0,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmAccountRange_jobCode_key] ON [dbo].[FarmAccountRange]([jobCode]);
    CREATE INDEX [FarmAccountRange_acc_idx] ON [dbo].[FarmAccountRange]([farmAccountId]);
    CREATE INDEX [FarmAccountRange_level_server_idx] ON [dbo].[FarmAccountRange]([farmLevel], [serverId]);
END;

-- [MOD FEATURE]: Mot tai khoan duoc NHIEU viec cung server + level (khac dai STT)
-- -> bo khoa duy nhat (tai khoan, level, server) cua ban cu, thay bang chi muc thuong.
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'FarmAccountRange_acc_level_server_key' AND object_id = OBJECT_ID(N'[dbo].[FarmAccountRange]'))
BEGIN
    DROP INDEX [FarmAccountRange_acc_level_server_key] ON [dbo].[FarmAccountRange];
END;
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'FarmAccountRange_acc_idx' AND object_id = OBJECT_ID(N'[dbo].[FarmAccountRange]'))
   AND EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmAccountRange')
BEGIN
    CREATE INDEX [FarmAccountRange_acc_idx] ON [dbo].[FarmAccountRange]([farmAccountId]);
END;

-- Cot dinh danh cho kho tao tu ban cu (idempotent; ban moi da co san)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'stt')
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [stt] INT NOT NULL DEFAULT 0;
END;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'uid')
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [uid] NVARCHAR(50) NOT NULL DEFAULT '';
END;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'regIp')
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [regIp] NVARCHAR(50) NOT NULL DEFAULT '';
END;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'regAt')
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [regAt] DATETIME2 NULL;
END;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInvitee]') AND name = 'stt')
BEGIN
    ALTER TABLE [dbo].[FarmInvitee] ADD [stt] INT NOT NULL DEFAULT 0;
END;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInvitee]') AND name = 'uid')
BEGIN
    ALTER TABLE [dbo].[FarmInvitee] ADD [uid] NVARCHAR(50) NOT NULL DEFAULT '';
END;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInvitee]') AND name = 'regIp')
BEGIN
    ALTER TABLE [dbo].[FarmInvitee] ADD [regIp] NVARCHAR(50) NOT NULL DEFAULT '';
END;
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInvitee]') AND name = 'regAt')
BEGIN
    ALTER TABLE [dbo].[FarmInvitee] ADD [regAt] DATETIME2 NULL;
END;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInvitee]') AND name = 'importBatch')
BEGIN
    ALTER TABLE [dbo].[FarmInvitee] ADD [importBatch] NVARCHAR(100) NOT NULL DEFAULT '';
END;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'importBatch')
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [importBatch] NVARCHAR(100) NOT NULL DEFAULT '';
END;

-- =====================================================================
-- [MOD FEATURE]: FARM KC - BANG THEO DOI ACC GAME x SERVER x NGUOI CHOI
-- Mo ta: FarmInviter / FarmInvitee la KHO MAC DINH (chi de doi chieu,
--        KHONG ghi tien do vao do nua). Moi lan mot acc game duoc choi tren
--        mot server thi tien do nam o 2 bang duoi day:
--          FarmInviterPlay : acc Lv200 @ server (ma moi, so nguoi da moi...)
--          FarmInviteePlay : acc Lv50  @ server (ma da nhap, moi boi ai...)
--        Cung mot acc game choi o S517 (longdt) va S518 (datnd) = 2 dong.
--        masterId   -> dong goc trong kho mac dinh
--        farmAccountId / jobCode -> nguoi choi + cong viec duoc giao
-- =====================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmInviterPlay')
BEGIN
    CREATE TABLE [dbo].[FarmInviterPlay] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
        [masterId] NVARCHAR(100) NULL,
        [stt] INT NOT NULL DEFAULT 0,
        [email] NVARCHAR(255) NOT NULL,
        [password] NVARCHAR(255) NOT NULL DEFAULT '',
        [serverId] INT NOT NULL,
        [serverName] NVARCHAR(255) NOT NULL DEFAULT '',
        [roleId] NVARCHAR(50) NOT NULL DEFAULT '',
        [roleName] NVARCHAR(255) NOT NULL DEFAULT '',
        [level] INT NOT NULL DEFAULT 0,
        [inviteCode] NVARCHAR(50) NULL,
        [gameInviteNum] INT NOT NULL DEFAULT 0,
        [confirmedCount] INT NOT NULL DEFAULT 0,
        [reservedCount] INT NOT NULL DEFAULT 0,
        [maxInvites] INT NOT NULL DEFAULT 5,
        [unboundGold] BIGINT NOT NULL DEFAULT 0,
        [unboundDiamond] BIGINT NOT NULL DEFAULT 0,
        [goldVoucher] BIGINT NOT NULL DEFAULT 0,
        [packBought] INT NOT NULL DEFAULT 0,
        [status] NVARCHAR(20) NOT NULL DEFAULT 'NEW',
        [failCount] INT NOT NULL DEFAULT 0,
        [lastError] NVARCHAR(1000) NULL,
        [lastSyncAt] DATETIME2 NULL,
        [farmAccountId] NVARCHAR(100) NULL,
        [jobCode] NVARCHAR(60) NULL,
        [createdById] NVARCHAR(100) NOT NULL,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmInviterPlay_email_serverId_key] ON [dbo].[FarmInviterPlay]([email], [serverId]);
    CREATE INDEX [FarmInviterPlay_serverId_status_idx] ON [dbo].[FarmInviterPlay]([serverId], [status]);
    CREATE INDEX [FarmInviterPlay_masterId_idx] ON [dbo].[FarmInviterPlay]([masterId]);
    CREATE INDEX [FarmInviterPlay_farmAccountId_idx] ON [dbo].[FarmInviterPlay]([farmAccountId]);
    CREATE INDEX [FarmInviterPlay_createdById_idx] ON [dbo].[FarmInviterPlay]([createdById]);
END;

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmInviteePlay')
BEGIN
    CREATE TABLE [dbo].[FarmInviteePlay] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
        [masterId] NVARCHAR(100) NULL,
        [stt] INT NOT NULL DEFAULT 0,
        [email] NVARCHAR(255) NOT NULL,
        [password] NVARCHAR(255) NOT NULL DEFAULT '',
        [serverId] INT NOT NULL,
        [serverName] NVARCHAR(255) NOT NULL DEFAULT '',
        [roleId] NVARCHAR(50) NOT NULL DEFAULT '',
        [roleName] NVARCHAR(255) NOT NULL DEFAULT '',
        [level] INT NOT NULL DEFAULT 0,
        -- Moi boi acc Lv200 nao (dong trong FarmInviterPlay, CUNG server)
        [inviterId] NVARCHAR(100) NULL,
        [inviteCode] NVARCHAR(50) NULL,
        [status] NVARCHAR(20) NOT NULL DEFAULT 'NEW',
        [deviceId] NVARCHAR(255) NULL,
        [reservedAt] DATETIME2 NULL,
        [expireAt] DATETIME2 NULL,
        [confirmedAt] DATETIME2 NULL,
        [errorMsg] NVARCHAR(1000) NULL,
        [farmAccountId] NVARCHAR(100) NULL,
        [jobCode] NVARCHAR(60) NULL,
        [createdById] NVARCHAR(100) NOT NULL,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmInviteePlay_email_serverId_key] ON [dbo].[FarmInviteePlay]([email], [serverId]);
    CREATE INDEX [FarmInviteePlay_serverId_status_idx] ON [dbo].[FarmInviteePlay]([serverId], [status]);
    CREATE INDEX [FarmInviteePlay_masterId_idx] ON [dbo].[FarmInviteePlay]([masterId]);
    CREATE INDEX [FarmInviteePlay_inviterId_idx] ON [dbo].[FarmInviteePlay]([inviterId]);
    CREATE INDEX [FarmInviteePlay_farmAccountId_idx] ON [dbo].[FarmInviteePlay]([farmAccountId]);
    CREATE INDEX [FarmInviteePlay_createdById_idx] ON [dbo].[FarmInviteePlay]([createdById]);
END;
`;

// -------------------------------------------------------------------------
// SP giữ chỗ (lease): chọn 1 acc Lv200 cùng server còn suất, tăng reservedCount
// NGUYÊN TỬ trong 1 câu UPDATE, rồi ghi dòng FarmInvitee trạng thái RESERVED.
// Thứ tự ưu tiên: DỒN ĐỦ 5 cho từng acc trước (used+reserved DESC).
// resultCode: OK | ALREADY_DONE | NO_CODE
// -------------------------------------------------------------------------
// [MOD FEATURE]: SP gio doc/ghi BANG THEO DOI (FarmInviterPlay / FarmInviteePlay),
// KHONG dung vao kho mac dinh FarmInviter / FarmInvitee nua.
const FARM_KC_CLAIM_SP_BODY = `
ALTER PROCEDURE [dbo].[sp_FarmClaimInviteCode]
    @email         NVARCHAR(255),
    @password      NVARCHAR(255) = '',
    @serverId      INT,
    @serverName    NVARCHAR(255) = '',
    @roleId        NVARCHAR(50)  = '',
    @roleName      NVARCHAR(255) = '',
    @level         INT = 0,
    @deviceId      NVARCHAR(255) = NULL,
    @createdById   NVARCHAR(100),
    @newInviteeId  NVARCHAR(100),
    @leaseMinutes  INT = 10,
    -- [MOD FEATURE]: dong goc trong kho + nguoi choi/cong viec giu acc nay
    @masterId      NVARCHAR(100) = NULL,
    @stt           INT = 0,
    @farmAccountId NVARCHAR(100) = NULL,
    @jobCode       NVARCHAR(60)  = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    -- Cho doi khoa toi da 5s roi bao loi, tranh treo vo han khi nhieu may
    -- cung xin ma cua CUNG MOT acc Lv200 (chien luoc DESC - don du 5).
    SET LOCK_TIMEOUT 5000;

    DECLARE @now DATETIME2 = SYSUTCDATETIME();

    BEGIN TRAN;

    -- 0. Trả suất cho các lease quá hạn.
    --    Van giu READPAST o day: dong nao dang bi khoa thi de lan goi sau don,
    --    khong anh huong den tinh dung dan cua viec cap ma.
    DECLARE @expired TABLE (inviterId NVARCHAR(100));
    UPDATE V SET V.[status] = 'EXPIRED', V.[updatedAt] = @now
    OUTPUT DELETED.[inviterId] INTO @expired
    FROM [dbo].[FarmInviteePlay] V WITH (ROWLOCK, READPAST)
    WHERE V.[status] = 'RESERVED' AND V.[expireAt] IS NOT NULL AND V.[expireAt] < @now;

    UPDATE I
       SET I.[reservedCount] = CASE WHEN I.[reservedCount] - E.Cnt < 0 THEN 0 ELSE I.[reservedCount] - E.Cnt END,
           I.[updatedAt] = @now
    FROM [dbo].[FarmInviterPlay] I
    JOIN (SELECT inviterId, COUNT(*) AS Cnt FROM @expired WHERE inviterId IS NOT NULL GROUP BY inviterId) E
      ON E.inviterId = I.[id];

    -- 1. Nếu acc Lv50 này đã có bản ghi -> xử lý idempotent
    DECLARE @exId NVARCHAR(100), @exStatus NVARCHAR(20), @exCode NVARCHAR(50),
            @exInviterId NVARCHAR(100), @exExpire DATETIME2;
    SELECT TOP 1 @exId = [id], @exStatus = [status], @exCode = [inviteCode],
                 @exInviterId = [inviterId], @exExpire = [expireAt]
    FROM [dbo].[FarmInviteePlay] WITH (UPDLOCK, ROWLOCK)
    WHERE [email] = @email AND [serverId] = @serverId;

    IF @exId IS NOT NULL AND @exStatus IN ('SUCCESS', 'ALREADY_USED')
    BEGIN
        COMMIT;
        SELECT 'ALREADY_DONE' AS resultCode, @exId AS inviteeId, @exCode AS inviteCode,
               @exInviterId AS inviterId, @exStatus AS existingStatus;
        RETURN;
    END

    IF @exId IS NOT NULL AND @exStatus = 'RESERVED' AND @exExpire IS NOT NULL AND @exExpire >= @now
    BEGIN
        -- Lease cũ còn hạn -> trả lại đúng mã cũ, KHÔNG giữ chỗ lần 2
        COMMIT;
        SELECT 'OK' AS resultCode, @exId AS inviteeId, @exCode AS inviteCode,
               @exInviterId AS inviterId, @exStatus AS existingStatus;
        RETURN;
    END

    -- 2. Chọn 1 acc Lv200 còn suất + tăng reservedCount trong CÙNG 1 câu lệnh
    DECLARE @picked TABLE (id NVARCHAR(100), inviteCode NVARCHAR(50));
    ;WITH pick AS (
        SELECT TOP (1) I.*
        FROM [dbo].[FarmInviterPlay] I WITH (UPDLOCK, ROWLOCK)
        WHERE I.[serverId] = @serverId
          AND I.[status] = 'ACTIVE'   -- chi acc dang gom nguoi moi moi duoc cap ma
          AND I.[inviteCode] IS NOT NULL AND I.[inviteCode] <> ''
          -- So luot da dung = gameInviteNum (moc that luc acc Lv200 dang nhap lan cuoi)
          --                   + confirmedCount (so web cap THEM sau moc do)
          -- KHONG dung MAX: hai con so do hai thu khac nhau, lay MAX se cap vuot suat.
          AND (I.[gameInviteNum] + I.[confirmedCount] + I.[reservedCount]) < I.[maxInvites]
        ORDER BY (I.[gameInviteNum] + I.[confirmedCount] + I.[reservedCount]) DESC, I.[createdAt] ASC
    )
    UPDATE pick
       SET [reservedCount] = [reservedCount] + 1, [updatedAt] = @now
    OUTPUT INSERTED.[id], INSERTED.[inviteCode] INTO @picked;

    IF NOT EXISTS (SELECT 1 FROM @picked)
    BEGIN
        -- Không còn mã cùng server -> ghi nhận NO_CODE
        IF @exId IS NOT NULL
            UPDATE [dbo].[FarmInviteePlay]
               SET [status] = 'NO_CODE', [inviterId] = NULL, [inviteCode] = NULL,
                   [expireAt] = NULL, [deviceId] = @deviceId, [level] = @level,
                   [roleId] = @roleId, [roleName] = @roleName, [serverName] = @serverName,
                   [masterId] = ISNULL([masterId], @masterId),
                   [stt] = CASE WHEN [stt] > 0 THEN [stt] ELSE @stt END,
                   [farmAccountId] = ISNULL(@farmAccountId, [farmAccountId]),
                   [jobCode] = ISNULL(@jobCode, [jobCode]),
                   [updatedAt] = @now
             WHERE [id] = @exId;
        ELSE
            INSERT [dbo].[FarmInviteePlay] ([id],[masterId],[stt],[email],[password],[serverId],[serverName],[roleId],[roleName],
                   [level],[status],[deviceId],[farmAccountId],[jobCode],[createdById],[createdAt],[updatedAt])
            VALUES (@newInviteeId, @masterId, @stt, @email, @password, @serverId, @serverName, @roleId, @roleName,
                   @level, 'NO_CODE', @deviceId, @farmAccountId, @jobCode, @createdById, @now, @now);

        COMMIT;
        SELECT 'NO_CODE' AS resultCode, NULL AS inviteeId, NULL AS inviteCode,
               NULL AS inviterId, NULL AS existingStatus;
        RETURN;
    END

    DECLARE @pickId NVARCHAR(100), @pickCode NVARCHAR(50);
    SELECT TOP 1 @pickId = id, @pickCode = inviteCode FROM @picked;
    DECLARE @expireAt DATETIME2 = DATEADD(MINUTE, @leaseMinutes, @now);

    -- 3. Ghi lease cho acc Lv50 (upsert theo email + serverId)
    IF @exId IS NOT NULL
    BEGIN
        UPDATE [dbo].[FarmInviteePlay]
           SET [inviterId] = @pickId, [inviteCode] = @pickCode, [status] = 'RESERVED',
               [deviceId] = @deviceId, [reservedAt] = @now, [expireAt] = @expireAt,
               [errorMsg] = NULL, [level] = @level, [roleId] = @roleId, [roleName] = @roleName,
               [serverName] = @serverName, [password] = @password,
               [masterId] = ISNULL([masterId], @masterId),
               [stt] = CASE WHEN [stt] > 0 THEN [stt] ELSE @stt END,
               [farmAccountId] = ISNULL(@farmAccountId, [farmAccountId]),
               [jobCode] = ISNULL(@jobCode, [jobCode]),
               [updatedAt] = @now
         WHERE [id] = @exId;
    END
    ELSE
    BEGIN
        SET @exId = @newInviteeId;
        INSERT [dbo].[FarmInviteePlay] ([id],[masterId],[stt],[email],[password],[serverId],[serverName],[roleId],[roleName],
               [level],[inviterId],[inviteCode],[status],[deviceId],[reservedAt],[expireAt],
               [farmAccountId],[jobCode],[createdById],[createdAt],[updatedAt])
        VALUES (@exId, @masterId, @stt, @email, @password, @serverId, @serverName, @roleId, @roleName,
               @level, @pickId, @pickCode, 'RESERVED', @deviceId, @now, @expireAt,
               @farmAccountId, @jobCode, @createdById, @now, @now);
    END

    COMMIT;
    SELECT 'OK' AS resultCode, @exId AS inviteeId, @pickCode AS inviteCode,
           @pickId AS inviterId, NULL AS existingStatus;
END
`;

// -------------------------------------------------------------------------
// SQL Server < 2016 SP1 không có "CREATE OR ALTER", và CREATE PROCEDURE bắt
// buộc là câu lệnh đầu tiên của batch. Vì vậy: tạo stub nếu chưa có, rồi
// ALTER qua sp_executesql (thân SP thành một batch riêng).
// Lưu ý: literal NVARCHAR trong SQL Server tối đa 4000 ký tự, mà thân SP dài
// hơn thế -> phải cắt thành nhiều đoạn (theo dòng) rồi nối vào NVARCHAR(MAX).
// -------------------------------------------------------------------------
// KHÔNG dùng DROP + CREATE: giữa 2 lệnh đó stored procedure biến mất, request
// nào rơi đúng khoảnh khắc ấy sẽ lỗi 2812. Thay vào đó: tạo stub rỗng nếu chưa
// có, rồi ALTER thân thật -> stored procedure LUÔN tồn tại, an toàn khi nhiều
// request chạy song song.
export const FARM_KC_SP_STUB_SQL = `
IF OBJECT_ID(N'[dbo].[sp_FarmClaimInviteCode]', N'P') IS NULL
    EXEC(N'CREATE PROCEDURE [dbo].[sp_FarmClaimInviteCode] AS SET NOCOUNT ON;');
`;

function buildExecSqlScript(body: string, chunkSize = 2500): string {
  const lines = body.split('\n');
  const chunks: string[] = [];
  let cur = '';
  for (const line of lines) {
    const piece = line + '\n';
    // escape nháy đơn THEO TỪNG DÒNG để không bao giờ cắt đôi cặp ''
    if (cur.length + piece.length > chunkSize && cur !== '') {
      chunks.push(cur);
      cur = '';
    }
    cur += piece;
  }
  if (cur !== '') chunks.push(cur);

  const stmts = chunks.map((c, i) => {
    const esc = c.replace(/'/g, "''");
    return i === 0 ? `SET @sql = N'${esc}';` : `SET @sql = @sql + N'${esc}';`;
  });

  return [
    'DECLARE @sql NVARCHAR(MAX);',
    ...stmts,
    'EXEC sp_executesql @sql;',
  ].join('\n');
}

export const FARM_KC_CLAIM_SP_SQL = buildExecSqlScript(FARM_KC_CLAIM_SP_BODY);
