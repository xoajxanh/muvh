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

---

## ⬜ CÒN PHẢI LÀM

### A. Việc gấp — chặn chạy thật

> A1 (test luồng LV50) ĐÃ XONG 2026-11-18.

| # | Việc | Vì sao cần |
|---|---|---|
| A2 | **Quay vòng khi hết danh sách acc** | Đã có cấu hình `LoopWhenDone` / `LoopRestMinutes` nhưng **CHƯA viết code**. Hiện hết acc là bot dừng hẳn |
| A3 | **Gửi bù khi mất mạng** | Hiện chỉ **ghi** vào `farm_invite_pending.txt`, **chưa có code đọc lại và gửi lại** |

### B. Việc nên làm

| # | Việc | Vì sao |
|---|---|---|
| B1 | **Nút gạt DEBUG KẾT QUẢ FARM** | Tắt để giảm ghi file, đỡ lag. Đụng nhiều điểm rải rác trong `Main.lua`, cần rà kỹ |
| B2 | **Bỏ qua acc đã đủ 5 người** | Hỏi web trước khi đăng nhập → acc `COMPLETE` thì bỏ qua, tiết kiệm vài phút mỗi acc |
| B3 | **Chạy thật cả dàn acc** | Kiểm tra: không acc nào vượt 5 lượt, không acc nào kẹt |

### C. Việc để sau (đã thống nhất hoãn)

| # | Việc |
|---|---|
| C1 | Nhận thưởng mốc 1 / 3 / 5 người (`ReqGetGift` 6600001-3) rồi chuyển trạng thái `DONE` |
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

## BẪY KỸ THUẬT ĐÃ GẶP (đừng lặp lại)

| Bẫy | Cách xử lý |
|---|---|
| `Timer.Start` **không chạy** trong mod | Luôn dùng `Timer.StartLoop` |
| `Encoding.UTF8:GetBytes()` **lỗi** trên XLua | Dùng `UnityWebRequest.Put(url, chuỗi)` + đổi method `POST` |
| `UnityWebRequest.Post(...)` **lỗi** mọi biến thể | Không dùng |
| `roleId` bị làm tròn mất số cuối | `tostring()` thẳng, không qua `tonumber()` |
| `LoginData.account` = nil | Tài khoản SDK nằm ở `LoginData.userName` |
