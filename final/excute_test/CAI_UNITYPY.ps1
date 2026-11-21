# =========================================================================
# [BUILD] CAI UnityPy vao mot ban Python phu hop (3.10 - 3.13)
# Chay bang file CAI_UNITYPY.bat
# =========================================================================
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

Write-Host "=============== KIEM TRA PYTHON TREN MAY ===============" -ForegroundColor Cyan

$coLauncher = $null
try { $coLauncher = Get-Command py -ErrorAction Stop } catch {}

if (-not $coLauncher) {
    Write-Host "Khong tim thay 'py' (Python Launcher)." -ForegroundColor Red
    Write-Host "Hay tai Python 3.12 tai: https://www.python.org/downloads/release/python-3128/"
    Write-Host "Khi cai nho TICK 'Add python.exe to PATH' va 'py launcher'."
    Read-Host "Bam Enter de dong"
    exit
}

Write-Host "Cac ban Python dang co:" -ForegroundColor Gray
& py -0p

# Thu lan luot cac ban co wheel san, moi nhat truoc
$ungVien = @("3.13", "3.12", "3.11", "3.10")
$chon = $null
foreach ($v in $ungVien) {
    $null = & py -$v -c "print(1)" 2>$null
    if ($LASTEXITCODE -eq 0) { $chon = $v; break }
}

if (-not $chon) {
    Write-Host ""
    Write-Host "Tren may chi co Python qua moi (3.15) - UnityPy chua co ban dung san." -ForegroundColor Yellow
    Write-Host "Cach nhanh nhat: cai them Python 3.12 (cai song song, khong anh huong 3.15):" -ForegroundColor Yellow
    Write-Host "   https://www.python.org/downloads/release/python-3128/"
    Write-Host "   -> tai 'Windows installer (64-bit)', cai xong chay lai file nay."
    Read-Host "Bam Enter de dong"
    exit
}

Write-Host ""
Write-Host "=> Dung Python $chon de cai UnityPy..." -ForegroundColor Green
& py -$chon -m pip install --upgrade pip
& py -$chon -m pip install UnityPy

Write-Host ""
Write-Host "--- KIEM TRA LAI ---" -ForegroundColor Cyan
& py -$chon -c "import UnityPy; print('UnityPy OK, phien ban:', UnityPy.__version__)"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Cai that bai. Thu ban thap hon, vi du: py -3.11 -m pip install UnityPy" -ForegroundColor Red
    Read-Host "Bam Enter de dong"
    exit
}

# Lay duong dan python.exe cua ban vua cai de script build dung dung no
$duongDan = (& py -$chon -c "import sys; print(sys.executable)").Trim()
Write-Host ""
Write-Host "Duong dan Python: $duongDan" -ForegroundColor Gray

[Environment]::SetEnvironmentVariable("MU_PYTHON", $duongDan, "User")
Write-Host "Da ghi bien moi truong MU_PYTHON (pham vi User)." -ForegroundColor Green
Write-Host ""
Write-Host "XONG. Hay DONG cua so PowerShell/CMD dang mo roi mo lai," -ForegroundColor Yellow
Write-Host "sau do chay lai build_and_update.ps1." -ForegroundColor Yellow
Read-Host "Bam Enter de dong"
