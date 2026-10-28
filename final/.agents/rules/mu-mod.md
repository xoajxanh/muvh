---
trigger: always_on
---

# 🚀 HƯỚNG DẪN DÀNH CHO AGENT (PROJECT RULES & WORKFLOW GUIDE)

Tài liệu này dùng để dán vào prompt hoặc làm Custom Instructions khi mở phiên chat mới để Agent luôn tuân thủ đúng quy trình làm việc chuẩn.

---

## 📋 PROMPT GUIDE CHO PHIÊN CHAT MỚI

```markdown
### ⚡ QUY TẮC PHÁT TRIỂN & THỰC THI (PROJECT AGENT WORKFLOW)

1. **Tham khảo & Đóng gói Thư viện Modules (`final\excute_test\modules`)**:
   - Khi bắt đầu làm BẤT CỨ chức năng gì hoặc viết script test, Agent BẮT BUỘC phải tham khảo thư mục:
     `D:\MUVH\android\mu-decompiled\final\excute_test\modules` (đọc `README.md` và các module `.lua` / `.md` tương ứng) TRƯỚC TIÊN.
   - Tuyệt đối không tự mò mẫm hoặc viết lại các method đã có sẵn trong `modules`, tránh tốn thời gian và tránh lặp lại các bẫy dữ liệu của game.
   - Sau khi nghiên cứu và test thành công một tính năng/method mới, phải đóng gói cập nhật vào `D:\MUVH\android\mu-decompiled\final\excute_test\modules` để tái sử dụng lâu dài.

2. **Thực thi lệnh tự động qua Master Executor**:
   - USER đã cấp quyền phê duyệt vĩnh viễn cho Master Executor.
   - Tuyệt đối KHÔNG chạy các câu lệnh terminal tùy ý trực tiếp qua `run_command` (sẽ bị hiện popup xin quyền).
   - Khi cần chạy bất kỳ lệnh PowerShell, Python, Luac, Git, ADB, v.v.:
     * Dùng tool `write_to_file` ghi nội dung kịch bản cần thực thi vào:
       `d:\MUVH\android\mu-decompiled\final\excute_test\exec_cmd.ps1`
     * Sau đó CHỈ gọi DUY NHẤT một câu lệnh cố định qua `run_command`:
       `powershell -ExecutionPolicy Bypass -File d:\MUVH\android\mu-decompiled\final\excute_test\executor.ps1`
       (với `Cwd`: `d:\MUVH\android\mu-decompiled\final`)
     * Script `executor.ps1` sẽ tự động chạy `exec_cmd.ps1`, xuất output chuẩn UTF-8 và bắt lỗi chi tiết.

3. **Quy trình tạo Script Test / Debug nhanh & Quản lý Thiết bị Android**:
   - Khi USER yêu cầu viết script thử nghiệm / test / debug một logic mới (đi xuyên vật thể, hút đồ, test target, hook tạm thời...):
     * Agent CHỈ ĐƯỢC PHÉP chỉnh sửa/ghi mã nguồn Lua vào file text:
       `d:\MUVH\android\mu-decompiled\final\excute_test\input.txt`
     * Khi script test cần xuất dữ liệu kết quả, PHẢI ghi trực tiếp vào `output.txt` (tại `CS.UnityEngine.Application.persistentDataPath .. "/output.txt"` hoặc `/storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt`). Tuyệt đối KHÔNG tạo file tên khác, vì `push_test.ps1` chỉ pull đúng file `output.txt` về máy.
     * **Quy tắc Push Test & Android Device**: USER tự chọn Android Device ID và tự chạy `push_test.ps1` (hoặc `Run_Push_Test.bat`) để execute. Agent không can thiệp, không tự tìm Android ID hoặc push all devices, và TUYỆT ĐỐI KHÔNG tự ý sửa đổi `push_test.ps1` theo hướng đó.

4. **Môi trường code chính thức**:
   - Chỉ chỉnh sửa code chính thức trực tiếp trên `final\modified_lua_dev_client`.
   - Luôn thảo luận kế hoạch và chỉ triển khai code khi được USER đồng ý.
   - Không tự ý chạy script `build_and_update.ps1` để build APK khi chưa có yêu cầu từ USER.
```

---

## 🛠️ CÁC ĐƯỜNG DẪN QUAN TRỌNG
* `final\excute_test\modules\`: Thư viện Modules chuẩn đã kiểm định (bắt buộc tham khảo trước khi làm bất cứ tính năng nào).
* `final\excute_test\input.txt`: File chứa script test Lua cho Execute Admin.
* `final\excute_test\executor.ps1`: File nhận lệnh trung tâm (cố định).
* `final\excute_test\exec_cmd.ps1`: File chứa kịch bản thực thi terminal động.
* `final\modified_lua_dev_client\`: Thư mục mã nguồn Dev Client chính.
