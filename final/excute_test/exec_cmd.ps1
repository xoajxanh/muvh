$luacPath = "D:\MUVH\android\mu-decompiled\lua53\luac53.exe"
if (-not (Test-Path $luacPath)) {
    $luacPath = (Get-ChildItem -Path "D:\MUVH\android\mu-decompiled" -Filter "*luac*.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
}

Write-Output "Checking Customer lua syntax..."
& $luacPath -p "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_customer\EmmyluaDebug.lua"
if ($LASTEXITCODE -eq 0) {
    Write-Output "CUSTOMER LUA SYNTAX CHECK PASSED: EmmyluaDebug.lua is valid syntax!"
} else {
    Write-Output "CUSTOMER LUA SYNTAX ERROR!"
}
