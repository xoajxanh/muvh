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

## 2026-11-21 (5): VIEC 1 - bo cuc nut panel
- Panel cao 590 -> 710, danh 120px duoi day cho 2 hang nut.
  Them `DY = 120` + `YY(y, boQuaDY)` trong 3 helper Khung/Chu/Nut va DatO
  -> moi widget cu TU dich len 120, khong phai sua tay hang tram toa do.
  Hai hang nut moi truyen `boQuaDY = true` de dung toa do that.
- Hang y=72: 3 cum chinh so [-] <nhan> [+]: Lv Bo NH | % Vuot Thu | Delay Nu Hoang.
  Dung dung bien toan cuc + PlayerPrefs cua ban cu -> logic farm khong doi.
- Hang y=18: 2 nut gat AUTO HL / AUTO QTQ, dan deu (376px moi nut).
- GOP Bat dau + Tam dung thanh MOT nut (x=12, w=600):
  dang dung -> "▶ BAT DAU" (xanh); dang chay -> "■ KET THUC" (do).
- Nut kich thuoc day ra sat vien phai (x=624, w=144), nhan gon lai "CO 1.0x",
  mau xam chim vi khong phai hanh dong chinh.

## VIEC 2 (da chot, CHUA lam): bo Jobs -> chon Mode + Server + So luong
- Chon Mode: Cay Lv200 / Cay Lv50.
- Server: DROPDOWN (cuon duoc neu nhieu) + nut TAI LAI de fetch lai danh sach
  khi duoc giao moi, khong phai tat app hay dang nhap lai.
- Lease 15 phut, nhip tim 60s gia han CA LO.
- Giu ca lo: may 3 mo len -> pool rong -> bao "con 0 tai khoan".
- Can them cot leaseDeviceId / leaseDeviceName / leaseUntil vao kho acc.
- Claim bang MOT cau UPDATE ... OUTPUT (UPDLOCK, READPAST) -> 2 may bam cung luc
  khong the nhan trung.

## 2026-11-21 (6): VIEC 2 - phan WEB da xong
2.1 DB (raw SQL trong ensureInitialSeed, lib/farm-schema.ts -> FARM_KC_LEASE_SQL)
    - FarmInviterPlay / FarmInviteePlay: them leaseDeviceId, leaseDeviceName, leaseUntil
    - index (serverId, status, leaseUntil) phuc vu claim
    - schema.prisma: them 3 field tuong ung
2.2 GET /api/v1/farm/pool?mode=200|50
    - tra danh sach SERVER duoc giao + tong / daXong / dangGiu (may khac) / conLai
    - phuc vu dropdown server + nut Tai lai
2.3 POST /api/v1/farm/lease-claim
    - UPDATE TOP (n) ... OUTPUT voi (UPDLOCK, READPAST) -> 2 may khong nhan trung
    - thieu thi INSERT ... SELECT tu kho cho acc chua tung chay tren server do
    - lease 15 phut, ky = MD5(username + serverId + soLuong + ts + SALT)
2.4 POST /api/v1/farm/lease-keep
    - gia han ca lo (nhip tim) hoac nha ngay khi bam KET THUC (nha: true)
    - chi dong vao dong CHINH MAY NAY dang giu
    - ky = MD5(deviceId + serverId + ts + SALT)

CON LAI: 2.5 panel MOD (chon Mode + dropdown Server + so luong + nut Tai lai)

## 2026-11-22: doi khai niem panel - MOD cho KHACH TU CAY
- "DANH SACH CONG VIEC DUOC CAP" -> "THIET LAP PHIEN CAY"
  + dong phu "chon che do, may chu va so tai khoan muon cay".
- Bo DAI ACC STT -> o NHAP SO LUONG: [-] [so] [+] kem nut -10 / +10,
  nho vao PlayerPrefs `Mod_FarmKc_SoLuong`. Nhan ben canh hien
  "(con N tai khoan chua cay)".
