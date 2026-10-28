Get-ChildItem -Path 'd:\MUVH\android\mu-decompiled\final\excute_test' -Recurse | ForEach-Object { Write-Host "$($_.Mode) $($_.FullName)" }
