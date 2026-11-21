# ==============================================================================
# MU ORIGIN AUTOMATED BUILD & DEPLOYMENT SYSTEM
# ==============================================================================
$ErrorActionPreference = "Continue"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Refresh PATH tu Registry de tu dong nhan dien Python/Java vua moi cai dat ma khong can mo lai console
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
$version = "206"
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

# =========================================================================
# [MOD FEATURE]: TỰ DÒ PYTHON CÓ SẴN UNITYPY ĐỂ BUILD (DYNAMIC PYTHON)
# Mô tả: Không phụ thuộc lệnh "python" mặc định của máy (có thể là bản quá mới,
#        chưa có wheel UnityPy, vd 3.15). Thứ tự ưu tiên:
#          1. Biến môi trường MU_PYTHON (đường dẫn python.exe chỉ định tay)
#          2. Lệnh python / python3 trong PATH
#          3. Các bản Python do launcher "py" quản lý (py -0p)
#        Lấy bản ĐẦU TIÊN import được UnityPy. Không có bản nào -> báo cách cài rồi dừng.
# =========================================================================
function Resolve-BuildPython {
    $candidates = New-Object System.Collections.Generic.List[string]

    if ($env:MU_PYTHON) { $candidates.Add($env:MU_PYTHON) }

    foreach ($cmd in @("python", "python3")) {
        if (Get-Command $cmd -ErrorAction SilentlyContinue) {
            # Lấy đường dẫn thật (lệnh alias WindowsApps chỉ là lối tắt)
            $real = & $cmd -c "import sys; print(sys.executable)" 2>$null
            if ($LASTEXITCODE -eq 0 -and $real) { $candidates.Add(($real | Select-Object -First 1).Trim()) }
        }
    }

    if (Get-Command py -ErrorAction SilentlyContinue) {
        $pyList = & py -0p 2>$null
        foreach ($line in $pyList) {
            if ($line -match '([A-Za-z]:\\.*?python[w]?\.exe)\s*$') { $candidates.Add($Matches[1]) }
        }
    }

    $checked = @()
    foreach ($exe in ($candidates | Select-Object -Unique)) {
        if (-not (Test-Path $exe)) { continue }
        $checked += $exe
        & $exe -c "import UnityPy" 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) { return $exe }
    }

    Write-Host "[LOI] Khong tim thay ban Python nao da cai UnityPy (can cho buoc dong goi lua.mu2)." -ForegroundColor Red
    if ($checked.Count -gt 0) {
        Write-Host "Da kiem tra:" -ForegroundColor Yellow
        $checked | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    }
    Write-Host "Cach khac phuc: cai UnityPy vao 1 ban Python co san wheel (khuyen nghi 3.10 - 3.13), vd:" -ForegroundColor Yellow
    Write-Host "   py -3.12 -m pip install UnityPy" -ForegroundColor Cyan
    Write-Host "   (Python qua moi nhu 3.15 chua co wheel -> pip doi Microsoft C++ Build Tools)" -ForegroundColor Yellow
    Write-Host "Hoac chi dinh tay: `$env:MU_PYTHON = 'C:\duong\dan\python.exe'" -ForegroundColor Yellow
    return $null
}

$PyExe = Resolve-BuildPython
if (-not $PyExe) {
    Pause
    exit 1
}
Write-Host "-> Python dung de build: $PyExe" -ForegroundColor Green

