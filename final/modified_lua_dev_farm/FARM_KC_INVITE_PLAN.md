# KẾ HOẠCH TRIỂN KHAI: FARM KC — MÃ MỜI RỒNG VÀNG (LV200 ↔ LV50)

> **Trạng thái:** ĐÃ NGHIÊN CỨU XONG PHÍA GAME (đã test thật) — **CHƯA TRIỂN KHAI CODE** (DB / API / Web / Mod).
> **Ngày lập:** 2026-11-15 · **Người yêu cầu:** USER (chủ dự án) · **Bàn giao cho:** Agent kế tiếp
> **Phạm vi:** `final/web_active` (Next.js + Prisma + MSSQL) và `final/modified_lua_dev_farm` (mod Farm Lua/XLua).

---

## 0. ĐỌC TRƯỚC KHI LÀM — QUY TẮC LÀM VIỆC VỚI USER (BẮT BUỘC)

1. **Luôn thảo luận & chốt phương án cụ thể với USER trước khi sửa code.** Không tự ý sửa khi chưa thống nhất. Tài liệu này là kế hoạch đã được USER duyệt ở mức định hướng; chi tiết từng phase vẫn phải trình USER duyệt trước khi code.
2. **Gắn tag cho mọi khối code mới/sửa** (Lua và cả TS nếu hợp lý):
   ```lua
   -- =========================================================================
   -- [MOD FEATURE]: <TÊN CHỨC NĂNG>
   -- Mô tả: ...
   -- =========================================================================
   ```
3. **Terminal:** mọi lệnh (git, luac, tìm kiếm, python...) viết vào `final/excute_test/exec_cmd.ps1`, rồi chạy **đúng 1 lệnh cố định** (PowerShell tool, không thêm tham số/timeout):
   `& d:\MUVH\android\mu-decompiled\final\excute_test\executor.ps1`
   (Không dùng `powershell -ExecutionPolicy Bypass ...` — vẫn bị hỏi approve. Không gọi Bash/PowerShell trực tiếp.)
4. **Script test Lua** chỉ ghi vào `final/excute_test/input.txt`, kết quả đọc ở `final/excute_test/output.txt`. **USER tự chọn thiết bị và tự chạy `push_test.ps1`, tự bấm nút EXEC trong game.** Agent không tự push, không tìm Android ID, không sửa `push_test.ps1`.
5. Trước khi viết script/tính năng: tham khảo `final/excute_test/modules` (README + `.lua/.md`) và tái sử dụng. Hàm mới đã kiểm chứng → đóng gói lại vào modules.
6. Kiểm tra cú pháp Lua bằng `d:\MUVH\android\mu-decompiled\lua53\luac53.exe -p <file>` (qua executor) trước khi bàn giao.
7. **Chỉ chạy `build_and_update.ps1` khi USER cho phép.** Commit/push chỉ khi USER yêu cầu (nhánh `v2`, chỉ add file liên quan; nội dung commit dùng `git commit -F <file>` vì PowerShell 5.1 làm hỏng dấu `"` trong `-m`).
8. Giao tiếp với USER bằng tiếng Việt, xưng "em", gọi USER là "anh".

---

## 1. MỤC TIÊU NGHIỆP VỤ

Sự kiện **"Treo Thưởng Rồng Vàng" → tab "Mời Bạn Bè"** trong game:
- Nhân vật **đạt Lv200** tạo được **mã mời** riêng.
- Nhân vật khác **(từ Lv50)** nhập mã mời đó → người mời được tính **+1 "người mời thành công"**.
- Người mời đủ **1 / 3 / 5** người → nhận 3 mốc thưởng (5000 / 10K / 15K Kim Phiếu…).

**Luồng tổng thể USER muốn:**
```
NHÓM A – acc Lv200 ("người mời" / Inviter)
  Farm lên Lv200 → nếu chưa có mã thì [Tạo mã] → đọc mã, số người đã mời,
  vàng & KC không khóa, thông tin acc → LƯU/CẬP NHẬT vào DB → chuyển acc kế tiếp.
  Lần sau gặp lại: chỉ cập nhật số người mời + tài nguyên.
  Đủ 5 người mời → đánh dấu COMPLETE (bước nhận Kim Phiếu / mua đồ / DONE làm SAU).

NHÓM B – acc Lv50 ("người được mời" / Invitee)
  Farm lên Lv50 → hỏi DB lấy 1 mã mời của acc Lv200 CÙNG SERVER còn thiếu lượt (có giữ chỗ chống tranh chấp)
  → nhập mã + [Xác minh] → báo kết quả về DB → chuyển acc kế tiếp.
```
Nguyên tắc: **không được nghẽn ở 1 acc** — mọi bước đều có timeout, lỗi thì ghi nhận và chuyển acc.

---

## 2. KẾT QUẢ NGHIÊN CỨU PHÍA GAME (ĐÃ TEST THẬT — server VĨNH HẰNG 517, 2026-11-15)

