# ============================================================================
#                      MU MOD VIP KEYGEN (NEW VERSION)
# ============================================================================

chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "         MU MOD VIP KEYGEN 2026          " -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Nhập Mã Thiết Bị (MD5)
$DeviceCode = Read-Host "1. Nhập Mã Thiết Bị / Device Code của khách (VD: 8a5f...)"
if ([string]::IsNullOrWhiteSpace($DeviceCode)) {
    Write-Host "Lỗi: Mã Thiết Bị không được để trống!" -ForegroundColor Red
    exit
}
$DeviceCode = $DeviceCode.Trim()

# 2. Nhập UID Nhân Vật (mặc định ALL)
$InputUID = Read-Host "2. Nhập UID nhân vật khách (Ấn Enter để mặc định ALL cho mọi NV)"
$UID = "ALL"
if (-not [string]::IsNullOrWhiteSpace($InputUID)) {
    $UID = $InputUID.Trim()
}

# 3. Nhập Cấp Chuyển Chính (3-12, mặc định 8)
$InputMainTier = Read-Host "3. Nhập Chuyển Chính (3-12, Ấn Enter để mặc định 8)"
$MainTier = 8
if (-not [string]::IsNullOrWhiteSpace($InputMainTier)) {
    $parsedMain = 0
    if ([int]::TryParse($InputMainTier.Trim(), [ref]$parsedMain) -and $parsedMain -ge 3 -and $parsedMain -le 12) {
        $MainTier = $parsedMain
    } else {
        Write-Host "Chuyển chính không hợp lệ, lấy mặc định: 8" -ForegroundColor DarkYellow
    }
}

# 4. Nhập Cấp Chuyển Phụ (3-12, mặc định 7)
$InputSubTier = Read-Host "4. Nhập Chuyển Phụ (3-12, Ấn Enter để mặc định 7)"
$SubTier = 7
if (-not [string]::IsNullOrWhiteSpace($InputSubTier)) {
    $parsedSub = 0
    if ([int]::TryParse($InputSubTier.Trim(), [ref]$parsedSub) -and $parsedSub -ge 3 -and $parsedSub -le 12) {
        $SubTier = $parsedSub
    } else {
        Write-Host "Chuyển phụ không hợp lệ, lấy mặc định: 7" -ForegroundColor DarkYellow
    }
}

# 5. Nhập Ngày Bắt Đầu (Start Date)
Write-Host ""
$InputStartDate = Read-Host "5. Nhập Ngày Bắt Đầu (dd/MM/yyyy hoặc yyyy-MM-dd, Ấn Enter để lấy Ngày/Giờ Hiện Tại)"
$StartDate = Get-Date
if (-not [string]::IsNullOrWhiteSpace($InputStartDate)) {
    $formats = @(
        'dd/MM/yyyy HH:mm:ss', 'dd/MM/yyyy HH:mm', 'dd/MM/yyyy',
        'd/M/yyyy HH:mm:ss', 'd/M/yyyy HH:mm', 'd/M/yyyy',
        'yyyy-MM-dd HH:mm:ss', 'yyyy-MM-dd HH:mm', 'yyyy-MM-dd',
        'yyyy/MM/dd HH:mm:ss', 'yyyy/MM/dd HH:mm', 'yyyy/MM/dd',
        'dd-MM-yyyy HH:mm:ss', 'dd-MM-yyyy HH:mm', 'dd-MM-yyyy'
    )
    $parsedDate = [DateTime]::MinValue
    $isParsed = $false
    foreach ($fmt in $formats) {
        if ([DateTime]::TryParseExact($InputStartDate.Trim(), $fmt, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$parsedDate)) {
            $isParsed = $true
            break
        }
    }
    if (-not $isParsed) {
        $isParsed = [DateTime]::TryParse($InputStartDate.Trim(), [ref]$parsedDate)
    }

    if ($isParsed) {
        $StartDate = $parsedDate
        Write-Host (" -> Đã chọn Ngày Bắt Đầu: " + $StartDate.ToString("yyyy/MM/dd HH:mm:ss")) -ForegroundColor Green
    } else {
        Write-Host "Định dạng ngày không hợp lệ! Lấy Ngày/Giờ Hiện Tại." -ForegroundColor DarkYellow
        $StartDate = Get-Date
    }
} else {
    Write-Host (" -> Mặc định Ngày Bắt Đầu: " + $StartDate.ToString("yyyy/MM/dd HH:mm:ss")) -ForegroundColor DarkGray
}

