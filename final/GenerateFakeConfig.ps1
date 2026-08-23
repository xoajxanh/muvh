# GenerateFakeConfig.ps1
# Script tao Fake JSON Config gia lap Response tu Server cho Customer Mod

Param(
    [string]$SerialNumber,
    [string]$UID,
    [int]$DaysValid,
    [int]$CurrentRebirth
)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      MU VIP MOD - FAKE CONFIG GENERATOR " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

if (-not $SerialNumber) {
    $SerialNumber = Read-Host "Nhap Serial Number MD5 cua thiet bi (De trong de dung mac dinh: 8a5f123456789abcdef)"
    if (-not $SerialNumber) { $SerialNumber = "8a5f123456789abcdef" }
}

if (-not $UID) {
    $UID = Read-Host "Nhap Character UID cua khach (De trong de dung mac dinh: 10001)"
    if (-not $UID) { $UID = "10001" }
}

if (-not $DaysValid) {
    Write-Host ""
    Write-Host "Chon thoi han Active:" -ForegroundColor Yellow
    Write-Host "1. 3 ngay"
    Write-Host "2. 7 ngay"
    Write-Host "3. 15 ngay"
    Write-Host "4. 30 ngay"
    Write-Host "5. 90 ngay"
    Write-Host "6. 60 giay (Test Het Han Dynamic)"
    $opt = Read-Host "Nhap lua chon (1-6, Mac dinh: 4 - 30 ngay)"
    
    switch ($opt) {
        "1" { $DaysValid = 3 }
        "2" { $DaysValid = 7 }
        "3" { $DaysValid = 15 }
        "4" { $DaysValid = 30 }
        "5" { $DaysValid = 90 }
        "6" { $DaysValid = -1 } # Cho am ngay de gia lap het han ngay lap tuc
        default { $DaysValid = 30 }
    }
}

if (-not $CurrentRebirth) {
    $rInput = Read-Host "Nhap Cap Chuyen/Rebirth cua nhan vat (De trong de dung mac dinh: 8)"
    if ($rInput -and [int]::TryParse($rInput, [ref]$CurrentRebirth)) {
        # Parsed successfully
    } else {
        $CurrentRebirth = 8
    }
}

$secretSalt = "MUVH_SECRET_SALT_XOAI"

if ($DaysValid -lt 0) {
    # Het han ngay lap tuc
    $expireTime = [int][double]::Parse((Get-Date (Get-Date).AddMinutes(-5).ToUniversalTime() -UFormat %s))
} else {
    $expireTime = [int][double]::Parse((Get-Date (Get-Date).AddDays($DaysValid).ToUniversalTime() -UFormat %s))
}

$configObj = [PSCustomObject]@{
    serial_number = $SerialNumber
    uid = $UID
    expire_time = $expireTime
    fov_min = 30
    fov_max = 70
    boss_refresh_min = 2
    boss_refresh_max = 10
    max_move_speed = 1.5
    max_attack_speed = 2.0
    max_monster_range = 20
    max_pickup_count = 50
    active_basic_tab = $true
    active_advanced_tab = $true
    active_autofarm_tab = $true
    current_rebirth = $CurrentRebirth
    admin_telegram_usernames = @("xoajx_admin1", "xoajx_admin2")
}

$jsonConfig = $configObj | ConvertTo-Json -Compress -Depth 5

$dataToHash = $jsonConfig + $secretSalt
$md5 = [System.Security.Cryptography.MD5]::Create()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($dataToHash)
$hashBytes = $md5.ComputeHash($bytes)
$sb = New-Object System.Text.StringBuilder
foreach ($b in $hashBytes) {
    [void]$sb.Append($b.ToString("x2"))
}
$signature = $sb.ToString()

$finalPayload = "$jsonConfig|$signature"
$payloadBytes = [System.Text.Encoding]::UTF8.GetBytes($finalPayload)
$base64Payload = [Convert]::ToBase64String($payloadBytes)

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "JSON Config Sinh Ra:" -ForegroundColor Yellow
Write-Host $jsonConfig
Write-Host ""
Write-Host "Base64 Encrypted Payload (Server Response):" -ForegroundColor Green
Write-Host $base64Payload
Write-Host "=========================================" -ForegroundColor Cyan

# Ghi vao file local fake_config.json trong d:\MUVH\android\mu-decompiled\final\
$outputPath = Join-Path $PSScriptRoot "fake_config.json"
Set-Content -Path $outputPath -Value $base64Payload -Encoding UTF8
Write-Host "Da xuat payload vao file: $outputPath" -ForegroundColor Green