### 2.1. Giao diện & dữ liệu
- UI: `final/extracted_lua/Task_EarlyGoldGameplay.lua` (tab `panel_invite`), data: `Task_EarlyGoldData.lua`, thưởng mốc: `InviteReward_ItemTemplate.lua`.
- Dữ liệu mã mời nằm ở: `QuickFind:GetTask_EarlyGoldManager():GetVerifyData()` → bảng `{ code, num, isCode }`.
- **Server TỰ ĐẨY gói 1029 khi nhân vật vào game** → bot đọc được ngay `VerifyData` mà không cần mở UI hay gửi gói "xem mã".
- Điều kiện mở nút Tạo mã: `ClientTable.cfg_Function_functionManager:TryGetValue(5100001, "id")` + `ConditionManager.Check4D(func.condition)` (= Lv200).

> ⚠️ **KHÔNG nhầm** với bộ gói `ReqInviteCodeView 1019 / ReqInputInviteCode 1021 / ReqGenInviteCode 1023` — đó là hệ mã mời khác (màn Cài đặt `PreferenceUI` / màn Login), **không dùng**.

### 2.2. Gói tin (module User — `final/extracted_lua/User.lua`, `NetworkRequest_User.lua`)
| Chức năng | Gọi trong Lua | Message ID |
|---|---|---|
| **Tạo mã** (nút Tạo mã) | `networkRequest.ReqRoleCode()` | `ReqRoleCode = 1027` |
| **Nhập mã** (nút Xác minh) | `networkRequest.ReqRoleVerifyCode(code)` → gửi `{ code = code }` | `ReqRoleVerifyCode = 1028` |
| Server trả về | `netMsgPreprocessing[1029]` → `Task_EarlyGoldManager:SetVerificationCode(tblData)` | `ResRoleCode = 1029` |
| Nhận thưởng mốc 1/3/5 (LÀM SAU) | `networkRequest.ReqGetGift({ 6600001 })` / `6600002` / `6600003` | — |

### 2.3. Ý nghĩa 3 trường (đã xác nhận)
| Trường | Ý nghĩa | Bằng chứng |
|---|---|---|
| `code` | Mã mời **của chính nhân vật** (rỗng `""` = chưa tạo). **Đuôi mã = serverId** (vd `hFek6LlTdvgSdj6Z517` → server 517) | Lv200 Tedyg4: trước `""`, sau ReqRoleCode → `hFek6LlTdvgSdj6Z517` |
| `num` | Số người **mình đã mời thành công** | Tedyg4: 0 → 1 → 2 sau 2 acc Lv50 nhập mã (UI hiện "Số người mời thành công: 1") |
| `isCode` | Nhân vật **ĐÃ NHẬP mã mời của người khác** hay chưa | Lv50 mới Benwt1: `false` → sau Xác minh → `true`. Lv50 Leowr4 đã nhập trước đó: `true` |

### 2.4. Hành vi đã quan sát
- **Tạo mã:** gửi `ReqRoleCode()` → nhận ngay 1029 `{code="hFek6LlTdvgSdj6Z517", num=0, isCode=false}` + toast `FloatingTipUtility` **"Đã tạo mã mời"**. Đọc lại `GetVerifyData()` sau 3s có mã.
- **Nhập mã thành công:** phía Lv50 **không thấy gói 1029 / toast rõ ràng trong 3s** → **dấu hiệu thành công duy nhất đáng tin = `isCode` chuyển `false → true`** (poll lại `GetVerifyData()`).
- **Nhập mã thất bại / nhập lại:** hiện popup "Nhắc nhở" qua `UIManager.Show(UIID.PromptTipUI, { title, textContent })` với nội dung **"Mã mời này đã dùng hoặc bị lỗi, hãy kiểm tra lại rồi nhập"** (bắt bằng hook `UIManager.Show`, đọc `args.textContent`).
- **Mỗi nhân vật chỉ nhập mã được 1 lần.**
- **Server KHÔNG chặn cùng thiết bị / cùng tài khoản SDK:** Lv200 và Lv50 cùng 1 giả lập, cùng tiền tố tài khoản `1320:1320:...` vẫn mời thành công → **DB không cần ghép cặp theo DeviceId**.
- **Mã mời chỉ dùng trong cùng server** (USER xác nhận + đuôi mã = serverId).

### 2.5. ID tiền tệ (`BagInfoData.CoinInfos[id]`) — USER xác nhận bằng ảnh thanh tiền
| ID | Tên | Dùng cho báo cáo |
|---|---|---|
| **1000020** | Vàng (KHÔNG khóa) | ✅ `UnboundGold` |
| 1000021 | Vàng Khoá | — |
| **1000030** | KC (KHÔNG khóa) | ✅ `UnboundDiamond` |
| 1000050 | Kim Cương Khóa | — |
| 1000010 | "Vàng" (loại khác) | KHÔNG dùng |

