param (
    [string]$Target = "$PSScriptRoot\exec_cmd.ps1"
)

# Thiet lap ma hoa UTF-8 cho toan bo output console
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==================== [AGENT EXECUTOR] ====================" -ForegroundColor Cyan
Write-Host "Dang thuc thi: $Target" -ForegroundColor Gray
Write-Host "Thoi gian: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "---------------------------------------------------------" -ForegroundColor DarkGray

if (-not (Test-Path $Target)) {
    Write-Host "[ERROR] Khong tim thay file kich ban: $Target" -ForegroundColor Red
    exit 1
}

$outputFile = "$PSScriptRoot\exec_output.txt"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
    # Chay file kich ban duoc chi dinh
    & $Target
    $exitCode = if ($LASTEXITCODE -ne $null) { $LASTEXITCODE } else { 0 }
    
    $sw.Stop()
    Write-Host "---------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "[SUCCESS] Thuc thi thanh cong trong $($sw.ElapsedMilliseconds)ms (ExitCode: $exitCode)" -ForegroundColor Green
    Write-Host "=========================================================" -ForegroundColor Cyan
    exit $exitCode
}
catch {
    $sw.Stop()
    Write-Host "---------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "[FAILED] Gap loi ngoai le khi thuc thi: $_" -ForegroundColor Red
    Write-Host "Stack Trace:`n$($_.ScriptStackTrace)" -ForegroundColor DarkRed
    Write-Host "=========================================================" -ForegroundColor Cyan
    exit 1
}
