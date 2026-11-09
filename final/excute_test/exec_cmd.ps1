$luac = "d:\MUVH\android\mu-decompiled\lua53\luac53.exe"
$files = @(
    "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua",
    "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_customer\EmmyluaDebug.lua"
)
foreach ($f in $files) {
    & $luac -p $f
    if ($LASTEXITCODE -eq 0) { Write-Output "[OK] $f" } else { Write-Output "[SYNTAX ERROR] $f" }
}
$global:LASTEXITCODE = 0
