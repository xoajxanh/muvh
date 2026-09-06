# EscapeUnicode.ps1
# Bật UTF-8 cho console
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Đảm bảo host cũng dùng UTF-8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

Write-Host "Nhập chuỗi Unicode:" -ForegroundColor Cyan
$inputString = Read-Host

# Chuyển từng ký tự sang UTF-8 bytes và xuất dạng \ddd
$utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($inputString)
$output = ""
foreach ($b in $utf8Bytes) {
    if ($b -ge 32 -and $b -le 126) {
        # ASCII dễ đọc thì giữ nguyên
        $output += [char]$b
    }
    else {
        # Ký tự khác thì chuyển thành \ddd
        $output += "\" + $b
    }
}

Write-Host ""
Write-Host "Kết quả escape:" -ForegroundColor Yellow
Write-Host $output -ForegroundColor Green

# Copy vào clipboard
$copied = $false
try {
    Set-Clipboard -Value $output -ErrorAction Stop
    $copied = $true
}
catch {
    try {
        $output | clip.exe
        $copied = $true
    }
    catch {}
}

if ($copied) {
    Write-Host "Đã copy chuỗi escape vào Clipboard!" -ForegroundColor Cyan
}
else {
    Write-Host "Hãy tự copy chuỗi escape ở trên." -ForegroundColor DarkYellow
}
