netMsgPreprocessing[2001] = function(msgID, tblData)
  if tblData ~= nil and RoleManager.me ~= nil then
    if RoleManager.me.id == tblData.uid then
      local lastCareerCategory = RoleUtility.GetCurrentCareerCategory()
      gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():Refresh(tblData)
      if lastCareerCategory ~= RoleUtility.GetCurrentCareerCategory() then
        BagSellController.ChangeBagSellConfigByCareer()
      end
    else
      local avatar = gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Player, tblData.uid)
      if avatar then
        avatar:GetInfo():Refresh(tblData)
      end
    end
  end
end
netMsgPreprocessing[2002] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager().MeID = tblData.basic.info.roleId
    gameMgr:GetAvatarManager():GetMainPlayer():RefreshMeAttr(tblData)
  end
end
netMsgPreprocessing[2003] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():RefreshMeEXAttr(tblData)
  end
end
netMsgPreprocessing[2004] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():RefreshMeBy2004(tblData)
    EventManager.Dispatch(Event.KoreaSDKClienAirbrigeAndFirebase, {
      type = KoreaSDKEnum.airbridgeachieveLevel,
      param = "",
      reason = "",
      node = KoreaSDKNodeEnum.airbridge
    })
  end
end
netMsgPreprocessing[2006] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():RefreshMeBy2006(tblData)
  end
end
netMsgPreprocessing[2008] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():RefrashData(tblData.info)
    gameMgr:GetAvatarManager():GetOtherPlayer():GetGuardData():SetGuardInfo(tblData.guardInfo)
    gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():RefreshAllData(tblData.equips)
    gameMgr:GetAvatarManager():GetOtherPlayer():GetRuneDataMgr():ServerUpdateRuneData(tblData.reRuneInfoPackingInfo)
    gameMgr:GetAvatarManager():GetOtherPlayer():GetHolyRingDataMgr():RefreshOtherHoleData(tblData.holyRingInfo)
    gameMgr:GetAvatarManager():GetOtherPlayer():GetSacredBoneDataMgr():RefreshSacredBoneEquipInfo(tblData)
    gameMgr:GetAvatarManager():GetOtherPlayer():GetEnchantEquipManager():ResAllEnchantInfo(tblData)
    EventManager.Dispatch(Event.Rank_EquipInfoUIOpen)
    EventManager.Dispatch(Event.NamingPlayerData, tblData)
  end
end
netMsgPreprocessing[2009] = function(msgID, tblData)
end
netMsgPreprocessing[2011] = function(msgID, tblData)
end
netMsgPreprocessing[2012] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():RefreshMeBy2012(tblData)
  end
end
netMsgPreprocessing[2014] = function(msgID, tblData)
end
netMsgPreprocessing[2018] = function(msgID, tblData)
end
netMsgPreprocessing[2020] = function(msgID, tblData)
end
netMsgPreprocessing[2021] = function(msgID, tblData)
end
netMsgPreprocessing[2022] = function(msgID, tblData)
end
netMsgPreprocessing[2023] = function(msgID, tblData)
end
netMsgPreprocessing[2024] = function(msgID, tblData)
end
netMsgPreprocessing[2026] = function(msgID, tblData)
end
netMsgPreprocessing[2027] = function(msgID, tblData)
end
netMsgPreprocessing[2028] = function(msgID, tblData)
end
netMsgPreprocessing[2031] = function(msgID, tblData)
end
netMsgPreprocessing[2033] = function(msgID, tblData)
end
netMsgPreprocessing[2034] = function(msgID, tblData)
end
netMsgPreprocessing[2035] = function(msgID, tblData)
end
netMsgPreprocessing[2036] = function(msgID, tblData)
end
netMsgPreprocessing[2038] = function(msgID, tblData)
end
netMsgPreprocessing[2039] = function(msgID, tblData)
end
netMsgPreprocessing[2040] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():RefreshMeBy2040(tblData)
  end
end
netMsgPreprocessing[2042] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():RefreshData(tblData)
  end