Clear-Host
Write-Host "Python build: $PyExe" -ForegroundColor DarkGray
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
# =========================================================================
# [MOD FEATURE]: TỰ DÒ ĐƯỜNG DẪN WINRAR (DYNAMIC WINRAR PATH)
# Mô tả: Không ghi cứng 1 đường dẫn. Thứ tự: biến MU_WINRAR -> registry
#        (HKLM/HKCU\SOFTWARE\WinRAR exe64/exe32, App Paths\WinRAR.exe)
#        -> Program Files / Program Files (x86) -> lệnh WinRAR trong PATH.
#        Không tìm thấy -> báo lỗi rõ ràng và dừng trước khi build.
# =========================================================================
function Resolve-WinRar {
    $cands = New-Object System.Collections.Generic.List[string]
    if ($env:MU_WINRAR) { $cands.Add($env:MU_WINRAR) }
    foreach ($k in @("HKLM:\SOFTWARE\WinRAR", "HKLM:\SOFTWARE\WOW6432Node\WinRAR", "HKCU:\SOFTWARE\WinRAR")) {
        $p = Get-ItemProperty $k -ErrorAction SilentlyContinue
        if ($p) { foreach ($n in @("exe64", "exe32")) { if ($p.$n) { $cands.Add($p.$n) } } }
    }
    foreach ($k in @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinRAR.exe",
                     "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WinRAR.exe")) {
        $p = Get-ItemProperty $k -ErrorAction SilentlyContinue
        if ($p -and $p.'(default)') { $cands.Add($p.'(default)') }
    }
    $cands.Add("$env:ProgramFiles\WinRAR\WinRAR.exe")
    if (${env:ProgramFiles(x86)}) { $cands.Add("${env:ProgramFiles(x86)}\WinRAR\WinRAR.exe") }
    $cmd = Get-Command WinRAR.exe -ErrorAction SilentlyContinue
    if ($cmd) { $cands.Add($cmd.Source) }

    foreach ($c in ($cands | Select-Object -Unique)) {
        if ($c -and (Test-Path $c)) { return $c }
    }
    return $null
}

$winrar = Resolve-WinRar
if (-not $winrar) {
    Write-Host "[LOI] Khong tim thay WinRAR.exe! Hay cai WinRAR hoac chi dinh tay: `$env:MU_WINRAR = 'C:\duong\dan\WinRAR.exe'" -ForegroundColor Red
    Pause
    exit 1
}
Write-Host "WinRAR: $winrar" -ForegroundColor DarkGray

# =========================================================================
# [MOD FEATURE]: WINRAR CHÈN FILE VÀO APK CÓ THỬ LẠI (CHỐNG LỖI KHÓA FILE)
# Mô tả: ExitCode 6 (Open error) / 5 (Write error) / 9 (Create error) thường do file APK 334MB
#        hoặc lua.mu2 vừa copy/ghi xong đang bị Windows Defender / chương trình
#        khác giữ khóa. Tự thử lại tối đa 8 lần, mỗi lần cách 5s. Hỏng hẳn thì
#        in nội dung log của WinRAR để biết file nào không mở được.
#        Máy có antivirus bên thứ 3 (360 Total Security, Reason...) hay mở APK ra quét
#        ngay sau khi copy/ghi -> WinRAR không đổi tên được file tạm .rartemp đè lên APK.
#        => Trước mỗi lần chạy: chờ tới khi APK + file nguồn mở độc quyền được (tối đa 60s).
#        -inul: không bật popup lỗi của WinRAR (popup sẽ chặn build), lỗi vẫn ghi vào -ilog.
# =========================================================================
function Wait-FileUnlocked {
    param([string]$Path, [int]$TimeoutSec = 60)
    if (-not (Test-Path $Path)) { return $true }
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $warned = $false
    while ($sw.Elapsed.TotalSeconds -lt $TimeoutSec) {
        try {
            $fs = [System.IO.File]::Open($Path, 'Open', 'ReadWrite', 'None')
            $fs.Close()
            return $true
        } catch {
            if (-not $warned) {
                Write-Host "   [CHO] $([System.IO.Path]::GetFileName($Path)) dang bi chuong trinh khac giu (antivirus?) - dang cho..." -ForegroundColor Yellow
                $warned = $true
            }
            Start-Sleep -Milliseconds 500
        }
    }
    return $false
}

