$projectDir = (Get-Item "$PSScriptRoot\..\..").FullName
if (-not (Test-Path "$projectDir\adb.exe")) {
    $projectDir = "D:\MUVH\android\mu-decompiled"
}
$testDir = "$projectDir\final\excute_test"
$inputFile = "$testDir\input.txt"
$luacExe = "$projectDir\lua53\luac53.exe"
$convertScript = "$projectDir\convert_64_to_32.py"
$tempLuac = "$testDir\input.luac"
$androidPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"

$adbExe = "$projectDir\adb.exe"
if (-not (Test-Path $adbExe)) {
    $adbExe = "adb"
} 

# Tự động nhận diện thiết bị Android / Giả lập
$onlineDevs = & $adbExe devices | Where-Object { $_ -match '\tdevice$' } | ForEach-Object { ($_ -split '\t')[0] }
$androidId = "emulator-5554"
if ($onlineDevs.Count -gt 0) {
    if ($onlineDevs -contains "emulator-5554") {
        $androidId = "emulator-5554"
    } else {
        $androidId = $onlineDevs[0]
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ">>> BIÊN DỊCH & NẠP SCRIPT TEST VÀO ANDROID ($androidId) <<<" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not (Test-Path $inputFile)) {
    Write-Host "LOI: Khong tim thay file input.txt!" -ForegroundColor Red
    Pause
    exit
}

# 1. Compile to luac
Write-Host "1. Bien dich input.txt sang Bytecode..."
& $luacExe "-s" "-o" $tempLuac $inputFile
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: Bien dich Lua that bai (Sai cu phap)!" -ForegroundColor Red
    Pause
    exit
}

# 2. Convert to 32-bit
Write-Host "2. Chuyen doi sang 32-bit..."
python $convertScript $tempLuac $tempLuac
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: Chuyen doi 64-bit sang 32-bit that bai!" -ForegroundColor Red
    Pause
    exit
}

# 3. Patch header (giong trong compile_lua.py)
Write-Host "3. Patch Header Lua 5.3 32-bit..."
python -c "
with open(r'$tempLuac', 'rb') as f: data = bytearray(f.read())
if data[0:4] == b'\x1bLua':
    data[5] = 0x01
    del data[14]
    with open(r'$tempLuac', 'wb') as f: f.write(data)
"

# 4. Push to Android
Write-Host "4. Xoa output.txt cu va day file input.luac vao $androidId..."
& $adbExe -s $androidId shell "rm -f /storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt"
& $adbExe -s $androidId push $tempLuac $androidPath

Write-Host ""
Write-Host "-> DA NẠP SCRIPT THÀNH CÔNG VÀO THIẾT BỊ $androidId!" -ForegroundColor Green
Write-Host "   - Bạn có thể bấm nút [EXEC] màu đỏ trong game." -ForegroundColor Yellow
Write-Host "   - Hoặc gõ 't' rồi Enter để tự động chạm [EXEC] trên màn hình." -ForegroundColor Cyan
Write-Host "   - Hoặc bấm Enter để kéo log output.txt về xem ngay." -ForegroundColor Gray
$choice = Read-Host "Lựa chọn [Enter=Lấy log / t=Tap EXEC]"

if ($choice -eq 't' -or $choice -eq 'T') {
    Write-Host "Đang chạm nút [EXEC] tại tọa độ (30, 910)..." -ForegroundColor Yellow
    & $adbExe -s $androidId shell input tap 30 910
    Start-Sleep -Seconds 2
}

# 5. Pull output
Write-Host "Dang lay output.txt ve..."
$destOut = "$testDir\output.txt"
& $adbExe -s $androidId pull "/storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt" $destOut 2>$null

if (Test-Path $destOut) {
    Write-Host ""
    Write-Host "==================== [KẾT QUẢ OUTPUT.TXT] ====================" -ForegroundColor Green
    Get-Content $destOut -Tail 40
    Write-Host "==============================================================" -ForegroundColor Green
} else {
    Write-Host "Chua co file output.txt tren thiet bi!" -ForegroundColor Yellow
}

Write-Host ""
Pause
