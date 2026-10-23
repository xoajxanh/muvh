# ==============================================================================
# MU ORIGIN AUTOMATED BUILD & DEPLOYMENT SYSTEM
# ==============================================================================
$ErrorActionPreference = "Continue"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Refresh PATH tu Registry de tu dong nhan dien Python/Java vua moi cai dat ma khong can mo lai console
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
$version = "203"
# Tu dong xac dinh thu muc goc (Git Root Directory)
$rootDir = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path "$rootDir\.git")) {
    $curr = $PSScriptRoot
    while ($curr -and (-not (Test-Path "$curr\.git"))) {
        $parent = Split-Path -Parent $curr
        if ($parent -eq $curr) { break }
        $curr = $parent
    }
    if (Test-Path "$curr\.git") { $rootDir = $curr } else { $rootDir = (Split-Path -Parent $PSScriptRoot) }
}
Set-Location $rootDir

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     MU ORIGIN BUILD & DEPLOYMENT UTILITY" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Hien thi Menu Chon Che Do Build
Write-Host "CHON CHE DO BUILD:" -ForegroundColor Yellow
Write-Host " [1] CLIENT       : Sync 'modified_lua_dev_client' -> Build MU_admin.apk & MU_client.apk (release_client) [MAC DINH]" -ForegroundColor Cyan
Write-Host " [2] CUSTOMER     : Sync 'modified_lua_dev_customer' -> Build MU_vut_teams.apk (release_customer)" -ForegroundColor Cyan
Write-Host " [3] NOTIFICATION : Build 'modified_lua_dev_notification' -> Build MU_notification.apk (release_notification)" -ForegroundColor Cyan
Write-Host " [4] ALL          : Build TAT CA (CLIENT + CUSTOMER + NOTIFICATION + FARM)" -ForegroundColor Cyan
Write-Host " [5] FARM         : Build 'modified_lua_dev_farm' -> Build MU_farm.apk (release_farm)" -ForegroundColor Cyan
Write-Host "----------------------------------------------------------" -ForegroundColor Gray

$modeInput = Read-Host "Nhap lua chon (1/2/3/4/5) [Nhan Enter = 1 (CLIENT)]"

if ([string]::IsNullOrWhiteSpace($modeInput)) {
    $choice = 1
}
else {
    $parsedInt = 0
    if ([int]::TryParse($modeInput, [ref]$parsedInt)) {
        $choice = $parsedInt
    }
    else {
        $choice = 1
    }
}

# 2. Kiem tra file Template Base APK
$baseApk = Join-Path $rootDir "test_apk\v1\MU_base.apk"
if (-not (Test-Path $baseApk)) {
    Write-Host "[LOI] Khong tim thay file base template $baseApk!" -ForegroundColor Red
    Pause
    exit
}

$signerJar = Join-Path $rootDir "test_apk\uber-apk-signer.jar"
$winrar = "C:\Program Files\WinRAR\WinRAR.exe"
if (-not (Test-Path $winrar)) {
    if (Test-Path "C:\Program Files (x86)\WinRAR\WinRAR.exe") {
        $winrar = "C:\Program Files (x86)\WinRAR\WinRAR.exe"
    }
}
$tempBuildDir = Join-Path $rootDir "final\temp_build"