function Invoke-WinRarAdd {
    param([string]$ApkPath, [string]$FilePath, [string]$ApPath)
    $logFile = Join-Path $env:TEMP "mu_build_winrar.log"
    $code = -1
    $maxTry = 8
    for ($i = 1; $i -le $maxTry; $i++) {
        [void](Wait-FileUnlocked -Path $ApkPath)
        [void](Wait-FileUnlocked -Path $FilePath)
        Remove-Item $logFile -Force -ErrorAction SilentlyContinue
        $rarArgs = "a -m0 -ep -o+ -ibck -inul -ilog`"$logFile`" -ap$ApPath `"$ApkPath`" `"$FilePath`""
        $p = Start-Process -FilePath $winrar -ArgumentList $rarArgs -Wait -PassThru -NoNewWindow
        $code = $p.ExitCode
        if ($code -eq 0) { return 0 }
        if (@(5, 6, 9) -notcontains $code) { break }
        Write-Host "   [CANH BAO] WinRAR ExitCode $code (file dang bi khoa) - thu lai lan $i/$maxTry sau 5s..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
    }
    # Dọn file tạm .rartemp WinRAR bỏ lại khi đổi tên thất bại
    Get-ChildItem (Split-Path $ApkPath) -Filter "__rzi_*.rartemp" -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    if (Test-Path $logFile) {
        Write-Host "   Log WinRAR:" -ForegroundColor Yellow
        Get-Content $logFile | ForEach-Object { Write-Host "   $_" -ForegroundColor Yellow }
    }
    return $code
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
    & $PyExe compile_lua.py
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[LOI] Bien dich Lua that bai cho version: $Ver" -ForegroundColor Red
        Pause
        exit 1
    }

    Write-Host "2. Dong goi LUA Bundle cho $Ver..."
    & $PyExe pack_lua.py
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
    # =====================================================================
    # [MOD FEATURE]: TRUYEN DUONG DAN QUA THAM SO, KHONG NHUNG VAO MA PYTHON
    # Truoc day duong dan duoc nhung thang vao chuoi nhay don cua Python:
    #   open('C:/Users/Pea'sDad/.../bundles.txt')
    # Ten thu muc co dau nhay don -> chuoi Python dut -> SyntaxError, file
    # bundles.txt khong duoc tao -> WinRAR bao ExitCode 10 (khong co file).
    # Dung here-string nhay don nen PowerShell cung khong noi suy bien.
    # =====================================================================
    $pyCode = @'
import sys, io
src, dst, h, sz, ver = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
with io.open(src, "r", encoding="utf-8") as f:
    lines = f.readlines()
with io.open(dst, "w", encoding="utf-8", newline="") as f:
    for line in lines:
        if line.startswith("lua.mu2|"):
            f.write("lua.mu2|0|%s|%s|%s\n" % (h, sz, ver))
        else:
            f.write(line)
'@
    # [MOD FEATURE]: GHI MA PYTHON RA FILE .py TAM ROI CHAY FILE
    # PowerShell 5.1 lam roi dau nhay kep (") khi truyen chuoi cho chuong trinh
    # ngoai qua "-c" -> Python nhan  io.open(dst, w, encoding=utf-8, ...)  -> SyntaxError.
    # Chay tu file thi khong con van de nhay.
    $pyFile = Join-Path $env:TEMP ("mu_bundles_" + [guid]::NewGuid().ToString("N") + ".py")
    [System.IO.File]::WriteAllText($pyFile, $pyCode, (New-Object System.Text.UTF8Encoding($false)))
    & $PyExe $pyFile $bundlesSrc $bundlesDst $hash $size $version
    $pyExit = $LASTEXITCODE
    Remove-Item -Path $pyFile -Force -ErrorAction SilentlyContinue
    $global:LASTEXITCODE = $pyExit
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[LOI] Khong tao duoc bundles.txt moi (Python tra ve $LASTEXITCODE)." -ForegroundColor Red
        Pause
        exit 1
    }

    # D. Inject with WinRAR
    Write-Host "4. Injecting lua.mu2 & bundles.txt into $OutputApkName..."
    $pLua = Invoke-WinRarAdd -ApkPath $tempApkPath -FilePath $packedFile -ApPath "assets\Bundles"
    if ($pLua -ne 0) {
        Write-Host "[LOI] WinRAR inject lua.mu2 that bai! (ExitCode: $pLua)" -ForegroundColor Red
        Pause
        exit 1
    }

    $newBundlesFile = Join-Path $newBundlesDir "bundles.txt"
    if (-not (Test-Path $newBundlesFile)) {
        Write-Host "[LOI] Khong thay $newBundlesFile - buoc tao bundles.txt phia tren da that bai." -ForegroundColor Red
        Pause
        exit 1
    }
    $pBundles = Invoke-WinRarAdd -ApkPath $tempApkPath -FilePath $newBundlesFile -ApPath "assets"
    if ($pBundles -ne 0) {
        Write-Host "[LOI] WinRAR inject bundles.txt that bai! (ExitCode: $pBundles)" -ForegroundColor Red
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