### 2.6. Thông tin nhân vật & server
- RoleId/Level/Name: `ViewData.meData.id / .level / .name` (fallback `RoleManager.me`).
- Server: `LoginData.serverId` (vd `517`), tên `LoginData.GetServerName()` (vd `VĨNH HẰNG 517`). Bản Farm còn có `_G.GetActualCurrentServerInfo()` (Main.lua ~7703) trả `sId, sName`.
- `LoginData.account` có dạng `1320:1320:179084762180159000` (KHÔNG phải email) → **email/password lấy từ danh sách acc của bản Farm** (xem 6.1).

### 2.7. Script test đã dùng
`final/excute_test/test_scripts/test_invite_code_rong_vang.lua` — 3 chế độ `VIEW` (chỉ đọc) / `GEN` (tạo mã) / `VERIFY` (nhập mã). Copy vào `input.txt` để USER chạy. Lưu ý: ở lần VERIFY thật, timer 3s không chạy → khi viết code mod thật phải poll nhiều lần (xem 6.4).

---

## 3. CÁC QUYẾT ĐỊNH USER ĐÃ CHỐT

1. **Mã mời chỉ trong cùng server** → acc Lv50 buộc phải lấy mã của acc Lv200 **cùng serverId**.
2. **Mời thành công** = Lv50 nhập mã + Xác minh là xong (không cần bước gì tiếp theo).
3. **Lv200 đủ 5 lượt mời → đánh dấu `COMPLETE`.** Việc đăng nhập nhận Kim Phiếu thưởng mốc, mua đồ rồi mới `DONE` → **làm SAU** (không ôm đồm).
4. USER có sẵn acc Lv200 & Lv50 để test; Agent viết script + log, USER execute.
5. **Web — phân hệ:**
   - Gom toàn bộ menu hiện có (Dashboard, Token Customer, Token SVIP, Mẫu Tin Nhắn, Gói Cước VIP, Telegram CSKH) vào **phân hệ lớn "MOD MU VH"**.
   - Thêm **phân hệ "FARM KC"** với 2 menu con: **"DS ACC 200"**, **"DS ACC 50"** — tạm thời **chỉ load table có phân trang phía server** để xem data; **filter làm sau**.
   - **Tài khoản web được phân vào các phân hệ**; được phân phân hệ nào mới thấy menu, xem data và thao tác trên phân hệ đó. Vẫn giữ quy tắc **user thường chỉ dùng data của chính mình** (theo CreatedBy); **ADMIN xem & thao tác tất cả** như hiện nay.
   - Menu **"Quản lý phân hệ"** (chỉ ADMIN): **active / deactive** phân hệ. Phân hệ bị deactive → **ẩn khỏi UI và chặn luôn truy cập BE** (API trả 403).
6. **Bản Farm có ô nhập "username web"** của người dùng → dùng cho trường **CreatedBy** khi đẩy data lên.
7. **Bản Farm có 2 toggle mới, đặt TRÊN CÙNG bộ nút**, kiểu toggle giống các nút khác:
   - **"LV50 & NHẬP MÃ MỜI"** → bật thì target level **mặc định = 50 và KHÔNG sửa được**.
   - **"LV200 & FARM MÃ MỜI"** → bật thì target level **mặc định = 200 và KHÔNG sửa được**.
   - (Đề xuất: 2 toggle loại trừ nhau; tắt cả 2 thì trả quyền sửa target level như cũ.)
8. **Toggle "DEBUG KẾT QUẢ FARM" — mặc định ON.** Khi ON: nút nổi **[KQ]** cùng **toàn bộ hệ thống ghi nhận kết quả & quá trình farm lên level** mới hoạt động. Khi OFF: tắt hết để **giảm đọc/ghi file, đỡ lag** (sau này kết quả xem trên web).

---

## 4. THIẾT KẾ DATABASE (MSSQL qua Prisma)

> Dự án dùng Prisma (`final/web_active/prisma/schema.prisma`, provider `sqlserver`) và có thêm migrate thủ công trong `final/web_active/lib/db.ts` (ALTER TABLE …) + `schema.sql`. Agent cần xem cách dự án đang migrate để làm theo cùng kiểu.
> Model `User` hiện có: `id (uuid)`, `username (unique)`, `passwordHash`, `displayName`, `role ("ADMIN" | "SALE")`.

