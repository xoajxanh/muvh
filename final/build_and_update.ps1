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
Write-Host " [1] CLIENT       : Sync 'modified_lua_dev_client' -> Build MU_admin.apk & MU_client.apk (release_client) [MAC DINH]" -ForegroundColor Cyan
Write-Host " [2] CUSTOMER     : Sync 'modified_lua_dev_customer' -> Build MU_vut_teams.apk (release_customer)" -ForegroundColor Cyan
Write-Host " [3] NOTIFICATION : Build 'modified_lua_dev_notification' -> Build MU_notification.apk (release_notification)" -ForegroundColor Cyan
Write-Host " [4] ALL          : Build TAT CA (CLIENT + CUSTOMER + NOTIFICATION)" -ForegroundColor Cyan
Write-Host "----------------------------------------------------------" -ForegroundColor Gray

$modeInput = Read-Host "Nhap lua chon (1/2/3/4) [Nhan Enter = 1 (CLIENT)]"

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

# 2. Kiem tra file Template Base APK
$baseApk = "D:\MUVH\android\mu-decompiled\test_apk\v1\MU_base.apk"
if (-not (Test-Path $baseApk)) {
    Write-Host "[LOI] Khong tim thay file base template $baseApk!" -ForegroundColor Red
    Pause
    exit
}

$signerJar = "D:\MUVH\android\mu-decompiled\test_apk\uber-apk-signer.jar"
$winrar = "C:\Program Files\WinRAR\WinRAR.exe"
$tempBuildDir = "final\temp_build"

# Clean up bat ky file build tam cu
if (Test-Path $tempBuildDir) {
    Remove-Item -Path $tempBuildDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force -Path $tempBuildDir | Out-Null

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Function thuc hien build cho 1 task APK
function Build-ApkTask {
    param (
        [string]$Ver,
        [string]$OutputApkName,
        [string]$TargetFolder
    )
    $tempApkPath = "$tempBuildDir\$OutputApkName"

    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "   BUILDING $OutputApkName (Version: $Ver)" -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Cyan

    # A. Compile & Pack Lua
    Write-Host "1. Bien dich LUA cho $Ver..."
    $env:LUA_SRC_DIR = "final\modified_lua_$Ver"
    python compile_lua.py

    Write-Host "2. Dong goi LUA Bundle cho $Ver..."
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
            f.write(f'lua.mu2|0|$hash|$size|175\n')
        else:
            f.write(line)
"

    # D. Inject with WinRAR
    Write-Host "4. Injecting lua.mu2 & bundles.txt into $OutputApkName..."
    $argsLua = "a -m0 -ep -o+ -ibck -inul -apassets\Bundles `"$tempApkPath`" `"$packedFile`""
    Start-Process -FilePath $winrar -ArgumentList $argsLua -Wait

    $argsBundles = "a -m0 -ep -o+ -ibck -inul -apassets `"$tempApkPath`" `"final\new_bundles\bundles.txt`""
    Start-Process -FilePath $winrar -ArgumentList $argsBundles -Wait

    # E. Sign APK in temp folder
    Write-Host "5. Tu dong Ky APK tren PC voi uber-apk-signer..." -ForegroundColor Cyan
    $signArgs = @("-jar", $signerJar, "-a", $tempApkPath, "--allowResign", "--overwrite")
    Start-Process -FilePath "java" -ArgumentList $signArgs -Wait -NoNewWindow
    Write-Host "-> Da Ky chu ky thanh cong cho $OutputApkName!" -ForegroundColor Green

    # F. Deploy truc tiep sang thu muc release PC
    Write-Host "6. Sao chep file $OutputApkName sang PC folder release..." -ForegroundColor Cyan
    if (-not (Test-Path $TargetFolder)) {
        New-Item -ItemType Directory -Force -Path $TargetFolder | Out-Null
    }
    $destPath = Join-Path $TargetFolder $OutputApkName
    Copy-Item -Path $tempApkPath -Destination $destPath -Force
    Write-Host "-> Da sao chep thanh cong sang PC: $destPath" -ForegroundColor Green
}

# 3. Thuc hien quy trinh build theo che do
if ($choice -eq 1 -or $choice -eq 4) {
    # --------------------------------------------------------------------------
    # CLIENT MODE (Sync dev_client -> admin & client)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- DONG BO CODE MOD DEV CLIENT -> ADMIN & CLIENT ---" -ForegroundColor Yellow
    Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_admin" -Recurse -Force
    Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_client" -Recurse -Force

    $clientLua = "d:\MUVH\android\mu-decompiled\final\modified_lua_client\EmmyluaDebug.lua"
    if (Test-Path $clientLua) {
        $content = [System.IO.File]::ReadAllText($clientLua, $utf8NoBom)
        $content = $content.Replace("_G.Mod_IsAdmin = true", "_G.Mod_IsAdmin = false")
        [System.IO.File]::WriteAllText($clientLua, $content, $utf8NoBom)
    }

    Build-ApkTask -Ver "admin"  -OutputApkName "MU_admin.apk"  -TargetFolder "D:\MUVH\android\mu-decompiled\test_apk\v1\release\release_client"
    Build-ApkTask -Ver "client" -OutputApkName "MU_client.apk" -TargetFolder "D:\MUVH\android\mu-decompiled\test_apk\v1\release\release_client"
}

if ($choice -eq 2 -or $choice -eq 4) {
    # --------------------------------------------------------------------------
    # CUSTOMER MODE (Sync dev_customer -> customer)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- DONG BO CODE MOD DEV CUSTOMER -> CUSTOMER ---" -ForegroundColor Yellow
    Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_customer\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_customer" -Recurse -Force

    $customerLua = "d:\MUVH\android\mu-decompiled\final\modified_lua_customer\EmmyluaDebug.lua"
    if (Test-Path $customerLua) {
        $content = [System.IO.File]::ReadAllText($customerLua, $utf8NoBom)
        $content = $content.Replace("_G.Mod_IsDev = true", "_G.Mod_IsDev = false")
        $content = $content.Replace("_G.Mod_IsAdmin = true", "_G.Mod_IsAdmin = false")
        [System.IO.File]::WriteAllText($customerLua, $content, $utf8NoBom)
    }

    Build-ApkTask -Ver "customer" -OutputApkName "MU_vut_teams.apk" -TargetFolder "D:\MUVH\android\mu-decompiled\test_apk\v1\release\release_customer"
}

if ($choice -eq 3 -or $choice -eq 4) {
    # --------------------------------------------------------------------------
    # NOTIFICATION MODE (Direct dev_notification)
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "--- BUILD MOD DEV NOTIFICATION ---" -ForegroundColor Yellow
    Build-ApkTask -Ver "dev_notification" -OutputApkName "MU_notification.apk" -TargetFolder "D:\MUVH\android\mu-decompiled\test_apk\v1\release\release_notification"
}

# 4. Don dep thu muc temp build
Write-Host ""
Write-Host "Don dep file tam..." -ForegroundColor Gray
Remove-Item -Path $tempBuildDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " SUCCESS! QUY TRINH BUILD & DEPLOY HOAN TAT" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Pause
