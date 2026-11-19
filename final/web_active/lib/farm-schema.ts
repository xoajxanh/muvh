// =========================================================================
// [MOD FEATURE]: FARM KC - MIGRATE BANG & STORED PROCEDURE
// Mô tả: Tạo bảng FarmInviter / FarmInvitee và stored procedure
//        sp_FarmClaimInviteCode (giữ chỗ lease chống vượt 5 lượt mời).
//        Idempotent - chạy lại nhiều lần không mất dữ liệu.
// =========================================================================

export const FARM_KC_TABLES_SQL = `
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmInviter')
BEGIN
    CREATE TABLE [dbo].[FarmInviter] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
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
        [status] NVARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
        [failCount] INT NOT NULL DEFAULT 0,
        [lastError] NVARCHAR(1000) NULL,
        [lastSyncAt] DATETIME2 NULL,
        [createdById] NVARCHAR(100) NOT NULL,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmInviter_email_serverId_key] ON [dbo].[FarmInviter]([email], [serverId]);
    CREATE INDEX [FarmInviter_serverId_status_idx] ON [dbo].[FarmInviter]([serverId], [status]);
    CREATE INDEX [FarmInviter_createdById_idx] ON [dbo].[FarmInviter]([createdById]);
END;

-- Them cot moi cho DB da tao tu truoc (idempotent)
IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'goldVoucher'
)
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [goldVoucher] BIGINT NOT NULL DEFAULT 0;
END;

IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'packBought'
)
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [packBought] INT NOT NULL DEFAULT 0;
END;

-- Chuyen du lieu cu sang bo trang thai moi (chay mot lan, idempotent):
--   COMPLETE cu = du 5 nguoi moi nhung CHUA chac da mua kim cuong
--   -> packBought = 0 thi la INVITED, > 0 thi la DONE
UPDATE [dbo].[FarmInviter]
SET [status] = CASE WHEN [packBought] > 0 THEN 'DONE' ELSE 'INVITED' END
WHERE [status] = 'COMPLETE';

-- Acc chua co ma moi -> NEW (khong dung NO_CODE vi ten do danh cho bang ACC 50)
UPDATE [dbo].[FarmInviter]
SET [status] = 'NEW'
WHERE [status] = 'ACTIVE' AND ([inviteCode] IS NULL OR [inviteCode] = '');

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FarmInvitee')
BEGIN
    CREATE TABLE [dbo].[FarmInvitee] (
        [id] NVARCHAR(100) NOT NULL PRIMARY KEY,
        [email] NVARCHAR(255) NOT NULL,
        [password] NVARCHAR(255) NOT NULL DEFAULT '',
        [serverId] INT NOT NULL,
        [serverName] NVARCHAR(255) NOT NULL DEFAULT '',
        [roleId] NVARCHAR(50) NOT NULL DEFAULT '',
        [roleName] NVARCHAR(255) NOT NULL DEFAULT '',
        [level] INT NOT NULL DEFAULT 0,
        [inviterId] NVARCHAR(100) NULL,
        [inviteCode] NVARCHAR(50) NULL,
        [status] NVARCHAR(20) NOT NULL DEFAULT 'RESERVED',
        [deviceId] NVARCHAR(255) NULL,
        [reservedAt] DATETIME2 NULL,
        [expireAt] DATETIME2 NULL,
        [confirmedAt] DATETIME2 NULL,
        [errorMsg] NVARCHAR(1000) NULL,
        [createdById] NVARCHAR(100) NOT NULL,
        [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
        [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE UNIQUE INDEX [FarmInvitee_email_serverId_key] ON [dbo].[FarmInvitee]([email], [serverId]);
    CREATE INDEX [FarmInvitee_serverId_status_idx] ON [dbo].[FarmInvitee]([serverId], [status]);
    CREATE INDEX [FarmInvitee_inviterId_idx] ON [dbo].[FarmInvitee]([inviterId]);
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
    -- Moi tai khoan chi 1 viec cho moi cap (server, level)
    CREATE UNIQUE INDEX [FarmAccountRange_acc_level_server_key] ON [dbo].[FarmAccountRange]([farmAccountId], [farmLevel], [serverId]);
    CREATE INDEX [FarmAccountRange_level_server_idx] ON [dbo].[FarmAccountRange]([farmLevel], [serverId]);
END;

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
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'farmAccountId')
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [farmAccountId] NVARCHAR(100) NULL;
    CREATE INDEX [FarmInviter_farmAccountId_idx] ON [dbo].[FarmInviter]([farmAccountId]);
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
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInvitee]') AND name = 'farmAccountId')
BEGIN
    ALTER TABLE [dbo].[FarmInvitee] ADD [farmAccountId] NVARCHAR(100) NULL;
    CREATE INDEX [FarmInvitee_farmAccountId_idx] ON [dbo].[FarmInvitee]([farmAccountId]);
END;

-- Acc import chua chay thi de trang thai goc
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInvitee]') AND name = 'importBatch')
BEGIN
    ALTER TABLE [dbo].[FarmInvitee] ADD [importBatch] NVARCHAR(100) NOT NULL DEFAULT '';
END;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[FarmInviter]') AND name = 'importBatch')
BEGIN
    ALTER TABLE [dbo].[FarmInviter] ADD [importBatch] NVARCHAR(100) NOT NULL DEFAULT '';
END;
`;

