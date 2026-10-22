$filesToRemove = @(
    "D:\MUVH\android\mu-decompiled\final\excute_test\check_cust.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\check_send_conditions.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\check_timers2.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\compare_features.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\compare_net.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\compare_timers.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\diff_hooks.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\diff_speed_section.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\find_active.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\find_admin.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\find_all_timers.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\find_hooks.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\find_net_timers.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\find_speed_ctl.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\inspect_client_timers.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\inspect_customer_timers.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\inspect_speed.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\side_by_side.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\write_inspect.py",
    "D:\MUVH\android\mu-decompiled\final\excute_test\features_diff.txt",
    "D:\MUVH\android\mu-decompiled\final\excute_test\hooks_output.txt",
    "D:\MUVH\android\mu-decompiled\final\excute_test\net_output.txt",
    "D:\MUVH\android\mu-decompiled\final\excute_test\send_conds.txt",
    "D:\MUVH\android\mu-decompiled\final\excute_test\speed_output.txt",
    "D:\MUVH\android\mu-decompiled\final\excute_test\timers_detail.txt"
)

foreach ($f in $filesToRemove) {
    if (Test-Path $f) {
        Remove-Item -Path $f -Force
        Write-Host "Đã xóa: $(Split-Path $f -Leaf)" -ForegroundColor Yellow
    }
}

Write-Host "--- Trạng thái Git sau khi dọn dẹp ---" -ForegroundColor Cyan
git status --short
