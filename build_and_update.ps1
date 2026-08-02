$ErrorActionPreference = "Stop"

$versions = @("admin", "customer")

foreach ($ver in $versions) {
    Write-Host "--- BUILDING $ver VERSION ---"
    
    $modifiedDir = "final\modified_lua_$ver"
    $compiledDir = "final\compiled_lua"
    
    Write-Host "1. Compiling Lua for $ver..."
    $env:LUA_SRC_DIR = $modifiedDir
    python compile_lua.py
    
    Write-Host "2. Packing Lua to Bundle for $ver..."
    python pack_lua.py
    
    $packedFile = "final\new_lua\lua.mu2"
    $newBundlesFile = "final\new_bundles\bundles.txt"
    $apkPath = "D:\MUVH\android\mu-decompiled\test_apk\v1\MU_$ver.apk"
    $winrar = "C:\Program Files\WinRAR\WinRAR.exe"
    
    # Check if target APK exists, otherwise copy from base
    if (-not (Test-Path $apkPath)) {
        Write-Host "Creating backup for specific version..."
        Write-Host "Base APK MU_$ver.apk not found in test_apk\v1. Creating a copy from MU.apk..."
        Copy-Item "D:\MUVH\android\mu-decompiled\test_apk\v1\MU.apk" $apkPath
    }

    Write-Host "4. Calculating MD5 and Size..."
    $hash = (Get-FileHash $packedFile -Algorithm MD5).Hash.ToLower()
    $size = (Get-Item $packedFile).Length
    
    Write-Host "5. Updating bundles.txt (Hash: $hash, Size: $size)..."
    New-Item -ItemType Directory -Force -Path "final\new_bundles" | Out-Null
    python -c "
import sys
with open('D:/MUVH/android/mu-decompiled/test_apk/bundles.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()
with open('final/new_bundles/bundles.txt', 'w', encoding='utf-8') as f:
    for line in lines:
        if line.startswith('lua.mu2|'):
            f.write(f'lua.mu2|0|$hash|$size|164\n')
        else:
            f.write(line)
"
    
    Write-Host "6. Injecting files into $ver APK with WinRAR..."
    $argsLua = "a -m0 -ep -o+ -ibck -inul -apassets\Bundles `"$apkPath`" `"$packedFile`""
    Start-Process -FilePath $winrar -ArgumentList $argsLua -Wait
    Write-Host "Injected lua.mu2 into MU_$ver.apk"
    
    $argsBundles = "a -m0 -ep -o+ -ibck -inul -apassets `"$apkPath`" `"$newBundlesFile`""
    Start-Process -FilePath $winrar -ArgumentList $argsBundles -Wait
    Write-Host "Injected bundles.txt into MU_$ver.apk"
    
    Write-Host "DONE! $ver APK has been fully updated."
    Write-Host ""
}
