local RechargeActivityManager = {}
setmetatable(RechargeActivityManager, LuaClass.ActivityManagerBase)

function RechargeActivityManager:GetActivityTbl()
  return ClientTable.cfg_Commerce_RechargeoverviewManager:GetDic()
end

function RechargeActivityManager:GetActivityClass(activityId)
  return LuaClass.RechargeActivity:New()
end

function RechargeActivityManager:GetActivityChangeEventId()
end

function RechargeActivityManager:RefreshActivityData(data)
end

return RechargeActivityManager