# Clean up bat ky file build tam cu
if (Test-Path $tempBuildDir) {
    Remove-Item -Path $tempBuildDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force -Path $tempBuildDir | Out-Null

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# =========================================================================
# [MOD FEATURE]: HỆ THỐNG XỬ LÝ BUILD TASK CÔ LẬP & DỌN DẸP SẠCH FILE TẠM
# Mô tả: Tự động reset và dọn dẹp sạch sẽ toàn bộ thư mục/file trung gian
#        (compiled_lua, new_lua, new_bundles, temp_build) trước và sau mỗi task,
#        bắt lỗi ExitCode nghiêm ngặt cho WinRAR, Java Signer và kiểm tra copy.
# =========================================================================
function Build-ApkTask {
    param (
        [string]$Ver,
        [string]$OutputApkName,
        [string]$TargetFolder
    )
    $tempApkPath = "$tempBuildDir\$OutputApkName"
    $compiledDir = Join-Path $rootDir "final\compiled_lua"
    $newLuaDir = Join-Path $rootDir "final\new_lua"
    $newBundlesDir = Join-Path $rootDir "final\new_bundles"
    $packedFile = Join-Path $newLuaDir "lua.mu2"

    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "   BUILDING $OutputApkName (Version: $Ver)" -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Cyan

    # 0. Don dep moi truong truoc khi build de tranh de chong file giua cac ban
    if (Test-Path $tempApkPath) {
        Remove-Item -Path $tempApkPath -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path $compiledDir) {
        Remove-Item -Path $compiledDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $compiledDir | Out-Null

    if (Test-Path $newLuaDir) {
        Remove-Item -Path $newLuaDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $newLuaDir | Out-Null

    if (Test-Path $newBundlesDir) {
        Remove-Item -Path $newBundlesDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $newBundlesDir | Out-Null

    # A. Compile & Pack Lua
    Write-Host "1. Bien dich LUA cho $Ver..."
    $luaSrc = Join-Path $rootDir "final\modified_lua_$Ver"
    if (-not (Test-Path $luaSrc -PathType Container)) {
        Write-Host "[LOI] Thu muc ma nguon Lua khong hop le hoac khong ton tai: $luaSrc" -ForegroundColor Red
        Pause
        exit 1
    }
    $env:LUA_SRC_DIR = $luaSrc
    python compile_lua.py
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[LOI] Bien dich Lua that bai cho version: $Ver" -ForegroundColor Red
        Pause
        exit 1
    }

    Write-Host "2. Dong goi LUA Bundle cho $Ver..."
    python pack_lua.py
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[LOI] Dong goi LUA bundle that bai cho version: $Ver" -ForegroundColor Red
        Pause
        exit 1
    }

    if (-not (Test-Path $packedFile)) {
        Write-Host "[LOI] Khong tim thay file bundle da dong goi: $packedFile" -ForegroundColor Red
        Pause
        exit 1
    }
    
    # B. Clone fresh from MU_base.apk to temp folder
    Write-Host "3. Khoi phuc tu base template MU_base.apk..."
    Copy-Item -Path $baseApk -Destination $tempApkPath -Force

    # C. Update bundles.txt
    $hash = (Get-FileHash $packedFile -Algorithm MD5).Hash.ToLower()
    $size = (Get-Item $packedFile).Length
    $bundlesSrc = (Join-Path $rootDir "test_apk\bundles.txt") -replace '\\', '/'
    $bundlesDst = (Join-Path $newBundlesDir "bundles.txt") -replace '\\', '/'
    python -c "
import sys
with open('$bundlesSrc', 'r', encoding='utf-8') as f:
    lines = f.readlines()
with open('$bundlesDst', 'w', encoding='utf-8') as f:
    for line in lines:
        if line.startswith('lua.mu2|'):
            f.write(f'lua.mu2|0|$hash|$size|$version\n')
        else:
            f.write(line)
"

    # D. Inject with WinRAR
    Write-Host "4. Injecting lua.mu2 & bundles.txt into $OutputApkName..."
    $argsLua = "a -m0 -ep -o+ -ibck -inul -apassets\Bundles `"$tempApkPath`" `"$packedFile`""
    $pLua = Start-Process -FilePath $winrar -ArgumentList $argsLua -Wait -PassThru -NoNewWindow
    if ($pLua.ExitCode -ne 0) {
        Write-Host "[LOI] WinRAR inject lua.mu2 that bai! (ExitCode: $($pLua.ExitCode))" -ForegroundColor Red
        Pause
        exit 1
    }

    $newBundlesFile = Join-Path $newBundlesDir "bundles.txt"
    $argsBundles = "a -m0 -ep -o+ -ibck -inul -apassets `"$tempApkPath`" `"$newBundlesFile`""
    $pBundles = Start-Process -FilePath $winrar -ArgumentList $argsBundles -Wait -PassThru -NoNewWindow
    if ($pBundles.ExitCode -ne 0) {
        Write-Host "[LOI] WinRAR inject bundles.txt that bai! (ExitCode: $($pBundles.ExitCode))" -ForegroundColor Red
        Pause
        exit 1
    }

    # E. Sign APK in temp folder
    Write-Host "5. Tu dong Ky APK tren PC voi uber-apk-signer..." -ForegroundColor Cyan
    $signArgs = @("-jar", $signerJar, "-a", $tempApkPath, "--allowResign", "--overwrite")
    $pSign = Start-Process -FilePath "java" -ArgumentList $signArgs -Wait -PassThru -NoNewWindow
    if ($pSign.ExitCode -ne 0) {
        Write-Host "[LOI] uber-apk-signer ky that bai cho $OutputApkName! (ExitCode: $($pSign.ExitCode))" -ForegroundColor Red
        Pause
        exit 1
    }
    Write-Host "-> Da Ky chu ky thanh cong cho $OutputApkName!" -ForegroundColor Green

    # F. Deploy truc tiep sang thu muc release PC
    Write-Host "6. Sao chep file $OutputApkName sang PC folder release..." -ForegroundColor Cyan
    if (-not (Test-Path $TargetFolder)) {
        New-Item -ItemType Directory -Force -Path $TargetFolder | Out-Null
    }
    $destPath = Join-Path $TargetFolder $OutputApkName
    if (Test-Path $destPath) {
        Remove-Item -Path $destPath -Force -ErrorAction SilentlyContinue
    }
    Copy-Item -Path $tempApkPath -Destination $destPath -Force
    
    # Kiem tra xac nhan copy thanh cong va khop dung luong
    if (-not (Test-Path $destPath)) {
        Write-Host "[LOI] Khong the sao chep sang: $destPath (Co the file dang bi khoa boi gia lap hoac chuong trinh khac)!" -ForegroundColor Red
        Pause
        exit 1
    }
    $srcSize = (Get-Item $tempApkPath).Length
    $dstSize = (Get-Item $destPath).Length
    if ($srcSize -ne $dstSize) {
        Write-Host "[LOI] Dung luong file sau khi sao chep bi lech! ($srcSize != $dstSize)" -ForegroundColor Red
        Pause
        exit 1
    }
    Write-Host "-> Da sao chep thanh cong sang PC: $destPath" -ForegroundColor Green

    # G. Don dep sach se ngay sau task nay de tranh anh huong toi task tiep theo
    Remove-Item -Path $tempApkPath -Force -ErrorAction SilentlyContinue
    if (Test-Path $compiledDir) { Remove-Item -Path $compiledDir -Recurse -Force -ErrorAction SilentlyContinue }
    if (Test-Path $newLuaDir) { Remove-Item -Path $newLuaDir -Recurse -Force -ErrorAction SilentlyContinue }
    if (Test-Path $newBundlesDir) { Remove-Item -Path $newBundlesDir -Recurse -Force -ErrorAction SilentlyContinue }
}

# 3. Thuc hien quy trinh build theo che do
$releaseClientDir = Join-Path $rootDir "test_apk\v1\release\release_client"
$releaseCustomerDir = Join-Path $rootDir "test_apk\v1\release\release_customer"
$releaseNotificationDir = Join-Path $rootDir "test_apk\v1\release\release_notification"
$releaseFarmDir = Join-Path $rootDir "test_apk\v1\release\release_farm"

if ($choice -eq 1 -or $choice -eq 4) {
    # --------------------------------------------------------------------------
    # CLIENT MODE (Sync dev_client -> admin & client)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- DONG BO CODE MOD DEV CLIENT -> ADMIN & CLIENT ---" -ForegroundColor Yellow
    $adminDir = Join-Path $rootDir "final\modified_lua_admin"
    $clientDir = Join-Path $rootDir "final\modified_lua_client"
    $devClientDir = Join-Path $rootDir "final\modified_lua_dev_client"

    # Don dep va khoi tao thu muc admin
    if (Test-Path $adminDir) {
        Remove-Item -Path $adminDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $adminDir | Out-Null
    Copy-Item -Path "$devClientDir\*" -Destination $adminDir -Recurse -Force
    Write-Host "-> Da dong bo code sang: $adminDir" -ForegroundColor Green

    # Don dep va khoi tao thu muc client
    if (Test-Path $clientDir) {
        Remove-Item -Path $clientDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $clientDir | Out-Null
    Copy-Item -Path "$devClientDir\*" -Destination $clientDir -Recurse -Force
    Write-Host "-> Da dong bo code sang: $clientDir" -ForegroundColor Green

    $clientLua = Join-Path $clientDir "EmmyluaDebug.lua"
    if (Test-Path $clientLua) {
        $content = [System.IO.File]::ReadAllText($clientLua, $utf8NoBom)
        $content = $content.Replace("_G.Mod_IsAdmin = true", "_G.Mod_IsAdmin = false")
        [System.IO.File]::WriteAllText($clientLua, $content, $utf8NoBom)
        Write-Host "-> Da set _G.Mod_IsAdmin = false cho Client" -ForegroundColor Green
    }
    else {
        Write-Host "[CANH BAO] Khong tim thay EmmyluaDebug.lua trong $clientDir de sua isAdmin!" -ForegroundColor Red
    }

    Build-ApkTask -Ver "admin"  -OutputApkName "MU_admin.apk"  -TargetFolder $releaseClientDir
    Build-ApkTask -Ver "client" -OutputApkName "MU_client.apk" -TargetFolder $releaseClientDir
}

if ($choice -eq 2 -or $choice -eq 4) {
    # --------------------------------------------------------------------------
    # CUSTOMER MODE (Sync dev_customer -> customer)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- DONG BO CODE MOD DEV CUSTOMER -> CUSTOMER ---" -ForegroundColor Yellow
    $customerDir = Join-Path $rootDir "final\modified_lua_customer"
    $devCustomerDir = Join-Path $rootDir "final\modified_lua_dev_customer"

    # Don dep va khoi tao thu muc customer
    if (Test-Path $customerDir) {
        Remove-Item -Path $customerDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $customerDir | Out-Null
    Copy-Item -Path "$devCustomerDir\*" -Destination $customerDir -Recurse -Force
    Get-ChildItem -Path $customerDir -Filter "*.bak*" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "-> Da dong bo code sang: $customerDir" -ForegroundColor Green

    $customerLua = Join-Path $customerDir "EmmyluaDebug.lua"
    if (Test-Path $customerLua) {
        $content = [System.IO.File]::ReadAllText($customerLua, $utf8NoBom)
        $content = $content.Replace("_G.Mod_IsDev = true", "_G.Mod_IsDev = false")
        $content = $content.Replace("_G.Mod_IsAdmin = true", "_G.Mod_IsAdmin = false")
        [System.IO.File]::WriteAllText($customerLua, $content, $utf8NoBom)
        Write-Host "-> Da set _G.Mod_IsDev = false va _G.Mod_IsAdmin = false cho Customer" -ForegroundColor Green
    }
    else {
        Write-Host "[CANH BAO] Khong tim thay EmmyluaDebug.lua trong $customerDir de sua config!" -ForegroundColor Red
    }

    Build-ApkTask -Ver "customer" -OutputApkName "MU_vut_teams.apk" -TargetFolder $releaseCustomerDir
}

if ($choice -eq 3 -or $choice -eq 4) {
    # --------------------------------------------------------------------------
    # NOTIFICATION MODE (Direct dev_notification)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- BUILD MOD DEV NOTIFICATION ---" -ForegroundColor Yellow
    Build-ApkTask -Ver "dev_notification" -OutputApkName "MU_notification.apk" -TargetFolder $releaseNotificationDir
}

if ($choice -eq 5 -or $choice -eq 4) {
    # --------------------------------------------------------------------------
    # FARM MODE (Direct dev_farm)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- BUILD MOD DEV FARM ---" -ForegroundColor Yellow
    Build-ApkTask -Ver "dev_farm" -OutputApkName "MU_farm.apk" -TargetFolder $releaseFarmDir
}

# 4. Don dep thu muc temp build & compiled lua
Write-Host ""
Write-Host "Don dep file tam..." -ForegroundColor Gray
Remove-Item -Path $tempBuildDir -Recurse -Force -ErrorAction SilentlyContinue
$finalCompiled = Join-Path $rootDir "final\compiled_lua"
$finalNewLua = Join-Path $rootDir "final\new_lua"
$finalNewBundles = Join-Path $rootDir "final\new_bundles"
if (Test-Path $finalCompiled) { Remove-Item -Path $finalCompiled -Recurse -Force -ErrorAction SilentlyContinue }
if (Test-Path $finalNewLua) { Remove-Item -Path $finalNewLua -Recurse -Force -ErrorAction SilentlyContinue }
if (Test-Path $finalNewBundles) { Remove-Item -Path $finalNewBundles -Recurse -Force -ErrorAction SilentlyContinue }

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " SUCCESS! QUY TRINH BUILD & DEPLOY HOAN TAT" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Pause

