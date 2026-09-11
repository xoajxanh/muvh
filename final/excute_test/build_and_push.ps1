$projectDir = "D:\MUVH\android\mu-decompiled"
$testDir = "$projectDir\final\excute_test"
$inputFile = "$testDir\input.txt"
$luacExe = "$projectDir\lua53\luac53.exe"
$convertScript = "$projectDir\convert_64_to_32.py"
$tempLuac = "$testDir\input.luac"
$androidPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"
$adbExe = "$projectDir\adb.exe"

Write-Host "1. Bien dich input.txt sang Lua Bytecode..." -ForegroundColor Cyan
if (-not (Test-Path $inputFile)) {
    Write-Host "LOI: Khong tim thay input.txt" -ForegroundColor Red
    exit 1
}

& $luacExe "-s" "-o" $tempLuac $inputFile
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: Bien dich Lua that bai!" -ForegroundColor Red
    exit 1
}

python $convertScript $tempLuac $tempLuac
if ($LASTEXITCODE -ne 0) {
    Write-Host "LOI: Convert sang 32-bit that bai!" -ForegroundColor Red
    exit 1
}

python -c "with open(r'$tempLuac', 'rb') as f: data = bytearray(f.read());
if data[0:4] == b'\x1bLua':
    data[5] = 0x01
    del data[14]
    with open(r'$tempLuac', 'wb') as f: f.write(data)"

Write-Host "-> Da tao input.luac 32-bit thanh cong!" -ForegroundColor Green

$devs = & $adbExe devices | Where-Object { $_ -match "\tdevice$" }
foreach ($d in $devs) {
    $devId = $d.Split("`t")[0]
    Write-Host "2. Day input.luac vao $devId..." -ForegroundColor Yellow
    & $adbExe -s $devId shell "rm -f /storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt"
    & $adbExe -s $devId push $tempLuac $androidPath
}

Write-Host "=== BUILD & PUSH HOAN TAT ===" -ForegroundColor Green