### 4.1. Bảng `FarmInviter` — acc Lv200
| Cột | Kiểu | Ghi chú |
|---|---|---|
| Id | uuid PK | |
| Email | nvarchar | Email đăng nhập acc game |
| PasswordEnc | nvarchar | Mật khẩu acc game (**xem câu hỏi mở 9.2 — đề xuất mã hóa AES, không lưu plain**) |
| ServerId | int | vd 517 — **UNIQUE (Email, ServerId)** |
| ServerName | nvarchar | vd "VĨNH HẰNG 517" |
| RoleId | nvarchar(30) | int64 của game → lưu string |
| RoleName | nvarchar | |
| Level | int | |
| InviteCode | nvarchar(50) NULL | mã mời; NULL = chưa tạo |
| GameInviteNum | int | `num` do chính acc Lv200 báo về (nguồn sự thật từ game) |
| ConfirmedCount | int | số invitee `SUCCESS` ghi nhận trong DB (từ phía Lv50) |
| ReservedCount | int | số suất đang được giữ chỗ (lease) |
| MaxInvites | int default 5 | |
| UnboundGold | bigint | coin 1000020 |
| UnboundDiamond | bigint | coin 1000030 |
| Status | nvarchar(20) | `ACTIVE` / `COMPLETE` / `DONE` (sau này) / `ERROR` |
| FailCount | int | số lần lỗi liên tiếp |
| LastError | nvarchar NULL | |
| LastSyncAt | datetime2 | |
| CreatedById | FK → User.id | từ ô "username web" của bản Farm |
| CreatedAt / UpdatedAt | datetime2 | |

- **Số lượt đã dùng hiệu dụng** = `MAX(GameInviteNum, ConfirmedCount)`.
- **Còn suất** khi `MAX(GameInviteNum, ConfirmedCount) + ReservedCount < MaxInvites`.
- Index gợi ý: `(ServerId, Status)`, `(CreatedById)`.

### 4.2. Bảng `FarmInvitee` — acc Lv50
| Cột | Kiểu | Ghi chú |
|---|---|---|
| Id | uuid PK | |
| Email, PasswordEnc | nvarchar | |
| ServerId | int | **UNIQUE (Email, ServerId)** (mỗi nhân vật chỉ nhập mã 1 lần) |
| ServerName, RoleId, RoleName, Level | | |
| InviterId | FK → FarmInviter.Id NULL | đã/đang dùng mã của acc Lv200 nào |
| InviteCode | nvarchar NULL | |
| Status | nvarchar(20) | `RESERVED` / `SUCCESS` / `FAILED` / `EXPIRED` / `ALREADY_USED` (isCode đã true từ trước) / `NO_CODE` (lúc xin không còn mã) |
| DeviceId | nvarchar NULL | máy đang giữ chỗ |
| ReservedAt / ExpireAt / ConfirmedAt | datetime2 NULL | lease ~10 phút |
| ErrorMsg | nvarchar NULL | vd nội dung popup "Mã mời này đã dùng hoặc bị lỗi..." |
| CreatedById | FK → User.id | |
| CreatedAt / UpdatedAt | datetime2 | |

### 4.3. Bảng phân hệ (web)
- `SystemModule`: `Id`, `Code` (`MOD_MU_VH`, `FARM_KC`), `Name`, `IsActive` (bit), `SortOrder`.
- `UserModule`: `UserId` + `ModuleId` (PK ghép) — tài khoản được phân vào phân hệ nào.
- ADMIN mặc định thấy mọi phân hệ **đang active** (phân hệ deactive thì ẩn với tất cả, kể cả quyền truy cập BE — trừ màn "Quản lý phân hệ" của ADMIN để bật lại).
- **Migrate dữ liệu cũ:** gán tất cả user hiện có vào `MOD_MU_VH` để không mất quyền đang dùng.

---

## 5. CHỐNG TRANH CHẤP MÃ MỜI (KHÔNG ĐỂ 1 ACC LV200 VƯỢT 5 LƯỢT)

**Vấn đề:** khóa dòng SQL (`ROWLOCK/UPDLOCK`) chỉ tồn tại trong 1 câu lệnh / 1 transaction (mili-giây), còn việc Lv50 nhận mã → nhập trong game → báo lại kéo dài cả phút qua nhiều HTTP call → **không thể giữ lock DB suốt quá trình**.

**Giải pháp: giữ chỗ có hạn (lease):**
- `claim`: chọn 1 acc Lv200 cùng server còn suất **và tăng `ReservedCount` ngay trong 1 câu UPDATE nguyên tử**, đồng thời tạo dòng `FarmInvitee` trạng thái `RESERVED` với `ExpireAt = now + 10 phút`.
- `result SUCCESS`: `ReservedCount - 1`, `ConfirmedCount + 1`. `result FAILED`: `ReservedCount - 1`.
- Máy chết không báo lại → lease **tự hết hạn** và trả suất (bước dọn dẹp chạy đầu mỗi lần `claim`).

