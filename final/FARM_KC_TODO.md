# FARM KC — MÃ MỜI RỒNG VÀNG · DANH SÁCH VIỆC

> Cập nhật: 2026-11-18
> Tài liệu liên quan: `modified_lua_dev_farm/FARM_KC_INVITE_PLAN.md` (kế hoạch gốc),
> `modified_lua_dev_farm/FARM_KC_LUA_PLAN.md` (chi tiết phía Lua + các bẫy đã gặp)

---

## ✅ ĐÃ XONG

| # | Việc | Ghi chú |
|---|---|---|
| 1 | **Database**: 2 bảng `FarmInviter` / `FarmInvitee` | Tự tạo khi web khởi động |
| 2 | **Stored procedure** `sp_FarmClaimInviteCode` | Giữ chỗ 10 phút, chống vượt 5 lượt |
| 3 | **4 API cho game** | GET inviter · report · claim · result |
| 4 | **Ký MD5** giữa game và web | Đã khớp, test thật đạt |
| 5 | **Hạ tầng gọi web trong mod** | GET + POST JSON (dùng `Put` + đổi method) |
| 6 | **Giao diện trong game** | Ô USER WEB + 2 nút gạt LV200 / LV50 |
| 7 | **Luồng LV200** (người mời) | Đã test thật đạt — HTTP 200, DB nhận dữ liệu |
| 8 | **Luồng LV50** (được mời) | Đã test thật đạt 2026-11-18 — isCode đổi true, DB nhận SUCCESS |
| 9 | **Trang web Farm KC** | 1 menu, đổi bảng ACC 200 / ACC 50 bằng nút gạt |
| 10 | **A2 — Quay vòng khi hết acc** | Nghỉ `LoopRestMinutes` phút rồi quay lại acc 1. Bấm dừng bot thì huỷ hẹn |
| 11 | **A3 — Gửi bù khi mất mạng** | Đọc lại `farm_invite_pending.txt`, gửi tuần tự, dòng nào lỗi giữ lại cho lần sau |
| 12 | **Tự nhận Kim Phiếu mốc mời** | Nằm trong luồng LV200, nhận xong đọc lại số rồi mới báo cáo. Trạng thái giữ `COMPLETE` |
| 13 | **Cột Kim Phiếu trên web** | Đọc vật phẩm `1000250` từ túi, hiển thị cạnh cột KC |

---

## ⬜ CÒN PHẢI LÀM

### A. Việc gấp — chặn chạy thật

> A1 (test luồng LV50) ĐÃ XONG 2026-11-18.

| # | Việc | Vì sao cần |
|---|---|---|
> A2, A3 ĐÃ XONG 2026-11-18 (chưa test thật).

### B. Việc nên làm

| # | Việc | Vì sao |
|---|---|---|
| B1 | **Nút gạt DEBUG KẾT QUẢ FARM** | Tắt để giảm ghi file, đỡ lag. Đụng nhiều điểm rải rác trong `Main.lua`, cần rà kỹ |
| B2 | **Bỏ qua acc đã đủ 5 người** | Hỏi web trước khi đăng nhập → acc `COMPLETE` thì bỏ qua, tiết kiệm vài phút mỗi acc |
| B3 | **Chạy thật cả dàn acc** | Kiểm tra: không acc nào vượt 5 lượt, không acc nào kẹt |

### C. Việc để sau (đã thống nhất hoãn)

| # | Việc |
|---|---|
| C2 | Gom menu web thành phân hệ "MOD MU VH" / "FARM KC" + phân quyền theo phân hệ |
| C3 | Trang quản lý phân hệ cho ADMIN (bật/tắt phân hệ) |
| C4 | Bộ lọc nâng cao trên web |
| C5 | Mã hoá mật khẩu acc game trong DB (hiện lưu thô theo yêu cầu) |

---

## 🔧 ĐÃ SỬA — CÔNG THỨC ĐẾM SUẤT MỜI (2026-11-18)

**Lỗ hổng:** công thức cũ `MAX(gameInviteNum, confirmedCount)` lấy giá trị lớn hơn
của hai con số **đo hai thứ khác nhau**:
- `gameInviteNum` = tổng thật lúc acc Lv200 đăng nhập lần cuối
- `confirmedCount` = số lượt web cấp thêm **sau** mốc đó

Hậu quả: acc Lv200 có sẵn 2 lượt mời → web vẫn cấp đủ 5 suất nữa → game nhận **7**,
vượt mốc thưởng cao nhất (5). Hai lượt cuối lãng phí, acc Lv50 mất quyền nhập mã vô ích.

**Đã sửa thành phép cộng:**
```
Tổng đã dùng = gameInviteNum + confirmedCount
```
Khi acc Lv200 đăng nhập lại báo số mới (đã gồm cả phần web cấp) → **reset
`confirmedCount` về 0** để không đếm trùng.

Sửa ở 4 chỗ: stored procedure `claim` · API `inviter/report` · API `invite/result` ·
trang web (cột "Đã mời" hiện `game X + web Y`).

---

## ⚠️ ĐIỂM CẦN BIẾT

**Bảo mật.** `.env.example` trong repo đang chứa thông tin thật (địa chỉ máy chủ DB,
tài khoản `sa`, mật khẩu, `JWT_SECRET`) và đã được đẩy lên GitHub. Nên đổi mật khẩu
`sa` + `JWT_SECRET`, chặn cổng DB chỉ cho máy chủ web, và gỡ file này khỏi git.

