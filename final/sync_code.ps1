Write-Host "Syncing from dev to admin..."
Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_admin" -Recurse -Force

Write-Host "Syncing from dev to customer..."
Copy-Item -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev\*" -Destination "d:\MUVH\android\mu-decompiled\final\modified_lua_customer" -Recurse -Force

Write-Host "Patching customer version (Mod_IsAdmin = false)..."
$customerLua = "d:\MUVH\android\mu-decompiled\final\modified_lua_customer\EmmyluaDebug.lua"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$content = [System.IO.File]::ReadAllText($customerLua, $utf8NoBom)
$content = $content.Replace("_G.Mod_IsAdmin = true", "_G.Mod_IsAdmin = false")
[System.IO.File]::WriteAllText($customerLua, $content, $utf8NoBom)

Write-Host "Sync Complete!"
