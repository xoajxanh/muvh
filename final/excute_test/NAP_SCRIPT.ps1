# =========================================================================
# [TIEN ICH] NAP SCRIPT TEST (input.txt) VAO GIA LAP DUOC CHON
# Ban cu push_test.ps1 hard-code emulator-5554 nen luon nap vao may dau tien.
# Ban nay: liet ke may dang chay, cho chon tung may hoac TAT CA.
# =========================================================================
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$testDir = $PSScriptRoot
$projectDir = (Get-Item "$testDir\..\..").FullName
$inputFile = "$testDir\input.txt"
$luacExe = "$projectDir\lua53\luac53.exe"
$convertScript = "$projectDir\convert_64_to_32.py"
$tempLuac = "$testDir\input.luac"
$androidPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"

$adb = Join-Path $testDir "adb.exe"
if (-not (Test-Path $adb)) { $adb = "adb" }

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "        NAP SCRIPT TEST VAO GIA LAP (chon may)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not (Test-Path $inputFile)) {
    Write-Host "[LOI] Khong thay input.txt" -ForegroundColor Red
    Read-Host "Bam Enter de dong"; exit
}

# ---------- 1. Liet ke may dang chay ----------
$devs = @(& $adb devices | Select-String "device$" | ForEach-Object { ($_ -split "\s+")[0] })
if ($devs.Count -eq 0) {
    Write-Host "[LOI] Khong thay may ao nao dang ket noi." -ForegroundColor Red
    Read-Host "Bam Enter de dong"; exit
}

Write-Host ""
Write-Host "Cac may dang chay:" -ForegroundColor Yellow
for ($i = 0; $i -lt $devs.Count; $i++) {
    Write-Host ("  {0}. {1}" -f ($i + 1), $devs[$i]) -ForegroundColor White
}
Write-Host "  A. TAT CA cac may" -ForegroundColor Green
Write-Host ""
$chon = Read-Host "Nap vao may nao? (so, hoac A de nap tat ca)"

$dsNap = @()
if ($chon -match '^[Aa]$') {
    $dsNap = $devs
} else {
    $idx = 0
    if ([int]::TryParse($chon, [ref]$idx) -and $idx -ge 1 -and $idx -le $devs.Count) {
        $dsNap = @($devs[$idx - 1])
    } else {
        Write-Host "[LOI] Lua chon khong hop le." -ForegroundColor Red
        Read-Host "Bam Enter de dong"; exit
    }
}

# ---------- 2. Bien dich ----------
Write-Host ""
Write-Host "1. Bien dich input.txt sang bytecode..." -ForegroundColor Gray
& $luacExe "-s" "-o" $tempLuac $inputFile
if ($LASTEXITCODE -ne 0) {
    Write-Host "[LOI] Bien dich Lua that bai (sai cu phap)!" -ForegroundColor Red
    Read-Host "Bam Enter de dong"; exit
}

Write-Host "2. Chuyen doi sang 32-bit..." -ForegroundColor Gray
python $convertScript $tempLuac $tempLuac
if ($LASTEXITCODE -ne 0) {
    Write-Host "[LOI] Chuyen doi 64-bit sang 32-bit that bai!" -ForegroundColor Red
    Read-Host "Bam Enter de dong"; exit
}

# ---------- 3. Nap vao tung may ----------
Write-Host ""
foreach ($d in $dsNap) {
    Write-Host "3. Nap vao $d ..." -ForegroundColor Gray
    & $adb -s $d push $tempLuac $androidPath 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   OK - vao game bam nut EXEC tren may nay de chay" -ForegroundColor Green
    } else {
        Write-Host "   THAT BAI - kiem tra may con ket noi khong" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "XONG. Nho bam EXEC trong game o DUNG may vua nap." -ForegroundColor Yellow
Read-Host "Bam Enter de dong"
