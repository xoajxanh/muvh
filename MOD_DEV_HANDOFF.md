# MU Origin - Mod Development Handoff & Architecture

## 1. Mod Menu Architecture
The custom Mod Menu is injected via `EmmyluaDebug.lua`.
- **UI System**: Utilizes `_G.Main_GMToolUI` (if available) or raw `CS.UnityEngine.GUI` for drawing on-screen menus.
- **Entry Point**: The mod initializes through `EmmyluaDebug.lua` which is required or injected early in the loading process.

## 2. Directory Blocker (Security Bypass)
- **Goal**: Prevent the game's anti-cheat from detecting root/mod directories.
- **Implementation**: Hooked `CS.System.IO.Directory.Exists`.
- **Target Directories**: `/data/local/su`, `/system/app/Superuser.apk`, `/system/bin/failsafe/su`, `/system/bin/su`, `/system/sd/xbin/su`, `/system/xbin/su`, `/data/local/xbin/su`, `/data/local/bin/su`, `/system/bin/cufsdosck`, `/system/xbin/cufsdosck`, `/system/bin/cufsmgr`, `/system/xbin/cufsmgr`, `/system/bin/cufaevdd`, `/system/xbin/cufaevdd`, `/system/bin/conbb`, `/system/xbin/conbb`, `Superuser`, `Supersu`, `/su/bin/su`.
- **Result**: The game will see these directories as non-existent, bypassing basic root checks.

## 3. Workflow for Modding
1. **Decompile**: Lua scripts are extracted from the Unity AssetBundle (`lua.mu2`) using a tool like AssetStudio. The raw `.bytes` files are decompiled using `unluac` (or similar) into readable `.lua` files in the `final/extracted_lua/` directory.
2. **Setup Mod Project**: Use VSCode with EmmyLua extension. Mount the `final/extracted_lua/` as a workspace for code navigation.
3. **Chỉnh sửa Mod**: Dựa vào code đã decompile, tiến hành sửa đổi logic, chèn giao diện Mod Menu, Hook vào các hàm hệ thống (như trong `EmmyluaDebug.lua` và `Main.lua`), và lưu vào thư mục `final/modified_lua/`.
4. **Biên dịch (Compile)**: Sử dụng `luac53.exe` để biên dịch lại các file Lua đã sửa thành bytecode (phiên bản Lua 5.3, format 32-bit `size_t`) thông qua script `compile_lua.py`.
5. **Đóng gói (Pack)**: Gắn đè các file bytecode vừa biên dịch vào trong file AssetBundle `lua.mu2` gốc thông qua script `pack_lua.py`, sinh ra một file `lua.mu2` mới.
6. **Build và Update APK**: Chạy kịch bản `build_and_update.ps1` để tự động tính toán lại dung lượng và MD5 của file `lua.mu2` mới, cập nhật vào file `bundles.txt`, và cuối cùng dùng WinRAR chèn đè `lua.mu2`, `bundles.txt`, cùng `Bundles` v158 vào bên trong file `MU.apk` gốc.

## 4. File Locations & Scripts
- **Decompiled Lua**: `final/extracted_lua/`
- **Modified Lua**: `final/modified_lua/`
  - `EmmyluaDebug.lua`: Contains the Mod Menu UI, Directory Blocker, and Hooks.
  - `Main.lua`: Initial entry points (if needed).
- **Compiler/Packer**: `build_and_update.ps1` (Main orchestrator), `compile_lua.py`, `pack_lua.py`.
- **Bundle File**: `final/new_lua/lua.mu2`

*Note: Always ensure `bundles.txt` inside the APK matches the actual size and MD5 of the `lua.mu2` inside the APK, or the C# AssetBundle loader will throw an exception and hang at the logo.*

## 5. Current Task State (v6 - Tower Boss & Fire Dragon Radar)
- **Goal:** Tự động hoá săn Boss Tháp (Phong Ma Tháp) và săn Hoả Long, cải thiện giao diện Mod.
- **Progress (v6):**
  - **Boss Tháp (Map 1059***):** Đã hoàn thiện logic rà quét Boss tự động bằng Radar ngầm (`_G.Timer.StartLoop` mỗi 0.1s). Khi vào map Tháp, radar tự động quét cho đến khi Boss sinh ra (`hp > 0`). Nhân vật sẽ tự tắt AutoFight, chạy tới sát chân Boss (phạm vi 2), và bật lại AutoFight để cắn. Đã khắc phục lỗi đứng im do va chạm quái.
  - **Hỏa Long:** Cập nhật nút bấm [ TÌM HỎA LONG ] sử dụng logic `MoveTo` tương tự Boss Tháp (ngắt AutoFight -> Chạy tới toạ độ Hỏa Long -> Bật lại AutoFight khi đến nơi).
  - **Kundun UI:** Sửa lỗi hiển thị UI Kundun. Phục hồi logic chuẩn của game, hiển thị `(Max)` khi người chơi đạt giới hạn số lần nhặt trong ngày để tránh hiển thị bộ đếm rác. Căn chỉnh lại khoảng cách UI để các nút không bị đè lên nhau.
  - **Thực thi script (Exec):** Đưa nút EXEC ra màn hình chính, làm nút hình vuông màu đỏ nằm thẳng hàng phía trên nút Mod để kích hoạt script nóng từ `input.luac` (hữu ích cho việc Dump và test nhanh).
- **Next Step:** Tiếp tục theo dõi phản hồi từ người dùng về radar bắt Boss Tháp và Hỏa Long. Nếu ổn định, có thể mở rộng logic Radar này cho các Boss map dã ngoại hoặc sự kiện khác. Bản lưu trữ hiện tại đang được khoá cứng ở thư mục `final/modified_lua_v6/`.
