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
| 14 | **Tự mua gói bằng Kim Phiếu** | `ReqUseItem` — đã test thật: 30.000 → 5.000 |
| 15 | **Tự nhận thư sau khi mua** | Chỉ thư nạp (`rechargeId ≠ 0`), không đụng thư khác |
| 16 | **Dọn popup "Nhắc nhở"** | Tự bấm Xác nhận, tránh treo bot |
| 17 | **B2 — Bỏ qua acc đã đủ 5 người** | Hỏi web trước khi đăng nhập; web lỗi thì vẫn login bình thường |
| 18 | **B1 — Nút gạt DEBUG KẾT QUẢ FARM** | Chặn 5 cửa ngõ ghi file + ẩn nút [KQ] |

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

→ Gọi: `networkRequest.ReqUseItem(giá, <id ô Kim Phiếu>, { "mã gói" })`

⚠️ **`clientParams` PHẢI là mảng CHUỖI**, truyền số sẽ lỗi:
`bad argument #2 to 'encode' (string expected for field 'clientParams', got number)`
Công cụ bắt gói tin in ra `clientParams={1=100001}` nhìn như số, nhưng thực tế là chuỗi.

⚠️ **`itemId` là `id` của Ô trong túi** (vd `5945036051196359711`), lấy qua
`BagInfoData.GetItemByConfigID(1000250).id` — KHÔNG phải mã vật phẩm `1000250`.

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

## FIX 2026-11-18: treo o man dang nhap
- Nguyen nhan: `LoginCurrentSelectedAccount` goi lai chinh no trong callback kiem tra bo qua -> de quy vo tan (treo ca khi tat 2 nut gat).
- Da sua: tach phan dang nhap that ra `FarmKc_DangNhapThat()`; truong hop khong bo qua goi ham do, KHONG goi lai `_G.LoginCurrentSelectedAccount()`.
- Them `FarmKc_DonPopup()` vao `RunInviteeStep` (2 cho) de don popup Nhac nho.
- Da kiem cu phap: Main.lua OK, EmmyluaDebug.lua OK.

## FIX 2026-11-19: watchdog chong treo popup
- Trieu chung: popup "Nhac nho" (PromptTipUI) hien giua man dang nhap, co nut Xac nhan, bot dung han.
- Nguyen nhan: thong bao ket qua acc duoc game render thanh popup CHAN; khong luong nao dang chay de don no.
- Da them `_G.FarmKc_BatWatchdogPopup()` trong EmmyluaDebug.lua: vong lap nen 5s, popup hien lien tiep 2 nhip (>=10s) thi tu bam Xac nhan + ep an.
- Goi tai 2 diem trong Main.lua: dau `StartAutoFarmBot` va dau `LoginCurrentSelectedAccount` (co co chay 1 lan).
- CAN TEST: chay lai bot, de popup hien, sau ~10s phai tu tat va bot chay tiep.

## FIX 2026-11-19 (2): vong lap "Dang nhap bat thuong"
- Log that: `SDK Login that bai: Phat hien hanh vi dang nhap bat thuong`.
- Popup "Nhac nho" chinh la thong bao loi nay tu server, KHONG phai bo dem 5s.
- Code cu: loi SDK -> chi Log roi return -> man Splash kich hoat lai -> thu lai ngay -> bi chan tiep -> vo tan.
- Da them `FarmKc_XuLyLoiSdkLogin()` (Main.lua ~8104): cho 60s -> 180s -> 300s; qua 3 lan thi bo acc, sang acc ke tiep.
- Guard dau `StartFullLoginProcess`: dang cho thi return, khong cho Splash dap lai server.
- Login thanh cong -> reset `FarmKc_SdkLoiDem = 0`.
- Giu `Bot_IsInGameWorld` guard o FlashAccTimeCenterAlert va watchdog popup lam luoi an toan.

## FIX 2026-11-19 (3): chong phat hien bot khi dang nhap
- (1) device_id cu hard-code MD5("muvh_bot_device_equip_uuid_001") dung chung CA DAN ACC.
  Nay `FarmKc_VanTayThietBi(email)` = MD5(email|salt) -> moi acc mot thiet bi, on dinh qua cac lan.
