
Write-Host "========================================="
Write-Host "         MU MOD VIP KEYGEN               "
Write-Host "========================================="
Write-Host ""
$DeviceCode = Read-Host "Nhap Device Code cua khach hang (VD: 8a5f...)"

Write-Host ""
Write-Host "Chon thoi han Token:"
Write-Host "1. 3 ngay"
Write-Host "2. 7 ngay"
Write-Host "3. 15 ngay"
Write-Host "4. 30 ngay"
Write-Host "5. 60 giay (Test)"
$opt = Read-Host "Nhap lua chon (1-5)"

$Duration = 0
switch ($opt) {
    "1" { $Duration = 3 }
    "2" { $Duration = 7 }
    "3" { $Duration = 15 }
    "4" { $Duration = 30 }
    "5" { $Duration = "0.000694444" }
    default { 
        Write-Host "Lua chon khong hop le! Mac dinh se cho 3 ngay." -ForegroundColor Red
        $Duration = 3
    }
}

$unixTime = [int][double]::Parse((Get-Date (Get-Date).ToUniversalTime() -UFormat %s))
$secretSalt = "MUVH_SECRET_SALT_XOAI"

$tokenData = "$DeviceCode|$Duration|$unixTime"
$dataToHash = $tokenData + $secretSalt

# Compute MD5 Signature
$md5 = [System.Security.Cryptography.MD5]::Create()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($dataToHash)
$hashBytes = $md5.ComputeHash($bytes)
$sb = New-Object System.Text.StringBuilder
foreach ($b in $hashBytes) {
    [void]$sb.Append($b.ToString("x2"))
}
$signature = $sb.ToString()

$finalString = "$tokenData|$signature"
$finalBytes = [System.Text.Encoding]::UTF8.GetBytes($finalString)
$base64Token = [Convert]::ToBase64String($finalBytes)

Write-Host ""
Write-Host "========================================="
Write-Host "TOKEN CUA KHACH HANG: " -ForegroundColor Yellow
Write-Host $base64Token -ForegroundColor Green
Write-Host "========================================="
Set-Clipboard -Value $base64Token
Write-Host "Da tu dong Copy Token vao Clipboard!" -ForegroundColor Cyan

