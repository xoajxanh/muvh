# KẾ HOẠCH TRIỂN KHAI PHÍA LUA — FARM KC MÃ MỜI RỒNG VÀNG

> **Tài liệu mẹ:** `FARM_KC_INVITE_PLAN.md` (mục 6 — PHÍA MOD FARM).
> **Trạng thái:** P1 (DB + API) ĐÃ XONG. Tài liệu này chi tiết hoá **P4/P5/P6**.
> **Ngày lập:** 2026-11-17 · **Phạm vi:** `final/modified_lua_dev_farm`
> **Nguyên tắc:** mọi phần dưới đây phải trình USER duyệt trước khi code; test bằng
> `excute_test/input.txt` + nút EXEC trước khi đưa vào file chính.

---

## 0. KẾT QUẢ KHẢO SÁT CODE FARM (2026-11-17)

| Thứ cần dùng | Bản Farm có sẵn? | Ghi chú |
|---|---|---|
| `MD5(str)` | ✅ CÓ | `EmmyluaDebug.lua:3469`, export ở bảng cuối file (dòng 10570) |
| `UrlEncode(str)` | ✅ CÓ | `EmmyluaDebug.lua:3508`, export dòng 10583 |
| `Timer.StartLoop` | ✅ CÓ | dùng 20 chỗ trong EmmyluaDebug, 6 chỗ trong Main |
| **`UnityWebRequest`** | ❌ **KHÔNG** | Chỉ có trong `Login_LoginUI.lua:868`. **Phải viết mới** |
| **`Mod_ParseJSON`** | ❌ **KHÔNG** | Bản client có (`modified_lua_dev_client/EmmyluaDebug.lua:11809`). **Phải port** |
| **POST JSON** | ❌ **KHÔNG** | Bản client chỉ có GET. **Phải viết mới + tự kiểm chứng trên XLua** |

> ⚠️ **Đây là rủi ro lớn nhất của P5.** Bản Farm chưa từng gọi HTTP API. Toàn bộ hạ tầng
> mạng phải dựng mới và **test riêng bằng script EXEC trước**, không gộp vào luồng farm.

### Các điểm chèn đã xác định

| Mục đích | Vị trí |
|---|---|
| Danh sách acc (email + password) | `EmmyluaDebug.lua:3325` `BuildBotAccounts()` |
| Acc hiện tại | `EmmyluaDebug.lua:3394` `_G.GetCurrentAccount()` |
| **Chèn luồng mã mời** | `Main.lua:2369` `_G.OnAccountReachLevelGoal` |
| Nơi chuyển acc (chèn TRƯỚC đoạn này) | `Main.lua:2435` `local nextAccIdx = curAccIdx + 1` |
| Luồng lỗi | `Main.lua:2473` `_G.OnAccountFailedAndSkip` |
| Target level | PlayerPrefs `Mod_Farm_TargetLevel`; đọc ở EmmyluaDebug 1267/1561/1707, 8684/9024/9547 (mặc định 201), Main 2362 (mặc định 200) |
| Panel UI | `EmmyluaDebug.lua:1131` `ModMenuPanel` (780×590) |
| Mẫu nút toggle | `EmmyluaDebug.lua:2080` (BUG QUEST) |
| Server hiện tại | `_G.GetActualCurrentServerInfo()` → `sId, sName` |

---

## 0b. KẾT QUẢ TEST T1 TRÊN GAME THẬT (2026-11-17, acc Tedyg4 Lv282, server 517)

**T1 ĐẠT.** Mọi trường cần cho luồng mã mời đều đọc được. Đối chiếu với ảnh chụp UI
trong game: mã mời, số người mời, vàng và KC đều khớp tuyệt đối.

### Giá trị thật đọc được

| Trường | Nguồn | Giá trị thật |
|---|---|---|
| `code` | `GetVerifyData().code` | `hFek6LlTdvgSdj6Z517` (đuôi = serverId 517) |
| `num` | `GetVerifyData().num` | `2` — khớp UI "Số người mời thành công: 2" |
| `isCode` | `GetVerifyData().isCode` | `false` |
| `roleId` | `ViewData.meData.id` | `5945036050158842885` (int64 → **phải lưu dạng string**) |
| `roleName` / `level` | `ViewData.meData` | `Tedyg4` / `282` |
| `serverId` / `serverName` | `_G.GetActualCurrentServerInfo()` | `517` / `VĨNH HẰNG 517` |
| `unboundGold` | `CoinInfos[1000020]` | `41071` ✅ khớp UI |
| `unboundDiamond` | `CoinInfos[1000030]` | `0` ✅ khớp UI |
| `deviceId` | `SystemInfo.deviceUniqueIdentifier` | `2dc8b81c...` (ổn định) |
| `canGenCode` | func 5100001 + `Check4D` | `true` |

