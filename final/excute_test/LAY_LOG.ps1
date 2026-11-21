# =========================================================================
# [FARM KC] LAY LOG TU MAY AO - chay bang file LAY_LOG.bat
# Keo ve: output.txt, farm_failed_accounts.txt, farm_success_accounts.txt
# Ket qua gop vao KET_QUA_LOG.txt va tu mo Notepad.
# =========================================================================
$exec = $PSScriptRoot
$adb  = Join-Path $exec "adb.exe"
$base = "/storage/emulated/0/Android/data/com.vnyh.gp/files"
$ketQua = Join-Path $exec "KET_QUA_LOG.txt"

try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch {}

$dong = New-Object System.Collections.Generic.List[string]
function Ghi($s) {
    Write-Host $s
    $script:dong.Add($s)
}

Ghi "==================== LAY LOG FARM KC ===================="
Ghi ("Thoi gian: " + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
Ghi ""

if (-not (Test-Path $adb)) {
    Ghi "LOI: khong tim thay adb.exe trong $exec"
    $dong -join "`r`n" | Out-File -FilePath $ketQua -Encoding UTF8
    Read-Host "Bam Enter de dong"
    exit
}

$devs = & $adb devices | Select-String "device$" | ForEach-Object { ($_ -split "\s+")[0] }
if (-not $devs) {
    Ghi "Khong thay may ao nao dang ket noi."
    Ghi "Kiem tra: LDPlayer da bat chua? Thu chay 'adb.exe devices' de xem."
    $dong -join "`r`n" | Out-File -FilePath $ketQua -Encoding UTF8
    Read-Host "Bam Enter de dong"
    exit
}

foreach ($d in $devs) {
    Ghi "========================================================="
    Ghi "                      MAY: $d"
    Ghi "========================================================="

    # ---------- 1) output.txt ----------
    $log = Join-Path $exec "log_$d.txt"
    & $adb -s $d pull "$base/output.txt" $log 2>&1 | Out-Null
    if (Test-Path $log) {
        $f = Get-Item $log
        Ghi ("[output.txt] " + $f.Length + " bytes | sua lan cuoi: " + $f.LastWriteTime)
        Ghi ""
        Ghi "--- BAO CAO LEN WEB (quan trong nhat - 20 dong cuoi) ---"
        $bc = Select-String -Path $log -Pattern "bao web|bao cao|gui bu|Gui bu xong|DAT MUC TIEU|KHONG BAO DB|Ma moi|ma moi|report" |
              Select-Object -Last 20
        if ($bc) { $bc | ForEach-Object { Ghi ("   " + $_.Line) } }
        else { Ghi "   (chua co dong nao - chua acc nao cham muc tieu?)" }

        Ghi ""
        Ghi "--- MOC KHAC (30 dong cuoi, da BO nhip tim) ---"
        $hits = Select-String -Path $log -Pattern "FARM KC|LOGIN \d/5|SDK|SKIP ACC|HOAN THANH|FAILED|WATCHDOG|Thiet bi" |
                Where-Object { $_.Line -notmatch "NHIP TIM" } |
                Select-Object -Last 30
        if ($hits) { $hits | ForEach-Object { Ghi ("   " + $_.Line) } }
        else { Ghi "   (khong co dong nao khop)" }

        Ghi ""
        Ghi "--- NHIP TIM (3 dong cuoi) ---"
        $hb = Select-String -Path $log -Pattern "NHIP TIM" | Select-Object -Last 3
        if ($hb) { $hb | ForEach-Object { Ghi ("   " + $_.Line) } }
        else { Ghi "   (chua co)" }
        Ghi ""
        Ghi "--- 20 DONG CUOI FILE ---"
        Get-Content $log -Tail 20 | ForEach-Object { Ghi ("   " + $_) }
    } else {
        Ghi "[output.txt] KHONG KEO DUOC - game chua ghi log?"
    }

    # ---------- 2) acc FAILED ----------
    Ghi ""
    Ghi "--- ACC FAILED (15 dong cuoi) ---"
    $ff = Join-Path $exec "failed_$d.txt"
    & $adb -s $d pull "$base/farm_failed_accounts.txt" $ff 2>&1 | Out-Null
    if (Test-Path $ff) { Get-Content $ff -Tail 15 | ForEach-Object { Ghi ("   " + $_) } }
    else { Ghi "   (khong co file - chua acc nao FAILED)" }

    # ---------- 2b) HANG DOI GUI BU ----------
    Ghi ""
    Ghi "--- HANG DOI GUI BU len web (so ban ghi + 5 dong cuoi) ---"
    $fp = Join-Path $exec "pending_$d.txt"
    & $adb -s $d pull "$base/farm_invite_pending.txt" $fp 2>&1 | Out-Null
    if (Test-Path $fp) {
        $n = (Get-Content $fp | Measure-Object -Line).Lines
        Ghi ("   Con $n ban ghi CHUA len duoc web")
        Get-Content $fp -Tail 5 | ForEach-Object { Ghi ("   " + $_) }
    } else { Ghi "   (khong co file - khong con ban ghi nao cho gui bu)" }

    # ---------- 3) acc THANH CONG ----------
    Ghi ""
    Ghi "--- ACC THANH CONG / DAT MUC TIEU (15 dong cuoi) ---"
    $fs = Join-Path $exec "success_$d.txt"
    & $adb -s $d pull "$base/farm_success_accounts.txt" $fs 2>&1 | Out-Null
    if (Test-Path $fs) { Get-Content $fs -Tail 15 | ForEach-Object { Ghi ("   " + $_) } }
    else { Ghi "   (khong co file - chua acc nao dat muc tieu)" }
    Ghi ""
}

Ghi "========================= XONG =========================="
Ghi ("Da luu day du vao: " + $ketQua)

$dong -join "`r`n" | Out-File -FilePath $ketQua -Encoding UTF8
try { Start-Process notepad.exe $ketQua } catch {}
Read-Host "Bam Enter de dong cua so nay"