**Mẫu SQL (USER đề xuất pattern `UPDATE … OUTPUT … WITH (ROWLOCK, READPAST)`; đã chỉnh thêm `UPDLOCK` + kiểm tra điều kiện ngay trong UPDATE):**
```sql
BEGIN TRAN;
-- 0. Trả suất các lease quá hạn
DECLARE @expired TABLE (InviterId uniqueidentifier);
UPDATE V SET V.Status = 'EXPIRED', V.UpdatedAt = SYSUTCDATETIME()
OUTPUT DELETED.InviterId INTO @expired
FROM dbo.FarmInvitee V WITH (ROWLOCK, READPAST)
WHERE V.Status = 'RESERVED' AND V.ExpireAt < SYSUTCDATETIME();

UPDATE I SET I.ReservedCount = CASE WHEN I.ReservedCount - E.Cnt < 0 THEN 0 ELSE I.ReservedCount - E.Cnt END
FROM dbo.FarmInviter I
JOIN (SELECT InviterId, COUNT(*) Cnt FROM @expired GROUP BY InviterId) E ON E.InviterId = I.Id;

-- 1. Chọn 1 acc Lv200 còn suất + tăng ReservedCount trong CÙNG 1 câu
DECLARE @picked TABLE (Id uniqueidentifier, InviteCode nvarchar(50));
;WITH pick AS (
  SELECT TOP (1) I.*
  FROM dbo.FarmInviter I WITH (UPDLOCK, ROWLOCK, READPAST)
  WHERE I.ServerId = @serverId
    AND I.Status = 'ACTIVE' AND I.InviteCode IS NOT NULL
    AND (CASE WHEN I.GameInviteNum > I.ConfirmedCount THEN I.GameInviteNum ELSE I.ConfirmedCount END)
        + I.ReservedCount < I.MaxInvites
  ORDER BY (CASE WHEN I.GameInviteNum > I.ConfirmedCount THEN I.GameInviteNum ELSE I.ConfirmedCount END)
           + I.ReservedCount DESC, I.CreatedAt   -- lấp đầy từng acc trước (đổi ASC nếu muốn chia đều)
)
UPDATE pick SET ReservedCount = ReservedCount + 1, UpdatedAt = SYSUTCDATETIME()
OUTPUT INSERTED.Id, INSERTED.InviteCode INTO @picked;

-- 2. Ghi lease cho acc Lv50 (upsert theo Email+ServerId)
--    (nếu đã có dòng RESERVED còn hạn của chính acc này → trả lại mã cũ, KHÔNG giữ chỗ 2 lần — xử lý ở đầu API)
INSERT dbo.FarmInvitee (Id, Email, ServerId, InviterId, InviteCode, Status, DeviceId, ReservedAt, ExpireAt, CreatedById, CreatedAt, UpdatedAt)
SELECT NEWID(), @email, @serverId, Id, InviteCode, 'RESERVED', @deviceId, SYSUTCDATETIME(),
       DATEADD(MINUTE, 10, SYSUTCDATETIME()), @createdById, SYSUTCDATETIME(), SYSUTCDATETIME()
FROM @picked;
COMMIT;
SELECT * FROM @picked;
```
- `READPAST`: dòng đang bị phiên khác giữ thì bỏ qua sang acc kế tiếp (không chờ).
- Chạy bằng `prisma.$queryRawUnsafe` / `$executeRaw` trong transaction hoặc tạo **stored procedure** (khuyến nghị SP cho gọn).
- **Idempotent:** gọi `claim` lại cho cùng (Email, ServerId) khi đã có lease `RESERVED` còn hạn → trả lại đúng mã cũ; đã `SUCCESS` → trả trạng thái đã xong.

---

## 6. PHÍA MOD FARM (`final/modified_lua_dev_farm`)

### 6.1. Hiện trạng cần nắm
- `EmmyluaDebug.lua` ~3325 `BuildBotAccounts()`: danh sách acc sinh từ PlayerPrefs `Mod_Farm_AccPrefix` (mặc định `accvutmuvh`), dải `Mod_Farm_AccStart..Mod_Farm_AccEnd`, mật khẩu chung `Mod_Farm_AccPass`, server `Mod_Farm_TargetServer`. Email = `string.format("%s%04d@gmail.com", prefix, i)`. Mỗi phần tử: `{ id, stt, account(email), password, targetServer, roles }`.
- `_G.GetCurrentAccount()` (~3390), chỉ số acc `_G.CurrentAccountIndex` lưu PlayerPrefs `Mod_Farm_CurAccIndex`.
- Target level: PlayerPrefs `Mod_Farm_TargetLevel` (UI nhập ở EmmyluaDebug ~1267 / ~1561 / ~1707; một số chỗ đọc mặc định 200/201: EmmyluaDebug ~8684, ~9024, ~9547; Main.lua ~2359).
- Đạt target → `_G.OnAccountReachLevelGoal(lvl, targetLvl)` (**Main.lua ~2369**): dừng timer, ghi `farm_success_accounts.txt`, tăng index, đăng nhập acc kế tiếp; hết danh sách → `StopAutoFarmBot()`. Lỗi → `_G.OnAccountFailedAndSkip(reason)` (Main.lua ~2470, ghi `farm_failed_accounts.txt`). Có nhiều chỗ gọi `OnAccountReachLevelGoal` (Main.lua ~142, ~300, ~6010, ~6635; EmmyluaDebug ~9554).
- UI chính: panel `ModMenuPanel` (EmmyluaDebug ~1131, 780×590). Mẫu nút toggle: BUG QUEST (~2080–2137), bộ nút mua gói KC (`[MOD FEATURE]: BỘ NÚT BẬT/TẮT MUA GÓI KIM CƯƠNG KHÓA`).
- Hệ thống KQ/ghi nhận: Main.lua ~717–1994 (`account_level_details.json`, `LoadAccountTimeRecords`, `FinalizeAccountTimeOnGoal/Failed`), nút nổi [KQ] + panel `ModKqResultPanel` (Main.lua ~1307–1380+). Nút EXEC vừa bật lại (`_G.Mod_ExecBtn_Visible = true`).
- Tài liệu luồng farm cũ: `final/modified_lua_dev_farm/FARM_BOT_WORKFLOW_NOTE.md`.
- **Mẫu gọi HTTP từ mod:** bản client có `Mod_FetchSvipConfigFromAPI` (`final/modified_lua_dev_client/EmmyluaDebug.lua` ~11850) dùng `CS.UnityEngine.Networking.UnityWebRequest.Get(url)` + poll `req.isDone` bằng `Timer.StartLoop`, parse JSON bằng `Mod_ParseJSON`; có `Mod_GetMD5` để ký. **POST JSON** cần `UnityWebRequest` + `UploadHandlerRaw` + header `Content-Type: application/json` (agent tự kiểm chứng trên XLua bằng script test trước).