ID tiền tệ đã xác nhận bằng ảnh: `1000020` Vàng KHÔNG khóa · `1000021` Vàng Khóa
(554252) · `1000030` KC KHÔNG khóa · `1000050` Kim Cương Khóa (145).

### BA ĐIỂM SỬA SO VỚI TÀI LIỆU MẸ — BẮT BUỘC TUÂN THỦ

**1. `Timer.Start` KHÔNG CHẠY trong script EXEC.**
Phần hẹn giờ 5 giây của T1 không hề chạy (cả khi ở màn login lẫn khi đã vào game).
Đây chính là nguyên nhân "timer 3s không chạy" đã ghi trong tài liệu mẹ mục 2.7.
→ **Mọi vòng poll (chờ VerifyData, chờ `isCode`, chờ `req.isDone`) PHẢI dùng
`Timer.StartLoop`, TUYỆT ĐỐI KHÔNG dùng `Timer.Start`.**
→ `_G.LuaTimer` = `false` trên bản Farm, không dùng được.

**2. Tài khoản SDK nằm ở `LoginData.userName`, KHÔNG phải `LoginData.account`.**
`LoginData.account` = `nil`; `LoginData.userName` = `1320:1320:179084762180159000`.
Tài liệu mẹ mục 2.6 ghi `LoginData.account` là **sai**. Email/password vẫn lấy từ
`GetCurrentAccount()` của bản Farm như kế hoạch.

**3. `Time.GetServerSecondTime()` dùng được để ký.**
Khi đã vào game trả `1794917550`, trùng khít `os.time()` → dùng làm `ts`.
Lưu ý: ở màn **login** nó trả `3343` (sai) → chỉ gọi sau khi đã vào thế giới game,
có dự phòng `os.time()`.

### Trường KHÔNG dùng được (trả nil, đã loại khỏi kế hoạch)
`masterLevel`, `fight` (lực chiến), `isDead`, `LoginData.sid`, `LoginData.account`.

### Hạ tầng mạng — ĐÃ XÁC NHẬN CÓ ĐỦ
`UnityWebRequest` ✅ · `UploadHandlerRaw` ✅ · `DownloadHandlerBuffer` ✅ ·
`Timer.StartLoop` ✅ → **POST JSON khả thi**, rủi ro lớn nhất của P5 đã được gỡ.

---

## 1. P4 — UI TRÊN BẢN FARM

Theo mục 3.6–3.8 tài liệu mẹ. Đặt **trên cùng** bộ nút trong `ModMenuPanel`, dựng theo
đúng khuôn nút BUG QUEST (`EmmyluaDebug.lua:2080`).

| Thành phần | PlayerPrefs | Hành vi |
|---|---|---|
| Ô nhập **USERNAME WEB** | `Mod_Farm_WebUsername` | Gửi kèm mọi API làm `createdBy` |
| Toggle **LV50 & NHẬP MÃ MỜI** | `Mod_Farm_InviteMode` = `LV50` | Set target level = 50, **khóa** ô sửa |
| Toggle **LV200 & FARM MÃ MỜI** | `Mod_Farm_InviteMode` = `LV200` | Set target level = 200, **khóa** ô sửa |
| Toggle **DEBUG KẾT QUẢ FARM** | `Mod_Farm_DebugResult` (mặc định **1**) | OFF → ẩn nút [KQ], bỏ qua mọi ghi file KQ |

Hai toggle LV50/LV200 **loại trừ nhau**; tắt cả hai → `Mod_Farm_InviteMode = NONE`, trả
quyền sửa target level như cũ.

**Việc cần rà kỹ cho toggle Debug:** phải bọc điều kiện ở *tất cả* điểm ghi file KQ —
`SaveAccountTimeRecords`, `account_level_details.json`, `farm_success_accounts.txt`,
`farm_failed_accounts.txt`, `FinalizeAccountTimeOnGoal/Failed`, nút nổi [KQ] và panel
`ModKqResultPanel` (Main.lua ~717–1994, ~1307–1380).

