# Mod Development & Deployment Workflow

1. **Target Environment**: Chỉ làm việc trực tiếp trên `final\modified_lua_dev_client`.
2. **Ideation & Planning**: Luôn trao đổi, thảo luận phương án/kế hoạch cụ thể trước với USER. Không tự ý sửa code khi chưa thống nhất.
3. **Development & Approval**: Chờ USER phê duyệt phương án trước khi triển khai code.
4. **Code Commenting & Tagging**: Mọi khối code triển khai logic chức năng mới hoặc sửa đổi PHẢI có chú thích tên chức năng ở đầu logic theo định dạng chuẩn (ví dụ: `-- =========================================================================` / `-- [MOD FEATURE]: <TÊN CHỨC NĂNG>` / `-- Mô tả: ...`) để dễ dàng tìm kiếm (search text).
5. **Cloning & Build Sync**: Development on dev client and dev customer is independent. When building via `build_and_update.ps1`:
   - `modified_lua_dev_client` syncs to `modified_lua_admin` (Admin) and `modified_lua_client` (Client, `_G.Mod_IsAdmin = false`).
   - `modified_lua_dev_customer` syncs to `modified_lua_customer` (Customer, `_G.Mod_IsDev = false`, `_G.Mod_IsAdmin = false`).
6. **Build Phase**: Only trigger the `build_and_update.ps1` script to build the APKs AFTER explicitly receiving the USER's permission to build.

