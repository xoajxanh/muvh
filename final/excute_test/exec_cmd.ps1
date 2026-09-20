& "d:\MUVH\android\mu-decompiled\lua53\luac53.exe" -p "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
if ($LASTEXITCODE -eq 0) {
    Write-Output "LUAC SYNTAX CHECK PASSED: EmmyluaDebug.lua is clean!"
} else {
    Write-Output "LUAC SYNTAX CHECK FAILED with code $LASTEXITCODE"
}
