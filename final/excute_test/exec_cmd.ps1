$projectDir = "D:\MUVH\android\mu-decompiled"
$testDir = "$projectDir\final\excute_test"
$inputFile = "$testDir\input.txt"
$luacExe = "$projectDir\lua53\luac53.exe"
$convertScript = "$projectDir\convert_64_to_32.py"
$tempLuac = "$testDir\input.luac"
$androidPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"
$adbExe = "$testDir\adb.exe"
if (-not (Test-Path $adbExe)) { $adbExe = "$projectDir\adb.exe" }

# 1. Compile
& $luacExe "-s" "-o" $tempLuac $inputFile
if ($LASTEXITCODE -ne 0) { Write-Host "Compile failed"; exit 1 }

# 2. Convert 32-bit
python $convertScript $tempLuac $tempLuac
if ($LASTEXITCODE -ne 0) { Write-Host "Convert failed"; exit 1 }

# 3. Patch Header
python -c "
with open(r'$tempLuac', 'rb') as f: data = bytearray(f.read())
if data[0:4] == b'\x1bLua':
    data[5] = 0x01
    del data[14]
    with open(r'$tempLuac', 'wb') as f: f.write(data)
"

# 4. Push to all online emulators
$onlineDevs = & $adbExe devices | Where-Object { $_ -match '\tdevice$' } | ForEach-Object { ($_ -split '\t')[0] }
foreach ($dev in $onlineDevs) {
    & $adbExe -s $dev push $tempLuac $androidPath
}
Write-Host "DA NAP THANH CONG INPUT.LUAC V2 VAO TAT CA CAC EMULATOR!"
