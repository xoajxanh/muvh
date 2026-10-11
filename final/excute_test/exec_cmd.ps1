& "d:\MUVH\android\mu-decompiled\lua53\luac53.exe" -p "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
if ($LASTEXITCODE -eq 0) {
    Write-Host ">>> LUA 5.3 SYNTAX CHECK: 100% CLEAN & PASSED! <<<"
} else {
    Write-Host ">>> LUA 5.3 SYNTAX ERROR! ExitCode: $LASTEXITCODE <<<"
}