**Cookie đăng nhập web.** Đã sửa để chạy được qua HTTP (biến `USE_HTTPS`). Khi chạy
thật nên bật HTTPS và đặt `USE_HTTPS=true`, vì token phiên đi qua mạng không mã hoá.

**Mỗi nhân vật chỉ nhập mã mời được một lần**, không hoàn tác được. Cẩn thận khi test.

**Mã mời chỉ dùng trong cùng server.** Acc Lv50 phải cùng server với acc Lv200.

---

## NHẬN THƯỞNG MỐC MỜI — ĐÃ NGHIÊN CỨU XONG CODE GAME (2026-11-18)

Nguồn: `extracted_lua/InviteReward_ItemTemplate.lua` · `Task_EarlyGoldData.lua`

**Danh sách mốc** không hardcode, đọc từ cấu hình:
```lua
cfg_Global_globalManager:TryGetValue(68000001).effect   -- "6600001#6600002#6600003"
  → tách "#" → cfg_Gift_giftManager:TryGetValue(id)
```

| Mốc | Gift ID | Cần số người mời |
|---|---|---|
| 5.000 Kim Phiếu | `6600001` | ≥ 1 |
| 10.000 | `6600002` | ≥ 3 |
| 15.000 | `6600003` | ≥ 5 |

**Điều kiện nhận:** `VerifyData.num >= targetNum` VÀ chưa nhận.

**Kiểm tra đã nhận:** `RefreshData.GetRefreshByKey(gift.countKey)` → `total == count` là đã nhận.

**Lệnh nhận:** `networkRequest.ReqGetGift({ gift.id })`

**KIM PHIẾU = vật phẩm `itemId 1000250`** (xác minh 2026-11-18 qua `GetBoxItemTbl`):
`6600001` → 5.000 · `6600002` → 10.000 · `6600003` → 15.000 (tổng 30.000).
**KHÔNG nằm trong bảng tiền tệ `CoinInfos`** — phải đọc từ TÚI ĐỒ
(`BagInfoData.GetItemByConfigID(1000250)` hoặc quét `TotalItems`).

**`GetRefreshCountFun` đáng tin:** sau khi nhận, cả 3 mốc đổi `false → true`,
nên bot không gửi trùng.

**Script kiểm chứng:** `test_farm_claim_gift.lua` (VIEW/CLAIM) · `test_farm_find_voucher.lua`
(tìm mã Kim Phiếu) · `test_farm_check_voucher.lua` (kiểm chứng cách đọc)

**ĐÃ KIỂM CHỨNG TRÊN GAME THẬT 2026-11-18** (acc Ace1iw, 5 người mời):
nhận đủ 3 mốc → túi có đúng 30.000 Kim Phiếu → `GetItemByConfigID` và quét
`TotalItems` đều đọc ra đúng số.

> **USER chốt:** khi làm phần này, CHỈ nhận thưởng và ghi nhận số Kim Phiếu về web.
> **KHÔNG chuyển trạng thái sang `DONE`** — giữ nguyên `COMPLETE`, vì còn việc khác
> cần làm trên acc sau khi nhận thưởng.

---

## MUA GÓI BẰNG KIM PHIẾU — ĐÃ GIẢI MÃ (2026-11-18)

**Phát hiện bằng cách bắt gói tin thật**, không phải đọc code (code UI của tab này
không nằm trong bộ đã giải nén):

```
msgId 203003  BagPackage.UseItem
  count        = 25000                      -- số Kim Phiếu tiêu
  itemId       = 5945036051188201481        -- id Ô KIM PHIẾU TRONG TÚI (KHÔNG phải mã 1000250)
  clientParams = { 100001 }                 -- mã gói, trùng rechargeId trong thư
```

→ Gọi: `networkRequest.ReqUseItem(giá, <id ô Kim Phiếu>, { mã gói })`

**Mua gói KHÔNG phải lệnh nạp** (nhóm 20xxx) mà là **dùng vật phẩm** — đây là lý do
dò mãi trong `NetworkRequest_Recharge` không ra.

| Gói | Giá | Mã gói |
|---|---|---|
| 60 kim cương / 25K VND | 25.000 Kim Phiếu | `100001` |

**Vật phẩm mua được gửi QUA THƯ**, phải nhận thư mới vào túi:
`NetManager.Send(MailMessage.ReqGetMailItems, { mailIds = {...}, delete = false })`
Thư nạp phân biệt bằng `rechargeId ~= 0`; còn vật phẩm chưa nhận khi `stateType` là 1 hoặc 3.

**Mở popup Cộng đồng:** `UIManager.Show(UIID.RechargeWelfareUI, { openFirstTab = 4 })`

---

## BẪY KỸ THUẬT ĐÃ GẶP (đừng lặp lại)

| Bẫy | Cách xử lý |
|---|---|
| `Timer.Start` **không chạy** trong mod | Luôn dùng `Timer.StartLoop` |
| `Encoding.UTF8:GetBytes()` **lỗi** trên XLua | Dùng `UnityWebRequest.Put(url, chuỗi)` + đổi method `POST` |
| `UnityWebRequest.Post(...)` **lỗi** mọi biến thể | Không dùng |
| `roleId` bị làm tròn mất số cuối | `tostring()` thẳng, không qua `tonumber()` |
| `LoginData.account` = nil | Tài khoản SDK nằm ở `LoginData.userName` |