end
netMsgPreprocessing[2046] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():RefreshTaskData(tblData)
  end
end
netMsgPreprocessing[2048] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():SetGuardInfo(tblData)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.guard
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.guard_culture
  })
end
netMsgPreprocessing[2052] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr():InitExpAdditionData(tblData)
  end
end
netMsgPreprocessing[2053] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetExperienceBonusMgr():RefreshExpAdditionData(tblData)
  end
end
netMsgPreprocessing[2054] = function(msgID, tblData)
  if tblData then
    if tblData.messageType == 1 then
      if ViewData.meData ~= nil and ViewData.meData.reincarnationLevel ~= nil then
        ViewData.meData.reincarnationLevel = tblData.level
      end
      EventManager.Dispatch(Event.InsertAutoPopUI, UIID.Zhuansheng_TIpsUI)
    elseif tblData.messageType == 2 then
      networkRequest.ReqGuardInfo()
    elseif tblData.messageType == 3 then
      BagSellController.ClearRecycleTogConfigAndSave()
    end
  end
end
netMsgPreprocessing[2057] = function(msgID, tblData)
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():RefreshExpCountData(tblData)
  end
end
netMsgPreprocessing[2058] = function(msgID, tblData)
  local avatar = gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Player, tblData.roleId)
  if avatar then
    avatar:GetShieldDataMgr():RefreshAngelData(tblData)
  end
end
netMsgPreprocessing[2059] = function(msgID, tblData)
end
netMsgPreprocessing[2060] = function(msgID, tblData)
  if tblData == nil then
    return
  end
  local timeLeft = tblData.endTime - Time.GetServerTime()
  timeLeft = 0 < timeLeft and timeLeft or 0
  local nowschedule = 0
  if tblData.allCd ~= 0 then
    nowschedule = timeLeft / tblData.allCd
  end
  local Client_SkillCdSpeedUpdate = {
    skillId = tblData.skillId,
    remainingCd = timeLeft,
    allCd = tblData.allCd,
    schedule = nowschedule
  }
  MeController.SpecialChangeClientSkillCd(tblData.skillId, tblData.endTime)
  EventManager.Dispatch(Event.Skill_CdSpeedUpdate, Client_SkillCdSpeedUpdate)
end
netMsgPreprocessing[2061] = function(msgID, tblData)
  local avatar = gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Player, tblData.roleId)
  if avatar then
    avatar:GetShieldDataMgr():RefreshUniversalData(tblData)
  end
end
netMsgPreprocessing[2065] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():OnResHoleChange(tblData)
  end
end
netMsgPreprocessing[2066] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():OnResHoleInfo(tblData)
  end
end
netMsgPreprocessing[2067] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():OnResUpgradeHolyRing(tblData)
  end
end
netMsgPreprocessing[2069] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():OnResHolyRingExpChange(tblData)
  end
end
netMsgPreprocessing[2071] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():SetRoleEquipNormalPos(tblData)
end
netMsgPreprocessing[2072] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetClimBTowerData():RefreshLevel(tblData)
  end
end
netMsgPreprocessing[2075] = function(msgID, tblData)
end
netMsgPreprocessing[2077] = function(msgID, tblData)
end
netMsgPreprocessing[2081] = function(msgID, tblData)
end
netMsgPreprocessing[2084] = function(msgID, tblData)
end
netMsgPreprocessing[2086] = function(msgID, tblData)
  if tblData then
    if tblData.inBag then
      CrystalNucleusBagManager:OnResBagItemChange(tblData.items)
    else
      CrystalNucleusManager:RefreshCrystalNucleusEquipInfo(tblData.items)
    end
  end
end
netMsgPreprocessing[2088] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivity_SeaChestData():ReasherNet(tblData)
  end
end
netMsgPreprocessing[2092] = function(msgID, tblData)
  if tblData and gameMgr:GetAvatarManager() then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivity_SeaChestData():GetDataRewardTitle(tblData)
  end
end
netMsgPreprocessing[2095] = function(msgID, tblData)
end
