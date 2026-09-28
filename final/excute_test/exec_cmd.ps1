$luac = "d:\MUVH\android\mu-decompiled\lua53\luac53.exe"
$target = "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
& $luac -p $target
if ($LASTEXITCODE -eq 0) {
    Write-Output "SYNTAX CHECK: SUCCESS (EmmyluaDebug.lua is VALID)"
} else {
    Write-Error "SYNTAX CHECK: FAILED with exit code $LASTEXITCODE"
}
