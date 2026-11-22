# =========================================================================
# [TIEN ICH] XAC DINH CUA SO GIA LAP NAO UNG VOI SERIAL ADB NAO
# Chup man hinh tung thiet bi thanh anh rieng, dat ten theo serial,
# roi mo thu muc len. Nhin anh la biet ngay may nao la may nao.
# =========================================================================
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$exec = $PSScriptRoot
$adb  = Join-Path $exec "adb.exe"
$thuMuc = Join-Path $exec "anh_may_ao"

if (-not (Test-Path $adb)) {
    Write-Host "[LOI] Khong thay adb.exe" -ForegroundColor Red
    Read-Host "Bam Enter de dong"; exit
}

New-Item -ItemType Directory -Force -Path $thuMuc | Out-Null
Get-ChildItem $thuMuc -Filter "*.png" -ErrorAction SilentlyContinue | Remove-Item -Force

$devs = & $adb devices | Select-String "device$" | ForEach-Object { ($_ -split "\s+")[0] }
if (-not $devs) {
    Write-Host "Khong thay may ao nao dang ket noi." -ForegroundColor Yellow
    Read-Host "Bam Enter de dong"; exit
}

Write-Host "============ CHUP MAN HINH TUNG MAY ============" -ForegroundColor Cyan
foreach ($d in $devs) {
    $anh = Join-Path $thuMuc "$d.png"
    Write-Host "  Dang chup $d ..." -ForegroundColor Gray
    # exec-out giu nguyen byte, khong bi loi xuong dong cua Windows
    & $adb -s $d exec-out screencap -p > $anh
    if ((Test-Path $anh) -and ((Get-Item $anh).Length -gt 1000)) {
        Write-Host "     OK -> $anh" -ForegroundColor Green
    } else {
        Write-Host "     Chup that bai" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Mo thu muc anh: $thuMuc" -ForegroundColor Yellow
Write-Host "Ten file chinh la serial cua may do." -ForegroundColor Yellow
try { Start-Process explorer.exe $thuMuc } catch {}
Read-Host "Bam Enter de dong"