---

## 2. P5a — HẠ TẦNG HTTP (LÀM TRƯỚC, TEST RIÊNG)

Viết vào `EmmyluaDebug.lua`, đặt cạnh `MD5`/`UrlEncode` (sau dòng ~3520).

```
_G.Mod_FarmApi_ParseJSON(str)              -- port từ bản client dòng 11809
_G.Mod_FarmApi_Get(url, onDone)            -- onDone(ok, obj, rawText)
_G.Mod_FarmApi_PostJson(url, bodyTable, onDone)
_G.Mod_FarmApi_Sign(partsTable, ts)        -- MD5(nối tham số + ts + SALT)
_G.Mod_FarmApi_Now()                       -- unix giây, ưu tiên Time.GetServerSecondTime()
```

**POST JSON trên XLua** (chưa từng dùng ở dự án này — phải kiểm chứng):
```lua
local req = CS.UnityEngine.Networking.UnityWebRequest(url, "POST")
local bytes = CS.System.Text.Encoding.UTF8:GetBytes(jsonStr)
req.uploadHandler = CS.UnityEngine.Networking.UploadHandlerRaw(bytes)
req.downloadHandler = CS.UnityEngine.Networking.DownloadHandlerBuffer()
req:SetRequestHeader("Content-Type", "application/json")
req.timeout = 10
```
Poll `req.isDone` bằng `Timer.StartLoop(0.05, 200, ...)` theo đúng khuôn
`Mod_FetchSvipConfigFromAPI` của bản client (dòng 11969).

**Chuỗi ký phải khớp server (P1 đã chốt):**

| API | Nối theo thứ tự |
|---|---|
| GET inviter | `email + serverId` |
| inviter/report | `email + serverId + roleId + inviteCode + gameInviteNum` |
| invite/claim | `email + serverId + deviceId` |
| invite/result | `email + serverId + status` |

rồi `MD5(chuỗi .. ts .. FARM_SECRET_SALT)`. Salt phải **giống hệt** biến môi trường
`FARM_SECRET_SALT` bên web.

---

## 3. P5b — THU THẬP THÔNG TIN TRONG GAME

Một hàm duy nhất, không gửi gói tin, an toàn gọi bất cứ lúc nào:

```
_G.Mod_FarmInvite_CollectInfo() -> table
```

Toàn bộ nguồn dữ liệu đã được xác minh thật (tài liệu mẹ mục 2), tái sử dụng code
từ `excute_test/test_scripts/test_invite_code_rong_vang.lua`:

| Trường trả về | Lấy từ | Dự phòng |
|---|---|---|
| `code`, `num`, `isCode` | `QuickFind:GetTask_EarlyGoldManager():GetVerifyData()` | `nil` nếu chưa có gói 1029 |
| `roleId`, `roleName`, `level` | `ViewData.meData.id/.name/.level` | `RoleManager.me` |
| `serverId`, `serverName` | `_G.GetActualCurrentServerInfo()` | `LoginData.serverId` / `GetServerName()` |
| `unboundGold` | `BagInfoData.CoinInfos[1000020]` | 0 |
| `unboundDiamond` | `BagInfoData.CoinInfos[1000030]` | 0 |
| `email`, `password` | `GetCurrentAccount()` | — |
| `canGenCode` | `cfg_Function_functionManager:TryGetValue(5100001,"id")` + `ConditionManager.Check4D` | false |
| `deviceId` | mã máy của bản Farm | `LoginData.account` |

Mọi truy cập bọc `pcall`, thiếu trường nào trả giá trị mặc định — **không được để
nil làm vỡ luồng farm**.

Kèm `_G.Mod_FarmInvite_WaitVerifyData(maxSec, onDone)`: poll `GetVerifyData()` mỗi 1s,
tối đa 10s (server tự đẩy gói 1029 khi vào game).

---

## 4. P5c — LUỒNG LV200 (INVITER)

Tách hàm `_G.RunInviterStep(onDone)`, gọi trong `OnAccountReachLevelGoal` **ngay trước**
`local nextAccIdx = curAccIdx + 1` (Main.lua:2435). Dù kết quả thế nào cũng gọi `onDone()`
để tiếp tục chuyển acc.

