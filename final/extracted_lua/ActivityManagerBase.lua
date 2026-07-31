local ActivityManagerBase = {}
ActivityManagerBase.ActivityDic = nil

function ActivityManagerBase:Init()
  self:CreatePlayActivity()
end

function ActivityManagerBase:CreatePlayActivity()
  local activityTblDic = self:GetActivityTbl()
  if activityTblDic == nil then
    return
  end
  self.ActivityDic = {}
  for k, v in pairs(activityTblDic) do
    if v.activityId ~= nil then
      self.ActivityDic[v.activityId] = self:GetActivityClass(v.activityId)
      self.ActivityDic[v.activityId]:Refresh(v)
    end
  end
end

function ActivityManagerBase:GetInProgressActivityList()
  local inProgressActivityIdList = {}
  for k, v in pairs(self.ActivityDic) do
    if v:GetActivityState() == ActivityStatusEnum.RUNNING then
      table.insert(inProgressActivityIdList, v)
    end
  end
  return inProgressActivityIdList
end

function ActivityManagerBase:GetActivityData(activityId)
  if self.ActivityDic == nil then
    return
  end
  return self.ActivityDic[activityId]
end

function ActivityManagerBase:GetAllActivityData()
  return self.ActivityDic
end

function ActivityManagerBase:GetAllActivityDes()
  if type(self.ActivityDic) ~= "table" then
    return
  end
  local activityDes, curActivityDes
  for k, v in pairs(self.ActivityDic) do
    curActivityDes = v:GetActivityTimeDes()
    if curActivityDes ~= nil then
      if string.isNullOrEmpty(activityDes) then
        activityDes = curActivityDes
      else
        activityDes = activityDes .. "   " .. curActivityDes
      end
    end
  end
  return activityDes
end

function ActivityManagerBase:RefreshTimeAcrossDay()
  if self.ActivityDic ~= nil then
    for k, v in pairs(self.ActivityDic) do
      v:TimeAcrossDay()
    end
  end
end

function ActivityManagerBase:ResetTimeData()
  if self.ActivityDic ~= nil then
    for k, v in pairs(self.ActivityDic) do
      v:ResetTimeCache()
    end
  end
end

function ActivityManagerBase:ResetActivityData()
  if self.ActivityDic ~= nil then
    for k, v in pairs(self.ActivityDic) do
      v:ResetActivityData()
    end
  end
end

function ActivityManagerBase:Update()
  if self.ActivityDic ~= nil and self:GetActivityChangeEventId() then
    for k, v in pairs(self.ActivityDic) do
      if v:RefreshActivityState() then
        EventManager.Dispatch(self:GetActivityChangeEventId(), k)
      end
    end
  end
end

function ActivityManagerBase:GetActivityTbl()
end

function ActivityManagerBase:GetActivityClass(activityId)
  return LuaClass.ActivityDataBase:New()
end

function ActivityManagerBase:GetActivityChangeEventId()
end

return ActivityManagerBase
