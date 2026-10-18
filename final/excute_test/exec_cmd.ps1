$file = "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
Select-String -Path $file -Pattern "RefreshMainTabs" | Select-Object -First 10 | ForEach-Object { "$($_.LineNumber): $($_.Line.Trim())" }
