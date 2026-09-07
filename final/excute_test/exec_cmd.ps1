# Kich ban scan diff duoc thuc thi boi Executor
$oldLines = git show "dc9a1d7:final/modified_lua_dev_client/EmmyluaDebug.lua"
$old = $oldLines -join "`n"
$curr = Get-Content 'd:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua' -Raw

Write-Host "================== KET QUA SCAN DIFF QUA EXECUTOR ==================" -ForegroundColor Yellow

Write-Host "`n--- 1. Auto PK & Khoa Muc Tieu ---" -ForegroundColor Cyan
$pkKeys = @('isMatchLockTarget', 'IsPlayerProtected', 'GetNearestPlayerTarget', 'GetPlayerTarget', 'IsSelfBuffOrNoTargetSkill', 'isMonsterNearby', 'Mod_StartPKScanLoop')
foreach ($k in $pkKeys) {
    $inOld = if ($old.Contains($k)) { "YES" } else { "NO" }
    $inNew = if ($curr.Contains($k)) { "YES" } else { "NO" }
    Write-Host ("  * " + $k.PadRight(28) + " -> Ban cu (dc9a1d7): " + $inOld.PadRight(5) + "| Ban moi (HEAD): " + $inNew)
}

Write-Host "`n--- 2. Auto Loot & Nhat Do ---" -ForegroundColor Cyan
$lootKeys = @('ExecutePickupCommon', 'Mod_PerformVacuumItems', 'Mod_PerformBagRecycle', 'Fumo', 'Rune', 'Bone', 'AutoPick_Mode', 'CanAutoPickUpDropItem')
foreach ($k in $lootKeys) {
    $inOld = if ($old.Contains($k)) { "YES" } else { "NO" }
    $inNew = if ($curr.Contains($k)) { "YES" } else { "NO" }
    Write-Host ("  * " + $k.PadRight(28) + " -> Ban cu (dc9a1d7): " + $inOld.PadRight(5) + "| Ban moi (HEAD): " + $inNew)
}

Write-Host "`n--- 3. Săn Boss & Kundun & Telegram ---" -ForegroundColor Cyan
$bossKeys = @('ReqGetBossMapAndCount', 'ReqAncientBossInfo', 'Mod_AutoBoss_SkipHpPct', 'KundunTitleGo', 'ModUpdateKundunUI', 'Mod_StartReturnPosLoop')
foreach ($k in $bossKeys) {
    $inOld = if ($old.Contains($k)) { "YES" } else { "NO" }
    $inNew = if ($curr.Contains($k)) { "YES" } else { "NO" }
    Write-Host ("  * " + $k.PadRight(28) + " -> Ban cu (dc9a1d7): " + $inOld.PadRight(5) + "| Ban moi (HEAD): " + $inNew)
}

Write-Host "`n--- 4. Speed & Camera & Lam Muot ---" -ForegroundColor Cyan
$speedKeys = @('Mod_DoSystemFreshCleanup', 'Mod_StartTrackedTimer', 'Mod_StartSpeedAnimLockLoop', 'Mod_StartSmoothCameraLoop', 'Mod_StartVisualMasterLoop', 'Mod_StartGoldenChestLoop')
foreach ($k in $speedKeys) {
    $inOld = if ($old.Contains($k)) { "YES" } else { "NO" }
    $inNew = if ($curr.Contains($k)) { "YES" } else { "NO" }
    Write-Host ("  * " + $k.PadRight(28) + " -> Ban cu (dc9a1d7): " + $inOld.PadRight(5) + "| Ban moi (HEAD): " + $inNew)
}
