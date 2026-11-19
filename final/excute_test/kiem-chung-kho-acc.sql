/* =========================================================================
   FARM KC - KIEM CHUNG MO HINH LUU ACC THEO SERVER
   Muc dich: chung minh bang du lieu that 3 dieu:
     (1) Cung mot email chay o nhieu server = nhieu ban ghi rieng
     (2) Ban ghi kho (serverId = 0) KHONG BAO GIO duoc danh dau xong
     (3) Cung mot acc kho dang bi HAI cong viec khac nhau cung nhan
   Chay trong SSMS, doc ket qua tung phan.
   ========================================================================= */
SET NOCOUNT ON;

/* -------------------------------------------------------------------------
   PHAN 1 - Mot email cu the dang nam o nhung server nao
   ------------------------------------------------------------------------- */
PRINT '=== 1. accmuvhfang00045 dang co nhung ban ghi nao ===';
SELECT [stt], [email], [serverId], [serverName], [status], [inviteCode],
       [importBatch], [farmAccountId], [updatedAt]
FROM [dbo].[FarmInvitee]
WHERE [email] = 'accmuvhfang00045@gmail.com'
ORDER BY [serverId];

/* -------------------------------------------------------------------------
   PHAN 2 - Cac cong viec dang giao, kem so ban ghi THUC TE theo tung server
   Cot y nghia:
     tong_dai     = so luong STT trong dai (rangeTo - rangeFrom + 1)
     co_o_server  = so ban ghi da ton tai dung tren server cua cong viec
     con_o_kho    = so ban ghi moi chi co o kho chung (serverId = 0)
     da_xong      = so ban ghi tren server do da hoan thanh
   ------------------------------------------------------------------------- */
PRINT '=== 2. Doi chieu tung cong viec voi du lieu that ===';
SELECT
    a.[username],
    r.[jobCode],
    r.[farmLevel],
    r.[serverId],
    r.[rangeFrom],
    r.[rangeTo],
    (r.[rangeTo] - r.[rangeFrom] + 1) AS tong_dai,
    co_o_server = (
        SELECT COUNT(*) FROM [dbo].[FarmInvitee] t
        WHERE r.[farmLevel] = 50 AND t.[serverId] = r.[serverId]
          AND t.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
    ) + (
        SELECT COUNT(*) FROM [dbo].[FarmInviter] t
        WHERE r.[farmLevel] = 200 AND t.[serverId] = r.[serverId]
          AND t.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
    ),
    con_o_kho = (
        SELECT COUNT(*) FROM [dbo].[FarmInvitee] t
        WHERE r.[farmLevel] = 50 AND t.[serverId] = 0
          AND t.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
    ) + (
        SELECT COUNT(*) FROM [dbo].[FarmInviter] t
        WHERE r.[farmLevel] = 200 AND t.[serverId] = 0
          AND t.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
    ),
    da_xong = (
        SELECT COUNT(*) FROM [dbo].[FarmInvitee] t
        WHERE r.[farmLevel] = 50 AND t.[serverId] = r.[serverId]
          AND t.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
          AND t.[status] IN ('SUCCESS', 'ALREADY_USED')
    ) + (
        SELECT COUNT(*) FROM [dbo].[FarmInviter] t
        WHERE r.[farmLevel] = 200 AND t.[serverId] = r.[serverId]
          AND t.[stt] BETWEEN r.[rangeFrom] AND r.[rangeTo]
          AND t.[status] IN ('DONE', 'INVITED')
    )
FROM [dbo].[FarmAccountRange] r
JOIN [dbo].[FarmAccount] a ON a.[id] = r.[farmAccountId]
ORDER BY a.[username], r.[farmLevel], r.[serverId];

/* -------------------------------------------------------------------------
   PHAN 3 - BANG CHUNG LOI: ban ghi kho van NEW du da chay xong o server khac
   Neu phan nay tra ve dong nao thi dung nhu da noi: ban ghi serverId = 0
   khong bao gio duoc danh dau xong, nen se bi phat lai mai mai.
   ------------------------------------------------------------------------- */
PRINT '=== 3. Acc da chay xong o server that nhung ban kho van NEW (ACC 50) ===';
SELECT TOP (30)
    kho.[stt], kho.[email],
    kho.[status]  AS trang_thai_kho,
    dachay.[serverId] AS da_chay_o_server,
    dachay.[status]   AS trang_thai_that
FROM [dbo].[FarmInvitee] kho
JOIN [dbo].[FarmInvitee] dachay
     ON dachay.[email] = kho.[email] AND dachay.[serverId] <> 0
WHERE kho.[serverId] = 0
  AND dachay.[status] IN ('SUCCESS', 'ALREADY_USED')
ORDER BY kho.[stt];

PRINT '=== 3b. Tuong tu cho ACC 200 ===';
SELECT TOP (30)
    kho.[stt], kho.[email],
    kho.[status]  AS trang_thai_kho,
    dachay.[serverId] AS da_chay_o_server,
    dachay.[status]   AS trang_thai_that
FROM [dbo].[FarmInviter] kho
JOIN [dbo].[FarmInviter] dachay
     ON dachay.[email] = kho.[email] AND dachay.[serverId] <> 0
WHERE kho.[serverId] = 0
  AND dachay.[status] IN ('DONE', 'INVITED')
ORDER BY kho.[stt];

/* -------------------------------------------------------------------------
   PHAN 4 - BANG CHUNG TRANH CHAP: mot acc kho nam trong dai cua NHIEU cong viec
   Dai 1-100 Lv50 duoc giao cho ca longdt (S517) lan datnd (S518), nen cung
   mot ban ghi serverId = 0 se duoc phat cho ca hai may.
   ------------------------------------------------------------------------- */
PRINT '=== 4. Acc kho dang thuoc dai cua nhieu cong viec cung luc ===';
WITH kho50 AS (
    SELECT [stt], [email] FROM [dbo].[FarmInvitee] WHERE [serverId] = 0
),
viec50 AS (
    SELECT a.[username], r.[jobCode], r.[serverId], r.[rangeFrom], r.[rangeTo]
    FROM [dbo].[FarmAccountRange] r
    JOIN [dbo].[FarmAccount] a ON a.[id] = r.[farmAccountId]
    WHERE r.[farmLevel] = 50
)
SELECT TOP (30)
    k.[stt], k.[email],
    so_cong_viec = COUNT(*),
    danh_sach    = STRING_AGG(CONCAT(v.[username], '@S', v.[serverId], ' (', v.[jobCode], ')'), ' | ')
FROM kho50 k
JOIN viec50 v ON k.[stt] BETWEEN v.[rangeFrom] AND v.[rangeTo]
GROUP BY k.[stt], k.[email]
HAVING COUNT(*) > 1
ORDER BY k.[stt];

/* -------------------------------------------------------------------------
   PHAN 5 - Tong ket so ban ghi theo server, de nhin toan canh
   ------------------------------------------------------------------------- */
PRINT '=== 5. So ban ghi theo tung server ===';
SELECT 'FarmInviter' AS bang, [serverId],
       COUNT(*) AS so_dong,
       MIN([stt]) AS stt_min, MAX([stt]) AS stt_max
FROM [dbo].[FarmInviter] GROUP BY [serverId]
UNION ALL
SELECT 'FarmInvitee', [serverId], COUNT(*), MIN([stt]), MAX([stt])
FROM [dbo].[FarmInvitee] GROUP BY [serverId]
ORDER BY bang, [serverId];
