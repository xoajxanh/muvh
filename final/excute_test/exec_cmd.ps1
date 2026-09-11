# Syntax & line count check
$luaFile = "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_customer\EmmyluaDebug.lua"
Write-Output "Checking file: $luaFile"
$lines = (Get-Content $luaFile).Count
Write-Output "Total lines: $lines"