### 6.2. UI mới trên bản Farm (theo mục 3.6–3.8)
1. **Ô nhập "USERNAME WEB"** (InputField) → PlayerPrefs `Mod_Farm_WebUsername`; gửi kèm mọi API làm `createdBy`.
2. **Toggle "LV50 & NHẬP MÃ MỜI"** và **"LV200 & FARM MÃ MỜI"** đặt **trên cùng bộ nút**:
   - Bật Lv50 → set `Mod_Farm_TargetLevel = 50`, khóa ô sửa target; bật Lv200 → `= 200`, khóa ô sửa. Loại trừ nhau. Tắt cả 2 → mở khóa như cũ.
   - Lưu PlayerPrefs (vd `Mod_Farm_InviteMode` = `NONE` / `LV50` / `LV200`).
3. **Toggle "DEBUG KẾT QUẢ FARM"** (mặc định **ON**, PlayerPrefs `Mod_Farm_DebugResult`): OFF → ẩn nút [KQ] + panel KQ, **bỏ qua toàn bộ ghi file/ghi nhận kết quả & thời gian farm** (`SaveAccountTimeRecords`, `account_level_details.json`, `farm_success/failed_accounts.txt`, `Log/SaveOutput` của luồng KQ...). Agent cần rà hết các điểm đọc/ghi để bọc điều kiện.

### 6.3. Luồng chế độ LV200 & FARM MÃ MỜI (Inviter)
Chèn vào thời điểm đạt target (trước khi chuyển acc trong `OnAccountReachLevelGoal`, hoặc tách hàm `RunInviterStep(onDone)` rồi gọi trước phần chuyển acc):
1. Chờ `GetVerifyData()` có dữ liệu (server tự đẩy 1029 khi vào game) — poll mỗi 1s, tối đa ~10s.
2. Nếu `code` rỗng và điều kiện func 5100001 = true → `networkRequest.ReqRoleCode()` → poll tới khi có `code` (tối đa ~10s). Quá hạn → ghi lỗi.
3. Thu thập: `code`, `num`, `UnboundGold = CoinInfos[1000020]`, `UnboundDiamond = CoinInfos[1000030]`, RoleId/RoleName/Level, `LoginData.serverId` + tên server, email/password từ `GetCurrentAccount()`.
4. `POST inviter/report` (upsert). Server tự set `COMPLETE` nếu `MAX(GameInviteNum, ConfirmedCount) >= 5`.
5. Dù thành công hay lỗi mạng → **chuyển acc** (lỗi mạng: lưu vào hàng đợi gửi bù trên máy, xem 6.6).
6. **(Tùy chọn khuyến nghị)** Trước khi đăng nhập 1 acc ở chế độ này: `GET inviter?email&serverId` → nếu `COMPLETE`/`DONE` thì bỏ qua acc, không cần login.

### 6.4. Luồng chế độ LV50 & NHẬP MÃ MỜI (Invitee)
1. Đạt Lv50 → chờ `GetVerifyData()` (poll ≤10s).
2. Nếu `isCode == true` → acc đã nhập mã từ trước → `POST invite/result` với `ALREADY_USED` (không xin mã) → chuyển acc.
3. `POST invite/claim { email, serverId, deviceId, createdBy }` → nhận `inviteCode` (+ `inviteeId`). Không còn mã cùng server → ghi `NO_CODE` → chuyển acc (vòng sau thử lại).
4. Hook tạm `UIManager.Show` để bắt popup lỗi (`args.textContent`), gửi `networkRequest.ReqRoleVerifyCode(inviteCode)`.
5. **Poll `GetVerifyData().isCode` mỗi 1s, tối đa ~10s** (KHÔNG dựa vào 1 lần chờ 3s — đã thấy timer 3s không chạy ở lần test thật):
   - `isCode == true` → `SUCCESS`.
   - Bắt được popup lỗi → `FAILED` + `ErrorMsg`.
   - Hết 10s vẫn `false` → `FAILED` ("timeout").
