# Mod Development & Deployment Workflow

1. **Target Environment**: Chỉ làm việc trực tiếp trên `final\modified_lua_dev_client`.
2. **Tham khảo & Tái sử dụng Thư viện Modules (`final\excute_test\modules`)**:
   - Trước khi làm bất cứ chức năng gì hoặc viết script test, Agent BẮT BUỘC phải kiểm tra và tham khảo thư mục `D:\MUVH\android\mu-decompiled\final\excute_test\modules` (đọc `README.md` và các file `.lua` / `.md` liên quan) trước tiên.
   - Tái sử dụng tối đa các method chuẩn đã được kiểm định trong `modules` để tránh mất thời gian tìm hiểu lại từ đầu hoặc mắc các lỗi cấu trúc dữ liệu đã biết.
   - Khi xây dựng và kiểm thử thành công một cơ chế/method mới, phải đóng gói bổ sung vào `D:\MUVH\android\mu-decompiled\final\excute_test\modules` (cả `.lua`, `.md` và cập nhật `README.md`) để dùng lại về sau.
3. **Ideation & Planning**: Luôn trao đổi, thảo luận phương án/kế hoạch cụ thể trước với USER. Không tự ý sửa code khi chưa thống nhất.
4. **Development & Approval**: Chờ USER phê duyệt phương án trước khi triển khai code.
5. **Code Commenting & Tagging**: Mọi khối code triển khai logic chức năng mới hoặc sửa đổi PHẢI có chú thích tên chức năng ở đầu logic theo định dạng chuẩn (ví dụ: `-- =========================================================================` / `-- [MOD FEATURE]: <TÊN CHỨC NĂNG>` / `-- Mô tả: ...`) để dễ dàng tìm kiếm (search text).
6. **Cloning & Build Sync**: Development on dev client and dev customer is independent. When building via `build_and_update.ps1`:
   - `modified_lua_dev_client` syncs to `modified_lua_admin` (Admin) and `modified_lua_client` (Client, `_G.Mod_IsAdmin = false`).
   - `modified_lua_dev_customer` syncs to `modified_lua_customer` (Customer, `_G.Mod_IsDev = false`, `_G.Mod_IsAdmin = false`).
7. **Build Phase**: Only trigger the `build_and_update.ps1` script to build the APKs AFTER explicitly receiving the USER's permission to build.
8. **Push Test & Android Device**: USER tự chọn Android Device ID và tự chạy `push_test.ps1` để execute. Agent không can thiệp, không tự tìm Android ID hoặc push all devices, và tuyệt đối không tự ý sửa đổi `push_test.ps1` theo hướng đó.