- Nut BAT DAU xuong DUOI CUNG, rong het be ngang (12..768).
  Thu tu tu day len: BAT DAU (y14) -> AUTO HL/QTQ (y72) -> 3 cum chinh so (y124).
  Panel 780x770, DY = 180.
- Nut "CO 1.0x" -> TAI NHO nho ra khoi mep TREN PHAI panel (680, 770, 88x26),
  khong con la nut ben trong panel.
- Bo dong goi y "Bam the cong viec de xep hang [1] [2]...".
- Doi chu: "DANG NHAP & TAI JOBS" -> "DANG NHAP"; "RESET DAI JOB" -> "⟳ TAI LAI";
  "cong viec" -> "may chu" trong cac thong bao; bo nhan "/api/v1/farm/jobs" o header.

## 2026-11-22 (2): sua nut Co + panel tran man hinh
- Nut CO: tu goc TREN phai (bi che, qua to) -> TAI NHO dan vao VIEN PHAI phia DUOI
  (x = 780 = be ngang panel, y = 188, 46x40). Nhan rut gon con "1.0x".
- Panel 770 bi TRAN man hinh (hang Username bi cat o tren).
  The trang thai thu tu (12,86,756,226) -> (12,128,756,184): bo 42px trong o day.
  Panel 780x770 -> 780x728.

## 2026-11-22 (3): panel rong hon, thap hon, so lieu theo phien
1. Panel 780x728 -> 880x630. Mo rong ngang +100 cho moi khoi (the 856, dong chu 832,
   luoi may chu RONG 183 -> 208, nut day 426/856, 3 cum chinh so rong 282).
2. Nen doc: nhom tren (y>=324) tru 140, noi dung the trang thai tru 128
   -> bo khoang trong 140px giua the trang thai va hang nut.
   Header 552 -> 412. Panel cao 630 => zoom 1.5x = 945, 1.2x = 756.
3. So lieu tinh THEO PHIEN khach dat, khong theo ca kho:
   soPhien = so luong khach nhap (0 = lay het kho, va khong vuot qua kho con lai)
   daXongPhien / conLaiPhien / khoConLai. Thanh progress theo phien.
   `DatSoLuong` goi `Mod_FarmKc_CapNhatPanel` -> bam +/- la so doi ngay.
4. Thong tin duoi viet lai cho MOD tu chu:
   - "Job: XXX | Tien do" -> "Phien cay: Lv50 · S520 | Tien do: 0/5 (0%)"
   - 2 dong muc tieu Lv50/Lv200 -> "Phien nay: X xong · Y con lai · N tai khoan da dat"
     + "Kho cua ban con Z tai khoan chua cay tren may chu nay"
   - Nut CO chuyen sang vien phai, y=120.

## 2026-11-22 (4): sua 6 diem panel
1. Nut TAI LAI de len o Server -> chuyen len HANG TIEU DE (764,310,92x26);
   lblTongJob thu ve (600,312,160); o Server tra lai do rong (666,192,190).
2. TAI LAI nay thuoc khu "THIET LAP PHIEN CAY" dung nghia.
3. So luong KEP theo kho con lai: `Mod_FarmKc_KhoConLai` cap nhat moi lan CapNhat;
   `DatSoLuong` khong cho vuot, va CapNhat tu keo o nhap ve dung tran neu da vuot.
   Nhan ben canh: "(toi da N - kho con N)".
4. Dong "Phien cay" da co may chu: "Phien cay: Lv50 · S520 | Tien do: x/y (z%)".
   Chua chon -> "chua chon - bam mot may chu phia tren".
5. MOI GIA LAP CHI MOT PHIEN: bo han hang doi nhieu viec.
   Bam the khac -> thay the the cu. Bam lai the dang chon -> bo chon.
   Dang chay thi KHONG cho doi phien (phai bam KET THUC truoc).
   Nhan the: "▶ S520 · Lv50 (con 25 acc)" / "✓ S520 · Lv200 (da xong)".
   Bo mau xanh duong xep hang va so thu tu [1][2].