// -------------------------------------------------------------------------
// SP giữ chỗ (lease): chọn 1 acc Lv200 cùng server còn suất, tăng reservedCount
// NGUYÊN TỬ trong 1 câu UPDATE, rồi ghi dòng FarmInvitee trạng thái RESERVED.
// Thứ tự ưu tiên: DỒN ĐỦ 5 cho từng acc trước (used+reserved DESC).
// resultCode: OK | ALREADY_DONE | NO_CODE
// -------------------------------------------------------------------------
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
    @leaseMinutes  INT = 10
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
    FROM [dbo].[FarmInvitee] V WITH (ROWLOCK, READPAST)
    WHERE V.[status] = 'RESERVED' AND V.[expireAt] IS NOT NULL AND V.[expireAt] < @now;

    UPDATE I
       SET I.[reservedCount] = CASE WHEN I.[reservedCount] - E.Cnt < 0 THEN 0 ELSE I.[reservedCount] - E.Cnt END,
           I.[updatedAt] = @now
    FROM [dbo].[FarmInviter] I
    JOIN (SELECT inviterId, COUNT(*) AS Cnt FROM @expired WHERE inviterId IS NOT NULL GROUP BY inviterId) E
      ON E.inviterId = I.[id];

    -- 1. Nếu acc Lv50 này đã có bản ghi -> xử lý idempotent
    DECLARE @exId NVARCHAR(100), @exStatus NVARCHAR(20), @exCode NVARCHAR(50),
            @exInviterId NVARCHAR(100), @exExpire DATETIME2;
    SELECT TOP 1 @exId = [id], @exStatus = [status], @exCode = [inviteCode],
                 @exInviterId = [inviterId], @exExpire = [expireAt]
    FROM [dbo].[FarmInvitee] WITH (UPDLOCK, ROWLOCK)
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
        FROM [dbo].[FarmInviter] I WITH (UPDLOCK, ROWLOCK)
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
            UPDATE [dbo].[FarmInvitee]
               SET [status] = 'NO_CODE', [inviterId] = NULL, [inviteCode] = NULL,
                   [expireAt] = NULL, [deviceId] = @deviceId, [level] = @level,
                   [roleId] = @roleId, [roleName] = @roleName, [serverName] = @serverName,
                   [updatedAt] = @now
             WHERE [id] = @exId;
        ELSE
            INSERT [dbo].[FarmInvitee] ([id],[email],[password],[serverId],[serverName],[roleId],[roleName],
                   [level],[status],[deviceId],[createdById],[createdAt],[updatedAt])
            VALUES (@newInviteeId, @email, @password, @serverId, @serverName, @roleId, @roleName,
                   @level, 'NO_CODE', @deviceId, @createdById, @now, @now);

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
        UPDATE [dbo].[FarmInvitee]
           SET [inviterId] = @pickId, [inviteCode] = @pickCode, [status] = 'RESERVED',
               [deviceId] = @deviceId, [reservedAt] = @now, [expireAt] = @expireAt,
               [errorMsg] = NULL, [level] = @level, [roleId] = @roleId, [roleName] = @roleName,
               [serverName] = @serverName, [password] = @password, [updatedAt] = @now
         WHERE [id] = @exId;
    END
    ELSE
    BEGIN
        SET @exId = @newInviteeId;
        INSERT [dbo].[FarmInvitee] ([id],[email],[password],[serverId],[serverName],[roleId],[roleName],
               [level],[inviterId],[inviteCode],[status],[deviceId],[reservedAt],[expireAt],
               [createdById],[createdAt],[updatedAt])
        VALUES (@exId, @email, @password, @serverId, @serverName, @roleId, @roleName,
               @level, @pickId, @pickCode, 'RESERVED', @deviceId, @now, @expireAt,
               @createdById, @now, @now);
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
