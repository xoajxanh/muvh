# ==============================================================================
# SCRIPT COPY FILE APK TU APKTOOL_M SANG LDPLAYER SHARED FOLDER VIA ADB
# ==============================================================================
$ErrorActionPreference = "Continue"

$projectDir = "D:\MUVH\android\mu-decompiled"
$adbExe = "$projectDir\adb.exe"

if (-not (Test-Path $adbExe)) {
    $adbExe = "adb"
}

# Duong dan trong Android
$apkToolMDir = "/storage/emulated/0/Apktool_M"
$baseShareDir = "/mnt/shared/Pictures/release"

# Write Header
Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   CONG CU COPY APK TU APKTOOL_M -> LDPLAYER SHARED FOLDER" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Nguon  : $apkToolMDir" -ForegroundColor Gray
Write-Host "Dich   : $baseShareDir" -ForegroundColor Gray
Write-Host "----------------------------------------------------------" -ForegroundColor Cyan

# 1. Kiem tra ket noi ADB
Write-Host "[1/3] Kiem tra ket noi ADB..." -ForegroundColor White
$devices = & $adbExe devices | Select-String -Pattern "\tdevice$"
if (-not $devices) {
    Write-Host "[LOI] Khong tim thay thiet bi/gia lap ADB nao dang ket noi!" -ForegroundColor Red
    Write-Host "Vui long bat LDPlayer va dam bao ADB enabled." -ForegroundColor Yellow
    Pause
    exit
}

$targetDevice = ""
foreach ($d in $devices) {
    $devName = ($d.Line -split "\t")[0]
    if ($devName -eq "emulator-5554") {
        $targetDevice = $devName
        break
    }
}
if (-not $targetDevice) {
    $targetDevice = ($devices[0].Line -split "\t")[0]
}
Write-Host "-> Da ket noi thiet bi: $targetDevice" -ForegroundColor Green

# 2. Hien thi Menu Chon Che Do
Write-Host ""
Write-Host "CHON CHE DO COPY:" -ForegroundColor Yellow
Write-Host " [1] CLIENT   : Copy MU_admin -> MU_admin.apk & MU_customer -> MU_client.apk (vao release_client) [MAC DINH]" -ForegroundColor Cyan
Write-Host " [2] CUSTOMER : Copy MU_customer -> MU_vut_teams.apk (vao release_customer)" -ForegroundColor Cyan
Write-Host " [3] THU CONG : Liet ke tat ca file APK de chon copy thu cong" -ForegroundColor Cyan
Write-Host "----------------------------------------------------------" -ForegroundColor Gray

$modeInput = Read-Host "Nhap lua chon (1/2/3) [Nhan Enter = 1 (CLIENT)]"

if ([string]::IsNullOrWhiteSpace($modeInput)) {
    $mode = 1
} else {
    $parsedMode = 0
    if ([int]::TryParse($modeInput, [ref]$parsedMode)) {
        $mode = $parsedMode
    } else {
        $mode = 1
    }
}

# 3. Quet file trong ApkToolM
Write-Host ""
Write-Host "[2/3] Quet danh sach file APK trong $apkToolMDir..." -ForegroundColor White
$rawList = & $adbExe -s $targetDevice shell "stat -c '%Y|%s|%n' $apkToolMDir/*.apk 2>/dev/null"

if (-not $rawList) {
    Write-Host "[LOI] Khong tim thay file .apk nao trong $apkToolMDir!" -ForegroundColor Red
    Pause
    exit
}

$apkFiles = @()
foreach ($line in $rawList) {
    $lineStr = $line.ToString().Trim()
    if ([string]::IsNullOrWhiteSpace($lineStr)) { continue }
    $parts = $lineStr -split '\|'
    if ($parts.Count -ge 3) {
        $timeSec = [long]$parts[0]
        $sizeBytes = [long]$parts[1]
        $fullPath = $parts[2]
        $fileName = [System.IO.Path]::GetFileName($fullPath)
        
        $sizeMB = [math]::Round($sizeBytes / 1MB, 2)
        $dateTime = ([datetime]'1970-01-01T00:00:00Z').AddSeconds($timeSec).ToLocalTime()
        $dateStr = $dateTime.ToString("yyyy-MM-dd HH:mm:ss")
        
        $apkFiles += [PSCustomObject]@{
            FileName  = $fileName
            FullPath  = $fullPath
            SizeBytes = $sizeBytes
            SizeMB    = $sizeMB
            TimeSec   = $timeSec
            DateStr   = $dateStr
        }
    }
}

