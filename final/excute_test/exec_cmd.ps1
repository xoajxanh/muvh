$projectDir = "D:\MUVH\android\mu-decompiled"
$testDir = "$projectDir\final\excute_test"
$inputFile = "$testDir\input.txt"
$luacExe = "$projectDir\lua53\luac53.exe"
$convertScript = "$projectDir\convert_64_to_32.py"
$tempLuac = "$testDir\input.luac"
$androidPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"
$adbExe = "$projectDir\adb.exe"

& $luacExe "-s" "-o" $tempLuac $inputFile
python $convertScript $tempLuac $tempLuac
python -c "with open(r'$tempLuac', 'rb') as f: data = bytearray(f.read());
if data[0:4] == b'\x1bLua':
    data[5] = 0x01
    del data[14]
    with open(r'$tempLuac', 'wb') as f: f.write(data)"

& $adbExe -s emulator-5556 push $tempLuac $androidPath
Write-Host "-> Da day input.luac moi vao emulator-5556 thanh cong!" -ForegroundColor Green
