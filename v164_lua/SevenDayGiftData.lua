local SevenDayGiftData = {}
setmetatable(SevenDayGiftData, LuaClass.HolidayActivity)
SevenDayGiftData.dayGiftInfoList = nil
SevenDayGiftData.targetGiftInfoList = nil
SevenDayGiftData.curDay = 0
SevenDayGiftData.finishTaskCount = 0

function SevenDayGiftData:Init()
end

function SevenDayGiftData:InitData()
  self.curDay = 0
  self.finishTaskCount = 0
  self:ResetList(self:GetDayGiftInfoList())
  self:ResetList(self:GetTargetGiftInfoList())
  local tblDic = ClientTable.cfg_Commerce_sevengiftManager:GetDic()
  for i, tbl in pairs(tblDic) do
    if tbl.condition and ConditionManager.Check4D(tbl.condition) then
      if tbl.type == SevenDayGiftTypeEnum.Day then
        local dayGiftInfo = self:NewDayGiftInfo(tbl)
        table.insert(self.dayGiftInfoList, dayGiftInfo)
      elseif tbl.type == SevenDayGiftTypeEnum.Target then
        local targetGiftInfo = self:NewTargetGiftInfo(tbl)
        table.insert(self.targetGiftInfoList, targetGiftInfo)
      end
    end
  end
  table.sort(self.dayGiftInfoList, function(a, b)
    return a.day < b.day
  end)
  table.sort(self.targetGiftInfoList, function(a, b)
    return a.totalTaskNum < b.totalTaskNum
  end)
end

function SevenDayGiftData:NewDayGiftInfo(tbl)
  local dayGiftInfo = {}
  self:SetDayGiftInfoByTbl(dayGiftInfo, tbl)
  dayGiftInfo.state = GuardRewardStateEnum.NotGet
  dayGiftInfo.unlockDay = 0
  return dayGiftInfo
end

function SevenDayGiftData:NewTargetGiftInfo(tbl)
  local targetGiftInfo = {}
  self:SetTargetGiftInfoByTbl(targetGiftInfo, tbl)
  targetGiftInfo.state = GuardRewardStateEnum.NotGet
  return targetGiftInfo
end

function SevenDayGiftData:SetDayGiftInfoByTbl(dayGiftInfo, tbl)
  if tbl == nil then
    return
  end
  dayGiftInfo.id = tbl.id or 0
  dayGiftInfo.day = tbl.days or 0
  dayGiftInfo.rewardId = tbl.itemId or 0
  dayGiftInfo.rewardCount = tbl.itemnum or 0
  dayGiftInfo.taskDes = tbl.des or ""
  dayGiftInfo.goalId = tbl.goalId or 0
  dayGiftInfo.count = 0
end

function SevenDayGiftData:SetTargetGiftInfoByTbl(targetGiftInfo, tbl)
  if tbl == nil then
    return
  end
  targetGiftInfo.id = tbl.id or 0
  targetGiftInfo.rewardId = tbl.itemId or 0
  targetGiftInfo.rewardCount = tbl.itemnum or 0
  targetGiftInfo.totalTaskNum = tbl.goalId or 0
end

function SevenDayGiftData:RefreshDataByServerData(serverData)
  if serverData and serverData.goals and table.count(serverData.goals) and serverData.getRewards then
    self:InitData()
    for i, gotId in ipairs(serverData.getRewards) do
      self:RefreshGiftInfoByGotId(gotId)
    end
    self:SetTaskCount(serverData.goals)
    self:RefreshDayGiftInfoStateByFinishIdList(serverData.goals, serverData.getRewards)
    self:TrySetCurDay()
    self:TrySetFinishTaskCount(serverData.goals)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.holidayActivity_SevenDayGift
    })
    EventManager.Dispatch(Event.SevenDayGiftRefresh)
  end
end

function SevenDayGiftData:TrySetCurDay(day)
  local setDay = day or self:GetOpenDay()
  if setDay > self.curDay then
    self.curDay = setDay
    self:RefreshDayGiftInfoUnlockDayByCurDay(self.curDay)
    return true
  end
  return false
end

function SevenDayGiftData:RefreshDayGiftInfoByOpenDay()
  if self:TrySetCurDay() then
    EventManager.Dispatch(Event.SevenDayGiftRefresh)
  end
end

function SevenDayGiftData:RefreshDayGiftInfoUnlockDayByCurDay(curDay)
  if curDay == nil or type(curDay) ~= "number" then
    return
  end
  for i, dayGiftInfo in ipairs(self:GetDayGiftInfoList()) do
    if curDay >= dayGiftInfo.day then
      dayGiftInfo.unlockDay = 0
    else
      dayGiftInfo.unlockDay = dayGiftInfo.day - curDay
    end
  end
end

