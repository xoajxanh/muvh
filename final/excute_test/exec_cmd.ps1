if (Test-Path "$PSScriptRoot\diff_out.txt") {
    Remove-Item "$PSScriptRoot\diff_out.txt" -Force
    Write-Host "Removed temporary diff_out.txt"
}