6. Tac vu noi dung so lieu that:
   "May chu nay con N tai khoan chua cay · phien nay cay M".

## 2026-11-22 (5): LOI GOC - panel dung 2 bo closure
Trieu chung: the may chu SANG XANH LA (da chon) nhung dong duoi van bao
"Phien cay: chua chon", "Trang thai: Cho dang nhap", va o so luong khong bi kep
theo kho (nhap 32 trong khi toi da 25).
Nguyen nhan: `InitEmmyluaDebug` chay lai -> tao BO CLOSURE MOI (nut bam thuoc bo
moi), nhung vong lap panel bi khoa boi `if not _G.Mod_FarmKc_PanelLoop` nen van
giu `CapNhat` cua lan DAU -> doc `vieEcDangChon` cua instance cu, luon nil.
Keo theo `Mod_FarmKc_KhoConLai` khong bao gio duoc set -> DatSoLuong het kep.
Sua: vong lap goi `_G.Mod_FarmKc_CapNhatPanel()` (luon tro ban moi nhat)
thay vi goi thang `CapNhat` cua closure cu.
Them: phan biet "Chua chon may chu" (da dang nhap) vs "Cho dang nhap".

## 2026-11-22 (6): sua triet de + noi so luong vao luong chay
1. `vieEcDangChon` -> `_G.Mod_FarmKc_Job`, `dsViec` -> `_G.Mod_FarmKc_DsViec`.
   Panel dung lai nhieu lan sinh nhieu bo closure; bien LOCAL bi ket o bo cu nen
   nut bam (bo moi) va dong trang thai (bo cu) noi hai dang khac nhau.
   Dua ra _G thi moi bo doc cung mot cho - het lech.
2. Bo chu thua: chua chon may chu thi de TRONG, khong in "chua chon ...".
   Nhan trang thai chi hien khi co nghia (Dang chay / San sang).
3. `TranSoLuong()` doc thang tu `_G.Mod_FarmKc_Job` -> o nhap luon biet tran
   ke ca khi CapNhat thuoc bo closure khac.
4. GOC CUA "CHAY LUNG TUNG": so luong khach nhap TRUOC DAY KHONG anh huong gi
   toi danh sach acc. `NapAccTuWeb` nay CAT danh sach con dung N acc dau va luu
   `_G.Mod_FarmKc_SoAccPhien`.
5. Nut BAT DAU NAP LAI danh sach theo so luong hien tai roi moi chay
   (khach co the doi so luong sau khi chon may chu).

## 2026-11-22 (7): hien ro acc dang chay + tien do
- Dong "Dang chay" nay co du: #STT, EMAIL (mau xanh), Cay Lv x/y, Server, Che do,
  va "Hoan thanh: X/Y" voi Y = so acc cua phien (Mod_FarmKc_SoAccPhien).
- Du phong email: neu danh sach acc chua nap kip thi lay `Bot_ActiveSessionEmail`
  -> dong nay khong con hien "--" trong khi bot dang chay.
- `coDsWeb` khong con phu thuoc viec da chon the may chu hay chua.
- Dong "Phien cay" hien ca khi Bot_Running du the chua ve lai; zz lay
  Mod_FarmKc_SoAccPhien thay vi JobTong (tong ca dai).

## 2026-11-22 (8): xong phien phai DUNG + dong "Dang chay" bi trong
1. GOC CUA "CHAY LUNG TUNG": `LoopWhenDone = true` -> cay xong N acc la NGHI 10 PHUT
   ROI QUAY VONG, chay lai chinh nhung acc vua cay (dat 1 acc ma cay di cay lai).
   - Doi mac dinh `LoopWhenDone = false`.
   - Chan them trong `FarmKc_HenQuayVong`: dang chay mot PHIEN
     (`Mod_FarmKc_SoAccPhien > 0`) thi KHONG BAO GIO quay vong.
2. `Mod_FarmKc_ViecKeTiep` khi xong KHONG con xoa `Mod_FarmKc_Job` /
   `Mod_FarmKc_WebAccounts` -> giu nguyen may chu da chon, moi dong thong tin
   van hien, khach bam BAT DAU la chay me moi.
