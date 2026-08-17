# ==============================================================================
# MU ORIGIN AUTOMATED BUILD & DEPLOYMENT SYSTEM
# ==============================================================================
$ErrorActionPreference = "Continue"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Set-Location "D:\MUVH\android\mu-decompiled"

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     MU ORIGIN BUILD & DEPLOYMENT UTILITY" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Hien thi Menu Chon Che Do Build
Write-Host "CHON CHE DO BUILD:" -ForegroundColor Yellow
Write-Host " [1] CLIENT   : Nhanh 'main' -> Build MU_admin.apk & MU_client.apk (release_client) [MAC DINH]" -ForegroundColor Cyan
Write-Host " [2] CUSTOMER : Nhanh 'commercial' -> Build MU_vut_teams.apk (release_customer)" -ForegroundColor Cyan
Write-Host "----------------------------------------------------------" -ForegroundColor Gray

$modeInput = Read-Host "Nhap lua chon (1/2) [Nhan Enter = 1 (CLIENT)]"

if ([string]::IsNullOrWhiteSpace($modeInput)) {
    $choice = 1
} else {
    $parsedInt = 0
    if ([int]::TryParse($modeInput, [ref]$parsedInt)) {
        $choice = $parsedInt
    } else {
        $choice = 1
    }
}

# 2. Xac dinh Nhanh Git Tuong Ung
if ($choice -eq 2) {
    $targetBranch = "commercial"
    $buildMode = "CUSTOMER"
} else {
    $targetBranch = "main"
    $buildMode = "CLIENT"
}

Write-Host ""
Write-Host "[1/4] Kiem tra va chuyen nhanh Git sang '$targetBranch'..." -ForegroundColor White

$currentBranch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host "-> Nhanh hien tai: $currentBranch" -ForegroundColor Gray

if ($currentBranch -ne $targetBranch) {
    Write-Host "-> Lam sach working tree de chuyen nhanh..." -ForegroundColor Gray
    git checkout -- .
    Write-Host "-> Dang chuyen sang nhanh '$targetBranch'..." -ForegroundColor Yellow
    git checkout $targetBranch
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[LOI] Chuyen nhanh Git that bai! Vui long kiem tra uncommitted changes." -ForegroundColor Red
        Pause
        exit
    }
}

# Pull code moi nhat
Write-Host "-> Dang pull code moi nhat tu origin/$targetBranch..." -ForegroundColor Yellow
git pull origin $targetBranch

# 3. Kiem tra file Template Base APK
$baseApk = "D:\MUVH\android\mu-decompiled\test_apk\v1\MU_base.apk"
if (-not (Test-Path $baseApk)) {
    Write-Host "[LOI] Khong tim thay file base template $baseApk!" -ForegroundColor Red
    Pause
    exit
}

$signerJar = "D:\MUVH\android\mu-decompiled\test_apk\uber-apk-signer.jar"
$winrar = "C:\Program Files\WinRAR\WinRAR.exe"
$adbExe = "D:\MUVH\android\mu-decompiled\adb.exe"
$tempBuildDir = "final\temp_build"