function SevenDayGiftData:RefreshGiftInfoByGotId(gotId)
  local tbl = ClientTable.cfg_Commerce_sevengiftManager:TryGetValue(gotId)
  if tbl == nil then
    return
  end
  if tbl.type == SevenDayGiftTypeEnum.Day then
    for i, dayGiftInfo in ipairs(self:GetDayGiftInfoList()) do
      if dayGiftInfo.day == tbl.days and dayGiftInfo.id ~= gotId then
        self:SetDayGiftInfoByTbl(dayGiftInfo, tbl)
      end
      if dayGiftInfo.id == gotId then
        dayGiftInfo.state = GuardRewardStateEnum.Got
        break
      end
    end
  elseif tbl.type == SevenDayGiftTypeEnum.Target then
    for i, targetGiftInfo in ipairs(self:GetTargetGiftInfoList()) do
      if targetGiftInfo.totalTaskNum == tbl.goalId and targetGiftInfo.id ~= gotId then
        self:SetTargetGiftInfoByTbl(targetGiftInfo, tbl)
      end
      if targetGiftInfo.id == gotId then
        targetGiftInfo.state = GuardRewardStateEnum.Got
        break
      end
    end
  end
end

function SevenDayGiftData:RefreshDayGiftInfoStateByFinishIdList(finishIdList, getRewards)
  if finishIdList == nil or type(finishIdList) ~= "table" or table.count(finishIdList) <= 0 then
    return
  end
  local rewards = {}
  if table.count(getRewards) > 0 then
    for i, v in pairs(getRewards) do
      local sevenGift = ClientTable.cfg_Commerce_sevengiftManager:TryGetValue(v)
      if not rewards[sevenGift.goalId] then
        rewards[sevenGift.goalId] = v
      end
    end
  end
  for i, finishId in ipairs(finishIdList) do
    local targetCount = ClientTable.cfg_Task_goalManager:TryGetValue(finishId.goalId).goalCount
    if targetCount > finishId.count then
      self:SetState(finishId.goalId, GuardRewardStateEnum.NotGet)
    elseif targetCount <= finishId.count and not rewards[finishId.goalId] then
      self:SetState(finishId.goalId, GuardRewardStateEnum.CanGet)
    elseif rewards[finishId.goalId] then
      self:SetState(finishId.goalId, GuardRewardStateEnum.Got)
    end
  end
end

function SevenDayGiftData:SetState(goalId, state)
  local info = self:GetDayGiftInfoList()
  for i, v in pairs(info) do
    if v.goalId == goalId then
      v.state = state
      break
    end
  end
end

function SevenDayGiftData:TrySetFinishTaskCount(serverInfo)
  local count = 0
  for i, v in pairs(serverInfo) do
    local targetCount = ClientTable.cfg_Task_goalManager:TryGetValue(v.goalId).goalCount
    if targetCount <= v.count then
      count = count + 1
    end
  end
  self.finishTaskCount = count
  self:RefreshTargetGiftInfoStateByFinishTaskCount(count)
end

function SevenDayGiftData:RefreshTargetGiftInfoStateByFinishTaskCount(finishTaskCount)
  if finishTaskCount == nil or type(finishTaskCount) ~= "number" then
    return
  end
  for i, targetGiftInfo in ipairs(self:GetTargetGiftInfoList()) do
    if targetGiftInfo.state == GuardRewardStateEnum.NotGet and finishTaskCount >= targetGiftInfo.totalTaskNum then
      targetGiftInfo.state = GuardRewardStateEnum.CanGet
    end
  end
end

function SevenDayGiftData:GetFinishTaskCount()
  return self.finishTaskCount
end

function SevenDayGiftData:GetDayGiftInfoList()
  if self.dayGiftInfoList == nil then
    self.dayGiftInfoList = {}
  end
  return self.dayGiftInfoList
end

function SevenDayGiftData:SetTaskCount(tbl)
  local listInfo = self:GetDayGiftInfoList()
  if table.count(listInfo) <= 0 then
    return
  end
  for i, v in pairs(listInfo) do
    for m, n in pairs(tbl) do
      if v.goalId == n.goalId then
        v.count = n.count
        break
      end
    end
  end
end

function SevenDayGiftData:GetTargetGiftInfoList()
  if self.targetGiftInfoList == nil then
    self.targetGiftInfoList = {}
  end
  return self.targetGiftInfoList
end

function SevenDayGiftData:CheckRedPointState()
  for i, dayGiftInfo in ipairs(self:GetDayGiftInfoList()) do
    if dayGiftInfo.state == GuardRewardStateEnum.CanGet then
      return true
    end
  end
  for i, targetGiftInfo in ipairs(self:GetTargetGiftInfoList()) do
    if targetGiftInfo.state == GuardRewardStateEnum.CanGet then
      return true
    end
  end
  return false
end

function SevenDayGiftData:ResetActivityData()
  self:ResetList(self:GetDayGiftInfoList())
  self:ResetList(self:GetTargetGiftInfoList())
  self.curDay = 0
  self.finishTaskCount = 0
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_SevenDayGift
  })
end

function SevenDayGiftData:ResetList(list)
  if list == nil then
    list = {}
    return
  end
  for i = #list, 1, -1 do
    table.remove(list)
  end
end

return SevenDayGiftData