# 6. Chọn Thời Hạn (Duration)
Write-Host ""
Write-Host "Chọn thời hạn Token:" -ForegroundColor Green
Write-Host "1. 3 ngày"
Write-Host "2. 7 ngày"
Write-Host "3. 15 ngày"
Write-Host "4. 30 ngày"
Write-Host "5. 60 ngày"
Write-Host "6. 90 ngày"
Write-Host "7. Tùy chọn (Nhập số ngày bất kỳ)"
Write-Host "8. 60 giây (Test hết hạn)"
$opt = Read-Host "Nhập lựa chọn (1-8, Mặc định: 1 - 3 ngày)"

$Duration = 3
switch ($opt) {
    "1" { $Duration = 3 }
    "2" { $Duration = 7 }
    "3" { $Duration = 15 }
    "4" { $Duration = 30 }
    "5" { $Duration = 60 }
    "6" { $Duration = 90 }
    "7" {
        $customDays = Read-Host "Nhập số ngày hiệu lực"
        $parsedCustom = 0
        if ([double]::TryParse($customDays.Trim(), [ref]$parsedCustom) -and $parsedCustom -gt 0) {
            $Duration = $parsedCustom
        } else {
            Write-Host "Số ngày không hợp lệ, lấy mặc định 30 ngày." -ForegroundColor DarkYellow
            $Duration = 30
        }
    }
    "8" { $Duration = "0.000694444" } # 60s
    default { 
        Write-Host "Lựa chọn không hợp lệ! Mặc định 3 ngày." -ForegroundColor DarkYellow
        $Duration = 3
    }
}

# 7. Tính toán Token & Ngày Hết Hạn
$unixTime = [int][double]::Parse((Get-Date ($StartDate.ToUniversalTime()) -UFormat %s))
$secretSalt = "MUVH_SECRET_SALT_XOAI"

$tokenData = "$DeviceCode|$UID|$MainTier|$SubTier|$Duration|$unixTime"
$dataToHash = $tokenData + $secretSalt

# Tính MD5 Signature
$md5 = [System.Security.Cryptography.MD5]::Create()
$bytes = [System.Text.Encoding]::UTF8.GetBytes($dataToHash)
$hashBytes = $md5.ComputeHash($bytes)
$sb = New-Object System.Text.StringBuilder
foreach ($b in $hashBytes) {
    [void]$sb.Append($b.ToString("x2"))
}
$signature = $sb.ToString()

# Ghép chuỗi và Encode Base64
$finalString = "$tokenData|$signature"
$finalBytes = [System.Text.Encoding]::UTF8.GetBytes($finalString)
$base64Token = [Convert]::ToBase64String($finalBytes)

# Tính ngày hết hạn để hiển thị
$expireDate = $StartDate.AddDays([double]$Duration)

# 8. Xuất Kết QuẢ
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "TOKEN CỦA KHÁCH HÀNG: " -ForegroundColor Yellow
Write-Host $base64Token -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Cấu hình Key:" -ForegroundColor Gray
Write-Host " - Device:       $DeviceCode"
Write-Host " - UID:          $UID"
Write-Host " - Cấp Chuyển:   Chính C$MainTier | Phụ C$SubTier"
Write-Host (" - Ngày Bắt Đầu: " + $StartDate.ToString("yyyy/MM/dd HH:mm:ss"))
Write-Host " - Thời Lượng:   $Duration ngày"
Write-Host (" - Ngày Hết Hạn: " + $expireDate.ToString("yyyy/MM/dd HH:mm:ss"))
Write-Host "=========================================" -ForegroundColor Cyan

# 9. Copy Clipboard an toàn không crash
$copied = $false
try {
    Set-Clipboard -Value $base64Token -ErrorAction Stop
    $copied = $true
} catch {
    try {
        $base64Token | clip.exe
        $copied = $true
    } catch {}
}

if ($copied) {
    Write-Host "Đã tự động Copy Token vào Clipboard!" -ForegroundColor Cyan
} else {
    Write-Host "Hãy bôi đen và copy Token ở trên!" -ForegroundColor Yellow
}
