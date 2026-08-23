local HolidayActivityManager = {}
setmetatable(HolidayActivityManager, LuaClass.ActivityManagerBase)

function HolidayActivityManager:GetActivityTbl()
  return ClientTable.cfg_Commerce_HolidayoverviewManager:GetDic()
end

function HolidayActivityManager:GetActivityClass(activityId)
  if activityId == HolidayActivityIdType.WorldCupGuess then
    return LuaClass.WorldCupGuessData:New()
  elseif activityId == HolidayActivityIdType.SpringActivity then
    return LuaClass.SpringActivityManger:New()
  elseif activityId == HolidayActivityIdType.SevenDayGift then
    return LuaClass.SevenDayGiftData:New()
  elseif activityId == HolidayActivityIdType.FirecrackerTreasureHunting then
    return LuaClass.FirecrackerTreasureHuntingDataMgr:New()
  elseif activityId == HolidayActivityIdType.Yutulaixi then
    return LuaClass.YutulaixiData:New()
  elseif activityId == HolidayActivityIdType.HolidayInvest then
    return LuaClass.HolidayInvestData:New()
  elseif activityId == HolidayActivityIdType.ConnectionGift then
    return LuaClass.ConnectionGift:New()
  elseif activityId == HolidayActivityIdType.DiamondGashapon then
    return LuaClass.Commercial_NetNiudanManager:New()
  elseif activityId == HolidayActivityIdType.LuckyRebate then
    return LuaClass.LuckyRebateData:New()
  elseif activityId == HolidayActivityIdType.ShoppongSpree then
    return LuaClass.ShoppingSpreeData:New()
  end
  return LuaClass.HolidayActivity:New()
end

function HolidayActivityManager:GetActivityChangeEventId()
end

function HolidayActivityManager:RefreshActivityData(data)
  if CommercializeActivityTab.Holiday ~= data.icon then
    return
  end
end

return HolidayActivityManager
