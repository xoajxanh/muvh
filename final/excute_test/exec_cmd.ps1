$luaFile = "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
$luac = "D:\MUVH\android\mu-decompiled\lua53\luac53.exe"
& $luac -p $luaFile
Write-Host "Luac exit code: $LASTEXITCODE"