# Clean up bat ky file build tam cu
if (Test-Path $tempBuildDir) {
    Remove-Item -Path $tempBuildDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force -Path $tempBuildDir | Out-Null

# 4. Thuc hien quy trinh build theo che do
if ($choice -eq 1) {
    # --------------------------------------------------------------------------
    # CLIENT MODE (Nhánh main -> Build admin & client)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- DONG BO CODE MOD DEV -> ADMIN & CUSTOMER ---" -ForegroundColor Yellow
    Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_admin" -Recurse -Force
    Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_customer" -Recurse -Force

    $customerLua = "d:\MUVH\android\mu-decompiled\final\modified_lua_customer\EmmyluaDebug.lua"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $content = [System.IO.File]::ReadAllText($customerLua, $utf8NoBom)
    $content = $content.Replace("_G.Mod_IsDev = true", "_G.Mod_IsDev = false")
    $content = $content.Replace("_G.Mod_IsAdmin = true", "_G.Mod_IsAdmin = false")
    [System.IO.File]::WriteAllText($customerLua, $content, $utf8NoBom)

    $tasks = @(
        @{ Ver = "admin";    OutputApkName = "MU_admin.apk";  TargetFolder = "D:\MUVH\android\mu-decompiled\test_apk\v1\release\release_client" },
        @{ Ver = "customer"; OutputApkName = "MU_client.apk"; TargetFolder = "D:\MUVH\android\mu-decompiled\test_apk\v1\release\release_client" }
    )

    foreach ($task in $tasks) {
        $ver = $task.Ver
        $outName = $task.OutputApkName
        $targetFolder = $task.TargetFolder
        $tempApkPath = "$tempBuildDir\$outName"

        Write-Host ""
        Write-Host "==========================================================" -ForegroundColor Cyan
        Write-Host "   BUILDING $outName (Version: $ver)" -ForegroundColor Yellow
        Write-Host "==========================================================" -ForegroundColor Cyan

        # A. Compile & Pack Lua
        Write-Host "1. Bien dich LUA cho $ver..."
        $env:LUA_SRC_DIR = "final\modified_lua_$ver"
        python compile_lua.py

        Write-Host "2. Dong goi LUA Bundle cho $ver..."
        python pack_lua.py

        $packedFile = "final\new_lua\lua.mu2"
        
        # B. Clone fresh from MU_base.apk to temp folder
        Write-Host "3. Khoi phuc tu base template MU_base.apk..."
        Copy-Item -Path $baseApk -Destination $tempApkPath -Force

        # C. Update bundles.txt
        $hash = (Get-FileHash $packedFile -Algorithm MD5).Hash.ToLower()
        $size = (Get-Item $packedFile).Length
        New-Item -ItemType Directory -Force -Path "final\new_bundles" | Out-Null
        python -c "
import sys
with open('D:/MUVH/android/mu-decompiled/test_apk/bundles.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()
with open('D:/MUVH/android/mu-decompiled/final/new_bundles/bundles.txt', 'w', encoding='utf-8') as f:
    for line in lines:
        if line.startswith('lua.mu2|'):
            f.write(f'lua.mu2|0|$hash|$size|172\n')
        else:
            f.write(line)
"

        # D. Inject with WinRAR
        Write-Host "4. Injecting lua.mu2 & bundles.txt into $outName..."
        $argsLua = "a -m0 -ep -o+ -ibck -inul -apassets\Bundles `"$tempApkPath`" `"$packedFile`""
        Start-Process -FilePath $winrar -ArgumentList $argsLua -Wait

        $argsBundles = "a -m0 -ep -o+ -ibck -inul -apassets `"$tempApkPath`" `"final\new_bundles\bundles.txt`""
        Start-Process -FilePath $winrar -ArgumentList $argsBundles -Wait

        # E. Sign APK in temp folder
        Write-Host "5. Tu dong Ky APK tren PC voi uber-apk-signer..." -ForegroundColor Cyan
        $signArgs = @("-jar", $signerJar, "-a", $tempApkPath, "--allowResign", "--overwrite")
        Start-Process -FilePath "java" -ArgumentList $signArgs -Wait -NoNewWindow
        Write-Host "-> Da Ky chu ky thanh cong cho $outName!" -ForegroundColor Green

        # F. Deploy truc tiep sang thu muc release PC (Folder chia se voi LDPlayer)
        Write-Host "6. Sao chep file $outName sang PC folder release..." -ForegroundColor Cyan
        if (-not (Test-Path $targetFolder)) {
            New-Item -ItemType Directory -Force -Path $targetFolder | Out-Null
        }
        $destPath = Join-Path $targetFolder $outName
        Copy-Item -Path $tempApkPath -Destination $destPath -Force
        Write-Host "-> Da sao chep thanh cong sang PC: $destPath" -ForegroundColor Green
    }

} else {
    # --------------------------------------------------------------------------
    # CUSTOMER MODE (Nhánh commercial -> Build customer vut_teams)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- DONG BO CODE MOD DEV -> CUSTOMER ---" -ForegroundColor Yellow
    Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_customer" -Recurse -Force

    $customerLua = "d:\MUVH\android\mu-decompiled\final\modified_lua_customer\EmmyluaDebug.lua"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $content = [System.IO.File]::ReadAllText($customerLua, $utf8NoBom)
    $content = $content.Replace("_G.Mod_IsDev = true", "_G.Mod_IsDev = false")
    $content = $content.Replace("_G.Mod_IsAdmin = true", "_G.Mod_IsAdmin = false")
    [System.IO.File]::WriteAllText($customerLua, $content, $utf8NoBom)

    $outName = "MU_vut_teams.apk"
    $targetFolder = "D:\MUVH\android\mu-decompiled\test_apk\v1\release\release_customer"
    $tempApkPath = "$tempBuildDir\$outName"

    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "   BUILDING $outName (Version: customer - commercial)" -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Cyan

    # A. Compile & Pack Lua
    Write-Host "1. Bien dich LUA cho customer..."
    $env:LUA_SRC_DIR = "final\modified_lua_customer"
    python compile_lua.py

    Write-Host "2. Dong goi LUA Bundle cho customer..."
    python pack_lua.py

    $packedFile = "final\new_lua\lua.mu2"
    
    # B. Clone fresh from MU_base.apk to temp folder
    Write-Host "3. Khoi phuc tu base template MU_base.apk..."
    Copy-Item -Path $baseApk -Destination $tempApkPath -Force

    # C. Update bundles.txt
    $hash = (Get-FileHash $packedFile -Algorithm MD5).Hash.ToLower()
    $size = (Get-Item $packedFile).Length
    New-Item -ItemType Directory -Force -Path "final\new_bundles" | Out-Null
    python -c "
import sys
with open('D:/MUVH/android/mu-decompiled/test_apk/bundles.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()
with open('D:/MUVH/android/mu-decompiled/final/new_bundles/bundles.txt', 'w', encoding='utf-8') as f:
    for line in lines:
        if line.startswith('lua.mu2|'):
            f.write(f'lua.mu2|0|$hash|$size|172\n')
        else:
            f.write(line)
"

    # D. Inject with WinRAR
    Write-Host "4. Injecting lua.mu2 & bundles.txt into $outName..."
    $argsLua = "a -m0 -ep -o+ -ibck -inul -apassets\Bundles `"$tempApkPath`" `"$packedFile`""
    Start-Process -FilePath $winrar -ArgumentList $argsLua -Wait

    $argsBundles = "a -m0 -ep -o+ -ibck -inul -apassets `"$tempApkPath`" `"final\new_bundles\bundles.txt`""
    Start-Process -FilePath $winrar -ArgumentList $argsBundles -Wait

    # E. Sign APK in temp folder
    Write-Host "5. Tu dong Ky APK tren PC voi uber-apk-signer..." -ForegroundColor Cyan
    $signArgs = @("-jar", $signerJar, "-a", $tempApkPath, "--allowResign", "--overwrite")
    Start-Process -FilePath "java" -ArgumentList $signArgs -Wait -NoNewWindow
    Write-Host "-> Da Ky chu ky thanh cong cho $outName!" -ForegroundColor Green

    # F. Deploy truc tiep sang thu muc release PC (Folder chia se voi LDPlayer)
    Write-Host "6. Sao chep file $outName sang PC folder release..." -ForegroundColor Cyan
    if (-not (Test-Path $targetFolder)) {
        New-Item -ItemType Directory -Force -Path $targetFolder | Out-Null
    }
    $destPath = Join-Path $targetFolder $outName
    Copy-Item -Path $tempApkPath -Destination $destPath -Force
    Write-Host "-> Da sao chep thanh cong sang PC: $destPath" -ForegroundColor Green
}

# 5. Duyen dẹp thu muc temp build, giữ thư mục test_apk\v1 luôn sạch sẽ
Write-Host ""
Write-Host "Don dep file tam..." -ForegroundColor Gray
Remove-Item -Path $tempBuildDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " SUCCESS! QUY TRINH BUILD & DEPLOY HOAN TAT CHO $buildMode" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "Thu muc test_apk\v1 giu sach se chi chua duy nhat MU_base.apk." -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Pause
