# MU Origin - Mod Project Description

## 1. Directory Structure Update
- `modified_lua_dev_client`: Thu muc chua code Mod Client/Admin moi nhat de dev.
- `modified_lua_dev_customer`: Thu muc chua code Mod Customer moi nhat de dev.
- `modified_lua_admin`: Ban mod day du tinh nang danh cho Admin (Bao gom chuc nang Execute nong Script).
- `modified_lua_client`: Ban mod danh cho Client (Mod_IsAdmin = false).
- `modified_lua_customer`: Ban mod danh cho Khach hang Commercial (Mod_IsDev = false, Mod_IsAdmin = false).

## 2. Cac Tinh Nang Da Mod (Chi tiet ky thuat)

### 2.1. Vuot Anti-Cheat (Root Detection Bypass)
**Vi tri:** `EmmyluaDebug.lua`
**Cach thuc:** Hook vao ham `CS.System.IO.Directory.Exists`.
**Logic:** Thay the ham kiem tra ton tai thu muc cua C#. Khi game kiem tra cac duong dan lien quan den root, ham se tu dong tra ve false, khien game tuong rang may khong bi root.

### 2.2. Mod Menu UI Khung Co Ban
**Vi tri:** `EmmyluaDebug.lua`
**Cach thuc:** Su dung GameObject va cac component cua Unity UI de ve len mot Mod Menu noi tren man hinh. Menu co the keo tha (`EventTrigger`).
**Logic:** Gan UI vao mot `modRoot` GameObject voi `DontDestroyOnLoad` de giu nguyen qua cac map.

### 2.3. Thong Bao Thong Tin Boss & Dich Chuyen (Boss Watch)
**Cach thuc:** Them UI Boss Watch.
**Logic:** 
- Tu dong gui request (`ReqGetBossMapAndCount`, `ReqAncientBossInfo`) de lay thong tin boss thong qua he thong mang.
- Hien thi thong tin boss len man hinh. Nguoi choi co the bam vao the boss de **tu dong dich chuyen** hoac chay toi vi tri cua boss.

### 2.4. Tu dong san Boss Phong Ma Thap (Tower Boss Radar)
**Cach thuc:** Chay ngam radar moi 0.1s.
**Logic:** Kiem tra map Phong Ma Thap, quet entity de tim Boss. Khi thay, tu dong tat AutoFight, chay sat chan Boss va bat lai AutoFight.


### 2.6. Cau Hinh FOV (Field of View)
**Cach thuc:** UI cho phep dieu chinh tang giam FOV.
**Logic:** Thay doi truc tiep thuoc tinh `fieldOfView` cua `CS.UnityEngine.Camera.main` va luu vao `PlayerPrefs('Mod_FOV')`. Su dung Timer de dam bao FOV duoc giu nguyen khi chuyen map.

### 2.7. Cau Hinh Thoi Gian Lam Moi (Refresh Timer)
**Cach thuc:** UI cho phep bat/tat auto refresh va thiet lap chu ky (Interval).
**Logic:** Vong lap ngam se check `Time.GetServerSecondTime()`, neu du thoi gian se gui goi tin request thong tin Boss moi (`AutoRefreshInterval`).

### 2.8. Hack Toc Do (Toc Do Chay & Toc Do Danh)
**Cach thuc:** UI keo/bam de thay doi he so toc do chay va toc do danh.
**Logic:** 
- **Toc chay:** Hook vao `_G.Role.SetMoveSpeed`, nhan tham so truyen vao voi `_G.RunSpeedMultiplier`.
- **Toc danh:** Hook vao `InitFinalAttribute` / `MeData`, can thiep vao thuoc tinh `attackSpeedCalculateValue` nhan voi `_G.AtkSpeedMultiplier`.

### 2.9. Nhat Sieu Toc & Gioi Han So Luong Nhat
**Cach thuc:** Them UI cau hinh auto loot va the hien trang thai Kundun.
**Logic:**
- **Nhat sieu toc:** Bo qua delay nhat mac dinh bang viec check truc tiep item rot ra va thuc hien nhat luon (Instant Pick / Batch Loot).
- **Gioi han & Dem so luong:** Hien thi so lan nhat hien tai / gioi han (Limit). Khi full thi hien thi `(Hien)`. Co the tu thiet lap `_G.AutoPick_Limit` va bam nut Reset Luot Nhat.

### 2.10. He Thong Ban Quyen Khach Hang (Token Auth System)
**Vi tri:** `EmmyluaDebug.lua`
**Logic:**
- Khach hang phai co Token moi bat duoc Mod Menu.
- Token duoc sinh ra dua tren `DeviceID` cua dien thoai, thoi gian het han, va bam MD5 Signature (`CS.PCUtility.Md5`), sau do Encode Base64 (Thuan Lua).
- `DeviceID` se hien thi noi bat tren panel khach hang, kem nut Copy.

### 2.11. Admin Control Panel (Chi co o ban Admin)
*(Ghi chu: Thay the va nang cap cho chuc nang Execute Script cu)*
**Logic:** Bam nut `ADMIN` mau cam de mo bang dieu khien. Bap gom 2 cong cu chinh:
1. **Execute Script:** Chay bytecode doc tu file `input.luac`, giup test code lua nhanh ma khong can build lai game.
2. **Tao Token:** Sinh Token ban quyen cho khach truc tiep trong game. Paste ID cua khach, chon so ngay su dung, bam sinh Token. Token se tu dong duoc Encode Base64, hien thi ket qua va copy luon vao Clipboard.

### 2.12. Hook Mang (Network Debugging)
**Vi tri:** `NetMsgPreverifying_Map.lua`
**Logic:** In ra log cac goi tin gui len/nhan ve lien quan den map.

## 3. He Thong Build (build_and_update.ps1)
**Cach thuc hoat dong:** Script se tu dong build 2 ban `admin` va `customer` dua theo bien moi truong `LUA_SRC_DIR`.

## 4. Test Execute Script (push_test.ps1)
**Vi tri:** `final/excute_test/push_test.ps1`
**Cach thuc:** 
- Dat code can test vao `input.txt`.
- Chay `push_test.ps1` de compile thanh 32-bit va patch header.
- Script tu day qua adb vao thiet bi roi cho ban bam nut EXECUTE trong game ban Admin.
- Nhan Enter tren console de keo file `output.txt` tu thiet bi ve va xem ket qua tren may tinh.
