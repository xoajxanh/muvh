$oldLines = git show "dc9a1d7:final/modified_lua_dev_client/EmmyluaDebug.lua"
$old = $oldLines -join "`n"
$curr = Get-Content 'd:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua' -Raw

Write-Host "================== CHI TIET CAC THAY DOI THEO TUNG MODULE =================="

Write-Host "`n--- 1. Auto PK và Khoa Muc Tieu ---"
$pkKeys = @('isMatchLockTarget', 'IsPlayerProtected', 'GetNearestPlayerTarget', 'GetPlayerTarget', 'IsSelfBuffOrNoTargetSkill', 'isMonsterNearby', 'Mod_PKScanLoopStarted', 'Mod_StartPKScanLoop')
foreach ($k in $pkKeys) {
    Write-Host ($k + " -> Old: " + ($old.Contains($k)) + " | New: " + ($curr.Contains($k)))
}

Write-Host "`n--- 2. Auto Loot va Nhat Do ---"
$lootKeys = @('ExecutePickupCommon', 'Mod_PerformVacuumItems', 'HyperBurst', 'Fumo', 'Rune', 'Bone', 'AutoPick_Mode', 'CanAutoPickUpDropItem')
foreach ($k in $lootKeys) {
    Write-Host ($k + " -> Old: " + ($old.Contains($k)) + " | New: " + ($curr.Contains($k)))
}

Write-Host "`n--- 3. Boss FSM va Telegram ---"
$bossKeys = @('TelegramNotifyBossAlive', 'ReqGetBossMapAndCount', 'ReqAncientBossInfo', 'Mod_AutoBoss_SkipHpPct', 'KundunTitleGo', 'ModUpdateKundunUI')
foreach ($k in $bossKeys) {
    Write-Host ($k + " -> Old: " + ($old.Contains($k)) + " | New: " + ($curr.Contains($k)))
}

Write-Host "`n--- 4. Speed, Camera va Lam Muot ---"
$speedKeys = @('Mod_SmoothCamera_Timer', 'Mod_SpeedAnimLockLoop', 'Mod_DoSystemFreshCleanup', 'Mod_StartTrackedTimer', 'Mod_TrackedTimers')
foreach ($k in $speedKeys) {
    Write-Host ($k + " -> Old: " + ($old.Contains($k)) + " | New: " + ($curr.Contains($k)))
}
