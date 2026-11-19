/* =========================================================================
   [MOD FEATURE]: FARM KC - VA STT CHO CAC BAN GHI CU TU LUA
   Mo ta: Cac acc do mod ghi thang vao DB qua API claim/result khong co so thu
          tu (stt = 0), nen khong chia duoc vao khoang cong viec.
          Script nay lay DAY SO O CUOI phan truoc dau @ cua email lam stt:
              accmuvhfang00045@gmail.com -> 45
              accvutmuvh0441@gmail.com   -> 441
          Chi dong vao ban ghi dang co stt <= 0. Chay lai nhieu lan vo hai.

   Cach dung: chay tung buoc trong SSMS / Azure Data Studio, hoac
              sqlcmd -S <server> -d <database> -i fix-stt.sql
   ========================================================================= */

SET NOCOUNT ON;

/* -------------------------------------------------------------------------
   BUOC 0 - Ham phu: lay day so o cuoi phan local cua email
   Khong tao function, dung thang bieu thuc qua CROSS APPLY cho de doc.
   ------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------
   BUOC 1 - XEM TRUOC (khong sua gi)
   Doi chieu email -> stt se duoc gan, truoc khi chay UPDATE.
   ------------------------------------------------------------------------- */
PRINT '=== XEM TRUOC: FarmInviter (ACC LV200) ===';
SELECT TOP (50)
    t.[email],
    t.[stt]        AS stt_hien_tai,
    d.[sttMoi]     AS stt_se_gan,
    t.[serverId],
    t.[status]
FROM [dbo].[FarmInviter] AS t
CROSS APPLY (SELECT LEFT(t.[email], NULLIF(CHARINDEX('@', t.[email]), 0) - 1) AS phanTruocA) AS a
CROSS APPLY (SELECT REVERSE(a.phanTruocA) AS nguoc) AS b
CROSS APPLY (
    SELECT TRY_CAST(
        REVERSE(LEFT(b.nguoc, PATINDEX('%[^0-9]%', b.nguoc + 'x') - 1)) AS INT
    ) AS sttMoi
) AS d
WHERE ISNULL(t.[stt], 0) <= 0
  AND d.[sttMoi] IS NOT NULL
ORDER BY d.[sttMoi];

PRINT '=== XEM TRUOC: FarmInvitee (ACC LV50) ===';
SELECT TOP (50)
    t.[email],
    t.[stt]        AS stt_hien_tai,
    d.[sttMoi]     AS stt_se_gan,
    t.[serverId],
    t.[status]
FROM [dbo].[FarmInvitee] AS t
CROSS APPLY (SELECT LEFT(t.[email], NULLIF(CHARINDEX('@', t.[email]), 0) - 1) AS phanTruocA) AS a
CROSS APPLY (SELECT REVERSE(a.phanTruocA) AS nguoc) AS b
CROSS APPLY (
    SELECT TRY_CAST(
        REVERSE(LEFT(b.nguoc, PATINDEX('%[^0-9]%', b.nguoc + 'x') - 1)) AS INT
    ) AS sttMoi
) AS d
WHERE ISNULL(t.[stt], 0) <= 0
  AND d.[sttMoi] IS NOT NULL
ORDER BY d.[sttMoi];

/* Dem truoc khi sua */
PRINT '=== SO LUONG TRUOC KHI SUA ===';
SELECT 'FarmInviter' AS bang,
       COUNT(*)                                        AS tong,
       SUM(CASE WHEN ISNULL([stt], 0) > 0 THEN 1 ELSE 0 END) AS co_stt,
       SUM(CASE WHEN ISNULL([stt], 0) <= 0 THEN 1 ELSE 0 END) AS thieu_stt
FROM [dbo].[FarmInviter]
UNION ALL
SELECT 'FarmInvitee',
       COUNT(*),
       SUM(CASE WHEN ISNULL([stt], 0) > 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN ISNULL([stt], 0) <= 0 THEN 1 ELSE 0 END)
FROM [dbo].[FarmInvitee];

/* -------------------------------------------------------------------------
   BUOC 2 - CAP NHAT
   Chi gan khi:
     - dang thieu stt (<= 0)
     - lay duoc so o cuoi email
     - so do nam trong khoang hop ly 1..1000000
   ------------------------------------------------------------------------- */