1. Chờ `GetVerifyData()` (≤10s).
2. `code` rỗng **và** `canGenCode` → `networkRequest.ReqRoleCode()` → poll tới khi có mã (≤10s).
3. Thu thập dữ liệu bằng `Mod_FarmInvite_CollectInfo()`.
4. `POST /api/v1/farm/inviter/report`.
5. Lỗi mạng → đẩy vào hàng đợi gửi bù, **vẫn chuyển acc**.

**Tùy chọn (khuyến nghị):** trước khi login một acc ở chế độ LV200, gọi
`GET /api/v1/farm/inviter` — nếu `COMPLETE`/`DONE` thì bỏ qua acc, khỏi tốn thời gian login.

---

## 5. P5d — LUỒNG LV50 (INVITEE)

Tách hàm `_G.RunInviteeStep(onDone)`, cùng điểm chèn.

1. Chờ `GetVerifyData()` (≤10s).
2. `isCode == true` → acc đã nhập mã từ trước → `POST invite/result` với `ALREADY_USED` → chuyển acc.
3. `POST invite/claim` → nhận `inviteCode`. Trả `NO_CODE` → ghi nhận, chuyển acc (vòng sau thử lại).
4. Hook tạm `UIManager.Show` bắt popup lỗi (`args.textContent`), rồi
   `networkRequest.ReqRoleVerifyCode(inviteCode)`.
5. **Poll `GetVerifyData().isCode` mỗi 1s, tối đa 10s** — KHÔNG dựa vào một lần chờ 3s
   (lần test thật timer 3s không chạy):
   - `isCode` false → true → `SUCCESS`
   - Bắt được popup lỗi → `FAILED` + `errorMsg`
   - Hết 10s vẫn false → `FAILED` ("timeout")
6. `POST invite/result` → **gỡ hook** → chuyển acc.

> Hook `UIManager.Show` **bắt buộc phải gỡ** trong mọi nhánh thoát, kể cả nhánh lỗi.

---

## 6. CHỐNG NGHẼN (BẮT BUỘC)

- Timeout từng bước: chờ VerifyData 10s, tạo mã 10s, xác minh 10s, HTTP 10s.
- API lỗi → **không chặn farm**: ghi payload vào `persistentDataPath/farm_invite_pending.json`,
  gửi bù ở lần có mạng kế tiếp.
- Mọi nhánh thoát đều gọi `onDone()` đúng **một lần** (dùng cờ `hasFinished` như bản client).
- Không log/QuickMsg thừa; log debug chỉ khi toggle Debug bật.

---

## 7. THỨ TỰ TEST BẰNG `input.txt` + NÚT EXEC

Làm tuần tự, **xong bước nào mới sang bước sau**. USER tự push và bấm EXEC.

| # | Script test | Mục tiêu | Đạt khi |
|---|---|---|---|
| T1 | `test_farm_collect_info.lua` | Chỉ đọc — dump toàn bộ trường ở mục 3 | Đủ trường, không nil ngoài ý muốn |
| T2 | `test_farm_http_get.lua` | Gọi `GET /api/v1/farm/inviter` | Nhận JSON, sign hợp lệ (không lỗi 401) |
| T3 | `test_farm_http_post.lua` | Gọi `POST inviter/report` | **Kiểm chứng POST JSON chạy được trên XLua** |
| T4 | `test_farm_inviter_flow.lua` | Acc Lv200 thật: tạo mã + report | Web hiện đúng mã và số người mời |
| T5 | `test_farm_invitee_flow.lua` | Acc Lv50 thật: claim + verify + result | `isCode` false→true, DB `SUCCESS` |

Chỉ sau khi T1–T5 đạt mới đưa code vào `EmmyluaDebug.lua` / `Main.lua`, rồi kiểm cú pháp:
`lua53\luac53.exe -p <file>` qua `executor.ps1`.

---

## 8. CÂU HỎI CẦN USER CHỐT TRƯỚC KHI CODE P5

1. **URL API gốc** của web (vd `http://x.x.x.x:3000`) để nhúng vào bản Farm?
2. ~~**`deviceId`**~~ → **ĐÃ CHỐT (T1):** `SystemInfo.deviceUniqueIdentifier`.
3. Hết danh sách acc: USER đã chốt **nghỉ X phút rồi quay vòng** — **X = bao nhiêu phút?**
4. Có bật sẵn tùy chọn `GET inviter` trước khi login để bỏ qua acc đã COMPLETE không?
5. Có cần tăng `_G.Mod_Version` cho bản Farm không (câu hỏi mở 9.5 tài liệu mẹ)?