- (2) `device_name` + do phan giai chon tu 12 may Android pho bien, cung bam theo email cho khop nhau.
  (Truoc day tat ca deu bao SM-G975F / 1920*1080 - do phan giai nay con KHONG PHAI cua S10+.)
- (3) Gian thoi gian chuyen acc 2.5s -> ngau nhien 20-60s, tai 5 diem goi StartFullLoginProcess.
- Ghi them dong log `[FARM KC] Thiet bi: <ten> | <res> | did=<12 ky tu dau>` de kiem chung.
- LUU Y: cac cho goi FarmKc_DelayChuyenAcc nam TRUOC dong khai bao nen phai goi qua _G voi fallback 2.5.
- CON LAI: proxy cho may ao (anh tu setup sau).

## 2026-11-20: cong cu chan doan treo
- Nut LOGIN goi ban `LoginCurrentSelectedAccount` LOCAL trong EmmyluaDebug.lua (dong 1918),
  KHONG phai ban trong Main.lua -> log them o Main.lua khong bao gio chay khi bam nut.
- Them `_G.FarmKc_Nhat(msg)`: Log + SaveOutput ngay (Log don thuan chi nam trong RAM).
- Them log 5 buoc [LOGIN 1/5..5/5] vao dung ban ma nut goi.
- Them `_G.FarmKc_BatNhipTim()`: moi 60s ghi mot dong [NHIP TIM] trang thai bot.
- `FarmKc_HenQuayVong` nay ghi log ro luc BAT DAU nghi (LoopRestMinutes, mac dinh 10 phut).
- exec_cmd.ps1: kiem cu phap + keo log + loc NHIP TIM / moc quan trong.

## 2026-11-20 (2): chon nhieu viec + khoa viec
WEB
- `/api/v1/farm/jobs`: them co `hoanThanh` (daXong >= tongAcc), tu chot status = DONE,
  viec da xong thi khong con tinh la `dangChayOMayKhac`.
- MOI `/api/v1/farm/job-claim`: khoa NHIEU viec mot luc.
  Body { jobCodes[], deviceId, deviceName, ts, sign }, ky = MD5(jobCodes.join(",") + deviceId + ts + SALT).
  Tra ve { soKhoaDuoc, khoaDuoc[], tuChoi[{jobCode, lyDo, deviceName}] }.
- `/api/v1/farm/job-heartbeat`: nhan them `jobCodes[]` -> gia han khoa cho ca hang doi.
  Chi gia han viec may NAY dang giu hoac chua ai giu; khong dung toi viec may khac / viec DONE.

MOD
- `FarmKc_Api_JobClaim`, `FarmKc_Api_JobHeartbeatHangDoi` (endpoint JobClaim).
- Luoi nut: bam = toggle vao/ra hang doi. Mau: xam=xong (bam khong an), do=may khac giu,
  xanh la=dang chay, xanh duong=xep hang (co so thu tu [1][2]). Nhan hien (daXong/tongAcc).
- `Mod_FarmKc_HangDoi` giu thu tu bam. `Mod_FarmKc_DoiChonViec`, `Mod_FarmKc_ViecKeTiep`.
- Main.lua: 2 diem "hoan thanh tat ca acc" -> goi `Mod_FarmKc_ViecKeTiep()` TRUOC quay vong/dung.
- `Mod_FarmKc_BaoNhipTim` gui kem hang doi de giu khoa.

CAN TEST
- Bam chon 2-3 viec, kiem tra so thu tu [1][2] va mau nut.
- May thu 2 dang nhap cung tai khoan -> cac viec da khoa phai hien DO.
- Chay het viec 1 -> tu sang viec 2, doi dung server/level.
- Viec du acc -> nut xam, bam khong an.

## 2026-11-20 (3): sua theo phan hoi
- LOI "Thieu jobCodes": `FarmKc_ToJson` KHONG ho tro mang -> table con bi tostring()
  thanh "table: 0x...". Da viet lai: nhan dien mang, encode thanh [..], de quy cho table long nhau.
- Khoa viec: BO khoi luc chon, CHUYEN sang nut BAT DAU (`KhoaHangDoi()` ngay truoc StartAutoFarmBot).
  Chon/bo chon thoai mai khong giu cho may khac.