if ($apkFiles.Count -eq 0) {
    Write-Host "[LOI] Khong tim thay file .apk hop le!" -ForegroundColor Red
    Pause
    exit
}

# ==============================================================================
# XU LY THEO TUNGB CHE DO
# ==============================================================================

if ($mode -eq 1) {
    # --------------------------------------------------------------------------
    # CHE DO 1: CLIENT
    # --------------------------------------------------------------------------
    $targetFolder = "$baseShareDir/release_client"
    Write-Host "-> Che do: CLIENT (Dich: $targetFolder)" -ForegroundColor Green
    
    # 1. Tim MU_admin moi nhat
    $adminFiles = $apkFiles | Where-Object { $_.FileName -like "MU_admin*.apk" } | Sort-Object -Property TimeSec -Descending
    $newestAdmin = $adminFiles | Select-Object -First 1

    # 2. Tim MU_customer moi nhat
    $customerFiles = $apkFiles | Where-Object { $_.FileName -like "MU_customer*.apk" } | Sort-Object -Property TimeSec -Descending
    $newestCustomer = $customerFiles | Select-Object -First 1

    if (-not $newestAdmin -and -not $newestCustomer) {
        Write-Host "[LOI] Khong tim thay file MU_admin*.apk va MU_customer*.apk nao trong $apkToolMDir!" -ForegroundColor Red
        Pause
        exit
    }

    # Tao thu muc dich neu chua co
    & $adbExe -s $targetDevice shell "mkdir -p '$targetFolder'"

    Write-Host ""
    Write-Host "[3/3] Thuc hien copy cho CLIENT:" -ForegroundColor Yellow

    # Copy Admin
    if ($newestAdmin) {
        $destAdminPath = "$targetFolder/MU_admin.apk"
        Write-Host " [+] Admin: '$($newestAdmin.FileName)' -> 'MU_admin.apk'..." -ForegroundColor Cyan
        & $adbExe -s $targetDevice shell "cp '$($newestAdmin.FullPath)' '$destAdminPath'"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "     -> Thanh cong! (Dung luong: $($newestAdmin.SizeMB) MB, Ngay: $($newestAdmin.DateStr))" -ForegroundColor Green
        } else {
            Write-Host "     -> LOI copy file Admin!" -ForegroundColor Red
        }
    } else {
        Write-Host " [-] Khong tim thay file MU_admin*.apk!" -ForegroundColor Red
    }

    # Copy Customer (Client)
    if ($newestCustomer) {
        $destClientPath = "$targetFolder/MU_client.apk"
        Write-Host " [+] Client: '$($newestCustomer.FileName)' -> 'MU_client.apk'..." -ForegroundColor Cyan
        & $adbExe -s $targetDevice shell "cp '$($newestCustomer.FullPath)' '$destClientPath'"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "     -> Thanh cong! (Dung luong: $($newestCustomer.SizeMB) MB, Ngay: $($newestCustomer.DateStr))" -ForegroundColor Green
        } else {
            Write-Host "     -> LOI copy file Client!" -ForegroundColor Red
        }
    } else {
        Write-Host " [-] Khong tim thay file MU_customer*.apk!" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host " HOAN TAT COPY CHE DO CLIENT!" -ForegroundColor Green
    Write-Host " File dich nam tai: $targetFolder" -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Green

} elseif ($mode -eq 2) {
    # --------------------------------------------------------------------------
    # CHE DO 2: CUSTOMER
    # --------------------------------------------------------------------------
    $targetFolder = "$baseShareDir/release_customer"
    Write-Host "-> Che do: CUSTOMER (Dich: $targetFolder)" -ForegroundColor Green

    # Tim MU_customer moi nhat
    $customerFiles = $apkFiles | Where-Object { $_.FileName -like "MU_customer*.apk" } | Sort-Object -Property TimeSec -Descending
    $newestCustomer = $customerFiles | Select-Object -First 1

    if (-not $newestCustomer) {
        Write-Host "[LOI] Khong tim thay file MU_customer*.apk nao trong $apkToolMDir!" -ForegroundColor Red
        Pause
        exit
    }

    # Tao thu muc dich neu chua co
    & $adbExe -s $targetDevice shell "mkdir -p '$targetFolder'"

    Write-Host ""
    Write-Host "[3/3] Thuc hien copy cho CUSTOMER:" -ForegroundColor Yellow
    $destCustomerPath = "$targetFolder/MU_vut_teams.apk"
    Write-Host " [+] Customer: '$($newestCustomer.FileName)' -> 'MU_vut_teams.apk'..." -ForegroundColor Cyan
    & $adbExe -s $targetDevice shell "cp '$($newestCustomer.FullPath)' '$destCustomerPath'"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "     -> Thanh cong! (Dung luong: $($newestCustomer.SizeMB) MB, Ngay: $($newestCustomer.DateStr))" -ForegroundColor Green
        Write-Host ""
        Write-Host "==========================================================" -ForegroundColor Green
        Write-Host " HOAN TAT COPY CHE DO CUSTOMER!" -ForegroundColor Green
        Write-Host " File dich: $destCustomerPath" -ForegroundColor Yellow
        Write-Host "==========================================================" -ForegroundColor Green
    } else {
        Write-Host "     -> LOI copy file Customer!" -ForegroundColor Red
    }

} else {
    # --------------------------------------------------------------------------
    # CHE DO 3: THU CONG
    # --------------------------------------------------------------------------
    $sortedFiles = $apkFiles | Sort-Object -Property TimeSec -Descending

    Write-Host ""
    Write-Host "DANH SACH FILE APK (MOI NHAT XEP VI TRI [1]):" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Gray

    for ($i = 0; $i -lt $sortedFiles.Count; $i++) {
        $item = $sortedFiles[$i]
        $num = "[{0}]" -f ($i + 1)
        $nameDisplay = $item.FileName
        if ($nameDisplay.Length -gt 40) {
            $nameDisplay = $nameDisplay.Substring(0, 37) + "..."
        }
        $namePadded = $nameDisplay.PadRight(40)
        Write-Host (" {0,-5} {1} | {2,7} MB | {3}" -f $num, $namePadded, $item.SizeMB, $item.DateStr) -ForegroundColor Cyan
    }

    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Gray
    $selection = Read-Host "Nhap so thu tu file muon copy [Nhan Enter = Select 1 (Moi nhat)]"

    if ([string]::IsNullOrWhiteSpace($selection)) {
        $selectedIndex = 0
    } else {
        $parsedInt = 0
        if ([int]::TryParse($selection, [ref]$parsedInt)) {
            $selectedIndex = $parsedInt - 1
        } else {
            $selectedIndex = -1
        }
    }

    if ($selectedIndex -lt 0 -or $selectedIndex -ge $sortedFiles.Count) {
        Write-Host "[LOI] So thu tu nhap vao khong hop le!" -ForegroundColor Red
        Pause
        exit
    }

    $selectedFile = $sortedFiles[$selectedIndex]
    Write-Host ""
    Write-Host "[3/3] Dang copy '$($selectedFile.FileName)' sang '$baseShareDir'..." -ForegroundColor White

    & $adbExe -s $targetDevice shell "mkdir -p '$baseShareDir'"
    & $adbExe -s $targetDevice shell "cp '$($selectedFile.FullPath)' '$baseShareDir/'"

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "==========================================================" -ForegroundColor Green
        Write-Host " SUCCESS! Da copy file thanh cong:" -ForegroundColor Green
        Write-Host " File: $($selectedFile.FileName)" -ForegroundColor Yellow
        Write-Host " Den : $baseShareDir/$($selectedFile.FileName)" -ForegroundColor Yellow
        Write-Host "==========================================================" -ForegroundColor Green
    } else {
        Write-Host "[LOI] Copy that bai!" -ForegroundColor Red
    }
}

Write-Host ""
Pause