PRINT '=== DANG CAP NHAT FarmInviter ===';
UPDATE t
SET t.[stt] = d.[sttMoi],
    t.[updatedAt] = GETDATE()
FROM [dbo].[FarmInviter] AS t
CROSS APPLY (SELECT LEFT(t.[email], NULLIF(CHARINDEX('@', t.[email]), 0) - 1) AS phanTruocA) AS a
CROSS APPLY (SELECT REVERSE(a.phanTruocA) AS nguoc) AS b
CROSS APPLY (
    SELECT TRY_CAST(
        REVERSE(LEFT(b.nguoc, PATINDEX('%[^0-9]%', b.nguoc + 'x') - 1)) AS INT
    ) AS sttMoi
) AS d
WHERE ISNULL(t.[stt], 0) <= 0
  AND d.[sttMoi] IS NOT NULL
  AND d.[sttMoi] BETWEEN 1 AND 1000000;
PRINT CONCAT('  Da cap nhat ', @@ROWCOUNT, ' dong.');

PRINT '=== DANG CAP NHAT FarmInvitee ===';
UPDATE t
SET t.[stt] = d.[sttMoi],
    t.[updatedAt] = GETDATE()
FROM [dbo].[FarmInvitee] AS t
CROSS APPLY (SELECT LEFT(t.[email], NULLIF(CHARINDEX('@', t.[email]), 0) - 1) AS phanTruocA) AS a
CROSS APPLY (SELECT REVERSE(a.phanTruocA) AS nguoc) AS b
CROSS APPLY (
    SELECT TRY_CAST(
        REVERSE(LEFT(b.nguoc, PATINDEX('%[^0-9]%', b.nguoc + 'x') - 1)) AS INT
    ) AS sttMoi
) AS d
WHERE ISNULL(t.[stt], 0) <= 0
  AND d.[sttMoi] IS NOT NULL
  AND d.[sttMoi] BETWEEN 1 AND 1000000;
PRINT CONCAT('  Da cap nhat ', @@ROWCOUNT, ' dong.');

/* -------------------------------------------------------------------------
   BUOC 3 - KIEM TRA LAI
   ------------------------------------------------------------------------- */
PRINT '=== SO LUONG SAU KHI SUA ===';
SELECT 'FarmInviter' AS bang,
       COUNT(*)                                        AS tong,
       SUM(CASE WHEN ISNULL([stt], 0) > 0 THEN 1 ELSE 0 END) AS co_stt,
       SUM(CASE WHEN ISNULL([stt], 0) <= 0 THEN 1 ELSE 0 END) AS thieu_stt,
       MIN(NULLIF([stt], 0))                           AS stt_nho_nhat,
       MAX([stt])                                      AS stt_lon_nhat
FROM [dbo].[FarmInviter]
UNION ALL
SELECT 'FarmInvitee',
       COUNT(*),
       SUM(CASE WHEN ISNULL([stt], 0) > 0 THEN 1 ELSE 0 END),
       SUM(CASE WHEN ISNULL([stt], 0) <= 0 THEN 1 ELSE 0 END),
       MIN(NULLIF([stt], 0)),
       MAX([stt])
FROM [dbo].[FarmInvitee];

/* Con ban ghi nao khong vá được thì liệt kê ra để xem bằng mắt */
PRINT '=== CON THIEU STT (khong lay duoc so tu email) ===';
SELECT TOP (50) 'FarmInviter' AS bang, [email], [serverId], [status] FROM [dbo].[FarmInviter] WHERE ISNULL([stt], 0) <= 0
UNION ALL
SELECT TOP (50) 'FarmInvitee', [email], [serverId], [status] FROM [dbo].[FarmInvitee] WHERE ISNULL([stt], 0) <= 0;

/* Canh bao: cung mot STT bi lap trong cung bang (neu co, can xem lai email) */
PRINT '=== STT BI TRUNG (neu co) ===';
SELECT 'FarmInviter' AS bang, [stt], COUNT(*) AS so_dong
FROM [dbo].[FarmInviter] WHERE [stt] > 0 GROUP BY [stt] HAVING COUNT(*) > 1
UNION ALL
SELECT 'FarmInvitee', [stt], COUNT(*)
FROM [dbo].[FarmInvitee] WHERE [stt] > 0 GROUP BY [stt] HAVING COUNT(*) > 1;