3. Dong "Dang chay" du phong nhieu tang: WebAccounts -> Bot_ActiveSessionEmail
   -> BotAccounts[idx] -> GetCurrentAccount. Dang chay ma chua co email thi bao
   "Dang vao game..." chu khong phai "Chua chay".

## 2026-11-22 (9): viet lai khoi hien thi - moi phan mot pcall rieng
LY DO: ca khoi CapNhat nam trong MOT pcall -> chi can mot loi nho o giua
(widget da bi huy, bien nil...) la TAT CA dong phia sau ngung cap nhat,
panel dung yen khong bao gi. Day la ly do dong "Dang chay" mai khong hien.
NAY: tach nho tung phan, hong phan nao chi mat phan do.

Bo cuc thong tin moi (3 dong):
  Phien cay: Lv50 · S520   |   Tien do: 2/5 (40%)
  Dang chay: #3 accmuvhfang00003@gmail.com   |   Cay Lv: 37/50   |   Che do: Level 50
  Hoan thanh 2 · Con lai 3 · Tong da dat 5 | May chu 520 | Kho con 25
  Thoi gian tai khoan nay: 3p12s
Chua chon may chu -> "Chon mot may chu phia tren de bat dau".
Dang chay ma chua co email -> "Dang vao game..." (mau vang).

## 2026-11-22 (10): doi so luong -> moi con so phai doi theo
- LOI: `tongPhien` uu tien `Mod_FarmKc_SoAccPhien` (so cua phien chay TRUOC)
  nen o nhap 5 ma duoi van hien 0/1.
  NAY: dang chay -> lay SoAccPhien; CHUA chay -> lay SoLuong khach vua chon.
  `daXong` cung chi tinh khi dang chay (chua chay thi phai la 0).
- Dong thong ke them "chay xong phien nay con X" de thay anh huong cua so vua chon.
- Dong Tac vu tu cap nhat theo cau hinh khi bot KHONG chay
  (dat trong CapNhat, vi lblTacVu khai bao SAU DatSoLuong nen de o do la nil).

## 2026-11-22 (11): so lieu kho bi trung va sai
1. "Kho con 25" hien O HAI CHO (canh o nhap va dong thong ke).
   O canh o nhap rut con "(toi da 25)" - chi noi tran khi nhap.
2. "chay xong phien nay con" tinh sai: lay kho - conLaiPhien (25-1=24).
   Dung phai la kho - TOAN BO so da dat (25-2=23).
   Ngoai ra web chi doi `conLai` khi bam TAI LAI, nen kho hien tai phai tru
   them so acc vua cay xong trong phien: kho = khoGoc - daXong.
   Dong Tac vu cung dung con so da tru nay.

## 2026-11-22 (12): KHOA O MUC TAI KHOAN, khong khoa ca may chu
VAN DE: may A chon 5 acc -> may B nhin thay the DO, khong cay duoc gi du kho
con 20 acc. Vi mod van dung `job-claim` (khoa ca dai/may chu).
SUA:
- MOD dung `/api/v1/farm/lease-claim`: xin DUNG N acc, server khoa dung N acc
  do 15 phut. `Mod_FarmKc_NapAccTuWeb` viet lai theo huong nay
  (ban cu giu lai ten `Mod_FarmKc_NapAccTuWeb_Cu`).
- Nhip tim goi `/api/v1/farm/lease-keep` gia han lo dang giu.
- Nut KET THUC goi lease-keep voi `nha = true` -> nha ngay, khong bat may khac
  cho het 15 phut.
- Nut BAT DAU KHONG con goi job-claim (khoa ca may chu).
- The may chu khong con to DO theo `dangChayOMayKhac` va cho bam binh thuong.
- WEB `/jobs` tra them `dangGiu` (acc dang bi may khac lease) va
  `conLai = tong - daXong - dangGiu` -> nhan the hien dung so acc con xin duoc.
