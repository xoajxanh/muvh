local CommerceActivityManager = {}
setmetatable(CommerceActivityManager, LuaClass.ActivityManagerBase)

function CommerceActivityManager:GetSortAndShowActivity()
  local activityList, sortFilterList = self:GetAllActivityData(), {}
  for k, v in pairs(activityList) do
    if v:GetCommerce_CombineoverviewTbl() ~= nil and v:GetCommerce_CombineoverviewTbl().hide > 0 and v:GetActivityState() == ActivityStatusEnum.RUNNING then
      table.insert(sortFilterList, v)
    end
  end
  table.sort(sortFilterList, self.SortCompare)
  return sortFilterList
end

function CommerceActivityManager.SortCompare(activityA, activityB)
  return activityA:GetCommerce_CombineoverviewTbl().order < activityB:GetCommerce_CombineoverviewTbl().order
end

function CommerceActivityManager:GetActivityTbl()
  return ClientTable.cfg_Commerce_CombineoverviewManager:GetDic()
end

function CommerceActivityManager:GetActivityClass(activityId)
  if activityId == CommerceActivityIdType.MiracleBattlePass then
    return LuaClass.MiracleBattlePass:New()
  elseif activityId == CommerceActivityIdType.LianChongFanLi then
    return LuaClass.Co_serving_LianChongFanLiData:New()
  elseif activityId == CommerceActivityIdType.CombineFirstGiftData then
    return LuaClass.CombineFirstGiftData:New()
  elseif activityId == CommerceActivityIdType.GoodFiftsEveryDay then
    return LuaClass.GoodFiftsEveryDayData:New()
  elseif activityId == CommerceActivityIdType.ConsumeRanking then
    return LuaClass.CommercialRankingData:New()
  elseif activityId == CommerceActivityIdType.CombineTask then
    return LuaClass.CombineTaskData:New()
  end
  return LuaClass.CommerceActivity:New()
end

function CommerceActivityManager:GetActivityChangeEventId()
  return Event.CommerceCombineActivityStateChange
end

function CommerceActivityManager:RefreshActivityData(data)
  if CommercializeActivityTab.Combining_service ~= data.icon then
    return
  end
  if QuickFind:Co_serving_LCFLData() ~= nil and data.groupId == CommerceActivityIdType.LianChongFanLi then
    QuickFind:Co_serving_LCFLData():RereshDataByServerData(data.taskInfo)
  end
  if QuickFind:GetCombineFirstGiftData() ~= nil and data.groupId == CommerceActivityIdType.CombineFirstGiftData then
    QuickFind:GetCombineFirstGiftData():SetShopInfoData(data.shopInfo)
    EventManager.Dispatch(Event.CombineFirstGiftDataRefesh)
  end
  if QuickFind:CommercialRankingData() ~= nil and data.groupId == CommerceActivityIdType.ConsumeRanking then
    QuickFind:CommercialRankingData():ActivityannouncementUI(data.costDiamondRank)
  end
  if gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.MiracleBattlePass) ~= nil and data.groupId == CommerceActivityIdType.MiracleBattlePass then
    gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.MiracleBattlePass):RefreshDataByServerData(data.zhanLingInfo)
  end
  if QuickFind:GetGoodFiftsEveryDayData() ~= nil and data.groupId == CommerceActivityIdType.GoodFiftsEveryDay then
    QuickFind:GetGoodFiftsEveryDayData():RefreshDataByServerData(data.zhanLingInfo)
  end
end

return CommerceActivityManager
