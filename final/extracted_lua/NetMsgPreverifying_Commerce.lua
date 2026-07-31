netMsgPreprocessing[21002] = function(msgID, tblData)
end
netMsgPreprocessing[21004] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():SetCommercialActivityInfo(tblData)
  gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):RefreshActivityData(tblData)
  gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.LimitedTimeActivity):RefreshActivityData(tblData)
end
netMsgPreprocessing[21007] = function(msgID, tblData)
end
netMsgPreprocessing[21009] = function(msgID, tblData)
end
netMsgPreprocessing[21011] = function(msgID, tblData)
  if tblData ~= nil and tblData.advanceDay ~= nil then
    LoginData.ServerTimeAdvance = tblData.advanceDay
    Time.SetRemoteOpenTime(tblData.remoteOpenTime)
    Time.SetCommerceCount(tblData.combineCount)
    Time.SetCommerceTime(tblData.combineTime)
  end
end
netMsgPreprocessing[21013] = function(msgID, tblData)
  if tblData ~= nil and gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetHolidayLuckyTurntableManager() ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetHolidayLuckyTurntableManager():RefreshAllDataByServer(tblData)
  end
end
netMsgPreprocessing[21015] = function(msgID, tblData)
  if tblData ~= nil and gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetHolidayLuckyTurntableManager() ~= nil then
    gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetHolidayLuckyTurntableManager():RefreshCumulativeRewardData(tblData)
  end
end
netMsgPreprocessing[21017] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetOtherPlayer():GetActivityDataMgr():GetTurntableUIDataMgr():GetturntableData(tblData)
end
netMsgPreprocessing[21020] = function(msgID, tblData)
  QuickFind:GetWorldCupGuessData():RefreshDataByServerData(tblData)
end
netMsgPreprocessing[21023] = function(msgID, tblData)
end
netMsgPreprocessing[21027] = function(msgID, tblData)
  return QuickFind:GetSpringActivityDataMgr():RefreshSpringActivity(tblData)
end
netMsgPreprocessing[21029] = function(msgID, tblData)
  if QuickFind:GetFirecrackerTreasureHuntingDataMgr() and tblData then
    QuickFind:GetFirecrackerTreasureHuntingDataMgr():RefreshAllData(tblData)
  end
end
netMsgPreprocessing[21031] = function(msgID, tblData)
  if QuickFind:GetFirecrackerTreasureHuntingDataMgr() and tblData then
    QuickFind:GetFirecrackerTreasureHuntingDataMgr():RefreshCumulativeRewardData(tblData)
  end
end
netMsgPreprocessing[21033] = function(msgID, tblData)
  QuickFind:GetSevenDayGiftData():RefreshDataByServerData(tblData)
end
netMsgPreprocessing[21034] = function(msgID, tblData)
  if tblData then
    QuickFind:GetYutulaixiDataMgr():RefreshServerData(tblData)
  end
end
netMsgPreprocessing[21039] = function(msgID, tblData)
  if QuickFind:GetOpenServerInvestmentData() and tblData then
    QuickFind:GetOpenServerInvestmentData():RefreshDataByServerData(tblData)
  end
end
netMsgPreprocessing[21041] = function(msgID, tblData)
  local isHaveLimitedTimeType = false
  if tblData and table.count(tblData.tabInfo) > 0 then
    for i, tabInfo in pairs(tblData.tabInfo) do
      if tabInfo.icon == CommercializeActivityTab.LimitedTime then
        CommercialTimeLimitedActivityData.ResOpenGroups = tabInfo.group
        isHaveLimitedTimeType = true
      end
    end
  end
  if isHaveLimitedTimeType == false then
    CommercialTimeLimitedActivityData.ResOpenGroups = nil
  end
  EventManager.Dispatch(Event.ResOpenIconInfo)
end
netMsgPreprocessing[21044] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.CombineTask):RefreshData(tblData)
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.combineActivity,
      state = true
    })
  end
  EventManager.Dispatch(Event.CombineTask)
end
netMsgPreprocessing[21046] = function(msgID, tblData)
  if tblData ~= nil then
    gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.LuckyRebate):RefreshDataByServerData(tblData)
  end
end
netMsgPreprocessing[21047] = function(msgID, tblData)
  QuickFind:GetConnectionNiudanManager():ServerClientRefreshData(tblData)
end
netMsgPreprocessing[21052] = function(msgID, tblData)
  if tblData and QuickFind:GetHolidayInvestData() then
    QuickFind:GetHolidayInvestData():RefreshDataByServerData(tblData)
  end
end
netMsgPreprocessing[21053] = function(msgID, tblData)
  QuickFind:GetConnectionGiftManager():ServerClientRefreshData(tblData)
end
netMsgPreprocessing[21055] = function(msgID, tblData)
  QuickFind:GetConnectionNiudanManager():InitShowData(tblData)
  EventManager.Dispatch(Event.NiudanEEffectRefresh)
end
netMsgPreprocessing[21056] = function(msgID, tblData)
  gameMgr:GetAvatarManager():GetMainPlayer():GetRewriteNamingData():RefreshData(tblData)
end
netMsgPreprocessing[21059] = function(msgID, tblData)
  if tblData.code == 1 then
    EventManager.Dispatch(Event.IsNamingDetection, tblData)
  else
    FloatingTipUtility.QuickMsg(tblData.data)
  end
end
netMsgPreprocessing[21061] = function(msgID, tblData)
  if tblData then
    CommercialHolidayData.CrazyShoppingCarInfo = tblData
    QuickFind:GetShoppingSpreeDataMgr():RefreshServerData(tblData)
    EventManager.Dispatch(Event.CrazyShoppingCarInfo)
  end
end
netMsgPreprocessing[21067] = function(msgID, tblData)
end
netMsgPreprocessing[21069] = function(msgID, tblData)
end
netMsgPreprocessing[21070] = function(msgID, tblData)
end
