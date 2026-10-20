$compiler = "D:\MUVH\android\mu-decompiled\lua53\luac53.exe"
$targetLua = "D:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
& $compiler -p $targetLua
if ($LASTEXITCODE -eq 0) {
    Write-Host "[LUAC SUCCESS] Syntax check passed!"
} else {
    Write-Host "[LUAC ERROR] Syntax errors found!"
}