6. `POST invite/result { inviteeId, status, errorMsg }` → gỡ hook → chuyển acc.

### 6.5. Hết danh sách acc
Hiện tại bot dừng (`StopAutoFarmBot`). **Câu hỏi mở 9.1** (quay vòng hay dừng).

### 6.6. Chống nghẽn (bắt buộc)
- Timeout cho từng bước: đăng nhập, chờ VerifyData, tạo mã, xác minh, gọi API (UnityWebRequest timeout ~10s).
- API lỗi/mất mạng → **không chặn farm**: lưu payload vào file hàng đợi trên máy (vd `persistentDataPath/farm_invite_pending.json`), gửi bù ở lần kế tiếp có mạng.
- Đếm lỗi theo acc (DB `FailCount`); vượt ngưỡng (vd 3) → `ERROR`, vòng sau bỏ qua tới khi ADMIN reset trên web.
- Không log/QuickMsg thừa (USER thích chạy im lặng); log debug chỉ khi toggle Debug bật.

---

## 7. ĐẶC TẢ API (`final/web_active/app/api/v1/farm/...`)

> Hiện có các route `app/api/v1/config`, `app/api/v1/svip/config` mà mod đang gọi (tham khảo cách parse/response). Auth web dùng JWT cookie `muvh_session` (`lib/auth.ts` → `getSessionUser`).

**Xác thực cho mod:** mọi request kèm `ts` (unix time) + `sign = MD5(<chuỗi tham số theo thứ tự cố định> + ts + FARM_SECRET_SALT)`; server kiểm tra sign và `|now - ts| <= 300s`. `createdBy` = username web → server tra `User.username` → `CreatedById` (không tồn tại → 400).

| Method & Path | Dùng bởi | Request | Response / Xử lý |
|---|---|---|---|
| `GET /api/v1/farm/inviter?email&serverId&ts&sign` | Lv200 (trước login) | — | `{ exists, status, inviteCode, gameInviteNum, confirmedCount }` |
| `POST /api/v1/farm/inviter/report` | Lv200 | `{ email, password, serverId, serverName, roleId, roleName, level, inviteCode, gameInviteNum, unboundGold, unboundDiamond, createdBy, ts, sign }` | Upsert theo (Email, ServerId); tính lại Status (`COMPLETE` khi đủ 5). Trả `{ ok, status }` |
| `POST /api/v1/farm/invite/claim` | Lv50 | `{ email, password, serverId, serverName, roleId, roleName, level, deviceId, createdBy, ts, sign }` | SQL mục 5. Trả `{ ok, inviteeId, inviteCode }` hoặc `{ ok:false, reason:'NO_CODE' }` / `{ ok:true, alreadySuccess:true }` |
| `POST /api/v1/farm/invite/result` | Lv50 | `{ inviteeId?, email, serverId, status: SUCCESS|FAILED|ALREADY_USED, errorMsg?, createdBy, ts, sign }` | Cập nhật FarmInvitee + điều chỉnh `ReservedCount/ConfirmedCount` của FarmInviter; cập nhật Status inviter nếu đủ 5 |

**API cho web (đăng nhập JWT, kiểm tra phân hệ `FARM_KC` active + user thuộc phân hệ):**
- `GET /api/farm/inviters?page&pageSize` — non-ADMIN chỉ thấy `CreatedById = mình`.
- `GET /api/farm/invitees?page&pageSize` — tương tự.
- `GET/PATCH /api/admin/modules` (ADMIN) — liệt kê & bật/tắt phân hệ; quản lý gán user ↔ phân hệ.

---

## 8. PHÍA WEB (`final/web_active`)

- Menu hiện tại nằm ở `components/Sidebar.tsx` (và `components/Navbar.tsx`). Cấu trúc lại thành nhóm theo phân hệ:
  - **MOD MU VH**: Dashboard, Token Customer, Token SVIP, Mẫu Tin Nhắn, Gói Cước VIP, Telegram CSKH.
  - **FARM KC**: DS ACC 200, DS ACC 50.
  - **(ADMIN) Quản lý phân hệ**.
- Trang mới: `/farm-kc/acc-200`, `/farm-kc/acc-50` — table + **phân trang phía server**; cột gợi ý:
  - ACC 200: Email, Server, RoleName, Level, InviteCode, Số người mời (GameInviteNum/ConfirmedCount/Reserved), Vàng không khóa, KC không khóa, Status, LastSyncAt, CreatedBy.
  - ACC 50: Email, Server, RoleName, Level, InviteCode đã nhập, Inviter (email), Status, ErrorMsg, ConfirmedAt, CreatedBy.
  - Mật khẩu: không hiển thị mặc định (hoặc chỉ ADMIN, bấm để xem).
