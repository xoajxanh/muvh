local GlobalActivityDataManager = {}
GlobalActivityDataManager.ActivityStatisticsDic = nil

function GlobalActivityDataManager:EnterGame()
  self:TryInitAllActivityManager()
end

function GlobalActivityDataManager:TryInitAllActivityManager()
  for k, v in pairs(ActivityBaseType) do
    self:TryInitActivityManager(v)
  end
end

function GlobalActivityDataManager:TryInitActivityManager(activityBaseType)
  if self.ActivityStatisticsDic == nil then
    self.ActivityStatisticsDic = {}
  end
  if self.ActivityStatisticsDic[activityBaseType] ~= nil then
    return self.ActivityStatisticsDic[activityBaseType]
  end
  if activityBaseType == ActivityBaseType.PlayActivity then
    self.ActivityStatisticsDic[ActivityBaseType.PlayActivity] = LuaClass.PlayActivityManager:New()
  elseif activityBaseType == ActivityBaseType.CommerceActivity then
    self.ActivityStatisticsDic[ActivityBaseType.CommerceActivity] = LuaClass.CommerceActivityManager:New()
  elseif activityBaseType == ActivityBaseType.HolidayActivity then
    self.ActivityStatisticsDic[ActivityBaseType.HolidayActivity] = LuaClass.HolidayActivityManager:New()
  elseif activityBaseType == ActivityBaseType.RechargeActivity then
    self.ActivityStatisticsDic[ActivityBaseType.RechargeActivity] = LuaClass.RechargeActivityManager:New()
  elseif activityBaseType == ActivityBaseType.LimitedTimeActivity then
    self.ActivityStatisticsDic[ActivityBaseType.LimitedTimeActivity] = LuaClass.TimeLimitedActivityManager:New()
  end
  return self.ActivityStatisticsDic[activityBaseType]
end

function GlobalActivityDataManager:Update()
  if self.ActivityStatisticsDic == nil then
    return
  end
  for k, v in pairs(self.ActivityStatisticsDic) do
    v:Update()
  end
end

function GlobalActivityDataManager:GetActivityManger(activityBaseType)
  return self:TryInitActivityManager(activityBaseType)
end

function GlobalActivityDataManager:RefreshTimeAcrossDay()
  if self.ActivityStatisticsDic ~= nil then
    for k, v in pairs(self.ActivityStatisticsDic) do
      v:RefreshTimeAcrossDay()
    end
  end
end

function GlobalActivityDataManager:ResetAllActivity()
  if self.ActivityStatisticsDic ~= nil then
    for k, v in pairs(self.ActivityStatisticsDic) do
      v:ResetTimeData()
      v:ResetActivityData()
    end
  end
end

return GlobalActivityDataManager
