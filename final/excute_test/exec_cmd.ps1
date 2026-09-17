$luac = "D:\MUVH\android\mu-decompiled\lua53\luac53.exe"
$target = "D:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
& $luac -p $target
if ($LASTEXITCODE -eq 0) {
    Write-Host "SYNTAX OK" -ForegroundColor Green
} else {
    Write-Host "SYNTAX ERROR" -ForegroundColor Red
}
