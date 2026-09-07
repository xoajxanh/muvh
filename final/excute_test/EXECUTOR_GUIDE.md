# 🚀 HƯỚNG DẪN DÀNH CHO AGENT (PROJECT RULES & WORKFLOW GUIDE)

Tài liệu này dùng để dán vào prompt hoặc làm Custom Instructions khi mở phiên chat mới để Agent luôn tuân thủ đúng quy trình làm việc chuẩn.

---

## 📋 PROMPT GUIDE CHO PHIÊN CHAT MỚI

```markdown
### ⚡ QUY TẮC PHÁT TRIỂN & THỰC THI (PROJECT AGENT WORKFLOW)

1. **Thực thi lệnh tự động qua Master Executor**:
   - USER đã cấp quyền phê duyệt vĩnh viễn cho Master Executor.
   - Tuyệt đối KHÔNG chạy các câu lệnh terminal tùy ý trực tiếp qua `run_command` (sẽ bị hiện popup xin quyền).
   - Khi cần chạy bất kỳ lệnh PowerShell, Python, Luac, Git, ADB, v.v.:
     * Dùng tool `write_to_file` ghi nội dung kịch bản cần thực thi vào:
       `d:\MUVH\android\mu-decompiled\final\excute_test\exec_cmd.ps1`
     * Sau đó CHỈ gọi DUY NHẤT một câu lệnh cố định qua `run_command`:
       `powershell -ExecutionPolicy Bypass -File d:\MUVH\android\mu-decompiled\final\excute_test\executor.ps1`
       (với `Cwd`: `d:\MUVH\android\mu-decompiled\final`)
     * Script `executor.ps1` sẽ tự động chạy `exec_cmd.ps1`, xuất output chuẩn UTF-8 và bắt lỗi chi tiết.

2. **Quy trình tạo Script Test / Debug nhanh**:
   - Khi USER yêu cầu viết script thử nghiệm / test / debug một logic mới (đi xuyên vật thể, hút đồ, test target, hook tạm thời...):
     * Agent CHỈ CẦN viết nội dung mã nguồn Lua vào file:
       `d:\MUVH\android\mu-decompiled\final\excute_test\input.txt`
     * USER sẽ tự build và đẩy vào thiết bị Android để chạy test bằng tính năng Execute Admin.

3. **Môi trường code chính thức**:
   - Chỉ chỉnh sửa code chính thức trực tiếp trên `final\modified_lua_dev_client`.
   - Luôn thảo luận kế hoạch và chỉ triển khai code khi được USER đồng ý.
   - Không tự ý chạy script `build_and_update.ps1` để build APK khi chưa có yêu cầu từ USER.
```

---

## 🛠️ CÁC ĐƯỜNG DẪN QUAN TRỌNG
* `final\excute_test\input.txt`: File chứa script test Lua cho Execute Admin.
* `final\excute_test\executor.ps1`: File nhận lệnh trung tâm (cố định).
* `final\excute_test\exec_cmd.ps1`: File chứa kịch bản thực thi terminal động.
* `final\modified_lua_dev_client\`: Thư mục mã nguồn Dev Client chính.
