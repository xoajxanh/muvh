param (
    [string]$Target = "$PSScriptRoot\exec_cmd.ps1",
    [string]$Command = ""
)

# Thiet lap ma hoa UTF-8 cho toan bo output console
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==================== [AGENT EXECUTOR] ====================" -ForegroundColor Cyan
Write-Host "Thoi gian: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

if (-not [string]::IsNullOrWhiteSpace($Command)) {
    Write-Host "Dang thuc thi Command: $Command" -ForegroundColor Yellow
} else {
    Write-Host "Dang thuc thi Script Target: $Target" -ForegroundColor Gray
}
Write-Host "---------------------------------------------------------" -ForegroundColor DarkGray

$sw = [System.Diagnostics.Stopwatch]::StartNew()

try {
    if (-not [string]::IsNullOrWhiteSpace($Command)) {
        # Thuc thi truc tiep lenh PowerShell / Git / Python truyen vao
        Invoke-Expression $Command
        $exitCode = if ($LASTEXITCODE -ne $null) { $LASTEXITCODE } else { 0 }
    } else {
        if (-not (Test-Path $Target)) {
            Write-Host "[ERROR] Khong tim thay file kich ban: $Target" -ForegroundColor Red
            exit 1
        }
        # Chay file kich ban duoc chi dinh (vd: exec_cmd.ps1)
        & $Target
        $exitCode = if ($LASTEXITCODE -ne $null) { $LASTEXITCODE } else { 0 }
    }
    
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
