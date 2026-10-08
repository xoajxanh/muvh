& "d:\MUVH\android\mu-decompiled\lua53\luac53.exe" -p "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
if ($LASTEXITCODE -eq 0) {
    Write-Host "dev_client SYNTAX OK"
} else {
    Write-Host "dev_client SYNTAX ERROR"
}
& "d:\MUVH\android\mu-decompiled\lua53\luac53.exe" -p "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_customer\EmmyluaDebug.lua"
if ($LASTEXITCODE -eq 0) {
    Write-Host "dev_customer SYNTAX OK"
} else {
    Write-Host "dev_customer SYNTAX ERROR"
}
