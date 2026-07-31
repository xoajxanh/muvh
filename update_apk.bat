@echo off
set "WINRAR=C:\Program Files\WinRAR\WinRAR.exe"
set "APK_PATH=D:\MUVH\android\test_apk\v1\MU.apk"
set "LUA_FILE=D:\MUVH\android\mu-decompiled\final\new_lua\lua.mu2"
set "BUNDLES_FILE=D:\MUVH\android\test_apk\bundles.txt"

echo Dang cap nhat APK bang WinRAR (Che do Store)...

:: -a: add
:: -m0: store (khong nen)
:: -ep: bo qua duong dan thu muc khi add (chi lay ten file)
:: -ap"assets": add vao thu muc "assets" ben trong APK (doi thanh "" neu file nam o thu muc goc cua APK)
:: -o+: tu dong ghi de file cu (overwrite)

"%WINRAR%" a -m0 -ep -o+ -ap"assets\Bundles" "%APK_PATH%" "%LUA_FILE%"
"%WINRAR%" a -m0 -ep -o+ -ap"assets" "%APK_PATH%" "%BUNDLES_FILE%"

echo Da cap nhat xong!
pause