- Muc tieu: GOP theo level -> dung 2 dong, Lv50 va Lv200, cong don tong/daXong cua moi viec
  cung level trong hang doi; server liet ke dang "517,520". Viec dang chay dung so lieu song.
  Label `FkcLblMucTieu` doi tu (20,410,480,24) -> (20,396,480,44) de chua 2 dong.
- Kiem cu phap: cai luaparser tren VM may anh -> tu kiem duoc, khong can nho chay luac.

## 2026-11-21: che do + server theo cong viec web
- ChonViec: NAY dat luon `TARGET_SERVER_ID` + PlayerPrefs `Mod_Farm_TargetServer` theo
  `v.serverId`. Truoc day chon viec S520 ma bot van vao server cu dang nho -> sai server.
- Che do LV200/LV50 da tu bat theo `v.farmLevel` tu truoc (ApplyInviteMode), nay ghi log ro.
- Dong "Dang chay" hien them: `Server: <id>` va `Che do cay: Level 200 | Level 50` (co mau).
- Them log tai diem dat muc tieu: ghi ro che do dang bat va co hay khong RunInviterStep/
  RunInviteeStep -> biet ngay vi sao KHONG bao DB (thuong do che do ma moi dang TAT).

## 2026-11-21 (2): LOI THAT - bao cao bi chan vi sai BANG tai khoan
- Trieu chung: bot chay xong acc Lv200 nhung web van CHUA CHAY, ma moi "chua tao", Vang/KC = 0.
- Log: `[FARM KC] Loi gui bao cao (Username web \) -> da luu cho gui bu`
  (chuoi bi cat o dau nhay; nguyen van: `Username web "longdt" khong ton tai`).
- Goc re: mod dang nhap bang bang **FarmAccount** (/api/v1/farm/jobs), nhung
  `xacThucCreatedBy` trong lib/farm-auth.ts lai tim trong bang **User**.
- Da sua: tim User truoc; khong thay thi tim FarmAccount va lay `createdById` cua no.
- Du lieu KHONG MAT: cac ban ghi that bai nam trong farm_invite_pending.txt tren may ao,
  tu dong gui bu o dau moi RunInviterStep/RunInviteeStep sau khi web deploy xong.
- LAY_LOG.ps1: keo them farm_invite_pending.txt de dem so ban ghi con ton.

## 2026-11-21 (3): nhip tim lam ngap log
- Trieu chung: 40 dong "moc quan trong" deu la [NHIP TIM], moi dong dang doc bi day ra ngoai.
- Nhip tim nay CHI ghi khi co trang thai doi (chay/tamdung/trongGame/acc/che_do/job/
  choQuayVong/choSdk). LEVEL khong tinh la thay doi. Ngoai ra 10 phut ghi mot dong dinh ky.
- LAY_LOG.ps1 tach 3 muc: BAO CAO LEN WEB (quan trong nhat) / MOC KHAC (da bo nhip tim) /
  NHIP TIM (3 dong cuoi).
- Gui bu: ghi ro ban ghi bi vut vi hong, va ket qua "Xong: X thanh cong, Y con lai"
  bang FarmKc_Nhat (ghi file ngay).

## 2026-11-21 (4): them bay chan doan cho gui bu
- Xac nhan: khong co ban ghi nao trong FarmInviterPlay cho 0447 -> dung nhu du doan,
  bao cao bi web TU CHOI nen chua bao gio vao DB.
- `GuiBuPending` co nhanh `else -- Khong biet loai -> bo` VUT IM LANG. Nay ghi ro
  loai doc duoc + 160 ky tu dau cua dong -> khong con mat ban ghi ma khong biet ly do.
- Khi bao cao that bai: in ro `createdBy` gui len va loi day du (bo doc JSON don gian
  cat chuoi o dau nhay escape nen loi hien ra cut: `Username web \`).
- Web: bo `mode: insensitive` (Prisma KHONG ho tro tren provider sqlserver);
  SQL Server da dung collation khong phan biet hoa thuong san.
- Cach phan biet web da deploy ban moi chua, nhin NOI DUNG LOI:
    cu : Username web "longdt" khong ton tai
    moi: Username "longdt" khong ton tai (ca tai khoan web lan tai khoan farm)
