$luac = "D:\MUVH\android\mu-decompiled\lua53\luac53.exe"
$dir = "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client"

Write-Host "Checking all Lua files in: $dir"
$files = Get-ChildItem -Path $dir -Filter "*.lua"

$hasError = $false
foreach ($f in $files) {
    Write-Host "Checking: $($f.Name)..."
    & $luac -p $f.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Syntax error in: $($f.Name)" -ForegroundColor Red
        $hasError = $true
    } else {
        Write-Host "  -> [OK]" -ForegroundColor Green
    }
}

if (-not $hasError) {
    Write-Host "ALL LUA FILES COMPILED SUCCESSFULLY!" -ForegroundColor Green
}
