Set-Location "d:\MUVH\android\mu-decompiled\final"
Write-Output "===== COMMITS LIEN QUAN C13-15 / TIER / CHUYEN ====="
git log --all --date=short --pretty=format:"%h %ad %s" -i --grep="13" --grep="15" --grep="tier" --grep="chuy" --grep="C1" --grep="reinc" | Select-Object -First 40
Write-Output ""
Write-Output "===== COMMIT CHAM svip-tokens/page.tsx ====="
git log --all --date=short --pretty=format:"%h %ad %s" -- "web_active/app/svip-tokens/page.tsx" | Select-Object -First 15
Write-Output ""
Write-Output "===== COMMIT CHAM tokens/create/page.tsx ====="
git log --all --date=short --pretty=format:"%h %ad %s" -- "web_active/app/tokens/create/page.tsx" | Select-Object -First 15
Write-Output ""
Write-Output "===== COMMIT 527f525 (files) ====="
git show --stat --pretty=format:"%h %ad %s%n%b" 527f525 | Select-Object -First 40
$global:LASTEXITCODE = 0