- **Guard phân hệ ở BE**: helper `requireModule(req, 'FARM_KC')` → 401/403 nếu chưa đăng nhập / phân hệ deactive / user không thuộc phân hệ (ADMIN bỏ qua bước "thuộc phân hệ" nhưng vẫn tôn trọng deactive). Áp cho **cả** route cũ của MOD MU VH (để deactive MOD MU VH cũng chặn được).
- **Lọc data theo người tạo**: non-ADMIN luôn `where: { createdById: session.userId }`; ADMIN không lọc.
- Filter nâng cao: **làm sau**.

---

## 9. CÂU HỎI CÒN MỞ (hỏi USER trước khi làm phần liên quan)

1. **Hết danh sách acc:** (a) nghỉ X phút rồi quay vòng từ acc 1 (acc COMPLETE bỏ qua nhanh nhờ GET inviter) hay (b) chạy 1 lượt rồi dừng như hiện tại?
2. **Mật khẩu acc game trong DB:** mã hóa AES (khóa ở biến môi trường server, admin xem thì giải mã) — đề xuất — hay lưu plain cho tiện?
3. **Thứ tự lấp mã:** dồn đủ 5 cho từng acc Lv200 trước (`DESC`, đề xuất) hay chia đều (`ASC`)?
4. **Nhiều máy chạy cùng dải acc?** (Lease đã chống trùng suất mời; nếu 2 máy cùng đăng nhập 1 acc thì cần thêm cơ chế giữ chỗ acc — hiện chưa thiết kế.)
5. **Có cần tăng số phiên bản cho bản Farm** (`_G.Mod_Version` như client/customer đang dùng ở Watermark) không?

---

## 10. KẾ HOẠCH TRIỂN KHAI ĐỀ XUẤT (mỗi phase trình USER duyệt trước)

| Phase | Nội dung | Tiêu chí xong |
|---|---|---|
| **P1 – DB + API** | Prisma models + migrate (kiểu dự án đang dùng), SP/raw SQL claim, 4 API mod + ký MD5 | Gọi thử bằng script/HTTP client: claim đồng thời nhiều request không vượt 5 suất; lease hết hạn trả suất |
| **P2 – Web phân hệ** | Bảng SystemModule/UserModule, Sidebar theo phân hệ, guard BE, trang Quản lý phân hệ | Deactive phân hệ → ẩn menu + API 403; user chỉ thấy data của mình, ADMIN thấy hết |
| **P3 – Web DS ACC 200/50** | 2 trang table phân trang server | Xem được data do P1 ghi vào |
| **P4 – Mod: UI** | Ô username web, 2 toggle LV50/LV200 (khóa target), toggle Debug KQ (mặc định ON) | Toggle lưu PlayerPrefs, khóa/mở target đúng; Debug OFF thì không ghi file KQ |
| **P5 – Mod: HTTP + luồng Lv200** | Hàm gọi API (GET/POST JSON, timeout, hàng đợi gửi bù), RunInviterStep | Acc Lv200 đạt target → tạo mã nếu thiếu → report lên DB → chuyển acc |
| **P6 – Mod: luồng Lv50** | RunInviteeStep (isCode check, claim, verify, poll isCode, result) | Acc Lv50 → nhập mã thành công, DB SUCCESS, inviter tăng lượt; lỗi không làm nghẽn |
| **P7 – Test tổng** | USER chạy dàn acc thật | Không acc Lv200 nào vượt 5, không acc nào kẹt |

**Test từng bước bằng script `input.txt` + nút EXEC trước khi đưa vào code chính** (đúng quy tắc mục 0).

---

## 11. THAM CHIẾU NHANH

- Script test mã mời: `final/excute_test/test_scripts/test_invite_code_rong_vang.lua`
- Game UI/data: `final/extracted_lua/Task_EarlyGoldGameplay.lua`, `Task_EarlyGoldData.lua`, `InviteReward_ItemTemplate.lua`, `NetMsgPreverifying_User.lua` (1029), `NetworkRequest_User.lua` (ReqRoleCode/ReqRoleVerifyCode), `User.lua` (ID message)
- Mod Farm: `final/modified_lua_dev_farm/EmmyluaDebug.lua`, `Main.lua`, `FARM_BOT_WORKFLOW_NOTE.md`
- Mẫu HTTP + MD5 trong mod: `final/modified_lua_dev_client/EmmyluaDebug.lua` (`Mod_FetchSvipConfigFromAPI`, `Mod_GetMD5`, `Mod_ParseJSON`)
- Web: `final/web_active/prisma/schema.prisma`, `lib/db.ts`, `lib/auth.ts`, `components/Sidebar.tsx`, `app/api/v1/*`
