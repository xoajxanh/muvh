local TimeLimitedActivityManager = {}
setmetatable(TimeLimitedActivityManager, LuaClass.ActivityManagerBase)

function TimeLimitedActivityManager:GetActivityTbl()
  return ClientTable.cfg_Commerce_TimeLimitedoverviewManager:GetDic()
end

function TimeLimitedActivityManager:GetActivityClass(activityId)
  if activityId == TimeLimitedActivityIdType.OpenServerInvestment then
    return LuaClass.OpenServerInvestmentData:New()
  elseif activityId == TimeLimitedActivityIdType.MiracleBattlePass then
    return LuaClass.TimeLimited_MiracleBattlePass:New()
  end
  return LuaClass.TimeLimitedActivity:New()
end

function TimeLimitedActivityManager:GetActivityChangeEventId()
end

function TimeLimitedActivityManager:RefreshActivityData(data)
  if CommercializeActivityTab.LimitedTime ~= data.icon then
    return
  end
  if gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.LimitedTimeActivity):GetActivityData(TimeLimitedActivityIdType.MiracleBattlePass) ~= nil and data.groupId == TimeLimitedActivityIdType.MiracleBattlePass then
    gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.LimitedTimeActivity):GetActivityData(TimeLimitedActivityIdType.MiracleBattlePass):RefreshDataByServerData(data.zhanLingInfo)
  end
end

return TimeLimitedActivityManager
