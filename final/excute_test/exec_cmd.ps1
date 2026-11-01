Select-String -Path "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_farm\EmmyluaDebug.lua" -Pattern "IsRecyclableEquipment" | ForEach-Object {
    Write-Host ($_.LineNumber.ToString() + ": " + $_.Line)
}
