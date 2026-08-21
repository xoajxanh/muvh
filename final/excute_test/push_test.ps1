$projectDir = "D:\MUVH\android\mu-decompiled"
$testDir = "$projectDir\final\excute_test"
$inputFile = "$testDir\input.txt"
$luacExe = "$projectDir\lua53\luac53.exe"
$convertScript = "$projectDir\convert_64_to_32.py"
$tempLuac = "$testDir\input.luac"
$androidPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"

# Nếu máy bạn báo lỗi không nhận diện lệnh adb, hãy đổi đường dẫn adb dưới đây thành đường dẫn tuyệt đối
# Ví dụ: $adbExe = "C:\Program Files\Nox\bin\adb.exe" (Tuỳ thuộc vào giả lập bạn đang xài)
$adbExe = "$projectDir\adb.exe" 

Write-Host "1. Đang bien dich input.txt sang Bytecode..."
if (-not (Test-Path $inputFile)) {
    Write-Host "LOI: Khong tim thay file input.txt!" -ForegroundColor Red
    Pause
    exit
}

# 1. Compile to luac
$cmd1 = & $luacExe "-s" "-o" $tempLuac $inputFile
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: Bien dich Lua that bai (Sai cu phap)!" -ForegroundColor Red
    Pause
    exit
}

# 2. Convert to 32-bit
python $convertScript $tempLuac $tempLuac
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: Chuyen doi 64-bit sang 32-bit that bai!" -ForegroundColor Red
    Pause
    exit
}

# 3. Patch header (giong trong compile_lua.py)
python -c "
with open(r'$tempLuac', 'rb') as f: data = bytearray(f.read())
if data[0:4] == b'\x1bLua':
    data[5] = 0x01
    del data[14]
    with open(r'$tempLuac', 'wb') as f: f.write(data)
"
Write-Host "-> Da patch Header Lua 5.3 32-bit thanh cong!"

# 4. Push to Android
Write-Host "2. Xoa output.txt cu va day file input.luac vao thiet bi Android..."
& $adbExe -s emulator-5556 shell "rm -f /storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt"
& $adbExe -s emulator-5556 push $tempLuac $androidPath

Write-Host ""
Write-Host "HOAN TAT! Bay gio ban hay bam [ EXECUTE SCRIPT ] trong game." -ForegroundColor Green
Write-Host "Sau do bam Enter o day de keo file output.txt ve may..." -ForegroundColor Yellow
Pause

# 5. Pull output
Write-Host "Dang lay output.txt ve..."
& $adbExe -s emulator-5556 pull "/storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt" "$testDir\output.txt"

Write-Host "XONG! Hay mo file output.txt de xem ket qua." -ForegroundColor Green
Pause
