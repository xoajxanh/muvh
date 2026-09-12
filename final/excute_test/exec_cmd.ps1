$ErrorActionPreference = "Stop"
$projectDir = "d:\Xoai\muvh"
$testDir = "$projectDir\final\excute_test"
$inputFile = "$testDir\input.txt"
$luacExe = "$projectDir\lua53\luac53.exe"
$convertScript = "$projectDir\convert_64_to_32.py"
$tempLuac = "$testDir\input.luac"
$androidPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"
$adbExe = "$projectDir\adb.exe"
$androidId = "emulator-5554"

Write-Host "1. Bien dich luac..."
& $luacExe "-s" "-o" $tempLuac $inputFile

Write-Host "2. Convert 32-bit..."
python $convertScript $tempLuac $tempLuac

Write-Host "3. Patch header..."
$bytes = [System.IO.File]::ReadAllBytes($tempLuac)
if ($bytes[0] -eq 0x1b -and $bytes[1] -eq 0x4c) {
    $bytes[5] = 0x01
    $list = [System.Collections.Generic.List[byte]]$bytes
    $list.RemoveAt(14)
    [System.IO.File]::WriteAllBytes($tempLuac, $list.ToArray())
    Write-Host "Da patch header!"
}

Write-Host "4. Push input.luac vao Android..."
& $adbExe -s $androidId push $tempLuac $androidPath

Write-Host "XONG! Da push v7 thanh cong!"
